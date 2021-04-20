Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8AB3650C5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhDTDVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhDTDVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B966135F;
        Tue, 20 Apr 2021 03:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888835;
        bh=l4wmkhOGzeH4EyjFSBaB5lSt2rmaQ6SXWsVJ+MMobu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhDgBL7s3f3DyBAQz0tEYjR8sKruEFmHMBbd3xLnUDwZkNUjaMjAADQw10I7G0qpL
         SyvgrLVwmG2keVmYC5MKX5VrKoQVphSETRaulCc9sFogdDfpmcU/PujtUqw1AH81QT
         +0AiymEn54IzZD9L5de4DG4dZC+wusWT7/cOQkHP78aA9oGkq0QJ13eEQ6QrV6Kh58
         p8E2scejwbFxwaQseXrMLARWTywUPuatIxPvOC2H7QwOJ077QxGoQIlFMoNyY+yfQg
         34Eb9w620mnhstcx8/7pR7B/UzSnAwWEUUn/TEqrtc4uDvo777cZMvM5H//E6I6/3e
         HxbtGndd6hM5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: RX, Add checks for calculated Striding RQ attributes
Date:   Mon, 19 Apr 2021 20:20:06 -0700
Message-Id: <20210420032018.58639-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Striding RQ attributes below are mutually dependent. An unaware
change to one might take the others out of the valid range derived
by the HW caps:
- The MPWQE size in bytes
- The number of strides in a MPWQE
- The stride size

Add checks to verify they are valid and comply to the HW spec
and SW assumptions/requirements.
This is not a fix, no particular issue exists today.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 86 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/params.h   | 20 +++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  5 +-
 include/linux/mlx5/device.h                   |  7 +-
 4 files changed, 76 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 69f1f41b2b83..f410c1268422 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -90,30 +90,39 @@ bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
 	return !params->lro_en && linear_frag_sz <= PAGE_SIZE;
 }
 
-#define MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ ((BIT(__mlx5_bit_sz(wq, log_wqe_stride_size)) - 1) + \
-					  MLX5_MPWQE_LOG_STRIDE_SZ_BASE)
-bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
-				  struct mlx5e_params *params,
-				  struct mlx5e_xsk_param *xsk)
+bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
+				   u8 log_stride_sz, u8 log_num_strides)
 {
-	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params, xsk);
-	s8 signed_log_num_strides_param;
-	u8 log_num_strides;
+	if (log_stride_sz + log_num_strides != MLX5_MPWRQ_LOG_WQE_SZ)
+		return false;
 
-	if (!mlx5e_rx_is_linear_skb(params, xsk))
+	if (log_stride_sz < MLX5_MPWQE_LOG_STRIDE_SZ_BASE ||
+	    log_stride_sz > MLX5_MPWQE_LOG_STRIDE_SZ_MAX)
 		return false;
 
-	if (order_base_2(linear_frag_sz) > MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ)
+	if (log_num_strides > MLX5_MPWQE_LOG_NUM_STRIDES_MAX)
 		return false;
 
 	if (MLX5_CAP_GEN(mdev, ext_stride_num_range))
-		return true;
+		return log_num_strides >= MLX5_MPWQE_LOG_NUM_STRIDES_EXT_BASE;
 
-	log_num_strides = MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(linear_frag_sz);
-	signed_log_num_strides_param =
-		(s8)log_num_strides - MLX5_MPWQE_LOG_NUM_STRIDES_BASE;
+	return log_num_strides >= MLX5_MPWQE_LOG_NUM_STRIDES_BASE;
+}
 
-	return signed_log_num_strides_param >= 0;
+bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
+				  struct mlx5e_params *params,
+				  struct mlx5e_xsk_param *xsk)
+{
+	s8 log_num_strides;
+	u8 log_stride_sz;
+
+	if (!mlx5e_rx_is_linear_skb(params, xsk))
+		return false;
+
+	log_stride_sz = order_base_2(mlx5e_rx_get_linear_frag_sz(params, xsk));
+	log_num_strides = MLX5_MPWRQ_LOG_WQE_SZ - log_stride_sz;
+
+	return mlx5e_verify_rx_mpwqe_strides(mdev, log_stride_sz, log_num_strides);
 }
 
 u8 mlx5e_mpwqe_get_log_rq_size(struct mlx5e_params *params,
@@ -462,26 +471,36 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
 }
 
-void mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
-			  struct mlx5e_params *params,
-			  struct mlx5e_xsk_param *xsk,
-			  u16 q_counter,
-			  struct mlx5e_rq_param *param)
+int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
+			 struct mlx5e_params *params,
+			 struct mlx5e_xsk_param *xsk,
+			 u16 q_counter,
+			 struct mlx5e_rq_param *param)
 {
 	void *rqc = param->rqc;
 	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
 	int ndsegs = 1;
 
 	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ: {
+		u8 log_wqe_num_of_strides = mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
+		u8 log_wqe_stride_size = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
+
+		if (!mlx5e_verify_rx_mpwqe_strides(mdev, log_wqe_stride_size,
+						   log_wqe_num_of_strides)) {
+			mlx5_core_err(mdev,
+				      "Bad RX MPWQE params: log_stride_size %u, log_num_strides %u\n",
+				      log_wqe_stride_size, log_wqe_num_of_strides);
+			return -EINVAL;
+		}
+
 		MLX5_SET(wq, wq, log_wqe_num_of_strides,
-			 mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk) -
-			 MLX5_MPWQE_LOG_NUM_STRIDES_BASE);
+			 log_wqe_num_of_strides - MLX5_MPWQE_LOG_NUM_STRIDES_BASE);
 		MLX5_SET(wq, wq, log_wqe_stride_size,
-			 mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk) -
-			 MLX5_MPWQE_LOG_STRIDE_SZ_BASE);
+			 log_wqe_stride_size - MLX5_MPWQE_LOG_STRIDE_SZ_BASE);
 		MLX5_SET(wq, wq, log_wq_sz, mlx5e_mpwqe_get_log_rq_size(params, xsk));
 		break;
+	}
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
 		mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
@@ -499,6 +518,8 @@ void mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 	mlx5e_build_rx_cq_param(mdev, params, xsk, &param->cqp);
+
+	return 0;
 }
 
 void mlx5e_build_drop_rq_param(struct mlx5_core_dev *mdev,
@@ -643,14 +664,17 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
-void mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
-			       struct mlx5e_params *params,
-			       u16 q_counter,
-			       struct mlx5e_channel_param *cparam)
+int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
+			      struct mlx5e_params *params,
+			      u16 q_counter,
+			      struct mlx5e_channel_param *cparam)
 {
 	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
+	int err;
 
-	mlx5e_build_rq_param(mdev, params, NULL, q_counter, &cparam->rq);
+	err = mlx5e_build_rq_param(mdev, params, NULL, q_counter, &cparam->rq);
+	if (err)
+		return err;
 
 	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
 	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(mdev);
@@ -659,4 +683,6 @@ void mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 	mlx5e_build_xdpsq_param(mdev, params, &cparam->xdp_sq);
 	mlx5e_build_icosq_param(mdev, icosq_log_wq_sz, &cparam->icosq);
 	mlx5e_build_async_icosq_param(mdev, async_icosq_log_wq_sz, &cparam->async_icosq);
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index fcc51ec6084e..e9593f5f0661 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -96,6 +96,8 @@ void mlx5e_build_rq_params(struct mlx5_core_dev *mdev, struct mlx5e_params *para
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 
+bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
+				   u8 log_stride_sz, u8 log_num_strides);
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
@@ -122,11 +124,11 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 /* Build queue parameters */
 
 void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e_channel *c);
-void mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
-			  struct mlx5e_params *params,
-			  struct mlx5e_xsk_param *xsk,
-			  u16 q_counter,
-			  struct mlx5e_rq_param *param);
+int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
+			 struct mlx5e_params *params,
+			 struct mlx5e_xsk_param *xsk,
+			 u16 q_counter,
+			 struct mlx5e_rq_param *param);
 void mlx5e_build_drop_rq_param(struct mlx5_core_dev *mdev,
 			       u16 q_counter,
 			       struct mlx5e_rq_param *param);
@@ -141,10 +143,10 @@ void mlx5e_build_tx_cq_param(struct mlx5_core_dev *mdev,
 void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
 			     struct mlx5e_sq_param *param);
-void mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
-			       struct mlx5e_params *params,
-			       u16 q_counter,
-			       struct mlx5e_channel_param *cparam);
+int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
+			      struct mlx5e_params *params,
+			      u16 q_counter,
+			      struct mlx5e_channel_param *cparam);
 
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bc2d37d2806f..bca832cdc4cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2086,7 +2086,10 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	if (!chs->c || !cparam)
 		goto err_free;
 
-	mlx5e_build_channel_param(priv->mdev, &chs->params, priv->q_counter, cparam);
+	err = mlx5e_build_channel_param(priv->mdev, &chs->params, priv->q_counter, cparam);
+	if (err)
+		goto err_free;
+
 	for (i = 0; i < chs->num; i++) {
 		struct xsk_buff_pool *xsk_pool = NULL;
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 92a029a800a0..578c4ccae91c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -911,8 +911,11 @@ static inline u16 get_cqe_flow_tag(struct mlx5_cqe64 *cqe)
 	return be32_to_cpu(cqe->sop_drop_qpn) & 0xFFF;
 }
 
-#define MLX5_MPWQE_LOG_NUM_STRIDES_BASE	(9)
-#define MLX5_MPWQE_LOG_STRIDE_SZ_BASE	(6)
+#define MLX5_MPWQE_LOG_NUM_STRIDES_EXT_BASE	3
+#define MLX5_MPWQE_LOG_NUM_STRIDES_BASE		9
+#define MLX5_MPWQE_LOG_NUM_STRIDES_MAX		16
+#define MLX5_MPWQE_LOG_STRIDE_SZ_BASE		6
+#define MLX5_MPWQE_LOG_STRIDE_SZ_MAX		13
 
 struct mpwrq_cqe_bc {
 	__be16	filler_consumed_strides;
-- 
2.30.2

