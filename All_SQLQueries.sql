CREATE Database ecommerce;

Use ecommerce;

create table if not exists Supplier
(
SUPP_ID 	int auto_increment
,SUPP_NAME 	varchar(50)
,SUPP_CITY 	varchar(50)
,SUPP_PHONE bigint
,Primary key (SUPP_ID)
);

create table if not exists Customer
(
CUS_ID 		int auto_increment
,CUS_NAME 	varchar(50)
,CUS_PHONE 	bigint
,CUS_CITY	varchar(50)
,CUS_GENDER varchar(1)
,primary key (CUS_ID)
);

create table if not exists Category
(
CAT_ID		int auto_increment
,CAT_NAME	varchar(50)
,Primary key (CAT_ID)
);

create table if not exists Product
(
PRO_ID		int auto_increment
,PRO_NAME	varchar(50)
,PRO_DESC	varchar(50)
,CAT_ID		int
,primary key (Pro_ID)
,foreign key (CAT_ID) references Category(CAT_ID)
);

create table if not exists ProductDetails
(
PROD_ID		int auto_increment
,PRO_ID 	int
,SUPP_ID 	int
,PRICE		int
,primary key (PROD_ID)
,foreign key (PRO_ID) references Product(PRO_ID)
,foreign key (SUPP_ID) references Supplier(SUPP_ID)
);


create table if not exists ecommerce.Order
(
ORD_ID			int 
,ORD_AMOUNT		int
,ORD_DATE		varchar(50)
,CUS_ID			int
,PROD_ID		int
,primary key (ORD_ID)
,foreign key (PROD_ID) references ProductDetails(PROD_ID)
,foreign key (CUS_ID) references Customer(CUS_ID)
);


create table if not exists Rating
(
RAT_ID			int auto_increment
,CUS_ID			int
,SUPP_ID		int
,RAT_RATSTARS	int
,primary key (RAT_ID)
,foreign key (CUS_ID) references Customer(CUS_ID)
,foreign key (SUPP_ID) references Supplier(SUPP_ID)
);



Insert into ecommerce.Supplier (SUPP_NAME,SUPP_CITY,SUPP_PHONE)
values
('Rajesh Retails','Delhi',1234567890)
,('Appario Ltd.','Mumbai',2589631470)
,('Knome products','Banglore',9785462315)
,('Bansal Retails','Kochi',8975463285)
,('Mittal Ltd.','Lucknow',7898456532)
;

insert into ecommerce.Customer(CUS_NAME,CUS_PHONE,CUS_CITY,CUS_GENDER)
values
('AAKASH',9999999999,'DELHI','M')
,('AMAN',9785463215,'NOIDA','M')
,('NEHA',9999999999,'MUMBAI','F')
,('MEGHA',9994562399,'KOLKATA','F')
,('PULKIT',7895999999,'LUCKNOW','M')
;

insert into ecommerce.Category(CAT_NAME)
values
('BOOKS')
,('GAMES')
,('GROCERIES')
,('ELECTRONICS')
,('CLOTHES')
;

insert into ecommerce.Product(PRO_NAME,PRO_DESC,CAT_ID)
values
('GTA V','DFJDJFDJFDJFDJFJF',2)
,('TSHIRT','DFDFJDFJDKFD',5)
,('ROG LAPTOP','DFNTTNTNTERND',4)
,('OATS','REURENTBTOTH',3)
,('HARRY POTTER','NBEMCTHTJTH',1)
;

insert into ecommerce.ProductDetails(PRO_ID,SUPP_ID,PRICE)
values
(1,2,1500)
,(3,5,30000)
,(5,1,3000)
,(2,3,2500)
,(4,1,1000)
;

insert into ecommerce.Order
values
(20,1500,'2021-10-12',3,5)
,(25,30500,'2021-09-16',5,2)
,(26,2000,'2021-10-05',1,1)
,(30,3500,'2021-08-16',4,3)
,(50,2000,'2021-10-06',2,1)
;

insert into ecommerce.Rating(CUS_ID,SUPP_ID,RAT_RATSTARS)
values
(2,2,4)
,(3,4,3)
,(5,1,5)
,(1,3,2)
,(4,5,4)
;

/*Query 3
number of the customer group 
by their genders who have placed any order of 
amount greater than or equal to Rs.3000
*/
SELECT 		count(C.CUS_ID) AS No_of_Cus, 
			C.CUS_GENDER
FROM 		ecommerce.Customer 	C
JOIN 		ecommerce.Order 	O
ON 			C.CUS_ID 		= 	O.CUS_ID
WHERE 		O.ORD_AMOUNT 	>= 	3000
GROUP BY 	C.CUS_GENDER
;

/*Query 4
all the orders along with the 
product name ordered by a customer having Customer_Id=2.
*/
SELECT 	 O.ORD_ID
		,P.PRO_NAME
FROM 	ecommerce.Order 			O
JOIN 	ecommerce.Customer 			C
ON 		C.CUS_ID 				= 	O.CUS_ID
AND 	C.CUS_ID 				= 	2
JOIN 	ecommerce.ProductDetails 	PD
ON 		O.PROD_ID 				= 	PD.PROD_ID
JOIN 	ecommerce.Product			P
ON 		PD.PRO_ID 				= 	P.PRO_ID
;

/*Query 5
Display the Supplier details who can supply more than one product.
*/
with cte1 as
(
	SELECT 	 P.SUPP_ID
	FROM 	 ecommerce.Supplier 		S
	JOIN 	 ecommerce.ProductDetails 	P
	ON   	 S.SUPP_ID 		= 			P.SUPP_ID
	GROUP BY P.SUPP_ID
	HAVING 	 count(PROD_ID) > 			1
)
SELECT S.*
FROM 	ecommerce.Supplier 	S
JOIN 	cte1 				C
ON 		C.SUPP_ID 	= 		S.SUPP_ID
;

/*Query 6
category of the product whose order amount is minimum
*/
SELECT 	P.PRO_NAME
		,C.CAT_ID
        ,C.CAT_NAME
FROM 	ecommerce.Category 			C
JOIN 	ecommerce.Product 			P
ON 		C.CAT_ID 	= 				P.CAT_ID
JOIN    ecommerce.ProductDetails 	PD
ON 		P.PRO_ID 	= 				PD.PRO_ID
AND 	PD.PROD_ID  IN 		(	SELECT 	PROD_ID
								FROM 	ecommerce.Order
								WHERE 	ORD_AMOUNT IN 
													(SELECT 	MIN(ORD_AMOUNT)
													 FROM 		ecommerce.Order
													)
							)
;

/*Query 7
Display the Id and Name of the Product ordered after “2021-10-05”
*/
SELECT   P.PRO_ID
		,P.PRO_NAME
FROM 	ecommerce.Product 			P
JOIN    ecommerce.ProductDetails 	PD
ON 		P.PRO_ID 	= 				PD.PRO_ID
JOIN 	ecommerce.Order				O
ON 		O.PROD_ID	= 				PD.PROD_ID
WHERE   CAST(ORD_DATE AS date)     > '2021-10-05'
;

/*Query 8
customer name and gender whose names start or end with character 'A'.
*/
SELECT CUS_NAME, CUS_GENDER
FROM 	ecommerce.Customer 
WHERE 	(CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A')
;

/*Query 9
9)	Create a stored procedure to display the Rating for a Supplier 
if any along with the Verdict on that rating
if any like if rating >4 then “Genuine Supplier” 
if rating >2 “Average Supplier” 
else “Supplier should not be considered”.
*/
DELIMITER //
CREATE procedure ecommerce.Supplier_Rating()
 BEGIN
	SELECT  S.SUPP_NAME
			,CASE WHEN R.RAT_RATSTARS > 4 
				  THEN 'Genuine Supplier'
                  WHEN R.RAT_RATSTARS > 2
                  THEN 'Average Supplier'
                  ELSE 'Supplier should not be considered'
			 END  			AS VERDICT
    FROM ecommerce.Rating 	R
    JOIN ecommerce.SUPPLIER S
    ON 	 R.SUPP_ID 		= 	S.SUPP_ID
    ;
END //
DELIMITER ;

CALL ecommerce.Supplier_Rating();

