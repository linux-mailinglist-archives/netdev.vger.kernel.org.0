Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A3A173E71
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgB1RZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33232 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgB1RZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id x7so3898120wrr.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dpjd3XUfq2H1vm3o5lNuK7wBaHeAgThsCnc55VMx/q8=;
        b=1+1RrcB4z12Ws5/M1CIuRf287YXi/Tu+18m5+6p27veVfOJusGoqRWVvRt5fv2lkto
         zb7Me+8EpRfZ8YbuqFv6GsvONhgp1ps7DG5odN3sJ3NsFvUimLP3FDiU4JnU7Jub4WAn
         MKKGkrZGZABze/Nd/nS4D9xbUTsRNgeT83+ckogWD8I/qdohWNPzZU1CjdXE0l0Rd41+
         /q9Ss9y4EGD0dVaDT2Ag5g/O/+MdiQ/pObavKuWjYkJAhGDrpdjw2JZQ6XPR0sl8Wmoe
         J3TDj1JoSH+hZ0ylh9fUdcJHMCZ71LcY92ocBjAy+4gv6TdEEZZ4V4Bf30RgXDXuO76S
         nk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dpjd3XUfq2H1vm3o5lNuK7wBaHeAgThsCnc55VMx/q8=;
        b=FAGM2g6ex9PuV1xvwM7n1w9eO3VLw4Ny3tM/dy4mv3tTJ+K83vkSTVK8gGQuATgyT9
         IwdBT4U4JXQ15G48r1JfbdKrVDW1R8cRl6YrJiZPwYXEv5+g3PMAHZTRJ/qgNcPsjR/3
         /QXEItvCB13mscD96zdfDqFoJrjnpB7P/41i4kdF3ewKjRGSiIjsBUKNe4GmFUzPxXok
         vz4tm/PVTgR7//yJ2wUUjHCjyJlVxpyT4G2OSKQODNKEod2obqmk2pUqAXGw3Q1mZ9qc
         ZXBFKgUd0l7PhY3v83EgXmE45oPWPIzi9R6XebKDidIfjwr3iwte6Iug3aCBGNIAM7+s
         Vksg==
X-Gm-Message-State: APjAAAVVKXlcNfK8Dm2l+za3FBmKPdMelIeK4PTrQRc1N/L/p2VbWITy
        SX6SBTKbconRzUeZEarvA7SV/Axix0A=
X-Google-Smtp-Source: APXvYqyCh/++SmlKq8bVP5bsUShmP7vve0Tm4LccRLY8JkLcxncmbJ9dcDEszhSLmV6dFOr9ZqT+SQ==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr5615746wrk.407.1582910722323;
        Fri, 28 Feb 2020 09:25:22 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id w7sm2829891wmi.9.2020.02.28.09.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:21 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 12/12] sched: act: allow user to specify type of HW stats for a filter
Date:   Fri, 28 Feb 2020 18:25:05 +0100
Message-Id: <20200228172505.14386-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200228172505.14386-1-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
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
v1->v2:
- moved the stats attr from cls_flower (filter) to any action
- rebased on top of cookie offload changes
- adjusted the patch description a bit
---
 include/net/act_api.h        |  1 +
 include/uapi/linux/pkt_cls.h | 26 ++++++++++++++++++++++++++
 net/sched/act_api.c          | 21 +++++++++++++++++++++
 net/sched/cls_api.c          | 26 ++++++++++++++++++++++++++
 4 files changed, 74 insertions(+)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 71347a90a9d1..02b9bffa17ed 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -39,6 +39,7 @@ struct tc_action {
 	struct gnet_stats_basic_cpu __percpu *cpu_bstats_hw;
 	struct gnet_stats_queue __percpu *cpu_qstats;
 	struct tc_cookie	__rcu *act_cookie;
+	enum tca_act_hw_stats_type	hw_stats_type;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
 };
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 449a63971451..096ea59a090b 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -17,6 +17,7 @@ enum {
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
+	TCA_ACT_HW_STATS_TYPE,
 	__TCA_ACT_MAX
 };
 
@@ -118,6 +119,31 @@ enum tca_id {
 
 #define TCA_ID_MAX __TCA_ID_MAX
 
+/* tca HW stats type */
+enum tca_act_hw_stats_type {
+	TCA_ACT_HW_STATS_TYPE_ANY, /* User does not care, it's default
+				    * when user does not pass the attr.
+				    * Instructs the driver that user does not
+				    * care if the HW stats are "immediate"
+				    * or "delayed".
+				    */
+	TCA_ACT_HW_STATS_TYPE_IMMEDIATE, /* Means that in dump, user gets
+					  * the current HW stats state from
+					  * the device queried at the dump time.
+					  */
+	TCA_ACT_HW_STATS_TYPE_DELAYED, /* Means that in dump, user gets
+					* HW stats that might be out of date
+					* for some time, maybe couple of
+					* seconds. This is the case when driver
+					* polls stats updates periodically
+					* or when it gets async stats update
+					* from the device.
+					*/
+	TCA_ACT_HW_STATS_TYPE_DISABLED, /* User is not interested in getting
+					 * any HW statistics.
+					 */
+};
+
 struct tc_police {
 	__u32			index;
 	int			action;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8c466a712cda..d6468b09b932 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -185,6 +185,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 	return  nla_total_size(0) /* action number nested */
 		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
+		+ nla_total_size(sizeof(u8)) /* TCA_ACT_HW_STATS_TYPE */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
 		/* TCA_STATS_BASIC */
@@ -788,6 +789,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
+	if (nla_put_u8(skb, TCA_ACT_HW_STATS_TYPE, a->hw_stats_type))
+		goto nla_put_failure;
+
 	if (a->tcfa_flags) {
 		struct nla_bitfield32 flags = { a->tcfa_flags,
 						a->tcfa_flags, };
@@ -854,12 +858,23 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 	return c;
 }
 
+static inline enum tca_act_hw_stats_type
+tcf_action_hw_stats_type_get(struct nlattr *hw_stats_type_attr)
+{
+	/* If the user did not pass the attr, that means he does
+	 * not care about the type. Return "any" in that case.
+	 */
+	return hw_stats_type_attr ? nla_get_u8(hw_stats_type_attr) :
+				    TCA_ACT_HW_STATS_TYPE_ANY;
+}
+
 static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
+	[TCA_ACT_HW_STATS_TYPE]	= { .type = NLA_U8 },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
 	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
 				    .validation_data = &tca_act_flags_allowed },
@@ -871,6 +886,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
+	enum tca_act_hw_stats_type hw_stats_type = TCA_ACT_HW_STATS_TYPE_ANY;
 	struct nla_bitfield32 flags = { 0, 0 };
 	struct tc_action *a;
 	struct tc_action_ops *a_o;
@@ -903,6 +919,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				goto err_out;
 			}
 		}
+		hw_stats_type =
+			tcf_action_hw_stats_type_get(tb[TCA_ACT_HW_STATS_TYPE]);
 		if (tb[TCA_ACT_FLAGS])
 			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
@@ -953,6 +971,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
+	if (!name)
+		a->hw_stats_type = hw_stats_type;
+
 	/* module count goes up only when brand new policy is created
 	 * if it exists and is only bound to in a_o->init() then
 	 * ACT_P_CREATED is not returned (a zero is).
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4e766c5ab77a..21bf37242153 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3458,9 +3458,28 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 #endif
 }
 
+static inline enum flow_action_hw_stats_type
+tcf_flow_action_hw_stats_type(enum tca_act_hw_stats_type hw_stats_type)
+{
+	switch (hw_stats_type) {
+	default:
+		WARN_ON(1);
+		/* fall-through */
+	case TCA_ACT_HW_STATS_TYPE_ANY:
+		return FLOW_ACTION_HW_STATS_TYPE_ANY;
+	case TCA_ACT_HW_STATS_TYPE_IMMEDIATE:
+		return FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE;
+	case TCA_ACT_HW_STATS_TYPE_DELAYED:
+		return FLOW_ACTION_HW_STATS_TYPE_DELAYED;
+	case TCA_ACT_HW_STATS_TYPE_DISABLED:
+		return FLOW_ACTION_HW_STATS_TYPE_DISABLED;
+	}
+}
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
 {
+	enum flow_action_hw_stats_type uninitialized_var(last_hw_stats_type);
 	struct tc_action *act;
 	int i, j, k, err = 0;
 
@@ -3476,6 +3495,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		err = tcf_act_get_cookie(entry, act);
 		if (err)
 			goto err_out_locked;
+
+		entry->hw_stats_type =
+			tcf_flow_action_hw_stats_type(act->hw_stats_type);
+		if (i && last_hw_stats_type != entry->hw_stats_type)
+			flow_action->mixed_hw_stats_types = true;
+		last_hw_stats_type = entry->hw_stats_type;
+
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {
-- 
2.21.1

