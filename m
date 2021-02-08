Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D174313F2D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbhBHTg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbhBHTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 14:35:06 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31575C0617A7
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 11:34:16 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w11so12547892ybq.8
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 11:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/178W/gWgRrmzCNsCechDVt6IWBnhse2xaVZu64sZ+k=;
        b=XumNa+/BeAnG11/0XnsfKrUONiPkkabM040wQJIiOiUImdAJiTYBXj1mF6SQ+Gr/H3
         iNTqUBPEOwa8tyDuhSYwWak3z2Z8Ynq/Dm66lhf+ODVIfnEn01wORyoTrIxrdh81kUdl
         2Mr3LAR//5cLUszkKVhUZqUg9y6NFogXuHGNj15BVVuHI2Zq8cD/vqFNFKrJ3n9CE2di
         J7xlQbTpzwq35adosigXR/6uBCbsagxfuQtQVU8tC+aBbMRPlVTM8oMdylTYc96r0gzp
         heaEpa05VxJ4b3gsG1sTHMJZJWZvNJtWvsB4LlJLQpMjLussAm14Y61W203rGfEx5H2e
         m7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/178W/gWgRrmzCNsCechDVt6IWBnhse2xaVZu64sZ+k=;
        b=HzzkxzTPF9xEgzBRw6lBVuxRkoecTtVsk+4w+0Hp0lTbq5OGh+kHCTIB6lgZvLKFAU
         SVA/APv7MkU70Ks5Jq+o4GKEkvxhawPA1/7fuYrC1wLHKKFgymzsHWbKBqOF3ehnMTVE
         sQr7qsXYSgZhcAlFt021ndPcNQGakuSFmgZe+oSHPT3/nsqzkssEEGTUT0yeM/PT8uoD
         t5OxYD4zy2Uh9c+iSo5PRsiCw+i1JvF1daoLcLLL5IpwjZLQ2X0bk3Wnb6xqj+LK0CrQ
         VZiGklhr2Tvcp8RxpFAWv1Im61JueeCMFQBU8CZQrH/yVGAWuNTTqZnH6VRN8LArZi+D
         2yvQ==
X-Gm-Message-State: AOAM532fM5q9BeA3NBRkTepnjm3iOUyJoCxzgOajlo/RLVlaHZxOnZRc
        jMr6x1fWLPw8bc2QeXKQFZI4djSXeQs=
X-Google-Smtp-Source: ABdhPJw90BXOVLYseiVvrtvyjzi28BzO7TkwoLhLVmAk228CtqnQqWUKwgk0O6P0dWvCL9Xog4vEZdj8pMI=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:35a9:bca1:5bb0:4132])
 (user=weiwan job=sendgmr) by 2002:a25:ba13:: with SMTP id t19mr28264078ybg.129.1612812855491;
 Mon, 08 Feb 2021 11:34:15 -0800 (PST)
Date:   Mon,  8 Feb 2021 11:34:09 -0800
In-Reply-To: <20210208193410.3859094-1-weiwan@google.com>
Message-Id: <20210208193410.3859094-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210208193410.3859094-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH net-next v11 2/3] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows running each napi poll loop inside its own
kernel thread.
The kthread is created during netif_napi_add() if dev->threaded
is set. And threaded mode is enabled in napi_enable(). We will
provide a way to set dev->threaded and enable threaded mode
without a device up/down in the following patch.

Once that threaded mode is enabled and the kthread is
started, napi_schedule() will wake-up such thread instead
of scheduling the softirq.

The threaded poll loop behaves quite likely the net_rx_action,
but it does not have to manipulate local irqs and uses
an explicit scheduling point based on netdev_budget.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 include/linux/netdevice.h |  21 +++----
 net/core/dev.c            | 112 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9e7ada07ea1..99fb4ec9573e 100644
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
@@ -1827,6 +1817,8 @@ enum netdev_priv_flags {
  *
  *	@wol_enabled:	Wake-on-LAN is enabled
  *
+ *	@threaded:	napi threaded mode is enabled
+ *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
  *				to another network namespace.
@@ -2145,6 +2137,7 @@ struct net_device {
 	struct lock_class_key	*qdisc_running_key;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
+	unsigned		threaded:1;
 
 	struct list_head	net_notifier_list;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 59751a22d7c3..1e35f4f44f3b 100644
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
@@ -1494,6 +1495,27 @@ void netdev_notify_peers(struct net_device *dev)
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
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -4265,6 +4287,21 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
+	struct task_struct *thread;
+
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
+		/* Paired with smp_mb__before_atomic() in
+		 * napi_enable(). Use READ_ONCE() to guarantee
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
@@ -6728,6 +6765,12 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
+	/* Create kthread for this napi if dev->threaded is set.
+	 * Clear dev->threaded if kthread creation failed so that
+	 * threaded mode will not be enabled in napi_enable().
+	 */
+	if (dev->threaded && napi_kthread_create(napi))
+		dev->threaded = 0;
 }
 EXPORT_SYMBOL(netif_napi_add);
 
@@ -6745,9 +6788,28 @@ void napi_disable(struct napi_struct *n)
 
 	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
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
+	smp_mb__before_atomic();
+	clear_bit(NAPI_STATE_SCHED, &n->state);
+	clear_bit(NAPI_STATE_NPSVC, &n->state);
+	if (n->dev->threaded && n->thread)
+		set_bit(NAPI_STATE_THREADED, &n->state);
+}
+EXPORT_SYMBOL(napi_enable);
+
 static void flush_gro_hash(struct napi_struct *napi)
 {
 	int i;
@@ -6773,6 +6835,11 @@ void __netif_napi_del(struct napi_struct *napi)
 
 	flush_gro_hash(napi);
 	napi->gro_bitmask = 0;
+
+	if (napi->thread) {
+		kthread_stop(napi->thread);
+		napi->thread = NULL;
+	}
 }
 EXPORT_SYMBOL(__netif_napi_del);
 
@@ -6867,6 +6934,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.30.0.478.g8a0d178c01-goog

