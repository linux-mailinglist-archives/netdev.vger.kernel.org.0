Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ECA27901F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgIYSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIYSNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:13:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADC9C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:13:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b17so2137237pji.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dmrrI6hA8rqLLdoIyKYOn7OyD0r3xAzRz/h2DV9AWwY=;
        b=vbIBpu42ufSXxHLP7x5lscpU0dVwajWcHSeaSUjGvuvRsOaVjiGKH9HqVs6PrH/2ur
         q+FNcXwTcmABubRcN8hr9pL1TqH+OtGl18TWLKOt3tvdQBzfoYj+sR7BFL7rN78WBwLz
         Z2sJAmS4QDDWvpW+UBh3Gcb1xJxtgowpsQHHYZBh6+eK81PW0tezBo2BpjxNfsgiTZuz
         gpOC9p01CYWeeUjTndNTpldqTXka3TAmBzXelljd/eqZ7o5Gx+z3tPDY5UDxShDEm+8/
         XPAwU9YB9XzHfqrncJOHGdNxmTQHFkJrVs+8FOVuEcoFwA2AvweAQyUyFOaXcbFZpKkV
         pFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dmrrI6hA8rqLLdoIyKYOn7OyD0r3xAzRz/h2DV9AWwY=;
        b=VyOIjZCgDUVAVD7p4YoPIcCls7DB4TVYKJOMqcZMcUGXYxbOdSfgFo6qNlsPSVPOwv
         8jeRcB/b7chNw0ljtujGDK2AddvTSSdEutU4YONzRiHoAp1NwTghvAbnEjyuD7+KHUvI
         8nQgneEZRV86Vm2X8ILh3Cyvee83yCrMdkqyvh3cx7Ee3+t8qUXnbAUlr4EM2YJPxkfA
         gDLwGeiXgs3hQQkYNm0cWRZlnknjPdbp+S2L+gaFh661Gu9AIRsmx8bpOMYxpFSpZuzk
         r8CiG5ceB1p8hp3cmudznSrn2iYNSVjc7lIZEuTm3eYocFACT0bj45BTkSKx/4naTUHP
         q+/w==
X-Gm-Message-State: AOAM533vMJNkryHtdBPmezlb7WAc50uMPlZLF6a9yNYghpmEylbkOvwh
        Bz9eUmpVbUA+Cp7B5po/m1c=
X-Google-Smtp-Source: ABdhPJyRwTC8hFgfb3V/8NVkQIa4nDYwwsxzrL1H53hKrLTDE8bmhi4ZOjZ4z2shF6EJDE9VTY0fiw==
X-Received: by 2002:a17:90b:793:: with SMTP id l19mr768955pjz.154.1601057616763;
        Fri, 25 Sep 2020 11:13:36 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n9sm2820858pgi.2.2020.09.25.11.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:13:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, xiyou.wangcong@gmail.com
Subject: [PATCH net 3/3] net: core: add nested_level variable in net_device
Date:   Fri, 25 Sep 2020 18:13:29 +0000
Message-Id: <20200925181329.25303-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add a new variable 'nested_level' into the net_device
structure.
This variable will be used as a parameter of spin_lock_nested() of
dev->addr_list_lock.

netif_addr_lock() can be called recursively so spin_lock_nested() is
used instead of spin_lock() and dev->lower_level is used as a parameter
of spin_lock_nested().
But, dev->lower_level value can be updated while it is being used.
So, lockdep would warn a possible deadlock scenario.

When a stacked interface is deleted, netif_{uc | mc}_sync() is
called recursively.
So, spin_lock_nested() is called recursively too.
At this moment, the dev->lower_level variable is used as a parameter of it.
dev->lower_level value is updated when interfaces are being unlinked/linked
immediately.
Thus, After unlinking, dev->lower_level shouldn't be a parameter of
spin_lock_nested().

    A (macvlan)
    |
    B (vlan)
    |
    C (bridge)
    |
    D (macvlan)
    |
    E (vlan)
    |
    F (bridge)

    A->lower_level : 6
    B->lower_level : 5
    C->lower_level : 4
    D->lower_level : 3
    E->lower_level : 2
    F->lower_level : 1

When an interface 'A' is removed, it releases resources.
At this moment, netif_addr_lock() would be called.
Then, netdev_upper_dev_unlink() is called recursively.
Then dev->lower_level is updated.
There is no problem.

But, when the bridge module is removed, 'C' and 'F' interfaces
are removed at once.
If 'F' is removed first, a lower_level value is like below.
    A->lower_level : 5
    B->lower_level : 4
    C->lower_level : 3
    D->lower_level : 2
    E->lower_level : 1
    F->lower_level : 1

Then, 'C' is removed. at this moment, netif_addr_lock() is called
recursively.
The ordering is like this.
C(3)->D(2)->E(1)->F(1)
At this moment, the lower_level value of 'E' and 'F' are the same.
So, lockdep warns a possible deadlock scenario.

In order to avoid this problem, a new variable 'nested_level' is added.
This value is the same as dev->lower_level - 1.
But this value is updated in rtnl_unlock().
So, this variable can be used as a parameter of spin_lock_nested() safely
in the rtnl context.

Test commands:
   ip link add br0 type bridge vlan_filtering 1
   ip link add vlan1 link br0 type vlan id 10
   ip link add macvlan2 link vlan1 type macvlan
   ip link add br3 type bridge vlan_filtering 1
   ip link set macvlan2 master br3
   ip link add vlan4 link br3 type vlan id 10
   ip link add macvlan5 link vlan4 type macvlan
   ip link add br6 type bridge vlan_filtering 1
   ip link set macvlan5 master br6
   ip link add vlan7 link br6 type vlan id 10
   ip link add macvlan8 link vlan7 type macvlan

   ip link set br0 up
   ip link set vlan1 up
   ip link set macvlan2 up
   ip link set br3 up
   ip link set vlan4 up
   ip link set macvlan5 up
   ip link set br6 up
   ip link set vlan7 up
   ip link set macvlan8 up
   modprobe -rv bridge

Splat looks like:
[   36.057436][  T744] WARNING: possible recursive locking detected
[   36.058848][  T744] 5.9.0-rc6+ #728 Not tainted
[   36.059959][  T744] --------------------------------------------
[   36.061391][  T744] ip/744 is trying to acquire lock:
[   36.062590][  T744] ffff8c4767509280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: dev_set_rx_mode+0x19/0x30
[   36.064922][  T744]
[   36.064922][  T744] but task is already holding lock:
[   36.066626][  T744] ffff8c4767769280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: dev_uc_add+0x1e/0x60
[   36.068851][  T744]
[   36.068851][  T744] other info that might help us debug this:
[   36.070731][  T744]  Possible unsafe locking scenario:
[   36.070731][  T744]
[   36.072497][  T744]        CPU0
[   36.073238][  T744]        ----
[   36.074007][  T744]   lock(&vlan_netdev_addr_lock_key);
[   36.075290][  T744]   lock(&vlan_netdev_addr_lock_key);
[   36.076590][  T744]
[   36.076590][  T744]  *** DEADLOCK ***
[   36.076590][  T744]
[   36.078515][  T744]  May be due to missing lock nesting notation
[   36.078515][  T744]
[   36.080491][  T744] 3 locks held by ip/744:
[   36.081471][  T744]  #0: ffffffff98571df0 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x236/0x490
[   36.083614][  T744]  #1: ffff8c4767769280 (&vlan_netdev_addr_lock_key){+...}-{2:2}, at: dev_uc_add+0x1e/0x60
[   36.085942][  T744]  #2: ffff8c476c8da280 (&bridge_netdev_addr_lock_key/4){+...}-{2:2}, at: dev_uc_sync+0x39/0x80
[   36.088400][  T744]
[   36.088400][  T744] stack backtrace:
[   36.089772][  T744] CPU: 6 PID: 744 Comm: ip Not tainted 5.9.0-rc6+ #728
[   36.091364][  T744] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   36.093630][  T744] Call Trace:
[   36.094416][  T744]  dump_stack+0x77/0x9b
[   36.095385][  T744]  __lock_acquire+0xbc3/0x1f40
[   36.096522][  T744]  lock_acquire+0xb4/0x3b0
[   36.097540][  T744]  ? dev_set_rx_mode+0x19/0x30
[   36.098657][  T744]  ? rtmsg_ifinfo+0x1f/0x30
[   36.099711][  T744]  ? __dev_notify_flags+0xa5/0xf0
[   36.100874][  T744]  ? rtnl_is_locked+0x11/0x20
[   36.101967][  T744]  ? __dev_set_promiscuity+0x7b/0x1a0
[   36.103230][  T744]  _raw_spin_lock_bh+0x38/0x70
[   36.104348][  T744]  ? dev_set_rx_mode+0x19/0x30
[   36.105461][  T744]  dev_set_rx_mode+0x19/0x30
[   36.106532][  T744]  dev_set_promiscuity+0x36/0x50
[   36.107692][  T744]  __dev_set_promiscuity+0x123/0x1a0
[   36.108929][  T744]  dev_set_promiscuity+0x1e/0x50
[   36.110093][  T744]  br_port_set_promisc+0x1f/0x40 [bridge]
[   36.111415][  T744]  br_manage_promisc+0x8b/0xe0 [bridge]
[   36.112728][  T744]  __dev_set_promiscuity+0x123/0x1a0
[   36.113967][  T744]  ? __hw_addr_sync_one+0x23/0x50
[   36.115135][  T744]  __dev_set_rx_mode+0x68/0x90
[   36.116249][  T744]  dev_uc_sync+0x70/0x80
[   36.117244][  T744]  dev_uc_add+0x50/0x60
[   36.118223][  T744]  macvlan_open+0x18e/0x1f0 [macvlan]
[   36.119470][  T744]  __dev_open+0xd6/0x170
[   36.120470][  T744]  __dev_change_flags+0x181/0x1d0
[   36.121644][  T744]  dev_change_flags+0x23/0x60
[   36.122741][  T744]  do_setlink+0x30a/0x11e0
[   36.123778][  T744]  ? __lock_acquire+0x92c/0x1f40
[   36.124929][  T744]  ? __nla_validate_parse.part.6+0x45/0x8e0
[   36.126309][  T744]  ? __lock_acquire+0x92c/0x1f40
[   36.127457][  T744]  __rtnl_newlink+0x546/0x8e0
[   36.128560][  T744]  ? lock_acquire+0xb4/0x3b0
[   36.129623][  T744]  ? deactivate_slab.isra.85+0x6a1/0x850
[   36.130946][  T744]  ? __lock_acquire+0x92c/0x1f40
[   36.132102][  T744]  ? lock_acquire+0xb4/0x3b0
[   36.133176][  T744]  ? is_bpf_text_address+0x5/0xe0
[   36.134364][  T744]  ? rtnl_newlink+0x2e/0x70
[   36.135445][  T744]  ? rcu_read_lock_sched_held+0x32/0x60
[   36.136771][  T744]  ? kmem_cache_alloc_trace+0x2d8/0x380
[   36.138070][  T744]  ? rtnl_newlink+0x2e/0x70
[   36.139164][  T744]  rtnl_newlink+0x47/0x70
[ ... ]

Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/linux/netdevice.h | 52 ++++++++++++++++++++----
 net/core/dev.c            | 85 +++++++++++++++++++++++++++++++++------
 net/core/dev_addr_lists.c | 12 +++---
 3 files changed, 122 insertions(+), 27 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 313803d6c781..9fdb3ebef306 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1955,6 +1955,7 @@ struct net_device {
 	unsigned short		type;
 	unsigned short		hard_header_len;
 	unsigned char		min_header_len;
+	unsigned char		name_assign_type;
 
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
@@ -1965,21 +1966,28 @@ struct net_device {
 	unsigned char		addr_len;
 	unsigned char		upper_level;
 	unsigned char		lower_level;
+
 	unsigned short		neigh_priv_len;
 	unsigned short          dev_id;
 	unsigned short          dev_port;
 	spinlock_t		addr_list_lock;
-	unsigned char		name_assign_type;
-	bool			uc_promisc;
+
 	struct netdev_hw_addr_list	uc;
 	struct netdev_hw_addr_list	mc;
 	struct netdev_hw_addr_list	dev_addrs;
 
 #ifdef CONFIG_SYSFS
 	struct kset		*queues_kset;
+#endif
+#ifdef CONFIG_LOCKDEP
+	struct list_head	unlink_list;
 #endif
 	unsigned int		promiscuity;
 	unsigned int		allmulti;
+	bool			uc_promisc;
+#ifdef CONFIG_LOCKDEP
+	unsigned char		nested_level;
+#endif
 
 
 	/* Protocol-specific pointers */
@@ -4260,17 +4268,23 @@ static inline void netif_tx_disable(struct net_device *dev)
 
 static inline void netif_addr_lock(struct net_device *dev)
 {
-	spin_lock(&dev->addr_list_lock);
-}
+	unsigned char nest_level = 0;
 
-static inline void netif_addr_lock_nested(struct net_device *dev)
-{
-	spin_lock_nested(&dev->addr_list_lock, dev->lower_level);
+#ifdef CONFIG_LOCKDEP
+	nest_level = dev->nested_level;
+#endif
+	spin_lock_nested(&dev->addr_list_lock, nest_level);
 }
 
 static inline void netif_addr_lock_bh(struct net_device *dev)
 {
-	spin_lock_bh(&dev->addr_list_lock);
+	unsigned char nest_level = 0;
+
+#ifdef CONFIG_LOCKDEP
+	nest_level = dev->nested_level;
+#endif
+	local_bh_disable();
+	spin_lock_nested(&dev->addr_list_lock, nest_level);
 }
 
 static inline void netif_addr_unlock(struct net_device *dev)
@@ -4455,7 +4469,19 @@ extern int		dev_rx_weight;
 extern int		dev_tx_weight;
 extern int		gro_normal_batch;
 
+enum {
+	NESTED_SYNC_IMM_BIT,
+	NESTED_SYNC_TODO_BIT,
+};
+
+#define __NESTED_SYNC_BIT(bit)	((u32)1 << (bit))
+#define __NESTED_SYNC(name)	__NESTED_SYNC_BIT(NESTED_SYNC_ ## name ## _BIT)
+
+#define NESTED_SYNC_IMM		__NESTED_SYNC(IMM)
+#define NESTED_SYNC_TODO	__NESTED_SYNC(TODO)
+
 struct netdev_nested_priv {
+	unsigned char flags;
 	void *data;
 };
 
@@ -4465,6 +4491,16 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 struct net_device *netdev_all_upper_get_next_dev_rcu(struct net_device *dev,
 						     struct list_head **iter);
 
+#ifdef CONFIG_LOCKDEP
+static LIST_HEAD(net_unlink_list);
+
+static inline void net_unlink_todo(struct net_device *dev)
+{
+	if (list_empty(&dev->unlink_list))
+		list_add_tail(&dev->unlink_list, &net_unlink_list);
+}
+#endif
+
 /* iterate through upper list, must be called under RCU read lock */
 #define netdev_for_each_upper_dev_rcu(dev, updev, iter) \
 	for (iter = &(dev)->adj_list.upper, \
diff --git a/net/core/dev.c b/net/core/dev.c
index a4a1fa806c5c..4906b44af850 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7104,6 +7104,7 @@ static bool __netdev_has_upper_dev(struct net_device *dev,
 				   struct net_device *upper_dev)
 {
 	struct netdev_nested_priv priv = {
+		.flags = 0,
 		.data = (void *)upper_dev,
 	};
 
@@ -7385,9 +7386,19 @@ static int __netdev_update_upper_level(struct net_device *dev,
 }
 
 static int __netdev_update_lower_level(struct net_device *dev,
-				       struct netdev_nested_priv *__unused)
+				       struct netdev_nested_priv *priv)
 {
 	dev->lower_level = __netdev_lower_depth(dev) + 1;
+
+#ifdef CONFIG_LOCKDEP
+	if (!priv)
+		return 0;
+
+	if (priv->flags & NESTED_SYNC_IMM)
+		dev->nested_level = dev->lower_level - 1;
+	if (priv->flags & NESTED_SYNC_TODO)
+		net_unlink_todo(dev);
+#endif
 	return 0;
 }
 
@@ -7665,6 +7676,7 @@ static void __netdev_adjacent_dev_unlink_neighbour(struct net_device *dev,
 static int __netdev_upper_dev_link(struct net_device *dev,
 				   struct net_device *upper_dev, bool master,
 				   void *upper_priv, void *upper_info,
+				   struct netdev_nested_priv *priv,
 				   struct netlink_ext_ack *extack)
 {
 	struct netdev_notifier_changeupper_info changeupper_info = {
@@ -7721,9 +7733,9 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	__netdev_update_upper_level(dev, NULL);
 	__netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
 
-	__netdev_update_lower_level(upper_dev, NULL);
+	__netdev_update_lower_level(upper_dev, priv);
 	__netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level,
-				    NULL);
+				    priv);
 
 	return 0;
 
@@ -7748,8 +7760,13 @@ int netdev_upper_dev_link(struct net_device *dev,
 			  struct net_device *upper_dev,
 			  struct netlink_ext_ack *extack)
 {
+	struct netdev_nested_priv priv = {
+		.flags = NESTED_SYNC_IMM | NESTED_SYNC_TODO,
+		.data = NULL,
+	};
+
 	return __netdev_upper_dev_link(dev, upper_dev, false,
-				       NULL, NULL, extack);
+				       NULL, NULL, &priv, extack);
 }
 EXPORT_SYMBOL(netdev_upper_dev_link);
 
@@ -7772,13 +7789,19 @@ int netdev_master_upper_dev_link(struct net_device *dev,
 				 void *upper_priv, void *upper_info,
 				 struct netlink_ext_ack *extack)
 {
+	struct netdev_nested_priv priv = {
+		.flags = NESTED_SYNC_IMM | NESTED_SYNC_TODO,
+		.data = NULL,
+	};
+
 	return __netdev_upper_dev_link(dev, upper_dev, true,
-				       upper_priv, upper_info, extack);
+				       upper_priv, upper_info, &priv, extack);
 }
 EXPORT_SYMBOL(netdev_master_upper_dev_link);
 
 static void __netdev_upper_dev_unlink(struct net_device *dev,
-				      struct net_device *upper_dev)
+				      struct net_device *upper_dev,
+				      struct netdev_nested_priv *priv)
 {
 	struct netdev_notifier_changeupper_info changeupper_info = {
 		.info = {
@@ -7803,9 +7826,9 @@ static void __netdev_upper_dev_unlink(struct net_device *dev,
 	__netdev_update_upper_level(dev, NULL);
 	__netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
 
-	__netdev_update_lower_level(upper_dev, NULL);
+	__netdev_update_lower_level(upper_dev, priv);
 	__netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level,
-				    NULL);
+				    priv);
 }
 
 /**
@@ -7819,7 +7842,12 @@ static void __netdev_upper_dev_unlink(struct net_device *dev,
 void netdev_upper_dev_unlink(struct net_device *dev,
 			     struct net_device *upper_dev)
 {
-	__netdev_upper_dev_unlink(dev, upper_dev);
+	struct netdev_nested_priv priv = {
+		.flags = NESTED_SYNC_TODO,
+		.data = NULL,
+	};
+
+	__netdev_upper_dev_unlink(dev, upper_dev, &priv);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
@@ -7855,6 +7883,10 @@ int netdev_adjacent_change_prepare(struct net_device *old_dev,
 				   struct net_device *dev,
 				   struct netlink_ext_ack *extack)
 {
+	struct netdev_nested_priv priv = {
+		.flags = 0,
+		.data = NULL,
+	};
 	int err;
 
 	if (!new_dev)
@@ -7862,8 +7894,8 @@ int netdev_adjacent_change_prepare(struct net_device *old_dev,
 
 	if (old_dev && new_dev != old_dev)
 		netdev_adjacent_dev_disable(dev, old_dev);
-
-	err = netdev_upper_dev_link(new_dev, dev, extack);
+	err = __netdev_upper_dev_link(new_dev, dev, false, NULL, NULL, &priv,
+				      extack);
 	if (err) {
 		if (old_dev && new_dev != old_dev)
 			netdev_adjacent_dev_enable(dev, old_dev);
@@ -7878,6 +7910,11 @@ void netdev_adjacent_change_commit(struct net_device *old_dev,
 				   struct net_device *new_dev,
 				   struct net_device *dev)
 {
+	struct netdev_nested_priv priv = {
+		.flags = NESTED_SYNC_IMM | NESTED_SYNC_TODO,
+		.data = NULL,
+	};
+
 	if (!new_dev || !old_dev)
 		return;
 
@@ -7885,7 +7922,7 @@ void netdev_adjacent_change_commit(struct net_device *old_dev,
 		return;
 
 	netdev_adjacent_dev_enable(dev, old_dev);
-	netdev_upper_dev_unlink(old_dev, dev);
+	__netdev_upper_dev_unlink(old_dev, dev, &priv);
 }
 EXPORT_SYMBOL(netdev_adjacent_change_commit);
 
@@ -7893,13 +7930,18 @@ void netdev_adjacent_change_abort(struct net_device *old_dev,
 				  struct net_device *new_dev,
 				  struct net_device *dev)
 {
+	struct netdev_nested_priv priv = {
+		.flags = 0,
+		.data = NULL,
+	};
+
 	if (!new_dev)
 		return;
 
 	if (old_dev && new_dev != old_dev)
 		netdev_adjacent_dev_enable(dev, old_dev);
 
-	netdev_upper_dev_unlink(new_dev, dev);
+	__netdev_upper_dev_unlink(new_dev, dev, &priv);
 }
 EXPORT_SYMBOL(netdev_adjacent_change_abort);
 
@@ -10083,6 +10125,19 @@ static void netdev_wait_allrefs(struct net_device *dev)
 void netdev_run_todo(void)
 {
 	struct list_head list;
+#ifdef CONFIG_LOCKDEP
+	struct list_head unlink_list;
+
+	list_replace_init(&net_unlink_list, &unlink_list);
+
+	while (!list_empty(&unlink_list)) {
+		struct net_device *dev = list_first_entry(&unlink_list,
+							  struct net_device,
+							  unlink_list);
+		list_del(&dev->unlink_list);
+		dev->nested_level = dev->lower_level - 1;
+	}
+#endif
 
 	/* Snapshot list, allow later requests */
 	list_replace_init(&net_todo_list, &list);
@@ -10295,6 +10350,10 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
+#ifdef CONFIG_LOCKDEP
+	dev->nested_level = 0;
+	INIT_LIST_HEAD(&dev->unlink_list);
+#endif
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 54cd568e7c2f..fa1c37ec40c9 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -637,7 +637,7 @@ int dev_uc_sync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync(&to->uc, &from->uc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -667,7 +667,7 @@ int dev_uc_sync_multiple(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync_multiple(&to->uc, &from->uc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -700,7 +700,7 @@ void dev_uc_unsync(struct net_device *to, struct net_device *from)
 	 * larger.
 	 */
 	netif_addr_lock_bh(from);
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	__hw_addr_unsync(&to->uc, &from->uc, to->addr_len);
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
@@ -867,7 +867,7 @@ int dev_mc_sync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync(&to->mc, &from->mc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -897,7 +897,7 @@ int dev_mc_sync_multiple(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	err = __hw_addr_sync_multiple(&to->mc, &from->mc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -922,7 +922,7 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 
 	/* See the above comments inside dev_uc_unsync(). */
 	netif_addr_lock_bh(from);
-	netif_addr_lock_nested(to);
+	netif_addr_lock(to);
 	__hw_addr_unsync(&to->mc, &from->mc, to->addr_len);
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
-- 
2.17.1

