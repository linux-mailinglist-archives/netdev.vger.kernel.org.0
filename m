Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A24ECEF
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfD2WtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:49:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:39185 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbfD2WtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:49:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072453"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:49:09 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, olteanv@gmail.com,
        timo.koskiahde@tttech.com, m-karicheri2@ti.com
Subject: [PATCH net-next v1 2/4] taprio: Add support adding an admin schedule
Date:   Mon, 29 Apr 2019 15:48:31 -0700
Message-Id: <20190429224833.18208-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429224833.18208-1-vinicius.gomes@intel.com>
References: <20190429224833.18208-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IEEE 802.1Q-2018 defines two "types" of schedules, the "Oper" (from
operational?) and "Admin" ones. Up until now, 'taprio' only had
support for the "Oper" one, added when the qdisc is created. This adds
support for the "Admin" one, which allows the .change() operation to
be supported.

Just for clarification, some quick (and dirty) definitions, the "Oper"
schedule is the currently (as in this instant) running one, and it's
read-only. The "Admin" one is the one that the system configurator has
installed, it can be changed, and it will be "promoted" to "Oper" when
it's 'base-time' is reached.

The idea behing this patch is that calling something like the below,
(after taprio is already configured with an initial schedule):

$ tc qdisc change taprio dev IFACE parent root 	     \
     	   base-time X 	     	   	       	     \
     	   sched-entry <CMD> <GATES> <INTERVAL>	     \
	   ...

Will cause a new admin schedule to be created and programmed to be
"promoted" to "Oper" at instant X. If an "Admin" schedule already
exists, it will be overwritten with the new parameters.

Up until now, there was some code that was added to ease the support
of changing a single entry of a schedule, but was ultimately unused.
Now, that we have support for "change" with more well thought
semantics, updating a single entry seems to be less useful.

So we remove what is in practice dead code, and return a "not
supported" error if the user tries to use it. If changing a single
entry would make the user's life easier we may ressurrect this idea,
but at this point, removing it simplifies the code.

For now, only the schedule specific bits are allowed to be added for a
new schedule, that means that 'clockid', 'num_tc', 'map' and 'queues'
cannot be modified.

Example:

$ tc qdisc change dev IFACE parent root handle 100 taprio \
      base-time $BASE_TIME \
      sched-entry S 00 500000 \
      sched-entry S 0f 500000 \
      clockid CLOCK_TAI

The only change in the netlink API introduced by this change is the
introduction of an "admin" type in the response to a dump request,
that type allows userspace to separate the "oper" schedule from the
"admin" schedule. If userspace doesn't support the "admin" type, it
will only display the "oper" schedule.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/uapi/linux/pkt_sched.h |  11 +
 net/sched/sch_taprio.c         | 511 ++++++++++++++++++++-------------
 2 files changed, 329 insertions(+), 193 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 7ee74c3474bf..d59770d0eb84 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1148,6 +1148,16 @@ enum {
 
 #define TCA_TAPRIO_SCHED_MAX (__TCA_TAPRIO_SCHED_MAX - 1)
 
+/* The format for the admin sched (dump only):
+ * [TCA_TAPRIO_SCHED_ADMIN_SCHED]
+ *   [TCA_TAPRIO_ATTR_SCHED_BASE_TIME]
+ *   [TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]
+ *     [TCA_TAPRIO_ATTR_SCHED_ENTRY]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_CMD]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_GATES]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
+ */
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1156,6 +1166,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY, /* single entry */
 	TCA_TAPRIO_ATTR_SCHED_CLOCKID, /* s32 */
 	TCA_TAPRIO_PAD,
+	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index f827caa73862..ec8ccaee64e6 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -16,6 +16,7 @@
 #include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/rcupdate.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -41,25 +42,69 @@ struct sched_entry {
 	u8 command;
 };
 
+struct sched_gate_list {
+	struct rcu_head rcu;
+	struct list_head entries;
+	size_t num_entries;
+	s64 base_time;
+};
+
 struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
-	s64 base_time;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
 				    */
-	size_t num_entries;
 
 	/* Protects the update side of the RCU protected current_entry */
 	spinlock_t current_entry_lock;
 	struct sched_entry __rcu *current_entry;
-	struct list_head entries;
+	struct sched_gate_list __rcu *oper_sched;
+	struct sched_gate_list __rcu *admin_sched;
 	ktime_t (*get_time)(void);
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 };
 
+static ktime_t sched_base_time(const struct sched_gate_list *sched)
+{
+	if (!sched)
+		return KTIME_MAX;
+
+	return ns_to_ktime(sched->base_time);
+}
+
+static void taprio_free_sched_cb(struct rcu_head *head)
+{
+	struct sched_gate_list *sched = container_of(head, struct sched_gate_list, rcu);
+	struct sched_entry *entry, *n;
+
+	if (!sched)
+		return;
+
+	list_for_each_entry_safe(entry, n, &sched->entries, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+
+	kfree(sched);
+}
+
+static void switch_schedules(struct taprio_sched *q,
+			     struct sched_gate_list **admin,
+			     struct sched_gate_list **oper)
+{
+	rcu_assign_pointer(q->oper_sched, *admin);
+	rcu_assign_pointer(q->admin_sched, NULL);
+
+	if (*oper)
+		call_rcu(&(*oper)->rcu, taprio_free_sched_cb);
+
+	*oper = *admin;
+	*admin = NULL;
+}
+
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
@@ -211,10 +256,31 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
+static bool should_change_schedules(const struct sched_gate_list *admin,
+				    const struct sched_gate_list *oper,
+				    ktime_t close_time)
+{
+	ktime_t next_base_time;
+
+	if (!admin)
+		return false;
+
+	next_base_time = sched_base_time(admin);
+
+	/* This is the simple case, the close_time would fall after
+	 * the next schedule base_time.
+	 */
+	if (ktime_compare(next_base_time, close_time) <= 0)
+		return true;
+
+	return false;
+}
+
 static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 {
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
 					      advance_timer);
+	struct sched_gate_list *oper, *admin;
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
 	ktime_t close_time;
@@ -222,26 +288,43 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
 					  lockdep_is_held(&q->current_entry_lock));
+	oper = rcu_dereference_protected(q->oper_sched,
+					 lockdep_is_held(&q->current_entry_lock));
+	admin = rcu_dereference_protected(q->admin_sched,
+					  lockdep_is_held(&q->current_entry_lock));
 
-	/* This is the case that it's the first time that the schedule
-	 * runs, so it only happens once per schedule. The first entry
-	 * is pre-calculated during the schedule initialization.
+	if (!oper)
+		switch_schedules(q, &admin, &oper);
+
+	/* This can happen in two cases: 1. this is the very first run
+	 * of this function (i.e. we weren't running any schedule
+	 * previously); 2. The previous schedule just ended. The first
+	 * entry of all schedules are pre-calculated during the
+	 * schedule initialization.
 	 */
-	if (unlikely(!entry)) {
-		next = list_first_entry(&q->entries, struct sched_entry,
+	if (unlikely(!entry || entry->close_time == oper->base_time)) {
+		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
 		close_time = next->close_time;
 		goto first_run;
 	}
 
-	if (list_is_last(&entry->list, &q->entries))
-		next = list_first_entry(&q->entries, struct sched_entry,
+	if (list_is_last(&entry->list, &oper->entries))
+		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
 	else
 		next = list_next_entry(entry, list);
 
 	close_time = ktime_add_ns(entry->close_time, next->interval);
 
+	if (should_change_schedules(admin, oper, close_time)) {
+		/* Set things so the next time this runs, the new
+		 * schedule runs.
+		 */
+		close_time = sched_base_time(admin);
+		switch_schedules(q, &admin, &oper);
+	}
+
 	next->close_time = close_time;
 	taprio_set_budget(q, next);
 
@@ -324,71 +407,8 @@ static int parse_sched_entry(struct nlattr *n, struct sched_entry *entry,
 	return fill_sched_entry(tb, entry, extack);
 }
 
-/* Returns the number of entries in case of success */
-static int parse_sched_single_entry(struct nlattr *n,
-				    struct taprio_sched *q,
-				    struct netlink_ext_ack *extack)
-{
-	struct nlattr *tb_entry[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = { };
-	struct nlattr *tb_list[TCA_TAPRIO_SCHED_MAX + 1] = { };
-	struct sched_entry *entry;
-	bool found = false;
-	u32 index;
-	int err;
-
-	err = nla_parse_nested_deprecated(tb_list, TCA_TAPRIO_SCHED_MAX, n,
-					  entry_list_policy, NULL);
-	if (err < 0) {
-		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
-		return -EINVAL;
-	}
-
-	if (!tb_list[TCA_TAPRIO_SCHED_ENTRY]) {
-		NL_SET_ERR_MSG(extack, "Single-entry must include an entry");
-		return -EINVAL;
-	}
-
-	err = nla_parse_nested_deprecated(tb_entry,
-					  TCA_TAPRIO_SCHED_ENTRY_MAX,
-					  tb_list[TCA_TAPRIO_SCHED_ENTRY],
-					  entry_policy, NULL);
-	if (err < 0) {
-		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
-		return -EINVAL;
-	}
-
-	if (!tb_entry[TCA_TAPRIO_SCHED_ENTRY_INDEX]) {
-		NL_SET_ERR_MSG(extack, "Entry must specify an index\n");
-		return -EINVAL;
-	}
-
-	index = nla_get_u32(tb_entry[TCA_TAPRIO_SCHED_ENTRY_INDEX]);
-	if (index >= q->num_entries) {
-		NL_SET_ERR_MSG(extack, "Index for single entry exceeds number of entries in schedule");
-		return -EINVAL;
-	}
-
-	list_for_each_entry(entry, &q->entries, list) {
-		if (entry->index == index) {
-			found = true;
-			break;
-		}
-	}
-
-	if (!found) {
-		NL_SET_ERR_MSG(extack, "Could not find entry");
-		return -ENOENT;
-	}
-
-	err = fill_sched_entry(tb_entry, entry, extack);
-	if (err < 0)
-		return err;
-
-	return q->num_entries;
-}
-
 static int parse_sched_list(struct nlattr *list,
-			    struct taprio_sched *q,
+			    struct sched_gate_list *sched,
 			    struct netlink_ext_ack *extack)
 {
 	struct nlattr *n;
@@ -418,64 +438,36 @@ static int parse_sched_list(struct nlattr *list,
 			return err;
 		}
 
-		list_add_tail(&entry->list, &q->entries);
+		list_add_tail(&entry->list, &sched->entries);
 		i++;
 	}
 
-	q->num_entries = i;
+	sched->num_entries = i;
 
 	return i;
 }
 
-/* Returns the number of entries in case of success */
-static int parse_taprio_opt(struct nlattr **tb, struct taprio_sched *q,
-			    struct netlink_ext_ack *extack)
+static int parse_taprio_schedule(struct nlattr **tb,
+				 struct sched_gate_list *new,
+				 struct netlink_ext_ack *extack)
 {
 	int err = 0;
-	int clockid;
-
-	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST] &&
-	    tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY])
-		return -EINVAL;
 
-	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY] && q->num_entries == 0)
-		return -EINVAL;
-
-	if (q->clockid == -1 && !tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID])
-		return -EINVAL;
+	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
+		NL_SET_ERR_MSG(extack, "Adding a single entry is not supported");
+		return -ENOTSUPP;
+	}
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME])
-		q->base_time = nla_get_s64(
-			tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
-
-	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
-		clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
-
-		/* We only support static clockids and we don't allow
-		 * for it to be modified after the first init.
-		 */
-		if (clockid < 0 || (q->clockid != -1 && q->clockid != clockid))
-			return -EINVAL;
-
-		q->clockid = clockid;
-	}
+		new->base_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_BASE_TIME]);
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST])
 		err = parse_sched_list(
-			tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], q, extack);
-	else if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY])
-		err = parse_sched_single_entry(
-			tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY], q, extack);
-
-	/* parse_sched_* return the number of entries in the schedule,
-	 * a schedule with zero entries is an error.
-	 */
-	if (err == 0) {
-		NL_SET_ERR_MSG(extack, "The schedule should contain at least one entry");
-		return -EINVAL;
-	}
+			tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], new, extack);
+	if (err < 0)
+		return err;
 
-	return err;
+	return 0;
 }
 
 static int taprio_parse_mqprio_opt(struct net_device *dev,
@@ -484,11 +476,17 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 {
 	int i, j;
 
-	if (!qopt) {
+	if (!qopt && !dev->num_tc) {
 		NL_SET_ERR_MSG(extack, "'mqprio' configuration is necessary");
 		return -EINVAL;
 	}
 
+	/* If num_tc is already set, it means that the user already
+	 * configured the mqprio part
+	 */
+	if (dev->num_tc)
+		return 0;
+
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE) {
 		NL_SET_ERR_MSG(extack, "Number of traffic classes is outside valid range");
@@ -534,14 +532,16 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 	return 0;
 }
 
-static int taprio_get_start_time(struct Qdisc *sch, ktime_t *start)
+static int taprio_get_start_time(struct Qdisc *sch,
+				 struct sched_gate_list *sched,
+				 ktime_t *start)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct sched_entry *entry;
 	ktime_t now, base, cycle;
 	s64 n;
 
-	base = ns_to_ktime(q->base_time);
+	base = sched_base_time(sched);
 	now = q->get_time();
 
 	if (ktime_after(base, now)) {
@@ -552,7 +552,7 @@ static int taprio_get_start_time(struct Qdisc *sch, ktime_t *start)
 	/* Calculate the cycle_time, by summing all the intervals.
 	 */
 	cycle = 0;
-	list_for_each_entry(entry, &q->entries, list)
+	list_for_each_entry(entry, &sched->entries, list)
 		cycle = ktime_add_ns(cycle, entry->interval);
 
 	/* The qdisc is expected to have at least one sched_entry.  Moreover,
@@ -571,22 +571,34 @@ static int taprio_get_start_time(struct Qdisc *sch, ktime_t *start)
 	return 0;
 }
 
-static void taprio_start_sched(struct Qdisc *sch, ktime_t start)
+static void setup_first_close_time(struct taprio_sched *q,
+				   struct sched_gate_list *sched, ktime_t base)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
 	struct sched_entry *first;
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->current_entry_lock, flags);
 
-	first = list_first_entry(&q->entries, struct sched_entry,
-				 list);
+	first = list_first_entry(&sched->entries,
+				 struct sched_entry, list);
 
-	first->close_time = ktime_add_ns(start, first->interval);
+	first->close_time = ktime_add_ns(base, first->interval);
 	taprio_set_budget(q, first);
 	rcu_assign_pointer(q->current_entry, NULL);
+}
 
-	spin_unlock_irqrestore(&q->current_entry_lock, flags);
+static void taprio_start_sched(struct Qdisc *sch,
+			       ktime_t start, struct sched_gate_list *new)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	ktime_t expires;
+
+	expires = hrtimer_get_expires(&q->advance_timer);
+	if (expires == 0)
+		expires = KTIME_MAX;
+
+	/* If the new schedule starts before the next expiration, we
+	 * reprogram it to the earliest one, so we change the admin
+	 * schedule to the operational one at the right time.
+	 */
+	start = min_t(ktime_t, start, expires);
 
 	hrtimer_start(&q->advance_timer, start, HRTIMER_MODE_ABS);
 }
@@ -641,10 +653,12 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] = { };
+	struct sched_gate_list *oper, *admin, *new_admin;
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
-	int i, err, size;
+	int i, err, clockid;
+	unsigned long flags;
 	ktime_t start;
 
 	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
@@ -659,48 +673,64 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
-	/* A schedule with less than one entry is an error */
-	size = parse_taprio_opt(tb, q, extack);
-	if (size < 0)
-		return size;
+	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
+	if (!new_admin) {
+		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&new_admin->entries);
 
-	hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
-	q->advance_timer.function = advance_sched;
+	rcu_read_lock();
+	oper = rcu_dereference(q->oper_sched);
+	admin = rcu_dereference(q->admin_sched);
+	rcu_read_unlock();
 
-	switch (q->clockid) {
-	case CLOCK_REALTIME:
-		q->get_time = ktime_get_real;
-		break;
-	case CLOCK_MONOTONIC:
-		q->get_time = ktime_get;
-		break;
-	case CLOCK_BOOTTIME:
-		q->get_time = ktime_get_boottime;
-		break;
-	case CLOCK_TAI:
-		q->get_time = ktime_get_clocktai;
-		break;
-	default:
-		return -ENOTSUPP;
+	if (mqprio && (oper || admin)) {
+		NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running schedule is not supported");
+		err = -ENOTSUPP;
+		goto free_sched;
 	}
 
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct netdev_queue *dev_queue;
-		struct Qdisc *qdisc;
+	err = parse_taprio_schedule(tb, new_admin, extack);
+	if (err < 0)
+		goto free_sched;
 
-		dev_queue = netdev_get_tx_queue(dev, i);
-		qdisc = qdisc_create_dflt(dev_queue,
-					  &pfifo_qdisc_ops,
-					  TC_H_MAKE(TC_H_MAJ(sch->handle),
-						    TC_H_MIN(i + 1)),
-					  extack);
-		if (!qdisc)
-			return -ENOMEM;
+	if (new_admin->num_entries == 0) {
+		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
+		err = -EINVAL;
+		goto free_sched;
+	}
 
-		if (i < dev->real_num_tx_queues)
-			qdisc_hash_add(qdisc, false);
+	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
+		clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
 
-		q->qdiscs[i] = qdisc;
+		/* We only support static clockids and we don't allow
+		 * for it to be modified after the first init.
+		 */
+		if (clockid < 0 ||
+		    (q->clockid != -1 && q->clockid != clockid)) {
+			NL_SET_ERR_MSG(extack, "Changing the 'clockid' of a running schedule is not supported");
+			err = -ENOTSUPP;
+			goto free_sched;
+		}
+
+		q->clockid = clockid;
+	}
+
+	if (q->clockid == -1 && !tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
+		NL_SET_ERR_MSG(extack, "Specifying a 'clockid' is mandatory");
+		err = -EINVAL;
+		goto free_sched;
+	}
+
+	taprio_set_picos_per_byte(dev, q);
+
+	/* Protects against enqueue()/dequeue() */
+	spin_lock_bh(qdisc_lock(sch));
+
+	if (!hrtimer_active(&q->advance_timer)) {
+		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
+		q->advance_timer.function = advance_sched;
 	}
 
 	if (mqprio) {
@@ -716,24 +746,60 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
-	taprio_set_picos_per_byte(dev, q);
+	switch (q->clockid) {
+	case CLOCK_REALTIME:
+		q->get_time = ktime_get_real;
+		break;
+	case CLOCK_MONOTONIC:
+		q->get_time = ktime_get;
+		break;
+	case CLOCK_BOOTTIME:
+		q->get_time = ktime_get_boottime;
+		break;
+	case CLOCK_TAI:
+		q->get_time = ktime_get_clocktai;
+		break;
+	default:
+		NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
+		err = -EINVAL;
+		goto unlock;
+	}
 
-	err = taprio_get_start_time(sch, &start);
+	err = taprio_get_start_time(sch, new_admin, &start);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
-		return err;
+		goto unlock;
 	}
 
-	taprio_start_sched(sch, start);
+	setup_first_close_time(q, new_admin, start);
 
-	return 0;
+	/* Protects against advance_sched() */
+	spin_lock_irqsave(&q->current_entry_lock, flags);
+
+	taprio_start_sched(sch, start, new_admin);
+
+	rcu_assign_pointer(q->admin_sched, new_admin);
+	if (admin)
+		call_rcu(&admin->rcu, taprio_free_sched_cb);
+	new_admin = NULL;
+
+	spin_unlock_irqrestore(&q->current_entry_lock, flags);
+
+	err = 0;
+
+unlock:
+	spin_unlock_bh(qdisc_lock(sch));
+
+free_sched:
+	kfree(new_admin);
+
+	return err;
 }
 
 static void taprio_destroy(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	struct sched_entry *entry, *n;
 	unsigned int i;
 
 	spin_lock(&taprio_list_lock);
@@ -752,10 +818,11 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	netdev_set_num_tc(dev, 0);
 
-	list_for_each_entry_safe(entry, n, &q->entries, list) {
-		list_del(&entry->list);
-		kfree(entry);
-	}
+	if (q->oper_sched)
+		call_rcu(&q->oper_sched->rcu, taprio_free_sched_cb);
+
+	if (q->admin_sched)
+		call_rcu(&q->admin_sched->rcu, taprio_free_sched_cb);
 }
 
 static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
@@ -763,12 +830,12 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	int i;
 
-	INIT_LIST_HEAD(&q->entries);
 	spin_lock_init(&q->current_entry_lock);
 
-	/* We may overwrite the configuration later */
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
+	q->advance_timer.function = advance_sched;
 
 	q->root = sch;
 
@@ -798,6 +865,25 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	list_add(&q->taprio_list, &taprio_list);
 	spin_unlock(&taprio_list_lock);
 
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *dev_queue;
+		struct Qdisc *qdisc;
+
+		dev_queue = netdev_get_tx_queue(dev, i);
+		qdisc = qdisc_create_dflt(dev_queue,
+					  &pfifo_qdisc_ops,
+					  TC_H_MAKE(TC_H_MAJ(sch->handle),
+						    TC_H_MIN(i + 1)),
+					  extack);
+		if (!qdisc)
+			return -ENOMEM;
+
+		if (i < dev->real_num_tx_queues)
+			qdisc_hash_add(qdisc, false);
+
+		q->qdiscs[i] = qdisc;
+	}
+
 	return taprio_change(sch, opt, extack);
 }
 
@@ -869,15 +955,47 @@ static int dump_entry(struct sk_buff *msg,
 	return -1;
 }
 
+static int dump_schedule(struct sk_buff *msg,
+			 const struct sched_gate_list *root)
+{
+	struct nlattr *entry_list;
+	struct sched_entry *entry;
+
+	if (nla_put_s64(msg, TCA_TAPRIO_ATTR_SCHED_BASE_TIME,
+			root->base_time, TCA_TAPRIO_PAD))
+		return -1;
+
+	entry_list = nla_nest_start_noflag(msg,
+					   TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST);
+	if (!entry_list)
+		goto error_nest;
+
+	list_for_each_entry(entry, &root->entries, list) {
+		if (dump_entry(msg, entry) < 0)
+			goto error_nest;
+	}
+
+	nla_nest_end(msg, entry_list);
+	return 0;
+
+error_nest:
+	nla_nest_cancel(msg, entry_list);
+	return -1;
+}
+
 static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *oper, *admin;
 	struct tc_mqprio_qopt opt = { 0 };
-	struct nlattr *nest, *entry_list;
-	struct sched_entry *entry;
+	struct nlattr *nest, *sched_nest;
 	unsigned int i;
 
+	rcu_read_lock();
+	oper = rcu_dereference(q->oper_sched);
+	admin = rcu_dereference(q->admin_sched);
+
 	opt.num_tc = netdev_get_num_tc(dev);
 	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
 
@@ -888,35 +1006,41 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
-		return -ENOSPC;
+		goto start_error;
 
 	if (nla_put(skb, TCA_TAPRIO_ATTR_PRIOMAP, sizeof(opt), &opt))
 		goto options_error;
 
-	if (nla_put_s64(skb, TCA_TAPRIO_ATTR_SCHED_BASE_TIME,
-			q->base_time, TCA_TAPRIO_PAD))
-		goto options_error;
-
 	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
 		goto options_error;
 
-	entry_list = nla_nest_start_noflag(skb,
-					   TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST);
-	if (!entry_list)
+	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-	list_for_each_entry(entry, &q->entries, list) {
-		if (dump_entry(skb, entry) < 0)
-			goto options_error;
-	}
+	if (!admin)
+		goto done;
+
+	sched_nest = nla_nest_start_noflag(skb, TCA_TAPRIO_ATTR_ADMIN_SCHED);
 
-	nla_nest_end(skb, entry_list);
+	if (dump_schedule(skb, admin))
+		goto admin_error;
+
+	nla_nest_end(skb, sched_nest);
+
+done:
+	rcu_read_unlock();
 
 	return nla_nest_end(skb, nest);
 
+admin_error:
+	nla_nest_cancel(skb, sched_nest);
+
 options_error:
 	nla_nest_cancel(skb, nest);
-	return -1;
+
+start_error:
+	rcu_read_unlock();
+	return -ENOSPC;
 }
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
@@ -1003,6 +1127,7 @@ static struct Qdisc_ops taprio_qdisc_ops __read_mostly = {
 	.id		= "taprio",
 	.priv_size	= sizeof(struct taprio_sched),
 	.init		= taprio_init,
+	.change		= taprio_change,
 	.destroy	= taprio_destroy,
 	.peek		= taprio_peek,
 	.dequeue	= taprio_dequeue,
-- 
2.21.0

