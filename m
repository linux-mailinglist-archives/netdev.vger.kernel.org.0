Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C825F58476B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiG1U6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiG1U5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D566785A8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE7E5B82593
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5C4C433C1;
        Thu, 28 Jul 2022 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041861;
        bh=bhmiP2Hp1QOSnQ7utVbKD+LYEysCXP9HZrYazriU+qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mL2b93g57JlOpR8FB9pg4Re2V1QPLhxG963wWpGCJ9H3Q0N9d8Hgb5fB/ln0UFTZv
         CGZ1vdNZ6UDIC+OgWh0m31oSG57R2CP/BZ8gITafMWu449/NEIaYKKC/5jvrrQgbZ1
         eg4/PQ9p80GL5bz3lrFY2k/qVMUQTrVhUgOl5L/pHdoB4IOnNWiBrEVFrWPxQT9yJK
         0NVm5IcKddFsurwCnS/sLKnzLLI7MQC+98fzTwTheJIVBou9W76/nv/h+1EB7JFHH8
         PbZOvrVUkK5tX6Fo+kq3XNkHunrXcBkUetf/nhQp1ynugG3k8YD2/jCjKYDJbDIB7o
         JAn7hJiDC9ePA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Add mdev to flow_steering struct
Date:   Thu, 28 Jul 2022 13:57:25 -0700
Message-Id: <20220728205728.143074-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Make flow_steering struct contain mlx5_core_dev such that
it becomes self contained and easier to decouple later on this series.
Let its values be initialized in mlx5e_fs_init().

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 70 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 5 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index bc500e9833d4..64eb872d3f2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -143,6 +143,7 @@ struct mlx5e_fs_any;
 struct mlx5e_ptp_fs;
 
 struct mlx5e_flow_steering {
+	struct mlx5_core_dev		*mdev;
 	struct mlx5_flow_namespace      *ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
 	struct mlx5e_ethtool_steering   ethtool;
@@ -178,7 +179,8 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
 
-struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile);
+struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
+					  struct mlx5_core_dev *mdev);
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs);
 
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index c4994220c7d2..f25512d29b7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -146,10 +146,10 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 	for_each_set_bit(vlan, priv->fs->vlan->active_cvlans, VLAN_N_VID)
 		list_size++;
 
-	max_list_size = 1 << MLX5_CAP_GEN(priv->mdev, log_max_vlan_list);
+	max_list_size = 1 << MLX5_CAP_GEN(priv->fs->mdev, log_max_vlan_list);
 
 	if (list_size > max_list_size) {
-		mlx5_core_warn(priv->mdev,
+		mlx5_core_warn(priv->fs->mdev,
 			       "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
 			       list_size, max_list_size);
 		list_size = max_list_size;
@@ -166,9 +166,9 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 		vlans[i++] = vlan;
 	}
 
-	err = mlx5_modify_nic_vport_vlans(priv->mdev, vlans, list_size);
+	err = mlx5_modify_nic_vport_vlans(priv->fs->mdev, vlans, list_size);
 	if (err)
-		mlx5_core_err(priv->mdev, "Failed to modify vport vlans list err(%d)\n",
+		mlx5_core_err(priv->fs->mdev, "Failed to modify vport vlans list err(%d)\n",
 			      err);
 
 	kvfree(vlans);
@@ -250,7 +250,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		mlx5_core_err(priv->mdev, "%s: add rule failed\n", __func__);
+		mlx5_core_err(priv->fs->mdev, "%s: add rule failed\n", __func__);
 	}
 
 	return err;
@@ -362,7 +362,7 @@ int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->fs->vlan->trap_rule = NULL;
-		mlx5_core_err(priv->mdev, "%s: add VLAN trap rule failed, err %d\n",
+		mlx5_core_err(priv->fs->mdev, "%s: add VLAN trap rule failed, err %d\n",
 			      __func__, err);
 		return err;
 	}
@@ -388,7 +388,7 @@ int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->fs->l2.trap_rule = NULL;
-		mlx5_core_err(priv->mdev, "%s: add MAC trap rule failed, err %d\n",
+		mlx5_core_err(priv->fs->mdev, "%s: add MAC trap rule failed, err %d\n",
 			      __func__, err);
 		return err;
 	}
@@ -549,7 +549,7 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
 	case MLX5E_ACTION_ADD:
 		mlx5e_add_l2_flow_rule(priv, &hn->ai, MLX5E_FULLMATCH);
 		if (!is_multicast_ether_addr(mac_addr)) {
-			l2_err = mlx5_mpfs_add_mac(priv->mdev, mac_addr);
+			l2_err = mlx5_mpfs_add_mac(priv->fs->mdev, mac_addr);
 			hn->mpfs = !l2_err;
 		}
 		hn->action = MLX5E_ACTION_NONE;
@@ -557,14 +557,14 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
 
 	case MLX5E_ACTION_DEL:
 		if (!is_multicast_ether_addr(mac_addr) && hn->mpfs)
-			l2_err = mlx5_mpfs_del_mac(priv->mdev, mac_addr);
+			l2_err = mlx5_mpfs_del_mac(priv->fs->mdev, mac_addr);
 		mlx5e_del_l2_flow_rule(priv, &hn->ai);
 		mlx5e_del_l2_from_hash(hn);
 		break;
 	}
 
 	if (l2_err)
-		mlx5_core_warn(priv->mdev, "MPFS, failed to %s mac %pM, err(%d)\n",
+		mlx5_core_warn(priv->fs->mdev, "MPFS, failed to %s mac %pM, err(%d)\n",
 			       action == MLX5E_ACTION_ADD ? "add" : "del", mac_addr, l2_err);
 }
 
@@ -629,15 +629,15 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
 
 	size = is_uc ? 0 : (priv->fs->l2.broadcast_enabled ? 1 : 0);
 	max_size = is_uc ?
-		1 << MLX5_CAP_GEN(priv->mdev, log_max_current_uc_list) :
-		1 << MLX5_CAP_GEN(priv->mdev, log_max_current_mc_list);
+		1 << MLX5_CAP_GEN(priv->fs->mdev, log_max_current_uc_list) :
+		1 << MLX5_CAP_GEN(priv->fs->mdev, log_max_current_mc_list);
 
 	addr_list = is_uc ? priv->fs->l2.netdev_uc : priv->fs->l2.netdev_mc;
 	mlx5e_for_each_hash_node(hn, tmp, addr_list, hi)
 		size++;
 
 	if (size > max_size) {
-		mlx5_core_warn(priv->mdev,
+		mlx5_core_warn(priv->fs->mdev,
 			       "mdev %s list size (%d) > (%d) max vport list size, some addresses will be dropped\n",
 			      is_uc ? "UC" : "MC", size, max_size);
 		size = max_size;
@@ -652,10 +652,10 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
 		mlx5e_fill_addr_array(priv, list_type, addr_array, size);
 	}
 
-	err = mlx5_modify_nic_vport_mac_list(priv->mdev, list_type, addr_array, size);
+	err = mlx5_modify_nic_vport_mac_list(priv->fs->mdev, list_type, addr_array, size);
 out:
 	if (err)
-		mlx5_core_err(priv->mdev,
+		mlx5_core_err(priv->fs->mdev,
 			      "Failed to modify vport %s list err(%d)\n",
 			      is_uc ? "UC" : "MC", err);
 	kfree(addr_array);
@@ -667,7 +667,7 @@ static void mlx5e_vport_context_update(struct mlx5e_priv *priv)
 
 	mlx5e_vport_context_update_addr_list(priv, MLX5_NVPRT_LIST_TYPE_UC);
 	mlx5e_vport_context_update_addr_list(priv, MLX5_NVPRT_LIST_TYPE_MC);
-	mlx5_modify_nic_vport_promisc(priv->mdev, 0,
+	mlx5_modify_nic_vport_promisc(priv->fs->mdev, 0,
 				      ea->allmulti_enabled,
 				      ea->promisc_enabled);
 }
@@ -725,7 +725,7 @@ static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		mlx5_core_err(priv->mdev, "%s: add promiscuous rule failed\n", __func__);
+		mlx5_core_err(priv->fs->mdev, "%s: add promiscuous rule failed\n", __func__);
 	}
 	kvfree(spec);
 	return err;
@@ -745,7 +745,7 @@ static int mlx5e_create_promisc_table(struct mlx5e_priv *priv)
 	ft->t = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
-		mlx5_core_err(priv->mdev, "fail to create promisc table err=%d\n", err);
+		mlx5_core_err(priv->fs->mdev, "fail to create promisc table err=%d\n", err);
 		return err;
 	}
 
@@ -805,7 +805,7 @@ void mlx5e_set_rx_mode_work(struct work_struct *work)
 		if (err)
 			enable_promisc = false;
 		if (!priv->channels.params.vlan_strip_disable && !err)
-			mlx5_core_warn_once(priv->mdev,
+			mlx5_core_warn_once(priv->fs->mdev,
 					    "S-tagged traffic will be dropped while C-tag vlan stripping is enabled\n");
 	}
 	if (enable_allmulti)
@@ -861,7 +861,7 @@ static void mlx5e_set_inner_ttc_params(struct mlx5e_priv *priv,
 	int tt;
 
 	memset(ttc_params, 0, sizeof(*ttc_params));
-	ttc_params->ns = mlx5_get_flow_namespace(priv->mdev,
+	ttc_params->ns = mlx5_get_flow_namespace(priv->fs->mdev,
 						 MLX5_FLOW_NAMESPACE_KERNEL);
 	ft_attr->level = MLX5E_INNER_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_NIC_PRIO;
@@ -884,7 +884,7 @@ void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 	int tt;
 
 	memset(ttc_params, 0, sizeof(*ttc_params));
-	ttc_params->ns = mlx5_get_flow_namespace(priv->mdev,
+	ttc_params->ns = mlx5_get_flow_namespace(priv->fs->mdev,
 						 MLX5_FLOW_NAMESPACE_KERNEL);
 	ft_attr->level = MLX5E_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_NIC_PRIO;
@@ -898,7 +898,7 @@ void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 	}
 
 	ttc_params->inner_ttc = tunnel;
-	if (!tunnel || !mlx5_tunnel_inner_ft_supported(priv->mdev))
+	if (!tunnel || !mlx5_tunnel_inner_ft_supported(priv->fs->mdev))
 		return;
 
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
@@ -957,7 +957,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 
 	ai->rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(ai->rule)) {
-		mlx5_core_err(priv->mdev, "%s: add l2 rule(mac:%pM) failed\n",
+		mlx5_core_err(priv->fs->mdev, "%s: add l2 rule(mac:%pM) failed\n",
 			      __func__, mv_dmac);
 		err = PTR_ERR(ai->rule);
 		ai->rule = NULL;
@@ -1227,7 +1227,7 @@ static void mlx5e_destroy_vlan_table(struct mlx5e_priv *priv)
 
 static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv)
 {
-	if (!mlx5_tunnel_inner_ft_supported(priv->mdev))
+	if (!mlx5_tunnel_inner_ft_supported(priv->fs->mdev))
 		return;
 	mlx5_destroy_ttc_table(priv->fs->inner_ttc);
 }
@@ -1241,11 +1241,11 @@ static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv)
 {
 	struct ttc_params ttc_params = {};
 
-	if (!mlx5_tunnel_inner_ft_supported(priv->mdev))
+	if (!mlx5_tunnel_inner_ft_supported(priv->fs->mdev))
 		return 0;
 
 	mlx5e_set_inner_ttc_params(priv, &ttc_params);
-	priv->fs->inner_ttc = mlx5_create_inner_ttc_table(priv->mdev,
+	priv->fs->inner_ttc = mlx5_create_inner_ttc_table(priv->fs->mdev,
 							  &ttc_params);
 	if (IS_ERR(priv->fs->inner_ttc))
 		return PTR_ERR(priv->fs->inner_ttc);
@@ -1257,7 +1257,7 @@ int mlx5e_create_ttc_table(struct mlx5e_priv *priv)
 	struct ttc_params ttc_params = {};
 
 	mlx5e_set_ttc_params(priv, &ttc_params, true);
-	priv->fs->ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
+	priv->fs->ttc = mlx5_create_ttc_table(priv->fs->mdev, &ttc_params);
 	if (IS_ERR(priv->fs->ttc))
 		return PTR_ERR(priv->fs->ttc);
 	return 0;
@@ -1267,7 +1267,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 {
 	int err;
 
-	priv->fs->ns = mlx5_get_flow_namespace(priv->mdev,
+	priv->fs->ns = mlx5_get_flow_namespace(priv->fs->mdev,
 					       MLX5_FLOW_NAMESPACE_KERNEL);
 
 	if (!priv->fs->ns)
@@ -1275,35 +1275,35 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 	err = mlx5e_arfs_create_tables(priv);
 	if (err) {
-		mlx5_core_err(priv->mdev, "Failed to create arfs tables, err=%d\n",
+		mlx5_core_err(priv->fs->mdev, "Failed to create arfs tables, err=%d\n",
 			      err);
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
 	err = mlx5e_create_inner_ttc_table(priv);
 	if (err) {
-		mlx5_core_err(priv->mdev,
+		mlx5_core_err(priv->fs->mdev,
 			      "Failed to create inner ttc table, err=%d\n", err);
 		goto err_destroy_arfs_tables;
 	}
 
 	err = mlx5e_create_ttc_table(priv);
 	if (err) {
-		mlx5_core_err(priv->mdev, "Failed to create ttc table, err=%d\n",
+		mlx5_core_err(priv->fs->mdev, "Failed to create ttc table, err=%d\n",
 			      err);
 		goto err_destroy_inner_ttc_table;
 	}
 
 	err = mlx5e_create_l2_table(priv);
 	if (err) {
-		mlx5_core_err(priv->mdev, "Failed to create l2 table, err=%d\n",
+		mlx5_core_err(priv->fs->mdev, "Failed to create l2 table, err=%d\n",
 			      err);
 		goto err_destroy_ttc_table;
 	}
 
 	err = mlx5e_create_vlan_table(priv);
 	if (err) {
-		mlx5_core_err(priv->mdev, "Failed to create vlan table, err=%d\n",
+		mlx5_core_err(priv->fs->mdev, "Failed to create vlan table, err=%d\n",
 			      err);
 		goto err_destroy_l2_table;
 	}
@@ -1367,7 +1367,8 @@ static void mlx5e_fs_tc_free(struct mlx5e_flow_steering *fs)
 	mlx5e_tc_table_free(fs->tc);
 }
 
-struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile)
+struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
+					  struct mlx5_core_dev *mdev)
 {
 	struct mlx5e_flow_steering *fs;
 	int err;
@@ -1376,6 +1377,7 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile)
 	if (!fs)
 		goto err;
 
+	fs->mdev = mdev;
 	if (mlx5e_profile_feature_cap(profile, FS_VLAN)) {
 		err = mlx5e_fs_vlan_alloc(fs);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 872a78ef98cd..55d4b8f8b3d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5020,7 +5020,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 
 	mlx5e_timestamp_init(priv);
 
-	fs = mlx5e_fs_init(priv->profile);
+	fs = mlx5e_fs_init(priv->profile, mdev);
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b1d65bbebebb..3a4975bd46eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -836,7 +836,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	priv->fs = mlx5e_fs_init(priv->profile);
+	priv->fs = mlx5e_fs_init(priv->profile, mdev);
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index c865cbc3b2be..5d5331b1535b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -364,7 +364,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	priv->fs = mlx5e_fs_init(priv->profile);
+	priv->fs = mlx5e_fs_init(priv->profile, mdev);
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
-- 
2.37.1

