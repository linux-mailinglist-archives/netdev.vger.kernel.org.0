Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB495AAD86
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiIBLW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbiIBLWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:22:44 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED6FCE336;
        Fri,  2 Sep 2022 04:22:42 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MJwSC2yHBznV0F;
        Fri,  2 Sep 2022 19:20:11 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:39 +0800
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
Subject: [PATCH net-next 10/22] net: sched: act_ipt: get rid of tcf_ipt_walker/tcf_xt_walker and tcf_ipt_search/tcf_xt_search
Date:   Fri, 2 Sep 2022 19:24:34 +0800
Message-ID: <20220902112446.29858-11-shaozhengchao@huawei.com>
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

Use __tcf_generic_walker() and __tcf_idr_search() helpers by saving
ipt_net_id/xt_net_id when registering act_ipt_ops/act_xt_ops. And
then remove the walk and lookup hook functions in act_ipt.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_ipt.c | 40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 2f3d507c24a1..abacfb134caf 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -316,33 +316,15 @@ static int tcf_ipt_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	return -1;
 }
 
-static int tcf_ipt_walker(struct net *net, struct sk_buff *skb,
-			  struct netlink_callback *cb, int type,
-			  const struct tc_action_ops *ops,
-			  struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, ipt_net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
-static int tcf_ipt_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, ipt_net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static struct tc_action_ops act_ipt_ops = {
 	.kind		=	"ipt",
 	.id		=	TCA_ID_IPT,
+	.net_id		=	&ipt_net_id,
 	.owner		=	THIS_MODULE,
 	.act		=	tcf_ipt_act,
 	.dump		=	tcf_ipt_dump,
 	.cleanup	=	tcf_ipt_release,
 	.init		=	tcf_ipt_init,
-	.walk		=	tcf_ipt_walker,
-	.lookup		=	tcf_ipt_search,
 	.size		=	sizeof(struct tcf_ipt),
 };
 
@@ -365,33 +347,15 @@ static struct pernet_operations ipt_net_ops = {
 	.size = sizeof(struct tc_action_net),
 };
 
-static int tcf_xt_walker(struct net *net, struct sk_buff *skb,
-			 struct netlink_callback *cb, int type,
-			 const struct tc_action_ops *ops,
-			 struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, xt_net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
-static int tcf_xt_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, xt_net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static struct tc_action_ops act_xt_ops = {
 	.kind		=	"xt",
 	.id		=	TCA_ID_XT,
+	.net_id		=	&xt_net_id,
 	.owner		=	THIS_MODULE,
 	.act		=	tcf_ipt_act,
 	.dump		=	tcf_ipt_dump,
 	.cleanup	=	tcf_ipt_release,
 	.init		=	tcf_xt_init,
-	.walk		=	tcf_xt_walker,
-	.lookup		=	tcf_xt_search,
 	.size		=	sizeof(struct tcf_ipt),
 };
 
-- 
2.17.1

