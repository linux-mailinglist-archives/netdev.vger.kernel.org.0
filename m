Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8C6CCBA9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjC1U5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjC1U4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31EA1FEC
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CE1161961
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3C8C433EF;
        Tue, 28 Mar 2023 20:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037007;
        bh=5Bu/Yuh3agNi01wFGMv/W6+O95AGH3zwpV/OkAiRgWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4ANOeVeumRZVGo2Tcj6Tl5iFPXnehKBh8cMoFm3NUHu23e1HQwUFeE2CwA55SED4
         xzRPjxNgfr8DkOxYR5QjFcKBOPoBvgzCYGGuFsAcNPwXP8OKYNJjsSq7dWoM9ytkA5
         wxhRckQB2rnyNzpHbLf0RjP7WZzSpNj7l9/WbEH9CQwEmrrcMKMjbgFvDG/itvojgN
         u/68s8K3OLuSJC3UXsmUw5wa3loqxCYZGvkMGcUhHYV9wUbmU/DpDd+y5v3qB8OMHU
         n8PFXZpbgtTTZjh4TNO0Ppf+5dLzfAfPQHa9zRBH9EMxr32iCfrjwF/QoKPiHErvVk
         2m7iIxYUPTl7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: RX, Remove alloc unit layout constraint for striding rq
Date:   Tue, 28 Mar 2023 13:56:11 -0700
Message-Id: <20230328205623.142075-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

This change removes the usage of mlx5e_alloc_unit union for
striding rq. The change is more straightforward than legacy rq as
the alloc units union is already in place.

This patch only moves things around: instead of an array of unions make
it a union of arrays. This has the effect that each mlx5e_mpw_info will
allocate the largest possible size of the array member. For xsk this
means that the array of xdp_buff pointers for the wqe will still be
contiguous, but there will be some extra unused bytes at the end of the
array.

As further patch in the series will add the mlx5e_frag_page struct for
which the described size constraint will no longer hold.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  7 +--
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 29 ++++-----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 61 ++++++++++---------
 5 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 32036f23d962..ad4ad14853bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -475,11 +475,6 @@ struct mlx5e_txqsq {
 	cqe_ts_to_ns               ptp_cyc2time;
 } ____cacheline_aligned_in_smp;
 
-union mlx5e_alloc_unit {
-	struct page *page;
-	struct xdp_buff *xsk;
-};
-
 /* XDP packets can be transmitted in different ways. On completion, we need to
  * distinguish between them to clean up things in a proper way.
  */
@@ -622,7 +617,7 @@ union mlx5e_alloc_units {
 struct mlx5e_mpw_info {
 	u16 consumed_strides;
 	DECLARE_BITMAP(xdp_xmit_bitmap, MLX5_MPWRQ_MAX_PAGES_PER_WQE);
-	union mlx5e_alloc_unit alloc_units[];
+	union mlx5e_alloc_units alloc_units;
 };
 
 #define MLX5E_MAX_RX_FRAGS 4
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 816ea83e6413..dab00a2c2eb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -489,7 +489,7 @@ static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size
 
 static inline struct mlx5e_mpw_info *mlx5e_get_mpw_info(struct mlx5e_rq *rq, int i)
 {
-	size_t isz = struct_size(rq->mpwqe.info, alloc_units, rq->mpwqe.pages_per_wqe);
+	size_t isz = struct_size(rq->mpwqe.info, alloc_units.pages, rq->mpwqe.pages_per_wqe);
 
 	return (struct mlx5e_mpw_info *)((char *)rq->mpwqe.info + array_size(i, isz));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 8a5ae80e6142..b2c1af07c317 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -22,6 +22,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	struct mlx5e_icosq *icosq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &icosq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
+	struct xdp_buff **xsk_buffs;
 	int batch, i;
 	u32 offset; /* 17-bit value with MTT. */
 	u16 pi;
@@ -29,9 +30,9 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe)))
 		goto err;
 
-	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].xsk));
 	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
-	batch = xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->alloc_units,
+	xsk_buffs = (struct xdp_buff **)wi->alloc_units.xsk_buffs;
+	batch = xsk_buff_alloc_batch(rq->xsk_pool, xsk_buffs,
 				     rq->mpwqe.pages_per_wqe);
 
 	/* If batch < pages_per_wqe, either:
@@ -41,8 +42,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	 * the first error, which will mean there are no more valid descriptors.
 	 */
 	for (; batch < rq->mpwqe.pages_per_wqe; batch++) {
-		wi->alloc_units[batch].xsk = xsk_buff_alloc(rq->xsk_pool);
-		if (unlikely(!wi->alloc_units[batch].xsk))
+		xsk_buffs[batch] = xsk_buff_alloc(rq->xsk_pool);
+		if (unlikely(!xsk_buffs[batch]))
 			goto err_reuse_batch;
 	}
 
@@ -52,8 +53,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 
 	if (likely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_ALIGNED)) {
 		for (i = 0; i < batch; i++) {
-			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->alloc_units[i].xsk);
-			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(xsk_buffs[i]);
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(xsk_buffs[i]);
 
 			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
 				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
@@ -62,8 +63,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		}
 	} else if (unlikely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED)) {
 		for (i = 0; i < batch; i++) {
-			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->alloc_units[i].xsk);
-			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(xsk_buffs[i]);
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(xsk_buffs[i]);
 
 			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
 				.key = rq->mkey_be,
@@ -75,8 +76,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		u32 mapping_size = 1 << (rq->mpwqe.page_shift - 2);
 
 		for (i = 0; i < batch; i++) {
-			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->alloc_units[i].xsk);
-			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(xsk_buffs[i]);
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(xsk_buffs[i]);
 
 			umr_wqe->inline_ksms[i << 2] = (struct mlx5_ksm) {
 				.key = rq->mkey_be,
@@ -102,8 +103,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		__be32 frame_size = cpu_to_be32(rq->xsk_pool->chunk_size);
 
 		for (i = 0; i < batch; i++) {
-			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->alloc_units[i].xsk);
-			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(xsk_buffs[i]);
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(xsk_buffs[i]);
 
 			umr_wqe->inline_klms[i << 1] = (struct mlx5_klm) {
 				.key = rq->mkey_be,
@@ -149,7 +150,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 
 err_reuse_batch:
 	while (--batch >= 0)
-		xsk_buff_free(wi->alloc_units[batch].xsk);
+		xsk_buff_free(xsk_buffs[batch]);
 
 err:
 	rq->stats->buff_alloc_err++;
@@ -248,7 +249,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    u32 head_offset,
 						    u32 page_idx)
 {
-	struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->alloc_units[page_idx].xsk);
+	struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->alloc_units.xsk_buffs[page_idx]);
 	struct bpf_prog *prog;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 917b98d1da2d..0ed3f67f7dfc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -286,7 +286,8 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 	int wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
 	size_t alloc_size;
 
-	alloc_size = array_size(wq_sz, struct_size(rq->mpwqe.info, alloc_units,
+	alloc_size = array_size(wq_sz, struct_size(rq->mpwqe.info,
+						   alloc_units.pages,
 						   rq->mpwqe.pages_per_wqe));
 
 	rq->mpwqe.info = kvzalloc_node(alloc_size, GFP_KERNEL, node);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 74e7e00cf494..d02f2f2af4ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -469,16 +469,16 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 
 static inline void
 mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
-		   union mlx5e_alloc_unit *au, u32 frag_offset, u32 len,
+		   struct page *page, u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
-	dma_addr_t addr = page_pool_get_dma_addr(au->page);
+	dma_addr_t addr = page_pool_get_dma_addr(page);
 
 	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len,
 				rq->buff.map_dir);
-	page_ref_inc(au->page);
+	page_ref_inc(page);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-			au->page, frag_offset, len, truesize);
+			page, frag_offset, len, truesize);
 }
 
 static inline void
@@ -498,7 +498,6 @@ mlx5e_copy_skb_header(struct mlx5e_rq *rq, struct sk_buff *skb,
 static void
 mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle)
 {
-	union mlx5e_alloc_unit *alloc_units = wi->alloc_units;
 	bool no_xdp_xmit;
 	int i;
 
@@ -509,17 +508,21 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 	no_xdp_xmit = bitmap_empty(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
 
 	if (rq->xsk_pool) {
+		struct xdp_buff **xsk_buffs = wi->alloc_units.xsk_buffs;
+
 		/* The `recycle` parameter is ignored, and the page is always
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
 		 */
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
 			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-				xsk_buff_free(alloc_units[i].xsk);
+				xsk_buff_free(xsk_buffs[i]);
 	} else {
+		struct page **pages = wi->alloc_units.pages;
+
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
 			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-				mlx5e_page_release_dynamic(rq, alloc_units[i].page, recycle);
+				mlx5e_page_release_dynamic(rq, pages[i], recycle);
 	}
 }
 
@@ -694,7 +697,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
-	union mlx5e_alloc_unit *au = &wi->alloc_units[0];
+	struct page **pagep = &wi->alloc_units.pages[0];
 	struct mlx5e_icosq *sq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
@@ -713,13 +716,13 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
 	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, sizeof(struct mlx5e_umr_wqe));
 
-	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
+	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, pagep++) {
 		dma_addr_t addr;
 
-		err = mlx5e_page_alloc_pool(rq, &au->page);
+		err = mlx5e_page_alloc_pool(rq, pagep);
 		if (unlikely(err))
 			goto err_unmap;
-		addr = page_pool_get_dma_addr(au->page);
+		addr = page_pool_get_dma_addr(*pagep);
 		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
 			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
 		};
@@ -760,8 +763,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 
 err_unmap:
 	while (--i >= 0) {
-		au--;
-		mlx5e_page_release_dynamic(rq, au->page, true);
+		pagep--;
+		mlx5e_page_release_dynamic(rq, *pagep, true);
 	}
 
 err:
@@ -1914,7 +1917,7 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 
 static void
 mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
-		    union mlx5e_alloc_unit *au, u32 data_bcnt, u32 data_offset)
+		    struct page **pagep, u32 data_bcnt, u32 data_offset)
 {
 	net_prefetchw(skb->data);
 
@@ -1928,12 +1931,12 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
 		else
 			truesize = ALIGN(pg_consumed_bytes, BIT(rq->mpwqe.log_stride_sz));
 
-		mlx5e_add_skb_frag(rq, skb, au, data_offset,
+		mlx5e_add_skb_frag(rq, skb, *pagep, data_offset,
 				   pg_consumed_bytes, truesize);
 
 		data_bcnt -= pg_consumed_bytes;
 		data_offset = 0;
-		au++;
+		pagep++;
 	}
 }
 
@@ -1942,11 +1945,11 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 				   struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
 				   u32 page_idx)
 {
-	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
+	struct page **pagep = &wi->alloc_units.pages[page_idx];
 	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
-	union mlx5e_alloc_unit *head_au = au;
+	struct page *head_page = *pagep;
 	struct sk_buff *skb;
 	dma_addr_t addr;
 
@@ -1961,14 +1964,14 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	/* Non-linear mode, hence non-XSK, which always uses PAGE_SIZE. */
 	if (unlikely(frag_offset >= PAGE_SIZE)) {
-		au++;
+		pagep++;
 		frag_offset -= PAGE_SIZE;
 	}
 
-	mlx5e_fill_skb_data(skb, rq, au, byte_cnt, frag_offset);
+	mlx5e_fill_skb_data(skb, rq, pagep, byte_cnt, frag_offset);
 	/* copy header */
-	addr = page_pool_get_dma_addr(head_au->page);
-	mlx5e_copy_skb_header(rq, skb, head_au->page, addr,
+	addr = page_pool_get_dma_addr(head_page);
+	mlx5e_copy_skb_header(rq, skb, head_page, addr,
 			      head_offset, head_offset, headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
@@ -1982,7 +1985,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
 				u32 page_idx)
 {
-	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
+	struct page *page = wi->alloc_units.pages[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
@@ -1997,11 +2000,11 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 	}
 
-	va             = page_address(au->page) + head_offset;
+	va             = page_address(page) + head_offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = page_pool_get_dma_addr(page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, head_offset,
 				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
@@ -2028,7 +2031,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	page_ref_inc(au->page);
+	page_ref_inc(page);
 
 	return skb;
 }
@@ -2146,7 +2149,6 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	bool match		= cqe->shampo.match;
 	struct mlx5e_rq_stats *stats = rq->stats;
 	struct mlx5e_rx_wqe_ll *wqe;
-	union mlx5e_alloc_unit *au;
 	struct mlx5e_mpw_info *wi;
 	struct mlx5_wq_ll *wq;
 
@@ -2196,8 +2198,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (likely(head_size)) {
-		au = &wi->alloc_units[page_idx];
-		mlx5e_fill_skb_data(*skb, rq, au, data_bcnt, data_offset);
+		struct page **pagep = &wi->alloc_units.pages[page_idx];
+
+		mlx5e_fill_skb_data(*skb, rq, pagep, data_bcnt, data_offset);
 	}
 
 	mlx5e_shampo_complete_rx_cqe(rq, cqe, cqe_bcnt, *skb);
-- 
2.39.2

