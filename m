Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BDD6CCBA8
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjC1U4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC1U4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:56:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874402107
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC6E6195F
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542CEC433D2;
        Tue, 28 Mar 2023 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037006;
        bh=ryFkz8bAPLTIUIzOrHbBPU/j5oj85QcdgSeYusWrqDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN4QdaRhtbbZW39eaKF9Ju+NwUFS7H/v9wktHpg2WMbWB4lG48RxAfs30mse0MhoO
         ItHBk+dmXSPcdwTKGPBPLx7muWZN4uUS663CD8DM8Qhv9SWPRt21V1CS6aUyyjhev7
         UxdaejcdC1parq5L6eCsvj+u4OpHl9c/J2dv4rQJX1jXVUZcRvP4BjbWIAGFR2SEGK
         HNusvCge7+xgeNGt1Q4t85LlVHkE3SSzs+XwbyU613NdJMu24JSDK3BN9u79kqKVVv
         MBMoT+Y9AopAIiyGX7SSznSRTAA/+nlG/e6zE90J4MeGmVZuAmCxI+qIWrBRJlKici
         QT7m2plixKMkg==
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
Subject: [net-next 02/15] net/mlx5e: RX, Remove alloc unit layout constraint for legacy rq
Date:   Tue, 28 Mar 2023 13:56:10 -0700
Message-Id: <20230328205623.142075-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

The mlx5e_alloc_unit union is conveniently used to store arrays of
pointers to struct page or struct xdp_buff (for xsk). The union is
currently expected to have the size of a pointer for xsk batch
allocations to work. This is conveniet for the current state of the
code but makes it impossible to add a structure of a different size
to the alloc unit.

A further patch in the series will add the mlx5e_frag_page struct for
which the described size constraint will no longer hold.

This change removes the usage of mlx5e_alloc_unit union for legacy rq:

- A union of arrays is introduced (mlx5e_alloc_units) to replace the
  array of unions to allow structures of different sizes.

- Each fragment has a pointer to a unit in the mlx5e_alloc_units array.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 12 ++-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 19 ++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 82 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 36 ++++----
 4 files changed, 87 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 02237e630d13..32036f23d962 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -606,11 +606,19 @@ struct mlx5e_icosq {
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_wqe_frag_info {
-	union mlx5e_alloc_unit *au;
+	union {
+		struct page **pagep;
+		struct xdp_buff **xskp;
+	};
 	u32 offset;
 	bool last_in_page;
 };
 
+union mlx5e_alloc_units {
+	DECLARE_FLEX_ARRAY(struct page *, pages);
+	DECLARE_FLEX_ARRAY(struct xdp_buff *, xsk_buffs);
+};
+
 struct mlx5e_mpw_info {
 	u16 consumed_strides;
 	DECLARE_BITMAP(xdp_xmit_bitmap, MLX5_MPWRQ_MAX_PAGES_PER_WQE);
@@ -702,7 +710,7 @@ struct mlx5e_rq {
 		struct {
 			struct mlx5_wq_cyc          wq;
 			struct mlx5e_wqe_frag_info *frags;
-			union mlx5e_alloc_unit     *alloc_units;
+			union mlx5e_alloc_units    *alloc_units;
 			struct mlx5e_rq_frags_info  info;
 			mlx5e_fp_skb_from_cqe       skb_from_cqe;
 		} wqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index fab787600459..8a5ae80e6142 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -163,13 +163,10 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 	u32 contig, alloc;
 	int i;
 
-	/* mlx5e_init_frags_partition creates a 1:1 mapping between
-	 * rq->wqe.frags and rq->wqe.alloc_units, which allows us to
-	 * allocate XDP buffers straight into alloc_units.
+	/* Each rq->wqe.frags->xskp is 1:1 mapped to an element inside the
+	 * rq->wqe.alloc_units->xsk_buffs array allocated here.
 	 */
-	BUILD_BUG_ON(sizeof(rq->wqe.alloc_units[0]) !=
-		     sizeof(rq->wqe.alloc_units[0].xsk));
-	buffs = (struct xdp_buff **)rq->wqe.alloc_units;
+	buffs = rq->wqe.alloc_units->xsk_buffs;
 	contig = mlx5_wq_cyc_get_size(wq) - ix;
 	if (wqe_bulk <= contig) {
 		alloc = xsk_buff_alloc_batch(rq->xsk_pool, buffs + ix, wqe_bulk);
@@ -189,7 +186,7 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 		/* Assumes log_num_frags == 0. */
 		frag = &rq->wqe.frags[j];
 
-		addr = xsk_buff_xdp_get_frame_dma(frag->au->xsk);
+		addr = xsk_buff_xdp_get_frame_dma(*frag->xskp);
 		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
 	}
 
@@ -211,11 +208,11 @@ int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 		/* Assumes log_num_frags == 0. */
 		frag = &rq->wqe.frags[j];
 
-		frag->au->xsk = xsk_buff_alloc(rq->xsk_pool);
-		if (unlikely(!frag->au->xsk))
+		*frag->xskp = xsk_buff_alloc(rq->xsk_pool);
+		if (unlikely(!*frag->xskp))
 			return i;
 
-		addr = xsk_buff_xdp_get_frame_dma(frag->au->xsk);
+		addr = xsk_buff_xdp_get_frame_dma(*frag->xskp);
 		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
 	}
 
@@ -306,7 +303,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5_cqe64 *cqe,
 					      u32 cqe_bcnt)
 {
-	struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(wi->au->xsk);
+	struct mlx5e_xdp_buff *mxbuf = xsk_buff_to_mxbuf(*wi->xskp);
 	struct bpf_prog *prog;
 
 	/* wi->offset is not used in this function, because xdp->data and the
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 90eac1aa5f6b..917b98d1da2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -499,15 +499,9 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 	struct mlx5e_wqe_frag_info *prev = NULL;
 	int i;
 
-	if (rq->xsk_pool) {
-		/* Assumptions used by XSK batched allocator. */
-		WARN_ON(rq->wqe.info.num_frags != 1);
-		WARN_ON(rq->wqe.info.log_num_frags != 0);
-		WARN_ON(rq->wqe.info.arr[0].frag_stride != PAGE_SIZE);
-	}
-
-	next_frag.au = &rq->wqe.alloc_units[0];
+	WARN_ON(rq->xsk_pool);
 
+	next_frag.pagep = &rq->wqe.alloc_units->pages[0];
 	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
 		struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 		struct mlx5e_wqe_frag_info *frag =
@@ -516,7 +510,8 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 
 		for (f = 0; f < rq->wqe.info.num_frags; f++, frag++) {
 			if (next_frag.offset + frag_info[f].frag_stride > PAGE_SIZE) {
-				next_frag.au++;
+				/* Pages are assigned at runtime. */
+				next_frag.pagep++;
 				next_frag.offset = 0;
 				if (prev)
 					prev->last_in_page = true;
@@ -533,22 +528,59 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 		prev->last_in_page = true;
 }
 
-static int mlx5e_init_au_list(struct mlx5e_rq *rq, int wq_sz, int node)
+static void mlx5e_init_xsk_buffs(struct mlx5e_rq *rq)
+{
+	int i;
+
+	/* Assumptions used by XSK batched allocator. */
+	WARN_ON(rq->wqe.info.num_frags != 1);
+	WARN_ON(rq->wqe.info.log_num_frags != 0);
+	WARN_ON(rq->wqe.info.arr[0].frag_stride != PAGE_SIZE);
+
+	/* Considering the above assumptions a fragment maps to a single
+	 * xsk_buff.
+	 */
+	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++)
+		rq->wqe.frags[i].xskp = &rq->wqe.alloc_units->xsk_buffs[i];
+}
+
+static int mlx5e_init_wqe_alloc_info(struct mlx5e_rq *rq, int node)
 {
+	int wq_sz = mlx5_wq_cyc_get_size(&rq->wqe.wq);
 	int len = wq_sz << rq->wqe.info.log_num_frags;
+	struct mlx5e_wqe_frag_info *frags;
+	union mlx5e_alloc_units *aus;
+	int aus_sz;
+
+	if (rq->xsk_pool)
+		aus_sz = sizeof(*aus->xsk_buffs);
+	else
+		aus_sz = sizeof(*aus->pages);
+
+	aus = kvzalloc_node(array_size(len, aus_sz), GFP_KERNEL, node);
+	if (!aus)
+		return -ENOMEM;
 
-	rq->wqe.alloc_units = kvzalloc_node(array_size(len, sizeof(*rq->wqe.alloc_units)),
-					    GFP_KERNEL, node);
-	if (!rq->wqe.alloc_units)
+	frags = kvzalloc_node(array_size(len, sizeof(*frags)), GFP_KERNEL, node);
+	if (!frags) {
+		kvfree(aus);
 		return -ENOMEM;
+	}
+
+	rq->wqe.alloc_units = aus;
+	rq->wqe.frags = frags;
 
-	mlx5e_init_frags_partition(rq);
+	if (rq->xsk_pool)
+		mlx5e_init_xsk_buffs(rq);
+	else
+		mlx5e_init_frags_partition(rq);
 
 	return 0;
 }
 
-static void mlx5e_free_au_list(struct mlx5e_rq *rq)
+static void mlx5e_free_wqe_alloc_info(struct mlx5e_rq *rq)
 {
+	kvfree(rq->wqe.frags);
 	kvfree(rq->wqe.alloc_units);
 }
 
@@ -778,18 +810,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		rq->wqe.info = rqp->frags_info;
 		rq->buff.frame0_sz = rq->wqe.info.arr[0].frag_stride;
 
-		rq->wqe.frags =
-			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
-					(wq_sz << rq->wqe.info.log_num_frags)),
-				      GFP_KERNEL, node);
-		if (!rq->wqe.frags) {
-			err = -ENOMEM;
-			goto err_rq_wq_destroy;
-		}
-
-		err = mlx5e_init_au_list(rq, wq_sz, node);
+		err = mlx5e_init_wqe_alloc_info(rq, node);
 		if (err)
-			goto err_rq_frags;
+			goto err_rq_wq_destroy;
 	}
 
 	if (xsk) {
@@ -888,9 +911,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
-		mlx5e_free_au_list(rq);
-err_rq_frags:
-		kvfree(rq->wqe.frags);
+		mlx5e_free_wqe_alloc_info(rq);
 	}
 err_rq_wq_destroy:
 	mlx5_wq_destroy(&rq->wq_ctrl);
@@ -921,8 +942,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		mlx5e_rq_free_shampo(rq);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
-		kvfree(rq->wqe.frags);
-		mlx5e_free_au_list(rq);
+		mlx5e_free_wqe_alloc_info(rq);
 	}
 
 	for (i = rq->page_cache.head; i != rq->page_cache.tail;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 36300118b6e4..74e7e00cf494 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -371,12 +371,12 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 	int err = 0;
 
 	if (!frag->offset)
-		/* On first frag (offset == 0), replenish page (alloc_unit actually).
-		 * Other frags that point to the same alloc_unit (with a different
+		/* On first frag (offset == 0), replenish page.
+		 * Other frags that point to the same page (with a different
 		 * offset) should just use the new one without replenishing again
 		 * by themselves.
 		 */
-		err = mlx5e_page_alloc_pool(rq, &frag->au->page);
+		err = mlx5e_page_alloc_pool(rq, frag->pagep);
 
 	return err;
 }
@@ -386,7 +386,7 @@ static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
 				     bool recycle)
 {
 	if (frag->last_in_page)
-		mlx5e_page_release_dynamic(rq, frag->au->page, recycle);
+		mlx5e_page_release_dynamic(rq, *frag->pagep, recycle);
 }
 
 static inline struct mlx5e_wqe_frag_info *get_frag(struct mlx5e_rq *rq, u16 ix)
@@ -410,7 +410,7 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 			goto free_frags;
 
 		headroom = i == 0 ? rq->buff.headroom : 0;
-		addr = page_pool_get_dma_addr(frag->au->page);
+		addr = page_pool_get_dma_addr(*frag->pagep);
 		wqe->data[i].addr = cpu_to_be64(addr + frag->offset + headroom);
 	}
 
@@ -434,7 +434,7 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
 		 */
-		xsk_buff_free(wi->au->xsk);
+		xsk_buff_free(*wi->xskp);
 		return;
 	}
 
@@ -1587,8 +1587,8 @@ static struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 			  struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
 {
-	union mlx5e_alloc_unit *au = wi->au;
 	u16 rx_headroom = rq->buff.headroom;
+	struct page *page = *wi->pagep;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
 	u32 metasize = 0;
@@ -1596,11 +1596,11 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 	dma_addr_t addr;
 	u32 frag_size;
 
-	va             = page_address(au->page) + wi->offset;
+	va             = page_address(page) + wi->offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = page_pool_get_dma_addr(page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
@@ -1624,7 +1624,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	page_ref_inc(au->page);
+	page_ref_inc(page);
 
 	return skb;
 }
@@ -1635,8 +1635,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 	struct mlx5e_wqe_frag_info *head_wi = wi;
-	union mlx5e_alloc_unit *au = wi->au;
 	u16 rx_headroom = rq->buff.headroom;
+	struct page *page = *wi->pagep;
 	struct skb_shared_info *sinfo;
 	struct mlx5e_xdp_buff mxbuf;
 	u32 frag_consumed_bytes;
@@ -1646,10 +1646,10 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	u32 truesize;
 	void *va;
 
-	va = page_address(au->page) + wi->offset;
+	va = page_address(page) + wi->offset;
 	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = page_pool_get_dma_addr(page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      rq->buff.frame0_sz, rq->buff.map_dir);
 	net_prefetchw(va); /* xdp_frame data area */
@@ -1666,11 +1666,11 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	while (cqe_bcnt) {
 		skb_frag_t *frag;
 
-		au = wi->au;
+		page = *wi->pagep;
 
 		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-		addr = page_pool_get_dma_addr(au->page);
+		addr = page_pool_get_dma_addr(page);
 		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
 					frag_consumed_bytes, rq->buff.map_dir);
 
@@ -1684,11 +1684,11 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 		}
 
 		frag = &sinfo->frags[sinfo->nr_frags++];
-		__skb_frag_set_page(frag, au->page);
+		__skb_frag_set_page(frag, page);
 		skb_frag_off_set(frag, wi->offset);
 		skb_frag_size_set(frag, frag_consumed_bytes);
 
-		if (page_is_pfmemalloc(au->page))
+		if (page_is_pfmemalloc(page))
 			xdp_buff_set_frag_pfmemalloc(&mxbuf.xdp);
 
 		sinfo->xdp_frags_size += frag_consumed_bytes;
@@ -1717,7 +1717,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	if (unlikely(!skb))
 		return NULL;
 
-	page_ref_inc(head_wi->au->page);
+	page_ref_inc(*head_wi->pagep);
 
 	if (xdp_buff_has_frags(&mxbuf.xdp)) {
 		int i;
-- 
2.39.2

