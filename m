Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C8827F8BE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgJAEdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgJAEdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:17 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45BB621D92;
        Thu,  1 Oct 2020 04:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526796;
        bh=3N7nXlPXMq0L8lgw4fYTyjqCTQGBTeBTLCkTQBhv5Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4Nw+uKhZAVK3hZIYn9YtmFwf+jknFNCmSIvdqDG6A+jy1RLi25UhV9pqL62N+0YU
         O/5+NR4YE+8YieODL2rzWDG5aHvZjfpr0GL1mA9IfW5/yeQuQG/10oPzVodoTtHkOd
         pZfTGHTL7SZdN0dvHqKg2Xmdzv8j55kGy/JoxKn8=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hamdan Igbaria <hamdani@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: DR, Add support for rule creation with flow source hint
Date:   Wed, 30 Sep 2020 21:32:53 -0700
Message-Id: <20201001043302.48113-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@nvidia.com>

Skip the rule according to flow arrival source, in case of RX and the
source is local port skip and in case of TX and the source is uplink
skip, we get this info according to the flow source hint we get from
upper layers when creating the rule.
This is needed because for example in case of FDB table which has a TX
and RX tables and we are inserting a rule with an encap action which
is only a TX action, in this case rule will fail on RX, so we can rely
on the flow source hint and skip RX in such case.
Until now we relied on metadata regc_0 that upper layer mapped the
port in the regc_0, but the problem is that upper layer did not always
use regc_0 for port mapping, so now we added support to flow source
hint which upper layers will pass to SW steering when creating a rule.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Hamdan Igbaria <hamdani@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 41 ++++++++++---------
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 +
 .../mellanox/mlx5/core/steering/fs_dr.c       |  3 +-
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  3 +-
 4 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 17577181ce8f..b3c9dc032026 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -985,31 +985,28 @@ static enum mlx5dr_ipv dr_rule_get_ipv(struct mlx5dr_match_spec *spec)
 static bool dr_rule_skip(enum mlx5dr_domain_type domain,
 			 enum mlx5dr_ste_entry_type ste_type,
 			 struct mlx5dr_match_param *mask,
-			 struct mlx5dr_match_param *value)
+			 struct mlx5dr_match_param *value,
+			 u32 flow_source)
 {
+	bool rx = ste_type == MLX5DR_STE_TYPE_RX;
+
 	if (domain != MLX5DR_DOMAIN_TYPE_FDB)
 		return false;
 
 	if (mask->misc.source_port) {
-		if (ste_type == MLX5DR_STE_TYPE_RX)
-			if (value->misc.source_port != WIRE_PORT)
-				return true;
+		if (rx && value->misc.source_port != WIRE_PORT)
+			return true;
 
-		if (ste_type == MLX5DR_STE_TYPE_TX)
-			if (value->misc.source_port == WIRE_PORT)
-				return true;
+		if (!rx && value->misc.source_port == WIRE_PORT)
+			return true;
 	}
 
-	/* Metadata C can be used to describe the source vport */
-	if (mask->misc2.metadata_reg_c_0) {
-		if (ste_type == MLX5DR_STE_TYPE_RX)
-			if ((value->misc2.metadata_reg_c_0 & WIRE_PORT) != WIRE_PORT)
-				return true;
+	if (rx && flow_source == MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT)
+		return true;
+
+	if (!rx && flow_source == MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK)
+		return true;
 
-		if (ste_type == MLX5DR_STE_TYPE_TX)
-			if ((value->misc2.metadata_reg_c_0 & WIRE_PORT) == WIRE_PORT)
-				return true;
-	}
 	return false;
 }
 
@@ -1038,7 +1035,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	INIT_LIST_HEAD(&nic_rule->rule_members_list);
 
-	if (dr_rule_skip(dmn->type, nic_dmn->ste_type, &matcher->mask, param))
+	if (dr_rule_skip(dmn->type, nic_dmn->ste_type, &matcher->mask, param,
+			 rule->flow_source))
 		return 0;
 
 	hw_ste_arr = kzalloc(DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE, GFP_KERNEL);
@@ -1173,7 +1171,8 @@ static struct mlx5dr_rule *
 dr_rule_create_rule(struct mlx5dr_matcher *matcher,
 		    struct mlx5dr_match_parameters *value,
 		    size_t num_actions,
-		    struct mlx5dr_action *actions[])
+		    struct mlx5dr_action *actions[],
+		    u32 flow_source)
 {
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_match_param param = {};
@@ -1188,6 +1187,7 @@ dr_rule_create_rule(struct mlx5dr_matcher *matcher,
 		return NULL;
 
 	rule->matcher = matcher;
+	rule->flow_source = flow_source;
 	INIT_LIST_HEAD(&rule->rule_actions_list);
 
 	ret = dr_rule_add_action_members(rule, num_actions, actions);
@@ -1232,13 +1232,14 @@ dr_rule_create_rule(struct mlx5dr_matcher *matcher,
 struct mlx5dr_rule *mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
 				       struct mlx5dr_match_parameters *value,
 				       size_t num_actions,
-				       struct mlx5dr_action *actions[])
+				       struct mlx5dr_action *actions[],
+				       u32 flow_source)
 {
 	struct mlx5dr_rule *rule;
 
 	refcount_inc(&matcher->refcount);
 
-	rule = dr_rule_create_rule(matcher, value, num_actions, actions);
+	rule = dr_rule_create_rule(matcher, value, num_actions, actions, flow_source);
 	if (!rule)
 		refcount_dec(&matcher->refcount);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 46e7a0029d67..f50f3b107aa3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -797,6 +797,7 @@ struct mlx5dr_rule {
 	struct mlx5dr_rule_rx_tx rx;
 	struct mlx5dr_rule_rx_tx tx;
 	struct list_head rule_actions_list;
+	u32 flow_source;
 };
 
 void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *new_ste,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 9b08eb557a31..96c39a17d026 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -487,7 +487,8 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	rule = mlx5dr_rule_create(group->fs_dr_matcher.dr_matcher,
 				  &params,
 				  num_actions,
-				  actions);
+				  actions,
+				  fte->flow_context.flow_source);
 	if (!rule) {
 		err = -EINVAL;
 		goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 7deaca9ade3b..7914fe3fc68d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -67,7 +67,8 @@ struct mlx5dr_rule *
 mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
 		   struct mlx5dr_match_parameters *value,
 		   size_t num_actions,
-		   struct mlx5dr_action *actions[]);
+		   struct mlx5dr_action *actions[],
+		   u32 flow_source);
 
 int mlx5dr_rule_destroy(struct mlx5dr_rule *rule);
 
-- 
2.26.2

