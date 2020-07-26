Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5589B22E150
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 18:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgGZQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 12:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGZQbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 12:31:23 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022D5C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 09:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gOfY+L5m2gFYslw0Ou6nm2kKKDODYfGn/uBMSoHPHso=; b=WvIMglHvuXtYR18ZUTTg6broVH
        N5byepmCCDdUHqw3xf17uLL6DJqfYTChl7yday7EhTLe2ytVlSE9iCE9c5Jn1R2aBkUBYVtcvK555
        sSKXxAzx4XvhTbvhx1s6b4EXh41vbQKXVjkR8hLMV+XIoKcEX8tii3dBSYPvFMZ7oDKY=;
Received: from p5b206d80.dip0.t-ipconnect.de ([91.32.109.128] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jzjYX-0003QO-1e; Sun, 26 Jul 2020 18:31:21 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
Subject: [RFC] net: add support for threaded NAPI polling
Date:   Sun, 26 Jul 2020 18:31:19 +0200
Message-Id: <20200726163119.86162-1-nbd@nbd.name>
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
 include/linux/netdevice.h | 23 ++++++++++++++++++++++
 net/core/dev.c            | 40 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

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
index 19f1abc26fcd..e140b6a9d5eb 100644
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
@@ -6601,6 +6612,30 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+static void napi_workfn(struct work_struct *work)
+{
+	struct napi_struct *n = container_of(work, struct napi_struct, work);
+
+	for (;;) {
+		if (!test_bit(NAPI_STATE_SCHED, &n->state))
+			return;
+
+		if (n->poll(n, n->weight) < n->weight)
+			return;
+
+		if (!need_resched())
+			continue;
+
+		/*
+		 * have to pay for the latency of task switch even if
+		 * napi is scheduled
+		 */
+		if (test_bit(NAPI_STATE_SCHED, &n->state))
+			queue_work(napi_workq, work);
+		return;
+	}
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6621,6 +6656,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
+	INIT_WORK(&napi->work, napi_workfn);
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	napi_hash_add(napi);
 }
@@ -10676,6 +10712,10 @@ static int __init net_dev_init(void)
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

