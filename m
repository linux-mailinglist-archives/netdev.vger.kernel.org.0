Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3F5AAD60
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbiIBLWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiIBLWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:22:35 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E080AC2E81;
        Fri,  2 Sep 2022 04:22:33 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MJwQd3bSrzkWrn;
        Fri,  2 Sep 2022 19:18:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:30 +0800
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
Subject: [PATCH net-next 01/22] net: sched: act_api: implement generic walker and search for tc action
Date:   Fri, 2 Sep 2022 19:24:25 +0800
Message-ID: <20220902112446.29858-2-shaozhengchao@huawei.com>
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

Being able to get tc_action_net by using net_id stored in tc_action_ops
and execute the generic walk/search function, add __tcf_generic_walker()
and __tcf_idr_search() helpers.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/act_api.h |  1 +
 net/sched/act_api.c   | 48 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9cf6870b526e..a79d6e58519e 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -113,6 +113,7 @@ struct tc_action_ops {
 	enum tca_id  id; /* identifier should match kind */
 	size_t	size;
 	struct module		*owner;
+	unsigned int		*net_id;
 	int     (*act)(struct sk_buff *, const struct tc_action *,
 		       struct tcf_result *); /* called under RCU BH lock*/
 	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 817065aa2833..7063d2004199 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -676,6 +676,25 @@ int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
 }
 EXPORT_SYMBOL(tcf_idr_search);
 
+static int __tcf_generic_walker(struct net *net, struct sk_buff *skb,
+				struct netlink_callback *cb, int type,
+				const struct tc_action_ops *ops,
+				struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, *ops->net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int __tcf_idr_search(struct net *net,
+			    const struct tc_action_ops *ops,
+			    struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, *ops->net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
 static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 {
 	struct tc_action *p;
@@ -926,7 +945,8 @@ int tcf_register_action(struct tc_action_ops *act,
 	struct tc_action_ops *a;
 	int ret;
 
-	if (!act->act || !act->dump || !act->init || !act->walk || !act->lookup)
+	if (!act->act || !act->dump || !act->init ||
+	    (!act->net_id && (!act->walk || !act->lookup)))
 		return -EINVAL;
 
 	/* We have to register pernet ops before making the action ops visible,
@@ -1638,9 +1658,16 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 		goto err_out;
 	}
 	err = -ENOENT;
-	if (ops->lookup(net, &a, index) == 0) {
-		NL_SET_ERR_MSG(extack, "TC action with specified index not found");
-		goto err_mod;
+	if (ops->lookup) {
+		if (ops->lookup(net, &a, index) == 0) {
+			NL_SET_ERR_MSG(extack, "TC action with specified index not found");
+			goto err_mod;
+		}
+	} else {
+		if (__tcf_idr_search(net, ops, &a, index) == 0) {
+			NL_SET_ERR_MSG(extack, "TC action with specified index not found");
+			goto err_mod;
+		}
 	}
 
 	module_put(ops->owner);
@@ -1703,7 +1730,12 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 		goto out_module_put;
 	}
 
-	err = ops->walk(net, skb, &dcb, RTM_DELACTION, ops, extack);
+	if (ops->walk) {
+		err = ops->walk(net, skb, &dcb, RTM_DELACTION, ops, extack);
+	} else {
+		err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
+	}
+
 	if (err <= 0) {
 		nla_nest_cancel(skb, nest);
 		goto out_module_put;
@@ -2121,7 +2153,11 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto out_module_put;
 
-	ret = a_o->walk(net, skb, cb, RTM_GETACTION, a_o, NULL);
+	if (a_o->walk)
+		ret = a_o->walk(net, skb, cb, RTM_GETACTION, a_o, NULL);
+	else
+		ret = __tcf_generic_walker(net, skb, cb, RTM_GETACTION, a_o, NULL);
+
 	if (ret < 0)
 		goto out_module_put;
 
-- 
2.17.1

