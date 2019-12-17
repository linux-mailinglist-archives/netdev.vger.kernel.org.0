Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763FB1226ED
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLQIrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:47:39 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43147 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfLQIri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:47:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TlBMkDQ_1576572449;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TlBMkDQ_1576572449)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Dec 2019 16:47:34 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: sched: fix wrong class stats dumping in sch_mqprio
Date:   Tue, 17 Dec 2019 16:47:18 +0800
Message-Id: <20191217084718.52098-3-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20191217084718.52098-1-dust.li@linux.alibaba.com>
References: <20191217084718.52098-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, the stack variables bstats and qstats in
mqprio_dump_class_stats() are not really used. As a result,
'tc -s class show' for the mqprio class always return 0 for
both bstats and qstats.
This patch make them(bstats/qstats) storing the child qdisc's
stats, and add them up to a tbstats/tqstats which will store
the result mqprio class.

Fixes: ce679e8df7ed ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/sched/sch_mqprio.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index ce95e9b4a796..b356517c6ef4 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -511,8 +511,8 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 	if (cl >= TC_H_MIN_PRIORITY) {
 		int i;
 		__u32 qlen = 0;
-		struct gnet_stats_queue qstats = {0};
-		struct gnet_stats_basic_packed bstats = {0};
+		struct gnet_stats_queue tqstats = {0};
+		struct gnet_stats_basic_packed tbstats = {0};
 		struct net_device *dev = qdisc_dev(sch);
 		struct netdev_tc_txq tc = dev->tc_to_txq[cl & TC_BITMASK];
 
@@ -529,6 +529,8 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			struct Qdisc *qdisc = rtnl_dereference(q->qdisc);
 			struct gnet_stats_basic_cpu __percpu *cpu_bstats = NULL;
 			struct gnet_stats_queue __percpu *cpu_qstats = NULL;
+			struct gnet_stats_queue qstats = {0};
+			struct gnet_stats_basic_packed bstats = {0};
 
 			spin_lock_bh(qdisc_lock(qdisc));
 			if (qdisc_is_percpu_stats(qdisc)) {
@@ -536,21 +538,28 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 				cpu_qstats = qdisc->cpu_qstats;
 			}
 
-			qlen = qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
+			qlen += qdisc_qlen_sum(qdisc);
+			__gnet_stats_copy_basic(NULL, &bstats,
 						cpu_bstats, &qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
+			__gnet_stats_copy_queue(&qstats,
 						cpu_qstats,
 						&qdisc->qstats,
 						qlen);
 			spin_unlock_bh(qdisc_lock(qdisc));
+
+			tbstats.bytes		+= bstats.bytes;
+			tbstats.packets		+= bstats.packets;
+			tqstats.backlog		+= qstats.backlog;
+			tqstats.drops		+= qstats.drops;
+			tqstats.requeues	+= qstats.requeues;
+			tqstats.overlimits	+= qstats.overlimits;
 		}
 
 		/* Reclaim root sleeping lock before completing stats */
 		if (d->lock)
 			spin_lock_bh(d->lock);
-		if (gnet_stats_copy_basic(NULL, d, NULL, &bstats) < 0 ||
-		    gnet_stats_copy_queue(d, NULL, &qstats, qlen) < 0)
+		if (gnet_stats_copy_basic(NULL, d, NULL, &tbstats) < 0 ||
+		    gnet_stats_copy_queue(d, NULL, &tqstats, qlen) < 0)
 			return -1;
 	} else {
 		struct netdev_queue *dev_queue = mqprio_queue_get(sch, cl);
-- 
2.19.1.3.ge56e4f7

