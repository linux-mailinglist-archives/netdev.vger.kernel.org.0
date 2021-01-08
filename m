Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD72EED13
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbhAHFcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbhAHFcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73987235FF;
        Fri,  8 Jan 2021 05:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083860;
        bh=z0P2B5cF3JnhqoaBim1peyysRdd7H8ydax5UE9QTjDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRntdumRV+CCnMkXrG4RpTu+stOKIgN5FjtaVgF6UARM2kfm/djenW+vsji9b0QI9
         14HO5n+2YDr3HAnLv3W3m0bc/tHZnfax3MSVAEePNCwK2Gg0kx9LHh2UOiAQk5V9Au
         YZ1jdmpYMt5egPekJSWNsdofUyO+ybuPTMk1sjrUHaeWR+O1ZvIBHrRTw55Z5YqA0N
         2K9rmc6mZEhZSwpqjPXqLlF6XtRSmn/7FZUw4ekWhqPYj++5C5ciGYqC6wM2Dg8ZfT
         rRWry77RArhxnHYV8xI0ceyicd0mxT70jVC0wFNuZ3pBpRWFkP1czNvUnrbbysjxat
         h/Vs/2MWHgUBg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: CT: Support offload of +trk+new ct rules
Date:   Thu,  7 Jan 2021 21:30:48 -0800
Message-Id: <20210108053054.660499-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Add support to offload +trk+new rules for terminating flows for udp
protocols using source port entropy.
This kind of traffic will never be considered connect in conntrack
and thus never set as established so no need to keep
track of them in SW conntrack and offload this traffic based on dst
port.
In this commit we support only the default registered vxlan port,
RoCE and Geneve ports. Using the registered ports assume the traffic
is that of the registered protocol.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 228 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  16 +-
 3 files changed, 236 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 6dac2fabb7f5..b0c357f755d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -25,9 +25,6 @@
 
 #define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen * 8)
 #define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
-#define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
-#define MLX5_CT_STATE_TRK_BIT BIT(2)
-#define MLX5_CT_STATE_NAT_BIT BIT(3)
 
 #define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen * 8)
 #define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
@@ -39,6 +36,17 @@
 #define ct_dbg(fmt, args...)\
 	netdev_dbg(ct_priv->netdev, "ct_debug: " fmt "\n", ##args)
 
+#define IANA_VXLAN_UDP_PORT    4789
+#define ROCE_V2_UDP_DPORT      4791
+#define GENEVE_UDP_PORT        6081
+#define DEFAULT_UDP_PORTS 3
+
+static int default_udp_ports[] = {
+	IANA_VXLAN_UDP_PORT,
+	ROCE_V2_UDP_DPORT,
+	GENEVE_UDP_PORT,
+};
+
 struct mlx5_tc_ct_priv {
 	struct mlx5_core_dev *dev;
 	const struct net_device *netdev;
@@ -88,6 +96,16 @@ struct mlx5_tc_ct_pre {
 	struct mlx5_modify_hdr *modify_hdr;
 };
 
+struct mlx5_tc_ct_trk_new_rule {
+	struct mlx5_flow_handle *flow_rule;
+	struct list_head list;
+};
+
+struct mlx5_tc_ct_trk_new_rules {
+	struct list_head rules;
+	struct mlx5_modify_hdr *modify_hdr;
+};
+
 struct mlx5_ct_ft {
 	struct rhash_head node;
 	u16 zone;
@@ -98,6 +116,8 @@ struct mlx5_ct_ft {
 	struct rhashtable ct_entries_ht;
 	struct mlx5_tc_ct_pre pre_ct;
 	struct mlx5_tc_ct_pre pre_ct_nat;
+	struct mlx5_tc_ct_trk_new_rules trk_new_rules;
+	struct nf_conn *tmpl;
 };
 
 struct mlx5_ct_tuple {
@@ -1064,7 +1084,7 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector_key_ct *mask, *key;
-	bool trk, est, untrk, unest, new;
+	bool trk, est, untrk, unest, new, unnew;
 	u32 ctstate = 0, ctstate_mask = 0;
 	u16 ct_state_on, ct_state_off;
 	u16 ct_state, ct_state_mask;
@@ -1102,19 +1122,16 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 	new = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	est = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
+	unnew = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 
 	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
+	ctstate |= new ? MLX5_CT_STATE_NEW_BIT : 0;
 	ctstate |= est ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
 	ctstate_mask |= (untrk || trk) ? MLX5_CT_STATE_TRK_BIT : 0;
+	ctstate_mask |= (unnew || new) ? MLX5_CT_STATE_NEW_BIT : 0;
 	ctstate_mask |= (unest || est) ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
 
-	if (new) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "matching on ct_state +new isn't supported");
-		return -EOPNOTSUPP;
-	}
-
 	if (mask->ct_zone)
 		mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
 					    key->ct_zone, MLX5_CT_ZONE_MASK);
@@ -1136,6 +1153,8 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 					    MLX5_CT_LABELS_MASK);
 	}
 
+	ct_attr->ct_state = ctstate;
+
 	return 0;
 }
 
@@ -1390,10 +1409,157 @@ mlx5_tc_ct_free_pre_ct_tables(struct mlx5_ct_ft *ft)
 	mlx5_tc_ct_free_pre_ct(ft, &ft->pre_ct);
 }
 
+static void mlx5_tc_ct_set_match_dst_udp_port(struct mlx5_flow_spec *spec, u16 dst_port)
+{
+	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				       outer_headers);
+	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				       outer_headers);
+
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, udp_dport);
+	MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_dport, dst_port);
+
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+}
+
+static struct mlx5_tc_ct_trk_new_rule *
+tc_ct_add_trk_new_rule(struct mlx5_ct_ft *ft, int port)
+{
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
+	struct mlx5_tc_ct_trk_new_rule *trk_new_rule;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	int err;
+
+	trk_new_rule = kzalloc(sizeof(*trk_new_rule), GFP_KERNEL);
+	if (!trk_new_rule)
+		return ERR_PTR(-ENOMEM);
+
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		kfree(trk_new_rule);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	flow_act.modify_hdr = ft->trk_new_rules.modify_hdr;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = ct_priv->post_ct;
+
+	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, ft->zone, MLX5_CT_ZONE_MASK);
+	mlx5_tc_ct_set_match_dst_udp_port(spec, port);
+
+	rule = mlx5_add_flow_rules(ct_priv->trk_new_ct, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		ct_dbg("Failed to add trk_new rule for udp port %d, err %d", port, err);
+		goto err_insert;
+	}
+
+	kfree(spec);
+	trk_new_rule->flow_rule = rule;
+	list_add_tail(&trk_new_rule->list, &ft->trk_new_rules.rules);
+	return trk_new_rule;
+
+err_insert:
+	kfree(spec);
+	kfree(trk_new_rule);
+	return ERR_PTR(err);
+}
+
+static void
+tc_ct_del_trk_new_rule(struct mlx5_tc_ct_trk_new_rule *rule)
+{
+	list_del(&rule->list);
+	mlx5_del_flow_rules(rule->flow_rule);
+	kfree(rule);
+}
+
+static int
+tc_ct_init_trk_new_rules(struct mlx5_ct_ft *ft)
+{
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
+	struct mlx5_tc_ct_trk_new_rule *rule, *tmp;
+	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
+	struct mlx5_modify_hdr *mod_hdr;
+	struct mlx5e_priv *priv;
+	u32 ct_state;
+	int i, err;
+
+	priv = netdev_priv(ct_priv->netdev);
+
+	ct_state = MLX5_CT_STATE_TRK_BIT | MLX5_CT_STATE_NEW_BIT;
+	err = mlx5e_tc_match_to_reg_set(priv->mdev, &mod_acts, ct_priv->ns_type,
+					CTSTATE_TO_REG, ct_state);
+	if (err) {
+		ct_dbg("Failed to set register for ct trk_new");
+		goto err_set_registers;
+	}
+
+	err = mlx5e_tc_match_to_reg_set(priv->mdev, &mod_acts, ct_priv->ns_type,
+					ZONE_RESTORE_TO_REG, ft->zone_restore_id);
+	if (err) {
+		ct_dbg("Failed to set register for ct trk_new zone restore");
+		goto err_set_registers;
+	}
+
+	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
+					   ct_priv->ns_type,
+					   mod_acts.num_actions,
+					   mod_acts.actions);
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		ct_dbg("Failed to create ct trk_new mod hdr");
+		goto err_set_registers;
+	}
+
+	ft->trk_new_rules.modify_hdr = mod_hdr;
+	dealloc_mod_hdr_actions(&mod_acts);
+
+	for (i = 0; i < DEFAULT_UDP_PORTS; i++) {
+		int port = default_udp_ports[i];
+
+		rule = tc_ct_add_trk_new_rule(ft, port);
+		if (IS_ERR(rule))
+			goto err_insert;
+	}
+
+	return 0;
+
+err_insert:
+	list_for_each_entry_safe(rule, tmp, &ft->trk_new_rules.rules, list)
+		tc_ct_del_trk_new_rule(rule);
+	mlx5_modify_header_dealloc(priv->mdev, mod_hdr);
+err_set_registers:
+	dealloc_mod_hdr_actions(&mod_acts);
+	netdev_warn(priv->netdev,
+		    "Failed to offload ct trk_new flow, err %d\n", err);
+	return err;
+}
+
+static void
+tc_ct_cleanup_trk_new_rules(struct mlx5_ct_ft *ft)
+{
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
+	struct mlx5_tc_ct_trk_new_rule *rule, *tmp;
+	struct mlx5e_priv *priv;
+
+	list_for_each_entry_safe(rule, tmp, &ft->trk_new_rules.rules, list)
+		tc_ct_del_trk_new_rule(rule);
+
+	priv = netdev_priv(ct_priv->netdev);
+	mlx5_modify_header_dealloc(priv->mdev, ft->trk_new_rules.modify_hdr);
+}
+
 static struct mlx5_ct_ft *
 mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 		     struct nf_flowtable *nf_ft)
 {
+	struct nf_conntrack_zone ctzone;
 	struct mlx5_ct_ft *ft;
 	int err;
 
@@ -1415,11 +1581,16 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	ft->nf_ft = nf_ft;
 	ft->ct_priv = ct_priv;
 	refcount_set(&ft->refcount, 1);
+	INIT_LIST_HEAD(&ft->trk_new_rules.rules);
 
 	err = mlx5_tc_ct_alloc_pre_ct_tables(ft);
 	if (err)
 		goto err_alloc_pre_ct;
 
+	err = tc_ct_init_trk_new_rules(ft);
+	if (err)
+		goto err_add_trk_new_rules;
+
 	err = rhashtable_init(&ft->ct_entries_ht, &cts_ht_params);
 	if (err)
 		goto err_init;
@@ -1429,6 +1600,14 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	if (err)
 		goto err_insert;
 
+	nf_ct_zone_init(&ctzone, zone, NF_CT_DEFAULT_ZONE_DIR, 0);
+	ft->tmpl = nf_ct_tmpl_alloc(&init_net, &ctzone, GFP_KERNEL);
+	if (!ft->tmpl)
+		goto err_tmpl;
+
+	__set_bit(IPS_CONFIRMED_BIT, &ft->tmpl->status);
+	nf_conntrack_get(&ft->tmpl->ct_general);
+
 	err = nf_flow_table_offload_add_cb(ft->nf_ft,
 					   mlx5_tc_ct_block_flow_offload, ft);
 	if (err)
@@ -1437,10 +1616,14 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	return ft;
 
 err_add_cb:
+	nf_conntrack_put(&ft->tmpl->ct_general);
+err_tmpl:
 	rhashtable_remove_fast(&ct_priv->zone_ht, &ft->node, zone_params);
 err_insert:
 	rhashtable_destroy(&ft->ct_entries_ht);
 err_init:
+	tc_ct_cleanup_trk_new_rules(ft);
+err_add_trk_new_rules:
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 err_alloc_pre_ct:
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
@@ -1471,6 +1654,8 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
+	nf_conntrack_put(&ft->tmpl->ct_general);
+	tc_ct_cleanup_trk_new_rules(ft);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);
@@ -2100,6 +2285,27 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	kfree(ct_priv);
 }
 
+static bool
+mlx5e_tc_ct_restore_trk_new(struct mlx5_tc_ct_priv *ct_priv,
+			    struct sk_buff *skb,
+			    struct mlx5_ct_tuple *tuple,
+			    u16 zone)
+{
+	struct mlx5_ct_ft *ft;
+
+	if ((ntohs(tuple->port.dst) != IANA_VXLAN_UDP_PORT) &&
+	    (ntohs(tuple->port.dst) != ROCE_V2_UDP_DPORT))
+		return false;
+
+	ft = rhashtable_lookup_fast(&ct_priv->zone_ht, &zone, zone_params);
+	if (!ft)
+		return false;
+
+	nf_conntrack_get(&ft->tmpl->ct_general);
+	nf_ct_set(skb, ft->tmpl, IP_CT_NEW);
+	return true;
+}
+
 bool
 mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id)
@@ -2123,7 +2329,7 @@ mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 		entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_nat_ht,
 					       &tuple, tuples_nat_ht_params);
 	if (!entry)
-		return false;
+		return mlx5e_tc_ct_restore_trk_new(ct_priv, skb, &tuple, zone);
 
 	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 6503b614337c..f730dbfbb02c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -10,6 +10,11 @@
 
 #include "en.h"
 
+#define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
+#define MLX5_CT_STATE_TRK_BIT BIT(2)
+#define MLX5_CT_STATE_NAT_BIT BIT(3)
+#define MLX5_CT_STATE_NEW_BIT BIT(4)
+
 struct mlx5_flow_attr;
 struct mlx5e_tc_mod_hdr_acts;
 struct mlx5_rep_uplink_priv;
@@ -28,6 +33,7 @@ struct mlx5_ct_attr {
 	struct mlx5_ct_flow *ct_flow;
 	struct nf_flowtable *nf_ft;
 	u32 ct_labels_id;
+	u32 ct_state;
 };
 
 #define zone_to_reg_ct {\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 56aa39ac1a1c..5cf7c221404b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3255,11 +3255,11 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct netlink_ext_ack *extack)
 {
-	bool ct_flow = false, ct_clear = false;
+	bool ct_flow = false, ct_clear = false, ct_new = false;
 	u32 actions;
 
-	ct_clear = flow->attr->ct_attr.ct_action &
-		TCA_CT_ACT_CLEAR;
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
+	ct_new = flow->attr->ct_attr.ct_state & MLX5_CT_STATE_NEW_BIT;
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
 	actions = flow->attr->action;
 
@@ -3274,6 +3274,16 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 		}
 	}
 
+	if (ct_new && ct_flow) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't offload ct_state new with action ct");
+		return false;
+	}
+
+	if (ct_new && flow->attr->dest_chain) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't offload ct_state new with action goto");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		return modify_header_match_supported(priv, &parse_attr->spec,
 						     flow_action, actions,
-- 
2.26.2

