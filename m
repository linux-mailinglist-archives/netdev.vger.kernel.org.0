Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C39D273775
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgIVAbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728963AbgIVAbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:14 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9DC523A9F;
        Tue, 22 Sep 2020 00:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734673;
        bh=B5Ckl8S+NxCrNoLmIKXHy3mTQU8RLFDo33X38U3/ULo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qG0v7M5uAfpQPhCuNhSsirSqs/ti5VLIZgOXvzon1dSAiCpwuXqMlXED98yWaXRu0
         +E39yym0cj3XjafO2l01TF3R+bzpGo07HmuOmXjihhnAyPiJAIomv1KwQLbV/BZMez
         MORCG+oQEjshfBEKCfnYK2/87diTTwx1bQYqICYo=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 03/15] net/mlx5e: Use synchronize_rcu to sync with NAPI
Date:   Mon, 21 Sep 2020 17:30:49 -0700
Message-Id: <20200922003101.529117-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As described in the previous commit, napi_synchronize doesn't quite fit
the purpose when we just need to wait until the currently running NAPI
quits. Its implementation waits until NAPI is not running by polling and
waiting for 1ms in between. In cases where we need to deactivate one
queue (e.g., recovery flows) or where we deactivate them one-by-one
(deactivate channel flow), we may get stuck in napi_synchronize forever
if other queues keep NAPI active, causing a soft lockup. Depending on
kernel configuration (CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC), it may result
in a kernel panic.

To fix the issue, use synchronize_rcu to wait for NAPI to quit, and wrap
the whole NAPI in rcu_read_lock.

Fixes: acc6c5953af1 ("net/mlx5e: Split open/close channels to stages")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 14 ++------------
 .../ethernet/mellanox/mlx5/core/en/xsk/setup.c  |  3 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 12 ++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 12 ++----------
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c   | 17 +++++++++++++----
 5 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index a33a1f762c70..40db27bf790b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -31,7 +31,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 {
 	struct xdp_buff *xdp = wi->umr.dma_info[page_idx].xsk;
 	u32 cqe_bcnt32 = cqe_bcnt;
-	bool consumed;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -51,10 +50,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	xsk_buff_dma_sync_for_cpu(xdp);
 	prefetch(xdp->data);
 
-	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp);
-	rcu_read_unlock();
-
 	/* Possible flows:
 	 * - XDP_REDIRECT to XSKMAP:
 	 *   The page is owned by the userspace from now.
@@ -70,7 +65,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	 * allocated first from the Reuse Ring, so it has enough space.
 	 */
 
-	if (likely(consumed)) {
+	if (likely(mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
@@ -88,7 +83,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      u32 cqe_bcnt)
 {
 	struct xdp_buff *xdp = wi->di->xsk;
-	bool consumed;
 
 	/* wi->offset is not used in this function, because xdp->data and the
 	 * DMA address point directly to the necessary place. Furthermore, the
@@ -107,11 +101,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 		return NULL;
 	}
 
-	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt, xdp);
-	rcu_read_unlock();
-
-	if (likely(consumed))
+	if (likely(mlx5e_xdp_handle(rq, NULL, &cqe_bcnt, xdp)))
 		return NULL; /* page/packet was consumed by XDP */
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index dd9df519d383..55e65a438de7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -106,8 +106,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	napi_synchronize(&c->napi);
-	synchronize_rcu(); /* Sync with the XSK wakeup. */
+	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bde97b108db5..917c28e7f29e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -873,7 +873,7 @@ void mlx5e_activate_rq(struct mlx5e_rq *rq)
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	napi_synchronize(&rq->channel->napi); /* prevent mlx5e_post_rx_wqes */
+	synchronize_rcu(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 }
 
 void mlx5e_close_rq(struct mlx5e_rq *rq)
@@ -1318,12 +1318,10 @@ void mlx5e_tx_disable_queue(struct netdev_queue *txq)
 
 static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	/* prevent netif_tx_wake_queue */
-	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
 
 	mlx5e_tx_disable_queue(sq->txq);
 
@@ -1398,10 +1396,8 @@ void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
-	struct mlx5e_channel *c = icosq->channel;
-
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
-	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with NAPI. */
 }
 
 void mlx5e_close_icosq(struct mlx5e_icosq *sq)
@@ -1480,7 +1476,7 @@ void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 	struct mlx5e_channel *c = sq->channel;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with NAPI. */
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 65828af120b7..99d102c035b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1132,7 +1132,6 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	void *va, *data;
-	bool consumed;
 	u32 frag_size;
 
 	va             = page_address(di->page) + wi->offset;
@@ -1144,11 +1143,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
 
-	rcu_read_lock();
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-	consumed = mlx5e_xdp_handle(rq, di, &cqe_bcnt, &xdp);
-	rcu_read_unlock();
-	if (consumed)
+	if (mlx5e_xdp_handle(rq, di, &cqe_bcnt, &xdp))
 		return NULL; /* page/packet was consumed by XDP */
 
 	rx_headroom = xdp.data - xdp.data_hard_start;
@@ -1438,7 +1434,6 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
-	bool consumed;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -1455,11 +1450,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
 
-	rcu_read_lock();
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
-	consumed = mlx5e_xdp_handle(rq, di, &cqe_bcnt32, &xdp);
-	rcu_read_unlock();
-	if (consumed) {
+	if (mlx5e_xdp_handle(rq, di, &cqe_bcnt32, &xdp)) {
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index de10b06bade5..d5868670f8a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -121,13 +121,17 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	struct mlx5e_xdpsq *xsksq = &c->xsksq;
 	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
-	bool xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 	bool aff_change = false;
 	bool busy_xsk = false;
 	bool busy = false;
 	int work_done = 0;
+	bool xsk_open;
 	int i;
 
+	rcu_read_lock();
+
+	xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+
 	ch_stats->poll++;
 
 	for (i = 0; i < c->num_tc; i++)
@@ -167,8 +171,10 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	busy |= busy_xsk;
 
 	if (busy) {
-		if (likely(mlx5e_channel_no_affinity_change(c)))
-			return budget;
+		if (likely(mlx5e_channel_no_affinity_change(c))) {
+			work_done = budget;
+			goto out;
+		}
 		ch_stats->aff_change++;
 		aff_change = true;
 		if (budget && work_done == budget)
@@ -176,7 +182,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	}
 
 	if (unlikely(!napi_complete_done(napi, work_done)))
-		return work_done;
+		goto out;
 
 	ch_stats->arm++;
 
@@ -203,6 +209,9 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		ch_stats->force_irq++;
 	}
 
+out:
+	rcu_read_unlock();
+
 	return work_done;
 }
 
-- 
2.26.2

