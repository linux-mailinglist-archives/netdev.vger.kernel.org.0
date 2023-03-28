Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA286CCBB3
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjC1U5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjC1U5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5700C211F
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA9CD6195E
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32130C4339C;
        Tue, 28 Mar 2023 20:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037020;
        bh=V99hzGdcL4x5tPbDwgGODHmZuwj9GB3xclbylJAf9Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8i15LCviWap+e+t3OvDsZu7WJsYx7iwvgCyNnWJxNiOIT4LR9sdAIAt7vBrom0qm
         /R8/R9DTZX4Rf10z5os8hhsse3/BkeXv4B17Vbi81YJ9N7rPdBzCMSMsBZxQTlEzO0
         6JDNqIxeb8bLbDiqnqCe9gfedlDki1lHvU2Te/iz3bqOUO9fNfY2Z+Kn5aTArtjzhK
         8xTdYqgOA9Z0M6p70d1Q+o3OfRlFpzvl4Necl74MothRJf32opTDo8JwhZj2+cok0N
         FK7efHBKVzzRZC0v8iYVwkDE9+iKMUsUhbHW2QUspSoFDmEbQrVF7zZb+fzCIMjK6Z
         OK0PzeSpc4tbQ==
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
Subject: [net-next 14/15] net/mlx5e: RX, Break the wqe bulk refill in smaller chunks
Date:   Tue, 28 Mar 2023 13:56:22 -0700
Message-Id: <20230328205623.142075-15-saeed@kernel.org>
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

To avoid overflowing the page pool's cache, don't release the
whole bulk which is usually larger than the cache refill size.
Group release+alloc instead into cache refill units that
allow releasing to the cache and then allocating from the cache.

A refill_unit variable is added as a iteration unit over the
wqe_bulk when doing release+alloc.

For a single ring, single core, default MTU (1500) TCP stream
test the number of pages allocated from the cache directly
(rx_pp_recycle_cached) increases from 0% to 52%:

+---------------------------------------------+
| Page Pool stats (/sec)  |  Before |   After |
+-------------------------+---------+---------+
|rx_pp_alloc_fast         | 2145422 | 2193802 |
|rx_pp_alloc_slow         |       2 |       0 |
|rx_pp_alloc_empty        |       2 |       0 |
|rx_pp_alloc_refill       |   34059 |   16634 |
|rx_pp_alloc_waive        |       0 |       0 |
|rx_pp_recycle_cached     |       0 | 1145818 |
|rx_pp_recycle_cache_full |       0 |       0 |
|rx_pp_recycle_ring       | 2179361 | 1064616 |
|rx_pp_recycle_ring_full  |     121 |       0 |
+---------------------------------------------+

With this patch, the performance for legacy rq for the above test is
back to baseline.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  8 +++++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 28 +++++++++++++++++--
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a087c433366b..ba615b74bb8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -671,6 +671,7 @@ struct mlx5e_rq_frags_info {
 	u8 num_frags;
 	u8 log_num_frags;
 	u16 wqe_bulk;
+	u16 refill_unit;
 	u8 wqe_index_mask;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 40218d77ef34..31f3c6e51d9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -674,6 +674,7 @@ static void mlx5e_rx_compute_wqe_bulk_params(struct mlx5e_params *params,
 	u32 bulk_bound_rq_size_in_bytes;
 	u32 sum_frag_strides = 0;
 	u32 wqe_bulk_in_bytes;
+	u16 split_factor;
 	u32 wqe_bulk;
 	int i;
 
@@ -702,6 +703,10 @@ static void mlx5e_rx_compute_wqe_bulk_params(struct mlx5e_params *params,
 	 * by older WQEs.
 	 */
 	info->wqe_bulk = max_t(u16, info->wqe_index_mask + 1, wqe_bulk);
+
+	split_factor = DIV_ROUND_UP(MAX_WQE_BULK_BYTES(params->xdp_prog),
+				    PP_ALLOC_CACHE_REFILL * PAGE_SIZE);
+	info->refill_unit = DIV_ROUND_UP(info->wqe_bulk, split_factor);
 }
 
 #define DEFAULT_FRAG_SIZE (2048)
@@ -817,7 +822,8 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	 */
 	mlx5e_rx_compute_wqe_bulk_params(params, info);
 
-	mlx5_core_dbg(mdev, "%s: wqe_bulk = %u\n", __func__, info->wqe_bulk);
+	mlx5_core_dbg(mdev, "%s: wqe_bulk = %u, wqe_bulk_refill_unit = %u\n",
+		      __func__, info->wqe_bulk, info->refill_unit);
 
 	info->log_num_frags = order_base_2(info->num_frags);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9c5270eb9dc6..df5dbef9e5ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -449,6 +449,31 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 	return i;
 }
 
+static int mlx5e_refill_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
+{
+	int remaining = wqe_bulk;
+	int i = 0;
+
+	/* The WQE bulk is split into smaller bulks that are sized
+	 * according to the page pool cache refill size to avoid overflowing
+	 * the page pool cache due to too many page releases at once.
+	 */
+	do {
+		int refill = min_t(u16, rq->wqe.info.refill_unit, remaining);
+		int alloc_count;
+
+		mlx5e_free_rx_wqes(rq, ix + i, refill);
+		alloc_count = mlx5e_alloc_rx_wqes(rq, ix + i, refill);
+		i += alloc_count;
+		if (unlikely(alloc_count != refill))
+			break;
+
+		remaining -= refill;
+	} while (remaining);
+
+	return i;
+}
+
 static inline void
 mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   struct page *page, u32 frag_offset, u32 len,
@@ -837,8 +862,7 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	wqe_bulk -= (head + wqe_bulk) & rq->wqe.info.wqe_index_mask;
 
 	if (!rq->xsk_pool) {
-		mlx5e_free_rx_wqes(rq, head, wqe_bulk);
-		count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
+		count = mlx5e_refill_rx_wqes(rq, head, wqe_bulk);
 	} else if (likely(!rq->xsk_pool->dma_need_sync)) {
 		mlx5e_xsk_free_rx_wqes(rq, head, wqe_bulk);
 		count = mlx5e_xsk_alloc_rx_wqes_batched(rq, head, wqe_bulk);
-- 
2.39.2

