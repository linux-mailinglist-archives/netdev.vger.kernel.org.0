Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DBD30FF59
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhBDVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBDVcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:32:05 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96430C06178B
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 13:31:24 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id b1so3287053qvk.17
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 13:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=mQbZ39SMxx0go79W9ZRo8vRHwIKeCMnLqq3TMUcC4Sg=;
        b=UG/KfyUNRVhFZqTWlta3mmkJIKJ5h2CZuOU4VLk8rSInvDxMDs/K+a4w/8zhafE7AP
         E7tPU2cyshh9uoMRcySMwNzPqLSurcoKvNT7iYcvb7I3vHQKnucPtw+VrwkIdDjgMuZl
         mwkxpkznBxIPTp4mZPGZvrs7oU+ZO8dhUiGCk/+jL5HgiDYQKo5QIehVguDhzQKM3j50
         AOAjYD/x74oGArU0SnfEt6G+m5oxz74VdoMZICnm+BKRzFEcJQMPNBh/1r3JHPmGFSN1
         sNVb4K50VsxvXfLf5M8p7UwIGe/NYtP8ZSHNwBCMPa4jE9BgigCh/9gVCZQmob/fsrAb
         W3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mQbZ39SMxx0go79W9ZRo8vRHwIKeCMnLqq3TMUcC4Sg=;
        b=SYwAJkuNL/u9vGoi6b6g7pxYKTZjhuVSRYnI62/hrinczBHJLcELVSA+LJCZa7BGfr
         qcL7amDgnazmx7ygepTZPxVZViKwtqhunqclbpGG/rsLYpt9BTD0TJASrr2EOIVWzHsW
         rLIxWlQLYR1ASCRVd9dKHCER7C6VUYEFGy0EoGYVTt6qsMNCN6mrpdBsskk4dN3SphYE
         RbJ8XnsAiOPirABLiwmNoGFhcdX446MZN7CUyMro6B/n+9rYIrLkLyFYOO9DO4MxNuS3
         U+NqInwCL6vmBYlbqaU+m4fi9uNE+mUM8iia1lkgblt/tkiuwdJUjythRHDF6ruG47DK
         Yq5g==
X-Gm-Message-State: AOAM530uL4I3GgLZ2xxHW+eLrBm8c/12gcxKycFpD/qu76NuU++gnzU7
        FsIUpEUUaaP1NIE+bguUPeYtobxwbAk=
X-Google-Smtp-Source: ABdhPJw1rrbj0xKL4R7HNO7KIlBiV8kF2EdpsU1Lmbl5Xd5iMwHZx+DIQgNHMwHDbLW1Bf0LcnZWCTFkpkI=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:819e:a51d:5f26:827c])
 (user=weiwan job=sendgmr) by 2002:a05:6214:9d3:: with SMTP id
 dp19mr1335290qvb.40.1612474283801; Thu, 04 Feb 2021 13:31:23 -0800 (PST)
Date:   Thu,  4 Feb 2021 13:31:16 -0800
In-Reply-To: <20210204213117.1736289-1-weiwan@google.com>
Message-Id: <20210204213117.1736289-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210204213117.1736289-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v10 2/3] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexanderduyck@fb.com>
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
index 0fd40b9847c3..a8c5eca17074 100644
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
@@ -1493,6 +1494,27 @@ void netdev_notify_peers(struct net_device *dev)
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
@@ -4264,6 +4286,21 @@ int gro_normal_batch __read_mostly = 8;
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
@@ -6733,6 +6770,12 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
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
 
@@ -6750,9 +6793,28 @@ void napi_disable(struct napi_struct *n)
 
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
@@ -6778,6 +6840,11 @@ void __netif_napi_del(struct napi_struct *napi)
 
 	flush_gro_hash(napi);
 	napi->gro_bitmask = 0;
+
+	if (napi->thread) {
+		kthread_stop(napi->thread);
+		napi->thread = NULL;
+	}
 }
 EXPORT_SYMBOL(__netif_napi_del);
 
@@ -6872,6 +6939,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.30.0.365.g02bc693789-goog

