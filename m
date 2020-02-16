Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4F160348
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBPKCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:02:04 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52999 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727720AbgBPKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:47 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce7007834;
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
Subject: [PATCH net-next-mlx5 v3 11/16] net/mlx5e: Allow re-allocating mod header actions
Date:   Sun, 16 Feb 2020 12:01:31 +0200
Message-Id: <1581847296-19194-12-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the size of the mod header actions array is deduced from the
number of parsed TC header rewrite actions. However, mod header actions
are also used for setting HW register values. Support the dynamic
reallocation of the mod header array as a pre-step for adding HW
registers mod actions.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 120 +++++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h |  11 +++
 2 files changed, 76 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ac1ecf8..d844c05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -144,9 +144,7 @@ struct mlx5e_tc_flow_parse_attr {
 	const struct ip_tunnel_info *tun_info[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct net_device *filter_dev;
 	struct mlx5_flow_spec spec;
-	int num_mod_hdr_actions;
-	int max_mod_hdr_actions;
-	void *mod_hdr_actions;
+	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
 	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
 };
 
@@ -369,10 +367,10 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 	struct mod_hdr_key key;
 	u32 hash_key;
 
-	num_actions  = parse_attr->num_mod_hdr_actions;
+	num_actions  = parse_attr->mod_hdr_acts.num_actions;
 	actions_size = MLX5_MH_ACT_SZ * num_actions;
 
-	key.actions = parse_attr->mod_hdr_actions;
+	key.actions = parse_attr->mod_hdr_acts.actions;
 	key.num_actions = num_actions;
 
 	hash_key = hash_mod_hdr_info(&key);
@@ -962,7 +960,7 @@ static void mlx5e_hairpin_flow_del(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
 		flow_act.modify_hdr = attr->modify_hdr;
-		kfree(parse_attr->mod_hdr_actions);
+		dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 		if (err)
 			return err;
 	}
@@ -1228,7 +1226,7 @@ static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-		kfree(parse_attr->mod_hdr_actions);
+		dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 		if (err)
 			return err;
 	}
@@ -2391,25 +2389,26 @@ static bool cmp_val_mask(void *valp, void *maskp, void *matchvalp,
 	OFFLOAD(UDP_DPORT, 16, U16_MAX, udp.dest,   0, udp_dport),
 };
 
-/* On input attr->max_mod_hdr_actions tells how many HW actions can be parsed at
- * max from the SW pedit action. On success, attr->num_mod_hdr_actions
- * says how many HW actions were actually parsed.
- */
-static int offload_pedit_fields(struct pedit_headers_action *hdrs,
+static int offload_pedit_fields(struct mlx5e_priv *priv,
+				int namespace,
+				struct pedit_headers_action *hdrs,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
 				u32 *action_flags,
 				struct netlink_ext_ack *extack)
 {
 	struct pedit_headers *set_masks, *add_masks, *set_vals, *add_vals;
-	int i, action_size, nactions, max_actions, first, last, next_z;
+	int i, action_size, first, last, next_z;
 	void *headers_c, *headers_v, *action, *vals_p;
 	u32 *s_masks_p, *a_masks_p, s_mask, a_mask;
+	struct mlx5e_tc_mod_hdr_acts *mod_acts;
 	struct mlx5_fields *f;
 	unsigned long mask;
 	__be32 mask_be32;
 	__be16 mask_be16;
+	int err;
 	u8 cmd;
 
+	mod_acts = &parse_attr->mod_hdr_acts;
 	headers_c = get_match_headers_criteria(*action_flags, &parse_attr->spec);
 	headers_v = get_match_headers_value(*action_flags, &parse_attr->spec);
 
@@ -2419,11 +2418,6 @@ static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 	add_vals = &hdrs[1].vals;
 
 	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
-	action = parse_attr->mod_hdr_actions +
-		 parse_attr->num_mod_hdr_actions * action_size;
-
-	max_actions = parse_attr->max_mod_hdr_actions;
-	nactions = parse_attr->num_mod_hdr_actions;
 
 	for (i = 0; i < ARRAY_SIZE(fields); i++) {
 		bool skip;
@@ -2449,13 +2443,6 @@ static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 			return -EOPNOTSUPP;
 		}
 
-		if (nactions == max_actions) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "too many pedit actions, can't offload");
-			printk(KERN_WARNING "mlx5: parsed %d pedit actions, can't do more\n", nactions);
-			return -EOPNOTSUPP;
-		}
-
 		skip = false;
 		if (s_mask) {
 			void *match_mask = headers_c + f->match_offset;
@@ -2502,6 +2489,18 @@ static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 			return -EOPNOTSUPP;
 		}
 
+		err = alloc_mod_hdr_actions(priv->mdev, namespace, mod_acts);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "too many pedit actions, can't offload");
+			mlx5_core_warn(priv->mdev,
+				       "mlx5: parsed %d pedit actions, can't do more\n",
+				       mod_acts->num_actions);
+			return err;
+		}
+
+		action = mod_acts->actions +
+			 (mod_acts->num_actions * action_size);
 		MLX5_SET(set_action_in, action, action_type, cmd);
 		MLX5_SET(set_action_in, action, field, f->field);
 
@@ -2524,11 +2523,9 @@ static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 		else if (f->field_bsize == 8)
 			MLX5_SET(set_action_in, action, data, *(u8 *)vals_p >> first);
 
-		action += action_size;
-		nactions++;
+		++mod_acts->num_actions;
 	}
 
-	parse_attr->num_mod_hdr_actions = nactions;
 	return 0;
 }
 
@@ -2541,29 +2538,48 @@ static int mlx5e_flow_namespace_max_modify_action(struct mlx5_core_dev *mdev,
 		return MLX5_CAP_FLOWTABLE_NIC_RX(mdev, max_modify_header_actions);
 }
 
-static int alloc_mod_hdr_actions(struct mlx5e_priv *priv,
-				 struct pedit_headers_action *hdrs,
-				 int namespace,
-				 struct mlx5e_tc_flow_parse_attr *parse_attr)
+int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
+			  int namespace,
+			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
-	int nkeys, action_size, max_actions;
+	int action_size, new_num_actions, max_hw_actions;
+	size_t new_sz, old_sz;
+	void *ret;
 
-	nkeys = hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits +
-		hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits;
-	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
+	if (mod_hdr_acts->num_actions < mod_hdr_acts->max_actions)
+		return 0;
 
-	max_actions = mlx5e_flow_namespace_max_modify_action(priv->mdev, namespace);
-	/* can get up to crazingly 16 HW actions in 32 bits pedit SW key */
-	max_actions = min(max_actions, nkeys * 16);
+	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
 
-	parse_attr->mod_hdr_actions = kcalloc(max_actions, action_size, GFP_KERNEL);
-	if (!parse_attr->mod_hdr_actions)
+	max_hw_actions = mlx5e_flow_namespace_max_modify_action(mdev,
+								namespace);
+	new_num_actions = min(max_hw_actions,
+			      mod_hdr_acts->actions ?
+			      mod_hdr_acts->max_actions * 2 : 1);
+	if (mod_hdr_acts->max_actions == new_num_actions)
+		return -ENOSPC;
+
+	new_sz = action_size * new_num_actions;
+	old_sz = mod_hdr_acts->max_actions * action_size;
+	ret = krealloc(mod_hdr_acts->actions, new_sz, GFP_KERNEL);
+	if (!ret)
 		return -ENOMEM;
 
-	parse_attr->max_mod_hdr_actions = max_actions;
+	memset(ret + old_sz, 0, new_sz - old_sz);
+	mod_hdr_acts->actions = ret;
+	mod_hdr_acts->max_actions = new_num_actions;
+
 	return 0;
 }
 
+void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
+{
+	kfree(mod_hdr_acts->actions);
+	mod_hdr_acts->actions = NULL;
+	mod_hdr_acts->num_actions = 0;
+	mod_hdr_acts->max_actions = 0;
+}
+
 static const struct pedit_headers zero_masks = {};
 
 static int parse_tc_pedit_action(struct mlx5e_priv *priv,
@@ -2616,13 +2632,8 @@ static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 	int err;
 	u8 cmd;
 
-	if (!parse_attr->mod_hdr_actions) {
-		err = alloc_mod_hdr_actions(priv, hdrs, namespace, parse_attr);
-		if (err)
-			goto out_err;
-	}
-
-	err = offload_pedit_fields(hdrs, parse_attr, action_flags, extack);
+	err = offload_pedit_fields(priv, namespace, hdrs, parse_attr,
+				   action_flags, extack);
 	if (err < 0)
 		goto out_dealloc_parsed_actions;
 
@@ -2642,8 +2653,7 @@ static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 	return 0;
 
 out_dealloc_parsed_actions:
-	kfree(parse_attr->mod_hdr_actions);
-out_err:
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	return err;
 }
 
@@ -2976,9 +2986,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		/* in case all pedit actions are skipped, remove the MOD_HDR
 		 * flag.
 		 */
-		if (parse_attr->num_mod_hdr_actions == 0) {
+		if (parse_attr->mod_hdr_acts.num_actions == 0) {
 			action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			kfree(parse_attr->mod_hdr_actions);
+			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 		}
 	}
 
@@ -3564,9 +3574,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		 * flag. we might have set split_count either by pedit or
 		 * pop/push. if there is no pop/push either, reset it too.
 		 */
-		if (parse_attr->num_mod_hdr_actions == 0) {
+		if (parse_attr->mod_hdr_acts.num_actions == 0) {
 			action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			kfree(parse_attr->mod_hdr_actions);
+			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 			if (!((action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
 			      (action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)))
 				attr->split_count = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 9d5fcf6..3848ec7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -108,6 +108,17 @@ bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 
 bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
 
+struct mlx5e_tc_mod_hdr_acts {
+	int num_actions;
+	int max_actions;
+	void *actions;
+};
+
+int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
+			  int namespace,
+			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
+void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
-- 
1.8.3.1

