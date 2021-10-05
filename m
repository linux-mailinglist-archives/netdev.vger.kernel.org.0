Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A42421B95
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhJEBQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhJEBQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 430AD61407;
        Tue,  5 Oct 2021 01:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396485;
        bh=x8bRe48HSzypgld4MKsHqUPidg252UoUznLnCvSRlrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXoDX0S/sJ1NZJBwk+zhwr0Pmslanu1tiopZY8lB0I9WGWlToxn3j2/Xlmz622O2J
         SX9PzHd0UyONTZU4KmvRYml4LT1bFM/2Uik2OVGo6EhWYUN5puzPU4LLYpi0l59XQJ
         b1fGJ9Wv3AVNUT2yoMnwd+MSsPMoOPsnFu0JnukD+eh48jiBI+MLeRp7KyTg6zeC0d
         /qbqysOOjksDcq1H1Kwa3s6P1dJib95jfgHn0sylWQeKbViBXutPOkwa5ovo6uj1ym
         Y6tkO7ZG460X066tAqe5WepLnSHWWxIP2EdXzEU8Cl0RdV2OAAv06vEe8cVuMyN907
         22KwUvNYEnt/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Move parse fdb check into actions_match_supported_fdb()
Date:   Mon,  4 Oct 2021 18:12:53 -0700
Message-Id: <20211005011302.41793-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The parse fdb/nic actions funcs parse the actions and then call
actions_match_supported() for final check.
Move related check in parse_tc_fdb_actions() into
actions_match_supported_fdb() for more organized code.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 24b0c0e3c573..606a7757bb04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3175,13 +3175,14 @@ actions_match_supported_fdb(struct mlx5e_priv *priv,
 			    struct mlx5e_tc_flow *flow,
 			    struct netlink_ext_ack *extack)
 {
+	struct mlx5_esw_flow_attr *esw_attr = flow->attr->esw_attr;
 	bool ct_flow, ct_clear;
 
 	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
 
-	if (flow->attr->esw_attr->split_count && ct_flow &&
-	    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
+	if (esw_attr->split_count && ct_flow &&
+	    !MLX5_CAP_GEN(esw_attr->in_mdev, reg_c_preserve)) {
 		/* All registers used by ct are cleared when using
 		 * split rules.
 		 */
@@ -3189,6 +3190,14 @@ actions_match_supported_fdb(struct mlx5e_priv *priv,
 		return false;
 	}
 
+	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "current firmware doesn't support split rule for port mirroring");
+		netdev_warn_once(priv->netdev,
+				 "current firmware doesn't support split rule for port mirroring\n");
+		return false;
+	}
+
 	return true;
 }
 
@@ -4108,13 +4117,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "current firmware doesn't support split rule for port mirroring");
-		netdev_warn_once(priv->netdev, "current firmware doesn't support split rule for port mirroring\n");
-		return -EOPNOTSUPP;
-	}
-
 	/* Allocate sample attribute only when there is a sample action and
 	 * no errors after parsing.
 	 */
-- 
2.31.1

