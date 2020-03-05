Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEDA17A8E9
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCEPeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:34:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39104 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726920AbgCEPen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:34:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Mar 2020 17:34:35 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 025FYYsZ010824;
        Thu, 5 Mar 2020 17:34:35 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload 11/13] net/mlx5e: CT: Offload established flows
Date:   Thu,  5 Mar 2020 17:34:26 +0200
Message-Id: <1583422468-8456-12-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register driver callbacks with the nf flow table platform.
FT add/delete events will create/delete FTE in the CT/CT_NAT tables.

Restoring the CT state on miss will be added in the following patch.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 666 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   3 +
 2 files changed, 669 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 54d1c58..183a1ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -10,6 +10,7 @@
 #include <uapi/linux/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_ct.h>
 #include <net/flow_offload.h>
+#include <net/netfilter/nf_flow_table.h>
 #include <linux/workqueue.h>
 
 #include "en/tc_ct.h"
@@ -34,6 +35,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_eswitch *esw;
 	const struct net_device *netdev;
 	struct idr fte_ids;
+	struct rhashtable zone_ht;
 	struct mlx5_flow_table *ct;
 	struct mlx5_flow_table *ct_nat;
 	struct mlx5_flow_table *post_ct;
@@ -45,10 +47,51 @@ struct mlx5_ct_flow {
 	struct mlx5_esw_flow_attr post_ct_attr;
 	struct mlx5_flow_handle *pre_ct_rule;
 	struct mlx5_flow_handle *post_ct_rule;
+	struct mlx5_ct_ft *ft;
 	u32 fte_id;
 	u32 chain_mapping;
 };
 
+struct mlx5_ct_zone_rule {
+	struct mlx5_flow_handle *rule;
+	struct mlx5_esw_flow_attr attr;
+	bool nat;
+};
+
+struct mlx5_ct_ft {
+	struct rhash_head node;
+	u16 zone;
+	refcount_t refcount;
+	struct nf_flowtable *nf_ft;
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct rhashtable ct_entries_ht;
+};
+
+struct mlx5_ct_entry {
+	u16 zone;
+	struct rhash_head node;
+	struct flow_rule *flow_rule;
+	struct mlx5_fc *counter;
+	unsigned long lastuse;
+	unsigned long cookie;
+	struct mlx5_ct_zone_rule zone_rules[2];
+};
+
+static const struct rhashtable_params cts_ht_params = {
+	.head_offset = offsetof(struct mlx5_ct_entry, node),
+	.key_offset = offsetof(struct mlx5_ct_entry, cookie),
+	.key_len = sizeof(((struct mlx5_ct_entry *)0)->cookie),
+	.automatic_shrinking = true,
+	.min_size = 16 * 1024,
+};
+
+static const struct rhashtable_params zone_params = {
+	.head_offset = offsetof(struct mlx5_ct_ft, node),
+	.key_offset = offsetof(struct mlx5_ct_ft, zone),
+	.key_len = sizeof(((struct mlx5_ct_ft *)0)->zone),
+	.automatic_shrinking = true,
+};
+
 static struct mlx5_tc_ct_priv *
 mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
 {
@@ -61,6 +104,549 @@ struct mlx5_ct_flow {
 	return uplink_priv->ct_priv;
 }
 
+static int
+mlx5_tc_ct_set_tuple_match(struct mlx5_flow_spec *spec,
+			   struct flow_rule *rule)
+{
+	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				       outer_headers);
+	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				       outer_headers);
+	u16 addr_type = 0;
+	u8 ip_proto = 0;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
+			 ntohs(match.mask->n_proto));
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+			 ntohs(match.key->n_proto));
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
+			 match.mask->ip_proto);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
+			 match.key->ip_proto);
+
+		ip_proto = match.key->ip_proto;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
+		       &match.mask->src, sizeof(match.mask->src));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
+		       &match.key->src, sizeof(match.key->src));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
+		       &match.mask->dst, sizeof(match.mask->dst));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
+		       &match.key->dst, sizeof(match.key->dst));
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       &match.mask->src, sizeof(match.mask->src));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       &match.key->src, sizeof(match.key->src));
+
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       &match.mask->dst, sizeof(match.mask->dst));
+		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       &match.key->dst, sizeof(match.key->dst));
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		switch (ip_proto) {
+		case IPPROTO_TCP:
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 tcp_sport, ntohs(match.mask->src));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 tcp_sport, ntohs(match.key->src));
+
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 tcp_dport, ntohs(match.mask->dst));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 tcp_dport, ntohs(match.key->dst));
+			break;
+
+		case IPPROTO_UDP:
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 udp_sport, ntohs(match.mask->src));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 udp_sport, ntohs(match.key->src));
+
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 udp_dport, ntohs(match.mask->dst));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 udp_dport, ntohs(match.key->dst));
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP)) {
+		struct flow_match_tcp match;
+
+		flow_rule_match_tcp(rule, &match);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, tcp_flags,
+			 ntohs(match.mask->flags));
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, tcp_flags,
+			 ntohs(match.key->flags));
+	}
+
+	return 0;
+}
+
+static void
+mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
+			  struct mlx5_ct_entry *entry,
+			  bool nat)
+{
+	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
+	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
+	struct mlx5_eswitch *esw = ct_priv->esw;
+
+	ct_dbg("Deleting ct entry rule in zone %d", entry->zone);
+
+	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
+	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
+}
+
+static void
+mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
+			   struct mlx5_ct_entry *entry)
+{
+	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
+	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
+
+	mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
+}
+
+static struct flow_action_entry *
+mlx5_tc_ct_get_ct_metadata_action(struct flow_rule *flow_rule)
+{
+	struct flow_action *flow_action = &flow_rule->action;
+	struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id == FLOW_ACTION_CT_METADATA)
+			return act;
+	}
+
+	return NULL;
+}
+
+static int
+mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
+			       struct mlx5e_tc_mod_hdr_acts *mod_acts,
+			       u8 ct_state,
+			       u32 mark,
+			       u32 label)
+{
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	int err;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+					CTSTATE_TO_REG, ct_state);
+	if (err)
+		return err;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+					MARK_TO_REG, mark);
+	if (err)
+		return err;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+					LABELS_TO_REG, label);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
+				   char *modact)
+{
+	u32 offset = act->mangle.offset, field;
+
+	switch (act->mangle.htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+		MLX5_SET(set_action_in, modact, length, 0);
+		field = offset == offsetof(struct iphdr, saddr) ?
+			MLX5_ACTION_IN_FIELD_OUT_SIPV4 :
+			MLX5_ACTION_IN_FIELD_OUT_DIPV4;
+		break;
+
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+		MLX5_SET(set_action_in, modact, length, 0);
+		if (offset == offsetof(struct ipv6hdr, saddr))
+			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0;
+		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
+			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
+		else if (offset == offsetof(struct ipv6hdr, saddr) + 8)
+			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64;
+		else if (offset == offsetof(struct ipv6hdr, saddr) + 12)
+			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96;
+		else if (offset == offsetof(struct ipv6hdr, daddr))
+			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0;
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
+			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 8)
+			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64;
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
+			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96;
+		else
+			return -EOPNOTSUPP;
+		break;
+
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+		MLX5_SET(set_action_in, modact, length, 16);
+		field = offset == offsetof(struct tcphdr, source) ?
+			MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT :
+			MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT;
+		break;
+
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		MLX5_SET(set_action_in, modact, length, 16);
+		field = offset == offsetof(struct udphdr, source) ?
+			MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT :
+			MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT;
+		break;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, modact, offset, 0);
+	MLX5_SET(set_action_in, modact, field, field);
+	MLX5_SET(set_action_in, modact, data, act->mangle.val);
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_entry_create_nat(struct mlx5_tc_ct_priv *ct_priv,
+			    struct flow_rule *flow_rule,
+			    struct mlx5e_tc_mod_hdr_acts *mod_acts)
+{
+	struct flow_action *flow_action = &flow_rule->action;
+	struct mlx5_core_dev *mdev = ct_priv->esw->dev;
+	struct flow_action_entry *act;
+	size_t action_size;
+	char *modact;
+	int err, i;
+
+	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
+
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_MANGLE: {
+			err = alloc_mod_hdr_actions(mdev,
+						    MLX5_FLOW_NAMESPACE_FDB,
+						    mod_acts);
+			if (err)
+				return err;
+
+			modact = mod_acts->actions +
+				 mod_acts->num_actions * action_size;
+
+			err = mlx5_tc_ct_parse_mangle_to_mod_act(act, modact);
+			if (err)
+				return err;
+
+			mod_acts->num_actions++;
+		}
+		break;
+
+		case FLOW_ACTION_CT_METADATA:
+			/* Handled earlier */
+			continue;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
+				struct mlx5_esw_flow_attr *attr,
+				struct flow_rule *flow_rule,
+				bool nat)
+{
+	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_modify_hdr *mod_hdr;
+	struct flow_action_entry *meta;
+	int err;
+
+	meta = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
+	if (!meta)
+		return -EOPNOTSUPP;
+
+	if (meta->ct_metadata.labels[1] ||
+	    meta->ct_metadata.labels[2] ||
+	    meta->ct_metadata.labels[3]) {
+		ct_dbg("Failed to offload ct entry due to unsupported label");
+		return -EOPNOTSUPP;
+	}
+
+	if (nat) {
+		err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule,
+						  &mod_acts);
+		if (err)
+			goto err_mapping;
+	}
+
+	err = mlx5_tc_ct_entry_set_registers(ct_priv, &mod_acts,
+					     (MLX5_CT_STATE_ESTABLISHED_BIT |
+					      MLX5_CT_STATE_TRK_BIT),
+					     meta->ct_metadata.mark,
+					     meta->ct_metadata.labels[0]);
+	if (err)
+		goto err_mapping;
+
+	mod_hdr = mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_FDB,
+					   mod_acts.num_actions,
+					   mod_acts.actions);
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		goto err_mapping;
+	}
+	attr->modify_hdr = mod_hdr;
+
+	dealloc_mod_hdr_actions(&mod_acts);
+	return 0;
+
+err_mapping:
+	dealloc_mod_hdr_actions(&mod_acts);
+	return err;
+}
+
+static int
+mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
+			  struct flow_rule *flow_rule,
+			  struct mlx5_ct_entry *entry,
+			  bool nat)
+{
+	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
+	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_flow_spec spec = {};
+	int err;
+
+	zone_rule->nat = nat;
+
+	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule, nat);
+	if (err) {
+		ct_dbg("Failed to create ct entry mod hdr");
+		return err;
+	}
+
+	attr->action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
+		       MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+		       MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->dest_chain = 0;
+	attr->dest_ft = ct_priv->post_ct;
+	attr->fdb = nat ? ct_priv->ct_nat : ct_priv->ct;
+	attr->outer_match_level = MLX5_MATCH_L4;
+	attr->counter = entry->counter;
+	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
+
+	mlx5_tc_ct_set_tuple_match(&spec, flow_rule);
+	mlx5e_tc_match_to_reg_match(&spec, ZONE_TO_REG,
+				    entry->zone & MLX5_CT_ZONE_MASK,
+				    MLX5_CT_ZONE_MASK);
+
+	zone_rule->rule = mlx5_eswitch_add_offloaded_rule(esw, &spec, attr);
+	if (IS_ERR(zone_rule->rule)) {
+		err = PTR_ERR(zone_rule->rule);
+		ct_dbg("Failed to add ct entry rule, nat: %d", nat);
+		goto err_rule;
+	}
+
+	ct_dbg("Offloaded ct entry rule in zone %d", entry->zone);
+
+	return 0;
+
+err_rule:
+	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
+	return err;
+}
+
+static int
+mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
+			   struct flow_rule *flow_rule,
+			   struct mlx5_ct_entry *entry)
+{
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	int err;
+
+	entry->counter = mlx5_fc_create(esw->dev, true);
+	if (IS_ERR(entry->counter)) {
+		err = PTR_ERR(entry->counter);
+		ct_dbg("Failed to create counter for ct entry");
+		return err;
+	}
+
+	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
+	if (err)
+		goto err_orig;
+
+	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
+	if (err)
+		goto err_nat;
+
+	return 0;
+
+err_nat:
+	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
+err_orig:
+	mlx5_fc_destroy(esw->dev, entry->counter);
+	return err;
+}
+
+static int
+mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
+				  struct flow_cls_offload *flow)
+{
+	struct flow_rule *flow_rule = flow_cls_offload_flow_rule(flow);
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
+	struct flow_action_entry *meta_action;
+	unsigned long cookie = flow->cookie;
+	struct mlx5_ct_entry *entry;
+	int err;
+
+	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
+	if (!meta_action)
+		return -EOPNOTSUPP;
+
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie,
+				       cts_ht_params);
+	if (entry)
+		return 0;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->zone = meta_action->ct_metadata.zone;
+	entry->flow_rule = flow_rule;
+	entry->cookie = flow->cookie;
+
+	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
+	if (err)
+		goto err_rules;
+
+	err = rhashtable_insert_fast(&ft->ct_entries_ht, &entry->node,
+				     cts_ht_params);
+	if (err)
+		goto err_insert;
+
+	return 0;
+
+err_insert:
+	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+err_rules:
+	kfree(entry);
+	netdev_warn(ct_priv->netdev,
+		    "Failed to offload ct entry, err: %d\n", err);
+	return err;
+}
+
+static int
+mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
+				  struct flow_cls_offload *flow)
+{
+	unsigned long cookie = flow->cookie;
+	struct mlx5_ct_entry *entry;
+
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie,
+				       cts_ht_params);
+	if (!entry)
+		return -ENOENT;
+
+	mlx5_tc_ct_entry_del_rules(ft->ct_priv, entry);
+	WARN_ON(rhashtable_remove_fast(&ft->ct_entries_ht,
+				       &entry->node,
+				       cts_ht_params));
+	kfree(entry);
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_block_flow_offload_stats(struct mlx5_ct_ft *ft,
+				    struct flow_cls_offload *f)
+{
+	unsigned long cookie = f->cookie;
+	struct mlx5_ct_entry *entry;
+	u64 lastuse, packets, bytes;
+
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie,
+				       cts_ht_params);
+	if (!entry)
+		return -ENOENT;
+
+	mlx5_fc_query_cached(entry->counter, &bytes, &packets, &lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse);
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_block_flow_offload(enum tc_setup_type type, void *type_data,
+			      void *cb_priv)
+{
+	struct flow_cls_offload *f = type_data;
+	struct mlx5_ct_ft *ft = cb_priv;
+
+	if (type != TC_SETUP_CLSFLOWER)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return mlx5_tc_ct_block_flow_offload_add(ft, f);
+	case FLOW_CLS_DESTROY:
+		return mlx5_tc_ct_block_flow_offload_del(ft, f);
+	case FLOW_CLS_STATS:
+		return mlx5_tc_ct_block_flow_offload_stats(ft, f);
+	default:
+		break;
+	};
+
+	return -EOPNOTSUPP;
+}
+
 int
 mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
@@ -159,10 +745,74 @@ struct mlx5_ct_flow {
 
 	attr->ct_attr.zone = act->ct.zone;
 	attr->ct_attr.ct_action = act->ct.action;
+	attr->ct_attr.nf_ft = act->ct.flow_table;
 
 	return 0;
 }
 
+static struct mlx5_ct_ft *
+mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
+		     struct nf_flowtable *nf_ft)
+{
+	struct mlx5_ct_ft *ft;
+	int err;
+
+	ft = rhashtable_lookup_fast(&ct_priv->zone_ht, &zone, zone_params);
+	if (ft) {
+		refcount_inc(&ft->refcount);
+		return ft;
+	}
+
+	ft = kzalloc(sizeof(*ft), GFP_KERNEL);
+	if (!ft)
+		return ERR_PTR(-ENOMEM);
+
+	ft->zone = zone;
+	ft->nf_ft = nf_ft;
+	ft->ct_priv = ct_priv;
+
+	err = rhashtable_init(&ft->ct_entries_ht, &cts_ht_params);
+	if (err)
+		goto err_init;
+
+	err = nf_flow_table_offload_add_cb(ft->nf_ft,
+					   mlx5_tc_ct_block_flow_offload, ft);
+	if (err)
+		goto err_add_cb;
+
+	refcount_set(&ft->refcount, 1);
+
+	err = rhashtable_insert_fast(&ct_priv->zone_ht, &ft->node,
+				     zone_params);
+	if (err)
+		goto err_insert;
+
+	return ft;
+
+err_insert:
+	nf_flow_table_offload_del_cb(ft->nf_ft,
+				     mlx5_tc_ct_block_flow_offload, ft);
+err_add_cb:
+	rhashtable_destroy(&ft->ct_entries_ht);
+err_init:
+	kfree(ft);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv,
+		     struct mlx5_ct_ft *ft)
+{
+	if (!refcount_dec_and_test(&ft->refcount))
+		return;
+
+	nf_flow_table_offload_del_cb(ft->nf_ft,
+				     mlx5_tc_ct_block_flow_offload, ft);
+	rhashtable_remove_fast(&ct_priv->zone_ht, &ft->node, zone_params);
+	rhashtable_destroy(&ft->ct_entries_ht);
+	kfree(ft);
+}
+
 /* We translate the tc filter with CT action to the following HW model:
  *
  * +-------------------+      +--------------------+    +--------------+
@@ -193,12 +843,23 @@ struct mlx5_ct_flow {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_ct_flow *ct_flow;
 	int chain_mapping = 0, err;
+	struct mlx5_ct_ft *ft;
 	u32 fte_id = 1;
 
 	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
 	if (!ct_flow)
 		return -ENOMEM;
 
+	/* Register for CT established events */
+	ft = mlx5_tc_ct_add_ft_cb(ct_priv, attr->ct_attr.zone,
+				  attr->ct_attr.nf_ft);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		ct_dbg("Failed to register to ft callback");
+		goto err_ft;
+	}
+	ct_flow->ft = ft;
+
 	err = idr_alloc_u32(&ct_priv->fte_ids, ct_flow, &fte_id,
 			    MLX5_FTE_ID_MAX, GFP_KERNEL);
 	if (err) {
@@ -331,6 +992,8 @@ struct mlx5_ct_flow {
 err_get_chain:
 	idr_remove(&ct_priv->fte_ids, fte_id);
 err_idr:
+	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
+err_ft:
 	kfree(ct_flow);
 	netdev_warn(priv->netdev, "Failed to offload ct flow, err %d\n", err);
 	return err;
@@ -372,6 +1035,7 @@ struct mlx5_flow_handle *
 					&ct_flow->post_ct_attr);
 	mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
 	idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
+	mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 	kfree(ct_flow);
 }
 
@@ -503,6 +1167,7 @@ struct mlx5_flow_handle *
 
 	idr_init(&ct_priv->fte_ids);
 	mutex_init(&ct_priv->control_lock);
+	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 
 	/* Done, set ct_priv to know it initializted */
 	uplink_priv->ct_priv = ct_priv;
@@ -533,6 +1198,7 @@ struct mlx5_flow_handle *
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct_nat);
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct);
 
+	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 3a84216..f4bfda7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -15,10 +15,13 @@
 
 struct mlx5_ct_flow;
 
+struct nf_flowtable;
+
 struct mlx5_ct_attr {
 	u16 zone;
 	u16 ct_action;
 	struct mlx5_ct_flow *ct_flow;
+	struct nf_flowtable *nf_ft;
 };
 
 #define zone_to_reg_ct {\
-- 
1.8.3.1

