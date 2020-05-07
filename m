Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0F1C8724
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEGKoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGKoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:44:02 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BD0C061A10;
        Thu,  7 May 2020 03:44:02 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so2826426pfn.5;
        Thu, 07 May 2020 03:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mxSp1o2+GxhrhH52L5kKSB35AzNAghezjyX+vj4Xi+Q=;
        b=rTN5Uzew3XthS+5i+DFd3anhuwj5nBdR8F2KKLfZYa0085OWWXgIDPwTx42XD8tyBU
         Sd0irNj/kwHqIvXoLRN4ph6/fdTeAbWR3ZfX3mtN0RPJ0H2gXf6l1ohH3SLtgriVEyeM
         YItBvNVCAPiH/lGtEIU3aBpLbDqRkqdeO6oPH+yzSCIMgKCzuwV9c0oo1CJx1WOSHkwz
         CQR9B757vvu5t4u8hYDBVSKo1WD3Bzis+5J0HU3xchJE0p2sjPd8QH0krbxeC/mm2RiI
         0zmP3wEHgGbIWdFg+90C6jN7gLGtFBXnmj0PXbvO6NqpqszjEOIbachceJpLG4QXYVuz
         DIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mxSp1o2+GxhrhH52L5kKSB35AzNAghezjyX+vj4Xi+Q=;
        b=mLjMv6WKYGLHaz40qZAxRTIeViUnxip4HAtIm1tEanCvpYhq88BRsH+lICpsLTgJC0
         bjBook7i2urIFox3zxv+2zQmYU9J+iGqa8ugXTQukbnR/j5s4Zp0GiIXcDxy9NAZgV8b
         F2XwuMwmA2HpNNUiIwUjfop7KPsK2e8tkvwwHD4zbG6OGi9iWMZ5rq+cWUi4eIFE79cU
         MIHWvWg2O2HaHrNu7dThhd8Q7hUgU1ObXRB1NVJYhKTER7Ue2hbpz1SBduO9WrGhlwMk
         //nVqAOyoUdnpqXsgWI60tADQSfXroUBQpEwWqpxtP7kLG4fZ+JiHMvrSkK66VyEW/Mu
         2AmA==
X-Gm-Message-State: AGi0PuZQKW6aLnb4sjOf2hsz+MdmeqM8X4OONSN5OinG3zGpjPIF8TtR
        9HCDxZCZ25lkxZ23yHQfPsOGDtp4eKJYFg==
X-Google-Smtp-Source: APiQypItm9I//7fMaU+gLC9d0NZlkUk9vZF5Lw3mOrQoYX4Jz6bjj5eDJ+iD4SUTHD7mNBj6kT6Wjg==
X-Received: by 2002:a62:17c3:: with SMTP id 186mr13244778pfx.159.1588848241725;
        Thu, 07 May 2020 03:44:01 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:44:01 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
Date:   Thu,  7 May 2020 12:42:48 +0200
Message-Id: <20200507104252.544114-11-bjorn.topel@gmail.com>
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

Use the new MEM_TYPE_XSK_BUFF_POOL API in lieu of MEM_TYPE_ZERO_COPY in
mlx5e. It allows to drop a lot of code from the driver (which is now
common in AF_XDP core and was related to XSK RX frame allocation, DMA
mapping, etc.) and slightly improve performance.

rfc->v1: Put back the sanity check for XSK params, use XSK API to get
         the total headroom size. (Maxim)

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  30 ++---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 111 +++---------------
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   6 -
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  49 +-------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  15 +--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  43 +++++--
 10 files changed, 84 insertions(+), 202 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0864b76ca2c0..368563ff8efb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -426,13 +426,12 @@ struct mlx5e_txqsq {
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_dma_info {
-	dma_addr_t addr;
 	union {
-		struct page *page;
 		struct {
-			u64 handle;
-			void *data;
-		} xsk;
+			dma_addr_t addr;
+			struct page *page;
+		};
+		struct xdp_buff *xsk;
 	};
 };
 
@@ -650,7 +649,6 @@ struct mlx5e_rq {
 		} mpwqe;
 	};
 	struct {
-		u16            umem_headroom;
 		u16            headroom;
 		u8             map_dir;   /* dma map direction */
 	} buff;
@@ -682,7 +680,6 @@ struct mlx5e_rq {
 	struct page_pool      *page_pool;
 
 	/* AF_XDP zero-copy */
-	struct zero_copy_allocator zca;
 	struct xdp_umem       *umem;
 
 	struct work_struct     recover_work;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index eb2e1f2138e4..38e4f19d69f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -12,15 +12,16 @@ static inline bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk)
 {
-	u16 headroom = NET_IP_ALIGN;
+	u16 headroom;
 
-	if (mlx5e_rx_is_xdp(params, xsk)) {
+	if (xsk)
+		return xsk->headroom;
+
+	headroom = NET_IP_ALIGN;
+	if (mlx5e_rx_is_xdp(params, xsk))
 		headroom += XDP_PACKET_HEADROOM;
-		if (xsk)
-			headroom += xsk->headroom;
-	} else {
+	else
 		headroom += MLX5_RX_HEADROOM;
-	}
 
 	return headroom;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index b04b99396f65..a2a194525b15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -71,7 +71,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	xdptxd.data = xdpf->data;
 	xdptxd.len  = xdpf->len;
 
-	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY) {
+	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL) {
 		/* The xdp_buff was in the UMEM and was copied into a newly
 		 * allocated page. The UMEM page was returned via the ZCA, and
 		 * this new page has to be mapped at this point and has to be
@@ -119,49 +119,33 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
-		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
+		      u32 *len, struct xdp_buff *xdp)
 {
 	struct bpf_prog *prog = READ_ONCE(rq->xdp_prog);
-	struct xdp_umem *umem = rq->umem;
-	struct xdp_buff xdp;
 	u32 act;
 	int err;
 
 	if (!prog)
 		return false;
 
-	xdp.data = va + *rx_headroom;
-	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + *len;
-	xdp.data_hard_start = va;
-	if (xsk)
-		xdp.handle = di->xsk.handle;
-	xdp.rxq = &rq->xdp_rxq;
-
-	act = bpf_prog_run_xdp(prog, &xdp);
-	if (xsk) {
-		u64 off = xdp.data - xdp.data_hard_start;
-
-		xdp.handle = xsk_umem_adjust_offset(umem, xdp.handle, off);
-	}
+	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		*rx_headroom = xdp.data - xdp.data_hard_start;
-		*len = xdp.data_end - xdp.data;
+		*len = xdp->data_end - xdp->data;
 		return false;
 	case XDP_TX:
-		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, di, &xdp)))
+		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, di, xdp)))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
 		return true;
 	case XDP_REDIRECT:
 		/* When XDP enabled then page-refcnt==1 here */
-		err = xdp_do_redirect(rq->netdev, &xdp, prog);
+		err = xdp_do_redirect(rq->netdev, xdp, prog);
 		if (unlikely(err))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
-		if (!xsk)
+		if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
 			mlx5e_page_dma_unmap(rq, di);
 		rq->stats->xdp_redirect++;
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index ed6f045febeb..54bad625267f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -63,7 +63,7 @@
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
-		      void *va, u16 *rx_headroom, u32 *len, bool xsk);
+		      u32 *len, struct xdp_buff *xdp);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
 void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 62fc8a128a8d..59c40983d428 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -3,71 +3,10 @@
 
 #include "rx.h"
 #include "en/xdp.h"
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 
 /* RX data path */
 
-bool mlx5e_xsk_pages_enough_umem(struct mlx5e_rq *rq, int count)
-{
-	/* Check in advance that we have enough frames, instead of allocating
-	 * one-by-one, failing and moving frames to the Reuse Ring.
-	 */
-	return xsk_umem_has_addrs_rq(rq->umem, count);
-}
-
-int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
-			      struct mlx5e_dma_info *dma_info)
-{
-	struct xdp_umem *umem = rq->umem;
-	u64 handle;
-
-	if (!xsk_umem_peek_addr_rq(umem, &handle))
-		return -ENOMEM;
-
-	dma_info->xsk.handle = xsk_umem_adjust_offset(umem, handle,
-						      rq->buff.umem_headroom);
-	dma_info->xsk.data = xdp_umem_get_data(umem, dma_info->xsk.handle);
-
-	/* No need to add headroom to the DMA address. In striding RQ case, we
-	 * just provide pages for UMR, and headroom is counted at the setup
-	 * stage when creating a WQE. In non-striding RQ case, headroom is
-	 * accounted in mlx5e_alloc_rx_wqe.
-	 */
-	dma_info->addr = xdp_umem_get_dma(umem, handle);
-
-	xsk_umem_release_addr_rq(umem);
-
-	dma_sync_single_for_device(rq->pdev, dma_info->addr, PAGE_SIZE,
-				   DMA_BIDIRECTIONAL);
-
-	return 0;
-}
-
-static inline void mlx5e_xsk_recycle_frame(struct mlx5e_rq *rq, u64 handle)
-{
-	xsk_umem_fq_reuse(rq->umem, handle & rq->umem->chunk_mask);
-}
-
-/* XSKRQ uses pages from UMEM, they must not be released. They are returned to
- * the userspace if possible, and if not, this function is called to reuse them
- * in the driver.
- */
-void mlx5e_xsk_page_release(struct mlx5e_rq *rq,
-			    struct mlx5e_dma_info *dma_info)
-{
-	mlx5e_xsk_recycle_frame(rq, dma_info->xsk.handle);
-}
-
-/* Return a frame back to the hardware to fill in again. It is used by XDP when
- * the XDP program returns XDP_TX or XDP_REDIRECT not to an XSKMAP.
- */
-void mlx5e_xsk_zca_free(struct zero_copy_allocator *zca, unsigned long handle)
-{
-	struct mlx5e_rq *rq = container_of(zca, struct mlx5e_rq, zca);
-
-	mlx5e_xsk_recycle_frame(rq, handle);
-}
-
 static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, void *data,
 					       u32 cqe_bcnt)
 {
@@ -90,11 +29,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    u32 head_offset,
 						    u32 page_idx)
 {
-	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
-	u16 rx_headroom = rq->buff.headroom - rq->buff.umem_headroom;
+	struct xdp_buff *xdp = wi->umr.dma_info[page_idx].xsk;
 	u32 cqe_bcnt32 = cqe_bcnt;
-	void *va, *data;
-	u32 frag_size;
 	bool consumed;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
@@ -103,22 +39,19 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 		return NULL;
 	}
 
-	/* head_offset is not used in this function, because di->xsk.data and
-	 * di->addr point directly to the necessary place. Furthermore, in the
-	 * current implementation, UMR pages are mapped to XSK frames, so
+	/* head_offset is not used in this function, because xdp->data and the
+	 * DMA address point directly to the necessary place. Furthermore, in
+	 * the current implementation, UMR pages are mapped to XSK frames, so
 	 * head_offset should always be 0.
 	 */
 	WARN_ON_ONCE(head_offset);
 
-	va             = di->xsk.data;
-	data           = va + rx_headroom;
-	frag_size      = rq->buff.headroom + cqe_bcnt32;
-
-	dma_sync_single_for_cpu(rq->pdev, di->addr, frag_size, DMA_BIDIRECTIONAL);
-	prefetch(data);
+	xdp->data_end = xdp->data + cqe_bcnt32;
+	xsk_buff_dma_sync_for_cpu(xdp);
+	prefetch(xdp->data);
 
 	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt32, true);
+	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp);
 	rcu_read_unlock();
 
 	/* Possible flows:
@@ -145,7 +78,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	/* XDP_PASS: copy the data from the UMEM to a new SKB and reuse the
 	 * frame. On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, data, cqe_bcnt32);
+	return mlx5e_xsk_construct_skb(rq, xdp->data, cqe_bcnt32);
 }
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
@@ -153,25 +86,19 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt)
 {
-	struct mlx5e_dma_info *di = wi->di;
-	u16 rx_headroom = rq->buff.headroom - rq->buff.umem_headroom;
-	void *va, *data;
+	struct xdp_buff *xdp = wi->di->xsk;
 	bool consumed;
-	u32 frag_size;
 
-	/* wi->offset is not used in this function, because di->xsk.data and
-	 * di->addr point directly to the necessary place. Furthermore, in the
-	 * current implementation, one page = one packet = one frame, so
+	/* wi->offset is not used in this function, because xdp->data and the
+	 * DMA address point directly to the necessary place. Furthermore, the
+	 * XSK allocator allocates frames per packet, instead of pages, so
 	 * wi->offset should always be 0.
 	 */
 	WARN_ON_ONCE(wi->offset);
 
-	va             = di->xsk.data;
-	data           = va + rx_headroom;
-	frag_size      = rq->buff.headroom + cqe_bcnt;
-
-	dma_sync_single_for_cpu(rq->pdev, di->addr, frag_size, DMA_BIDIRECTIONAL);
-	prefetch(data);
+	xdp->data_end = xdp->data + cqe_bcnt;
+	xsk_buff_dma_sync_for_cpu(xdp);
+	prefetch(xdp->data);
 
 	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
 		rq->stats->wqe_err++;
@@ -179,7 +106,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	}
 
 	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt, true);
+	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt, xdp);
 	rcu_read_unlock();
 
 	if (likely(consumed))
@@ -189,5 +116,5 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	 * will be handled by mlx5e_put_rx_frag.
 	 * On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, data, cqe_bcnt);
+	return mlx5e_xsk_construct_skb(rq, xdp->data, cqe_bcnt);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index a8e11adbf426..0062652f37b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -9,12 +9,6 @@
 
 /* RX data path */
 
-bool mlx5e_xsk_pages_enough_umem(struct mlx5e_rq *rq, int count);
-int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
-			      struct mlx5e_dma_info *dma_info);
-void mlx5e_xsk_page_release(struct mlx5e_rq *rq,
-			    struct mlx5e_dma_info *dma_info);
-void mlx5e_xsk_zca_free(struct zero_copy_allocator *zca, unsigned long handle);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
 						    u16 cqe_bcnt,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 3bcdb5b2fc20..470f3b6317c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -5,7 +5,7 @@
 #include "umem.h"
 #include "en/xdp.h"
 #include "en/params.h"
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 
 int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
@@ -92,8 +92,8 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		xdptxd.dma_addr = xdp_umem_get_dma(umem, desc.addr);
-		xdptxd.data = xdp_umem_get_data(umem, desc.addr);
+		xdptxd.dma_addr = xsk_buff_raw_get_dma(umem, desc.addr);
+		xdptxd.data = xsk_buff_raw_get_data(umem, desc.addr);
 		xdptxd.len = desc.len;
 
 		dma_sync_single_for_device(sq->pdev, xdptxd.dma_addr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 5e49fdb564b3..7b17fcd0a56d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -10,40 +10,14 @@ static int mlx5e_xsk_map_umem(struct mlx5e_priv *priv,
 			      struct xdp_umem *umem)
 {
 	struct device *dev = priv->mdev->device;
-	u32 i;
 
-	for (i = 0; i < umem->npgs; i++) {
-		dma_addr_t dma = dma_map_page(dev, umem->pgs[i], 0, PAGE_SIZE,
-					      DMA_BIDIRECTIONAL);
-
-		if (unlikely(dma_mapping_error(dev, dma)))
-			goto err_unmap;
-		umem->pages[i].dma = dma;
-	}
-
-	return 0;
-
-err_unmap:
-	while (i--) {
-		dma_unmap_page(dev, umem->pages[i].dma, PAGE_SIZE,
-			       DMA_BIDIRECTIONAL);
-		umem->pages[i].dma = 0;
-	}
-
-	return -ENOMEM;
+	return xsk_buff_dma_map(umem, dev, 0);
 }
 
 static void mlx5e_xsk_unmap_umem(struct mlx5e_priv *priv,
 				 struct xdp_umem *umem)
 {
-	struct device *dev = priv->mdev->device;
-	u32 i;
-
-	for (i = 0; i < umem->npgs; i++) {
-		dma_unmap_page(dev, umem->pages[i].dma, PAGE_SIZE,
-			       DMA_BIDIRECTIONAL);
-		umem->pages[i].dma = 0;
-	}
+	return xsk_buff_dma_unmap(umem, 0);
 }
 
 static int mlx5e_xsk_get_umems(struct mlx5e_xsk *xsk)
@@ -90,13 +64,14 @@ static void mlx5e_xsk_remove_umem(struct mlx5e_xsk *xsk, u16 ix)
 
 static bool mlx5e_xsk_is_umem_sane(struct xdp_umem *umem)
 {
-	return umem->headroom <= 0xffff && umem->chunk_size_nohr <= 0xffff;
+	return xsk_umem_get_headroom(umem) <= 0xffff &&
+		xsk_umem_get_chunk_size(umem) <= 0xffff;
 }
 
 void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk)
 {
-	xsk->headroom = umem->headroom;
-	xsk->chunk_size = umem->chunk_size_nohr + umem->headroom;
+	xsk->headroom = xsk_umem_get_headroom(umem);
+	xsk->chunk_size = xsk_umem_get_chunk_size(umem);
 }
 
 static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
@@ -241,18 +216,6 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 		      mlx5e_xsk_disable_umem(priv, ix);
 }
 
-int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries)
-{
-	struct xdp_umem_fq_reuse *reuseq;
-
-	reuseq = xsk_reuseq_prepare(nentries);
-	if (unlikely(!reuseq))
-		return -ENOMEM;
-	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
-
-	return 0;
-}
-
 u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk)
 {
 	u16 res = xsk->refcnt ? params->num_channels : 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 048a4f8601a8..5ce73931eff4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -38,7 +38,7 @@
 #include <linux/bpf.h>
 #include <linux/if_bridge.h>
 #include <net/page_pool.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include "eswitch.h"
 #include "en.h"
 #include "en/txrx.h"
@@ -414,7 +414,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 	rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
-	rq->buff.umem_headroom = xsk ? xsk->headroom : 0;
 	pool_size = 1 << params->log_rq_mtu_frames;
 
 	switch (rq->wq_type) {
@@ -522,17 +521,9 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 
 	if (xsk) {
-		err = mlx5e_xsk_resize_reuseq(umem, num_xsk_frames);
-		if (unlikely(err)) {
-			mlx5_core_err(mdev, "Unable to allocate the Reuse Ring for %u frames\n",
-				      num_xsk_frames);
-			goto err_free;
-		}
-
-		rq->zca.free = mlx5e_xsk_zca_free;
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
-						 MEM_TYPE_ZERO_COPY,
-						 &rq->zca);
+						 MEM_TYPE_XSK_BUFF_POOL, NULL);
+		xsk_buff_set_rxq_info(rq->umem, &rq->xdp_rxq);
 	} else {
 		/* Create a page_pool and register it with rxq */
 		pp_params.order     = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d9a5a669b84d..662bc73f6dae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -263,10 +263,12 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 				   struct mlx5e_dma_info *dma_info)
 {
-	if (rq->umem)
-		return mlx5e_xsk_page_alloc_umem(rq, dma_info);
-	else
-		return mlx5e_page_alloc_pool(rq, dma_info);
+	if (rq->umem) {
+		dma_info->xsk = xsk_buff_alloc(rq->umem);
+		return dma_info->xsk ? 0 : -ENOMEM;
+	}
+
+	return mlx5e_page_alloc_pool(rq, dma_info);
 }
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
@@ -300,7 +302,7 @@ static inline void mlx5e_page_release(struct mlx5e_rq *rq,
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
 		 */
-		mlx5e_xsk_page_release(rq, dma_info);
+		xsk_buff_free(dma_info->xsk);
 	else
 		mlx5e_page_release_dynamic(rq, dma_info, recycle);
 }
@@ -385,7 +387,11 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 	if (rq->umem) {
 		int pages_desired = wqe_bulk << rq->wqe.info.log_num_frags;
 
-		if (unlikely(!mlx5e_xsk_pages_enough_umem(rq, pages_desired)))
+		/* Check in advance that we have enough frames, instead of
+		 * allocating one-by-one, failing and moving frames to the
+		 * Reuse Ring.
+		 */
+		if (unlikely(!xsk_buff_can_alloc(rq->umem, pages_desired)))
 			return -ENOMEM;
 	}
 
@@ -480,8 +486,11 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	int err;
 	int i;
 
+	/* Check in advance that we have enough frames, instead of allocating
+	 * one-by-one, failing and moving frames to the Reuse Ring.
+	 */
 	if (rq->umem &&
-	    unlikely(!mlx5e_xsk_pages_enough_umem(rq, MLX5_MPWRQ_PAGES_PER_WQE))) {
+	    unlikely(!xsk_buff_can_alloc(rq->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
 		err = -ENOMEM;
 		goto err;
 	}
@@ -1038,12 +1047,23 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 	return skb;
 }
 
+static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
+				u32 len, struct xdp_buff *xdp)
+{
+	xdp->data_hard_start = va;
+	xdp_set_data_meta_invalid(xdp);
+	xdp->data = va + headroom;
+	xdp->data_end = xdp->data + len;
+	xdp->rxq = &rq->xdp_rxq;
+}
+
 struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			  struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
 	struct mlx5e_dma_info *di = wi->di;
 	u16 rx_headroom = rq->buff.headroom;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	void *va, *data;
 	bool consumed;
@@ -1059,11 +1079,13 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	prefetch(data);
 
 	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt, false);
+	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
+	consumed = mlx5e_xdp_handle(rq, di, &cqe_bcnt, &xdp);
 	rcu_read_unlock();
 	if (consumed)
 		return NULL; /* page/packet was consumed by XDP */
 
+	rx_headroom = xdp.data - xdp.data_hard_start;
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt);
 	if (unlikely(!skb))
 		return NULL;
@@ -1336,6 +1358,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
 	u32 cqe_bcnt32 = cqe_bcnt;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
@@ -1357,7 +1380,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	prefetch(data);
 
 	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt32, false);
+	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
+	consumed = mlx5e_xdp_handle(rq, di, &cqe_bcnt32, &xdp);
 	rcu_read_unlock();
 	if (consumed) {
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
@@ -1365,6 +1389,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL; /* page/packet was consumed by XDP */
 	}
 
+	rx_headroom = xdp.data - xdp.data_hard_start;
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
 	if (unlikely(!skb))
 		return NULL;
-- 
2.25.1

