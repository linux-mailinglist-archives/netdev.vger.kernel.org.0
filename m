Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981D4B0C36
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbfILKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:04:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbfILKEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 06:04:20 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77B7B2D1CE;
        Thu, 12 Sep 2019 10:04:20 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B0B360C57;
        Thu, 12 Sep 2019 10:04:19 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Li Shuang <shuali@redhat.com>
Subject: [PATCH net] net/sched: fix race between deactivation and dequeue for NOLOCK qdisc
Date:   Thu, 12 Sep 2019 12:02:42 +0200
Message-Id: <80e0c9577218090cada29e4adc9ec116f591cb6f.1568113414.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 12 Sep 2019 10:04:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test implemented by some_qdisc_is_busy() is somewhat loosy for
NOLOCK qdisc, as we may hit the following scenario:

CPU1						CPU2
// in net_tx_action()
clear_bit(__QDISC_STATE_SCHED...);
						// in some_qdisc_is_busy()
						val = (qdisc_is_running(q) ||
						       test_bit(__QDISC_STATE_SCHED,
								&q->state));
						// here val is 0 but...
qdisc_run(q)
// ... CPU1 is going to run the qdisc next

As a conseguence qdisc_run() in net_tx_action() can race with qdisc_reset()
in dev_qdisc_reset(). Such race is not possible for !NOLOCK qdisc as
both the above bit operations are under the root qdisc lock().

After commit 021a17ed796b ("pfifo_fast: drop unneeded additional lock on dequeue") 
the race can cause use after free and/or null ptr dereference, but the root 
cause is likely older.

This patch addresses the issue explicitly checking for deactivation under
the seqlock for NOLOCK qdisc, so that the qdisc_run() in the critical
scenario becomes a no-op.

Note that the enqueue() op can still execute concurrently with dev_qdisc_reset(),
but that is safe due to the skb_array() locking, and we can't avoid that
for NOLOCK qdiscs.

Fixes: 021a17ed796b ("pfifo_fast: drop unneeded additional lock on dequeue")
Reported-by: Li Shuang <shuali@redhat.com>
Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/pkt_sched.h |  7 ++++++-
 net/core/dev.c          | 16 ++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index a16fbe9a2a67..aa99c73c3fbd 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -118,7 +118,12 @@ void __qdisc_run(struct Qdisc *q);
 static inline void qdisc_run(struct Qdisc *q)
 {
 	if (qdisc_run_begin(q)) {
-		__qdisc_run(q);
+		/* NOLOCK qdisc must check 'state' under the qdisc seqlock
+		 * to avoid racing with dev_qdisc_reset()
+		 */
+		if (!(q->flags & TCQ_F_NOLOCK) ||
+		    likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
+			__qdisc_run(q);
 		qdisc_run_end(q);
 	}
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 0891f499c1bb..ef8f2f002e09 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3467,18 +3467,22 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
-			__qdisc_drop(skb, &to_free);
-			rc = NET_XMIT_DROP;
-		} else if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
-			   qdisc_run_begin(q)) {
+		if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
+		    qdisc_run_begin(q)) {
+			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
+					      &q->state))) {
+				__qdisc_drop(skb, &to_free);
+				rc = NET_XMIT_DROP;
+				goto end_run;
+			}
 			qdisc_bstats_cpu_update(q, skb);
 
+			rc = NET_XMIT_SUCCESS;
 			if (sch_direct_xmit(skb, q, dev, txq, NULL, true))
 				__qdisc_run(q);
 
+end_run:
 			qdisc_run_end(q);
-			rc = NET_XMIT_SUCCESS;
 		} else {
 			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
 			qdisc_run(q);
-- 
2.21.0

