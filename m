Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF61226EC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfLQIrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:47:33 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:44409 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfLQIrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:47:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TlB4HLn_1576572444;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TlB4HLn_1576572444)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Dec 2019 16:47:29 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sched: keep __gnet_stats_copy_xxx() same semantics for percpu stats
Date:   Tue, 17 Dec 2019 16:47:17 +0800
Message-Id: <20191217084718.52098-2-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20191217084718.52098-1-dust.li@linux.alibaba.com>
References: <20191217084718.52098-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__gnet_stats_copy_basic/queue() support both percpu stat and
non-percpu stat, but they are handle in a different manner:
1. percpu stats are added to the return value;
2. non-percpu stats overwrite the return value;
We should keep the same semantics for both type.

This patch makes percpu stats follow non-percpu's manner by
reset the returned bstats/qstats before add the percpu bstats to it.
Also changes the caller in sch_mq.c/sch_mqprio.c to make sure
they dump the right statistics for percpu qdisc.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/core/gen_stats.c   |  2 ++
 net/sched/sch_mq.c     | 35 ++++++++++++++++-------------------
 net/sched/sch_mqprio.c | 36 +++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 1d653fbfcf52..efd3f5f69c73 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -145,6 +145,7 @@ __gnet_stats_copy_basic(const seqcount_t *running,
 	unsigned int seq;
 
 	if (cpu) {
+		memset(bstats, 0, sizeof(*bstats));
 		__gnet_stats_copy_basic_cpu(bstats, cpu);
 		return;
 	}
@@ -305,6 +306,7 @@ void __gnet_stats_copy_queue(struct gnet_stats_queue *qstats,
 			     __u32 qlen)
 {
 	if (cpu) {
+		memset(qstats, 0, sizeof(*qstats));
 		__gnet_stats_copy_queue_cpu(qstats, cpu);
 	} else {
 		qstats->qlen = q->qlen;
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index e79f1afe0cfd..b2178b7fe3a3 100644
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
@@ -145,25 +147,20 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
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
-			sch->q.qlen		+= qlen;
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
index 8766ab5b8788..ce95e9b4a796 100644
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
@@ -402,25 +405,20 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
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
-			sch->q.qlen		+= qlen;
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

