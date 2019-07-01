Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B95E5C14A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfGAQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:39:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfGAQj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:39:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GYBvJ181138;
        Mon, 1 Jul 2019 16:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=28Nw0hGU99E/K1BCBTci2Zpy3/koqJYVQ2VdLPoxS8M=;
 b=DU5ztx5ODkAGvS+dr8+7+a7pAiBBPiraEbhMMt64C/wyNu/4BZoukvFBTyUm0DPi2K9p
 BgSlKvpz2SLlBk/5ep2qT9bvlvYRRUVVSQ7thNp7W9798Q2FtkCw56xSHUQqD55rJiWI
 DxaTZPIWZ1vUmGyRknDtHUWTI/cxvNtZpG0jcyNcKdBAEWpKzmO5d6fuN8P8ZCKnFiuI
 5hqBqKlp8oOrqHPbxMqgQ0qmhBDdsXuz1fEWrH3cU/MkjuUdW0JJ6GOGgeIIoEVESrEp
 X9sMSAX/RbHFM2izab4cPuLhX+nLQais/C9au7g+ZDIvfpjKzpyJNpD7brl1MeXWEU8a GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2te61ppqx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:39:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWV2N172003;
        Mon, 1 Jul 2019 16:39:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tebbj9c8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:39:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61Gdtq4018541;
        Mon, 1 Jul 2019 16:39:55 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:39:55 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
Date:   Mon, 1 Jul 2019 09:39:54 -0700
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

In order to:
1) avoid a silly bouncing between "clean_list" and "drop_list"
   triggered by function "rds_ib_reg_frmr" as it is releases frmr
   regions whose state is not "FRMR_IS_FREE" right away.

2) prevent an invalid access error in a race from a pending
   "IB_WR_LOCAL_INV" operation with a teardown ("dma_unmap_sg", "put_page")
   and de-registration ("ib_dereg_mr") of the corresponding
   memory region.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_frmr.c | 89 ++++++++++++++++++++++++++++++-----------------
 net/rds/ib_mr.h   |  2 ++
 2 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 9f8aa310c27a..3c953034dca3 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -76,6 +76,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 
 	frmr->fr_state = FRMR_IS_FREE;
 	init_waitqueue_head(&frmr->fr_inv_done);
+	init_waitqueue_head(&frmr->fr_reg_done);
 	return ibmr;
 
 out_no_cigar:
@@ -124,6 +125,7 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 	 */
 	ib_update_fast_reg_key(frmr->mr, ibmr->remap_count++);
 	frmr->fr_state = FRMR_IS_INUSE;
+	frmr->fr_reg = true;
 
 	memset(&reg_wr, 0, sizeof(reg_wr));
 	reg_wr.wr.wr_id = (unsigned long)(void *)ibmr;
@@ -144,7 +146,29 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		if (printk_ratelimit())
 			pr_warn("RDS/IB: %s returned error(%d)\n",
 				__func__, ret);
+		goto out;
+	}
+
+	if (!frmr->fr_reg)
+		goto out;
+
+	/* Wait for the registration to complete in order to prevent an invalid
+	 * access error resulting from a race between the memory region already
+	 * being accessed while registration is still pending.
+	 */
+	wait_event_timeout(frmr->fr_reg_done, !frmr->fr_reg,
+			   msecs_to_jiffies(100));
+
+	/* Registration did not complete within one second, something's wrong */
+	if (frmr->fr_reg) {
+		pr_warn("RDS/IB: %s registration still incomplete after 100msec\n",
+			__func__);
+		frmr->fr_state = FRMR_IS_STALE;
+		ret = -EBUSY;
 	}
+
+out:
+
 	return ret;
 }
 
@@ -262,6 +286,26 @@ static int rds_ib_post_inv(struct rds_ib_mr *ibmr)
 		pr_err("RDS/IB: %s returned error(%d)\n", __func__, ret);
 		goto out;
 	}
+
+	if (frmr->fr_state != FRMR_IS_INUSE)
+		goto out;
+
+	/* Wait for the FRMR_IS_FREE (or FRMR_IS_STALE) transition in order to
+	 * 1) avoid a silly bouncing between "clean_list" and "drop_list"
+	 *    triggered by function "rds_ib_reg_frmr" as it is releases frmr
+	 *    regions whose state is not "FRMR_IS_FREE" right away.
+	 * 2) prevents an invalid access error in a race
+	 *    from a pending "IB_WR_LOCAL_INV" operation
+	 *    with a teardown ("dma_unmap_sg", "put_page")
+	 *    and de-registration ("ib_dereg_mr") of the corresponding
+	 *    memory region.
+	 */
+	wait_event_timeout(frmr->fr_inv_done, frmr->fr_state != FRMR_IS_INUSE,
+			   msecs_to_jiffies(50));
+
+	if (frmr->fr_state == FRMR_IS_INUSE)
+		ret = -EBUSY;
+
 out:
 	return ret;
 }
@@ -289,6 +333,11 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 		wake_up(&frmr->fr_inv_done);
 	}
 
+	if (frmr->fr_reg) {
+		frmr->fr_reg = false;
+		wake_up(&frmr->fr_reg_done);
+	}
+
 	atomic_inc(&ic->i_fastreg_wrs);
 }
 
@@ -297,14 +346,18 @@ void rds_ib_unreg_frmr(struct list_head *list, unsigned int *nfreed,
 {
 	struct rds_ib_mr *ibmr, *next;
 	struct rds_ib_frmr *frmr;
-	int ret = 0;
+	int ret = 0, ret2;
 	unsigned int freed = *nfreed;
 
 	/* String all ib_mr's onto one list and hand them to ib_unmap_fmr */
 	list_for_each_entry(ibmr, list, unmap_list) {
-		if (ibmr->sg_dma_len)
-			ret |= rds_ib_post_inv(ibmr);
+		if (ibmr->sg_dma_len) {
+			ret2 = rds_ib_post_inv(ibmr);
+			if (ret2 && !ret)
+				ret = ret2;
+		}
 	}
+
 	if (ret)
 		pr_warn("RDS/IB: %s failed (err=%d)\n", __func__, ret);
 
@@ -347,36 +400,8 @@ struct rds_ib_mr *rds_ib_reg_frmr(struct rds_ib_device *rds_ibdev,
 	}
 
 	do {
-		if (ibmr) {
-			/* Memory regions make it onto the "clean_list" via
-			 * "rds_ib_flush_mr_pool", after the memory region has
-			 * been posted for invalidation via "rds_ib_post_inv".
-			 *
-			 * At that point in time, "fr_state" may still be
-			 * in state "FRMR_IS_INUSE", since the only place where
-			 * "fr_state" transitions to "FRMR_IS_FREE" is in
-			 * is in "rds_ib_mr_cqe_handler", which is
-			 * triggered by a tasklet.
-			 *
-			 * So in case we notice that
-			 * "fr_state != FRMR_IS_FREE" (see below), * we wait for
-			 * "fr_inv_done" to trigger with a maximum of 10msec.
-			 * Then we check again, and only put the memory region
-			 * onto the drop_list (via "rds_ib_free_frmr")
-			 * in case the situation remains unchanged.
-			 *
-			 * This avoids the problem of memory-regions bouncing
-			 * between "clean_list" and "drop_list" before they
-			 * even have a chance to be properly invalidated.
-			 */
-			frmr = &ibmr->u.frmr;
-			wait_event_timeout(frmr->fr_inv_done,
-					   frmr->fr_state == FRMR_IS_FREE,
-					   msecs_to_jiffies(10));
-			if (frmr->fr_state == FRMR_IS_FREE)
-				break;
+		if (ibmr)
 			rds_ib_free_frmr(ibmr, true);
-		}
 		ibmr = rds_ib_alloc_frmr(rds_ibdev, nents);
 		if (IS_ERR(ibmr))
 			return ibmr;
diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
index ab26c20ed66f..9045a8c0edff 100644
--- a/net/rds/ib_mr.h
+++ b/net/rds/ib_mr.h
@@ -58,6 +58,8 @@ struct rds_ib_frmr {
 	enum rds_ib_fr_state	fr_state;
 	bool			fr_inv;
 	wait_queue_head_t	fr_inv_done;
+	bool			fr_reg;
+	wait_queue_head_t	fr_reg_done;
 	struct ib_send_wr	fr_wr;
 	unsigned int		dma_npages;
 	unsigned int		sg_byte_len;
-- 
2.18.0


