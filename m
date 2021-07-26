Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776C33D6509
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbhGZQTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241834AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB8860F6C;
        Mon, 26 Jul 2021 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318558;
        bh=xSWPfZ8GMwHEr7buJUrGU/vrdXW6FuwRJ/pJmdJDraQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3V76FU9SLSaKsgAsT/fT1yVBD5fs33PaC30veEJsQsR/rycCDfydiDPEOp2nrq1W
         sJ787YRe4br5+D4g7Lw3MezY6Fur0LHNUgCnoHINmW4b0iTaq8+QjnctgmYNTqnApX
         W5fUiryhFbNxN5lsWNU0sNqZBxKGydRhDreMMv7HTD+6vxUbKR1owCddosiJx4LbdB
         gzeTF/c7Gt9gWz1zZ55L7oNi9xE2oootmjMQFa4lo25Ku1dLghS1dyyVusNLXue04A
         icWP2Id1uvKJyns3Rb0n09Vit7U9YnZ8HImLp735bfO6HKLzRL3y079HlJNfPGRqcc
         K4qUpXRtEdFbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5e: Remove mdev from mlx5e_build_indir_tir_ctx_common()
Date:   Mon, 26 Jul 2021 09:55:40 -0700
Message-Id: <20210726165544.389143-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

In order to drop a dependency to mdev and make the function more
universal, stop passing mdev to mlx5e_build_indir_tir_ctx_common() and
pass transport domain directly instead. It also prepares this function
to be used in other contexts that need a custom transport domain, such
as hairpin.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 69a4a9336615..53a51ac86d64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3129,22 +3129,20 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 	mlx5e_destroy_tises(priv);
 }
 
-static void mlx5e_build_indir_tir_ctx_common(struct mlx5_core_dev *mdev,
-					     bool inner_ft_support,
+static void mlx5e_build_indir_tir_ctx_common(u32 tdn, bool inner_ft_support,
 					     u32 rqtn, u32 *tirc)
 {
-	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
+	MLX5_SET(tirc, tirc, transport_domain, tdn);
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
 	MLX5_SET(tirc, tirc, indirect_table, rqtn);
 	MLX5_SET(tirc, tirc, tunneled_offload_en, inner_ft_support);
 }
 
-static void mlx5e_build_direct_tir_ctx(struct mlx5_core_dev *mdev,
-				       struct mlx5e_lro_param *lro_param,
-				       bool inner_ft_support,
+static void mlx5e_build_direct_tir_ctx(struct mlx5e_lro_param *lro_param,
+				       u32 tdn, bool inner_ft_support,
 				       u32 rqtn, u32 *tirc)
 {
-	mlx5e_build_indir_tir_ctx_common(mdev, inner_ft_support, rqtn, tirc);
+	mlx5e_build_indir_tir_ctx_common(tdn, inner_ft_support, rqtn, tirc);
 	mlx5e_build_tir_ctx_lro(lro_param, tirc);
 	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
 }
@@ -3174,7 +3172,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		memset(in, 0, inlen);
 		tir = &res->rss[tt].indir_tir;
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_indir_tir_ctx_common(priv->mdev,
+		mlx5e_build_indir_tir_ctx_common(priv->mdev->mlx5e_res.hw_objs.td.tdn,
 						 priv->channels.params.tunneled_offload_en,
 						 indir_rqtn, tirc);
 		mlx5e_build_tir_ctx_lro(&lro_param, tirc);
@@ -3195,7 +3193,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		memset(in, 0, inlen);
 		tir = &res->rss[i].inner_indir_tir;
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_indir_tir_ctx_common(priv->mdev,
+		mlx5e_build_indir_tir_ctx_common(priv->mdev->mlx5e_res.hw_objs.td.tdn,
 						 priv->channels.params.tunneled_offload_en,
 						 indir_rqtn, tirc);
 		mlx5e_build_tir_ctx_lro(&lro_param, tirc);
@@ -3241,7 +3239,8 @@ static int mlx5e_create_direct_tir(struct mlx5e_priv *priv, struct mlx5e_tir *ti
 
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 	lro_param = mlx5e_get_lro_param(&priv->channels.params);
-	mlx5e_build_direct_tir_ctx(priv->mdev, &lro_param,
+	mlx5e_build_direct_tir_ctx(&lro_param,
+				   priv->mdev->mlx5e_res.hw_objs.td.tdn,
 				   priv->channels.params.tunneled_offload_en,
 				   mlx5e_rqt_get_rqtn(rqt), tirc);
 	err = mlx5e_create_tir(priv->mdev, tir, in);
-- 
2.31.1

