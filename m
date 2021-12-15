Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1105475225
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbhLOFdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbhLOFdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C637C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 21:33:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB0661825
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF78C34609;
        Wed, 15 Dec 2021 05:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546384;
        bh=08HKsXubTsagsFQBLXQcJV+6ogVyRi/fPzLlHAjPcD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNzuVhrlCMMHohsNPW9hQCDLhGxQhOsYD5mUwOckFON2pR+oxvme1mgNP1JmGM8l/
         kn+iALBOmxatjJqqEdPp/owi5DKSsxGnba0i3WrAifzFtTbSphGPnZC/MtZYffHNUt
         UXVVTorh5FOpSa5HdcRQF54q6sSM3zzCvD5OCxuvgQIT1DacBMZDpkyQxaru5Pz6y+
         P9l1qZgnzZuXsjV1DD0DgfJ15za+YqZjlgOeOTwPiPtJcgmrE5ZnCGZRnjrQpSgBer
         y/X/iOjk7bme3kWMFD8K7j6dhLM9cO5+JfgW3KRYlCV3lNju6dIkjxa1yfMADxm1a9
         z2XY0MdI5zz/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 05/16] net/mlx5e: Add pedit to tc action infra
Date:   Tue, 14 Dec 2021 21:32:49 -0800
Message-Id: <20211215053300.130679-6-saeed@kernel.org>
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
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |   8 +-
 .../mellanox/mlx5/core/en/tc/act/act.h        |   4 +
 .../mellanox/mlx5/core/en/tc/act/pedit.c      | 165 ++++++++++++++++
 .../mellanox/mlx5/core/en/tc/act/pedit.h      |  32 ++++
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 179 ++----------------
 7 files changed, 222 insertions(+), 169 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index c148d0fea6f1..47513edd2c86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -49,7 +49,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
-					en/tc/act/tun.o en/tc/act/csum.o
+					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 449a9425f107..a13d2377c7c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -20,8 +20,8 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
 	&mlx5e_tc_act_tun_encap,
 	&mlx5e_tc_act_tun_decap,
-	NULL, /* FLOW_ACTION_MANGLE, */
-	NULL, /* FLOW_ACTION_ADD, */
+	&mlx5e_tc_act_pedit,
+	&mlx5e_tc_act_pedit,
 	&mlx5e_tc_act_csum,
 };
 
@@ -40,8 +40,8 @@ static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
 	NULL, /* FLOW_ACTION_TUNNEL_ENCAP, */
 	NULL, /* FLOW_ACTION_TUNNEL_DECAP, */
-	NULL, /* FLOW_ACTION_MANGLE, */
-	NULL, /* FLOW_ACTION_ADD, */
+	&mlx5e_tc_act_pedit,
+	&mlx5e_tc_act_pedit,
 	&mlx5e_tc_act_csum,
 	&mlx5e_tc_act_mark,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index da19484add62..17aae5cd3ed3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -4,9 +4,11 @@
 #ifndef __MLX5_EN_TC_ACT_H__
 #define __MLX5_EN_TC_ACT_H__
 
+#include <net/tc_act/tc_pedit.h>
 #include <net/flow_offload.h>
 #include <linux/netlink.h>
 #include "eswitch.h"
+#include "pedit.h"
 
 struct mlx5_flow_attr;
 
@@ -17,6 +19,7 @@ struct mlx5e_tc_act_parse_state {
 	bool encap;
 	bool decap;
 	const struct ip_tunnel_info *tun_info;
+	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 };
 
 struct mlx5e_tc_act {
@@ -38,6 +41,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_goto;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_encap;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_decap;
 extern struct mlx5e_tc_act mlx5e_tc_act_csum;
+extern struct mlx5e_tc_act mlx5e_tc_act_pedit;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
new file mode 100644
index 000000000000..79addbbef087
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/if_vlan.h>
+#include "act.h"
+#include "pedit.h"
+#include "en/tc_priv.h"
+#include "en/mod_hdr.h"
+
+static int pedit_header_offsets[] = {
+	[FLOW_ACT_MANGLE_HDR_TYPE_ETH] = offsetof(struct pedit_headers, eth),
+	[FLOW_ACT_MANGLE_HDR_TYPE_IP4] = offsetof(struct pedit_headers, ip4),
+	[FLOW_ACT_MANGLE_HDR_TYPE_IP6] = offsetof(struct pedit_headers, ip6),
+	[FLOW_ACT_MANGLE_HDR_TYPE_TCP] = offsetof(struct pedit_headers, tcp),
+	[FLOW_ACT_MANGLE_HDR_TYPE_UDP] = offsetof(struct pedit_headers, udp),
+};
+
+#define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
+
+static int
+set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
+	      struct pedit_headers_action *hdrs,
+	      struct netlink_ext_ack *extack)
+{
+	u32 *curr_pmask, *curr_pval;
+
+	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
+	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
+
+	if (*curr_pmask & mask) { /* disallow acting twice on the same location */
+		NL_SET_ERR_MSG_MOD(extack,
+				   "curr_pmask and new mask same. Acting twice on same location");
+		goto out_err;
+	}
+
+	*curr_pmask |= mask;
+	*curr_pval  |= (val & mask);
+
+	return 0;
+
+out_err:
+	return -EOPNOTSUPP;
+}
+
+static int
+parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
+			  const struct flow_action_entry *act, int namespace,
+			  struct mlx5e_tc_flow_parse_attr *parse_attr,
+			  struct pedit_headers_action *hdrs,
+			  struct netlink_ext_ack *extack)
+{
+	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
+	u8 htype = act->mangle.htype;
+	int err = -EOPNOTSUPP;
+	u32 mask, val, offset;
+
+	if (htype == FLOW_ACT_MANGLE_UNSPEC) {
+		NL_SET_ERR_MSG_MOD(extack, "legacy pedit isn't offloaded");
+		goto out_err;
+	}
+
+	if (!mlx5e_mod_hdr_max_actions(priv->mdev, namespace)) {
+		NL_SET_ERR_MSG_MOD(extack, "The pedit offload action is not supported");
+		goto out_err;
+	}
+
+	mask = act->mangle.mask;
+	val = act->mangle.val;
+	offset = act->mangle.offset;
+
+	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
+	if (err)
+		goto out_err;
+
+	hdrs[cmd].pedits++;
+
+	return 0;
+out_err:
+	return err;
+}
+
+static int
+parse_pedit_to_reformat(const struct flow_action_entry *act,
+			struct mlx5e_tc_flow_parse_attr *parse_attr,
+			struct netlink_ext_ack *extack)
+{
+	u32 mask, val, offset;
+	u32 *p;
+
+	if (act->id != FLOW_ACTION_MANGLE) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
+		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
+		return -EOPNOTSUPP;
+	}
+
+	mask = ~act->mangle.mask;
+	val = act->mangle.val;
+	offset = act->mangle.offset;
+	p = (u32 *)&parse_attr->eth;
+	*(p + (offset >> 2)) |= (val & mask);
+
+	return 0;
+}
+
+int
+mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
+				const struct flow_action_entry *act, int namespace,
+				struct mlx5e_tc_flow_parse_attr *parse_attr,
+				struct pedit_headers_action *hdrs,
+				struct mlx5e_tc_flow *flow,
+				struct netlink_ext_ack *extack)
+{
+	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
+		return parse_pedit_to_reformat(act, parse_attr, extack);
+
+	return parse_pedit_to_modify_hdr(priv, act, namespace, parse_attr, hdrs, extack);
+}
+
+static bool
+tc_act_can_offload_pedit(struct mlx5e_tc_act_parse_state *parse_state,
+			 const struct flow_action_entry *act,
+			 int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_pedit(struct mlx5e_tc_act_parse_state *parse_state,
+		   const struct flow_action_entry *act,
+		   struct mlx5e_priv *priv,
+		   struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+	enum mlx5_flow_namespace_type ns_type;
+	int err;
+
+	ns_type = mlx5e_get_flow_namespace(flow);
+
+	err = mlx5e_tc_act_pedit_parse_action(flow->priv, act, ns_type,
+					      attr->parse_attr, parse_state->hdrs,
+					      flow, parse_state->extack);
+	if (err)
+		return err;
+
+	if (flow_flag_test(flow, L3_TO_L2_DECAP))
+		goto out;
+
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+	if (ns_type == MLX5_FLOW_NAMESPACE_FDB)
+		esw_attr->split_count = esw_attr->out_count;
+
+out:
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_pedit = {
+	.can_offload = tc_act_can_offload_pedit,
+	.parse_action = tc_act_parse_pedit,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
new file mode 100644
index 000000000000..da8ab03af58f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_TC_ACT_PEDIT_H__
+#define __MLX5_EN_TC_ACT_PEDIT_H__
+
+#include "en_tc.h"
+
+struct pedit_headers {
+	struct ethhdr   eth;
+	struct vlan_hdr vlan;
+	struct iphdr    ip4;
+	struct ipv6hdr  ip6;
+	struct tcphdr   tcp;
+	struct udphdr   udp;
+};
+
+struct pedit_headers_action {
+	struct pedit_headers vals;
+	struct pedit_headers masks;
+	u32 pedits;
+};
+
+int
+mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
+				const struct flow_action_entry *act, int namespace,
+				struct mlx5e_tc_flow_parse_attr *parse_attr,
+				struct pedit_headers_action *hdrs,
+				struct mlx5e_tc_flow *flow,
+				struct netlink_ext_ack *extack);
+
+#endif /* __MLX5_EN_TC_ACT_PEDIT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index c53871a25a0d..ddea835c3826 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -122,6 +122,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow);
 bool mlx5e_is_ft_flow(struct mlx5e_tc_flow *flow);
 bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow);
+int mlx5e_get_flow_namespace(struct mlx5e_tc_flow *flow);
 
 static inline void __flow_flag_set(struct mlx5e_tc_flow *flow, unsigned long flag)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 73132517c6a0..0bea8c90cd77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -40,7 +40,6 @@
 #include <linux/refcount.h>
 #include <linux/completion.h>
 #include <linux/if_macvlan.h>
-#include <net/tc_act/tc_pedit.h>
 #include <net/psample.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
@@ -62,6 +61,7 @@
 #include "en/tc_tun_encap.h"
 #include "en/tc/sample.h"
 #include "en/tc/act/act.h"
+#include "en/tc/act/pedit.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -407,7 +407,7 @@ bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
 	return flow_flag_test(flow, OFFLOADED);
 }
 
-static int get_flow_name_space(struct mlx5e_tc_flow *flow)
+int mlx5e_get_flow_namespace(struct mlx5e_tc_flow *flow)
 {
 	return mlx5e_is_eswitch_flow(flow) ?
 		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
@@ -418,7 +418,7 @@ get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	return get_flow_name_space(flow) == MLX5_FLOW_NAMESPACE_FDB ?
+	return mlx5e_get_flow_namespace(flow) == MLX5_FLOW_NAMESPACE_FDB ?
 		&esw->offloads.mod_hdr :
 		&priv->fs.tc.mod_hdr;
 }
@@ -431,7 +431,7 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 	struct mlx5e_mod_hdr_handle *mh;
 
 	mh = mlx5e_mod_hdr_attach(priv->mdev, get_mod_hdr_table(priv, flow),
-				  get_flow_name_space(flow),
+				  mlx5e_get_flow_namespace(flow),
 				  &parse_attr->mod_hdr_acts);
 	if (IS_ERR(mh))
 		return PTR_ERR(mh);
@@ -1365,7 +1365,7 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 	struct mlx5_modify_hdr *mod_hdr;
 
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
-					   get_flow_name_space(flow),
+					   mlx5e_get_flow_namespace(flow),
 					   mod_hdr_acts->num_actions,
 					   mod_hdr_acts->actions);
 	if (IS_ERR(mod_hdr))
@@ -2605,55 +2605,6 @@ static int parse_cls_flower(struct mlx5e_priv *priv,
 	return err;
 }
 
-struct pedit_headers {
-	struct ethhdr  eth;
-	struct vlan_hdr vlan;
-	struct iphdr   ip4;
-	struct ipv6hdr ip6;
-	struct tcphdr  tcp;
-	struct udphdr  udp;
-};
-
-struct pedit_headers_action {
-	struct pedit_headers	vals;
-	struct pedit_headers	masks;
-	u32			pedits;
-};
-
-static int pedit_header_offsets[] = {
-	[FLOW_ACT_MANGLE_HDR_TYPE_ETH] = offsetof(struct pedit_headers, eth),
-	[FLOW_ACT_MANGLE_HDR_TYPE_IP4] = offsetof(struct pedit_headers, ip4),
-	[FLOW_ACT_MANGLE_HDR_TYPE_IP6] = offsetof(struct pedit_headers, ip6),
-	[FLOW_ACT_MANGLE_HDR_TYPE_TCP] = offsetof(struct pedit_headers, tcp),
-	[FLOW_ACT_MANGLE_HDR_TYPE_UDP] = offsetof(struct pedit_headers, udp),
-};
-
-#define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
-
-static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
-			 struct pedit_headers_action *hdrs,
-			 struct netlink_ext_ack *extack)
-{
-	u32 *curr_pmask, *curr_pval;
-
-	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
-	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
-
-	if (*curr_pmask & mask) { /* disallow acting twice on the same location */
-		NL_SET_ERR_MSG_MOD(extack,
-				   "curr_pmask and new mask same. Acting twice on same location");
-		goto out_err;
-	}
-
-	*curr_pmask |= mask;
-	*curr_pval  |= (val & mask);
-
-	return 0;
-
-out_err:
-	return -EOPNOTSUPP;
-}
-
 struct mlx5_fields {
 	u8  field;
 	u8  field_bsize;
@@ -2890,88 +2841,6 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 
 static const struct pedit_headers zero_masks = {};
 
-static int
-parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
-			  const struct flow_action_entry *act, int namespace,
-			  struct mlx5e_tc_flow_parse_attr *parse_attr,
-			  struct pedit_headers_action *hdrs,
-			  struct netlink_ext_ack *extack)
-{
-	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
-	int err = -EOPNOTSUPP;
-	u32 mask, val, offset;
-	u8 htype;
-
-	htype = act->mangle.htype;
-	err = -EOPNOTSUPP; /* can't be all optimistic */
-
-	if (htype == FLOW_ACT_MANGLE_UNSPEC) {
-		NL_SET_ERR_MSG_MOD(extack, "legacy pedit isn't offloaded");
-		goto out_err;
-	}
-
-	if (!mlx5e_mod_hdr_max_actions(priv->mdev, namespace)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "The pedit offload action is not supported");
-		goto out_err;
-	}
-
-	mask = act->mangle.mask;
-	val = act->mangle.val;
-	offset = act->mangle.offset;
-
-	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
-	if (err)
-		goto out_err;
-
-	hdrs[cmd].pedits++;
-
-	return 0;
-out_err:
-	return err;
-}
-
-static int
-parse_pedit_to_reformat(const struct flow_action_entry *act,
-			struct mlx5e_tc_flow_parse_attr *parse_attr,
-			struct netlink_ext_ack *extack)
-{
-	u32 mask, val, offset;
-	u32 *p;
-
-	if (act->id != FLOW_ACTION_MANGLE) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
-		return -EOPNOTSUPP;
-	}
-
-	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
-		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
-		return -EOPNOTSUPP;
-	}
-
-	mask = ~act->mangle.mask;
-	val = act->mangle.val;
-	offset = act->mangle.offset;
-	p = (u32 *)&parse_attr->eth;
-	*(p + (offset >> 2)) |= (val & mask);
-
-	return 0;
-}
-
-static int parse_tc_pedit_action(struct mlx5e_priv *priv,
-				 const struct flow_action_entry *act, int namespace,
-				 struct mlx5e_tc_flow_parse_attr *parse_attr,
-				 struct pedit_headers_action *hdrs,
-				 struct mlx5e_tc_flow *flow,
-				 struct netlink_ext_ack *extack)
-{
-	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
-		return parse_pedit_to_reformat(act, parse_attr, extack);
-
-	return parse_pedit_to_modify_hdr(priv, act, namespace,
-					 parse_attr, hdrs, extack);
-}
-
 static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
 				 struct pedit_headers_action *hdrs,
@@ -3295,7 +3164,8 @@ static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		return -EOPNOTSUPP;
 	}
 
-	err = parse_tc_pedit_action(priv, &pedit_act, namespace, parse_attr, hdrs, NULL, extack);
+	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr, hdrs,
+					      NULL, extack);
 	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	return err;
@@ -3340,7 +3210,7 @@ actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 	    !hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits)
 		return 0;
 
-	ns_type = get_flow_name_space(flow);
+	ns_type = mlx5e_get_flow_namespace(flow);
 
 	err = alloc_tc_pedit_action(priv, ns_type, parse_attr, hdrs,
 				    &attr->action, extack);
@@ -3391,9 +3261,9 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
-	struct pedit_headers_action hdrs[2] = {};
 	enum mlx5_flow_namespace_type ns_type;
 	const struct flow_action_entry *act;
+	struct pedit_headers_action *hdrs;
 	struct mlx5e_tc_act *tc_act;
 	int err, i;
 
@@ -3405,19 +3275,11 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	parse_attr = attr->parse_attr;
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
-	ns_type = get_flow_name_space(flow);
+	ns_type = mlx5e_get_flow_namespace(flow);
+	hdrs = parse_state->hdrs;
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-		case FLOW_ACTION_MANGLE:
-		case FLOW_ACTION_ADD:
-			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_KERNEL,
-						    parse_attr, hdrs, NULL, extack);
-			if (err)
-				return err;
-
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			break;
 		case FLOW_ACTION_VLAN_MANGLE:
 			err = add_vlan_rewrite_action(priv,
 						      MLX5_FLOW_NAMESPACE_KERNEL,
@@ -3776,7 +3638,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
-	struct pedit_headers_action hdrs[2] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
@@ -3788,6 +3649,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	enum mlx5_flow_namespace_type ns_type;
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
+	struct pedit_headers_action *hdrs;
 	struct mlx5e_tc_act *tc_act;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
@@ -3801,7 +3663,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	parse_attr = attr->parse_attr;
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
-	ns_type = get_flow_name_space(flow);
+	ns_type = mlx5e_get_flow_namespace(flow);
+	hdrs = parse_state->hdrs;
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
@@ -3845,18 +3708,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			flow_flag_set(flow, L3_TO_L2_DECAP);
 			break;
-		case FLOW_ACTION_MANGLE:
-		case FLOW_ACTION_ADD:
-			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_FDB,
-						    parse_attr, hdrs, flow, extack);
-			if (err)
-				return err;
-
-			if (!flow_flag_test(flow, L3_TO_L2_DECAP)) {
-				attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-				esw_attr->split_count = esw_attr->out_count;
-			}
-			break;
 		case FLOW_ACTION_REDIRECT_INGRESS: {
 			struct net_device *out_dev;
 
@@ -4255,7 +4106,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	flow->cookie = f->cookie;
 	flow->priv = priv;
 
-	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
+	attr = mlx5_alloc_flow_attr(mlx5e_get_flow_namespace(flow));
 	if (!attr)
 		goto err_free;
 
-- 
2.31.1

