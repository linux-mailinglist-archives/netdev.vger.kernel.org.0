Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F5A10F587
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 04:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfLCDRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 22:17:50 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60353 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbfLCDRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 22:17:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TjmSBjD_1575343060;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TjmSBjD_1575343060)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Dec 2019 11:17:48 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues
Date:   Tue,  3 Dec 2019 11:17:40 +0800
Message-Id: <20191203031740.41506-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 sch->q.len hasn't been set if the subqueue is a NOLOCK qdisc
 in mq_dump() and mqprio_dump().

Fixes: ce679e8df7ed ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/sched/sch_mq.c     | 1 +
 net/sched/sch_mqprio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 278c0b2dc523..e79f1afe0cfd 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -153,6 +153,7 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
+			sch->q.qlen		+= qlen;
 		} else {
 			sch->q.qlen		+= qdisc->q.qlen;
 			sch->bstats.bytes	+= qdisc->bstats.bytes;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 0d0113a24962..de4e00a58bc6 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -411,6 +411,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
+			sch->q.qlen		+= qlen;
 		} else {
 			sch->q.qlen		+= qdisc->q.qlen;
 			sch->bstats.bytes	+= qdisc->bstats.bytes;
-- 
2.19.1.3.ge56e4f7

