Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC37EA2B9F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfH3ArH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51361 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbfH3ArB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id k1so5496811wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jkB/fQrumz+D8ijtPzdGU5sUKjYl9rcJNuttAQ1GgOo=;
        b=K68gMon0zJyTYCLlYDJzpeiQm1D38jLSyMzMAzm2dL/o+Slb0hFqiZPymF2krR39tY
         /22DZ3l/5YeyMunVTWq+cmXPR8dHTvHGFjKbPP1LxdYwtBLXyAeiTCJMI7bfNtzqkWWK
         7dNl6STL7M4Bp0GfSTs4nXK/t3KcxyVRIrccTbT5KbYwq2aMo3hCDw9sBrzlHkJYakff
         oXAgG4DIGx4HcCj66K7ymJPly6z3pbcAhTps9YiS1xNSpZOeVZUZYou9T5xF8Jt3N8C5
         P4XlHNwV1K1OFTonwFZU12UTGt8a2gIKy9t/saEbnVQvoagxVQyHm6O3bdt70XqWLnlS
         NXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jkB/fQrumz+D8ijtPzdGU5sUKjYl9rcJNuttAQ1GgOo=;
        b=tQ4gcULgVK5EInNdDKQ2DIv3L5Vjwu4vOkLkubphtt9B4H5PcWgAjYzsNUQgy9hjC5
         VGDpE9y8f3iQdtITEvMvTkaqCdFiR2Qa3S+qXejxxOW6WyNTl68g+v2DCygX/nTBsmu4
         Y6eI7sKWRKRp4qsERV0Fte6mr6lDoekr0qrCcULJ5yUyoHTi3Df4KrkdDT34rJfBHmXv
         tomd2SsN4aHT+LsqoQDnvbrFbqwlk8b6CKi/bzXOEY+4KIiuIcF1lb+31HLjmMWUIxgG
         B2GPqqXG5tT3QszXoc+2du61R/Nm/jd9mW0fCEYY/U0ky+2cdhbFdgCTVrADcXDxe2CW
         T1Ng==
X-Gm-Message-State: APjAAAU6XVDVbxo0WCgFBnxJ212cNyV420tKZWBR4KQoyBwW9pvcuW0s
        QmUEJggr/IcxYbnxrPiwSiw=
X-Google-Smtp-Source: APXvYqy8kdRoSMUY+1uRLjufKmHFv/h942bQ1sMeF8/PBVTrRGEx6anZv40frQQwuYAb8zEDL5jcDA==
X-Received: by 2002:a1c:18d:: with SMTP id 135mr14601477wmb.171.1567126019871;
        Thu, 29 Aug 2019 17:46:59 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 09/15] taprio: Add support for hardware offloading
Date:   Fri, 30 Aug 2019 03:46:29 +0300
Message-Id: <20190830004635.24863-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/linux/netdevice.h      |   1 +
 include/net/pkt_sched.h        |  33 +++++
 include/uapi/linux/pkt_sched.h |   3 +-
 net/sched/sch_taprio.c         | 246 ++++++++++++++++++++++++++++++++-
 4 files changed, 279 insertions(+), 4 deletions(-)

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
index 645ae744390b..219a4611b202 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -29,8 +29,10 @@ static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
-#define FLAGS_VALID(flags) (!((flags) & ~TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))
+#define FLAGS_VALID(flags) (!((flags) & ~(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST | \
+					  TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)))
 #define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
+#define FULL_OFFLOAD_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 
 struct sched_entry {
 	struct list_head list;
@@ -75,6 +77,8 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	struct sk_buff *(*dequeue)(struct Qdisc *sch);
+	struct sk_buff *(*peek)(struct Qdisc *sch);
 	u32 txtime_delay;
 };
 
@@ -417,7 +421,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
-static struct sk_buff *taprio_peek(struct Qdisc *sch)
+static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -461,6 +465,36 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
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
@@ -468,7 +502,7 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
+static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -550,6 +584,40 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
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
@@ -1011,6 +1079,166 @@ static void setup_txtime(struct taprio_sched *q,
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
+static int taprio_disable_offload(struct net_device *dev,
+				  struct taprio_sched *q)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload taprio = { };
+	int err;
+
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+		return 0;
+
+	if (!ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
+	taprio.enable = 0;
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, &taprio);
+	if (err < 0)
+		return err;
+
+	/* Just to be sure to keep the function pointers in a
+	 * consistent state always.
+	 */
+	q->dequeue = taprio_dequeue_soft;
+	q->peek = taprio_peek_soft;
+
+	q->advance_timer.function = advance_sched;
+
+	q->flags &= ~TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD;
+
+	return 0;
+}
+
+static enum hrtimer_restart next_sched(struct hrtimer *timer)
+{
+	struct taprio_sched *q = container_of(timer, struct taprio_sched,
+					      advance_timer);
+	struct sched_gate_list *oper, *admin;
+	bool cond;
+
+	spin_lock(&q->current_entry_lock);
+
+	cond = lockdep_is_held(&q->current_entry_lock);
+
+	oper = rcu_dereference_protected(q->oper_sched, cond);
+	admin = rcu_dereference_protected(q->admin_sched, cond);
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
+static int taprio_enable_offload(struct net_device *dev,
+				 struct tc_mqprio_qopt *mqprio,
+				 struct taprio_sched *q,
+				 struct sched_gate_list *sched,
+				 struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload *taprio;
+	size_t size;
+	int err = 0;
+
+	if (!ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support taprio offload");
+		return -EOPNOTSUPP;
+	}
+
+	size = sizeof(*taprio) +
+		sched->num_entries * sizeof(struct tc_taprio_sched_entry);
+
+	taprio = kzalloc(size, GFP_ATOMIC);
+	if (!taprio) {
+		NL_SET_ERR_MSG(extack,
+			       "Not enough memory for enabling offload mode");
+		return -ENOMEM;
+	}
+
+	refcount_set(&taprio->users, 1);
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
+	q->dequeue = taprio_dequeue_offload;
+	q->peek = taprio_peek_offload;
+
+	/* This function will only serve to keep the pointers to the
+	 * "oper" and "admin" schedules valid in relation to their
+	 * base times, so when calling dump() the users looks at the
+	 * right schedules.
+	 */
+	q->advance_timer.function = next_sched;
+
+done:
+	taprio_free(taprio);
+
+	return err;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1153,6 +1381,13 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
+	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
+	else
+		err = taprio_disable_offload(dev, q);
+	if (err)
+		goto unlock;
+
 	err = taprio_get_start_time(sch, new_admin, &start);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
@@ -1217,6 +1452,8 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	hrtimer_cancel(&q->advance_timer);
 
+	taprio_disable_offload(dev, q);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
 			qdisc_put(q->qdiscs[i]);
@@ -1246,6 +1483,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
+	q->dequeue = taprio_dequeue_soft;
+	q->peek = taprio_peek_soft;
+
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
-- 
2.17.1

