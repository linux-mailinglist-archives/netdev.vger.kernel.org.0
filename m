Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2A47521D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbhLOFdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239888AbhLOFdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80F646181E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95569C34600;
        Wed, 15 Dec 2021 05:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546383;
        bh=W8clpAwE2vBtOZT/feZfnSEyTXLPFwjo3pzJx0G1lx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOd8Y8kVzK1f6YrH6e19hSL96xat/fJ3vR0q2nTjDbk+F2Q8udYqEHw614QOVSStK
         D8vYY/hSM7Evj0GO7woCiscewGMTzloUh1J0BlhtaBK4aC3Ln+NctoMZXHR6P4uZP2
         lvrzqhWPS+0+FLDYbkz4WXYoRPYTICqPKUuNuPXEwIdt4ujYrEIFcxXzrSP8pXQ+a0
         xfM48SlfIqYVLMEttVE/sryA1usMPmJ0NCM7aQ9f4Gn2D1GSrFCWY/3hDYTEypzWQM
         i/Tl/THNIILjzdXSnVeVV1by0XT0KGXwg6VeDmOGCxMK+RwE/szAWw4RAEhvSbD9Uk
         ePoJabj40KD/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 04/16] net/mlx5e: Add csum to tc action infra
Date:   Tue, 14 Dec 2021 21:32:48 -0800
Message-Id: <20211215053300.130679-5-saeed@kernel.org>
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
 .../mellanox/mlx5/core/en/tc/act/act.c        |  5 +-
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/csum.c       | 61 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 43 -------------
 5 files changed, 67 insertions(+), 45 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 407e42c6f062..c148d0fea6f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -49,7 +49,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
-					en/tc/act/tun.o
+					en/tc/act/tun.o en/tc/act/csum.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 4b406153db72..449a9425f107 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -20,6 +20,9 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
 	&mlx5e_tc_act_tun_encap,
 	&mlx5e_tc_act_tun_decap,
+	NULL, /* FLOW_ACTION_MANGLE, */
+	NULL, /* FLOW_ACTION_ADD, */
+	&mlx5e_tc_act_csum,
 };
 
 /* Must be aligned with enum flow_action_id. */
@@ -39,7 +42,7 @@ static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_TUNNEL_DECAP, */
 	NULL, /* FLOW_ACTION_MANGLE, */
 	NULL, /* FLOW_ACTION_ADD, */
-	NULL, /* FLOW_ACTION_CSUM, */
+	&mlx5e_tc_act_csum,
 	&mlx5e_tc_act_mark,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index b0d6333b24a3..da19484add62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -37,6 +37,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_mark;
 extern struct mlx5e_tc_act mlx5e_tc_act_goto;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_encap;
 extern struct mlx5e_tc_act mlx5e_tc_act_tun_decap;
+extern struct mlx5e_tc_act mlx5e_tc_act_csum;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
new file mode 100644
index 000000000000..29920ef0180a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/tc_act/tc_csum.h>
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+csum_offload_supported(struct mlx5e_priv *priv,
+		       u32 action,
+		       u32 update_flags,
+		       struct netlink_ext_ack *extack)
+{
+	u32 prot_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR | TCA_CSUM_UPDATE_FLAG_TCP |
+			 TCA_CSUM_UPDATE_FLAG_UDP;
+
+	/*  The HW recalcs checksums only if re-writing headers */
+	if (!(action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "TC csum action is only offloaded with pedit");
+		netdev_warn(priv->netdev,
+			    "TC csum action is only offloaded with pedit\n");
+		return false;
+	}
+
+	if (update_flags & ~prot_flags) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload TC csum action for some header/s");
+		netdev_warn(priv->netdev,
+			    "can't offload TC csum action for some header/s - flags %#x\n",
+			    update_flags);
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+tc_act_can_offload_csum(struct mlx5e_tc_act_parse_state *parse_state,
+			const struct flow_action_entry *act,
+			int act_index)
+{
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+
+	return csum_offload_supported(flow->priv, flow->attr->action,
+				      act->csum_flags, parse_state->extack);
+}
+
+static int
+tc_act_parse_csum(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_csum = {
+	.can_offload = tc_act_can_offload_csum,
+	.parse_action = tc_act_parse_csum,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8b96d88d1691..73132517c6a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -41,7 +41,6 @@
 #include <linux/completion.h>
 #include <linux/if_macvlan.h>
 #include <net/tc_act/tc_pedit.h>
-#include <net/tc_act/tc_csum.h>
 #include <net/psample.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
@@ -3008,35 +3007,6 @@ static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 	return err;
 }
 
-static bool csum_offload_supported(struct mlx5e_priv *priv,
-				   u32 action,
-				   u32 update_flags,
-				   struct netlink_ext_ack *extack)
-{
-	u32 prot_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR | TCA_CSUM_UPDATE_FLAG_TCP |
-			 TCA_CSUM_UPDATE_FLAG_UDP;
-
-	/*  The HW recalcs checksums only if re-writing headers */
-	if (!(action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "TC csum action is only offloaded with pedit");
-		netdev_warn(priv->netdev,
-			    "TC csum action is only offloaded with pedit\n");
-		return false;
-	}
-
-	if (update_flags & ~prot_flags) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "can't offload TC csum action for some header/s");
-		netdev_warn(priv->netdev,
-			    "can't offload TC csum action for some header/s - flags %#x\n",
-			    update_flags);
-		return false;
-	}
-
-	return true;
-}
-
 struct ip_ttl_word {
 	__u8	ttl;
 	__u8	protocol;
@@ -3457,13 +3427,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 				return err;
 
 			break;
-		case FLOW_ACTION_CSUM:
-			if (csum_offload_supported(priv, attr->action,
-						   act->csum_flags,
-						   extack))
-				break;
-
-			return -EOPNOTSUPP;
 		case FLOW_ACTION_REDIRECT: {
 			struct net_device *peer_dev = act->dev;
 
@@ -3894,12 +3857,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				esw_attr->split_count = esw_attr->out_count;
 			}
 			break;
-		case FLOW_ACTION_CSUM:
-			if (csum_offload_supported(priv, attr->action,
-						   act->csum_flags, extack))
-				break;
-
-			return -EOPNOTSUPP;
 		case FLOW_ACTION_REDIRECT_INGRESS: {
 			struct net_device *out_dev;
 
-- 
2.31.1

