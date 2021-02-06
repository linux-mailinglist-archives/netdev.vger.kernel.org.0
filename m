Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB20311B5D
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhBFFKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231307AbhBFFGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC95B64FDF;
        Sat,  6 Feb 2021 05:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587767;
        bh=yxzGE5v4TrUM0zsuOJ5QbDIX3zb3pUtIjbP2DUUOZ/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlJ+T3tImNsCtHS54F5ggvTcfJFlUztubCmMrksoUhYrhebI+ufzmWkGn2jC/AICw
         5Xsq3Aftk+UUVi8c4wdAROB4qesheVKm+TnmXnojUpOlpVEp2RIPv1nkpFI1Y+HnKm
         1WXdcNST/HZqr2+cUB67VuxQ78aJ4yUzYhTyUbaEhLkWbXkobEdxMwA1uW0S5Du9GX
         xnhkFiKLtamPPRlSVZInSh3z/eogsSa9mMjdc8BEn1Ynslgb/j6EYHooOU+TpqBOmE
         uU6lqZ5J/YeynOENJL90wZ/HGnj0Kwje/Sm0nA0knlS1kNhqrvqCQ7kkn4QsGc+htG
         rKEIjxSdOUIMw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 11/17] net/mlx5e: Match recirculated packet miss in slow table using reg_c1
Date:   Fri,  5 Feb 2021 21:02:34 -0800
Message-Id: <20210206050240.48410-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Previous patch in series that implements stack devices RX path implements
indirect table rules that match on tunnel VNI. After such rule is created
all tunnel traffic is recirculated to root table. However, recirculated
packet might not match on any rules installed in the table (for example,
when IP traffic follows ARP traffic). In that case packets appear on
representor of tunnel endpoint VF instead being redirected to the VF
itself.

Extend slow table with additional flow group that matches on reg_c0 (source
port value set by indirect tables implemented by previous patch in series)
and reg_c1 (special 0xFFF mark). When creating offloads fdb tables, install
one rule per VF vport to match on recirculated miss packets and redirect
them to appropriate VF vport. Modify indirect tables code to also rewrite
reg_c1 with special 0xFFF mark.

Implementation reuses reg_c1 tunnel id bits. This is safe to do because
recirculated packets are always matched before decapsulation.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   3 +-
 .../mellanox/mlx5/core/esw/indir_table.c      |  17 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 119 +++++++++++++++++-
 include/linux/mlx5/eswitch.h                  |  10 +-
 5 files changed, 143 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 90db5a99879d..21568d1fc00f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5515,7 +5515,8 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	}
 	uplink_priv->tunnel_mapping = mapping;
 
-	mapping = mapping_create(sz_enc_opts, ENC_OPTS_BITS_MASK, true);
+	/* 0xFFF is reserved for stack devices slow path table mark */
+	mapping = mapping_create(sz_enc_opts, ENC_OPTS_BITS_MASK - 1, true);
 	if (IS_ERR(mapping)) {
 		err = PTR_ERR(mapping);
 		goto err_enc_opts_mapping;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index a0ebf40c9907..b7d00c4c7046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -162,7 +162,7 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 			 (attr->ip_version == 4 ? ETH_P_IP : ETH_P_IPV6));
 	} else {
 		err = -EOPNOTSUPP;
-		goto err_mod_hdr;
+		goto err_ethertype;
 	}
 
 	if (attr->ip_version == 4) {
@@ -198,13 +198,18 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
 					VPORT_TO_REG, data);
 	if (err)
-		goto err_mod_hdr;
+		goto err_mod_hdr_regc0;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
+					TUNNEL_TO_REG, ESW_TUN_SLOW_TABLE_GOTO_VPORT);
+	if (err)
+		goto err_mod_hdr_regc1;
 
 	flow_act.modify_hdr = mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_FDB,
 						       mod_acts.num_actions, mod_acts.actions);
 	if (IS_ERR(flow_act.modify_hdr)) {
 		err = PTR_ERR(flow_act.modify_hdr);
-		goto err_mod_hdr;
+		goto err_mod_hdr_alloc;
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
@@ -236,7 +241,11 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 	mlx5_chains_put_table(chains, 0, 1, 0);
 err_table:
 	mlx5_modify_header_dealloc(esw->dev, flow_act.modify_hdr);
-err_mod_hdr:
+err_mod_hdr_alloc:
+err_mod_hdr_regc1:
+	dealloc_mod_hdr_actions(&mod_acts);
+err_mod_hdr_regc0:
+err_ethertype:
 	kfree(rule);
 out:
 	kfree(rule_spec);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c2361c5b824c..34a21ff95472 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -179,9 +179,11 @@ struct mlx5_eswitch_fdb {
 			struct mlx5_flow_namespace *ns;
 			struct mlx5_flow_table *slow_fdb;
 			struct mlx5_flow_group *send_to_vport_grp;
+			struct mlx5_flow_group *send_to_vport_meta_grp;
 			struct mlx5_flow_group *peer_miss_grp;
 			struct mlx5_flow_handle **peer_miss_rules;
 			struct mlx5_flow_group *miss_grp;
+			struct mlx5_flow_handle **send_to_vport_meta_rules;
 			struct mlx5_flow_handle *miss_rule_uni;
 			struct mlx5_flow_handle *miss_rule_multi;
 			int vlan_push_pop_refcount;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a44728595420..94cb0217b4f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1080,6 +1080,81 @@ void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule)
 	mlx5_del_flow_rules(rule);
 }
 
+static void mlx5_eswitch_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
+{
+	struct mlx5_flow_handle **flows = esw->fdb_table.offloads.send_to_vport_meta_rules;
+	int i = 0, num_vfs = esw->esw_funcs.num_vfs, vport_num;
+
+	if (!num_vfs || !flows)
+		return;
+
+	mlx5_esw_for_each_vf_vport_num(esw, vport_num, num_vfs)
+		mlx5_del_flow_rules(flows[i++]);
+
+	kvfree(flows);
+}
+
+static int
+mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
+{
+	int num_vfs, vport_num, rule_idx = 0, err = 0;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {0};
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5_flow_handle **flows;
+	struct mlx5_flow_spec *spec;
+
+	num_vfs = esw->esw_funcs.num_vfs;
+	flows = kvzalloc(num_vfs * sizeof(*flows), GFP_KERNEL);
+	if (!flows)
+		return -ENOMEM;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		err = -ENOMEM;
+		goto alloc_err;
+	}
+
+	MLX5_SET(fte_match_param, spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
+	MLX5_SET(fte_match_param, spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_1,
+		 ESW_TUN_SLOW_TABLE_GOTO_VPORT_MARK);
+
+	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
+	mlx5_esw_for_each_vf_vport_num(esw, vport_num, num_vfs) {
+		MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
+		dest.vport.num = vport_num;
+
+		flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+						spec, &flow_act, &dest, 1);
+		if (IS_ERR(flow_rule)) {
+			err = PTR_ERR(flow_rule);
+			esw_warn(esw->dev, "FDB: Failed to add send to vport meta rule idx %d, err %ld\n",
+				 rule_idx, PTR_ERR(flow_rule));
+			goto rule_err;
+		}
+		flows[rule_idx++] = flow_rule;
+	}
+
+	esw->fdb_table.offloads.send_to_vport_meta_rules = flows;
+	kvfree(spec);
+	return 0;
+
+rule_err:
+	while (--rule_idx >= 0)
+		mlx5_del_flow_rules(flows[rule_idx]);
+	kvfree(spec);
+alloc_err:
+	kvfree(flows);
+	return err;
+}
+
 static bool mlx5_eswitch_reg_c1_loopback_supported(struct mlx5_eswitch *esw)
 {
 	return MLX5_CAP_ESW_FLOWTABLE(esw->dev, fdb_to_vport_reg_c_id) &
@@ -1562,11 +1637,11 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {};
+	int num_vfs, table_size, ix, err = 0;
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *fdb = NULL;
 	u32 flags = 0, *flow_group_in;
-	int table_size, ix, err = 0;
 	struct mlx5_flow_group *g;
 	void *match_criteria;
 	u8 *dmac;
@@ -1592,7 +1667,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	}
 
 	table_size = esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ +
-		MLX5_ESW_MISS_FLOWS + esw->total_vports;
+		MLX5_ESW_MISS_FLOWS + esw->total_vports + esw->esw_funcs.num_vfs;
 
 	/* create the slow path fdb with encap set, so further table instances
 	 * can be created at run time while VFs are probed if the FW allows that.
@@ -1640,6 +1715,38 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	}
 	esw->fdb_table.offloads.send_to_vport_grp = g;
 
+	/* meta send to vport */
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_MISC_PARAMETERS_2);
+
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
+
+	MLX5_SET(fte_match_param, match_criteria,
+		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
+	MLX5_SET(fte_match_param, match_criteria,
+		 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
+
+	num_vfs = esw->esw_funcs.num_vfs;
+	if (num_vfs) {
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ix + num_vfs - 1);
+		ix += num_vfs;
+
+		g = mlx5_create_flow_group(fdb, flow_group_in);
+		if (IS_ERR(g)) {
+			err = PTR_ERR(g);
+			esw_warn(dev, "Failed to create send-to-vport meta flow group err(%d)\n",
+				 err);
+			goto send_vport_meta_err;
+		}
+		esw->fdb_table.offloads.send_to_vport_meta_grp = g;
+
+		err = mlx5_eswitch_add_send_to_vport_meta_rules(esw);
+		if (err)
+			goto meta_rule_err;
+	}
+
 	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
 		/* create peer esw miss group */
 		memset(flow_group_in, 0, inlen);
@@ -1707,6 +1814,11 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 peer_miss_err:
+	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
+meta_rule_err:
+	if (esw->fdb_table.offloads.send_to_vport_meta_grp)
+		mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
+send_vport_meta_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
 send_vport_err:
 	esw_chains_destroy(esw, esw_chains(esw));
@@ -1728,7 +1840,10 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	esw_debug(esw->dev, "Destroy offloads FDB Tables\n");
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_multi);
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_uni);
+	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
+	if (esw->fdb_table.offloads.send_to_vport_meta_grp)
+		mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
 	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 3b20e84049c1..994c2c8cb4fd 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -114,8 +114,16 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 #define ESW_ZONE_ID_BITS 8
 #define ESW_TUN_OPTS_BITS 12
 #define ESW_TUN_ID_BITS 12
-#define ESW_TUN_OFFSET ESW_ZONE_ID_BITS
+#define ESW_TUN_OPTS_OFFSET ESW_ZONE_ID_BITS
+#define ESW_TUN_OFFSET ESW_TUN_OPTS_OFFSET
 #define ESW_ZONE_ID_MASK GENMASK(ESW_ZONE_ID_BITS - 1, 0)
+#define ESW_TUN_OPTS_MASK GENMASK(32 - ESW_TUN_ID_BITS - 1, ESW_TUN_OPTS_OFFSET)
+#define ESW_TUN_MASK GENMASK(31, ESW_TUN_OFFSET)
+#define ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT 0 /* 0 is not a valid tunnel id */
+#define ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT 0xFFF /* 0xFFF is a reserved mapping */
+#define ESW_TUN_SLOW_TABLE_GOTO_VPORT ((ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT << ESW_TUN_OPTS_BITS) | \
+				       ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT)
+#define ESW_TUN_SLOW_TABLE_GOTO_VPORT_MARK ESW_TUN_OPTS_MASK
 
 u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
 #else  /* CONFIG_MLX5_ESWITCH */
-- 
2.29.2

