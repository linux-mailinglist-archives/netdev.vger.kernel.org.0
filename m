Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9383D607265
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 10:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJUIec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 04:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJUIeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 04:34:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29F1106A50
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 01:33:39 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MtyRC2YvlzHvCM;
        Fri, 21 Oct 2022 16:33:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 16:33:09 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] net: sched: fq_codel: fix null-ptr-deref issue in fq_codel_enqueue()
Date:   Fri, 21 Oct 2022 16:40:58 +0800
Message-ID: <20221021084058.223823-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As [0] see, it will cause null-ptr-deref issue.
The following is the process of triggering the problem:
fq_codel_enqueue()
	...
	idx = fq_codel_classify()        --->if idx != 0
	flow = &q->flows[idx];
	flow_queue_add(flow, skb);       --->add skb to flow[idex]
	q->backlogs[idx] += qdisc_pkt_len(skb); --->backlogs = 0
	...
	fq_codel_drop()          --->set sch->limit = 0, always
				     drop packets
		...
		idx = i          --->because backlogs in every
				     flows is 0, so idx = 0
		...
		flow = &q->flows[idx];   --->get idx=0 flow
		...
		dequeue_head()
			skb = flow->head; --->flow->head = NULL
			flow->head = skb->next; --->cause null-ptr-deref

So, only need to discard the packets whose len is 0 on dropping path of
enqueue. Then, the correct flow id can be obtained by fq_codel_drop() on
next enqueuing.

[0]: https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5

Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_fq_codel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 99d318b60568..3bbe7f69dfb5 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -187,6 +187,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	unsigned int idx, prev_backlog, prev_qlen;
 	struct fq_codel_flow *flow;
+	struct sk_buff *drop_skb;
 	int ret;
 	unsigned int pkt_len;
 	bool memory_limited;
@@ -222,6 +223,13 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	/* save this packet length as it might be dropped by fq_codel_drop() */
 	pkt_len = qdisc_pkt_len(skb);
+
+	/* drop skb if len = 0, so fq_codel_drop could get the right flow idx*/
+	if (unlikely(!pkt_len)) {
+		drop_skb = dequeue_head(flow);
+		__qdisc_drop(drop_skb, to_free);
+		return NET_XMIT_SUCCESS;
+	}
 	/* fq_codel_drop() is quite expensive, as it performs a linear search
 	 * in q->backlogs[] to find a fat flow.
 	 * So instead of dropping a single packet, drop half of its backlog
-- 
2.17.1

