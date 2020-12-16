Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685B42DB869
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgLPB0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPB0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:26:02 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECD1C06179C
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:21 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id f19so15647005qtx.6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wc08jhTKe61pucxXWhT8a/zzyWuJsW+HuuhpSi6ecMo=;
        b=C6bAgOEYVtqK3I0ZU7oUjxV5kBw9tpAUotTGIbb/kxfY8WgxP6LcLf59vtsM/eTjeL
         8KtdZ16a+yrhEJGpzc8VX1FMC6PobDTb0NZLgFwW5yQ5oozbrX+hX7or4/LOnf19xzm8
         pcflqd1AIa1HHQdvhFv5QViGbEOFjFjlBl7+6SftN9x7KkOfdxpfh1Iw148es+MYXuIv
         MYc9SFhBqOXl53nzBw4+1331Fk7/RVfoBuEr7nXxWGQMjLgpWPbZLdgkhgTYUGZzIiW5
         xzp7TWbv6NwTH0nUWk+pgomRND7voeVvdlWG1QzM4QkcMxoOGjU7eDiuO7Tyh9xoC/cn
         HoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wc08jhTKe61pucxXWhT8a/zzyWuJsW+HuuhpSi6ecMo=;
        b=c6wup3MgQfMNOH5ieKaooYxCqY9QIr9L/ohFPBDbxDhrt0xV6/i76l87CXO6U7s2DO
         ddKBH0Y0Q/atOYeiWXFLsg5BBaZG9DW8r6MfAVqy6vZJD6fC73fY6Zwrg7luk2USlnk1
         6e6ZFpe/wX/1QaGW7AuoMMUfQ7Dn74+ei0nromCvFTNDfg6JVQyYzZPRuozs8PGOnJ+y
         ZLMR4Q2DdZOY+b86Lf4+hXznl9YIf2CjOPK39E+oztPvL5kHFWkN7K4V8jNDMGFvvckp
         kMrXtTMS+oL2LDItaX8CClP/j6nBl+/BB8MB1nvuunupoj19swKkr+IBfVwe2CHdTapQ
         ZdJA==
X-Gm-Message-State: AOAM532E/fLzcdpHS1tpFpuASv3+fXmFDSRp4Rk0xu1/8njj/WmmvGx9
        VQVGoBhjwZaeSnP/KZW6xQjb1zNhcSA=
X-Google-Smtp-Source: ABdhPJyKRjZNCuG/qVcbjfWdYXz8UUbtcPrWJueqKJKanT2307LeMQNNx7YC1N/+rxrL2hP7TnwEE+tGBz4=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:ad4:476c:: with SMTP id d12mr39676544qvx.20.1608081920933;
 Tue, 15 Dec 2020 17:25:20 -0800 (PST)
Date:   Tue, 15 Dec 2020 17:25:14 -0800
In-Reply-To: <20201216012515.560026-1-weiwan@google.com>
Message-Id: <20201216012515.560026-3-weiwan@google.com>
Mime-Version: 1.0
References: <20201216012515.560026-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH net-next v5 2/3] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
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
an explicit scheduling point based on netdev_budget.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/linux/netdevice.h |  12 ++--
 net/core/dev.c            | 121 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bf167993c05..2cd1e3975103 100644
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
@@ -511,13 +514,7 @@ void napi_disable(struct napi_struct *n);
  * Resume NAPI from being scheduled on this context.
  * Must be paired with napi_disable.
  */
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
@@ -2158,6 +2155,7 @@ struct net_device {
 	struct lock_class_key	*qdisc_tx_busylock;
 	struct lock_class_key	*qdisc_running_key;
 	bool			proto_down;
+	bool			threaded;
 	unsigned		wol_enabled:1;
 
 	struct list_head	net_notifier_list;
diff --git a/net/core/dev.c b/net/core/dev.c
index adf74573f51c..47c33affaa80 100644
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
@@ -1475,6 +1476,36 @@ void netdev_notify_peers(struct net_device *dev)
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
+	kthread_stop(n->thread);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
+	n->thread = NULL;
+}
+
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -4234,6 +4265,11 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
+		wake_up_process(napi->thread);
+		return;
+	}
+
 	list_add_tail(&napi->poll_list, &sd->poll_list);
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
@@ -6690,6 +6726,29 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+static int napi_set_threaded(struct napi_struct *n, bool threaded)
+{
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
+		return 0;
+	if (threaded) {
+		if (!n->thread) {
+			err = napi_kthread_create(n);
+			if (err)
+				goto out;
+		}
+		set_bit(NAPI_STATE_THREADED, &n->state);
+	} else {
+		clear_bit(NAPI_STATE_THREADED, &n->state);
+	}
+
+out:
+	return err;
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6731,12 +6790,29 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_kthread_stop(n);
 
 	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
 
+void napi_enable(struct napi_struct *n)
+{
+	bool locked = rtnl_is_locked();
+
+	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
+	smp_mb__before_atomic();
+	clear_bit(NAPI_STATE_SCHED, &n->state);
+	clear_bit(NAPI_STATE_NPSVC, &n->state);
+	if (!locked)
+		rtnl_lock();
+	WARN_ON(napi_set_threaded(n, n->dev->threaded));
+	if (!locked)
+		rtnl_unlock();
+}
+EXPORT_SYMBOL(napi_enable);
+
 static void flush_gro_hash(struct napi_struct *napi)
 {
 	int i;
@@ -6859,6 +6935,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.29.2.684.gfbc64c5ab5-goog

