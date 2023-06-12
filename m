Return-Path: <netdev+bounces-9957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF75872B610
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 05:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 653202810B8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 03:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944EC1C27;
	Mon, 12 Jun 2023 03:24:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8938717CE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 03:24:08 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DA49E
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 20:24:06 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QfcRL61GCztQYt;
	Mon, 12 Jun 2023 11:21:34 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 12 Jun
 2023 11:24:01 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <netdev@vger.kernel.org>, <vinicius.gomes@intel.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <vladimir.oltean@nxp.com>, <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] net/sched: taprio: drop packets when tc mapping to empty queue in taprio_enqueue
Date: Mon, 12 Jun 2023 11:31:15 +0800
Message-ID: <20230612033115.3766791-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

As discussed in link [1], queues setting (0@0) means TC mapped to the
"empty set" queue. We should drop the packets from TCs mapped to the
"empty set" queue (0@0) during enqueue().

[1] https://lore.kernel.org/all/20230608062756.3626573-1-shaozhengchao@huawei.com/
Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_taprio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5076da103f63..79ba9cbd7b3d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -632,11 +632,15 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
 	struct Qdisc *child;
-	int queue;
+	int tc, queue;
 
-	queue = skb_get_queue_mapping(skb);
+	tc = netdev_get_prio_tc_map(dev, skb->priority);
+	if (unlikely(!dev->tc_to_txq[tc].count))
+		return qdisc_drop(skb, sch, to_free);
 
+	queue = skb_get_queue_mapping(skb);
 	child = q->qdiscs[queue];
 	if (unlikely(!child))
 		return qdisc_drop(skb, sch, to_free);
-- 
2.34.1


