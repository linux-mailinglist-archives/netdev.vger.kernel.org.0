Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C81303503
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbhAZFcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730587AbhAZBcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:32:24 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DCDC061A32
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:11:15 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id b8so8377326qtr.18
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=MOobICiR3lrbiPVGXKBGqp4xvGAkQMkkuE51Yamln9Q=;
        b=aqRukVX3USA+ufIbk27Sobkm9wIL1cdiYPc1YSEiIpLuc8O9t99Wg6HMtO6WcppHAE
         TkH6tkRXn1kEdsH2vh2cTf3GJsBzqmDaSWIeY7FGLaKkmQQbpsc+TBK2E0ud64SClbYR
         K1y5t6Yz46Fet3r1cUnAMilqf0dlQq9QM9X0zg0hUFpeNOG3PwmSfj8gRssWSx7BdsPJ
         JjdyLWpWNQRfFiDcR15nn4U3E6SEi8Wk3C+ebU9zlXv4+x0N2dqLW6xuD0kAVMtPt+Py
         3xREe5Fl05TClQtLq04DNqGkuMtTb32v1TUJNrwbTbmo1HE2OC6v7Av/maKQnEnjXwEk
         RjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MOobICiR3lrbiPVGXKBGqp4xvGAkQMkkuE51Yamln9Q=;
        b=BakodpbfcpIUFvEgTOy4+8+YpTTu/LbnYpMjTQsZ4nTkIy7LqRB+2OGmek8BwxwMMM
         5ulHMIkphcnLcnHFsMHVHbv5T2Ud5xc976/J0RJoFsqwwScaW4lXSJPkITPERGwquhO2
         GIc0vN6BfIktLM9JZsOau0WA06yq4EUM41auTXSfbTJpL1Zb+No6CRAbR5gn6FGfbwJW
         eHic0akhYkmT3cExemYCThSIXGLSauvN/kq22N3KgsPXXMB5U1eGzG8weNEyM0ggtxNo
         C7cEfhQZymY93H0ly4QPXF0JFjivkPgAKaZaK2dR6h2VN149/gbkxNm2BEMj8Ie00YO5
         7ybQ==
X-Gm-Message-State: AOAM533HP+EGJaD06IRSG/irVdnrCQ3T4sWDJXkBQtuuhn5LYiV8sxoP
        bST0oKQy1Cg15qKtXiF88snNV5U/czs=
X-Google-Smtp-Source: ABdhPJwWt2nKiSwjPb4fjgnxLi6nBidkIu7YDZF0DAtWye7ReHIIjnVLsPKnwi4H0mqab4/G8+jdlsAsYBk=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:9e2d:: with SMTP id p45mr3519540qve.40.1611623474998;
 Mon, 25 Jan 2021 17:11:14 -0800 (PST)
Date:   Mon, 25 Jan 2021 17:11:08 -0800
In-Reply-To: <20210126011109.2425966-1-weiwan@google.com>
Message-Id: <20210126011109.2425966-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210126011109.2425966-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH net-next v8 2/3] net: implement threaded-able napi poll loop support
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
 include/linux/netdevice.h |  19 ++-----
 net/core/dev.c            | 117 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 14 deletions(-)

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
index 7d23bff03864..743dd69fba19 100644
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
@@ -6720,6 +6767,12 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
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
 
@@ -6734,12 +6787,31 @@ void napi_disable(struct napi_struct *n)
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
@@ -6862,6 +6934,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.30.0.280.ga3ce27912f-goog

