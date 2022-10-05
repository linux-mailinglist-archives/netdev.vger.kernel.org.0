Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99485F4D55
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJEBUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJEBUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 21:20:08 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FC81F9C0
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 18:20:05 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-127dca21a7dso18394784fac.12
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 18:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0yBylALprOBsqVAPyh3L9wldg4KBCBN0DxjdfvG3DR0=;
        b=F/fiPU3b37IOTBHW4BrJku5x6K0BgF/WBvKQh11nsIxUzKSwoVFaL6nh7CbTtmS1aU
         RjaC3f/Cee2p9A4aaBbGxdIv+gsoRde7+Tkh1nuAGw3MmzKfzTyiFycYEslAysHAgfcY
         wrJNBA/bySjfopJqUbmTYxr+U7T6x6I8HXLGFeu1sPC66+DrVJ2M1hyo7tfCz/m95PG5
         Q1ZdF9kmbrjcZ5jFSEI3sZnxZbRkd9BCI2GUYOgzFUwYR/r0tqvWuCaMH5+BgxP/p1Y+
         9eL6SvuWBwxf/wVUoIKuIWm0snP1+tCf9QbEOEBCvQRSptnNydrdgikcV1N3dQXXoW5Y
         b74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0yBylALprOBsqVAPyh3L9wldg4KBCBN0DxjdfvG3DR0=;
        b=SqDipuRmRJWIguxLqkoioMi2lG6hqW4Jvi/yfgRtxU1khR8iCo21ntZFwBZR75O3eF
         3+Cbj7qeeA1aBeOWkCxE/tHUcC3ACZRDssppOBOr8aK8CfHoEmklsX8tkCW5hExAp52h
         IZ+nL8dt0UsTloBemeASH1Atq51T8A0kyCMX1MPG8/W1dkp0sjizXkSV/8ZUwDrjEVYY
         EjFBaC2EA8g33Wo7+Gyi/oBO7UIaJHTXrqi6NRP1POD7ZGK2UHGDMW7xTYFams5bPycW
         EDVLGwZQmyvneqovQbgxOpx38RSX17IRFCmvMzH0PpzS+sK0d9IhCjY39V0FQDtR8o+Z
         6X2g==
X-Gm-Message-State: ACrzQf3ttGJddPEq8iakmoRarsL5w/kMaGDmNfOZev1QcTS3vnk/8d8P
        2rhT93zm4XG1FN/6aTon/iVUiwL3qahJZg==
X-Google-Smtp-Source: AMsMyM4kfhlmeHUCYuOSO07jOh2lB6IjdOH3w3D8VG5dW7atLqfEVf2h99HUQ7EMOJlayFbZl/Jg3A==
X-Received: by 2002:a05:6870:e24d:b0:131:22bf:691f with SMTP id d13-20020a056870e24d00b0013122bf691fmr1361470oac.238.1664932804483;
        Tue, 04 Oct 2022 18:20:04 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id ce4-20020a056830628400b00660a927e3bcsm1631787otb.25.2022.10.04.18.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:20:04 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: [PATCH net-next 3/3] net: sched: add helper support in act_ct
Date:   Tue,  4 Oct 2022 21:19:56 -0400
Message-Id: <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1664932669.git.lucien.xin@gmail.com>
References: <cover.1664932669.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
Allow attaching helpers to ct action") in OVS kernel part.

The difference is when adding TC actions family and proto cannot be got
from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
proto in tb[TCA_CT_HELPER_PROTO] to kernel.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/tc_act/tc_ct.h        |   1 +
 include/uapi/linux/tc_act/tc_ct.h |   3 +
 net/sched/act_ct.c                | 113 ++++++++++++++++++++++++++++--
 3 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 8250d6f0a462..b24ea2d9400b 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -10,6 +10,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 
 struct tcf_ct_params {
+	struct nf_conntrack_helper *helper;
 	struct nf_conn *tmpl;
 	u16 zone;
 
diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
index 5fb1d7ac1027..6c5200f0ed38 100644
--- a/include/uapi/linux/tc_act/tc_ct.h
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -22,6 +22,9 @@ enum {
 	TCA_CT_NAT_PORT_MIN,	/* be16 */
 	TCA_CT_NAT_PORT_MAX,	/* be16 */
 	TCA_CT_PAD,
+	TCA_CT_HELPER_NAME,	/* string */
+	TCA_CT_HELPER_FAMILY,	/* u8 */
+	TCA_CT_HELPER_PROTO,	/* u8 */
 	__TCA_CT_MAX
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 193a460a9d7f..f237c27079db 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -33,6 +33,7 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_conntrack_act_ct.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
 static struct workqueue_struct *act_ct_wq;
@@ -655,7 +656,7 @@ struct tc_ct_action_net {
 
 /* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
 static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
-				   u16 zone_id, bool force)
+				   struct tcf_ct_params *p, bool force)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
@@ -665,8 +666,15 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 		return false;
 	if (!net_eq(net, read_pnet(&ct->ct_net)))
 		goto drop_ct;
-	if (nf_ct_zone(ct)->id != zone_id)
+	if (nf_ct_zone(ct)->id != p->zone)
 		goto drop_ct;
+	if (p->helper) {
+		struct nf_conn_help *help;
+
+		help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
+		if (help && rcu_access_pointer(help->helper) != p->helper)
+			goto drop_ct;
+	}
 
 	/* Force conntrack entry direction. */
 	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
@@ -832,6 +840,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
 static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
+	if (params->helper) {
+#if IS_ENABLED(CONFIG_NF_NAT)
+		if (params->ct_action & TCA_CT_ACT_NAT)
+			nf_nat_helper_put(params->helper);
+#endif
+		nf_conntrack_helper_put(params->helper);
+	}
 	if (params->ct_ft)
 		tcf_ct_flow_table_put(params->ct_ft);
 	if (params->tmpl)
@@ -1033,6 +1048,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_hook_state state;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
+	bool add_helper = false;
 	bool skip_add = false;
 	bool defrag = false;
 	struct nf_conn *ct;
@@ -1086,7 +1102,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 * actually run the packet through conntrack twice unless it's for a
 	 * different zone.
 	 */
-	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
+	cached = tcf_ct_skb_nfct_cached(net, skb, p, force);
 	if (!cached) {
 		if (tcf_ct_flow_table_lookup(p, skb, family)) {
 			skip_add = true;
@@ -1119,6 +1135,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	if (err != NF_ACCEPT)
 		goto drop;
 
+	if (commit && p->helper && !nfct_help(ct)) {
+		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
+		if (err)
+			goto drop;
+		add_helper = true;
+		if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
+			if (!nfct_seqadj_ext_add(ct))
+				return -EINVAL;
+		}
+	}
+
+	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
+		if (nf_ct_helper(skb, family) != NF_ACCEPT)
+			goto drop;
+	}
+
 	if (commit) {
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
@@ -1167,6 +1199,9 @@ static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
 	[TCA_CT_NAT_IPV6_MAX] = NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
+	[TCA_CT_HELPER_NAME] = { .type = NLA_STRING, .len = NF_CT_HELPER_NAME_LEN },
+	[TCA_CT_HELPER_FAMILY] = { .type = NLA_U8 },
+	[TCA_CT_HELPER_PROTO] = { .type = NLA_U8 },
 };
 
 static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
@@ -1248,6 +1283,39 @@ static void tcf_ct_set_key_val(struct nlattr **tb,
 		nla_memcpy(mask, tb[mask_type], len);
 }
 
+static int tcf_ct_add_helper(struct tcf_ct_params *p, const char *name, u8 family,
+			     u8 proto, struct netlink_ext_ack *extack)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+	int err;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown helper");
+		return -EINVAL;
+	}
+
+	help = nf_ct_helper_ext_add(p->tmpl, GFP_KERNEL);
+	if (!help) {
+		nf_conntrack_helper_put(helper);
+		return -ENOMEM;
+	}
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (p->ct_action & TCA_CT_ACT_NAT) {
+		err = nf_nat_helper_try_module_get(name, family, proto);
+		if (err) {
+			nf_conntrack_helper_put(helper);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to load NAT helper");
+			return err;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	p->helper = helper;
+	return 0;
+}
+
 static int tcf_ct_fill_params(struct net *net,
 			      struct tcf_ct_params *p,
 			      struct tc_ct *parm,
@@ -1256,8 +1324,9 @@ static int tcf_ct_fill_params(struct net *net,
 {
 	struct tc_ct_action_net *tn = net_generic(net, act_ct_ops.net_id);
 	struct nf_conntrack_zone zone;
+	int err, family, proto, len;
 	struct nf_conn *tmpl;
-	int err;
+	char *name;
 
 	p->zone = NF_CT_DEFAULT_ZONE_ID;
 
@@ -1318,10 +1387,28 @@ static int tcf_ct_fill_params(struct net *net,
 		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate conntrack template");
 		return -ENOMEM;
 	}
-	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
 	p->tmpl = tmpl;
+	if (tb[TCA_CT_HELPER_NAME]) {
+		name = nla_data(tb[TCA_CT_HELPER_NAME]);
+		len = nla_len(tb[TCA_CT_HELPER_NAME]);
+		if (len > 16 || name[len - 1] != '\0') {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to parse helper name.");
+			err = -EINVAL;
+			goto err;
+		}
+		family = tb[TCA_CT_HELPER_FAMILY] ? nla_get_u8(tb[TCA_CT_HELPER_FAMILY]) : AF_INET;
+		proto = tb[TCA_CT_HELPER_PROTO] ? nla_get_u8(tb[TCA_CT_HELPER_PROTO]) : IPPROTO_TCP;
+		err = tcf_ct_add_helper(p, name, family, proto, extack);
+		if (err)
+			goto err;
+	}
 
+	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
 	return 0;
+err:
+	nf_ct_put(p->tmpl);
+	p->tmpl = NULL;
+	return err;
 }
 
 static int tcf_ct_init(struct net *net, struct nlattr *nla,
@@ -1490,6 +1577,19 @@ static int tcf_ct_dump_nat(struct sk_buff *skb, struct tcf_ct_params *p)
 	return 0;
 }
 
+static int tcf_ct_dump_helper(struct sk_buff *skb, struct nf_conntrack_helper *helper)
+{
+	if (!helper)
+		return 0;
+
+	if (nla_put_string(skb, TCA_CT_HELPER_NAME, helper->name) ||
+	    nla_put_u8(skb, TCA_CT_HELPER_FAMILY, helper->tuple.src.l3num) ||
+	    nla_put_u8(skb, TCA_CT_HELPER_PROTO, helper->tuple.dst.protonum))
+		return -1;
+
+	return 0;
+}
+
 static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 			      int bind, int ref)
 {
@@ -1542,6 +1642,9 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 	if (tcf_ct_dump_nat(skb, p))
 		goto nla_put_failure;
 
+	if (tcf_ct_dump_helper(skb, p->helper))
+		goto nla_put_failure;
+
 skip_dump:
 	if (nla_put(skb, TCA_CT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
-- 
2.31.1

