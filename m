Return-Path: <netdev+bounces-9140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B24072772F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABD992815CB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D915763B9;
	Thu,  8 Jun 2023 06:20:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ACF628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:20:39 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67363E62
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:20:37 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QcDYh6fXQz25h5k;
	Thu,  8 Jun 2023 14:18:48 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 8 Jun
 2023 14:20:32 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <netdev@vger.kernel.org>, <vinicius.gomes@intel.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <vladimir.oltean@nxp.com>, <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read in taprio_dequeue_from_txq
Date: Thu, 8 Jun 2023 14:27:56 +0800
Message-ID: <20230608062756.3626573-1-shaozhengchao@huawei.com>
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
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As shown in [1], out-of-bounds access occurs in two cases:
1)when the qdisc of the taprio type is used to replace the previously
configured taprio, count and offset in tc_to_txq can be set to 0. In this
case, the value of *txq in taprio_next_tc_txq() will increases
continuously. When the number of accessed queues exceeds the number of
queues on the device, out-of-bounds access occurs.
2)When packets are dequeued, taprio can be deleted. In this case, the tc
rule of dev is cleared. The count and offset values are also set to 0. In
this case, out-of-bounds access is also caused.

Now the restriction on the queue number is added.

[1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: set q->cur_txq[tc] to prevent out-of-bounds access during next dequeue
---
 net/sched/sch_taprio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 3c4c2c334878..82983a6eb8f8 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -799,6 +799,9 @@ static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
 
 			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
 
+			if (q->cur_txq[tc] >= dev->num_tx_queues)
+				q->cur_txq[tc] = first_txq;
+
 			if (skb)
 				return skb;
 		} while (q->cur_txq[tc] != first_txq);
-- 
2.34.1


