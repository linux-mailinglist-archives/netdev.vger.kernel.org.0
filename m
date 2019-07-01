Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DAA5C14D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfGAQkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:40:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbfGAQkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:40:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GYEmF181155;
        Mon, 1 Jul 2019 16:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=8XUhHis2shNn48L66IFsze2zF687tEUMutJdje6tn50=;
 b=t4Mq99WlwXg27sYKygnQgbdh85kmqjTzwQJ1JDH87NziBFB6cWIhlKncEksIiwXlOueG
 wQLmva9ErLqS9HnfwkE5tQinyUd0Ejgi4N8deG99FL9HWc4kyT+tvrkTH+7mNfNwi8q8
 am3CPDaHgA7c7prs+Z6Gdgmy255iERAnIoGPXWExCZ3e3POAWeUONiFurQNZPHfywUy/
 LpqlKR5RQ/xy2QAD/JMVyICJNUjtpoBclcbPpNcxXvIx7sP8kxDLu0LEl6+BcxhoIxFx
 CAJXxWICYCqg2pYyWI5TsMeTiApCMkjXQ0WXaz77eaLB0BvOOgSLc8Ax5I6VugQTdiEc ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2te61ppr00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWWPa172059;
        Mon, 1 Jul 2019 16:40:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tebbj9ccp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61GeBbi028918;
        Mon, 1 Jul 2019 16:40:11 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:40:11 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 6/7] net/rds: Keep track of and wait for FRWR
 segments in use upon shutdown
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <ad27abb5-b86a-1942-e2c8-2cba00812849@oracle.com>
Date:   Mon, 1 Jul 2019 09:40:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010200
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
 net/rds/ib_frmr.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 46 insertions(+), 7 deletions(-)

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
index a5d8f4128515..19c4cafb6952 100644
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
@@ -163,7 +187,7 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 	if (frmr->fr_reg) {
 		pr_warn("RDS/IB: %s registration still incomplete after 100msec\n",
 			__func__);
-		frmr->fr_state = FRMR_IS_STALE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
 		ret = -EBUSY;
 	}
 
@@ -280,8 +304,12 @@ static int rds_ib_post_inv(struct rds_ib_mr *ibmr)
 
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
@@ -316,7 +344,7 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	struct rds_ib_frmr *frmr = &ibmr->u.frmr;
 
 	if (wc->status != IB_WC_SUCCESS) {
-		frmr->fr_state = FRMR_IS_STALE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
 		if (rds_conn_up(ic->conn))
 			rds_ib_conn_error(ic->conn,
 					  "frmr completion <%pI4,%pI4> status %u(%s), vendor_err 0x%x, disconnecting and reconnecting\n",
@@ -328,8 +356,7 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	}
 
 	if (frmr->fr_inv) {
-		if (frmr->fr_state == FRMR_IS_INUSE)
-			frmr->fr_state = FRMR_IS_FREE;
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_FREE);
 		frmr->fr_inv = false;
 		wake_up(&frmr->fr_inv_done);
 	}
@@ -339,6 +366,10 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 		wake_up(&frmr->fr_reg_done);
 	}
 
+	/* enforce order of frmr->{fr_reg,fr_inv} update
+	 * before incrementing i_fastreg_wrs
+	 */
+	smp_mb__before_atomic();
 	atomic_inc(&ic->i_fastreg_wrs);
 }
 
-- 
2.18.0


