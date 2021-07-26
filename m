Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE193D6502
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbhGZQSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241833AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2816960F6E;
        Mon, 26 Jul 2021 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318558;
        bh=YgO8KAoqnQlYZnINVZBYLU1GrAO8YmnXbyFhbdgiavc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXvwis669Fd/xzosRsSGGP0ExU90buy43LmJSG8R5KPHzlmU8EmToFjTdK5tfr4lo
         F085mTmmAXVqs6SI1wBeU/vyOnCPbD8mRl+VP9mDhiPSjggEQAbQ06W6tyt/UlbkuN
         f4v6dJiwZdQoIshgElA9Jn8x+BmcBYOmbQY2rJaOdrqJ/L5GnyX4mF56rWDTjaKsWh
         wCrrlIrOeHqf3oISBuSXgSxSoyvyo6/9s96fmitjIYgnFWbwHbY2UvlQXzRm5WiMSN
         K6SX6dvcqeU2JFziQbSwlRzLG/F7L9Psrh580D/5s394AdFEOka1X0/kIMddSwwP24
         ZjnU1WZDrhoeQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5e: Remove lro_param from mlx5e_build_indir_tir_ctx_common()
Date:   Mon, 26 Jul 2021 09:55:39 -0700
Message-Id: <20210726165544.389143-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

In order to reduce the list of parameters and to define clearer
responsibility for mlx5e_build_indir_tir_ctx_common(), stop passing
lro_param and instead call mlx5e_build_tir_ctx_lro() directly where
needed.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 72782f0fd5eb..69a4a9336615 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3130,7 +3130,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 }
 
 static void mlx5e_build_indir_tir_ctx_common(struct mlx5_core_dev *mdev,
-					     struct mlx5e_lro_param *lro_param,
 					     bool inner_ft_support,
 					     u32 rqtn, u32 *tirc)
 {
@@ -3138,8 +3137,6 @@ static void mlx5e_build_indir_tir_ctx_common(struct mlx5_core_dev *mdev,
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
 	MLX5_SET(tirc, tirc, indirect_table, rqtn);
 	MLX5_SET(tirc, tirc, tunneled_offload_en, inner_ft_support);
-
-	mlx5e_build_tir_ctx_lro(lro_param, tirc);
 }
 
 static void mlx5e_build_direct_tir_ctx(struct mlx5_core_dev *mdev,
@@ -3147,7 +3144,8 @@ static void mlx5e_build_direct_tir_ctx(struct mlx5_core_dev *mdev,
 				       bool inner_ft_support,
 				       u32 rqtn, u32 *tirc)
 {
-	mlx5e_build_indir_tir_ctx_common(mdev, lro_param, inner_ft_support, rqtn, tirc);
+	mlx5e_build_indir_tir_ctx_common(mdev, inner_ft_support, rqtn, tirc);
+	mlx5e_build_tir_ctx_lro(lro_param, tirc);
 	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
 }
 
@@ -3176,9 +3174,10 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		memset(in, 0, inlen);
 		tir = &res->rss[tt].indir_tir;
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_indir_tir_ctx_common(priv->mdev, &lro_param,
+		mlx5e_build_indir_tir_ctx_common(priv->mdev,
 						 priv->channels.params.tunneled_offload_en,
 						 indir_rqtn, tirc);
+		mlx5e_build_tir_ctx_lro(&lro_param, tirc);
 		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
 					       &tirc_default_config[tt], tirc, false);
 
@@ -3196,9 +3195,10 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		memset(in, 0, inlen);
 		tir = &res->rss[i].inner_indir_tir;
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_indir_tir_ctx_common(priv->mdev, &lro_param,
+		mlx5e_build_indir_tir_ctx_common(priv->mdev,
 						 priv->channels.params.tunneled_offload_en,
 						 indir_rqtn, tirc);
+		mlx5e_build_tir_ctx_lro(&lro_param, tirc);
 		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
 					       &tirc_default_config[i], tirc, true);
 		err = mlx5e_create_tir(priv->mdev, tir, in);
-- 
2.31.1

