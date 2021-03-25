Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D770C34882E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCYFFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhCYFEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511FD619BA;
        Thu, 25 Mar 2021 05:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648686;
        bh=fmuF4DAHR3AWzMvpDT7WWXF/CEpd41rhDmHFejeyGc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEotLVGq0rFsf7tf6uhT11pfeYTCkAi4OGaNn+7cOtYMZHWYYGxnqg26eZKVwfkBp
         +V+b2jOVwtabg3jkNPCZoSIYKwQRLV9neGvMaml3AUjKMswbgcdpJfwklj/XTlhtU5
         ti1mZcDbIEk7WOS6KSblfhA4ZfMdbFIqC1o5b9VEY9K3zISWFvhf0necPH6yvC8Xdc
         1RVAIVqkpfgezUhlaSrygJ7Cbh/IEL8/BJKaUtEXSakmUpfeanDeQgeXyjLVlxOw5h
         x3ksIjCtLjLfNKyKVWTURGl6ieiARwtb2BRrg/0b/CR/qFwM2K3bLdSCWguVrO4m16
         xNemc4CgHCTrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Restrict usage of mlx5e_priv in params logic functions
Date:   Wed, 24 Mar 2021 22:04:29 -0700
Message-Id: <20210325050438.261511-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Do not use generic struct mlx5e_priv as a parameter to param
functions, as it is too generic. All calculations of the channel's
param should be mainly based on struct mlx5_core_dev and
struct mlx5e_params. Additional info can be explicitly passed.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 94 +++++++++----------
 .../ethernet/mellanox/mlx5/core/en/params.h   | 17 ++--
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  8 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/trap.c | 12 ++-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  9 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +-
 8 files changed, 77 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index d2e0e07407a8..c350e72215d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -174,15 +174,15 @@ u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *par
 	return stop_room;
 }
 
-int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *params)
+int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	size_t sq_size = 1 << params->log_sq_size;
 	u16 stop_room;
 
-	stop_room = mlx5e_calc_sq_stop_room(priv->mdev, params);
+	stop_room = mlx5e_calc_sq_stop_room(mdev, params);
 	if (stop_room >= sq_size) {
-		netdev_err(priv->netdev, "Stop room %u is bigger than the SQ size %zu\n",
-			   stop_room, sq_size);
+		mlx5_core_err(mdev, "Stop room %u is bigger than the SQ size %zu\n",
+			      stop_room, sq_size);
 		return -EINVAL;
 	}
 
@@ -421,22 +421,21 @@ static inline u8 mlx5e_get_rqwq_log_stride(u8 wq_type, int ndsegs)
 	return order_base_2(sz);
 }
 
-static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
+static void mlx5e_build_common_cq_param(struct mlx5_core_dev *mdev,
 					struct mlx5e_cq_param *param)
 {
 	void *cqc = param->cqc;
 
-	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
+	MLX5_SET(cqc, cqc, uar_page, mdev->priv.uar->index);
+	if (MLX5_CAP_GEN(mdev, cqe_128_always) && cache_line_size() >= 128)
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
-static void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
+static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 				    struct mlx5e_params *params,
 				    struct mlx5e_xsk_param *xsk,
 				    struct mlx5e_cq_param *param)
 {
-	struct mlx5_core_dev *mdev = priv->mdev;
 	bool hw_stridx = false;
 	void *cqc = param->cqc;
 	u8 log_cq_size;
@@ -458,17 +457,16 @@ static void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 		MLX5_SET(cqc, cqc, cqe_comp_en, 1);
 	}
 
-	mlx5e_build_common_cq_param(priv, param);
+	mlx5e_build_common_cq_param(mdev, param);
 	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
 }
 
-void mlx5e_build_rq_param(struct mlx5e_priv *priv,
+void mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
 			  u16 q_counter,
 			  struct mlx5e_rq_param *param)
 {
-	struct mlx5_core_dev *mdev = priv->mdev;
 	void *rqc = param->rqc;
 	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
 	int ndsegs = 1;
@@ -499,14 +497,13 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
 
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
-	mlx5e_build_rx_cq_param(priv, params, xsk, &param->cqp);
+	mlx5e_build_rx_cq_param(mdev, params, xsk, &param->cqp);
 }
 
-void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
+void mlx5e_build_drop_rq_param(struct mlx5_core_dev *mdev,
 			       u16 q_counter,
 			       struct mlx5e_rq_param *param)
 {
-	struct mlx5_core_dev *mdev = priv->mdev;
 	void *rqc = param->rqc;
 	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
 
@@ -518,7 +515,7 @@ void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 }
 
-void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
+void mlx5e_build_tx_cq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
 			     struct mlx5e_cq_param *param)
 {
@@ -526,40 +523,41 @@ void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
 
 	MLX5_SET(cqc, cqc, log_cq_size, params->log_sq_size);
 
-	mlx5e_build_common_cq_param(priv, param);
+	mlx5e_build_common_cq_param(mdev, param);
 	param->cq_period_mode = params->tx_cq_moderation.cq_period_mode;
 }
 
-void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
+void mlx5e_build_sq_param_common(struct mlx5_core_dev *mdev,
 				 struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
 	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
-	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(wq, wq, pd,            mdev->mlx5e_res.hw_objs.pdn);
 
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 }
 
-void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
+void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
+			  struct mlx5e_params *params,
 			  struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 	bool allow_swp;
 
-	allow_swp = mlx5_geneve_tx_allowed(priv->mdev) ||
-		    !!MLX5_IPSEC_DEV(priv->mdev);
-	mlx5e_build_sq_param_common(priv, param);
+	allow_swp = mlx5_geneve_tx_allowed(mdev) ||
+		    !!MLX5_IPSEC_DEV(mdev);
+	mlx5e_build_sq_param_common(mdev, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
 	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
-	param->stop_room = mlx5e_calc_sq_stop_room(priv->mdev, params);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
+	param->stop_room = mlx5e_calc_sq_stop_room(mdev, params);
+	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
-static void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
+static void mlx5e_build_ico_cq_param(struct mlx5_core_dev *mdev,
 				     u8 log_wq_size,
 				     struct mlx5e_cq_param *param)
 {
@@ -567,7 +565,7 @@ static void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
 
 	MLX5_SET(cqc, cqc, log_cq_size, log_wq_size);
 
-	mlx5e_build_common_cq_param(priv, param);
+	mlx5e_build_common_cq_param(mdev, param);
 
 	param->cq_period_mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 }
@@ -592,69 +590,69 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
 	}
 }
 
-static u8 mlx5e_build_async_icosq_log_wq_sz(struct net_device *netdev)
+static u8 mlx5e_build_async_icosq_log_wq_sz(struct mlx5_core_dev *mdev)
 {
-	if (netdev->hw_features & NETIF_F_HW_TLS_RX)
+	if (mlx5_accel_is_ktls_rx(mdev))
 		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
 
 	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 }
 
-static void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
+static void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
 				    u8 log_wq_size,
 				    struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
-	mlx5e_build_sq_param_common(priv, param);
+	mlx5e_build_sq_param_common(mdev, param);
 
 	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
-	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
-	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
+	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(mdev, reg_umr_sq));
+	mlx5e_build_ico_cq_param(mdev, log_wq_size, &param->cqp);
 }
 
-static void mlx5e_build_async_icosq_param(struct mlx5e_priv *priv,
+static void mlx5e_build_async_icosq_param(struct mlx5_core_dev *mdev,
 					  u8 log_wq_size,
 					  struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
-	mlx5e_build_sq_param_common(priv, param);
+	mlx5e_build_sq_param_common(mdev, param);
 	param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
-	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
+	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(mdev, reg_umr_sq));
 	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
-	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
+	mlx5e_build_ico_cq_param(mdev, log_wq_size, &param->cqp);
 }
 
-void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
+void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
 			     struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
-	mlx5e_build_sq_param_common(priv, param);
+	mlx5e_build_sq_param_common(mdev, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
+	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
-void mlx5e_build_channel_param(struct mlx5e_priv *priv,
+void mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			       struct mlx5e_params *params,
 			       u16 q_counter,
 			       struct mlx5e_channel_param *cparam)
 {
 	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
 
-	mlx5e_build_rq_param(priv, params, NULL, q_counter, &cparam->rq);
+	mlx5e_build_rq_param(mdev, params, NULL, q_counter, &cparam->rq);
 
 	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
-	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(priv->netdev);
+	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(mdev);
 
-	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
-	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
-	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
-	mlx5e_build_async_icosq_param(priv, async_icosq_log_wq_sz, &cparam->async_icosq);
+	mlx5e_build_sq_param(mdev, params, &cparam->txq_sq);
+	mlx5e_build_xdpsq_param(mdev, params, &cparam->xdp_sq);
+	mlx5e_build_icosq_param(mdev, icosq_log_wq_sz, &cparam->icosq);
+	mlx5e_build_async_icosq_param(mdev, async_icosq_log_wq_sz, &cparam->async_icosq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index a43776e8a86b..602e41a2bddd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -121,30 +121,31 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 /* Build queue parameters */
 
 void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e_channel *c);
-void mlx5e_build_rq_param(struct mlx5e_priv *priv,
+void mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
 			  u16 q_counter,
 			  struct mlx5e_rq_param *param);
-void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
+void mlx5e_build_drop_rq_param(struct mlx5_core_dev *mdev,
 			       u16 q_counter,
 			       struct mlx5e_rq_param *param);
-void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
+void mlx5e_build_sq_param_common(struct mlx5_core_dev *mdev,
 				 struct mlx5e_sq_param *param);
-void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
+void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
+			  struct mlx5e_params *params,
 			  struct mlx5e_sq_param *param);
-void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
+void mlx5e_build_tx_cq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
 			     struct mlx5e_cq_param *param);
-void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
+void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
 			     struct mlx5e_sq_param *param);
-void mlx5e_build_channel_param(struct mlx5e_priv *priv,
+void mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			       struct mlx5e_params *params,
 			       u16 q_counter,
 			       struct mlx5e_channel_param *cparam);
 
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
-int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *params);
+int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 
 #endif /* __MLX5_EN_PARAMS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index bb5d108f75d0..27b5c7b143b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -389,19 +389,19 @@ static void mlx5e_ptp_close_cqs(struct mlx5e_port_ptp *c)
 		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
 }
 
-static void mlx5e_ptp_build_sq_param(struct mlx5e_priv *priv,
+static void mlx5e_ptp_build_sq_param(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params,
 				     struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq;
 
-	mlx5e_build_sq_param_common(priv, param);
+	mlx5e_build_sq_param_common(mdev, param);
 
 	wq = MLX5_ADDR_OF(sqc, sqc, wq);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	param->stop_room = mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
+	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
 static void mlx5e_ptp_build_params(struct mlx5e_port_ptp *c,
@@ -419,7 +419,7 @@ static void mlx5e_ptp_build_params(struct mlx5e_port_ptp *c,
 	/* SQ */
 	params->log_sq_size = orig->log_sq_size;
 
-	mlx5e_ptp_build_sq_param(c->priv, params, &cparams->txq_sq_param);
+	mlx5e_ptp_build_sq_param(c->mdev, params, &cparams->txq_sq_param);
 }
 
 static int mlx5e_ptp_open_queues(struct mlx5e_port_ptp *c,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 12d7ad061237..5efe3278b0f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -232,8 +232,8 @@ static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs
 
 	memset(&param_sq, 0, sizeof(param_sq));
 	memset(&param_cq, 0, sizeof(param_cq));
-	mlx5e_build_sq_param(priv, params, &param_sq);
-	mlx5e_build_tx_cq_param(priv, params, &param_cq);
+	mlx5e_build_sq_param(priv->mdev, params, &param_sq);
+	mlx5e_build_tx_cq_param(priv->mdev, params, &param_cq);
 	err = mlx5e_open_cq(priv, params->tx_cq_moderation, &param_cq, &ccp, &sq->cq);
 	if (err)
 		goto err_free_sq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 0bfbc8cbe840..ba36657cd297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -238,14 +238,16 @@ static void mlx5e_deactivate_trap_rq(struct mlx5e_rq *rq)
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
 }
 
-static void mlx5e_build_trap_params(struct mlx5e_priv *priv, struct mlx5e_trap *t)
+static void mlx5e_build_trap_params(struct mlx5_core_dev *mdev,
+				    int max_mtu, u16 q_counter,
+				    struct mlx5e_trap *t)
 {
 	struct mlx5e_params *params = &t->params;
 
 	params->rq_wq_type = MLX5_WQ_TYPE_CYCLIC;
-	mlx5e_init_rq_type_params(priv->mdev, params);
-	params->sw_mtu = priv->netdev->max_mtu;
-	mlx5e_build_rq_param(priv, params, NULL, priv->q_counter, &t->rq_param);
+	mlx5e_init_rq_type_params(mdev, params);
+	params->sw_mtu = max_mtu;
+	mlx5e_build_rq_param(mdev, params, NULL, q_counter, &t->rq_param);
 }
 
 static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
@@ -259,7 +261,7 @@ static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
 	if (!t)
 		return ERR_PTR(-ENOMEM);
 
-	mlx5e_build_trap_params(priv, t);
+	mlx5e_build_trap_params(priv->mdev, netdev->max_mtu, priv->q_counter, t);
 
 	t->priv     = priv;
 	t->mdev     = priv->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index d84a2299adf4..313a708e351b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -35,13 +35,14 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 	}
 }
 
-static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
+static void mlx5e_build_xsk_cparam(struct mlx5_core_dev *mdev,
 				   struct mlx5e_params *params,
 				   struct mlx5e_xsk_param *xsk,
+				   u16 q_counter,
 				   struct mlx5e_channel_param *cparam)
 {
-	mlx5e_build_rq_param(priv, params, xsk, priv->q_counter, &cparam->rq);
-	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
+	mlx5e_build_rq_param(mdev, params, xsk, q_counter, &cparam->rq);
+	mlx5e_build_xdpsq_param(mdev, params, &cparam->xdp_sq);
 }
 
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
@@ -61,7 +62,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (!cparam)
 		return -ENOMEM;
 
-	mlx5e_build_xsk_cparam(priv, params, xsk, cparam);
+	mlx5e_build_xsk_cparam(priv->mdev, params, xsk, priv->q_counter, cparam);
 
 	err = mlx5e_open_cq(c->priv, params->rx_cq_moderation, &cparam->rq.cqp, &ccp,
 			    &c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index abdf721bb264..d2d8ba4b3508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -368,7 +368,7 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 	new_channels.params.log_rq_mtu_frames = log_rq_size;
 	new_channels.params.log_sq_size = log_sq_size;
 
-	err = mlx5e_validate_params(priv, &new_channels.params);
+	err = mlx5e_validate_params(priv->mdev, &new_channels.params);
 	if (err)
 		goto unlock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index de40ed634011..fe98f7d7921f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2070,7 +2070,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	if (!chs->c || !cparam)
 		goto err_free;
 
-	mlx5e_build_channel_param(priv, &chs->params, priv->q_counter, cparam);
+	mlx5e_build_channel_param(priv->mdev, &chs->params, priv->q_counter, cparam);
 	for (i = 0; i < chs->num; i++) {
 		struct xsk_buff_pool *xsk_pool = NULL;
 
@@ -3029,7 +3029,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 	struct mlx5e_cq *cq = &drop_rq->cq;
 	int err;
 
-	mlx5e_build_drop_rq_param(priv, priv->drop_rq_q_counter, &rq_param);
+	mlx5e_build_drop_rq_param(mdev, priv->drop_rq_q_counter, &rq_param);
 
 	err = mlx5e_alloc_drop_cq(priv, cq, &cq_param);
 	if (err)
@@ -3856,7 +3856,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 
 	new_channels.params = *params;
 	new_channels.params.sw_mtu = new_mtu;
-	err = mlx5e_validate_params(priv, &new_channels.params);
+	err = mlx5e_validate_params(priv->mdev, &new_channels.params);
 	if (err)
 		goto out;
 
-- 
2.30.2

