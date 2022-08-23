Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5331459D0D7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiHWF4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiHWF4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF0F5E554
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFD3061484
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CADC433D6;
        Tue, 23 Aug 2022 05:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234154;
        bh=WJ3+aKTchZMWtcOgD/CAdZND+n3Ch3QiUTtFXt0hMqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1FoCGwK5mGfjvbqfzCPHG9fk4dWU1bZ+IygvivcS88UlmsFI9895JEE7YLTXuzV8
         +7srkFzs5FjXxuucGyVnfZuAiO+TnLWT1OhrOsvLagDz2OYts+9NIoYfpog4YoVDmG
         lFjkLYlmw8LNh7YPyCzg8eNUzORosKU2bZQQfS1DMchdtDi/3V4VvwO3ZDA/Dao+58
         A7FGNT0iodcQVRe9rn14lOkmhz7+DxJWHRmI4wyxbucB4B8/OSBg7+Z3levzQi1ZY6
         y65FYr+ipCdV3FAPcoO2ZA1HFh3lHDrGr/zj1lQ+O/lCjaZgT5LxnUDRjEDhaFLdlT
         09C8IHnxWYacg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Completely eliminate priv from fs.h
Date:   Mon, 22 Aug 2022 22:55:29 -0700
Message-Id: <20220823055533.334471-12-saeed@kernel.org>
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

Complete the decoupling process of flow steering from en.h.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  21 +--
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 150 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  15 +-
 4 files changed, 100 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 3d86d8021958..bf2741eb7f9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -91,7 +91,6 @@ enum {
 
 struct mlx5e_flow_steering;
 struct mlx5e_rx_res;
-struct mlx5e_priv;
 
 #ifdef CONFIG_MLX5_EN_ARFS
 struct mlx5e_arfs_tables;
@@ -133,11 +132,15 @@ int mlx5e_create_ttc_table(struct mlx5e_flow_steering  *fs,
 
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
 
-void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv);
-void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
+void mlx5e_enable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc);
+void mlx5e_disable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc);
 
-int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
-void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
+int mlx5e_create_flow_steering(struct mlx5e_flow_steering *fs,
+			       struct mlx5e_rx_res *rx_res,
+			       const struct mlx5e_profile *profile,
+			       struct net_device *netdev);
+void mlx5e_destroy_flow_steering(struct mlx5e_flow_steering *fs, bool ntuple,
+				 const struct mlx5e_profile *profile);
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
@@ -172,10 +175,10 @@ void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destr
 void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs, bool vlan_strip_disable);
 
 struct mlx5_core_dev *mlx5e_fs_get_mdev(struct mlx5e_flow_steering *fs);
-int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
-void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
-int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
-void mlx5e_remove_mac_trap(struct mlx5e_priv *priv);
+int mlx5e_add_vlan_trap(struct mlx5e_flow_steering *fs, int  trap_id, int tir_num);
+void mlx5e_remove_vlan_trap(struct mlx5e_flow_steering *fs);
+int mlx5e_add_mac_trap(struct mlx5e_flow_steering *fs, int  trap_id, int tir_num);
+void mlx5e_remove_mac_trap(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs, struct net_device *netdev);
 int mlx5e_fs_vlan_rx_add_vid(struct mlx5e_flow_steering *fs,
 			     struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 11f2a7fb72a9..46c2e5f9c05c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -230,12 +230,12 @@ static int mlx5e_handle_action_trap(struct mlx5e_priv *priv, int trap_id)
 
 	switch (trap_id) {
 	case DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER:
-		err = mlx5e_add_vlan_trap(priv, trap_id, mlx5e_trap_get_tirn(priv->en_trap));
+		err = mlx5e_add_vlan_trap(priv->fs, trap_id, mlx5e_trap_get_tirn(priv->en_trap));
 		if (err)
 			goto err_out;
 		break;
 	case DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER:
-		err = mlx5e_add_mac_trap(priv, trap_id, mlx5e_trap_get_tirn(priv->en_trap));
+		err = mlx5e_add_mac_trap(priv->fs, trap_id, mlx5e_trap_get_tirn(priv->en_trap));
 		if (err)
 			goto err_out;
 		break;
@@ -256,10 +256,10 @@ static int mlx5e_handle_action_drop(struct mlx5e_priv *priv, int trap_id)
 {
 	switch (trap_id) {
 	case DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER:
-		mlx5e_remove_vlan_trap(priv);
+		mlx5e_remove_vlan_trap(priv->fs);
 		break;
 	case DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER:
-		mlx5e_remove_mac_trap(priv);
+		mlx5e_remove_mac_trap(priv->fs);
 		break;
 	default:
 		netdev_warn(priv->netdev, "%s: Unknown trap id %d\n", __func__, trap_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 49bc52559896..ef1dfbb78464 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -36,7 +36,6 @@
 #include <linux/tcp.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/mpfs.h>
-#include "en.h"
 #include "en_tc.h"
 #include "lib/mpfs.h"
 #include "en/ptp.h"
@@ -379,78 +378,78 @@ mlx5e_add_trap_rule(struct mlx5_flow_table *ft, int trap_id, int tir_num)
 	return rule;
 }
 
-int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
+int mlx5e_add_vlan_trap(struct mlx5e_flow_steering *fs, int trap_id, int tir_num)
 {
-	struct mlx5_flow_table *ft = priv->fs->vlan->ft.t;
+	struct mlx5_flow_table *ft = fs->vlan->ft.t;
 	struct mlx5_flow_handle *rule;
 	int err;
 
 	rule = mlx5e_add_trap_rule(ft, trap_id, tir_num);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		priv->fs->vlan->trap_rule = NULL;
-		fs_err(priv->fs, "%s: add VLAN trap rule failed, err %d\n",
+		fs->vlan->trap_rule = NULL;
+		fs_err(fs, "%s: add VLAN trap rule failed, err %d\n",
 		       __func__, err);
 		return err;
 	}
-	priv->fs->vlan->trap_rule = rule;
+	fs->vlan->trap_rule = rule;
 	return 0;
 }
 
-void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv)
+void mlx5e_remove_vlan_trap(struct mlx5e_flow_steering *fs)
 {
-	if (priv->fs->vlan->trap_rule) {
-		mlx5_del_flow_rules(priv->fs->vlan->trap_rule);
-		priv->fs->vlan->trap_rule = NULL;
+	if (fs->vlan->trap_rule) {
+		mlx5_del_flow_rules(fs->vlan->trap_rule);
+		fs->vlan->trap_rule = NULL;
 	}
 }
 
-int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
+int mlx5e_add_mac_trap(struct mlx5e_flow_steering *fs, int trap_id, int tir_num)
 {
-	struct mlx5_flow_table *ft = priv->fs->l2.ft.t;
+	struct mlx5_flow_table *ft = fs->l2.ft.t;
 	struct mlx5_flow_handle *rule;
 	int err;
 
 	rule = mlx5e_add_trap_rule(ft, trap_id, tir_num);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		priv->fs->l2.trap_rule = NULL;
-		fs_err(priv->fs, "%s: add MAC trap rule failed, err %d\n",
+		fs->l2.trap_rule = NULL;
+		fs_err(fs, "%s: add MAC trap rule failed, err %d\n",
 		       __func__, err);
 		return err;
 	}
-	priv->fs->l2.trap_rule = rule;
+	fs->l2.trap_rule = rule;
 	return 0;
 }
 
-void mlx5e_remove_mac_trap(struct mlx5e_priv *priv)
+void mlx5e_remove_mac_trap(struct mlx5e_flow_steering *fs)
 {
-	if (priv->fs->l2.trap_rule) {
-		mlx5_del_flow_rules(priv->fs->l2.trap_rule);
-		priv->fs->l2.trap_rule = NULL;
+	if (fs->l2.trap_rule) {
+		mlx5_del_flow_rules(fs->l2.trap_rule);
+		fs->l2.trap_rule = NULL;
 	}
 }
 
-void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv)
+void mlx5e_enable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 {
-	if (!priv->fs->vlan->cvlan_filter_disabled)
+	if (!fs->vlan->cvlan_filter_disabled)
 		return;
 
-	priv->fs->vlan->cvlan_filter_disabled = false;
-	if (priv->netdev->flags & IFF_PROMISC)
+	fs->vlan->cvlan_filter_disabled = false;
+	if (promisc)
 		return;
-	mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
+	mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
 }
 
-void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv)
+void mlx5e_disable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 {
-	if (priv->fs->vlan->cvlan_filter_disabled)
+	if (fs->vlan->cvlan_filter_disabled)
 		return;
 
-	priv->fs->vlan->cvlan_filter_disabled = true;
-	if (priv->netdev->flags & IFF_PROMISC)
+	fs->vlan->cvlan_filter_disabled = true;
+	if (promisc)
 		return;
-	mlx5e_add_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
+	mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
 }
 
 static int mlx5e_vlan_rx_add_cvid(struct mlx5e_flow_steering *fs, u16 vid)
@@ -540,28 +539,28 @@ static void mlx5e_fs_add_vlan_rules(struct mlx5e_flow_steering *fs)
 		mlx5e_fs_add_any_vid_rules(fs);
 }
 
-static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
+static void mlx5e_del_vlan_rules(struct mlx5e_flow_steering *fs)
 {
 	int i;
 
-	mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
+	mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
 
-	for_each_set_bit(i, priv->fs->vlan->active_cvlans, VLAN_N_VID) {
-		mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
+	for_each_set_bit(i, fs->vlan->active_cvlans, VLAN_N_VID) {
+		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
 	}
 
-	for_each_set_bit(i, priv->fs->vlan->active_svlans, VLAN_N_VID)
-		mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
+	for_each_set_bit(i, fs->vlan->active_svlans, VLAN_N_VID)
+		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	WARN_ON_ONCE(priv->fs->state_destroy);
+	WARN_ON_ONCE(fs->state_destroy);
 
-	mlx5e_remove_vlan_trap(priv);
+	mlx5e_remove_vlan_trap(fs);
 
 	/* must be called after DESTROY bit is set and
 	 * set_rx_mode is called and flushed
 	 */
-	if (priv->fs->vlan->cvlan_filter_disabled)
-		mlx5e_fs_del_any_vid_rules(priv->fs);
+	if (fs->vlan->cvlan_filter_disabled)
+		mlx5e_fs_del_any_vid_rules(fs);
 }
 
 #define mlx5e_for_each_hash_node(hn, tmp, hash, i) \
@@ -1072,14 +1071,14 @@ static int mlx5e_create_l2_table_groups(struct mlx5e_l2_table *l2_table)
 	return err;
 }
 
-static void mlx5e_destroy_l2_table(struct mlx5e_priv *priv)
+static void mlx5e_destroy_l2_table(struct mlx5e_flow_steering *fs)
 {
-	mlx5e_destroy_flow_table(&priv->fs->l2.ft);
+	mlx5e_destroy_flow_table(&fs->l2.ft);
 }
 
-static int mlx5e_create_l2_table(struct mlx5e_priv *priv)
+static int mlx5e_create_l2_table(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_l2_table *l2_table = &priv->fs->l2;
+	struct mlx5e_l2_table *l2_table = &fs->l2;
 	struct mlx5e_flow_table *ft = &l2_table->ft;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
@@ -1090,7 +1089,7 @@ static int mlx5e_create_l2_table(struct mlx5e_priv *priv)
 	ft_attr.level = MLX5E_L2_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
 		ft->t = NULL;
@@ -1249,17 +1248,17 @@ static int mlx5e_fs_create_vlan_table(struct mlx5e_flow_steering *fs)
 	return err;
 }
 
-static void mlx5e_destroy_vlan_table(struct mlx5e_priv *priv)
+static void mlx5e_destroy_vlan_table(struct mlx5e_flow_steering *fs)
 {
-	mlx5e_del_vlan_rules(priv);
-	mlx5e_destroy_flow_table(&priv->fs->vlan->ft);
+	mlx5e_del_vlan_rules(fs);
+	mlx5e_destroy_flow_table(&fs->vlan->ft);
 }
 
-static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv)
+static void mlx5e_destroy_inner_ttc_table(struct mlx5e_flow_steering *fs)
 {
-	if (!mlx5_tunnel_inner_ft_supported(priv->fs->mdev))
+	if (!mlx5_tunnel_inner_ft_supported(fs->mdev))
 		return;
-	mlx5_destroy_ttc_table(priv->fs->inner_ttc);
+	mlx5_destroy_ttc_table(fs->inner_ttc);
 }
 
 void mlx5e_destroy_ttc_table(struct mlx5e_flow_steering *fs)
@@ -1295,13 +1294,13 @@ int mlx5e_create_ttc_table(struct mlx5e_flow_steering *fs,
 	return 0;
 }
 
-int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
+int mlx5e_create_flow_steering(struct mlx5e_flow_steering *fs,
+			       struct mlx5e_rx_res *rx_res,
+			       const struct mlx5e_profile *profile,
+			       struct net_device *netdev)
 {
-	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(priv->fs->mdev,
+	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(fs->mdev,
 								 MLX5_FLOW_NAMESPACE_KERNEL);
-	struct mlx5e_rx_res *rx_res = priv->rx_res;
-	struct mlx5e_flow_steering *fs = priv->fs;
-
 	int err;
 
 	if (!ns)
@@ -1309,10 +1308,10 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 	mlx5e_fs_set_ns(fs, ns, false);
 	err = mlx5e_arfs_create_tables(fs, rx_res,
-				       !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
+				       !!(netdev->hw_features & NETIF_F_NTUPLE));
 	if (err) {
 		fs_err(fs, "Failed to create arfs tables, err=%d\n", err);
-		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
 	err = mlx5e_create_inner_ttc_table(fs, rx_res);
@@ -1327,51 +1326,50 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		goto err_destroy_inner_ttc_table;
 	}
 
-	err = mlx5e_create_l2_table(priv);
+	err = mlx5e_create_l2_table(fs);
 	if (err) {
 		fs_err(fs, "Failed to create l2 table, err=%d\n", err);
 		goto err_destroy_ttc_table;
 	}
 
-	err = mlx5e_fs_create_vlan_table(priv->fs);
+	err = mlx5e_fs_create_vlan_table(fs);
 	if (err) {
 		fs_err(fs, "Failed to create vlan table, err=%d\n", err);
 		goto err_destroy_l2_table;
 	}
 
-	err = mlx5e_ptp_alloc_rx_fs(priv->fs, priv->profile);
+	err = mlx5e_ptp_alloc_rx_fs(fs, profile);
 	if (err)
 		goto err_destory_vlan_table;
 
-	mlx5e_ethtool_init_steering(priv->fs);
+	mlx5e_ethtool_init_steering(fs);
 
 	return 0;
 
 err_destory_vlan_table:
-	mlx5e_destroy_vlan_table(priv);
+	mlx5e_destroy_vlan_table(fs);
 err_destroy_l2_table:
-	mlx5e_destroy_l2_table(priv);
+	mlx5e_destroy_l2_table(fs);
 err_destroy_ttc_table:
-	mlx5e_destroy_ttc_table(priv->fs);
+	mlx5e_destroy_ttc_table(fs);
 err_destroy_inner_ttc_table:
-	mlx5e_destroy_inner_ttc_table(priv);
+	mlx5e_destroy_inner_ttc_table(fs);
 err_destroy_arfs_tables:
-	mlx5e_arfs_destroy_tables(priv->fs,
-				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
+	mlx5e_arfs_destroy_tables(fs, !!(netdev->hw_features & NETIF_F_NTUPLE));
 
 	return err;
 }
 
-void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
+void mlx5e_destroy_flow_steering(struct mlx5e_flow_steering *fs, bool ntuple,
+				 const struct mlx5e_profile *profile)
 {
-	mlx5e_ptp_free_rx_fs(priv->fs, priv->profile);
-	mlx5e_destroy_vlan_table(priv);
-	mlx5e_destroy_l2_table(priv);
-	mlx5e_destroy_ttc_table(priv->fs);
-	mlx5e_destroy_inner_ttc_table(priv);
-	mlx5e_arfs_destroy_tables(priv->fs,
-				  !!(priv->netdev->hw_features & NETIF_F_NTUPLE));
-	mlx5e_ethtool_cleanup_steering(priv->fs);
+	mlx5e_ptp_free_rx_fs(fs, profile);
+	mlx5e_destroy_vlan_table(fs);
+	mlx5e_destroy_l2_table(fs);
+	mlx5e_destroy_ttc_table(fs);
+	mlx5e_destroy_inner_ttc_table(fs);
+	mlx5e_arfs_destroy_tables(fs, ntuple);
+	mlx5e_ethtool_cleanup_steering(fs);
 }
 
 static int mlx5e_fs_vlan_alloc(struct mlx5e_flow_steering *fs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f334cbcd003d..8426614092fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3669,9 +3669,11 @@ static int set_feature_cvlan_filter(struct net_device *netdev, bool enable)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 	if (enable)
-		mlx5e_enable_cvlan_filter(priv);
+		mlx5e_enable_cvlan_filter(priv->fs,
+					  !!(priv->netdev->flags & IFF_PROMISC));
 	else
-		mlx5e_disable_cvlan_filter(priv);
+		mlx5e_disable_cvlan_filter(priv->fs,
+					   !!(priv->netdev->flags & IFF_PROMISC));
 
 	return 0;
 }
@@ -5105,7 +5107,8 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_flow_steering(priv);
+	err = mlx5e_create_flow_steering(priv->fs, priv->rx_res, priv->profile,
+					 priv->netdev);
 	if (err) {
 		mlx5_core_warn(mdev, "create flow steering failed, %d\n", err);
 		goto err_destroy_rx_res;
@@ -5128,7 +5131,8 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_tc_nic_cleanup:
 	mlx5e_tc_nic_cleanup(priv);
 err_destroy_flow_steering:
-	mlx5e_destroy_flow_steering(priv);
+	mlx5e_destroy_flow_steering(priv->fs, !!(priv->netdev->hw_features & NETIF_F_NTUPLE),
+				    priv->profile);
 err_destroy_rx_res:
 	mlx5e_rx_res_destroy(priv->rx_res);
 err_close_drop_rq:
@@ -5144,7 +5148,8 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
-	mlx5e_destroy_flow_steering(priv);
+	mlx5e_destroy_flow_steering(priv->fs, !!(priv->netdev->hw_features & NETIF_F_NTUPLE),
+				    priv->profile);
 	mlx5e_rx_res_destroy(priv->rx_res);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
-- 
2.37.1

