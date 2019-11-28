Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971B110C3E0
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 07:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfK1G31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 01:29:27 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46473 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfK1G31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 01:29:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TjHb.Ek_1574922549;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TjHb.Ek_1574922549)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Nov 2019 14:29:23 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] net: sched: fix `tc -s class show` no bstats on class with nolock subqueues
Date:   Thu, 28 Nov 2019 14:29:09 +0800
Message-Id: <20191128062909.84666-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a classful qdisc's child qdisc has set the flag
TCQ_F_CPUSTATS (pfifo_fast for example), the child qdisc's
cpu_bstats should be passed to gnet_stats_copy_basic(),
but many classful qdisc didn't do that. As a result,
`tc -s class show dev DEV` always return 0 for bytes and
packets in this case.

Pass the child qdisc's cpu_bstats to gnet_stats_copy_basic()
to fix this issue.

The qstats also has this problem, but it has been fixed
in 5dd431b6b9 ("net: sched: introduce and use qstats read...")
and bstats still remains buggy.

Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/sched/sch_mq.c     | 3 ++-
 net/sched/sch_mqprio.c | 4 ++--
 net/sched/sch_multiq.c | 2 +-
 net/sched/sch_prio.c   | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 0d578333e967..278c0b2dc523 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -245,7 +245,8 @@ static int mq_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
 
 	sch = dev_queue->qdisc_sleeping;
-	if (gnet_stats_copy_basic(&sch->running, d, NULL, &sch->bstats) < 0 ||
+	if (gnet_stats_copy_basic(&sch->running, d, sch->cpu_bstats,
+				  &sch->bstats) < 0 ||
 	    qdisc_qstats_copy(d, sch) < 0)
 		return -1;
 	return 0;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 46980b8d66c5..0d0113a24962 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -557,8 +557,8 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 		struct netdev_queue *dev_queue = mqprio_queue_get(sch, cl);
 
 		sch = dev_queue->qdisc_sleeping;
-		if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
-					  d, NULL, &sch->bstats) < 0 ||
+		if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch), d,
+					  sch->cpu_bstats, &sch->bstats) < 0 ||
 		    qdisc_qstats_copy(d, sch) < 0)
 			return -1;
 	}
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index b2b7fdb06fc6..1330ad224931 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -339,7 +339,7 @@ static int multiq_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 
 	cl_q = q->queues[cl - 1];
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
-				  d, NULL, &cl_q->bstats) < 0 ||
+				  d, cl_q->cpu_bstats, &cl_q->bstats) < 0 ||
 	    qdisc_qstats_copy(d, cl_q) < 0)
 		return -1;
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 0f8fedb8809a..18b884cfdfe8 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -356,7 +356,7 @@ static int prio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 
 	cl_q = q->queues[cl - 1];
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
-				  d, NULL, &cl_q->bstats) < 0 ||
+				  d, cl_q->cpu_bstats, &cl_q->bstats) < 0 ||
 	    qdisc_qstats_copy(d, cl_q) < 0)
 		return -1;
 
-- 
2.19.1.3.ge56e4f7

