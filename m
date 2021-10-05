Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB90F421B93
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhJEBQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhJEBQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E9016152B;
        Tue,  5 Oct 2021 01:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396484;
        bh=20xdwuThhhLkG7QuZ/WjxgQo3Xw1YEMjpTKUs7Y+sco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgftpO01+xSaJeYQ8FHCHwyxH2xbv9vqsmoOIC8Gv4IDzm2bO3jNtUhq5xsuUin8D
         uIVmzNX8VTlSBJ7HsjKMFYpnOS/ue0mogw8uGjo6e0KvnwALc/BFAS06RC29Ckpj8g
         FItFo7VtvZJsGfyuHhrR+hLwGaTBFPyjEFaKJSsKWEe7I6xdzkKLyPJPLCs0P2FhjV
         fsvJhk1TCAe1QwGBNOP+fJOr6S9hA8OaOaizT2xRIBjAnRIDx64ZCGHTE6ETTQbyVz
         XaojVa+lUL6cR6E5gB+htY0LQNtYPi2VxqoIYevTDoksgLFlO/x6F/SJPz0JMGTPX2
         nqS9jcPk5h1fg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Move mod hdr allocation to a single place
Date:   Mon,  4 Oct 2021 18:12:51 -0700
Message-Id: <20211005011302.41793-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move mod hdr allocation chunk from parse_tc_fdb_actions() and
parse_tc_nic_actions() to a shared function.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 87 +++++++++++--------
 1 file changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0e03cefc5eeb..f39589fdd48f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3354,10 +3354,50 @@ static int validate_goto_chain(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int parse_tc_nic_actions(struct mlx5e_priv *priv,
-				struct flow_action *flow_action,
+static int
+actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
+				struct mlx5_flow_attr *attr,
+				struct pedit_headers_action *hdrs,
 				struct netlink_ext_ack *extack)
+{
+	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
+	enum mlx5_flow_namespace_type ns_type;
+	int err;
+
+	if (!hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits &&
+	    !hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits)
+		return 0;
+
+	ns_type = get_flow_name_space(flow);
+
+	err = alloc_tc_pedit_action(priv, ns_type, parse_attr, hdrs,
+				    &attr->action, extack);
+	if (err)
+		return err;
+
+	/* In case all pedit actions are skipped, remove the MOD_HDR flag. */
+	if (parse_attr->mod_hdr_acts.num_actions > 0)
+		return 0;
+
+	attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
+
+	if (ns_type != MLX5_FLOW_NAMESPACE_FDB)
+		return 0;
+
+	if (!((attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
+	      (attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)))
+		attr->esw_attr->split_count = 0;
+
+	return 0;
+}
+
+static int
+parse_tc_nic_actions(struct mlx5e_priv *priv,
+		     struct flow_action *flow_action,
+		     struct mlx5e_tc_flow *flow,
+		     struct netlink_ext_ack *extack)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
@@ -3467,21 +3507,6 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
-	    hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits) {
-		err = alloc_tc_pedit_action(priv, MLX5_FLOW_NAMESPACE_KERNEL,
-					    parse_attr, hdrs, &action, extack);
-		if (err)
-			return err;
-		/* in case all pedit actions are skipped, remove the MOD_HDR
-		 * flag.
-		 */
-		if (parse_attr->mod_hdr_acts.num_actions == 0) {
-			action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
-		}
-	}
-
 	attr->action = action;
 
 	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
@@ -3489,6 +3514,10 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
+	if (err)
+		return err;
+
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
@@ -4043,26 +4072,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
-	    hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits) {
-		err = alloc_tc_pedit_action(priv, MLX5_FLOW_NAMESPACE_FDB,
-					    parse_attr, hdrs, &action, extack);
-		if (err)
-			return err;
-		/* in case all pedit actions are skipped, remove the MOD_HDR
-		 * flag. we might have set split_count either by pedit or
-		 * pop/push. if there is no pop/push either, reset it too.
-		 */
-		if (parse_attr->mod_hdr_acts.num_actions == 0) {
-			action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
-			if (!((action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
-			      (action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)))
-				esw_attr->split_count = 0;
-		}
-	}
-
 	attr->action = action;
+
+	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
+	if (err)
+		return err;
+
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-- 
2.31.1

