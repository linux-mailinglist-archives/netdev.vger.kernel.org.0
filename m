Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4594F58476C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiG1U65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiG1U60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:58:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A862578233
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB27361865
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341A5C433C1;
        Thu, 28 Jul 2022 20:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041863;
        bh=HvT0Xeu3q1vArM9Y3y6Knk4AZwTG69x8cqI9hJfxIqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6Vm2z8bBP/E+QXEZJh3jhkYdFJpmEtF8dbpidMQhFLgnw4ChNZYDZjHZ/QD/BgVk
         s4gPunBVnBT3o9BL90jMQiQVSKy3JIGBQqyGA4662TTNH8fm9OQWLH19kqNzbZCORc
         upNsyR8/qCh7T7KGjNffkmqVvd1lpfEWYXpuJ8c9lYTeSkfyQAk+RKX+zvTXPZdt8Q
         2wxHqQf/kYrs58JDbF58+VZz3/ELjZPHOHnYzzS+YIOCcDLK9v+pKizm8CFnLcoqjY
         5V3QQhp5azYSffAASojLuRFuYgHEPl1mNgy4BaV9j/DG3y+slrGP5VYiFTmwybc/SL
         KZh3R/GzdjOlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Split en_fs ndo's and move to en_main
Date:   Thu, 28 Jul 2022 13:57:27 -0700
Message-Id: <20220728205728.143074-15-saeed@kernel.org>
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

Add inner callee for ndo mlx5e_vlan_rx_add_vid and
mlx5e_vlan_rx_kill_vid, to separate the priv usage from other
flow steering flows.

Move wrapper ndo's into en_main, and split the rest of the functionality
into a separate part inside en_fs.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 180 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  22 +++
 3 files changed, 120 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 681a17df5da3..83f67e536ca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -191,5 +191,11 @@ void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
 int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
 void mlx5e_remove_mac_trap(struct mlx5e_priv *priv);
 void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs, struct net_device *netdev);
+int mlx5e_fs_vlan_rx_add_vid(struct mlx5e_flow_steering *fs,
+			     struct net_device *netdev,
+			     __be16 proto, u16 vid);
+int mlx5e_fs_vlan_rx_kill_vid(struct mlx5e_flow_steering *fs,
+			      struct net_device *netdev,
+			      __be16 proto, u16 vid);
 #endif /* __MLX5E_FLOW_STEER_H__ */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 0f3730a099bb..121407f57564 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -37,7 +37,6 @@
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/mpfs.h>
 #include "en.h"
-#include "en_rep.h"
 #include "en_tc.h"
 #include "lib/mpfs.h"
 #include "en/ptp.h"
@@ -133,7 +132,7 @@ struct mlx5_flow_table *mlx5e_vlan_get_flowtable(struct mlx5e_vlan_table *vlan)
 	return vlan->ft.t;
 }
 
-static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
+static int mlx5e_vport_context_update_vlans(struct mlx5e_flow_steering *fs)
 {
 	int max_list_size;
 	int list_size;
@@ -143,13 +142,13 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 	int i;
 
 	list_size = 0;
-	for_each_set_bit(vlan, priv->fs->vlan->active_cvlans, VLAN_N_VID)
+	for_each_set_bit(vlan, fs->vlan->active_cvlans, VLAN_N_VID)
 		list_size++;
 
-	max_list_size = 1 << MLX5_CAP_GEN(priv->fs->mdev, log_max_vlan_list);
+	max_list_size = 1 << MLX5_CAP_GEN(fs->mdev, log_max_vlan_list);
 
 	if (list_size > max_list_size) {
-		mlx5_core_warn(priv->fs->mdev,
+		mlx5_core_warn(fs->mdev,
 			       "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
 			       list_size, max_list_size);
 		list_size = max_list_size;
@@ -160,15 +159,15 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	i = 0;
-	for_each_set_bit(vlan, priv->fs->vlan->active_cvlans, VLAN_N_VID) {
+	for_each_set_bit(vlan, fs->vlan->active_cvlans, VLAN_N_VID) {
 		if (i >= list_size)
 			break;
 		vlans[i++] = vlan;
 	}
 
-	err = mlx5_modify_nic_vport_vlans(priv->fs->mdev, vlans, list_size);
+	err = mlx5_modify_nic_vport_vlans(fs->mdev, vlans, list_size);
 	if (err)
-		mlx5_core_err(priv->fs->mdev, "Failed to modify vport vlans list err(%d)\n",
+		mlx5_core_err(fs->mdev, "Failed to modify vport vlans list err(%d)\n",
 			      err);
 
 	kvfree(vlans);
@@ -183,18 +182,18 @@ enum mlx5e_vlan_rule_type {
 	MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID,
 };
 
-static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
+static int __mlx5e_add_vlan_rule(struct mlx5e_flow_steering *fs,
 				 enum mlx5e_vlan_rule_type rule_type,
 				 u16 vid, struct mlx5_flow_spec *spec)
 {
-	struct mlx5_flow_table *ft = priv->fs->vlan->ft.t;
+	struct mlx5_flow_table *ft = fs->vlan->ft.t;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_handle **rule_p;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	int err = 0;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = priv->fs->l2.ft.t;
+	dest.ft = fs->l2.ft.t;
 
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
@@ -204,24 +203,24 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 		 * disabled in match value means both S & C tags
 		 * don't exist (untagged of both)
 		 */
-		rule_p = &priv->fs->vlan->untagged_rule;
+		rule_p = &fs->vlan->untagged_rule;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID:
-		rule_p = &priv->fs->vlan->any_cvlan_rule;
+		rule_p = &fs->vlan->any_cvlan_rule;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.cvlan_tag, 1);
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID:
-		rule_p = &priv->fs->vlan->any_svlan_rule;
+		rule_p = &fs->vlan->any_svlan_rule;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.svlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.svlan_tag, 1);
 		break;
 	case MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID:
-		rule_p = &priv->fs->vlan->active_svlans_rule[vid];
+		rule_p = &fs->vlan->active_svlans_rule[vid];
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.svlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.svlan_tag, 1);
@@ -231,7 +230,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 			 vid);
 		break;
 	default: /* MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID */
-		rule_p = &priv->fs->vlan->active_cvlans_rule[vid];
+		rule_p = &fs->vlan->active_cvlans_rule[vid];
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.cvlan_tag, 1);
@@ -250,13 +249,13 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		mlx5_core_err(priv->fs->mdev, "%s: add rule failed\n", __func__);
+		mlx5_core_err(fs->mdev, "%s: add rule failed\n", __func__);
 	}
 
 	return err;
 }
 
-static int mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
+static int mlx5e_add_vlan_rule(struct mlx5e_flow_steering *fs,
 			       enum mlx5e_vlan_rule_type rule_type, u16 vid)
 {
 	struct mlx5_flow_spec *spec;
@@ -267,68 +266,68 @@ static int mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 		return -ENOMEM;
 
 	if (rule_type == MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID)
-		mlx5e_vport_context_update_vlans(priv);
+		mlx5e_vport_context_update_vlans(fs);
 
-	err = __mlx5e_add_vlan_rule(priv, rule_type, vid, spec);
+	err = __mlx5e_add_vlan_rule(fs, rule_type, vid, spec);
 
 	kvfree(spec);
 
 	return err;
 }
 
-static void mlx5e_del_vlan_rule(struct mlx5e_priv *priv,
-				enum mlx5e_vlan_rule_type rule_type, u16 vid)
+static void mlx5e_fs_del_vlan_rule(struct mlx5e_flow_steering *fs,
+				   enum mlx5e_vlan_rule_type rule_type, u16 vid)
 {
 	switch (rule_type) {
 	case MLX5E_VLAN_RULE_TYPE_UNTAGGED:
-		if (priv->fs->vlan->untagged_rule) {
-			mlx5_del_flow_rules(priv->fs->vlan->untagged_rule);
-			priv->fs->vlan->untagged_rule = NULL;
+		if (fs->vlan->untagged_rule) {
+			mlx5_del_flow_rules(fs->vlan->untagged_rule);
+			fs->vlan->untagged_rule = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID:
-		if (priv->fs->vlan->any_cvlan_rule) {
-			mlx5_del_flow_rules(priv->fs->vlan->any_cvlan_rule);
-			priv->fs->vlan->any_cvlan_rule = NULL;
+		if (fs->vlan->any_cvlan_rule) {
+			mlx5_del_flow_rules(fs->vlan->any_cvlan_rule);
+			fs->vlan->any_cvlan_rule = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID:
-		if (priv->fs->vlan->any_svlan_rule) {
-			mlx5_del_flow_rules(priv->fs->vlan->any_svlan_rule);
-			priv->fs->vlan->any_svlan_rule = NULL;
+		if (fs->vlan->any_svlan_rule) {
+			mlx5_del_flow_rules(fs->vlan->any_svlan_rule);
+			fs->vlan->any_svlan_rule = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID:
-		if (priv->fs->vlan->active_svlans_rule[vid]) {
-			mlx5_del_flow_rules(priv->fs->vlan->active_svlans_rule[vid]);
-			priv->fs->vlan->active_svlans_rule[vid] = NULL;
+		if (fs->vlan->active_svlans_rule[vid]) {
+			mlx5_del_flow_rules(fs->vlan->active_svlans_rule[vid]);
+			fs->vlan->active_svlans_rule[vid] = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID:
-		if (priv->fs->vlan->active_cvlans_rule[vid]) {
-			mlx5_del_flow_rules(priv->fs->vlan->active_cvlans_rule[vid]);
-			priv->fs->vlan->active_cvlans_rule[vid] = NULL;
+		if (fs->vlan->active_cvlans_rule[vid]) {
+			mlx5_del_flow_rules(fs->vlan->active_cvlans_rule[vid]);
+			fs->vlan->active_cvlans_rule[vid] = NULL;
 		}
-		mlx5e_vport_context_update_vlans(priv);
+		mlx5e_vport_context_update_vlans(fs);
 		break;
 	}
 }
 
-static void mlx5e_del_any_vid_rules(struct mlx5e_priv *priv)
+static void mlx5e_fs_del_any_vid_rules(struct mlx5e_flow_steering *fs)
 {
-	mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
-	mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID, 0);
+	mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
+	mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID, 0);
 }
 
-static int mlx5e_add_any_vid_rules(struct mlx5e_priv *priv)
+static int mlx5e_fs_add_any_vid_rules(struct mlx5e_flow_steering *fs)
 {
 	int err;
 
-	err = mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
+	err = mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
 	if (err)
 		return err;
 
-	return mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID, 0);
+	return mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID, 0);
 }
 
 static struct mlx5_flow_handle *
@@ -412,7 +411,7 @@ void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv)
 	priv->fs->vlan->cvlan_filter_disabled = false;
 	if (priv->netdev->flags & IFF_PROMISC)
 		return;
-	mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
+	mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
 }
 
 void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv)
@@ -423,32 +422,32 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv)
 	priv->fs->vlan->cvlan_filter_disabled = true;
 	if (priv->netdev->flags & IFF_PROMISC)
 		return;
-	mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
+	mlx5e_add_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
 }
 
-static int mlx5e_vlan_rx_add_cvid(struct mlx5e_priv *priv, u16 vid)
+static int mlx5e_vlan_rx_add_cvid(struct mlx5e_flow_steering *fs, u16 vid)
 {
 	int err;
 
-	set_bit(vid, priv->fs->vlan->active_cvlans);
+	set_bit(vid, fs->vlan->active_cvlans);
 
-	err = mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
+	err = mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
 	if (err)
-		clear_bit(vid, priv->fs->vlan->active_cvlans);
+		clear_bit(vid, fs->vlan->active_cvlans);
 
 	return err;
 }
 
-static int mlx5e_vlan_rx_add_svid(struct mlx5e_priv *priv, u16 vid)
+static int mlx5e_vlan_rx_add_svid(struct mlx5e_flow_steering *fs,
+				  struct net_device *netdev, u16 vid)
 {
-	struct net_device *netdev = priv->netdev;
 	int err;
 
-	set_bit(vid, priv->fs->vlan->active_svlans);
+	set_bit(vid, fs->vlan->active_svlans);
 
-	err = mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, vid);
+	err = mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, vid);
 	if (err) {
-		clear_bit(vid, priv->fs->vlan->active_svlans);
+		clear_bit(vid, fs->vlan->active_svlans);
 		return err;
 	}
 
@@ -457,69 +456,74 @@ static int mlx5e_vlan_rx_add_svid(struct mlx5e_priv *priv, u16 vid)
 	return err;
 }
 
-int mlx5e_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
+int mlx5e_fs_vlan_rx_add_vid(struct mlx5e_flow_steering *fs,
+			     struct net_device *netdev,
+			     __be16 proto, u16 vid)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
 
-	if (mlx5e_is_uplink_rep(priv))
-		return 0; /* no vlan table for uplink rep */
+	if (!fs->vlan) {
+		mlx5_core_err(fs->mdev, "Vlan doesn't exist\n");
+		return -EINVAL;
+	}
 
 	if (be16_to_cpu(proto) == ETH_P_8021Q)
-		return mlx5e_vlan_rx_add_cvid(priv, vid);
+		return mlx5e_vlan_rx_add_cvid(fs, vid);
 	else if (be16_to_cpu(proto) == ETH_P_8021AD)
-		return mlx5e_vlan_rx_add_svid(priv, vid);
+		return mlx5e_vlan_rx_add_svid(fs, netdev, vid);
 
 	return -EOPNOTSUPP;
 }
 
-int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
+int mlx5e_fs_vlan_rx_kill_vid(struct mlx5e_flow_steering *fs,
+			      struct net_device *netdev,
+			      __be16 proto, u16 vid)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (mlx5e_is_uplink_rep(priv))
-		return 0; /* no vlan table for uplink rep */
+	if (!fs->vlan) {
+		mlx5_core_err(fs->mdev, "Vlan doesn't exist\n");
+		return -EINVAL;
+	}
 
 	if (be16_to_cpu(proto) == ETH_P_8021Q) {
-		clear_bit(vid, priv->fs->vlan->active_cvlans);
-		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
+		clear_bit(vid, fs->vlan->active_cvlans);
+		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
 	} else if (be16_to_cpu(proto) == ETH_P_8021AD) {
-		clear_bit(vid, priv->fs->vlan->active_svlans);
-		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, vid);
-		netdev_update_features(dev);
+		clear_bit(vid, fs->vlan->active_svlans);
+		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, vid);
+		netdev_update_features(netdev);
 	}
 
 	return 0;
 }
 
-static void mlx5e_add_vlan_rules(struct mlx5e_priv *priv)
+static void mlx5e_fs_add_vlan_rules(struct mlx5e_flow_steering *fs)
 {
 	int i;
 
-	mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
+	mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
 
-	for_each_set_bit(i, priv->fs->vlan->active_cvlans, VLAN_N_VID) {
-		mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
+	for_each_set_bit(i, fs->vlan->active_cvlans, VLAN_N_VID) {
+		mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
 	}
 
-	for_each_set_bit(i, priv->fs->vlan->active_svlans, VLAN_N_VID)
-		mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
+	for_each_set_bit(i, fs->vlan->active_svlans, VLAN_N_VID)
+		mlx5e_add_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	if (priv->fs->vlan->cvlan_filter_disabled)
-		mlx5e_add_any_vid_rules(priv);
+	if (fs->vlan->cvlan_filter_disabled)
+		mlx5e_fs_add_any_vid_rules(fs);
 }
 
 static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 {
 	int i;
 
-	mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
+	mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
 
 	for_each_set_bit(i, priv->fs->vlan->active_cvlans, VLAN_N_VID) {
-		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
+		mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
 	}
 
 	for_each_set_bit(i, priv->fs->vlan->active_svlans, VLAN_N_VID)
-		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
+		mlx5e_fs_del_vlan_rule(priv->fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
 	WARN_ON_ONCE(priv->fs->state_destroy);
 
@@ -529,7 +533,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 	 * set_rx_mode is called and flushed
 	 */
 	if (priv->fs->vlan->cvlan_filter_disabled)
-		mlx5e_del_any_vid_rules(priv);
+		mlx5e_fs_del_any_vid_rules(priv->fs);
 }
 
 #define mlx5e_for_each_hash_node(hn, tmp, hash, i) \
@@ -1178,20 +1182,20 @@ static int mlx5e_create_vlan_table_groups(struct mlx5e_flow_table *ft)
 	return err;
 }
 
-static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
+static int mlx5e_fs_create_vlan_table(struct mlx5e_flow_steering *fs)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5e_flow_table *ft;
 	int err;
 
-	ft = &priv->fs->vlan->ft;
+	ft = &fs->vlan->ft;
 	ft->num_groups = 0;
 
 	ft_attr.max_fte = MLX5E_VLAN_TABLE_SIZE;
 	ft_attr.level = MLX5E_VLAN_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t))
 		return PTR_ERR(ft->t);
 
@@ -1205,7 +1209,7 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 	if (err)
 		goto err_free_g;
 
-	mlx5e_add_vlan_rules(priv);
+	mlx5e_fs_add_vlan_rules(fs);
 
 	return 0;
 
@@ -1299,7 +1303,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		goto err_destroy_ttc_table;
 	}
 
-	err = mlx5e_create_vlan_table(priv);
+	err = mlx5e_fs_create_vlan_table(priv->fs);
 	if (err) {
 		mlx5_core_err(priv->fs->mdev, "Failed to create vlan table, err=%d\n",
 			      err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ca7f8d6f8ab7..2a6f5de2db28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3794,6 +3794,28 @@ static int set_feature_rx_vlan(struct net_device *netdev, bool enable)
 	return err;
 }
 
+int mlx5e_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_flow_steering *fs = priv->fs;
+
+	if (mlx5e_is_uplink_rep(priv))
+		return 0; /* no vlan table for uplink rep */
+
+	return mlx5e_fs_vlan_rx_add_vid(fs, dev, proto, vid);
+}
+
+int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_flow_steering *fs = priv->fs;
+
+	if (mlx5e_is_uplink_rep(priv))
+		return 0; /* no vlan table for uplink rep */
+
+	return mlx5e_fs_vlan_rx_kill_vid(fs, dev, proto, vid);
+}
+
 #ifdef CONFIG_MLX5_EN_ARFS
 static int set_feature_arfs(struct net_device *netdev, bool enable)
 {
-- 
2.37.1

