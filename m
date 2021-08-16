Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBF53EDF30
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhHPVTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhHPVTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C376361075;
        Mon, 16 Aug 2021 21:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148742;
        bh=PSg6rHNPs51vmWz5MurCJWMOtaTw+6JlcjTCVul7xr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6425rUbXwVvZb6wMgZCxwcsSwktU/b+q7wbULb8fDnjvvCZgGbD5M1D0oPgKbq0s
         N/qhh2SFfY7dRPO2sjkpy7idT/k0eM4XstQr2Z0+1TMdkokgOtkMtRFHr/RUZyYPMn
         RP7tK5po+7xIAiCZ6D733MTOJmiTLNJWwLrOm0S3BA5ABV+bJqqQGtOux8SgSQ2FTw
         9N7phR1w52Dt9CpJOjFraD4wH6uaOO/XwYdpJkT8jhkkkagRofQWYeBvm/6av+0GTd
         WynA+6OG1MMbXnWttEqm6ls3drLMks89KdNBxo3bm6j75zuiApihJ9mbhCV6PVEzKX
         cY8tVBOLYwokw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/17] net/mlx5e: Introduce TIR create/destroy API in rx_res
Date:   Mon, 16 Aug 2021 14:18:32 -0700
Message-Id: <20210816211847.526937-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Take TIR control operations in rx_res into functions.
This is in preparation to supporting on-demand TIR operations in
downstream patches.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 140 +++++++++++-------
 1 file changed, 83 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index 2d0e8c809936..dfa492a14928 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -117,84 +117,114 @@ static void mlx5e_rx_res_rss_params_init(struct mlx5e_rx_res *res, unsigned int
 			mlx5e_rss_get_default_tt_config(tt).rx_hash_fields;
 }
 
-static int mlx5e_rx_res_rss_init(struct mlx5e_rx_res *res,
-				 const struct mlx5e_lro_param *init_lro_param)
+static void mlx5e_rx_res_rss_destroy_tir(struct mlx5e_rx_res *res,
+					 enum mlx5_traffic_types tt,
+					 bool inner)
+{
+	struct mlx5e_tir *tir;
+
+	tir = inner ? &res->rss[tt].inner_indir_tir : &res->rss[tt].indir_tir;
+	mlx5e_tir_destroy(tir);
+}
+
+static int mlx5e_rx_res_rss_create_tir(struct mlx5e_rx_res *res,
+				       struct mlx5e_tir_builder *builder,
+				       enum mlx5_traffic_types tt,
+				       const struct mlx5e_lro_param *init_lro_param,
+				       bool inner)
 {
 	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
+	struct mlx5e_rss_params_traffic_type rss_tt;
+	struct mlx5e_tir *tir;
+	u32 rqtn;
+	int err;
+
+	tir = inner ? &res->rss[tt].inner_indir_tir : &res->rss[tt].indir_tir;
+
+	rqtn = mlx5e_rqt_get_rqtn(&res->indir_rqt);
+	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
+				    rqtn, inner_ft_support);
+	mlx5e_tir_builder_build_lro(builder, init_lro_param);
+	rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
+	mlx5e_tir_builder_build_rss(builder, &res->rss_params.hash, &rss_tt, inner);
+
+	err = mlx5e_tir_init(tir, builder, res->mdev, true);
+	if (err) {
+		mlx5_core_warn(res->mdev, "Failed to create %sindirect TIR: err = %d, tt = %d\n",
+			       inner ? "inner " : "", err, tt);
+		return err;
+	}
+
+	return 0;
+}
+
+static int mlx5e_rx_res_rss_create_tirs(struct mlx5e_rx_res *res,
+					const struct mlx5e_lro_param *init_lro_param,
+					bool inner)
+{
 	enum mlx5_traffic_types tt, max_tt;
 	struct mlx5e_tir_builder *builder;
-	u32 indir_rqtn;
 	int err;
 
 	builder = mlx5e_tir_builder_alloc(false);
 	if (!builder)
 		return -ENOMEM;
 
-	err = mlx5e_rqt_init_direct(&res->indir_rqt, res->mdev, true, res->drop_rqn);
-	if (err)
-		goto out;
-
-	indir_rqtn = mlx5e_rqt_get_rqtn(&res->indir_rqt);
-
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		struct mlx5e_rss_params_traffic_type rss_tt;
-
-		mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
-					    indir_rqtn, inner_ft_support);
-		mlx5e_tir_builder_build_lro(builder, init_lro_param);
-		rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
-		mlx5e_tir_builder_build_rss(builder, &res->rss_params.hash, &rss_tt, false);
-
-		err = mlx5e_tir_init(&res->rss[tt].indir_tir, builder, res->mdev, true);
-		if (err) {
-			mlx5_core_warn(res->mdev, "Failed to create an indirect TIR: err = %d, tt = %d\n",
-				       err, tt);
+		err = mlx5e_rx_res_rss_create_tir(res, builder, tt, init_lro_param, inner);
+		if (err)
 			goto err_destroy_tirs;
-		}
 
 		mlx5e_tir_builder_clear(builder);
 	}
 
-	if (!inner_ft_support)
-		goto out;
+out:
+	mlx5e_tir_builder_free(builder);
+	return err;
 
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		struct mlx5e_rss_params_traffic_type rss_tt;
+err_destroy_tirs:
+	max_tt = tt;
+	for (tt = 0; tt < max_tt; tt++)
+		mlx5e_rx_res_rss_destroy_tir(res, tt, inner);
+	goto out;
+}
 
-		mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
-					    indir_rqtn, inner_ft_support);
-		mlx5e_tir_builder_build_lro(builder, init_lro_param);
-		rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
-		mlx5e_tir_builder_build_rss(builder, &res->rss_params.hash, &rss_tt, true);
+static void mlx5e_rx_res_rss_destroy_tirs(struct mlx5e_rx_res *res, bool inner)
+{
+	enum mlx5_traffic_types tt;
 
-		err = mlx5e_tir_init(&res->rss[tt].inner_indir_tir, builder, res->mdev, true);
-		if (err) {
-			mlx5_core_warn(res->mdev, "Failed to create an inner indirect TIR: err = %d, tt = %d\n",
-				       err, tt);
-			goto err_destroy_inner_tirs;
-		}
+	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
+		mlx5e_rx_res_rss_destroy_tir(res, tt, inner);
+}
 
-		mlx5e_tir_builder_clear(builder);
-	}
+static int mlx5e_rx_res_rss_init(struct mlx5e_rx_res *res,
+				 const struct mlx5e_lro_param *init_lro_param)
+{
+	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
+	int err;
 
-	goto out;
+	err = mlx5e_rqt_init_direct(&res->indir_rqt, res->mdev, true, res->drop_rqn);
+	if (err)
+		return err;
 
-err_destroy_inner_tirs:
-	max_tt = tt;
-	for (tt = 0; tt < max_tt; tt++)
-		mlx5e_tir_destroy(&res->rss[tt].inner_indir_tir);
+	err = mlx5e_rx_res_rss_create_tirs(res, init_lro_param, false);
+	if (err)
+		goto err_destroy_rqt;
+
+	if (inner_ft_support) {
+		err = mlx5e_rx_res_rss_create_tirs(res, init_lro_param, true);
+		if (err)
+			goto err_destroy_tirs;
+	}
+
+	return 0;
 
-	tt = MLX5E_NUM_INDIR_TIRS;
 err_destroy_tirs:
-	max_tt = tt;
-	for (tt = 0; tt < max_tt; tt++)
-		mlx5e_tir_destroy(&res->rss[tt].indir_tir);
+	mlx5e_rx_res_rss_destroy_tirs(res, false);
 
+err_destroy_rqt:
 	mlx5e_rqt_destroy(&res->indir_rqt);
 
-out:
-	mlx5e_tir_builder_free(builder);
-
 	return err;
 }
 
@@ -337,14 +367,10 @@ static int mlx5e_rx_res_ptp_init(struct mlx5e_rx_res *res)
 
 static void mlx5e_rx_res_rss_destroy(struct mlx5e_rx_res *res)
 {
-	enum mlx5_traffic_types tt;
-
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		mlx5e_tir_destroy(&res->rss[tt].indir_tir);
+	mlx5e_rx_res_rss_destroy_tirs(res, false);
 
 	if (res->features & MLX5E_RX_RES_FEATURE_INNER_FT)
-		for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-			mlx5e_tir_destroy(&res->rss[tt].inner_indir_tir);
+		mlx5e_rx_res_rss_destroy_tirs(res, true);
 
 	mlx5e_rqt_destroy(&res->indir_rqt);
 }
-- 
2.31.1

