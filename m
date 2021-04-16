Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFCF36171E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 03:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbhDPBRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 21:17:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17003 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbhDPBRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 21:17:01 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FLys00XLgzPr0K;
        Fri, 16 Apr 2021 09:13:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 16 Apr 2021 09:16:29 +0800
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
        <JKosina@suse.com>
Subject: [PATCH net v4 1/2] net: sched: fix packet stuck problem for lockless qdisc
Date:   Fri, 16 Apr 2021 09:16:48 +0800
Message-ID: <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
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
1. Test STATE_MISSED before doing spin_trylock().
2. If the first spin_trylock() return false and STATE_MISSED is
   not set before the first spin_trylock(), Set STATE_MISSED and
   retry another spin_trylock() in case other CPU may not see
   STATE_MISSED after it releases the lock.
3. reschedule if STATE_MISSED is set after the lock is released
   at the end of qdisc_run_end().

For tx_action case, STATE_MISSED is also set when cpu1 is at the
end if qdisc_run_end(), so tx_action will be rescheduled again
to dequeue the skb enqueued by cpu2.

Clear STATE_MISSED before retrying a dequeuing when dequeuing
returns NULL in order to reduce the overhead of the above double
spin_trylock() and __netif_schedule() calling.

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
 include/net/sch_generic.h | 37 ++++++++++++++++++++++++++++++++++++-
 net/sched/sch_generic.c   | 12 ++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f7a6e14..b85b8ea 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -36,6 +36,7 @@ struct qdisc_rate_table {
 enum qdisc_state_t {
 	__QDISC_STATE_SCHED,
 	__QDISC_STATE_DEACTIVATED,
+	__QDISC_STATE_MISSED,
 };
 
 struct qdisc_size_table {
@@ -159,8 +160,37 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK) {
+		bool dont_retry = test_bit(__QDISC_STATE_MISSED,
+					   &qdisc->state);
+
+		if (spin_trylock(&qdisc->seqlock))
+			goto nolock_empty;
+
+		/* If the flag is set before doing the spin_trylock() and
+		 * the above spin_trylock() return false, it means other cpu
+		 * holding the lock will do dequeuing for us, or it wil see
+		 * the flag set after releasing lock and reschedule the
+		 * net_tx_action() to do the dequeuing.
+		 */
+		if (dont_retry)
+			return false;
+
+		/* We could do set_bit() before the first spin_trylock(),
+		 * and avoid doing second spin_trylock() completely, then
+		 * we could have multi cpus doing the set_bit(). Here use
+		 * dont_retry to avoid doing the set_bit() and the second
+		 * spin_trylock(), which has 5% performance improvement than
+		 * doing the set_bit() before the first spin_trylock().
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
@@ -176,8 +206,13 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
 	write_seqcount_end(&qdisc->running);
-	if (qdisc->flags & TCQ_F_NOLOCK)
+	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
+
+		if (unlikely(test_bit(__QDISC_STATE_MISSED,
+				      &qdisc->state)))
+			__netif_schedule(qdisc);
+	}
 }
 
 static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 44991ea..9bc73ea 100644
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
 
@@ -652,6 +654,16 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
 	}
 	if (likely(skb)) {
 		qdisc_update_stats_at_dequeue(qdisc, skb);
+	} else if (need_retry &&
+		   test_and_clear_bit(__QDISC_STATE_MISSED,
+				      &qdisc->state)) {
+		/* do another dequeuing after clearing the flag to
+		 * avoid calling __netif_schedule().
+		 */
+		smp_mb__after_atomic();
+		need_retry = false;
+
+		goto retry;
 	} else {
 		WRITE_ONCE(qdisc->empty, true);
 	}
-- 
2.7.4

