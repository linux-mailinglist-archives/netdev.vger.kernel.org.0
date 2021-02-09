Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4327314CCB
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhBIKTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhBIKR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:17:26 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B946C061788
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:16:46 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t11so8474264pgu.8
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nwegWcvfdOvDBjpI6rTN4TRoTlFUhYh/KI8czL+q75A=;
        b=WhhuOYrkXCM28jqhwV4zuWDb0/BpS8M3ZgiZZGQgwiYZPS8Aw3sEVN08hDBWqngs75
         3ekHx94OeAnXz++bWuWjLEb9r3uQKJnU/D3ols4sH1IMrG8qhcj/bCFhRHLzOqrk+ztd
         G6qUYIIIFKbu0+sWJ2krolsEmI/p4UcwiuPyWyDGN+f/tBgw2kVM3xNtOX5aIv4QIqk9
         pFqr61flU0+HaXkZ2fq37FBdFRzvnpBAaI9hJYK0uadYjD1IG5Is/LnLMDaZyjoc2VSD
         XgjjA+d0T4CQYIao/ZYDHO+v3uhDeU28OG4x4UmkdSlr9FhkdRuVGz4HvWZZD0Bx0XPH
         2nqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nwegWcvfdOvDBjpI6rTN4TRoTlFUhYh/KI8czL+q75A=;
        b=nmSg6SPortdgrvPFN/RtgI3ctBeYBR4+AmVOWrNWwZpEqIf8jr+ggqiC6XxD5c/ofr
         h5AiGGFWcA6RrsgvUxG0Mq1dHrmqFG1Zwd4c0vE9WndSYGffmuXgAhtZ/8flg0lEmcBD
         70XvxRs3+ZwTBu4LohHscX1yXq2gyhCeC3AdIF/rql4cXUsnpXsrce+h8yxavCVpZ5hs
         1/csHQ3JceDkC/8H4ltRg0QifPJ1NxoYrNTmWatvc4LCqpiIDQhBhtoXD8SuA3vCDPqw
         Pa4ivyd/B8QKjKSia99bcyuKRzYM/LAv7xJ8Myv4yO779ASFpDGV9QP4hIjuaXtUrVx3
         vMXQ==
X-Gm-Message-State: AOAM533y6qdVUPPJtNykcbeRjczv5AbLSYenRLva+5IBTrizk39FIu/l
        zXo7Fhh0fWmZTgIESfwGC+qpg5iG/tB1vA==
X-Google-Smtp-Source: ABdhPJxzSNOTNWpY5Us48fBgnjhRQpMVHMU9p3aISm43yT7ugEX+l5FfYhOejxd0ObSIUajS89WBmQ==
X-Received: by 2002:a63:2746:: with SMTP id n67mr20743051pgn.54.1612865805503;
        Tue, 09 Feb 2021 02:16:45 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id j185sm22261207pge.46.2021.02.09.02.16.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 02:16:44 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH net-next v2] net: octeontx2: Fix the confusion in buffer alloc failure path
Date:   Tue,  9 Feb 2021 18:15:16 +0800
Message-Id: <20210209101516.7536-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel pointed that the return of dma_addr_t in
otx2_alloc_rbuf/__otx2_alloc_rbuf() seem suspicious because a negative
error code may be returned in some cases. For a dma_addr_t, the error
code such as -ENOMEM does seem a valid value, so we can't judge if the
buffer allocation fail or not based on that value. Add a parameter for
otx2_alloc_rbuf/__otx2_alloc_rbuf() to store the dma address and make
the return value to indicate if the buffer allocation really fail or
not.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Tested-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
v2: Just sort the variable declaration and add Tested-by from Subbaraya.
    No function change.

 .../marvell/octeontx2/nic/otx2_common.c       | 38 +++++++++----------
 .../marvell/octeontx2/nic/otx2_common.h       |  7 ++--
 .../marvell/octeontx2/nic/otx2_txrx.c         |  5 +--
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cbd68fa9f1d6..70a91d8be074 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -483,33 +483,34 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 		     (pfvf->hw.cq_ecount_wait - 1));
 }
 
-dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
+int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+		      dma_addr_t *dma)
 {
-	dma_addr_t iova;
 	u8 *buf;
 
 	buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
+	*dma = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
-	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
+	if (unlikely(dma_mapping_error(pfvf->dev, *dma))) {
 		page_frag_free(buf);
 		return -ENOMEM;
 	}
 
-	return iova;
+	return 0;
 }
 
-static dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
+static int otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+			   dma_addr_t *dma)
 {
-	dma_addr_t addr;
+	int ret;
 
 	local_bh_disable();
-	addr = __otx2_alloc_rbuf(pfvf, pool);
+	ret = __otx2_alloc_rbuf(pfvf, pool, dma);
 	local_bh_enable();
-	return addr;
+	return ret;
 }
 
 void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
@@ -903,7 +904,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	struct refill_work *wrk;
 	int qidx, free_ptrs = 0;
 	struct otx2_nic *pfvf;
-	s64 bufptr;
+	dma_addr_t bufptr;
 
 	wrk = container_of(work, struct refill_work, pool_refill_work.work);
 	pfvf = wrk->pf;
@@ -913,8 +914,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	free_ptrs = cq->pool_ptrs;
 
 	while (cq->pool_ptrs) {
-		bufptr = otx2_alloc_rbuf(pfvf, rbpool);
-		if (bufptr <= 0) {
+		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
 			 * pointers else enable napi for this RQ.
 			 */
@@ -1213,8 +1213,8 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	struct otx2_hw *hw = &pfvf->hw;
 	struct otx2_snd_queue *sq;
 	struct otx2_pool *pool;
+	dma_addr_t bufptr;
 	int err, ptr;
-	s64 bufptr;
 
 	/* Calculate number of SQBs needed.
 	 *
@@ -1259,9 +1259,8 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			return -ENOMEM;
 
 		for (ptr = 0; ptr < num_sqbs; ptr++) {
-			bufptr = otx2_alloc_rbuf(pfvf, pool);
-			if (bufptr <= 0)
-				return bufptr;
+			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
+				return -ENOMEM;
 			otx2_aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
@@ -1280,7 +1279,7 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	int stack_pages, pool_id, rq;
 	struct otx2_pool *pool;
 	int err, ptr, num_ptrs;
-	s64 bufptr;
+	dma_addr_t bufptr;
 
 	num_ptrs = pfvf->qset.rqe_cnt;
 
@@ -1310,9 +1309,8 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
-			bufptr = otx2_alloc_rbuf(pfvf, pool);
-			if (bufptr <= 0)
-				return bufptr;
+			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
+				return -ENOMEM;
 			otx2_aura_freeptr(pfvf, pool_id,
 					  bufptr + OTX2_HEAD_ROOM);
 		}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 143ae04c8ad5..0404900338e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -485,9 +485,9 @@ static inline u64 otx2_aura_allocptr(struct otx2_nic *pfvf, int aura)
 
 /* Free pointer to a pool/aura */
 static inline void otx2_aura_freeptr(struct otx2_nic *pfvf,
-				     int aura, s64 buf)
+				     int aura, u64 buf)
 {
-	otx2_write128((u64)buf, (u64)aura | BIT_ULL(63),
+	otx2_write128(buf, (u64)aura | BIT_ULL(63),
 		      otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0));
 }
 
@@ -636,7 +636,8 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl);
 int otx2_txsch_alloc(struct otx2_nic *pfvf);
 int otx2_txschq_stop(struct otx2_nic *pfvf);
 void otx2_sqb_flush(struct otx2_nic *pfvf);
-dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool);
+int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+		      dma_addr_t *dma);
 int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index d0e25414f1a1..cc0dac325f77 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -304,7 +304,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 {
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
-	s64 bufptr;
+	dma_addr_t bufptr;
 
 	while (likely(processed_cqe < budget)) {
 		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
@@ -333,8 +333,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 
 	/* Refill pool with new buffers */
 	while (cq->pool_ptrs) {
-		bufptr = __otx2_alloc_rbuf(pfvf, cq->rbpool);
-		if (unlikely(bufptr <= 0)) {
+		if (unlikely(__otx2_alloc_rbuf(pfvf, cq->rbpool, &bufptr))) {
 			struct refill_work *work;
 			struct delayed_work *dwork;
 
-- 
2.29.2

