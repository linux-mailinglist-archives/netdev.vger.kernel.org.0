Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95B46CCBAD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjC1U5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC1U5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BFD211D
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E9776195E
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5964AC433D2;
        Tue, 28 Mar 2023 20:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037012;
        bh=UEVMpncYj0NNgiz4YMRHska2Y7K3nxa7I9T7UK3NixM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5rzhgRh6O5fR9+dAgZPTLcw3oE1e3DceRDK0QJ0w8DQ422ZTKTjJsKz6fn1WbcXT
         yjR9M17RpFbbAUYCTn3xQu7AZ0kCDVfsScoEBas5eG/PDILqgDoQ/rOMoTkxjkLv20
         u1UnJNGpmx9ecIw08XcZNuwIj+J3oqIBm+TJAPt2MGIB6V/IDFs+eeEc/uk1s1IUA8
         SFCMmE5jkGktULHYgydrsjRnFR66HFLyFFQcLdUN9LqW4UikCq4CAZn1YiV9jDZZBU
         Q11tgYJcBKXWJUdWVr7/on4aDdLLlxsL/+JGa8NkPlG8vdNkhlwpyYkDqKFYt9qkJW
         pbCsM0UCUfTuw==
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
Subject: [net-next 07/15] net/mlx5e: RX, Enable skb page recycling through the page_pool
Date:   Tue, 28 Mar 2023 13:56:15 -0700
Message-Id: <20230328205623.142075-8-saeed@kernel.org>
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

Start using the page_pool skb recycling api to recycle all pages back to
the page pool and stop using atomic page reference counting.

The mlx5e driver used to manage in-flight pages using page refcounting:
for each fragment there were 2 atomic write operations happening (one
for building the skb and one on skb release).

The page_pool api introduced a method to track page fragments more
optimally:
* The page's pp_fragment_count is set to a large bias on page alloc
  (1 x atomic write operation).
* The driver tracks the actual page fragments in a non atomic variable.
* When the skb is recycled, pp_fragment_count is decremented
  (atomic write operation).
* When page is released in the driver, the unused number of fragments
  (relative to the bias) is deducted from pp_fragment_count (atomic
  write operation).
* Last page defragmentation will only be an atomic read.

So in total there are `number of fragments + 1` atomic write ops. As
opposed to previously: `2 * frags` atomic writes ops.

Pages are wrapped in a mlx5e_frag_page structure which also contains the
number of fragments. This makes it easy to count the fragments in the
driver.

This change brings performance improvements for the case when the old rx
page_cache had low recycling rates due to head of queue blocking. For a
iperf3 TCP test with a single stream, on a single core (iperf and receive
queue running on same core), the following improvements can be noticed:

* Striding rq:
  - before (net-next baseline): bitrate = 30.1 Gbits/sec
  - after                     : bitrate = 31.4 Gbits/sec (diff: 4.14 %)

* Legacy rq:
  - before (net-next baseline): bitrate = 30.2 Gbits/sec
  - after                     : bitrate = 33.0 Gbits/sec (diff: 8.48 %)

There are 2 temporary performance degradations introduced:

1) TCP streams that had a good recycling rate with the old page_cache
   have a degradation for both striding and linear rq. This is due to
   very low page pool cache recycling: the pages are released during skb
   recycle which will release pages to the page pool ring for safety.
   The following patches in this series will tackle this problem by
   deferring the page release in the driver to increase the
   chance of having pages recycled to the cache.

2) XDP performance is now lower (4-5 %) due to the higher number of
   atomic operations used for fragment management. But this opens the
   door for supporting multiple packets per page in XDP, which will
   bring a big gain.

Otherwise, performance is similar to baseline.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 180 ++++++++++--------
 5 files changed, 121 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2684e7af5a7a..0862556105d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -600,9 +600,14 @@ struct mlx5e_icosq {
 	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
 
+struct mlx5e_frag_page {
+	struct page *page;
+	u16 frags;
+};
+
 struct mlx5e_wqe_frag_info {
 	union {
-		struct page **pagep;
+		struct mlx5e_frag_page *frag_page;
 		struct xdp_buff **xskp;
 	};
 	u32 offset;
@@ -610,6 +615,7 @@ struct mlx5e_wqe_frag_info {
 };
 
 union mlx5e_alloc_units {
+	DECLARE_FLEX_ARRAY(struct mlx5e_frag_page, frag_pages);
 	DECLARE_FLEX_ARRAY(struct page *, pages);
 	DECLARE_FLEX_ARRAY(struct xdp_buff *, xsk_buffs);
 };
@@ -666,7 +672,7 @@ struct mlx5e_rq_frags_info {
 struct mlx5e_dma_info {
 	dma_addr_t addr;
 	union {
-		struct page **pagep;
+		struct mlx5e_frag_page *frag_page;
 		struct page *page;
 	};
 };
@@ -674,7 +680,7 @@ struct mlx5e_dma_info {
 struct mlx5e_shampo_hd {
 	u32 mkey;
 	struct mlx5e_dma_info *info;
-	struct page **pages;
+	struct mlx5e_frag_page *pages;
 	u16 curr_page_index;
 	u16 hd_per_wq;
 	u16 hd_per_wqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 04419f56ac85..cd7779a9d046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -65,7 +65,6 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget);
 int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 
 /* RX */
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle);
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq));
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
@@ -488,7 +487,7 @@ static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size
 
 static inline struct mlx5e_mpw_info *mlx5e_get_mpw_info(struct mlx5e_rq *rq, int i)
 {
-	size_t isz = struct_size(rq->mpwqe.info, alloc_units.pages, rq->mpwqe.pages_per_wqe);
+	size_t isz = struct_size(rq->mpwqe.info, alloc_units.frag_pages, rq->mpwqe.pages_per_wqe);
 
 	return (struct mlx5e_mpw_info *)((char *)rq->mpwqe.info + array_size(i, isz));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 5e6ef602c748..ca6ac9772d22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -523,7 +523,8 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
-			mlx5e_page_release_dynamic(xdpi.page.rq, xdpi.page.page, recycle);
+			page_pool_put_defragged_page(xdpi.page.rq->page_pool,
+						     xdpi.page.page, -1, recycle);
 			break;
 		case MLX5E_XDP_XMIT_MODE_XSK:
 			/* AF_XDP send */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2a73680021c2..eca9a11454e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -294,7 +294,7 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 	size_t alloc_size;
 
 	alloc_size = array_size(wq_sz, struct_size(rq->mpwqe.info,
-						   alloc_units.pages,
+						   alloc_units.frag_pages,
 						   rq->mpwqe.pages_per_wqe));
 
 	rq->mpwqe.info = kvzalloc_node(alloc_size, GFP_KERNEL, node);
@@ -509,7 +509,8 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 
 	WARN_ON(rq->xsk_pool);
 
-	next_frag.pagep = &rq->wqe.alloc_units->pages[0];
+	next_frag.frag_page = &rq->wqe.alloc_units->frag_pages[0];
+
 	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
 		struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 		struct mlx5e_wqe_frag_info *frag =
@@ -519,7 +520,7 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 		for (f = 0; f < rq->wqe.info.num_frags; f++, frag++) {
 			if (next_frag.offset + frag_info[f].frag_stride > PAGE_SIZE) {
 				/* Pages are assigned at runtime. */
-				next_frag.pagep++;
+				next_frag.frag_page++;
 				next_frag.offset = 0;
 				if (prev)
 					prev->last_in_page = true;
@@ -563,7 +564,7 @@ static int mlx5e_init_wqe_alloc_info(struct mlx5e_rq *rq, int node)
 	if (rq->xsk_pool)
 		aus_sz = sizeof(*aus->xsk_buffs);
 	else
-		aus_sz = sizeof(*aus->pages);
+		aus_sz = sizeof(*aus->frag_pages);
 
 	aus = kvzalloc_node(array_size(len, aus_sz), GFP_KERNEL, node);
 	if (!aus)
@@ -831,7 +832,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		struct page_pool_params pp_params = { 0 };
 
 		pp_params.order     = 0;
-		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV | PP_FLAG_PAGE_FRAG;
 		pp_params.pool_size = pool_size;
 		pp_params.nid       = node;
 		pp_params.dev       = rq->pdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 01c789b89cb9..7724e30ec133 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -271,23 +271,36 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem);
 }
 
-static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct page **pagep)
+#define MLX5E_PAGECNT_BIAS_MAX (PAGE_SIZE / 64)
+
+static int mlx5e_page_alloc_fragmented(struct mlx5e_rq *rq,
+				       struct mlx5e_frag_page *frag_page)
 {
-	*pagep = page_pool_dev_alloc_pages(rq->page_pool);
-	if (unlikely(!*pagep))
+	struct page *page;
+
+	page = page_pool_dev_alloc_pages(rq->page_pool);
+	if (unlikely(!page))
 		return -ENOMEM;
 
+	page_pool_fragment_page(page, MLX5E_PAGECNT_BIAS_MAX);
+
+	*frag_page = (struct mlx5e_frag_page) {
+		.page	= page,
+		.frags	= 0,
+	};
+
 	return 0;
 }
 
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle)
+static void mlx5e_page_release_fragmented(struct mlx5e_rq *rq,
+					  struct mlx5e_frag_page *frag_page,
+					  bool recycle)
 {
-	if (likely(recycle)) {
-		page_pool_recycle_direct(rq->page_pool, page);
-	} else {
-		page_pool_release_page(rq->page_pool, page);
-		put_page(page);
-	}
+	u16 drain_count = MLX5E_PAGECNT_BIAS_MAX - frag_page->frags;
+	struct page *page = frag_page->page;
+
+	if (page_pool_defrag_page(page, drain_count) == 0)
+		page_pool_put_defragged_page(rq->page_pool, page, -1, recycle);
 }
 
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
@@ -301,7 +314,7 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 		 * offset) should just use the new one without replenishing again
 		 * by themselves.
 		 */
-		err = mlx5e_page_alloc_pool(rq, frag->pagep);
+		err = mlx5e_page_alloc_fragmented(rq, frag->frag_page);
 
 	return err;
 }
@@ -311,7 +324,7 @@ static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
 				     bool recycle)
 {
 	if (frag->last_in_page)
-		mlx5e_page_release_dynamic(rq, *frag->pagep, recycle);
+		mlx5e_page_release_fragmented(rq, frag->frag_page, recycle);
 }
 
 static inline struct mlx5e_wqe_frag_info *get_frag(struct mlx5e_rq *rq, u16 ix)
@@ -335,7 +348,7 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 			goto free_frags;
 
 		headroom = i == 0 ? rq->buff.headroom : 0;
-		addr = page_pool_get_dma_addr(*frag->pagep);
+		addr = page_pool_get_dma_addr(frag->frag_page->page);
 		wqe->data[i].addr = cpu_to_be64(addr + frag->offset + headroom);
 	}
 
@@ -401,7 +414,6 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 
 	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len,
 				rq->buff.map_dir);
-	page_ref_inc(page);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 			page, frag_offset, len, truesize);
 }
@@ -443,11 +455,14 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
 				xsk_buff_free(xsk_buffs[i]);
 	} else {
-		struct page **pages = wi->alloc_units.pages;
+		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++) {
+			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap)) {
+				struct mlx5e_frag_page *frag_page;
 
-		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
-			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-				mlx5e_page_release_dynamic(rq, pages[i], recycle);
+				frag_page = &wi->alloc_units.frag_pages[i];
+				mlx5e_page_release_fragmented(rq, frag_page, recycle);
+			}
+		}
 	}
 }
 
@@ -512,10 +527,10 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	u16 entries, pi, header_offset, err, wqe_bbs, new_entries;
 	u32 lkey = rq->mdev->mlx5e_res.hw_objs.mkey;
 	u16 page_index = shampo->curr_page_index;
+	struct mlx5e_frag_page *frag_page;
 	u64 addr = shampo->last_addr;
 	struct mlx5e_dma_info *dma_info;
 	struct mlx5e_umr_wqe *umr_wqe;
-	struct page **pagep;
 	int headroom, i;
 
 	headroom = rq->buff.headroom;
@@ -526,7 +541,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	umr_wqe = mlx5_wq_cyc_get_wqe(&sq->wq, pi);
 	build_klm_umr(sq, umr_wqe, shampo->key, index, entries, wqe_bbs);
 
-	pagep = &shampo->pages[page_index];
+	frag_page = &shampo->pages[page_index];
 
 	for (i = 0; i < entries; i++, index++) {
 		dma_info = &shampo->info[index];
@@ -537,19 +552,19 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 			MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
 		if (!(header_offset & (PAGE_SIZE - 1))) {
 			page_index = (page_index + 1) & (shampo->hd_per_wq - 1);
-			pagep = &shampo->pages[page_index];
+			frag_page = &shampo->pages[page_index];
 
-			err = mlx5e_page_alloc_pool(rq, pagep);
+			err = mlx5e_page_alloc_fragmented(rq, frag_page);
 			if (unlikely(err))
 				goto err_unmap;
 
-			addr = page_pool_get_dma_addr(*pagep);
+			addr = page_pool_get_dma_addr(frag_page->page);
 
 			dma_info->addr = addr;
-			dma_info->pagep = pagep;
+			dma_info->frag_page = frag_page;
 		} else {
 			dma_info->addr = addr + header_offset;
-			dma_info->pagep = pagep;
+			dma_info->frag_page = frag_page;
 		}
 
 update_klm:
@@ -579,7 +594,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
 			dma_info->addr = ALIGN_DOWN(dma_info->addr, PAGE_SIZE);
-			mlx5e_page_release_dynamic(rq, *dma_info->pagep, true);
+			mlx5e_page_release_fragmented(rq, dma_info->frag_page, true);
 		}
 	}
 	rq->stats->buff_alloc_err++;
@@ -628,8 +643,8 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
-	struct page **pagep = &wi->alloc_units.pages[0];
 	struct mlx5e_icosq *sq = rq->icosq;
+	struct mlx5e_frag_page *frag_page;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
 	u32 offset; /* 17-bit value with MTT. */
@@ -647,13 +662,15 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
 	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, sizeof(struct mlx5e_umr_wqe));
 
-	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, pagep++) {
+	frag_page = &wi->alloc_units.frag_pages[0];
+
+	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, frag_page++) {
 		dma_addr_t addr;
 
-		err = mlx5e_page_alloc_pool(rq, pagep);
+		err = mlx5e_page_alloc_fragmented(rq, frag_page);
 		if (unlikely(err))
 			goto err_unmap;
-		addr = page_pool_get_dma_addr(*pagep);
+		addr = page_pool_get_dma_addr(frag_page->page);
 		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
 			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
 		};
@@ -694,8 +711,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 
 err_unmap:
 	while (--i >= 0) {
-		pagep--;
-		mlx5e_page_release_dynamic(rq, *pagep, true);
+		frag_page--;
+		mlx5e_page_release_fragmented(rq, frag_page, true);
 	}
 
 err:
@@ -713,8 +730,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close)
 {
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
+	struct mlx5e_frag_page *deleted_page = NULL;
 	int hd_per_wq = shampo->hd_per_wq;
-	struct page **deleted_page = NULL;
 	struct mlx5e_dma_info *hd_info;
 	int i, index = start;
 
@@ -727,10 +744,12 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 
 		hd_info = &shampo->info[index];
 		hd_info->addr = ALIGN_DOWN(hd_info->addr, PAGE_SIZE);
-		if (hd_info->pagep != deleted_page) {
-			deleted_page = hd_info->pagep;
-			mlx5e_page_release_dynamic(rq, *hd_info->pagep, false);
+		if (hd_info->frag_page && hd_info->frag_page != deleted_page) {
+			deleted_page = hd_info->frag_page;
+			mlx5e_page_release_fragmented(rq, hd_info->frag_page, false);
 		}
+
+		hd_info->frag_page = NULL;
 	}
 
 	if (start + len > hd_per_wq) {
@@ -1068,7 +1087,7 @@ static void *mlx5e_shampo_get_packet_hd(struct mlx5e_rq *rq, u16 header_index)
 	struct mlx5e_dma_info *last_head = &rq->mpwqe.shampo->info[header_index];
 	u16 head_offset = (last_head->addr & (PAGE_SIZE - 1)) + rq->buff.headroom;
 
-	return page_address(*last_head->pagep) + head_offset;
+	return page_address(last_head->frag_page->page) + head_offset;
 }
 
 static void mlx5e_shampo_update_ipv4_udp_hdr(struct mlx5e_rq *rq, struct iphdr *ipv4)
@@ -1521,8 +1540,8 @@ static struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 			  struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
 {
+	struct mlx5e_frag_page *frag_page = wi->frag_page;
 	u16 rx_headroom = rq->buff.headroom;
-	struct page *page = *wi->pagep;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
 	u32 metasize = 0;
@@ -1530,11 +1549,11 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 	dma_addr_t addr;
 	u32 frag_size;
 
-	va             = page_address(page) + wi->offset;
+	va             = page_address(frag_page->page) + wi->offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(page);
+	addr = page_pool_get_dma_addr(frag_page->page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
@@ -1558,7 +1577,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	page_ref_inc(page);
+	skb_mark_for_recycle(skb);
+	frag_page->frags++;
 
 	return skb;
 }
@@ -1570,7 +1590,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 	struct mlx5e_wqe_frag_info *head_wi = wi;
 	u16 rx_headroom = rq->buff.headroom;
-	struct page *page = *wi->pagep;
+	struct mlx5e_frag_page *frag_page;
 	struct skb_shared_info *sinfo;
 	struct mlx5e_xdp_buff mxbuf;
 	u32 frag_consumed_bytes;
@@ -1580,10 +1600,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	u32 truesize;
 	void *va;
 
-	va = page_address(page) + wi->offset;
+	frag_page = wi->frag_page;
+
+	va = page_address(frag_page->page) + wi->offset;
 	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(page);
+	addr = page_pool_get_dma_addr(frag_page->page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      rq->buff.frame0_sz, rq->buff.map_dir);
 	net_prefetchw(va); /* xdp_frame data area */
@@ -1600,11 +1622,11 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	while (cqe_bcnt) {
 		skb_frag_t *frag;
 
-		page = *wi->pagep;
+		frag_page = wi->frag_page;
 
 		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-		addr = page_pool_get_dma_addr(page);
+		addr = page_pool_get_dma_addr(frag_page->page);
 		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
 					frag_consumed_bytes, rq->buff.map_dir);
 
@@ -1618,11 +1640,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 		}
 
 		frag = &sinfo->frags[sinfo->nr_frags++];
-		__skb_frag_set_page(frag, page);
+
+		__skb_frag_set_page(frag, frag_page->page);
 		skb_frag_off_set(frag, wi->offset);
 		skb_frag_size_set(frag, frag_consumed_bytes);
 
-		if (page_is_pfmemalloc(page))
+		if (page_is_pfmemalloc(frag_page->page))
 			xdp_buff_set_frag_pfmemalloc(&mxbuf.xdp);
 
 		sinfo->xdp_frags_size += frag_consumed_bytes;
@@ -1651,21 +1674,17 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	if (unlikely(!skb))
 		return NULL;
 
-	page_ref_inc(*head_wi->pagep);
+	skb_mark_for_recycle(skb);
+	head_wi->frag_page->frags++;
 
 	if (xdp_buff_has_frags(&mxbuf.xdp)) {
-		int i;
-
 		/* sinfo->nr_frags is reset by build_skb, calculate again. */
 		xdp_update_skb_shared_info(skb, wi - head_wi - 1,
 					   sinfo->xdp_frags_size, truesize,
 					   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
 
-		for (i = 0; i < sinfo->nr_frags; i++) {
-			skb_frag_t *frag = &sinfo->frags[i];
-
-			page_ref_inc(skb_frag_page(frag));
-		}
+		for (struct mlx5e_wqe_frag_info *pwi = head_wi + 1; pwi < wi; pwi++)
+			pwi->frag_page->frags++;
 	}
 
 	return skb;
@@ -1848,7 +1867,8 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 
 static void
 mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
-		    struct page **pagep, u32 data_bcnt, u32 data_offset)
+		    struct mlx5e_frag_page *frag_page,
+		    u32 data_bcnt, u32 data_offset)
 {
 	net_prefetchw(skb->data);
 
@@ -1862,12 +1882,13 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
 		else
 			truesize = ALIGN(pg_consumed_bytes, BIT(rq->mpwqe.log_stride_sz));
 
-		mlx5e_add_skb_frag(rq, skb, *pagep, data_offset,
+		frag_page->frags++;
+		mlx5e_add_skb_frag(rq, skb, frag_page->page, data_offset,
 				   pg_consumed_bytes, truesize);
 
 		data_bcnt -= pg_consumed_bytes;
 		data_offset = 0;
-		pagep++;
+		frag_page++;
 	}
 }
 
@@ -1876,11 +1897,11 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 				   struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
 				   u32 page_idx)
 {
-	struct page **pagep = &wi->alloc_units.pages[page_idx];
+	struct mlx5e_frag_page *frag_page = &wi->alloc_units.frag_pages[page_idx];
 	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
+	struct mlx5e_frag_page *head_page = frag_page;
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
-	struct page *head_page = *pagep;
 	struct sk_buff *skb;
 	dma_addr_t addr;
 
@@ -1895,14 +1916,15 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	/* Non-linear mode, hence non-XSK, which always uses PAGE_SIZE. */
 	if (unlikely(frag_offset >= PAGE_SIZE)) {
-		pagep++;
+		frag_page++;
 		frag_offset -= PAGE_SIZE;
 	}
 
-	mlx5e_fill_skb_data(skb, rq, pagep, byte_cnt, frag_offset);
+	skb_mark_for_recycle(skb);
+	mlx5e_fill_skb_data(skb, rq, frag_page, byte_cnt, frag_offset);
 	/* copy header */
-	addr = page_pool_get_dma_addr(head_page);
-	mlx5e_copy_skb_header(rq, skb, head_page, addr,
+	addr = page_pool_get_dma_addr(head_page->page);
+	mlx5e_copy_skb_header(rq, skb, head_page->page, addr,
 			      head_offset, head_offset, headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
@@ -1916,7 +1938,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
 				u32 page_idx)
 {
-	struct page *page = wi->alloc_units.pages[page_idx];
+	struct mlx5e_frag_page *frag_page = &wi->alloc_units.frag_pages[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
@@ -1931,11 +1953,11 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 	}
 
-	va             = page_address(page) + head_offset;
+	va             = page_address(frag_page->page) + head_offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(page);
+	addr = page_pool_get_dma_addr(frag_page->page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, head_offset,
 				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
@@ -1962,7 +1984,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	page_ref_inc(page);
+	skb_mark_for_recycle(skb);
+	frag_page->frags++;
 
 	return skb;
 }
@@ -1979,7 +2002,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	void *hdr, *data;
 	u32 frag_size;
 
-	hdr		= page_address(*head->pagep) + head_offset;
+	hdr		= page_address(head->frag_page->page) + head_offset;
 	data		= hdr + rx_headroom;
 	frag_size	= MLX5_SKB_FRAG_SZ(rx_headroom + head_size);
 
@@ -1993,9 +2016,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		if (unlikely(!skb))
 			return NULL;
 
-		/* queue up for recycling/reuse */
-		page_ref_inc(*head->pagep);
-
+		head->frag_page->frags++;
 	} else {
 		/* allocate SKB and copy header for large header */
 		rq->stats->gro_large_hds++;
@@ -2007,13 +2028,17 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		}
 
 		prefetchw(skb->data);
-		mlx5e_copy_skb_header(rq, skb, *head->pagep, head->addr,
+		mlx5e_copy_skb_header(rq, skb, head->frag_page->page, head->addr,
 				      head_offset + rx_headroom,
 				      rx_headroom, head_size);
 		/* skb linear part was allocated with headlen and aligned to long */
 		skb->tail += head_size;
 		skb->len  += head_size;
 	}
+
+	/* queue up for recycling/reuse */
+	skb_mark_for_recycle(skb);
+
 	return skb;
 }
 
@@ -2061,7 +2086,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 		struct mlx5e_dma_info *dma_info = &shampo->info[header_index];
 
 		dma_info->addr = ALIGN_DOWN(addr, PAGE_SIZE);
-		mlx5e_page_release_dynamic(rq, *dma_info->pagep, true);
+		mlx5e_page_release_fragmented(rq, dma_info->frag_page, true);
 	}
 	bitmap_clear(shampo->bitmap, header_index, 1);
 }
@@ -2131,9 +2156,10 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (likely(head_size)) {
-		struct page **pagep = &wi->alloc_units.pages[page_idx];
+		struct mlx5e_frag_page *frag_page;
 
-		mlx5e_fill_skb_data(*skb, rq, pagep, data_bcnt, data_offset);
+		frag_page = &wi->alloc_units.frag_pages[page_idx];
+		mlx5e_fill_skb_data(*skb, rq, frag_page, data_bcnt, data_offset);
 	}
 
 	mlx5e_shampo_complete_rx_cqe(rq, cqe, cqe_bcnt, *skb);
-- 
2.39.2

