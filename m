Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DF645F193
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhKZQUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:20:45 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60318 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378423AbhKZQSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:18:45 -0500
Date:   Fri, 26 Nov 2021 17:15:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637943331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3NPyJfAxI2QjSXyaUioepZSA2fN3iix7lUFwduAE7oQ=;
        b=TqXMzZaZDqdkXkHwPCHPUWMJVAmjMk6EgTr31O/ULgmB3PWbZi6y6MVWpO9ILHS/yhXxbj
        6p1wrV53c67MvzxOo6aOUYRg0PNOta6ung1+LUTqKq0q0LfnuyqzCfgBxLr9ivjUkFnJ8N
        haOsS8o7la4/L9fCDqHAh0Mbby7l8+lVxZ5vt+MUni761nc+yiBvQ0NlFd2fLqWWkHBaZY
        /Y2Wf/ZgIEiIW+ylFNYaYZuj7mFod886lALkrj9cT4lpZ7jl28JY2BU3DjkJA+rpTNkwII
        bKYR4PksOixKW38WIXeqBn0WDvi6ZcYHyU4t36NnUe03DDqG5dyd3XW4uSLKtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637943331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3NPyJfAxI2QjSXyaUioepZSA2fN3iix7lUFwduAE7oQ=;
        b=w2ffw5rnm8cqc5D+cd8dmERFqGqPbY1/oqAGB4zPc3SlJwqNQClNKjeRaMyLcrBaFTjhu9
        xgxEOocZvYyOhiDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Luis Goncalves <lgoncalv@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Pei Zhang <pezhang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next] net: Write lock dev_base_lock without disabling
 bottom halves.
Message-ID: <20211126161529.hwqbkv6z2svox3zs@linutronix.de>
References: <YVuviZ3F7MbPvleo@uudg.org>
 <20211011135609.22y7hkycbqm52w6d@linutronix.de>
 <20211011163601.m6j3ibb7ydeevpiz@linutronix.de>
 <CAD8J--8CjZym2afG3iSdztz51nOt9gmy747KPDxdmr1_WzwxcA@mail.gmail.com>
 <CAD8J---uJXqKeYR_3_8O5WPr9pVH8HX1DmGfE+7MdHDmaK4-Mw@mail.gmail.com>
 <CAD8J---a6X1u7SvKs5mR=EzxJ1uUxYZ0OGqM3PPq_LowBgY-Gw@mail.gmail.com>
 <20211125100109.qxc6k4a46s6ndv4e@linutronix.de>
 <20211125111124.sv7spgy2lm7qtxxc@linutronix.de>
 <CAD8J--91g575wynXdhOtcfCQ8wMiPzceWJx5sQrLscKdpZeeTg@mail.gmail.com>
 <CAD8J--_b7L-ZsVxz0Rvd2wUAH91fczfMRamUhhy+3Lig7B5fsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAD8J--_b7L-ZsVxz0Rvd2wUAH91fczfMRamUhhy+3Lig7B5fsg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The writer acquires dev_base_lock with disabled bottom halves.
The reader can acquire dev_base_lock without disabling bottom halves
because there is no writer in softirq context.

On PREEMPT_RT the softirqs are preemptible and local_bh_disable() acts
as a lock to ensure that resources, that are protected by disabling
bottom halves, remain protected.
This leads to a circular locking dependency if the lock acquired with
disabled bottom halves (as in write_lock_bh()) and somewhere else with
enabled bottom halves (as by read_lock() in netstat_show()) followed by
disabling bottom halves (cxgb_get_stats() -> t4_wr_mbox_meat_timeout()
-> spin_lock_bh()). This is the reverse locking order.

All read_lock() invocation are from sysfs callback which are not invoked
from softirq context. Therefore there is no need to disable bottom
halves while acquiring a write lock.

Acquire the write lock of dev_base_lock without disabling bottom halves.

Reported-by: Pei Zhang <pezhang@redhat.com>
Reported-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c        | 16 ++++++++--------
 net/core/link_watch.c |  4 ++--
 net/core/rtnetlink.c  |  8 ++++----
 net/hsr/hsr_device.c  |  6 +++---
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8b5cf8ad859b5..ad3cccbfa573b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -371,12 +371,12 @@ static void list_netdevice(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
 	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(net);
 }
@@ -389,11 +389,11 @@ static void unlist_netdevice(struct net_device *dev)
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
@@ -1272,15 +1272,15 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	netdev_adjacent_rename_links(dev, oldname);
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	netdev_name_node_del(dev->name_node);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	synchronize_rcu();
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	netdev_name_node_add(net, dev->name_node);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	ret = call_netdevice_notifiers(NETDEV_CHANGENAME, dev);
 	ret = notifier_to_errno(ret);
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 1a455847da54f..9599afd0862da 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -55,7 +55,7 @@ static void rfc2863_policy(struct net_device *dev)
 	if (operstate == dev->operstate)
 		return;
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 
 	switch(dev->link_mode) {
 	case IF_LINK_MODE_TESTING:
@@ -74,7 +74,7 @@ static void rfc2863_policy(struct net_device *dev)
 
 	dev->operstate = operstate;
 
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 }
 
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2af8aeeadadf0..716be2f88cd75 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -842,9 +842,9 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 	}
 
 	if (dev->operstate != operstate) {
-		write_lock_bh(&dev_base_lock);
+		write_lock(&dev_base_lock);
 		dev->operstate = operstate;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	}
 }
@@ -2779,11 +2779,11 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_LINKMODE]) {
 		unsigned char value = nla_get_u8(tb[IFLA_LINKMODE]);
 
-		write_lock_bh(&dev_base_lock);
+		write_lock(&dev_base_lock);
 		if (dev->link_mode ^ value)
 			status |= DO_SETLINK_NOTIFY;
 		dev->link_mode = value;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 	}
 
 	if (tb[IFLA_VFINFO_LIST]) {
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 737e4f17e1c6d..e57fdad9ef942 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -30,13 +30,13 @@ static bool is_slave_up(struct net_device *dev)
 
 static void __hsr_set_operstate(struct net_device *dev, int transition)
 {
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	if (dev->operstate != transition) {
 		dev->operstate = transition;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	} else {
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 	}
 }
 
-- 
2.34.0

