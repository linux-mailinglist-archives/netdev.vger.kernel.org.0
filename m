Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F91475227
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239927AbhLOFdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48202 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbhLOFdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4702B81EA5
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DBAC34609;
        Wed, 15 Dec 2021 05:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546387;
        bh=9ZtBnL51KByT3KqEQ4pyW/uTkp5IqjRw7H4EaWEKERU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNd7LMN6hQuef/2u/cwdcnkv2/kau5WwNHxDhdKFt8WTV+Gj4WjqV7yYLEVi3q6M1
         rjcsFWYK9zz02Z+s5hNHcbMhsnAzjx8novznmveddJVCE2zQ1SK0lhqYXoR5HUIY3f
         vLaqjXdQXxQHIODy152RkfaFee0jaeK45d3dv47qrCRWgfos9PT+4X5THNBkS2Aen1
         Fd+Cqa8Zbk56cBIyFQKn4t/97vkaPdEYevjc5HPXLXg4fLbgY6siX4sZD8GzH9Fedd
         jktvhftb2kgfQnyisEadVR1KsXRedRy1rzB32HAfquvQ1UssPoCDLoaWoIGVGo7ivw
         3ptV5T9W4QQng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 11/16] net/mlx5e: Add redirect ingress to tc action infra
Date:   Tue, 14 Dec 2021 21:32:55 -0800
Message-Id: <20211215053300.130679-12-saeed@kernel.org>
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
 .../mellanox/mlx5/core/en/tc/act/act.c        |  2 +-
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mlx5/core/en/tc/act/redirect_ingress.c    | 79 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 49 ------------
 5 files changed, 83 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 83f2b4d69e4f..e592e0955c71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -52,7 +52,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o \
 					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o \
 					en/tc/act/mirred.o en/tc/act/mirred_nic.o \
-					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o
+					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o \
+					en/tc/act/redirect_ingress.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index de25444464fb..e600924e30ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -13,7 +13,7 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	&mlx5e_tc_act_goto,
 	&mlx5e_tc_act_mirred,
 	&mlx5e_tc_act_mirred,
-	NULL, /* FLOW_ACTION_REDIRECT_INGRESS, */
+	&mlx5e_tc_act_redirect_ingress,
 	NULL, /* FLOW_ACTION_MIRRED_INGRESS, */
 	&mlx5e_tc_act_vlan,
 	&mlx5e_tc_act_vlan,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 2f92248091ac..51c9b9177f28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -57,6 +57,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_mirred_nic;
 extern struct mlx5e_tc_act mlx5e_tc_act_ct;
 extern struct mlx5e_tc_act mlx5e_tc_act_sample;
 extern struct mlx5e_tc_act mlx5e_tc_act_ptype;
+extern struct mlx5e_tc_act mlx5e_tc_act_redirect_ingress;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
new file mode 100644
index 000000000000..1c32e24e528d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_redirect_ingress(struct mlx5e_tc_act_parse_state *parse_state,
+				    const struct flow_action_entry *act,
+				    int act_index)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct net_device *out_dev = act->dev;
+	struct mlx5_esw_flow_attr *esw_attr;
+
+	parse_attr = flow->attr->parse_attr;
+	esw_attr = flow->attr->esw_attr;
+
+	if (!out_dev)
+		return false;
+
+	if (!netif_is_ovs_master(out_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "redirect to ingress is supported only for OVS internal ports");
+		return false;
+	}
+
+	if (netif_is_ovs_master(parse_attr->filter_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "redirect to ingress is not supported from internal port");
+		return false;
+	}
+
+	if (!parse_state->ptype_host) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "redirect to int port ingress requires ptype=host action");
+		return false;
+	}
+
+	if (esw_attr->out_count) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "redirect to int port ingress is supported only as single destination");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_redirect_ingress(struct mlx5e_tc_act_parse_state *parse_state,
+			      const struct flow_action_entry *act,
+			      struct mlx5e_priv *priv,
+			      struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct net_device *out_dev = act->dev;
+	int err;
+
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
+	err = mlx5e_set_fwd_to_int_port_actions(priv, attr, out_dev->ifindex,
+						MLX5E_TC_INT_PORT_INGRESS,
+						&attr->action, esw_attr->out_count);
+	if (err)
+		return err;
+
+	esw_attr->out_count++;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_redirect_ingress = {
+	.can_offload = tc_act_can_offload_redirect_ingress,
+	.parse_action = tc_act_parse_redirect_ingress,
+};
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 039284964e20..7fc89d41d971 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3366,55 +3366,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	hdrs = parse_state->hdrs;
 
 	flow_action_for_each(i, act, flow_action) {
-		switch (act->id) {
-		case FLOW_ACTION_REDIRECT_INGRESS: {
-			struct net_device *out_dev;
-
-			out_dev = act->dev;
-			if (!out_dev)
-				return -EOPNOTSUPP;
-
-			if (!netif_is_ovs_master(out_dev)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "redirect to ingress is supported only for OVS internal ports");
-				return -EOPNOTSUPP;
-			}
-
-			if (netif_is_ovs_master(parse_attr->filter_dev)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "redirect to ingress is not supported from internal port");
-				return -EOPNOTSUPP;
-			}
-
-			if (!parse_state->ptype_host) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "redirect to int port ingress requires ptype=host action");
-				return -EOPNOTSUPP;
-			}
-
-			if (esw_attr->out_count) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "redirect to int port ingress is supported only as single destination");
-				return -EOPNOTSUPP;
-			}
-
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-					MLX5_FLOW_CONTEXT_ACTION_COUNT;
-
-			err = mlx5e_set_fwd_to_int_port_actions(priv, attr, out_dev->ifindex,
-								MLX5E_TC_INT_PORT_INGRESS,
-								&attr->action, esw_attr->out_count);
-			if (err)
-				return err;
-
-			esw_attr->out_count++;
-
-			break;
-		}
-		default:
-			break;
-		}
-
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act) {
 			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
-- 
2.31.1

