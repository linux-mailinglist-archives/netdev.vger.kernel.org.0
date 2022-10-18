Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AF86022D0
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiJRDmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiJRDmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:42:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CB7CEE
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 20:39:24 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mrzxz5SlHzVhyX;
        Tue, 18 Oct 2022 11:34:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 11:39:22 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <cake@lists.bufferbloat.net>, <netdev@vger.kernel.org>,
        <toke@toke.dk>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <dave.taht@gmail.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net 2/3] net: sched: fq_codel: fix null pointer access issue when fq_codel_init() fails
Date:   Tue, 18 Oct 2022 11:47:17 +0800
Message-ID: <20221018034718.82389-3-shaozhengchao@huawei.com>
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

When the default qdisc is fq_codel, if the qdisc of dev_queue fails to be
inited during mqprio_init(), fq_codel_reset() is invoked to clear
resources. In this case, the flow is NULL, and it will cause gpf issue.

The process is as follows:
qdisc_create_dflt()
	fq_codel_init()
		...
		q->flows_cnt = 1024;
		...
		q->flows = kvcalloc(...)      --->failed, q->flows is NULL
		...
	...
	qdisc_put()
		...
		fq_codel_reset()
			...
			flow = q->flows + i   --->q->flows is NULL

The following is the Call Trace information:
general protection fault, probably for non-canonical address
0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:fq_codel_reset+0x14d/0x350
Call Trace:
<TASK>
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
RIP: 0033:0x7fd272b22d04
</TASK>

Fixes: 494f5063b86c ("net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_fq_codel.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 99d318b60568..d1e3c8083f2d 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -478,23 +478,27 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	if (opt) {
 		err = fq_codel_change(sch, opt, extack);
 		if (err)
-			return err;
+			goto err_out;
 	}
 
 	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
 	if (err)
-		return err;
+		goto err_out;
 
 	if (!q->flows) {
 		q->flows = kvcalloc(q->flows_cnt,
 				    sizeof(struct fq_codel_flow),
 				    GFP_KERNEL);
-		if (!q->flows)
-			return -ENOMEM;
+		if (!q->flows) {
+			err = -ENOMEM;
+			goto err_out;
+		}
 
 		q->backlogs = kvcalloc(q->flows_cnt, sizeof(u32), GFP_KERNEL);
-		if (!q->backlogs)
-			return -ENOMEM;
+		if (!q->backlogs) {
+			err = -ENOMEM;
+			goto err_out;
+		}
 
 		for (i = 0; i < q->flows_cnt; i++) {
 			struct fq_codel_flow *flow = q->flows + i;
@@ -508,6 +512,10 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	else
 		sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
+
+err_out:
+	q->flows_cnt = 0;
+	return err;
 }
 
 static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
-- 
2.17.1

