Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F91349FFE
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCZCy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhCZCxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84D861A3F;
        Fri, 26 Mar 2021 02:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727234;
        bh=m1UKNTFKq+WYzFVdgt42GiQ6TdEFHImYUioR/m7oXzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aem8a1hrorN0aNFZE03hD6zlKINnOZSGndCWW98YieAHJ0NaaoDtxh7GWlOvi5pJP
         ujDUb77SXrsWYIZPdFrgigX3MgVXz3cNwT0kAg37VwBoHMWumAbgJocjvwnMtW27vR
         HRQmcZEO/2+WgEfgF0w6OqDeyQKIU93AyGiYIWgaypbKjc8DuFOvjn85bLedPRLJuv
         WcTI0jR24Jr04sXnuHryDeM8h6g1Jx1f9e3+GIPyi10NjL76/MCl/XQSdTwDc0MzE3
         iqcFNrJgX+ckMaRjP4dTaQVapTMeiIgPq5PCmYKSTPrkjnDJ1btx+vsClGQQH9LRzs
         NScbcIVdqJA/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 11/13] net/mlx5e: Generalize PTP implementation
Date:   Thu, 25 Mar 2021 19:53:43 -0700
Message-Id: <20210326025345.456475-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Following patches in the set add support for RX PTP. Rename PTP prefix
from %s/port_ptp/ptp/g to include RX PTP too.

In addition rename indication (used in statistics context) that PTP-SQ
was opened: %s/port_ptp_opened/tx_ptp_opened/g. This will simplify adding
indication that PTP-RQ was opened.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 10 ++---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 39 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  | 12 +++---
 .../mellanox/mlx5/core/en/reporter_tx.c       |  8 ++--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++++++-------
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 18 ++++-----
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 8 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 1158d8aefbe2..aad2a752f7e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -707,11 +707,11 @@ struct mlx5e_channel {
 	int                        cpu;
 };
 
-struct mlx5e_port_ptp;
+struct mlx5e_ptp;
 
 struct mlx5e_channels {
 	struct mlx5e_channel **c;
-	struct mlx5e_port_ptp  *port_ptp;
+	struct mlx5e_ptp      *ptp;
 	unsigned int           num;
 	struct mlx5e_params    params;
 };
@@ -726,7 +726,7 @@ struct mlx5e_channel_stats {
 	struct mlx5e_xdpsq_stats xsksq;
 } ____cacheline_aligned_in_smp;
 
-struct mlx5e_port_ptp_stats {
+struct mlx5e_ptp_stats {
 	struct mlx5e_ch_stats ch;
 	struct mlx5e_sq_stats sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_ptp_cq_stats cq[MLX5E_MAX_NUM_TC];
@@ -855,10 +855,10 @@ struct mlx5e_priv {
 	struct mlx5e_stats         stats;
 	struct mlx5e_channel_stats channel_stats[MLX5E_MAX_NUM_CHANNELS];
 	struct mlx5e_channel_stats trap_stats;
-	struct mlx5e_port_ptp_stats port_ptp_stats;
+	struct mlx5e_ptp_stats     ptp_stats;
 	u16                        max_nch;
 	u8                         max_opened_tc;
-	bool                       port_ptp_opened;
+	bool                       tx_ptp_opened;
 	struct hwtstamp_config     tstamp;
 	u16                        q_counter;
 	u16                        drop_rq_q_counter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index fb93edf910b9..2bc6d4362670 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -116,8 +116,7 @@ static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
 
 static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 {
-	struct mlx5e_port_ptp *c = container_of(napi, struct mlx5e_port_ptp,
-						napi);
+	struct mlx5e_ptp *c = container_of(napi, struct mlx5e_ptp, napi);
 	struct mlx5e_ch_stats *ch_stats = c->stats;
 	bool busy = false;
 	int work_done = 0;
@@ -153,7 +152,7 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static int mlx5e_ptp_alloc_txqsq(struct mlx5e_port_ptp *c, int txq_ix,
+static int mlx5e_ptp_alloc_txqsq(struct mlx5e_ptp *c, int txq_ix,
 				 struct mlx5e_params *params,
 				 struct mlx5e_sq_param *param,
 				 struct mlx5e_txqsq *sq, int tc,
@@ -177,7 +176,7 @@ static int mlx5e_ptp_alloc_txqsq(struct mlx5e_port_ptp *c, int txq_ix,
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->stats     = &c->priv->port_ptp_stats.sq[tc];
+	sq->stats     = &c->priv->ptp_stats.sq[tc];
 	sq->ptpsq     = ptpsq;
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
@@ -241,7 +240,7 @@ static void mlx5e_ptp_free_traffic_db(struct mlx5e_skb_fifo *skb_fifo)
 	kvfree(skb_fifo->fifo);
 }
 
-static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp *c, u32 tisn,
+static int mlx5e_ptp_open_txqsq(struct mlx5e_ptp *c, u32 tisn,
 				int txq_ix, struct mlx5e_ptp_params *cparams,
 				int tc, struct mlx5e_ptpsq *ptpsq)
 {
@@ -291,7 +290,7 @@ static void mlx5e_ptp_close_txqsq(struct mlx5e_ptpsq *ptpsq)
 	mlx5e_free_txqsq(sq);
 }
 
-static int mlx5e_ptp_open_txqsqs(struct mlx5e_port_ptp *c,
+static int mlx5e_ptp_open_txqsqs(struct mlx5e_ptp *c,
 				 struct mlx5e_ptp_params *cparams)
 {
 	struct mlx5e_params *params = &cparams->params;
@@ -319,7 +318,7 @@ static int mlx5e_ptp_open_txqsqs(struct mlx5e_port_ptp *c,
 	return err;
 }
 
-static void mlx5e_ptp_close_txqsqs(struct mlx5e_port_ptp *c)
+static void mlx5e_ptp_close_txqsqs(struct mlx5e_ptp *c)
 {
 	int tc;
 
@@ -327,7 +326,7 @@ static void mlx5e_ptp_close_txqsqs(struct mlx5e_port_ptp *c)
 		mlx5e_ptp_close_txqsq(&c->ptpsq[tc]);
 }
 
-static int mlx5e_ptp_open_cqs(struct mlx5e_port_ptp *c,
+static int mlx5e_ptp_open_cqs(struct mlx5e_ptp *c,
 			      struct mlx5e_ptp_params *cparams)
 {
 	struct mlx5e_params *params = &cparams->params;
@@ -360,7 +359,7 @@ static int mlx5e_ptp_open_cqs(struct mlx5e_port_ptp *c,
 		if (err)
 			goto out_err_ts_cq;
 
-		ptpsq->cq_stats = &c->priv->port_ptp_stats.cq[tc];
+		ptpsq->cq_stats = &c->priv->ptp_stats.cq[tc];
 	}
 
 	return 0;
@@ -376,7 +375,7 @@ static int mlx5e_ptp_open_cqs(struct mlx5e_port_ptp *c,
 	return err;
 }
 
-static void mlx5e_ptp_close_cqs(struct mlx5e_port_ptp *c)
+static void mlx5e_ptp_close_cqs(struct mlx5e_ptp *c)
 {
 	int tc;
 
@@ -402,7 +401,7 @@ static void mlx5e_ptp_build_sq_param(struct mlx5_core_dev *mdev,
 	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
-static void mlx5e_ptp_build_params(struct mlx5e_port_ptp *c,
+static void mlx5e_ptp_build_params(struct mlx5e_ptp *c,
 				   struct mlx5e_ptp_params *cparams,
 				   struct mlx5e_params *orig)
 {
@@ -420,7 +419,7 @@ static void mlx5e_ptp_build_params(struct mlx5e_port_ptp *c,
 	mlx5e_ptp_build_sq_param(c->mdev, params, &cparams->txq_sq_param);
 }
 
-static int mlx5e_ptp_open_queues(struct mlx5e_port_ptp *c,
+static int mlx5e_ptp_open_queues(struct mlx5e_ptp *c,
 				 struct mlx5e_ptp_params *cparams)
 {
 	int err;
@@ -441,19 +440,19 @@ static int mlx5e_ptp_open_queues(struct mlx5e_port_ptp *c,
 	return err;
 }
 
-static void mlx5e_ptp_close_queues(struct mlx5e_port_ptp *c)
+static void mlx5e_ptp_close_queues(struct mlx5e_ptp *c)
 {
 	mlx5e_ptp_close_txqsqs(c);
 	mlx5e_ptp_close_cqs(c);
 }
 
-int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
-			u8 lag_port, struct mlx5e_port_ptp **cp)
+int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		   u8 lag_port, struct mlx5e_ptp **cp)
 {
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_ptp_params *cparams;
-	struct mlx5e_port_ptp *c;
+	struct mlx5e_ptp *c;
 	unsigned int irq;
 	int err;
 	int eqn;
@@ -475,7 +474,7 @@ int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	c->netdev   = priv->netdev;
 	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
 	c->num_tc   = params->num_tc;
-	c->stats    = &priv->port_ptp_stats.ch;
+	c->stats    = &priv->ptp_stats.ch;
 	c->lag_port = lag_port;
 
 	netif_napi_add(netdev, &c->napi, mlx5e_ptp_napi_poll, 64);
@@ -500,7 +499,7 @@ int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	return err;
 }
 
-void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c)
+void mlx5e_ptp_close(struct mlx5e_ptp *c)
 {
 	mlx5e_ptp_close_queues(c);
 	netif_napi_del(&c->napi);
@@ -508,7 +507,7 @@ void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c)
 	kvfree(c);
 }
 
-void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c)
+void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 {
 	int tc;
 
@@ -518,7 +517,7 @@ void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c)
 		mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
 }
 
-void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c)
+void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
 {
 	int tc;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 90c98ea63b7f..4cae06f2c312 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -17,7 +17,7 @@ struct mlx5e_ptpsq {
 	struct mlx5e_ptp_cq_stats *cq_stats;
 };
 
-struct mlx5e_port_ptp {
+struct mlx5e_ptp {
 	/* data path */
 	struct mlx5e_ptpsq         ptpsq[MLX5E_MAX_NUM_TC];
 	struct napi_struct         napi;
@@ -43,11 +43,11 @@ struct mlx5e_ptp_params {
 	struct mlx5e_sq_param      txq_sq_param;
 };
 
-int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
-			u8 lag_port, struct mlx5e_port_ptp **cp);
-void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c);
-void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c);
-void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c);
+int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		   u8 lag_port, struct mlx5e_ptp **cp);
+void mlx5e_ptp_close(struct mlx5e_ptp *c);
+void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
 
 enum {
 	MLX5E_SKB_CB_CQE_HWTSTAMP  = BIT(0),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 63ee3b9416de..e107801adf48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -315,8 +315,8 @@ mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *reporte
 	if (err)
 		return err;
 
-	generic_ptpsq = priv->channels.port_ptp ?
-			&priv->channels.port_ptp->ptpsq[0] :
+	generic_ptpsq = priv->channels.ptp ?
+			&priv->channels.ptp->ptpsq[0] :
 			NULL;
 	if (!generic_ptpsq)
 		goto out;
@@ -346,7 +346,7 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
-	struct mlx5e_port_ptp *ptp_ch = priv->channels.port_ptp;
+	struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
 
 	int i, tc, err = 0;
 
@@ -460,7 +460,7 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devlink_fms
 static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 					  struct devlink_fmsg *fmsg)
 {
-	struct mlx5e_port_ptp *ptp_ch = priv->channels.port_ptp;
+	struct mlx5e_ptp *ptp_ch = priv->channels.ptp;
 	struct mlx5_rsc_key key = {};
 	int i, tc, err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index a2b23cdd2047..cf319f06521d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2032,7 +2032,7 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 					 mlx5e_num_channels_changed_ctx, NULL);
 out:
 	if (!err)
-		priv->port_ptp_opened = true;
+		priv->tx_ptp_opened = true;
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index df941fe808ab..40a62d2e9558 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2088,8 +2088,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	}
 
 	if (MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS)) {
-		err = mlx5e_port_ptp_open(priv, &chs->params, chs->c[0]->lag_port,
-					  &chs->port_ptp);
+		err = mlx5e_ptp_open(priv, &chs->params, chs->c[0]->lag_port, &chs->ptp);
 		if (err)
 			goto err_close_channels;
 	}
@@ -2103,8 +2102,8 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	return 0;
 
 err_close_ptp:
-	if (chs->port_ptp)
-		mlx5e_port_ptp_close(chs->port_ptp);
+	if (chs->ptp)
+		mlx5e_ptp_close(chs->ptp);
 
 err_close_channels:
 	for (i--; i >= 0; i--)
@@ -2124,8 +2123,8 @@ static void mlx5e_activate_channels(struct mlx5e_channels *chs)
 	for (i = 0; i < chs->num; i++)
 		mlx5e_activate_channel(chs->c[i]);
 
-	if (chs->port_ptp)
-		mlx5e_ptp_activate_channel(chs->port_ptp);
+	if (chs->ptp)
+		mlx5e_ptp_activate_channel(chs->ptp);
 }
 
 #define MLX5E_RQ_WQES_TIMEOUT 20000 /* msecs */
@@ -2152,8 +2151,8 @@ static void mlx5e_deactivate_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	if (chs->port_ptp)
-		mlx5e_ptp_deactivate_channel(chs->port_ptp);
+	if (chs->ptp)
+		mlx5e_ptp_deactivate_channel(chs->ptp);
 
 	for (i = 0; i < chs->num; i++)
 		mlx5e_deactivate_channel(chs->c[i]);
@@ -2163,11 +2162,10 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	if (chs->port_ptp) {
-		mlx5e_port_ptp_close(chs->port_ptp);
-		chs->port_ptp = NULL;
+	if (chs->ptp) {
+		mlx5e_ptp_close(chs->ptp);
+		chs->ptp = NULL;
 	}
-
 	for (i = 0; i < chs->num; i++)
 		mlx5e_close_channel(chs->c[i]);
 
@@ -2758,11 +2756,11 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 		}
 	}
 
-	if (!priv->channels.port_ptp)
+	if (!priv->channels.ptp)
 		return;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		struct mlx5e_port_ptp *c = priv->channels.port_ptp;
+		struct mlx5e_ptp *c = priv->channels.ptp;
 		struct mlx5e_txqsq *sq = &c->ptpsq[tc].txqsq;
 
 		priv->txq2sq[sq->txq_ix] = sq;
@@ -3486,9 +3484,9 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 			s->tx_dropped    += sq_stats->dropped;
 		}
 	}
-	if (priv->port_ptp_opened) {
+	if (priv->tx_ptp_opened) {
 		for (i = 0; i < priv->max_opened_tc; i++) {
-			struct mlx5e_sq_stats *sq_stats = &priv->port_ptp_stats.sq[i];
+			struct mlx5e_sq_stats *sq_stats = &priv->ptp_stats.sq[i];
 
 			s->tx_packets    += sq_stats->packets;
 			s->tx_bytes      += sq_stats->bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 92c5b81427b9..32331ac9288c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -407,13 +407,13 @@ static void mlx5e_stats_grp_sw_update_stats_ptp(struct mlx5e_priv *priv,
 {
 	int i;
 
-	if (!priv->port_ptp_opened)
+	if (!priv->tx_ptp_opened)
 		return;
 
-	mlx5e_stats_grp_sw_update_stats_ch_stats(s, &priv->port_ptp_stats.ch);
+	mlx5e_stats_grp_sw_update_stats_ch_stats(s, &priv->ptp_stats.ch);
 
 	for (i = 0; i < priv->max_opened_tc; i++) {
-		mlx5e_stats_grp_sw_update_stats_sq(s, &priv->port_ptp_stats.sq[i]);
+		mlx5e_stats_grp_sw_update_stats_sq(s, &priv->ptp_stats.sq[i]);
 
 		/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
 		barrier();
@@ -1851,7 +1851,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(qos) { return; }
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ptp)
 {
-	return priv->port_ptp_opened ?
+	return priv->tx_ptp_opened ?
 	       NUM_PTP_CH_STATS +
 	       ((NUM_PTP_SQ_STATS + NUM_PTP_CQ_STATS) * priv->max_opened_tc) :
 	       0;
@@ -1861,7 +1861,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
 {
 	int i, tc;
 
-	if (!priv->port_ptp_opened)
+	if (!priv->tx_ptp_opened)
 		return idx;
 
 	for (i = 0; i < NUM_PTP_CH_STATS; i++)
@@ -1884,24 +1884,24 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ptp)
 {
 	int i, tc;
 
-	if (!priv->port_ptp_opened)
+	if (!priv->tx_ptp_opened)
 		return idx;
 
 	for (i = 0; i < NUM_PTP_CH_STATS; i++)
 		data[idx++] =
-			MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.ch,
+			MLX5E_READ_CTR64_CPU(&priv->ptp_stats.ch,
 					     ptp_ch_stats_desc, i);
 
 	for (tc = 0; tc < priv->max_opened_tc; tc++)
 		for (i = 0; i < NUM_PTP_SQ_STATS; i++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.sq[tc],
+				MLX5E_READ_CTR64_CPU(&priv->ptp_stats.sq[tc],
 						     ptp_sq_stats_desc, i);
 
 	for (tc = 0; tc < priv->max_opened_tc; tc++)
 		for (i = 0; i < NUM_PTP_CQ_STATS; i++)
 			data[idx++] =
-				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.cq[tc],
+				MLX5E_READ_CTR64_CPU(&priv->ptp_stats.cq[tc],
 						     ptp_cq_stats_desc, i);
 
 	return idx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index d2efe2455955..cfb6ffd7df54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -142,7 +142,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 				return txq_ix;
 		}
 
-		if (unlikely(priv->channels.port_ptp))
+		if (unlikely(priv->channels.ptp))
 			if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 			    mlx5e_use_ptpsq(skb))
 				return mlx5e_select_ptpsq(dev, skb);
-- 
2.30.2

