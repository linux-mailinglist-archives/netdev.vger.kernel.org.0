Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C151466EDE
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbhLCA76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244682AbhLCA7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77258C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 16:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ECCB6291C
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1718BC53FCC;
        Fri,  3 Dec 2021 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492991;
        bh=d7r1odX6bgJjpPBQIYygGGN4YFrgOLd2cc7E3+n/7ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXXXwD4waOS/dhCBD3TVBaOcc5LqTg8kJeXO0dpHzcnUFniw83imyVEh7xbYQMFWH
         mnWXJpNRbZTTJ7G7u+O/mdICYTlJM5jgG44nQHO7pjF/oZHfM8ZVA+mqtxqxUU/+rN
         bisCogMAyA1+qubGhJYpP1SMBvgab6pz1VLdwgmb3pDPIN+BTFsv4AWm/ZzcFtbneL
         LlY6rbHkkvUYNuYDtyLteU0as+rb8+9qUFCTIb3vsws+YslV/5hWaVNfa96lg0eEL8
         tfkWYuczvFCNjMayXwtvNp1j0rGI4hSfM+62oyhavOoyV/+m2L468O7SJBkYNPK/AQ
         iY/D4lLuDtCFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 12/14] net/mlx5e: TC, Move common flow_action checks into function
Date:   Thu,  2 Dec 2021 16:56:20 -0800
Message-Id: <20211203005622.183325-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove duplicate checks on flow_action by using common function.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 44 ++++++++++---------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3c5e9efb9873..c7f1c93709cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3444,6 +3444,24 @@ actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static int
+flow_action_supported(struct flow_action *flow_action,
+		      struct netlink_ext_ack *extack)
+{
+	if (!flow_action_has_entries(flow_action)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
+		return -EINVAL;
+	}
+
+	if (!flow_action_hw_stats_check(flow_action, extack,
+					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int
 parse_tc_nic_actions(struct mlx5e_priv *priv,
 		     struct flow_action *flow_action,
@@ -3457,16 +3475,9 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	struct mlx5_nic_flow_attr *nic_attr;
 	int err, i;
 
-	if (!flow_action_has_entries(flow_action)) {
-		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
-		return -EINVAL;
-	}
-
-	if (!flow_action_hw_stats_check(flow_action, extack,
-					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
-		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
-		return -EOPNOTSUPP;
-	}
+	err = flow_action_supported(flow_action, extack);
+	if (err)
+		return err;
 
 	nic_attr = attr->nic_attr;
 	nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
@@ -3883,16 +3894,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	bool ptype_host = false;
 	bool mpls_push = false;
 
-	if (!flow_action_has_entries(flow_action)) {
-		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
-		return -EINVAL;
-	}
-
-	if (!flow_action_hw_stats_check(flow_action, extack,
-					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
-		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
-		return -EOPNOTSUPP;
-	}
+	err = flow_action_supported(flow_action, extack);
+	if (err)
+		return err;
 
 	esw_attr = attr->esw_attr;
 	parse_attr = attr->parse_attr;
-- 
2.31.1

