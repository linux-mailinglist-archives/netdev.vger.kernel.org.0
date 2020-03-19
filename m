Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDAD18C39A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCSX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727597AbgCSX0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 19:26:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C42820767;
        Thu, 19 Mar 2020 23:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584660391;
        bh=d0G+YQFb3Pu1AVwoL0G6RU3RIjEYng5aC5NvIfkcx7g=;
        h=From:To:Cc:Subject:Date:From;
        b=Jj42uq5rGG3XIxcwr3rJAZvLE47ObpnFPg3Wvcd+8F4nZVa65tONtnr6p2EvbZZfz
         zeSFPBWCMriRgg/NozCaKhnAPagEuU2HzplwFGzNTWnj5fDoE9wUAFyfBkyTkTRczA
         /eSgjX/H60Tk71RaANgxhtkQb/ipijysJfv7oCzc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: sched: rename more stats_types
Date:   Thu, 19 Mar 2020 16:26:23 -0700
Message-Id: <20200319232623.102700-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 53eca1f3479f ("net: rename flow_action_hw_stats_types* ->
flow_action_hw_stats*") renamed just the flow action types and
helpers. For consistency rename variables, enums, struct members
and UAPI too (note that this UAPI was not in any official release,
yet).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  6 +--
 .../stmicro/stmmac/stmmac_selftests.c         |  4 +-
 include/net/act_api.h                         |  6 +--
 include/net/flow_offload.h                    | 20 +++++-----
 include/uapi/linux/pkt_cls.h                  | 29 +++++++-------
 net/sched/act_api.c                           | 38 +++++++++----------
 net/sched/cls_api.c                           | 10 ++---
 7 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 21c4b10d106c..67252094a0ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -30,13 +30,13 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_ANY ||
-	    act->hw_stats_type == FLOW_ACTION_HW_STATS_IMMEDIATE) {
+	if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||
+	    act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
 			return err;
-	} else if (act->hw_stats_type != FLOW_ACTION_HW_STATS_DISABLED) {
+	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 63d6c85a59e3..e6696495f126 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1387,7 +1387,7 @@ static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	cls->rule = rule;
 
 	rule->action.entries[0].id = FLOW_ACTION_DROP;
-	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_ANY;
+	rule->action.entries[0].hw_stats = FLOW_ACTION_HW_STATS_ANY;
 	rule->action.num_entries = 1;
 
 	attr.dst = priv->dev->dev_addr;
@@ -1516,7 +1516,7 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	cls->rule = rule;
 
 	rule->action.entries[0].id = FLOW_ACTION_DROP;
-	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_ANY;
+	rule->action.entries[0].hw_stats = FLOW_ACTION_HW_STATS_ANY;
 	rule->action.num_entries = 1;
 
 	attr.dst = priv->dev->dev_addr;
diff --git a/include/net/act_api.h b/include/net/act_api.h
index 41337c7fc728..ecdec9d6ead0 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -41,7 +41,7 @@ struct tc_action {
 	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
-	u8			hw_stats_type;
+	u8			hw_stats;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
@@ -53,8 +53,8 @@ struct tc_action {
 #define tcf_rate_est	common.tcfa_rate_est
 #define tcf_lock	common.tcfa_lock
 
-#define TCA_ACT_HW_STATS_TYPE_ANY (TCA_ACT_HW_STATS_TYPE_IMMEDIATE | \
-				   TCA_ACT_HW_STATS_TYPE_DELAYED)
+#define TCA_ACT_HW_STATS_ANY (TCA_ACT_HW_STATS_IMMEDIATE | \
+			      TCA_ACT_HW_STATS_DELAYED)
 
 /* Update lastuse only if needed, to avoid dirtying a cache line.
  * We use a temp variable to avoid fetching jiffies twice.
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 1e30b0d44b61..282989502dde 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -162,12 +162,12 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
-enum flow_action_hw_stats_type_bit {
+enum flow_action_hw_stats_bit {
 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
 };
 
-enum flow_action_hw_stats_type {
+enum flow_action_hw_stats {
 	FLOW_ACTION_HW_STATS_DISABLED = 0,
 	FLOW_ACTION_HW_STATS_IMMEDIATE =
 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
@@ -190,7 +190,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
-	enum flow_action_hw_stats_type	hw_stats_type;
+	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
 	union {
@@ -287,18 +287,18 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 				 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *action_entry;
-	u8 uninitialized_var(last_hw_stats_type);
+	u8 uninitialized_var(last_hw_stats);
 	int i;
 
 	if (flow_offload_has_one_action(action))
 		return true;
 
 	flow_action_for_each(i, action_entry, action) {
-		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
+		if (i && action_entry->hw_stats != last_hw_stats) {
 			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
 			return false;
 		}
-		last_hw_stats_type = action_entry->hw_stats_type;
+		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
@@ -314,7 +314,7 @@ static inline bool
 __flow_action_hw_stats_check(const struct flow_action *action,
 			     struct netlink_ext_ack *extack,
 			     bool check_allow_bit,
-			     enum flow_action_hw_stats_type_bit allow_bit)
+			     enum flow_action_hw_stats_bit allow_bit)
 {
 	const struct flow_action_entry *action_entry;
 
@@ -324,11 +324,11 @@ __flow_action_hw_stats_check(const struct flow_action *action,
 		return false;
 	action_entry = flow_action_first_entry_get(action);
 	if (!check_allow_bit &&
-	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_ANY) {
+	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
 		return false;
 	} else if (check_allow_bit &&
-		   !(action_entry->hw_stats_type & BIT(allow_bit))) {
+		   !(action_entry->hw_stats & BIT(allow_bit))) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
 		return false;
 	}
@@ -338,7 +338,7 @@ __flow_action_hw_stats_check(const struct flow_action *action,
 static inline bool
 flow_action_hw_stats_check(const struct flow_action *action,
 			   struct netlink_ext_ack *extack,
-			   enum flow_action_hw_stats_type_bit allow_bit)
+			   enum flow_action_hw_stats_bit allow_bit)
 {
 	return __flow_action_hw_stats_check(action, extack, true, allow_bit);
 }
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 81cc1a869588..6fcf7307e534 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -17,7 +17,7 @@ enum {
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
-	TCA_ACT_HW_STATS_TYPE,
+	TCA_ACT_HW_STATS,
 	__TCA_ACT_MAX
 };
 
@@ -31,20 +31,19 @@ enum {
  * all supported bits set.
  * In case no bits are set, user is not interested in getting any HW statistics.
  */
-#define TCA_ACT_HW_STATS_TYPE_IMMEDIATE (1 << 0) /* Means that in dump, user
-						  * gets the current HW stats
-						  * state from the device
-						  * queried at the dump time.
-						  */
-#define TCA_ACT_HW_STATS_TYPE_DELAYED (1 << 1) /* Means that in dump, user gets
-						* HW stats that might be out
-						* of date for some time, maybe
-						* couple of seconds. This is
-						* the case when driver polls
-						* stats updates periodically
-						* or when it gets async stats update
-						* from the device.
-						*/
+#define TCA_ACT_HW_STATS_IMMEDIATE (1 << 0) /* Means that in dump, user
+					     * gets the current HW stats
+					     * state from the device
+					     * queried at the dump time.
+					     */
+#define TCA_ACT_HW_STATS_DELAYED (1 << 1) /* Means that in dump, user gets
+					   * HW stats that might be out of date
+					   * for some time, maybe couple of
+					   * seconds. This is the case when
+					   * driver polls stats updates
+					   * periodically or when it gets async
+					   * stats update from the device.
+					   */
 
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index aa7b737fed2e..861a831b0ef7 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -185,7 +185,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 	return  nla_total_size(0) /* action number nested */
 		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
-		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_HW_STATS_TYPE */
+		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_HW_STATS */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
 		/* TCA_STATS_BASIC */
@@ -789,14 +789,13 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
-	if (a->hw_stats_type != TCA_ACT_HW_STATS_TYPE_ANY) {
-		struct nla_bitfield32 hw_stats_type = {
-			a->hw_stats_type,
-			TCA_ACT_HW_STATS_TYPE_ANY,
+	if (a->hw_stats != TCA_ACT_HW_STATS_ANY) {
+		struct nla_bitfield32 hw_stats = {
+			a->hw_stats,
+			TCA_ACT_HW_STATS_ANY,
 		};
 
-		if (nla_put(skb, TCA_ACT_HW_STATS_TYPE, sizeof(hw_stats_type),
-			    &hw_stats_type))
+		if (nla_put(skb, TCA_ACT_HW_STATS, sizeof(hw_stats), &hw_stats))
 			goto nla_put_failure;
 	}
 
@@ -866,22 +865,22 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 	return c;
 }
 
-static u8 tcf_action_hw_stats_type_get(struct nlattr *hw_stats_type_attr)
+static u8 tcf_action_hw_stats_get(struct nlattr *hw_stats_attr)
 {
-	struct nla_bitfield32 hw_stats_type_bf;
+	struct nla_bitfield32 hw_stats_bf;
 
 	/* If the user did not pass the attr, that means he does
 	 * not care about the type. Return "any" in that case
 	 * which is setting on all supported types.
 	 */
-	if (!hw_stats_type_attr)
-		return TCA_ACT_HW_STATS_TYPE_ANY;
-	hw_stats_type_bf = nla_get_bitfield32(hw_stats_type_attr);
-	return hw_stats_type_bf.value;
+	if (!hw_stats_attr)
+		return TCA_ACT_HW_STATS_ANY;
+	hw_stats_bf = nla_get_bitfield32(hw_stats_attr);
+	return hw_stats_bf.value;
 }
 
 static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
-static const u32 tca_act_hw_stats_type_allowed = TCA_ACT_HW_STATS_TYPE_ANY;
+static const u32 tca_act_hw_stats_allowed = TCA_ACT_HW_STATS_ANY;
 
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_KIND]		= { .type = NLA_STRING },
@@ -891,8 +890,8 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
 	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
 				    .validation_data = &tca_act_flags_allowed },
-	[TCA_ACT_HW_STATS_TYPE]	= { .type = NLA_BITFIELD32,
-				    .validation_data = &tca_act_hw_stats_type_allowed },
+	[TCA_ACT_HW_STATS]	= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_act_hw_stats_allowed },
 };
 
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
@@ -901,8 +900,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
-	u8 hw_stats_type = TCA_ACT_HW_STATS_TYPE_ANY;
 	struct nla_bitfield32 flags = { 0, 0 };
+	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
 	struct tc_action *a;
 	struct tc_action_ops *a_o;
 	struct tc_cookie *cookie = NULL;
@@ -934,8 +933,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				goto err_out;
 			}
 		}
-		hw_stats_type =
-			tcf_action_hw_stats_type_get(tb[TCA_ACT_HW_STATS_TYPE]);
+		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
 		if (tb[TCA_ACT_FLAGS])
 			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
@@ -987,7 +985,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
 	if (!name)
-		a->hw_stats_type = hw_stats_type;
+		a->hw_stats = hw_stats;
 
 	/* module count goes up only when brand new policy is created
 	 * if it exists and is only bound to in a_o->init() then
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index eefacb3176e3..06978dad9b89 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3528,9 +3528,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	struct tc_action *act;
 	int i, j, k, err = 0;
 
-	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_ANY);
-	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
-	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
 	if (!exts)
 		return 0;
@@ -3545,7 +3545,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		if (err)
 			goto err_out_locked;
 
-		entry->hw_stats_type = act->hw_stats_type;
+		entry->hw_stats = act->hw_stats;
 
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
@@ -3613,7 +3613,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mangle.mask = tcf_pedit_mask(act, k);
 				entry->mangle.val = tcf_pedit_val(act, k);
 				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry->hw_stats_type = act->hw_stats_type;
+				entry->hw_stats = act->hw_stats;
 				entry = &flow_action->entries[++j];
 			}
 		} else if (is_tcf_csum(act)) {
-- 
2.25.1

