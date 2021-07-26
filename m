Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BE23D64FE
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhGZQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241831AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DB5060F92;
        Mon, 26 Jul 2021 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318557;
        bh=FEga9gDd+3tz8meluN8Siw3+hIW3coc3zRLRF6+ujNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWB09V3gaii0QNcLqNg0cZ5qvXUl8g45E176Dqpu6gK9g3nxc+xEikSMtMu8iu+wa
         Ch1u23hCAWjyMSARZ0XbdPELJsP6eyZBhebewHephYbkU1ViOjawBHRsBFROoyCzOi
         DrMiMs1lNm8dIHSGem2/vDK1I7P+MME/55AGCr/rkKwAyfo7ySOIypNWRSu24asifo
         em4JOZRNU41pkqU0t8i/Ycp0I2XDnWFrXGLVpxfevf6VL1Jm31SrTgsP2tF9qxDd6x
         8j13/bxzGtbQBb5hf+nGuBjEyH/MhifZpXnT7aVhcd/H7LmkxbsJAWtjkHeYjwIMQW
         ciAODVVyYuIbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5e: Use mlx5e_rqt_get_rqtn to access RQT hardware id
Date:   Mon, 26 Jul 2021 09:55:37 -0700
Message-Id: <20210726165544.389143-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

In order to abstract from implementation details of mlx5e_rqt, use the
mlx5e_rqt_get_rqtn getter instead of accessing the field directly.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      | 10 +++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 15153317a083..44bc6efd62fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -635,7 +635,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
-	rqtn = priv->rx_res->channels[rxq].direct_rqt.rqtn;
+	rqtn = mlx5e_rqt_get_rqtn(&priv->rx_res->channels[rxq].direct_rqt);
 
 	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tirn, rqtn);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0e387799ee93..a70ada2e7208 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3143,7 +3143,9 @@ static void mlx5e_build_indir_tir_ctx(struct mlx5e_priv *priv,
 				      enum mlx5e_traffic_types tt,
 				      u32 *tirc)
 {
-	mlx5e_build_indir_tir_ctx_common(priv, priv->rx_res->indir_rqt.rqtn, tirc);
+	u32 rqtn = mlx5e_rqt_get_rqtn(&priv->rx_res->indir_rqt);
+
+	mlx5e_build_indir_tir_ctx_common(priv, rqtn, tirc);
 	mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
 				       &tirc_default_config[tt], tirc, false);
 }
@@ -3158,7 +3160,9 @@ static void mlx5e_build_inner_indir_tir_ctx(struct mlx5e_priv *priv,
 					    enum mlx5e_traffic_types tt,
 					    u32 *tirc)
 {
-	mlx5e_build_indir_tir_ctx_common(priv, priv->rx_res->indir_rqt.rqtn, tirc);
+	u32 rqtn = mlx5e_rqt_get_rqtn(&priv->rx_res->indir_rqt);
+
+	mlx5e_build_indir_tir_ctx_common(priv, rqtn, tirc);
 	mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
 				       &tirc_default_config[tt], tirc, true);
 }
@@ -3237,7 +3241,7 @@ static int mlx5e_create_direct_tir(struct mlx5e_priv *priv, struct mlx5e_tir *ti
 		return -ENOMEM;
 
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-	mlx5e_build_direct_tir_ctx(priv, rqt->rqtn, tirc);
+	mlx5e_build_direct_tir_ctx(priv, mlx5e_rqt_get_rqtn(rqt), tirc);
 	err = mlx5e_create_tir(priv->mdev, tir, in);
 	if (unlikely(err))
 		mlx5_core_warn(priv->mdev, "create tirs failed, %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4c00abc472be..dd5546fb0f42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -528,7 +528,7 @@ static int mlx5e_hairpin_create_indirect_tirs(struct mlx5e_hairpin *hp)
 
 		MLX5_SET(tirc, tirc, transport_domain, hp->tdn);
 		MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
-		MLX5_SET(tirc, tirc, indirect_table, hp->indir_rqt.rqtn);
+		MLX5_SET(tirc, tirc, indirect_table, mlx5e_rqt_get_rqtn(&hp->indir_rqt));
 		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params, &ttconfig,
 					       tirc, false);
 
-- 
2.31.1

