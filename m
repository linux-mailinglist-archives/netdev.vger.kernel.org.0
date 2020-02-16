Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D334160349
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgBPKCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:02:06 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44744 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726824AbgBPKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:47 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce4007834;
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
Subject: [PATCH net-next-mlx5 v3 08/16] net/mlx5: E-Switch, Mark miss packets with new chain id mapping
Date:   Sun, 16 Feb 2020 12:01:28 +0200
Message-Id: <1581847296-19194-9-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if we miss in hardware after jumping to some chain,
we continue in chain 0 in software. This is wrong, and with the new
tc skb extension we can now restore the chain id on the skb, so
tc can continue with in the correct chain.

To restore the chain id in software after a miss in hardware, we create
a register mapping from 32bit chain ids to 16bit of reg_c0 (that
survives loopback), to 32bit chain ids. We then mark packets that
miss on some chain with the current chain id mapping on their reg_c0
field. Using this mapping, we will support up to 64K concurrent
chains.

This register survives loopback and gets to the CQE on flow_tag
via the eswitch restore rules.

In next commit, we will reverse the mapping we got on the CQE
to a chain id and tell tc to continue in the sw chain where we
left off via the tc skb extension.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   8 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  12 ++
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   | 130 ++++++++++++++++++++-
 .../mellanox/mlx5/core/eswitch_offloads_chains.h   |   4 +-
 4 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74091f7..2ee80f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -153,6 +153,14 @@ struct mlx5e_tc_flow_parse_attr {
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(16)
 
+struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
+	[CHAIN_TO_REG] = {
+		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
+		.moffset = 0,
+		.mlen = 2,
+	},
+};
+
 struct mlx5e_hairpin {
 	struct mlx5_hairpin *pair;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 262cdb7..e2dbbae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -91,6 +91,18 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
+enum mlx5e_tc_attr_to_reg {
+	CHAIN_TO_REG,
+};
+
+struct mlx5e_tc_attr_to_reg_mapping {
+	int mfield; /* rewrite field */
+	int moffset; /* offset of mfield */
+	int mlen; /* bytes to rewrite/match */
+};
+
+extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
+
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index c5a446e..b139a97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -6,14 +6,17 @@
 #include <linux/mlx5/fs.h>
 
 #include "eswitch_offloads_chains.h"
+#include "en/mapping.h"
 #include "mlx5_core.h"
 #include "fs_core.h"
 #include "eswitch.h"
 #include "en.h"
+#include "en_tc.h"
 
 #define esw_chains_priv(esw) ((esw)->fdb_table.offloads.esw_chains_priv)
 #define esw_chains_lock(esw) (esw_chains_priv(esw)->lock)
 #define esw_chains_ht(esw) (esw_chains_priv(esw)->chains_ht)
+#define esw_chains_mapping(esw) (esw_chains_priv(esw)->chains_mapping)
 #define esw_prios_ht(esw) (esw_chains_priv(esw)->prios_ht)
 #define fdb_pool_left(esw) (esw_chains_priv(esw)->fdb_left)
 #define tc_slow_fdb(esw) ((esw)->fdb_table.offloads.slow_fdb)
@@ -44,6 +47,7 @@ struct mlx5_esw_chains_priv {
 	struct mutex lock;
 
 	struct mlx5_flow_table *tc_end_fdb;
+	struct mapping_ctx *chains_mapping;
 
 	int fdb_left[ARRAY_SIZE(ESW_POOLS)];
 };
@@ -54,9 +58,12 @@ struct fdb_chain {
 	u32 chain;
 
 	int ref;
+	int id;
 
 	struct mlx5_eswitch *esw;
 	struct list_head prios_list;
+	struct mlx5_flow_handle *restore_rule;
+	struct mlx5_modify_hdr *miss_modify_hdr;
 };
 
 struct fdb_prio_key {
@@ -255,6 +262,70 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	mlx5_destroy_flow_table(fdb);
 }
 
+static int
+create_fdb_chain_restore(struct fdb_chain *fdb_chain)
+{
+	char modact[MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)];
+	struct mlx5_eswitch *esw = fdb_chain->esw;
+	struct mlx5_modify_hdr *mod_hdr;
+	u32 index;
+	int err;
+
+	if (fdb_chain->chain == mlx5_esw_chains_get_ft_chain(esw))
+		return 0;
+
+	err = mapping_add(esw_chains_mapping(esw), &fdb_chain->chain, &index);
+	if (err)
+		return err;
+	if (index == MLX5_FS_DEFAULT_FLOW_TAG) {
+		/* we got the special default flow tag id, so we won't know
+		 * if we actually marked the packet with the restore rule
+		 * we create.
+		 *
+		 * This case isn't possible with MLX5_FS_DEFAULT_FLOW_TAG = 0.
+		 */
+		err = mapping_add(esw_chains_mapping(esw),
+				  &fdb_chain->chain, &index);
+		mapping_remove(esw_chains_mapping(esw),
+			       MLX5_FS_DEFAULT_FLOW_TAG);
+		if (err)
+			return err;
+	}
+
+	fdb_chain->id = index;
+
+	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, modact, field,
+		 mlx5e_tc_attr_to_reg_mappings[CHAIN_TO_REG].mfield);
+	MLX5_SET(set_action_in, modact, offset,
+		 mlx5e_tc_attr_to_reg_mappings[CHAIN_TO_REG].moffset * 8);
+	MLX5_SET(set_action_in, modact, length,
+		 mlx5e_tc_attr_to_reg_mappings[CHAIN_TO_REG].mlen * 8);
+	MLX5_SET(set_action_in, modact, data, fdb_chain->id);
+	mod_hdr = mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_FDB,
+					   1, modact);
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		goto err_mod_hdr;
+	}
+	fdb_chain->miss_modify_hdr = mod_hdr;
+
+	fdb_chain->restore_rule = esw_add_restore_rule(esw, fdb_chain->id);
+	if (IS_ERR(fdb_chain->restore_rule)) {
+		err = PTR_ERR(fdb_chain->restore_rule);
+		goto err_rule;
+	}
+
+	return 0;
+
+err_rule:
+	mlx5_modify_header_dealloc(esw->dev, fdb_chain->miss_modify_hdr);
+err_mod_hdr:
+	/* Datapath can't find this mapping, so we can safely remove it */
+	mapping_remove(esw_chains_mapping(esw), fdb_chain->id);
+	return err;
+}
+
 static struct fdb_chain *
 mlx5_esw_chains_create_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
 {
@@ -269,6 +340,10 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	fdb_chain->chain = chain;
 	INIT_LIST_HEAD(&fdb_chain->prios_list);
 
+	err = create_fdb_chain_restore(fdb_chain);
+	if (err)
+		goto err_restore;
+
 	err = rhashtable_insert_fast(&esw_chains_ht(esw), &fdb_chain->node,
 				     chain_params);
 	if (err)
@@ -277,6 +352,12 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	return fdb_chain;
 
 err_insert:
+	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw)) {
+		mlx5_del_flow_rules(fdb_chain->restore_rule);
+		mlx5_modify_header_dealloc(esw->dev,
+					   fdb_chain->miss_modify_hdr);
+	}
+err_restore:
 	kvfree(fdb_chain);
 	return ERR_PTR(err);
 }
@@ -288,6 +369,15 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 
 	rhashtable_remove_fast(&esw_chains_ht(esw), &fdb_chain->node,
 			       chain_params);
+
+	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw)) {
+		mlx5_del_flow_rules(fdb_chain->restore_rule);
+		mlx5_modify_header_dealloc(esw->dev,
+					   fdb_chain->miss_modify_hdr);
+
+		mapping_remove(esw_chains_mapping(esw), fdb_chain->id);
+	}
+
 	kvfree(fdb_chain);
 }
 
@@ -310,10 +400,12 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 }
 
 static struct mlx5_flow_handle *
-mlx5_esw_chains_add_miss_rule(struct mlx5_flow_table *fdb,
+mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
+			      struct mlx5_flow_table *fdb,
 			      struct mlx5_flow_table *next_fdb)
 {
 	static const struct mlx5_flow_spec spec = {};
+	struct mlx5_eswitch *esw = fdb_chain->esw;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act act = {};
 
@@ -322,6 +414,11 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = next_fdb;
 
+	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw)) {
+		act.modify_hdr = fdb_chain->miss_modify_hdr;
+		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	}
+
 	return mlx5_add_flow_rules(fdb, &spec, &act, &dest, 1);
 }
 
@@ -345,7 +442,8 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	list_for_each_entry_continue_reverse(pos,
 					     &fdb_chain->prios_list,
 					     list) {
-		miss_rules[n] = mlx5_esw_chains_add_miss_rule(pos->fdb,
+		miss_rules[n] = mlx5_esw_chains_add_miss_rule(fdb_chain,
+							      pos->fdb,
 							      next_fdb);
 		if (IS_ERR(miss_rules[n])) {
 			err = PTR_ERR(miss_rules[n]);
@@ -459,7 +557,7 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
 	}
 
 	/* Add miss rule to next_fdb */
-	miss_rule = mlx5_esw_chains_add_miss_rule(fdb, next_fdb);
+	miss_rule = mlx5_esw_chains_add_miss_rule(fdb_chain, fdb, next_fdb);
 	if (IS_ERR(miss_rule)) {
 		err = PTR_ERR(miss_rule);
 		goto err_miss_rule;
@@ -624,6 +722,7 @@ struct mlx5_flow_table *
 	struct mlx5_esw_chains_priv *chains_priv;
 	struct mlx5_core_dev *dev = esw->dev;
 	u32 max_flow_counter, fdb_max;
+	struct mapping_ctx *mapping;
 	int err;
 
 	chains_priv = kzalloc(sizeof(*chains_priv), GFP_KERNEL);
@@ -660,10 +759,20 @@ struct mlx5_flow_table *
 	if (err)
 		goto init_prios_ht_err;
 
+	mapping = mapping_create(sizeof(u32), esw_get_max_restore_tag(esw),
+				 true);
+	if (IS_ERR(mapping)) {
+		err = PTR_ERR(mapping);
+		goto mapping_err;
+	}
+	esw_chains_mapping(esw) = mapping;
+
 	mutex_init(&esw_chains_lock(esw));
 
 	return 0;
 
+mapping_err:
+	rhashtable_destroy(&esw_prios_ht(esw));
 init_prios_ht_err:
 	rhashtable_destroy(&esw_chains_ht(esw));
 init_chains_ht_err:
@@ -675,6 +784,7 @@ struct mlx5_flow_table *
 mlx5_esw_chains_cleanup(struct mlx5_eswitch *esw)
 {
 	mutex_destroy(&esw_chains_lock(esw));
+	mapping_destroy(esw_chains_mapping(esw));
 	rhashtable_destroy(&esw_prios_ht(esw));
 	rhashtable_destroy(&esw_chains_ht(esw));
 
@@ -756,3 +866,17 @@ struct mlx5_flow_table *
 	mlx5_esw_chains_close(esw);
 	mlx5_esw_chains_cleanup(esw);
 }
+
+int mlx5_eswitch_get_chain_for_tag(struct mlx5_eswitch *esw, u32 tag,
+				   u32 *chain)
+{
+	int err;
+
+	err = mapping_find(esw_chains_mapping(esw), tag, chain);
+	if (err) {
+		esw_warn(esw->dev, "Can't find chain for tag: %d\n", tag);
+		return -ENOENT;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
index 2e13097..da45e49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -26,5 +26,7 @@ struct mlx5_flow_table *
 int mlx5_esw_chains_create(struct mlx5_eswitch *esw);
 void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
 
-#endif /* __ML5_ESW_CHAINS_H__ */
+int
+mlx5_eswitch_get_chain_for_tag(struct mlx5_eswitch *esw, u32 tag, u32 *chain);
 
+#endif /* __ML5_ESW_CHAINS_H__ */
-- 
1.8.3.1

