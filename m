Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6D5AAD94
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiIBLWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiIBLWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:22:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC8CC9E8B;
        Fri,  2 Sep 2022 04:22:41 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJwPx4SfpzWf48;
        Fri,  2 Sep 2022 19:18:13 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:22:38 +0800
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
Subject: [PATCH net-next 09/22] net: sched: act_ife: get rid of tcf_ife_walker and tcf_ife_search
Date:   Fri, 2 Sep 2022 19:24:33 +0800
Message-ID: <20220902112446.29858-10-shaozhengchao@huawei.com>
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
ife_net_id when registering act_ife_ops. And then remove the walk
and lookup hook functions in act_ife.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_ife.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41ba55e60b1b..d473618877e0 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -878,33 +878,15 @@ static int tcf_ife_act(struct sk_buff *skb, const struct tc_action *a,
 	return tcf_ife_decode(skb, a, res);
 }
 
-static int tcf_ife_walker(struct net *net, struct sk_buff *skb,
-			  struct netlink_callback *cb, int type,
-			  const struct tc_action_ops *ops,
-			  struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, ife_net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
-static int tcf_ife_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, ife_net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static struct tc_action_ops act_ife_ops = {
 	.kind = "ife",
 	.id = TCA_ID_IFE,
+	.net_id = &ife_net_id,
 	.owner = THIS_MODULE,
 	.act = tcf_ife_act,
 	.dump = tcf_ife_dump,
 	.cleanup = tcf_ife_cleanup,
 	.init = tcf_ife_init,
-	.walk = tcf_ife_walker,
-	.lookup = tcf_ife_search,
 	.size =	sizeof(struct tcf_ife_info),
 };
 
-- 
2.17.1

