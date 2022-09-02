Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58E05AAD8A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiIBLXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiIBLWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:22:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328A6D290F;
        Fri,  2 Sep 2022 04:22:47 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJwR91gmRzlWhT;
        Fri,  2 Sep 2022 19:19:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:44 +0800
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
Subject: [PATCH net-next 15/22] net: sched: act_police: get rid of tcf_police_walker and tcf_police_search
Date:   Fri, 2 Sep 2022 19:24:39 +0800
Message-ID: <20220902112446.29858-16-shaozhengchao@huawei.com>
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
police_net_id when registering act_police_ops. And then remove the
walk and lookup hook functions in act_police.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_police.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index b759628a47c2..a9dd89210bd4 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -25,16 +25,6 @@
 static unsigned int police_net_id;
 static struct tc_action_ops act_police_ops;
 
-static int tcf_police_walker(struct net *net, struct sk_buff *skb,
-				 struct netlink_callback *cb, int type,
-				 const struct tc_action_ops *ops,
-				 struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, police_net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
 static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
 	[TCA_POLICE_RATE]	= { .len = TC_RTAB_SIZE },
 	[TCA_POLICE_PEAKRATE]	= { .len = TC_RTAB_SIZE },
@@ -412,13 +402,6 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
-static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, police_net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static int tcf_police_act_to_flow_act(int tc_act, u32 *extval,
 				      struct netlink_ext_ack *extack)
 {
@@ -508,13 +491,12 @@ MODULE_LICENSE("GPL");
 static struct tc_action_ops act_police_ops = {
 	.kind		=	"police",
 	.id		=	TCA_ID_POLICE,
+	.net_id		=	&police_net_id,
 	.owner		=	THIS_MODULE,
 	.stats_update	=	tcf_police_stats_update,
 	.act		=	tcf_police_act,
 	.dump		=	tcf_police_dump,
 	.init		=	tcf_police_init,
-	.walk		=	tcf_police_walker,
-	.lookup		=	tcf_police_search,
 	.cleanup	=	tcf_police_cleanup,
 	.offload_act_setup =	tcf_police_offload_act_setup,
 	.size		=	sizeof(struct tcf_police),
-- 
2.17.1

