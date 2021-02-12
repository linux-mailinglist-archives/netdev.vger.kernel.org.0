Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268A231986D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBLC6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8677664E7A;
        Fri, 12 Feb 2021 02:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098643;
        bh=49IERqhuOVhrIKQmqvWwTL4rSgODHaCPF/7CJn5odV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf/N3b3yCir0tpF5Qmdlan7poOESMKOTXyzXhiAVoGqPzXMkiABjjHTNkzd82ciQf
         fai5WsWyySGJggtYEp5sHpYys9D8Y/CAW2VfkX7ieiYpVg6+d3cvLDyHB0fEIyIavs
         Hi7y4yWvmopa99+c0+oL6cNhge82lemAKaDBN89odYNjHdqyxOlrsIWesFUHFKfGvX
         YMFtvabWudN4zNLITvt6XsbyFPzpfaqxUBgRpinuw9iNRprPZo6A3toUxGKAoTZsxo
         cc/l2u1kLWMwGfzPSYD7U6EOHGDh9Mt7EdrifDuqq6sSyF8pZC2itwnxpFNSrNsWWt
         6freght3t9JsA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/15] net/mlx5e: Replace synchronize_rcu with synchronize_net
Date:   Thu, 11 Feb 2021 18:56:33 -0800
Message-Id: <20210212025641.323844-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

The commit cited below switched from using napi_synchronize to
synchronize_rcu to have a guarantee that it will finish in finite time.
However, on average, synchronize_rcu takes more time than
napi_synchronize. Given that it's called multiple times per channel on
deactivation, it accumulates to a significant amount, which causes
timeouts in some applications (for example, when using bonding with
NetworkManager).

This commit replaces synchronize_rcu with synchronize_net, which is
faster when called under rtnl_lock, allowing to speed up the described
flow.

Fixes: 9c25a22dfb00 ("net/mlx5e: Use synchronize_rcu to sync with NAPI")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c    | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index d487e5e37162..8d991c3b7a50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -83,7 +83,7 @@ static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
 
 	clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
 	/* Let other device's napi(s) and XSK wakeups see our new state. */
-	synchronize_rcu();
+	synchronize_net();
 }
 
 static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index d87c345878d3..f4bce1365639 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -111,7 +111,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
+	synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 6a1d82503ef8..0f13b661f7f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -663,7 +663,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_ctx);
 	set_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags);
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, NULL);
-	synchronize_rcu(); /* Sync with NAPI */
+	synchronize_net(); /* Sync with NAPI */
 	if (!cancel_work_sync(&priv_rx->rule.work))
 		/* completion is needed, as the priv_rx in the add flow
 		 * is maintained on the wqe info (wi), not on the socket.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5052820f7a51..3edc826cc6bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -915,7 +915,7 @@ void mlx5e_activate_rq(struct mlx5e_rq *rq)
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	synchronize_rcu(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
+	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 }
 
 void mlx5e_close_rq(struct mlx5e_rq *rq)
@@ -1349,7 +1349,7 @@ void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 	struct mlx5_wq_cyc *wq = &sq->wq;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_rcu(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
+	synchronize_net(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
 
 	mlx5e_tx_disable_queue(sq->txq);
 
@@ -1424,7 +1424,7 @@ void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
-	synchronize_rcu(); /* Sync with NAPI. */
+	synchronize_net(); /* Sync with NAPI. */
 }
 
 void mlx5e_close_icosq(struct mlx5e_icosq *sq)
@@ -1503,7 +1503,7 @@ void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 	struct mlx5e_channel *c = sq->channel;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_rcu(); /* Sync with NAPI. */
+	synchronize_net(); /* Sync with NAPI. */
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
-- 
2.29.2

