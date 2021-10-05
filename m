Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB5421B94
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhJEBQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhJEBQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1ADD6154B;
        Tue,  5 Oct 2021 01:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396485;
        bh=CkvjtBI0yQqRcdZBk94LJc5vg/PJOJLKrGCjKqScFd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOYMPMc+NVSsWewElhsr5FhjMl13zH3ikEnJ4FUVKro5wBk38j2ieMQTFcQIin4gg
         l/5PpR3xvt8ElKyMkOOttPpHAHzw9EDzS9dKcylRN/bFvTeGJhhM75lCHt4deDgG/z
         3Pkrbn+cwgxJ2NsG38BC8xAUPpdbxfQAWbvmJuoXg+uVQUwVBEKe7EAIWpGHSlfhqG
         M94coa80dTHAwxUd20smslXP7bUIcxZX5Slwoez5E5dswxhfZi35JMPEiGmj1IB3rE
         qqGC/wfvZh249pFZZvZBXEyi4BY9cYKE+dVo1JC1KJg6mCl/vI/mnMcqYfwfGbh2sQ
         YJ4eXJWtCSx/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Split actions_match_supported() into a sub function
Date:   Mon,  4 Oct 2021 18:12:52 -0700
Message-Id: <20211005011302.41793-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

There will probably be more checks, some for nic flows, some for fdb
flows and some are shared checks. Split it for fdb and nic to avoid
the function getting too big.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 65 +++++++++++--------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f39589fdd48f..24b0c0e3c573 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3169,19 +3169,41 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	return true;
 }
 
-static bool actions_match_supported(struct mlx5e_priv *priv,
-				    struct flow_action *flow_action,
-				    struct mlx5e_tc_flow_parse_attr *parse_attr,
-				    struct mlx5e_tc_flow *flow,
-				    struct netlink_ext_ack *extack)
+static bool
+actions_match_supported_fdb(struct mlx5e_priv *priv,
+			    struct mlx5e_tc_flow_parse_attr *parse_attr,
+			    struct mlx5e_tc_flow *flow,
+			    struct netlink_ext_ack *extack)
+{
+	bool ct_flow, ct_clear;
+
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
+	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
+
+	if (flow->attr->esw_attr->split_count && ct_flow &&
+	    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
+		/* All registers used by ct are cleared when using
+		 * split rules.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "Can't offload mirroring with action ct");
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+actions_match_supported(struct mlx5e_priv *priv,
+			struct flow_action *flow_action,
+			struct mlx5e_tc_flow_parse_attr *parse_attr,
+			struct mlx5e_tc_flow *flow,
+			struct netlink_ext_ack *extack)
 {
-	bool ct_flow = false, ct_clear = false;
-	u32 actions;
+	u32 actions = flow->attr->action;
+	bool ct_flow, ct_clear;
 
-	ct_clear = flow->attr->ct_attr.ct_action &
-		TCA_CT_ACT_CLEAR;
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
-	actions = flow->attr->action;
 
 	if (!(actions &
 	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
@@ -3189,23 +3211,14 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 	}
 
-	if (mlx5e_is_eswitch_flow(flow)) {
-		if (flow->attr->esw_attr->split_count && ct_flow &&
-		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
-			/* All registers used by ct are cleared when using
-			 * split rules.
-			 */
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Can't offload mirroring with action ct");
-			return false;
-		}
-	}
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
+					   actions, ct_flow, ct_clear, extack))
+		return false;
 
-	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		return modify_header_match_supported(priv, &parse_attr->spec,
-						     flow_action, actions,
-						     ct_flow, ct_clear,
-						     extack);
+	if (mlx5e_is_eswitch_flow(flow) &&
+	    !actions_match_supported_fdb(priv, parse_attr, flow, extack))
+		return false;
 
 	return true;
 }
-- 
2.31.1

