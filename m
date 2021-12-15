Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7828E475224
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbhLOFdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239893AbhLOFdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C282F61826
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8DC34600;
        Wed, 15 Dec 2021 05:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546386;
        bh=RqoSRxlQEfJMHZvTAlgo1Gp53HAm17ShBt3GdNGhDkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lh+NbCMmY+EpMi8tp03wtCaUxlifOYukPhhwoRuBcc0dCkQzWCfFs8PeouvrbmeK7
         e7mSrrNe+S7Z0eDQ38KyNELnNkDh5F6slzXaPJRQsHY3VcHfWtnparqcubdDs7zkOq
         SXBzGsPhPBiuRrGeU8vvr8A/H2jkpE3wV/HlWogeHVdEEaRS6Oy7v6qLIcI09A+w1+
         eEd0R+uUDZXArzFnOTcJgMGO+vTczFJRevGk3AOBqySJt5RPQ76IoUz4bEPb6S5t9u
         cyzoj4bA8pckRGoTyvBkrZ7cEYUZm1AEQaz1ywZ1xySW0mNr9+nMagZKOTbEca/sHX
         3kKeNanJVXG1w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 09/16] net/mlx5e: Add ct to tc action infra
Date:   Tue, 14 Dec 2021 21:32:53 -0800
Message-Id: <20211215053300.130679-10-saeed@kernel.org>
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
 .../mellanox/mlx5/core/en/tc/act/act.c        |  9 +++-
 .../mellanox/mlx5/core/en/tc/act/act.h        |  2 +
 .../mellanox/mlx5/core/en/tc/act/ct.c         | 50 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 30 +----------
 5 files changed, 64 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8712a5ca8f55..5f2258275ff6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -51,7 +51,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
 					en/tc/act/tun.o en/tc/act/csum.o en/tc/act/pedit.o \
 					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o \
-					en/tc/act/mirred.o en/tc/act/mirred_nic.o
+					en/tc/act/mirred.o en/tc/act/mirred_nic.o \
+					en/tc/act/ct.o
 
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 70a362279809..9813a6321a9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -30,7 +30,7 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_QUEUE, */
 	NULL, /* FLOW_ACTION_SAMPLE, */
 	NULL, /* FLOW_ACTION_POLICE, */
-	NULL, /* FLOW_ACTION_CT, */
+	&mlx5e_tc_act_ct,
 	NULL, /* FLOW_ACTION_CT_METADATA, */
 	&mlx5e_tc_act_mpls_push,
 	&mlx5e_tc_act_mpls_pop,
@@ -55,6 +55,13 @@ static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
 	&mlx5e_tc_act_pedit,
 	&mlx5e_tc_act_csum,
 	&mlx5e_tc_act_mark,
+	NULL, /* FLOW_ACTION_PTYPE, */
+	NULL, /* FLOW_ACTION_PRIORITY, */
+	NULL, /* FLOW_ACTION_WAKE, */
+	NULL, /* FLOW_ACTION_QUEUE, */
+	NULL, /* FLOW_ACTION_SAMPLE, */
+	NULL, /* FLOW_ACTION_POLICE, */
+	&mlx5e_tc_act_ct,
 };
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index b57f22ca8f96..5b92ffbf4819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -23,6 +23,7 @@ struct mlx5e_tc_act_parse_state {
 	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
+	struct mlx5_tc_ct_priv *ct_priv;
 };
 
 struct mlx5e_tc_act {
@@ -51,6 +52,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_mpls_push;
 extern struct mlx5e_tc_act mlx5e_tc_act_mpls_pop;
 extern struct mlx5e_tc_act mlx5e_tc_act_mirred;
 extern struct mlx5e_tc_act mlx5e_tc_act_mirred_nic;
+extern struct mlx5e_tc_act mlx5e_tc_act_ct;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
new file mode 100644
index 000000000000..06ec30cdb269
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+#include "en/tc_ct.h"
+
+static bool
+tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
+		      const struct flow_action_entry *act,
+		      int act_index)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+
+	if (flow_flag_test(parse_state->flow, SAMPLE)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Sample action with connection tracking is not supported");
+		return false;
+	}
+
+	return true;
+}
+
+static int
+tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
+		const struct flow_action_entry *act,
+		struct mlx5e_priv *priv,
+		struct mlx5_flow_attr *attr)
+{
+	int err;
+
+	err = mlx5_tc_ct_parse_action(parse_state->ct_priv, attr,
+				      &attr->parse_attr->mod_hdr_acts,
+				      act, parse_state->extack);
+	if (err)
+		return err;
+
+	flow_flag_set(parse_state->flow, CT);
+
+	if (mlx5e_is_eswitch_flow(parse_state->flow))
+		attr->esw_attr->split_count = attr->esw_attr->out_count;
+
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_ct = {
+	.can_offload = tc_act_can_offload_ct,
+	.parse_action = tc_act_parse_ct,
+};
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d1e803098e0d..03ae519bfa4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3219,24 +3219,11 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	parse_attr = attr->parse_attr;
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
+	parse_state->ct_priv = get_ct_priv(priv);
 	ns_type = mlx5e_get_flow_namespace(flow);
 	hdrs = parse_state->hdrs;
 
 	flow_action_for_each(i, act, flow_action) {
-		switch (act->id) {
-		case FLOW_ACTION_CT:
-			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr,
-						      &parse_attr->mod_hdr_acts,
-						      act, extack);
-			if (err)
-				return err;
-
-			flow_flag_set(flow, CT);
-			break;
-		default:
-			break;
-		}
-
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act) {
 			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
@@ -3377,6 +3364,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	parse_attr = attr->parse_attr;
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
+	parse_state->ct_priv = get_ct_priv(priv);
 	ns_type = mlx5e_get_flow_namespace(flow);
 	hdrs = parse_state->hdrs;
 
@@ -3435,20 +3423,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			break;
 		}
-		case FLOW_ACTION_CT:
-			if (flow_flag_test(flow, SAMPLE)) {
-				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
-				return -EOPNOTSUPP;
-			}
-			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr,
-						      &parse_attr->mod_hdr_acts,
-						      act, extack);
-			if (err)
-				return err;
-
-			flow_flag_set(flow, CT);
-			esw_attr->split_count = esw_attr->out_count;
-			break;
 		case FLOW_ACTION_SAMPLE:
 			if (flow_flag_test(flow, CT)) {
 				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
-- 
2.31.1

