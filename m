Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3435AAD5A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiIBLXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiIBLWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:22:50 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BCCD25C1;
        Fri,  2 Sep 2022 04:22:45 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJwQ039HNzWf4H;
        Fri,  2 Sep 2022 19:18:16 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:41 +0800
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
Subject: [PATCH net-next 12/22] net: sched: act_mpls: get rid of tcf_mpls_walker and tcf_mpls_search
Date:   Fri, 2 Sep 2022 19:24:36 +0800
Message-ID: <20220902112446.29858-13-shaozhengchao@huawei.com>
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
mpls_net_id when registering act_mpls_ops. And then remove the walk
and lookup hook functions in act_mpls.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_mpls.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index adabeccb63e1..32c5b9586025 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -367,23 +367,6 @@ static int tcf_mpls_dump(struct sk_buff *skb, struct tc_action *a,
 	return -EMSGSIZE;
 }
 
-static int tcf_mpls_walker(struct net *net, struct sk_buff *skb,
-			   struct netlink_callback *cb, int type,
-			   const struct tc_action_ops *ops,
-			   struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, mpls_net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
-static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, mpls_net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
 				      u32 *index_inc, bool bind,
 				      struct netlink_ext_ack *extack)
@@ -446,13 +429,12 @@ static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
 static struct tc_action_ops act_mpls_ops = {
 	.kind		=	"mpls",
 	.id		=	TCA_ID_MPLS,
+	.net_id		=	&mpls_net_id,
 	.owner		=	THIS_MODULE,
 	.act		=	tcf_mpls_act,
 	.dump		=	tcf_mpls_dump,
 	.init		=	tcf_mpls_init,
 	.cleanup	=	tcf_mpls_cleanup,
-	.walk		=	tcf_mpls_walker,
-	.lookup		=	tcf_mpls_search,
 	.offload_act_setup =	tcf_mpls_offload_act_setup,
 	.size		=	sizeof(struct tcf_mpls),
 };
-- 
2.17.1

