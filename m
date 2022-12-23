Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEBF6549E0
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiLWA5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLWA5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:57:08 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D3B20993;
        Thu, 22 Dec 2022 16:57:07 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMH1F8S028064;
        Thu, 22 Dec 2022 16:56:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=QulrNgaOUK33IV9vkpmdoeKHE6HJxWkxmTMgRZ9iX8o=;
 b=cJoR/Ig7bO7dXKthOJCTJqolR7aibYfABybEHhSvL+2KvyIHRuQbxzq8fwN9WhwJt1AR
 gafyR2K8AWD5Dshv4WIpmZwCKmt3daRkmDhmwOD/7VVn2vfiA/pZk2CQwmoOztQfLiwV
 85MLfx7Pt7P7+izKAVyKu1x2/0RSyalDGuvM7bCD4fWu3LlwcM38h9NDGVCWVxIBZBfC
 kDvMIo4wczk0LYQmJUUqYWvdu6APfbcJV6264ZShMpybmfJLMCaBUnxdFxSjApQ2fXLL
 4i8oTRFphnbZejNYLMltfDx+hLveK8NKjCLalT7qmRSfENNO+Zb/l5WIk0AOXswFNDm4 UQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mhe5rv0ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 16:56:54 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 22 Dec
 2022 16:56:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 22 Dec 2022 16:56:51 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id C16F23F705C;
        Thu, 22 Dec 2022 16:56:48 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [PATCH net] octeontx2-pf: Fix lmtst Id used in aura free
Date:   Fri, 23 Dec 2022 06:26:45 +0530
Message-ID: <20221223005645.8709-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: C8wYzdYiF0iOqmTIWj8YSg--lELqOcO_
X-Proofpoint-ORIG-GUID: C8wYzdYiF0iOqmTIWj8YSg--lELqOcO_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_12,2022-12-22_03,2022-06-22_01
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

This patch also addresses the memory reservation issue,
currently NIX, NPA queue context memory is being allocated using
GFP_KERNEL flag which inturns allocates from memory reserved for
CMA_DMA. Sizing CMA_DMA memory is getting difficult due to this
dependency, the more number of interfaces enabled the more the
CMA_DMA memory requirement.

To fix this issue, GFP_KERNEL flag is replaced with GFP_ATOMIC,
with this memory will be allocated from unreserved memory.

Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/common.h    |  2 +-
 .../marvell/octeontx2/nic/otx2_common.c       | 30 +++++++++++++------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 8931864ee110..4b4be9ca4d2f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -61,7 +61,7 @@ static inline int qmem_alloc(struct device *dev, struct qmem **q,
 	qmem->entry_sz = entry_sz;
 	qmem->alloc_sz = (qsize * entry_sz) + OTX2_ALIGN;
 	qmem->base = dma_alloc_attrs(dev, qmem->alloc_sz, &qmem->iova,
-				     GFP_KERNEL, DMA_ATTR_FORCE_CONTIGUOUS);
+				     GFP_ATOMIC, DMA_ATTR_FORCE_CONTIGUOUS);
 	if (!qmem->base)
 		return -ENOMEM;
 
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

