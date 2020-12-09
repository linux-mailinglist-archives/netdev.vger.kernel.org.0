Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B182D3805
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgLIAzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLIAzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:55:37 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6367C06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:54:50 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id t127so189060qkf.0
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 16:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=5OkKxgxDxxYnQ0ng7/ZnEnQTthDelIY86K9kd2On1/Y=;
        b=fCz2fIQJ3Oda7bPq/hzJlTifv6+d+eprOz45wq/fJwKNiFRd4ljgyX4y/wltr5ZlUA
         9bhXwKdxnTdYitj4xo9P2tSOxBfL3zNrSMYXtR3378zukUirh/MZFiAXTgdfh8VSY5Yv
         L+oLo7tWutcFwh6VOIPqesIeL/SpfX5GSzaNHNelXHQhk8+K8pXHAgUy4zf6NS/Q9ixn
         +H25P9Cn7iafFX20dYoiaD6fLCW+tWpB4HestU+RjxcfhEEyMj+lpXeBPmkDyFZorw8O
         W39uAFe2ZLT7/3tWytfWhhTU3N4JcYhOV2meMfzCDtc3C4UmTc0T68A5/YJgAZOKijiO
         ZMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5OkKxgxDxxYnQ0ng7/ZnEnQTthDelIY86K9kd2On1/Y=;
        b=Tg5ZsYnneMo/JTZZmq37Gzr6eJ7X60LJ4nwwzkHz58OngxoopGdA/LKz8wqPnOxwRM
         +PKSp6KDByvxTfwCVN/hQJ9hokzY/dswwW28ooKAgef60hrh9K0odNtyePhvw1sWIhC1
         3PiKA/RKn0iYTgY/uCSodWiLkLJcF0tpEhjeaJmRsK+zUmz8T1mfX/QH1px29H9Aav1O
         xFSHiHOw5XCnsuYVM+uccAZxYnsUYPYLqyjsn/1gM6USg2jlx5vHCOpTfeWzmh3pigT3
         iJ0ztzPT70tMHH3Lx8eqETO6+p/Leg2mNxdZKO7YfreXsW++Q//U+MU7SOgMD4HFA4uz
         VXMw==
X-Gm-Message-State: AOAM532VqiLvunGGogDKck8yri3i2OcIXkyngaYmj+0DipHC3dTzlryj
        /W4CTtt8ITWue+q/K2i2q4TlaYZHHyM=
X-Google-Smtp-Source: ABdhPJzktaCyiHqEDHiniMaumGrrJu1xbr1PiQJdIXYwHaR3my9nRJrCbXgcyDVgE5sTlwOxkAyiHRtZHWc=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:f046:: with SMTP id b6mr285531qvl.14.1607475290114;
 Tue, 08 Dec 2020 16:54:50 -0800 (PST)
Date:   Tue,  8 Dec 2020 16:54:43 -0800
In-Reply-To: <20201209005444.1949356-1-weiwan@google.com>
Message-Id: <20201209005444.1949356-3-weiwan@google.com>
Mime-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v4 2/3] net: implement threaded-able napi poll loop support
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |   5 ++
 net/core/dev.c            | 105 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bf167993c05..abd3b52b7da6 100644
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
@@ -495,6 +498,8 @@ static inline bool napi_complete(struct napi_struct *n)
 	return napi_complete_done(n, 0);
 }
 
+int napi_set_threaded(struct napi_struct *n, bool threaded);
+
 /**
  *	napi_disable - prevent NAPI from scheduling
  *	@n: NAPI context
diff --git a/net/core/dev.c b/net/core/dev.c
index 8064af1dd03c..cb6c4e2363a4 100644
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
 
+int napi_set_threaded(struct napi_struct *n, bool threaded)
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
@@ -6731,6 +6790,7 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_kthread_stop(n);
 
 	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
@@ -6859,6 +6919,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.29.2.576.ga3fc446d84-goog

