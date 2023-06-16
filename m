Return-Path: <netdev+bounces-11623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E96EE733B94
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 23:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54041C21051
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB9D6ADE;
	Fri, 16 Jun 2023 21:32:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765A76FA8
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 21:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C323C433C8;
	Fri, 16 Jun 2023 21:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686951161;
	bh=5A8TEdQydFsgpK/InfHKq0kXeC+ZloLwWmUOoX1sFGY=;
	h=From:To:Cc:Subject:Date:From;
	b=XW9JBdQ3RlS2+pvro2sC28BUCPYnc7JTyKcFYub+lb83PRWHdGabaW9h+igkOqIcn
	 eqs41nHI6nspbCzRO5Xu2bSigNT9h6o59Sk7nJgM73WH46KcUELQ1htVMPolYnyqW5
	 lfK2nXI/+8Xvr+TbYPKS0m9zac06h5JQEnwOu89IWqhtrWrPeO/hvDQSazxtgGRpsi
	 ELNQ48Wl/DQkEI6Z+Xzsny/2N1YLh2lE0zN1FMZS1mBAlkx7n4RBiPKX1Cy4h8PE9y
	 gJd1NXxkv7J+1sx4TawK+PIp49c8u2SPDzq6jD48g/V3R0ezwvqL0fMYAtNpy4FGwp
	 pr4hOml4PT2xg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dqs: add NIC stall detector based on BQL
Date: Fri, 16 Jun 2023 14:32:36 -0700
Message-Id: <20230616213236.2379935-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

softnet_data->time_squeeze is sometimes used as a proxy for
host overload or indication of scheduling problems. In practice
this statistic is very noisy and has hard to grasp units -
e.g. is 10 squeezes a second to be expected, or high?

Delaying network (NAPI) processing leads to drops on NIC queues
but also RTT bloat, impacting pacing and CA decisions.
Stalls are a little hard to detect on the Rx side, because
there may simply have not been any packets received in given
period of time. Packet timestamps help a little bit, but
again we don't know if packets are stale because we're
not keeping up or because someone (*cough* cgroups)
disabled IRQs for a long time.

We can, however, use Tx as a proxy for Rx stalls. Most drivers
use combined Rx+Tx NAPIs so if Tx gets starved so will Rx.
On the Tx side we know exactly when packets get queued,
and completed, so there is no uncertainty.

This patch adds stall checks to BQL. Why BQL? Because
it's a convenient place to add such checks, already
called by most drivers, and it has copious free space
in its structures (this patch adds no extra cache
references or dirtying to the fast path).

The algorithm takes one parameter - max delay AKA stall
threshold and increments a counter whenever NAPI got delayed
for at least that amount of time. It also records the length
of the longest stall.

To be precise every time NAPI has not polled for at least
stall thrs we check if there were any Tx packets queued
between last NAPI run and now - stall_thrs/2.

Unlike the classic Tx watchdog this mechanism does not
ignore stalls caused by Tx being disabled, or loss of link.
I don't think the check is worth the complexity, and
stall is a stall, whether due to host overload, flow
control, link down... doesn't matter much to the application.

We have been running this detector in production at Meta
for 2 years, with the threshold of 8ms. It's the lowest
value where false positives become rare. There's still
a constant stream of reported stalls (especially without
the ksoftirqd deferral patches reverted), those who like
their stall metrics to be 0 may prefer higher value.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
I have mixed confidence on this one, but as I said we've
been using this for 2 years, and I find the metric fairly
meaningful. So I figured I'd post it and get some feedback.
---
 .../ABI/testing/sysfs-class-net-queues        | 23 +++++++
 include/linux/dynamic_queue_limits.h          | 34 ++++++++++
 include/trace/events/napi.h                   | 33 ++++++++++
 lib/dynamic_queue_limits.c                    | 57 +++++++++++++++++
 net/core/net-sysfs.c                          | 63 +++++++++++++++++++
 5 files changed, 210 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-queues b/Documentation/ABI/testing/sysfs-class-net-queues
index 978b76358661..cdf673452d01 100644
--- a/Documentation/ABI/testing/sysfs-class-net-queues
+++ b/Documentation/ABI/testing/sysfs-class-net-queues
@@ -96,3 +96,26 @@ Contact:	netdev@vger.kernel.org
 		Indicates the absolute minimum limit of bytes allowed to be
 		queued on this network device transmit queue. Default value is
 		0.
+
+What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/stall_thrs
+Date:		June 2023
+KernelVersion:	6.5
+Contact:	netdev@vger.kernel.org
+Description:
+		Tx completion stall detection threshold. Kernel will guarantee
+		to detect all stalls longer than this threshold but may also
+		detect stalls longer than half of the threshold.
+
+What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/stall_cnt
+Date:		June 2023
+KernelVersion:	6.5
+Contact:	netdev@vger.kernel.org
+Description:
+		Number of detected Tx completion stalls.
+
+What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/stall_max
+Date:		June 2023
+KernelVersion:	6.5
+Contact:	netdev@vger.kernel.org
+Description:
+		Longest detected Tx completion stall. Write 0 to clear.
diff --git a/include/linux/dynamic_queue_limits.h b/include/linux/dynamic_queue_limits.h
index 407c2f281b64..4529e59f8388 100644
--- a/include/linux/dynamic_queue_limits.h
+++ b/include/linux/dynamic_queue_limits.h
@@ -38,14 +38,21 @@
 
 #ifdef __KERNEL__
 
+#include <asm/bitops.h>
 #include <asm/bug.h>
 
+#define DQL_HIST_LEN		4
+#define DQL_HIST_ENT(dql, idx)	((dql)->history[(idx) % DQL_HIST_LEN])
+
 struct dql {
 	/* Fields accessed in enqueue path (dql_queued) */
 	unsigned int	num_queued;		/* Total ever queued */
 	unsigned int	adj_limit;		/* limit + num_completed */
 	unsigned int	last_obj_cnt;		/* Count at last queuing */
 
+	unsigned long	history_head;
+	unsigned long	history[DQL_HIST_LEN];
+
 	/* Fields accessed only by completion path (dql_completed) */
 
 	unsigned int	limit ____cacheline_aligned_in_smp; /* Current limit */
@@ -62,6 +69,11 @@ struct dql {
 	unsigned int	max_limit;		/* Max limit */
 	unsigned int	min_limit;		/* Minimum limit */
 	unsigned int	slack_hold_time;	/* Time to measure slack */
+
+	unsigned char	stall_thrs;
+	unsigned char	stall_max;
+	unsigned long	last_reap;
+	unsigned long	stall_cnt;
 };
 
 /* Set some static maximums */
@@ -74,6 +86,8 @@ struct dql {
  */
 static inline void dql_queued(struct dql *dql, unsigned int count)
 {
+	unsigned long map, now, now_hi, i;
+
 	BUG_ON(count > DQL_MAX_OBJECT);
 
 	dql->last_obj_cnt = count;
@@ -86,6 +100,26 @@ static inline void dql_queued(struct dql *dql, unsigned int count)
 	barrier();
 
 	dql->num_queued += count;
+
+	now = jiffies;
+	now_hi = now / BITS_PER_LONG;
+	if (unlikely(now_hi != dql->history_head)) {
+		/* About to reuse slots, clear them */
+		for (i = 0; i < DQL_HIST_LEN; i++) {
+			/* Multiplication masks high bits */
+			if (now_hi * BITS_PER_LONG ==
+			    (dql->history_head + i) * BITS_PER_LONG)
+				break;
+			DQL_HIST_ENT(dql, dql->history_head + i + 1) = 0;
+		}
+		smp_wmb();
+		WRITE_ONCE(dql->history_head, now_hi);
+	}
+
+	/* __set_bit() does not guarantee WRITE_ONCE() semantics */
+	map = DQL_HIST_ENT(dql, now_hi);
+	if (!(map & BIT_MASK(now)))
+		WRITE_ONCE(DQL_HIST_ENT(dql, now_hi), map | BIT_MASK(now));
 }
 
 /* Returns how many objects can be queued, < 0 indicates over limit. */
diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index 6678cf8b235b..272112ddaaa8 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -36,6 +36,39 @@ TRACE_EVENT(napi_poll,
 		  __entry->work, __entry->budget)
 );
 
+TRACE_EVENT(dql_stall_detected,
+
+	TP_PROTO(unsigned int thrs, unsigned int len,
+		 unsigned long last_reap, unsigned long hist_head,
+		 unsigned long now, unsigned long *hist),
+
+	TP_ARGS(thrs, len, last_reap, hist_head, now, hist),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,		thrs)
+		__field(	unsigned int,		len)
+		__field(	unsigned long,		last_reap)
+		__field(	unsigned long,		hist_head)
+		__field(	unsigned long,		now)
+		__array(	unsigned long,		hist, 4)
+	),
+
+	TP_fast_assign(
+		__entry->thrs = thrs;
+		__entry->len = len;
+		__entry->last_reap = last_reap;
+		__entry->hist_head = hist_head * BITS_PER_LONG;
+		__entry->now = now;
+		memcpy(__entry->hist, hist, sizeof(entry->hist));
+	),
+
+	TP_printk("thrs %u  len %u  last_reap %lu  hist_head %lu  now %lu  hist %016lx %016lx %016lx %016lx",
+		  __entry->thrs, __entry->len,
+		  __entry->last_reap, __entry->hist_head, __entry->now,
+		  __entry->hist[0], __entry->hist[1],
+		  __entry->hist[2], __entry->hist[3])
+);
+
 #undef NO_DEV
 
 #endif /* _TRACE_NAPI_H */
diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index fde0aa244148..833052479d0e 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -10,10 +10,60 @@
 #include <linux/dynamic_queue_limits.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
+#include <trace/events/napi.h>
 
 #define POSDIFF(A, B) ((int)((A) - (B)) > 0 ? (A) - (B) : 0)
 #define AFTER_EQ(A, B) ((int)((A) - (B)) >= 0)
 
+void dql_check_stall(struct dql *dql)
+{
+	unsigned long stall_thrs, now;
+
+	/* If we detect a stall see if anything was queued */
+	stall_thrs = READ_ONCE(dql->stall_thrs);
+	if (!stall_thrs)
+		return;
+
+	now = jiffies;
+	if (time_after_eq(now, dql->last_reap + stall_thrs)) {
+		unsigned long hist_head, t, start, end;
+
+		/* We are trying to detect a period of at least @stall_thrs
+		 * jiffies without any Tx completions, but during first half
+		 * of which some Tx was posted.
+		 */
+dqs_again:
+		hist_head = READ_ONCE(dql->history_head);
+		smp_rmb();
+		/* oldest sample since last reap */
+		start = (hist_head - DQL_HIST_LEN + 1) * BITS_PER_LONG;
+		if (time_before(start, dql->last_reap + 1))
+			start = dql->last_reap + 1;
+		/* newest sample we should have already seen a completion for */
+		end = hist_head * BITS_PER_LONG + (BITS_PER_LONG - 1);
+		if (time_before(now, end + stall_thrs / 2))
+			end = now - stall_thrs / 2;
+
+		for (t = start; time_before_eq(t, end); t++)
+			if (test_bit(t % (DQL_HIST_LEN * BITS_PER_LONG),
+				     dql->history))
+				break;
+		if (!time_before_eq(t, end))
+			goto no_stall;
+		if (hist_head != READ_ONCE(dql->history_head))
+			goto dqs_again;
+
+		dql->stall_cnt++;
+		dql->stall_max = max_t(unsigned int, dql->stall_max, now - t);
+
+		trace_dql_stall_detected(dql->stall_thrs, now - t,
+					 dql->last_reap, dql->history_head,
+					 now, dql->history);
+	}
+no_stall:
+	dql->last_reap = now;
+}
+
 /* Records completed count and recalculates the queue limit */
 void dql_completed(struct dql *dql, unsigned int count)
 {
@@ -110,6 +160,8 @@ void dql_completed(struct dql *dql, unsigned int count)
 	dql->prev_last_obj_cnt = dql->last_obj_cnt;
 	dql->num_completed = completed;
 	dql->prev_num_queued = num_queued;
+
+	dql_check_stall(dql);
 }
 EXPORT_SYMBOL(dql_completed);
 
@@ -125,6 +177,10 @@ void dql_reset(struct dql *dql)
 	dql->prev_ovlimit = 0;
 	dql->lowest_slack = UINT_MAX;
 	dql->slack_start_time = jiffies;
+
+	dql->last_reap = jiffies;
+	dql->history_head = jiffies / BITS_PER_LONG;
+	memset(dql->history, 0, sizeof(dql->history));
 }
 EXPORT_SYMBOL(dql_reset);
 
@@ -133,6 +189,7 @@ void dql_init(struct dql *dql, unsigned int hold_time)
 	dql->max_limit = DQL_MAX_LIMIT;
 	dql->min_limit = 0;
 	dql->slack_hold_time = hold_time;
+	dql->stall_thrs = 0;
 	dql_reset(dql);
 }
 EXPORT_SYMBOL(dql_init);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 15e3f4606b5f..f5c3fb92e0d9 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1397,6 +1397,66 @@ static struct netdev_queue_attribute bql_hold_time_attribute __ro_after_init
 	= __ATTR(hold_time, 0644,
 		 bql_show_hold_time, bql_set_hold_time);
 
+static ssize_t bql_show_stall_thrs(struct netdev_queue *queue, char *buf)
+{
+	struct dql *dql = &queue->dql;
+
+	return sprintf(buf, "%u\n", jiffies_to_msecs(dql->stall_thrs));
+}
+
+static ssize_t bql_set_stall_thrs(struct netdev_queue *queue,
+				  const char *buf, size_t len)
+{
+	struct dql *dql = &queue->dql;
+	unsigned int value;
+	int err;
+
+	err = kstrtouint(buf, 10, &value);
+	if (err < 0)
+		return err;
+
+	value = msecs_to_jiffies(value);
+	if (value && (value < 4 || value > 4 / 2 * BITS_PER_LONG))
+		return -ERANGE;
+
+	if (!dql->stall_thrs && value)
+		dql->last_reap = jiffies;
+	smp_wmb();
+	dql->stall_thrs = value;
+
+	return len;
+}
+
+static struct netdev_queue_attribute bql_stall_thrs_attribute __ro_after_init
+	= __ATTR(stall_thrs, 0644,
+		 bql_show_stall_thrs, bql_set_stall_thrs);
+
+static ssize_t bql_show_stall_max(struct netdev_queue *queue, char *buf)
+{
+	return sprintf(buf, "%u\n", READ_ONCE(queue->dql.stall_max));
+}
+
+static ssize_t bql_set_stall_max(struct netdev_queue *queue,
+				 const char *buf, size_t len)
+{
+	WRITE_ONCE(queue->dql.stall_max, 0);
+	return len;
+}
+
+static struct netdev_queue_attribute bql_stall_max_attribute __ro_after_init
+	= __ATTR(stall_max, 0644,
+		 bql_show_stall_max, bql_set_stall_max);
+
+static ssize_t bql_show_stall_cnt(struct netdev_queue *queue, char *buf)
+{
+	struct dql *dql = &queue->dql;
+
+	return sprintf(buf, "%lu\n", dql->stall_cnt);
+}
+
+static struct netdev_queue_attribute bql_stall_cnt_attribute __ro_after_init
+	= __ATTR(stall_cnt, 0444, bql_show_stall_cnt, NULL);
+
 static ssize_t bql_show_inflight(struct netdev_queue *queue,
 				 char *buf)
 {
@@ -1435,6 +1495,9 @@ static struct attribute *dql_attrs[] __ro_after_init = {
 	&bql_limit_min_attribute.attr,
 	&bql_hold_time_attribute.attr,
 	&bql_inflight_attribute.attr,
+	&bql_stall_thrs_attribute.attr,
+	&bql_stall_cnt_attribute.attr,
+	&bql_stall_max_attribute.attr,
 	NULL
 };
 
-- 
2.40.1


