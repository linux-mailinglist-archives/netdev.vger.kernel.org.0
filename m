Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AD917A8E8
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCEPep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:34:45 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39094 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726917AbgCEPen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:34:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Mar 2020 17:34:35 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 025FYYsb010824;
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
Subject: [PATCH net-next ct-offload 13/13] net/mlx5e: CT: Support clear action
Date:   Thu,  5 Mar 2020 17:34:28 +0200
Message-Id: <1583422468-8456-14-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear action, as with software, removes all ct metadata from
the packet.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 90 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 10 ++-
 3 files changed, 95 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index ff54a41..479e44e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1025,12 +1025,79 @@ struct mlx5_ct_entry {
 	return err;
 }
 
+static int
+__mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
+				struct mlx5e_tc_flow *flow,
+				struct mlx5_flow_spec *orig_spec,
+				struct mlx5_esw_flow_attr *attr,
+				struct mlx5e_tc_mod_hdr_acts *mod_acts,
+				struct mlx5_flow_handle **flow_rule)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_esw_flow_attr *pre_ct_attr;
+	struct mlx5_modify_hdr *mod_hdr;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_ct_flow *ct_flow;
+	int err;
+
+	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
+	if (!ct_flow)
+		return -ENOMEM;
+
+	/* Base esw attributes on original rule attribute */
+	pre_ct_attr = &ct_flow->pre_ct_attr;
+	memcpy(pre_ct_attr, attr, sizeof(*attr));
+
+	err = mlx5_tc_ct_entry_set_registers(ct_priv, mod_acts, 0, 0, 0, 0);
+	if (err) {
+		ct_dbg("Failed to set register for ct clear");
+		goto err_set_registers;
+	}
+
+	mod_hdr = mlx5_modify_header_alloc(esw->dev,
+					   MLX5_FLOW_NAMESPACE_FDB,
+					   mod_acts->num_actions,
+					   mod_acts->actions);
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		ct_dbg("Failed to add create ct clear mod hdr");
+		goto err_set_registers;
+	}
+
+	dealloc_mod_hdr_actions(mod_acts);
+	pre_ct_attr->modify_hdr = mod_hdr;
+	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+	rule = mlx5_eswitch_add_offloaded_rule(esw, orig_spec, pre_ct_attr);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		ct_dbg("Failed to add ct clear rule");
+		goto err_insert;
+	}
+
+	attr->ct_attr.ct_flow = ct_flow;
+	ct_flow->pre_ct_rule = rule;
+	*flow_rule = rule;
+
+	return 0;
+
+err_insert:
+	mlx5_modify_header_dealloc(priv->mdev, mod_hdr);
+err_set_registers:
+	netdev_warn(priv->netdev,
+		    "Failed to offload ct clear flow, err %d\n", err);
+	return err;
+}
+
 struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_esw_flow_attr *attr)
+			struct mlx5_esw_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
+	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct mlx5_flow_handle *rule;
 	int err;
@@ -1039,7 +1106,12 @@ struct mlx5_flow_handle *
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&ct_priv->control_lock);
-	err = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr, &rule);
+	if (clear_action)
+		err = __mlx5_tc_ct_flow_offload_clear(priv, flow, spec, attr,
+						      mod_hdr_acts, &rule);
+	else
+		err = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr,
+						&rule);
 	mutex_unlock(&ct_priv->control_lock);
 	if (err)
 		return ERR_PTR(err);
@@ -1057,11 +1129,15 @@ struct mlx5_flow_handle *
 	mlx5_eswitch_del_offloaded_rule(esw, ct_flow->pre_ct_rule,
 					pre_ct_attr);
 	mlx5_modify_header_dealloc(esw->dev, pre_ct_attr->modify_hdr);
-	mlx5_eswitch_del_offloaded_rule(esw, ct_flow->post_ct_rule,
-					&ct_flow->post_ct_attr);
-	mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
-	idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
-	mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
+
+	if (ct_flow->post_ct_rule) {
+		mlx5_eswitch_del_offloaded_rule(esw, ct_flow->post_ct_rule,
+						&ct_flow->post_ct_attr);
+		mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
+		idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
+		mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
+	}
+
 	kfree(ct_flow);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 464c865..6b2c893 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -9,6 +9,7 @@
 #include <net/tc_act/tc_ct.h>
 
 struct mlx5_esw_flow_attr;
+struct mlx5e_tc_mod_hdr_acts;
 struct mlx5_rep_uplink_priv;
 struct mlx5e_tc_flow;
 struct mlx5e_priv;
@@ -97,7 +98,8 @@ struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_esw_flow_attr *attr);
+			struct mlx5_esw_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 void
 mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
@@ -142,7 +144,8 @@ struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_esw_flow_attr *attr)
+			struct mlx5_esw_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1fe2293..e56cf93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1151,11 +1151,15 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			   struct mlx5_flow_spec *spec,
 			   struct mlx5_esw_flow_attr *attr)
 {
+	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct mlx5_flow_handle *rule;
-	struct mlx5e_tc_mod_hdr_acts;
 
-	if (flow_flag_test(flow, CT))
-		return mlx5_tc_ct_flow_offload(flow->priv, flow, spec, attr);
+	if (flow_flag_test(flow, CT)) {
+		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
+
+		return mlx5_tc_ct_flow_offload(flow->priv, flow, spec, attr,
+					       mod_hdr_acts);
+	}
 
 	rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	if (IS_ERR(rule))
-- 
1.8.3.1

