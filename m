Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1D41441E2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgAUQRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:17:05 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43524 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729275AbgAUQQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:16:59 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Jan 2020 18:16:54 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00LGGrX6008966;
        Tue, 21 Jan 2020 18:16:54 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next-mlx5 11/13] net/mlx5e: Support inner header rewrite with goto action
Date:   Tue, 21 Jan 2020 18:16:20 +0200
Message-Id: <1579623382-6934-12-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware supports header rewrite of outer headers only.
To perform header rewrite on inner headers, we must first
decapsulate the packet.

Currently, the hardware decap action is explicitly set by the tc
tunnel_key unset action. However, with goto action the user won't
use the tunnel_key unset action. In addition, header rewrites actions
will not apply to the inner header as done by the software model.

To support this, we will map each tunnel matches seen on a tc rule to
a unique tunnel id, implicity add a decap action on tc chain 0 flows,
and mark the packets with this unique tunnel id. Tunnel matches on
the decapsulated tunnel on later chains will match on this unique id
instead of the actual packet.

We will also use this mapping to restore the tunnel info metadata
on miss.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 473 ++++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h  |  13 +
 3 files changed, 446 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 5e29141..3849f06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -80,6 +80,11 @@ struct mlx5_rep_uplink_priv {
 	struct mutex                unready_flows_lock;
 	struct list_head            unready_flows;
 	struct work_struct          reoffload_flows_work;
+
+	/* maps tun_info to a unique id*/
+	struct mapping_ctx *tunnel_mapping;
+	/* maps tun_enc_opts to a unique id*/
+	struct mapping_ctx *tunnel_enc_opts_mapping;
 };
 
 struct mlx5e_rep_priv {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index af7c917..9f8ff40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -57,8 +57,11 @@
 #include "en/tc_tun.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
+#include "lib/mapping.h"
 #include "diag/en_tc_tracepoint.h"
 
+#define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)
+
 struct mlx5_nic_flow_attr {
 	u32 action;
 	u32 flow_tag;
@@ -134,6 +137,8 @@ struct mlx5e_tc_flow {
 	refcount_t		refcnt;
 	struct rcu_head		rcu_head;
 	struct completion	init_done;
+	int tunnel_id; /* the mapped tunnel id of this flow */
+
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
 		struct mlx5_nic_flow_attr nic_attr[0];
@@ -151,14 +156,105 @@ struct mlx5e_tc_flow_parse_attr {
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(16)
 
+struct tunnel_match_key {
+	struct flow_dissector_key_control enc_control;
+	struct flow_dissector_key_keyid enc_key_id;
+	struct flow_dissector_key_ports enc_tp;
+	struct flow_dissector_key_ip enc_ip;
+	union {
+		struct flow_dissector_key_ipv4_addrs enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs enc_ipv6;
+	};
+
+	int filter_ifindex;
+};
+
+/* Tunnel_id mapping is TUNNEL_INFO_BITS + ENC_OPTS_BITS.
+ * Upper TUNNEL_INFO_BITS for general tunnel info.
+ * Lower ENC_OPTS_BITS bits for enc_opts.
+ */
+#define TUNNEL_INFO_BITS 6
+#define TUNNEL_INFO_BITS_MASK GENMASK(TUNNEL_INFO_BITS - 1, 0)
+#define ENC_OPTS_BITS 2
+#define ENC_OPTS_BITS_MASK GENMASK(ENC_OPTS_BITS - 1, 0)
+#define TUNNEL_ID_BITS (TUNNEL_INFO_BITS + ENC_OPTS_BITS)
+#define TUNNEL_ID_MASK GENMASK(TUNNEL_ID_BITS - 1, 0)
+
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[CHAIN_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
 		.moffset = 0,
 		.mlen = 2,
 	},
+	[TUNNEL_TO_REG] = {
+		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,
+		.moffset = 3,
+		.mlen = 1,
+		.soffset = MLX5_BYTE_OFF(fte_match_param,
+					 misc_parameters_2.metadata_reg_c_1),
+	},
 };
 
+static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
+
+void
+mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
+			    enum mlx5e_tc_attr_to_reg type,
+			    u32 data,
+			    u32 mask)
+{
+	int soffset = mlx5e_tc_attr_to_reg_mappings[type].soffset;
+	int match_len = mlx5e_tc_attr_to_reg_mappings[type].mlen;
+	void *headers_c = spec->match_criteria;
+	void *headers_v = spec->match_value;
+	void *fmask, *fval;
+
+	fmask = headers_c + soffset;
+	fval = headers_v + soffset;
+
+	mask = cpu_to_be32(mask) >> (32 - (match_len * 8));
+	data = cpu_to_be32(data) >> (32 - (match_len * 8));
+
+	memcpy(fmask, &mask, match_len);
+	memcpy(fval, &data, match_len);
+
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
+}
+
+int
+mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
+			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			  enum mlx5e_tc_attr_to_reg type,
+			  u32 data)
+{
+	int moffset = mlx5e_tc_attr_to_reg_mappings[type].moffset;
+	int mfield = mlx5e_tc_attr_to_reg_mappings[type].mfield;
+	int mlen = mlx5e_tc_attr_to_reg_mappings[type].mlen;
+	char *modact;
+	int err;
+
+	err = alloc_mod_hdr_actions(mdev, MLX5_FLOW_NAMESPACE_FDB,
+				    mod_hdr_acts);
+	if (err)
+		return err;
+
+	modact = mod_hdr_acts->actions +
+		 (mod_hdr_acts->num_actions * MLX5_MH_ACT_SZ);
+
+	/* Firmware has 5bit length field and 0 means 32bits */
+	if (mlen == 4)
+		mlen = 0;
+
+	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, modact, field, mfield);
+	MLX5_SET(set_action_in, modact, offset, moffset * 8);
+	MLX5_SET(set_action_in, modact, length, mlen * 8);
+	MLX5_SET(set_action_in, modact, data, data);
+	mod_hdr_acts->num_actions++;
+
+	return 0;
+}
+
 struct mlx5e_hairpin {
 	struct mlx5_hairpin *pair;
 
@@ -216,8 +312,6 @@ struct mlx5e_mod_hdr_entry {
 	int compl_result;
 };
 
-#define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)
-
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow);
 
@@ -1281,6 +1375,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_esw_flow_attr slow_attr;
 	int out_index;
 
+	mlx5e_put_flow_tunnel_id(flow);
+
 	if (flow_flag_test(flow, NOT_READY)) {
 		remove_unready_flow(flow);
 		kvfree(attr->parse_attr);
@@ -1670,46 +1766,271 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	}
 }
 
+static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_action *flow_action = &rule->action;
+	const struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_GOTO:
+			return true;
+		default:
+			continue;
+		}
+	}
+
+	return false;
+}
+
+static int
+enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
+				    struct flow_dissector_key_enc_opts *opts,
+				    struct netlink_ext_ack *extack,
+				    bool *dont_care)
+{
+	struct geneve_opt *opt;
+	int off = 0;
+
+	*dont_care = true;
+
+	while (opts->len > off) {
+		opt = (struct geneve_opt *)&opts->data[off];
+
+		if (!(*dont_care) || opt->opt_class || opt->type ||
+		    memchr_inv(opt->opt_data, 0, opt->length * 4)) {
+			*dont_care = false;
+
+			if (opt->opt_class != U16_MAX ||
+			    opt->type != U8_MAX ||
+			    memchr_inv(opt->opt_data, 0xFF,
+				       opt->length * 4)) {
+				NL_SET_ERR_MSG(extack,
+					       "Partial match of tunnel options in chain > 0 isn't supported");
+				netdev_warn(priv->netdev,
+					    "Partial match of tunnel options in chain > 0 isn't supported");
+				return -EOPNOTSUPP;
+			}
+		}
+
+		off += sizeof(struct geneve_opt) + opt->length * 4;
+	}
+
+	return 0;
+}
+
+#define COPY_DISSECTOR(rule, diss_key, dst)\
+({ \
+	struct flow_rule *__rule = (rule);\
+	typeof(dst) __dst = dst;\
+\
+	memcpy(__dst,\
+	       skb_flow_dissector_target(__rule->match.dissector,\
+					 diss_key,\
+					 __rule->match.key),\
+	       sizeof(*__dst));\
+})
+
+static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct flow_cls_offload *f,
+				    struct net_device *filter_dev)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	struct flow_match_enc_opts enc_opts_match;
+	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	bool enc_opts_is_dont_care = true;
+	struct tunnel_match_key tunnel_key;
+	u32 tun_id, enc_opts_id = 0;
+	struct mlx5_eswitch *esw;
+	u32 value, mask;
+	int err;
+
+	esw = priv->mdev->priv.eswitch;
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	memset(&tunnel_key, 0, sizeof(tunnel_key));
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
+		       &tunnel_key.enc_control);
+	if (tunnel_key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
+		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
+			       &tunnel_key.enc_ipv4);
+	else
+		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
+			       &tunnel_key.enc_ipv6);
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key.enc_ip);
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
+		       &tunnel_key.enc_tp);
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
+		       &tunnel_key.enc_key_id);
+	tunnel_key.filter_ifindex = filter_dev->ifindex;
+
+	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
+	if (err)
+		return err;
+
+	flow_rule_match_enc_opts(rule, &enc_opts_match);
+	err = enc_opts_is_dont_care_or_full_match(priv,
+						  enc_opts_match.mask,
+						  extack,
+						  &enc_opts_is_dont_care);
+	if (err)
+		goto err_enc_opts;
+
+	if (!enc_opts_is_dont_care) {
+		err = mapping_add(uplink_priv->tunnel_enc_opts_mapping,
+				  enc_opts_match.key, &enc_opts_id);
+		if (err)
+			goto err_enc_opts;
+	}
+
+	value = tun_id << ENC_OPTS_BITS | enc_opts_id;
+	mask = enc_opts_id ? TUNNEL_ID_MASK :
+			     (TUNNEL_ID_MASK & ~ENC_OPTS_BITS_MASK);
+
+	if (attr->chain) {
+		mlx5e_tc_match_to_reg_match(&attr->parse_attr->spec,
+					    TUNNEL_TO_REG, value, mask);
+	} else {
+		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
+		err = mlx5e_tc_match_to_reg_set(priv->mdev,
+						mod_hdr_acts,
+						TUNNEL_TO_REG, value);
+		if (err)
+			goto err_set;
+
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	}
+
+	flow->tunnel_id = value;
+	return 0;
+
+err_set:
+	if (enc_opts_id)
+		mapping_remove(uplink_priv->tunnel_enc_opts_mapping,
+			       enc_opts_id);
+err_enc_opts:
+	mapping_remove(uplink_priv->tunnel_mapping, tun_id);
+	return err;
+}
+
+static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
+{
+	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
+	u32 tun_id = flow->tunnel_id >> ENC_OPTS_BITS;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5_eswitch *esw;
+
+	esw = flow->priv->mdev->priv.eswitch;
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	if (tun_id)
+		mapping_remove(uplink_priv->tunnel_mapping, tun_id);
+	if (enc_opts_id)
+		mapping_remove(uplink_priv->tunnel_enc_opts_mapping,
+			       enc_opts_id);
+}
 
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
+			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
 			     struct flow_cls_offload *f,
-			     struct net_device *filter_dev, u8 *match_level)
+			     struct net_device *filter_dev,
+			     u8 *match_level,
+			     bool *match_inner)
 {
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
+	bool needs_mapping, sets_mapping;
 	int err;
 
-	err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f, match_level);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "failed to parse tunnel attributes");
-		return err;
+	if (!mlx5e_is_eswitch_flow(flow))
+		return -EOPNOTSUPP;
+
+	needs_mapping = !!flow->esw_attr->chain;
+	sets_mapping = !flow->esw_attr->chain && flow_has_tc_fwd_action(f);
+	*match_inner = !needs_mapping;
+
+	if ((needs_mapping || sets_mapping) &&
+	    !mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		NL_SET_ERR_MSG(extack,
+			       "Chains on tunnel devices isn't supported without register metadata support");
+		netdev_warn(priv->netdev,
+			    "Chains on tunnel devices isn't supported without register metadata support");
+		return -EOPNOTSUPP;
 	}
 
-	return 0;
+	if (!flow->esw_attr->chain) {
+		err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
+					 match_level);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to parse tunnel attributes");
+			netdev_warn(priv->netdev,
+				    "Failed to parse tunnel attributes");
+			return err;
+		}
+
+		flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+	}
+
+	if (!needs_mapping && !sets_mapping)
+		return 0;
+
+	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev);
 }
 
-static void *get_match_headers_criteria(u32 flags,
-					struct mlx5_flow_spec *spec)
+static void *get_match_inner_headers_criteria(struct mlx5_flow_spec *spec)
 {
-	return (flags & MLX5_FLOW_CONTEXT_ACTION_DECAP) ?
-		MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			     inner_headers) :
-		MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			     outer_headers);
+	return MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    inner_headers);
+}
+
+static void *get_match_inner_headers_value(struct mlx5_flow_spec *spec)
+{
+	return MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    inner_headers);
+}
+
+static void *get_match_outer_headers_criteria(struct mlx5_flow_spec *spec)
+{
+	return MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    outer_headers);
+}
+
+static void *get_match_outer_headers_value(struct mlx5_flow_spec *spec)
+{
+	return MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers);
 }
 
 static void *get_match_headers_value(u32 flags,
 				     struct mlx5_flow_spec *spec)
 {
 	return (flags & MLX5_FLOW_CONTEXT_ACTION_DECAP) ?
-		MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			     inner_headers) :
-		MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			     outer_headers);
+		get_match_inner_headers_value(spec) :
+		get_match_outer_headers_value(spec);
+}
+
+static void *get_match_headers_criteria(u32 flags,
+					struct mlx5_flow_spec *spec)
+{
+	return (flags & MLX5_FLOW_CONTEXT_ACTION_DECAP) ?
+		get_match_inner_headers_criteria(spec) :
+		get_match_outer_headers_criteria(spec);
 }
 
 static int __parse_cls_flower(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec,
 			      struct flow_cls_offload *f,
 			      struct net_device *filter_dev,
@@ -1729,6 +2050,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
+	int err;
 
 	match_level = outer_match_level;
 
@@ -1758,18 +2080,22 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	}
 
 	if (mlx5e_get_tc_tun(filter_dev)) {
-		if (parse_tunnel_attr(priv, spec, f, filter_dev,
-				      outer_match_level))
-			return -EOPNOTSUPP;
+		bool match_inner = false;
 
-		/* At this point, header pointers should point to the inner
-		 * headers, outer header were already set by parse_tunnel_attr
-		 */
-		match_level = inner_match_level;
-		headers_c = get_match_headers_criteria(MLX5_FLOW_CONTEXT_ACTION_DECAP,
-						       spec);
-		headers_v = get_match_headers_value(MLX5_FLOW_CONTEXT_ACTION_DECAP,
-						    spec);
+		err = parse_tunnel_attr(priv, flow, spec, f, filter_dev,
+					outer_match_level, &match_inner);
+		if (err)
+			return err;
+
+		if (match_inner) {
+			/* header pointers should point to the inner headers
+			 * if the packet was decapsulated already.
+			 * outer headers are set by parse_tunnel_attr.
+			 */
+			match_level = inner_match_level;
+			headers_c = get_match_inner_headers_criteria(spec);
+			headers_v = get_match_inner_headers_value(spec);
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
@@ -2082,8 +2408,8 @@ static int parse_cls_flower(struct mlx5e_priv *priv,
 	inner_match_level = MLX5_MATCH_NONE;
 	outer_match_level = MLX5_MATCH_NONE;
 
-	err = __parse_cls_flower(priv, spec, f, filter_dev, &inner_match_level,
-				 &outer_match_level);
+	err = __parse_cls_flower(priv, flow, spec, f, filter_dev,
+				 &inner_match_level, &outer_match_level);
 	non_tunnel_match_level = (inner_match_level == MLX5_MATCH_NONE) ?
 				 outer_match_level : inner_match_level;
 
@@ -2637,7 +2963,7 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 				    struct netlink_ext_ack *extack)
 {
 	struct net_device *filter_dev = parse_attr->filter_dev;
-	bool drop_action, decap_action, pop_action;
+	bool drop_action, pop_action;
 	u32 actions;
 
 	if (mlx5e_is_eswitch_flow(flow))
@@ -2646,17 +2972,15 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 		actions = flow->nic_attr->action;
 
 	drop_action = actions & MLX5_FLOW_CONTEXT_ACTION_DROP;
-	decap_action = actions & MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	pop_action = actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 
 	if (flow_flag_test(flow, EGRESS) && !drop_action) {
-		/* If no drop, we must decap (vxlan) or pop (vlan) */
-		if (mlx5e_get_tc_tun(filter_dev) && !decap_action)
-			return false;
-		else if (is_vlan_dev(filter_dev) && !pop_action)
+		/* We only support filters on tunnel device, or on vlan
+		 * devices if they have pop/drop action
+		 */
+		if (!mlx5e_get_tc_tun(filter_dev) ||
+		    (is_vlan_dev(filter_dev) && !pop_action))
 			return false;
-		else
-			return false; /* Sanity */
 	}
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
@@ -3209,9 +3533,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
+	bool encap = false, decap = false;
+	u32 action = attr->action;
 	int err, i, if_count = 0;
-	bool encap = false;
-	u32 action = 0;
 
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
@@ -3388,7 +3712,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			attr->split_count = attr->out_count;
 			break;
 		case FLOW_ACTION_TUNNEL_DECAP:
-			action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+			decap = true;
 			break;
 		case FLOW_ACTION_GOTO: {
 			u32 dest_chain = act->chain_index;
@@ -3452,6 +3776,22 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 
 	if (attr->dest_chain) {
+		if (decap) {
+			/* It can be supported if we'll create a mapping for
+			 * the tunnel device only (without tunnel), and set
+			 * this tunnel id with this decap flow.
+			 *
+			 * On restore (miss), we'll just set this saved tunnel
+			 * device.
+			 */
+
+			NL_SET_ERR_MSG(extack,
+				       "Decap with goto isn't supported");
+			netdev_warn(priv->netdev,
+				    "Decap with goto isn't supported");
+			return -EOPNOTSUPP;
+		}
+
 		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 			NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
 			return -EOPNOTSUPP;
@@ -4166,12 +4506,55 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 {
-	return rhashtable_init(tc_ht, &tc_ht_params);
+	const size_t sz_enc_opts = sizeof(struct flow_dissector_key_enc_opts);
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *priv;
+	struct mapping_ctx *mapping;
+	int err;
+
+	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
+	priv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
+
+	mapping = mapping_idr_create(sizeof(struct tunnel_match_key),
+				     TUNNEL_INFO_BITS_MASK, true);
+	if (IS_ERR(mapping)) {
+		err = PTR_ERR(mapping);
+		goto err_tun_mapping;
+	}
+	uplink_priv->tunnel_mapping = mapping;
+
+	mapping = mapping_idr_create(sz_enc_opts, ENC_OPTS_BITS_MASK, true);
+	if (IS_ERR(mapping)) {
+		err = PTR_ERR(mapping);
+		goto err_enc_opts_mapping;
+	}
+	uplink_priv->tunnel_enc_opts_mapping = mapping;
+
+	err = rhashtable_init(tc_ht, &tc_ht_params);
+	if (err)
+		goto err_ht_init;
+
+	return err;
+
+err_ht_init:
+	mapping_idr_destroy(uplink_priv->tunnel_enc_opts_mapping);
+err_enc_opts_mapping:
+	mapping_idr_destroy(uplink_priv->tunnel_mapping);
+err_tun_mapping:
+	netdev_warn(priv->netdev,
+		    "Failed to initialize tc (eswitch), err: %d", err);
+	return err;
 }
 
 void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 {
+	struct mlx5_rep_uplink_priv *uplink_priv;
+
 	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
+
+	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
+	mapping_idr_destroy(uplink_priv->tunnel_enc_opts_mapping);
+	mapping_idr_destroy(uplink_priv->tunnel_mapping);
 }
 
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 3848ec7..2fab76b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -93,12 +93,15 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 
 enum mlx5e_tc_attr_to_reg {
 	CHAIN_TO_REG,
+	TUNNEL_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
 	int mfield; /* rewrite field */
 	int moffset; /* offset of mfield */
 	int mlen; /* bytes to rewrite/match */
+
+	int soffset; /* offset of spec for match */
 };
 
 extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
@@ -114,6 +117,16 @@ struct mlx5e_tc_mod_hdr_acts {
 	void *actions;
 };
 
+int mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
+			      struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			      enum mlx5e_tc_attr_to_reg type,
+			      u32 data);
+
+void mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
+				 enum mlx5e_tc_attr_to_reg type,
+				 u32 data,
+				 u32 mask);
+
 int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 			  int namespace,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
-- 
1.8.3.1

