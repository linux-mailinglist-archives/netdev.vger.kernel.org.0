Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517B25AAD7B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiIBLXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiIBLXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:23:13 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15067D2EA0;
        Fri,  2 Sep 2022 04:22:53 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MJwR13v23z1N7k3;
        Fri,  2 Sep 2022 19:19:09 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:50 +0800
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
Subject: [PATCH net-next 22/22] net: sched: act: remove redundant code in act_api
Date:   Fri, 2 Sep 2022 19:24:46 +0800
Message-ID: <20220902112446.29858-23-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220902112446.29858-1-shaozhengchao@huawei.com>
References: <20220902112446.29858-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Based on previous patches of this patchset, the walk and lookup hooks in
the tc_action_ops structure are no longer used, and redundant code logic
branches should be removed. tcf_generic_walker() and tcf_idr_search() are
also used only in the act_api.c, change them to static.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/act_api.h | 10 ----------
 net/sched/act_api.c   | 42 ++++++++++++------------------------------
 2 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index a79d6e58519e..ebd84ef06b5b 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -118,15 +118,10 @@ struct tc_action_ops {
 		       struct tcf_result *); /* called under RCU BH lock*/
 	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
 	void	(*cleanup)(struct tc_action *);
-	int     (*lookup)(struct net *net, struct tc_action **a, u32 index);
 	int     (*init)(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act,
 			struct tcf_proto *tp,
 			u32 flags, struct netlink_ext_ack *extack);
-	int     (*walk)(struct net *, struct sk_buff *,
-			struct netlink_callback *, int,
-			const struct tc_action_ops *,
-			struct netlink_ext_ack *);
 	void	(*stats_update)(struct tc_action *, u64, u64, u64, u64, bool);
 	size_t  (*get_fill_size)(const struct tc_action *act);
 	struct net_device *(*get_dev)(const struct tc_action *a,
@@ -178,11 +173,6 @@ static inline void tc_action_net_exit(struct list_head *net_list,
 	rtnl_unlock();
 }
 
-int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
-		       struct netlink_callback *cb, int type,
-		       const struct tc_action_ops *ops,
-		       struct netlink_ext_ack *extack);
-int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index);
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
 		   int bind, bool cpustats, u32 flags);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 7063d2004199..2d26aec25e3a 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -636,10 +636,10 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	return ret;
 }
 
-int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
-		       struct netlink_callback *cb, int type,
-		       const struct tc_action_ops *ops,
-		       struct netlink_ext_ack *extack)
+static int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
+			      struct netlink_callback *cb, int type,
+			      const struct tc_action_ops *ops,
+			      struct netlink_ext_ack *extack)
 {
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
@@ -653,9 +653,8 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 		return -EINVAL;
 	}
 }
-EXPORT_SYMBOL(tcf_generic_walker);
 
-int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
+static int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
 {
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 	struct tc_action *p;
@@ -674,7 +673,6 @@ int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
 	}
 	return false;
 }
-EXPORT_SYMBOL(tcf_idr_search);
 
 static int __tcf_generic_walker(struct net *net, struct sk_buff *skb,
 				struct netlink_callback *cb, int type,
@@ -945,8 +943,7 @@ int tcf_register_action(struct tc_action_ops *act,
 	struct tc_action_ops *a;
 	int ret;
 
-	if (!act->act || !act->dump || !act->init ||
-	    (!act->net_id && (!act->walk || !act->lookup)))
+	if (!act->act || !act->dump || !act->init || !act->net_id)
 		return -EINVAL;
 
 	/* We have to register pernet ops before making the action ops visible,
@@ -1658,16 +1655,10 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 		goto err_out;
 	}
 	err = -ENOENT;
-	if (ops->lookup) {
-		if (ops->lookup(net, &a, index) == 0) {
-			NL_SET_ERR_MSG(extack, "TC action with specified index not found");
-			goto err_mod;
-		}
-	} else {
-		if (__tcf_idr_search(net, ops, &a, index) == 0) {
-			NL_SET_ERR_MSG(extack, "TC action with specified index not found");
-			goto err_mod;
-		}
+
+	if (__tcf_idr_search(net, ops, &a, index) == 0) {
+		NL_SET_ERR_MSG(extack, "TC action with specified index not found");
+		goto err_mod;
 	}
 
 	module_put(ops->owner);
@@ -1730,12 +1721,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 		goto out_module_put;
 	}
 
-	if (ops->walk) {
-		err = ops->walk(net, skb, &dcb, RTM_DELACTION, ops, extack);
-	} else {
-		err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
-	}
-
+	err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
 	if (err <= 0) {
 		nla_nest_cancel(skb, nest);
 		goto out_module_put;
@@ -2153,11 +2139,7 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto out_module_put;
 
-	if (a_o->walk)
-		ret = a_o->walk(net, skb, cb, RTM_GETACTION, a_o, NULL);
-	else
-		ret = __tcf_generic_walker(net, skb, cb, RTM_GETACTION, a_o, NULL);
-
+	ret = __tcf_generic_walker(net, skb, cb, RTM_GETACTION, a_o, NULL);
 	if (ret < 0)
 		goto out_module_put;
 
-- 
2.17.1

