Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3E65AE79D
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbiIFMPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239642AbiIFMNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:13:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E8F79A75;
        Tue,  6 Sep 2022 05:12:01 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MMPL16BdCzmVFm;
        Tue,  6 Sep 2022 20:08:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 6 Sep
 2022 20:11:58 +0800
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
Subject: [PATCH net-next,v2 22/22] net: sched: act_vlan: get rid of tcf_vlan_walker and tcf_vlan_search
Date:   Tue, 6 Sep 2022 20:13:46 +0800
Message-ID: <20220906121346.71578-23-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220906121346.71578-1-shaozhengchao@huawei.com>
References: <20220906121346.71578-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

tcf_vlan_walker() and tcf_vlan_search() do the same thing as generic
walk/search function, so remove them.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_vlan.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index a1a0c2c6a5cc..7b24e898a3e6 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -332,16 +332,6 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
-static int tcf_vlan_walker(struct net *net, struct sk_buff *skb,
-			   struct netlink_callback *cb, int type,
-			   const struct tc_action_ops *ops,
-			   struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
 static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 				  u64 drops, u64 lastuse, bool hw)
 {
@@ -352,13 +342,6 @@ static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
-static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 {
 	return nla_total_size(sizeof(struct tc_vlan))
@@ -437,10 +420,8 @@ static struct tc_action_ops act_vlan_ops = {
 	.dump		=	tcf_vlan_dump,
 	.init		=	tcf_vlan_init,
 	.cleanup	=	tcf_vlan_cleanup,
-	.walk		=	tcf_vlan_walker,
 	.stats_update	=	tcf_vlan_stats_update,
 	.get_fill_size	=	tcf_vlan_get_fill_size,
-	.lookup		=	tcf_vlan_search,
 	.offload_act_setup =	tcf_vlan_offload_act_setup,
 	.size		=	sizeof(struct tcf_vlan),
 };
-- 
2.17.1

