Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8EA584768
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiG1U6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiG1U5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C44178595
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33F0161871
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAC3C433D6;
        Thu, 28 Jul 2022 20:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041860;
        bh=/rCAsb7CoGFYYbRJdaA6ljL5oqdBc42qxd6B5P6wsCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXwTv3/rkEHGmrOqXjDAYXxoGm/paxWLCmMNbtfqk0MD4qJdz6mWrBERBemD289pO
         0UldTpmadyFbbIMSgLv5Wa5FzKjv5YIIRkxoqA0F8htfmGP1MSlTdBlTKrKqw17v7s
         G9Ezix670R2NhonkNRPrcrgP21ip582qFf9iVDEV5MwyjO7+lxl0tGiuWdiP4Uccb1
         xIdgD0hMM+tc0iBi0EayzC6VNcv4SQCqayYSVEQdIqfFnxBLGJd/vTnuy6VMmR2I/o
         6smzDmNSKqng2NI33EiXtY7puyoDmRkZga9HO+qpBk0jRV4uUP6VqYaK3XxpdLXAgq
         zRvnE+VBMSG8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Report flow steering errors with mdev err report API
Date:   Thu, 28 Jul 2022 13:57:24 -0700
Message-Id: <20220728205728.143074-12-saeed@kernel.org>
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

Let en_fs report errors via mdev error report API, aka mlx5_core_*
macros, thus replace the netdev API reports.
This to minimize netdev coupling to the flow steering struct.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 70 +++++++++----------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 4fa256019298..c4994220c7d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -135,7 +135,6 @@ struct mlx5_flow_table *mlx5e_vlan_get_flowtable(struct mlx5e_vlan_table *vlan)
 
 static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 {
-	struct net_device *ndev = priv->netdev;
 	int max_list_size;
 	int list_size;
 	u16 *vlans;
@@ -150,9 +149,9 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 	max_list_size = 1 << MLX5_CAP_GEN(priv->mdev, log_max_vlan_list);
 
 	if (list_size > max_list_size) {
-		netdev_warn(ndev,
-			    "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
-			    list_size, max_list_size);
+		mlx5_core_warn(priv->mdev,
+			       "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
+			       list_size, max_list_size);
 		list_size = max_list_size;
 	}
 
@@ -169,8 +168,8 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 
 	err = mlx5_modify_nic_vport_vlans(priv->mdev, vlans, list_size);
 	if (err)
-		netdev_err(ndev, "Failed to modify vport vlans list err(%d)\n",
-			   err);
+		mlx5_core_err(priv->mdev, "Failed to modify vport vlans list err(%d)\n",
+			      err);
 
 	kvfree(vlans);
 	return err;
@@ -251,7 +250,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		netdev_err(priv->netdev, "%s: add rule failed\n", __func__);
+		mlx5_core_err(priv->mdev, "%s: add rule failed\n", __func__);
 	}
 
 	return err;
@@ -363,8 +362,8 @@ int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->fs->vlan->trap_rule = NULL;
-		netdev_err(priv->netdev, "%s: add VLAN trap rule failed, err %d\n",
-			   __func__, err);
+		mlx5_core_err(priv->mdev, "%s: add VLAN trap rule failed, err %d\n",
+			      __func__, err);
 		return err;
 	}
 	priv->fs->vlan->trap_rule = rule;
@@ -389,8 +388,8 @@ int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->fs->l2.trap_rule = NULL;
-		netdev_err(priv->netdev, "%s: add MAC trap rule failed, err %d\n",
-			   __func__, err);
+		mlx5_core_err(priv->mdev, "%s: add MAC trap rule failed, err %d\n",
+			      __func__, err);
 		return err;
 	}
 	priv->fs->l2.trap_rule = rule;
@@ -565,8 +564,8 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
 	}
 
 	if (l2_err)
-		netdev_warn(priv->netdev, "MPFS, failed to %s mac %pM, err(%d)\n",
-			    action == MLX5E_ACTION_ADD ? "add" : "del", mac_addr, l2_err);
+		mlx5_core_warn(priv->mdev, "MPFS, failed to %s mac %pM, err(%d)\n",
+			       action == MLX5E_ACTION_ADD ? "add" : "del", mac_addr, l2_err);
 }
 
 static void mlx5e_sync_netdev_addr(struct mlx5e_priv *priv)
@@ -638,9 +637,9 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
 		size++;
 
 	if (size > max_size) {
-		netdev_warn(priv->netdev,
-			    "netdev %s list size (%d) > (%d) max vport list size, some addresses will be dropped\n",
-			    is_uc ? "UC" : "MC", size, max_size);
+		mlx5_core_warn(priv->mdev,
+			       "mdev %s list size (%d) > (%d) max vport list size, some addresses will be dropped\n",
+			      is_uc ? "UC" : "MC", size, max_size);
 		size = max_size;
 	}
 
@@ -656,9 +655,9 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_priv *priv,
 	err = mlx5_modify_nic_vport_mac_list(priv->mdev, list_type, addr_array, size);
 out:
 	if (err)
-		netdev_err(priv->netdev,
-			   "Failed to modify vport %s list err(%d)\n",
-			   is_uc ? "UC" : "MC", err);
+		mlx5_core_err(priv->mdev,
+			      "Failed to modify vport %s list err(%d)\n",
+			      is_uc ? "UC" : "MC", err);
 	kfree(addr_array);
 }
 
@@ -726,7 +725,7 @@ static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		netdev_err(priv->netdev, "%s: add promiscuous rule failed\n", __func__);
+		mlx5_core_err(priv->mdev, "%s: add promiscuous rule failed\n", __func__);
 	}
 	kvfree(spec);
 	return err;
@@ -746,7 +745,7 @@ static int mlx5e_create_promisc_table(struct mlx5e_priv *priv)
 	ft->t = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
-		netdev_err(priv->netdev, "fail to create promisc table err=%d\n", err);
+		mlx5_core_err(priv->mdev, "fail to create promisc table err=%d\n", err);
 		return err;
 	}
 
@@ -806,8 +805,8 @@ void mlx5e_set_rx_mode_work(struct work_struct *work)
 		if (err)
 			enable_promisc = false;
 		if (!priv->channels.params.vlan_strip_disable && !err)
-			netdev_warn_once(ndev,
-					 "S-tagged traffic will be dropped while C-tag vlan stripping is enabled\n");
+			mlx5_core_warn_once(priv->mdev,
+					    "S-tagged traffic will be dropped while C-tag vlan stripping is enabled\n");
 	}
 	if (enable_allmulti)
 		mlx5e_add_l2_flow_rule(priv, &ea->allmulti, MLX5E_ALLMULTI);
@@ -958,8 +957,8 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 
 	ai->rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(ai->rule)) {
-		netdev_err(priv->netdev, "%s: add l2 rule(mac:%pM) failed\n",
-			   __func__, mv_dmac);
+		mlx5_core_err(priv->mdev, "%s: add l2 rule(mac:%pM) failed\n",
+			      __func__, mv_dmac);
 		err = PTR_ERR(ai->rule);
 		ai->rule = NULL;
 	}
@@ -1276,37 +1275,36 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 	err = mlx5e_arfs_create_tables(priv);
 	if (err) {
-		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
-			   err);
+		mlx5_core_err(priv->mdev, "Failed to create arfs tables, err=%d\n",
+			      err);
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
 	err = mlx5e_create_inner_ttc_table(priv);
 	if (err) {
-		netdev_err(priv->netdev,
-			   "Failed to create inner ttc table, err=%d\n",
-			   err);
+		mlx5_core_err(priv->mdev,
+			      "Failed to create inner ttc table, err=%d\n", err);
 		goto err_destroy_arfs_tables;
 	}
 
 	err = mlx5e_create_ttc_table(priv);
 	if (err) {
-		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
-			   err);
+		mlx5_core_err(priv->mdev, "Failed to create ttc table, err=%d\n",
+			      err);
 		goto err_destroy_inner_ttc_table;
 	}
 
 	err = mlx5e_create_l2_table(priv);
 	if (err) {
-		netdev_err(priv->netdev, "Failed to create l2 table, err=%d\n",
-			   err);
+		mlx5_core_err(priv->mdev, "Failed to create l2 table, err=%d\n",
+			      err);
 		goto err_destroy_ttc_table;
 	}
 
 	err = mlx5e_create_vlan_table(priv);
 	if (err) {
-		netdev_err(priv->netdev, "Failed to create vlan table, err=%d\n",
-			   err);
+		mlx5_core_err(priv->mdev, "Failed to create vlan table, err=%d\n",
+			      err);
 		goto err_destroy_l2_table;
 	}
 
-- 
2.37.1

