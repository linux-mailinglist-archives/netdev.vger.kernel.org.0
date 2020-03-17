Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3F18778C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCQBmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgCQBms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 21:42:48 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B51D206C0;
        Tue, 17 Mar 2020 01:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584409366;
        bh=QLttxDviXFKf+11ef1kwY2IjH7EYLdO8b1jEGCMrS3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWzhUf+/Ls8+U+bY1pGDZfA7GAprK+WQnN4JW3gidb1cs+mvTdCK19Cy19rsmlCrK
         7VpbyHqxNhLqxuy9WjsUMFex6BnRPMb0rnPJbHo9O78a0T/pq/sWLnCCAuVc8aQ2rh
         4BcHxklcbE/BbqPsVVGtYhry0gOBwZy0IR23pjH0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, ecree@solarflare.com,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: rename flow_action_hw_stats_types* -> flow_action_hw_stats*
Date:   Mon, 16 Mar 2020 18:42:11 -0700
Message-Id: <20200317014212.3467451-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317014212.3467451-1-kuba@kernel.org>
References: <20200317014212.3467451-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

flow_action_hw_stats_types_check() helper takes one of the
FLOW_ACTION_HW_STATS_*_BIT values as input. If we align
the arguments to the opening bracket of the helper there
is no way to call this helper and stay under 80 characters.

Remove the "types" part from the new flow_action helpers
and enum values.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 10 ++--
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  8 +--
 drivers/net/ethernet/mscc/ocelot_flower.c     |  4 +-
 .../ethernet/netronome/nfp/flower/action.c    |  3 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 .../stmicro/stmmac/stmmac_selftests.c         |  4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  2 +-
 include/net/flow_offload.h                    | 49 +++++++++----------
 net/dsa/slave.c                               |  4 +-
 net/sched/cls_api.c                           |  6 +--
 13 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 523bf4be43cc..b19be7549aad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -300,7 +300,7 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 		return -EINVAL;
 	}
 
-	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+	if (!flow_action_basic_hw_stats_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, flow_action) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index cc46277e98de..b457f2505f97 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -553,7 +553,7 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 	bool act_vlan = false;
 	int i;
 
-	if (!flow_action_basic_hw_stats_types_check(actions, extack))
+	if (!flow_action_basic_hw_stats_check(actions, extack))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, actions) {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 0a0c6ec2336c..8972cdd559e8 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1082,7 +1082,7 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 	u8 qh, ql, pmap;
 	int index, ctx;
 
-	if (!flow_action_basic_hw_stats_types_check(&rule->flow->action, NULL))
+	if (!flow_action_basic_hw_stats_check(&rule->flow->action, NULL))
 		return -EOPNOTSUPP;
 
 	memset(&c2, 0, sizeof(c2));
@@ -1308,7 +1308,7 @@ static int mvpp2_cls_rfs_parse_rule(struct mvpp2_rfs_rule *rule)
 	struct flow_rule *flow = rule->flow;
 	struct flow_action_entry *act;
 
-	if (!flow_action_basic_hw_stats_types_check(&rule->flow->action, NULL))
+	if (!flow_action_basic_hw_stats_check(&rule->flow->action, NULL))
 		return -EOPNOTSUPP;
 
 	act = &flow->action.entries[0];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 044891a03be3..4a48bcb0a8f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3180,8 +3180,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
-	if (!flow_action_hw_stats_types_check(flow_action, extack,
-					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
+	if (!flow_action_hw_stats_check(flow_action, extack,
+					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
@@ -3675,8 +3675,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
-	if (!flow_action_hw_stats_types_check(flow_action, extack,
-					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
+	if (!flow_action_hw_stats_check(flow_action, extack,
+					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, flow_action) {
@@ -4510,7 +4510,7 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+	if (!flow_action_basic_hw_stats_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, flow_action) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 88aa554415df..21c4b10d106c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -26,17 +26,17 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 
 	if (!flow_action_has_entries(flow_action))
 		return 0;
-	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
+	if (!flow_action_mixed_hw_stats_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_ANY ||
-	    act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE) {
+	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_ANY ||
+	    act->hw_stats_type == FLOW_ACTION_HW_STATS_IMMEDIATE) {
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
 			return err;
-	} else if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_DISABLED) {
+	} else if (act->hw_stats_type != FLOW_ACTION_HW_STATS_DISABLED) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 6d84173373c7..873a9944fbfb 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -17,8 +17,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	if (!flow_offload_has_one_action(&f->rule->action))
 		return -EOPNOTSUPP;
 
-	if (!flow_action_basic_hw_stats_types_check(&f->rule->action,
-						    f->common.extack))
+	if (!flow_action_basic_hw_stats_check(&f->rule->action,
+					      f->common.extack))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, a, &f->rule->action) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 4aa7346cb040..5fb9869f85d7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -1207,8 +1207,7 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	bool pkt_host = false;
 	u32 csum_updated = 0;
 
-	if (!flow_action_basic_hw_stats_types_check(&flow->rule->action,
-						    extack))
+	if (!flow_action_basic_hw_stats_check(&flow->rule->action, extack))
 		return -EOPNOTSUPP;
 
 	memset(nfp_flow->action_data, 0, NFP_FL_MAX_A_SIZ);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 6505f7e2d1db..fe72bb6c9455 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1757,7 +1757,7 @@ static int qede_parse_actions(struct qede_dev *edev,
 		return -EINVAL;
 	}
 
-	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+	if (!flow_action_basic_hw_stats_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, flow_action) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 07dbe4f5456e..63d6c85a59e3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1387,7 +1387,7 @@ static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	cls->rule = rule;
 
 	rule->action.entries[0].id = FLOW_ACTION_DROP;
-	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_TYPE_ANY;
+	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_ANY;
 	rule->action.num_entries = 1;
 
 	attr.dst = priv->dev->dev_addr;
@@ -1516,7 +1516,7 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	cls->rule = rule;
 
 	rule->action.entries[0].id = FLOW_ACTION_DROP;
-	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_TYPE_ANY;
+	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_ANY;
 	rule->action.num_entries = 1;
 
 	attr.dst = priv->dev->dev_addr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index a0e6118444b0..3d747846f482 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -376,7 +376,7 @@ static int tc_parse_flow_actions(struct stmmac_priv *priv,
 	if (!flow_action_has_entries(action))
 		return -EINVAL;
 
-	if (!flow_action_basic_hw_stats_types_check(action, extack))
+	if (!flow_action_basic_hw_stats_check(action, extack))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, action) {
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index efd8d47f6997..1e30b0d44b61 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -163,19 +163,17 @@ enum flow_action_mangle_base {
 };
 
 enum flow_action_hw_stats_type_bit {
-	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE_BIT,
-	FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT,
+	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
+	FLOW_ACTION_HW_STATS_DELAYED_BIT,
 };
 
 enum flow_action_hw_stats_type {
-	FLOW_ACTION_HW_STATS_TYPE_DISABLED = 0,
-	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE =
-		BIT(FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE_BIT),
-	FLOW_ACTION_HW_STATS_TYPE_DELAYED =
-		BIT(FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT),
-	FLOW_ACTION_HW_STATS_TYPE_ANY =
-		FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE |
-		FLOW_ACTION_HW_STATS_TYPE_DELAYED,
+	FLOW_ACTION_HW_STATS_DISABLED = 0,
+	FLOW_ACTION_HW_STATS_IMMEDIATE =
+		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
+	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
+	FLOW_ACTION_HW_STATS_ANY = FLOW_ACTION_HW_STATS_IMMEDIATE |
+				   FLOW_ACTION_HW_STATS_DELAYED,
 };
 
 typedef void (*action_destr)(void *priv);
@@ -285,8 +283,8 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
 	     __act = &(__actions)->entries[++__i])
 
 static inline bool
-flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
-				       struct netlink_ext_ack *extack)
+flow_action_mixed_hw_stats_check(const struct flow_action *action,
+				 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *action_entry;
 	u8 uninitialized_var(last_hw_stats_type);
@@ -313,20 +311,20 @@ flow_action_first_entry_get(const struct flow_action *action)
 }
 
 static inline bool
-__flow_action_hw_stats_types_check(const struct flow_action *action,
-				   struct netlink_ext_ack *extack,
-				   bool check_allow_bit,
-				   enum flow_action_hw_stats_type_bit allow_bit)
+__flow_action_hw_stats_check(const struct flow_action *action,
+			     struct netlink_ext_ack *extack,
+			     bool check_allow_bit,
+			     enum flow_action_hw_stats_type_bit allow_bit)
 {
 	const struct flow_action_entry *action_entry;
 
 	if (!flow_action_has_entries(action))
 		return true;
-	if (!flow_action_mixed_hw_stats_types_check(action, extack))
+	if (!flow_action_mixed_hw_stats_check(action, extack))
 		return false;
 	action_entry = flow_action_first_entry_get(action);
 	if (!check_allow_bit &&
-	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
+	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_ANY) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
 		return false;
 	} else if (check_allow_bit &&
@@ -338,19 +336,18 @@ __flow_action_hw_stats_types_check(const struct flow_action *action,
 }
 
 static inline bool
-flow_action_hw_stats_types_check(const struct flow_action *action,
-				 struct netlink_ext_ack *extack,
-				 enum flow_action_hw_stats_type_bit allow_bit)
+flow_action_hw_stats_check(const struct flow_action *action,
+			   struct netlink_ext_ack *extack,
+			   enum flow_action_hw_stats_type_bit allow_bit)
 {
-	return __flow_action_hw_stats_types_check(action, extack,
-						  true, allow_bit);
+	return __flow_action_hw_stats_check(action, extack, true, allow_bit);
 }
 
 static inline bool
-flow_action_basic_hw_stats_types_check(const struct flow_action *action,
-				       struct netlink_ext_ack *extack)
+flow_action_basic_hw_stats_check(const struct flow_action *action,
+				 struct netlink_ext_ack *extack)
 {
-	return __flow_action_hw_stats_types_check(action, extack, false, 0);
+	return __flow_action_hw_stats_check(action, extack, false, 0);
 }
 
 struct flow_rule {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c5beb3031a72..5f782fa3029f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -861,8 +861,8 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	if (!flow_offload_has_one_action(&cls->rule->action))
 		return err;
 
-	if (!flow_action_basic_hw_stats_types_check(&cls->rule->action,
-						    cls->common.extack))
+	if (!flow_action_basic_hw_stats_check(&cls->rule->action,
+					      cls->common.extack))
 		return err;
 
 	act = &cls->rule->action.entries[0];
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 363264ca2e09..2dc6e23a88c8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3528,9 +3528,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	struct tc_action *act;
 	int i, j, k, err = 0;
 
-	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_TYPE_ANY);
-	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE);
-	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_TYPE_DELAYED);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_ANY);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
 	if (!exts)
 		return 0;
-- 
2.24.1

