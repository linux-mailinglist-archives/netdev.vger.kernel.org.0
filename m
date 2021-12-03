Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F221466EDB
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343948AbhLCA75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60690 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245273AbhLCA7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7BC262920
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1785C53FD0;
        Fri,  3 Dec 2021 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492990;
        bh=sUi8aZJ7EVaTCgKyrUfp0ifAVBkpN+UTSDM9ubAbURY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeJNMElBKNYr+SFR/t8gwKTlDuvu6fnxjbXCMARG2peOgnsL69SfHbacz97Z7MVPi
         oH7PMJcaGiv8Xf1Yml2ehkq0hV0YZCV/pLDDB0nv6nV8XQJwoC8FI488iVUjeV1q2E
         yHQ1fwx/9QckAzdEAASTxXKzXhrFroG7YMo1M5ieE4v1l2s31wHB/9AztgDb0lVjL5
         fZ7wCZOrOZLQUtK8pQ8lkpr/sk8rSNMw40tQyw0ZmjRlS1ELP79jljts/oA/pLHv8h
         vqpE1Q1p68u4KJFOcAi6yDHOXo05o62v9O2EXVJfAAuIlHUHRGx59xf090x7wVm6Do
         3gxr7GZROxW9w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 10/14] net/mlx5e: Remove redundant actions arg from validate_goto_chain()
Date:   Thu,  2 Dec 2021 16:56:18 -0800
Message-Id: <20211203005622.183325-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Passing actions is redundant and can be retrieved from flow.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d869907fdb70..90fca3555563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3359,11 +3359,9 @@ add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 static int validate_goto_chain(struct mlx5e_priv *priv,
 			       struct mlx5e_tc_flow *flow,
 			       const struct flow_action_entry *act,
-			       u32 actions,
 			       struct netlink_ext_ack *extack)
 {
 	bool is_esw = mlx5e_is_eswitch_flow(flow);
-	struct mlx5_flow_attr *attr = flow->attr;
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	u32 dest_chain = act->chain_index;
 	struct mlx5_fs_chains *chains;
@@ -3384,7 +3382,7 @@ static int validate_goto_chain(struct mlx5e_priv *priv,
 	}
 
 	if (!mlx5_chains_backwards_supported(chains) &&
-	    dest_chain <= attr->chain) {
+	    dest_chain <= flow->attr->chain) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Goto lower numbered chain isn't supported");
 		return -EOPNOTSUPP;
@@ -3396,8 +3394,8 @@ static int validate_goto_chain(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (actions & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
-		       MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
+	if (flow->attr->action & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
+				  MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
 	    !reformat_and_fwd) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Goto chain is not allowed if action has reformat or decap");
@@ -3541,8 +3539,7 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			}
 			break;
 		case FLOW_ACTION_GOTO:
-			err = validate_goto_chain(priv, flow, act, attr->action,
-						  extack);
+			err = validate_goto_chain(priv, flow, act, extack);
 			if (err)
 				return err;
 
@@ -4206,8 +4203,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			decap = true;
 			break;
 		case FLOW_ACTION_GOTO:
-			err = validate_goto_chain(priv, flow, act, attr->action,
-						  extack);
+			err = validate_goto_chain(priv, flow, act, extack);
 			if (err)
 				return err;
 
-- 
2.31.1

