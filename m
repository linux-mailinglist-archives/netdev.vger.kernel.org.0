Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2675F33FFEF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCRGxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 02:53:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14372 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCRGwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 02:52:50 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F1HjV335mz8yLk;
        Thu, 18 Mar 2021 14:50:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Mar 2021 14:52:42 +0800
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
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>
Subject: [PATCH net] net: sched: fix packet stuck problem for lockless qdisc
Date:   Thu, 18 Mar 2021 14:53:22 +0800
Message-ID: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lockless qdisc has below concurrent problem:
        cpu0                  cpu1
          .                     .
     q->enqueue                 .
          .                     .
   qdisc_run_begin()            .
          .                     .
     dequeue_skb()              .
          .                     .
   sch_direct_xmit()            .
          .                     .
          .                q->enqueue
          .             qdisc_run_begin()
          .            return and do nothing
          .                     .
qdisc_run_end()                 .

cpu1 enqueue a skb without calling __qdisc_run() because cpu0
has not released the lock yet and spin_trylock() return false
for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
enqueued by cpu1 when calling dequeue_skb() because cpu1 may
enqueue the skb after cpu0 calling dequeue_skb() and before
cpu0 calling qdisc_run_end().

Lockless qdisc has another concurrent problem when tx_action
is involved:

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
clear __QDISC_STATE_SCHED     .                .
    qdisc_run_begin()         .                .
return and do nothing         .                .
          .                   .                .
          .          qdisc_run_begin()         .

This patch fixes the above data race by:
1. Set a flag after spin_trylock() return false.
2. Retry a spin_trylock() in case other CPU may not see the
   new flag after it releases the lock.
3. reschedule if the flag is set after the lock is released
   at the end of qdisc_run_end().

For tx_action case, the flags is also set when cpu1 is at the
end if qdisc_run_begin(), so tx_action will be rescheduled
again to dequeue the skb enqueued by cpu2.

Also clear the flag before dequeuing in order to reduce the
overhead of the above process, and aviod doing the heavy
test_and_clear_bit() at the end of qdisc_run_end().

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
For those who has not been following the qdsic scheduling
discussion, there is packet stuck problem for lockless qdisc,
see [1], and I has done some cleanup and added some enhanced
features too, see [2] [3].
While I was doing the optimization for lockless qdisc, it
accurred to me that these optimization is useless if there is
still basic bug in lockless qdisc, even the bug is not easily
reproducible. So look through [1] again, I found that the data
race for tx action mentioned by Michael, and thought deep about
it and came up with this patch trying to fix it.

So I am really appreciated some who still has the reproducer
can try this patch and report back.

1. https://lore.kernel.org/netdev/d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com/t/#ma7013a79b8c4d8e7c49015c724e481e6d5325b32
2. https://patchwork.kernel.org/project/netdevbpf/patch/1615777818-13969-1-git-send-email-linyunsheng@huawei.com/
3. https://patchwork.kernel.org/project/netdevbpf/patch/1615800610-34700-1-git-send-email-linyunsheng@huawei.com/
---
 include/net/sch_generic.h | 23 ++++++++++++++++++++---
 net/sched/sch_generic.c   |  1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f7a6e14..4220eab 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -36,6 +36,7 @@ struct qdisc_rate_table {
 enum qdisc_state_t {
 	__QDISC_STATE_SCHED,
 	__QDISC_STATE_DEACTIVATED,
+	__QDISC_STATE_NEED_RESCHEDULE,
 };
 
 struct qdisc_size_table {
@@ -159,8 +160,17 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK) {
-		if (!spin_trylock(&qdisc->seqlock))
-			return false;
+		if (!spin_trylock(&qdisc->seqlock)) {
+			set_bit(__QDISC_STATE_NEED_RESCHEDULE,
+				&qdisc->state);
+
+			/* Retry again in case other CPU may not see the
+			 * new flags after it releases the lock at the
+			 * end of qdisc_run_end().
+			 */
+			if (!spin_trylock(&qdisc->seqlock))
+				return false;
+		}
 		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
@@ -176,8 +186,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
 	write_seqcount_end(&qdisc->running);
-	if (qdisc->flags & TCQ_F_NOLOCK)
+	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
+
+		if (unlikely(test_bit(__QDISC_STATE_NEED_RESCHEDULE,
+				      &qdisc->state) &&
+			     !test_bit(__QDISC_STATE_DEACTIVATED,
+				       &qdisc->state)))
+			__netif_schedule(qdisc);
+	}
 }
 
 static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 44991ea..25d75d8 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -205,6 +205,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	const struct netdev_queue *txq = q->dev_queue;
 	struct sk_buff *skb = NULL;
 
+	clear_bit(__QDISC_STATE_NEED_RESCHEDULE, &q->state);
 	*packets = 1;
 	if (unlikely(!skb_queue_empty(&q->gso_skb))) {
 		spinlock_t *lock = NULL;
-- 
2.7.4

