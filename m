Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891DB58476D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiG1U7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiG1U6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:58:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE93785BD
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3C49B82596
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDE8C433D7;
        Thu, 28 Jul 2022 20:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041862;
        bh=9RITXjJT8H5B5bB7jkU8mlmHBxa2RfnEpbPYZIxmw7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGfJ3iFEF8e04d01/uBcAJyvDnYcpKWgv32SU7OVUWLN1sQRUGFFNO2LDG5DsZsTG
         42bY/jqyM2pRGiAoWDDsfwMAfFHjHKJY7DPGrCk0AW0W+q+FFdcM3pGEOUyIN/EJ0v
         CAVnmZI4emg3jvEZSgzXgmMyD5gDthQM5FqqAO2ijJwpOsSzu3QC7Xs17hUsEwhouc
         wl92/TyeVkrYZ615cgEsMMhKFUXr14yaAAzuplEPLtkOdhE7Ra0Z3yVT8aTunh02ow
         4njWGr1yyKvYKPYW2W/DVnxR8CWVDl4WgI9YJlVNdgBtPAssw5zttJ8QmzOpNYsOeO
         kckW4cL2bpmiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Separate mlx5e_set_rx_mode_work and move caller to en_main
Date:   Thu, 28 Jul 2022 13:57:26 -0700
Message-Id: <20220728205728.143074-14-saeed@kernel.org>
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

Separate mlx5e_set_rx_mode into two, and move caller to en_main while
keeping implementation in en_fs in the newly declared function
mlx5e_fs_set_rx_mode. This; to minimize the coupling of flow_steering
to priv.

Add a parallel boolean member vlan_strip_disable to
mlx5e_flow_steering that's updated similarly as its identical in priv,
thus making it possible to adjust the rx_mode work handler to current
changes.

Also, add state_destroy boolean to mlx5e_flow_steering struct which
replaces the old check : !test_bit(MLX5E_STATE_DESTROYING, &priv->state).
This state member is updated accordingly prior to
INIT_WORK(mlx5e_set_rx_mode_work), This is done for similar purposes as
mentioned earlier and to minimize argument passings.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 178 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  24 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   3 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   3 +-
 5 files changed, 119 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 64eb872d3f2f..681a17df5da3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -143,6 +143,8 @@ struct mlx5e_fs_any;
 struct mlx5e_ptp_fs;
 
 struct mlx5e_flow_steering {
+	bool				state_destroy;
+	bool				vlan_strip_disable;
 	struct mlx5_core_dev		*mdev;
 	struct mlx5_flow_namespace      *ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
@@ -180,13 +182,14 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
-					  struct mlx5_core_dev *mdev);
+					  struct mlx5_core_dev *mdev,
+					  bool state_destroy);
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs);
 
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
 void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
 int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
 void mlx5e_remove_mac_trap(struct mlx5e_priv *priv);
-
+void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs, struct net_device *netdev);
 #endif /* __MLX5E_FLOW_STEER_H__ */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index f25512d29b7c..0f3730a099bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -42,9 +42,9 @@
 #include "lib/mpfs.h"
 #include "en/ptp.h"
 
-static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
+static int mlx5e_add_l2_flow_rule(struct mlx5e_flow_steering *fs,
 				  struct mlx5e_l2_rule *ai, int type);
-static void mlx5e_del_l2_flow_rule(struct mlx5e_priv *priv,
+static void mlx5e_del_l2_flow_rule(struct mlx5e_flow_steering *fs,
 				   struct mlx5e_l2_rule *ai);
 
 enum {
@@ -521,7 +521,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 	for_each_set_bit(i, priv->fs->vlan->active_svlans, VLAN_N_VID)
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	WARN_ON_ONCE(!(test_bit(MLX5E_STATE_DESTROYING, &priv->state)));
+	WARN_ON_ONCE(priv->fs->state_destroy);
 
 	mlx5e_remove_vlan_trap(priv);
 
@@ -536,7 +536,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 	for (i = 0; i < MLX5E_L2_ADDR_HASH_SIZE; i++) \
 		hlist_for_each_entry_safe(hn, tmp, &hash[i], hlist)
 
-static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
+static void mlx5e_execute_l2_action(struct mlx5e_flow_steering *fs,
 				    struct mlx5e_l2_hash_node *hn)
 {
 	u8 action = hn->action;
@@ -547,9 +547,9 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
 
 	switch (action) {
 	case MLX5E_ACTION_ADD:
-		mlx5e_add_l2_flow_rule(priv, &hn->ai, MLX5E_FULLMATCH);
+		mlx5e_add_l2_flow_rule(fs, &hn->ai, MLX5E_FULLMATCH);
 		if (!is_multicast_ether_addr(mac_addr)) {
-			l2_err = mlx5_mpfs_add_mac(priv->fs->mdev, mac_addr);
+			l2_err = mlx5_mpfs_add_mac(fs->mdev, mac_addr);
 			hn->mpfs = !l2_err;
 		}
 		hn->action = MLX5E_ACTION_NONE;
@@ -557,52 +557,50 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
 
 	case MLX5E_ACTION_DEL:
 		if (!is_multicast_ether_addr(mac_addr) && hn->mpfs)
-			l2_err = mlx5_mpfs_del_mac(priv->fs->mdev, mac_addr);
-		mlx5e_del_l2_flow_rule(priv, &hn->ai);
+			l2_err = mlx5_mpfs_del_mac(fs->mdev, mac_addr);
+		mlx5e_del_l2_flow_rule(fs, &hn->ai);
 		mlx5e_del_l2_from_hash(hn);
 		break;
 	}
 
 	if (l2_err)
-		mlx5_core_warn(priv->fs->mdev, "MPFS, failed to %s mac %pM, err(%d)\n",
+		mlx5_core_warn(fs->mdev, "MPFS, failed to %s mac %pM, err(%d)\n",
 			       action == MLX5E_ACTION_ADD ? "add" : "del", mac_addr, l2_err);
 }
 
-static void mlx5e_sync_netdev_addr(struct mlx5e_priv *priv)
+static void mlx5e_sync_netdev_addr(struct mlx5e_flow_steering *fs,
+				   struct net_device *netdev)
 {
-	struct net_device *netdev = priv->netdev;
 	struct netdev_hw_addr *ha;
 
 	netif_addr_lock_bh(netdev);
 
-	mlx5e_add_l2_to_hash(priv->fs->l2.netdev_uc,
-			     priv->netdev->dev_addr);
-
+	mlx5e_add_l2_to_hash(fs->l2.netdev_uc, netdev->dev_addr);
 	netdev_for_each_uc_addr(ha, netdev)
-		mlx5e_add_l2_to_hash(priv->fs->l2.netdev_uc, ha->addr);
+		mlx5e_add_l2_to_hash(fs->l2.netdev_uc, ha->addr);
 
 	netdev_for_each_mc_addr(ha, netdev)
-		mlx5e_add_l2_to_hash(priv->fs->l2.netdev_mc, ha->addr);
+		mlx5e_add_l2_to_hash(fs->l2.netdev_mc, ha->addr);
 
 	netif_addr_unlock_bh(netdev);
 }
 
-static void mlx5e_fill_addr_array(struct mlx5e_priv *priv, int list_type,
+static void mlx5e_fill_addr_array(struct mlx5e_flow_steering *fs, int list_type,
+				  struct net_device *ndev,
 				  u8 addr_array[][ETH_ALEN], int size)
 {
 	bool is_uc = (list_type == MLX5_NVPRT_LIST_TYPE_UC);
-	struct net_device *ndev = priv->netdev;
 	struct mlx5e_l2_hash_node *hn;
 	struct hlist_head *addr_list;
 	struct hlist_node *tmp;
 	int i = 0;
 	int hi;
 
-	addr_list = is_uc ? priv->fs->l2.netdev_uc : priv->fs->l2.netdev_mc;
+	addr_list = is_uc ? fs->l2.netdev_uc : fs->l2.netdev_mc;
 
 	if (is_uc) /* Make sure our own address is pushed first */
 		ether_addr_copy(addr_array[i++], ndev->dev_addr);
-	else if (priv->fs->l2.broadcast_enabled)
+	else if (fs->l2.broadcast_enabled)
 		ether_addr_copy(addr_array[i++], ndev->broadcast);
 
 	mlx5e_for_each_hash_node(hn, tmp, addr_list, hi) {
@@ -614,7 +612,8 @@ static void mlx5e_fill_addr_array(struct mlx5e_priv *priv, int list_type,
 	}
 }
 
-static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
+static void mlx5e_vport_context_update_addr_list(struct mlx5e_flow_steering *fs,
+						 struct net_device *netdev,
 						 int list_type)
 {
 	bool is_uc = (list_type == MLX5_NVPRT_LIST_TYPE_UC);
@@ -627,17 +626,17 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
 	int err;
 	int hi;
 
-	size = is_uc ? 0 : (priv->fs->l2.broadcast_enabled ? 1 : 0);
+	size = is_uc ? 0 : (fs->l2.broadcast_enabled ? 1 : 0);
 	max_size = is_uc ?
-		1 << MLX5_CAP_GEN(priv->fs->mdev, log_max_current_uc_list) :
-		1 << MLX5_CAP_GEN(priv->fs->mdev, log_max_current_mc_list);
+		1 << MLX5_CAP_GEN(fs->mdev, log_max_current_uc_list) :
+		1 << MLX5_CAP_GEN(fs->mdev, log_max_current_mc_list);
 
-	addr_list = is_uc ? priv->fs->l2.netdev_uc : priv->fs->l2.netdev_mc;
+	addr_list = is_uc ? fs->l2.netdev_uc : fs->l2.netdev_mc;
 	mlx5e_for_each_hash_node(hn, tmp, addr_list, hi)
 		size++;
 
 	if (size > max_size) {
-		mlx5_core_warn(priv->fs->mdev,
+		mlx5_core_warn(fs->mdev,
 			       "mdev %s list size (%d) > (%d) max vport list size, some addresses will be dropped\n",
 			      is_uc ? "UC" : "MC", size, max_size);
 		size = max_size;
@@ -649,65 +648,67 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
 			err = -ENOMEM;
 			goto out;
 		}
-		mlx5e_fill_addr_array(priv, list_type, addr_array, size);
+		mlx5e_fill_addr_array(fs, list_type, netdev, addr_array, size);
 	}
 
-	err = mlx5_modify_nic_vport_mac_list(priv->fs->mdev, list_type, addr_array, size);
+	err = mlx5_modify_nic_vport_mac_list(fs->mdev, list_type, addr_array, size);
 out:
 	if (err)
-		mlx5_core_err(priv->fs->mdev,
+		mlx5_core_err(fs->mdev,
 			      "Failed to modify vport %s list err(%d)\n",
 			      is_uc ? "UC" : "MC", err);
 	kfree(addr_array);
 }
 
-static void mlx5e_vport_context_update(struct mlx5e_priv *priv)
+static void mlx5e_vport_context_update(struct mlx5e_flow_steering *fs,
+				       struct net_device *netdev)
 {
-	struct mlx5e_l2_table *ea = &priv->fs->l2;
+	struct mlx5e_l2_table *ea = &fs->l2;
 
-	mlx5e_vport_context_update_addr_list(priv, MLX5_NVPRT_LIST_TYPE_UC);
-	mlx5e_vport_context_update_addr_list(priv, MLX5_NVPRT_LIST_TYPE_MC);
-	mlx5_modify_nic_vport_promisc(priv->fs->mdev, 0,
+	mlx5e_vport_context_update_addr_list(fs, netdev, MLX5_NVPRT_LIST_TYPE_UC);
+	mlx5e_vport_context_update_addr_list(fs, netdev, MLX5_NVPRT_LIST_TYPE_MC);
+	mlx5_modify_nic_vport_promisc(fs->mdev, 0,
 				      ea->allmulti_enabled,
 				      ea->promisc_enabled);
 }
 
-static void mlx5e_apply_netdev_addr(struct mlx5e_priv *priv)
+static void mlx5e_apply_netdev_addr(struct mlx5e_flow_steering *fs)
 {
 	struct mlx5e_l2_hash_node *hn;
 	struct hlist_node *tmp;
 	int i;
 
-	mlx5e_for_each_hash_node(hn, tmp, priv->fs->l2.netdev_uc, i)
-		mlx5e_execute_l2_action(priv, hn);
+	mlx5e_for_each_hash_node(hn, tmp, fs->l2.netdev_uc, i)
+		mlx5e_execute_l2_action(fs, hn);
 
-	mlx5e_for_each_hash_node(hn, tmp, priv->fs->l2.netdev_mc, i)
-		mlx5e_execute_l2_action(priv, hn);
+	mlx5e_for_each_hash_node(hn, tmp, fs->l2.netdev_mc, i)
+		mlx5e_execute_l2_action(fs, hn);
 }
 
-static void mlx5e_handle_netdev_addr(struct mlx5e_priv *priv)
+static void mlx5e_handle_netdev_addr(struct mlx5e_flow_steering *fs,
+				     struct net_device *netdev)
 {
 	struct mlx5e_l2_hash_node *hn;
 	struct hlist_node *tmp;
 	int i;
 
-	mlx5e_for_each_hash_node(hn, tmp, priv->fs->l2.netdev_uc, i)
+	mlx5e_for_each_hash_node(hn, tmp, fs->l2.netdev_uc, i)
 		hn->action = MLX5E_ACTION_DEL;
-	mlx5e_for_each_hash_node(hn, tmp, priv->fs->l2.netdev_mc, i)
+	mlx5e_for_each_hash_node(hn, tmp, fs->l2.netdev_mc, i)
 		hn->action = MLX5E_ACTION_DEL;
 
-	if (!test_bit(MLX5E_STATE_DESTROYING, &priv->state))
-		mlx5e_sync_netdev_addr(priv);
+	if (fs->state_destroy)
+		mlx5e_sync_netdev_addr(fs, netdev);
 
-	mlx5e_apply_netdev_addr(priv);
+	mlx5e_apply_netdev_addr(fs);
 }
 
 #define MLX5E_PROMISC_GROUP0_SIZE BIT(0)
 #define MLX5E_PROMISC_TABLE_SIZE MLX5E_PROMISC_GROUP0_SIZE
 
-static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
+static int mlx5e_add_promisc_rule(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_flow_table *ft = priv->fs->promisc.ft.t;
+	struct mlx5_flow_table *ft = fs->promisc.ft.t;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_handle **rule_p;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -718,22 +719,22 @@ static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
 	if (!spec)
 		return -ENOMEM;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = mlx5_get_ttc_flow_table(priv->fs->ttc);
+	dest.ft = mlx5_get_ttc_flow_table(fs->ttc);
 
-	rule_p = &priv->fs->promisc.rule;
+	rule_p = &fs->promisc.rule;
 	*rule_p = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		mlx5_core_err(priv->fs->mdev, "%s: add promiscuous rule failed\n", __func__);
+		mlx5_core_err(fs->mdev, "%s: add promiscuous rule failed\n", __func__);
 	}
 	kvfree(spec);
 	return err;
 }
 
-static int mlx5e_create_promisc_table(struct mlx5e_priv *priv)
+static int mlx5e_create_promisc_table(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_flow_table *ft = &priv->fs->promisc.ft;
+	struct mlx5e_flow_table *ft = &fs->promisc.ft;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
 
@@ -742,14 +743,14 @@ static int mlx5e_create_promisc_table(struct mlx5e_priv *priv)
 	ft_attr.level = MLX5E_PROMISC_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_auto_grouped_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
-		mlx5_core_err(priv->fs->mdev, "fail to create promisc table err=%d\n", err);
+		mlx5_core_err(fs->mdev, "fail to create promisc table err=%d\n", err);
 		return err;
 	}
 
-	err = mlx5e_add_promisc_rule(priv);
+	err = mlx5e_add_promisc_rule(fs);
 	if (err)
 		goto err_destroy_promisc_table;
 
@@ -762,34 +763,31 @@ static int mlx5e_create_promisc_table(struct mlx5e_priv *priv)
 	return err;
 }
 
-static void mlx5e_del_promisc_rule(struct mlx5e_priv *priv)
+static void mlx5e_del_promisc_rule(struct mlx5e_flow_steering *fs)
 {
-	if (WARN(!priv->fs->promisc.rule, "Trying to remove non-existing promiscuous rule"))
+	if (WARN(!fs->promisc.rule, "Trying to remove non-existing promiscuous rule"))
 		return;
-	mlx5_del_flow_rules(priv->fs->promisc.rule);
-	priv->fs->promisc.rule = NULL;
+	mlx5_del_flow_rules(fs->promisc.rule);
+	fs->promisc.rule = NULL;
 }
 
-static void mlx5e_destroy_promisc_table(struct mlx5e_priv *priv)
+static void mlx5e_destroy_promisc_table(struct mlx5e_flow_steering *fs)
 {
-	if (WARN(!priv->fs->promisc.ft.t, "Trying to remove non-existing promiscuous table"))
+	if (WARN(!fs->promisc.ft.t, "Trying to remove non-existing promiscuous table"))
 		return;
-	mlx5e_del_promisc_rule(priv);
-	mlx5_destroy_flow_table(priv->fs->promisc.ft.t);
-	priv->fs->promisc.ft.t = NULL;
+	mlx5e_del_promisc_rule(fs);
+	mlx5_destroy_flow_table(fs->promisc.ft.t);
+	fs->promisc.ft.t = NULL;
 }
 
-void mlx5e_set_rx_mode_work(struct work_struct *work)
+void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs,
+			       struct net_device *netdev)
 {
-	struct mlx5e_priv *priv = container_of(work, struct mlx5e_priv,
-					       set_rx_mode_work);
-
-	struct mlx5e_l2_table *ea = &priv->fs->l2;
-	struct net_device *ndev = priv->netdev;
+	struct mlx5e_l2_table *ea = &fs->l2;
 
-	bool rx_mode_enable   = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	bool promisc_enabled   = rx_mode_enable && (ndev->flags & IFF_PROMISC);
-	bool allmulti_enabled  = rx_mode_enable && (ndev->flags & IFF_ALLMULTI);
+	bool rx_mode_enable  = fs->state_destroy;
+	bool promisc_enabled   = rx_mode_enable && (netdev->flags & IFF_PROMISC);
+	bool allmulti_enabled  = rx_mode_enable && (netdev->flags & IFF_ALLMULTI);
 	bool broadcast_enabled = rx_mode_enable;
 
 	bool enable_promisc    = !ea->promisc_enabled   &&  promisc_enabled;
@@ -801,32 +799,32 @@ void mlx5e_set_rx_mode_work(struct work_struct *work)
 	int err;
 
 	if (enable_promisc) {
-		err = mlx5e_create_promisc_table(priv);
+		err = mlx5e_create_promisc_table(fs);
 		if (err)
 			enable_promisc = false;
-		if (!priv->channels.params.vlan_strip_disable && !err)
-			mlx5_core_warn_once(priv->fs->mdev,
+		if (!fs->vlan_strip_disable && !err)
+			mlx5_core_warn_once(fs->mdev,
 					    "S-tagged traffic will be dropped while C-tag vlan stripping is enabled\n");
 	}
 	if (enable_allmulti)
-		mlx5e_add_l2_flow_rule(priv, &ea->allmulti, MLX5E_ALLMULTI);
+		mlx5e_add_l2_flow_rule(fs, &ea->allmulti, MLX5E_ALLMULTI);
 	if (enable_broadcast)
-		mlx5e_add_l2_flow_rule(priv, &ea->broadcast, MLX5E_FULLMATCH);
+		mlx5e_add_l2_flow_rule(fs, &ea->broadcast, MLX5E_FULLMATCH);
 
-	mlx5e_handle_netdev_addr(priv);
+	mlx5e_handle_netdev_addr(fs, netdev);
 
 	if (disable_broadcast)
-		mlx5e_del_l2_flow_rule(priv, &ea->broadcast);
+		mlx5e_del_l2_flow_rule(fs, &ea->broadcast);
 	if (disable_allmulti)
-		mlx5e_del_l2_flow_rule(priv, &ea->allmulti);
+		mlx5e_del_l2_flow_rule(fs, &ea->allmulti);
 	if (disable_promisc)
-		mlx5e_destroy_promisc_table(priv);
+		mlx5e_destroy_promisc_table(fs);
 
 	ea->promisc_enabled   = promisc_enabled;
 	ea->allmulti_enabled  = allmulti_enabled;
 	ea->broadcast_enabled = broadcast_enabled;
 
-	mlx5e_vport_context_update(priv);
+	mlx5e_vport_context_update(fs, netdev);
 }
 
 static void mlx5e_destroy_groups(struct mlx5e_flow_table *ft)
@@ -909,7 +907,7 @@ void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 	}
 }
 
-static void mlx5e_del_l2_flow_rule(struct mlx5e_priv *priv,
+static void mlx5e_del_l2_flow_rule(struct mlx5e_flow_steering *fs,
 				   struct mlx5e_l2_rule *ai)
 {
 	if (!IS_ERR_OR_NULL(ai->rule)) {
@@ -918,10 +916,10 @@ static void mlx5e_del_l2_flow_rule(struct mlx5e_priv *priv,
 	}
 }
 
-static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
+static int mlx5e_add_l2_flow_rule(struct mlx5e_flow_steering *fs,
 				  struct mlx5e_l2_rule *ai, int type)
 {
-	struct mlx5_flow_table *ft = priv->fs->l2.ft.t;
+	struct mlx5_flow_table *ft = fs->l2.ft.t;
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_spec *spec;
@@ -939,7 +937,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 			       outer_headers.dmac_47_16);
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = mlx5_get_ttc_flow_table(priv->fs->ttc);
+	dest.ft = mlx5_get_ttc_flow_table(fs->ttc);
 
 	switch (type) {
 	case MLX5E_FULLMATCH:
@@ -957,7 +955,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 
 	ai->rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(ai->rule)) {
-		mlx5_core_err(priv->fs->mdev, "%s: add l2 rule(mac:%pM) failed\n",
+		mlx5_core_err(fs->mdev, "%s: add l2 rule(mac:%pM) failed\n",
 			      __func__, mv_dmac);
 		err = PTR_ERR(ai->rule);
 		ai->rule = NULL;
@@ -1368,7 +1366,8 @@ static void mlx5e_fs_tc_free(struct mlx5e_flow_steering *fs)
 }
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
-					  struct mlx5_core_dev *mdev)
+					  struct mlx5_core_dev *mdev,
+					  bool state_destroy)
 {
 	struct mlx5e_flow_steering *fs;
 	int err;
@@ -1378,6 +1377,7 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 		goto err;
 
 	fs->mdev = mdev;
+	fs->state_destroy = state_destroy;
 	if (mlx5e_profile_feature_cap(profile, FS_VLAN)) {
 		err = mlx5e_fs_vlan_alloc(fs);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 55d4b8f8b3d3..ca7f8d6f8ab7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3777,14 +3777,17 @@ static int set_feature_rx_vlan(struct net_device *netdev, bool enable)
 
 	mutex_lock(&priv->state_lock);
 
+	priv->fs->vlan_strip_disable = !enable;
 	priv->channels.params.vlan_strip_disable = !enable;
+
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
 
 	err = mlx5e_modify_channels_vsd(&priv->channels, !enable);
-	if (err)
+	if (err) {
+		priv->fs->vlan_strip_disable = enable;
 		priv->channels.params.vlan_strip_disable = enable;
-
+	}
 unlock:
 	mutex_unlock(&priv->state_lock);
 
@@ -5020,7 +5023,8 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 
 	mlx5e_timestamp_init(priv);
 
-	fs = mlx5e_fs_init(priv->profile, mdev);
+	fs = mlx5e_fs_init(priv->profile, mdev,
+			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
@@ -5297,6 +5301,14 @@ int mlx5e_get_pf_num_tirs(struct mlx5_core_dev *mdev)
 		+ mlx5e_profile_max_num_channels(mdev, &mlx5e_nic_profile);
 }
 
+void mlx5e_set_rx_mode_work(struct work_struct *work)
+{
+	struct mlx5e_priv *priv = container_of(work, struct mlx5e_priv,
+					       set_rx_mode_work);
+
+	return mlx5e_fs_set_rx_mode_work(priv->fs, priv->netdev);
+}
+
 /* mlx5e generic netdev management API (move to en_common.c) */
 int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    const struct mlx5e_profile *profile,
@@ -5474,6 +5486,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	int err;
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
+	if (priv->fs)
+		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
 	/* max number of channels may have changed */
 	max_nch = mlx5e_calc_max_nch(priv->mdev, priv->netdev, profile);
@@ -5533,6 +5547,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 out:
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
+	if (priv->fs)
+		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -5542,6 +5558,8 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 	const struct mlx5e_profile *profile = priv->profile;
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
+	if (priv->fs)
+		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
 	if (profile->disable)
 		profile->disable(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3a4975bd46eb..3ad9752c35ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -836,7 +836,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	priv->fs = mlx5e_fs_init(priv->profile, mdev);
+	priv->fs = mlx5e_fs_init(priv->profile, mdev,
+				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 5d5331b1535b..c02b7b08fb4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -364,7 +364,8 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	priv->fs = mlx5e_fs_init(priv->profile, mdev);
+	priv->fs = mlx5e_fs_init(priv->profile, mdev,
+				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
-- 
2.37.1

