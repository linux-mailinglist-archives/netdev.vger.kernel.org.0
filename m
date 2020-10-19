Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E482930C4
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbgJSVtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:49:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgJSVtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:49:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JLmbhZ030972;
        Mon, 19 Oct 2020 21:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=HyOiXC2cvloZThsLuaahRtu+b1JDYSbHbdjOYgi3a2Q=;
 b=cR2JBIy2WkK8Adg3QdMHC13nQNm1GB/GPCbimcz65Qg5z12FK3nxX31WSgMCGdghzW2k
 sdQiwoMabz+hUUzS9ZIVfRvd4K9iKYyX8Mm+n3xk1dwneKvWlgSY+HFLjTlFREhGPUze
 LQwz/U8kl+2gz4BenV/r5WRWnNGYEfKYl+2sT3wHlKyxywP93vAwCTryGaemiODkk5fJ
 vM1tE1PYOkkMeyRQ5ORwF+I6ssQZc5ir4LUpF4XWvzB5Gj9XLa+Ren9DQ7+PAFReBaUe
 XId3b2zPsajy0ynmOJoeyvvlRoJSXkxyn4RcZ44gmSsCXA0/DMHQa/pqCytx/iZfOgK9 OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 349jrpg24j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 21:49:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JLdx8j144456;
        Mon, 19 Oct 2020 21:49:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 348a6mdcbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 21:49:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JLnT7f018603;
        Mon, 19 Oct 2020 21:49:29 GMT
Received: from mbpatil.us.oracle.com (/10.211.44.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 14:49:29 -0700
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rama.nichanamatlu@oracle.com, manjunath.b.patil@oracle.com
Subject: [PATCH 1/2] rds: track memory region (MR) usage in kernel
Date:   Mon, 19 Oct 2020 14:48:07 -0700
Message-Id: <1603144088-8769-2-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
References: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=3 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=3 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Excessive MR utilization by certain RDS applications can starve other
RDS applications from getting MRs. Therefore tracking MR usage by RDS
applications is beneficial.

The collected data is intended to be exported to userspace using
rds-info interface.

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
---
 net/rds/af_rds.c |  4 ++++
 net/rds/rdma.c   | 29 ++++++++++++++++++++++-------
 net/rds/rds.h    |  6 ++++++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 1a5bf3fa4578..e291095e5224 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -688,6 +688,10 @@ static int __rds_create(struct socket *sock, struct sock *sk, int protocol)
 	rs->rs_rx_traces = 0;
 	rs->rs_tos = 0;
 	rs->rs_conn = NULL;
+	rs->rs_pid = current->pid;
+	get_task_comm(rs->rs_comm, current);
+	atomic64_set(&rs->rs_mr_gets, 0);
+	atomic64_set(&rs->rs_mr_puts, 0);
 
 	spin_lock_bh(&rds_sock_lock);
 	list_add_tail(&rs->rs_item, &rds_sock_list);
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 585e6b3b69ce..a1ae7b5ea3b2 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -44,6 +44,23 @@
  *  - an rdma is an mlock, apply rlimit?
  */
 
+static inline void mr_stats_update_gets(struct rds_sock *rs)
+{
+	atomic64_inc(&rs->rs_mr_gets);
+}
+
+static inline void mr_stats_update_puts(struct rds_sock *rs)
+{
+	atomic64_inc(&rs->rs_mr_puts);
+}
+
+static inline void rds_rb_erase(struct rds_sock *rs, struct rds_mr *mr)
+{
+	rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
+	RB_CLEAR_NODE(&mr->r_rb_node);
+	mr_stats_update_puts(rs);
+}
+
 /*
  * get the number of pages by looking at the page indices that the start and
  * end addresses fall in.
@@ -106,7 +123,7 @@ static void rds_destroy_mr(struct rds_mr *mr)
 
 	spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	if (!RB_EMPTY_NODE(&mr->r_rb_node))
-		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
+		rds_rb_erase(rs, mr);
 	trans_private = mr->r_trans_private;
 	mr->r_trans_private = NULL;
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
@@ -137,8 +154,7 @@ void rds_rdma_drop_keys(struct rds_sock *rs)
 		mr = rb_entry(node, struct rds_mr, r_rb_node);
 		if (mr->r_trans == rs->rs_transport)
 			mr->r_invalidate = 0;
-		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
-		RB_CLEAR_NODE(&mr->r_rb_node);
+		rds_rb_erase(rs, mr);
 		spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
 		rds_destroy_mr(mr);
 		rds_mr_put(mr);
@@ -337,6 +353,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 	 * reference count. */
 	spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	found = rds_mr_tree_walk(&rs->rs_rdma_keys, mr->r_key, mr);
+	mr_stats_update_gets(rs);
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
 
 	BUG_ON(found && found != mr);
@@ -424,8 +441,7 @@ int rds_free_mr(struct rds_sock *rs, char __user *optval, int optlen)
 	spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	mr = rds_mr_tree_walk(&rs->rs_rdma_keys, rds_rdma_cookie_key(args.cookie), NULL);
 	if (mr) {
-		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
-		RB_CLEAR_NODE(&mr->r_rb_node);
+		rds_rb_erase(rs, mr);
 		if (args.flags & RDS_RDMA_INVALIDATE)
 			mr->r_invalidate = 1;
 	}
@@ -465,8 +481,7 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 	}
 
 	if (mr->r_use_once || force) {
-		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
-		RB_CLEAR_NODE(&mr->r_rb_node);
+		rds_rb_erase(rs, mr);
 		zot_me = 1;
 	}
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
diff --git a/net/rds/rds.h b/net/rds/rds.h
index e4a603523083..5e61868e1799 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -654,6 +654,12 @@ struct rds_sock {
 	spinlock_t		rs_rdma_lock;
 	struct rb_root		rs_rdma_keys;
 
+	/* per rds_sock MR stats */
+	pid_t                   rs_pid;
+	char                    rs_comm[TASK_COMM_LEN];
+	atomic64_t              rs_mr_gets;
+	atomic64_t              rs_mr_puts;
+
 	/* Socket options - in case there will be more */
 	unsigned char		rs_recverr,
 				rs_cong_monitor;
-- 
2.27.0.112.g101b320

