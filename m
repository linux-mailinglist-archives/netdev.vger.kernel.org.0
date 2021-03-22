Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB5E3450B1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhCVU0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhCVUZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E99B619A1;
        Mon, 22 Mar 2021 20:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444734;
        bh=Kva627dsJXByZtz6oQusR8VuSpyYFYXRx87s0m3Ai1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/eMRBZm3SNbcs1V7odjSBSfyOdzt5mFZcJGwTe6Fp+7F0gUNVjT08jSCgG99kSnb
         dbq2dmS1QP107Fo6HAveFUPmjqTjpf+lWHtOlYZLj1S+6TOCmr6lvLX/iCvnqiWEtI
         Zi9DlRi+427mgGOdA/Pk8pchjJhz5I6fL0DOx73lHsrF5iV5aRX9op/q9QbxyB3Qjl
         jZcD9NHkwvtFgJrbhTTQt6BEAmL6NeJWGoz9Rik2E1PfQRwrDMo9sOMQPng4TkR6vf
         p35hDW4diskkT1u+9A+b2f3GJs5lPZkQpLSQBFIp/wD6qtDgMvKLHF/tQd+QR0HP+y
         phqC7a8kxc1AA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/6] net/mlx5e: Offload tuple rewrite for non-CT flows
Date:   Mon, 22 Mar 2021 13:25:21 -0700
Message-Id: <20210322202524.68886-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322202524.68886-1-saeed@kernel.org>
References: <20210322202524.68886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Setting connection tracking OVS flows and then setting non-CT flows that
use tuple rewrite action (e.g. mod_tp_dst), causes the latter flows not
being offloaded.

Fix by using a stricter condition in modify_header_match_supported() to
check tuple rewrite support only for flows with CT action. The check is
factored out into standalone modify_tuple_supported() function to aid
readability.

Fixes: 7e36feeb0467 ("net/mlx5e: CT: Don't offload tuple rewrites for established tuples")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 44 ++++++++++++++-----
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index f3f6eb081948..b2cd29847a37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1181,7 +1181,8 @@ int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 
 	mlx5e_tc_match_to_reg_get_match(spec, CTSTATE_TO_REG,
 					&ctstate, &ctstate_mask);
-	if (ctstate_mask)
+
+	if ((ctstate & ctstate_mask) == MLX5_CT_STATE_TRK_BIT)
 		return -EOPNOTSUPP;
 
 	ctstate_mask |= MLX5_CT_STATE_TRK_BIT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3359098c51d4..df2a0af854bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2909,6 +2909,37 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 	return 0;
 }
 
+static bool modify_tuple_supported(bool modify_tuple, bool ct_clear,
+				   bool ct_flow, struct netlink_ext_ack *extack,
+				   struct mlx5e_priv *priv,
+				   struct mlx5_flow_spec *spec)
+{
+	if (!modify_tuple || ct_clear)
+		return true;
+
+	if (ct_flow) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload tuple modification with non-clear ct()");
+		netdev_info(priv->netdev,
+			    "can't offload tuple modification with non-clear ct()");
+		return false;
+	}
+
+	/* Add ct_state=-trk match so it will be offloaded for non ct flows
+	 * (or after clear action), as otherwise, since the tuple is changed,
+	 * we can't restore ct state
+	 */
+	if (mlx5_tc_ct_add_no_trk_match(spec)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload tuple modification with ct matches and no ct(clear) action");
+		netdev_info(priv->netdev,
+			    "can't offload tuple modification with ct matches and no ct(clear) action");
+		return false;
+	}
+
+	return true;
+}
+
 static bool modify_header_match_supported(struct mlx5e_priv *priv,
 					  struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
@@ -2947,18 +2978,9 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	/* Add ct_state=-trk match so it will be offloaded for non ct flows
-	 * (or after clear action), as otherwise, since the tuple is changed,
-	 *  we can't restore ct state
-	 */
-	if (!ct_clear && modify_tuple &&
-	    mlx5_tc_ct_add_no_trk_match(spec)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "can't offload tuple modify header with ct matches");
-		netdev_info(priv->netdev,
-			    "can't offload tuple modify header with ct matches");
+	if (!modify_tuple_supported(modify_tuple, ct_clear, ct_flow, extack,
+				    priv, spec))
 		return false;
-	}
 
 	ip_proto = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol);
 	if (modify_ip_header && ip_proto != IPPROTO_TCP &&
-- 
2.30.2

