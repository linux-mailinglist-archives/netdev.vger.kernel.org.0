Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD517CDDD
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgCGLkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:43 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36965 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgCGLki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id 6so5375743wre.4
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Rmi0sC4ZOb9CTz7dqsCHikMLwzkdKpWFb8GwbJ6WJU=;
        b=zxLSOppQkPveFaJj0bkTAiodNFRgOwrZGNqrn1rExnqVbpxDs9ttokJzyRhO4j8g5l
         lKHARsYOjr8/dYopuBEoFE2qm/232JfMn9mxpzfFMu44br2+R1AgN+6MTe9BRKpQd6gd
         xU8oFWDY7hli9VDBam3QlwSPcpktQFUlVlRp5eFYnRUbgor6JnzJr3YTTcIf21w0z5zH
         iMcLX7rSFMnyEvSvU7PSBTnPMdtsRlW0Z1MsZASqMlA/n+ns4zc89HZjopskALCj4pAU
         aKP/yuRucPG4HmGuRNWzKu7Uzed6ndjiSmyVAOoLiLsc8nQqh09wKAw0OiQ0tXiCYMIl
         CUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Rmi0sC4ZOb9CTz7dqsCHikMLwzkdKpWFb8GwbJ6WJU=;
        b=hc7jvjckbG3IHggtXLV552b5CevageXlzPrCGqZhhZyKb/Pv4xEWtwIDE/ponKmiv7
         0uVyVZCWjTeAhd/DrIiCrjjwE0ylOBqKXaTfCxmMG7LY758pSU4271yLtgMhhBK5FgAz
         YqVmaiboKvr79TwIeZW5+m8L95aYHPTOJFjuKHHa8boLDrilKz1sQkNnTUTj/YJyjpBm
         gflZyTZ4Vg2EJbjfr2y6RTEnHHNbYdnQo9QxwSwzQ3XrUb6LLzbz8bwadPvPj+BOSiPG
         qrOPSp/+nVwXRPZFkc2lStY2v0Gxpq1Pmn2faGPnwQsnE120HaEkT5uY9WBLcoFRcqkj
         Uw2Q==
X-Gm-Message-State: ANhLgQ3gIVA+0hoAd6Bmpzb6kWwpqnzir5aMJJOLfgb/Iv9lT0J5OXBR
        MqnlM/UNsu+5rJKL0YehpXRTxdDUGCo=
X-Google-Smtp-Source: ADFU+vvrtXXZB8thO4RSs46E5+eXWlUgSOIzn27OOV9wK7GPDoVJkl9yM1loRDwTwu8JZkU5JwAhlw==
X-Received: by 2002:a5d:4104:: with SMTP id l4mr7770344wrp.55.1583581235906;
        Sat, 07 Mar 2020 03:40:35 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id r28sm55453943wra.16.2020.03.07.03.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:35 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 10/10] sched: act: allow user to specify type of HW stats for a filter
Date:   Sat,  7 Mar 2020 12:40:20 +0100
Message-Id: <20200307114020.8664-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200307114020.8664-1-jiri@resnulli.us>
References: <20200307114020.8664-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, user who is adding an action expects HW to report stats,
however it does not have exact expectations about the stats types.
That is aligned with TCA_ACT_HW_STATS_TYPE_ANY.

Allow user to specify the type of HW stats for an action and require it.

Pass the information down to flow_offload layer.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- removed "mixed" bool init
- moved to bitfield
- removed "inline"
v1->v2:
- moved the stats attr from cls_flower (filter) to any action
- rebased on top of cookie offload changes
- adjusted the patch description a bit
---
 include/net/act_api.h        |  4 ++++
 include/uapi/linux/pkt_cls.h | 22 ++++++++++++++++++++++
 net/sched/act_api.c          | 36 ++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c          |  7 +++++++
 4 files changed, 69 insertions(+)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 71347a90a9d1..41337c7fc728 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -41,6 +41,7 @@ struct tc_action {
 	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
+	u8			hw_stats_type;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
@@ -52,6 +53,9 @@ struct tc_action {
 #define tcf_rate_est	common.tcfa_rate_est
 #define tcf_lock	common.tcfa_lock
 
+#define TCA_ACT_HW_STATS_TYPE_ANY (TCA_ACT_HW_STATS_TYPE_IMMEDIATE | \
+				   TCA_ACT_HW_STATS_TYPE_DELAYED)
+
 /* Update lastuse only if needed, to avoid dirtying a cache line.
  * We use a temp variable to avoid fetching jiffies twice.
  */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 449a63971451..81cc1a869588 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -17,6 +17,7 @@ enum {
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
+	TCA_ACT_HW_STATS_TYPE,
 	__TCA_ACT_MAX
 };
 
@@ -24,6 +25,27 @@ enum {
 					 * actions stats.
 					 */
 
+/* tca HW stats type
+ * When user does not pass the attribute, he does not care.
+ * It is the same as if he would pass the attribute with
+ * all supported bits set.
+ * In case no bits are set, user is not interested in getting any HW statistics.
+ */
+#define TCA_ACT_HW_STATS_TYPE_IMMEDIATE (1 << 0) /* Means that in dump, user
+						  * gets the current HW stats
+						  * state from the device
+						  * queried at the dump time.
+						  */
+#define TCA_ACT_HW_STATS_TYPE_DELAYED (1 << 1) /* Means that in dump, user gets
+						* HW stats that might be out
+						* of date for some time, maybe
+						* couple of seconds. This is
+						* the case when driver polls
+						* stats updates periodically
+						* or when it gets async stats update
+						* from the device.
+						*/
+
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
 #define TCA_ACT_MAX_PRIO 32
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8c466a712cda..aa7b737fed2e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -185,6 +185,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 	return  nla_total_size(0) /* action number nested */
 		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
+		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_HW_STATS_TYPE */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
 		/* TCA_STATS_BASIC */
@@ -788,6 +789,17 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
+	if (a->hw_stats_type != TCA_ACT_HW_STATS_TYPE_ANY) {
+		struct nla_bitfield32 hw_stats_type = {
+			a->hw_stats_type,
+			TCA_ACT_HW_STATS_TYPE_ANY,
+		};
+
+		if (nla_put(skb, TCA_ACT_HW_STATS_TYPE, sizeof(hw_stats_type),
+			    &hw_stats_type))
+			goto nla_put_failure;
+	}
+
 	if (a->tcfa_flags) {
 		struct nla_bitfield32 flags = { a->tcfa_flags,
 						a->tcfa_flags, };
@@ -854,7 +866,23 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 	return c;
 }
 
+static u8 tcf_action_hw_stats_type_get(struct nlattr *hw_stats_type_attr)
+{
+	struct nla_bitfield32 hw_stats_type_bf;
+
+	/* If the user did not pass the attr, that means he does
+	 * not care about the type. Return "any" in that case
+	 * which is setting on all supported types.
+	 */
+	if (!hw_stats_type_attr)
+		return TCA_ACT_HW_STATS_TYPE_ANY;
+	hw_stats_type_bf = nla_get_bitfield32(hw_stats_type_attr);
+	return hw_stats_type_bf.value;
+}
+
 static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
+static const u32 tca_act_hw_stats_type_allowed = TCA_ACT_HW_STATS_TYPE_ANY;
+
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
@@ -863,6 +891,8 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
 	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
 				    .validation_data = &tca_act_flags_allowed },
+	[TCA_ACT_HW_STATS_TYPE]	= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_act_hw_stats_type_allowed },
 };
 
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
@@ -871,6 +901,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
+	u8 hw_stats_type = TCA_ACT_HW_STATS_TYPE_ANY;
 	struct nla_bitfield32 flags = { 0, 0 };
 	struct tc_action *a;
 	struct tc_action_ops *a_o;
@@ -903,6 +934,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				goto err_out;
 			}
 		}
+		hw_stats_type =
+			tcf_action_hw_stats_type_get(tb[TCA_ACT_HW_STATS_TYPE]);
 		if (tb[TCA_ACT_FLAGS])
 			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
@@ -953,6 +986,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
+	if (!name)
+		a->hw_stats_type = hw_stats_type;
+
 	/* module count goes up only when brand new policy is created
 	 * if it exists and is only bound to in a_o->init() then
 	 * ACT_P_CREATED is not returned (a zero is).
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4e766c5ab77a..e91448640a4f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3464,6 +3464,10 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	struct tc_action *act;
 	int i, j, k, err = 0;
 
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_TYPE_ANY);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE);
+	BUILD_BUG_ON(TCA_ACT_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_TYPE_DELAYED);
+
 	if (!exts)
 		return 0;
 
@@ -3476,6 +3480,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		err = tcf_act_get_cookie(entry, act);
 		if (err)
 			goto err_out_locked;
+
+		entry->hw_stats_type = act->hw_stats_type;
+
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {
-- 
2.21.1

