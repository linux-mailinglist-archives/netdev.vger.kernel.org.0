Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8644275163
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIWGYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgIWGYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:48 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD4223731;
        Wed, 23 Sep 2020 06:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842284;
        bh=4pz+Hewe38DjPQX6pdzcZ6AE2qmBo7oOg2puUq1m4p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0V7N7Wtxg6ByA/3niG/c1myD8PQJBYr8VLmRlNa14IWb1JMnlcNQjgKV8j0m9xZ4
         tw6vv0oiTxaMk6N6DgK2501zqC4eJMac/ri28wBu5DIKxKG6/ydPdCZgAQe1T8RGQ0
         D5dfwD58ii+j0rx/0uDmAfmmhHAEX6Tdep1C09DA=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Support CT offload for tc nic flows
Date:   Tue, 22 Sep 2020 23:24:31 -0700
Message-Id: <20200923062438.15997-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Adding support to perform CT related tc actions and
matching on CT states for nic flows.

The ct flows management and handling will be done using a new
instance of the ct database that is declared in this patch to
keep it separate from the eswitch ct flows database.
Offloading and unoffloading ct flows will be done using the
existing ct offload api by providing it the relevant ct
database reference in each mode.

In addition, refactoring the tc ct api is introduced to make it
agnostic to the flow type and perform the resource allocations
and rule insertion to the proper steering domain in the device.

In the initialization call, the api requests and stores in the ct
database instance all the relevant information that distinguishes
between nic flows and esw flows, such as chains database, steering
namespace and mod hdr table.
This way the operations of adding and removing ct flows to the device
can later performed agnostically to the flow type.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   2 +
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 289 +++++++++---------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  54 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 171 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  26 ++
 6 files changed, 348 insertions(+), 200 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index ef3c9a165b1d..6a97452dc60e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -27,6 +27,8 @@ struct mlx5e_tc_table {
 
 	struct notifier_block     netdevice_nb;
 	struct netdev_net_notifier	netdevice_nn;
+
+	struct mlx5_tc_ct_priv         *ct;
 };
 
 struct mlx5e_flow_table {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 771e73f211fb..e36e505d38ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -612,7 +612,6 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
-	int tunnel_moffset;
 	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
@@ -647,13 +646,12 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb,
+		if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
 					      zone_restore_id))
 			return false;
 	}
 
-	tunnel_moffset = mlx5e_tc_attr_to_reg_mappings[TUNNEL_TO_REG].moffset;
-	tunnel_id = reg_c1 >> (8 * tunnel_moffset);
+	tunnel_id = reg_c1 >> REG_MAPPING_SHIFT(TUNNEL_TO_REG);
 	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index bc7589711357..86afef459dc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -41,6 +41,7 @@
 struct mlx5_tc_ct_priv {
 	struct mlx5_eswitch *esw;
 	const struct net_device *netdev;
+	struct mod_hdr_tbl *mod_hdr_tbl;
 	struct idr fte_ids;
 	struct xarray tuple_ids;
 	struct rhashtable zone_ht;
@@ -52,6 +53,8 @@ struct mlx5_tc_ct_priv {
 	struct mutex control_lock; /* guards parallel adds/dels */
 	struct mapping_ctx *zone_mapping;
 	struct mapping_ctx *labels_mapping;
+	enum mlx5_flow_namespace_type ns_type;
+	struct mlx5_fs_chains *chains;
 };
 
 struct mlx5_ct_flow {
@@ -72,7 +75,7 @@ struct mlx5_ct_zone_rule {
 };
 
 struct mlx5_tc_ct_pre {
-	struct mlx5_flow_table *fdb;
+	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *flow_grp;
 	struct mlx5_flow_group *miss_grp;
 	struct mlx5_flow_handle *flow_rule;
@@ -157,18 +160,6 @@ static const struct rhashtable_params tuples_nat_ht_params = {
 	.min_size = 16 * 1024,
 };
 
-static struct mlx5_tc_ct_priv *
-mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-	return uplink_priv->ct_priv;
-}
-
 static int
 mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *rule)
 {
@@ -401,13 +392,12 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 {
 	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
 	struct mlx5_flow_attr *attr = zone_rule->attr;
-	struct mlx5_eswitch *esw = ct_priv->esw;
 
 	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
 
-	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
+	mlx5_tc_rule_delete(netdev_priv(ct_priv->netdev), zone_rule->rule, attr);
 	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
-			     &esw->offloads.mod_hdr, zone_rule->mh);
+			     ct_priv->mod_hdr_tbl, zone_rule->mh);
 	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 	kfree(attr);
 }
@@ -445,29 +435,40 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 			       u32 labels_id,
 			       u8 zone_restore_id)
 {
+	enum mlx5_flow_namespace_type ns = ct_priv->ns_type;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
 					CTSTATE_TO_REG, ct_state);
 	if (err)
 		return err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
 					MARK_TO_REG, mark);
 	if (err)
 		return err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
 					LABELS_TO_REG, labels_id);
 	if (err)
 		return err;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
 					ZONE_RESTORE_TO_REG, zone_restore_id);
 	if (err)
 		return err;
 
+	/* Make another copy of zone id in reg_b for
+	 * NIC rx flows since we don't copy reg_c1 to
+	 * reg_b upon miss.
+	 */
+	if (ns != MLX5_FLOW_NAMESPACE_FDB) {
+		err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts, ns,
+						NIC_ZONE_RESTORE_TO_REG, zone_restore_id);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -559,8 +560,7 @@ mlx5_tc_ct_entry_create_nat(struct mlx5_tc_ct_priv *ct_priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_MANGLE: {
-			err = alloc_mod_hdr_actions(mdev,
-						    MLX5_FLOW_NAMESPACE_FDB,
+			err = alloc_mod_hdr_actions(mdev, ct_priv->ns_type,
 						    mod_acts);
 			if (err)
 				return err;
@@ -626,8 +626,8 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 		goto err_mapping;
 
 	*mh = mlx5e_mod_hdr_attach(ct_priv->esw->dev,
-				   &ct_priv->esw->offloads.mod_hdr,
-				   MLX5_FLOW_NAMESPACE_FDB,
+				   ct_priv->mod_hdr_tbl,
+				   ct_priv->ns_type,
 				   &mod_acts);
 	if (IS_ERR(*mh)) {
 		err = PTR_ERR(*mh);
@@ -651,7 +651,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 			  bool nat, u8 zone_restore_id)
 {
 	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
-	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
 	struct mlx5_flow_spec *spec = NULL;
 	struct mlx5_flow_attr *attr;
 	int err;
@@ -662,7 +662,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	if (!spec)
 		return -ENOMEM;
 
-	attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
 	if (!attr) {
 		err = -ENOMEM;
 		goto err_attr;
@@ -691,7 +691,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 				    entry->tuple.zone & MLX5_CT_ZONE_MASK,
 				    MLX5_CT_ZONE_MASK);
 
-	zone_rule->rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+	zone_rule->rule = mlx5_tc_rule_insert(priv, spec, attr);
 	if (IS_ERR(zone_rule->rule)) {
 		err = PTR_ERR(zone_rule->rule);
 		ct_dbg("Failed to add ct entry rule, nat: %d", nat);
@@ -707,7 +707,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 err_rule:
 	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
-			     &esw->offloads.mod_hdr, zone_rule->mh);
+			     ct_priv->mod_hdr_tbl, zone_rule->mh);
 	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(attr);
@@ -970,24 +970,21 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 	return 0;
 }
 
-void mlx5_tc_ct_match_del(struct mlx5e_priv *priv, struct mlx5_ct_attr *ct_attr)
+void mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_attr)
 {
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
-
-	if (!ct_priv || !ct_attr->ct_labels_id)
+	if (!priv || !ct_attr->ct_labels_id)
 		return;
 
-	mapping_remove(ct_priv->labels_mapping, ct_attr->ct_labels_id);
+	mapping_remove(priv->labels_mapping, ct_attr->ct_labels_id);
 }
 
 int
-mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
+mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		     struct mlx5_flow_spec *spec,
 		     struct flow_cls_offload *f,
 		     struct mlx5_ct_attr *ct_attr,
 		     struct netlink_ext_ack *extack)
 {
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector_key_ct *mask, *key;
 	bool trk, est, untrk, unest, new;
@@ -1000,7 +997,7 @@ mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
 	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CT))
 		return 0;
 
-	if (!ct_priv) {
+	if (!priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "offload of ct matching isn't available");
 		return -EOPNOTSUPP;
@@ -1056,7 +1053,7 @@ mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
 		ct_labels[1] = key->ct_labels[1] & mask->ct_labels[1];
 		ct_labels[2] = key->ct_labels[2] & mask->ct_labels[2];
 		ct_labels[3] = key->ct_labels[3] & mask->ct_labels[3];
-		if (mapping_add(ct_priv->labels_mapping, ct_labels, &ct_attr->ct_labels_id))
+		if (mapping_add(priv->labels_mapping, ct_labels, &ct_attr->ct_labels_id))
 			return -EOPNOTSUPP;
 		mlx5e_tc_match_to_reg_match(spec, LABELS_TO_REG, ct_attr->ct_labels_id,
 					    MLX5_CT_LABELS_MASK);
@@ -1066,14 +1063,12 @@ mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
 }
 
 int
-mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
+mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
-
-	if (!ct_priv) {
+	if (!priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "offload of ct action isn't available");
 		return -EOPNOTSUPP;
@@ -1093,7 +1088,7 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
 	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
 	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
 	struct mlx5_core_dev *dev = ct_priv->esw->dev;
-	struct mlx5_flow_table *fdb = pre_ct->fdb;
+	struct mlx5_flow_table *ft = pre_ct->ft;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_modify_hdr *mod_hdr;
@@ -1108,14 +1103,14 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
 		return -ENOMEM;
 
 	zone = ct_ft->zone & MLX5_CT_ZONE_MASK;
-	err = mlx5e_tc_match_to_reg_set(dev, &pre_mod_acts, ZONE_TO_REG, zone);
+	err = mlx5e_tc_match_to_reg_set(dev, &pre_mod_acts, ct_priv->ns_type,
+					ZONE_TO_REG, zone);
 	if (err) {
 		ct_dbg("Failed to set zone register mapping");
 		goto err_mapping;
 	}
 
-	mod_hdr = mlx5_modify_header_alloc(dev,
-					   MLX5_FLOW_NAMESPACE_FDB,
+	mod_hdr = mlx5_modify_header_alloc(dev, ct_priv->ns_type,
 					   pre_mod_acts.num_actions,
 					   pre_mod_acts.actions);
 
@@ -1141,7 +1136,7 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
 	mlx5e_tc_match_to_reg_match(spec, CTSTATE_TO_REG, ctstate, ctstate);
 
 	dest.ft = ct_priv->post_ct;
-	rule = mlx5_add_flow_rules(fdb, spec, &flow_act, &dest, 1);
+	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		ct_dbg("Failed to add pre ct flow rule zone %d", zone);
@@ -1152,7 +1147,7 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
 	/* add miss rule */
 	memset(spec, 0, sizeof(*spec));
 	dest.ft = nat ? ct_priv->ct_nat : ct_priv->ct;
-	rule = mlx5_add_flow_rules(fdb, spec, &flow_act, &dest, 1);
+	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		ct_dbg("Failed to add pre ct miss rule zone %d", zone);
@@ -1203,10 +1198,10 @@ mlx5_tc_ct_alloc_pre_ct(struct mlx5_ct_ft *ct_ft,
 	void *misc;
 	int err;
 
-	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
+	ns = mlx5_get_flow_namespace(dev, ct_priv->ns_type);
 	if (!ns) {
 		err = -EOPNOTSUPP;
-		ct_dbg("Failed to get FDB flow namespace");
+		ct_dbg("Failed to get flow namespace");
 		return err;
 	}
 
@@ -1215,7 +1210,8 @@ mlx5_tc_ct_alloc_pre_ct(struct mlx5_ct_ft *ct_ft,
 		return -ENOMEM;
 
 	ft_attr.flags = MLX5_FLOW_TABLE_UNMANAGED;
-	ft_attr.prio = FDB_TC_OFFLOAD;
+	ft_attr.prio =  ct_priv->ns_type ==  MLX5_FLOW_NAMESPACE_FDB ?
+			FDB_TC_OFFLOAD : MLX5E_TC_PRIO;
 	ft_attr.max_fte = 2;
 	ft_attr.level = 1;
 	ft = mlx5_create_flow_table(ns, &ft_attr);
@@ -1224,7 +1220,7 @@ mlx5_tc_ct_alloc_pre_ct(struct mlx5_ct_ft *ct_ft,
 		ct_dbg("Failed to create pre ct table");
 		goto out_free;
 	}
-	pre_ct->fdb = ft;
+	pre_ct->ft = ft;
 
 	/* create flow group */
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
@@ -1288,7 +1284,7 @@ mlx5_tc_ct_free_pre_ct(struct mlx5_ct_ft *ct_ft,
 	tc_ct_pre_ct_del_rules(ct_ft, pre_ct);
 	mlx5_destroy_flow_group(pre_ct->miss_grp);
 	mlx5_destroy_flow_group(pre_ct->flow_grp);
-	mlx5_destroy_flow_table(pre_ct->fdb);
+	mlx5_destroy_flow_table(pre_ct->ft);
 }
 
 static int
@@ -1407,7 +1403,7 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 /* We translate the tc filter with CT action to the following HW model:
  *
  * +---------------------+
- * + fdb prio (tc chain) +
+ * + ft prio (tc chain) +
  * + original match      +
  * +---------------------+
  *      | set chain miss mapping
@@ -1437,16 +1433,16 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  * +--------------+
  */
 static struct mlx5_flow_handle *
-__mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+__mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 			  struct mlx5e_tc_flow *flow,
 			  struct mlx5_flow_spec *orig_spec,
 			  struct mlx5_flow_attr *attr)
 {
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	bool nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
+	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
 	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
+	u32 attr_sz = ns_to_attr_sz(ct_priv->ns_type);
 	struct mlx5_flow_spec *post_ct_spec = NULL;
-	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_flow_handle *rule;
@@ -1483,21 +1479,21 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	ct_flow->fte_id = fte_id;
 
 	/* Base flow attributes of both rules on original rule attribute */
-	ct_flow->pre_ct_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	ct_flow->pre_ct_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
 	if (!ct_flow->pre_ct_attr) {
 		err = -ENOMEM;
 		goto err_alloc_pre;
 	}
 
-	ct_flow->post_ct_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	ct_flow->post_ct_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
 	if (!ct_flow->post_ct_attr) {
 		err = -ENOMEM;
 		goto err_alloc_post;
 	}
 
 	pre_ct_attr = ct_flow->pre_ct_attr;
-	memcpy(pre_ct_attr, attr, ESW_FLOW_ATTR_SZ);
-	memcpy(ct_flow->post_ct_attr, attr, ESW_FLOW_ATTR_SZ);
+	memcpy(pre_ct_attr, attr, attr_sz);
+	memcpy(ct_flow->post_ct_attr, attr, attr_sz);
 
 	/* Modify the original rule's action to fwd and modify, leave decap */
 	pre_ct_attr->action = attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP;
@@ -1508,7 +1504,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	 * don't go though all prios of this chain as normal tc rules
 	 * miss.
 	 */
-	err = mlx5_chains_get_chain_mapping(esw_chains(esw), attr->chain,
+	err = mlx5_chains_get_chain_mapping(ct_priv->chains, attr->chain,
 					    &chain_mapping);
 	if (err) {
 		ct_dbg("Failed to get chain register mapping for chain");
@@ -1516,14 +1512,14 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	}
 	ct_flow->chain_mapping = chain_mapping;
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
+	err = mlx5e_tc_match_to_reg_set(priv->mdev, &pre_mod_acts, ct_priv->ns_type,
 					CHAIN_TO_REG, chain_mapping);
 	if (err) {
 		ct_dbg("Failed to set chain register mapping");
 		goto err_mapping;
 	}
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
+	err = mlx5e_tc_match_to_reg_set(priv->mdev, &pre_mod_acts, ct_priv->ns_type,
 					FTEID_TO_REG, fte_id);
 	if (err) {
 		ct_dbg("Failed to set fte_id register mapping");
@@ -1537,7 +1533,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	    attr->chain == 0) {
 		u32 tun_id = mlx5e_tc_get_flow_tun_id(flow);
 
-		err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
+		err = mlx5e_tc_match_to_reg_set(priv->mdev, &pre_mod_acts,
+						ct_priv->ns_type,
 						TUNNEL_TO_REG,
 						tun_id);
 		if (err) {
@@ -1546,8 +1543,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 		}
 	}
 
-	mod_hdr = mlx5_modify_header_alloc(esw->dev,
-					   MLX5_FLOW_NAMESPACE_FDB,
+	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
 					   pre_mod_acts.num_actions,
 					   pre_mod_acts.actions);
 	if (IS_ERR(mod_hdr)) {
@@ -1563,7 +1559,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	mlx5e_tc_match_to_reg_match(post_ct_spec, FTEID_TO_REG,
 				    fte_id, MLX5_FTE_ID_MASK);
 
-	/* Put post_ct rule on post_ct fdb */
+	/* Put post_ct rule on post_ct flow table */
 	ct_flow->post_ct_attr->chain = 0;
 	ct_flow->post_ct_attr->prio = 0;
 	ct_flow->post_ct_attr->ft = ct_priv->post_ct;
@@ -1571,8 +1567,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	ct_flow->post_ct_attr->inner_match_level = MLX5_MATCH_NONE;
 	ct_flow->post_ct_attr->outer_match_level = MLX5_MATCH_NONE;
 	ct_flow->post_ct_attr->action &= ~(MLX5_FLOW_CONTEXT_ACTION_DECAP);
-	rule = mlx5_eswitch_add_offloaded_rule(esw, post_ct_spec,
-					       ct_flow->post_ct_attr);
+	rule = mlx5_tc_rule_insert(priv, post_ct_spec,
+				   ct_flow->post_ct_attr);
 	ct_flow->post_ct_rule = rule;
 	if (IS_ERR(ct_flow->post_ct_rule)) {
 		err = PTR_ERR(ct_flow->post_ct_rule);
@@ -1582,10 +1578,9 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 
 	/* Change original rule point to ct table */
 	pre_ct_attr->dest_chain = 0;
-	pre_ct_attr->dest_ft = nat ? ft->pre_ct_nat.fdb : ft->pre_ct.fdb;
-	ct_flow->pre_ct_rule = mlx5_eswitch_add_offloaded_rule(esw,
-							       orig_spec,
-							       pre_ct_attr);
+	pre_ct_attr->dest_ft = nat ? ft->pre_ct_nat.ft : ft->pre_ct.ft;
+	ct_flow->pre_ct_rule = mlx5_tc_rule_insert(priv, orig_spec,
+						   pre_ct_attr);
 	if (IS_ERR(ct_flow->pre_ct_rule)) {
 		err = PTR_ERR(ct_flow->pre_ct_rule);
 		ct_dbg("Failed to add pre ct rule");
@@ -1599,13 +1594,13 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	return rule;
 
 err_insert_orig:
-	mlx5_eswitch_del_offloaded_rule(ct_priv->esw, ct_flow->post_ct_rule,
-					ct_flow->post_ct_attr);
+	mlx5_tc_rule_delete(priv, ct_flow->post_ct_rule,
+			    ct_flow->post_ct_attr);
 err_insert_post_ct:
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 err_mapping:
 	dealloc_mod_hdr_actions(&pre_mod_acts);
-	mlx5_chains_put_chain_mapping(esw_chains(esw), ct_flow->chain_mapping);
+	mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
 err_get_chain:
 	kfree(ct_flow->post_ct_attr);
 err_alloc_post:
@@ -1622,13 +1617,13 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 }
 
 static struct mlx5_flow_handle *
-__mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
+__mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_flow_spec *orig_spec,
 				struct mlx5_flow_attr *attr,
 				struct mlx5e_tc_mod_hdr_acts *mod_acts)
 {
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
-	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
+	u32 attr_sz = ns_to_attr_sz(ct_priv->ns_type);
 	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_flow_handle *rule;
@@ -1640,13 +1635,13 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 		return ERR_PTR(-ENOMEM);
 
 	/* Base esw attributes on original rule attribute */
-	pre_ct_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	pre_ct_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
 	if (!pre_ct_attr) {
 		err = -ENOMEM;
 		goto err_attr;
 	}
 
-	memcpy(pre_ct_attr, attr, ESW_FLOW_ATTR_SZ);
+	memcpy(pre_ct_attr, attr, attr_sz);
 
 	err = mlx5_tc_ct_entry_set_registers(ct_priv, mod_acts, 0, 0, 0, 0);
 	if (err) {
@@ -1654,8 +1649,7 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 		goto err_set_registers;
 	}
 
-	mod_hdr = mlx5_modify_header_alloc(esw->dev,
-					   MLX5_FLOW_NAMESPACE_FDB,
+	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
 					   mod_acts->num_actions,
 					   mod_acts->actions);
 	if (IS_ERR(mod_hdr)) {
@@ -1668,7 +1662,7 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 	pre_ct_attr->modify_hdr = mod_hdr;
 	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
-	rule = mlx5_eswitch_add_offloaded_rule(esw, orig_spec, pre_ct_attr);
+	rule = mlx5_tc_rule_insert(priv, orig_spec, pre_ct_attr);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		ct_dbg("Failed to add ct clear rule");
@@ -1693,45 +1687,45 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 }
 
 struct mlx5_flow_handle *
-mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
 	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct mlx5_flow_handle *rule;
 
-	if (!ct_priv)
+	if (!priv)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	mutex_lock(&ct_priv->control_lock);
+	mutex_lock(&priv->control_lock);
 
 	if (clear_action)
 		rule = __mlx5_tc_ct_flow_offload_clear(priv, spec, attr, mod_hdr_acts);
 	else
 		rule = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr);
-	mutex_unlock(&ct_priv->control_lock);
+	mutex_unlock(&priv->control_lock);
 
 	return rule;
 }
 
 static void
 __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
+			 struct mlx5e_tc_flow *flow,
 			 struct mlx5_ct_flow *ct_flow)
 {
 	struct mlx5_flow_attr *pre_ct_attr = ct_flow->pre_ct_attr;
-	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
 
-	mlx5_eswitch_del_offloaded_rule(esw, ct_flow->pre_ct_rule,
-					pre_ct_attr);
-	mlx5_modify_header_dealloc(esw->dev, pre_ct_attr->modify_hdr);
+	mlx5_tc_rule_delete(priv, ct_flow->pre_ct_rule,
+			    pre_ct_attr);
+	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 
 	if (ct_flow->post_ct_rule) {
-		mlx5_eswitch_del_offloaded_rule(esw, ct_flow->post_ct_rule,
-						ct_flow->post_ct_attr);
-		mlx5_chains_put_chain_mapping(esw_chains(esw), ct_flow->chain_mapping);
+		mlx5_tc_rule_delete(priv, ct_flow->post_ct_rule,
+				    ct_flow->post_ct_attr);
+		mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
 		idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
 		mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 	}
@@ -1742,10 +1736,10 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 }
 
 void
-mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow,
+mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
+		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_flow_attr *attr)
 {
-	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct mlx5_ct_flow *ct_flow = attr->ct_attr.ct_flow;
 
 	/* We are called on error to clean up stuff from parsing
@@ -1754,22 +1748,15 @@ mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow,
 	if (!ct_flow)
 		return;
 
-	mutex_lock(&ct_priv->control_lock);
-	__mlx5_tc_ct_delete_flow(ct_priv, ct_flow);
-	mutex_unlock(&ct_priv->control_lock);
+	mutex_lock(&priv->control_lock);
+	__mlx5_tc_ct_delete_flow(priv, flow, ct_flow);
+	mutex_unlock(&priv->control_lock);
 }
 
 static int
-mlx5_tc_ct_init_check_support(struct mlx5_eswitch *esw,
-			      const char **err_msg)
+mlx5_tc_ct_init_check_esw_support(struct mlx5_eswitch *esw,
+				  const char **err_msg)
 {
-#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	/* cannot restore chain ID on HW miss */
-
-	*err_msg = "tc skb extension missing";
-	return -EOPNOTSUPP;
-#endif
-
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level)) {
 		*err_msg = "firmware level support is missing";
 		return -EOPNOTSUPP;
@@ -1803,25 +1790,51 @@ mlx5_tc_ct_init_check_support(struct mlx5_eswitch *esw,
 	return 0;
 }
 
+static int
+mlx5_tc_ct_init_check_nic_support(struct mlx5e_priv *priv,
+				  const char **err_msg)
+{
+	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
+		*err_msg = "firmware level support is missing";
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
+			      enum mlx5_flow_namespace_type ns_type,
+			      const char **err_msg)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	/* cannot restore chain ID on HW miss */
+
+	*err_msg = "tc skb extension missing";
+	return -EOPNOTSUPP;
+#endif
+	if (ns_type == MLX5_FLOW_NAMESPACE_FDB)
+		return mlx5_tc_ct_init_check_esw_support(esw, err_msg);
+	else
+		return mlx5_tc_ct_init_check_nic_support(priv, err_msg);
+}
+
 #define INIT_ERR_PREFIX "tc ct offload init failed"
 
-int
-mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
+struct mlx5_tc_ct_priv *
+mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
+		struct mod_hdr_tbl *mod_hdr,
+		enum mlx5_flow_namespace_type ns_type)
 {
 	struct mlx5_tc_ct_priv *ct_priv;
-	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_core_dev *dev;
-	struct mlx5_eswitch *esw;
-	struct mlx5e_priv *priv;
 	const char *msg;
 	int err;
 
-	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
-	priv = netdev_priv(rpriv->netdev);
 	dev = priv->mdev;
-	esw = dev->priv.eswitch;
-
-	err = mlx5_tc_ct_init_check_support(esw, &msg);
+	err = mlx5_tc_ct_init_check_support(priv, ns_type, &msg);
 	if (err) {
 		mlx5_core_warn(dev,
 			       "tc ct offload not supported, %s\n",
@@ -1845,9 +1858,12 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_mapping_labels;
 	}
 
-	ct_priv->esw = esw;
-	ct_priv->netdev = rpriv->netdev;
-	ct_priv->ct = mlx5_chains_create_global_table(esw_chains(esw));
+	ct_priv->ns_type = ns_type;
+	ct_priv->chains = chains;
+	ct_priv->esw = priv->mdev->priv.eswitch;
+	ct_priv->netdev = priv->netdev;
+	ct_priv->mod_hdr_tbl = mod_hdr;
+	ct_priv->ct = mlx5_chains_create_global_table(chains);
 	if (IS_ERR(ct_priv->ct)) {
 		err = PTR_ERR(ct_priv->ct);
 		mlx5_core_warn(dev,
@@ -1856,7 +1872,7 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_ct_tbl;
 	}
 
-	ct_priv->ct_nat = mlx5_chains_create_global_table(esw_chains(esw));
+	ct_priv->ct_nat = mlx5_chains_create_global_table(chains);
 	if (IS_ERR(ct_priv->ct_nat)) {
 		err = PTR_ERR(ct_priv->ct_nat);
 		mlx5_core_warn(dev,
@@ -1865,7 +1881,7 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_ct_nat_tbl;
 	}
 
-	ct_priv->post_ct = mlx5_chains_create_global_table(esw_chains(esw));
+	ct_priv->post_ct = mlx5_chains_create_global_table(chains);
 	if (IS_ERR(ct_priv->post_ct)) {
 		err = PTR_ERR(ct_priv->post_ct);
 		mlx5_core_warn(dev,
@@ -1880,15 +1896,12 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
 	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
 
-	/* Done, set ct_priv to know it initializted */
-	uplink_priv->ct_priv = ct_priv;
-
-	return 0;
+	return ct_priv;
 
 err_post_ct_tbl:
-	mlx5_chains_destroy_global_table(esw_chains(esw), ct_priv->ct_nat);
+	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
 err_ct_nat_tbl:
-	mlx5_chains_destroy_global_table(esw_chains(esw), ct_priv->ct);
+	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 err_ct_tbl:
 	mapping_destroy(ct_priv->labels_mapping);
 err_mapping_labels:
@@ -1898,21 +1911,18 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 err_alloc:
 err_support:
 
-	return 0;
+	return NULL;
 }
 
 void
-mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
+mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 {
-	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
 	struct mlx5_fs_chains *chains;
-	struct mlx5_eswitch *esw;
 
 	if (!ct_priv)
 		return;
 
-	esw = ct_priv->esw;
-	chains = esw_chains(esw);
+	chains = ct_priv->chains;
 
 	mlx5_chains_destroy_global_table(chains, ct_priv->post_ct);
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
@@ -1926,15 +1936,12 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 	mutex_destroy(&ct_priv->control_lock);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
-
-	uplink_priv->ct_priv = NULL;
 }
 
 bool
-mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
+mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id)
 {
-	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
 	struct mlx5_ct_tuple tuple = {};
 	struct mlx5_ct_entry *entry;
 	u16 zone;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 2bfe930faa3b..bab872b76a5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -16,6 +16,8 @@ struct mlx5_rep_uplink_priv;
 struct mlx5e_tc_flow;
 struct mlx5e_priv;
 
+struct mlx5_fs_chains;
+struct mlx5_tc_ct_priv;
 struct mlx5_ct_flow;
 
 struct nf_flowtable;
@@ -76,22 +78,32 @@ struct mlx5_ct_attr {
 				 misc_parameters_2.metadata_reg_c_1) + 3,\
 }
 
+#define nic_zone_restore_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,\
+	.moffset = 2,\
+	.mlen = 1,\
+}
+
 #define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
+#define REG_MAPPING_MOFFSET(reg) (mlx5e_tc_attr_to_reg_mappings[reg].moffset)
+#define REG_MAPPING_SHIFT(reg) (REG_MAPPING_MOFFSET(reg) * 8)
 #define ZONE_RESTORE_BITS (REG_MAPPING_MLEN(ZONE_RESTORE_TO_REG) * 8)
 #define ZONE_RESTORE_MAX GENMASK(ZONE_RESTORE_BITS - 1, 0)
 
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
-int
-mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv);
+struct mlx5_tc_ct_priv *
+mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
+		struct mod_hdr_tbl *mod_hdr,
+		enum mlx5_flow_namespace_type ns_type);
 void
-mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv);
+mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv);
 
 void
-mlx5_tc_ct_match_del(struct mlx5e_priv *priv, struct mlx5_ct_attr *ct_attr);
+mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_attr);
 
 int
-mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
+mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		     struct mlx5_flow_spec *spec,
 		     struct flow_cls_offload *f,
 		     struct mlx5_ct_attr *ct_attr,
@@ -100,44 +112,46 @@ int
 mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 			    struct mlx5_flow_spec *spec);
 int
-mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
+mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack);
 
 struct mlx5_flow_handle *
-mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 void
-mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
+mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_flow_attr *attr);
 
 bool
-mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
+mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id);
 
 #else /* CONFIG_MLX5_TC_CT */
 
-static inline int
-mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
+static inline struct mlx5_tc_ct_priv *
+mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
+		struct mod_hdr_tbl *mod_hdr,
+		enum mlx5_flow_namespace_type ns_type)
 {
-	return 0;
+	return NULL;
 }
 
 static inline void
-mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
+mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 {
 }
 
 static inline void
-mlx5_tc_ct_match_del(struct mlx5e_priv *priv, struct mlx5_ct_attr *ct_attr) {}
+mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_attr) {}
 
 static inline int
-mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
+mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		     struct mlx5_flow_spec *spec,
 		     struct flow_cls_offload *f,
 		     struct mlx5_ct_attr *ct_attr,
@@ -149,7 +163,6 @@ mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
 		return 0;
 
 	NL_SET_ERR_MSG_MOD(extack, "mlx5 tc ct offload isn't enabled.");
-	netdev_warn(priv->netdev, "mlx5 tc ct offload isn't enabled.\n");
 	return -EOPNOTSUPP;
 }
 
@@ -161,18 +174,17 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 }
 
 static inline int
-mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
+mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
 	NL_SET_ERR_MSG_MOD(extack, "mlx5 tc ct offload isn't enabled.");
-	netdev_warn(priv->netdev, "mlx5 tc ct offload isn't enabled.\n");
 	return -EOPNOTSUPP;
 }
 
 static inline struct mlx5_flow_handle *
-mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr,
@@ -182,14 +194,14 @@ mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 }
 
 static inline void
-mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
+mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_flow_attr *attr)
 {
 }
 
 static inline bool
-mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
+mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id)
 {
 	if (!zone_restore_id)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index da05c4c195ff..4084a293442d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -186,6 +186,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 		.moffset = 0,
 		.mlen = 2,
 	},
+	[NIC_ZONE_RESTORE_TO_REG] = nic_zone_restore_to_reg_ct,
 };
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
@@ -239,6 +240,7 @@ mlx5e_tc_match_to_reg_get_match(struct mlx5_flow_spec *spec,
 int
 mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			  enum mlx5_flow_namespace_type ns,
 			  enum mlx5e_tc_attr_to_reg type,
 			  u32 data)
 {
@@ -248,8 +250,7 @@ mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 	char *modact;
 	int err;
 
-	err = alloc_mod_hdr_actions(mdev, MLX5_FLOW_NAMESPACE_FDB,
-				    mod_hdr_acts);
+	err = alloc_mod_hdr_actions(mdev, ns, mod_hdr_acts);
 	if (err)
 		return err;
 
@@ -270,6 +271,54 @@ mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 	return 0;
 }
 
+#define esw_offloads_mode(esw) (mlx5_eswitch_mode(esw) == MLX5_ESWITCH_OFFLOADS)
+
+static struct mlx5_tc_ct_priv *
+get_ct_priv(struct mlx5e_priv *priv)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+
+	if (esw_offloads_mode(esw)) {
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+
+		return uplink_priv->ct_priv;
+	}
+
+	return priv->fs.tc.ct;
+}
+
+struct mlx5_flow_handle *
+mlx5_tc_rule_insert(struct mlx5e_priv *priv,
+		    struct mlx5_flow_spec *spec,
+		    struct mlx5_flow_attr *attr)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	if (esw_offloads_mode(esw))
+		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+
+	return	mlx5e_add_offloaded_nic_rule(priv, spec, attr);
+}
+
+void
+mlx5_tc_rule_delete(struct mlx5e_priv *priv,
+		    struct mlx5_flow_handle *rule,
+		    struct mlx5_flow_attr *attr)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	if (esw_offloads_mode(esw)) {
+		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
+
+		return;
+	}
+
+	mlx5e_del_offloaded_nic_rule(priv, rule, attr);
+}
+
 struct mlx5e_hairpin {
 	struct mlx5_hairpin *pair;
 
@@ -365,7 +414,7 @@ static bool __flow_flag_test(struct mlx5e_tc_flow *flow, unsigned long flag)
 #define flow_flag_test(flow, flag) __flow_flag_test(flow, \
 						    MLX5E_TC_FLOW_FLAG_##flag)
 
-static bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow)
+bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow)
 {
 	return flow_flag_test(flow, ESWITCH);
 }
@@ -903,7 +952,11 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
 	flow_context->flow_tag = nic_attr->flow_tag;
 
-	if (nic_attr->hairpin_ft) {
+	if (attr->dest_ft) {
+		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dest[dest_ix].ft = attr->dest_ft;
+		dest_ix++;
+	} else if (nic_attr->hairpin_ft) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 		dest[dest_ix].ft = nic_attr->hairpin_ft;
 		dest_ix++;
@@ -954,9 +1007,13 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&tc->t_lock);
 
-	ft = mlx5_chains_get_table(nic_chains,
-				   attr->chain, attr->prio,
-				   MLX5E_TC_FT_LEVEL);
+	if (attr->chain || attr->prio)
+		ft = mlx5_chains_get_table(nic_chains,
+					   attr->chain, attr->prio,
+					   MLX5E_TC_FT_LEVEL);
+	else
+		ft = attr->ft;
+
 	if (IS_ERR(ft)) {
 		rule = ERR_CAST(ft);
 		goto err_ft_get;
@@ -973,9 +1030,10 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	return rule;
 
 err_rule:
-	mlx5_chains_put_table(nic_chains,
-			      attr->chain, attr->prio,
-			      MLX5E_TC_FT_LEVEL);
+	if (attr->chain || attr->prio)
+		mlx5_chains_put_table(nic_chains,
+				      attr->chain, attr->prio,
+				      MLX5E_TC_FT_LEVEL);
 err_ft_get:
 	if (attr->dest_chain)
 		mlx5_chains_put_table(nic_chains,
@@ -1017,8 +1075,12 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	flow->rule[0] = mlx5e_add_offloaded_nic_rule(priv, &parse_attr->spec,
-						     attr);
+	if (flow_flag_test(flow, CT))
+		flow->rule[0] = mlx5_tc_ct_flow_offload(get_ct_priv(priv), flow, &parse_attr->spec,
+							attr, &parse_attr->mod_hdr_acts);
+	else
+		flow->rule[0] = mlx5e_add_offloaded_nic_rule(priv, &parse_attr->spec,
+							     attr);
 
 	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
@@ -1031,8 +1093,9 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 
 	mlx5_del_flow_rules(rule);
 
-	mlx5_chains_put_table(nic_chains, attr->chain, attr->prio,
-			      MLX5E_TC_FT_LEVEL);
+	if (attr->chain || attr->prio)
+		mlx5_chains_put_table(nic_chains, attr->chain, attr->prio,
+				      MLX5E_TC_FT_LEVEL);
 
 	if (attr->dest_chain)
 		mlx5_chains_put_table(nic_chains, attr->dest_chain, 1,
@@ -1045,12 +1108,13 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 
-	if (!IS_ERR_OR_NULL(flow->rule[0]))
-		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0], attr);
-	mlx5_fc_destroy(priv->mdev, attr->counter);
-
 	flow_flag_clear(flow, OFFLOADED);
 
+	if (flow_flag_test(flow, CT))
+		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
+	else if (!IS_ERR_OR_NULL(flow->rule[0]))
+		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0], attr);
+
 	/* Remove root table if no rules are left to avoid
 	 * extra steering hops.
 	 */
@@ -1062,9 +1126,13 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&priv->fs.tc.t_lock);
 
+	kvfree(attr->parse_attr);
+
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
+	mlx5_fc_destroy(priv->mdev, attr->counter);
+
 	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
 
@@ -1099,7 +1167,8 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	if (flow_flag_test(flow, CT)) {
 		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 
-		return mlx5_tc_ct_flow_offload(flow->priv, flow, spec, attr,
+		return mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
+					       flow, spec, attr,
 					       mod_hdr_acts);
 	}
 
@@ -1126,7 +1195,7 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	flow_flag_clear(flow, OFFLOADED);
 
 	if (flow_flag_test(flow, CT)) {
-		mlx5_tc_ct_delete_flow(flow->priv, flow, attr);
+		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
 		return;
 	}
 
@@ -1383,7 +1452,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		}
 	kvfree(attr->parse_attr);
 
-	mlx5_tc_ct_match_del(priv, &flow->attr->ct_attr);
+	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
@@ -1942,7 +2011,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	} else {
 		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 		err = mlx5e_tc_match_to_reg_set(priv->mdev,
-						mod_hdr_acts,
+						mod_hdr_acts, MLX5_FLOW_NAMESPACE_FDB,
 						TUNNEL_TO_REG, value);
 		if (err)
 			goto err_set;
@@ -3458,6 +3527,13 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
+		case FLOW_ACTION_CT:
+			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
+			if (err)
+				return err;
+
+			flow_flag_set(flow, CT);
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
 			return -EOPNOTSUPP;
@@ -4288,7 +4364,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
-			err = mlx5_tc_ct_parse_action(priv, attr, act, extack);
+			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
 			if (err)
 				return err;
 
@@ -4558,7 +4634,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		goto err_free;
 
 	/* actions validation depends on parsing the ct matches first */
-	err = mlx5_tc_ct_match_add(priv, &parse_attr->spec, f,
+	err = mlx5_tc_ct_match_add(get_ct_priv(priv), &parse_attr->spec, f,
 				   &flow->attr->ct_attr, extack);
 	if (err)
 		goto err_free;
@@ -4704,6 +4780,11 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
+	err = mlx5_tc_ct_match_add(get_ct_priv(priv), &parse_attr->spec, f,
+				   &flow->attr->ct_attr, extack);
+	if (err)
+		goto err_free;
+
 	err = parse_tc_nic_actions(priv, &rule->action, parse_attr, flow, extack);
 	if (err)
 		goto err_free;
@@ -4713,14 +4794,12 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 		goto err_free;
 
 	flow_flag_set(flow, OFFLOADED);
-	kvfree(parse_attr);
 	*__flow = flow;
 
 	return 0;
 
 err_free:
 	mlx5e_flow_put(priv, flow);
-	kvfree(parse_attr);
 out:
 	return err;
 }
@@ -5143,6 +5222,11 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 		goto err_chains;
 	}
 
+	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
+				 MLX5_FLOW_NAMESPACE_KERNEL);
+	if (IS_ERR(tc->ct))
+		goto err_ct;
+
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
 						  &tc->netdevice_nb,
@@ -5156,6 +5240,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	return 0;
 
 err_reg:
+	mlx5_tc_ct_clean(tc->ct);
+err_ct:
 	mlx5_chains_destroy(tc->chains);
 err_chains:
 	rhashtable_destroy(&tc->ht);
@@ -5191,6 +5277,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	}
 	mutex_destroy(&tc->t_lock);
 
+	mlx5_tc_ct_clean(tc->ct);
 	mlx5_chains_destroy(tc->chains);
 }
 
@@ -5198,15 +5285,22 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 {
 	const size_t sz_enc_opts = sizeof(struct tunnel_match_enc_opts);
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *priv;
+	struct mlx5e_rep_priv *rpriv;
 	struct mapping_ctx *mapping;
-	int err;
+	struct mlx5_eswitch *esw;
+	struct mlx5e_priv *priv;
+	int err = 0;
 
 	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
-	priv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
+	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
+	priv = netdev_priv(rpriv->netdev);
+	esw = priv->mdev->priv.eswitch;
 
-	err = mlx5_tc_ct_init(uplink_priv);
-	if (err)
+	uplink_priv->ct_priv = mlx5_tc_ct_init(netdev_priv(priv->netdev),
+					       esw_chains(esw),
+					       &esw->offloads.mod_hdr,
+					       MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(uplink_priv->ct_priv))
 		goto err_ct;
 
 	mapping = mapping_create(sizeof(struct tunnel_match_key),
@@ -5235,7 +5329,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 err_enc_opts_mapping:
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
-	mlx5_tc_ct_clean(uplink_priv);
+	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 err_ct:
 	netdev_warn(priv->netdev,
 		    "Failed to initialize tc (eswitch), err: %d", err);
@@ -5249,10 +5343,11 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
 
 	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
+
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 	mapping_destroy(uplink_priv->tunnel_mapping);
 
-	mlx5_tc_ct_clean(uplink_priv);
+	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 }
 
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
@@ -5322,8 +5417,9 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 			 struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	u32 chain = 0, chain_tag, reg_b;
+	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct tc_skb_ext *tc_skb_ext;
 	int err;
 
@@ -5345,6 +5441,13 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 			return false;
 
 		tc_skb_ext->chain = chain;
+
+		zone_restore_id = (reg_b >> REG_MAPPING_SHIFT(NIC_ZONE_RESTORE_TO_REG)) &
+				  ZONE_RESTORE_MAX;
+
+		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
+					      zone_restore_id))
+			return false;
 	}
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index fa78289489b6..3b979008143d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -42,8 +42,14 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+#define NIC_FLOW_ATTR_SZ (sizeof(struct mlx5_flow_attr) +\
+			  sizeof(struct mlx5_nic_flow_attr))
 #define ESW_FLOW_ATTR_SZ (sizeof(struct mlx5_flow_attr) +\
 			  sizeof(struct mlx5_esw_flow_attr))
+#define ns_to_attr_sz(ns) (((ns) == MLX5_FLOW_NAMESPACE_FDB) ?\
+			    ESW_FLOW_ATTR_SZ :\
+			    NIC_FLOW_ATTR_SZ)
+
 
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
@@ -124,6 +130,7 @@ enum {
 
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht);
 void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht);
+bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow);
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 			   struct flow_cls_offload *f, unsigned long flags);
@@ -168,6 +175,7 @@ enum mlx5e_tc_attr_to_reg {
 	LABELS_TO_REG,
 	FTEID_TO_REG,
 	NIC_CHAIN_TO_REG,
+	NIC_ZONE_RESTORE_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
@@ -185,6 +193,7 @@ bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 
 int mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 			      struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			      enum mlx5_flow_namespace_type ns,
 			      enum mlx5e_tc_attr_to_reg type,
 			      u32 data);
 
@@ -224,6 +233,15 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 				  struct mlx5_flow_handle *rule,
 				  struct mlx5_flow_attr *attr);
 
+struct mlx5_flow_handle *
+mlx5_tc_rule_insert(struct mlx5e_priv *priv,
+		    struct mlx5_flow_spec *spec,
+		    struct mlx5_flow_attr *attr);
+void
+mlx5_tc_rule_delete(struct mlx5e_priv *priv,
+		    struct mlx5_flow_handle *rule,
+		    struct mlx5_flow_attr *attr);
+
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
@@ -235,6 +253,14 @@ mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 
 struct mlx5_flow_attr *mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type);
 
+struct mlx5_flow_handle *
+mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
+			     struct mlx5_flow_spec *spec,
+			     struct mlx5_flow_attr *attr);
+void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
+				  struct mlx5_flow_handle *rule,
+				  struct mlx5_flow_attr *attr);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
-- 
2.26.2

