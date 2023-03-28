Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856F66CCBB1
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjC1U5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjC1U5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55B130F6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31973B81E6F
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB806C433EF;
        Tue, 28 Mar 2023 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037017;
        bh=Dd+ANndra4TNzK2nlJZI0Sf3aGqVqxXlUMe2cY2C9os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIX01ZdG5tP36LTlWnBjqFkPyirBACYL0dl8PxncRfXVDJPmLTLVhxsETntxlr/Xd
         M52vm0JFjjLX+PlRvnIub7Rhhiv731IrH0J39pX/mLIx1bgPpBTYXZ9rjSqROmpZw7
         LuGYOLaWEIgGw2m54+ZCRbmYqVPi3xl43aE9Vz01Dk6zyHmvxyoOoAF/al4WbdcRoE
         O4JDBhr5C4vuAXn+PfKWTZIvJyi0aa9BPVnMIF+9viIolTihTK51hu1QMngvnLyjl8
         cly23UiJC9ju6JS+Wefi8i9ZynVG9aH/J6E9jDrw063iTZsC/+IEfQk05DPomb/g5o
         IL/oKZ9KMoaVg==
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
Subject: [net-next 11/15] net/mlx5e: RX, Defer page release in legacy rq for better recycling
Date:   Tue, 28 Mar 2023 13:56:19 -0700
Message-Id: <20230328205623.142075-12-saeed@kernel.org>
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

Currently, fragmented pages from the page pool can be released
in two ways:

1) In the mlx5e driver when trimming off the unused fragments AND the
associated skb fragments have been released. This path allows
recycling of pages to the page pool cache (allow_direct == true).

2) On the skb release path (last fragment release), which
will always release pages to the page pool ring
(allow_direct == false).

Whichever is releasing the last fragment will be decisive on
where the page gets released: the cache or the ring. So we
obviously want to maximize for doing the release from 1.

This patch does that by deferring the release of page fragments
right before requesting new ones from the page pool. A flag is
added to make sure that there's no release before first alloc
and that XDP_TX fragments are not released prematurely.

This is a preparation patch that doesn't unlock the performance
improvements yet. A followup patch will do that.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 66 ++++++++++++-------
 4 files changed, 66 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 9ef4b7163e5a..613a7daf9595 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -607,6 +607,7 @@ struct mlx5e_frag_page {
 
 enum mlx5e_wqe_frag_flag {
 	MLX5E_WQE_FRAG_LAST_IN_PAGE,
+	MLX5E_WQE_FRAG_SKIP_RELEASE,
 };
 
 struct mlx5e_wqe_frag_info {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 3cde264cbe4e..d97e6df66f45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -189,6 +189,7 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 
 		addr = xsk_buff_xdp_get_frame_dma(*frag->xskp);
 		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
+		frag->flags &= ~BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 	}
 
 	return alloc;
@@ -215,6 +216,7 @@ int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 
 		addr = xsk_buff_xdp_get_frame_dma(*frag->xskp);
 		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
+		frag->flags &= ~BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 	}
 
 	return wqe_bulk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bb1cbf008876..3cf7d2b59037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -520,6 +520,9 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 
 	next_frag.frag_page = &rq->wqe.alloc_units->frag_pages[0];
 
+	/* Skip first release due to deferred release. */
+	next_frag.flags = BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
+
 	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
 		struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 		struct mlx5e_wqe_frag_info *frag =
@@ -558,8 +561,14 @@ static void mlx5e_init_xsk_buffs(struct mlx5e_rq *rq)
 	/* Considering the above assumptions a fragment maps to a single
 	 * xsk_buff.
 	 */
-	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++)
+	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
 		rq->wqe.frags[i].xskp = &rq->wqe.alloc_units->xsk_buffs[i];
+
+		/* Skip first release due to deferred release as WQES are
+		 * not allocated yet.
+		 */
+		rq->wqe.frags[i].flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
+	}
 }
 
 static int mlx5e_init_wqe_alloc_info(struct mlx5e_rq *rq, int node)
@@ -1183,12 +1192,21 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 						0, true);
 	} else {
 		struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+		u16 missing = mlx5_wq_cyc_missing(wq);
+		u16 head = mlx5_wq_cyc_get_head(wq);
 
 		while (!mlx5_wq_cyc_is_empty(wq)) {
 			wqe_ix = mlx5_wq_cyc_get_tail(wq);
 			rq->dealloc_wqe(rq, wqe_ix);
 			mlx5_wq_cyc_pop(wq);
 		}
+		/* Missing slots might also contain unreleased pages due to
+		 * deferred release.
+		 */
+		while (missing--) {
+			wqe_ix = mlx5_wq_cyc_ctr2ix(wq, head++);
+			rq->dealloc_wqe(rq, wqe_ix);
+		}
 	}
 
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f98212596c1e..0675ffa5f8df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -319,11 +319,21 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 	return err;
 }
 
+static bool mlx5e_frag_can_release(struct mlx5e_wqe_frag_info *frag)
+{
+#define CAN_RELEASE_MASK \
+	(BIT(MLX5E_WQE_FRAG_LAST_IN_PAGE) | BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))
+
+#define CAN_RELEASE_VALUE BIT(MLX5E_WQE_FRAG_LAST_IN_PAGE)
+
+	return (frag->flags & CAN_RELEASE_MASK) == CAN_RELEASE_VALUE;
+}
+
 static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
 				     struct mlx5e_wqe_frag_info *frag,
 				     bool recycle)
 {
-	if (frag->flags & BIT(MLX5E_WQE_FRAG_LAST_IN_PAGE))
+	if (mlx5e_frag_can_release(frag))
 		mlx5e_page_release_fragmented(rq, frag->frag_page, recycle);
 }
 
@@ -347,6 +357,8 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 		if (unlikely(err))
 			goto free_frags;
 
+		frag->flags &= ~BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
+
 		headroom = i == 0 ? rq->buff.headroom : 0;
 		addr = page_pool_get_dma_addr(frag->frag_page->page);
 		wqe->data[i].addr = cpu_to_be64(addr + frag->offset + headroom);
@@ -367,7 +379,7 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 {
 	int i;
 
-	if (rq->xsk_pool) {
+	if (rq->xsk_pool && !(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))) {
 		/* The `recycle` parameter is ignored, and the page is always
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
@@ -387,6 +399,20 @@ static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 	mlx5e_free_rx_wqe(rq, wi, false);
 }
 
+static void mlx5e_free_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
+{
+	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+	int i;
+
+	for (i = 0; i < wqe_bulk; i++) {
+		int j = mlx5_wq_cyc_ctr2ix(wq, ix + i);
+		struct mlx5e_wqe_frag_info *wi;
+
+		wi = get_frag(rq, j);
+		mlx5e_free_rx_wqe(rq, wi, true);
+	}
+}
+
 static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
@@ -792,6 +818,8 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	 */
 	wqe_bulk -= (head + wqe_bulk) & rq->wqe.info.wqe_index_mask;
 
+	mlx5e_free_rx_wqes(rq, head, wqe_bulk);
+
 	if (!rq->xsk_pool)
 		count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
 	else if (likely(!rq->xsk_pool->dma_need_sync))
@@ -1727,7 +1755,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		mlx5e_handle_rx_err_cqe(rq, cqe);
-		goto free_wqe;
+		goto wq_cyc_pop;
 	}
 
 	skb = INDIRECT_CALL_3(rq->wqe.skb_from_cqe,
@@ -1741,9 +1769,9 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 			/* do not return page to cache,
 			 * it will be returned on XDP_TX completion.
 			 */
-			goto wq_cyc_pop;
+			wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 		}
-		goto free_wqe;
+		goto wq_cyc_pop;
 	}
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
@@ -1751,13 +1779,11 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (mlx5e_cqe_regb_chain(cqe))
 		if (!mlx5e_tc_update_skb_nic(cqe, skb)) {
 			dev_kfree_skb_any(skb);
-			goto free_wqe;
+			goto wq_cyc_pop;
 		}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
-free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
 wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
@@ -1781,7 +1807,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		mlx5e_handle_rx_err_cqe(rq, cqe);
-		goto free_wqe;
+		goto wq_cyc_pop;
 	}
 
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
@@ -1794,9 +1820,9 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 			/* do not return page to cache,
 			 * it will be returned on XDP_TX completion.
 			 */
-			goto wq_cyc_pop;
+			wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 		}
-		goto free_wqe;
+		goto wq_cyc_pop;
 	}
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
@@ -1806,8 +1832,6 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	mlx5e_rep_tc_receive(cqe, rq, skb);
 
-free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
 wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
@@ -2454,7 +2478,7 @@ static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		rq->stats->wqe_err++;
-		goto wq_free_wqe;
+		goto wq_cyc_pop;
 	}
 
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
@@ -2462,17 +2486,16 @@ static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 			      mlx5e_skb_from_cqe_nonlinear,
 			      rq, wi, cqe, cqe_bcnt);
 	if (!skb)
-		goto wq_free_wqe;
+		goto wq_cyc_pop;
 
 	mlx5i_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 	if (unlikely(!skb->dev)) {
 		dev_kfree_skb_any(skb);
-		goto wq_free_wqe;
+		goto wq_cyc_pop;
 	}
 	napi_gro_receive(rq->cq.napi, skb);
 
-wq_free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
+wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
 
@@ -2547,12 +2570,12 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		rq->stats->wqe_err++;
-		goto free_wqe;
+		goto wq_cyc_pop;
 	}
 
 	skb = mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe, cqe_bcnt);
 	if (!skb)
-		goto free_wqe;
+		goto wq_cyc_pop;
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 	skb_push(skb, ETH_HLEN);
@@ -2561,8 +2584,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 				 rq->netdev->devlink_port);
 	dev_kfree_skb_any(skb);
 
-free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, false);
+wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
 
-- 
2.39.2

