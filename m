Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9CC3128D4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 02:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBHBz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 20:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBHBzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 20:55:25 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913ADC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 17:54:45 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x23so7208222pfn.6
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 17:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KMMfvhQndZz5ZN09ti33GHNuUIpORbDBuZ9Th9DM3Co=;
        b=s8OdLLcZRK9wFNBoXUQgug7y6TQiwGCyQb6+mD43n0ETeOLIe377dK8e980V0h6o6K
         zlDlcsWfJgt9ep/gnC5mbYFUWjXkIwWTInADhS94H/kwgKd2Rmvu/CvkQdGGnv4DbHQd
         9/12Mqbsrl59Loq98cF8IgeYDAST7Ae/5/cq6VHkgTiHW6ra8hLid6xDHE6h/iwbuICz
         PNpem9XBXwEWquai2VzApAvKTnmEx0wVArUzIPAzssMabGYvWylQN0nDX+jp/qUpdicR
         5DC9hDBtls6hI/dAvJjUWA2f8rFMKPBXlDjis0nqzfrkPdi80Rll80yPcX6pX9Yi7h0e
         bgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KMMfvhQndZz5ZN09ti33GHNuUIpORbDBuZ9Th9DM3Co=;
        b=PCJC/DIQw6wFcmzyrLfx35A7dcZI69u6H3QsQp2IHPTEPe8bV0Zi5oA9xK8PY/hdc6
         l2+OzAP+AH2bvJIYb8GsZkO3wQUrGviy6VC+bBuZQl1g8uCpP2epREqlj6QXv8hnLk5S
         zUhDifyh4eXsz8ChzZrRs07EN1u6UITb+sSUkRLgRd1vsCOAKBTL7siOu1T172TpMcgq
         iH8Z98lCL1XEsWme3bbH3nj6eAWjH8ZTY8fCtD1jjD+ixzENQVbHwzsOv3uwN98+9jCI
         6eAQYPxpwijjOddsnMsw0KLhCpwMK41WI5gxnzlBNASQiY/nKiOGBSZMXCKTVWjjGObO
         OiCw==
X-Gm-Message-State: AOAM531NB9+OE/J4CVU2YbDXHtiGgvhfLYimmuSxj6fRpTYkSRSV1kKN
        ynK4boqr0XtQgwGrhiNdv/w=
X-Google-Smtp-Source: ABdhPJx089EBBi9/jK69l7SpiD4LxhBOklRIqLlo2jktPNsntW5msRDZBgcrk86RPhUun/Mz8y7tzA==
X-Received: by 2002:a63:ff0f:: with SMTP id k15mr15339236pgi.213.1612749284987;
        Sun, 07 Feb 2021 17:54:44 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id z11sm14258496pjn.5.2021.02.07.17.54.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 07 Feb 2021 17:54:44 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH net-next] net: octeontx2: Fix the confusion in buffer alloc failure path
Date:   Mon,  8 Feb 2021 09:45:45 +0800
Message-Id: <20210208014545.6945-1-haokexin@gmail.com>
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
---
 .../marvell/octeontx2/nic/otx2_common.c       | 38 +++++++++----------
 .../marvell/octeontx2/nic/otx2_common.h       |  7 ++--
 .../marvell/octeontx2/nic/otx2_txrx.c         |  5 +--
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cbd68fa9f1d6..ca2c47ce8ade 100644
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
@@ -1214,7 +1214,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	struct otx2_snd_queue *sq;
 	struct otx2_pool *pool;
 	int err, ptr;
-	s64 bufptr;
+	dma_addr_t bufptr;
 
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

