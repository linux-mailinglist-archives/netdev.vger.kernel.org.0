Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16A334E01E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhC3E2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhC3E1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4613661987;
        Tue, 30 Mar 2021 04:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078465;
        bh=rsksgJacTihkkoayYuYt2F3idEPlp+F2TO1CC6020Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzKcNG/zlOmRKotPe/VfYruhmDs1hbVYG5it2vRxYFjkd0s/yl+wuXoicH5EE3psz
         V54BTLjsaLIr1gqq3YW/Qff0Kqrs8sS++lelZw4CNaLG3dUjKZHxur9TlnMuN3iF74
         hUA1NlGUy9pbh3q1Lc+xZfL+bgs1s9yLjhJUqxJPDvnsG3tN1+6ypjdvtguEIJYiv/
         89+Jerx3LPqgs+X3t/38ALEsj8Kp2mY5ThesEHB2TCwldTxBGSybnZQHHFs0APpmcX
         mTfZiin20Bf9Rrvh1QarRIMesJYHhzc89Z1fl8kMzwffVi/PW1WgIxX9MDEg85K4xB
         D0E4B29ETLuVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/12] net/mlx5e: Add RQ to PTP channel
Date:   Mon, 29 Mar 2021 21:27:31 -0700
Message-Id: <20210330042741.198601-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Enhance PTP channel to allow PTP without disabling CQE compression. Add
RQ, TIR and PTP_RX_STATE to PTP channel. When this bit is set, PTP
channel manages its RQ, and PTP traffic is directed to the PTP-RQ which
is not affected by compression.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 123 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   2 +
 3 files changed, 118 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index aad2a752f7e3..33db35980970 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -730,6 +730,7 @@ struct mlx5e_ptp_stats {
 	struct mlx5e_ch_stats ch;
 	struct mlx5e_sq_stats sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_ptp_cq_stats cq[MLX5E_MAX_NUM_TC];
+	struct mlx5e_rq_stats rq;
 } ____cacheline_aligned_in_smp;
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 286bd2345da1..7f7dfaed9fb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -10,6 +10,7 @@
 struct mlx5e_ptp_params {
 	struct mlx5e_params params;
 	struct mlx5e_sq_param txq_sq_param;
+	struct mlx5e_rq_param rq_param;
 };
 
 struct mlx5e_skb_cb_hwtstamp {
@@ -126,6 +127,7 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct mlx5e_ptp *c = container_of(napi, struct mlx5e_ptp, napi);
 	struct mlx5e_ch_stats *ch_stats = c->stats;
+	struct mlx5e_rq *rq = &c->rq;
 	bool busy = false;
 	int work_done = 0;
 	int i;
@@ -140,6 +142,14 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 			busy |= mlx5e_ptp_poll_ts_cq(&c->ptpsq[i].ts_cq, budget);
 		}
 	}
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state) && likely(budget)) {
+		work_done = mlx5e_poll_rx_cq(&rq->cq, budget);
+		busy |= work_done == budget;
+		busy |= INDIRECT_CALL_2(rq->post_wqes,
+					mlx5e_post_rx_mpwqes,
+					mlx5e_post_rx_wqes,
+					rq);
+	}
 
 	if (busy) {
 		work_done = budget;
@@ -157,6 +167,8 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 			mlx5e_cq_arm(&c->ptpsq[i].ts_cq);
 		}
 	}
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+		mlx5e_cq_arm(&rq->cq);
 
 out:
 	rcu_read_unlock();
@@ -338,8 +350,8 @@ static void mlx5e_ptp_close_txqsqs(struct mlx5e_ptp *c)
 		mlx5e_ptp_close_txqsq(&c->ptpsq[tc]);
 }
 
-static int mlx5e_ptp_open_cqs(struct mlx5e_ptp *c,
-			      struct mlx5e_ptp_params *cparams)
+static int mlx5e_ptp_open_tx_cqs(struct mlx5e_ptp *c,
+				 struct mlx5e_ptp_params *cparams)
 {
 	struct mlx5e_params *params = &cparams->params;
 	struct mlx5e_create_cq_param ccp = {};
@@ -387,7 +399,25 @@ static int mlx5e_ptp_open_cqs(struct mlx5e_ptp *c,
 	return err;
 }
 
-static void mlx5e_ptp_close_cqs(struct mlx5e_ptp *c)
+static int mlx5e_ptp_open_rx_cq(struct mlx5e_ptp *c,
+				struct mlx5e_ptp_params *cparams)
+{
+	struct mlx5e_create_cq_param ccp = {};
+	struct dim_cq_moder ptp_moder = {};
+	struct mlx5e_cq_param *cq_param;
+	struct mlx5e_cq *cq = &c->rq.cq;
+
+	ccp.node     = dev_to_node(mlx5_core_dma_dev(c->mdev));
+	ccp.ch_stats = c->stats;
+	ccp.napi     = &c->napi;
+	ccp.ix       = MLX5E_PTP_CHANNEL_IX;
+
+	cq_param = &cparams->rq_param.cqp;
+
+	return mlx5e_open_cq(c->priv, ptp_moder, cq_param, &ccp, cq);
+}
+
+static void mlx5e_ptp_close_tx_cqs(struct mlx5e_ptp *c)
 {
 	int tc;
 
@@ -413,6 +443,20 @@ static void mlx5e_ptp_build_sq_param(struct mlx5_core_dev *mdev,
 	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
+static void mlx5e_ptp_build_rq_param(struct mlx5_core_dev *mdev,
+				     struct net_device *netdev,
+				     u16 q_counter,
+				     struct mlx5e_ptp_params *ptp_params)
+{
+	struct mlx5e_rq_param *rq_params = &ptp_params->rq_param;
+	struct mlx5e_params *params = &ptp_params->params;
+
+	params->rq_wq_type = MLX5_WQ_TYPE_CYCLIC;
+	mlx5e_init_rq_type_params(mdev, params);
+	params->sw_mtu = netdev->max_mtu;
+	mlx5e_build_rq_param(mdev, params, NULL, q_counter, rq_params);
+}
+
 static void mlx5e_ptp_build_params(struct mlx5e_ptp *c,
 				   struct mlx5e_ptp_params *cparams,
 				   struct mlx5e_params *orig)
@@ -430,6 +474,45 @@ static void mlx5e_ptp_build_params(struct mlx5e_ptp *c,
 		params->log_sq_size = orig->log_sq_size;
 		mlx5e_ptp_build_sq_param(c->mdev, params, &cparams->txq_sq_param);
 	}
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+		mlx5e_ptp_build_rq_param(c->mdev, c->netdev, c->priv->q_counter, cparams);
+}
+
+static int mlx5e_init_ptp_rq(struct mlx5e_ptp *c, struct mlx5e_params *params,
+			     struct mlx5e_rq *rq)
+{
+	struct mlx5_core_dev *mdev = c->mdev;
+	struct mlx5e_priv *priv = c->priv;
+	int err;
+
+	rq->wq_type      = params->rq_wq_type;
+	rq->pdev         = mdev->device;
+	rq->netdev       = priv->netdev;
+	rq->priv         = priv;
+	rq->clock        = &mdev->clock;
+	rq->tstamp       = &priv->tstamp;
+	rq->mdev         = mdev;
+	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->stats        = &c->priv->ptp_stats.rq;
+	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
+	err = mlx5e_rq_set_handlers(rq, params, false);
+	if (err)
+		return err;
+
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, 0);
+}
+
+static int mlx5e_ptp_open_rq(struct mlx5e_ptp *c, struct mlx5e_params *params,
+			     struct mlx5e_rq_param *rq_param)
+{
+	int node = dev_to_node(c->mdev->device);
+	int err;
+
+	err = mlx5e_init_ptp_rq(c, params, &c->rq);
+	if (err)
+		return err;
+
+	return mlx5e_open_rq(params, rq_param, NULL, node, &c->rq);
 }
 
 static int mlx5e_ptp_open_queues(struct mlx5e_ptp *c,
@@ -438,28 +521,47 @@ static int mlx5e_ptp_open_queues(struct mlx5e_ptp *c,
 	int err;
 
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
-		err = mlx5e_ptp_open_cqs(c, cparams);
+		err = mlx5e_ptp_open_tx_cqs(c, cparams);
 		if (err)
 			return err;
 
 		err = mlx5e_ptp_open_txqsqs(c, cparams);
 		if (err)
-			goto close_cqs;
+			goto close_tx_cqs;
+	}
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
+		err = mlx5e_ptp_open_rx_cq(c, cparams);
+		if (err)
+			goto close_txqsq;
+
+		err = mlx5e_ptp_open_rq(c, &cparams->params, &cparams->rq_param);
+		if (err)
+			goto close_rx_cq;
 	}
 	return 0;
 
-close_cqs:
+close_rx_cq:
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+		mlx5e_close_cq(&c->rq.cq);
+close_txqsq:
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state))
+		mlx5e_ptp_close_txqsqs(c);
+close_tx_cqs:
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state))
-		mlx5e_ptp_close_cqs(c);
+		mlx5e_ptp_close_tx_cqs(c);
 
 	return err;
 }
 
 static void mlx5e_ptp_close_queues(struct mlx5e_ptp *c)
 {
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
+		mlx5e_close_rq(&c->rq);
+		mlx5e_close_cq(&c->rq.cq);
+	}
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
 		mlx5e_ptp_close_txqsqs(c);
-		mlx5e_ptp_close_cqs(c);
+		mlx5e_ptp_close_tx_cqs(c);
 	}
 }
 
@@ -540,12 +642,17 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 		for (tc = 0; tc < c->num_tc; tc++)
 			mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
 	}
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+		mlx5e_activate_rq(&c->rq);
 }
 
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
 {
 	int tc;
 
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+		mlx5e_deactivate_rq(&c->rq);
+
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
 		for (tc = 0; tc < c->num_tc; tc++)
 			mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 36c46274a46a..cc6a48a43233 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -18,12 +18,14 @@ struct mlx5e_ptpsq {
 
 enum {
 	MLX5E_PTP_STATE_TX,
+	MLX5E_PTP_STATE_RX,
 	MLX5E_PTP_STATE_NUM_STATES,
 };
 
 struct mlx5e_ptp {
 	/* data path */
 	struct mlx5e_ptpsq         ptpsq[MLX5E_MAX_NUM_TC];
+	struct mlx5e_rq            rq;
 	struct napi_struct         napi;
 	struct device             *pdev;
 	struct net_device         *netdev;
-- 
2.30.2

