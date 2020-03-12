Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBE2182D61
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCLKXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56660 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726922AbgCLKXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:29 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTk017875;
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
Subject: [PATCH net-next ct-offload v4 12/15] net/mlx5e: CT: Introduce connection tracking
Date:   Thu, 12 Mar 2020 12:23:14 +0200
Message-Id: <1584008597-15875-13-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading tc ct action and ct matches.
We translate the tc filter with CT action the following HW model:

+-------------------+      +--------------------+    +--------------+
+ pre_ct (tc chain) +----->+ CT (nat or no nat) +--->+ post_ct      +----->
+ original match    +  |   + tuple + zone match + |  + fte_id match +  |
+-------------------+  |   +--------------------+ |  +--------------+  |
                       v                          v                    v
                      set chain miss mapping  set mark             original
                      set fte_id              set label            filter
                      set zone                set established      actions
                      set tunnel_id           do nat (if needed)
                      do decap

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
Changelog:
   v2->v3:
      check reg loopback support instead of metadata support/enabled

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 541 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 140 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 104 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +
 8 files changed, 793 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index a1f20b2..312e0a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -78,6 +78,16 @@ config MLX5_ESWITCH
 	        Legacy SRIOV mode (L2 mac vlan steering based).
 	        Switchdev mode (eswitch offloads).
 
+config MLX5_TC_CT
+	bool "MLX5 TC connection tracking offload support"
+	depends on MLX5_CORE_EN && NET_SWITCHDEV && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
+	default y
+	help
+	  Say Y here if you want to support offloading connection tracking rules
+	  via tc ct action.
+
+	  If unsure, set to Y
+
 config MLX5_CORE_EN_DCB
 	bool "Data Center Bridging (DCB) Support"
 	default y
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a62dc81..7408ae3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -37,6 +37,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/tc_tun.o lib/port_tu
 					lib/geneve.o en/mapping.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
 					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
+mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 
 #
 # Core extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
new file mode 100644
index 0000000..c113046
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -0,0 +1,541 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_conntrack_labels.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_acct.h>
+#include <uapi/linux/tc_act/tc_pedit.h>
+#include <net/tc_act/tc_ct.h>
+#include <net/flow_offload.h>
+#include <linux/workqueue.h>
+
+#include "en/tc_ct.h"
+#include "en.h"
+#include "en_tc.h"
+#include "en_rep.h"
+#include "eswitch_offloads_chains.h"
+
+#define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen * 8)
+#define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
+#define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
+#define MLX5_CT_STATE_TRK_BIT BIT(2)
+
+#define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen * 8)
+#define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
+#define MLX5_FTE_ID_MASK MLX5_FTE_ID_MAX
+
+#define ct_dbg(fmt, args...)\
+	netdev_dbg(ct_priv->netdev, "ct_debug: " fmt "\n", ##args)
+
+struct mlx5_tc_ct_priv {
+	struct mlx5_eswitch *esw;
+	const struct net_device *netdev;
+	struct idr fte_ids;
+	struct mlx5_flow_table *ct;
+	struct mlx5_flow_table *ct_nat;
+	struct mlx5_flow_table *post_ct;
+	struct mutex control_lock; /* guards parallel adds/dels */
+};
+
+struct mlx5_ct_flow {
+	struct mlx5_esw_flow_attr pre_ct_attr;
+	struct mlx5_esw_flow_attr post_ct_attr;
+	struct mlx5_flow_handle *pre_ct_rule;
+	struct mlx5_flow_handle *post_ct_rule;
+	u32 fte_id;
+	u32 chain_mapping;
+};
+
+static struct mlx5_tc_ct_priv *
+mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+	return uplink_priv->ct_priv;
+}
+
+int
+mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
+		       struct mlx5_flow_spec *spec,
+		       struct flow_cls_offload *f,
+		       struct netlink_ext_ack *extack)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+	struct flow_dissector_key_ct *mask, *key;
+	bool trk, est, untrk, unest, new, unnew;
+	u32 ctstate = 0, ctstate_mask = 0;
+	u16 ct_state_on, ct_state_off;
+	u16 ct_state, ct_state_mask;
+	struct flow_match_ct match;
+
+	if (!flow_rule_match_key(f->rule, FLOW_DISSECTOR_KEY_CT))
+		return 0;
+
+	if (!ct_priv) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload of ct matching isn't available");
+		return -EOPNOTSUPP;
+	}
+
+	flow_rule_match_ct(f->rule, &match);
+
+	key = match.key;
+	mask = match.mask;
+
+	ct_state = key->ct_state;
+	ct_state_mask = mask->ct_state;
+
+	if (ct_state_mask & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+			      TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED |
+			      TCA_FLOWER_KEY_CT_FLAGS_NEW)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "only ct_state trk, est and new are supported for offload");
+		return -EOPNOTSUPP;
+	}
+
+	if (mask->ct_labels[1] || mask->ct_labels[2] || mask->ct_labels[3]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "only lower 32bits of ct_labels are supported for offload");
+		return -EOPNOTSUPP;
+	}
+
+	ct_state_on = ct_state & ct_state_mask;
+	ct_state_off = (ct_state & ct_state_mask) ^ ct_state_mask;
+	trk = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
+	new = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_NEW;
+	est = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
+	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
+	unnew = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_NEW;
+	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
+
+	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
+	ctstate |= est ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
+	ctstate_mask |= (untrk || trk) ? MLX5_CT_STATE_TRK_BIT : 0;
+	ctstate_mask |= (unest || est) ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
+
+	if (new) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "matching on ct_state +new isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (mask->ct_zone)
+		mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
+					    key->ct_zone, MLX5_CT_ZONE_MASK);
+	if (ctstate_mask)
+		mlx5e_tc_match_to_reg_match(spec, CTSTATE_TO_REG,
+					    ctstate, ctstate_mask);
+	if (mask->ct_mark)
+		mlx5e_tc_match_to_reg_match(spec, MARK_TO_REG,
+					    key->ct_mark, mask->ct_mark);
+	if (mask->ct_labels[0])
+		mlx5e_tc_match_to_reg_match(spec, LABELS_TO_REG,
+					    key->ct_labels[0],
+					    mask->ct_labels[0]);
+
+	return 0;
+}
+
+int
+mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
+			struct mlx5_esw_flow_attr *attr,
+			const struct flow_action_entry *act,
+			struct netlink_ext_ack *extack)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+
+	if (!ct_priv) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload of ct action isn't available");
+		return -EOPNOTSUPP;
+	}
+
+	attr->ct_attr.zone = act->ct.zone;
+	attr->ct_attr.ct_action = act->ct.action;
+
+	return 0;
+}
+
+/* We translate the tc filter with CT action to the following HW model:
+ *
+ * +-------------------+      +--------------------+    +--------------+
+ * + pre_ct (tc chain) +----->+ CT (nat or no nat) +--->+ post_ct      +----->
+ * + original match    +  |   + tuple + zone match + |  + fte_id match +  |
+ * +-------------------+  |   +--------------------+ |  +--------------+  |
+ *                        v                          v                    v
+ *                       set chain miss mapping  set mark             original
+ *                       set fte_id              set label            filter
+ *                       set zone                set established      actions
+ *                       set tunnel_id           do nat (if needed)
+ *                       do decap
+ */
+static int
+__mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+			  struct mlx5e_tc_flow *flow,
+			  struct mlx5_flow_spec *orig_spec,
+			  struct mlx5_esw_flow_attr *attr,
+			  struct mlx5_flow_handle **flow_rule)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+	bool nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
+	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_flow_spec post_ct_spec = {};
+	struct mlx5_esw_flow_attr *pre_ct_attr;
+	struct  mlx5_modify_hdr *mod_hdr;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_ct_flow *ct_flow;
+	int chain_mapping = 0, err;
+	u32 fte_id = 1;
+
+	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
+	if (!ct_flow)
+		return -ENOMEM;
+
+	err = idr_alloc_u32(&ct_priv->fte_ids, ct_flow, &fte_id,
+			    MLX5_FTE_ID_MAX, GFP_KERNEL);
+	if (err) {
+		netdev_warn(priv->netdev,
+			    "Failed to allocate fte id, err: %d\n", err);
+		goto err_idr;
+	}
+	ct_flow->fte_id = fte_id;
+
+	/* Base esw attributes of both rules on original rule attribute */
+	pre_ct_attr = &ct_flow->pre_ct_attr;
+	memcpy(pre_ct_attr, attr, sizeof(*attr));
+	memcpy(&ct_flow->post_ct_attr, attr, sizeof(*attr));
+
+	/* Modify the original rule's action to fwd and modify, leave decap */
+	pre_ct_attr->action = attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP;
+	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			       MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+	/* Write chain miss tag for miss in ct table as we
+	 * don't go though all prios of this chain as normal tc rules
+	 * miss.
+	 */
+	err = mlx5_esw_chains_get_chain_mapping(esw, attr->chain,
+						&chain_mapping);
+	if (err) {
+		ct_dbg("Failed to get chain register mapping for chain");
+		goto err_get_chain;
+	}
+	ct_flow->chain_mapping = chain_mapping;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
+					CHAIN_TO_REG, chain_mapping);
+	if (err) {
+		ct_dbg("Failed to set chain register mapping");
+		goto err_mapping;
+	}
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts, ZONE_TO_REG,
+					attr->ct_attr.zone &
+					MLX5_CT_ZONE_MASK);
+	if (err) {
+		ct_dbg("Failed to set zone register mapping");
+		goto err_mapping;
+	}
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
+					FTEID_TO_REG, fte_id);
+	if (err) {
+		ct_dbg("Failed to set fte_id register mapping");
+		goto err_mapping;
+	}
+
+	/* If original flow is decap, we do it before going into ct table
+	 * so add a rewrite for the tunnel match_id.
+	 */
+	if ((pre_ct_attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
+	    attr->chain == 0) {
+		u32 tun_id = mlx5e_tc_get_flow_tun_id(flow);
+
+		err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
+						TUNNEL_TO_REG,
+						tun_id);
+		if (err) {
+			ct_dbg("Failed to set tunnel register mapping");
+			goto err_mapping;
+		}
+	}
+
+	mod_hdr = mlx5_modify_header_alloc(esw->dev,
+					   MLX5_FLOW_NAMESPACE_FDB,
+					   pre_mod_acts.num_actions,
+					   pre_mod_acts.actions);
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		ct_dbg("Failed to create pre ct mod hdr");
+		goto err_mapping;
+	}
+	pre_ct_attr->modify_hdr = mod_hdr;
+
+	/* Post ct rule matches on fte_id and executes original rule's
+	 * tc rule action
+	 */
+	mlx5e_tc_match_to_reg_match(&post_ct_spec, FTEID_TO_REG,
+				    fte_id, MLX5_FTE_ID_MASK);
+
+	/* Put post_ct rule on post_ct fdb */
+	ct_flow->post_ct_attr.chain = 0;
+	ct_flow->post_ct_attr.prio = 0;
+	ct_flow->post_ct_attr.fdb = ct_priv->post_ct;
+
+	ct_flow->post_ct_attr.inner_match_level = MLX5_MATCH_NONE;
+	ct_flow->post_ct_attr.outer_match_level = MLX5_MATCH_NONE;
+	ct_flow->post_ct_attr.action &= ~(MLX5_FLOW_CONTEXT_ACTION_DECAP);
+	rule = mlx5_eswitch_add_offloaded_rule(esw, &post_ct_spec,
+					       &ct_flow->post_ct_attr);
+	ct_flow->post_ct_rule = rule;
+	if (IS_ERR(ct_flow->post_ct_rule)) {
+		err = PTR_ERR(ct_flow->post_ct_rule);
+		ct_dbg("Failed to add post ct rule");
+		goto err_insert_post_ct;
+	}
+
+	/* Change original rule point to ct table */
+	pre_ct_attr->dest_chain = 0;
+	pre_ct_attr->dest_ft = nat ? ct_priv->ct_nat : ct_priv->ct;
+	ct_flow->pre_ct_rule = mlx5_eswitch_add_offloaded_rule(esw,
+							       orig_spec,
+							       pre_ct_attr);
+	if (IS_ERR(ct_flow->pre_ct_rule)) {
+		err = PTR_ERR(ct_flow->pre_ct_rule);
+		ct_dbg("Failed to add pre ct rule");
+		goto err_insert_orig;
+	}
+
+	attr->ct_attr.ct_flow = ct_flow;
+	*flow_rule = ct_flow->post_ct_rule;
+	dealloc_mod_hdr_actions(&pre_mod_acts);
+
+	return 0;
+
+err_insert_orig:
+	mlx5_eswitch_del_offloaded_rule(ct_priv->esw, ct_flow->post_ct_rule,
+					&ct_flow->post_ct_attr);
+err_insert_post_ct:
+	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
+err_mapping:
+	dealloc_mod_hdr_actions(&pre_mod_acts);
+	mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
+err_get_chain:
+	idr_remove(&ct_priv->fte_ids, fte_id);
+err_idr:
+	kfree(ct_flow);
+	netdev_warn(priv->netdev, "Failed to offload ct flow, err %d\n", err);
+	return err;
+}
+
+struct mlx5_flow_handle *
+mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_esw_flow_attr *attr)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+	struct mlx5_flow_handle *rule;
+	int err;
+
+	if (!ct_priv)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	mutex_lock(&ct_priv->control_lock);
+	err = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr, &rule);
+	mutex_unlock(&ct_priv->control_lock);
+	if (err)
+		return ERR_PTR(err);
+
+	return rule;
+}
+
+static void
+__mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
+			 struct mlx5_ct_flow *ct_flow)
+{
+	struct mlx5_esw_flow_attr *pre_ct_attr = &ct_flow->pre_ct_attr;
+	struct mlx5_eswitch *esw = ct_priv->esw;
+
+	mlx5_eswitch_del_offloaded_rule(esw, ct_flow->pre_ct_rule,
+					pre_ct_attr);
+	mlx5_modify_header_dealloc(esw->dev, pre_ct_attr->modify_hdr);
+	mlx5_eswitch_del_offloaded_rule(esw, ct_flow->post_ct_rule,
+					&ct_flow->post_ct_attr);
+	mlx5_esw_chains_put_chain_mapping(esw, ct_flow->chain_mapping);
+	idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
+	kfree(ct_flow);
+}
+
+void
+mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow,
+		       struct mlx5_esw_flow_attr *attr)
+{
+	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+	struct mlx5_ct_flow *ct_flow = attr->ct_attr.ct_flow;
+
+	/* We are called on error to clean up stuff from parsing
+	 * but we don't have anything for now
+	 */
+	if (!ct_flow)
+		return;
+
+	mutex_lock(&ct_priv->control_lock);
+	__mlx5_tc_ct_delete_flow(ct_priv, ct_flow);
+	mutex_unlock(&ct_priv->control_lock);
+}
+
+static int
+mlx5_tc_ct_init_check_support(struct mlx5_eswitch *esw,
+			      const char **err_msg)
+{
+#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	/* cannot restore chain ID on HW miss */
+
+	*err_msg = "tc skb extension missing";
+	return -EOPNOTSUPP;
+#endif
+
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level)) {
+		*err_msg = "firmware level support is missing";
+		return -EOPNOTSUPP;
+	}
+
+	if (!mlx5_eswitch_vlan_actions_supported(esw->dev, 1)) {
+		/* vlan workaround should be avoided for multi chain rules.
+		 * This is just a sanity check as pop vlan action should
+		 * be supported by any FW that supports ignore_flow_level
+		 */
+
+		*err_msg = "firmware vlan actions support is missing";
+		return -EOPNOTSUPP;
+	}
+
+	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev,
+				    fdb_modify_header_fwd_to_table)) {
+		/* CT always writes to registers which are mod header actions.
+		 * Therefore, mod header and goto is required
+		 */
+
+		*err_msg = "firmware fwd and modify support is missing";
+		return -EOPNOTSUPP;
+	}
+
+	if (!mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
+		*err_msg = "register loopback isn't supported";
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static void
+mlx5_tc_ct_init_err(struct mlx5e_rep_priv *rpriv, const char *msg, int err)
+{
+	if (msg)
+		netdev_warn(rpriv->netdev,
+			    "tc ct offload not supported, %s, err: %d\n",
+			    msg, err);
+	else
+		netdev_warn(rpriv->netdev,
+			    "tc ct offload not supported, err: %d\n",
+			    err);
+}
+
+int
+mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
+{
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5e_priv *priv;
+	const char *msg;
+	int err;
+
+	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
+	priv = netdev_priv(rpriv->netdev);
+	esw = priv->mdev->priv.eswitch;
+
+	err = mlx5_tc_ct_init_check_support(esw, &msg);
+	if (err) {
+		mlx5_tc_ct_init_err(rpriv, msg, err);
+		goto err_support;
+	}
+
+	ct_priv = kzalloc(sizeof(*ct_priv), GFP_KERNEL);
+	if (!ct_priv) {
+		mlx5_tc_ct_init_err(rpriv, NULL, -ENOMEM);
+		goto err_alloc;
+	}
+
+	ct_priv->esw = esw;
+	ct_priv->netdev = rpriv->netdev;
+	ct_priv->ct = mlx5_esw_chains_create_global_table(esw);
+	if (IS_ERR(ct_priv->ct)) {
+		err = PTR_ERR(ct_priv->ct);
+		mlx5_tc_ct_init_err(rpriv, "failed to create ct table", err);
+		goto err_ct_tbl;
+	}
+
+	ct_priv->ct_nat = mlx5_esw_chains_create_global_table(esw);
+	if (IS_ERR(ct_priv->ct_nat)) {
+		err = PTR_ERR(ct_priv->ct_nat);
+		mlx5_tc_ct_init_err(rpriv, "failed to create ct nat table",
+				    err);
+		goto err_ct_nat_tbl;
+	}
+
+	ct_priv->post_ct = mlx5_esw_chains_create_global_table(esw);
+	if (IS_ERR(ct_priv->post_ct)) {
+		err = PTR_ERR(ct_priv->post_ct);
+		mlx5_tc_ct_init_err(rpriv, "failed to create post ct table",
+				    err);
+		goto err_post_ct_tbl;
+	}
+
+	idr_init(&ct_priv->fte_ids);
+	mutex_init(&ct_priv->control_lock);
+
+	/* Done, set ct_priv to know it initializted */
+	uplink_priv->ct_priv = ct_priv;
+
+	return 0;
+
+err_post_ct_tbl:
+	mlx5_esw_chains_destroy_global_table(esw, ct_priv->ct_nat);
+err_ct_nat_tbl:
+	mlx5_esw_chains_destroy_global_table(esw, ct_priv->ct);
+err_ct_tbl:
+	kfree(ct_priv);
+err_alloc:
+err_support:
+
+	return 0;
+}
+
+void
+mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
+{
+	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
+
+	if (!ct_priv)
+		return;
+
+	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->post_ct);
+	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct_nat);
+	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct);
+
+	mutex_destroy(&ct_priv->control_lock);
+	idr_destroy(&ct_priv->fte_ids);
+	kfree(ct_priv);
+
+	uplink_priv->ct_priv = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
new file mode 100644
index 0000000..3a84216
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -0,0 +1,140 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2018 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_TC_CT_H__
+#define __MLX5_EN_TC_CT_H__
+
+#include <net/pkt_cls.h>
+#include <linux/mlx5/fs.h>
+#include <net/tc_act/tc_ct.h>
+
+struct mlx5_esw_flow_attr;
+struct mlx5_rep_uplink_priv;
+struct mlx5e_tc_flow;
+struct mlx5e_priv;
+
+struct mlx5_ct_flow;
+
+struct mlx5_ct_attr {
+	u16 zone;
+	u16 ct_action;
+	struct mlx5_ct_flow *ct_flow;
+};
+
+#define zone_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_2,\
+	.moffset = 0,\
+	.mlen = 2,\
+	.soffset = MLX5_BYTE_OFF(fte_match_param,\
+				 misc_parameters_2.metadata_reg_c_2) + 2,\
+}
+
+#define ctstate_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_2,\
+	.moffset = 2,\
+	.mlen = 2,\
+	.soffset = MLX5_BYTE_OFF(fte_match_param,\
+				 misc_parameters_2.metadata_reg_c_2),\
+}
+
+#define mark_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_3,\
+	.moffset = 0,\
+	.mlen = 4,\
+	.soffset = MLX5_BYTE_OFF(fte_match_param,\
+				 misc_parameters_2.metadata_reg_c_3),\
+}
+
+#define labels_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_4,\
+	.moffset = 0,\
+	.mlen = 4,\
+	.soffset = MLX5_BYTE_OFF(fte_match_param,\
+				 misc_parameters_2.metadata_reg_c_4),\
+}
+
+#define fteid_to_reg_ct {\
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_5,\
+	.moffset = 0,\
+	.mlen = 4,\
+	.soffset = MLX5_BYTE_OFF(fte_match_param,\
+				 misc_parameters_2.metadata_reg_c_5),\
+}
+
+#if IS_ENABLED(CONFIG_MLX5_TC_CT)
+
+int
+mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv);
+void
+mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv);
+
+int
+mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
+		       struct mlx5_flow_spec *spec,
+		       struct flow_cls_offload *f,
+		       struct netlink_ext_ack *extack);
+int
+mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
+			struct mlx5_esw_flow_attr *attr,
+			const struct flow_action_entry *act,
+			struct netlink_ext_ack *extack);
+
+struct mlx5_flow_handle *
+mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_esw_flow_attr *attr);
+void
+mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
+		       struct mlx5e_tc_flow *flow,
+		       struct mlx5_esw_flow_attr *attr);
+
+#else /* CONFIG_MLX5_TC_CT */
+
+static inline int
+mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
+{
+	return 0;
+}
+
+static inline void
+mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
+{
+}
+
+static inline int
+mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
+		       struct mlx5_flow_spec *spec,
+		       struct flow_cls_offload *f,
+		       struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
+			struct mlx5_esw_flow_attr *attr,
+			const struct flow_action_entry *act,
+			struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline struct mlx5_flow_handle *
+mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_esw_flow_attr *attr)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void
+mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
+		       struct mlx5e_tc_flow *flow,
+		       struct mlx5_esw_flow_attr *attr)
+{
+}
+
+#endif /* !IS_ENABLED(CONFIG_MLX5_TC_CT) */
+#endif /* __MLX5_EN_TC_CT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 2bbdbdc..6a23379 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -55,6 +55,7 @@ struct mlx5e_neigh_update_table {
 	unsigned long           min_interval; /* jiffies */
 };
 
+struct mlx5_tc_ct_priv;
 struct mlx5_rep_uplink_priv {
 	/* Filters DB - instantiated by the uplink representor and shared by
 	 * the uplink's VFs
@@ -86,6 +87,8 @@ struct mlx5_rep_uplink_priv {
 	struct mapping_ctx *tunnel_mapping;
 	/* maps tun_enc_opts to a unique id*/
 	struct mapping_ctx *tunnel_enc_opts_mapping;
+
+	struct mlx5_tc_ct_priv *ct_priv;
 };
 
 struct mlx5e_rep_priv {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4b04992..1f6a306 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -56,6 +56,7 @@
 #include "en/port.h"
 #include "en/tc_tun.h"
 #include "en/mapping.h"
+#include "en/tc_ct.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "diag/en_tc_tracepoint.h"
@@ -87,6 +88,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_DUP		= MLX5E_TC_FLOW_BASE + 4,
 	MLX5E_TC_FLOW_FLAG_NOT_READY	= MLX5E_TC_FLOW_BASE + 5,
 	MLX5E_TC_FLOW_FLAG_DELETED	= MLX5E_TC_FLOW_BASE + 6,
+	MLX5E_TC_FLOW_FLAG_CT		= MLX5E_TC_FLOW_BASE + 7,
 };
 
 #define MLX5E_TC_MAX_SPLITS 1
@@ -193,6 +195,11 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 		.soffset = MLX5_BYTE_OFF(fte_match_param,
 					 misc_parameters_2.metadata_reg_c_1),
 	},
+	[ZONE_TO_REG] = zone_to_reg_ct,
+	[CTSTATE_TO_REG] = ctstate_to_reg_ct,
+	[MARK_TO_REG] = mark_to_reg_ct,
+	[LABELS_TO_REG] = labels_to_reg_ct,
+	[FTEID_TO_REG] = fteid_to_reg_ct,
 };
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
@@ -1144,6 +1151,10 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			   struct mlx5_esw_flow_attr *attr)
 {
 	struct mlx5_flow_handle *rule;
+	struct mlx5e_tc_mod_hdr_acts;
+
+	if (flow_flag_test(flow, CT))
+		return mlx5_tc_ct_flow_offload(flow->priv, flow, spec, attr);
 
 	rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	if (IS_ERR(rule))
@@ -1163,10 +1174,15 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 static void
 mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 			     struct mlx5e_tc_flow *flow,
-			   struct mlx5_esw_flow_attr *attr)
+			     struct mlx5_esw_flow_attr *attr)
 {
 	flow_flag_clear(flow, OFFLOADED);
 
+	if (flow_flag_test(flow, CT)) {
+		mlx5_tc_ct_delete_flow(flow->priv, flow, attr);
+		return;
+	}
+
 	if (attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
@@ -1938,6 +1954,11 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
 			       enc_opts_id);
 }
 
+u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow)
+{
+	return flow->tunnel_id;
+}
+
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
@@ -2103,6 +2124,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_TCP) |
 	      BIT(FLOW_DISSECTOR_KEY_IP)  |
+	      BIT(FLOW_DISSECTOR_KEY_CT) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
@@ -2913,7 +2935,9 @@ struct ipv6_hoplimit_word {
 	__u8	hop_limit;
 };
 
-static bool is_action_keys_supported(const struct flow_action_entry *act)
+static int is_action_keys_supported(const struct flow_action_entry *act,
+				    bool ct_flow, bool *modify_ip_header,
+				    struct netlink_ext_ack *extack)
 {
 	u32 mask, offset;
 	u8 htype;
@@ -2932,7 +2956,13 @@ static bool is_action_keys_supported(const struct flow_action_entry *act)
 		if (offset != offsetof(struct iphdr, ttl) ||
 		    ttl_word->protocol ||
 		    ttl_word->check) {
-			return true;
+			*modify_ip_header = true;
+		}
+
+		if (ct_flow && offset >= offsetof(struct iphdr, saddr)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "can't offload re-write of ipv4 address with action ct");
+			return -EOPNOTSUPP;
 		}
 	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
 		struct ipv6_hoplimit_word *hoplimit_word =
@@ -2941,15 +2971,27 @@ static bool is_action_keys_supported(const struct flow_action_entry *act)
 		if (offset != offsetof(struct ipv6hdr, payload_len) ||
 		    hoplimit_word->payload_len ||
 		    hoplimit_word->nexthdr) {
-			return true;
+			*modify_ip_header = true;
+		}
+
+		if (ct_flow && offset >= offsetof(struct ipv6hdr, saddr)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "can't offload re-write of ipv6 address with action ct");
+			return -EOPNOTSUPP;
 		}
+	} else if (ct_flow && (htype == FLOW_ACT_MANGLE_HDR_TYPE_TCP ||
+			       htype == FLOW_ACT_MANGLE_HDR_TYPE_UDP)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload re-write of transport header ports with action ct");
+		return -EOPNOTSUPP;
 	}
-	return false;
+
+	return 0;
 }
 
 static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
-					  u32 actions,
+					  u32 actions, bool ct_flow,
 					  struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
@@ -2957,7 +2999,7 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 	void *headers_v;
 	u16 ethertype;
 	u8 ip_proto;
-	int i;
+	int i, err;
 
 	headers_v = get_match_headers_value(actions, spec);
 	ethertype = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ethertype);
@@ -2972,10 +3014,10 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 		    act->id != FLOW_ACTION_ADD)
 			continue;
 
-		if (is_action_keys_supported(act)) {
-			modify_ip_header = true;
-			break;
-		}
+		err = is_action_keys_supported(act, ct_flow,
+					       &modify_ip_header, extack);
+		if (err)
+			return err;
 	}
 
 	ip_proto = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol);
@@ -2998,13 +3040,24 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 				    struct netlink_ext_ack *extack)
 {
 	struct net_device *filter_dev = parse_attr->filter_dev;
-	bool drop_action, pop_action;
+	bool drop_action, pop_action, ct_flow;
 	u32 actions;
 
-	if (mlx5e_is_eswitch_flow(flow))
+	ct_flow = flow_flag_test(flow, CT);
+	if (mlx5e_is_eswitch_flow(flow)) {
 		actions = flow->esw_attr->action;
-	else
+
+		if (flow->esw_attr->split_count && ct_flow) {
+			/* All registers used by ct are cleared when using
+			 * split rules.
+			 */
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Can't offload mirroring with action ct");
+			return -EOPNOTSUPP;
+		}
+	} else {
 		actions = flow->nic_attr->action;
+	}
 
 	drop_action = actions & MLX5_FLOW_CONTEXT_ACTION_DROP;
 	pop_action = actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
@@ -3021,7 +3074,7 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		return modify_header_match_supported(&parse_attr->spec,
 						     flow_action, actions,
-						     extack);
+						     ct_flow, extack);
 
 	return true;
 }
@@ -3826,6 +3879,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
+		case FLOW_ACTION_CT:
+			err = mlx5_tc_ct_parse_action(priv, attr, act, extack);
+			if (err)
+				return err;
+
+			flow_flag_set(flow, CT);
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
 			return -EOPNOTSUPP;
@@ -4066,6 +4126,10 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 	if (err)
 		goto err_free;
 
+	err = mlx5_tc_ct_parse_match(priv, &parse_attr->spec, f, extack);
+	if (err)
+		goto err_free;
+
 	err = mlx5e_tc_add_fdb_flow(priv, flow, extack);
 	complete_all(&flow->init_done);
 	if (err) {
@@ -4350,7 +4414,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		goto errout;
 	}
 
-	if (mlx5e_is_offloaded_flow(flow)) {
+	if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
 		counter = mlx5e_tc_get_counter(flow);
 		if (!counter)
 			goto errout;
@@ -4622,6 +4686,10 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
 	priv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
 
+	err = mlx5_tc_ct_init(uplink_priv);
+	if (err)
+		goto err_ct;
+
 	mapping = mapping_create(sizeof(struct tunnel_match_key),
 				 TUNNEL_INFO_BITS_MASK, true);
 	if (IS_ERR(mapping)) {
@@ -4648,6 +4716,8 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 err_enc_opts_mapping:
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
+	mlx5_tc_ct_clean(uplink_priv);
+err_ct:
 	netdev_warn(priv->netdev,
 		    "Failed to initialize tc (eswitch), err: %d", err);
 	return err;
@@ -4662,6 +4732,8 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 	mapping_destroy(uplink_priv->tunnel_mapping);
+
+	mlx5_tc_ct_clean(uplink_priv);
 }
 
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 21cbde4..31c9e81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -94,6 +94,11 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 enum mlx5e_tc_attr_to_reg {
 	CHAIN_TO_REG,
 	TUNNEL_TO_REG,
+	CTSTATE_TO_REG,
+	ZONE_TO_REG,
+	MARK_TO_REG,
+	LABELS_TO_REG,
+	FTEID_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
@@ -139,6 +144,9 @@ int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 
+struct mlx5e_tc_flow;
+u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 6254bb6..2e0417d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -42,6 +42,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
+#include "en/tc_ct.h"
 
 #define FDB_TC_MAX_CHAIN 3
 #define FDB_FT_CHAIN (FDB_TC_MAX_CHAIN + 1)
@@ -424,6 +425,7 @@ struct mlx5_esw_flow_attr {
 	u32	flags;
 	struct mlx5_flow_table *fdb;
 	struct mlx5_flow_table *dest_ft;
+	struct mlx5_ct_attr ct_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
 
-- 
1.8.3.1

