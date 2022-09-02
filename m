Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75455AAD59
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiIBLWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiIBLWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:22:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB90C7B81;
        Fri,  2 Sep 2022 04:22:39 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJwPv5LZfzWf3l;
        Fri,  2 Sep 2022 19:18:11 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:36 +0800
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
Subject: [PATCH net-next 07/22] net: sched: act_gact: get rid of tcf_gact_walker and tcf_gact_search
Date:   Fri, 2 Sep 2022 19:24:31 +0800
Message-ID: <20220902112446.29858-8-shaozhengchao@huawei.com>
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
gact_net_id when registering act_gact_ops. And then remove the walk
and lookup hook functions in act_gact.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_gact.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index ac29d1065232..80c276d2793d 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -222,23 +222,6 @@ static int tcf_gact_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
-static int tcf_gact_walker(struct net *net, struct sk_buff *skb,
-			   struct netlink_callback *cb, int type,
-			   const struct tc_action_ops *ops,
-			   struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, gact_net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
-static int tcf_gact_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, gact_net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 {
 	size_t sz = nla_total_size(sizeof(struct tc_gact)); /* TCA_GACT_PARMS */
@@ -303,13 +286,12 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 static struct tc_action_ops act_gact_ops = {
 	.kind		=	"gact",
 	.id		=	TCA_ID_GACT,
+	.net_id		=	&gact_net_id,
 	.owner		=	THIS_MODULE,
 	.act		=	tcf_gact_act,
 	.stats_update	=	tcf_gact_stats_update,
 	.dump		=	tcf_gact_dump,
 	.init		=	tcf_gact_init,
-	.walk		=	tcf_gact_walker,
-	.lookup		=	tcf_gact_search,
 	.get_fill_size	=	tcf_gact_get_fill_size,
 	.offload_act_setup =	tcf_gact_offload_act_setup,
 	.size		=	sizeof(struct tcf_gact),
-- 
2.17.1

