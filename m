Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6035C147
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfGAQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:39:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbfGAQju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:39:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GYKQB172269;
        Mon, 1 Jul 2019 16:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=NztnnUSXZXmPetNTRZ2235Lj690RYtKlQub2amL4wVU=;
 b=pjFkxwVDG3+SWhkO3KqzLiWruBM1eIUiPe8DI6rbrIYCnx8RCPX0K1bNZMpbIMnbOmC7
 eEL1FVY1EdcNykPjbBl3aBOUapOL3xf/QYeleH0Sm75f6bCaOGDI+GJcY/0wJw+roYFx
 aeGhaQZwJo5VjuKZbXh0b66DyHDiWiwQRnBvQyfdCtIDjkazKmUTwTg5LF4o4MnIl+t5
 qxmDp36OyZhisbyl1gi8rOXCR0ge6Q19oq/4F6eJYtINzBp38Bp+h0hRMwOPVGj3exYi
 ZIFVypkxt+teudZjKR+wHROh0Wq8ZoaMDWvWM3Zv758fAZmEW9+ELTS4Yar7BephS7a1 GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61dxqux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:39:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWb3O148035;
        Mon, 1 Jul 2019 16:39:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebktsaut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:39:46 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61GdjAq021187;
        Mon, 1 Jul 2019 16:39:45 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:39:45 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 1/7] net/rds: Give fr_state a chance to transition to
 FRMR_IS_FREE
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <44f1794c-7c9c-35bc-dc64-a2a993d06a6e@oracle.com>
Date:   Mon, 1 Jul 2019 09:39:44 -0700
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

In the context of FRMR (ib_frmr.c):

Memory regions make it onto the "clean_list" via "rds_ib_flush_mr_pool",
after the memory region has been posted for invalidation via
"rds_ib_post_inv".

At that point in time, "fr_state" may still be in state "FRMR_IS_INUSE",
since the only place where "fr_state" transitions to "FRMR_IS_FREE"
is in "rds_ib_mr_cqe_handler", which is triggered by a tasklet.

So in case we notice that "fr_state != FRMR_IS_FREE" (see below),
we wait for "fr_inv_done" to trigger with a maximum of 10msec.
Then we check again, and only put the memory region onto the drop_list
(via "rds_ib_free_frmr") in case the situation remains unchanged.

This avoids the problem of memory-regions bouncing between "clean_list"
and "drop_list" before they even have a chance to be properly invalidated.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_frmr.c | 32 +++++++++++++++++++++++++++++++-
 net/rds/ib_mr.h   |  1 +
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 32ae26ed58a0..9f8aa310c27a 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -75,6 +75,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 		pool->max_items_soft = pool->max_items;
 
 	frmr->fr_state = FRMR_IS_FREE;
+	init_waitqueue_head(&frmr->fr_inv_done);
 	return ibmr;
 
 out_no_cigar:
@@ -285,6 +286,7 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	if (frmr->fr_inv) {
 		frmr->fr_state = FRMR_IS_FREE;
 		frmr->fr_inv = false;
+		wake_up(&frmr->fr_inv_done);
 	}
 
 	atomic_inc(&ic->i_fastreg_wrs);
@@ -345,8 +347,36 @@ struct rds_ib_mr *rds_ib_reg_frmr(struct rds_ib_device *rds_ibdev,
 	}
 
 	do {
-		if (ibmr)
+		if (ibmr) {
+			/* Memory regions make it onto the "clean_list" via
+			 * "rds_ib_flush_mr_pool", after the memory region has
+			 * been posted for invalidation via "rds_ib_post_inv".
+			 *
+			 * At that point in time, "fr_state" may still be
+			 * in state "FRMR_IS_INUSE", since the only place where
+			 * "fr_state" transitions to "FRMR_IS_FREE" is in
+			 * is in "rds_ib_mr_cqe_handler", which is
+			 * triggered by a tasklet.
+			 *
+			 * So in case we notice that
+			 * "fr_state != FRMR_IS_FREE" (see below), * we wait for
+			 * "fr_inv_done" to trigger with a maximum of 10msec.
+			 * Then we check again, and only put the memory region
+			 * onto the drop_list (via "rds_ib_free_frmr")
+			 * in case the situation remains unchanged.
+			 *
+			 * This avoids the problem of memory-regions bouncing
+			 * between "clean_list" and "drop_list" before they
+			 * even have a chance to be properly invalidated.
+			 */
+			frmr = &ibmr->u.frmr;
+			wait_event_timeout(frmr->fr_inv_done,
+					   frmr->fr_state == FRMR_IS_FREE,
+					   msecs_to_jiffies(10));
+			if (frmr->fr_state == FRMR_IS_FREE)
+				break;
 			rds_ib_free_frmr(ibmr, true);
+		}
 		ibmr = rds_ib_alloc_frmr(rds_ibdev, nents);
 		if (IS_ERR(ibmr))
 			return ibmr;
diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
index 5da12c248431..42daccb7b5eb 100644
--- a/net/rds/ib_mr.h
+++ b/net/rds/ib_mr.h
@@ -57,6 +57,7 @@ struct rds_ib_frmr {
 	struct ib_mr		*mr;
 	enum rds_ib_fr_state	fr_state;
 	bool			fr_inv;
+	wait_queue_head_t	fr_inv_done;
 	struct ib_send_wr	fr_wr;
 	unsigned int		dma_npages;
 	unsigned int		sg_byte_len;
-- 
2.18.0


