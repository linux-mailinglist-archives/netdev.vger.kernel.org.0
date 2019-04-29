Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5F3ECED
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfD2WtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:49:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:39185 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbfD2WtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:49:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072448"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:49:09 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, olteanv@gmail.com,
        timo.koskiahde@tttech.com, m-karicheri2@ti.com
Subject: [PATCH net-next v1 1/4] taprio: Fix potencial use of invalid memory during dequeue()
Date:   Mon, 29 Apr 2019 15:48:30 -0700
Message-Id: <20190429224833.18208-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429224833.18208-1-vinicius.gomes@intel.com>
References: <20190429224833.18208-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, this isn't a problem, but the next commit allows schedules
to be added during runtime. When a new schedule transitions from the
inactive to the active state ("admin" -> "oper") the previous one can
be freed, if it's freed just after the RCU read lock is released, we
may access an invalid entry.

So, we should take care to protect the dequeue() flow, so all the
places that access the entries are protected by the RCU read lock.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 09563c245473..f827caa73862 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -136,8 +136,8 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct sk_buff *skb = NULL;
 	struct sched_entry *entry;
-	struct sk_buff *skb;
 	u32 gate_mask;
 	int i;
 
@@ -154,10 +154,9 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	 * "AdminGateSates"
 	 */
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
-	rcu_read_unlock();
 
 	if (!gate_mask)
-		return NULL;
+		goto done;
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct Qdisc *child = q->qdiscs[i];
@@ -197,16 +196,19 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 
 		skb = child->ops->dequeue(child);
 		if (unlikely(!skb))
-			return NULL;
+			goto done;
 
 		qdisc_bstats_update(sch, skb);
 		qdisc_qstats_backlog_dec(sch, skb);
 		sch->q.qlen--;
 
-		return skb;
+		goto done;
 	}
 
-	return NULL;
+done:
+	rcu_read_unlock();
+
+	return skb;
 }
 
 static enum hrtimer_restart advance_sched(struct hrtimer *timer)
-- 
2.21.0

