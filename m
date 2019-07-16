Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD03A6B1D1
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfGPW3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbfGPW25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:28:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDcSG109876;
        Tue, 16 Jul 2019 22:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=wjiHSu+u3O6hyh4tC1UAZdjA75HS7RvDLG+KN2zBEcs=;
 b=iJz6nSbdKtofG/OHKat0RII8Uu7l62JSwyr1/6vanBzzVs1iOyalzlz/F1SZreeWUI5Z
 BjC7S+F/H2ez7KSEVs45ojwFdPsi664Y2DlXniFI4Ct4y9jjtfjNPNbfZMk+LDO28+T5
 4s/lqI/RQb1c5uPLrmnBWVPhwuEFNrBd8w4Ncc56TZcZdWPU4EeX0RUwkoV17riFIoaQ
 FpiwmJzpnmDr08s8Pn2t4lqpjeZDnosA83YjTbNWSXJdQDqrrnxFtxNnOg/rjVrVbzgf
 PFmWTFxSpgDZeCFr465h5IJ2D58W85JaBaRrmv1PdrDEe9wAzouPIrWyl6IDBjicGqPH GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tq7xqy4er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:28:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCkvb028008;
        Tue, 16 Jul 2019 22:28:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2tsmcc2p0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:28:54 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMSsiR059654;
        Tue, 16 Jul 2019 22:28:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tsmcc2p0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:28:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GMSqf2030995;
        Tue, 16 Jul 2019 22:28:52 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:28:52 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 1/7] net/rds: Give fr_state a chance to transition to
 FRMR_IS_FREE
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <491db13c-3843-b57a-c9c5-9c7e7c18381a@oracle.com>
Date:   Tue, 16 Jul 2019 15:28:51 -0700
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
 net/rds/ib_frmr.c | 27 ++++++++++++++++++++++++++-
 net/rds/ib_mr.h   |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 32ae26ed58a0..6038138d6e38 100644
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
@@ -345,8 +347,31 @@ struct rds_ib_mr *rds_ib_reg_frmr(struct rds_ib_device *rds_ibdev,
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
+			 * So we wait for "fr_inv_done" to trigger
+			 * and only put memory regions onto the drop_list
+			 * that failed (i.e. not marked "FRMR_IS_FREE").
+			 *
+			 * This avoids the problem of memory-regions bouncing
+			 * between "clean_list" and "drop_list" before they
+			 * even have a chance to be properly invalidated.
+			 */
+			frmr = &ibmr->u.frmr;
+			wait_event(frmr->fr_inv_done, frmr->fr_state != FRMR_IS_INUSE);
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
2.22.0


