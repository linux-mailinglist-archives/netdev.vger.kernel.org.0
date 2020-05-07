Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ECD1C871E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEGKns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGKnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:43:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3635C061A10;
        Thu,  7 May 2020 03:43:47 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so2447683pjb.5;
        Thu, 07 May 2020 03:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wEXYgsYD3Y+R+C2BDRDsqzw6Doabf1POTv38ULLKg1A=;
        b=lQuWdjK7t3UFD9E8YOYPOr9lTxa9RKtjggjD8WAJsLlc6hGnTxcgrfRpBacyOfauKv
         QVi0HYib4OGRD3B0Ly9U7jf9caGJK13wKRpHdZ6w42z8hKKAwIgD0At55qSV8sicH4eD
         lUrshmxrWuzD0bG9z+Z4HD9PqpPzHoX5Xz/r+4zPEr2t5gjc3S0k8CcmX+odOrdj1fl9
         AH/1SpBuz5ejWLeBFlLZ089Z59O1zT571EHmoeGAkcPh1RhSqRPeYplKhdEmRpkTjM2B
         rCUbST2waYQe711QZOtYix+8RWDopcRULtZ68oLcOTAE3Xn93NzjpG5s5Dcru5xVX6Gy
         RaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wEXYgsYD3Y+R+C2BDRDsqzw6Doabf1POTv38ULLKg1A=;
        b=L6pRLE2BHL+fvRbqQP3GcSJGKuPKhvWBN8lATcPiY72xJ6nUgoqU7VrgkSmrTXnC+S
         4K9pc9bOHfx9pbw+j+X+Zrd1uP/v3e12/3D9i7LknCRhpIBmS7C0ATuZ9fCY2Fx7EYIb
         F+5ROpxs33xDVbkvfPzblvJQROqOXL2XwZl/1Ix86y/kDmuNp4QKU7Jd6BsOghS8AcFx
         0rIvUEbpMlrFFUpTnIvCZTpSCjPMUrQgD23YIcnr4oGDpXBtgTP9oAMaOH4/KAtIZ23I
         BX+ToeCiOURqVXGd7cJL4l0WwPMN14I3rtoIBJh8tMlcXdZridBMf2H8pgezb53P9Ejd
         wSkw==
X-Gm-Message-State: AGi0Pub7gm8Lsod8oKMLputkzwFO7CVNNYwd7zoqxCFiT9JcOma7f89h
        s21tCZa4ys5is6sLpbN7518=
X-Google-Smtp-Source: APiQypLdwpMwK2oNmRBJPz8AbC91z18arWxsZzYne9YasY9NTQNdug32tbRA2IjAcoe9VjZdPpSSBw==
X-Received: by 2002:a17:90b:78e:: with SMTP id l14mr13449042pjz.144.1588848227260;
        Thu, 07 May 2020 03:43:47 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:43:46 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 07/14] i40e, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
Date:   Thu,  7 May 2020 12:42:45 +0200
Message-Id: <20200507104252.544114-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200507104252.544114-1-bjorn.topel@gmail.com>
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Remove MEM_TYPE_ZERO_COPY in favor of the new MEM_TYPE_XSK_BUFF_POOL
APIs. The AF_XDP zero-copy rx_bi ring is now simply a struct xdp_buff
pointer.

Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |  19 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 350 ++------------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |   1 -
 4 files changed, 47 insertions(+), 332 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3e1695bb8262..ea7395b391e5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3266,21 +3266,19 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		ret = i40e_alloc_rx_bi_zc(ring);
 		if (ret)
 			return ret;
-		ring->rx_buf_len = ring->xsk_umem->chunk_size_nohr -
-				   XDP_PACKET_HEADROOM;
+		ring->rx_buf_len = xsk_umem_get_rx_frame_size(ring->xsk_umem);
 		/* For AF_XDP ZC, we disallow packets to span on
 		 * multiple buffers, thus letting us skip that
 		 * handling in the fast-path.
 		 */
 		chain_len = 1;
-		ring->zca.free = i40e_zca_free;
 		ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
-						 MEM_TYPE_ZERO_COPY,
-						 &ring->zca);
+						 MEM_TYPE_XSK_BUFF_POOL,
+						 NULL);
 		if (ret)
 			return ret;
 		dev_info(&vsi->back->pdev->dev,
-			 "Registered XDP mem model MEM_TYPE_ZERO_COPY on Rx ring %d\n",
+			 "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 			 ring->queue_index);
 
 	} else {
@@ -3351,9 +3349,12 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	ring->tail = hw->hw_addr + I40E_QRX_TAIL(pf_q);
 	writel(0, ring->tail);
 
-	ok = ring->xsk_umem ?
-	     i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring)) :
-	     !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
+	if (ring->xsk_umem) {
+		xsk_buff_set_rxq_info(ring->xsk_umem, &ring->xdp_rxq);
+		ok = i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring));
+	} else {
+		ok = !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
+	}
 	if (!ok) {
 		/* Log this in case the user has forgotten to give the kernel
 		 * any buffers, even later in the application.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index d343498e8de5..5c255977fd58 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -301,12 +301,6 @@ struct i40e_rx_buffer {
 	__u16 pagecnt_bias;
 };
 
-struct i40e_rx_buffer_zc {
-	dma_addr_t dma;
-	void *addr;
-	u64 handle;
-};
-
 struct i40e_queue_stats {
 	u64 packets;
 	u64 bytes;
@@ -356,7 +350,7 @@ struct i40e_ring {
 	union {
 		struct i40e_tx_buffer *tx_bi;
 		struct i40e_rx_buffer *rx_bi;
-		struct i40e_rx_buffer_zc *rx_bi_zc;
+		struct xdp_buff **rx_bi_zc;
 	};
 	DECLARE_BITMAP(state, __I40E_RING_STATE_NBITS);
 	u16 queue_index;		/* Queue number of ring */
@@ -418,7 +412,6 @@ struct i40e_ring {
 	struct i40e_channel *ch;
 	struct xdp_rxq_info xdp_rxq;
 	struct xdp_umem *xsk_umem;
-	struct zero_copy_allocator zca; /* ZC allocator anchor */
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ring_uses_build_skb(struct i40e_ring *ring)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 4fce057f1eec..460f5052e1db 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -23,68 +23,11 @@ void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring)
 	       sizeof(*rx_ring->rx_bi_zc) * rx_ring->count);
 }
 
-static struct i40e_rx_buffer_zc *i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
+static struct xdp_buff **i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
 {
 	return &rx_ring->rx_bi_zc[idx];
 }
 
-/**
- * i40e_xsk_umem_dma_map - DMA maps all UMEM memory for the netdev
- * @vsi: Current VSI
- * @umem: UMEM to DMA map
- *
- * Returns 0 on success, <0 on failure
- **/
-static int i40e_xsk_umem_dma_map(struct i40e_vsi *vsi, struct xdp_umem *umem)
-{
-	struct i40e_pf *pf = vsi->back;
-	struct device *dev;
-	unsigned int i, j;
-	dma_addr_t dma;
-
-	dev = &pf->pdev->dev;
-	for (i = 0; i < umem->npgs; i++) {
-		dma = dma_map_page_attrs(dev, umem->pgs[i], 0, PAGE_SIZE,
-					 DMA_BIDIRECTIONAL, I40E_RX_DMA_ATTR);
-		if (dma_mapping_error(dev, dma))
-			goto out_unmap;
-
-		umem->pages[i].dma = dma;
-	}
-
-	return 0;
-
-out_unmap:
-	for (j = 0; j < i; j++) {
-		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
-				     DMA_BIDIRECTIONAL, I40E_RX_DMA_ATTR);
-		umem->pages[i].dma = 0;
-	}
-
-	return -1;
-}
-
-/**
- * i40e_xsk_umem_dma_unmap - DMA unmaps all UMEM memory for the netdev
- * @vsi: Current VSI
- * @umem: UMEM to DMA map
- **/
-static void i40e_xsk_umem_dma_unmap(struct i40e_vsi *vsi, struct xdp_umem *umem)
-{
-	struct i40e_pf *pf = vsi->back;
-	struct device *dev;
-	unsigned int i;
-
-	dev = &pf->pdev->dev;
-
-	for (i = 0; i < umem->npgs; i++) {
-		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
-				     DMA_BIDIRECTIONAL, I40E_RX_DMA_ATTR);
-
-		umem->pages[i].dma = 0;
-	}
-}
-
 /**
  * i40e_xsk_umem_enable - Enable/associate a UMEM to a certain ring/qid
  * @vsi: Current VSI
@@ -97,7 +40,6 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 				u16 qid)
 {
 	struct net_device *netdev = vsi->netdev;
-	struct xdp_umem_fq_reuse *reuseq;
 	bool if_running;
 	int err;
 
@@ -111,13 +53,7 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	reuseq = xsk_reuseq_prepare(vsi->rx_rings[0]->count);
-	if (!reuseq)
-		return -ENOMEM;
-
-	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
-
-	err = i40e_xsk_umem_dma_map(vsi, umem);
+	err = xsk_buff_dma_map(umem, &vsi->back->pdev->dev, I40E_RX_DMA_ATTR);
 	if (err)
 		return err;
 
@@ -170,7 +106,7 @@ static int i40e_xsk_umem_disable(struct i40e_vsi *vsi, u16 qid)
 	}
 
 	clear_bit(qid, vsi->af_xdp_zc_qps);
-	i40e_xsk_umem_dma_unmap(vsi, umem);
+	xsk_buff_dma_unmap(umem, I40E_RX_DMA_ATTR);
 
 	if (if_running) {
 		err = i40e_queue_pair_enable(vsi, qid);
@@ -209,11 +145,9 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
  **/
 static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
-	struct xdp_umem *umem = rx_ring->xsk_umem;
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
-	u64 offset;
 	u32 act;
 
 	rcu_read_lock();
@@ -222,9 +156,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	offset = xdp->data - xdp->data_hard_start;
-
-	xdp->handle = xsk_umem_adjust_offset(umem, xdp->handle, offset);
 
 	switch (act) {
 	case XDP_PASS:
@@ -251,107 +182,26 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	return result;
 }
 
-/**
- * i40e_alloc_buffer_zc - Allocates an i40e_rx_buffer_zc
- * @rx_ring: Rx ring
- * @bi: Rx buffer to populate
- *
- * This function allocates an Rx buffer. The buffer can come from fill
- * queue, or via the recycle queue (next_to_alloc).
- *
- * Returns true for a successful allocation, false otherwise
- **/
-static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
-				 struct i40e_rx_buffer_zc *bi)
-{
-	struct xdp_umem *umem = rx_ring->xsk_umem;
-	void *addr = bi->addr;
-	u64 handle, hr;
-
-	if (addr) {
-		rx_ring->rx_stats.page_reuse_count++;
-		return true;
-	}
-
-	if (!xsk_umem_peek_addr(umem, &handle)) {
-		rx_ring->rx_stats.alloc_page_failed++;
-		return false;
-	}
-
-	hr = umem->headroom + XDP_PACKET_HEADROOM;
-
-	bi->dma = xdp_umem_get_dma(umem, handle);
-	bi->dma += hr;
-
-	bi->addr = xdp_umem_get_data(umem, handle);
-	bi->addr += hr;
-
-	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
-
-	xsk_umem_release_addr(umem);
-	return true;
-}
-
-/**
- * i40e_alloc_buffer_slow_zc - Allocates an i40e_rx_buffer_zc
- * @rx_ring: Rx ring
- * @bi: Rx buffer to populate
- *
- * This function allocates an Rx buffer. The buffer can come from fill
- * queue, or via the reuse queue.
- *
- * Returns true for a successful allocation, false otherwise
- **/
-static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer_zc *bi)
-{
-	struct xdp_umem *umem = rx_ring->xsk_umem;
-	u64 handle, hr;
-
-	if (!xsk_umem_peek_addr_rq(umem, &handle)) {
-		rx_ring->rx_stats.alloc_page_failed++;
-		return false;
-	}
-
-	handle &= rx_ring->xsk_umem->chunk_mask;
-
-	hr = umem->headroom + XDP_PACKET_HEADROOM;
-
-	bi->dma = xdp_umem_get_dma(umem, handle);
-	bi->dma += hr;
-
-	bi->addr = xdp_umem_get_data(umem, handle);
-	bi->addr += hr;
-
-	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
-
-	xsk_umem_release_addr_rq(umem);
-	return true;
-}
-
-static __always_inline bool
-__i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
-			   bool alloc(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer_zc *bi))
+bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 {
 	u16 ntu = rx_ring->next_to_use;
 	union i40e_rx_desc *rx_desc;
-	struct i40e_rx_buffer_zc *bi;
+	struct xdp_buff **bi, *xdp;
+	dma_addr_t dma;
 	bool ok = true;
 
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
 	bi = i40e_rx_bi(rx_ring, ntu);
 	do {
-		if (!alloc(rx_ring, bi)) {
+		xdp = xsk_buff_alloc(rx_ring->xsk_umem);
+		if (!xdp) {
 			ok = false;
 			goto no_buffers;
 		}
-
-		dma_sync_single_range_for_device(rx_ring->dev, bi->dma, 0,
-						 rx_ring->rx_buf_len,
-						 DMA_BIDIRECTIONAL);
-
-		rx_desc->read.pkt_addr = cpu_to_le64(bi->dma);
+		*bi = xdp;
+		dma = xsk_buff_xdp_get_dma(xdp);
+		rx_desc->read.pkt_addr = cpu_to_le64(dma);
+		rx_desc->read.hdr_addr = 0;
 
 		rx_desc++;
 		bi++;
@@ -363,7 +213,6 @@ __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 			ntu = 0;
 		}
 
-		rx_desc->wb.qword1.status_error_len = 0;
 		count--;
 	} while (count);
 
@@ -374,126 +223,6 @@ __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 	return ok;
 }
 
-/**
- * i40e_alloc_rx_buffers_zc - Allocates a number of Rx buffers
- * @rx_ring: Rx ring
- * @count: The number of buffers to allocate
- *
- * This function allocates a number of Rx buffers from the reuse queue
- * or fill ring and places them on the Rx ring.
- *
- * Returns true for a successful allocation, false otherwise
- **/
-bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
-{
-	return __i40e_alloc_rx_buffers_zc(rx_ring, count,
-					  i40e_alloc_buffer_slow_zc);
-}
-
-/**
- * i40e_alloc_rx_buffers_fast_zc - Allocates a number of Rx buffers
- * @rx_ring: Rx ring
- * @count: The number of buffers to allocate
- *
- * This function allocates a number of Rx buffers from the fill ring
- * or the internal recycle mechanism and places them on the Rx ring.
- *
- * Returns true for a successful allocation, false otherwise
- **/
-static bool i40e_alloc_rx_buffers_fast_zc(struct i40e_ring *rx_ring, u16 count)
-{
-	return __i40e_alloc_rx_buffers_zc(rx_ring, count,
-					  i40e_alloc_buffer_zc);
-}
-
-/**
- * i40e_get_rx_buffer_zc - Return the current Rx buffer
- * @rx_ring: Rx ring
- * @size: The size of the rx buffer (read from descriptor)
- *
- * This function returns the current, received Rx buffer, and also
- * does DMA synchronization.  the Rx ring.
- *
- * Returns the received Rx buffer
- **/
-static struct i40e_rx_buffer_zc *i40e_get_rx_buffer_zc(
-	struct i40e_ring *rx_ring,
-	const unsigned int size)
-{
-	struct i40e_rx_buffer_zc *bi;
-
-	bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
-
-	/* we are reusing so sync this buffer for CPU use */
-	dma_sync_single_range_for_cpu(rx_ring->dev,
-				      bi->dma, 0,
-				      size,
-				      DMA_BIDIRECTIONAL);
-
-	return bi;
-}
-
-/**
- * i40e_reuse_rx_buffer_zc - Recycle an Rx buffer
- * @rx_ring: Rx ring
- * @old_bi: The Rx buffer to recycle
- *
- * This function recycles a finished Rx buffer, and places it on the
- * recycle queue (next_to_alloc).
- **/
-static void i40e_reuse_rx_buffer_zc(struct i40e_ring *rx_ring,
-				    struct i40e_rx_buffer_zc *old_bi)
-{
-	struct i40e_rx_buffer_zc *new_bi = i40e_rx_bi(rx_ring,
-						      rx_ring->next_to_alloc);
-	u16 nta = rx_ring->next_to_alloc;
-
-	/* update, and store next to alloc */
-	nta++;
-	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
-
-	/* transfer page from old buffer to new buffer */
-	new_bi->dma = old_bi->dma;
-	new_bi->addr = old_bi->addr;
-	new_bi->handle = old_bi->handle;
-
-	old_bi->addr = NULL;
-}
-
-/**
- * i40e_zca_free - Free callback for MEM_TYPE_ZERO_COPY allocations
- * @alloc: Zero-copy allocator
- * @handle: Buffer handle
- **/
-void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
-{
-	struct i40e_rx_buffer_zc *bi;
-	struct i40e_ring *rx_ring;
-	u64 hr, mask;
-	u16 nta;
-
-	rx_ring = container_of(alloc, struct i40e_ring, zca);
-	hr = rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
-	mask = rx_ring->xsk_umem->chunk_mask;
-
-	nta = rx_ring->next_to_alloc;
-	bi = i40e_rx_bi(rx_ring, nta);
-
-	nta++;
-	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
-
-	handle &= mask;
-
-	bi->dma = xdp_umem_get_dma(rx_ring->xsk_umem, handle);
-	bi->dma += hr;
-
-	bi->addr = xdp_umem_get_data(rx_ring->xsk_umem, handle);
-	bi->addr += hr;
-
-	bi->handle = xsk_umem_adjust_offset(rx_ring->xsk_umem, (u64)handle,
-					    rx_ring->xsk_umem->headroom);
-}
-
 /**
  * i40e_construct_skb_zc - Create skbufff from zero-copy Rx buffer
  * @rx_ring: Rx ring
@@ -505,7 +234,6 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
  * Returns the skb, or NULL on failure.
  **/
 static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
-					     struct i40e_rx_buffer_zc *bi,
 					     struct xdp_buff *xdp)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
@@ -524,7 +252,7 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	i40e_reuse_rx_buffer_zc(rx_ring, bi);
+	xsk_buff_free(xdp);
 	return skb;
 }
 
@@ -542,20 +270,17 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	unsigned int xdp_res, xdp_xmit = 0;
 	bool failure = false;
 	struct sk_buff *skb;
-	struct xdp_buff xdp;
-
-	xdp.rxq = &rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
-		struct i40e_rx_buffer_zc *bi;
 		union i40e_rx_desc *rx_desc;
+		struct xdp_buff **bi;
 		unsigned int size;
 		u64 qword;
 
 		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
 			failure = failure ||
-				  !i40e_alloc_rx_buffers_fast_zc(rx_ring,
-								 cleaned_count);
+				  !i40e_alloc_rx_buffers_zc(rx_ring,
+							    cleaned_count);
 			cleaned_count = 0;
 		}
 
@@ -573,9 +298,10 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 						      rx_desc->raw.qword[0],
 						      qword);
 			bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
-			i40e_inc_ntc(rx_ring);
-			i40e_reuse_rx_buffer_zc(rx_ring, bi);
+			xsk_buff_free(*bi);
+			*bi = NULL;
 			cleaned_count++;
+			i40e_inc_ntc(rx_ring);
 			continue;
 		}
 
@@ -585,22 +311,18 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		bi = i40e_get_rx_buffer_zc(rx_ring, size);
-		xdp.data = bi->addr;
-		xdp.data_meta = xdp.data;
-		xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
-		xdp.data_end = xdp.data + size;
-		xdp.handle = bi->handle;
+		bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+		(*bi)->data_end = (*bi)->data + size;
+		xsk_buff_dma_sync_for_cpu(*bi);
 
-		xdp_res = i40e_run_xdp_zc(rx_ring, &xdp);
+		xdp_res = i40e_run_xdp_zc(rx_ring, *bi);
 		if (xdp_res) {
-			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
+			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR))
 				xdp_xmit |= xdp_res;
-				bi->addr = NULL;
-			} else {
-				i40e_reuse_rx_buffer_zc(rx_ring, bi);
-			}
+			else
+				xsk_buff_free(*bi);
 
+			*bi = NULL;
 			total_rx_bytes += size;
 			total_rx_packets++;
 
@@ -616,7 +338,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		 * BIT(I40E_RXD_QW1_ERROR_SHIFT). This is due to that
 		 * SBP is *not* set in PRT_SBPVSI (default not set).
 		 */
-		skb = i40e_construct_skb_zc(rx_ring, bi, &xdp);
+		skb = i40e_construct_skb_zc(rx_ring, *bi);
+		*bi = NULL;
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			break;
@@ -674,10 +397,9 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
 			break;
 
-		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
-
-		dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
-					   DMA_BIDIRECTIONAL);
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_umem, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_umem, dma,
+						 desc.len);
 
 		tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
 		tx_bi->bytecount = desc.len;
@@ -836,13 +558,13 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 	u16 i;
 
 	for (i = 0; i < rx_ring->count; i++) {
-		struct i40e_rx_buffer_zc *rx_bi = i40e_rx_bi(rx_ring, i);
+		struct xdp_buff *rx_bi = *i40e_rx_bi(rx_ring, i);
 
-		if (!rx_bi->addr)
+		if (!rx_bi)
 			continue;
 
-		xsk_umem_fq_reuse(rx_ring->xsk_umem, rx_bi->handle);
-		rx_bi->addr = NULL;
+		xsk_buff_free(rx_bi);
+		rx_bi = NULL;
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index f5e292c218ee..ea919a7d60ec 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -12,7 +12,6 @@ int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair);
 int i40e_queue_pair_enable(struct i40e_vsi *vsi, int queue_pair);
 int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
 			u16 qid);
-void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle);
 bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 
-- 
2.25.1

