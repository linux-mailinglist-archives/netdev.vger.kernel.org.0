Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6A2FC929
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbhATDhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbhATDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:35:41 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A38C0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:35:01 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id w3so20056151qti.17
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=XDlapyM+7BgJ9DMCUCwjp4KkPFgyLD0ktpAqmgX2S/g=;
        b=KLA96Gi+VaamLrxS0NOv9/xpxkt+dsHswxFNz/xnR8ZKV4PqSJgqMnAZyuqkgeqYEa
         j2RSIqyYXV/eCARDuNw+BK/O4KB6mPUC5XcdSK+lEFFYGslJ8JmbzfSNvES+dwqntHSM
         t0uCjHQ2QvCJSJfUnfI9MZMAyED57SivsQlxrVceIKd+GUPU1hbMXKX5YvKH8PMxX+ld
         W/cF5stMCNPnL53Pw4/6BEDUUkGZXlYdOYWfBI8qYAasicAJUyK1VzaD/ni5wJO9uYqJ
         NCgi5ElwUlf7wWKe+RZCj+vU108uZZqo8FrzeDwFxVcoEtB06ciMHIJfdb7Ccsf8NBjX
         r9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XDlapyM+7BgJ9DMCUCwjp4KkPFgyLD0ktpAqmgX2S/g=;
        b=LmK55GG5SzOWvRPjZRz/pPV+7wH8b1Myoxps7wndgKmwDRdHTZU1U6WGo+oq9sn+EN
         tuXcHqOa9B2zwdrpjIdCkbOhSepwJ/h+DbN/imzU30X/PaMSrZQo62Jzul5Q9Z4dJO3T
         G0oiwtMd2c9B2Fed99qZCy68z2kSHxqgRp0P+aw15Kqunxh8i3WUltJeVivFF/77A2Pu
         +iI0wnLmMzqjeg0alahdG+Getbkdr0pbzIVvr+FGXguIFm8K79vumNQ4gOPE3/TRTTO2
         buRIZNNFYmQxzwLreg6ifqaEv4OLuS0UMoZsji5oYKOis7Q49Ef4b+pjaAc4x5kgmw0j
         NPMw==
X-Gm-Message-State: AOAM530koEfXz8uqJjR8WCDBTah2KAhCtlzY7MsZgSQ3l9itptbslbZX
        sayveKkg0Ih2poUdRCD+0FNMp5AyJcs=
X-Google-Smtp-Source: ABdhPJwlmV/8rqhWWVlUjQK5C7mPqkXbuXpXI1sH3/urgS3NZ4WI9JtNlSCJiaX0buoFfcecmWBubWmRPMw=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:ba18:: with SMTP id w24mr3978420qvf.57.1611113700708;
 Tue, 19 Jan 2021 19:35:00 -0800 (PST)
Date:   Tue, 19 Jan 2021 19:34:54 -0800
In-Reply-To: <20210120033455.4034611-1-weiwan@google.com>
Message-Id: <20210120033455.4034611-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net-next v7 2/3] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows running each napi poll loop inside its own
kernel thread.
The threaded mode could be enabled through napi_set_threaded()
api, and does not require a device up/down. The kthread gets
created on demand when napi_set_threaded() is called, and gets
shut down eventually in napi_disable().

Once that threaded mode is enabled and the kthread is
started, napi_schedule() will wake-up such thread instead
of scheduling the softirq.

The threaded poll loop behaves quite likely the net_rx_action,
but it does not have to manipulate local irqs and uses
an explicit scheduling point based on napi->weight.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/linux/netdevice.h |  19 ++----
 net/core/dev.c            | 137 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 02dcef4d66e2..8cb8d43ea5fa 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -347,6 +347,7 @@ struct napi_struct {
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
+	struct task_struct	*thread;
 };
 
 enum {
@@ -358,6 +359,7 @@ enum {
 	NAPI_STATE_NO_BUSY_POLL,	/* Do not add in napi_hash, no busy polling */
 	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() owns this NAPI */
 	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over softirq processing*/
+	NAPI_STATE_THREADED,		/* The poll is performed inside its own thread*/
 };
 
 enum {
@@ -369,6 +371,7 @@ enum {
 	NAPIF_STATE_NO_BUSY_POLL	= BIT(NAPI_STATE_NO_BUSY_POLL),
 	NAPIF_STATE_IN_BUSY_POLL	= BIT(NAPI_STATE_IN_BUSY_POLL),
 	NAPIF_STATE_PREFER_BUSY_POLL	= BIT(NAPI_STATE_PREFER_BUSY_POLL),
+	NAPIF_STATE_THREADED		= BIT(NAPI_STATE_THREADED),
 };
 
 enum gro_result {
@@ -503,20 +506,7 @@ static inline bool napi_complete(struct napi_struct *n)
  */
 void napi_disable(struct napi_struct *n);
 
-/**
- *	napi_enable - enable NAPI scheduling
- *	@n: NAPI context
- *
- * Resume NAPI from being scheduled on this context.
- * Must be paired with napi_disable.
- */
-static inline void napi_enable(struct napi_struct *n)
-{
-	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
-	smp_mb__before_atomic();
-	clear_bit(NAPI_STATE_SCHED, &n->state);
-	clear_bit(NAPI_STATE_NPSVC, &n->state);
-}
+void napi_enable(struct napi_struct *n);
 
 /**
  *	napi_synchronize - wait until NAPI is not running
@@ -2143,6 +2133,7 @@ struct net_device {
 	struct lock_class_key	*qdisc_running_key;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
+	unsigned		threaded:1;
 
 	struct list_head	net_notifier_list;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 7d23bff03864..7ffa91475856 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -91,6 +91,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
+#include <linux/kthread.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <net/net_namespace.h>
@@ -1493,6 +1494,37 @@ void netdev_notify_peers(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_notify_peers);
 
+static int napi_threaded_poll(void *data);
+
+static int napi_kthread_create(struct napi_struct *n)
+{
+	int err = 0;
+
+	/* Create and wake up the kthread once to put it in
+	 * TASK_INTERRUPTIBLE mode to avoid the blocked task
+	 * warning and work with loadavg.
+	 */
+	n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
+				n->dev->name, n->napi_id);
+	if (IS_ERR(n->thread)) {
+		err = PTR_ERR(n->thread);
+		pr_err("kthread_run failed with err %d\n", err);
+		n->thread = NULL;
+	}
+
+	return err;
+}
+
+static void napi_kthread_stop(struct napi_struct *n)
+{
+	if (!n->thread)
+		return;
+
+	kthread_stop(n->thread);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
+	n->thread = NULL;
+}
+
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -4252,6 +4284,21 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
+	struct task_struct *thread;
+
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
+		/* Paired with smp_mb__before_atomic() in
+		 * napi_set_threaded(). Use READ_ONCE() to guarantee
+		 * a complete read on napi->thread. Only call
+		 * wake_up_process() when it's not NULL.
+		 */
+		thread = READ_ONCE(napi->thread);
+		if (thread) {
+			wake_up_process(thread);
+			return;
+		}
+	}
+
 	list_add_tail(&napi->poll_list, &sd->poll_list);
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
@@ -6693,6 +6740,33 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+static int napi_set_threaded(struct napi_struct *n, bool threaded)
+{
+	int err = 0;
+
+	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
+		return 0;
+
+	if (!threaded) {
+		clear_bit(NAPI_STATE_THREADED, &n->state);
+		return 0;
+	}
+
+	if (!n->thread) {
+		err = napi_kthread_create(n);
+		if (err)
+			return err;
+	}
+
+	/* Make sure kthread is created before THREADED bit
+	 * is set.
+	 */
+	smp_mb__before_atomic();
+	set_bit(NAPI_STATE_THREADED, &n->state);
+
+	return 0;
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6734,12 +6808,30 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_kthread_stop(n);
 
 	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
 
+/**
+ *	napi_enable - enable NAPI scheduling
+ *	@n: NAPI context
+ *
+ * Resume NAPI from being scheduled on this context.
+ * Must be paired with napi_disable.
+ */
+void napi_enable(struct napi_struct *n)
+{
+	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
+	WARN_ON(napi_set_threaded(n, n->dev->threaded));
+	smp_mb__before_atomic();
+	clear_bit(NAPI_STATE_SCHED, &n->state);
+	clear_bit(NAPI_STATE_NPSVC, &n->state);
+}
+EXPORT_SYMBOL(napi_enable);
+
 static void flush_gro_hash(struct napi_struct *napi)
 {
 	int i;
@@ -6862,6 +6954,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	return work;
 }
 
+static int napi_thread_wait(struct napi_struct *napi)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
+		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+			WARN_ON(!list_empty(&napi->poll_list));
+			__set_current_state(TASK_RUNNING);
+			return 0;
+		}
+
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+	return -1;
+}
+
+static int napi_threaded_poll(void *data)
+{
+	struct napi_struct *napi = data;
+	void *have;
+
+	while (!napi_thread_wait(napi)) {
+		for (;;) {
+			bool repoll = false;
+
+			local_bh_disable();
+
+			have = netpoll_poll_lock(napi);
+			__napi_poll(napi, &repoll);
+			netpoll_poll_unlock(have);
+
+			__kfree_skb_flush();
+			local_bh_enable();
+
+			if (!repoll)
+				break;
+
+			cond_resched();
+		}
+	}
+	return 0;
+}
+
 static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

