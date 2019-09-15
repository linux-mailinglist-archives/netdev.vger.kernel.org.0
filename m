Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7408B2DBB
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 04:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfIOCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 22:00:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34812 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfIOCAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 22:00:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so4615693wmc.1
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 19:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zDx526YUx3qSCV4qbXZPEU1TVXew/odBskXi/sqJVN4=;
        b=rRcTF0V/1A0Zk6Q9atrVR1XMOks6iJNj1bCXYHm0Tz5l5OkdoCpIQxwO8kZ3SKMA+2
         gZIa333odOjv9BwqNsjpRc5AKpx68Rzz+F0lepOuzyrNMddQ1EkCc4Mip0yYlgziZ4It
         VePDSo+vy5wzW96qWol4omTulFYCr3jX3d1IjhiUyJDJSVpL3N63qjRJFf4n4mCkwny4
         fJWwOski8n7syZUlAvIapnDOP4nQ5F/NxQpjcnPsoJohAemMoQdPO/na0GT+hB9b7u2Q
         +lrak3K4FqXtbN4g3jTPqi7exNbbqPIReoDSTRI7P/Ig5ukx1XJaAMPqQ7f7qttRkSt/
         DPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zDx526YUx3qSCV4qbXZPEU1TVXew/odBskXi/sqJVN4=;
        b=txcuXUb2LmM6WacT2CVtmUp/ZuIAaDhOyG8Dlulc2/SwNnr8ot60/I7ghDwJl5l3X+
         MbpXxAbHVvMqSJMtzB4nvev6GVBcSy3GjTwJUS5IKc78JXDTL7M06d5dldQMGIvWNSnA
         6kMhb1fS1AZvVzq0ewdqiLskuxKhzds9mJ6LXxuNLlxeGqXMPdU9UbygEKhEb/kOjuPA
         o6TKneI4RvkxeCRmuSdDx+cUcZByRu/y0cKtDH+KIRcuSfujr6KmVxvkyFwuCQO61B+v
         NNJbQz/7/6l8Y+xQ4YbJF2TiRYmedtF5QM/4r6kzGClLRrsFkxgGlNsSEEQMprXGvxEK
         rNzQ==
X-Gm-Message-State: APjAAAVyErMiScRUFLU6nAiVgq1Ijt8LJeC5vBoa3qpYICppkDHKSLkw
        V1gTLmnF6vx3kZhEQudlgNLfNq0Kh/HGPg==
X-Google-Smtp-Source: APXvYqw65iCWo+fgwo8dRDeLsNrXLwb2BtMRD963HnEtIvbOiyHiPkBPX/W14kguX8NUC02O/Ee35A==
X-Received: by 2002:a7b:c946:: with SMTP id i6mr3845222wml.158.1568512810226;
        Sat, 14 Sep 2019 19:00:10 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id q15sm7216333wmb.28.2019.09.14.19.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 19:00:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        jose.abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 1/6] taprio: Add support for hardware offloading
Date:   Sun, 15 Sep 2019 04:59:58 +0300
Message-Id: <20190915020003.27926-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915020003.27926-1-olteanv@gmail.com>
References: <20190915020003.27926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

This allows taprio to offload the schedule enforcement to capable
network cards, resulting in more precise windows and less CPU usage.

The gate mask acts on traffic classes (groups of queues of same
priority), as specified in IEEE 802.1Q-2018, and following the existing
taprio and mqprio semantics.
It is up to the driver to perform conversion between tc and individual
netdev queues if for some reason it needs to make that distinction.

Full offload is requested from the network interface by specifying
"flags 2" in the tc qdisc creation command, which in turn corresponds to
the TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD bit.

The important detail here is the clockid which is implicitly /dev/ptpN
for full offload, and hence not configurable.

A reference counting API is added to support the use case where Ethernet
drivers need to keep the taprio offload structure locally (i.e. they are
a multi-port switch driver, and configuring a port depends on the
settings of other ports as well). The refcount_t variable is kept in a
private structure (__tc_taprio_qopt_offload) and not exposed to drivers.

In the future, the private structure might also be expanded with a
backpointer to taprio_sched *q, to implement the notification system
described in the patch (of when admin became oper, or an error occurred,
etc, so the offload can be monitored with 'tc qdisc show').

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since v2:
- None.

Changes since v1:
- Turned the next_sched hrtimer function into a simple
  taprio_offload_config_changed function called synchronously (for now)
  from taprio_enable_offload. But the idea is that the driver may have a
  lot more means to figure out when the admin schedule is no longer
  pending (perhaps even an interrupt), so leave an open window for
  implementing a notification system from the driver.
- Made it an error to specify 'clockid' with full offload.
- Created a wrapper __tc_taprio_qopt_offload structure which holds the
  refcount_t (for now) and maybe a backpointer to the qdisc_priv in the
  future.
- Renamed taprio_get and taprio_free to taprio_offload_get and
  taprio_offload_free. Renamed the "taprio" variable to "offload".
- Moved the reference counting helper implementations to sch_taprio.c.
- Removed the tc_mask_to_queue_mask manipulation done to the gate_mask
  before passing it on to drivers. Instead of netdev queue gates, they
  now see a mask of traffic class gates, which:
  - They need to care about anyway, if they have a multi-queue device
    and they need to configure the queue-to-tc hardware mapping.
  - Makes no difference to them if the hardware makes no distinction
    between queue and traffic class (there is only one egress queue per
    tc, having a fixed priority). The sja1105 hw is in this situation.

Changes since RFC:
- Made the combination of FULL_OFFLOAD and TXTIME_ASSIST invalid.
- Made ndo_setup_tc be called from sleepable context.
- Added a taprio_alloc helper to avoid passing stack memory to drivers.
- Made taprio_disable_offload take the extack as well.
- Conditioned the setup of the software (and txtime-assisted)
  implementation of taprio on there not being a full offload in place.
- Fixed a lockdep-related compilation bug.

 include/linux/netdevice.h      |   1 +
 include/net/pkt_sched.h        |  23 ++
 include/uapi/linux/pkt_sched.h |   3 +-
 net/sched/sch_taprio.c         | 409 +++++++++++++++++++++++++++++----
 4 files changed, 392 insertions(+), 44 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d7d5626002e9..9eda1c31d1f7 100644
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
index a16fbe9a2a67..d1632979622e 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -161,4 +161,27 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_taprio_sched_entry {
+	u8 command; /* TC_TAPRIO_CMD_* */
+
+	/* The gate_mask in the offloading side refers to traffic classes */
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
+/* Reference counting */
+struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
+						  *offload);
+void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
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
index 84b863e2bdbd..2f7b34205c82 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -29,8 +29,8 @@ static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
-#define FLAGS_VALID(flags) (!((flags) & ~TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))
 #define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
+#define FULL_OFFLOAD_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 
 struct sched_entry {
 	struct list_head list;
@@ -75,9 +75,16 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	struct sk_buff *(*dequeue)(struct Qdisc *sch);
+	struct sk_buff *(*peek)(struct Qdisc *sch);
 	u32 txtime_delay;
 };
 
+struct __tc_taprio_qopt_offload {
+	refcount_t users;
+	struct tc_taprio_qopt_offload offload;
+};
+
 static ktime_t sched_base_time(const struct sched_gate_list *sched)
 {
 	if (!sched)
@@ -268,6 +275,19 @@ static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
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
@@ -417,7 +437,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
-static struct sk_buff *taprio_peek(struct Qdisc *sch)
+static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -461,6 +481,36 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
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
@@ -468,7 +518,7 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
+static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -550,6 +600,40 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
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
@@ -932,6 +1016,9 @@ static void taprio_start_sched(struct Qdisc *sch,
 	struct taprio_sched *q = qdisc_priv(sch);
 	ktime_t expires;
 
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
+		return;
+
 	expires = hrtimer_get_expires(&q->advance_timer);
 	if (expires == 0)
 		expires = KTIME_MAX;
@@ -1011,6 +1098,254 @@ static void setup_txtime(struct taprio_sched *q,
 	}
 }
 
+static struct tc_taprio_qopt_offload *taprio_offload_alloc(int num_entries)
+{
+	size_t size = sizeof(struct tc_taprio_sched_entry) * num_entries +
+		      sizeof(struct __tc_taprio_qopt_offload);
+	struct __tc_taprio_qopt_offload *__offload;
+
+	__offload = kzalloc(size, GFP_KERNEL);
+	if (!__offload)
+		return NULL;
+
+	refcount_set(&__offload->users, 1);
+
+	return &__offload->offload;
+}
+
+struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
+						  *offload)
+{
+	struct __tc_taprio_qopt_offload *__offload;
+
+	__offload = container_of(offload, struct __tc_taprio_qopt_offload,
+				 offload);
+
+	refcount_inc(&__offload->users);
+
+	return offload;
+}
+EXPORT_SYMBOL_GPL(taprio_offload_get);
+
+void taprio_offload_free(struct tc_taprio_qopt_offload *offload)
+{
+	struct __tc_taprio_qopt_offload *__offload;
+
+	__offload = container_of(offload, struct __tc_taprio_qopt_offload,
+				 offload);
+
+	if (!refcount_dec_and_test(&__offload->users))
+		return;
+
+	kfree(__offload);
+}
+EXPORT_SYMBOL_GPL(taprio_offload_free);
+
+/* The function will only serve to keep the pointers to the "oper" and "admin"
+ * schedules valid in relation to their base times, so when calling dump() the
+ * users looks at the right schedules.
+ * When using full offload, the admin configuration is promoted to oper at the
+ * base_time in the PHC time domain.  But because the system time is not
+ * necessarily in sync with that, we can't just trigger a hrtimer to call
+ * switch_schedules at the right hardware time.
+ * At the moment we call this by hand right away from taprio, but in the future
+ * it will be useful to create a mechanism for drivers to notify taprio of the
+ * offload state (PENDING, ACTIVE, INACTIVE) so it can be visible in dump().
+ * This is left as TODO.
+ */
+void taprio_offload_config_changed(struct taprio_sched *q)
+{
+	struct sched_gate_list *oper, *admin;
+
+	spin_lock(&q->current_entry_lock);
+
+	oper = rcu_dereference_protected(q->oper_sched,
+					 lockdep_is_held(&q->current_entry_lock));
+	admin = rcu_dereference_protected(q->admin_sched,
+					  lockdep_is_held(&q->current_entry_lock));
+
+	switch_schedules(q, &admin, &oper);
+
+	spin_unlock(&q->current_entry_lock);
+}
+
+static void taprio_sched_to_offload(struct taprio_sched *q,
+				    struct sched_gate_list *sched,
+				    const struct tc_mqprio_qopt *mqprio,
+				    struct tc_taprio_qopt_offload *offload)
+{
+	struct sched_entry *entry;
+	int i = 0;
+
+	offload->base_time = sched->base_time;
+	offload->cycle_time = sched->cycle_time;
+	offload->cycle_time_extension = sched->cycle_time_extension;
+
+	list_for_each_entry(entry, &sched->entries, list) {
+		struct tc_taprio_sched_entry *e = &offload->entries[i];
+
+		e->command = entry->command;
+		e->interval = entry->interval;
+		e->gate_mask = entry->gate_mask;
+		i++;
+	}
+
+	offload->num_entries = i;
+}
+
+static int taprio_enable_offload(struct net_device *dev,
+				 struct tc_mqprio_qopt *mqprio,
+				 struct taprio_sched *q,
+				 struct sched_gate_list *sched,
+				 struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload *offload;
+	int err = 0;
+
+	if (!ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support taprio offload");
+		return -EOPNOTSUPP;
+	}
+
+	offload = taprio_offload_alloc(sched->num_entries);
+	if (!offload) {
+		NL_SET_ERR_MSG(extack,
+			       "Not enough memory for enabling offload mode");
+		return -ENOMEM;
+	}
+	offload->enable = 1;
+	taprio_sched_to_offload(q, sched, mqprio, offload);
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Device failed to setup taprio offload");
+		goto done;
+	}
+
+	taprio_offload_config_changed(q);
+
+done:
+	taprio_offload_free(offload);
+
+	return err;
+}
+
+static int taprio_disable_offload(struct net_device *dev,
+				  struct taprio_sched *q,
+				  struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_taprio_qopt_offload *offload;
+	int err;
+
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+		return 0;
+
+	if (!ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
+	offload = taprio_offload_alloc(0);
+	if (!offload) {
+		NL_SET_ERR_MSG(extack,
+			       "Not enough memory to disable offload mode");
+		return -ENOMEM;
+	}
+	offload->enable = 0;
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Device failed to disable offload");
+		goto out;
+	}
+
+out:
+	taprio_offload_free(offload);
+
+	return err;
+}
+
+/* If full offload is enabled, the only possible clockid is the net device's
+ * PHC. For that reason, specifying a clockid through netlink is incorrect.
+ * For txtime-assist, it is implicitly assumed that the device's PHC is kept
+ * in sync with the specified clockid via a user space daemon such as phc2sys.
+ * For both software taprio and txtime-assist, the clockid is used for the
+ * hrtimer that advances the schedule and hence mandatory.
+ */
+static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
+				struct netlink_ext_ack *extack)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int err = -EINVAL;
+
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		const struct ethtool_ops *ops = dev->ethtool_ops;
+		struct ethtool_ts_info info = {
+			.cmd = ETHTOOL_GET_TS_INFO,
+			.phc_index = -1,
+		};
+
+		if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
+			NL_SET_ERR_MSG(extack,
+				       "The 'clockid' cannot be specified for full offload");
+			goto out;
+		}
+
+		if (ops && ops->get_ts_info)
+			err = ops->get_ts_info(dev, &info);
+
+		if (err || info.phc_index < 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Device does not have a PTP clock");
+			err = -ENOTSUPP;
+			goto out;
+		}
+	} else if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
+		int clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
+
+		/* We only support static clockids and we don't allow
+		 * for it to be modified after the first init.
+		 */
+		if (clockid < 0 ||
+		    (q->clockid != -1 && q->clockid != clockid)) {
+			NL_SET_ERR_MSG(extack,
+				       "Changing the 'clockid' of a running schedule is not supported");
+			err = -ENOTSUPP;
+			goto out;
+		}
+
+		switch (clockid) {
+		case CLOCK_REALTIME:
+			q->tk_offset = TK_OFFS_REAL;
+			break;
+		case CLOCK_MONOTONIC:
+			q->tk_offset = TK_OFFS_MAX;
+			break;
+		case CLOCK_BOOTTIME:
+			q->tk_offset = TK_OFFS_BOOT;
+			break;
+		case CLOCK_TAI:
+			q->tk_offset = TK_OFFS_TAI;
+			break;
+		default:
+			NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
+			err = -EINVAL;
+			goto out;
+		}
+
+		q->clockid = clockid;
+	} else {
+		NL_SET_ERR_MSG(extack, "Specifying a 'clockid' is mandatory");
+		goto out;
+	}
+out:
+	return err;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1020,9 +1355,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
 	u32 taprio_flags = 0;
-	int i, err, clockid;
 	unsigned long flags;
 	ktime_t start;
+	int i, err;
 
 	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
 					  taprio_policy, extack);
@@ -1038,7 +1373,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		if (q->flags != 0 && q->flags != taprio_flags) {
 			NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
 			return -EOPNOTSUPP;
-		} else if (!FLAGS_VALID(taprio_flags)) {
+		} else if (!taprio_flags_valid(taprio_flags)) {
 			NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
 			return -EINVAL;
 		}
@@ -1078,30 +1413,19 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
-	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
-		clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
-
-		/* We only support static clockids and we don't allow
-		 * for it to be modified after the first init.
-		 */
-		if (clockid < 0 ||
-		    (q->clockid != -1 && q->clockid != clockid)) {
-			NL_SET_ERR_MSG(extack, "Changing the 'clockid' of a running schedule is not supported");
-			err = -ENOTSUPP;
-			goto free_sched;
-		}
-
-		q->clockid = clockid;
-	}
-
-	if (q->clockid == -1 && !tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
-		NL_SET_ERR_MSG(extack, "Specifying a 'clockid' is mandatory");
-		err = -EINVAL;
+	err = taprio_parse_clockid(sch, tb, extack);
+	if (err < 0)
 		goto free_sched;
-	}
 
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
 
@@ -1116,6 +1440,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
+	    !FULL_OFFLOAD_IS_ENABLED(taprio_flags) &&
 	    !hrtimer_active(&q->advance_timer)) {
 		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
 		q->advance_timer.function = advance_sched;
@@ -1134,23 +1459,15 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
-	switch (q->clockid) {
-	case CLOCK_REALTIME:
-		q->tk_offset = TK_OFFS_REAL;
-		break;
-	case CLOCK_MONOTONIC:
-		q->tk_offset = TK_OFFS_MAX;
-		break;
-	case CLOCK_BOOTTIME:
-		q->tk_offset = TK_OFFS_BOOT;
-		break;
-	case CLOCK_TAI:
-		q->tk_offset = TK_OFFS_TAI;
-		break;
-	default:
-		NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
-		err = -EINVAL;
-		goto unlock;
+	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
+		q->dequeue = taprio_dequeue_offload;
+		q->peek = taprio_peek_offload;
+	} else {
+		/* Be sure to always keep the function pointers
+		 * in a consistent state.
+		 */
+		q->dequeue = taprio_dequeue_soft;
+		q->peek = taprio_peek_soft;
 	}
 
 	err = taprio_get_start_time(sch, new_admin, &start);
@@ -1212,6 +1529,8 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	hrtimer_cancel(&q->advance_timer);
 
+	taprio_disable_offload(dev, q, NULL);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
 			qdisc_put(q->qdiscs[i]);
@@ -1241,6 +1560,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
+	q->dequeue = taprio_dequeue_soft;
+	q->peek = taprio_peek_soft;
+
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
@@ -1423,7 +1745,8 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put(skb, TCA_TAPRIO_ATTR_PRIOMAP, sizeof(opt), &opt))
 		goto options_error;
 
-	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
+	    nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
 		goto options_error;
 
 	if (q->flags && nla_put_u32(skb, TCA_TAPRIO_ATTR_FLAGS, q->flags))
-- 
2.17.1

