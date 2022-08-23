Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA3459D0D4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbiHWF4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240352AbiHWF4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547B35F21B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E545061483
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389E2C433B5;
        Tue, 23 Aug 2022 05:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234153;
        bh=T3MTFwpEem1zAdDaoOor25V54Cfyw97L9IO54f4QwbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gq4T7TWAFZ7SZ47uqvZjSpHqBUC82HpmRVo8dXfbcC5wUSUiSwB38DGDGGH0yr8Vu
         faLeTFRkmbEiX9zdJGDBtQl1iX4Y/GlfP21JgIrby8usbHa3pDHz2slRa4t3FSu1L/
         kBnT8jDAUk4RMDSLUFURaEihWPFX/Rxfp1D/XwpOfmhp6+mNMu1PZuHX85qMlqlZDK
         JuhSgUMSj1NTI5yS6WhmECftWMPUJrAiQQnok4rPHuRKO+MMP72+j9Z5qVm1CHo33J
         63IfRxmGhslhDVV0XNn1YjZa+bhTswc4Bdgc+oiboXmvzLd7lSLUMBT4Kbz9JgfTu4
         1S8Z4mxTGsnVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Make all ttc functions of en_fs get fs struct as argument
Date:   Mon, 22 Aug 2022 22:55:28 -0700
Message-Id: <20220823055533.334471-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Let all ttc creation be independent of priv, and pass relevant members
of priv only.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  8 ++-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 65 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  4 +-
 4 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 389f389b814b..3d86d8021958 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -123,11 +123,13 @@ struct mlx5e_fs_udp;
 struct mlx5e_fs_any;
 struct mlx5e_ptp_fs;
 
-void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
+void mlx5e_set_ttc_params(struct mlx5e_flow_steering *fs,
+			  struct mlx5e_rx_res *rx_res,
 			  struct ttc_params *ttc_params, bool tunnel);
 
-void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv);
-int mlx5e_create_ttc_table(struct mlx5e_priv *priv);
+void mlx5e_destroy_ttc_table(struct mlx5e_flow_steering *fs);
+int mlx5e_create_ttc_table(struct mlx5e_flow_steering  *fs,
+			   struct mlx5e_rx_res *rx_res);
 
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1c7842dd0462..49bc52559896 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -883,14 +883,15 @@ void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft)
 	ft->t = NULL;
 }
 
-static void mlx5e_set_inner_ttc_params(struct mlx5e_priv *priv,
+static void mlx5e_set_inner_ttc_params(struct mlx5e_flow_steering *fs,
+				       struct mlx5e_rx_res *rx_res,
 				       struct ttc_params *ttc_params)
 {
 	struct mlx5_flow_table_attr *ft_attr = &ttc_params->ft_attr;
 	int tt;
 
 	memset(ttc_params, 0, sizeof(*ttc_params));
-	ttc_params->ns = mlx5_get_flow_namespace(priv->fs->mdev,
+	ttc_params->ns = mlx5_get_flow_namespace(fs->mdev,
 						 MLX5_FLOW_NAMESPACE_KERNEL);
 	ft_attr->level = MLX5E_INNER_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_NIC_PRIO;
@@ -899,13 +900,14 @@ static void mlx5e_set_inner_ttc_params(struct mlx5e_priv *priv,
 		ttc_params->dests[tt].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 		ttc_params->dests[tt].tir_num =
 			tt == MLX5_TT_ANY ?
-				mlx5e_rx_res_get_tirn_direct(priv->rx_res, 0) :
-				mlx5e_rx_res_get_tirn_rss_inner(priv->rx_res,
+				mlx5e_rx_res_get_tirn_direct(rx_res, 0) :
+				mlx5e_rx_res_get_tirn_rss_inner(rx_res,
 								tt);
 	}
 }
 
-void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
+void mlx5e_set_ttc_params(struct mlx5e_flow_steering *fs,
+			  struct mlx5e_rx_res *rx_res,
 			  struct ttc_params *ttc_params, bool tunnel)
 
 {
@@ -913,7 +915,7 @@ void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 	int tt;
 
 	memset(ttc_params, 0, sizeof(*ttc_params));
-	ttc_params->ns = mlx5_get_flow_namespace(priv->fs->mdev,
+	ttc_params->ns = mlx5_get_flow_namespace(fs->mdev,
 						 MLX5_FLOW_NAMESPACE_KERNEL);
 	ft_attr->level = MLX5E_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_NIC_PRIO;
@@ -922,19 +924,19 @@ void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 		ttc_params->dests[tt].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 		ttc_params->dests[tt].tir_num =
 			tt == MLX5_TT_ANY ?
-				mlx5e_rx_res_get_tirn_direct(priv->rx_res, 0) :
-				mlx5e_rx_res_get_tirn_rss(priv->rx_res, tt);
+				mlx5e_rx_res_get_tirn_direct(rx_res, 0) :
+				mlx5e_rx_res_get_tirn_rss(rx_res, tt);
 	}
 
 	ttc_params->inner_ttc = tunnel;
-	if (!tunnel || !mlx5_tunnel_inner_ft_supported(priv->fs->mdev))
+	if (!tunnel || !mlx5_tunnel_inner_ft_supported(fs->mdev))
 		return;
 
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
 		ttc_params->tunnel_dests[tt].type =
 			MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 		ttc_params->tunnel_dests[tt].ft =
-			mlx5_get_ttc_flow_table(priv->fs->inner_ttc);
+			mlx5_get_ttc_flow_table(fs->inner_ttc);
 	}
 }
 
@@ -1260,34 +1262,36 @@ static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv)
 	mlx5_destroy_ttc_table(priv->fs->inner_ttc);
 }
 
-void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv)
+void mlx5e_destroy_ttc_table(struct mlx5e_flow_steering *fs)
 {
-	mlx5_destroy_ttc_table(priv->fs->ttc);
+	mlx5_destroy_ttc_table(fs->ttc);
 }
 
-static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv)
+static int mlx5e_create_inner_ttc_table(struct mlx5e_flow_steering *fs,
+					struct mlx5e_rx_res *rx_res)
 {
 	struct ttc_params ttc_params = {};
 
-	if (!mlx5_tunnel_inner_ft_supported(priv->fs->mdev))
+	if (!mlx5_tunnel_inner_ft_supported(fs->mdev))
 		return 0;
 
-	mlx5e_set_inner_ttc_params(priv, &ttc_params);
-	priv->fs->inner_ttc = mlx5_create_inner_ttc_table(priv->fs->mdev,
-							  &ttc_params);
-	if (IS_ERR(priv->fs->inner_ttc))
-		return PTR_ERR(priv->fs->inner_ttc);
+	mlx5e_set_inner_ttc_params(fs, rx_res, &ttc_params);
+	fs->inner_ttc = mlx5_create_inner_ttc_table(fs->mdev,
+						    &ttc_params);
+	if (IS_ERR(fs->inner_ttc))
+		return PTR_ERR(fs->inner_ttc);
 	return 0;
 }
 
-int mlx5e_create_ttc_table(struct mlx5e_priv *priv)
+int mlx5e_create_ttc_table(struct mlx5e_flow_steering *fs,
+			   struct mlx5e_rx_res *rx_res)
 {
 	struct ttc_params ttc_params = {};
 
-	mlx5e_set_ttc_params(priv, &ttc_params, true);
-	priv->fs->ttc = mlx5_create_ttc_table(priv->fs->mdev, &ttc_params);
-	if (IS_ERR(priv->fs->ttc))
-		return PTR_ERR(priv->fs->ttc);
+	mlx5e_set_ttc_params(fs, rx_res, &ttc_params, true);
+	fs->ttc = mlx5_create_ttc_table(fs->mdev, &ttc_params);
+	if (IS_ERR(fs->ttc))
+		return PTR_ERR(fs->ttc);
 	return 0;
 }
 
@@ -1295,6 +1299,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 {
 	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(priv->fs->mdev,
 								 MLX5_FLOW_NAMESPACE_KERNEL);
+	struct mlx5e_rx_res *rx_res = priv->rx_res;
 	struct mlx5e_flow_steering *fs = priv->fs;
 
 	int err;
@@ -1302,21 +1307,21 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	if (!ns)
 		return -EOPNOTSUPP;
 
-	mlx5e_fs_set_ns(priv->fs, ns, false);
-	err = mlx5e_arfs_create_tables(priv->fs, priv->rx_res,
+	mlx5e_fs_set_ns(fs, ns, false);
+	err = mlx5e_arfs_create_tables(fs, rx_res,
 				       !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 	if (err) {
 		fs_err(fs, "Failed to create arfs tables, err=%d\n", err);
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
-	err = mlx5e_create_inner_ttc_table(priv);
+	err = mlx5e_create_inner_ttc_table(fs, rx_res);
 	if (err) {
 		fs_err(fs, "Failed to create inner ttc table, err=%d\n", err);
 		goto err_destroy_arfs_tables;
 	}
 
-	err = mlx5e_create_ttc_table(priv);
+	err = mlx5e_create_ttc_table(fs, rx_res);
 	if (err) {
 		fs_err(fs, "Failed to create ttc table, err=%d\n", err);
 		goto err_destroy_inner_ttc_table;
@@ -1347,7 +1352,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 err_destroy_l2_table:
 	mlx5e_destroy_l2_table(priv);
 err_destroy_ttc_table:
-	mlx5e_destroy_ttc_table(priv);
+	mlx5e_destroy_ttc_table(priv->fs);
 err_destroy_inner_ttc_table:
 	mlx5e_destroy_inner_ttc_table(priv);
 err_destroy_arfs_tables:
@@ -1362,7 +1367,7 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_ptp_free_rx_fs(priv->fs, priv->profile);
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
-	mlx5e_destroy_ttc_table(priv);
+	mlx5e_destroy_ttc_table(priv->fs);
 	mlx5e_destroy_inner_ttc_table(priv);
 	mlx5e_arfs_destroy_tables(priv->fs,
 				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 49a67fa5327c..c85fd0223449 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -751,7 +751,7 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 						MLX5_FLOW_NAMESPACE_KERNEL), false);
 
 	/* The inner_ttc in the ttc params is intentionally not set */
-	mlx5e_set_ttc_params(priv, &ttc_params, false);
+	mlx5e_set_ttc_params(priv->fs, priv->rx_res, &ttc_params, false);
 
 	if (rep->vport != MLX5_VPORT_UPLINK)
 		/* To give uplik rep TTC a lower level for chaining from root ft */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index c3149e391f10..35f797cfd21e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -338,7 +338,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
-	err = mlx5e_create_ttc_table(priv);
+	err = mlx5e_create_ttc_table(priv->fs, priv->rx_res);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
@@ -358,7 +358,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
-	mlx5e_destroy_ttc_table(priv);
+	mlx5e_destroy_ttc_table(priv->fs);
 	mlx5e_arfs_destroy_tables(priv->fs,
 				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
 	mlx5e_ethtool_cleanup_steering(priv->fs);
-- 
2.37.1

