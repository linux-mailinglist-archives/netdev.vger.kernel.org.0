Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65D55B1333
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 06:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiIHENP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 00:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiIHENK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 00:13:10 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75967F08E;
        Wed,  7 Sep 2022 21:13:09 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MNQfS040HzHnZv;
        Thu,  8 Sep 2022 12:11:12 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 8 Sep
 2022 12:13:06 +0800
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
Subject: [PATCH net-next,v3 02/22] net: sched: act_api: implement generic walker and search for tc action
Date:   Thu, 8 Sep 2022 12:14:34 +0800
Message-ID: <20220908041454.365070-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908041454.365070-1-shaozhengchao@huawei.com>
References: <20220908041454.365070-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_api.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 817065aa2833..9b31a10cc639 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -676,6 +676,31 @@ int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
 }
 EXPORT_SYMBOL(tcf_idr_search);
 
+static int __tcf_generic_walker(struct net *net, struct sk_buff *skb,
+				struct netlink_callback *cb, int type,
+				const struct tc_action_ops *ops,
+				struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, ops->net_id);
+
+	if (unlikely(ops->walk))
+		return ops->walk(net, skb, cb, type, ops, extack);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int __tcf_idr_search(struct net *net,
+			    const struct tc_action_ops *ops,
+			    struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, ops->net_id);
+
+	if (unlikely(ops->lookup))
+		return ops->lookup(net, a, index);
+
+	return tcf_idr_search(tn, a, index);
+}
+
 static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 {
 	struct tc_action *p;
@@ -926,7 +951,7 @@ int tcf_register_action(struct tc_action_ops *act,
 	struct tc_action_ops *a;
 	int ret;
 
-	if (!act->act || !act->dump || !act->init || !act->walk || !act->lookup)
+	if (!act->act || !act->dump || !act->init)
 		return -EINVAL;
 
 	/* We have to register pernet ops before making the action ops visible,
@@ -1638,7 +1663,7 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 		goto err_out;
 	}
 	err = -ENOENT;
-	if (ops->lookup(net, &a, index) == 0) {
+	if (__tcf_idr_search(net, ops, &a, index) == 0) {
 		NL_SET_ERR_MSG(extack, "TC action with specified index not found");
 		goto err_mod;
 	}
@@ -1703,7 +1728,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 		goto out_module_put;
 	}
 
-	err = ops->walk(net, skb, &dcb, RTM_DELACTION, ops, extack);
+	err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
 	if (err <= 0) {
 		nla_nest_cancel(skb, nest);
 		goto out_module_put;
@@ -2121,7 +2146,7 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto out_module_put;
 
-	ret = a_o->walk(net, skb, cb, RTM_GETACTION, a_o, NULL);
+	ret = __tcf_generic_walker(net, skb, cb, RTM_GETACTION, a_o, NULL);
 	if (ret < 0)
 		goto out_module_put;
 
-- 
2.17.1

