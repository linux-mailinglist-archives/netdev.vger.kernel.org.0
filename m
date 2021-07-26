Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2583D64F4
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhGZQRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241127AbhGZQPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275DB60F4F;
        Mon, 26 Jul 2021 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318553;
        bh=zIcP6Fu0+OeXOKM6WogiOguybbb1wYHbzeJC3h8Pi8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2lYZOJQ5Z8MpvFoiul8FKeauHE4NnCA/ymCtLwPDjN16LFuCXBqbr9X8MNYS1SVE
         bqKX2iN1NqL/IgH4C+6syHwyMbfk4KP7nUKnLQ5nSb5wIdwBQCkO0SJAOG4DchK842
         AMjXpxruWqHJNUidC4auLk8oG8GHW1cmKf6Qk7eaIhXlAP+bC6/Bi8PxxXFgar6bWb
         iOl/ZJqRJrHG58hApsF0rHD7v4f3t3utftVNPqk1I0qjjS362I3eM2VN7t6tHFFHbc
         um6H5qC/LzqNYn8JqGHB12pdBFqroC5WtOEvhL7KaCRPPbU+jokjifR64AL5lUQaHe
         bUqZrLEqNpCZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5e: Prohibit inner indir TIRs in IPoIB
Date:   Mon, 26 Jul 2021 09:55:29 -0700
Message-Id: <20210726165544.389143-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

TIR's rx_hash_field_selector_inner can be enabled only when
tunneled_offload_en = 1. tunneled_offload_en is filled according to the
tunneled_offload_en field in struct mlx5e_params, which is false in the
IPoIB profile. On the other hand, the IPoIB profile passes inner_ttc =
true to mlx5e_create_indirect_tirs, which potentially allows the latter
function to attempt to create inner indirect TIRs without having
tunneled_offload_en set.

This commit prohibits this behavior by passing inner_ttc = false to
mlx5e_create_indirect_tirs. The latter function won't attempt to create
inner indirect TIRs.

As inner indirect TIRs are not created in the IPoIB profile (this commit
blocks it explicitly, and even before they would have failed to be
created), the call to mlx5e_create_inner_ttc_table in
mlx5i_create_flow_steering is a no-op and can be removed.

Fixes: 46dc933cee82 ("net/mlx5e: Provide explicit directive if to create inner indirect tirs")
Fixes: 458821c72bd0 ("net/mlx5e: IPoIB, Add inner TTC table to IPoIB flow steering")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h    |  6 ------
 .../net/ethernet/mellanox/mlx5/core/en_fs.c    | 10 +++++-----
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c  | 18 ++----------------
 3 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 1d5ce07b83f4..43b092f5565a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -248,18 +248,12 @@ struct ttc_params {
 
 void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv, struct ttc_params *ttc_params);
 void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params);
-void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params);
 
 int mlx5e_create_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
 			   struct mlx5e_ttc_table *ttc);
 void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv,
 			     struct mlx5e_ttc_table *ttc);
 
-int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-				 struct mlx5e_ttc_table *ttc);
-void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-				   struct mlx5e_ttc_table *ttc);
-
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
 int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type,
 		       struct mlx5_flow_destination *new_dest);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 0b75fab41ae8..6464ac3f294e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1324,7 +1324,7 @@ void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv,
 	ttc_params->inner_ttc = &priv->fs.inner_ttc;
 }
 
-void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
+static void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
 {
 	struct mlx5_flow_table_attr *ft_attr = &ttc_params->ft_attr;
 
@@ -1343,8 +1343,8 @@ void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params)
 	ft_attr->prio = MLX5E_NIC_PRIO;
 }
 
-int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-				 struct mlx5e_ttc_table *ttc)
+static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
+					struct mlx5e_ttc_table *ttc)
 {
 	struct mlx5e_flow_table *ft = &ttc->ft;
 	int err;
@@ -1374,8 +1374,8 @@ int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *par
 	return err;
 }
 
-void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-				   struct mlx5e_ttc_table *ttc)
+static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
+					  struct mlx5e_ttc_table *ttc)
 {
 	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 7d7ed025db0d..620d638e1e8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -331,17 +331,6 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	}
 
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
-	mlx5e_set_inner_ttc_ft_params(&ttc_params);
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->inner_indir_tir[tt].tirn;
-
-	err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
-	if (err) {
-		netdev_err(priv->netdev, "Failed to create inner ttc table, err=%d\n",
-			   err);
-		goto err_destroy_arfs_tables;
-	}
-
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
@@ -350,13 +339,11 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
-		goto err_destroy_inner_ttc_table;
+		goto err_destroy_arfs_tables;
 	}
 
 	return 0;
 
-err_destroy_inner_ttc_table:
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
 
@@ -366,7 +353,6 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 	mlx5e_arfs_destroy_tables(priv);
 }
 
@@ -392,7 +378,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_indirect_rqts;
 
-	err = mlx5e_create_indirect_tirs(priv, true);
+	err = mlx5e_create_indirect_tirs(priv, false);
 	if (err)
 		goto err_destroy_direct_rqts;
 
-- 
2.31.1

