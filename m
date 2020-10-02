Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E610281E44
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgJBWZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBWZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:25:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB2C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:25:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d15so3238005ybk.0
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0wvsohMyHdXnObtAKPx1AR8JBXMOhGggZVbB5ys0L5s=;
        b=AIEpJtiDFEvHr83ipBkCQt5FpTrRj4QKNHnFl4BRHlmwqj3bIqJ3AOdaU0oOaUwF3C
         F33vTkcRyE9/uzsiHI2VEbK4w/YmZuWNGvZhKMmej3WLTlq+76B9gWQQ45ut1tOM9Ssd
         7uE8J3bRX0JfG9GgUvbZG8SXfXKFKQuH3YAEcIRu34/9NxmvtG4fJvkAdAMQV2Q1LBZR
         qrYIuxyZuAB5wruv/pfjFMkH69KoxNaF8jtp5gaZuLESk76j9kcBCWHrXrl9vjIzFmkq
         E3Ie/HD1u7aALy/QnkOuJrggmXXz/SHlOlGkX0diJILiboQdkrE0lqzO4nG/DAeyyDlm
         tClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0wvsohMyHdXnObtAKPx1AR8JBXMOhGggZVbB5ys0L5s=;
        b=hrVpPS80ftabT1a/AD2E3H5LbSuSQvC1kF9ekA3cx+QOZ4Bom9Zl1Y+dBbS8Ba347o
         7X7Kcy0UMivIx2TsV47soAjc2ak41XoKhGKZpD1eNauC2L5izwBuy8D5jm2x3D/yi3/w
         wlUVidwOOpYxT9s7YwpuU1IZ2OzWIiAenYOJ8FneNCJ2MOIw1jjrcnZaOoJiYJIoLsk8
         CcyJ5ljUvRonhgFgNMEANAqy2XD9E9Fm3a7yxMr6Ticw7R2a8DgJnbVqCTyddFc2B/Ab
         RbHKh737O0GLP/P2HNW+PevB3lp2TI22dO/r8QJznNY60lBDhIxvCiGbUDB79iPiPGaO
         fWZA==
X-Gm-Message-State: AOAM53018NkcJcoSXaBznyQFAWA5X5cYb5ImlqmAfWgkqzgQw1DBmLKS
        KEqJ3L8uxK8H7dGwM7acL4+oe7itPHE=
X-Google-Smtp-Source: ABdhPJwosaFiwKDOon6H7Coxg12th8+mIcV7NyqWbkjoSPslNu2OiBFqZ/rWxTYgWNjOrJVg2fgaGT6WOWo=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:dbcf:: with SMTP id g198mr5900208ybf.354.1601677534581;
 Fri, 02 Oct 2020 15:25:34 -0700 (PDT)
Date:   Fri,  2 Oct 2020 15:25:10 -0700
In-Reply-To: <20201002222514.1159492-1-weiwan@google.com>
Message-Id: <20201002222514.1159492-2-weiwan@google.com>
Mime-Version: 1.0
References: <20201002222514.1159492-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH net-next v2 1/5] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This patch allows running each napi poll loop inside its
own kernel thread.
The rx mode can be enabled per napi instance via the
newly addded napi_set_threaded() api; the requested kthread
will be created on demand and shut down on device stop.

Once that threaded mode is enabled and the kthread is
started, napi_schedule() will wake-up such thread instead
of scheduling the softirq.

The threaded poll loop behaves quite likely the net_rx_action,
but it does not have to manipulate local irqs and uses
an explicit scheduling point based on netdev_budget.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/linux/netdevice.h |   5 ++
 net/core/dev.c            | 113 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28cfa53daf72..b3516e77371e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -348,6 +348,7 @@ struct napi_struct {
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
+	struct task_struct	*thread;
 };
 
 enum {
@@ -358,6 +359,7 @@ enum {
 	NAPI_STATE_LISTED,	/* NAPI added to system lists */
 	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
 	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_THREADED,	/* The poll is performed inside its own thread*/
 };
 
 enum {
@@ -368,6 +370,7 @@ enum {
 	NAPIF_STATE_LISTED	 = BIT(NAPI_STATE_LISTED),
 	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
 	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
 };
 
 enum gro_result {
@@ -489,6 +492,8 @@ static inline bool napi_complete(struct napi_struct *n)
 	return napi_complete_done(n, 0);
 }
 
+int napi_set_threaded(struct napi_struct *n, bool threded);
+
 /**
  *	napi_disable - prevent NAPI from scheduling
  *	@n: NAPI context
diff --git a/net/core/dev.c b/net/core/dev.c
index 9d55bf5d1a65..259cd7f3434f 100644
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
@@ -1487,9 +1488,19 @@ void netdev_notify_peers(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_notify_peers);
 
+static int napi_threaded_poll(void *data);
+
+static void napi_thread_start(struct napi_struct *n)
+{
+	if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
+		n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
+					   n->dev->name, n->napi_id);
+}
+
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	struct napi_struct *n;
 	int ret;
 
 	ASSERT_RTNL();
@@ -1521,6 +1532,9 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
+	list_for_each_entry(n, &dev->napi_list, dev_list)
+		napi_thread_start(n);
+
 	netpoll_poll_enable(dev);
 
 	if (ret)
@@ -1566,6 +1580,14 @@ int dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 }
 EXPORT_SYMBOL(dev_open);
 
+static void napi_thread_stop(struct napi_struct *n)
+{
+	if (!n->thread)
+		return;
+	kthread_stop(n->thread);
+	n->thread = NULL;
+}
+
 static void __dev_close_many(struct list_head *head)
 {
 	struct net_device *dev;
@@ -1594,6 +1616,7 @@ static void __dev_close_many(struct list_head *head)
 
 	list_for_each_entry(dev, head, close_list) {
 		const struct net_device_ops *ops = dev->netdev_ops;
+		struct napi_struct *n;
 
 		/*
 		 *	Call the device specific close. This cannot fail.
@@ -1605,6 +1628,9 @@ static void __dev_close_many(struct list_head *head)
 		if (ops->ndo_stop)
 			ops->ndo_stop(dev);
 
+		list_for_each_entry(n, &dev->napi_list, dev_list)
+			napi_thread_stop(n);
+
 		dev->flags &= ~IFF_UP;
 		netpoll_poll_enable(dev);
 	}
@@ -4241,6 +4267,11 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
+	if (napi->thread) {
+		wake_up_process(napi->thread);
+		return;
+	}
+
 	list_add_tail(&napi->poll_list, &sd->poll_list);
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
@@ -6654,6 +6685,30 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+int napi_set_threaded(struct napi_struct *n, bool threaded)
+{
+	ASSERT_RTNL();
+
+	if (n->dev->flags & IFF_UP)
+		return -EBUSY;
+
+	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
+		return 0;
+	if (threaded)
+		set_bit(NAPI_STATE_THREADED, &n->state);
+	else
+		clear_bit(NAPI_STATE_THREADED, &n->state);
+
+	/* if the device is initializing, nothing todo */
+	if (test_bit(__LINK_STATE_START, &n->dev->state))
+		return 0;
+
+	napi_thread_stop(n);
+	napi_thread_start(n);
+	return 0;
+}
+EXPORT_SYMBOL(napi_set_threaded);
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6794,6 +6849,64 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	return work;
 }
 
+static int napi_thread_wait(struct napi_struct *napi)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
+		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
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
+
+	while (!napi_thread_wait(napi)) {
+		struct list_head dummy_repoll;
+		int budget = netdev_budget;
+		unsigned long time_limit;
+		bool again = true;
+
+		INIT_LIST_HEAD(&dummy_repoll);
+		local_bh_disable();
+		time_limit = jiffies + 2;
+		do {
+			/* ensure that the poll list is not empty */
+			if (list_empty(&dummy_repoll))
+				list_add(&napi->poll_list, &dummy_repoll);
+
+			budget -= napi_poll(napi, &dummy_repoll);
+			if (unlikely(budget <= 0 ||
+				     time_after_eq(jiffies, time_limit))) {
+				cond_resched();
+
+				/* refresh the budget */
+				budget = netdev_budget;
+				__kfree_skb_flush();
+				time_limit = jiffies + 2;
+			}
+
+			if (napi_disable_pending(napi))
+				again = false;
+			else if (!test_bit(NAPI_STATE_SCHED, &napi->state))
+				again = false;
+		} while (again);
+
+		__kfree_skb_flush();
+		local_bh_enable();
+	}
+	return 0;
+}
+
 static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
-- 
2.28.0.806.g8561365e88-goog

