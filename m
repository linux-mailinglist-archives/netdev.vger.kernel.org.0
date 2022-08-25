Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9305A0DDA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiHYKZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiHYKZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:25:10 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F7310556;
        Thu, 25 Aug 2022 03:25:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MCzZN123VzGphj;
        Thu, 25 Aug 2022 18:23:24 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 25 Aug
 2022 18:25:04 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next] net: sched: sch_skbprio: add support for qlen statistics of each priority in sch_skbprio
Date:   Thu, 25 Aug 2022 18:27:45 +0800
Message-ID: <20220825102745.70728-1-shaozhengchao@huawei.com>
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

The skbprio_dump_class_stats() gets the qlen of queues with the cl - 1
priority, but the qlen of each priority is not used in enqueue or dequeue
process.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_skbprio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 7a5e4c454715..fe2bb7bf9d2a 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -83,6 +83,7 @@ static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		__skb_queue_tail(qdisc, skb);
 		qdisc_qstats_backlog_inc(sch, skb);
 		q->qstats[prio].backlog += qdisc_pkt_len(skb);
+		q->qstats[prio].qlen++;
 
 		/* Check to update highest and lowest priorities. */
 		if (prio > q->highest_prio)
@@ -106,6 +107,7 @@ static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	__skb_queue_tail(qdisc, skb);
 	qdisc_qstats_backlog_inc(sch, skb);
 	q->qstats[prio].backlog += qdisc_pkt_len(skb);
+	q->qstats[prio].qlen++;
 
 	/* Drop the packet at the tail of the lowest priority qdisc. */
 	lp_qdisc = &q->qdiscs[lp];
@@ -115,6 +117,7 @@ static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	qdisc_drop(to_drop, sch, to_free);
 
 	q->qstats[lp].backlog -= qdisc_pkt_len(to_drop);
+	q->qstats[lp].qlen--;
 	q->qstats[lp].drops++;
 	q->qstats[lp].overlimits++;
 
@@ -150,6 +153,7 @@ static struct sk_buff *skbprio_dequeue(struct Qdisc *sch)
 	qdisc_bstats_update(sch, skb);
 
 	q->qstats[q->highest_prio].backlog -= qdisc_pkt_len(skb);
+	q->qstats[q->highest_prio].qlen--;
 
 	/* Update highest priority field. */
 	if (skb_queue_empty(hpq)) {
-- 
2.17.1

