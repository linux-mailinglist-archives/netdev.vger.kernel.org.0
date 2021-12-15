Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D525F47521B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbhLOFdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51412 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbhLOFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00841617E1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF4C34607;
        Wed, 15 Dec 2021 05:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546382;
        bh=V0JxryNve+afgCn0udqBrpJcP4Ww4u/1pKZBXx/7e/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OB34BcOFK0TyN/yrdQgE22DSSnVeKzhP5H9nP/HoRwfxdcAGPQc4tZfAcH+Fsw5TI
         nAB5BN1hmBUdwFEHfarVh/0ivW4kjKx6hoFued6EfhwIL+rj101e8Bh5ofJUf352gc
         rIg2FUSAZ6rc0gCBNfDAvK/CgUXOoZmJiWODy9az8xHXpJWmKmsfYCRf2H62rfeLjC
         H49FvdKn1ES7KHCWbJtVNNToRT5L+N802ECaeVvHmq5N0tos1oDhEd+gxGrFQLRW0u
         J71ehm3p/n/becbQiv5Q2PlZ3TIIV2ZT+omzQH4fryH3U6xF8JUtjoUPucDQbKKolW
         AivF7FPv+RjBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 01/16] net/mlx5e: Add tc action infrastructure
Date:   Tue, 14 Dec 2021 21:32:45 -0800
Message-Id: <20211215053300.130679-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Add an infrastructure to help parsing tc actions in a generic way.

Supporting an action parser means implementing struct mlx5e_tc_act
for that action.

The infrastructure will give the possibility to be generic when parsing tc
actions, i.e. parse_tc_nic_actions() and parse_tc_fdb_actions().
To parse tc actions a user needs to allocate a parse_state instance
and pass it when iterating over the tc actions parsers.
If a parser doesn't exists then a user can treat it as unsupported.

To add an action parser a user needs to implement two callbacks.
The can_offload() callback to quickly check if an action can be offloaded.
The parse_action() callback to do actual parsing and prepare for offload.

Add implementation for drop, trap, mark and accept action parsers with this
commit to act as examples and implement usage of the new infrastructure for
those actions.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  4 +
 .../mellanox/mlx5/core/en/tc/act/accept.c     | 31 +++++++
 .../mellanox/mlx5/core/en/tc/act/act.c        | 72 +++++++++++++++
 .../mellanox/mlx5/core/en/tc/act/act.h        | 45 ++++++++++
 .../mellanox/mlx5/core/en/tc/act/drop.c       | 30 +++++++
 .../mellanox/mlx5/core/en/tc/act/mark.c       | 35 ++++++++
 .../mellanox/mlx5/core/en/tc/act/trap.c       | 38 ++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 87 +++++++++----------
 9 files changed, 297 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e63bb9ceb9c0..46eb3f791887 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -46,6 +46,10 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o \
 					en/tc/post_act.o en/tc/int_port.o
+
+mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
+					en/tc/act/accept.o en/tc/act/mark.o
+
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
new file mode 100644
index 000000000000..b0de6b999675
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_accept(struct mlx5e_tc_act_parse_state *parse_state,
+			  const struct flow_action_entry *act,
+			  int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_accept(struct mlx5e_tc_act_parse_state *parse_state,
+		    const struct flow_action_entry *act,
+		    struct mlx5e_priv *priv,
+		    struct mlx5_flow_attr *attr)
+{
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->flags |= MLX5_ESW_ATTR_FLAG_ACCEPT;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_accept = {
+	.can_offload = tc_act_can_offload_accept,
+	.parse_action = tc_act_parse_accept,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
new file mode 100644
index 000000000000..3f940856d4b1
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+#include "mlx5_core.h"
+
+/* Must be aligned with enum flow_action_id. */
+static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
+	&mlx5e_tc_act_accept,
+	&mlx5e_tc_act_drop,
+	&mlx5e_tc_act_trap,
+};
+
+/* Must be aligned with enum flow_action_id. */
+static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
+	&mlx5e_tc_act_accept,
+	&mlx5e_tc_act_drop,
+	NULL, /* FLOW_ACTION_TRAP, */
+	NULL, /* FLOW_ACTION_GOTO, */
+	NULL, /* FLOW_ACTION_REDIRECT, */
+	NULL, /* FLOW_ACTION_MIRRED, */
+	NULL, /* FLOW_ACTION_REDIRECT_INGRESS, */
+	NULL, /* FLOW_ACTION_MIRRED_INGRESS, */
+	NULL, /* FLOW_ACTION_VLAN_PUSH, */
+	NULL, /* FLOW_ACTION_VLAN_POP, */
+	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
+	NULL, /* FLOW_ACTION_TUNNEL_ENCAP, */
+	NULL, /* FLOW_ACTION_TUNNEL_DECAP, */
+	NULL, /* FLOW_ACTION_MANGLE, */
+	NULL, /* FLOW_ACTION_ADD, */
+	NULL, /* FLOW_ACTION_CSUM, */
+	&mlx5e_tc_act_mark,
+};
+
+/**
+ * mlx5e_tc_act_get() - Get an action parser for an action id.
+ * @act_id: Flow action id.
+ * @ns_type: flow namespace type.
+ */
+struct mlx5e_tc_act *
+mlx5e_tc_act_get(enum flow_action_id act_id,
+		 enum mlx5_flow_namespace_type ns_type)
+{
+	struct mlx5e_tc_act **tc_acts;
+
+	tc_acts = ns_type == MLX5_FLOW_NAMESPACE_FDB ? tc_acts_fdb : tc_acts_nic;
+
+	return tc_acts[act_id];
+}
+
+/**
+ * mlx5e_tc_act_init_parse_state() - Init a new parse_state.
+ * @parse_state: Parsing state.
+ * @flow:        mlx5e tc flow being handled.
+ * @flow_action: flow action to parse.
+ * @extack:      to set an error msg.
+ *
+ * The same parse_state should be passed to action parsers
+ * for tracking the current parsing state.
+ */
+void
+mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
+			      struct mlx5e_tc_flow *flow,
+			      struct flow_action *flow_action,
+			      struct netlink_ext_ack *extack)
+{
+	memset(parse_state, 0, sizeof(*parse_state));
+	parse_state->flow = flow;
+	parse_state->num_actions = flow_action->num_entries;
+	parse_state->extack = extack;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
new file mode 100644
index 000000000000..70bc7b1bc08f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_TC_ACT_H__
+#define __MLX5_EN_TC_ACT_H__
+
+#include <net/flow_offload.h>
+#include <linux/netlink.h>
+#include "eswitch.h"
+
+struct mlx5_flow_attr;
+
+struct mlx5e_tc_act_parse_state {
+	unsigned int num_actions;
+	struct mlx5e_tc_flow *flow;
+	struct netlink_ext_ack *extack;
+};
+
+struct mlx5e_tc_act {
+	bool (*can_offload)(struct mlx5e_tc_act_parse_state *parse_state,
+			    const struct flow_action_entry *act,
+			    int act_index);
+
+	int (*parse_action)(struct mlx5e_tc_act_parse_state *parse_state,
+			    const struct flow_action_entry *act,
+			    struct mlx5e_priv *priv,
+			    struct mlx5_flow_attr *attr);
+};
+
+extern struct mlx5e_tc_act mlx5e_tc_act_drop;
+extern struct mlx5e_tc_act mlx5e_tc_act_trap;
+extern struct mlx5e_tc_act mlx5e_tc_act_accept;
+extern struct mlx5e_tc_act mlx5e_tc_act_mark;
+
+struct mlx5e_tc_act *
+mlx5e_tc_act_get(enum flow_action_id act_id,
+		 enum mlx5_flow_namespace_type ns_type);
+
+void
+mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
+			      struct mlx5e_tc_flow *flow,
+			      struct flow_action *flow_action,
+			      struct netlink_ext_ack *extack);
+
+#endif /* __MLX5_EN_TC_ACT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
new file mode 100644
index 000000000000..2e29a23bed12
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_drop(struct mlx5e_tc_act_parse_state *parse_state,
+			const struct flow_action_entry *act,
+			int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_drop(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
+			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_drop = {
+	.can_offload = tc_act_can_offload_drop,
+	.parse_action = tc_act_parse_drop,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
new file mode 100644
index 000000000000..d775c3d9edf3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en_tc.h"
+
+static bool
+tc_act_can_offload_mark(struct mlx5e_tc_act_parse_state *parse_state,
+			const struct flow_action_entry *act,
+			int act_index)
+{
+	if (act->mark & ~MLX5E_TC_FLOW_ID_MASK) {
+		NL_SET_ERR_MSG_MOD(parse_state->extack, "Bad flow mark, only 16 bit supported");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_mark(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	attr->nic_attr->flow_tag = act->mark;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_mark = {
+	.can_offload = tc_act_can_offload_mark,
+	.parse_action = tc_act_parse_mark,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
new file mode 100644
index 000000000000..046b64c2cec4
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_trap(struct mlx5e_tc_act_parse_state *parse_state,
+			const struct flow_action_entry *act,
+			int act_index)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+
+	if (parse_state->num_actions != 1) {
+		NL_SET_ERR_MSG_MOD(extack, "action trap is supported as a sole action only");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_trap(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_trap = {
+	.can_offload = tc_act_can_offload_trap,
+	.parse_action = tc_act_parse_trap,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index b689701ac7d8..d6057464cfd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -5,6 +5,7 @@
 #define __MLX5_EN_TC_PRIV_H__
 
 #include "en_tc.h"
+#include "en/tc/act/act.h"
 
 #define MLX5E_TC_FLOW_BASE (MLX5E_TC_FLAG_LAST_EXPORTED_BIT + 1)
 
@@ -37,6 +38,7 @@ struct mlx5e_tc_flow_parse_attr {
 	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
 	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct ethhdr eth;
+	struct mlx5e_tc_act_parse_state parse_state;
 };
 
 /* Helper struct for accessing a struct containing list_head array.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3e3419190c55..12ab29fba789 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -62,6 +62,7 @@
 #include "en/mod_hdr.h"
 #include "en/tc_tun_encap.h"
 #include "en/tc/sample.h"
+#include "en/tc/act/act.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -3468,31 +3469,27 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 		     struct mlx5e_tc_flow *flow,
 		     struct netlink_ext_ack *extack)
 {
+	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct pedit_headers_action hdrs[2] = {};
+	enum mlx5_flow_namespace_type ns_type;
 	const struct flow_action_entry *act;
-	struct mlx5_nic_flow_attr *nic_attr;
+	struct mlx5e_tc_act *tc_act;
 	int err, i;
 
 	err = flow_action_supported(flow_action, extack);
 	if (err)
 		return err;
 
-	nic_attr = attr->nic_attr;
-	nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
+	attr->nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 	parse_attr = attr->parse_attr;
+	parse_state = &parse_attr->parse_state;
+	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
+	ns_type = get_flow_name_space(flow);
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-		case FLOW_ACTION_ACCEPT:
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-					MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			break;
-		case FLOW_ACTION_DROP:
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
-					MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			break;
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_KERNEL,
@@ -3536,19 +3533,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			}
 			}
 			break;
-		case FLOW_ACTION_MARK: {
-			u32 mark = act->mark;
-
-			if (mark & ~MLX5E_TC_FLOW_ID_MASK) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Bad flow mark - only 16 bit is supported");
-				return -EOPNOTSUPP;
-			}
-
-			nic_attr->flow_tag = mark;
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-			}
-			break;
 		case FLOW_ACTION_GOTO:
 			err = validate_goto_chain(priv, flow, act, extack);
 			if (err)
@@ -3568,10 +3552,21 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, CT);
 			break;
 		default:
-			NL_SET_ERR_MSG_MOD(extack,
-					   "The offload action is not supported in NIC action");
+			break;
+		}
+
+		tc_act = mlx5e_tc_act_get(act->id, ns_type);
+		if (!tc_act) {
+			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
 			return -EOPNOTSUPP;
 		}
+
+		if (!tc_act->can_offload(parse_state, act, i))
+			return -EOPNOTSUPP;
+
+		err = tc_act->parse_action(parse_state, act, priv, attr);
+		if (err)
+			return err;
 	}
 
 	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
@@ -3880,6 +3875,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 {
 	struct pedit_headers_action hdrs[2] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5e_sample_attr sample_attr = {};
@@ -3887,9 +3883,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5_flow_attr *attr = flow->attr;
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	bool ft_flow = mlx5e_is_ft_flow(flow);
+	enum mlx5_flow_namespace_type ns_type;
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
 	bool encap = false, decap = false;
+	struct mlx5e_tc_act *tc_act;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
 	bool mpls_push = false;
@@ -3900,14 +3898,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	esw_attr = attr->esw_attr;
 	parse_attr = attr->parse_attr;
+	parse_state = &parse_attr->parse_state;
+	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
+	ns_type = get_flow_name_space(flow);
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-		case FLOW_ACTION_ACCEPT:
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-					MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			attr->flags |= MLX5_ESW_ATTR_FLAG_ACCEPT;
-			break;
 		case FLOW_ACTION_PTYPE:
 			if (act->ptype != PACKET_HOST) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -3917,20 +3913,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			ptype_host = true;
 			break;
-		case FLOW_ACTION_DROP:
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
-					MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			break;
-		case FLOW_ACTION_TRAP:
-			if (!flow_offload_has_one_action(flow_action)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "action trap is supported as a sole action only");
-				return -EOPNOTSUPP;
-			}
-			attr->action |= (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-					 MLX5_FLOW_CONTEXT_ACTION_COUNT);
-			attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
-			break;
 		case FLOW_ACTION_MPLS_PUSH:
 			if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
 							reformat_l2_to_l3_tunnel) ||
@@ -4237,10 +4219,21 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, SAMPLE);
 			break;
 		default:
-			NL_SET_ERR_MSG_MOD(extack,
-					   "The offload action is not supported in FDB action");
+			break;
+		}
+
+		tc_act = mlx5e_tc_act_get(act->id, ns_type);
+		if (!tc_act) {
+			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
 			return -EOPNOTSUPP;
 		}
+
+		if (!tc_act->can_offload(parse_state, act, i))
+			return -EOPNOTSUPP;
+
+		err = tc_act->parse_action(parse_state, act, priv, attr);
+		if (err)
+			return err;
 	}
 
 	/* Forward to/from internal port can only have 1 dest */
-- 
2.31.1

