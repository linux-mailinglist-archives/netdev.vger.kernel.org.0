Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFD02D337C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgLHUTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgLHUTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:19:51 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 04/15] net/mlx5e: Allow SQ outside of channel context
Date:   Tue,  8 Dec 2020 11:35:44 -0800
Message-Id: <20201208193555.674504-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

In order to be able to create an SQ outside of a channel context, remove
sq->channel direct pointer. This requires adding a direct pointer to:
netdevice, priv and mlx5_core in order to support SQs that are part of
mlx5e_channel. Use channel_stats from the corresponding CQ.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 +++-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  4 +---
 .../ethernet/mellanox/mlx5/core/en/health.h   |  2 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       | 20 +++++++++----------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +++++----
 7 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3dec0731f4da..c014e8ff66aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -369,10 +369,12 @@ struct mlx5e_txqsq {
 	unsigned int               hw_mtu;
 	struct hwtstamp_config    *tstamp;
 	struct mlx5_clock         *clock;
+	struct net_device         *netdev;
+	struct mlx5_core_dev      *mdev;
+	struct mlx5e_priv         *priv;
 
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
-	struct mlx5e_channel      *channel;
 	int                        ch_ix;
 	int                        txq_ix;
 	u32                        rate_limit;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index e8fc535e6f91..718f8c0a4f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -157,10 +157,8 @@ void mlx5e_health_channels_update(struct mlx5e_priv *priv)
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
 }
 
-int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
+int mlx5e_health_sq_to_ready(struct mlx5_core_dev *mdev, struct net_device *dev, u32 sqn)
 {
-	struct mlx5_core_dev *mdev = channel->mdev;
-	struct net_device *dev = channel->netdev;
 	struct mlx5e_modify_sq_param msp = {};
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 48d0232ce654..f88fbbe06995 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -42,7 +42,7 @@ struct mlx5e_err_ctx {
 	void *ctx;
 };
 
-int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
+int mlx5e_health_sq_to_ready(struct mlx5_core_dev *mdev, struct net_device *dev, u32 sqn);
 int mlx5e_health_channel_eq_recover(struct net_device *dev, struct mlx5_eq_comp *eq,
 				    struct mlx5e_ch_stats *stats);
 int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 0206e033a271..d80bbd17e5f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -87,7 +87,7 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 
 	/* At this point, both the rq and the icosq are disabled */
 
-	err = mlx5e_health_sq_to_ready(icosq->channel, icosq->sqn);
+	err = mlx5e_health_sq_to_ready(mdev, dev, icosq->sqn);
 	if (err)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 97bfeae17dec..88b3b21d1068 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -15,7 +15,7 @@ static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 		msleep(20);
 	}
 
-	netdev_err(sq->channel->netdev,
+	netdev_err(sq->netdev,
 		   "Wait for SQ 0x%x flush timeout (sq cc = 0x%x, sq pc = 0x%x)\n",
 		   sq->sqn, sq->cc, sq->pc);
 
@@ -41,8 +41,8 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	int err;
 
 	sq = ctx;
-	mdev = sq->channel->mdev;
-	dev = sq->channel->netdev;
+	mdev = sq->mdev;
+	dev = sq->netdev;
 
 	if (!test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 		return 0;
@@ -68,7 +68,7 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	 * pending WQEs. SQ can safely reset the SQ.
 	 */
 
-	err = mlx5e_health_sq_to_ready(sq->channel, sq->sqn);
+	err = mlx5e_health_sq_to_ready(mdev, dev, sq->sqn);
 	if (err)
 		goto out;
 
@@ -99,8 +99,8 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	to_ctx = ctx;
 	sq = to_ctx->sq;
 	eq = sq->cq.mcq.eq;
-	priv = sq->channel->priv;
-	err = mlx5e_health_channel_eq_recover(sq->channel->netdev, eq, sq->channel->stats);
+	priv = sq->priv;
+	err = mlx5e_health_channel_eq_recover(sq->netdev, eq, sq->cq.ch_stats);
 	if (!err) {
 		to_ctx->status = 0; /* this sq recovered */
 		return err;
@@ -144,8 +144,8 @@ static int
 mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
 					struct mlx5e_txqsq *sq, int tc)
 {
-	struct mlx5e_priv *priv = sq->channel->priv;
 	bool stopped = netif_xmit_stopped(sq->txq);
+	struct mlx5e_priv *priv = sq->priv;
 	u8 state;
 	int err;
 
@@ -396,8 +396,8 @@ static int mlx5e_tx_reporter_dump(struct devlink_health_reporter *reporter,
 
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_priv *priv = sq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_priv *priv = sq->priv;
 	struct mlx5e_err_ctx err_ctx = {};
 
 	err_ctx.ctx = sq;
@@ -410,9 +410,9 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_priv *priv = sq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
 	struct mlx5e_tx_timeout_ctx to_ctx = {};
+	struct mlx5e_priv *priv = sq->priv;
 	struct mlx5e_err_ctx err_ctx = {};
 
 	to_ctx.sq = sq;
@@ -421,7 +421,7 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	err_ctx.dump = mlx5e_tx_reporter_dump_sq;
 	snprintf(err_str, sizeof(err_str),
 		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u",
-		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 sq->ch_ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
 		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
 
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index f51c04284e4d..2b51d3222ca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -276,7 +276,7 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
 		goto err_out;
 
-	if (mlx5_accel_is_ktls_tx(sq->channel->mdev))
+	if (mlx5_accel_is_ktls_tx(sq->mdev))
 		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, datalen, state);
 
 	/* FPGA */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 68c1497d9506..15750119b413 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1132,7 +1132,9 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->tstamp    = c->tstamp;
 	sq->clock     = &mdev->clock;
 	sq->mkey_be   = c->mkey_be;
-	sq->channel   = c;
+	sq->netdev    = c->netdev;
+	sq->mdev      = c->mdev;
+	sq->priv      = c->priv;
 	sq->ch_ix     = c->ix;
 	sq->txq_ix    = txq_ix;
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
@@ -1332,7 +1334,7 @@ static int mlx5e_open_txqsq(struct mlx5e_channel *c,
 
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
 {
-	sq->txq = netdev_get_tx_queue(sq->channel->netdev, sq->txq_ix);
+	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
@@ -1370,8 +1372,7 @@ static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 
 static void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
-	struct mlx5_core_dev *mdev = c->mdev;
+	struct mlx5_core_dev *mdev = sq->mdev;
 	struct mlx5_rate_limit rl = {0};
 
 	cancel_work_sync(&sq->dim.work);
-- 
2.26.2

