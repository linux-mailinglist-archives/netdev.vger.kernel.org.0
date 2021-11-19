Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79FF45777A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhKSUBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234486AbhKSUB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 662E261B43;
        Fri, 19 Nov 2021 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351902;
        bh=1LEK1YVPSbTm+4SuHZ3kd+zJUvrgAoTXhFxCLyFn4ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdnKwJDriCgb4zUZS6StUOKzNleebSp8NBUkhMYJKZM+MjP5OW7kM0DQQuTaQuWHs
         SDufHkkFP1yKI4I3bIFaR8wyrsyoJWrpj6MAeuE6qPW4/Nhbh6BpAfik5Tyy/WjQo2
         xr+0/T0HJqqFEHw7pqFdsmo7zx/YFU/F3HW/F79H0HTy3Sw50T1p/46tSc50EjalQc
         ValodavcaEnSis4yQJ0NGlAX7D+a8migACOz2GucTZr+sIlIJSPVvpbc3WeuO2xsKL
         YTE7cFXQCCwVTu6AYwKDDM4rKw5kzezTecG6lJQFG2TJqpGGL2pyizdtb01oCM0M4X
         wDYDAs/yU4HsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net 09/10] net/mlx5e: Call synchronize_net outside of deactivating a queue
Date:   Fri, 19 Nov 2021 11:58:12 -0800
Message-Id: <20211119195813.739586-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This patch moves synchronize_net outside of queue deactivate functions.
It prepares the code for the following fix that will convert to calling
synchronize_net only once when deactivating channels.

This patch also reduces the number of synchronize_net calls by squashing
together the calls in mlx5e_deactivate_channel, however, the real
reduction will happen in the next patch.

Also, mlx5e_deactivate_txqsq got separated into two functions, and
mlx5e_qos_deactivate_queues got separated into two sections and
to make it possible to move synchronize_net outside.

Fixes: 9c25a22dfb00 ("net/mlx5e: Use synchronize_rcu to sync with NAPI")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 ++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 16 ++++---
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 30 ++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  2 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |  3 ++
 .../mellanox/mlx5/core/en/reporter_tx.c       |  3 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 44 ++++++++++++-------
 8 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a0a5d6321098..837354118df8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1077,8 +1077,10 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		     struct mlx5e_params *params, struct mlx5e_sq_param *param,
 		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id,
 		     struct mlx5e_sq_stats *sq_stats);
-void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
-void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_enable_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_start_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_disable_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_stop_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_free_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_tx_disable_queue(struct netdev_queue *txq);
 int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 18d542b1c5cb..f190c5437294 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -731,8 +731,10 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	napi_enable(&c->napi);
 
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
-		for (tc = 0; tc < c->num_tc; tc++)
-			mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
+		for (tc = 0; tc < c->num_tc; tc++) {
+			mlx5e_enable_txqsq(&c->ptpsq[tc].txqsq);
+			mlx5e_start_txqsq(&c->ptpsq[tc].txqsq);
+		}
 	}
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		mlx5e_ptp_rx_set_fs(c->priv);
@@ -748,10 +750,14 @@ void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
 		mlx5e_deactivate_rq(&c->rq);
 
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
-		for (tc = 0; tc < c->num_tc; tc++)
-			mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
-	}
+		for (tc = 0; tc < c->num_tc; tc++) {
+			mlx5e_disable_txqsq(&c->ptpsq[tc].txqsq);
 
+			/* Sync with NAPI to prevent netif_tx_wake_queue. */
+			synchronize_net();
+			mlx5e_stop_txqsq(&c->ptpsq[tc].txqsq);
+		}
+	}
 	napi_disable(&c->napi);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 50977f01a050..869d5b3a38cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -284,7 +284,8 @@ static void mlx5e_activate_qos_sq(struct mlx5e_priv *priv, struct mlx5e_qos_node
 	smp_wmb();
 
 	qos_dbg(priv->mdev, "Activate QoS SQ qid %u\n", node->qid);
-	mlx5e_activate_txqsq(sq);
+	mlx5e_enable_txqsq(sq);
+	mlx5e_start_txqsq(sq);
 }
 
 static void mlx5e_deactivate_qos_sq(struct mlx5e_priv *priv, u16 qid)
@@ -296,8 +297,9 @@ static void mlx5e_deactivate_qos_sq(struct mlx5e_priv *priv, u16 qid)
 		return;
 
 	qos_dbg(priv->mdev, "Deactivate QoS SQ qid %u\n", qid);
-	mlx5e_deactivate_txqsq(sq);
-
+	mlx5e_disable_txqsq(sq);
+	synchronize_net();
+	mlx5e_stop_txqsq(sq);
 	/* The queue is disabled, no synchronization with datapath is needed. */
 	priv->txq2sq[mlx5e_qid_from_qos(&priv->channels, qid)] = NULL;
 }
@@ -431,7 +433,7 @@ void mlx5e_qos_activate_queues(struct mlx5e_priv *priv)
 	}
 }
 
-void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c)
+void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c, bool finalize)
 {
 	struct mlx5e_params *params = &c->priv->channels.params;
 	struct mlx5e_txqsq __rcu **qos_sqs;
@@ -448,12 +450,15 @@ void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c)
 		sq = mlx5e_state_dereference(c->priv, qos_sqs[i]);
 		if (!sq) /* Handle the case when the SQ failed to open. */
 			continue;
-
-		qos_dbg(c->mdev, "Deactivate QoS SQ qid %u\n", qid);
-		mlx5e_deactivate_txqsq(sq);
-
-		/* The queue is disabled, no synchronization with datapath is needed. */
-		c->priv->txq2sq[mlx5e_qid_from_qos(&c->priv->channels, qid)] = NULL;
+		if (finalize) {
+			qos_dbg(c->mdev, "Finalize QoS SQ qid %u\n", qid);
+			mlx5e_stop_txqsq(sq);
+			/* The queue is disabled, no synchronization with datapath is needed. */
+			c->priv->txq2sq[mlx5e_qid_from_qos(&c->priv->channels, qid)] = NULL;
+		} else {
+			qos_dbg(c->mdev, "Deactivate QoS SQ qid %u\n", qid);
+			mlx5e_disable_txqsq(sq);
+		}
 	}
 }
 
@@ -462,7 +467,10 @@ static void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs)
 	int i;
 
 	for (i = 0; i < chs->num; i++)
-		mlx5e_qos_deactivate_queues(chs->c[i]);
+		mlx5e_qos_deactivate_queues(chs->c[i], false);
+	synchronize_net();
+	for (i = 0; i < chs->num; i++)
+		mlx5e_qos_deactivate_queues(chs->c[i], true);
 }
 
 /* HTB API */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index b7558907ba20..bf294288c1ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -23,7 +23,7 @@ struct mlx5e_txqsq *mlx5e_get_sq(struct mlx5e_priv *priv, int qid);
 /* SQ lifecycle */
 int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
 void mlx5e_qos_activate_queues(struct mlx5e_priv *priv);
-void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c);
+void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c, bool finalize);
 void mlx5e_qos_close_queues(struct mlx5e_channel *c);
 
 /* HTB API */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 74086eb556ae..98959ffa5efa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -84,11 +84,13 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		goto out;
 
 	mlx5e_deactivate_rq(rq);
+	synchronize_net(); /* Sync with NAPI. */
 	err = mlx5e_wait_for_icosq_flush(icosq);
 	if (err)
 		goto out;
 
 	mlx5e_deactivate_icosq(icosq);
+	synchronize_net(); /* Sync with NAPI. */
 
 	/* At this point, both the rq and the icosq are disabled */
 
@@ -134,6 +136,7 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	int err;
 
 	mlx5e_deactivate_rq(rq);
+	synchronize_net(); /* Sync with NAPI. */
 	mlx5e_free_rx_descs(rq);
 
 	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 4f4bc8726ec4..262deeb80e5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -80,7 +80,8 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	mlx5e_reset_txqsq_cc_pc(sq);
 	sq->stats->recover++;
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
-	mlx5e_activate_txqsq(sq);
+	mlx5e_enable_txqsq(sq);
+	mlx5e_start_txqsq(sq);
 
 	return 0;
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 7b562d2c8a19..4c7bf4e1bfee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -130,6 +130,7 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 
 err_deactivate:
 	mlx5e_deactivate_xsk(c);
+	synchronize_net(); /* Sync with NAPI. */
 	mlx5e_close_xsk(c);
 
 err_remove_pool:
@@ -171,6 +172,7 @@ static int mlx5e_xsk_disable_locked(struct mlx5e_priv *priv, u16 ix)
 	c = priv->channels.c[ix];
 	mlx5e_rx_res_xsk_deactivate(priv->rx_res, ix);
 	mlx5e_deactivate_xsk(c);
+	synchronize_net(); /* Sync with NAPI. */
 	mlx5e_close_xsk(c);
 
 remove_pool:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6914fc17277a..1fb0d9b70301 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1081,7 +1081,6 @@ void mlx5e_activate_rq(struct mlx5e_rq *rq)
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 }
 
 void mlx5e_close_rq(struct mlx5e_rq *rq)
@@ -1513,14 +1512,18 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 	return err;
 }
 
-void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
+void mlx5e_enable_txqsq(struct mlx5e_txqsq *sq)
 {
 	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+}
+
+void mlx5e_start_txqsq(struct mlx5e_txqsq *sq)
+{
+	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
 	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
 }
-
 void mlx5e_tx_disable_queue(struct netdev_queue *txq)
 {
 	__netif_tx_lock_bh(txq);
@@ -1528,13 +1531,18 @@ void mlx5e_tx_disable_queue(struct netdev_queue *txq)
 	__netif_tx_unlock_bh(txq);
 }
 
-void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
+void mlx5e_disable_txqsq(struct mlx5e_txqsq *sq)
 {
-	struct mlx5_wq_cyc *wq = &sq->wq;
-
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_net(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
+}
+
+void mlx5e_stop_txqsq(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
 
+	/* The SQ must be deactivated, and synchronize_rcu must be called before
+	 * this function to prevent netif_tx_wake_queue from reenabling the SQ.
+	 */
 	mlx5e_tx_disable_queue(sq->txq);
 
 	/* last doorbell out, godspeed .. */
@@ -1617,7 +1625,6 @@ void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
-	synchronize_net(); /* Sync with NAPI. */
 }
 
 void mlx5e_close_icosq(struct mlx5e_icosq *sq)
@@ -1699,7 +1706,6 @@ void mlx5e_activate_xdpsq(struct mlx5e_xdpsq *sq)
 void mlx5e_deactivate_xdpsq(struct mlx5e_xdpsq *sq)
 {
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_net(); /* Sync with NAPI. */
 }
 
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
@@ -2251,8 +2257,10 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 
 	napi_enable(&c->napi);
 
-	for (tc = 0; tc < c->num_tc; tc++)
-		mlx5e_activate_txqsq(&c->sq[tc]);
+	for (tc = 0; tc < c->num_tc; tc++) {
+		mlx5e_enable_txqsq(&c->sq[tc]);
+		mlx5e_start_txqsq(&c->sq[tc]);
+	}
 	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_icosq(&c->async_icosq);
 	if (c->xdp)
@@ -2277,10 +2285,16 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 		mlx5e_deactivate_xdpsq(&c->rq_xdpsq);
 	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
-	for (tc = 0; tc < c->num_tc; tc++)
-		mlx5e_deactivate_txqsq(&c->sq[tc]);
-	mlx5e_qos_deactivate_queues(c);
-
+	synchronize_net(); /* Sync with NAPI. */
+	for (tc = 0; tc < c->num_tc; tc++) {
+		mlx5e_disable_txqsq(&c->sq[tc]);
+		/* Sync with NAPI to prevent netif_tx_wake_queue. */
+		synchronize_net();
+		mlx5e_stop_txqsq(&c->sq[tc]);
+	}
+	mlx5e_qos_deactivate_queues(c, false);
+	synchronize_net();
+	mlx5e_qos_deactivate_queues(c, true);
 	napi_disable(&c->napi);
 }
 
-- 
2.31.1

