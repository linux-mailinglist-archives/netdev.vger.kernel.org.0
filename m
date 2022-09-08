Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0215B5B1358
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 06:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiIHEPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 00:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiIHEOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 00:14:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463E3CCE1D;
        Wed,  7 Sep 2022 21:13:23 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNQbl2srpzZcPH;
        Thu,  8 Sep 2022 12:08:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 8 Sep
 2022 12:13:20 +0800
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
Subject: [PATCH net-next,v3 16/22] net: sched: act_police: get rid of tcf_police_walker and tcf_police_search
Date:   Thu, 8 Sep 2022 12:14:48 +0800
Message-ID: <20220908041454.365070-17-shaozhengchao@huawei.com>
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

tcf_police_walker() and tcf_police_search() do the same thing as generic
walk/search function, so remove them.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_police.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index b5df33c6de52..0adb26e366a7 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -24,16 +24,6 @@
 
 static struct tc_action_ops act_police_ops;
 
-static int tcf_police_walker(struct net *net, struct sk_buff *skb,
-				 struct netlink_callback *cb, int type,
-				 const struct tc_action_ops *ops,
-				 struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
 static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
 	[TCA_POLICE_RATE]	= { .len = TC_RTAB_SIZE },
 	[TCA_POLICE_PEAKRATE]	= { .len = TC_RTAB_SIZE },
@@ -411,13 +401,6 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
-static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static int tcf_police_act_to_flow_act(int tc_act, u32 *extval,
 				      struct netlink_ext_ack *extack)
 {
@@ -512,8 +495,6 @@ static struct tc_action_ops act_police_ops = {
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

