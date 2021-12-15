Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E450B47521F
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbhLOFdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbhLOFdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5498C06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 21:33:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC4E6B81E48
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CB1C3460C;
        Wed, 15 Dec 2021 05:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546383;
        bh=NKfe4sfgkD2IbKbeXLVGLWq0Y3aZBdxn1u8x3q/SZ+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIpfgaKcJYJok+I34in2NayNEA/ukBHMJnArhOa4mGPSnSAFtj+s5gsw7FPnUVtGz
         hYo5BHPlcS8wg16aDPXe5xc3e51vkVnB5Jmh46qnypcXT5jW5qjuGHNRV7Obn3Xvqx
         36vhhc2kHcg/Xjz1Yt5BeaSm/TzX8wiHieuG0jpIveWGTblh1LtEquwfa63079d42m
         ZWAL0zyqmMKUxc7KeoVnLMFp7x4PVHqv8G/ChD2wbXPvsmWPHtvPBzKQWwPdUKAjHj
         rK0d6Hu89ATTOcxoibzyzueKqHqN32IrhKXy/bAvbmYA8h6Z+SQx67fa7xu9/8uZMe
         jZ/aoP/lWEdSA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 03/16] net/mlx5e: Add tunnel encap/decap to tc action infra
Date:   Tue, 14 Dec 2021 21:32:47 -0800
Message-Id: <20211215053300.130679-4-saeed@kernel.org>
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
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |  9 +++
 .../mellanox/mlx5/core/en/tc/act/act.h        |  5 ++
 .../mellanox/mlx5/core/en/tc/act/tun.c        | 61 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 24 ++------
 5 files changed, 81 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 0f3dd6e97023..407e42c6f062 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -48,7 +48,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/tc/post_act.o en/tc/int_port.o
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
-					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o
+					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
+					en/tc/act/tun.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 6be1d1c7476c..4b406153db72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -11,6 +11,15 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	&mlx5e_tc_act_drop,
 	&mlx5e_tc_act_trap,
 	&mlx5e_tc_act_goto,
+	NULL, /* FLOW_ACTION_REDIRECT, */
+	NULL, /* FLOW_ACTION_MIRRED, */
+	NULL, /* FLOW_ACTION_REDIRECT_INGRESS, */
+	NULL, /* FLOW_ACTION_MIRRED_INGRESS, */
+	NULL, /* FLOW_ACTION_VLAN_PUSH, */
+	NULL, /* FLOW_ACTION_VLAN_POP, */
+	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
+	&mlx5e_tc_act_tun_encap,
+	&mlx5e_tc_act_tun_decap,
 };
 
 /* Must be aligned with enum flow_action_id. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index b72fc0c89b6f..b0d6333b24a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -14,6 +14,9 @@ struct mlx5e_tc_act_parse_state {
 	unsigned int num_actions;
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
+	bool encap;
+	bool decap;
+	const struct ip_tunnel_info *tun_info;
 };
 
 struct mlx5e_tc_act {
@@ -32,6 +35,8 @@ extern struct mlx5e_tc_act mlx5e_tc_act_trap;
 extern struct mlx5e_tc_act mlx5e_tc_act_accept;
 extern struct mlx5e_tc_act mlx5e_tc_act_mark;
 extern struct mlx5e_tc_act mlx5e_tc_act_goto;
+extern struct mlx5e_tc_act mlx5e_tc_act_tun_encap;
+extern struct mlx5e_tc_act mlx5e_tc_act_tun_decap;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
new file mode 100644
index 000000000000..6f4a2cf46afd
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_tun_encap.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_tun_encap(struct mlx5e_tc_act_parse_state *parse_state,
+			     const struct flow_action_entry *act,
+			     int act_index)
+{
+	if (!act->tunnel) {
+		NL_SET_ERR_MSG_MOD(parse_state->extack,
+				   "Zero tunnel attributes is not supported");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_tun_encap(struct mlx5e_tc_act_parse_state *parse_state,
+		       const struct flow_action_entry *act,
+		       struct mlx5e_priv *priv,
+		       struct mlx5_flow_attr *attr)
+{
+	parse_state->tun_info = act->tunnel;
+	parse_state->encap = true;
+
+	return 0;
+}
+
+static bool
+tc_act_can_offload_tun_decap(struct mlx5e_tc_act_parse_state *parse_state,
+			     const struct flow_action_entry *act,
+			     int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_tun_decap(struct mlx5e_tc_act_parse_state *parse_state,
+		       const struct flow_action_entry *act,
+		       struct mlx5e_priv *priv,
+		       struct mlx5_flow_attr *attr)
+{
+	parse_state->decap = true;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_tun_encap = {
+	.can_offload = tc_act_can_offload_tun_encap,
+	.parse_action = tc_act_parse_tun_encap,
+};
+
+struct mlx5e_tc_act mlx5e_tc_act_tun_decap = {
+	.can_offload = tc_act_can_offload_tun_decap,
+	.parse_action = tc_act_parse_tun_decap,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1455e4fcd322..8b96d88d1691 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3819,14 +3819,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5e_sample_attr sample_attr = {};
-	const struct ip_tunnel_info *info = NULL;
 	struct mlx5_flow_attr *attr = flow->attr;
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	enum mlx5_flow_namespace_type ns_type;
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
-	bool encap = false, decap = false;
 	struct mlx5e_tc_act *tc_act;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
@@ -3985,14 +3983,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 					MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			if (encap) {
+			if (parse_state->encap) {
 				parse_attr->mirred_ifindex[esw_attr->out_count] =
 					out_dev->ifindex;
 				parse_attr->tun_info[esw_attr->out_count] =
-					mlx5e_dup_tun_info(info);
+					mlx5e_dup_tun_info(parse_state->tun_info);
 				if (!parse_attr->tun_info[esw_attr->out_count])
 					return -ENOMEM;
-				encap = false;
+				parse_state->encap = false;
 				esw_attr->dests[esw_attr->out_count].flags |=
 					MLX5_ESW_DEST_ENCAP;
 				esw_attr->out_count++;
@@ -4080,17 +4078,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 			}
-			break;
-		case FLOW_ACTION_TUNNEL_ENCAP:
-			info = act->tunnel;
-			if (info) {
-				encap = true;
-			} else {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Zero tunnel attributes is not supported");
-				return -EOPNOTSUPP;
-			}
-
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
 		case FLOW_ACTION_VLAN_POP:
@@ -4121,9 +4108,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			esw_attr->split_count = esw_attr->out_count;
 			break;
-		case FLOW_ACTION_TUNNEL_DECAP:
-			decap = true;
-			break;
 		case FLOW_ACTION_CT:
 			if (flow_flag_test(flow, SAMPLE)) {
 				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
@@ -4194,7 +4178,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-	if (attr->dest_chain && decap) {
+	if (attr->dest_chain && parse_state->decap) {
 		/* It can be supported if we'll create a mapping for
 		 * the tunnel device only (without tunnel), and set
 		 * this tunnel id with this decap flow.
-- 
2.31.1

