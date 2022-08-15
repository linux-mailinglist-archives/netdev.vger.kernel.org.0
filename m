Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A3C5929F2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiHOG6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241193AbiHOG6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:58:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5CB1BEBF;
        Sun, 14 Aug 2022 23:58:17 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M5lQp45P8zlW9N;
        Mon, 15 Aug 2022 14:55:14 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 14:58:14 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: make tcf_action_dump_1() static
Date:   Mon, 15 Aug 2022 15:01:22 +0800
Message-ID: <20220815070122.113871-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
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

Function tcf_action_dump_1() is not used outside of act_api.c, so remove
the superfluous EXPORT_SYMBOL() and marks it static.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/act_api.h |   1 -
 net/sched/act_api.c   | 100 +++++++++++++++++++++---------------------
 2 files changed, 49 insertions(+), 52 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9cf6870b526e..d51b3f931771 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -215,7 +215,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
-int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
 
 static inline void tcf_action_update_bstats(struct tc_action *a,
 					    struct sk_buff *skb)
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b69fcde546ba..9fd98bf5c724 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -510,6 +510,55 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
 	return -1;
 }
 
+int
+tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
+{
+	return a->ops->dump(skb, a, bind, ref);
+}
+
+static int
+tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
+{
+	int err = -EINVAL;
+	unsigned char *b = skb_tail_pointer(skb);
+	struct nlattr *nest;
+	u32 flags;
+
+	if (tcf_action_dump_terse(skb, a, false))
+		goto nla_put_failure;
+
+	if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
+	    nla_put_bitfield32(skb, TCA_ACT_HW_STATS,
+			       a->hw_stats, TCA_ACT_HW_STATS_ANY))
+		goto nla_put_failure;
+
+	if (a->used_hw_stats_valid &&
+	    nla_put_bitfield32(skb, TCA_ACT_USED_HW_STATS,
+			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
+		goto nla_put_failure;
+
+	flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
+	if (flags &&
+	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
+			       flags, flags))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+	err = tcf_action_dump_old(skb, a, bind, ref);
+	if (err > 0) {
+		nla_nest_end(skb, nest);
+		return err;
+	}
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
 static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			   struct netlink_callback *cb)
 {
@@ -1132,57 +1181,6 @@ static void tcf_action_put_many(struct tc_action *actions[])
 	}
 }
 
-int
-tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
-{
-	return a->ops->dump(skb, a, bind, ref);
-}
-
-int
-tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
-{
-	int err = -EINVAL;
-	unsigned char *b = skb_tail_pointer(skb);
-	struct nlattr *nest;
-	u32 flags;
-
-	if (tcf_action_dump_terse(skb, a, false))
-		goto nla_put_failure;
-
-	if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
-	    nla_put_bitfield32(skb, TCA_ACT_HW_STATS,
-			       a->hw_stats, TCA_ACT_HW_STATS_ANY))
-		goto nla_put_failure;
-
-	if (a->used_hw_stats_valid &&
-	    nla_put_bitfield32(skb, TCA_ACT_USED_HW_STATS,
-			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
-		goto nla_put_failure;
-
-	flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
-	if (flags &&
-	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
-			       flags, flags))
-		goto nla_put_failure;
-
-	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
-		goto nla_put_failure;
-
-	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
-	if (nest == NULL)
-		goto nla_put_failure;
-	err = tcf_action_dump_old(skb, a, bind, ref);
-	if (err > 0) {
-		nla_nest_end(skb, nest);
-		return err;
-	}
-
-nla_put_failure:
-	nlmsg_trim(skb, b);
-	return -1;
-}
-EXPORT_SYMBOL(tcf_action_dump_1);
-
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
 		    int bind, int ref, bool terse)
 {
-- 
2.17.1

