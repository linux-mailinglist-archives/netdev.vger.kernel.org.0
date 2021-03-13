Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B17339B62
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhCMCrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:47:22 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13157 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhCMCrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 21:47:11 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dy6Ts6x7szlV4k;
        Sat, 13 Mar 2021 10:44:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 13 Mar 2021 10:47:05 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andriin@fb.com>,
        <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH RFC] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
Date:   Sat, 13 Mar 2021 10:47:47 +0800
Message-ID: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
flag set, but queue discipline by-pass does not work for lockless
qdisc because skb is always enqueued to qdisc even when the qdisc
is empty, see __dev_xmit_skb().

This patch calles sch_direct_xmit() to transmit the skb directly
to the driver for empty lockless qdisc too, which aviod enqueuing
and dequeuing operation. qdisc->empty is set to false whenever a
skb is enqueued, and is set to true when skb dequeuing return NULL,
see pfifo_fast_dequeue().

Also, qdisc is scheduled at the end of qdisc_run_end() when q->empty
is false to avoid packet stuck problem.

The performance for ip_forward test increases about 10% with this
patch.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/sch_generic.h |  7 +++++--
 net/core/dev.c            | 11 +++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 2d6eb60..6591356 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -161,7 +161,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		if (!spin_trylock(&qdisc->seqlock))
 			return false;
-		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
@@ -176,8 +175,12 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
 	write_seqcount_end(&qdisc->running);
-	if (qdisc->flags & TCQ_F_NOLOCK)
+	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
+
+		if (unlikely(!READ_ONCE(qdisc->empty)))
+			__netif_schedule(qdisc);
+	}
 }
 
 static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
diff --git a/net/core/dev.c b/net/core/dev.c
index 2bfdd52..fa8504d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3791,7 +3791,18 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
+		if (q->flags & TCQ_F_CAN_BYPASS && READ_ONCE(q->empty) && qdisc_run_begin(q)) {
+			qdisc_bstats_cpu_update(q, skb);
+
+			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) && !READ_ONCE(q->empty))
+				__qdisc_run(q);
+
+			qdisc_run_end(q);
+			return NET_XMIT_SUCCESS;
+		}
+
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		WRITE_ONCE(q->empty, false);
 		qdisc_run(q);
 
 		if (unlikely(to_free))
-- 
2.7.4

