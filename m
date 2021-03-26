Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99E2349FF8
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhCZCyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhCZCxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C8261A41;
        Fri, 26 Mar 2021 02:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727229;
        bh=Z3k3Wi9xdMs8WtZfy3xQqbYXgtbKECcPZr2iE1HTx3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7ncJZOqNPoFJJSvykgPCjqa2ktmCgfVX1CvzBndOsIisFu/JJbPTFGYYCReh8FKt
         9jK3ppw+4wcjj596y5v5VCbWNOI0PwEfUmhzsraEdFS33kBNYBDLbBtDR17Ve+k+fr
         NjLL8DUdC6OtKlPgVa+rghF8sxk6SSOlrjgO65NFV8wAyHPdRnBg2DTRWrqKakqcRk
         d2dUdhz0Z/QWS1Yb/FnGmCFLSTuS1jZ5GeXLPxw/HceL4yjiHvtjmnhO4MYvd6g6nW
         HHuEI4B0kuUdd67n9UOVp4pxfRk5cXVZbof56a0K6x/oPNDvi/2DgzNaUSwyNrbHyN
         o58kI6DMfOPPw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/13] net/mlx5e: Pass q_counter indentifier as parameter to rq_param builders
Date:   Thu, 25 Mar 2021 19:53:34 -0700
Message-Id: <20210326025345.456475-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Pass q_counter idintifier, instead of reading it from mlx5e_priv
parameter.
This is a step towards removing the mlx5e_priv parameter from all
params function and logic in the next patches of the series.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 13 ++++++++-----
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index ea2cfb04b31a..97a5bf50a53b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -115,6 +115,7 @@ void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e
 void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
+			  u16 q_counter,
 			  struct mlx5e_rq_param *param);
 void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
 				 struct mlx5e_sq_param *param);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 41db93883fea..0bfbc8cbe840 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -245,7 +245,7 @@ static void mlx5e_build_trap_params(struct mlx5e_priv *priv, struct mlx5e_trap *
 	params->rq_wq_type = MLX5_WQ_TYPE_CYCLIC;
 	mlx5e_init_rq_type_params(priv->mdev, params);
 	params->sw_mtu = priv->netdev->max_mtu;
-	mlx5e_build_rq_param(priv, params, NULL, &t->rq_param);
+	mlx5e_build_rq_param(priv, params, NULL, priv->q_counter, &t->rq_param);
 }
 
 static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index f4bce1365639..d84a2299adf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -40,7 +40,7 @@ static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
 				   struct mlx5e_xsk_param *xsk,
 				   struct mlx5e_channel_param *cparam)
 {
-	mlx5e_build_rq_param(priv, params, xsk, &cparam->rq);
+	mlx5e_build_rq_param(priv, params, xsk, priv->q_counter, &cparam->rq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d40fc2672530..6aae2bce32f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2190,6 +2190,7 @@ static u8 mlx5e_get_rq_log_wq_sz(void *rqc)
 void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
+			  u16 q_counter,
 			  struct mlx5e_rq_param *param)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -2218,7 +2219,7 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(wq, wq, log_wq_stride,
 		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
 	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.hw_objs.pdn);
-	MLX5_SET(rqc, rqc, counter_set_id, priv->q_counter);
+	MLX5_SET(rqc, rqc, counter_set_id, q_counter);
 	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
 	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
 
@@ -2227,6 +2228,7 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 }
 
 static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
+				      u16 q_counter,
 				      struct mlx5e_rq_param *param)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -2236,7 +2238,7 @@ static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
 	MLX5_SET(wq, wq, log_wq_stride,
 		 mlx5e_get_rqwq_log_stride(MLX5_WQ_TYPE_CYCLIC, 1));
-	MLX5_SET(rqc, rqc, counter_set_id, priv->drop_rq_q_counter);
+	MLX5_SET(rqc, rqc, counter_set_id, q_counter);
 
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 }
@@ -2386,11 +2388,12 @@ static u8 mlx5e_build_async_icosq_log_wq_sz(struct net_device *netdev)
 
 static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 				      struct mlx5e_params *params,
+				      u16 q_counter,
 				      struct mlx5e_channel_param *cparam)
 {
 	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
 
-	mlx5e_build_rq_param(priv, params, NULL, &cparam->rq);
+	mlx5e_build_rq_param(priv, params, NULL, q_counter, &cparam->rq);
 
 	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
 	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(priv->netdev);
@@ -2415,7 +2418,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	if (!chs->c || !cparam)
 		goto err_free;
 
-	mlx5e_build_channel_param(priv, &chs->params, cparam);
+	mlx5e_build_channel_param(priv, &chs->params, priv->q_counter, cparam);
 	for (i = 0; i < chs->num; i++) {
 		struct xsk_buff_pool *xsk_pool = NULL;
 
@@ -3376,7 +3379,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 	struct mlx5e_cq *cq = &drop_rq->cq;
 	int err;
 
-	mlx5e_build_drop_rq_param(priv, &rq_param);
+	mlx5e_build_drop_rq_param(priv, priv->drop_rq_q_counter, &rq_param);
 
 	err = mlx5e_alloc_drop_cq(priv, cq, &cq_param);
 	if (err)
-- 
2.30.2

