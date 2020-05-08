Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BDE1CA9FE
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEHLvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726638AbgEHLva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:51:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EB9C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 04:51:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so4153148pjt.4
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 04:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PAEgPYSMQLjvLttCgFHeo1FyIgbM4EAEax551wq6Al0=;
        b=iylKaAK59BYpIG+BP9Wwe/iRJlmRx3VUhnRJ8BRxEuJKhDaUYeclv2BZt8yThL885d
         M7LyqPd0U/p/wtA4WC+SOG+rU0t0na3NFuZMakz7LrYZV8017dqrHggAerrawGyjvTKn
         bHhtd1uuJvQFXo+oj8XrtGvYKC58AnjomLlPpiF1vapy0kSwTrCBpgOcF9gls5A8V8M1
         XARjAM654ZQqQWnGfSyTVC/60V/hGQ43kXM4ke4kMzfgnulxl/eZHc+Gz0G6TQtb4v/X
         tQ0Sa+tidZ1269eoSR0KJujLx7QkQlAvAjLnVqLETJ3L56HJlFzJ/BarHG7QcJ563SFx
         yKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PAEgPYSMQLjvLttCgFHeo1FyIgbM4EAEax551wq6Al0=;
        b=ItTeIRaec0G2sbHuBZR4faq+SM2BQ9Iil1TtVnpzDEGpGC4Z4aAOKOUJDCJVDDha4x
         MgJsF8imFI9lZ8+z7EMyI6bC9M8NVrUZTzv/12F7mS62lfs1nPOg/a/Syn+Xb5cMmnzT
         G1E4I6zHBOFjtahsq9+qqtjCtq2/5WZgtlKA7HA0GDhoZL4ZH+nlU/Y3s94bQYr+zRw5
         l2215TjdhnMlYVAXX8aigKo4/5T6gQQxGclsSfENhNkXuOKSRStianj6x3jFrdn4Sr9i
         ZnYSd9u0rvSW+DSl46XSG1zdl6551GuxZySaxpIEypGBGSpt16R6oMRvY3zHDMo0IP5E
         RLDg==
X-Gm-Message-State: AGi0PuY+ovUroBkaVzwKRz0nyFJbSkVrfbhnKJWQeJQm0AEU+yj0lyTz
        lgWecejwnVVg7fYC3MDl02B3XUkuvvA=
X-Google-Smtp-Source: APiQypJ+/5i4iYZy+HIYy2KeVy/tKG160m8WYoX/k4Cjjwf653lRvgys46mtngpq3jbnO7oH3gHc/w==
X-Received: by 2002:a17:90b:374e:: with SMTP id ne14mr5381350pjb.145.1588938688699;
        Fri, 08 May 2020 04:51:28 -0700 (PDT)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id p1sm2351957pjf.15.2020.05.08.04.51.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 04:51:28 -0700 (PDT)
From:   Kevin Hao <haokexin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, davem@davemloft.net,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
Subject: [PATCH v2] octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers
Date:   Fri,  8 May 2020 19:49:53 +0800
Message-Id: <20200508114953.2753-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current codes, the octeontx2 uses its own method to allocate
the pool buffers, but there are some issues in this implementation.
1. We have to run the otx2_get_page() for each allocation cycle and
   this is pretty error prone. As I can see there is no invocation
   of the otx2_get_page() in otx2_pool_refill_task(), this will leave
   the allocated pages have the wrong refcount and may be freed wrongly.
2. It wastes memory. For example, if we only receive one packet in a
   NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
   to refill the pool buffers and leave the remain area of the allocated
   page wasted. On a kernel with 64K page, 62K area is wasted.

IMHO it is really unnecessary to implement our own method for the
buffers allocate, we can reuse the napi_alloc_frag() to simplify
our code.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
v2: Use DMA_ATTR_SKIP_CPU_SYNC while mapping the buffer as indicated by
Sunil Kovvuri.

 .../marvell/octeontx2/nic/otx2_common.c       | 52 ++++++++-----------
 .../marvell/octeontx2/nic/otx2_common.h       | 15 +-----
 .../marvell/octeontx2/nic/otx2_txrx.c         |  3 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |  4 --
 4 files changed, 23 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f1d2dea90a8c..612d33207326 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -379,40 +379,33 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 		     (pfvf->hw.cq_ecount_wait - 1));
 }
 
-dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
-			   gfp_t gfp)
+dma_addr_t _otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
 {
 	dma_addr_t iova;
+	u8 *buf;
 
-	/* Check if request can be accommodated in previous allocated page */
-	if (pool->page && ((pool->page_offset + pool->rbsize) <=
-	    (PAGE_SIZE << pool->rbpage_order))) {
-		pool->pageref++;
-		goto ret;
-	}
-
-	otx2_get_page(pool);
-
-	/* Allocate a new page */
-	pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
-				 pool->rbpage_order);
-	if (unlikely(!pool->page))
+	buf = napi_alloc_frag(pool->rbsize);
+	if (unlikely(!buf))
 		return -ENOMEM;
 
-	pool->page_offset = 0;
-ret:
-	iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
-				      pool->rbsize, DMA_FROM_DEVICE);
-	if (!iova) {
-		if (!pool->page_offset)
-			__free_pages(pool->page, pool->rbpage_order);
-		pool->page = NULL;
+	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
+				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+	if (unlikely(dma_mapping_error(pfvf->dev, iova)))
 		return -ENOMEM;
-	}
-	pool->page_offset += pool->rbsize;
+
 	return iova;
 }
 
+static dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
+{
+	dma_addr_t addr;
+
+	local_bh_disable();
+	addr = _otx2_alloc_rbuf(pfvf, pool);
+	local_bh_enable();
+	return addr;
+}
+
 void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -805,7 +798,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	free_ptrs = cq->pool_ptrs;
 
 	while (cq->pool_ptrs) {
-		bufptr = otx2_alloc_rbuf(pfvf, rbpool, GFP_KERNEL);
+		bufptr = otx2_alloc_rbuf(pfvf, rbpool);
 		if (bufptr <= 0) {
 			/* Schedule a WQ if we fails to free atleast half of the
 			 * pointers else enable napi for this RQ.
@@ -1064,7 +1057,6 @@ static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 		return err;
 
 	pool->rbsize = buf_size;
-	pool->rbpage_order = get_order(buf_size);
 
 	/* Initialize this pool's context via AF */
 	aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
@@ -1152,13 +1144,12 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			return -ENOMEM;
 
 		for (ptr = 0; ptr < num_sqbs; ptr++) {
-			bufptr = otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
+			bufptr = otx2_alloc_rbuf(pfvf, pool);
 			if (bufptr <= 0)
 				return bufptr;
 			otx2_aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
-		otx2_get_page(pool);
 	}
 
 	return 0;
@@ -1204,13 +1195,12 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
-			bufptr = otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
+			bufptr = otx2_alloc_rbuf(pfvf, pool);
 			if (bufptr <= 0)
 				return bufptr;
 			otx2_aura_freeptr(pfvf, pool_id,
 					  bufptr + OTX2_HEAD_ROOM);
 		}
-		otx2_get_page(pool);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 0b1c653b3449..5d806252efd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -434,18 +434,6 @@ static inline void otx2_aura_freeptr(struct otx2_nic *pfvf,
 		      otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0));
 }
 
-/* Update page ref count */
-static inline void otx2_get_page(struct otx2_pool *pool)
-{
-	if (!pool->page)
-		return;
-
-	if (pool->pageref)
-		page_ref_add(pool->page, pool->pageref);
-	pool->pageref = 0;
-	pool->page = NULL;
-}
-
 static inline int otx2_get_pool_idx(struct otx2_nic *pfvf, int type, int idx)
 {
 	if (type == AURA_NIX_SQ)
@@ -589,8 +577,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl);
 int otx2_txsch_alloc(struct otx2_nic *pfvf);
 int otx2_txschq_stop(struct otx2_nic *pfvf);
 void otx2_sqb_flush(struct otx2_nic *pfvf);
-dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
-			   gfp_t gfp);
+dma_addr_t _otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool);
 int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 45abe0cd0e7b..62e95c6f38eb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -286,7 +286,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 
 	/* Refill pool with new buffers */
 	while (cq->pool_ptrs) {
-		bufptr = otx2_alloc_rbuf(pfvf, cq->rbpool, GFP_ATOMIC);
+		bufptr = _otx2_alloc_rbuf(pfvf, cq->rbpool);
 		if (unlikely(bufptr <= 0)) {
 			struct refill_work *work;
 			struct delayed_work *dwork;
@@ -304,7 +304,6 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
-	otx2_get_page(cq->rbpool);
 
 	return processed_cqe;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 4ab32d3adb78..da97f2d4416f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -113,11 +113,7 @@ struct otx2_cq_poll {
 struct otx2_pool {
 	struct qmem		*stack;
 	struct qmem		*fc_addr;
-	u8			rbpage_order;
 	u16			rbsize;
-	u32			page_offset;
-	u16			pageref;
-	struct page		*page;
 };
 
 struct otx2_cq_queue {
-- 
2.26.0

