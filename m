Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F9E65B9DC
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 04:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjACDul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 22:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjACDuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 22:50:40 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B76E26FC;
        Mon,  2 Jan 2023 19:50:37 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3033dwKf008462;
        Mon, 2 Jan 2023 19:50:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Dk2UWTXHJ3uZtt1XlZoFNQHxMPmImW71MwcUgswlzaU=;
 b=I7Xo42A/f2iAumjUVtbw4ZOfPxXIzj5Q0onxDFTpsCL26A+WegGgX0qMfnbXJQQhrFLa
 Zc2PfJfHtmMTXbNxcksz64GUcdZgZnNO962bWJqxJ32li+/CBbvf90cgSAH47vrl8m0k
 k9Qyo43DqQDVdljs3YI8maF1tmHyCdd79hKSLRCYY2v/qVjarQtehDspsii7MhVwAlum
 mHMLGGVuYJ6XVuO43aEisiSMsgP8gn8sRReauJOVXtVfiqWUjLn9QDZYBA5ZgJR5l4ou
 s3mybZP42zEgZrwCdv/2zaPfGX+6QTkNoSwvdcdO97O63nyedM2MjdoIXu+xGyLwK3ln eA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mtkauv8te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 19:50:23 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 2 Jan
 2023 19:50:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 2 Jan 2023 19:50:22 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 0FA8B3F7084;
        Mon,  2 Jan 2023 19:50:18 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [v2 PATCH net] octeontx2-pf: Fix lmtst ID used in aura free
Date:   Tue, 3 Jan 2023 09:20:12 +0530
Message-ID: <20230103035012.15924-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: cj5fMaFhr0flZ9wZDZjuwxTV1v2A6jmF
X-Proofpoint-ORIG-GUID: cj5fMaFhr0flZ9wZDZjuwxTV1v2A6jmF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-02_14,2022-12-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code uses per_cpu pointer to get the lmtst_id mapped to
the core on which aura_free() is executed. Using per_cpu pointer
without preemption disable causing mismatch between lmtst_id and
core on which pointer gets freed. This patch fixes the issue by
disabling preemption around aura_free.

Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
v1-v2:
- Moved the RVU AF driver fix to different patch.

 .../marvell/octeontx2/nic/otx2_common.c       | 30 +++++++++++++------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9e10e7471b88..88f8772a61cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1012,6 +1012,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	rbpool = cq->rbpool;
 	free_ptrs = cq->pool_ptrs;
 
+	get_cpu();
 	while (cq->pool_ptrs) {
 		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
@@ -1031,6 +1032,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
+	put_cpu();
 	cq->refill_task_sched = false;
 }
 
@@ -1368,6 +1370,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
+	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1376,18 +1379,24 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 		sq = &qset->sq[qidx];
 		sq->sqb_count = 0;
 		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
-		if (!sq->sqb_ptrs)
-			return -ENOMEM;
+		if (!sq->sqb_ptrs) {
+			err = -ENOMEM;
+			goto err_mem;
+		}
 
 		for (ptr = 0; ptr < num_sqbs; ptr++) {
-			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
-				return -ENOMEM;
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
+			if (err)
+				goto err_mem;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
 
-	return 0;
+err_mem:
+	put_cpu();
+	return err ? -ENOMEM : 0;
+
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
@@ -1426,18 +1435,21 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
+	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
-			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
-				return -ENOMEM;
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
+			if (err)
+				goto err_mem;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
 						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
-
-	return 0;
+err_mem:
+	put_cpu();
+	return err ? -ENOMEM : 0;
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
-- 
2.25.1

