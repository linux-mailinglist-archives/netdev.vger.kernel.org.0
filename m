Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A93B615B1
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfGGR3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:29:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37962 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfGGR3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:29:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so4437504wrr.5
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 10:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3d4+feB6xC86x+AhNLaBH4jiv2MCqz67UMupg572fLU=;
        b=uTBCsj1UOUAbkpSOlE/Wro3ZNGmevTRGHXMzYRmmcj5t464MUWukvgdRivaMOEUGd3
         z7M/HJozAQNgQMtwZrDd+nQcoIqc96ODqRWHuxec+qM4H5w5NXqratHJZ86xS2GzxWKd
         4E/hpCtm9fxiwtJaEktBcojRez97d94KUTx+Qm+fYn1MiJlYcUnrjueRg+IoGBT5cmNG
         26RKMHrkBJwwlogqjFg8I6Co53zkQGHh2t6lD0hfaEOr94OaiPn8OZ+efA6Pz8FNNtJw
         ACNV7tlKpfD19fJrOhrpfzriDmJvLtEDfh5iXxUBC677a1YEXecWIbQC1xLtXWzOxKEO
         Z8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3d4+feB6xC86x+AhNLaBH4jiv2MCqz67UMupg572fLU=;
        b=VaessQpPtd6a/cRsr0COq980zQ/2hFltDefgpgfm3cQo5ym1+Se2jBw4EDr7FHtbxS
         kdzbmse03tnPX2zfeRMmkEBiXRMIf0FDA7vdpTWz2ja1f8vh++9VS2DUf7IL239EIpqp
         Udja3THhplORGd90r8hk5BEomX1JdO6C2yGyPvUb0FZMSbIg8KNZJ+mpU4VLfG0bk8ZN
         BEo/92YaC6Dw1GCH9ZfHTVJOXeKQn7/uHDVG0Ewc+DuXFlMEWBTrtP8XDnQTa1oOnKdG
         Dg83CcdnO0XzP8sG+IU7OyPuyF1MqAsfnp/7ilWxzmKK3Bk7sg3WVpleF7A2J+lXRh1R
         +1mg==
X-Gm-Message-State: APjAAAUthNasH8zwkutgFBrytAHoBnSbPpz4v+iuKSdXRmZrJyWBy44m
        PVER6Ek1jy/T/Z+jS5fLWOY=
X-Google-Smtp-Source: APXvYqwQ+4jt0wkvk8MlABLi/ojggtc09pIcZhDJmBUWJbfE2zfiWlwcIIt80NPemOIaSk2VJCKuFA==
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr14819760wrx.269.1562520575430;
        Sun, 07 Jul 2019 10:29:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id g14sm14280463wro.11.2019.07.07.10.29.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 10:29:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH net-next 2/6] taprio: Add support for hardware offloading
Date:   Sun,  7 Jul 2019 20:29:17 +0300
Message-Id: <20190707172921.17731-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
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

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 include/linux/netdevice.h      |   1 +
 include/net/pkt_sched.h        |  18 +++
 include/uapi/linux/pkt_sched.h |   4 +
 net/sched/sch_taprio.c         | 263 ++++++++++++++++++++++++++++++++-
 4 files changed, 284 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..514eb7e9feee 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -845,6 +845,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_ETF,
 	TC_SETUP_ROOT_QDISC,
 	TC_SETUP_QDISC_GRED,
+	TC_SETUP_QDISC_TAPRIO,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index a16fbe9a2a67..3333c107f920 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -161,4 +161,22 @@ struct tc_etf_qopt_offload {
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
+	u8 enable;
+	ktime_t base_time;
+	u64 cycle_time;
+	u64 cycle_time_extension;
+
+	size_t num_entries;
+	struct tc_taprio_sched_entry entries[0];
+};
+
 #endif
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 8b2f993cbb77..08a260fd7843 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1158,6 +1158,9 @@ enum {
  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
  */
 
+#define TCA_TAPRIO_ATTR_OFFLOAD_FLAG_FULL_OFFLOAD 0x1
+#define TCA_TAPRIO_ATTR_OFFLOAD_FLAG_TXTIME_OFFLOAD 0x2
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1169,6 +1172,7 @@ enum {
 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
+	TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, /* u32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9ecfb8f5902a..9e8f066a2474 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -26,6 +26,9 @@ static LIST_HEAD(taprio_list);
 static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
+#define FULL_OFFLOAD_IS_ON(flags) ((flags) & TCA_TAPRIO_ATTR_OFFLOAD_FLAG_FULL_OFFLOAD)
+#define TXTIME_OFFLOAD_IS_ON(flags) ((flags) & TCA_TAPRIO_ATTR_OFFLOAD_FLAG_TXTIME_OFFLOAD)
+#define VALID_OFFLOAD(flags) ((flags) != U32_MAX)
 
 struct sched_entry {
 	struct list_head list;
@@ -55,6 +58,8 @@ struct sched_gate_list {
 struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
+	struct tc_mqprio_qopt mqprio;
+	u32 offload_flags;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
@@ -66,6 +71,8 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *oper_sched;
 	struct sched_gate_list __rcu *admin_sched;
 	ktime_t (*get_time)(void);
+	struct sk_buff *(*dequeue)(struct Qdisc *sch);
+	struct sk_buff *(*peek)(struct Qdisc *sch);
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 };
@@ -143,7 +150,30 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
-static struct sk_buff *taprio_peek(struct Qdisc *sch)
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
+static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -184,6 +214,13 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
+static struct sk_buff *taprio_peek(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+
+	return q->peek(sch);
+}
+
 static inline int length_to_duration(struct taprio_sched *q, int len)
 {
 	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
@@ -196,7 +233,7 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
+static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -275,6 +312,40 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
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
@@ -707,6 +778,165 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_DONE;
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
+				    struct tc_taprio_qopt_offload *taprio)
+{
+	struct sched_entry *entry;
+	int i = 0;
+
+	taprio->base_time = sched->base_time;
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
+		e->gate_mask = tc_mask_to_queue_mask(&q->mqprio,
+						     entry->gate_mask);
+		i++;
+	}
+
+	taprio->num_entries = i;
+}
+
+static void taprio_disable_offload(struct net_device *dev,
+				   struct taprio_sched *q)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload taprio = { };
+	int err;
+
+	if (!q->offload_flags)
+		return;
+
+	if (!ops->ndo_setup_tc)
+		return;
+
+	taprio.enable = 0;
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, &taprio);
+	if (err < 0)
+		return;
+
+	/* Just to be sure to keep the function pointers in a
+	 * consistent state always.
+	 */
+	q->dequeue = taprio_dequeue_soft;
+	q->peek = taprio_peek_soft;
+
+	q->advance_timer.function = advance_sched;
+
+	q->offload_flags = 0;
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
+static int taprio_enable_offload(struct net_device *dev,
+				 struct tc_mqprio_qopt *mqprio,
+				 struct taprio_sched *q,
+				 struct sched_gate_list *sched,
+				 struct netlink_ext_ack *extack,
+				 u32 offload_flags)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload *taprio;
+	size_t size;
+	int err = 0;
+
+	if (!FULL_OFFLOAD_IS_ON(offload_flags)) {
+		NL_SET_ERR_MSG(extack, "Offload mode is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack, "Specified device does not support taprio offload");
+		return -EOPNOTSUPP;
+	}
+
+	size = sizeof(*taprio) +
+		sched->num_entries * sizeof(struct tc_taprio_sched_entry);
+
+	taprio = kzalloc(size, GFP_ATOMIC);
+	if (!taprio) {
+		NL_SET_ERR_MSG(extack, "Not enough memory for enabling offload mode");
+		return -ENOMEM;
+	}
+
+	taprio->enable = 1;
+	taprio_sched_to_offload(q, sched, taprio);
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, taprio);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack, "Specified device failed to setup taprio hardware offload");
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
+	kfree(taprio);
+
+	if (err == 0)
+		q->offload_flags = offload_flags;
+
+	return err;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -715,6 +945,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
+	u32 offload_flags = U32_MAX;
 	int i, err, clockid;
 	unsigned long flags;
 	ktime_t start;
@@ -731,6 +962,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
+		offload_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
+
 	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
 	if (!new_admin) {
 		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
@@ -749,6 +983,12 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	if (offload_flags != U32_MAX && (oper || admin)) {
+		NL_SET_ERR_MSG(extack, "Changing 'offload' of a running schedule is not supported");
+		err = -ENOTSUPP;
+		goto free_sched;
+	}
+
 	err = parse_taprio_schedule(tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -802,6 +1042,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		for (i = 0; i < TC_BITMASK + 1; i++)
 			netdev_set_prio_tc_map(dev, i,
 					       mqprio->prio_tc_map[i]);
+
+		memcpy(&q->mqprio, mqprio, sizeof(q->mqprio));
 	}
 
 	switch (q->clockid) {
@@ -823,6 +1065,15 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
+	if (!offload_flags) {
+		taprio_disable_offload(dev, q);
+	} else if (VALID_OFFLOAD(offload_flags) || q->offload_flags) {
+		err = taprio_enable_offload(dev, mqprio, q,
+					    new_admin, extack, offload_flags);
+		if (err)
+			goto unlock;
+	}
+
 	err = taprio_get_start_time(sch, new_admin, &start);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
@@ -866,6 +1117,8 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	hrtimer_cancel(&q->advance_timer);
 
+	taprio_disable_offload(dev, q);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
 			qdisc_put(q->qdiscs[i]);
@@ -895,6 +1148,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
+	q->dequeue = taprio_dequeue_soft;
+	q->peek = taprio_peek_soft;
+
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
@@ -1080,6 +1336,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
 		goto options_error;
 
+	if (nla_put_u32(skb, TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, q->offload_flags))
+		goto options_error;
+
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.17.1

