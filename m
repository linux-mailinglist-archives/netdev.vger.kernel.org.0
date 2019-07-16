Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8406B1D6
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388840AbfGPW3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbfGPW3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:29:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMEFBS192823;
        Tue, 16 Jul 2019 22:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=gDb2wr4tBHWdyt2HcBQ6FO1xSvCGiWvDYVpE07RKs6M=;
 b=UxF6TiFBy/T6rPnP26Gs+WsQF6uAKLzc/tdlbI1KsnMwMekpJtz4kHj7uzEvwWe/Nk/1
 go4JfxM/IV5mOHY29TCZb6gHIT3zXF8E9Zl53Ju6ith8T34HCngTHdMnzd7LI9Und6jS
 GeoxXy046eWu85HN4d3cX3HByQ4UuEEiBS9rkLDrB0VVIP8Dlc9CXNN1Ixn2MEI2VZlf
 QinRFU0TW8FzQQN3YQDv1/z+kKvGoex1Fpfp5ig+mUq9gJCycysYPx+BEPGi5IbSWM2i
 YJIM+yCfpw4dLu+Rp7Dbozmt0PaHqcSBP0dapaaACwh7ajkohMM2gWkOgfKoocnbXih7 eA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tq78pq5fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCff9064441;
        Tue, 16 Jul 2019 22:29:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tq5bcnryg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:29:04 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMSkFA096156;
        Tue, 16 Jul 2019 22:29:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tq5bcnry5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:04 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GMT38v031052;
        Tue, 16 Jul 2019 22:29:03 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:29:03 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <59304e3c-e15f-6a3b-a8d2-63de370ed847@oracle.com>
Date:   Tue, 16 Jul 2019 15:29:02 -0700
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
 net/rds/ib_frmr.c | 65 +++++++++++++++++++++++++++--------------------
 net/rds/ib_mr.h   |  2 ++
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 6038138d6e38..708c553c3da5 100644
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
@@ -144,7 +146,17 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		if (printk_ratelimit())
 			pr_warn("RDS/IB: %s returned error(%d)\n",
 				__func__, ret);
+		goto out;
 	}
+
+	/* Wait for the registration to complete in order to prevent an invalid
+	 * access error resulting from a race between the memory region already
+	 * being accessed while registration is still pending.
+	 */
+	wait_event(frmr->fr_reg_done, !frmr->fr_reg);
+
+out:
+
 	return ret;
 }
 
@@ -262,6 +274,19 @@ static int rds_ib_post_inv(struct rds_ib_mr *ibmr)
 		pr_err("RDS/IB: %s returned error(%d)\n", __func__, ret);
 		goto out;
 	}
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
+	wait_event(frmr->fr_inv_done, frmr->fr_state != FRMR_IS_INUSE);
+
 out:
 	return ret;
 }
@@ -289,6 +314,11 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 		wake_up(&frmr->fr_inv_done);
 	}
 
+	if (frmr->fr_reg) {
+		frmr->fr_reg = false;
+		wake_up(&frmr->fr_reg_done);
+	}
+
 	atomic_inc(&ic->i_fastreg_wrs);
 }
 
@@ -297,14 +327,18 @@ void rds_ib_unreg_frmr(struct list_head *list, unsigned int *nfreed,
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
 
@@ -347,31 +381,8 @@ struct rds_ib_mr *rds_ib_reg_frmr(struct rds_ib_device *rds_ibdev,
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
-			 * So we wait for "fr_inv_done" to trigger
-			 * and only put memory regions onto the drop_list
-			 * that failed (i.e. not marked "FRMR_IS_FREE").
-			 *
-			 * This avoids the problem of memory-regions bouncing
-			 * between "clean_list" and "drop_list" before they
-			 * even have a chance to be properly invalidated.
-			 */
-			frmr = &ibmr->u.frmr;
-			wait_event(frmr->fr_inv_done, frmr->fr_state != FRMR_IS_INUSE);
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
2.22.0


