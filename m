Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6907A55A9F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfFYWHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:07:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:34260 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbfFYWHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 18:07:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 15:07:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,417,1557212400"; 
   d="scan'208";a="172511972"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2019 15:07:30 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v6 6/8] taprio: Add support for txtime-assist mode
Date:   Tue, 25 Jun 2019 15:07:17 -0700
Message-Id: <1561500439-30276-7-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
References: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we are seeing non-critical packets being transmitted outside of
their timeslice. We can confirm that the packets are being dequeued at the
right time. So, the delay is induced in the hardware side.  The most likely
reason is the hardware queues are starving the lower priority queues.

In order to improve the performance of taprio, we will be making use of the
txtime feature provided by the ETF qdisc. For all the packets which do not
have the SO_TXTIME option set, taprio will set the transmit timestamp (set
in skb->tstamp) in this mode. TAPrio Qdisc will ensure that the transmit
time for the packet is set to when the gate is open. If SO_TXTIME is set,
the TAPrio qdisc will validate whether the timestamp (in skb->tstamp)
occurs when the gate corresponding to skb's traffic class is open.

Following two parameters added to support this mode:
- flags: used to enable txtime-assist mode. Will also be used to enable
  other modes (like hardware offloading) later.
- txtime-delay: This indicates the minimum time it will take for the packet
  to hit the wire. This is useful in determining whether we can transmit
the packet in the remaining time if the gate corresponding to the packet is
currently open.

An example configuration for enabling txtime-assist:

tc qdisc replace dev eth0 parent root handle 100 taprio \\
      num_tc 3 \\
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
      queues 1@0 1@0 1@0 \\
      base-time 1558653424279842568 \\
      sched-entry S 01 300000 \\
      sched-entry S 02 300000 \\
      sched-entry S 04 400000 \\
      flags 0x1 \\
      txtime-delay 40000 \\
      clockid CLOCK_TAI

tc qdisc replace dev $IFACE parent 100:1 etf skip_sock_check \\
      offload delta 200000 clockid CLOCK_TAI

Note that all the traffic classes are mapped to the same queue.  This is
only possible in taprio when txtime-assist is enabled. Also, note that the
ETF Qdisc is enabled with offload mode set.

In this mode, if the packet's traffic class is open and the complete packet
can be transmitted, taprio will try to transmit the packet immediately.
This will be done by setting skb->tstamp to current_time + the time delta
indicated in the txtime-delay parameter. This parameter indicates the time
taken (in software) for packet to reach the network adapter.

If the packet cannot be transmitted in the current interval or if the
packet's traffic is not currently transmitting, the skb->tstamp is set to
the next available timestamp value. This is tracked in the next_launchtime
parameter in the struct sched_entry.

The behaviour w.r.t admin and oper schedules is not changed from what is
present in software mode.

The transmit time is already known in advance. So, we do not need the HR
timers to advance the schedule and wakeup the dequeue side of taprio.  So,
HR timer won't be run when this mode is enabled.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 include/uapi/linux/pkt_sched.h |   4 +
 net/sched/sch_taprio.c         | 341 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 328 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 127ac6d2888c..390efb54b2e0 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1159,6 +1159,8 @@ enum {
  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
  */
 
+#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST 0x1
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1170,6 +1172,8 @@ enum {
 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
+	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
+	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6ef0cc03fdb9..078230e44471 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -21,12 +21,16 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/sch_generic.h>
+#include <net/sock.h>
 
 static LIST_HEAD(taprio_list);
 static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
+#define FLAGS_VALID(flags) (!((flags) & ~TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))
+#define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
+
 struct sched_entry {
 	struct list_head list;
 
@@ -35,6 +39,7 @@ struct sched_entry {
 	 * packet leaves after this time.
 	 */
 	ktime_t close_time;
+	ktime_t next_txtime;
 	atomic_t budget;
 	int index;
 	u32 gate_mask;
@@ -55,6 +60,7 @@ struct sched_gate_list {
 struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
+	u32 flags;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
@@ -68,6 +74,7 @@ struct taprio_sched {
 	ktime_t (*get_time)(void);
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	int txtime_delay;
 };
 
 static ktime_t sched_base_time(const struct sched_gate_list *sched)
@@ -108,6 +115,227 @@ static void switch_schedules(struct taprio_sched *q,
 	*admin = NULL;
 }
 
+/* Get how much time has been already elapsed in the current cycle. */
+static s32 get_cycle_time_elapsed(struct sched_gate_list *sched, ktime_t time)
+{
+	ktime_t time_since_sched_start;
+	s32 time_elapsed;
+
+	time_since_sched_start = ktime_sub(time, sched->base_time);
+	div_s64_rem(time_since_sched_start, sched->cycle_time, &time_elapsed);
+
+	return time_elapsed;
+}
+
+static ktime_t get_interval_end_time(struct sched_gate_list *sched,
+				     struct sched_gate_list *admin,
+				     struct sched_entry *entry,
+				     ktime_t intv_start)
+{
+	s32 cycle_elapsed = get_cycle_time_elapsed(sched, intv_start);
+	ktime_t intv_end, cycle_ext_end, cycle_end;
+
+	cycle_end = ktime_add_ns(intv_start, sched->cycle_time - cycle_elapsed);
+	intv_end = ktime_add_ns(intv_start, entry->interval);
+	cycle_ext_end = ktime_add(cycle_end, sched->cycle_time_extension);
+
+	if (ktime_before(intv_end, cycle_end))
+		return intv_end;
+	else if (admin && admin != sched &&
+		 ktime_after(admin->base_time, cycle_end) &&
+		 ktime_before(admin->base_time, cycle_ext_end))
+		return admin->base_time;
+	else
+		return cycle_end;
+}
+
+static int length_to_duration(struct taprio_sched *q, int len)
+{
+	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
+}
+
+/* Returns the entry corresponding to next available interval. If
+ * validate_interval is set, it only validates whether the timestamp occurs
+ * when the gate corresponding to the skb's traffic class is open.
+ */
+static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
+						  struct Qdisc *sch,
+						  struct sched_gate_list *sched,
+						  struct sched_gate_list *admin,
+						  ktime_t time,
+						  ktime_t *interval_start,
+						  ktime_t *interval_end,
+						  bool validate_interval)
+{
+	ktime_t curr_intv_start, curr_intv_end, cycle_end, packet_transmit_time;
+	ktime_t earliest_txtime = KTIME_MAX, txtime, cycle, transmit_end_time;
+	struct sched_entry *entry = NULL, *entry_found = NULL;
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	bool entry_available = false;
+	s32 cycle_elapsed;
+	int tc, n;
+
+	tc = netdev_get_prio_tc_map(dev, skb->priority);
+	packet_transmit_time = length_to_duration(q, qdisc_pkt_len(skb));
+
+	*interval_start = 0;
+	*interval_end = 0;
+
+	if (!sched)
+		return NULL;
+
+	cycle = sched->cycle_time;
+	cycle_elapsed = get_cycle_time_elapsed(sched, time);
+	curr_intv_end = ktime_sub_ns(time, cycle_elapsed);
+	cycle_end = ktime_add_ns(curr_intv_end, cycle);
+
+	list_for_each_entry(entry, &sched->entries, list) {
+		curr_intv_start = curr_intv_end;
+		curr_intv_end = get_interval_end_time(sched, admin, entry,
+						      curr_intv_start);
+
+		if (ktime_after(curr_intv_start, cycle_end))
+			break;
+
+		if (!(entry->gate_mask & BIT(tc)) ||
+		    packet_transmit_time > entry->interval)
+			continue;
+
+		txtime = entry->next_txtime;
+
+		if (ktime_before(txtime, time) || validate_interval) {
+			transmit_end_time = ktime_add_ns(time, packet_transmit_time);
+			if ((ktime_before(curr_intv_start, time) &&
+			     ktime_before(transmit_end_time, curr_intv_end)) ||
+			    (ktime_after(curr_intv_start, time) && !validate_interval)) {
+				entry_found = entry;
+				*interval_start = curr_intv_start;
+				*interval_end = curr_intv_end;
+				break;
+			} else if (!entry_available && !validate_interval) {
+				/* Here, we are just trying to find out the
+				 * first available interval in the next cycle.
+				 */
+				entry_available = 1;
+				entry_found = entry;
+				*interval_start = ktime_add_ns(curr_intv_start, cycle);
+				*interval_end = ktime_add_ns(curr_intv_end, cycle);
+			}
+		} else if (ktime_before(txtime, earliest_txtime) &&
+			   !entry_available) {
+			earliest_txtime = txtime;
+			entry_found = entry;
+			n = div_s64(ktime_sub(txtime, curr_intv_start), cycle);
+			*interval_start = ktime_add(curr_intv_start, n * cycle);
+			*interval_end = ktime_add(curr_intv_end, n * cycle);
+		}
+	}
+
+	return entry_found;
+}
+
+static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct sched_gate_list *sched, *admin;
+	ktime_t interval_start, interval_end;
+	struct sched_entry *entry;
+
+	rcu_read_lock();
+	sched = rcu_dereference(q->oper_sched);
+	admin = rcu_dereference(q->admin_sched);
+
+	entry = find_entry_to_transmit(skb, sch, sched, admin, skb->tstamp,
+				       &interval_start, &interval_end, true);
+	rcu_read_unlock();
+
+	return entry;
+}
+
+/* There are a few scenarios where we will have to modify the txtime from
+ * what is read from next_txtime in sched_entry. They are:
+ * 1. If txtime is in the past,
+ *    a. The gate for the traffic class is currently open and packet can be
+ *       transmitted before it closes, schedule the packet right away.
+ *    b. If the gate corresponding to the traffic class is going to open later
+ *       in the cycle, set the txtime of packet to the interval start.
+ * 2. If txtime is in the future, there are packets corresponding to the
+ *    current traffic class waiting to be transmitted. So, the following
+ *    possibilities exist:
+ *    a. We can transmit the packet before the window containing the txtime
+ *       closes.
+ *    b. The window might close before the transmission can be completed
+ *       successfully. So, schedule the packet in the next open window.
+ */
+static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
+{
+	ktime_t transmit_end_time, interval_end, interval_start;
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct sched_gate_list *sched, *admin;
+	ktime_t minimum_time, now, txtime;
+	int len, packet_transmit_time;
+	struct sched_entry *entry;
+	bool sched_changed;
+
+	now = q->get_time();
+	minimum_time = ktime_add_ns(now, q->txtime_delay);
+
+	rcu_read_lock();
+	admin = rcu_dereference(q->admin_sched);
+	sched = rcu_dereference(q->oper_sched);
+	if (admin && ktime_after(minimum_time, admin->base_time))
+		switch_schedules(q, &admin, &sched);
+
+	/* Until the schedule starts, all the queues are open */
+	if (!sched || ktime_before(minimum_time, sched->base_time)) {
+		txtime = minimum_time;
+		goto done;
+	}
+
+	len = qdisc_pkt_len(skb);
+	packet_transmit_time = length_to_duration(q, len);
+
+	do {
+		sched_changed = 0;
+
+		entry = find_entry_to_transmit(skb, sch, sched, admin,
+					       minimum_time,
+					       &interval_start, &interval_end,
+					       false);
+		if (!entry) {
+			txtime = 0;
+			goto done;
+		}
+
+		txtime = entry->next_txtime;
+		txtime = max_t(ktime_t, txtime, minimum_time);
+		txtime = max_t(ktime_t, txtime, interval_start);
+
+		if (admin && admin != sched &&
+		    ktime_after(txtime, admin->base_time)) {
+			sched = admin;
+			sched_changed = 1;
+			continue;
+		}
+
+		transmit_end_time = ktime_add(txtime, packet_transmit_time);
+		minimum_time = transmit_end_time;
+
+		/* Update the txtime of current entry to the next time it's
+		 * interval starts.
+		 */
+		if (ktime_after(transmit_end_time, interval_end))
+			entry->next_txtime = ktime_add(interval_start, sched->cycle_time);
+	} while (sched_changed || ktime_after(transmit_end_time, interval_end));
+
+	entry->next_txtime = transmit_end_time;
+
+done:
+	rcu_read_unlock();
+	return txtime;
+}
+
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
@@ -121,6 +349,15 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (unlikely(!child))
 		return qdisc_drop(skb, sch, to_free);
 
+	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
+		if (!is_valid_interval(skb, sch))
+			return qdisc_drop(skb, sch, to_free);
+	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
+		skb->tstamp = get_packet_txtime(skb, sch);
+		if (!skb->tstamp)
+			return qdisc_drop(skb, sch, to_free);
+	}
+
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -156,6 +393,9 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 		if (!skb)
 			continue;
 
+		if (TXTIME_ASSIST_IS_ENABLED(q->flags))
+			return skb;
+
 		prio = skb->priority;
 		tc = netdev_get_prio_tc_map(dev, prio);
 
@@ -168,11 +408,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
-static int length_to_duration(struct taprio_sched *q, int len)
-{
-	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
-}
-
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
@@ -216,6 +451,13 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		if (unlikely(!child))
 			continue;
 
+		if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
+			skb = child->ops->dequeue(child);
+			if (!skb)
+				continue;
+			goto skb_found;
+		}
+
 		skb = child->ops->peek(child);
 		if (!skb)
 			continue;
@@ -246,6 +488,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		if (unlikely(!skb))
 			goto done;
 
+skb_found:
 		qdisc_bstats_update(sch, skb);
 		qdisc_qstats_backlog_dec(sch, skb);
 		sch->q.qlen--;
@@ -522,7 +765,8 @@ static int parse_taprio_schedule(struct nlattr **tb,
 
 static int taprio_parse_mqprio_opt(struct net_device *dev,
 				   struct tc_mqprio_qopt *qopt,
-				   struct netlink_ext_ack *extack)
+				   struct netlink_ext_ack *extack,
+				   u32 taprio_flags)
 {
 	int i, j;
 
@@ -570,6 +814,9 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 			return -EINVAL;
 		}
 
+		if (TXTIME_ASSIST_IS_ENABLED(taprio_flags))
+			continue;
+
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
 			if (last > qopt->offset[j]) {
@@ -700,6 +947,18 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_DONE;
 }
 
+static void setup_txtime(struct taprio_sched *q,
+			 struct sched_gate_list *sched, ktime_t base)
+{
+	struct sched_entry *entry;
+	u32 interval = 0;
+
+	list_for_each_entry(entry, &sched->entries, list) {
+		entry->next_txtime = ktime_add_ns(base, interval);
+		interval += entry->interval;
+	}
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -708,6 +967,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
+	u32 taprio_flags = 0;
 	int i, err, clockid;
 	unsigned long flags;
 	ktime_t start;
@@ -720,7 +980,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
 		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
 
-	err = taprio_parse_mqprio_opt(dev, mqprio, extack);
+	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
+		taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
+
+		if (q->flags != 0 && q->flags != taprio_flags) {
+			NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
+			return -EOPNOTSUPP;
+		} else if (!FLAGS_VALID(taprio_flags)) {
+			NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
+			return -EINVAL;
+		}
+
+		q->flags = taprio_flags;
+	}
+
+	err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
 	if (err < 0)
 		return err;
 
@@ -779,7 +1053,18 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	/* Protects against enqueue()/dequeue() */
 	spin_lock_bh(qdisc_lock(sch));
 
-	if (!hrtimer_active(&q->advance_timer)) {
+	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
+		if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
+			NL_SET_ERR_MSG_MOD(extack, "txtime-delay can only be set when txtime-assist mode is enabled");
+			err = -EINVAL;
+			goto unlock;
+		}
+
+		q->txtime_delay = nla_get_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
+	}
+
+	if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
+	    !hrtimer_active(&q->advance_timer)) {
 		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
 		q->advance_timer.function = advance_sched;
 	}
@@ -822,20 +1107,35 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
-	setup_first_close_time(q, new_admin, start);
+	if (TXTIME_ASSIST_IS_ENABLED(taprio_flags)) {
+		setup_txtime(q, new_admin, start);
 
-	/* Protects against advance_sched() */
-	spin_lock_irqsave(&q->current_entry_lock, flags);
+		if (!oper) {
+			rcu_assign_pointer(q->oper_sched, new_admin);
+			err = 0;
+			new_admin = NULL;
+			goto unlock;
+		}
 
-	taprio_start_sched(sch, start, new_admin);
+		rcu_assign_pointer(q->admin_sched, new_admin);
+		if (admin)
+			call_rcu(&admin->rcu, taprio_free_sched_cb);
+	} else {
+		setup_first_close_time(q, new_admin, start);
 
-	rcu_assign_pointer(q->admin_sched, new_admin);
-	if (admin)
-		call_rcu(&admin->rcu, taprio_free_sched_cb);
-	new_admin = NULL;
+		/* Protects against advance_sched() */
+		spin_lock_irqsave(&q->current_entry_lock, flags);
+
+		taprio_start_sched(sch, start, new_admin);
 
-	spin_unlock_irqrestore(&q->current_entry_lock, flags);
+		rcu_assign_pointer(q->admin_sched, new_admin);
+		if (admin)
+			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
+		spin_unlock_irqrestore(&q->current_entry_lock, flags);
+	}
+
+	new_admin = NULL;
 	err = 0;
 
 unlock:
@@ -1073,6 +1373,13 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
 		goto options_error;
 
+	if (q->flags && nla_put_u32(skb, TCA_TAPRIO_ATTR_FLAGS, q->flags))
+		goto options_error;
+
+	if (q->txtime_delay &&
+	    nla_put_s32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
+		goto options_error;
+
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.7.3

