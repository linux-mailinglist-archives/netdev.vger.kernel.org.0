Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57359421B98
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhJEBQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhJEBQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C327961507;
        Tue,  5 Oct 2021 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396487;
        bh=FqK40UsG2ikXoZuviicf84r5mtZYelPCZTMqfcvAGyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbUuS6MDDwhHGX0LY7g/pBygWmgWF+Qxy0/GnHwDQjxQfNbEI1px+W/cZbr45TKgk
         S4MvigzeI4AXPRj5ZNrRhyVHQ0EKF8xXE88JgYX4/+JCiPzCFvLV3mD3A1TRoSWmVp
         BwXK4W68wwsyMPd3SCLMPfu8xINYXvQNDxQIaBzpVAef00ydj7AwkJMLZo6C+ksab/
         drVtNgpAchGHsc5O8BqqpnAXPPR1r4Os2bihuNFHcqVpvevvupPYEriZ8VXMZm5gyf
         HsD0qA+lV+cceHPhnuKLilxyhCGQT/xhDtTzkpn5Dp9NkPXdmocY4vSZQKJ+94oWVO
         amioRdl92kW7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Support accept action
Date:   Mon,  4 Oct 2021 18:12:56 -0700
Message-Id: <20211005011302.41793-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Support TC generic 'accept' action in mlx5 by introducing
MLX5_ESW_ATTR_FLAG_ACCEPT attribute flag. Flag has similar semantics to
existing MLX5_ESW_ATTR_FLAG_SLOW_PATH flag, however, dedicated flag is
required because existing 'slow path' flag can be flipped by tunneling
subsystem when neighbor changes state.

Introduce new helper function mlx5_esw_attr_flags_skip() to check whether
attribute flags for 'slow path' or 'accept' action are set and use it in
eswitch code instead of direct bit manipulation.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 8 ++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 +++---
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c         | 2 +-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dc21d28a4333..d92ee2f37c22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3810,6 +3810,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->flags |= MLX5_ESW_ATTR_FLAG_ACCEPT;
+			break;
 		case FLOW_ACTION_DROP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2c7444101bb9..7461aafb321e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -447,8 +447,16 @@ enum {
 	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
 	MLX5_ESW_ATTR_FLAG_SRC_REWRITE   = BIT(3),
 	MLX5_ESW_ATTR_FLAG_SAMPLE        = BIT(4),
+	MLX5_ESW_ATTR_FLAG_ACCEPT        = BIT(5),
 };
 
+/* Returns true if any of the flags that require skipping further TC/NF processing are set. */
+static inline bool
+mlx5_esw_attr_flags_skip(u32 attr_flags)
+{
+	return attr_flags & (MLX5_ESW_ATTR_FLAG_SLOW_PATH | MLX5_ESW_ATTR_FLAG_ACCEPT);
+}
+
 struct mlx5_esw_flow_attr {
 	struct mlx5_eswitch_rep *in_rep;
 	struct mlx5_core_dev	*in_mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4e1628f25265..ca7e31a1a431 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -440,7 +440,7 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
 		(*i)++;
-	} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
+	} else if (mlx5_esw_attr_flags_skip(attr->flags)) {
 		esw_setup_slow_path_dest(dest, flow_act, chains, *i);
 		(*i)++;
 	} else if (attr->dest_chain) {
@@ -467,7 +467,7 @@ esw_cleanup_dests(struct mlx5_eswitch *esw,
 
 	if (attr->dest_ft) {
 		esw_cleanup_decap_indir(esw, attr);
-	} else if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
+	} else if (!mlx5_esw_attr_flags_skip(attr->flags)) {
 		if (attr->dest_chain)
 			esw_cleanup_chain_dest(chains, attr->dest_chain, 1, 0);
 		else if (esw_is_indir_table(esw, attr))
@@ -678,7 +678,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 
 	mlx5_del_flow_rules(rule);
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
+	if (!mlx5_esw_attr_flags_skip(attr->flags)) {
 		/* unref the term table */
 		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
 			if (esw_attr->dests[i].termtbl)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index b45954905845..879d78e46e47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -219,7 +219,7 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
 	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level) ||
-	    attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH ||
+	    mlx5_esw_attr_flags_skip(attr->flags) ||
 	    !mlx5_eswitch_offload_is_uplink_port(esw, spec))
 		return false;
 
-- 
2.31.1

