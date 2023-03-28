Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F936CCBAC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjC1U5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjC1U5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2374E2128
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC221B81E72
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6ACC433A8;
        Tue, 28 Mar 2023 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037010;
        bh=OA8Yemg54kVKc2KCJD9jtA6MRRGKX1qsAXKBPa9ZfEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWAAK2tGIjI/BkgPwEzBrjFCJNYmYNc18Io7z/Sh1bWgA+5RtDj2KXZ8CW85psrh2
         LnUou1jrQuXSPsXOmkgEneSaFY4tNz8rnsKfKCbRumPmg9xNVDCn9F3BhvaVP9yvQn
         reKvnBMqZGmucLN2UcnnX18GFLd5YEFYtRNgJUIwBkq9cKGbIeKKSAStuczyD06Piq
         IHXDNHJ04sE10OYxRg/+24qyUROtwDVshQ9Z9Vmt2ZJl10cs8B7rKNPJIaJa0BBWLs
         GV1Kbi67/LtTdp/jdKzRepEUs1Hj1SvoGpB5lP5QAKddbz9DElwx97W9FLK3gH2Pbb
         RGPM2YkBdFaTA==
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
Subject: [net-next 05/15] net/mlx5e: RX, Remove internal page_cache
Date:   Tue, 28 Mar 2023 13:56:13 -0700
Message-Id: <20230328205623.142075-6-saeed@kernel.org>
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

This patch removes the internal rx page_cache and uses the generic
page_pool api only. It used to be that the page_pool couldn't handle all
the mlx5 driver usecases, but with the introduction of skb recycling and
page fragmentaton in the page_pool full switch can now be made. Some
benfits of this transition:
* Better page recycling in the cases when the page_cache was suffering
  from head of queue blocking. The page_pool doesn't have this issue.
* DMA mapping/unmapping can be managed by the page_pool.
* mlx5e_rq size reduced by more than 50% due to the page_cache array
  being deleted.

This patch only removes the page_cache. Downstream patches will enable
the required page_pool features and will add further fine-tuning.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 ---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 13 -----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 53 -------------------
 3 files changed, 72 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b38fbacbb4d1..2684e7af5a7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -628,11 +628,6 @@ struct mlx5e_mpw_info {
 #define MLX5E_CACHE_UNIT (MLX5_MPWRQ_MAX_PAGES_PER_WQE > NAPI_POLL_WEIGHT ? \
 			  MLX5_MPWRQ_MAX_PAGES_PER_WQE : NAPI_POLL_WEIGHT)
 #define MLX5E_CACHE_SIZE	(4 * roundup_pow_of_two(MLX5E_CACHE_UNIT))
-struct mlx5e_page_cache {
-	u32 head;
-	u32 tail;
-	struct page *page_cache[MLX5E_CACHE_SIZE];
-};
 
 struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
@@ -745,7 +740,6 @@ struct mlx5e_rq {
 	struct mlx5e_rq_stats *stats;
 	struct mlx5e_cq        cq;
 	struct mlx5e_cq_decomp cqd;
-	struct mlx5e_page_cache page_cache;
 	struct hwtstamp_config *tstamp;
 	struct mlx5_clock      *clock;
 	struct mlx5e_icosq    *icosq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 77f81d74ff30..b0322a20b71b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -900,9 +900,6 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		rq->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	}
 
-	rq->page_cache.head = 0;
-	rq->page_cache.tail = 0;
-
 	return 0;
 
 err_destroy_page_pool:
@@ -933,7 +930,6 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 static void mlx5e_free_rq(struct mlx5e_rq *rq)
 {
 	struct bpf_prog *old_prog;
-	int i;
 
 	if (xdp_rxq_info_is_reg(&rq->xdp_rxq)) {
 		old_prog = rcu_dereference_protected(rq->xdp_prog,
@@ -953,15 +949,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		mlx5e_free_wqe_alloc_info(rq);
 	}
 
-	for (i = rq->page_cache.head; i != rq->page_cache.tail;
-	     i = (i + 1) & (MLX5E_CACHE_SIZE - 1)) {
-		/* With AF_XDP, page_cache is not used, so this loop is not
-		 * entered, and it's safe to call mlx5e_page_release_dynamic
-		 * directly.
-		 */
-		mlx5e_page_release_dynamic(rq, rq->page_cache.page_cache[i], false);
-	}
-
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
 	page_pool_destroy(rq->page_pool);
 	mlx5_wq_destroy(&rq->wq_ctrl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7057db954f6f..192f12a7d9a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -271,60 +271,10 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem);
 }
 
-static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
-{
-	struct mlx5e_page_cache *cache = &rq->page_cache;
-	u32 tail_next = (cache->tail + 1) & (MLX5E_CACHE_SIZE - 1);
-	struct mlx5e_rq_stats *stats = rq->stats;
-
-	if (tail_next == cache->head) {
-		stats->cache_full++;
-		return false;
-	}
-
-	if (!dev_page_is_reusable(page)) {
-		stats->cache_waive++;
-		return false;
-	}
-
-	cache->page_cache[cache->tail] = page;
-	cache->tail = tail_next;
-	return true;
-}
-
-static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, struct page **pagep)
-{
-	struct mlx5e_page_cache *cache = &rq->page_cache;
-	struct mlx5e_rq_stats *stats = rq->stats;
-	dma_addr_t addr;
-
-	if (unlikely(cache->head == cache->tail)) {
-		stats->cache_empty++;
-		return false;
-	}
-
-	if (page_ref_count(cache->page_cache[cache->head]) != 1) {
-		stats->cache_busy++;
-		return false;
-	}
-
-	*pagep = cache->page_cache[cache->head];
-	cache->head = (cache->head + 1) & (MLX5E_CACHE_SIZE - 1);
-	stats->cache_reuse++;
-
-	addr = page_pool_get_dma_addr(*pagep);
-	/* Non-XSK always uses PAGE_SIZE. */
-	dma_sync_single_for_device(rq->pdev, addr, PAGE_SIZE, rq->buff.map_dir);
-	return true;
-}
-
 static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct page **pagep)
 {
 	dma_addr_t addr;
 
-	if (mlx5e_rx_cache_get(rq, pagep))
-		return 0;
-
 	*pagep = page_pool_dev_alloc_pages(rq->page_pool);
 	if (unlikely(!*pagep))
 		return -ENOMEM;
@@ -353,9 +303,6 @@ void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page)
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle)
 {
 	if (likely(recycle)) {
-		if (mlx5e_rx_cache_put(rq, page))
-			return;
-
 		mlx5e_page_dma_unmap(rq, page);
 		page_pool_recycle_direct(rq->page_pool, page);
 	} else {
-- 
2.39.2

