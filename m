Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921DA475221
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239920AbhLOFdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51468 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbhLOFdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F387615C7
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8760C34607;
        Wed, 15 Dec 2021 05:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546385;
        bh=ikZamzppTYNPReDD0RZAICs4MYuE16mos/nAiDybLhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFTDVmQEU+QgSs6Nm9gWWt+dcqXdOeRNq6D2GywyZFMisfcIodZUXDNVAcXiM694o
         UNzRENJfyiXuESpL8n31ytut80Hx3EeuQn9lHJsX9uxMY4nG1KleDUaFjUhlvkTlH4
         DbHcjtQ6EvTsTP0nrMnECaCGshKmGKkMGAosf0Pzwy4Xj169/5Zfj758L7JcvDMVNy
         mL+JjWnuQzq4XhQWPp19kAgnyIqThACg7Qox0B5KAxVT52lZqZGogkeBCkducK4Mm+
         9axbz/ZC2leQun1COp5DdSy17/1kudczhGGRjY887QLsBOuloMzVG1j6ynVaJ6bJdZ
         WVxLOuHlt2MLQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 06/16] net/mlx5e: Add vlan push/pop/mangle to tc action infra
Date:   Tue, 14 Dec 2021 21:32:50 -0800
Message-Id: <20211215053300.130679-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Add parsing support by implementing struct mlx5e_tc_act
for this action.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |   6 +-
 .../mellanox/mlx5/core/en/tc/act/act.h        |   2 +
 .../mellanox/mlx5/core/en/tc/act/vlan.c       | 167 +++++++++++++
 .../mellanox/mlx5/core/en/tc/act/vlan.h       |  30 +++
 .../mlx5/core/en/tc/act/vlan_mangle.c         |  87 +++++++
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 236 ++----------------
 8 files changed, 314 insertions(+), 221 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 47513edd2c86..074482b5bc96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -49,7 +49,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
-					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o
+					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o \
+					en/tc/act/vlan.o en/tc/act/vlan_mangle.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index a13d2377c7c2..deeeb7f61220 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -15,9 +15,9 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_MIRRED, */
 	NULL, /* FLOW_ACTION_REDIRECT_INGRESS, */
 	NULL, /* FLOW_ACTION_MIRRED_INGRESS, */
-	NULL, /* FLOW_ACTION_VLAN_PUSH, */
-	NULL, /* FLOW_ACTION_VLAN_POP, */
-	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
+	&mlx5e_tc_act_vlan,
+	&mlx5e_tc_act_vlan,
+	&mlx5e_tc_act_vlan_mangle,
 	&mlx5e_tc_act_tun_encap,
 	&mlx5e_tc_act_tun_decap,
 	&mlx5e_tc_act_pedit,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 17aae5cd3ed3..bf3bc791519a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -42,6 +42,8 @@ extern struct mlx5e_tc_act mlx5e_tc_act_tun_encap;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_decap;
 extern struct mlx5e_tc_act mlx5e_tc_act_csum;
 extern struct mlx5e_tc_act mlx5e_tc_act_pedit;
+extern struct mlx5e_tc_act mlx5e_tc_act_vlan;
+extern struct mlx5e_tc_act mlx5e_tc_act_vlan_mangle;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
new file mode 100644
index 000000000000..5a80eaeb90dc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/if_vlan.h>
+#include "act.h"
+#include "vlan.h"
+#include "en/tc_priv.h"
+
+static int
+parse_tc_vlan_action(struct mlx5e_priv *priv,
+		     const struct flow_action_entry *act,
+		     struct mlx5_esw_flow_attr *attr,
+		     u32 *action,
+		     struct netlink_ext_ack *extack)
+{
+	u8 vlan_idx = attr->total_vlan;
+
+	if (vlan_idx >= MLX5_FS_VLAN_DEPTH) {
+		NL_SET_ERR_MSG_MOD(extack, "Total vlans used is greater than supported");
+		return -EOPNOTSUPP;
+	}
+
+	switch (act->id) {
+	case FLOW_ACTION_VLAN_POP:
+		if (vlan_idx) {
+			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
+								 MLX5_FS_VLAN_DEPTH)) {
+				NL_SET_ERR_MSG_MOD(extack, "vlan pop action is not supported");
+				return -EOPNOTSUPP;
+			}
+
+			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
+		} else {
+			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+		}
+		break;
+	case FLOW_ACTION_VLAN_PUSH:
+		attr->vlan_vid[vlan_idx] = act->vlan.vid;
+		attr->vlan_prio[vlan_idx] = act->vlan.prio;
+		attr->vlan_proto[vlan_idx] = act->vlan.proto;
+		if (!attr->vlan_proto[vlan_idx])
+			attr->vlan_proto[vlan_idx] = htons(ETH_P_8021Q);
+
+		if (vlan_idx) {
+			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
+								 MLX5_FS_VLAN_DEPTH)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "vlan push action is not supported for vlan depth > 1");
+				return -EOPNOTSUPP;
+			}
+
+			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
+		} else {
+			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
+			    (act->vlan.proto != htons(ETH_P_8021Q) ||
+			     act->vlan.prio)) {
+				NL_SET_ERR_MSG_MOD(extack, "vlan push action is not supported");
+				return -EOPNOTSUPP;
+			}
+
+			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
+		}
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
+		return -EINVAL;
+	}
+
+	attr->total_vlan = vlan_idx + 1;
+
+	return 0;
+}
+
+int
+mlx5e_tc_act_vlan_add_push_action(struct mlx5e_priv *priv,
+				  struct mlx5_flow_attr *attr,
+				  struct net_device **out_dev,
+				  struct netlink_ext_ack *extack)
+{
+	struct net_device *vlan_dev = *out_dev;
+	struct flow_action_entry vlan_act = {
+		.id = FLOW_ACTION_VLAN_PUSH,
+		.vlan.vid = vlan_dev_vlan_id(vlan_dev),
+		.vlan.proto = vlan_dev_vlan_proto(vlan_dev),
+		.vlan.prio = 0,
+	};
+	int err;
+
+	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action, extack);
+	if (err)
+		return err;
+
+	rcu_read_lock();
+	*out_dev = dev_get_by_index_rcu(dev_net(vlan_dev), dev_get_iflink(vlan_dev));
+	rcu_read_unlock();
+	if (!*out_dev)
+		return -ENODEV;
+
+	if (is_vlan_dev(*out_dev))
+		err = mlx5e_tc_act_vlan_add_push_action(priv, attr, out_dev, extack);
+
+	return err;
+}
+
+int
+mlx5e_tc_act_vlan_add_pop_action(struct mlx5e_priv *priv,
+				 struct mlx5_flow_attr *attr,
+				 struct netlink_ext_ack *extack)
+{
+	struct flow_action_entry vlan_act = {
+		.id = FLOW_ACTION_VLAN_POP,
+	};
+	int nest_level, err = 0;
+
+	nest_level = attr->parse_attr->filter_dev->lower_level -
+						priv->netdev->lower_level;
+	while (nest_level--) {
+		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action,
+					   extack);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static bool
+tc_act_can_offload_vlan(struct mlx5e_tc_act_parse_state *parse_state,
+			const struct flow_action_entry *act,
+			int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	int err;
+
+	if (act->id == FLOW_ACTION_VLAN_PUSH &&
+	    (attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)) {
+		/* Replace vlan pop+push with vlan modify */
+		attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+		err = mlx5e_tc_act_vlan_add_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB, act,
+							   attr->parse_attr, parse_state->hdrs,
+							   &attr->action, parse_state->extack);
+	} else {
+		err = parse_tc_vlan_action(priv, act, esw_attr, &attr->action,
+					   parse_state->extack);
+	}
+
+	if (err)
+		return err;
+
+	esw_attr->split_count = esw_attr->out_count;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_vlan = {
+	.can_offload = tc_act_can_offload_vlan,
+	.parse_action = tc_act_parse_vlan,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
new file mode 100644
index 000000000000..3d62f13ab61f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_TC_ACT_VLAN_H__
+#define __MLX5_EN_TC_ACT_VLAN_H__
+
+#include <net/flow_offload.h>
+#include "en/tc_priv.h"
+
+struct pedit_headers_action;
+
+int
+mlx5e_tc_act_vlan_add_push_action(struct mlx5e_priv *priv,
+				  struct mlx5_flow_attr *attr,
+				  struct net_device **out_dev,
+				  struct netlink_ext_ack *extack);
+
+int
+mlx5e_tc_act_vlan_add_pop_action(struct mlx5e_priv *priv,
+				 struct mlx5_flow_attr *attr,
+				 struct netlink_ext_ack *extack);
+
+int
+mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
+				     const struct flow_action_entry *act,
+				     struct mlx5e_tc_flow_parse_attr *parse_attr,
+				     struct pedit_headers_action *hdrs,
+				     u32 *action, struct netlink_ext_ack *extack);
+
+#endif /* __MLX5_EN_TC_ACT_VLAN_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
new file mode 100644
index 000000000000..63e36e7f53e3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/if_vlan.h>
+#include "act.h"
+#include "vlan.h"
+#include "en/tc_priv.h"
+
+struct pedit_headers_action;
+
+int
+mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
+				     const struct flow_action_entry *act,
+				     struct mlx5e_tc_flow_parse_attr *parse_attr,
+				     struct pedit_headers_action *hdrs,
+				     u32 *action, struct netlink_ext_ack *extack)
+{
+	u16 mask16 = VLAN_VID_MASK;
+	u16 val16 = act->vlan.vid & VLAN_VID_MASK;
+	const struct flow_action_entry pedit_act = {
+		.id = FLOW_ACTION_MANGLE,
+		.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH,
+		.mangle.offset = offsetof(struct vlan_ethhdr, h_vlan_TCI),
+		.mangle.mask = ~(u32)be16_to_cpu(*(__be16 *)&mask16),
+		.mangle.val = (u32)be16_to_cpu(*(__be16 *)&val16),
+	};
+	u8 match_prio_mask, match_prio_val;
+	void *headers_c, *headers_v;
+	int err;
+
+	headers_c = mlx5e_get_match_headers_criteria(*action, &parse_attr->spec);
+	headers_v = mlx5e_get_match_headers_value(*action, &parse_attr->spec);
+
+	if (!(MLX5_GET(fte_match_set_lyr_2_4, headers_c, cvlan_tag) &&
+	      MLX5_GET(fte_match_set_lyr_2_4, headers_v, cvlan_tag))) {
+		NL_SET_ERR_MSG_MOD(extack, "VLAN rewrite action must have VLAN protocol match");
+		return -EOPNOTSUPP;
+	}
+
+	match_prio_mask = MLX5_GET(fte_match_set_lyr_2_4, headers_c, first_prio);
+	match_prio_val = MLX5_GET(fte_match_set_lyr_2_4, headers_v, first_prio);
+	if (act->vlan.prio != (match_prio_val & match_prio_mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing VLAN prio is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr, hdrs,
+					      NULL, extack);
+	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+	return err;
+}
+
+static bool
+tc_act_can_offload_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
+			       const struct flow_action_entry *act,
+			       int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
+			 const struct flow_action_entry *act,
+			 struct mlx5e_priv *priv,
+			 struct mlx5_flow_attr *attr)
+{
+	enum mlx5_flow_namespace_type ns_type;
+	int err;
+
+	ns_type = mlx5e_get_flow_namespace(parse_state->flow);
+	err = mlx5e_tc_act_vlan_add_rewrite_action(priv, ns_type, act,
+						   attr->parse_attr, parse_state->hdrs,
+						   &attr->action, parse_state->extack);
+	if (err)
+		return err;
+
+	if (ns_type == MLX5_FLOW_NAMESPACE_FDB)
+		attr->esw_attr->split_count = attr->esw_attr->out_count;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_vlan_mangle = {
+	.can_offload = tc_act_can_offload_vlan_mangle,
+	.parse_action = tc_act_parse_vlan_mangle,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index ddea835c3826..21adbdfe80bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -183,4 +183,8 @@ struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow);
 
 struct mlx5e_tc_int_port_priv *
 mlx5e_get_int_port_priv(struct mlx5e_priv *priv);
+
+void *mlx5e_get_match_headers_value(u32 flags, struct mlx5_flow_spec *spec);
+void *mlx5e_get_match_headers_criteria(u32 flags, struct mlx5_flow_spec *spec);
+
 #endif /* __MLX5_EN_TC_PRIV_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0bea8c90cd77..6e1b02b8eda6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -61,7 +61,7 @@
 #include "en/tc_tun_encap.h"
 #include "en/tc/sample.h"
 #include "en/tc/act/act.h"
-#include "en/tc/act/pedit.h"
+#include "en/tc/act/vlan.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -2051,16 +2051,14 @@ static void *get_match_outer_headers_value(struct mlx5_flow_spec *spec)
 			    outer_headers);
 }
 
-static void *get_match_headers_value(u32 flags,
-				     struct mlx5_flow_spec *spec)
+void *mlx5e_get_match_headers_value(u32 flags, struct mlx5_flow_spec *spec)
 {
 	return (flags & MLX5_FLOW_CONTEXT_ACTION_DECAP) ?
 		get_match_inner_headers_value(spec) :
 		get_match_outer_headers_value(spec);
 }
 
-static void *get_match_headers_criteria(u32 flags,
-					struct mlx5_flow_spec *spec)
+void *mlx5e_get_match_headers_criteria(u32 flags, struct mlx5_flow_spec *spec)
 {
 	return (flags & MLX5_FLOW_CONTEXT_ACTION_DECAP) ?
 		get_match_inner_headers_criteria(spec) :
@@ -2725,8 +2723,8 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 	u8 cmd;
 
 	mod_acts = &parse_attr->mod_hdr_acts;
-	headers_c = get_match_headers_criteria(*action_flags, &parse_attr->spec);
-	headers_v = get_match_headers_value(*action_flags, &parse_attr->spec);
+	headers_c = mlx5e_get_match_headers_criteria(*action_flags, &parse_attr->spec);
+	headers_v = mlx5e_get_match_headers_value(*action_flags, &parse_attr->spec);
 
 	set_masks = &hdrs[0].masks;
 	add_masks = &hdrs[1].masks;
@@ -2998,8 +2996,8 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	u8 ip_proto;
 	int i;
 
-	headers_c = get_match_headers_criteria(actions, spec);
-	headers_v = get_match_headers_value(actions, spec);
+	headers_c = mlx5e_get_match_headers_criteria(actions, spec);
+	headers_v = mlx5e_get_match_headers_value(actions, spec);
 	ethertype = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ethertype);
 
 	/* for non-IP we only re-write MACs, so we're okay */
@@ -3127,50 +3125,6 @@ static bool same_vf_reps(struct mlx5e_priv *priv,
 	       priv->netdev == out_dev;
 }
 
-static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
-				   const struct flow_action_entry *act,
-				   struct mlx5e_tc_flow_parse_attr *parse_attr,
-				   struct pedit_headers_action *hdrs,
-				   u32 *action, struct netlink_ext_ack *extack)
-{
-	u16 mask16 = VLAN_VID_MASK;
-	u16 val16 = act->vlan.vid & VLAN_VID_MASK;
-	const struct flow_action_entry pedit_act = {
-		.id = FLOW_ACTION_MANGLE,
-		.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH,
-		.mangle.offset = offsetof(struct vlan_ethhdr, h_vlan_TCI),
-		.mangle.mask = ~(u32)be16_to_cpu(*(__be16 *)&mask16),
-		.mangle.val = (u32)be16_to_cpu(*(__be16 *)&val16),
-	};
-	u8 match_prio_mask, match_prio_val;
-	void *headers_c, *headers_v;
-	int err;
-
-	headers_c = get_match_headers_criteria(*action, &parse_attr->spec);
-	headers_v = get_match_headers_value(*action, &parse_attr->spec);
-
-	if (!(MLX5_GET(fte_match_set_lyr_2_4, headers_c, cvlan_tag) &&
-	      MLX5_GET(fte_match_set_lyr_2_4, headers_v, cvlan_tag))) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "VLAN rewrite action must have VLAN protocol match");
-		return -EOPNOTSUPP;
-	}
-
-	match_prio_mask = MLX5_GET(fte_match_set_lyr_2_4, headers_c, first_prio);
-	match_prio_val = MLX5_GET(fte_match_set_lyr_2_4, headers_v, first_prio);
-	if (act->vlan.prio != (match_prio_val & match_prio_mask)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Changing VLAN prio is not supported");
-		return -EOPNOTSUPP;
-	}
-
-	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr, hdrs,
-					      NULL, extack);
-	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-
-	return err;
-}
-
 static int
 add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
@@ -3181,18 +3135,18 @@ add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 		.vlan.vid = 0,
 		.vlan.prio =
 			MLX5_GET(fte_match_set_lyr_2_4,
-				 get_match_headers_value(*action,
-							 &parse_attr->spec),
+				 mlx5e_get_match_headers_value(*action,
+							       &parse_attr->spec),
 				 first_prio) &
 			MLX5_GET(fte_match_set_lyr_2_4,
-				 get_match_headers_criteria(*action,
-							    &parse_attr->spec),
+				 mlx5e_get_match_headers_criteria(*action,
+								  &parse_attr->spec),
 				 first_prio),
 	};
 
-	return add_vlan_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB,
-				       &prio_tag_act, parse_attr, hdrs, action,
-				       extack);
+	return mlx5e_tc_act_vlan_add_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB,
+						    &prio_tag_act, parse_attr, hdrs, action,
+						    extack);
 }
 
 static int
@@ -3280,15 +3234,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-		case FLOW_ACTION_VLAN_MANGLE:
-			err = add_vlan_rewrite_action(priv,
-						      MLX5_FLOW_NAMESPACE_KERNEL,
-						      act, parse_attr, hdrs,
-						      &attr->action, extack);
-			if (err)
-				return err;
-
-			break;
 		case FLOW_ACTION_REDIRECT: {
 			struct net_device *peer_dev = act->dev;
 
@@ -3362,72 +3307,6 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
 		same_hw_devs(priv, peer_priv));
 }
 
-static int parse_tc_vlan_action(struct mlx5e_priv *priv,
-				const struct flow_action_entry *act,
-				struct mlx5_esw_flow_attr *attr,
-				u32 *action,
-				struct netlink_ext_ack *extack)
-{
-	u8 vlan_idx = attr->total_vlan;
-
-	if (vlan_idx >= MLX5_FS_VLAN_DEPTH) {
-		NL_SET_ERR_MSG_MOD(extack, "Total vlans used is greater than supported");
-		return -EOPNOTSUPP;
-	}
-
-	switch (act->id) {
-	case FLOW_ACTION_VLAN_POP:
-		if (vlan_idx) {
-			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "vlan pop action is not supported");
-				return -EOPNOTSUPP;
-			}
-
-			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
-		} else {
-			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
-		}
-		break;
-	case FLOW_ACTION_VLAN_PUSH:
-		attr->vlan_vid[vlan_idx] = act->vlan.vid;
-		attr->vlan_prio[vlan_idx] = act->vlan.prio;
-		attr->vlan_proto[vlan_idx] = act->vlan.proto;
-		if (!attr->vlan_proto[vlan_idx])
-			attr->vlan_proto[vlan_idx] = htons(ETH_P_8021Q);
-
-		if (vlan_idx) {
-			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "vlan push action is not supported for vlan depth > 1");
-				return -EOPNOTSUPP;
-			}
-
-			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
-		} else {
-			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
-			    (act->vlan.proto != htons(ETH_P_8021Q) ||
-			     act->vlan.prio)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "vlan push action is not supported");
-				return -EOPNOTSUPP;
-			}
-
-			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
-		}
-		break;
-	default:
-		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
-		return -EINVAL;
-	}
-
-	attr->total_vlan = vlan_idx + 1;
-
-	return 0;
-}
-
 static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 					  struct net_device *out_dev)
 {
@@ -3450,57 +3329,6 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 	return fdb_out_dev;
 }
 
-static int add_vlan_push_action(struct mlx5e_priv *priv,
-				struct mlx5_flow_attr *attr,
-				struct net_device **out_dev,
-				struct netlink_ext_ack *extack)
-{
-	struct net_device *vlan_dev = *out_dev;
-	struct flow_action_entry vlan_act = {
-		.id = FLOW_ACTION_VLAN_PUSH,
-		.vlan.vid = vlan_dev_vlan_id(vlan_dev),
-		.vlan.proto = vlan_dev_vlan_proto(vlan_dev),
-		.vlan.prio = 0,
-	};
-	int err;
-
-	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action, extack);
-	if (err)
-		return err;
-
-	rcu_read_lock();
-	*out_dev = dev_get_by_index_rcu(dev_net(vlan_dev), dev_get_iflink(vlan_dev));
-	rcu_read_unlock();
-	if (!*out_dev)
-		return -ENODEV;
-
-	if (is_vlan_dev(*out_dev))
-		err = add_vlan_push_action(priv, attr, out_dev, extack);
-
-	return err;
-}
-
-static int add_vlan_pop_action(struct mlx5e_priv *priv,
-			       struct mlx5_flow_attr *attr,
-			       struct netlink_ext_ack *extack)
-{
-	struct flow_action_entry vlan_act = {
-		.id = FLOW_ACTION_VLAN_POP,
-	};
-	int nest_level, err = 0;
-
-	nest_level = attr->parse_attr->filter_dev->lower_level -
-						priv->netdev->lower_level;
-	while (nest_level--) {
-		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr,
-					   &attr->action, extack);
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
 static bool same_hw_reps(struct mlx5e_priv *priv,
 			 struct net_device *peer_netdev)
 {
@@ -3824,13 +3652,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 					return -ENODEV;
 
 				if (is_vlan_dev(out_dev)) {
-					err = add_vlan_push_action(priv, attr, &out_dev, extack);
+					err = mlx5e_tc_act_vlan_add_push_action(priv, attr,
+										&out_dev,
+										extack);
 					if (err)
 						return err;
 				}
 
 				if (is_vlan_dev(parse_attr->filter_dev)) {
-					err = add_vlan_pop_action(priv, attr, extack);
+					err = mlx5e_tc_act_vlan_add_pop_action(priv, attr,
+									       extack);
 					if (err)
 						return err;
 				}
@@ -3887,35 +3718,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			}
 			}
 			break;
-		case FLOW_ACTION_VLAN_PUSH:
-		case FLOW_ACTION_VLAN_POP:
-			if (act->id == FLOW_ACTION_VLAN_PUSH &&
-			    (attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)) {
-				/* Replace vlan pop+push with vlan modify */
-				attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
-				err = add_vlan_rewrite_action(priv,
-							      MLX5_FLOW_NAMESPACE_FDB,
-							      act, parse_attr, hdrs,
-							      &attr->action, extack);
-			} else {
-				err = parse_tc_vlan_action(priv, act, esw_attr, &attr->action,
-							   extack);
-			}
-			if (err)
-				return err;
-
-			esw_attr->split_count = esw_attr->out_count;
-			break;
-		case FLOW_ACTION_VLAN_MANGLE:
-			err = add_vlan_rewrite_action(priv,
-						      MLX5_FLOW_NAMESPACE_FDB,
-						      act, parse_attr, hdrs,
-						      &attr->action, extack);
-			if (err)
-				return err;
-
-			esw_attr->split_count = esw_attr->out_count;
-			break;
 		case FLOW_ACTION_CT:
 			if (flow_flag_test(flow, SAMPLE)) {
 				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
-- 
2.31.1

