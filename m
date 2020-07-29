Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5B52322E9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2QvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2QvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:51:03 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81809C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nERP88IdyzewMHC50OgwcDBmbRdb4m8Xykck4HF/ItA=; b=pKsvakC15lCbHHoFpJZYRHlTFA
        EyqmBX/TXIpWZDNgoCsvTfBMpnjUwAtp0qd+XzHsODzHTx/wK84Y/4OhKVSzxfg6zy+cTOSMFEMHj
        gIHHgkFNdHqe9E6DLe429Ncu2A3PBgHM3NfPjKkQLO/Ia/iVWYQ1KK5VSBKcgThFrw0c=;
Received: from p54ae996c.dip0.t-ipconnect.de ([84.174.153.108] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k0pIC-0008Uo-1s; Wed, 29 Jul 2020 18:51:00 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Subject: [PATCH] net: add support for threaded NAPI polling
Date:   Wed, 29 Jul 2020 18:50:58 +0200
Message-Id: <20200729165058.83984-1-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
poll function does not perform well. Since NAPI poll is bound to the CPU it
was scheduled from, we can easily end up with a few very busy CPUs spending
most of their time in softirq/ksoftirqd and some idle ones.

Introduce threaded NAPI for such drivers based on a workqueue. The API is the
same except for using netif_threaded_napi_add instead of netif_napi_add.

In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
thread.

With threaded NAPI, throughput seems stable and consistent (and higher than
the best results I got without it).

Based on a patch by Hillf Danton

Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
Changes since RFC v2:
- fix unused but set variable reported by kbuild test robot

Changes since RFC:
- disable softirq around threaded poll functions
- reuse most parts of napi_poll()
- fix re-schedule condition

 include/linux/netdevice.h |  23 ++++++
 net/core/dev.c            | 162 ++++++++++++++++++++++++++------------
 2 files changed, 133 insertions(+), 52 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ac2cd3f49aba..3a39211c7598 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -347,6 +347,7 @@ struct napi_struct {
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
+	struct work_struct	work;
 };
 
 enum {
@@ -357,6 +358,7 @@ enum {
 	NAPI_STATE_HASHED,	/* In NAPI hash (busy polling possible) */
 	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
 	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_THREADED,	/* Use threaded NAPI */
 };
 
 enum {
@@ -367,6 +369,7 @@ enum {
 	NAPIF_STATE_HASHED	 = BIT(NAPI_STATE_HASHED),
 	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
 	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
 };
 
 enum gro_result {
@@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight);
 
+/**
+ *	netif_threaded_napi_add - initialize a NAPI context
+ *	@dev:  network device
+ *	@napi: NAPI context
+ *	@poll: polling function
+ *	@weight: default weight
+ *
+ * This variant of netif_napi_add() should be used from drivers using NAPI
+ * with CPU intensive poll functions.
+ * This will schedule polling from a high priority workqueue that
+ */
+static inline void netif_threaded_napi_add(struct net_device *dev,
+					   struct napi_struct *napi,
+					   int (*poll)(struct napi_struct *, int),
+					   int weight)
+{
+	set_bit(NAPI_STATE_THREADED, &napi->state);
+	netif_napi_add(dev, napi, poll, weight);
+}
+
 /**
  *	netif_tx_napi_add - initialize a NAPI context
  *	@dev:  network device
diff --git a/net/core/dev.c b/net/core/dev.c
index 19f1abc26fcd..11b027f3a2b9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
 struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 static struct list_head offload_base __read_mostly;
+static struct workqueue_struct *napi_workq __read_mostly;
 
 static int netif_rx_internal(struct sk_buff *skb);
 static int call_netdevice_notifiers_info(unsigned long val,
@@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
 {
 	unsigned long flags;
 
+	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
+		queue_work(napi_workq, &n->work);
+		return;
+	}
+
 	local_irq_save(flags);
 	____napi_schedule(this_cpu_ptr(&softnet_data), n);
 	local_irq_restore(flags);
@@ -6333,6 +6339,11 @@ EXPORT_SYMBOL(napi_schedule_prep);
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
+	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
+		queue_work(napi_workq, &n->work);
+		return;
+	}
+
 	____napi_schedule(this_cpu_ptr(&softnet_data), n);
 }
 EXPORT_SYMBOL(__napi_schedule_irqoff);
@@ -6601,6 +6612,95 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+static int __napi_poll(struct napi_struct *n, bool *repoll)
+{
+	int work, weight;
+
+	weight = n->weight;
+
+	/* This NAPI_STATE_SCHED test is for avoiding a race
+	 * with netpoll's poll_napi().  Only the entity which
+	 * obtains the lock and sees NAPI_STATE_SCHED set will
+	 * actually make the ->poll() call.  Therefore we avoid
+	 * accidentally calling ->poll() when NAPI is not scheduled.
+	 */
+	work = 0;
+	if (test_bit(NAPI_STATE_SCHED, &n->state)) {
+		work = n->poll(n, weight);
+		trace_napi_poll(n, work, weight);
+	}
+
+	if (unlikely(work > weight))
+		pr_err_once("NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
+			    n->poll, work, weight);
+
+	if (likely(work < weight))
+		return work;
+
+	/* Drivers must not modify the NAPI state if they
+	 * consume the entire weight.  In such cases this code
+	 * still "owns" the NAPI instance and therefore can
+	 * move the instance around on the list at-will.
+	 */
+	if (unlikely(napi_disable_pending(n))) {
+		napi_complete(n);
+		return work;
+	}
+
+	if (n->gro_bitmask) {
+		/* flush too old packets
+		 * If HZ < 1000, flush all packets.
+		 */
+		napi_gro_flush(n, HZ >= 1000);
+	}
+
+	gro_normal_list(n);
+
+	/* Some drivers may have called napi_schedule
+	 * prior to exhausting their budget.
+	 */
+	if (unlikely(!list_empty(&n->poll_list))) {
+		pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
+			     n->dev ? n->dev->name : "backlog");
+		return work;
+	}
+
+	*repoll = true;
+
+	return work;
+}
+
+static void napi_workfn(struct work_struct *work)
+{
+	struct napi_struct *n = container_of(work, struct napi_struct, work);
+	void *have;
+
+	for (;;) {
+		bool repoll = false;
+
+		local_bh_disable();
+
+		have = netpoll_poll_lock(n);
+		__napi_poll(n, &repoll);
+		netpoll_poll_unlock(have);
+
+		local_bh_enable();
+
+		if (!repoll)
+			return;
+
+		if (!need_resched())
+			continue;
+
+		/*
+		 * have to pay for the latency of task switch even if
+		 * napi is scheduled
+		 */
+		queue_work(napi_workq, work);
+		return;
+	}
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6621,6 +6721,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
+	INIT_WORK(&napi->work, napi_workfn);
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	napi_hash_add(napi);
 }
@@ -6671,65 +6772,18 @@ EXPORT_SYMBOL(netif_napi_del);
 
 static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 {
+	bool do_repoll = false;
 	void *have;
-	int work, weight;
+	int work;
 
 	list_del_init(&n->poll_list);
 
 	have = netpoll_poll_lock(n);
 
-	weight = n->weight;
-
-	/* This NAPI_STATE_SCHED test is for avoiding a race
-	 * with netpoll's poll_napi().  Only the entity which
-	 * obtains the lock and sees NAPI_STATE_SCHED set will
-	 * actually make the ->poll() call.  Therefore we avoid
-	 * accidentally calling ->poll() when NAPI is not scheduled.
-	 */
-	work = 0;
-	if (test_bit(NAPI_STATE_SCHED, &n->state)) {
-		work = n->poll(n, weight);
-		trace_napi_poll(n, work, weight);
-	}
-
-	if (unlikely(work > weight))
-		pr_err_once("NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
-			    n->poll, work, weight);
-
-	if (likely(work < weight))
-		goto out_unlock;
-
-	/* Drivers must not modify the NAPI state if they
-	 * consume the entire weight.  In such cases this code
-	 * still "owns" the NAPI instance and therefore can
-	 * move the instance around on the list at-will.
-	 */
-	if (unlikely(napi_disable_pending(n))) {
-		napi_complete(n);
-		goto out_unlock;
-	}
-
-	if (n->gro_bitmask) {
-		/* flush too old packets
-		 * If HZ < 1000, flush all packets.
-		 */
-		napi_gro_flush(n, HZ >= 1000);
-	}
-
-	gro_normal_list(n);
-
-	/* Some drivers may have called napi_schedule
-	 * prior to exhausting their budget.
-	 */
-	if (unlikely(!list_empty(&n->poll_list))) {
-		pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
-			     n->dev ? n->dev->name : "backlog");
-		goto out_unlock;
-	}
-
-	list_add_tail(&n->poll_list, repoll);
+	work = __napi_poll(n, &do_repoll);
+	if (do_repoll)
+		list_add_tail(&n->poll_list, repoll);
 
-out_unlock:
 	netpoll_poll_unlock(have);
 
 	return work;
@@ -10676,6 +10730,10 @@ static int __init net_dev_init(void)
 		sd->backlog.weight = weight_p;
 	}
 
+	napi_workq = alloc_workqueue("napi_workq", WQ_UNBOUND | WQ_HIGHPRI,
+				     WQ_UNBOUND_MAX_ACTIVE);
+	BUG_ON(!napi_workq);
+
 	dev_boot_phase = 0;
 
 	/* The loopback device is special if any other network devices
-- 
2.24.0

