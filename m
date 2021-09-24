Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC390417B47
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbhIXSuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239410AbhIXStw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DFCC61279;
        Fri, 24 Sep 2021 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509299;
        bh=BgJHWjzoXDXq31fXKMB0zC9EFMPC+r7HIw98yor/kAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OglN7InoJzAZ6xW9/HN8X4jTlfSLZn/K3uvi0IK8WjCW+pec2MZhexlVq8PFC9ucS
         YB/HEm5YtlHnvs43fVgovpVsA95BuGVFRybrZnn+JupYXuOcnSw/1/5JJkM0cbfkvW
         Rdqe0ub/lLbdjYbM0wCFf1bu8qG/5qdvLWkcLx+b8V8obvozHdoTa506VKIpe+cBbF
         CJmtClwRJH9hudvvb9c+Ge5+Tjr76vBuDKlB+AxEVFJ1vYBv/pe/AVpduiIv4zzQeh
         r18gEfjmhYue5Bpmyw8149WWo4XbrqyNUq0z5Y3q+OlJPCnvD95kD/pjn2CvQx3GVK
         vcM5oob//0upg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/12] net/mlx5e: Set action fwd flag when parsing tc action goto
Date:   Fri, 24 Sep 2021 11:48:01 -0700
Message-Id: <20210924184808.796968-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Do it when parsing like in other actions instead of when
checking if goto is supported in current scenario.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 43 ++++++++-----------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d68c67b98d94..3646e88b6401 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3450,7 +3450,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -3483,12 +3484,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 
 	attr->action = action;
 
-	if (attr->dest_chain) {
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-			NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
-			return -EOPNOTSUPP;
-		}
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
+		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
+		return -EOPNOTSUPP;
 	}
 
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
@@ -3994,7 +3992,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -4064,24 +4063,18 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-	if (attr->dest_chain) {
-		if (decap) {
-			/* It can be supported if we'll create a mapping for
-			 * the tunnel device only (without tunnel), and set
-			 * this tunnel id with this decap flow.
-			 *
-			 * On restore (miss), we'll just set this saved tunnel
-			 * device.
-			 */
-
-			NL_SET_ERR_MSG(extack,
-				       "Decap with goto isn't supported");
-			netdev_warn(priv->netdev,
-				    "Decap with goto isn't supported");
-			return -EOPNOTSUPP;
-		}
+	if (attr->dest_chain && decap) {
+		/* It can be supported if we'll create a mapping for
+		 * the tunnel device only (without tunnel), and set
+		 * this tunnel id with this decap flow.
+		 *
+		 * On restore (miss), we'll just set this saved tunnel
+		 * device.
+		 */
 
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		NL_SET_ERR_MSG(extack, "Decap with goto isn't supported");
+		netdev_warn(priv->netdev, "Decap with goto isn't supported");
+		return -EOPNOTSUPP;
 	}
 
 	if (!(attr->action &
-- 
2.31.1

