Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D833B5EEED9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiI2HXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiI2HW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED56F118B23
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5DE262067
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4D5C433D6;
        Thu, 29 Sep 2022 07:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436169;
        bh=EdRtLRM7X8yWIw0GDWbT6CeWzPEQ67QJ9I90M85j5h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xof+HwOd0DB/O59PiOdKQXW4NvwVd6euHPmJ9//Ec8uAXrC6Npuf0j0As9YmDlDzT
         /O6sRyTXJF/QNagzKyx/itwxZNs8VLgl3mNvf4NCorGc4K9PKcMs0gt3qEetsoKORQ
         k0FT6W2LyNdesOm4fwJwTg9YVtIdqZP0Yt9VPwongHv5L04VKIw5gUCuslWuTqthPw
         fdsJczoZ3BWJSfjf5SUNMma2yYXeQLv+rzQGskxe576Clh3Y+4ilYstcxPxV74ZBnu
         8mBKAE4RKiMf5US+IhmO5oQxMEGJbiQhQE5bj6+tlCZmJ4Vl8gXxruoNaP+1eVJBiY
         vf/HeBGNyxe0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 11/16] net/mlx5e: Remove DMA address from mlx5e_alloc_unit
Date:   Thu, 29 Sep 2022 00:21:51 -0700
Message-Id: <20220929072156.93299-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_alloc_unit stores the DMA address and a pointer to either struct
page (regular RQ) or struct xdp_buff (XSK RQ). This DMA address is
redundant, because when a page or an XSK frame is allocated, the same
address is also stored there. Some flows take the address from struct
mlx5e_alloc_unit, and some take it from struct page or xdp_buff.

This commit removes the address from struct mlx5e_alloc_unit, which
makes it twice as small and improves locality (this struct is used in an
array), also saving on unnecessary stores to the addr field. Almost all
flows know unambiguously whether the DMA address should be taken from
page or from xdp_buff. The exception is the allocation flows, where a
new branch appeared, which will be optimized out in the next commits.

struct mlx5e_alloc_unit used to be called mlx5e_dma_info.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  7 ---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 57 +++++++++++++------
 3 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 06f49ef71b5b..944bf4c92582 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -475,7 +475,6 @@ struct mlx5e_txqsq {
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_alloc_unit {
-	dma_addr_t addr;
 	union {
 		struct page *page;
 		struct xdp_buff *xsk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index c9bdd2c04922..d6dddad890e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -25,13 +25,6 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 	if (!au->xsk)
 		return -ENOMEM;
 
-	/* Store the DMA address without headroom. In striding RQ case, we just
-	 * provide pages for UMR, and headroom is counted at the setup stage
-	 * when creating a WQE. In non-striding RQ case, headroom is accounted
-	 * in mlx5e_alloc_rx_wqe.
-	 */
-	au->addr = xsk_buff_xdp_get_frame_dma(au->xsk);
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 83941a4c40a1..a3891a88863e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -254,6 +254,7 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, struct mlx5e_alloc_un
 {
 	struct mlx5e_page_cache *cache = &rq->page_cache;
 	struct mlx5e_rq_stats *stats = rq->stats;
+	dma_addr_t addr;
 
 	if (unlikely(cache->head == cache->tail)) {
 		stats->cache_empty++;
@@ -266,17 +267,19 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, struct mlx5e_alloc_un
 	}
 
 	au->page = cache->page_cache[cache->head];
-	au->addr = page_pool_get_dma_addr(au->page);
 	cache->head = (cache->head + 1) & (MLX5E_CACHE_SIZE - 1);
 	stats->cache_reuse++;
 
+	addr = page_pool_get_dma_addr(au->page);
 	/* Non-XSK always uses PAGE_SIZE. */
-	dma_sync_single_for_device(rq->pdev, au->addr, PAGE_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(rq->pdev, addr, PAGE_SIZE, DMA_FROM_DEVICE);
 	return true;
 }
 
 static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct mlx5e_alloc_unit *au)
 {
+	dma_addr_t addr;
+
 	if (mlx5e_rx_cache_get(rq, au))
 		return 0;
 
@@ -285,14 +288,14 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct mlx5e_alloc_
 		return -ENOMEM;
 
 	/* Non-XSK always uses PAGE_SIZE. */
-	au->addr = dma_map_page_attrs(rq->pdev, au->page, 0, PAGE_SIZE,
-				      rq->buff.map_dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (unlikely(dma_mapping_error(rq->pdev, au->addr))) {
+	addr = dma_map_page_attrs(rq->pdev, au->page, 0, PAGE_SIZE,
+				  rq->buff.map_dir, DMA_ATTR_SKIP_CPU_SYNC);
+	if (unlikely(dma_mapping_error(rq->pdev, addr))) {
 		page_pool_recycle_direct(rq->page_pool, au->page);
 		au->page = NULL;
 		return -ENOMEM;
 	}
-	page_pool_set_dma_addr(au->page, au->addr);
+	page_pool_set_dma_addr(au->page, addr);
 
 	return 0;
 }
@@ -380,6 +383,7 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 	int i;
 
 	for (i = 0; i < rq->wqe.info.num_frags; i++, frag++) {
+		dma_addr_t addr;
 		u16 headroom;
 
 		err = mlx5e_get_rx_frag(rq, frag);
@@ -387,8 +391,9 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 			goto free_frags;
 
 		headroom = i == 0 ? rq->buff.headroom : 0;
-		wqe->data[i].addr = cpu_to_be64(frag->au->addr +
-						frag->offset + headroom);
+		addr = rq->xsk_pool ? xsk_buff_xdp_get_frame_dma(frag->au->xsk) :
+				      page_pool_get_dma_addr(frag->au->page);
+		wqe->data[i].addr = cpu_to_be64(addr + frag->offset + headroom);
 	}
 
 	return 0;
@@ -456,8 +461,9 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   struct mlx5e_alloc_unit *au, u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
-	dma_sync_single_for_cpu(rq->pdev, au->addr + frag_offset,
-				len, DMA_FROM_DEVICE);
+	dma_addr_t addr = page_pool_get_dma_addr(au->page);
+
+	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len, DMA_FROM_DEVICE);
 	page_ref_inc(au->page);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 			au->page, frag_offset, len, truesize);
@@ -698,21 +704,29 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 
 	if (unlikely(rq->mpwqe.unaligned)) {
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
+			dma_addr_t addr;
+
 			err = mlx5e_page_alloc(rq, au);
 			if (unlikely(err))
 				goto err_unmap;
+			/* Unaligned means XSK. */
+			addr = xsk_buff_xdp_get_frame_dma(au->xsk);
 			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
 				.key = rq->mkey_be,
-				.va = cpu_to_be64(au->addr),
+				.va = cpu_to_be64(addr),
 			};
 		}
 	} else {
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
+			dma_addr_t addr;
+
 			err = mlx5e_page_alloc(rq, au);
 			if (unlikely(err))
 				goto err_unmap;
+			addr = rq->xsk_pool ? xsk_buff_xdp_get_frame_dma(au->xsk) :
+					      page_pool_get_dma_addr(au->page);
 			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
-				.ptag = cpu_to_be64(au->addr | MLX5_EN_WR),
+				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
 			};
 		}
 	}
@@ -1563,13 +1577,15 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 	struct sk_buff *skb;
 	u32 metasize = 0;
 	void *va, *data;
+	dma_addr_t addr;
 	u32 frag_size;
 
 	va             = page_address(au->page) + wi->offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	dma_sync_single_range_for_cpu(rq->pdev, au->addr, wi->offset,
+	addr = page_pool_get_dma_addr(au->page);
+	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      frag_size, DMA_FROM_DEVICE);
 	net_prefetch(data);
 
@@ -1610,13 +1626,15 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	struct bpf_prog *prog;
 	struct xdp_buff xdp;
 	struct sk_buff *skb;
+	dma_addr_t addr;
 	u32 truesize;
 	void *va;
 
 	va = page_address(au->page) + wi->offset;
 	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-	dma_sync_single_range_for_cpu(rq->pdev, au->addr, wi->offset,
+	addr = page_pool_get_dma_addr(au->page);
+	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      rq->buff.frame0_sz, DMA_FROM_DEVICE);
 	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
@@ -1636,7 +1654,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-		dma_sync_single_for_cpu(rq->pdev, au->addr + wi->offset,
+		addr = page_pool_get_dma_addr(au->page);
+		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
 					frag_consumed_bytes, DMA_FROM_DEVICE);
 
 		if (!xdp_buff_has_frags(&xdp)) {
@@ -1913,6 +1932,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	u32 byte_cnt       = cqe_bcnt - headlen;
 	struct mlx5e_alloc_unit *head_au = au;
 	struct sk_buff *skb;
+	dma_addr_t addr;
 
 	skb = napi_alloc_skb(rq->cq.napi,
 			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
@@ -1931,7 +1951,8 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	mlx5e_fill_skb_data(skb, rq, au, byte_cnt, frag_offset);
 	/* copy header */
-	mlx5e_copy_skb_header(rq->pdev, skb, head_au->page, head_au->addr,
+	addr = page_pool_get_dma_addr(head_au->page);
+	mlx5e_copy_skb_header(rq->pdev, skb, head_au->page, addr,
 			      head_offset, head_offset, headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
@@ -1950,6 +1971,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	struct sk_buff *skb;
 	u32 metasize = 0;
 	void *va, *data;
+	dma_addr_t addr;
 	u32 frag_size;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
@@ -1962,7 +1984,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	dma_sync_single_range_for_cpu(rq->pdev, au->addr, head_offset,
+	addr = page_pool_get_dma_addr(au->page);
+	dma_sync_single_range_for_cpu(rq->pdev, addr, head_offset,
 				      frag_size, DMA_FROM_DEVICE);
 	net_prefetch(data);
 
-- 
2.37.3

