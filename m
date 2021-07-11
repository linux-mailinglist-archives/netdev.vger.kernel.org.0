Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A433C3AA8
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 07:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhGKFDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 01:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhGKFDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 01:03:01 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1064BC0613DD
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 22:00:15 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y17so14482098pgf.12
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 22:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/YrxSl2tp9RWF+ZcjOCmhzeXts8i9KqtNHczK7Iknc=;
        b=VcUihxtBee+rfMhfi8PRjeiq3sp/jZxEMC+PMo86bHOchp/daCxFV2lByRxk3rDOwD
         Ys9cuFWXhQE0DM2TTNracGZjWfIAFfPHsloQO0eonqYVtTjrgE+eKu9u6sgc0T3orWWn
         HKG14Ipyi+TPvm5/X+pMhvSD7ZJR7ArJdAvFj5hDmYz0ESGRjqUf0zsw0TKRW/NbuA33
         YqPGvVguGgEVKIWSY666mZim5C80vlrUjscceGCRwUiIC+Wt/ZsOXwPoRJ7S1GeZ2je/
         Q1wTKeajIT7GJsi4ESBRuolNPxYNrfgUDW42wWe04WP8/1Vn0mlJzRm2nGICf5eH/q7H
         UnWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/YrxSl2tp9RWF+ZcjOCmhzeXts8i9KqtNHczK7Iknc=;
        b=D4PKA6Y+q7LAea6y+N2x7RFgnr0tV0f+puBR2ab7CaEeyLVCzuADJBSYGqg3C+ItVX
         CuOi73fmQHK/leJMSpoqGVmamAqmYL0VORc6cum3Y2ISsVhScnQZbdgyat/cWU5MbNOi
         eEedvUdygPMDIOUiT0qxvk0fHc30wzqSTSJDSK3Bb9k3Yi7DNfHTrhIZvteVloYPZUgq
         eJ8hREzX3P0eBY8eJzT68vWbQlWrjHtNwo+Vr28Bduel6seYuKXhF1qZ4BM5kMIcNEaC
         qM/P/IYwKvdqAoA9OIpbBZdgVuNksyTfw9MuRKUFfqc+HcU0qXbf00T27MZQ+Av8uHDx
         lbzg==
X-Gm-Message-State: AOAM5302FIkBinD2zSOlMNwfe4cCv+qse2mednhOFBmPsmHxBQN6lVwF
        IAeblnW9+2mxBsvn/2tGzio=
X-Google-Smtp-Source: ABdhPJwLBa+JNnSNWLhH7GuUi3MOV8GOJPCLn5L5mdkCuRcfiI2/0lg20LAfJIFrSYpaCwew0llalA==
X-Received: by 2002:a63:582:: with SMTP id 124mr46493859pgf.299.1625979614677;
        Sat, 10 Jul 2021 22:00:14 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.99])
        by smtp.gmail.com with ESMTPSA id u37sm11147448pfg.140.2021.07.10.22.00.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jul 2021 22:00:14 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     xiyou.wangcong@gmail.com, jhs@mojatatu.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net-next 1/2] qdisc: add tracepoint qdisc:qdisc_enqueue for enqueued SKBs
Date:   Sun, 11 Jul 2021 13:00:06 +0800
Message-Id: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This tracepoint can work with qdisc:qdisc_dequeue to measure
packets latency in qdisc queue. In some case, for example,
if TX queues are stopped or frozen, sch_direct_xmit will invoke
the dev_requeue_skb to requeue SKBs to qdisc->gso_skb, that may
delay the SKBs in qdisc queue.

With this patch, we can measure packets latency.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/net/pkt_sched.h      |  4 ++++
 include/trace/events/qdisc.h | 32 ++++++++++++++++++++++++++++++++
 net/core/dev.c               |  4 ++--
 net/sched/sch_generic.c      | 11 +++++++++++
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6d7b12cba015..66411b4ff284 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -133,6 +133,10 @@ static inline void qdisc_run(struct Qdisc *q)
 	}
 }
 
+int qdisc_enqueue_skb(struct netdev_queue *txq, struct Qdisc *q,
+		      struct sk_buff *skb,
+		      struct sk_buff **to_free);
+
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 330d32d84485..b0e76237bb74 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -11,6 +11,38 @@
 #include <linux/pkt_sched.h>
 #include <net/sch_generic.h>
 
+TRACE_EVENT(qdisc_enqueue,
+
+	TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq,
+		 struct sk_buff *skb, int ret),
+
+	TP_ARGS(qdisc, txq, skb, ret),
+
+	TP_STRUCT__entry(
+		__field(	struct Qdisc *,		qdisc	)
+		__field(const	struct netdev_queue *,	txq	)
+		__field(	void *,			skbaddr	)
+		__field(	int,			ifindex	)
+		__field(	u32,			handle	)
+		__field(	u32,			parent	)
+		__field(	int,			ret	)
+	),
+
+	TP_fast_assign(
+		__entry->qdisc		= qdisc;
+		__entry->txq		= txq;
+		__entry->skbaddr	= skb;
+		__entry->ifindex	= txq->dev ? txq->dev->ifindex : 0;
+		__entry->handle		= qdisc->handle;
+		__entry->parent		= qdisc->parent;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%p ret=%d",
+		  __entry->ifindex, __entry->handle, __entry->parent,
+		  __entry->skbaddr, __entry->ret)
+);
+
 TRACE_EVENT(qdisc_dequeue,
 
 	TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq,
diff --git a/net/core/dev.c b/net/core/dev.c
index 50531a2d0b20..78efac6b2e60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3852,7 +3852,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = qdisc_enqueue_skb(txq, q, skb, &to_free);
 		if (likely(!netif_xmit_frozen_or_stopped(txq)))
 			qdisc_run(q);
 
@@ -3896,7 +3896,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = qdisc_enqueue_skb(txq, q, skb, &to_free);
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index e9c0afc8becc..75605075178f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -415,6 +415,17 @@ void __qdisc_run(struct Qdisc *q)
 	}
 }
 
+int qdisc_enqueue_skb(struct netdev_queue *txq, struct Qdisc *q,
+		      struct sk_buff *skb,
+		      struct sk_buff **to_free)
+{
+	int ret;
+
+	ret = q->enqueue(skb, q, to_free) & NET_XMIT_MASK;
+	trace_qdisc_enqueue(q, txq, skb, ret);
+	return ret;
+}
+
 unsigned long dev_trans_start(struct net_device *dev)
 {
 	unsigned long val, res;
-- 
2.27.0

