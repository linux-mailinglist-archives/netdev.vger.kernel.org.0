Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB837F0D2
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 03:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbhEMBM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 21:12:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2571 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbhEMBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 21:12:23 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FgYSc0KsZzsRKg;
        Thu, 13 May 2021 09:08:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 09:10:58 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: [PATCH net v7 2/3] net: sched: fix endless tx action reschedule during deactivation
Date:   Thu, 13 May 2021 09:10:59 +0800
Message-ID: <1620868260-32984-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
References: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently qdisc_run() checks the STATE_DEACTIVATED of lockless
qdisc before calling __qdisc_run(), which ultimately clear the
STATE_MISSED when all the skb is dequeued. If STATE_DEACTIVATED
is set before clearing STATE_MISSED, there may be endless
rescheduling of net_tx_action() at the end of qdisc_run_end(),
see below:

CPU0(net_tx_atcion)  CPU1(__dev_xmit_skb)  CPU2(dev_deactivate)
          .                   .                     .
          .            set STATE_MISSED             .
          .           __netif_schedule()            .
          .                   .           set STATE_DEACTIVATED
          .                   .                qdisc_reset()
          .                   .                     .
          .<---------------   .              synchronize_net()
clear __QDISC_STATE_SCHED  |  .                     .
          .                |  .                     .
          .                |  .                     .
          .                |  .           --------->.
          .                |  .          |          .
  test STATE_DEACTIVATED   |  .          | some_qdisc_is_busy()
__qdisc_run() *not* called |  .          |-----return *true*
          .                |  .                     .
   test STATE_MISS         |  .                     .
 __netif_schedule()--------|  .                     .
          .                   .                     .
          .                   .                     .

__qdisc_run() is not called by net_tx_atcion() in CPU0 because
CPU2 has set STATE_DEACTIVATED flag during dev_deactivate(), and
STATE_MISSED is only cleared in __qdisc_run(), __netif_schedule
is called endlessly at the end of qdisc_run_end(), causing endless
tx action rescheduling problem.

qdisc_run() called by net_tx_action() runs in the softirq context,
which should has the same semantic as the qdisc_run() called by
__dev_xmit_skb() protected by rcu_read_lock_bh(). And there is a
synchronize_net() between STATE_DEACTIVATED flag being set and
qdisc_reset()/some_qdisc_is_busy in dev_deactivate(), we can safely
bail out for the deactived lockless qdisc in net_tx_action(), and
qdisc_reset() will reset all skb not dequeued yet.

So add the rcu_read_lock() explicitly to protect the qdisc_run()
and do the STATE_DEACTIVATED checking in net_tx_action() before
calling qdisc_run_begin(). Another option is to do the checking in
the qdisc_run_end(), but it will add unnecessary overhead for
non-tx_action case, because __dev_queue_xmit() will not see qdisc
with STATE_DEACTIVATED after synchronize_net(), the qdisc with
STATE_DEACTIVATED can only be seen by net_tx_action() because of
__netif_schedule().

The STATE_DEACTIVATED checking in qdisc_run() is to avoid race
between net_tx_action() and qdisc_reset(), see:
commit d518d2ed8640 ("net/sched: fix race between deactivation
and dequeue for NOLOCK qdisc"). As the bailout added above for
deactived lockless qdisc in net_tx_action() provides better
protection for the race without calling qdisc_run() at all, so
remove the STATE_DEACTIVATED checking in qdisc_run().

After qdisc_reset(), there is no skb in qdisc to be dequeued, so
clear the STATE_MISSED in dev_reset_queue() too.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/pkt_sched.h |  7 +------
 net/core/dev.c          | 26 ++++++++++++++++++++++----
 net/sched/sch_generic.c |  4 +++-
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index f5c1bee..6d7b12c 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -128,12 +128,7 @@ void __qdisc_run(struct Qdisc *q);
 static inline void qdisc_run(struct Qdisc *q)
 {
 	if (qdisc_run_begin(q)) {
-		/* NOLOCK qdisc must check 'state' under the qdisc seqlock
-		 * to avoid racing with dev_qdisc_reset()
-		 */
-		if (!(q->flags & TCQ_F_NOLOCK) ||
-		    likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
-			__qdisc_run(q);
+		__qdisc_run(q);
 		qdisc_run_end(q);
 	}
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 222b1d3..d596cd7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5025,25 +5025,43 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 		sd->output_queue_tailp = &sd->output_queue;
 		local_irq_enable();
 
+		rcu_read_lock();
+
 		while (head) {
 			struct Qdisc *q = head;
 			spinlock_t *root_lock = NULL;
 
 			head = head->next_sched;
 
-			if (!(q->flags & TCQ_F_NOLOCK)) {
-				root_lock = qdisc_lock(q);
-				spin_lock(root_lock);
-			}
 			/* We need to make sure head->next_sched is read
 			 * before clearing __QDISC_STATE_SCHED
 			 */
 			smp_mb__before_atomic();
+
+			if (!(q->flags & TCQ_F_NOLOCK)) {
+				root_lock = qdisc_lock(q);
+				spin_lock(root_lock);
+			} else if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
+						     &q->state))) {
+				/* There is a synchronize_net() between
+				 * STATE_DEACTIVATED flag being set and
+				 * qdisc_reset()/some_qdisc_is_busy() in
+				 * dev_deactivate(), so we can safely bail out
+				 * early here to avoid data race between
+				 * qdisc_deactivate() and some_qdisc_is_busy()
+				 * for lockless qdisc.
+				 */
+				clear_bit(__QDISC_STATE_SCHED, &q->state);
+				continue;
+			}
+
 			clear_bit(__QDISC_STATE_SCHED, &q->state);
 			qdisc_run(q);
 			if (root_lock)
 				spin_unlock(root_lock);
 		}
+
+		rcu_read_unlock();
 	}
 
 	xfrm_dev_backlog(sd);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 795d986..d86c4cc 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1177,8 +1177,10 @@ static void dev_reset_queue(struct net_device *dev,
 	qdisc_reset(qdisc);
 
 	spin_unlock_bh(qdisc_lock(qdisc));
-	if (nolock)
+	if (nolock) {
+		clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
 		spin_unlock_bh(&qdisc->seqlock);
+	}
 }
 
 static bool some_qdisc_is_busy(struct net_device *dev)
-- 
2.7.4

