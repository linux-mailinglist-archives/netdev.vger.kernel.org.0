Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518116B1D2
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbfGPW3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388741AbfGPW3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:29:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDb5j109864;
        Tue, 16 Jul 2019 22:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=c8MEsuUNr/M3bMH+7WStr5Mv3W08E9i5AMDBhIvizVs=;
 b=fUgOrQwvvgcq+8vaIobFl0Q9HyPKGORZ4K+GGzqFEbA5gt1tmKgfndv9fsKPP/t2DiCx
 l5v95kRTEwpv0WyMYK48yKR5M6rCTbOE0J1l+ykFtRcWw5LwPMyiJ/vogN9WyUhEtFT+
 zCobyQI248RwHCiJLGA0RZiK6wdItIlQNjd+9yOxDb6w1ffKy4wzV9U2IMUzQm6cBmpr
 Ulgb1bHZAmkt7R967sYSKCPddNRsxPsUJnBB0h1XhydZhCIsQCVmBUb4Mx4bn+jVmg0o
 kh6iwRKzPE658ib51JyYGW59KcDJBfdEp+ymQ+erJ9qalNGT43UEct8KZJPRpg6XbTCO /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tq7xqy4f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCfMq064481;
        Tue, 16 Jul 2019 22:28:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tq5bcnrwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:28:59 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMSx3x096541;
        Tue, 16 Jul 2019 22:28:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tq5bcnrws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:28:59 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GMSwgs003594;
        Tue, 16 Jul 2019 22:28:58 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:28:58 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 2/7] net/rds: Get rid of "wait_clean_list_grace" and
 add locking
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <3e608430-4b96-4c25-6593-4479131bb904@oracle.com>
Date:   Tue, 16 Jul 2019 15:28:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Waiting for activity on the "clean_list" to quiesce is no substitute
for proper locking.

We can have multiple threads competing for "llist_del_first"
via "rds_ib_reuse_mr", and a single thread competing
for "llist_del_all" and "llist_del_first" via "rds_ib_flush_mr_pool".

Since "llist_del_first" depends on "list->first->next" not to change
in the midst of the operation, simply waiting for all current calls
to "rds_ib_reuse_mr" to quiesce across all CPUs is woefully inadequate:

By the time "wait_clean_list_grace" is done iterating over all CPUs to see
that there is no concurrent caller to "rds_ib_reuse_mr", a new caller may
have just shown up on the first CPU.

Furthermore, <linux/llist.h> explicitly calls out the need for locking:
 * Cases where locking is needed:
 * If we have multiple consumers with llist_del_first used in one consumer,
 * and llist_del_first or llist_del_all used in other consumers,
 * then a lock is needed.

Also, while at it, drop the unused "pool" parameter
from "list_to_llist_nodes".

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_mr.h   |  1 +
 net/rds/ib_rdma.c | 56 +++++++++++++++--------------------------------
 2 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
index 42daccb7b5eb..ab26c20ed66f 100644
--- a/net/rds/ib_mr.h
+++ b/net/rds/ib_mr.h
@@ -98,6 +98,7 @@ struct rds_ib_mr_pool {
 	struct llist_head	free_list;	/* unused MRs */
 	struct llist_head	clean_list;	/* unused & unmapped MRs */
 	wait_queue_head_t	flush_wait;
+	spinlock_t		clean_lock;	/* "clean_list" concurrency */
 
 	atomic_t		free_pinned;	/* memory pinned by free MRs */
 	unsigned long		max_items;
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 0b347f46b2f4..6b047e63a769 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -40,9 +40,6 @@
 
 struct workqueue_struct *rds_ib_mr_wq;
 
-static DEFINE_PER_CPU(unsigned long, clean_list_grace);
-#define CLEAN_LIST_BUSY_BIT 0
-
 static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
 {
 	struct rds_ib_device *rds_ibdev;
@@ -195,12 +192,11 @@ struct rds_ib_mr *rds_ib_reuse_mr(struct rds_ib_mr_pool *pool)
 {
 	struct rds_ib_mr *ibmr = NULL;
 	struct llist_node *ret;
-	unsigned long *flag;
+	unsigned long flags;
 
-	preempt_disable();
-	flag = this_cpu_ptr(&clean_list_grace);
-	set_bit(CLEAN_LIST_BUSY_BIT, flag);
+	spin_lock_irqsave(&pool->clean_lock, flags);
 	ret = llist_del_first(&pool->clean_list);
+	spin_unlock_irqrestore(&pool->clean_lock, flags);
 	if (ret) {
 		ibmr = llist_entry(ret, struct rds_ib_mr, llnode);
 		if (pool->pool_type == RDS_IB_MR_8K_POOL)
@@ -209,23 +205,9 @@ struct rds_ib_mr *rds_ib_reuse_mr(struct rds_ib_mr_pool *pool)
 			rds_ib_stats_inc(s_ib_rdma_mr_1m_reused);
 	}
 
-	clear_bit(CLEAN_LIST_BUSY_BIT, flag);
-	preempt_enable();
 	return ibmr;
 }
 
-static inline void wait_clean_list_grace(void)
-{
-	int cpu;
-	unsigned long *flag;
-
-	for_each_online_cpu(cpu) {
-		flag = &per_cpu(clean_list_grace, cpu);
-		while (test_bit(CLEAN_LIST_BUSY_BIT, flag))
-			cpu_relax();
-	}
-}
-
 void rds_ib_sync_mr(void *trans_private, int direction)
 {
 	struct rds_ib_mr *ibmr = trans_private;
@@ -324,8 +306,7 @@ static unsigned int llist_append_to_list(struct llist_head *llist,
  * of clusters.  Each cluster has linked llist nodes of
  * MR_CLUSTER_SIZE mrs that are ready for reuse.
  */
-static void list_to_llist_nodes(struct rds_ib_mr_pool *pool,
-				struct list_head *list,
+static void list_to_llist_nodes(struct list_head *list,
 				struct llist_node **nodes_head,
 				struct llist_node **nodes_tail)
 {
@@ -402,8 +383,13 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
 	 */
 	dirty_to_clean = llist_append_to_list(&pool->drop_list, &unmap_list);
 	dirty_to_clean += llist_append_to_list(&pool->free_list, &unmap_list);
-	if (free_all)
+	if (free_all) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&pool->clean_lock, flags);
 		llist_append_to_list(&pool->clean_list, &unmap_list);
+		spin_unlock_irqrestore(&pool->clean_lock, flags);
+	}
 
 	free_goal = rds_ib_flush_goal(pool, free_all);
 
@@ -416,27 +402,20 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
 		rds_ib_unreg_fmr(&unmap_list, &nfreed, &unpinned, free_goal);
 
 	if (!list_empty(&unmap_list)) {
-		/* we have to make sure that none of the things we're about
-		 * to put on the clean list would race with other cpus trying
-		 * to pull items off.  The llist would explode if we managed to
-		 * remove something from the clean list and then add it back again
-		 * while another CPU was spinning on that same item in llist_del_first.
-		 *
-		 * This is pretty unlikely, but just in case  wait for an llist grace period
-		 * here before adding anything back into the clean list.
-		 */
-		wait_clean_list_grace();
-
-		list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
+		unsigned long flags;
+
+		list_to_llist_nodes(&unmap_list, &clean_nodes, &clean_tail);
 		if (ibmr_ret) {
 			*ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);
 			clean_nodes = clean_nodes->next;
 		}
 		/* more than one entry in llist nodes */
-		if (clean_nodes)
+		if (clean_nodes) {
+			spin_lock_irqsave(&pool->clean_lock, flags);
 			llist_add_batch(clean_nodes, clean_tail,
 					&pool->clean_list);
-
+			spin_unlock_irqrestore(&pool->clean_lock, flags);
+		}
 	}
 
 	atomic_sub(unpinned, &pool->free_pinned);
@@ -610,6 +589,7 @@ struct rds_ib_mr_pool *rds_ib_create_mr_pool(struct rds_ib_device *rds_ibdev,
 	init_llist_head(&pool->free_list);
 	init_llist_head(&pool->drop_list);
 	init_llist_head(&pool->clean_list);
+	spin_lock_init(&pool->clean_lock);
 	mutex_init(&pool->flush_lock);
 	init_waitqueue_head(&pool->flush_wait);
 	INIT_DELAYED_WORK(&pool->flush_worker, rds_ib_mr_pool_flush_worker);
-- 
2.22.0


