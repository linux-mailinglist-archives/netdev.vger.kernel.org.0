Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14923D64FB
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhGZQSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241313AbhGZQPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D8A60F6D;
        Mon, 26 Jul 2021 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318554;
        bh=O4/y+5JMftspdi1zUdOeeWKP9myX6PFVSwrLjjAENSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbA10ydHBiucUuealfRmX7JemEZADtXciHw35XhzFaLtFQaUwfdWJxQ8Fd3OerQGP
         lWOts9e/OEQwlyflFMdPYywxvlqoDr79ZjGPp3yViOzYU0tUiQJ0r6Wc353nmQtrYK
         2EverqMoFX6yXjECISDEs+deC+f9cd0ITD9DowKHqgVnO8m0F7+dgFMbE53/CO7URg
         R+n2PofICTkn9GVKuX4cXcVwkQ6tacwP9q5AjJOU5mJf74j0k3z1N0j+9kvMFgoZGG
         +RtNPbNdCpaWGWiB3BwER8Qj78IC3ljLH4I9/7YDhm9aKWlFaEWfbf0HWIIPYfUKQS
         QsxKtT/6TLG3w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5e: Check if inner FT is supported outside of create/destroy functions
Date:   Mon, 26 Jul 2021 09:55:32 -0700
Message-Id: <20210726165544.389143-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Move the mlx5e_tunnel_inner_ft_supported() check for inner flow tables
support outside of mlx5e_create_inner_ttc_table() and
mlx5e_destroy_inner_ttc_table(). It allows to avoid accessing invalid
TIRNs of inner indirect TIRs. In a later commit these accesses will be
replaced by getters that will WARN if inner indirect TIRs don't exist.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 6464ac3f294e..1a38c527423e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1349,9 +1349,6 @@ static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_para
 	struct mlx5e_flow_table *ft = &ttc->ft;
 	int err;
 
-	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
-		return 0;
-
 	ft->t = mlx5_create_flow_table(priv->fs.ns, &params->ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
@@ -1377,9 +1374,6 @@ static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_para
 static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
 					  struct mlx5e_ttc_table *ttc)
 {
-	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
-		return;
-
 	mlx5e_cleanup_ttc_rules(ttc);
 	mlx5e_destroy_flow_table(&ttc->ft);
 }
@@ -1788,15 +1782,18 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	}
 
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
-	mlx5e_set_inner_ttc_ft_params(&ttc_params);
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->inner_indir_tir[tt].tirn;
 
-	err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
-	if (err) {
-		netdev_err(priv->netdev, "Failed to create inner ttc table, err=%d\n",
-			   err);
-		goto err_destroy_arfs_tables;
+	if (mlx5e_tunnel_inner_ft_supported(priv->mdev)) {
+		mlx5e_set_inner_ttc_ft_params(&ttc_params);
+		for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
+			ttc_params.indir_tirn[tt] = priv->inner_indir_tir[tt].tirn;
+
+		err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
+		if (err) {
+			netdev_err(priv->netdev, "Failed to create inner ttc table, err=%d\n",
+				   err);
+			goto err_destroy_arfs_tables;
+		}
 	}
 
 	mlx5e_set_ttc_ft_params(&ttc_params);
@@ -1839,7 +1836,8 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_inner_ttc_table:
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
+	if (mlx5e_tunnel_inner_ft_supported(priv->mdev))
+		mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
 
@@ -1852,7 +1850,8 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
+	if (mlx5e_tunnel_inner_ft_supported(priv->mdev))
+		mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 	mlx5e_arfs_destroy_tables(priv);
 	mlx5e_ethtool_cleanup_steering(priv);
 }
-- 
2.31.1

