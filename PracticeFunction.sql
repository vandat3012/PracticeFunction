drop database if exists practice_group_by;
create database if not exists practice_group_by;

use practice_group_by;

create table class (
class_id int primary key,
class_name varchar(20) not null,
startdate date not null,
statuss bit 
);

create table student (
student_id int auto_increment primary key,
student_name varchar(30) not null,
adress varchar(50),
phone varchar(20),
statuss bit,
class_id int not null,
foreign key (class_id) references class(class_id)
);

create table `subject` (
sub_id int primary key auto_increment,
sub_name varchar(200) not null,
credit tinyint not null default 1 check (credit >= 1),
statuss bit default 1
);

create table mark (
mark_id int primary key auto_increment,
sub_id int not null,
student_id int not null,
mark float default 0 check(mark between 0 and 100),
exam_time tinyint default 1,
foreign key (sub_id) references `subject`(sub_id),
foreign key (student_id) references student(student_id)
);

insert into class values
(1,"A1",'2000-11-11',1),
(2,"B1",'2000-12-11',0),
(3,"C1",'2000-11-11',1);

insert into student values
(1,"dat1","HN",'0911111111',1,1),
(2,"dat2","SG",'0911111112',1,1),
(3,"dat3","ĐN",'0911111113',0,2),
(4,"dat4","ĐN",'0911111113',0,2);

insert into subject values
(1,"JV",5,1),
(2,"JS",6,1),
(3,"C",7,1);

insert into mark values
(1,1,1,7,1),
(2,3,2,10, 2),
(3,2,3,8,1),
(4,2,3,9,1),
(5,2,2,5,1);


-- select
select * from student;
-- where
select * from student where statuss = true;
-- credit < 10
select * from subject where credit < 10;
-- join where để hiện thị danh sách lớp A1
select s.student_id, s.student_name, c.class_name 
from student s join class c on s.class_id = c.class_id
where c.class_name = "A1";
-- sử dụng where để hiện thị môn JV
select s.student_id,s.student_name,sub.sub_name,m.mark
from student s
join mark m on s.student_id = m.student_id 
join subject sub on sub.sub_id  = m.sub_id
where sub.sub_name = "JV";

-- hien thi hoc sinh bắt đầu bằng chữ h
select * from student where student_name like "h%";
-- hien thi thong tin lop học có thoi gian vao tháng 12
select * from class where month(startdate) = 12;
-- hiện thị thông tin môn học có credit từ 3-5;
select * from subject where credit between 3 and 5;
-- Thay đổi mã lớp của sinh viên có tên dat1 là 3

-- sắp xếp theo thứ tự tăng dần
select s.student_name, sub.sub_name, m.mark 
from student s
join mark m on s.student_id = m.student_id 
join subject sub on sub.sub_id = m.sub_id
order by m.mark;

-- Hiện thị số lượng sinh viên ở từng nơi group_by --
select adress , count(*) as 'so luong' 
from student
group by adress;

-- Hiện thị điểm trung bình các môn học của mỗi học viên
select s.student_name , avg(m.mark) as avg_point
from student s
join mark m on m.student_id = s.student_id
group by s.student_name;

-- Hiện thi học sinh có điểm trung bình hơn 9 
select s.student_name ,avg(m.mark) as avg_point
from student s
join mark m on m.student_id = s.student_id
group by student_name 
having avg_point > 7;

-- Hiện thị học  viên có điểm trung bình lớn nhất
select s.student_name, avg(m.mark) as avg_point
from student s
join mark m on m.student_id = s.student_id 
group by s.student_name
having avg_point >= all (select avg(m.mark) as avg_point from mark m group by m.student_id);

-- Hiển thị thông tin môn học có credit lớn nhất
select *
from subject 
where credit = (select max(credit) from subject);

-- Hiển thị thông tin môn học có điểm thi lớn nhất
select *
from subject s
join mark m on m.sub_id = s.sub_id
where mark = (select max(mark) from mark);

-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
select s.student_id,s.student_name, avg (m.mark) as avg_point
from student s
join mark m on m.student_id = s.student_id
group by s.student_id
order by avg_point; 