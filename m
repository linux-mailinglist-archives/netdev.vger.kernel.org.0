Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B05610C3E6
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 07:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfK1GbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 01:31:09 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:54794 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbfK1GbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 01:31:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TjHc7.._1574922648;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TjHc7.._1574922648)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Nov 2019 14:30:57 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org
Subject: [PATCH] net: sched: keep __gnet_stats_copy_xxx() same semantics for percpu stats
Date:   Thu, 28 Nov 2019 14:30:48 +0800
Message-Id: <20191128063048.90282-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__gnet_stats_copy_basic/queue() support both percpu stat and
non-percpu stat, but they are handle in a different manner:
1. For percpu stat, percpu stats are added to the return value;
2. For non-percpu stat, non-percpu stats will overwrite the
   return value;
We should keep the same semantics for both type.

This patch makes percpu stats follow non-percpu's manner by
reset the return bstats before add the percpu bstats to it.
Also changes the caller in sch_mq.c/sch_mqprio.c to make sure
they dump the right statistics for percpu qdisc.

One more thing, the sch->q.qlen is not set with nonlock child
qdisc in mq_dump()/mqprio_dump(), add that.

Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/core/gen_stats.c   |  2 ++
 net/sched/sch_mq.c     | 34 ++++++++++++++++------------------
 net/sched/sch_mqprio.c | 35 +++++++++++++++++------------------
 3 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 1d653fbfcf52..d71af69196c9 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -120,6 +120,7 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
 {
 	int i;
 
+	memset(bstats, 0, sizeof(*bstats));
 	for_each_possible_cpu(i) {
 		struct gnet_stats_basic_cpu *bcpu = per_cpu_ptr(cpu, i);
 		unsigned int start;
@@ -288,6 +289,7 @@ __gnet_stats_copy_queue_cpu(struct gnet_stats_queue *qstats,
 {
 	int i;
 
+	memset(qstats, 0, sizeof(*qstats));
 	for_each_possible_cpu(i) {
 		const struct gnet_stats_queue *qcpu = per_cpu_ptr(q, i);
 
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 278c0b2dc523..b2178b7fe3a3 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -131,6 +131,8 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct Qdisc *qdisc;
 	unsigned int ntx;
 	__u32 qlen = 0;
+	struct gnet_stats_queue qstats = {0};
+	struct gnet_stats_basic_packed bstats = {0};
 
 	sch->q.qlen = 0;
 	memset(&sch->bstats, 0, sizeof(sch->bstats));
@@ -145,24 +147,20 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
 		qdisc = netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
 		spin_lock_bh(qdisc_lock(qdisc));
 
-		if (qdisc_is_percpu_stats(qdisc)) {
-			qlen = qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						qdisc->cpu_bstats,
-						&qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						qdisc->cpu_qstats,
-						&qdisc->qstats, qlen);
-		} else {
-			sch->q.qlen		+= qdisc->q.qlen;
-			sch->bstats.bytes	+= qdisc->bstats.bytes;
-			sch->bstats.packets	+= qdisc->bstats.packets;
-			sch->qstats.qlen	+= qdisc->qstats.qlen;
-			sch->qstats.backlog	+= qdisc->qstats.backlog;
-			sch->qstats.drops	+= qdisc->qstats.drops;
-			sch->qstats.requeues	+= qdisc->qstats.requeues;
-			sch->qstats.overlimits	+= qdisc->qstats.overlimits;
-		}
+		qlen = qdisc_qlen_sum(qdisc);
+		__gnet_stats_copy_basic(NULL, &bstats, qdisc->cpu_bstats,
+					&qdisc->bstats);
+		__gnet_stats_copy_queue(&qstats, qdisc->cpu_qstats,
+					&qdisc->qstats, qlen);
+
+		sch->q.qlen		+= qdisc->q.qlen;
+		sch->bstats.bytes	+= bstats.bytes;
+		sch->bstats.packets	+= bstats.packets;
+		sch->qstats.qlen	+= qstats.qlen;
+		sch->qstats.backlog	+= qstats.backlog;
+		sch->qstats.drops	+= qstats.drops;
+		sch->qstats.requeues	+= qstats.requeues;
+		sch->qstats.overlimits	+= qstats.overlimits;
 
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 0d0113a24962..6887084bd5ad 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -388,6 +388,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_mqprio_qopt opt = { 0 };
 	struct Qdisc *qdisc;
 	unsigned int ntx, tc;
+	__u32 qlen = 0;
+	struct gnet_stats_queue qstats = {0};
+	struct gnet_stats_basic_packed bstats = {0};
 
 	sch->q.qlen = 0;
 	memset(&sch->bstats, 0, sizeof(sch->bstats));
@@ -402,24 +405,20 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 		qdisc = netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
 		spin_lock_bh(qdisc_lock(qdisc));
 
-		if (qdisc_is_percpu_stats(qdisc)) {
-			__u32 qlen = qdisc_qlen_sum(qdisc);
-
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						qdisc->cpu_bstats,
-						&qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						qdisc->cpu_qstats,
-						&qdisc->qstats, qlen);
-		} else {
-			sch->q.qlen		+= qdisc->q.qlen;
-			sch->bstats.bytes	+= qdisc->bstats.bytes;
-			sch->bstats.packets	+= qdisc->bstats.packets;
-			sch->qstats.backlog	+= qdisc->qstats.backlog;
-			sch->qstats.drops	+= qdisc->qstats.drops;
-			sch->qstats.requeues	+= qdisc->qstats.requeues;
-			sch->qstats.overlimits	+= qdisc->qstats.overlimits;
-		}
+		qlen = qdisc_qlen_sum(qdisc);
+		__gnet_stats_copy_basic(NULL, &bstats, qdisc->cpu_bstats,
+					&qdisc->bstats);
+		__gnet_stats_copy_queue(&qstats, qdisc->cpu_qstats,
+					&qdisc->qstats, qlen);
+
+		sch->q.qlen		+= qdisc->q.qlen;
+		sch->bstats.bytes	+= bstats.bytes;
+		sch->bstats.packets	+= bstats.packets;
+		sch->qstats.qlen	+= qstats.qlen;
+		sch->qstats.backlog	+= qstats.backlog;
+		sch->qstats.drops	+= qstats.drops;
+		sch->qstats.requeues	+= qstats.requeues;
+		sch->qstats.overlimits	+= qstats.overlimits;
 
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
-- 
2.19.1.3.ge56e4f7

