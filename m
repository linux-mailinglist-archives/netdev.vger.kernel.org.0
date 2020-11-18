Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF872B854B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgKRUHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:07:16 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09E0C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:16 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j12so1850933plj.20
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jIQIpkd1u2dhmvMkde7f4Crf0+RGMzwf23gd/v5mBFA=;
        b=Q8D/uSGI/yz/Zx6wPl0CT4F5vE7H+e4cqBz+Zg8lKhY0Hmn3+DCf5cETP/Ub6orSMJ
         Uts3NXD8msRUKyOjuWA2Gmck5Tg/Xe3aKUZJTdgOLuWmh69qm0qRZfqhXCdiaxWw3fdi
         wHVSxEsB3QSWCV9VeNsjl7lGnHHeSJY9lj/dH5CHOGDGMsxXlGA8oZHC7CJmgrW1wcwm
         xoE2OG4dlAqWNvc7sD82XDdRn0g2aG0FaRRbnzq2pJ9wqHvmumNwH3lEqfVfncsfEpwB
         vhkjfQFDzTGO0M6Xr2JEh9eIeITjSDCmZAcout2L/vpLxZH2Bmg+fxVLZiWV6SA14bJS
         rD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jIQIpkd1u2dhmvMkde7f4Crf0+RGMzwf23gd/v5mBFA=;
        b=G3Iu8fbZjfZ2hr2pKfEIJxxxCQtXHJc+mY5qnvKQCr0yrAgWr4HFsG2cS8v1xmtymi
         uTYGV/9oSERXocXJHE9jpARTdmg6kQ6dwonNWnS3u2c1+9dcxnWulVB/yXI/gMWM4cNj
         Y/f8lpfzj/4QnYi+ZXQrQDtTK4OJZOLL5+u+lXg47Oab5FtZiOcgRfx+JGpb1KEU5omA
         qa5UENTFqkqxdJF45kMJM9ccocWH5rkHXAWqaJrb7ggqonEXVJejtre3IzihMqJsK/2D
         RLMuudW+Jmt3NeKbY5S1t1GKTgdxJKhMYiEOipTl/7kuk3Nq8H1gPjo53PCsYiMDr6CW
         C4tg==
X-Gm-Message-State: AOAM531szAGMn4fs1P4cGNvVn5BPqnp54L/9BkmqMcSNN2of+Jg+LbIR
        ShSnppBJd/gR4k2BlYMWeGDm8ssXRg8=
X-Google-Smtp-Source: ABdhPJyVw0xqrq0vSmAc4B5DTUNbhlxN3NCJ3Xc+u7vW6IkFXeZJwoFLe20zg26PNsA7uS0KTAGQ8MQkzSI=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a62:8cd6:0:b029:18b:ad92:503b with SMTP id
 m205-20020a628cd60000b029018bad92503bmr5962239pfd.77.1605730036412; Wed, 18
 Nov 2020 12:07:16 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:10:05 -0800
In-Reply-To: <20201118191009.3406652-1-weiwan@google.com>
Message-Id: <20201118191009.3406652-2-weiwan@google.com>
Mime-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v3 1/5] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |   5 ++
 net/core/dev.c            | 113 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 03433a4c929e..5ba430f56085 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -347,6 +347,7 @@ struct napi_struct {
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
+	struct task_struct	*thread;
 };
 
 enum {
@@ -357,6 +358,7 @@ enum {
 	NAPI_STATE_LISTED,	/* NAPI added to system lists */
 	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
 	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_THREADED,	/* The poll is performed inside its own thread*/
 };
 
 enum {
@@ -367,6 +369,7 @@ enum {
 	NAPIF_STATE_LISTED	 = BIT(NAPI_STATE_LISTED),
 	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
 	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
 };
 
 enum gro_result {
@@ -488,6 +491,8 @@ static inline bool napi_complete(struct napi_struct *n)
 	return napi_complete_done(n, 0);
 }
 
+int napi_set_threaded(struct napi_struct *n, bool threaded);
+
 /**
  *	napi_disable - prevent NAPI from scheduling
  *	@n: NAPI context
diff --git a/net/core/dev.c b/net/core/dev.c
index 4bfdcd6b20e8..a5d2ead8be78 100644
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
@@ -1488,9 +1489,19 @@ void netdev_notify_peers(struct net_device *dev)
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
@@ -1522,6 +1533,9 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
+	list_for_each_entry(n, &dev->napi_list, dev_list)
+		napi_thread_start(n);
+
 	netpoll_poll_enable(dev);
 
 	if (ret)
@@ -1567,6 +1581,14 @@ int dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
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
@@ -1595,6 +1617,7 @@ static void __dev_close_many(struct list_head *head)
 
 	list_for_each_entry(dev, head, close_list) {
 		const struct net_device_ops *ops = dev->netdev_ops;
+		struct napi_struct *n;
 
 		/*
 		 *	Call the device specific close. This cannot fail.
@@ -1606,6 +1629,9 @@ static void __dev_close_many(struct list_head *head)
 		if (ops->ndo_stop)
 			ops->ndo_stop(dev);
 
+		list_for_each_entry(n, &dev->napi_list, dev_list)
+			napi_thread_stop(n);
+
 		dev->flags &= ~IFF_UP;
 		netpoll_poll_enable(dev);
 	}
@@ -4245,6 +4271,11 @@ int gro_normal_batch __read_mostly = 8;
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
@@ -6667,6 +6698,30 @@ static void init_gro_hash(struct napi_struct *napi)
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
@@ -6807,6 +6862,64 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.29.2.454.gaff20da3a2-goog

