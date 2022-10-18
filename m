Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD686022D4
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiJRDmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiJRDmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:42:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6F1D70
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 20:39:24 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ms0382j1NzHttK;
        Tue, 18 Oct 2022 11:39:16 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 11:39:21 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <cake@lists.bufferbloat.net>, <netdev@vger.kernel.org>,
        <toke@toke.dk>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <dave.taht@gmail.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net 1/3] net: sched: cake: fix null pointer access issue when cake_init() fails
Date:   Tue, 18 Oct 2022 11:47:16 +0800
Message-ID: <20221018034718.82389-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221018034718.82389-1-shaozhengchao@huawei.com>
References: <20221018034718.82389-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the default qdisc is cake, if the qdisc of dev_queue fails to be
inited during mqprio_init(), cake_reset() is invoked to clear
resources. In this case, the tins is NULL, and it will cause gpf issue.

The process is as follows:
qdisc_create_dflt()
	cake_init()
		q->tins = kvcalloc(...)        --->failed, q->tins is NULL
	...
	qdisc_put()
		...
		cake_reset()
			...
			cake_dequeue_one()
				b = &q->tins[...]   --->q->tins is NULL

The following is the Call Trace information:
general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:cake_dequeue_one+0xc9/0x3c0
Call Trace:
<TASK>
cake_reset+0xb1/0x140
qdisc_reset+0xed/0x6f0
qdisc_destroy+0x82/0x4c0
qdisc_put+0x9e/0xb0
qdisc_create_dflt+0x2c3/0x4a0
mqprio_init+0xa71/0x1760
qdisc_create+0x3eb/0x1000
tc_modify_qdisc+0x408/0x1720
rtnetlink_rcv_msg+0x38e/0xac0
netlink_rcv_skb+0x12d/0x3a0
netlink_unicast+0x4a2/0x740
netlink_sendmsg+0x826/0xcc0
sock_sendmsg+0xc5/0x100
____sys_sendmsg+0x583/0x690
___sys_sendmsg+0xe8/0x160
__sys_sendmsg+0xbf/0x160
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f89e5122d04
</TASK>

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_cake.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 55c6879d2c7e..87f8ce2c65ee 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2224,8 +2224,12 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 
 static void cake_reset(struct Qdisc *sch)
 {
+	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 c;
 
+	if (!q->tins)
+		return;
+
 	for (c = 0; c < CAKE_MAX_TINS; c++)
 		cake_clear_tin(sch, c);
 }
-- 
2.17.1

