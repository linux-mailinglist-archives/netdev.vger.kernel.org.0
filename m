Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB4847522B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbhLOFdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51578 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbhLOFdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6961617E1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDB0C34604;
        Wed, 15 Dec 2021 05:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546390;
        bh=qFMgPE6zPnBGLryOn+yUbSlPoGJ6/UtdhiI4G3cdTUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqRijEEabpyg6xCITQ7yRjnPqS+ZOODTW8QmZ9q1vZeuAH05BUFTj9QZtMj8mEZph
         NDTzPg4Q0vM7CPsWIzA3z39XLCwjoTLQCpa8VNeNxM51vcsAT+mZrdb6/GH4jokNqt
         V4U+5gg4LJccNcIL+Nnj/tEiQvxnRQJY2YAIq8k2yhGjnn6zjl4yH0tGImhn9sw5ue
         IDs0bPlBLvinymkKsjRE9C8Cb/j9dbJ/P/ujYdijKnFdBKRItsugBu01nyViuOybeS
         D1JujNhBOjNIM+2jzjpnpHHsj5jiTAljRDnMbQu7EtliIJWllTqXDuEQNdD/VMs+wK
         U2p2PLlCdfU4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 16/16] net/mlx5e: Move goto action checks into tc_action goto post parse op
Date:   Tue, 14 Dec 2021 21:33:00 -0800
Message-Id: <20211215053300.130679-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move goto action checks from parse nic/fdb funcs into the tc action
infra goto post parse op.
While moving this part also use NL_SET_ERR_MSG_MOD() instead of
NL_SET_ERR_MSG().

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/goto.c       | 35 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 19 ----------
 2 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
index d713cf8e92a5..f44515061228 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
@@ -81,7 +81,42 @@ tc_act_parse_goto(struct mlx5e_tc_act_parse_state *parse_state,
 	return 0;
 }
 
+static int
+tc_act_post_parse_goto(struct mlx5e_tc_act_parse_state *parse_state,
+		       struct mlx5e_priv *priv,
+		       struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+
+	if (!attr->dest_chain)
+		return 0;
+
+	if (parse_state->decap) {
+		/* It can be supported if we'll create a mapping for
+		 * the tunnel device only (without tunnel), and set
+		 * this tunnel id with this decap flow.
+		 *
+		 * On restore (miss), we'll just set this saved tunnel
+		 * device.
+		 */
+
+		NL_SET_ERR_MSG_MOD(extack, "Decap with goto isn't supported");
+		netdev_warn(priv->netdev, "Decap with goto isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!mlx5e_is_eswitch_flow(flow) && parse_attr->mirred_ifindex[0]) {
+		NL_SET_ERR_MSG_MOD(extack, "Mirroring goto chain rules isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 struct mlx5e_tc_act mlx5e_tc_act_goto = {
 	.can_offload = tc_act_can_offload_goto,
 	.parse_action = tc_act_parse_goto,
+	.post_parse = tc_act_post_parse_goto,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 28a8db85994c..eec919f1b476 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3241,11 +3241,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
-		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
-		return -EOPNOTSUPP;
-	}
-
 	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
 	if (err)
 		return err;
@@ -3384,20 +3379,6 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-	if (attr->dest_chain && parse_state->decap) {
-		/* It can be supported if we'll create a mapping for
-		 * the tunnel device only (without tunnel), and set
-		 * this tunnel id with this decap flow.
-		 *
-		 * On restore (miss), we'll just set this saved tunnel
-		 * device.
-		 */
-
-		NL_SET_ERR_MSG(extack, "Decap with goto isn't supported");
-		netdev_warn(priv->netdev, "Decap with goto isn't supported");
-		return -EOPNOTSUPP;
-	}
-
 	return 0;
 }
 
-- 
2.31.1

