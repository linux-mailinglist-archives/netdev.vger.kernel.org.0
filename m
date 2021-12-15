Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38306475229
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhLOFdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbhLOFdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EBBC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 21:33:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D3E615C7
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5413EC34605;
        Wed, 15 Dec 2021 05:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546389;
        bh=lX+qzdjS/jKMLpzBhhSjImSXLFkuBfq7KxrM0nyy3eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RESBmFzMD4jKrwU3e4/VTLammH+F8qGlxmRKHBBFkWa+wkpKMHMXFGfKJLPRvScR/
         hl0eQNr6oyduTuxVf2lKClFfK6Xae5hvYDOrTGVabtEBvAleqxIri7iK0xTH5g0JPi
         Aa0WIr3lqpD+vwG23v/duEl8dETZEpQkg/cTV28kmzXTY8BCcppaQg7j8EC5+ObHik
         mlNSrJSIdzG8FXqh6p2z0FzIB0mXED8ZaZqtWHZzbtxp808ymMgzLGBwa0sXGmqQbP
         sVjcEPK1zLNgmp+YfJ04ncnNHt7J7oBdM8D9mElUScGJvUKi505MchLxbmeszVMFc8
         7kKAgLC4xmO6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 15/16] net/mlx5e: Move vlan action chunk into tc action vlan post parse op
Date:   Tue, 14 Dec 2021 21:32:59 -0800
Message-Id: <20211215053300.130679-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move vlan prio tag rewrite handling into tc action infra vlan post parse op.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/vlan.c       | 51 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 38 --------------
 2 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index 5a80eaeb90dc..70fc0c2d8813 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -6,6 +6,30 @@
 #include "vlan.h"
 #include "en/tc_priv.h"
 
+static int
+add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
+				 struct mlx5e_tc_flow_parse_attr *parse_attr,
+				 struct pedit_headers_action *hdrs,
+				 u32 *action, struct netlink_ext_ack *extack)
+{
+	const struct flow_action_entry prio_tag_act = {
+		.vlan.vid = 0,
+		.vlan.prio =
+			MLX5_GET(fte_match_set_lyr_2_4,
+				 mlx5e_get_match_headers_value(*action,
+							       &parse_attr->spec),
+				 first_prio) &
+			MLX5_GET(fte_match_set_lyr_2_4,
+				 mlx5e_get_match_headers_criteria(*action,
+								  &parse_attr->spec),
+				 first_prio),
+	};
+
+	return mlx5e_tc_act_vlan_add_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB,
+						    &prio_tag_act, parse_attr, hdrs, action,
+						    extack);
+}
+
 static int
 parse_tc_vlan_action(struct mlx5e_priv *priv,
 		     const struct flow_action_entry *act,
@@ -161,7 +185,34 @@ tc_act_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 	return 0;
 }
 
+static int
+tc_act_post_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
+		       struct mlx5e_priv *priv,
+		       struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
+	struct pedit_headers_action *hdrs = parse_state->hdrs;
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	int err;
+
+	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
+	    attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
+		/* For prio tag mode, replace vlan pop with rewrite vlan prio
+		 * tag rewrite.
+		 */
+		attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+		err = add_vlan_prio_tag_rewrite_action(priv, parse_attr, hdrs,
+						       &attr->action, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 struct mlx5e_tc_act mlx5e_tc_act_vlan = {
 	.can_offload = tc_act_can_offload_vlan,
 	.parse_action = tc_act_parse_vlan,
+	.post_parse = tc_act_post_parse_vlan,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2ece349592cd..28a8db85994c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -59,7 +59,6 @@
 #include "en/tc_tun_encap.h"
 #include "en/tc/sample.h"
 #include "en/tc/act/act.h"
-#include "en/tc/act/vlan.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -3114,30 +3113,6 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	return (fsystem_guid == psystem_guid);
 }
 
-static int
-add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
-				 struct mlx5e_tc_flow_parse_attr *parse_attr,
-				 struct pedit_headers_action *hdrs,
-				 u32 *action, struct netlink_ext_ack *extack)
-{
-	const struct flow_action_entry prio_tag_act = {
-		.vlan.vid = 0,
-		.vlan.prio =
-			MLX5_GET(fte_match_set_lyr_2_4,
-				 mlx5e_get_match_headers_value(*action,
-							       &parse_attr->spec),
-				 first_prio) &
-			MLX5_GET(fte_match_set_lyr_2_4,
-				 mlx5e_get_match_headers_criteria(*action,
-								  &parse_attr->spec),
-				 first_prio),
-	};
-
-	return mlx5e_tc_act_vlan_add_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB,
-						    &prio_tag_act, parse_attr, hdrs, action,
-						    extack);
-}
-
 static int
 parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		 struct flow_action *flow_action)
@@ -3372,7 +3347,6 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		     struct mlx5e_tc_flow *flow,
 		     struct netlink_ext_ack *extack)
 {
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
@@ -3403,18 +3377,6 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
-	    attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
-		/* For prio tag mode, replace vlan pop with rewrite vlan prio
-		 * tag rewrite.
-		 */
-		attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
-		err = add_vlan_prio_tag_rewrite_action(priv, parse_attr, hdrs,
-						       &attr->action, extack);
-		if (err)
-			return err;
-	}
-
 	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
 	if (err)
 		return err;
-- 
2.31.1

