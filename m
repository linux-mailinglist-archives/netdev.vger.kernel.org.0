Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F363A227E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFJDAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhFJDAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C89F6142D;
        Thu, 10 Jun 2021 02:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293906;
        bh=yVK0d1+UY6787kvqscNmlp+eizyAkTeTnupwwZzBA1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqSb5lUnctRssADxT30TGCIim+p2L9SKnKlXEsWpu3T95u84tp2F2uvDxuqXD+qsq
         uJJDUhI3oWVcdd/YeAOG2DjO9jAmvCE0+br+ce0A7Q4O+GyYkPT00BRwP77mAn+2gR
         +5fUxSDipFW62wtUlzsjEq/rEzsM/2HLTgWOuUKXWSdn2Ru8E7WYwPMFq05/Lbns9g
         Ngv0inUcfTNv2WpYrMgNZSi20pAHb2LlNHW9i85hm7Y2M9mBUMdE2oBOub1oZWJ8SK
         3B+Ceg3lpy2G6iqEWNyaFxAdz77ayK8yS8kY3q5gpLCQm9NS2hbKUibC9H1Jc79TfB
         laLxKRL7o6Wbg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5: Bridge, filter tagged packets that didn't match tagged fg
Date:   Wed,  9 Jun 2021 19:58:13 -0700
Message-Id: <20210610025814.274607-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

With support for pvid vlans in mlx5 bridge it is possible to have rules in
untagged flow group when vlan filtering is enabled. However, such rules can
also match tagged packets that didn't match anything in tagged flow group.
Filter such packets by introducing additional flow group between tagged and
untagged groups. When filtering is enabled on the bridge create additional
flow in vlan filtering flow group and matches tagged packets with specified
source MAC address and redirects them to new "skip" table. The skip table
is new lowest-level empty table that is used to skip all further processing
on packet in bridge priority.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 141 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   3 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 3 files changed, 141 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 442a62ff7b43..b6345619cbfe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -15,9 +15,13 @@
 
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE 64000
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE / 2 - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM \
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE / 4 - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM \
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO \
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE / 2 - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE - 1)
 
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE 64000
@@ -27,9 +31,12 @@
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 1)
 
+#define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
+
 enum {
 	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
 	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
 };
 
 struct mlx5_esw_bridge_fdb_key {
@@ -54,6 +61,7 @@ struct mlx5_esw_bridge_fdb_entry {
 	struct mlx5_fc *ingress_counter;
 	unsigned long lastuse;
 	struct mlx5_flow_handle *egress_handle;
+	struct mlx5_flow_handle *filter_handle;
 };
 
 static const struct rhashtable_params fdb_ht_params = {
@@ -172,6 +180,44 @@ mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flo
 	return fg;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_filter_fg_create(struct mlx5_eswitch *esw,
+					 struct mlx5_flow_table *ingress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_2);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+
+	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_mask());
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(ingress_ft, in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create bridge ingress table VLAN filter flow group (err=%ld)\n",
+			 PTR_ERR(fg));
+
+	kvfree(in);
+	return fg;
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
 {
@@ -275,8 +321,8 @@ mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_
 static int
 mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_flow_group *mac_fg, *vlan_fg;
-	struct mlx5_flow_table *ingress_ft;
+	struct mlx5_flow_group *mac_fg, *filter_fg, *vlan_fg;
+	struct mlx5_flow_table *ingress_ft, *skip_ft;
 	int err;
 
 	if (!mlx5_eswitch_vport_match_metadata_enabled(br_offloads->esw))
@@ -288,12 +334,26 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	if (IS_ERR(ingress_ft))
 		return PTR_ERR(ingress_ft);
 
+	skip_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE,
+					       MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
+					       br_offloads->esw);
+	if (IS_ERR(skip_ft)) {
+		err = PTR_ERR(skip_ft);
+		goto err_skip_tbl;
+	}
+
 	vlan_fg = mlx5_esw_bridge_ingress_vlan_fg_create(br_offloads->esw, ingress_ft);
 	if (IS_ERR(vlan_fg)) {
 		err = PTR_ERR(vlan_fg);
 		goto err_vlan_fg;
 	}
 
+	filter_fg = mlx5_esw_bridge_ingress_filter_fg_create(br_offloads->esw, ingress_ft);
+	if (IS_ERR(filter_fg)) {
+		err = PTR_ERR(filter_fg);
+		goto err_filter_fg;
+	}
+
 	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(br_offloads->esw, ingress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
@@ -301,13 +361,19 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	}
 
 	br_offloads->ingress_ft = ingress_ft;
+	br_offloads->skip_ft = skip_ft;
 	br_offloads->ingress_vlan_fg = vlan_fg;
+	br_offloads->ingress_filter_fg = filter_fg;
 	br_offloads->ingress_mac_fg = mac_fg;
 	return 0;
 
 err_mac_fg:
+	mlx5_destroy_flow_group(filter_fg);
+err_filter_fg:
 	mlx5_destroy_flow_group(vlan_fg);
 err_vlan_fg:
+	mlx5_destroy_flow_table(skip_ft);
+err_skip_tbl:
 	mlx5_destroy_flow_table(ingress_ft);
 	return err;
 }
@@ -317,8 +383,12 @@ mlx5_esw_bridge_ingress_table_cleanup(struct mlx5_esw_bridge_offloads *br_offloa
 {
 	mlx5_destroy_flow_group(br_offloads->ingress_mac_fg);
 	br_offloads->ingress_mac_fg = NULL;
+	mlx5_destroy_flow_group(br_offloads->ingress_filter_fg);
+	br_offloads->ingress_filter_fg = NULL;
 	mlx5_destroy_flow_group(br_offloads->ingress_vlan_fg);
 	br_offloads->ingress_vlan_fg = NULL;
+	mlx5_destroy_flow_table(br_offloads->skip_ft);
+	br_offloads->skip_ft = NULL;
 	mlx5_destroy_flow_table(br_offloads->ingress_ft);
 	br_offloads->ingress_ft = NULL;
 }
@@ -428,6 +498,52 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
 	return handle;
 }
 
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_ingress_filter_flow_create(u16 vport_num, const unsigned char *addr,
+					   struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
+		.ft = br_offloads->skip_ft,
+	};
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+	u8 *smac_v, *smac_c;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_2;
+
+	smac_v = MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
+			      outer_headers.smac_47_16);
+	ether_addr_copy(smac_v, addr);
+	smac_c = MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria,
+			      outer_headers.smac_47_16);
+	eth_broadcast_addr(smac_c);
+
+	MLX5_SET(fte_match_param, rule_spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
+	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
+
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+			 outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+			 outer_headers.cvlan_tag);
+
+	handle = mlx5_add_flow_rules(br_offloads->ingress_ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
 static struct mlx5_flow_handle *
 mlx5_esw_bridge_egress_flow_create(u16 vport_num, const unsigned char *addr,
 				   struct mlx5_esw_bridge_vlan *vlan,
@@ -587,8 +703,11 @@ mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
 {
 	rhashtable_remove_fast(&bridge->fdb_ht, &entry->ht_node, fdb_ht_params);
 	mlx5_del_flow_rules(entry->egress_handle);
+	if (entry->filter_handle)
+		mlx5_del_flow_rules(entry->filter_handle);
 	mlx5_del_flow_rules(entry->ingress_handle);
 	mlx5_fc_destroy(bridge->br_offloads->esw->dev, entry->ingress_counter);
+	list_del(&entry->vlan_list);
 	list_del(&entry->list);
 	kvfree(entry);
 }
@@ -857,6 +976,17 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 	}
 	entry->ingress_handle = handle;
 
+	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG) {
+		handle = mlx5_esw_bridge_ingress_filter_flow_create(vport_num, addr, bridge);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			esw_warn(esw->dev, "Failed to create ingress filter(vport=%u,err=%d)\n",
+				 vport_num, err);
+			goto err_ingress_filter_flow_create;
+		}
+		entry->filter_handle = handle;
+	}
+
 	handle = mlx5_esw_bridge_egress_flow_create(vport_num, addr, vlan, bridge);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
@@ -882,6 +1012,9 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 err_ht_init:
 	mlx5_del_flow_rules(entry->egress_handle);
 err_egress_flow_create:
+	if (entry->filter_handle)
+		mlx5_del_flow_rules(entry->filter_handle);
+err_ingress_filter_flow_create:
 	mlx5_del_flow_rules(entry->ingress_handle);
 err_ingress_flow_create:
 	mlx5_fc_destroy(priv->mdev, entry->ingress_counter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index bedbda57cdb3..d826942b27fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -23,7 +23,10 @@ struct mlx5_esw_bridge_offloads {
 
 	struct mlx5_flow_table *ingress_ft;
 	struct mlx5_flow_group *ingress_vlan_fg;
+	struct mlx5_flow_group *ingress_filter_fg;
 	struct mlx5_flow_group *ingress_mac_fg;
+
+	struct mlx5_flow_table *skip_ft;
 };
 
 struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fc37ac9eab12..2cd7aea5d329 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2786,7 +2786,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
-	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BR_OFFLOAD, 2);
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BR_OFFLOAD, 3);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
 		goto out_err;
-- 
2.31.1

