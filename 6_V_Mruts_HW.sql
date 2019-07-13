use master
go
drop database if exists V_MRUTS
go
create database V_MRUTS
go

use V_MRUTS
go

create table [suppliers] (
	supplierid			integer,
	name				varchar(20),
	rating				integer,
	city				varchar(20),
	constraint supplr_pk PRIMARY KEY (supplierid)
);	

create table [details] (
	detailid			integer,
	name				varchar(20),
	color				varchar(20),
	weight				integer,
	city				varchar(20),
	constraint detail_pk PRIMARY KEY (detailid)
);	

create table [products] (
	productid			integer,
	name				varchar(20),
	city				varchar(20),
	constraint product_pk PRIMARY KEY (productid)
);		

create table [supplies] (
	supplierid			integer,
	detailid			integer,
	productid			integer,
	quantity			integer,
	constraint suppl_supplr_fk FOREIGN KEY (supplierid) REFERENCES suppliers (supplierid),
	constraint suppl_detail_fk FOREIGN KEY (detailid) REFERENCES details (detailid),
	constraint suppl_product_fk FOREIGN KEY (productid) REFERENCES products (productid),
);

---INSERTS------
insert into suppliers(
	supplierid,
	name,
	rating,
	city
)
values
(1, 'Smith', 20, 'London'),
(2, 'Jonth', 10, 'Paris'),
(3, 'Blacke', 30, 'Paris'),
(4, 'Clarck', 20, 'London'),
(5, 'Adams', 30, 'Athens');

insert into details(
	detailid,
	name,
	color,
	weight,
	city
)
values
(1, 'Screw', 'red', 12, 'London'),
(2, 'Bolt', 'green', 17, 'Paris'),
(3, 'Male-screw', 'blue', 17, 'Roma'),
(4, 'Male-screw', 'red', 14, 'London'),
(5, 'Whell', 'blue', 12, 'Paris'),
(6, 'Bloom', 'red', 19, 'London');

insert into products(
	productid,
	name,
	city
)
values
(1, 'HDD', 'Paris'),
(2, 'Perforator', 'Roma'),
(3, 'Reader', 'Athens'),
(4, 'Printer', 'Athens'),
(5, 'FDD', 'London'),
(6, 'Terminal', 'Oslo'),
(7, 'Ribbon', 'London');

insert into supplies(
	supplierid,
	detailid,
	productid,
	quantity
	
)
values
(1, 1, 1, 200),
(1, 1, 4, 700),
(2, 3, 1, 400),
(2, 3, 2, 200),
(2, 3, 3, 200),
(2, 3, 4, 500),
(2, 3, 5, 600),
(2, 3, 6, 400),
(2, 3, 7, 800),
(2, 5, 2, 100),
(3, 3, 1, 200),
(3, 4, 2, 500),
(4, 6, 3, 300),
(4, 6, 7, 300),
(5, 2, 2, 200),
(5, 2, 4, 100),
(5, 5, 5, 500),
(5, 5, 7, 100),
(5, 6, 2, 200),
(5, 1, 4, 100),
(5, 3, 4, 200),
(5, 4, 4, 800),
(5, 5, 4, 400),
(5, 6, 4, 500);


---Tasks------
---[1]------
SELECT 
	productid, 
	name,
	city, 
	ROW_NUMBER() OVER(ORDER BY city) AS RowNumber
FROM products
ORDER BY city;

---[2]------
SELECT 
	productid, 
	name,
	city, 
	ROW_NUMBER() OVER(PARTITION BY city ORDER BY name) AS RowNumber
FROM products
ORDER BY city, name;

---[3]------
SELECT * 
FROM
(SELECT 
	productid, 
	name, 
	city, 
	ROW_NUMBER() OVER(PARTITION BY city ORDER BY name) AS RowNumber
FROM products) AS scnd
WHERE RowNumber = 1;

---[4]------
SELECT 
	productid,
	detailid, 
	quantity,
	SUM(quantity) OVER(PARTITION BY productid) AS all_quantity_per_prod,
	SUM(quantity) OVER(PARTITION BY detailid) AS all_quantity_per_det
FROM supplies;

---[5]------
SELECT * 
FROM
	(SELECT
	supplierid,
	detailid,
	productid,
	quantity,
	ROW_NUMBER() OVER(ORDER BY supplierid) AS RowNumber,
	COUNT(*) OVER() AS total 
	FROM supplies) AS scnd
WHERE RowNumber >= 10 AND RowNumber <= 15
ORDER BY supplierid;

---[6]------
SELECT * 
FROM
	(SELECT
	supplierid,
	detailid,
	productid,
	quantity,
	AVG(quantity) OVER() AS AvgQty 
	FROM supplies) AS scnd
WHERE quantity < AvgQty
ORDER BY supplierid;