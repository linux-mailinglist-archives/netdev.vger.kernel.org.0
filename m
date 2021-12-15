Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F877475223
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhLOFdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbhLOFdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BB6C061401
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 21:33:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A90406181B
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F27C34607;
        Wed, 15 Dec 2021 05:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546387;
        bh=S7Bow1aUvxB48U0mAs0ODb4sSOWErSd2UHQwisp5a8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpVPSQ16NsIGAAX47qpoT3L/I0HJ7ZDBdscTdA+tJTRYSXfNGYpVvEvQQ4vHK5y/Y
         ibXatYuYqwOwjNLBhSUdIckXm4GUWB8R6IAnvQlqVOAXWWqYQeqzicDctAjuKQwle4
         P5aCQ6D9ybg6vOV6jO9kHSU8kZpKFNJv1D0uJIn/lzGljV9mWZBBjMS//fNepUhGtS
         xNeq0OvmpqQ2ZyBv+3VFA6c9gtRPKLl2EQlNxd6NFvf/1eewOgwUn7Whf8+KvucaSs
         MXZxDSPlKWLMXQrttnKiivGYL5KtUlqaDkMlTSjYX+lSzU4djrgUGS/hxIdPn6+oj+
         v8aDAtyeh2LZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 10/16] net/mlx5e: Add sample and ptype to tc_action infra
Date:   Tue, 14 Dec 2021 21:32:54 -0800
Message-Id: <20211215053300.130679-11-saeed@kernel.org>
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
 .../mellanox/mlx5/core/en/tc/act/act.c        |  4 +-
 .../mellanox/mlx5/core/en/tc/act/act.h        |  4 ++
 .../mellanox/mlx5/core/en/tc/act/ptype.c      | 35 ++++++++++++++
 .../mellanox/mlx5/core/en/tc/act/sample.c     | 46 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 27 +----------
 6 files changed, 90 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 5f2258275ff6..83f2b4d69e4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -52,7 +52,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o \
 					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o \
 					en/tc/act/mirred.o en/tc/act/mirred_nic.o \
-					en/tc/act/ct.o
+					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 9813a6321a9e..de25444464fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -24,11 +24,11 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	&mlx5e_tc_act_pedit,
 	&mlx5e_tc_act_csum,
 	NULL, /* FLOW_ACTION_MARK, */
-	NULL, /* FLOW_ACTION_PTYPE, */
+	&mlx5e_tc_act_ptype,
 	NULL, /* FLOW_ACTION_PRIORITY, */
 	NULL, /* FLOW_ACTION_WAKE, */
 	NULL, /* FLOW_ACTION_QUEUE, */
-	NULL, /* FLOW_ACTION_SAMPLE, */
+	&mlx5e_tc_act_sample,
 	NULL, /* FLOW_ACTION_POLICE, */
 	&mlx5e_tc_act_ct,
 	NULL, /* FLOW_ACTION_CT_METADATA, */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 5b92ffbf4819..2f92248091ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -19,11 +19,13 @@ struct mlx5e_tc_act_parse_state {
 	bool encap;
 	bool decap;
 	bool mpls_push;
+	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
 	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
 	struct mlx5_tc_ct_priv *ct_priv;
+	struct mlx5e_sample_attr sample_attr;
 };
 
 struct mlx5e_tc_act {
@@ -53,6 +55,8 @@ extern struct mlx5e_tc_act mlx5e_tc_act_mpls_pop;
 extern struct mlx5e_tc_act mlx5e_tc_act_mirred;
 extern struct mlx5e_tc_act mlx5e_tc_act_mirred_nic;
 extern struct mlx5e_tc_act mlx5e_tc_act_ct;
+extern struct mlx5e_tc_act mlx5e_tc_act_sample;
+extern struct mlx5e_tc_act mlx5e_tc_act_ptype;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
new file mode 100644
index 000000000000..0819110193dc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_ptype(struct mlx5e_tc_act_parse_state *parse_state,
+			 const struct flow_action_entry *act,
+			 int act_index)
+{
+	return true;
+}
+
+static int
+tc_act_parse_ptype(struct mlx5e_tc_act_parse_state *parse_state,
+		   const struct flow_action_entry *act,
+		   struct mlx5e_priv *priv,
+		   struct mlx5_flow_attr *attr)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+
+	if (act->ptype != PACKET_HOST) {
+		NL_SET_ERR_MSG_MOD(extack, "skbedit ptype is only supported with type host");
+		return -EOPNOTSUPP;
+	}
+
+	parse_state->ptype_host = true;
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_ptype = {
+	.can_offload = tc_act_can_offload_ptype,
+	.parse_action = tc_act_parse_ptype,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
new file mode 100644
index 000000000000..0d37fb0cad7c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <net/psample.h>
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_sample(struct mlx5e_tc_act_parse_state *parse_state,
+			  const struct flow_action_entry *act,
+			  int act_index)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+
+	if (flow_flag_test(parse_state->flow, CT)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Sample action with connection tracking is not supported");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
+		    const struct flow_action_entry *act,
+		    struct mlx5e_priv *priv,
+		    struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_sample_attr *sample_attr = &parse_state->sample_attr;
+
+	sample_attr->rate = act->sample.rate;
+	sample_attr->group_num = act->sample.psample_group->group_num;
+
+	if (act->sample.truncate)
+		sample_attr->trunc_size = act->sample.trunc_size;
+
+	flow_flag_set(parse_state->flow, SAMPLE);
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_sample = {
+	.can_offload = tc_act_can_offload_sample,
+	.parse_action = tc_act_parse_sample,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 03ae519bfa4c..039284964e20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -39,7 +39,6 @@
 #include <linux/rhashtable.h>
 #include <linux/refcount.h>
 #include <linux/completion.h>
-#include <net/psample.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include <net/bareudp.h>
@@ -3346,14 +3345,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5e_sample_attr sample_attr = {};
 	struct mlx5_flow_attr *attr = flow->attr;
 	enum mlx5_flow_namespace_type ns_type;
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct pedit_headers_action *hdrs;
 	struct mlx5e_tc_act *tc_act;
-	bool ptype_host = false;
 	int err, i;
 
 	err = flow_action_supported(flow_action, extack);
@@ -3370,15 +3367,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-		case FLOW_ACTION_PTYPE:
-			if (act->ptype != PACKET_HOST) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "skbedit ptype is only supported with type host");
-				return -EOPNOTSUPP;
-			}
-
-			ptype_host = true;
-			break;
 		case FLOW_ACTION_REDIRECT_INGRESS: {
 			struct net_device *out_dev;
 
@@ -3398,7 +3386,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			if (!ptype_host) {
+			if (!parse_state->ptype_host) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "redirect to int port ingress requires ptype=host action");
 				return -EOPNOTSUPP;
@@ -3423,17 +3411,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			break;
 		}
-		case FLOW_ACTION_SAMPLE:
-			if (flow_flag_test(flow, CT)) {
-				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
-				return -EOPNOTSUPP;
-			}
-			sample_attr.rate = act->sample.rate;
-			sample_attr.group_num = act->sample.psample_group->group_num;
-			if (act->sample.truncate)
-				sample_attr.trunc_size = act->sample.trunc_size;
-			flow_flag_set(flow, SAMPLE);
-			break;
 		default:
 			break;
 		}
@@ -3500,7 +3477,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		attr->sample_attr = kzalloc(sizeof(*attr->sample_attr), GFP_KERNEL);
 		if (!attr->sample_attr)
 			return -ENOMEM;
-		*attr->sample_attr = sample_attr;
+		*attr->sample_attr = parse_state->sample_attr;
 	}
 
 	return 0;
-- 
2.31.1

