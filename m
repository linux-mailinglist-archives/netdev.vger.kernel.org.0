Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6584C5AE775
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbiIFML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbiIFMLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:11:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7E0786ED;
        Tue,  6 Sep 2022 05:11:41 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MMPMY6SwpzrS6r;
        Tue,  6 Sep 2022 20:09:45 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 6 Sep
 2022 20:11:38 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <martin.lau@linux.dev>
CC:     <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <ast@kernel.org>, <andrii@kernel.org>, <song@kernel.org>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 01/22] net: sched: act: move global static variable net_id to tc_action_ops
Date:   Tue, 6 Sep 2022 20:13:25 +0800
Message-ID: <20220906121346.71578-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220906121346.71578-1-shaozhengchao@huawei.com>
References: <20220906121346.71578-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each tc action module has a corresponding net_id, so put net_id directly
into the structure tc_action_ops.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/act_api.h      |  1 +
 net/sched/act_bpf.c        | 13 ++++++-------
 net/sched/act_connmark.c   | 13 ++++++-------
 net/sched/act_csum.c       | 13 ++++++-------
 net/sched/act_ct.c         | 17 ++++++++---------
 net/sched/act_ctinfo.c     | 13 ++++++-------
 net/sched/act_gact.c       | 13 ++++++-------
 net/sched/act_gate.c       | 13 ++++++-------
 net/sched/act_ife.c        | 13 ++++++-------
 net/sched/act_ipt.c        | 31 ++++++++++++++-----------------
 net/sched/act_mirred.c     | 13 ++++++-------
 net/sched/act_mpls.c       | 13 ++++++-------
 net/sched/act_nat.c        | 13 ++++++-------
 net/sched/act_pedit.c      | 13 ++++++-------
 net/sched/act_police.c     | 13 ++++++-------
 net/sched/act_sample.c     | 13 ++++++-------
 net/sched/act_simple.c     | 13 ++++++-------
 net/sched/act_skbedit.c    | 13 ++++++-------
 net/sched/act_skbmod.c     | 13 ++++++-------
 net/sched/act_tunnel_key.c | 13 ++++++-------
 net/sched/act_vlan.c       | 13 ++++++-------
 21 files changed, 131 insertions(+), 152 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9cf6870b526e..86253f8b69a3 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -113,6 +113,7 @@ struct tc_action_ops {
 	enum tca_id  id; /* identifier should match kind */
 	size_t	size;
 	struct module		*owner;
+	unsigned int		net_id;
 	int     (*act)(struct sk_buff *, const struct tc_action *,
 		       struct tcf_result *); /* called under RCU BH lock*/
 	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index fea2d78b9ddc..dd839efe9649 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -29,7 +29,6 @@ struct tcf_bpf_cfg {
 	bool is_ebpf;
 };
 
-static unsigned int bpf_net_id;
 static struct tc_action_ops act_bpf_ops;
 
 static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
@@ -280,7 +279,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 			struct tcf_proto *tp, u32 flags,
 			struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, bpf_net_id);
+	struct tc_action_net *tn = net_generic(net, act_bpf_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_ACT_BPF_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -395,14 +394,14 @@ static int tcf_bpf_walker(struct net *net, struct sk_buff *skb,
 			  const struct tc_action_ops *ops,
 			  struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, bpf_net_id);
+	struct tc_action_net *tn = net_generic(net, act_bpf_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_bpf_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, bpf_net_id);
+	struct tc_action_net *tn = net_generic(net, act_bpf_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -422,20 +421,20 @@ static struct tc_action_ops act_bpf_ops __read_mostly = {
 
 static __net_init int bpf_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, bpf_net_id);
+	struct tc_action_net *tn = net_generic(net, act_bpf_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_bpf_ops);
 }
 
 static void __net_exit bpf_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, bpf_net_id);
+	tc_action_net_exit(net_list, act_bpf_ops.net_id);
 }
 
 static struct pernet_operations bpf_net_ops = {
 	.init = bpf_init_net,
 	.exit_batch = bpf_exit_net,
-	.id   = &bpf_net_id,
+	.id   = &act_bpf_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 09e2aafc8943..1ea9ad187560 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -25,7 +25,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
-static unsigned int connmark_net_id;
 static struct tc_action_ops act_connmark_ops;
 
 static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
@@ -99,7 +98,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 			     struct tcf_proto *tp, u32 flags,
 			     struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, connmark_net_id);
+	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
 	struct nlattr *tb[TCA_CONNMARK_MAX + 1];
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_chain *goto_ch = NULL;
@@ -205,14 +204,14 @@ static int tcf_connmark_walker(struct net *net, struct sk_buff *skb,
 			       const struct tc_action_ops *ops,
 			       struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, connmark_net_id);
+	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_connmark_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, connmark_net_id);
+	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -231,20 +230,20 @@ static struct tc_action_ops act_connmark_ops = {
 
 static __net_init int connmark_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, connmark_net_id);
+	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_connmark_ops);
 }
 
 static void __net_exit connmark_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, connmark_net_id);
+	tc_action_net_exit(net_list, act_connmark_ops.net_id);
 }
 
 static struct pernet_operations connmark_net_ops = {
 	.init = connmark_init_net,
 	.exit_batch = connmark_exit_net,
-	.id   = &connmark_net_id,
+	.id   = &act_connmark_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 22847ee009ef..400f80cca40f 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -37,7 +37,6 @@ static const struct nla_policy csum_policy[TCA_CSUM_MAX + 1] = {
 	[TCA_CSUM_PARMS] = { .len = sizeof(struct tc_csum), },
 };
 
-static unsigned int csum_net_id;
 static struct tc_action_ops act_csum_ops;
 
 static int tcf_csum_init(struct net *net, struct nlattr *nla,
@@ -45,7 +44,7 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 			 struct tcf_proto *tp,
 			 u32 flags, struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, csum_net_id);
+	struct tc_action_net *tn = net_generic(net, act_csum_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_csum_params *params_new;
 	struct nlattr *tb[TCA_CSUM_MAX + 1];
@@ -678,14 +677,14 @@ static int tcf_csum_walker(struct net *net, struct sk_buff *skb,
 			   const struct tc_action_ops *ops,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, csum_net_id);
+	struct tc_action_net *tn = net_generic(net, act_csum_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_csum_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, csum_net_id);
+	struct tc_action_net *tn = net_generic(net, act_csum_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -731,20 +730,20 @@ static struct tc_action_ops act_csum_ops = {
 
 static __net_init int csum_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, csum_net_id);
+	struct tc_action_net *tn = net_generic(net, act_csum_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_csum_ops);
 }
 
 static void __net_exit csum_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, csum_net_id);
+	tc_action_net_exit(net_list, act_csum_ops.net_id);
 }
 
 static struct pernet_operations csum_net_ops = {
 	.init = csum_init_net,
 	.exit_batch = csum_exit_net,
-	.id   = &csum_net_id,
+	.id   = &act_csum_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d55afb8d14be..38b2f583106c 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -649,7 +649,6 @@ static void tcf_ct_flow_tables_uninit(void)
 }
 
 static struct tc_action_ops act_ct_ops;
-static unsigned int ct_net_id;
 
 struct tc_ct_action_net {
 	struct tc_action_net tn; /* Must be first */
@@ -1255,7 +1254,7 @@ static int tcf_ct_fill_params(struct net *net,
 			      struct nlattr **tb,
 			      struct netlink_ext_ack *extack)
 {
-	struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
+	struct tc_ct_action_net *tn = net_generic(net, act_ct_ops.net_id);
 	struct nf_conntrack_zone zone;
 	struct nf_conn *tmpl;
 	int err;
@@ -1330,7 +1329,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 		       struct tcf_proto *tp, u32 flags,
 		       struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ct_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ct_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_ct_params *params = NULL;
 	struct nlattr *tb[TCA_CT_MAX + 1];
@@ -1563,14 +1562,14 @@ static int tcf_ct_walker(struct net *net, struct sk_buff *skb,
 			 const struct tc_action_ops *ops,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ct_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ct_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_ct_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, ct_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ct_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -1623,7 +1622,7 @@ static struct tc_action_ops act_ct_ops = {
 static __net_init int ct_init_net(struct net *net)
 {
 	unsigned int n_bits = sizeof_field(struct tcf_ct_params, labels) * 8;
-	struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
+	struct tc_ct_action_net *tn = net_generic(net, act_ct_ops.net_id);
 
 	if (nf_connlabels_get(net, n_bits - 1)) {
 		tn->labels = false;
@@ -1641,20 +1640,20 @@ static void __net_exit ct_exit_net(struct list_head *net_list)
 
 	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list) {
-		struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
+		struct tc_ct_action_net *tn = net_generic(net, act_ct_ops.net_id);
 
 		if (tn->labels)
 			nf_connlabels_put(net);
 	}
 	rtnl_unlock();
 
-	tc_action_net_exit(net_list, ct_net_id);
+	tc_action_net_exit(net_list, act_ct_ops.net_id);
 }
 
 static struct pernet_operations ct_net_ops = {
 	.init = ct_init_net,
 	.exit_batch = ct_exit_net,
-	.id   = &ct_net_id,
+	.id   = &act_ct_ops.net_id,
 	.size = sizeof(struct tc_ct_action_net),
 };
 
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 0281e45987a4..626f338c694d 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -25,7 +25,6 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 
 static struct tc_action_ops act_ctinfo_ops;
-static unsigned int ctinfo_net_id;
 
 static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				struct tcf_ctinfo_params *cp,
@@ -157,7 +156,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 			   struct tcf_proto *tp, u32 flags,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ctinfo_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	u32 dscpmask = 0, dscpstatemask, index;
 	struct nlattr *tb[TCA_CTINFO_MAX + 1];
@@ -347,14 +346,14 @@ static int tcf_ctinfo_walker(struct net *net, struct sk_buff *skb,
 			     const struct tc_action_ops *ops,
 			     struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ctinfo_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_ctinfo_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ctinfo_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -384,20 +383,20 @@ static struct tc_action_ops act_ctinfo_ops = {
 
 static __net_init int ctinfo_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ctinfo_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_ctinfo_ops);
 }
 
 static void __net_exit ctinfo_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, ctinfo_net_id);
+	tc_action_net_exit(net_list, act_ctinfo_ops.net_id);
 }
 
 static struct pernet_operations ctinfo_net_ops = {
 	.init		= ctinfo_init_net,
 	.exit_batch	= ctinfo_exit_net,
-	.id		= &ctinfo_net_id,
+	.id		= &act_ctinfo_ops.net_id,
 	.size		= sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index ac29d1065232..ede896a7ee6b 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -19,7 +19,6 @@
 #include <linux/tc_act/tc_gact.h>
 #include <net/tc_act/tc_gact.h>
 
-static unsigned int gact_net_id;
 static struct tc_action_ops act_gact_ops;
 
 #ifdef CONFIG_GACT_PROB
@@ -55,7 +54,7 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 			 struct tcf_proto *tp, u32 flags,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, gact_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gact_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_GACT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -227,14 +226,14 @@ static int tcf_gact_walker(struct net *net, struct sk_buff *skb,
 			   const struct tc_action_ops *ops,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, gact_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gact_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_gact_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, gact_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gact_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -317,20 +316,20 @@ static struct tc_action_ops act_gact_ops = {
 
 static __net_init int gact_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, gact_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gact_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_gact_ops);
 }
 
 static void __net_exit gact_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, gact_net_id);
+	tc_action_net_exit(net_list, act_gact_ops.net_id);
 }
 
 static struct pernet_operations gact_net_ops = {
 	.init = gact_init_net,
 	.exit_batch = gact_exit_net,
-	.id   = &gact_net_id,
+	.id   = &act_gact_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index fd5155274733..1b528550eb22 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -15,7 +15,6 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gate.h>
 
-static unsigned int gate_net_id;
 static struct tc_action_ops act_gate_ops;
 
 static ktime_t gate_get_time(struct tcf_gate *gact)
@@ -298,7 +297,7 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 			 struct tcf_proto *tp, u32 flags,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, gate_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gate_ops.net_id);
 	enum tk_offsets tk_offset = TK_OFFS_TAI;
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_GATE_MAX + 1];
@@ -570,7 +569,7 @@ static int tcf_gate_walker(struct net *net, struct sk_buff *skb,
 			   const struct tc_action_ops *ops,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, gate_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gate_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
@@ -587,7 +586,7 @@ static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 
 static int tcf_gate_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, gate_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gate_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -664,20 +663,20 @@ static struct tc_action_ops act_gate_ops = {
 
 static __net_init int gate_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, gate_net_id);
+	struct tc_action_net *tn = net_generic(net, act_gate_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_gate_ops);
 }
 
 static void __net_exit gate_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, gate_net_id);
+	tc_action_net_exit(net_list, act_gate_ops.net_id);
 }
 
 static struct pernet_operations gate_net_ops = {
 	.init = gate_init_net,
 	.exit_batch = gate_exit_net,
-	.id   = &gate_net_id,
+	.id   = &act_gate_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41ba55e60b1b..ef8355012ac0 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -30,7 +30,6 @@
 #include <linux/etherdevice.h>
 #include <net/ife.h>
 
-static unsigned int ife_net_id;
 static int max_metacnt = IFE_META_MAX + 1;
 static struct tc_action_ops act_ife_ops;
 
@@ -482,7 +481,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 			struct tcf_proto *tp, u32 flags,
 			struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ife_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ife_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_IFE_MAX + 1];
 	struct nlattr *tb2[IFE_META_MAX + 1];
@@ -883,14 +882,14 @@ static int tcf_ife_walker(struct net *net, struct sk_buff *skb,
 			  const struct tc_action_ops *ops,
 			  struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ife_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ife_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_ife_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, ife_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ife_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -910,20 +909,20 @@ static struct tc_action_ops act_ife_ops = {
 
 static __net_init int ife_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, ife_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ife_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_ife_ops);
 }
 
 static void __net_exit ife_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, ife_net_id);
+	tc_action_net_exit(net_list, act_ife_ops.net_id);
 }
 
 static struct pernet_operations ife_net_ops = {
 	.init = ife_init_net,
 	.exit_batch = ife_exit_net,
-	.id   = &ife_net_id,
+	.id   = &act_ife_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 2f3d507c24a1..45bd55096ea8 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -24,10 +24,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 
-static unsigned int ipt_net_id;
 static struct tc_action_ops act_ipt_ops;
-
-static unsigned int xt_net_id;
 static struct tc_action_ops act_xt_ops;
 
 static int ipt_init_target(struct net *net, struct xt_entry_target *t,
@@ -206,8 +203,8 @@ static int tcf_ipt_init(struct net *net, struct nlattr *nla,
 			struct tcf_proto *tp,
 			u32 flags, struct netlink_ext_ack *extack)
 {
-	return __tcf_ipt_init(net, ipt_net_id, nla, est, a, &act_ipt_ops,
-			      tp, flags);
+	return __tcf_ipt_init(net, act_ipt_ops.net_id, nla, est,
+			      a, &act_ipt_ops, tp, flags);
 }
 
 static int tcf_xt_init(struct net *net, struct nlattr *nla,
@@ -215,8 +212,8 @@ static int tcf_xt_init(struct net *net, struct nlattr *nla,
 		       struct tcf_proto *tp,
 		       u32 flags, struct netlink_ext_ack *extack)
 {
-	return __tcf_ipt_init(net, xt_net_id, nla, est, a, &act_xt_ops,
-			      tp, flags);
+	return __tcf_ipt_init(net, act_xt_ops.net_id, nla, est,
+			      a, &act_xt_ops, tp, flags);
 }
 
 static int tcf_ipt_act(struct sk_buff *skb, const struct tc_action *a,
@@ -321,14 +318,14 @@ static int tcf_ipt_walker(struct net *net, struct sk_buff *skb,
 			  const struct tc_action_ops *ops,
 			  struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, ipt_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ipt_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_ipt_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, ipt_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ipt_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -348,20 +345,20 @@ static struct tc_action_ops act_ipt_ops = {
 
 static __net_init int ipt_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, ipt_net_id);
+	struct tc_action_net *tn = net_generic(net, act_ipt_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_ipt_ops);
 }
 
 static void __net_exit ipt_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, ipt_net_id);
+	tc_action_net_exit(net_list, act_ipt_ops.net_id);
 }
 
 static struct pernet_operations ipt_net_ops = {
 	.init = ipt_init_net,
 	.exit_batch = ipt_exit_net,
-	.id   = &ipt_net_id,
+	.id   = &act_ipt_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
@@ -370,14 +367,14 @@ static int tcf_xt_walker(struct net *net, struct sk_buff *skb,
 			 const struct tc_action_ops *ops,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, xt_net_id);
+	struct tc_action_net *tn = net_generic(net, act_xt_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_xt_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, xt_net_id);
+	struct tc_action_net *tn = net_generic(net, act_xt_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -397,20 +394,20 @@ static struct tc_action_ops act_xt_ops = {
 
 static __net_init int xt_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, xt_net_id);
+	struct tc_action_net *tn = net_generic(net, act_xt_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_xt_ops);
 }
 
 static void __net_exit xt_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, xt_net_id);
+	tc_action_net_exit(net_list, act_xt_ops.net_id);
 }
 
 static struct pernet_operations xt_net_ops = {
 	.init = xt_init_net,
 	.exit_batch = xt_exit_net,
-	.id   = &xt_net_id,
+	.id   = &act_xt_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index a1d70cf86843..56877dd19375 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -86,7 +86,6 @@ static const struct nla_policy mirred_policy[TCA_MIRRED_MAX + 1] = {
 	[TCA_MIRRED_PARMS]	= { .len = sizeof(struct tc_mirred) },
 };
 
-static unsigned int mirred_net_id;
 static struct tc_action_ops act_mirred_ops;
 
 static int tcf_mirred_init(struct net *net, struct nlattr *nla,
@@ -94,7 +93,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			   struct tcf_proto *tp,
 			   u32 flags, struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, mirred_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mirred_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_MIRRED_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -378,14 +377,14 @@ static int tcf_mirred_walker(struct net *net, struct sk_buff *skb,
 			     const struct tc_action_ops *ops,
 			     struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, mirred_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mirred_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_mirred_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, mirred_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mirred_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -520,20 +519,20 @@ static struct tc_action_ops act_mirred_ops = {
 
 static __net_init int mirred_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, mirred_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mirred_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_mirred_ops);
 }
 
 static void __net_exit mirred_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, mirred_net_id);
+	tc_action_net_exit(net_list, act_mirred_ops.net_id);
 }
 
 static struct pernet_operations mirred_net_ops = {
 	.init = mirred_init_net,
 	.exit_batch = mirred_exit_net,
-	.id   = &mirred_net_id,
+	.id   = &act_mirred_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index adabeccb63e1..b754d2eae477 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -15,7 +15,6 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mpls.h>
 
-static unsigned int mpls_net_id;
 static struct tc_action_ops act_mpls_ops;
 
 #define ACT_MPLS_TTL_DEFAULT	255
@@ -155,7 +154,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 			 struct tcf_proto *tp, u32 flags,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mpls_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_MPLS_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -372,14 +371,14 @@ static int tcf_mpls_walker(struct net *net, struct sk_buff *skb,
 			   const struct tc_action_ops *ops,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mpls_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mpls_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -459,20 +458,20 @@ static struct tc_action_ops act_mpls_ops = {
 
 static __net_init int mpls_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, mpls_net_id);
+	struct tc_action_net *tn = net_generic(net, act_mpls_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_mpls_ops);
 }
 
 static void __net_exit mpls_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, mpls_net_id);
+	tc_action_net_exit(net_list, act_mpls_ops.net_id);
 }
 
 static struct pernet_operations mpls_net_ops = {
 	.init = mpls_init_net,
 	.exit_batch = mpls_exit_net,
-	.id   = &mpls_net_id,
+	.id   = &act_mpls_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 2a39b3729e84..f5810387ce9a 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -26,7 +26,6 @@
 #include <net/udp.h>
 
 
-static unsigned int nat_net_id;
 static struct tc_action_ops act_nat_ops;
 
 static const struct nla_policy nat_policy[TCA_NAT_MAX + 1] = {
@@ -37,7 +36,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 			struct tc_action **a, struct tcf_proto *tp,
 			u32 flags, struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, nat_net_id);
+	struct tc_action_net *tn = net_generic(net, act_nat_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_NAT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -294,14 +293,14 @@ static int tcf_nat_walker(struct net *net, struct sk_buff *skb,
 			  const struct tc_action_ops *ops,
 			  struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, nat_net_id);
+	struct tc_action_net *tn = net_generic(net, act_nat_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_nat_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, nat_net_id);
+	struct tc_action_net *tn = net_generic(net, act_nat_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -320,20 +319,20 @@ static struct tc_action_ops act_nat_ops = {
 
 static __net_init int nat_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, nat_net_id);
+	struct tc_action_net *tn = net_generic(net, act_nat_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_nat_ops);
 }
 
 static void __net_exit nat_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, nat_net_id);
+	tc_action_net_exit(net_list, act_nat_ops.net_id);
 }
 
 static struct pernet_operations nat_net_ops = {
 	.init = nat_init_net,
 	.exit_batch = nat_exit_net,
-	.id   = &nat_net_id,
+	.id   = &act_nat_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 823ee643371c..0951cd1e277e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -21,7 +21,6 @@
 #include <uapi/linux/tc_act/tc_pedit.h>
 #include <net/pkt_cls.h>
 
-static unsigned int pedit_net_id;
 static struct tc_action_ops act_pedit_ops;
 
 static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
@@ -139,7 +138,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			  struct tcf_proto *tp, u32 flags,
 			  struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, pedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_PEDIT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -497,14 +496,14 @@ static int tcf_pedit_walker(struct net *net, struct sk_buff *skb,
 			    const struct tc_action_ops *ops,
 			    struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, pedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, pedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -561,20 +560,20 @@ static struct tc_action_ops act_pedit_ops = {
 
 static __net_init int pedit_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, pedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_pedit_ops);
 }
 
 static void __net_exit pedit_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, pedit_net_id);
+	tc_action_net_exit(net_list, act_pedit_ops.net_id);
 }
 
 static struct pernet_operations pedit_net_ops = {
 	.init = pedit_init_net,
 	.exit_batch = pedit_exit_net,
-	.id   = &pedit_net_id,
+	.id   = &act_pedit_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index b759628a47c2..b5df33c6de52 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -22,7 +22,6 @@
 
 /* Each policer is serialized by its individual spinlock */
 
-static unsigned int police_net_id;
 static struct tc_action_ops act_police_ops;
 
 static int tcf_police_walker(struct net *net, struct sk_buff *skb,
@@ -30,7 +29,7 @@ static int tcf_police_walker(struct net *net, struct sk_buff *skb,
 				 const struct tc_action_ops *ops,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, police_net_id);
+	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
@@ -58,7 +57,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	struct tc_police *parm;
 	struct tcf_police *police;
 	struct qdisc_rate_table *R_tab = NULL, *P_tab = NULL;
-	struct tc_action_net *tn = net_generic(net, police_net_id);
+	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
 	struct tcf_police_params *new;
 	bool exists = false;
 	u32 index;
@@ -414,7 +413,7 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 
 static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, police_net_id);
+	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -522,20 +521,20 @@ static struct tc_action_ops act_police_ops = {
 
 static __net_init int police_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, police_net_id);
+	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_police_ops);
 }
 
 static void __net_exit police_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, police_net_id);
+	tc_action_net_exit(net_list, act_police_ops.net_id);
 }
 
 static struct pernet_operations police_net_ops = {
 	.init = police_init_net,
 	.exit_batch = police_exit_net,
-	.id   = &police_net_id,
+	.id   = &act_police_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 2f7f5e44d28c..c25a193f9ef4 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -23,7 +23,6 @@
 
 #include <linux/if_arp.h>
 
-static unsigned int sample_net_id;
 static struct tc_action_ops act_sample_ops;
 
 static const struct nla_policy sample_policy[TCA_SAMPLE_MAX + 1] = {
@@ -38,7 +37,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 			   struct tcf_proto *tp,
 			   u32 flags, struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, sample_net_id);
+	struct tc_action_net *tn = net_generic(net, act_sample_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_SAMPLE_MAX + 1];
 	struct psample_group *psample_group;
@@ -246,14 +245,14 @@ static int tcf_sample_walker(struct net *net, struct sk_buff *skb,
 			     const struct tc_action_ops *ops,
 			     struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, sample_net_id);
+	struct tc_action_net *tn = net_generic(net, act_sample_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_sample_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, sample_net_id);
+	struct tc_action_net *tn = net_generic(net, act_sample_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -330,20 +329,20 @@ static struct tc_action_ops act_sample_ops = {
 
 static __net_init int sample_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, sample_net_id);
+	struct tc_action_net *tn = net_generic(net, act_sample_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_sample_ops);
 }
 
 static void __net_exit sample_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, sample_net_id);
+	tc_action_net_exit(net_list, act_sample_ops.net_id);
 }
 
 static struct pernet_operations sample_net_ops = {
 	.init = sample_init_net,
 	.exit_batch = sample_exit_net,
-	.id   = &sample_net_id,
+	.id   = &act_sample_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 8c1d60bde93e..06efa08afff7 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -18,7 +18,6 @@
 #include <linux/tc_act/tc_defact.h>
 #include <net/tc_act/tc_defact.h>
 
-static unsigned int simp_net_id;
 static struct tc_action_ops act_simp_ops;
 
 #define SIMP_MAX_DATA	32
@@ -89,7 +88,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 			 struct tcf_proto *tp, u32 flags,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, simp_net_id);
+	struct tc_action_net *tn = net_generic(net, act_simp_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_DEF_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -203,14 +202,14 @@ static int tcf_simp_walker(struct net *net, struct sk_buff *skb,
 			   const struct tc_action_ops *ops,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, simp_net_id);
+	struct tc_action_net *tn = net_generic(net, act_simp_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_simp_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, simp_net_id);
+	struct tc_action_net *tn = net_generic(net, act_simp_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -230,20 +229,20 @@ static struct tc_action_ops act_simp_ops = {
 
 static __net_init int simp_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, simp_net_id);
+	struct tc_action_net *tn = net_generic(net, act_simp_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_simp_ops);
 }
 
 static void __net_exit simp_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, simp_net_id);
+	tc_action_net_exit(net_list, act_simp_ops.net_id);
 }
 
 static struct pernet_operations simp_net_ops = {
 	.init = simp_init_net,
 	.exit_batch = simp_exit_net,
-	.id   = &simp_net_id,
+	.id   = &act_simp_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index e3bd11dfe1ca..72729ed7219a 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -20,7 +20,6 @@
 #include <linux/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_skbedit.h>
 
-static unsigned int skbedit_net_id;
 static struct tc_action_ops act_skbedit_ops;
 
 static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
@@ -118,7 +117,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 			    struct tcf_proto *tp, u32 act_flags,
 			    struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbedit_ops.net_id);
 	bool bind = act_flags & TCA_ACT_FLAGS_BIND;
 	struct tcf_skbedit_params *params_new;
 	struct nlattr *tb[TCA_SKBEDIT_MAX + 1];
@@ -352,14 +351,14 @@ static int tcf_skbedit_walker(struct net *net, struct sk_buff *skb,
 			      const struct tc_action_ops *ops,
 			      struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbedit_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_skbedit_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbedit_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -437,20 +436,20 @@ static struct tc_action_ops act_skbedit_ops = {
 
 static __net_init int skbedit_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbedit_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_skbedit_ops);
 }
 
 static void __net_exit skbedit_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, skbedit_net_id);
+	tc_action_net_exit(net_list, act_skbedit_ops.net_id);
 }
 
 static struct pernet_operations skbedit_net_ops = {
 	.init = skbedit_init_net,
 	.exit_batch = skbedit_exit_net,
-	.id   = &skbedit_net_id,
+	.id   = &act_skbedit_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 2083612d8780..999adceb686a 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -19,7 +19,6 @@
 #include <linux/tc_act/tc_skbmod.h>
 #include <net/tc_act/tc_skbmod.h>
 
-static unsigned int skbmod_net_id;
 static struct tc_action_ops act_skbmod_ops;
 
 static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
@@ -103,7 +102,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 			   struct tcf_proto *tp, u32 flags,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbmod_ops.net_id);
 	bool ovr = flags & TCA_ACT_FLAGS_REPLACE;
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_SKBMOD_MAX + 1];
@@ -281,14 +280,14 @@ static int tcf_skbmod_walker(struct net *net, struct sk_buff *skb,
 			     const struct tc_action_ops *ops,
 			     struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbmod_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tcf_skbmod_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbmod_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -308,20 +307,20 @@ static struct tc_action_ops act_skbmod_ops = {
 
 static __net_init int skbmod_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
+	struct tc_action_net *tn = net_generic(net, act_skbmod_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_skbmod_ops);
 }
 
 static void __net_exit skbmod_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, skbmod_net_id);
+	tc_action_net_exit(net_list, act_skbmod_ops.net_id);
 }
 
 static struct pernet_operations skbmod_net_ops = {
 	.init = skbmod_init_net,
 	.exit_batch = skbmod_exit_net,
-	.id   = &skbmod_net_id,
+	.id   = &act_skbmod_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 856dc23cef8c..2db0c929fa09 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -20,7 +20,6 @@
 #include <linux/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_tunnel_key.h>
 
-static unsigned int tunnel_key_net_id;
 static struct tc_action_ops act_tunnel_key_ops;
 
 static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
@@ -358,7 +357,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 			   struct tcf_proto *tp, u32 act_flags,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
+	struct tc_action_net *tn = net_generic(net, act_tunnel_key_ops.net_id);
 	bool bind = act_flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_TUNNEL_KEY_MAX + 1];
 	struct tcf_tunnel_key_params *params_new;
@@ -775,14 +774,14 @@ static int tunnel_key_walker(struct net *net, struct sk_buff *skb,
 			     const struct tc_action_ops *ops,
 			     struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
+	struct tc_action_net *tn = net_generic(net, act_tunnel_key_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
 static int tunnel_key_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
+	struct tc_action_net *tn = net_generic(net, act_tunnel_key_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -858,20 +857,20 @@ static struct tc_action_ops act_tunnel_key_ops = {
 
 static __net_init int tunnel_key_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
+	struct tc_action_net *tn = net_generic(net, act_tunnel_key_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_tunnel_key_ops);
 }
 
 static void __net_exit tunnel_key_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, tunnel_key_net_id);
+	tc_action_net_exit(net_list, act_tunnel_key_ops.net_id);
 }
 
 static struct pernet_operations tunnel_key_net_ops = {
 	.init = tunnel_key_init_net,
 	.exit_batch = tunnel_key_exit_net,
-	.id   = &tunnel_key_net_id,
+	.id   = &act_tunnel_key_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 68b5e772386a..a1a0c2c6a5cc 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -16,7 +16,6 @@
 #include <linux/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_vlan.h>
 
-static unsigned int vlan_net_id;
 static struct tc_action_ops act_vlan_ops;
 
 static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
@@ -117,7 +116,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			 struct tcf_proto *tp, u32 flags,
 			 struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, vlan_net_id);
+	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_VLAN_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
@@ -338,7 +337,7 @@ static int tcf_vlan_walker(struct net *net, struct sk_buff *skb,
 			   const struct tc_action_ops *ops,
 			   struct netlink_ext_ack *extack)
 {
-	struct tc_action_net *tn = net_generic(net, vlan_net_id);
+	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
 
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
@@ -355,7 +354,7 @@ static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 
 static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
 {
-	struct tc_action_net *tn = net_generic(net, vlan_net_id);
+	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
 
 	return tcf_idr_search(tn, a, index);
 }
@@ -448,20 +447,20 @@ static struct tc_action_ops act_vlan_ops = {
 
 static __net_init int vlan_init_net(struct net *net)
 {
-	struct tc_action_net *tn = net_generic(net, vlan_net_id);
+	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
 
 	return tc_action_net_init(net, tn, &act_vlan_ops);
 }
 
 static void __net_exit vlan_exit_net(struct list_head *net_list)
 {
-	tc_action_net_exit(net_list, vlan_net_id);
+	tc_action_net_exit(net_list, act_vlan_ops.net_id);
 }
 
 static struct pernet_operations vlan_net_ops = {
 	.init = vlan_init_net,
 	.exit_batch = vlan_exit_net,
-	.id   = &vlan_net_id,
+	.id   = &act_vlan_ops.net_id,
 	.size = sizeof(struct tc_action_net),
 };
 
-- 
2.17.1

