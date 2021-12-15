Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E92475220
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhLOFdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51488 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239900AbhLOFdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A20617E1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C9BC34608;
        Wed, 15 Dec 2021 05:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546385;
        bh=U7uijacCTLkoEqo/3HPrImINgIPeXpCfCNpocKggMq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tqdtq8+1Z/56U5N3iZMCCdOiLYXye9qFXwQPjgIeBHMNPMPSFeMuUowHDQ4RlhOpV
         NGKUS6NLsskSwX3wkZynysI8k3IRJaMqiWULTBOk6VI/K/AQozNuM0YAc3bgaHR3ms
         fW1Z3QHqtzG/hhaw8MjdbsF3jwreHxkbzOJv+jKHeDcPjTnSaec6X1cKYlucXy2+3W
         cX+rBdgYx0dJ4aG/2ARPikmGsux6V7qbEwcP11wckgHKSrK5/7RxLtjyReU8vAHm5Q
         7035AxCp8T7t6Xgltz6OV8mUL6e5HFtaTalAWxkxUVQV37Ie5Jz//fIZwo78B7TWEq
         JhoebIKVpwKvA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 07/16] net/mlx5e: Add mpls push/pop to tc action infra
Date:   Tue, 14 Dec 2021 21:32:51 -0800
Message-Id: <20211215053300.130679-8-saeed@kernel.org>
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
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        | 11 +++
 .../mellanox/mlx5/core/en/tc/act/act.h        |  3 +
 .../mellanox/mlx5/core/en/tc/act/mpls.c       | 86 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 34 +-------
 5 files changed, 102 insertions(+), 34 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 074482b5bc96..530acd000d6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -50,7 +50,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
 					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o \
-					en/tc/act/vlan.o en/tc/act/vlan_mangle.o
+					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index deeeb7f61220..e4a96f24e7b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -23,6 +23,17 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	&mlx5e_tc_act_pedit,
 	&mlx5e_tc_act_pedit,
 	&mlx5e_tc_act_csum,
+	NULL, /* FLOW_ACTION_MARK, */
+	NULL, /* FLOW_ACTION_PTYPE, */
+	NULL, /* FLOW_ACTION_PRIORITY, */
+	NULL, /* FLOW_ACTION_WAKE, */
+	NULL, /* FLOW_ACTION_QUEUE, */
+	NULL, /* FLOW_ACTION_SAMPLE, */
+	NULL, /* FLOW_ACTION_POLICE, */
+	NULL, /* FLOW_ACTION_CT, */
+	NULL, /* FLOW_ACTION_CT_METADATA, */
+	&mlx5e_tc_act_mpls_push,
+	&mlx5e_tc_act_mpls_pop,
 };
 
 /* Must be aligned with enum flow_action_id. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index bf3bc791519a..a442a282f163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -18,6 +18,7 @@ struct mlx5e_tc_act_parse_state {
 	struct netlink_ext_ack *extack;
 	bool encap;
 	bool decap;
+	bool mpls_push;
 	const struct ip_tunnel_info *tun_info;
 	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 };
@@ -44,6 +45,8 @@ extern struct mlx5e_tc_act mlx5e_tc_act_csum;
 extern struct mlx5e_tc_act mlx5e_tc_act_pedit;
 extern struct mlx5e_tc_act mlx5e_tc_act_vlan;
 extern struct mlx5e_tc_act mlx5e_tc_act_vlan_mangle;
+extern struct mlx5e_tc_act mlx5e_tc_act_mpls_push;
+extern struct mlx5e_tc_act mlx5e_tc_act_mpls_pop;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
new file mode 100644
index 000000000000..784fc4f68b1e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <net/bareudp.h>
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
+			     const struct flow_action_entry *act,
+			     int act_index)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_priv *priv = parse_state->flow->priv;
+
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, reformat_l2_to_l3_tunnel) ||
+	    act->mpls_push.proto != htons(ETH_P_MPLS_UC)) {
+		NL_SET_ERR_MSG_MOD(extack, "mpls push is supported only for mpls_uc protocol");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
+		       const struct flow_action_entry *act,
+		       struct mlx5e_priv *priv,
+		       struct mlx5_flow_attr *attr)
+{
+	parse_state->mpls_push = true;
+
+	return 0;
+}
+
+static bool
+tc_act_can_offload_mpls_pop(struct mlx5e_tc_act_parse_state *parse_state,
+			    const struct flow_action_entry *act,
+			    int act_index)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+	struct net_device *filter_dev;
+
+	filter_dev = flow->attr->parse_attr->filter_dev;
+
+	/* we only support mpls pop if it is the first action
+	 * and the filter net device is bareudp. Subsequent
+	 * actions can be pedit and the last can be mirred
+	 * egress redirect.
+	 */
+	if (act_index) {
+		NL_SET_ERR_MSG_MOD(extack, "mpls pop supported only as first action");
+		return false;
+	}
+
+	if (!netif_is_bareudp(filter_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "mpls pop supported only on bareudp devices");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_mpls_pop(struct mlx5e_tc_act_parse_state *parse_state,
+		      const struct flow_action_entry *act,
+		      struct mlx5e_priv *priv,
+		      struct mlx5_flow_attr *attr)
+{
+	attr->parse_attr->eth.h_proto = act->mpls_pop.proto;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+	flow_flag_set(parse_state->flow, L3_TO_L2_DECAP);
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_mpls_push = {
+	.can_offload = tc_act_can_offload_mpls_push,
+	.parse_action = tc_act_parse_mpls_push,
+};
+
+struct mlx5e_tc_act mlx5e_tc_act_mpls_pop = {
+	.can_offload = tc_act_can_offload_mpls_pop,
+	.parse_action = tc_act_parse_mpls_pop,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6e1b02b8eda6..9602d2fb7736 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3481,7 +3481,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_act *tc_act;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
-	bool mpls_push = false;
 
 	err = flow_action_supported(flow_action, extack);
 	if (err)
@@ -3505,37 +3504,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			ptype_host = true;
 			break;
-		case FLOW_ACTION_MPLS_PUSH:
-			if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
-							reformat_l2_to_l3_tunnel) ||
-			    act->mpls_push.proto != htons(ETH_P_MPLS_UC)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "mpls push is supported only for mpls_uc protocol");
-				return -EOPNOTSUPP;
-			}
-			mpls_push = true;
-			break;
-		case FLOW_ACTION_MPLS_POP:
-			/* we only support mpls pop if it is the first action
-			 * and the filter net device is bareudp. Subsequent
-			 * actions can be pedit and the last can be mirred
-			 * egress redirect.
-			 */
-			if (i) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "mpls pop supported only as first action");
-				return -EOPNOTSUPP;
-			}
-			if (!netif_is_bareudp(parse_attr->filter_dev)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "mpls pop supported only on bareudp devices");
-				return -EOPNOTSUPP;
-			}
-
-			parse_attr->eth.h_proto = act->mpls_pop.proto;
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-			flow_flag_set(flow, L3_TO_L2_DECAP);
-			break;
 		case FLOW_ACTION_REDIRECT_INGRESS: {
 			struct net_device *out_dev;
 
@@ -3594,7 +3562,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EINVAL;
 			}
 
-			if (mpls_push && !netif_is_bareudp(out_dev)) {
+			if (parse_state->mpls_push && !netif_is_bareudp(out_dev)) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "mpls is supported only through a bareudp device");
 				return -EOPNOTSUPP;
-- 
2.31.1

