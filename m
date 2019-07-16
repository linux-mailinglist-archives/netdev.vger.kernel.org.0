Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AB76B1DC
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388915AbfGPW3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388741AbfGPW3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:29:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDpIO109918;
        Tue, 16 Jul 2019 22:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=UB8BcFHFjsfkNuaZMeVZ1MZ+P1bCqO0q7UySV6Oz1qw=;
 b=Nh+cW8pzMlauQrewD9yqb8GcX17FOwkcmORjBDf9ZCrNZyH9mvl4/282s7qwHJhtVFjX
 rtYFp64K6vPXDNnBe82un9ydqlvHN1nVgya9kjWloc26Srr04QuEdH8wNM9D2516axfQ
 lhk4FBnsVGzw/fq5XjYoIOSJ+NsFSuyIrkslWUrZBkJIQ5yrm54l61Q9HYc8Ra/nNeUn
 P30iraC9mHCtHLdZV7WeZgi3jXCgWuEG+w2rUR5nrSfCon0j6ai/Alrhny3uP9ylqYn8
 XRobfSaWnDcNg+5ruiRuVZ8+HVeFEy8tYgizAIa3+P14XzItQXbXSvrU0sck1djvLe3U Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tq7xqy4ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCh3v153542;
        Tue, 16 Jul 2019 22:29:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tsctwhx7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:29:21 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMTLNN192994;
        Tue, 16 Jul 2019 22:29:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tsctwhx78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:21 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GMTJHb018056;
        Tue, 16 Jul 2019 22:29:19 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:29:19 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 6/7] net/rds: Keep track of and wait for FRWR segments
 in use upon shutdown
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <28ded44a-bce9-8632-d7e8-fe843140658e@oracle.com>
Date:   Tue, 16 Jul 2019 15:29:17 -0700
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

Since "rds_ib_free_frmr" and "rds_ib_free_frmr_list" simply put
the FRMR memory segments on the "drop_list" or "free_list",
and it is the job of "rds_ib_flush_mr_pool" to reap those entries
by ultimately issuing a "IB_WR_LOCAL_INV" work-request,
we need to trigger and then wait for all those memory segments
attached to a particular connection to be fully released before
we can move on to release the QP, CQ, etc.

So we make "rds_ib_conn_path_shutdown" wait for one more
atomic_t called "i_fastreg_inuse_count" that keeps track of how
many FRWR memory segments are out there marked "FRMR_IS_INUSE"
(and also wake_up rds_ib_ring_empty_wait, as they go away).

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib.h      |  1 +
 net/rds/ib_cm.c   |  7 +++++++
 net/rds/ib_frmr.c | 43 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 66c03c7665b2..303c6ee8bdb7 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -156,6 +156,7 @@ struct rds_ib_connection {
 
 	/* To control the number of wrs from fastreg */
 	atomic_t		i_fastreg_wrs;
+	atomic_t		i_fastreg_inuse_count;
 
 	/* interrupt handling */
 	struct tasklet_struct	i_send_tasklet;
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 8891822eba4f..1b6fd6c8b12b 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -40,6 +40,7 @@
 #include "rds_single_path.h"
 #include "rds.h"
 #include "ib.h"
+#include "ib_mr.h"
 
 /*
  * Set the selected protocol version
@@ -993,6 +994,11 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 				ic->i_cm_id, err);
 		}
 
+		/* kick off "flush_worker" for all pools in order to reap
+		 * all FRMR registrations that are still marked "FRMR_IS_INUSE"
+		 */
+		rds_ib_flush_mrs();
+
 		/*
 		 * We want to wait for tx and rx completion to finish
 		 * before we tear down the connection, but we have to be
@@ -1005,6 +1011,7 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		wait_event(rds_ib_ring_empty_wait,
 			   rds_ib_ring_empty(&ic->i_recv_ring) &&
 			   (atomic_read(&ic->i_signaled_sends) == 0) &&
+			   (atomic_read(&ic->i_fastreg_inuse_count) == 0) &&
 			   (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR));
 		tasklet_kill(&ic->i_send_tasklet);
 		tasklet_kill(&ic->i_recv_tasklet);
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index adaa8e99e5a9..06ecf9d2d4bf 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -32,6 +32,24 @@
 
 #include "ib_mr.h"
 
+static inline void
+rds_transition_frwr_state(struct rds_ib_mr *ibmr,
+			  enum rds_ib_fr_state old_state,
+			  enum rds_ib_fr_state new_state)
+{
+	if (cmpxchg(&ibmr->u.frmr.fr_state,
+		    old_state, new_state) == old_state &&
+	    old_state == FRMR_IS_INUSE) {
+		/* enforce order of ibmr->u.frmr.fr_state update
+		 * before decrementing i_fastreg_inuse_count
+		 */
+		smp_mb__before_atomic();
+		atomic_dec(&ibmr->ic->i_fastreg_inuse_count);
+		if (waitqueue_active(&rds_ib_ring_empty_wait))
+			wake_up(&rds_ib_ring_empty_wait);
+	}
+}
+
 static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 					   int npages)
 {
@@ -118,13 +136,18 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 	if (unlikely(ret != ibmr->sg_len))
 		return ret < 0 ? ret : -EINVAL;
 
+	if (cmpxchg(&frmr->fr_state,
+		    FRMR_IS_FREE, FRMR_IS_INUSE) != FRMR_IS_FREE)
+		return -EBUSY;
+
+	atomic_inc(&ibmr->ic->i_fastreg_inuse_count);
+
 	/* Perform a WR for the fast_reg_mr. Each individual page
 	 * in the sg list is added to the fast reg page list and placed
 	 * inside the fast_reg_mr WR.  The key used is a rolling 8bit
 	 * counter, which should guarantee uniqueness.
 	 */
 	ib_update_fast_reg_key(frmr->mr, ibmr->remap_count++);
-	frmr->fr_state = FRMR_IS_INUSE;
 	frmr->fr_reg = true;
 
 	memset(&reg_wr, 0, sizeof(reg_wr));
@@ -141,7 +164,8 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 	ret = ib_post_send(ibmr->ic->i_cm_id->qp, &reg_wr.wr, NULL);
 	if (unlikely(ret)) {
 		/* Failure here can be because of -ENOMEM as well */
-		frmr->fr_state = FRMR_IS_STALE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
+
 		atomic_inc(&ibmr->ic->i_fastreg_wrs);
 		if (printk_ratelimit())
 			pr_warn("RDS/IB: %s returned error(%d)\n",
@@ -268,8 +292,12 @@ static int rds_ib_post_inv(struct rds_ib_mr *ibmr)
 
 	ret = ib_post_send(i_cm_id->qp, s_wr, NULL);
 	if (unlikely(ret)) {
-		frmr->fr_state = FRMR_IS_STALE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
 		frmr->fr_inv = false;
+		/* enforce order of frmr->fr_inv update
+		 * before incrementing i_fastreg_wrs
+		 */
+		smp_mb__before_atomic();
 		atomic_inc(&ibmr->ic->i_fastreg_wrs);
 		pr_err("RDS/IB: %s returned error(%d)\n", __func__, ret);
 		goto out;
@@ -297,7 +325,7 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	struct rds_ib_frmr *frmr = &ibmr->u.frmr;
 
 	if (wc->status != IB_WC_SUCCESS) {
-		frmr->fr_state = FRMR_IS_STALE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
 		if (rds_conn_up(ic->conn))
 			rds_ib_conn_error(ic->conn,
 					  "frmr completion <%pI4,%pI4> status %u(%s), vendor_err 0x%x, disconnecting and reconnecting\n",
@@ -309,8 +337,7 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	}
 
 	if (frmr->fr_inv) {
-		if (frmr->fr_state == FRMR_IS_INUSE)
-			frmr->fr_state = FRMR_IS_FREE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_FREE);
 		frmr->fr_inv = false;
 		wake_up(&frmr->fr_inv_done);
 	}
@@ -320,6 +347,10 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 		wake_up(&frmr->fr_reg_done);
 	}
 
+	/* enforce order of frmr->{fr_reg,fr_inv} update
+	 * before incrementing i_fastreg_wrs
+	 */
+	smp_mb__before_atomic();
 	atomic_inc(&ic->i_fastreg_wrs);
 }
 
-- 
2.22.0


