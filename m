Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709D56CCBAF
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjC1U5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjC1U5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0671D26BD
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E94DB81E72
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C043FC433EF;
        Tue, 28 Mar 2023 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037014;
        bh=0SqVWcJuQ6ckR3Kt1QYR6aleFJ0U14eEudewJWQMP50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGqr6InwfY8bCp6Q1GwEFXVXDbknY9m22GdqCwTU1A3GIJ/Jl5I+klLYfCCCWgmq1
         tpgG4yL1h0PXEz40IW+qYmmv2dSUPKBAv3p+Ety1VotOHv30LjKxOchvKD/G5KgMY/
         +53hI8LWZ45Za8J5+OeNR7Z9xymfS/bMJgadxu9PYqhHRF6ylx6+kOaylVnjrXEtW6
         dF4XkPHYyRIRnPvDeknxQD1jiQscSBvTMT8AeCsphIM8TmxQQB6fYQxTBfNk4c2ShR
         VXoS4OI94GXtlZVXl3iXALy61sFuMP0iftMdCSAa0G60gksEjOHitLuIbr/ARFUX32
         b/h8ADBT5HLwA==
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
Subject: [net-next 09/15] net/mlx5e: RX, Defer page release in striding rq for better recycling
Date:   Tue, 28 Mar 2023 13:56:17 -0700
Message-Id: <20230328205623.142075-10-saeed@kernel.org>
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

Currently, for striding RQ, fragmented pages from the page pool can
get released in two ways:

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
right before requesting new ones from the page pool. Extra care
needs to be taken for the corner cases:

* On first call, make sure that release is not called. The
  skip_release_bitmap is used for this purpose.

* On rq shutdown, make sure that all wqes that were not
  in the linked list are released.

For a single ring, single core, default MTU (1500) TCP stream
test the number of pages allocated from the cache directly
(rx_pp_recycle_cached) increases from 31 % to 98 %:

+----------------------------------------------+
| Page Pool stats (/sec)  |  Before |   After  |
+-------------------------+---------+----------+
|rx_pp_alloc_fast         | 2137754 |  2261033 |
|rx_pp_alloc_slow         |      47 |        9 |
|rx_pp_alloc_empty        |      47 |        9 |
|rx_pp_alloc_refill       |   23230 |      819 |
|rx_pp_alloc_waive        |       0 |        0 |
|rx_pp_recycle_cached     |  672182 |  2209015 |
|rx_pp_recycle_cache_full |    1789 |        0 |
|rx_pp_recycle_ring       | 1485848 |    52259 |
|rx_pp_recycle_ring_full  |    3003 |      584 |
+----------------------------------------------+

With this patch, the performance in striding rq for the above test is
back to baseline.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 21 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  8 ++++---
 4 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index b621f735cdc3..a047a2a4ddac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -121,9 +121,9 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 
 	mlx5e_reset_icosq_cc_pc(icosq);
 
-	mlx5e_free_rx_in_progress_descs(rq);
+	mlx5e_free_rx_missing_descs(rq);
 	if (xskrq)
-		mlx5e_free_rx_in_progress_descs(xskrq);
+		mlx5e_free_rx_missing_descs(xskrq);
 
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
 	mlx5e_activate_icosq(icosq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index cd7779a9d046..651be7aaf7d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -69,7 +69,7 @@ INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq));
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
-void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
+void mlx5e_free_rx_missing_descs(struct mlx5e_rq *rq);
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index eca9a11454e5..53eef689f225 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -301,6 +301,15 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 	if (!rq->mpwqe.info)
 		return -ENOMEM;
 
+	/* For deferred page release (release right before alloc), make sure
+	 * that on first round release is not called.
+	 */
+	for (int i = 0; i < wq_sz; i++) {
+		struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, i);
+
+		bitmap_fill(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
+	}
+
 	mlx5e_build_umr_wqe(rq, rq->icosq, &rq->mpwqe.umr_wqe);
 
 	return 0;
@@ -1112,7 +1121,7 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 	return -ETIMEDOUT;
 }
 
-void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq)
+void mlx5e_free_rx_missing_descs(struct mlx5e_rq *rq)
 {
 	struct mlx5_wq_ll *wq;
 	u16 head;
@@ -1124,8 +1133,12 @@ void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq)
 	wq = &rq->mpwqe.wq;
 	head = wq->head;
 
-	/* Outstanding UMR WQEs (in progress) start at wq->head */
-	for (i = 0; i < rq->mpwqe.umr_in_progress; i++) {
+	/* Release WQEs that are in missing state: they have been
+	 * popped from the list after completion but were not freed
+	 * due to deferred release.
+	 * Also free the linked-list reserved entry, hence the "+ 1".
+	 */
+	for (i = 0; i < mlx5_wq_ll_missing(wq) + 1; i++) {
 		rq->dealloc_wqe(rq, head);
 		head = mlx5_wq_ll_get_wqe_next_ix(wq, head);
 	}
@@ -1152,7 +1165,7 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
 
-		mlx5e_free_rx_in_progress_descs(rq);
+		mlx5e_free_rx_missing_descs(rq);
 
 		while (!mlx5_wq_ll_is_empty(wq)) {
 			struct mlx5e_rx_wqe_ll *wqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index eab8cba33ce4..73bc373bf27d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -983,6 +983,11 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	head = rq->mpwqe.actual_wq_head;
 	i = missing;
 	do {
+		struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, head);
+
+		/* Deferred free for better page pool cache usage. */
+		mlx5e_free_rx_mpwqe(rq, wi, true);
+
 		alloc_err = rq->xsk_pool ? mlx5e_xsk_alloc_rx_mpwqe(rq, head) :
 					   mlx5e_alloc_rx_mpwqe(rq, head);
 
@@ -1855,7 +1860,6 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	wq  = &rq->mpwqe.wq;
 	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
-	mlx5e_free_rx_mpwqe(rq, wi, true);
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
 }
 
@@ -2173,7 +2177,6 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	wq  = &rq->mpwqe.wq;
 	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
-	mlx5e_free_rx_mpwqe(rq, wi, true);
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
 }
 
@@ -2233,7 +2236,6 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 
 	wq  = &rq->mpwqe.wq;
 	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
-	mlx5e_free_rx_mpwqe(rq, wi, true);
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
 }
 
-- 
2.39.2

