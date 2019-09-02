Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B2A5B5A
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfIBQ0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34204 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfIBQ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so14645506wrn.1
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gb+XpVNWvAutOHefVCkJg6GdE0SI5MtCbOhbPOlPurU=;
        b=OfUwScZ+b7H8b6ZsjYBVGmWEcmZ9DbtTPFzsGwLwKD/s4lv/k83ZosRw7lkllVZEWg
         OHnlN5pNQp3amn2ZqT6jjRKfum/KMrAF2UumNGAzCpy4M7mBWeCMF+H+3NkDTYLfgenx
         e4N6qKMObfBF+oFahSUXH+K5ddwGAGlxRpBSMKkQFcWP+VDqe5eWWyxQSCobN2mHEjsK
         bLE+4yJcfCs0FXT+aSiLTSlHdTknnQQzCpiiYBidHBfo7bX+LOXqg/PsA4nYhjCYfQ6l
         cPHhx/CLnQtZmH6qNr761nO06ERbNVBLHQSXriWZT0DQqPgBDKANYo01w/eA2BcdU0E6
         zW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gb+XpVNWvAutOHefVCkJg6GdE0SI5MtCbOhbPOlPurU=;
        b=BjG1PkMtI9Gu0BfMZ99GbV+GMG0v75I1OuLqUHHiJO+63x9V5CN2xFEP6ZCb98eRNr
         ZX4/DRZ6Y9r573t8F1N0gDcKxMAtCd4s9Xuz+T5oBvZDTFTqnknZ0s1EKANeOQ29Wm9n
         o6K+UpXx9qo6wB3lbzJqykBkqGH4tvLoHsDBDlTkBiQ5EnCI3wh2FjwJcS/wH5G/ghOg
         hZEZguBLHmb7omuIPDL0iiKn2Bw9jrWd1nW6V+Zo2JyYZoinZk1qdWz+pejTBfUnFqbk
         kofb7LR5l/E43bh0+/HSAXszFHmtg9wFyyBo0iNj/FY21TwNhDRv4eyFPRT3rNzkOr92
         LqyQ==
X-Gm-Message-State: APjAAAWAHOLHC0v7q+YWa8qPJy4zp3Y0JP23Y7BPRd0YV0GRig/rqPYg
        hl+VP58id1C2QfTD94hr/E8=
X-Google-Smtp-Source: APXvYqynWNMKXwYw5XPvL5UWlTTkJWtvXFaPIIc8DqJO8/H4LZr3O+qMsGwgMWqCqj0NLlkSlkwpGQ==
X-Received: by 2002:adf:e44b:: with SMTP id t11mr16356252wrm.269.1567441576123;
        Mon, 02 Sep 2019 09:26:16 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 09/15] taprio: Add support for hardware offloading
Date:   Mon,  2 Sep 2019 19:25:38 +0300
Message-Id: <20190902162544.24613-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

This allows taprio to offload the schedule enforcement to capable
network cards, resulting in more precise windows and less CPU usage.

The important detail here is the difference between the gate_mask in
taprio and gate_mask for the network driver. For the driver, each bit
in gate_mask references a transmission queue: bit 0 for queue 0, bit 1
for queue 1, and so on. This is done so the driver doesn't need to
know about traffic classes.

Two reference counting API helpers are also added to support the use
case where Ethernet drivers need to keep the taprio offload structure
locally (i.e. they are a multi-port switch driver, and configuring a
port depends on the settings of other ports as well).

Full offload is requested from the network interface by specifying
"flags 2" in the tc qdisc creation command, which in turn corresponds to
the TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD bit.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since RFC:
- Made the combination of FULL_OFFLOAD and TXTIME_ASSIST invalid.
- Made ndo_setup_tc be called from sleepable context.
- Added a taprio_alloc helper to avoid passing stack memory to drivers.
- Made taprio_disable_offload take the extack as well.
- Conditioned the setup of the software (and txtime-assisted)
  implementation of taprio on there not being a full offload in place.
- Fixed a lockdep-related compilation bug.

 include/linux/netdevice.h      |   1 +
 include/net/pkt_sched.h        |  33 ++++
 include/uapi/linux/pkt_sched.h |   3 +-
 net/sched/sch_taprio.c         | 278 ++++++++++++++++++++++++++++++++-
 4 files changed, 309 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b5d28dadf964..8225631b9315 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -847,6 +847,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_ETF,
 	TC_SETUP_ROOT_QDISC,
 	TC_SETUP_QDISC_GRED,
+	TC_SETUP_QDISC_TAPRIO,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index a16fbe9a2a67..bba288f9c98b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -161,4 +161,37 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_taprio_sched_entry {
+	u8 command; /* TC_TAPRIO_CMD_* */
+
+	/* The gate_mask in the offloading side refers to HW queues */
+	u32 gate_mask;
+	u32 interval;
+};
+
+struct tc_taprio_qopt_offload {
+	refcount_t users;
+	u8 enable;
+	ktime_t base_time;
+	u64 cycle_time;
+	u64 cycle_time_extension;
+
+	size_t num_entries;
+	struct tc_taprio_sched_entry entries[0];
+};
+
+static inline struct tc_taprio_qopt_offload *
+taprio_get(struct tc_taprio_qopt_offload *taprio)
+{
+	refcount_inc(&taprio->users);
+	return taprio;
+}
+
+static inline void taprio_free(struct tc_taprio_qopt_offload *taprio)
+{
+	if (!refcount_dec_and_test(&taprio->users))
+		return;
+	kfree(taprio);
+}
+
 #endif
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 18f185299f47..5011259b8f67 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1160,7 +1160,8 @@ enum {
  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
  */
 
-#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST 0x1
+#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	BIT(0)
+#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	BIT(1)
 
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 84b863e2bdbd..f0fa9a47142c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -29,8 +29,8 @@ static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
-#define FLAGS_VALID(flags) (!((flags) & ~TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))
 #define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
+#define FULL_OFFLOAD_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 
 struct sched_entry {
 	struct list_head list;
@@ -75,6 +75,8 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	struct sk_buff *(*dequeue)(struct Qdisc *sch);
+	struct sk_buff *(*peek)(struct Qdisc *sch);
 	u32 txtime_delay;
 };
 
@@ -268,6 +270,19 @@ static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
 	return entry;
 }
 
+static bool taprio_flags_valid(u32 flags)
+{
+	/* Make sure no other flag bits are set. */
+	if (flags & ~(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST |
+		      TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD))
+		return false;
+	/* txtime-assist and full offload are mutually exclusive */
+	if ((flags & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST) &&
+	    (flags & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD))
+		return false;
+	return true;
+}
+
 /* This returns the tstamp value set by TCP in terms of the set clock. */
 static ktime_t get_tcp_tstamp(struct taprio_sched *q, struct sk_buff *skb)
 {
@@ -417,7 +432,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
-static struct sk_buff *taprio_peek(struct Qdisc *sch)
+static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -461,6 +476,36 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
+static struct sk_buff *taprio_peek_offload(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct Qdisc *child = q->qdiscs[i];
+
+		if (unlikely(!child))
+			continue;
+
+		skb = child->ops->peek(child);
+		if (!skb)
+			continue;
+
+		return skb;
+	}
+
+	return NULL;
+}
+
+static struct sk_buff *taprio_peek(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+
+	return q->peek(sch);
+}
+
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
@@ -468,7 +513,7 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
+static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -550,6 +595,40 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
+static struct sk_buff *taprio_dequeue_offload(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct Qdisc *child = q->qdiscs[i];
+
+		if (unlikely(!child))
+			continue;
+
+		skb = child->ops->dequeue(child);
+		if (unlikely(!skb))
+			continue;
+
+		qdisc_bstats_update(sch, skb);
+		qdisc_qstats_backlog_dec(sch, skb);
+		sch->q.qlen--;
+
+		return skb;
+	}
+
+	return NULL;
+}
+
+static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+
+	return q->dequeue(sch);
+}
+
 static bool should_restart_cycle(const struct sched_gate_list *oper,
 				 const struct sched_entry *entry)
 {
@@ -1011,6 +1090,163 @@ static void setup_txtime(struct taprio_sched *q,
 	}
 }
 
+static u32 tc_mask_to_queue_mask(const struct tc_mqprio_qopt *mqprio,
+				 u32 tc_mask)
+{
+	u32 i, queue_mask = 0;
+
+	for (i = 0; i < mqprio->num_tc; i++) {
+		u32 offset, count;
+
+		if (!(tc_mask & BIT(i)))
+			continue;
+
+		offset = mqprio->offset[i];
+		count = mqprio->count[i];
+
+		queue_mask |= GENMASK(offset + count - 1, offset);
+	}
+
+	return queue_mask;
+}
+
+static void taprio_sched_to_offload(struct taprio_sched *q,
+				    struct sched_gate_list *sched,
+				    const struct tc_mqprio_qopt *mqprio,
+				    struct tc_taprio_qopt_offload *taprio)
+{
+	struct sched_entry *entry;
+	int i = 0;
+
+	taprio->base_time = sched->base_time;
+	taprio->cycle_time = sched->cycle_time;
+	taprio->cycle_time_extension = sched->cycle_time_extension;
+
+	list_for_each_entry(entry, &sched->entries, list) {
+		struct tc_taprio_sched_entry *e = &taprio->entries[i];
+
+		e->command = entry->command;
+		e->interval = entry->interval;
+
+		/* We do this transformation because the NIC
+		 * has no knowledge of traffic classes, but it
+		 * knows about queues.
+		 */
+		e->gate_mask = tc_mask_to_queue_mask(mqprio, entry->gate_mask);
+		i++;
+	}
+
+	taprio->num_entries = i;
+}
+
+static enum hrtimer_restart next_sched(struct hrtimer *timer)
+{
+	struct taprio_sched *q = container_of(timer, struct taprio_sched,
+					      advance_timer);
+	struct sched_gate_list *oper, *admin;
+
+	spin_lock(&q->current_entry_lock);
+	oper = rcu_dereference_protected(q->oper_sched,
+					 lockdep_is_held(&q->current_entry_lock));
+	admin = rcu_dereference_protected(q->admin_sched,
+					  lockdep_is_held(&q->current_entry_lock));
+
+	rcu_assign_pointer(q->oper_sched, admin);
+	rcu_assign_pointer(q->admin_sched, NULL);
+
+	if (oper)
+		call_rcu(&oper->rcu, taprio_free_sched_cb);
+
+	spin_unlock(&q->current_entry_lock);
+
+	return HRTIMER_NORESTART;
+}
+
+static struct tc_taprio_qopt_offload *taprio_alloc(int num_entries)
+{
+	size_t size = sizeof(struct tc_taprio_sched_entry) * num_entries +
+		      sizeof(struct tc_taprio_qopt_offload);
+	struct tc_taprio_qopt_offload *taprio;
+
+	taprio = kzalloc(size, GFP_KERNEL);
+	if (!taprio)
+		return taprio;
+
+	refcount_set(&taprio->users, 1);
+
+	return taprio;
+}
+
+static int taprio_enable_offload(struct net_device *dev,
+				 struct tc_mqprio_qopt *mqprio,
+				 struct taprio_sched *q,
+				 struct sched_gate_list *sched,
+				 struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload *taprio;
+	int err = 0;
+
+	if (!ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support taprio offload");
+		return -EOPNOTSUPP;
+	}
+
+	taprio = taprio_alloc(sched->num_entries);
+	if (!taprio) {
+		NL_SET_ERR_MSG(extack,
+			       "Not enough memory for enabling offload mode");
+		return -ENOMEM;
+	}
+	taprio->enable = 1;
+	taprio_sched_to_offload(q, sched, mqprio, taprio);
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, taprio);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Device failed to setup taprio offload");
+		goto done;
+	}
+
+done:
+	taprio_free(taprio);
+
+	return err;
+}
+
+static int taprio_disable_offload(struct net_device *dev,
+				  struct taprio_sched *q,
+				  struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload *taprio;
+	int err;
+
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+		return 0;
+
+	if (!ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
+	taprio = taprio_alloc(0);
+	if (!taprio) {
+		NL_SET_ERR_MSG(extack,
+			       "Not enough memory to disable offload mode");
+		return -ENOMEM;
+	}
+	taprio->enable = 0;
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, taprio);
+	if (err < 0)
+		goto out;
+
+out:
+	taprio_free(taprio);
+
+	return 0;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1038,7 +1274,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		if (q->flags != 0 && q->flags != taprio_flags) {
 			NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
 			return -EOPNOTSUPP;
-		} else if (!FLAGS_VALID(taprio_flags)) {
+		} else if (!taprio_flags_valid(taprio_flags)) {
 			NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
 			return -EINVAL;
 		}
@@ -1102,6 +1338,13 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	taprio_set_picos_per_byte(dev, q);
 
+	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
+	else
+		err = taprio_disable_offload(dev, q, extack);
+	if (err)
+		goto free_sched;
+
 	/* Protects against enqueue()/dequeue() */
 	spin_lock_bh(qdisc_lock(sch));
 
@@ -1153,6 +1396,26 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
+	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
+		q->dequeue = taprio_dequeue_offload;
+		q->peek = taprio_peek_offload;
+
+		/* This function will only serve to keep the pointers to the
+		 * "oper" and "admin" schedules valid in relation to their
+		 * base times, so when calling dump() the users looks at the
+		 * right schedules.
+		 */
+		q->advance_timer.function = next_sched;
+	} else {
+		/* Just to be sure to keep the function pointers in a
+		 * consistent state always.
+		 */
+		q->dequeue = taprio_dequeue_soft;
+		q->peek = taprio_peek_soft;
+
+		q->advance_timer.function = advance_sched;
+	}
+
 	err = taprio_get_start_time(sch, new_admin, &start);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
@@ -1172,7 +1435,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		rcu_assign_pointer(q->admin_sched, new_admin);
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
-	} else {
+	} else if (!FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
 		setup_first_close_time(q, new_admin, start);
 
 		/* Protects against advance_sched() */
@@ -1212,6 +1475,8 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	hrtimer_cancel(&q->advance_timer);
 
+	taprio_disable_offload(dev, q, NULL);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
 			qdisc_put(q->qdiscs[i]);
@@ -1241,6 +1506,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
+	q->dequeue = taprio_dequeue_soft;
+	q->peek = taprio_peek_soft;
+
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
-- 
2.17.1

