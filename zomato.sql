-- what is the total amount wach coustomer spent on zomato
SELECT a.userid , sum(b.price) total_ammount_spent
from sales a
join product b
on a.product_id = b.product_id 
group by 1;


-- how many days has each customer visited zomato?
select userid, count(distinct created_date)  as total_visit
from sales
group by userid;


-- What was the first product purchase by each customer?
select * from  
(select * , rank() over (partition by userid order by created_date ) as rnk
from sales) as ranked
where rnk = 1;


-- What is The most puchased item on the menu and how many time it purchased by all customer? 
SELECT userid, COUNT(product_id) AS cnt
FROM sales
WHERE product_id in (
    SELECT product_id
    FROM sales
    GROUP BY product_id
    ORDER BY COUNT(product_id) DESC
)
GROUP BY userid;


-- which item was the most popular for each customer?
SELECT * FROM
    (SELECT *,
        RANK() OVER (PARTITION BY userid ORDER BY cnt DESC) AS rnk
    FROM
        (SELECT userid,product_id,
            COUNT(product_id) AS cnt
        FROM sales
        GROUP BY userid, product_id) AS subquery) AS ranked_data
WHERE rnk = 1;


-- which item was purchased first by the customer after the became a gold member?
select * from
 (select c.*,
	rank() over ( partition by userid order by created_date) 
rnk from 
		(select a.userid ,a.created_date,a.product_id, b.gold_signup_date 
		from sales a
		inner join goldusers_signup b
		on a.userid = b.userid
		and created_date >= gold_signup_date ) c) d
where rnk = 1;


-- which item was purchased just before the customer become the member ?
select * from
(SELECT c.*,
       RANK() OVER (PARTITION BY userid ORDER BY created_date desc) AS rnk
FROM (SELECT a.userid,a.created_date,a.product_id,b.gold_signup_date
      FROM sales a
               INNER JOIN goldusers_signup b
               ON a.userid = b.userid
                 AND b.gold_signup_date >= a.created_date) c)d
where rnk = 1;


-- what is the total orders and amount spent for each member before they became a member ?

select userid, count(created_date) order_purchase, sum(price) total_amount from
(select c.*, d.price  from
(SELECT a.userid,a.created_date,a.product_id,b.gold_signup_date
      FROM sales a
               INNER JOIN goldusers_signup b
               ON a.userid = b.userid
                 AND b.gold_signup_date >= a.created_date) as c
                 inner join product d 
                 on c.product_id = d.product_id) as e
group by userid;                 
	










