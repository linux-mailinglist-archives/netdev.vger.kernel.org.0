Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447F0182D60
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgCLKXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56687 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726930AbgCLKXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:29 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTm017875;
        Thu, 12 Mar 2020 12:23:29 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 14/15] net/mlx5e: CT: Handle misses after executing CT action
Date:   Thu, 12 Mar 2020 12:23:16 +0200
Message-Id: <1584008597-15875-15-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark packets with a unique tupleid, and on miss use that id to get
the act ct restore_cookie. Using that restore cookie, we ask CT to
restore the relevant info on the SKB.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 59 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 25 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 12 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  1 +
 4 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e9826e3..c75dc97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -35,6 +35,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_eswitch *esw;
 	const struct net_device *netdev;
 	struct idr fte_ids;
+	struct idr tuple_ids;
 	struct rhashtable zone_ht;
 	struct mlx5_flow_table *ct;
 	struct mlx5_flow_table *ct_nat;
@@ -55,6 +56,7 @@ struct mlx5_ct_flow {
 struct mlx5_ct_zone_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_esw_flow_attr attr;
+	int tupleid;
 	bool nat;
 };
 
@@ -76,6 +78,7 @@ struct mlx5_ct_entry {
 	struct mlx5_fc *counter;
 	unsigned long lastuse;
 	unsigned long cookie;
+	unsigned long restore_cookie;
 	struct mlx5_ct_zone_rule zone_rules[2];
 };
 
@@ -237,6 +240,7 @@ struct mlx5_ct_entry {
 
 	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
+	idr_remove(&ct_priv->tuple_ids, zone_rule->tupleid);
 }
 
 static void
@@ -269,7 +273,8 @@ struct mlx5_ct_entry {
 			       struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			       u8 ct_state,
 			       u32 mark,
-			       u32 label)
+			       u32 label,
+			       u32 tupleid)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
@@ -289,6 +294,11 @@ struct mlx5_ct_entry {
 	if (err)
 		return err;
 
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
+					TUPLEID_TO_REG, tupleid);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -412,6 +422,7 @@ struct mlx5_ct_entry {
 mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_esw_flow_attr *attr,
 				struct flow_rule *flow_rule,
+				u32 tupleid,
 				bool nat)
 {
 	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
@@ -442,7 +453,8 @@ struct mlx5_ct_entry {
 					     (MLX5_CT_STATE_ESTABLISHED_BIT |
 					      MLX5_CT_STATE_TRK_BIT),
 					     meta->ct_metadata.mark,
-					     meta->ct_metadata.labels[0]);
+					     meta->ct_metadata.labels[0],
+					     tupleid);
 	if (err)
 		goto err_mapping;
 
@@ -473,15 +485,27 @@ struct mlx5_ct_entry {
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_spec spec = {};
+	u32 tupleid = 1;
 	int err;
 
 	zone_rule->nat = nat;
 
-	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule, nat);
+	/* Get tuple unique id */
+	err = idr_alloc_u32(&ct_priv->tuple_ids, zone_rule, &tupleid,
+			    TUPLE_ID_MAX, GFP_KERNEL);
 	if (err) {
-		ct_dbg("Failed to create ct entry mod hdr");
+		netdev_warn(ct_priv->netdev,
+			    "Failed to allocate tuple id, err: %d\n", err);
 		return err;
 	}
+	zone_rule->tupleid = tupleid;
+
+	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
+					      tupleid, nat);
+	if (err) {
+		ct_dbg("Failed to create ct entry mod hdr");
+		goto err_mod_hdr;
+	}
 
 	attr->action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
 		       MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
@@ -511,6 +535,8 @@ struct mlx5_ct_entry {
 
 err_rule:
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
+err_mod_hdr:
+	idr_remove(&ct_priv->tuple_ids, zone_rule->tupleid);
 	return err;
 }
 
@@ -573,6 +599,7 @@ struct mlx5_ct_entry {
 	entry->zone = ft->zone;
 	entry->flow_rule = flow_rule;
 	entry->cookie = flow->cookie;
+	entry->restore_cookie = meta_action->ct_metadata.cookie;
 
 	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
 	if (err)
@@ -1188,6 +1215,7 @@ struct mlx5_flow_handle *
 	}
 
 	idr_init(&ct_priv->fte_ids);
+	idr_init(&ct_priv->tuple_ids);
 	mutex_init(&ct_priv->control_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 
@@ -1222,8 +1250,31 @@ struct mlx5_flow_handle *
 
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
+	idr_destroy(&ct_priv->tuple_ids);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
 
 	uplink_priv->ct_priv = NULL;
 }
+
+bool
+mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
+			 struct sk_buff *skb, u32 tupleid)
+{
+	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
+	struct mlx5_ct_zone_rule *zone_rule;
+	struct mlx5_ct_entry *entry;
+
+	if (!ct_priv || !tupleid)
+		return true;
+
+	zone_rule = idr_find(&ct_priv->tuple_ids, tupleid);
+	if (!zone_rule)
+		return false;
+
+	entry = container_of(zone_rule, struct mlx5_ct_entry,
+			     zone_rules[zone_rule->nat]);
+	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
+
+	return true;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index f4bfda7..464c865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -64,6 +64,17 @@ struct mlx5_ct_attr {
 				 misc_parameters_2.metadata_reg_c_5),\
 }
 
+#define tupleid_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,\
+	.moffset = 0,\
+	.mlen = 3,\
+	.soffset = MLX5_BYTE_OFF(fte_match_param,\
+				 misc_parameters_2.metadata_reg_c_1),\
+}
+
+#define TUPLE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[TUPLEID_TO_REG].mlen * 8)
+#define TUPLE_ID_MAX GENMASK(TUPLE_ID_BITS - 1, 0)
+
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
 int
@@ -92,6 +103,10 @@ struct mlx5_flow_handle *
 		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_esw_flow_attr *attr);
 
+bool
+mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
+			 struct sk_buff *skb, u32 tupleid);
+
 #else /* CONFIG_MLX5_TC_CT */
 
 static inline int
@@ -139,5 +154,15 @@ struct mlx5_flow_handle *
 {
 }
 
+static inline bool
+mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
+			 struct sk_buff *skb, u32 tupleid)
+{
+	if  (!tupleid)
+		return  true;
+
+	return false;
+}
+
 #endif /* !IS_ENABLED(CONFIG_MLX5_TC_CT) */
 #endif /* __MLX5_EN_TC_CT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1f6a306..5497d5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -200,6 +200,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[MARK_TO_REG] = mark_to_reg_ct,
 	[LABELS_TO_REG] = labels_to_reg_ct,
 	[FTEID_TO_REG] = fteid_to_reg_ct,
+	[TUPLEID_TO_REG] = tupleid_to_reg_ct,
 };
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
@@ -4851,7 +4852,9 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 			     struct mlx5e_tc_update_priv *tc_priv)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, reg_c0, reg_c1, tunnel_id;
+	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
@@ -4885,6 +4888,13 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 		}
 
 		tc_skb_ext->chain = chain;
+
+		tuple_id = reg_c1 & TUPLE_ID_MAX;
+
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
+			return false;
 	}
 
 	tunnel_moffset = mlx5e_tc_attr_to_reg_mappings[TUNNEL_TO_REG].moffset;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 31c9e81..abdcfa4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -99,6 +99,7 @@ enum mlx5e_tc_attr_to_reg {
 	MARK_TO_REG,
 	LABELS_TO_REG,
 	FTEID_TO_REG,
+	TUPLEID_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
-- 
1.8.3.1

