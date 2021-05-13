Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5E737F0CA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 03:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbhEMBMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 21:12:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2570 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbhEMBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 21:12:23 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FgYSb6QPkzsRNP;
        Thu, 13 May 2021 09:08:31 +0800 (CST)
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
Subject: [PATCH net v7 1/3] net: sched: fix packet stuck problem for lockless qdisc
Date:   Thu, 13 May 2021 09:10:58 +0800
Message-ID: <1620868260-32984-2-git-send-email-linyunsheng@huawei.com>
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

Lockless qdisc has below concurrent problem:
    cpu0                 cpu1
     .                     .
q->enqueue                 .
     .                     .
qdisc_run_begin()          .
     .                     .
dequeue_skb()              .
     .                     .
sch_direct_xmit()          .
     .                     .
     .                q->enqueue
     .             qdisc_run_begin()
     .            return and do nothing
     .                     .
qdisc_run_end()            .

cpu1 enqueue a skb without calling __qdisc_run() because cpu0
has not released the lock yet and spin_trylock() return false
for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
enqueued by cpu1 when calling dequeue_skb() because cpu1 may
enqueue the skb after cpu0 calling dequeue_skb() and before
cpu0 calling qdisc_run_end().

Lockless qdisc has below another concurrent problem when
tx_action is involved:

cpu0(serving tx_action)     cpu1             cpu2
          .                   .                .
          .              q->enqueue            .
          .            qdisc_run_begin()       .
          .              dequeue_skb()         .
          .                   .            q->enqueue
          .                   .                .
          .             sch_direct_xmit()      .
          .                   .         qdisc_run_begin()
          .                   .       return and do nothing
          .                   .                .
 clear __QDISC_STATE_SCHED    .                .
 qdisc_run_begin()            .                .
 return and do nothing        .                .
          .                   .                .
          .            qdisc_run_end()         .

This patch fixes the above data race by:
1. If the first spin_trylock() return false and STATE_MISSED is
   not set, set STATE_MISSED and retry another spin_trylock() in
   case other CPU may not see STATE_MISSED after it releases the
   lock.
2. reschedule if STATE_MISSED is set after the lock is released
   at the end of qdisc_run_end().

For tx_action case, STATE_MISSED is also set when cpu1 is at the
end if qdisc_run_end(), so tx_action will be rescheduled again
to dequeue the skb enqueued by cpu2.

Clear STATE_MISSED before retrying a dequeuing when dequeuing
returns NULL in order to reduce the overhead of the second
spin_trylock() and __netif_schedule() calling.

Also clear the STATE_MISSED before calling __netif_schedule()
at the end of qdisc_run_end() to avoid doing another round of
dequeuing in the pfifo_fast_dequeue().

The performance impact of this patch, tested using pktgen and
dummy netdev with pfifo_fast qdisc attached:

 threads  without+this_patch   with+this_patch      delta
    1        2.61Mpps            2.60Mpps           -0.3%
    2        3.97Mpps            3.82Mpps           -3.7%
    4        5.62Mpps            5.59Mpps           -0.5%
    8        2.78Mpps            2.77Mpps           -0.3%
   16        2.22Mpps            2.22Mpps           -0.0%

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Tested-by: Juergen Gross <jgross@suse.com>
---
V7: Clear STATE_MISSED before calling __netif_schedule()
    as suggested by Jakub.
V6: Check MISSED after the first trylock, and remove the
    automic test and set for performance sake as suggested
    by Jakub.
V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED mirroring
    NAPI's NAPIF_STATE_MISSED, and add Juergen's "Tested-by"
    tag for there is only renaming and typo fixing between
    V4 and V3.
V3: Fix a compile error and a few comment typo, remove the
    __QDISC_STATE_DEACTIVATED checking, and update the
    performance data.
V2: Avoid the overhead of fixing the data race as much as
    possible.
---
 include/net/sch_generic.h | 35 ++++++++++++++++++++++++++++++++++-
 net/sched/sch_generic.c   | 19 +++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f7a6e14..1e62551 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -36,6 +36,7 @@ struct qdisc_rate_table {
 enum qdisc_state_t {
 	__QDISC_STATE_SCHED,
 	__QDISC_STATE_DEACTIVATED,
+	__QDISC_STATE_MISSED,
 };
 
 struct qdisc_size_table {
@@ -159,8 +160,33 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK) {
+		if (spin_trylock(&qdisc->seqlock))
+			goto nolock_empty;
+
+		/* If the MISSED flag is set, it means other thread has
+		 * set the MISSED flag before second spin_trylock(), so
+		 * we can return false here to avoid multi cpus doing
+		 * the set_bit() and second spin_trylock() concurrently.
+		 */
+		if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
+			return false;
+
+		/* Set the MISSED flag before the second spin_trylock(),
+		 * if the second spin_trylock() return false, it means
+		 * other cpu holding the lock will do dequeuing for us
+		 * or it will see the MISSED flag set after releasing
+		 * lock and reschedule the net_tx_action() to do the
+		 * dequeuing.
+		 */
+		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
+
+		/* Retry again in case other CPU may not see the new flag
+		 * after it releases the lock at the end of qdisc_run_end().
+		 */
 		if (!spin_trylock(&qdisc->seqlock))
 			return false;
+
+nolock_empty:
 		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
@@ -176,8 +202,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
 	write_seqcount_end(&qdisc->running);
-	if (qdisc->flags & TCQ_F_NOLOCK)
+	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
+
+		if (unlikely(test_bit(__QDISC_STATE_MISSED,
+				      &qdisc->state))) {
+			clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+			__netif_schedule(qdisc);
+		}
+	}
 }
 
 static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 44991ea..795d986 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -640,8 +640,10 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
 {
 	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
 	struct sk_buff *skb = NULL;
+	bool need_retry = true;
 	int band;
 
+retry:
 	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
 		struct skb_array *q = band2list(priv, band);
 
@@ -652,6 +654,23 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
 	}
 	if (likely(skb)) {
 		qdisc_update_stats_at_dequeue(qdisc, skb);
+	} else if (need_retry &&
+		   test_bit(__QDISC_STATE_MISSED, &qdisc->state)) {
+		/* Delay clearing the STATE_MISSED here to reduce
+		 * the overhead of the second spin_trylock() in
+		 * qdisc_run_begin() and __netif_schedule() calling
+		 * in qdisc_run_end().
+		 */
+		clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+
+		/* Make sure dequeuing happens after clearing
+		 * STATE_MISSED.
+		 */
+		smp_mb__after_atomic();
+
+		need_retry = false;
+
+		goto retry;
 	} else {
 		WRITE_ONCE(qdisc->empty, true);
 	}
-- 
2.7.4

