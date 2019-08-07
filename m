Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCBC84C82
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbfHGNLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:11:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387598AbfHGNLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 09:11:08 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 985D478C74173526DB54;
        Wed,  7 Aug 2019 21:11:06 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 7 Aug 2019
 21:10:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <dave.taht@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] fq_codel: remove set but not used variables 'prev_ecn_mark' and 'prev_drop_count'
Date:   Wed, 7 Aug 2019 21:10:55 +0800
Message-ID: <20190807131055.66668-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/sched/sch_fq_codel.c: In function fq_codel_dequeue:
net/sched/sch_fq_codel.c:288:23: warning: variable prev_ecn_mark set but not used [-Wunused-but-set-variable]
net/sched/sch_fq_codel.c:288:6: warning: variable prev_drop_count set but not used [-Wunused-but-set-variable]

They are not used since commit 77ddaff218fc ("fq_codel: Kill
useless per-flow dropped statistic")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/sched/sch_fq_codel.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 9edd0f4..c261c0a 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -285,7 +285,6 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 	struct sk_buff *skb;
 	struct fq_codel_flow *flow;
 	struct list_head *head;
-	u32 prev_drop_count, prev_ecn_mark;
 
 begin:
 	head = &q->new_flows;
@@ -302,9 +301,6 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 		goto begin;
 	}
 
-	prev_drop_count = q->cstats.drop_count;
-	prev_ecn_mark = q->cstats.ecn_mark;
-
 	skb = codel_dequeue(sch, &sch->qstats.backlog, &q->cparams,
 			    &flow->cvars, &q->cstats, qdisc_pkt_len,
 			    codel_get_enqueue_time, drop_func, dequeue_func);
-- 
2.7.4


