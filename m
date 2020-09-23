Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F8F275169
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgIWGZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgIWGYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:45 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779D4221F0;
        Wed, 23 Sep 2020 06:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842282;
        bh=3wEedYw7XqK/EAkB0kgLKqhA48mgKut0rwa+HVc3R+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqUEreLxh7ITH4GBa5h5MYX06v4bQpf+7Gr16JC1iJrVgBT9x3hzj+Lsp25yGxLIq
         SCot+zTb7qpfQPMyRZP7x9dNCNPRoraWQAutuyJTsCw3zqxVqbGSVr+4OWuQYcQDja
         DX8zHHS+pnnkyu3/rO+P3D6R/FL3vQak9lAC5nok=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Refactor tc flow attributes structure
Date:   Tue, 22 Sep 2020 23:24:28 -0700
Message-Id: <20200923062438.15997-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

In order to support chains and connection tracking offload for
nic flows, there's a need to introduce a common flow attributes
struct so that these features can be agnostic and have access to
a single attributes struct, regardless of the flow type.

Therefore, a new tc flow attributes format is introduced to allow
access to attributes that are common to eswitch and nic flows.

The common attributes will always get allocated for the new flows,
regardless of their type, while the type specific attributes are
separated into different structs and will be allocated based on the
flow type to avoid memory waste.

When allocating the flow attributes the caller provides the flow
steering namespace and according the namespace type the additional
space for the extra, type specific, attributes is determined and
added to the total attribute allocation size.

In addition, the attributes that are going to be common to both
flow types are moved to the common attributes struct.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

fixup! net/mlx5: Refactor tc flow attributes structure

Init the parse_attr pointer in the beginning of parse_tc_fdb_actions
so it will be valid for the entire method.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  99 ++++--
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 304 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  36 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  27 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 150 +++++----
 .../mlx5/core/eswitch_offloads_termtbl.c      |   8 +-
 7 files changed, 376 insertions(+), 262 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 579f888c22ab..9509f8674e5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -55,8 +55,8 @@ struct mlx5_tc_ct_priv {
 };
 
 struct mlx5_ct_flow {
-	struct mlx5_esw_flow_attr pre_ct_attr;
-	struct mlx5_esw_flow_attr post_ct_attr;
+	struct mlx5_flow_attr *pre_ct_attr;
+	struct mlx5_flow_attr *post_ct_attr;
 	struct mlx5_flow_handle *pre_ct_rule;
 	struct mlx5_flow_handle *post_ct_rule;
 	struct mlx5_ct_ft *ft;
@@ -67,7 +67,7 @@ struct mlx5_ct_flow {
 struct mlx5_ct_zone_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5e_mod_hdr_handle *mh;
-	struct mlx5_esw_flow_attr attr;
+	struct mlx5_flow_attr *attr;
 	bool nat;
 };
 
@@ -400,7 +400,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 			  bool nat)
 {
 	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
-	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
+	struct mlx5_flow_attr *attr = zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 
 	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
@@ -409,6 +409,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
 			     &esw->offloads.mod_hdr, zone_rule->mh);
 	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	kfree(attr);
 }
 
 static void
@@ -588,7 +589,7 @@ mlx5_tc_ct_entry_create_nat(struct mlx5_tc_ct_priv *ct_priv,
 
 static int
 mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
-				struct mlx5_esw_flow_attr *attr,
+				struct mlx5_flow_attr *attr,
 				struct flow_rule *flow_rule,
 				struct mlx5e_mod_hdr_handle **mh,
 				u8 zone_restore_id, bool nat)
@@ -650,9 +651,9 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 			  bool nat, u8 zone_restore_id)
 {
 	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
-	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_spec *spec = NULL;
+	struct mlx5_flow_attr *attr;
 	int err;
 
 	zone_rule->nat = nat;
@@ -661,6 +662,12 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	if (!spec)
 		return -ENOMEM;
 
+	attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!attr) {
+		err = -ENOMEM;
+		goto err_attr;
+	}
+
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
 					      &zone_rule->mh,
 					      zone_restore_id, nat);
@@ -674,7 +681,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 		       MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	attr->dest_chain = 0;
 	attr->dest_ft = ct_priv->post_ct;
-	attr->fdb = nat ? ct_priv->ct_nat : ct_priv->ct;
+	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
 	attr->outer_match_level = MLX5_MATCH_L4;
 	attr->counter = entry->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
@@ -691,6 +698,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 		goto err_rule;
 	}
 
+	zone_rule->attr = attr;
+
 	kfree(spec);
 	ct_dbg("Offloaded ct entry rule in zone %d", entry->tuple.zone);
 
@@ -701,6 +710,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 			     &esw->offloads.mod_hdr, zone_rule->mh);
 	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
+	kfree(attr);
+err_attr:
 	kfree(spec);
 	return err;
 }
@@ -1056,7 +1067,7 @@ mlx5_tc_ct_match_add(struct mlx5e_priv *priv,
 
 int
 mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
@@ -1429,14 +1440,14 @@ static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			  struct mlx5e_tc_flow *flow,
 			  struct mlx5_flow_spec *orig_spec,
-			  struct mlx5_esw_flow_attr *attr)
+			  struct mlx5_flow_attr *attr)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	bool nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
 	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
 	struct mlx5_flow_spec *post_ct_spec = NULL;
 	struct mlx5_eswitch *esw = ct_priv->esw;
-	struct mlx5_esw_flow_attr *pre_ct_attr;
+	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_ct_flow *ct_flow;
@@ -1471,10 +1482,22 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	}
 	ct_flow->fte_id = fte_id;
 
-	/* Base esw attributes of both rules on original rule attribute */
-	pre_ct_attr = &ct_flow->pre_ct_attr;
-	memcpy(pre_ct_attr, attr, sizeof(*attr));
-	memcpy(&ct_flow->post_ct_attr, attr, sizeof(*attr));
+	/* Base flow attributes of both rules on original rule attribute */
+	ct_flow->pre_ct_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!ct_flow->pre_ct_attr) {
+		err = -ENOMEM;
+		goto err_alloc_pre;
+	}
+
+	ct_flow->post_ct_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!ct_flow->post_ct_attr) {
+		err = -ENOMEM;
+		goto err_alloc_post;
+	}
+
+	pre_ct_attr = ct_flow->pre_ct_attr;
+	memcpy(pre_ct_attr, attr, ESW_FLOW_ATTR_SZ);
+	memcpy(ct_flow->post_ct_attr, attr, ESW_FLOW_ATTR_SZ);
 
 	/* Modify the original rule's action to fwd and modify, leave decap */
 	pre_ct_attr->action = attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP;
@@ -1541,15 +1564,15 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 				    fte_id, MLX5_FTE_ID_MASK);
 
 	/* Put post_ct rule on post_ct fdb */
-	ct_flow->post_ct_attr.chain = 0;
-	ct_flow->post_ct_attr.prio = 0;
-	ct_flow->post_ct_attr.fdb = ct_priv->post_ct;
+	ct_flow->post_ct_attr->chain = 0;
+	ct_flow->post_ct_attr->prio = 0;
+	ct_flow->post_ct_attr->ft = ct_priv->post_ct;
 
-	ct_flow->post_ct_attr.inner_match_level = MLX5_MATCH_NONE;
-	ct_flow->post_ct_attr.outer_match_level = MLX5_MATCH_NONE;
-	ct_flow->post_ct_attr.action &= ~(MLX5_FLOW_CONTEXT_ACTION_DECAP);
+	ct_flow->post_ct_attr->inner_match_level = MLX5_MATCH_NONE;
+	ct_flow->post_ct_attr->outer_match_level = MLX5_MATCH_NONE;
+	ct_flow->post_ct_attr->action &= ~(MLX5_FLOW_CONTEXT_ACTION_DECAP);
 	rule = mlx5_eswitch_add_offloaded_rule(esw, post_ct_spec,
-					       &ct_flow->post_ct_attr);
+					       ct_flow->post_ct_attr);
 	ct_flow->post_ct_rule = rule;
 	if (IS_ERR(ct_flow->post_ct_rule)) {
 		err = PTR_ERR(ct_flow->post_ct_rule);
@@ -1577,13 +1600,17 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 
 err_insert_orig:
 	mlx5_eswitch_del_offloaded_rule(ct_priv->esw, ct_flow->post_ct_rule,
-					&ct_flow->post_ct_attr);
+					ct_flow->post_ct_attr);
 err_insert_post_ct:
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 err_mapping:
 	dealloc_mod_hdr_actions(&pre_mod_acts);
 	mlx5_chains_put_chain_mapping(esw_chains(esw), ct_flow->chain_mapping);
 err_get_chain:
+	kfree(ct_flow->post_ct_attr);
+err_alloc_post:
+	kfree(ct_flow->pre_ct_attr);
+err_alloc_pre:
 	idr_remove(&ct_priv->fte_ids, fte_id);
 err_idr:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
@@ -1597,12 +1624,12 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 				struct mlx5_flow_spec *orig_spec,
-				struct mlx5_esw_flow_attr *attr,
+				struct mlx5_flow_attr *attr,
 				struct mlx5e_tc_mod_hdr_acts *mod_acts)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct mlx5_eswitch *esw = ct_priv->esw;
-	struct mlx5_esw_flow_attr *pre_ct_attr;
+	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_ct_flow *ct_flow;
@@ -1613,8 +1640,13 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 		return ERR_PTR(-ENOMEM);
 
 	/* Base esw attributes on original rule attribute */
-	pre_ct_attr = &ct_flow->pre_ct_attr;
-	memcpy(pre_ct_attr, attr, sizeof(*attr));
+	pre_ct_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!pre_ct_attr) {
+		err = -ENOMEM;
+		goto err_attr;
+	}
+
+	memcpy(pre_ct_attr, attr, ESW_FLOW_ATTR_SZ);
 
 	err = mlx5_tc_ct_entry_set_registers(ct_priv, mod_acts, 0, 0, 0, 0);
 	if (err) {
@@ -1644,6 +1676,7 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 	}
 
 	attr->ct_attr.ct_flow = ct_flow;
+	ct_flow->pre_ct_attr = pre_ct_attr;
 	ct_flow->pre_ct_rule = rule;
 	return rule;
 
@@ -1652,6 +1685,10 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
 err_set_registers:
 	netdev_warn(priv->netdev,
 		    "Failed to offload ct clear flow, err %d\n", err);
+	kfree(pre_ct_attr);
+err_attr:
+	kfree(ct_flow);
+
 	return ERR_PTR(err);
 }
 
@@ -1659,7 +1696,7 @@ struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
 	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
@@ -1684,7 +1721,7 @@ static void
 __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct mlx5_ct_flow *ct_flow)
 {
-	struct mlx5_esw_flow_attr *pre_ct_attr = &ct_flow->pre_ct_attr;
+	struct mlx5_flow_attr *pre_ct_attr = ct_flow->pre_ct_attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 
 	mlx5_eswitch_del_offloaded_rule(esw, ct_flow->pre_ct_rule,
@@ -1693,18 +1730,20 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 
 	if (ct_flow->post_ct_rule) {
 		mlx5_eswitch_del_offloaded_rule(esw, ct_flow->post_ct_rule,
-						&ct_flow->post_ct_attr);
+						ct_flow->post_ct_attr);
 		mlx5_chains_put_chain_mapping(esw_chains(esw), ct_flow->chain_mapping);
 		idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
 		mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 	}
 
+	kfree(ct_flow->pre_ct_attr);
+	kfree(ct_flow->post_ct_attr);
 	kfree(ct_flow);
 }
 
 void
 mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow,
-		       struct mlx5_esw_flow_attr *attr)
+		       struct mlx5_flow_attr *attr)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct mlx5_ct_flow *ct_flow = attr->ct_attr.ct_flow;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 708c216325d3..2bfe930faa3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -10,7 +10,7 @@
 
 #include "en.h"
 
-struct mlx5_esw_flow_attr;
+struct mlx5_flow_attr;
 struct mlx5e_tc_mod_hdr_acts;
 struct mlx5_rep_uplink_priv;
 struct mlx5e_tc_flow;
@@ -101,7 +101,7 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 			    struct mlx5_flow_spec *spec);
 int
 mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack);
 
@@ -109,12 +109,12 @@ struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 void
 mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
-		       struct mlx5_esw_flow_attr *attr);
+		       struct mlx5_flow_attr *attr);
 
 bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
@@ -162,7 +162,7 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
@@ -175,7 +175,7 @@ static inline struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
 	return ERR_PTR(-EOPNOTSUPP);
@@ -184,7 +184,7 @@ mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 static inline void
 mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
-		       struct mlx5_esw_flow_attr *attr)
+		       struct mlx5_flow_attr *attr)
 {
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4b810ad9d6d6..a54821107566 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -70,17 +70,6 @@
 
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
-
-struct mlx5_nic_flow_attr {
-	u32 action;
-	u32 flow_tag;
-	struct mlx5_modify_hdr *modify_hdr;
-	u32 hairpin_tirn;
-	u8 match_level;
-	struct mlx5_flow_table	*hairpin_ft;
-	struct mlx5_fc		*counter;
-};
-
 #define MLX5E_TC_FLOW_BASE (MLX5E_TC_FLAG_LAST_EXPORTED_BIT + 1)
 
 enum {
@@ -154,11 +143,7 @@ struct mlx5e_tc_flow {
 	struct rcu_head		rcu_head;
 	struct completion	init_done;
 	int tunnel_id; /* the mapped tunnel id of this flow */
-
-	union {
-		struct mlx5_esw_flow_attr esw_attr[0];
-		struct mlx5_nic_flow_attr nic_attr[0];
-	};
+	struct mlx5_flow_attr *attr;
 };
 
 struct mlx5e_tc_flow_parse_attr {
@@ -416,10 +401,7 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 		return PTR_ERR(mh);
 
 	modify_hdr = mlx5e_mod_hdr_get(mh);
-	if (mlx5e_is_eswitch_flow(flow))
-		flow->esw_attr->modify_hdr = modify_hdr;
-	else
-		flow->nic_attr->modify_hdr = modify_hdr;
+	flow->attr->modify_hdr = modify_hdr;
 	flow->mh = mh;
 
 	return 0;
@@ -859,9 +841,9 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 attach_flow:
 	if (hpe->hp->num_channels > 1) {
 		flow_flag_set(flow, HAIRPIN_RSS);
-		flow->nic_attr->hairpin_ft = hpe->hp->ttc.ft.t;
+		flow->attr->nic_attr->hairpin_ft = hpe->hp->ttc.ft.t;
 	} else {
-		flow->nic_attr->hairpin_tirn = hpe->hp->tirn;
+		flow->attr->nic_attr->hairpin_tirn = hpe->hp->tirn;
 	}
 
 	flow->hpe = hpe;
@@ -894,9 +876,10 @@ static void mlx5e_hairpin_flow_del(struct mlx5e_priv *priv,
 struct mlx5_flow_handle *
 mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			     struct mlx5_flow_spec *spec,
-			     struct mlx5_nic_flow_attr *attr)
+			     struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_context *flow_context = &spec->flow_context;
+	struct mlx5_nic_flow_attr *nic_attr = attr->nic_attr;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {
@@ -907,15 +890,15 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	int dest_ix = 0;
 
 	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
-	flow_context->flow_tag = attr->flow_tag;
+	flow_context->flow_tag = nic_attr->flow_tag;
 
-	if (attr->hairpin_ft) {
+	if (nic_attr->hairpin_ft) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-		dest[dest_ix].ft = attr->hairpin_ft;
+		dest[dest_ix].ft = nic_attr->hairpin_ft;
 		dest_ix++;
-	} else if (attr->hairpin_tirn) {
+	} else if (nic_attr->hairpin_tirn) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-		dest[dest_ix].tir_num = attr->hairpin_tirn;
+		dest[dest_ix].tir_num = nic_attr->hairpin_tirn;
 		dest_ix++;
 	} else if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
@@ -947,7 +930,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&tc->t_lock);
 
-	if (attr->match_level != MLX5_MATCH_NONE)
+	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 
 	rule = mlx5_add_flow_rules(tc->t, spec,
@@ -964,7 +947,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		      struct mlx5e_tc_flow *flow,
 		      struct netlink_ext_ack *extack)
 {
-	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_core_dev *dev = priv->mdev;
 	struct mlx5_fc *counter = NULL;
 	int err;
@@ -1005,7 +988,7 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
-	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 
 	if (!IS_ERR_OR_NULL(flow->rule[0]))
@@ -1025,6 +1008,8 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 
 	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
+
+	kfree(flow->attr);
 }
 
 static void mlx5e_detach_encap(struct mlx5e_priv *priv,
@@ -1047,7 +1032,7 @@ static struct mlx5_flow_handle *
 mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 			   struct mlx5e_tc_flow *flow,
 			   struct mlx5_flow_spec *spec,
-			   struct mlx5_esw_flow_attr *attr)
+			   struct mlx5_flow_attr *attr)
 {
 	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct mlx5_flow_handle *rule;
@@ -1063,7 +1048,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	if (IS_ERR(rule))
 		return rule;
 
-	if (attr->split_count) {
+	if (attr->esw_attr->split_count) {
 		flow->rule[1] = mlx5_eswitch_add_fwd_rule(esw, spec, attr);
 		if (IS_ERR(flow->rule[1])) {
 			mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
@@ -1077,7 +1062,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 static void
 mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 			     struct mlx5e_tc_flow *flow,
-			     struct mlx5_esw_flow_attr *attr)
+			     struct mlx5_flow_attr *attr)
 {
 	flow_flag_clear(flow, OFFLOADED);
 
@@ -1086,7 +1071,7 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 		return;
 	}
 
-	if (attr->split_count)
+	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
 	mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
@@ -1097,18 +1082,24 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec)
 {
-	struct mlx5_esw_flow_attr slow_attr;
+	struct mlx5_flow_attr *slow_attr;
 	struct mlx5_flow_handle *rule;
 
-	memcpy(&slow_attr, flow->esw_attr, sizeof(slow_attr));
-	slow_attr.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	slow_attr.split_count = 0;
-	slow_attr.flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!slow_attr)
+		return ERR_PTR(-ENOMEM);
 
-	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, &slow_attr);
+	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
+	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	slow_attr->esw_attr->split_count = 0;
+	slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+
+	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
 	if (!IS_ERR(rule))
 		flow_flag_set(flow, SLOW);
 
+	kfree(slow_attr);
+
 	return rule;
 }
 
@@ -1116,14 +1107,19 @@ static void
 mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 				  struct mlx5e_tc_flow *flow)
 {
-	struct mlx5_esw_flow_attr slow_attr;
+	struct mlx5_flow_attr *slow_attr;
 
-	memcpy(&slow_attr, flow->esw_attr, sizeof(slow_attr));
-	slow_attr.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	slow_attr.split_count = 0;
-	slow_attr.flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
-	mlx5e_tc_unoffload_fdb_rules(esw, flow, &slow_attr);
+	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!slow_attr)
+		mlx5_core_warn(flow->priv->mdev, "Unable to unoffload slow path rule\n");
+
+	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
+	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	slow_attr->esw_attr->split_count = 0;
+	slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
 	flow_flag_clear(flow, SLOW);
+	kfree(slow_attr);
 }
 
 /* Caller must obtain uplink_priv->unready_flows_lock mutex before calling this
@@ -1181,9 +1177,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
-	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
 	struct net_device *out_dev, *encap_dev = NULL;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
+	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_fc *counter = NULL;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *out_priv;
@@ -1223,10 +1220,13 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			return err;
 	}
 
+	parse_attr = attr->parse_attr;
+	esw_attr = attr->esw_attr;
+
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		int mirred_ifindex;
 
-		if (!(attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
+		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
 			continue;
 
 		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
@@ -1239,8 +1239,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 
 		out_priv = netdev_priv(encap_dev);
 		rpriv = out_priv->ppriv;
-		attr->dests[out_index].rep = rpriv->rep;
-		attr->dests[out_index].mdev = out_priv->mdev;
+		esw_attr->dests[out_index].rep = rpriv->rep;
+		esw_attr->dests[out_index].mdev = out_priv->mdev;
 	}
 
 	err = mlx5_eswitch_add_vlan_action(esw, attr);
@@ -1256,7 +1256,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-		counter = mlx5_fc_create(attr->counter_dev, true);
+		counter = mlx5_fc_create(esw_attr->counter_dev, true);
 		if (IS_ERR(counter))
 			return PTR_ERR(counter);
 
@@ -1282,7 +1282,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 
 static bool mlx5_flow_has_geneve_opt(struct mlx5e_tc_flow *flow)
 {
-	struct mlx5_flow_spec *spec = &flow->esw_attr->parse_attr->spec;
+	struct mlx5_flow_spec *spec = &flow->attr->parse_attr->spec;
 	void *headers_v = MLX5_ADDR_OF(fte_match_param,
 				       spec->match_value,
 				       misc_parameters_3);
@@ -1297,7 +1297,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
 	int out_index;
 
 	mlx5e_put_flow_tunnel_id(flow);
@@ -1318,22 +1318,24 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	mlx5_eswitch_del_vlan_action(esw, attr);
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
-		if (attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
+		if (attr->esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
 			mlx5e_detach_encap(priv, flow, out_index);
 			kfree(attr->parse_attr->tun_info[out_index]);
 		}
 	kvfree(attr->parse_attr);
 
-	mlx5_tc_ct_match_del(priv, &flow->esw_attr->ct_attr);
+	mlx5_tc_ct_match_del(priv, &flow->attr->ct_attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
-		mlx5_fc_destroy(attr->counter_dev, attr->counter);
+		mlx5_fc_destroy(attr->esw_attr->counter_dev, attr->counter);
 
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
+
+	kfree(flow->attr);
 }
 
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
@@ -1343,6 +1345,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *attr;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_tc_flow *flow;
 	int err;
@@ -1365,8 +1368,9 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 
 		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
-		esw_attr = flow->esw_attr;
-		spec = &esw_attr->parse_attr->spec;
+		attr = flow->attr;
+		esw_attr = attr->esw_attr;
+		spec = &attr->parse_attr->spec;
 
 		esw_attr->dests[flow->tmp_efi_index].pkt_reformat = e->pkt_reformat;
 		esw_attr->dests[flow->tmp_efi_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
@@ -1386,7 +1390,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 		if (!all_flow_encaps_valid)
 			continue;
 		/* update from slow path rule to encap rule */
-		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, esw_attr);
+		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, attr);
 		if (IS_ERR(rule)) {
 			err = PTR_ERR(rule);
 			mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow, %d\n",
@@ -1406,7 +1410,9 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 			      struct list_head *flow_list)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *attr;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_tc_flow *flow;
 	int err;
@@ -1414,12 +1420,14 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	list_for_each_entry(flow, flow_list, tmp_list) {
 		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
-		spec = &flow->esw_attr->parse_attr->spec;
+		attr = flow->attr;
+		esw_attr = attr->esw_attr;
+		spec = &attr->parse_attr->spec;
 
 		/* update from encap rule to slow path rule */
 		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 		/* mark the flow's encap dest as non-valid */
-		flow->esw_attr->dests[flow->tmp_efi_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_efi_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
 
 		if (IS_ERR(rule)) {
 			err = PTR_ERR(rule);
@@ -1428,7 +1436,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 			continue;
 		}
 
-		mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->esw_attr);
+		mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
 		flow->rule[0] = rule;
 		/* was unset when fast path rule removed */
 		flow_flag_set(flow, OFFLOADED);
@@ -1441,10 +1449,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 
 static struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow)
 {
-	if (mlx5e_is_eswitch_flow(flow))
-		return flow->esw_attr->counter;
-	else
-		return flow->nic_attr->counter;
+	return flow->attr->counter;
 }
 
 /* Takes reference to all flows attached to encap and adds the flows to
@@ -1810,11 +1815,11 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct flow_match_enc_opts enc_opts_match;
 	struct tunnel_match_enc_opts tun_enc_opts;
 	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	bool enc_opts_is_dont_care = true;
@@ -1964,8 +1969,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	if (!mlx5e_is_eswitch_flow(flow))
 		return -EOPNOTSUPP;
 
-	needs_mapping = !!flow->esw_attr->chain;
-	sets_mapping = !flow->esw_attr->chain && flow_has_tc_fwd_action(f);
+	needs_mapping = !!flow->attr->chain;
+	sets_mapping = !flow->attr->chain && flow_has_tc_fwd_action(f);
 	*match_inner = !needs_mapping;
 
 	if ((needs_mapping || sets_mapping) &&
@@ -1977,7 +1982,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow->esw_attr->chain) {
+	if (!flow->attr->chain) {
 		err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
 					 match_level);
 		if (err) {
@@ -1992,7 +1997,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		 * object
 		 */
 		if (!netif_is_bareudp(filter_dev))
-			flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+			flow->attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	}
 
 	if (!needs_mapping && !sets_mapping)
@@ -2495,12 +2500,9 @@ static int parse_cls_flower(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (is_eswitch_flow) {
-		flow->esw_attr->inner_match_level = inner_match_level;
-		flow->esw_attr->outer_match_level = outer_match_level;
-	} else {
-		flow->nic_attr->match_level = non_tunnel_match_level;
-	}
+	flow->attr->inner_match_level = inner_match_level;
+	flow->attr->outer_match_level = outer_match_level;
+
 
 	return err;
 }
@@ -3134,12 +3136,13 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	bool ct_flow = false, ct_clear = false;
 	u32 actions;
 
+	ct_clear = flow->attr->ct_attr.ct_action &
+		TCA_CT_ACT_CLEAR;
+	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
+	actions = flow->attr->action;
+
 	if (mlx5e_is_eswitch_flow(flow)) {
-		actions = flow->esw_attr->action;
-		ct_clear = flow->esw_attr->ct_attr.ct_action &
-			   TCA_CT_ACT_CLEAR;
-		ct_flow = flow_flag_test(flow, CT) && !ct_clear;
-		if (flow->esw_attr->split_count && ct_flow) {
+		if (flow->attr->esw_attr->split_count && ct_flow) {
 			/* All registers used by ct are cleared when using
 			 * split rules.
 			 */
@@ -3147,8 +3150,6 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 					   "Can't offload mirroring with action ct");
 			return false;
 		}
-	} else {
-		actions = flow->nic_attr->action;
 	}
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
@@ -3252,9 +3253,10 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
-	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
 	struct pedit_headers_action hdrs[2] = {};
 	const struct flow_action_entry *act;
+	struct mlx5_nic_flow_attr *nic_attr;
 	u32 action = 0;
 	int err, i;
 
@@ -3265,7 +3267,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
-	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
+	nic_attr = attr->nic_attr;
+
+	nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
@@ -3332,7 +3336,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 				return -EINVAL;
 			}
 
-			attr->flow_tag = mark;
+			nic_attr->flow_tag = mark;
 			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 			}
 			break;
@@ -3489,8 +3493,8 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      bool *encap_valid)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
 	struct encap_key key;
 	struct mlx5e_encap_entry *e;
@@ -3576,8 +3580,8 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	flow->encaps[out_index].index = out_index;
 	*encap_dev = e->out_dev;
 	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
-		attr->dests[out_index].pkt_reformat = e->pkt_reformat;
-		attr->dests[out_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
+		attr->esw_attr->dests[out_index].pkt_reformat = e->pkt_reformat;
+		attr->esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
 		*encap_valid = true;
 	} else {
 		*encap_valid = false;
@@ -3604,14 +3608,14 @@ static int mlx5e_attach_decap(struct mlx5e_priv *priv,
 			      struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_decap_entry *d;
 	struct mlx5e_decap_key key;
 	uintptr_t hash_key;
 	int err = 0;
 
-	parse_attr = attr->parse_attr;
+	parse_attr = flow->attr->parse_attr;
 	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "encap header larger than max supported");
@@ -3753,7 +3757,7 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 }
 
 static int add_vlan_push_action(struct mlx5e_priv *priv,
-				struct mlx5_esw_flow_attr *attr,
+				struct mlx5_flow_attr *attr,
 				struct net_device **out_dev,
 				u32 *action)
 {
@@ -3766,7 +3770,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 	};
 	int err;
 
-	err = parse_tc_vlan_action(priv, &vlan_act, attr, action);
+	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
 	if (err)
 		return err;
 
@@ -3779,7 +3783,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 }
 
 static int add_vlan_pop_action(struct mlx5e_priv *priv,
-			       struct mlx5_esw_flow_attr *attr,
+			       struct mlx5_flow_attr *attr,
 			       u32 *action)
 {
 	struct flow_action_entry vlan_act = {
@@ -3790,7 +3794,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 	nest_level = attr->parse_attr->filter_dev->lower_level -
 						priv->netdev->lower_level;
 	while (nest_level--) {
-		err = parse_tc_vlan_action(priv, &vlan_act, attr, action);
+		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
 		if (err)
 			return err;
 	}
@@ -3858,7 +3862,7 @@ static int mlx5_validate_goto_chain(struct mlx5_eswitch *esw,
 				    struct netlink_ext_ack *extack)
 {
 	u32 max_chain = mlx5_chains_get_chain_range(esw_chains(esw));
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	u32 dest_chain = act->chain_index;
 
@@ -3895,15 +3899,15 @@ static int verify_uplink_forwarding(struct mlx5e_priv *priv,
 				    struct net_device *out_dev,
 				    struct netlink_ext_ack *extack)
 {
+	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	struct mlx5e_rep_priv *rep_priv;
 
 	/* Forwarding non encapsulated traffic between
 	 * uplink ports is allowed only if
 	 * termination_table_raw_traffic cap is set.
 	 *
-	 * Input vport was stored esw_attr->in_rep.
+	 * Input vport was stored attr->in_rep.
 	 * In LAG case, *priv* is the private data of
 	 * uplink which may be not the input vport.
 	 */
@@ -3938,13 +3942,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 {
 	struct pedit_headers_action hdrs[2] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
-	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	const struct ip_tunnel_info *info = NULL;
+	struct mlx5_flow_attr *attr = flow->attr;
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
+	struct mlx5_esw_flow_attr *esw_attr;
 	bool encap = false, decap = false;
 	u32 action = attr->action;
 	int err, i, if_count = 0;
@@ -3957,6 +3962,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
+	esw_attr = attr->esw_attr;
+	parse_attr = attr->parse_attr;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
@@ -4013,7 +4021,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			if (!flow_flag_test(flow, L3_TO_L2_DECAP)) {
 				action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-				attr->split_count = attr->out_count;
+				esw_attr->split_count = esw_attr->out_count;
 			}
 			break;
 		case FLOW_ACTION_CSUM:
@@ -4050,27 +4058,27 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			if (attr->out_count >= MLX5_MAX_FLOW_FWD_VPORTS) {
+			if (esw_attr->out_count >= MLX5_MAX_FLOW_FWD_VPORTS) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "can't support more output ports, can't offload forwarding");
 				netdev_warn(priv->netdev,
 					    "can't support more than %d output ports, can't offload forwarding\n",
-					    attr->out_count);
+					    esw_attr->out_count);
 				return -EOPNOTSUPP;
 			}
 
 			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			if (encap) {
-				parse_attr->mirred_ifindex[attr->out_count] =
+				parse_attr->mirred_ifindex[esw_attr->out_count] =
 					out_dev->ifindex;
-				parse_attr->tun_info[attr->out_count] = dup_tun_info(info);
-				if (!parse_attr->tun_info[attr->out_count])
+				parse_attr->tun_info[esw_attr->out_count] = dup_tun_info(info);
+				if (!parse_attr->tun_info[esw_attr->out_count])
 					return -ENOMEM;
 				encap = false;
-				attr->dests[attr->out_count].flags |=
+				esw_attr->dests[esw_attr->out_count].flags |=
 					MLX5_ESW_DEST_ENCAP;
-				attr->out_count++;
+				esw_attr->out_count++;
 				/* attr->dests[].rep is resolved when we
 				 * handle encap
 				 */
@@ -4119,9 +4127,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 				out_priv = netdev_priv(out_dev);
 				rpriv = out_priv->ppriv;
-				attr->dests[attr->out_count].rep = rpriv->rep;
-				attr->dests[attr->out_count].mdev = out_priv->mdev;
-				attr->out_count++;
+				esw_attr->dests[esw_attr->out_count].rep = rpriv->rep;
+				esw_attr->dests[esw_attr->out_count].mdev = out_priv->mdev;
+				esw_attr->out_count++;
 			} else if (parse_attr->filter_dev != priv->netdev) {
 				/* All mlx5 devices are called to configure
 				 * high level device filters. Therefore, the
@@ -4159,12 +4167,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 							      act, parse_attr, hdrs,
 							      &action, extack);
 			} else {
-				err = parse_tc_vlan_action(priv, act, attr, &action);
+				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
 			}
 			if (err)
 				return err;
 
-			attr->split_count = attr->out_count;
+			esw_attr->split_count = esw_attr->out_count;
 			break;
 		case FLOW_ACTION_VLAN_MANGLE:
 			err = add_vlan_rewrite_action(priv,
@@ -4174,7 +4182,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			attr->split_count = attr->out_count;
+			esw_attr->split_count = esw_attr->out_count;
 			break;
 		case FLOW_ACTION_TUNNEL_DECAP:
 			decap = true;
@@ -4228,7 +4236,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 			if (!((action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
 			      (action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)))
-				attr->split_count = 0;
+				esw_attr->split_count = 0;
 		}
 	}
 
@@ -4268,7 +4276,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
+	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
 		netdev_warn_once(priv->netdev, "current firmware doesn't support split rule for port mirroring\n");
@@ -4319,25 +4327,37 @@ static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv,
 
 static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 {
-	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
-	bool is_rep_ingress = attr->in_rep->vport != MLX5_VPORT_UPLINK &&
+	struct mlx5_esw_flow_attr *esw_attr = flow->attr->esw_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
+	bool is_rep_ingress = esw_attr->in_rep->vport != MLX5_VPORT_UPLINK &&
 		flow_flag_test(flow, INGRESS);
 	bool act_is_encap = !!(attr->action &
 			       MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT);
-	bool esw_paired = mlx5_devcom_is_paired(attr->in_mdev->priv.devcom,
+	bool esw_paired = mlx5_devcom_is_paired(esw_attr->in_mdev->priv.devcom,
 						MLX5_DEVCOM_ESW_OFFLOADS);
 
 	if (!esw_paired)
 		return false;
 
-	if ((mlx5_lag_is_sriov(attr->in_mdev) ||
-	     mlx5_lag_is_multipath(attr->in_mdev)) &&
+	if ((mlx5_lag_is_sriov(esw_attr->in_mdev) ||
+	     mlx5_lag_is_multipath(esw_attr->in_mdev)) &&
 	    (is_rep_ingress || act_is_encap))
 		return true;
 
 	return false;
 }
 
+struct mlx5_flow_attr *
+mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type)
+{
+	u32 ex_attr_size = (type == MLX5_FLOW_NAMESPACE_FDB)  ?
+				sizeof(struct mlx5_esw_flow_attr) :
+				sizeof(struct mlx5_nic_flow_attr);
+	struct mlx5_flow_attr *attr;
+
+	return kzalloc(sizeof(*attr) + ex_attr_size, GFP_KERNEL);
+}
+
 static int
 mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 		 struct flow_cls_offload *f, unsigned long flow_flags,
@@ -4345,19 +4365,24 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 		 struct mlx5e_tc_flow **__flow)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr;
 	struct mlx5e_tc_flow *flow;
 	int out_index, err;
 
-	flow = kzalloc(sizeof(*flow) + attr_size, GFP_KERNEL);
+	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 	parse_attr = kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
-	if (!parse_attr || !flow) {
+
+	flow->flags = flow_flags;
+	flow->cookie = f->cookie;
+	flow->priv = priv;
+
+	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
+	if (!parse_attr || !flow || !attr) {
 		err = -ENOMEM;
 		goto err_free;
 	}
+	flow->attr = attr;
 
-	flow->cookie = f->cookie;
-	flow->flags = flow_flags;
-	flow->priv = priv;
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
 		INIT_LIST_HEAD(&flow->encaps[out_index].list);
 	INIT_LIST_HEAD(&flow->hairpin);
@@ -4373,11 +4398,12 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 err_free:
 	kfree(flow);
 	kvfree(parse_attr);
+	kfree(attr);
 	return err;
 }
 
 static void
-mlx5e_flow_esw_attr_init(struct mlx5_esw_flow_attr *esw_attr,
+mlx5e_flow_esw_attr_init(struct mlx5_flow_attr *attr,
 			 struct mlx5e_priv *priv,
 			 struct mlx5e_tc_flow_parse_attr *parse_attr,
 			 struct flow_cls_offload *f,
@@ -4385,10 +4411,11 @@ mlx5e_flow_esw_attr_init(struct mlx5_esw_flow_attr *esw_attr,
 			 struct mlx5_core_dev *in_mdev)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 
-	esw_attr->parse_attr = parse_attr;
-	esw_attr->chain = f->common.chain_index;
-	esw_attr->prio = f->common.prio;
+	attr->parse_attr = parse_attr;
+	attr->chain = f->common.chain_index;
+	attr->prio = f->common.prio;
 
 	esw_attr->in_rep = in_rep;
 	esw_attr->in_mdev = in_mdev;
@@ -4422,7 +4449,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		goto out;
 
 	parse_attr->filter_dev = filter_dev;
-	mlx5e_flow_esw_attr_init(flow->esw_attr,
+	mlx5e_flow_esw_attr_init(flow->attr,
 				 priv, parse_attr,
 				 f, in_rep, in_mdev);
 
@@ -4433,7 +4460,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 
 	/* actions validation depends on parsing the ct matches first */
 	err = mlx5_tc_ct_match_add(priv, &parse_attr->spec, f,
-				   &flow->esw_attr->ct_attr, extack);
+				   &flow->attr->ct_attr, extack);
 	if (err)
 		goto err_free;
 
@@ -4464,6 +4491,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 {
 	struct mlx5e_priv *priv = flow->priv, *peer_priv;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch, *peer_esw;
+	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
 	struct mlx5_devcom *devcom = priv->mdev->priv.devcom;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_rep_priv *peer_urpriv;
@@ -4483,15 +4511,15 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	 * original flow and packets redirected from uplink use the
 	 * peer mdev.
 	 */
-	if (flow->esw_attr->in_rep->vport == MLX5_VPORT_UPLINK)
+	if (attr->in_rep->vport == MLX5_VPORT_UPLINK)
 		in_mdev = peer_priv->mdev;
 	else
 		in_mdev = priv->mdev;
 
-	parse_attr = flow->esw_attr->parse_attr;
+	parse_attr = flow->attr->parse_attr;
 	peer_flow = __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
 					 parse_attr->filter_dev,
-					 flow->esw_attr->in_rep, in_mdev);
+					 attr->in_rep, in_mdev);
 	if (IS_ERR(peer_flow)) {
 		err = PTR_ERR(peer_flow);
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 2d63a75a9326..9e84f03eebce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -35,17 +35,48 @@
 
 #include <net/pkt_cls.h>
 #include "en.h"
+#include "eswitch.h"
+#include "en/tc_ct.h"
 
 #define MLX5E_TC_FLOW_ID_MASK 0x0000ffff
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+#define ESW_FLOW_ATTR_SZ (sizeof(struct mlx5_flow_attr) +\
+			  sizeof(struct mlx5_esw_flow_attr))
+
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
 	struct net_device *tun_dev;
 };
 
+struct mlx5_nic_flow_attr {
+	u32 flow_tag;
+	u32 hairpin_tirn;
+	struct mlx5_flow_table *hairpin_ft;
+};
+
+struct mlx5_flow_attr {
+	u32 action;
+	struct mlx5_fc *counter;
+	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_ct_attr ct_attr;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	u32 chain;
+	u16 prio;
+	u32 dest_chain;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_table *dest_ft;
+	u8 inner_match_level;
+	u8 outer_match_level;
+	u32 flags;
+	union {
+		struct mlx5_esw_flow_attr esw_attr[0];
+		struct mlx5_nic_flow_attr nic_attr[0];
+	};
+};
+
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 
 struct tunnel_match_key {
@@ -181,11 +212,10 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
 int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 			    void *cb_priv);
 
-struct mlx5_nic_flow_attr;
 struct mlx5_flow_handle *
 mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			     struct mlx5_flow_spec *spec,
-			     struct mlx5_nic_flow_attr *attr);
+			     struct mlx5_flow_attr *attr);
 void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 				  struct mlx5_flow_handle *rule);
 #else /* CONFIG_MLX5_CLS_ACT */
@@ -196,6 +226,8 @@ mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 { return -EOPNOTSUPP; }
 #endif /* CONFIG_MLX5_CLS_ACT */
 
+struct mlx5_flow_attr *mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index fc23d57e9e44..66393fbdcd94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -328,7 +328,7 @@ struct mlx5_termtbl_handle;
 
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
-			      struct mlx5_esw_flow_attr *attr,
+			      struct mlx5_flow_attr *attr,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec);
 
@@ -348,19 +348,19 @@ mlx5_eswitch_termtbl_put(struct mlx5_eswitch *esw,
 struct mlx5_flow_handle *
 mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_spec *spec,
-				struct mlx5_esw_flow_attr *attr);
+				struct mlx5_flow_attr *attr);
 struct mlx5_flow_handle *
 mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 			  struct mlx5_flow_spec *spec,
-			  struct mlx5_esw_flow_attr *attr);
+			  struct mlx5_flow_attr *attr);
 void
 mlx5_eswitch_del_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_handle *rule,
-				struct mlx5_esw_flow_attr *attr);
+				struct mlx5_flow_attr *attr);
 void
 mlx5_eswitch_del_fwd_rule(struct mlx5_eswitch *esw,
 			  struct mlx5_flow_handle *rule,
-			  struct mlx5_esw_flow_attr *attr);
+			  struct mlx5_flow_attr *attr);
 
 struct mlx5_flow_handle *
 mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
@@ -400,7 +400,6 @@ struct mlx5_esw_flow_attr {
 	int split_count;
 	int out_count;
 
-	int	action;
 	__be16	vlan_proto[MLX5_FS_VLAN_DEPTH];
 	u16	vlan_vid[MLX5_FS_VLAN_DEPTH];
 	u8	vlan_prio[MLX5_FS_VLAN_DEPTH];
@@ -412,19 +411,7 @@ struct mlx5_esw_flow_attr {
 		struct mlx5_core_dev *mdev;
 		struct mlx5_termtbl_handle *termtbl;
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
-	struct  mlx5_modify_hdr *modify_hdr;
-	u8	inner_match_level;
-	u8	outer_match_level;
-	struct mlx5_fc *counter;
-	u32	chain;
-	u16	prio;
-	u32	dest_chain;
-	u32	flags;
-	struct mlx5_flow_table *fdb;
-	struct mlx5_flow_table *dest_ft;
-	struct mlx5_ct_attr ct_attr;
 	struct mlx5_pkt_reformat *decap_pkt_reformat;
-	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
 
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
@@ -450,9 +437,9 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink *devlink,
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_esw_flow_attr *attr);
+				 struct mlx5_flow_attr *attr);
 int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_esw_flow_attr *attr);
+				 struct mlx5_flow_attr *attr);
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 38eef5a8feb9..ffd5d540a19e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -45,6 +45,7 @@
 #include "lib/devcom.h"
 #include "lib/eq.h"
 #include "lib/fs_chains.h"
+#include "en_tc.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
@@ -66,6 +67,12 @@ struct mlx5_vport_key {
 	u16 vhca_id;
 } __packed;
 
+struct mlx5_vport_tbl_attr {
+	u16 chain;
+	u16 prio;
+	u16 vport;
+};
+
 struct mlx5_vport_table {
 	struct hlist_node hlist;
 	struct mlx5_flow_table *fdb;
@@ -94,10 +101,10 @@ esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns)
 }
 
 static u32 flow_attr_to_vport_key(struct mlx5_eswitch *esw,
-				  struct mlx5_esw_flow_attr *attr,
+				  struct mlx5_vport_tbl_attr *attr,
 				  struct mlx5_vport_key *key)
 {
-	key->vport = attr->in_rep->vport;
+	key->vport = attr->vport;
 	key->chain = attr->chain;
 	key->prio = attr->prio;
 	key->vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
@@ -118,7 +125,7 @@ esw_vport_tbl_lookup(struct mlx5_eswitch *esw, struct mlx5_vport_key *skey, u32
 }
 
 static void
-esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *attr)
+esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
 {
 	struct mlx5_vport_table *e;
 	struct mlx5_vport_key key;
@@ -138,7 +145,7 @@ esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *attr)
 }
 
 static struct mlx5_flow_table *
-esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *attr)
+esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
 {
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *ns;
@@ -189,16 +196,15 @@ esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *attr)
 
 int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
 {
-	struct mlx5_esw_flow_attr attr = {};
-	struct mlx5_eswitch_rep rep = {};
+	struct mlx5_vport_tbl_attr attr;
 	struct mlx5_flow_table *fdb;
 	struct mlx5_vport *vport;
 	int i;
 
+	attr.chain = 0;
 	attr.prio = 1;
-	attr.in_rep = &rep;
 	mlx5_esw_for_all_vports(esw, i, vport) {
-		attr.in_rep->vport = vport->vport;
+		attr.vport = vport->vport;
 		fdb = esw_vport_tbl_get(esw, &attr);
 		if (IS_ERR(fdb))
 			goto out;
@@ -212,15 +218,14 @@ int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
 
 void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw)
 {
-	struct mlx5_esw_flow_attr attr = {};
-	struct mlx5_eswitch_rep rep = {};
+	struct mlx5_vport_tbl_attr attr;
 	struct mlx5_vport *vport;
 	int i;
 
+	attr.chain = 0;
 	attr.prio = 1;
-	attr.in_rep = &rep;
 	mlx5_esw_for_all_vports(esw, i, vport) {
-		attr.in_rep->vport = vport->vport;
+		attr.vport = vport->vport;
 		esw_vport_tbl_put(esw, &attr);
 	}
 }
@@ -290,12 +295,14 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 struct mlx5_flow_handle *
 mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_spec *spec,
-				struct mlx5_esw_flow_attr *attr)
+				struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_destination dest[MLX5_MAX_FLOW_FWD_VPORTS + 1] = {};
 	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
-	bool split = !!(attr->split_count);
+	bool split = !!(esw_attr->split_count);
+	struct mlx5_vport_tbl_attr fwd_attr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_table *fdb;
 	int j, i = 0;
@@ -309,13 +316,13 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		flow_act.action &= ~(MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH |
 				     MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
 	else if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
-		flow_act.vlan[0].ethtype = ntohs(attr->vlan_proto[0]);
-		flow_act.vlan[0].vid = attr->vlan_vid[0];
-		flow_act.vlan[0].prio = attr->vlan_prio[0];
+		flow_act.vlan[0].ethtype = ntohs(esw_attr->vlan_proto[0]);
+		flow_act.vlan[0].vid = esw_attr->vlan_vid[0];
+		flow_act.vlan[0].prio = esw_attr->vlan_prio[0];
 		if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
-			flow_act.vlan[1].ethtype = ntohs(attr->vlan_proto[1]);
-			flow_act.vlan[1].vid = attr->vlan_vid[1];
-			flow_act.vlan[1].prio = attr->vlan_prio[1];
+			flow_act.vlan[1].ethtype = ntohs(esw_attr->vlan_proto[1]);
+			flow_act.vlan[1].vid = esw_attr->vlan_vid[1];
+			flow_act.vlan[1].prio = esw_attr->vlan_prio[1];
 		}
 	}
 
@@ -345,28 +352,29 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 			dest[i].ft = ft;
 			i++;
 		} else {
-			for (j = attr->split_count; j < attr->out_count; j++) {
+			for (j = esw_attr->split_count; j < esw_attr->out_count; j++) {
 				dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-				dest[i].vport.num = attr->dests[j].rep->vport;
+				dest[i].vport.num = esw_attr->dests[j].rep->vport;
 				dest[i].vport.vhca_id =
-					MLX5_CAP_GEN(attr->dests[j].mdev, vhca_id);
+					MLX5_CAP_GEN(esw_attr->dests[j].mdev, vhca_id);
 				if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 					dest[i].vport.flags |=
 						MLX5_FLOW_DEST_VPORT_VHCA_ID;
-				if (attr->dests[j].flags & MLX5_ESW_DEST_ENCAP) {
+				if (esw_attr->dests[j].flags & MLX5_ESW_DEST_ENCAP) {
 					flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-					flow_act.pkt_reformat = attr->dests[j].pkt_reformat;
+					flow_act.pkt_reformat =
+							esw_attr->dests[j].pkt_reformat;
 					dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 					dest[i].vport.pkt_reformat =
-						attr->dests[j].pkt_reformat;
+						esw_attr->dests[j].pkt_reformat;
 				}
 				i++;
 			}
 		}
 	}
 
-	if (attr->decap_pkt_reformat)
-		flow_act.pkt_reformat = attr->decap_pkt_reformat;
+	if (esw_attr->decap_pkt_reformat)
+		flow_act.pkt_reformat = esw_attr->decap_pkt_reformat;
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
@@ -383,26 +391,30 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		flow_act.modify_hdr = attr->modify_hdr;
 
 	if (split) {
-		fdb = esw_vport_tbl_get(esw, attr);
+		fwd_attr.chain = attr->chain;
+		fwd_attr.prio = attr->prio;
+		fwd_attr.vport = esw_attr->in_rep->vport;
+
+		fdb = esw_vport_tbl_get(esw, &fwd_attr);
 	} else {
 		if (attr->chain || attr->prio)
 			fdb = mlx5_chains_get_table(chains, attr->chain,
 						    attr->prio, 0);
 		else
-			fdb = attr->fdb;
+			fdb = attr->ft;
 
 		if (!(attr->flags & MLX5_ESW_ATTR_FLAG_NO_IN_PORT))
-			mlx5_eswitch_set_rule_source_port(esw, spec, attr);
+			mlx5_eswitch_set_rule_source_port(esw, spec, esw_attr);
 	}
 	if (IS_ERR(fdb)) {
 		rule = ERR_CAST(fdb);
 		goto err_esw_get;
 	}
 
-	mlx5_eswitch_set_rule_flow_source(esw, spec, attr);
+	mlx5_eswitch_set_rule_flow_source(esw, spec, esw_attr);
 
 	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec))
-		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, attr,
+		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, esw_attr,
 						     &flow_act, dest, i);
 	else
 		rule = mlx5_add_flow_rules(fdb, spec, &flow_act, dest, i);
@@ -415,7 +427,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 
 err_add_rule:
 	if (split)
-		esw_vport_tbl_put(esw, attr);
+		esw_vport_tbl_put(esw, &fwd_attr);
 	else if (attr->chain || attr->prio)
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_esw_get:
@@ -428,11 +440,13 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 struct mlx5_flow_handle *
 mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 			  struct mlx5_flow_spec *spec,
-			  struct mlx5_esw_flow_attr *attr)
+			  struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_destination dest[MLX5_MAX_FLOW_FWD_VPORTS + 1] = {};
 	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND, };
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
+	struct mlx5_vport_tbl_attr fwd_attr;
 	struct mlx5_flow_table *fast_fdb;
 	struct mlx5_flow_table *fwd_fdb;
 	struct mlx5_flow_handle *rule;
@@ -444,31 +458,33 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 		goto err_get_fast;
 	}
 
-	fwd_fdb = esw_vport_tbl_get(esw, attr);
+	fwd_attr.chain = attr->chain;
+	fwd_attr.prio = attr->prio;
+	fwd_attr.vport = esw_attr->in_rep->vport;
+	fwd_fdb = esw_vport_tbl_get(esw, &fwd_attr);
 	if (IS_ERR(fwd_fdb)) {
 		rule = ERR_CAST(fwd_fdb);
 		goto err_get_fwd;
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	for (i = 0; i < attr->split_count; i++) {
+	for (i = 0; i < esw_attr->split_count; i++) {
 		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-		dest[i].vport.num = attr->dests[i].rep->vport;
+		dest[i].vport.num = esw_attr->dests[i].rep->vport;
 		dest[i].vport.vhca_id =
-			MLX5_CAP_GEN(attr->dests[i].mdev, vhca_id);
+			MLX5_CAP_GEN(esw_attr->dests[i].mdev, vhca_id);
 		if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 			dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
-		if (attr->dests[i].flags & MLX5_ESW_DEST_ENCAP) {
+		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP) {
 			dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
-			dest[i].vport.pkt_reformat = attr->dests[i].pkt_reformat;
+			dest[i].vport.pkt_reformat = esw_attr->dests[i].pkt_reformat;
 		}
 	}
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = fwd_fdb,
 	i++;
 
-	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
-	mlx5_eswitch_set_rule_flow_source(esw, spec, attr);
+	mlx5_eswitch_set_rule_source_port(esw, spec, esw_attr);
 
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
@@ -483,7 +499,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	return rule;
 add_err:
-	esw_vport_tbl_put(esw, attr);
+	esw_vport_tbl_put(esw, &fwd_attr);
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_get_fast:
@@ -493,11 +509,13 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 static void
 __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 			struct mlx5_flow_handle *rule,
-			struct mlx5_esw_flow_attr *attr,
+			struct mlx5_flow_attr *attr,
 			bool fwd_rule)
 {
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
-	bool split = (attr->split_count > 0);
+	bool split = (esw_attr->split_count > 0);
+	struct mlx5_vport_tbl_attr fwd_attr;
 	int i;
 
 	mlx5_del_flow_rules(rule);
@@ -505,19 +523,25 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
 		/* unref the term table */
 		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
-			if (attr->dests[i].termtbl)
-				mlx5_eswitch_termtbl_put(esw, attr->dests[i].termtbl);
+			if (esw_attr->dests[i].termtbl)
+				mlx5_eswitch_termtbl_put(esw, esw_attr->dests[i].termtbl);
 		}
 	}
 
 	atomic64_dec(&esw->offloads.num_flows);
 
+	if (fwd_rule || split) {
+		fwd_attr.chain = attr->chain;
+		fwd_attr.prio = attr->prio;
+		fwd_attr.vport = esw_attr->in_rep->vport;
+	}
+
 	if (fwd_rule)  {
-		esw_vport_tbl_put(esw, attr);
+		esw_vport_tbl_put(esw, &fwd_attr);
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 	} else {
 		if (split)
-			esw_vport_tbl_put(esw, attr);
+			esw_vport_tbl_put(esw, &fwd_attr);
 		else if (attr->chain || attr->prio)
 			mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 		if (attr->dest_chain)
@@ -528,7 +552,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 void
 mlx5_eswitch_del_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_handle *rule,
-				struct mlx5_esw_flow_attr *attr)
+				struct mlx5_flow_attr *attr)
 {
 	__mlx5_eswitch_del_rule(esw, rule, attr, false);
 }
@@ -536,7 +560,7 @@ mlx5_eswitch_del_offloaded_rule(struct mlx5_eswitch *esw,
 void
 mlx5_eswitch_del_fwd_rule(struct mlx5_eswitch *esw,
 			  struct mlx5_flow_handle *rule,
-			  struct mlx5_esw_flow_attr *attr)
+			  struct mlx5_flow_attr *attr)
 {
 	__mlx5_eswitch_del_rule(esw, rule, attr, true);
 }
@@ -613,9 +637,10 @@ static int esw_add_vlan_action_check(struct mlx5_esw_flow_attr *attr,
 }
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_esw_flow_attr *attr)
+				 struct mlx5_flow_attr *attr)
 {
 	struct offloads_fdb *offloads = &esw->fdb_table.offloads;
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_eswitch_rep *vport = NULL;
 	bool push, pop, fwd;
 	int err = 0;
@@ -631,17 +656,17 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 
 	mutex_lock(&esw->state_lock);
 
-	err = esw_add_vlan_action_check(attr, push, pop, fwd);
+	err = esw_add_vlan_action_check(esw_attr, push, pop, fwd);
 	if (err)
 		goto unlock;
 
 	attr->flags &= ~MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
 
-	vport = esw_vlan_action_get_vport(attr, push, pop);
+	vport = esw_vlan_action_get_vport(esw_attr, push, pop);
 
 	if (!push && !pop && fwd) {
 		/* tracks VF --> wire rules without vlan push action */
-		if (attr->dests[0].rep->vport == MLX5_VPORT_UPLINK) {
+		if (esw_attr->dests[0].rep->vport == MLX5_VPORT_UPLINK) {
 			vport->vlan_refcount++;
 			attr->flags |= MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
 		}
@@ -664,11 +689,11 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 		if (vport->vlan_refcount)
 			goto skip_set_push;
 
-		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport, attr->vlan_vid[0], 0,
-						    SET_VLAN_INSERT | SET_VLAN_STRIP);
+		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport, esw_attr->vlan_vid[0],
+						    0, SET_VLAN_INSERT | SET_VLAN_STRIP);
 		if (err)
 			goto out;
-		vport->vlan = attr->vlan_vid[0];
+		vport->vlan = esw_attr->vlan_vid[0];
 skip_set_push:
 		vport->vlan_refcount++;
 	}
@@ -681,9 +706,10 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 }
 
 int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_esw_flow_attr *attr)
+				 struct mlx5_flow_attr *attr)
 {
 	struct offloads_fdb *offloads = &esw->fdb_table.offloads;
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_eswitch_rep *vport = NULL;
 	bool push, pop, fwd;
 	int err = 0;
@@ -701,11 +727,11 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 
 	mutex_lock(&esw->state_lock);
 
-	vport = esw_vlan_action_get_vport(attr, push, pop);
+	vport = esw_vlan_action_get_vport(esw_attr, push, pop);
 
 	if (!push && !pop && fwd) {
 		/* tracks VF --> wire rules without vlan push action */
-		if (attr->dests[0].rep->vport == MLX5_VPORT_UPLINK)
+		if (esw_attr->dests[0].rep->vport == MLX5_VPORT_UPLINK)
 			vport->vlan_refcount--;
 
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 17a0d2bc102b..ec679560a95d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/fs.h>
 #include "eswitch.h"
+#include "en_tc.h"
 #include "fs_core.h"
 
 struct mlx5_termtbl_handle {
@@ -228,10 +229,11 @@ static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
-			      struct mlx5_esw_flow_attr *attr,
+			      struct mlx5_flow_attr *attr,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec)
 {
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	int i;
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
@@ -244,8 +246,8 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 		return true;
 
 	/* hairpin */
-	for (i = attr->split_count; i < attr->out_count; i++)
-		if (attr->dests[i].rep->vport == MLX5_VPORT_UPLINK)
+	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
+		if (esw_attr->dests[i].rep->vport == MLX5_VPORT_UPLINK)
 			return true;
 
 	return false;
-- 
2.26.2

