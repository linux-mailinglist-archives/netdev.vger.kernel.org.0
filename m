Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77676160341
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBPKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52963 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727637AbgBPKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:47 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce3007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v3 07/16] net/mlx5: E-Switch, Get reg_c0 value on CQE
Date:   Sun, 16 Feb 2020 12:01:27 +0200
Message-Id: <1581847296-19194-8-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RX side create a restore table in OFFLOADS namespace.
This table will match on all values for reg_c0 we will use,
and set it to the flow_tag. This flow tag can then be read on the CQE.

As there is no copy action from reg c0 to flow tag, instead we have to
set the flow tag explictily. We add an API so callers can add all the used
reg_c0 values (tags) and for each of those we add a restore rule.

This will be used in a following patch to save the miss chain mapping
tag on reg_c0 and from it restore the tc chain on the skb.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  14 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 147 +++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +-
 include/linux/mlx5/eswitch.h                       |   2 +
 4 files changed, 156 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 4472710..a94d91c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -189,6 +189,9 @@ struct mlx5_eswitch_fdb {
 };
 
 struct mlx5_esw_offload {
+	struct mlx5_flow_table *ft_offloads_restore;
+	struct mlx5_flow_group *restore_group;
+
 	struct mlx5_flow_table *ft_offloads;
 	struct mlx5_flow_group *vport_rx_group;
 	struct mlx5_eswitch_rep *vport_reps;
@@ -623,6 +626,11 @@ struct mlx5_vport *__must_check
 esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport);
 
+struct mlx5_flow_handle *
+esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag);
+u32
+esw_get_max_restore_tag(struct mlx5_eswitch *esw);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
@@ -638,6 +646,12 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 
 static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs) {}
 
+static struct mlx5_flow_handle *
+esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 788bb83..81c2cbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -838,6 +838,54 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 	return err;
 }
 
+struct mlx5_flow_handle *
+esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
+{
+	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
+	struct mlx5_flow_table *ft = esw->offloads.ft_offloads_restore;
+	struct mlx5_flow_context *flow_context;
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5_flow_destination dest;
+	struct mlx5_flow_spec *spec;
+	void *misc;
+
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
+
+	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    misc_parameters_2);
+	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+		 ESW_CHAIN_TAG_METADATA_MASK);
+	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    misc_parameters_2);
+	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0, tag);
+	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
+	flow_context = &spec->flow_context;
+	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
+	flow_context->flow_tag = tag;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = esw->offloads.ft_offloads;
+
+	flow_rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
+	kfree(spec);
+
+	if (IS_ERR(flow_rule))
+		esw_warn(esw->dev,
+			 "Failed to create restore rule for tag: %d, err(%d)\n",
+			 tag, (int)PTR_ERR(flow_rule));
+
+	return flow_rule;
+}
+
+u32
+esw_get_max_restore_tag(struct mlx5_eswitch *esw)
+{
+	return ESW_CHAIN_TAG_METADATA_MASK;
+}
+
 #define MAX_PF_SQ 256
 #define MAX_SQ_NVPORTS 32
 
@@ -1060,6 +1108,7 @@ static int esw_create_offloads_table(struct mlx5_eswitch *esw, int nvports)
 	}
 
 	ft_attr.max_fte = nvports + MLX5_ESW_MISS_FLOWS;
+	ft_attr.prio = 1;
 
 	ft_offloads = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft_offloads)) {
@@ -1164,6 +1213,81 @@ struct mlx5_flow_handle *
 	return flow_rule;
 }
 
+static void esw_destroy_restore_table(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_offload *offloads = &esw->offloads;
+
+	mlx5_destroy_flow_group(offloads->restore_group);
+	mlx5_destroy_flow_table(offloads->ft_offloads_restore);
+}
+
+static int esw_create_restore_table(struct mlx5_eswitch *esw)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_namespace *ns;
+	void *match_criteria, *misc;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *g;
+	u32 *flow_group_in;
+	int err = 0;
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_OFFLOADS);
+	if (!ns) {
+		esw_warn(esw->dev, "Failed to get offloads flow namespace\n");
+		return -EOPNOTSUPP;
+	}
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	ft_attr.max_fte = 1 << ESW_CHAIN_TAG_METADATA_BITS;
+	ft = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		esw_warn(esw->dev, "Failed to create restore table, err %d\n",
+			 err);
+		goto out_free;
+	}
+
+	memset(flow_group_in, 0, inlen);
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
+				      match_criteria);
+	misc = MLX5_ADDR_OF(fte_match_param, match_criteria,
+			    misc_parameters_2);
+
+	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+		 ESW_CHAIN_TAG_METADATA_MASK);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 ft_attr.max_fte - 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_MISC_PARAMETERS_2);
+	g = mlx5_create_flow_group(ft, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(dev, "Failed to create restore flow group, err: %d\n",
+			 err);
+		goto err_group;
+	}
+
+	esw->offloads.ft_offloads_restore = ft;
+	esw->offloads.restore_group = g;
+
+	return 0;
+
+err_group:
+	mlx5_destroy_flow_table(ft);
+out_free:
+	kvfree(flow_group_in);
+
+	return err;
+}
+
 static int esw_offloads_start(struct mlx5_eswitch *esw,
 			      struct netlink_ext_ack *extack)
 {
@@ -1923,13 +2047,17 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		return err;
 
-	err = esw_create_offloads_fdb_tables(esw, total_vports);
+	err = esw_create_offloads_table(esw, total_vports);
 	if (err)
-		goto create_fdb_err;
+		goto create_offloads_err;
 
-	err = esw_create_offloads_table(esw, total_vports);
+	err = esw_create_restore_table(esw);
 	if (err)
-		goto create_ft_err;
+		goto create_restore_err;
+
+	err = esw_create_offloads_fdb_tables(esw, total_vports);
+	if (err)
+		goto create_fdb_err;
 
 	err = esw_create_vport_rx_group(esw, total_vports);
 	if (err)
@@ -1938,12 +2066,12 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	return 0;
 
 create_fg_err:
-	esw_destroy_offloads_table(esw);
-
-create_ft_err:
 	esw_destroy_offloads_fdb_tables(esw);
-
 create_fdb_err:
+	esw_destroy_restore_table(esw);
+create_restore_err:
+	esw_destroy_offloads_table(esw);
+create_offloads_err:
 	esw_destroy_uplink_offloads_acl_tables(esw);
 
 	return err;
@@ -1952,8 +2080,9 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 {
 	esw_destroy_vport_rx_group(esw);
-	esw_destroy_offloads_table(esw);
 	esw_destroy_offloads_fdb_tables(esw);
+	esw_destroy_restore_table(esw);
+	esw_destroy_offloads_table(esw);
 	esw_destroy_uplink_offloads_acl_tables(esw);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9dc2424..2660ffa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -111,8 +111,8 @@
 #define ANCHOR_MIN_LEVEL (BY_PASS_MIN_LEVEL + 1)
 
 #define OFFLOADS_MAX_FT 1
-#define OFFLOADS_NUM_PRIOS 1
-#define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + 1)
+#define OFFLOADS_NUM_PRIOS 2
+#define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)
 
 #define LAG_PRIO_NUM_LEVELS 1
 #define LAG_NUM_PRIOS 1
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index dd1333f..61705e7 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -84,6 +84,8 @@ enum devlink_eswitch_encap_mode
 #define ESW_SOURCE_PORT_METADATA_BITS (ESW_VHCA_ID_BITS + ESW_VPORT_BITS)
 #define ESW_SOURCE_PORT_METADATA_OFFSET (32 - ESW_SOURCE_PORT_METADATA_BITS)
 #define ESW_CHAIN_TAG_METADATA_BITS (32 - ESW_SOURCE_PORT_METADATA_BITS)
+#define ESW_CHAIN_TAG_METADATA_MASK GENMASK(ESW_CHAIN_TAG_METADATA_BITS - 1,\
+					    0)
 
 static inline u32 mlx5_eswitch_get_vport_metadata_mask(void)
 {
-- 
1.8.3.1

