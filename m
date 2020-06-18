Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDC71FFA4B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgFRRbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:31:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42321 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726899AbgFRRbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592501500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oLkqGLLdDLRrDn/1stSrBNuTT9sGLYr7euvY1J93qF8=;
        b=Vzcfku9xDTu7q32DzjAauSSZkm1pawAFhlZF5OrW/nsezapbOBUK7JRNBBUfEgqI1slllG
        hdjLTGffDkE+et9WH8NLKHz8wMkaPF2KSfB5UaZq630synQqZ3BMTSVCH/KL4RwsSPU47d
        +zaqLMUWRDQsSkoBDgHNKa6SnNAdxsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-aqE9C9hqP-y8iM24H0j4DA-1; Thu, 18 Jun 2020 13:31:37 -0400
X-MC-Unique: aqE9C9hqP-y8iM24H0j4DA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CECF48005AD;
        Thu, 18 Jun 2020 17:31:36 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-36.ams2.redhat.com [10.36.115.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E37660E3E;
        Thu, 18 Jun 2020 17:31:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH] net/sched: add indirect call wrapper hint.
Date:   Thu, 18 Jun 2020 19:31:02 +0200
Message-Id: <da175b76ca89e57876cf55d3d56aef126054d12c.1592501362.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sched layer can use several indirect calls per
packet, with not work-conservative qdisc being
more affected due to the lack of the BYPASS path.

This change tries to improve the situation using
the indirect call wrappers infrastructure for the
qdisc enqueue end dequeue indirect calls.

To cope with non-trivial scenarios, a compile-time know is
introduced, so that the qdisc used by ICW can be different
from the default one.

Tested with pktgen over qdisc, with CONFIG_HINT_FQ_CODEL=y:

qdisc		threads vanilla	patched delta
		nr	Kpps	Kpps	%
pfifo_fast	1	3300	3700	12
pfifo_fast	2	3940	4070	3
fq_codel	1	3840	4110	7
fq_codel	2	1920	2260	17
fq		1	2230	2210	-1
fq		2	1530	1540	1

In the first 4 test-cases the sch hint kicks-in and we observe
measurable gain. The last 2 tests show scenarios where ICW
does not avoid the indirect calls and just add more branches:
deltas are within noise range.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sch_hint.h   | 51 ++++++++++++++++++++++++++++++++++++++++
 net/core/dev.c           |  5 ++--
 net/sched/Kconfig        | 33 ++++++++++++++++++++++++++
 net/sched/sch_codel.c    | 10 +++++---
 net/sched/sch_fq.c       | 11 ++++++---
 net/sched/sch_fq_codel.c | 11 ++++++---
 net/sched/sch_generic.c  | 14 +++++++----
 net/sched/sch_sfq.c      | 10 +++++---
 8 files changed, 126 insertions(+), 19 deletions(-)
 create mode 100644 include/net/sch_hint.h

diff --git a/include/net/sch_hint.h b/include/net/sch_hint.h
new file mode 100644
index 000000000000..d7ede93d01f7
--- /dev/null
+++ b/include/net/sch_hint.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_SCHED_HINT_H
+#define __NET_SCHED_HINT_H
+
+#include <linux/indirect_call_wrapper.h>
+
+/* pfifo_fast is a bit special: we can use it for the 'nolock' path
+ * regardless of the specified hint
+ */
+INDIRECT_CALLABLE_DECLARE(int pfifo_fast_enqueue(struct sk_buff *skb,
+						struct Qdisc *qdisc,
+						struct sk_buff **to_free));
+
+#define Q_NOLOCK_ENQUEUE(skb, q, to_free) \
+	INDIRECT_CALL_1(q->enqueue, pfifo_fast_enqueue, skb, q, to_free)
+
+#if IS_ENABLED(CONFIG_HINT_FQ_CODEL)
+#define NET_SCHED_ENQUEUE fq_codel_enqueue
+#define NET_SCHED_DEQUEUE fq_codel_dequeue
+#define FQ_CODEL_SCOPE INDIRECT_CALLABLE_SCOPE
+#elif IS_ENABLED(CONFIG_HINT_FQ)
+#define NET_SCHED_ENQUEUE fq_enqueue
+#define NET_SCHED_DEQUEUE fq_dequeue
+#define FQ_SCOPE INDIRECT_CALLABLE_SCOPE
+#elif IS_ENABLED(CONFIG_HINT_CODEL)
+#define NET_SCHED_ENQUEUE codel_enqueue
+#define NET_SCHED_DEQUEUE codel_dequeue
+#define CODEL_SCOPE INDIRECT_CALLABLE_SCOPE
+#elif IS_ENABLED(CONFIG_HINT_CODEL)
+#define NET_SCHED_ENQUEUE sfq_enqueue
+#define NET_SCHED_DEQUEUE sfq_dequeue
+#define SFQ_SCOPE INDIRECT_CALLABLE_SCOPE
+#endif
+
+#if defined(NET_SCHED_DEQUEUE)
+INDIRECT_CALLABLE_DECLARE(int NET_SCHED_ENQUEUE(struct sk_buff *skb,
+						struct Qdisc *qdisc,
+						struct sk_buff **to_free));
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *NET_SCHED_DEQUEUE(struct Qdisc *q));
+
+#define Q_LOCK_ENQUEUE(skb, q, to_free) \
+	INDIRECT_CALL_1(q->enqueue, NET_SCHED_ENQUEUE, skb, q, to_free)
+#define Q_DEQUEUE(q) \
+	INDIRECT_CALL_2(q->dequeue, NET_SCHED_DEQUEUE, pfifo_fast_dequeue, q)
+
+#else
+#define Q_LOCK_ENQUEUE(skb, q, to_free) q->enqueue(skb, q, to_free)
+#define Q_DEQUEUE(q) INDIRECT_CALL_1(q->dequeue, pfifo_fast_dequeue, q)
+#endif
+
+#endif
diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6..064e4a86d502 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -143,6 +143,7 @@
 #include <linux/net_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 #include <net/devlink.h>
+#include <net/sch_hint.h>
 
 #include "net-sysfs.h"
 
@@ -3743,7 +3744,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = Q_NOLOCK_ENQUEUE(skb, q, &to_free) & NET_XMIT_MASK;
 		qdisc_run(q);
 
 		if (unlikely(to_free))
@@ -3786,7 +3787,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = Q_LOCK_ENQUEUE(skb, q, &to_free) & NET_XMIT_MASK;
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 84badf00647e..a86e0ff4de26 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -484,6 +484,39 @@ config DEFAULT_NET_SCH
 	default "pfifo_fast"
 endif
 
+if RETPOLINE
+
+choice
+	prompt "Queuing discipline hint for retpoline"
+	default HINT_PFIFO_FAST if DEFAULT_PFIFO_FAST
+	default HINT_FQ if DEFAULT_FQ && NET_SCH_FQ=y
+	default HINT_FQ_CODEL if DEFAULT_FQ_CODEL && NET_SCH_FQ_CODEL=y
+	default HINT_CODEL if DEFAULT_CODEL && NET_SCH_CODEL=y
+	default HINT_SFQ if DEFAULT_FQ_CODEL && NET_SCH_SFQ=y
+	default HINT_PFIFO_FAST
+	help
+	  Specify the hint used by the queue disciplice to
+	  avoid the retpoline indirect call.
+	  Usually should match the default queue discipline.
+
+	config HINT_FQ_CODEL
+		bool "Fair Queue Controlled Delay" if NET_SCH_FQ_CODEL=y
+
+	config HINT_FQ
+		bool "Fair Queue" if NET_SCH_FQ=y
+
+	config HINT_CODEL
+		bool "Controlled Delay" if NET_SCH_CODEL=y
+
+	config HINT_SFQ
+		bool "Stochastic Fair Queue" if NET_SCH_SFQ=y
+
+	config HINT_PFIFO_FAST
+		bool "Priority FIFO Fast"
+endchoice
+
+endif
+
 comment "Classification"
 
 config NET_CLS
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 30169b3adbbb..d5a79bcc3bd3 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -51,7 +51,11 @@
 #include <net/codel.h>
 #include <net/codel_impl.h>
 #include <net/codel_qdisc.h>
+#include <net/sch_hint.h>
 
+#ifndef CODEL_SCOPE
+#define CODEL_SCOPE static
+#endif
 
 #define DEFAULT_CODEL_LIMIT 1000
 
@@ -86,7 +90,7 @@ static void drop_func(struct sk_buff *skb, void *ctx)
 	qdisc_qstats_drop(sch);
 }
 
-static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
+CODEL_SCOPE struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 {
 	struct codel_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
@@ -108,8 +112,8 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
-static int codel_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-			       struct sk_buff **to_free)
+CODEL_SCOPE int codel_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+				    struct sk_buff **to_free)
 {
 	struct codel_sched_data *q;
 
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 8f06a808c59a..2660e8163a23 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -49,6 +49,11 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/tcp.h>
+#include <net/sch_hint.h>
+
+#ifndef FQ_SCOPE
+#define FQ_SCOPE static
+#endif
 
 struct fq_skb_cb {
 	u64	        time_to_send;
@@ -439,8 +444,8 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
 	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
 }
 
-static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-		      struct sk_buff **to_free)
+FQ_SCOPE int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+			struct sk_buff **to_free)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
 	struct fq_flow *f;
@@ -523,7 +528,7 @@ static void fq_check_throttled(struct fq_sched_data *q, u64 now)
 	}
 }
 
-static struct sk_buff *fq_dequeue(struct Qdisc *sch)
+FQ_SCOPE struct sk_buff *fq_dequeue(struct Qdisc *sch)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
 	struct fq_flow_head *head;
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 436160be9c18..c3fb13527781 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -22,6 +22,11 @@
 #include <net/codel.h>
 #include <net/codel_impl.h>
 #include <net/codel_qdisc.h>
+#include <net/sch_hint.h>
+
+#ifndef FQ_CODEL_SCOPE
+#define FQ_CODEL_SCOPE static
+#endif
 
 /*	Fair Queue CoDel.
  *
@@ -181,8 +186,8 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
 	return idx;
 }
 
-static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-			    struct sk_buff **to_free)
+FQ_CODEL_SCOPE int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+				    struct sk_buff **to_free)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	unsigned int idx, prev_backlog, prev_qlen;
@@ -278,7 +283,7 @@ static void drop_func(struct sk_buff *skb, void *ctx)
 	qdisc_qstats_drop(sch);
 }
 
-static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
+FQ_CODEL_SCOPE struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d011df..1e3685be4975 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -30,6 +30,9 @@
 #include <trace/events/qdisc.h>
 #include <trace/events/net.h>
 #include <net/xfrm.h>
+#include <net/sch_hint.h>
+
+static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc);
 
 /* Qdisc to use by default */
 const struct Qdisc_ops *default_qdisc_ops = &pfifo_fast_ops;
@@ -157,7 +160,7 @@ static void try_bulk_dequeue_skb(struct Qdisc *q,
 	int bytelimit = qdisc_avail_bulklimit(txq) - skb->len;
 
 	while (bytelimit > 0) {
-		struct sk_buff *nskb = q->dequeue(q);
+		struct sk_buff *nskb = Q_DEQUEUE(q);
 
 		if (!nskb)
 			break;
@@ -182,7 +185,7 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
 	int cnt = 0;
 
 	do {
-		nskb = q->dequeue(q);
+		nskb = Q_DEQUEUE(q);
 		if (!nskb)
 			break;
 		if (unlikely(skb_get_queue_mapping(nskb) != mapping)) {
@@ -260,7 +263,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 			return NULL;
 		goto bulk;
 	}
-	skb = q->dequeue(q);
+	skb = Q_DEQUEUE(q);
 	if (skb) {
 bulk:
 		if (qdisc_may_bulk(q))
@@ -614,8 +617,9 @@ static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
 	return &priv->q[band];
 }
 
-static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
-			      struct sk_buff **to_free)
+INDIRECT_CALLABLE_SCOPE int pfifo_fast_enqueue(struct sk_buff *skb,
+					       struct Qdisc *qdisc,
+					       struct sk_buff **to_free)
 {
 	int band = prio2band[skb->priority & TC_PRIO_MAX];
 	struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 5a6def5e4e6d..e120dc2aae72 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -21,6 +21,11 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/red.h>
+#include <net/sch_hint.h>
+
+#ifndef SFQ_SCOPE
+#define SFQ_SCOPE static
+#endif
 
 
 /*	Stochastic Fairness Queuing algorithm.
@@ -342,7 +347,7 @@ static int sfq_headdrop(const struct sfq_sched_data *q)
 	return q->headdrop;
 }
 
-static int
+SFQ_SCOPE int
 sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
@@ -476,8 +481,7 @@ sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 	return NET_XMIT_SUCCESS;
 }
 
-static struct sk_buff *
-sfq_dequeue(struct Qdisc *sch)
+SFQ_SCOPE struct sk_buff *sfq_dequeue(struct Qdisc *sch)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
-- 
2.26.2

