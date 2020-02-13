Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A6E15CB13
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 20:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgBMTVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 14:21:39 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40812 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgBMTVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 14:21:39 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so2720275plp.7
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 11:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=42BA2jddtR7Kn6tIL3heMc9Sei3fnfXZYap84gqK/VY=;
        b=TiCr3UhyMrCr8Pm/ummoBM4X5FZec6/nSVQxyGe7hEqKcPm63nqTqIwzt6VKBIE4yA
         vkkHN1HrVhLODyzaFT9LAoHQjO6S8Xlj+QGYsdKvpcafnxIU1WPjv8i+cM/kgBC6m/em
         YLVf21xvbZmyF+PJ/Z7YHnG90U7ImhVZ5ujDEJGAly8KpYhhYlwDlouIcMIm+m51u30f
         ix9VWx4jP/Da7EKaDGwmRg9Taosu1RIi8+BHUIZ/tm4e0JjSM+7miQSBFOumY6XVbU67
         udSJ6U2B/XxFkwfXv4DAyC9g95jDA0jjj+UkkmUusNFD+PO5DzL89jQ1Pxc5uvWNuzjh
         Y9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=42BA2jddtR7Kn6tIL3heMc9Sei3fnfXZYap84gqK/VY=;
        b=dGcfTss5JgPZPDJ/fYs6xgU1Qca3CidN6GrjNfu7xk9UYBPYfCe3l36U3CyZffb2ox
         NEfL3aBpQTqWa/4W23gYm0l5bAqDANIAKBmuVDpwhaeqj5zw0Y7qXQwAHhzBZ9SJRbam
         TijaR44XFE4AEfeYqw7H77gzAIjg55kdhjX/JNRkVoPKrVn1Yanalyn/+jVK8gbVv+g5
         JPzRB0kMIwJa7CSglxi4ZEm36eBtNpdL/GwnPNugRqi9CDZ2qHTk4/YfSXkAmMwYJnhy
         HEKSTHUDSNc8vEb4QuCBetfq09cnjZJs/AMnM8Sm6U0sarraSy+bVMQLraWYJJUAHArj
         HLTA==
X-Gm-Message-State: APjAAAWYenrY/pkLbkU+s1dj0Cjt4rjdaiJRsbZ+ynUI608LRPCmwtRE
        qID+g739yLFASk8zUpi9GCY=
X-Google-Smtp-Source: APXvYqzkuPEZaQtzGmXo+xFibncUFk43RUiMsfhuKL/50ItgrjLX1jBaUhccT07dMOQLJqMjVD8jmw==
X-Received: by 2002:a17:90a:c385:: with SMTP id h5mr6802738pjt.122.1581621697384;
        Thu, 13 Feb 2020 11:21:37 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f9sm4012193pfd.141.2020.02.13.11.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:21:36 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/2] bonding: do not collect slave's stats
Date:   Thu, 13 Feb 2020 19:21:29 +0000
Message-Id: <20200213192129.16104-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When stat query is requested(dev_get_stats()), bonding interfaces
collect stats of slave interfaces.
Then, it prints delta value, which is "new_stats - old_stats" and
updates bond->bond_stats.
But, this mechanism has some problems.

1. It needs a lock for protecting "bond->bond_stats".
Bonding interfaces would be nested. So this lock would also be nested.
So, spin_lock_nested() or dynamic lockdep class key was used.
In the case of spin_lock_nested(), it needs correct nested level value
and this value will be changed when master/nomaster operations
(ip link set bond0 master bond1) are being executed.
This value is protected by RTNL mutex lock, but "dev_get_stats()" would
be called outside of RTNL mutex.
So, imbalance lock/unlock would be happened.
Another case, which is to use dynamic lockdep class key has same problem.
dynamic lockdep class key is protected by RTNL mutex lock
and if master/nomaster operations are executed, updating lockdep class
key is needed.
But, dev_get_stats() would be called outside of RTNL mutex, so imbalance
lock/unlock would be happened too.

2. Couldn't show correct stats value when slave interfaces are used
directly.

Test commands:
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link set veth1 netns nst
    ip link add bond0 type bond
    ip link set veth0 master bond0
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip a a 192.168.100.2/24 dev veth1
    ip a a 192.168.100.1/24 dev bond0
    ip link set veth0 up
    ip link set bond0 up
    ping 192.168.100.2 -I veth0 -c 10
    ip -s link show bond0
    ip -s link show veth0

Before:
26: bond0:
RX: bytes  packets  errors  dropped overrun mcast
656        8        0       0       0       0
TX: bytes  packets  errors  dropped carrier collsns
1340       22       0       0       0       0
~~~~~~~~~~~~

25: veth0@if24:
RX: bytes  packets  errors  dropped overrun mcast
656        8        0       0       0       0
TX: bytes  packets  errors  dropped carrier collsns
1340       22       0       0       0       0
~~~~~~~~~~~~

After:
19: bond0:
RX: bytes  packets  errors  dropped overrun mcast
544        8        0       0       0       8
TX: bytes  packets  errors  dropped carrier collsns
746        9        0       0       0       0
~~~~~~~~~~~

18: veth0@if17:
link/ether 76:14:ee:f1:7d:8e brd ff:ff:ff:ff:ff:ff link-netns nst
RX: bytes  packets  errors  dropped overrun mcast
656        8        0       0       0       0
TX: bytes  packets  errors  dropped carrier collsns
1250       21       0       0       0       0
~~~~~~~~~~~~

Only veth0 interface is used by ping process directly. bond0 interface
isn't used. So, bond0 stats should not be increased.
But, bond0 collects stats value of slave interface.
So bond0 stats will be increased.

In order to fix the above problems, this patch makes bonding interfaces
record own stats data like other interfaces.
This patch is made based on team interface stats logic.

There is another problem.
When master/nomaster operations are being executed, updating a dynamic
lockdep class key is needed.
But, bonding doesn't update dynamic lockdep key.
So, lockdep warning message occurs.
But, this problem will be disappeared by this patch.
Because this patch removes stats_lock and a dynamic lockdep class key
for stats_lock, which is stats_lock_key.

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond0 master bond1
    ip link set bond0 nomaster
    ip link set bond1 master bond0

Splat looks like:
[  316.354460][ T1170] WARNING: possible circular locking dependency detected
[  316.355240][ T1170] 5.5.0+ #366 Not tainted
[  316.355720][ T1170] ------------------------------------------------------
[  316.357345][ T1170] ip/1170 is trying to acquire lock:
[  316.358007][ T1170] ffff8880ca79acd8 (&bond->stats_lock_key#2){+.+.}, at: bond_get_stats+0x90/0x4d0 [bonding]
[  316.359544][ T1170]
[  316.359544][ T1170] but task is already holding lock:
[  316.360578][ T1170] ffff8880b12f2cd8 (&bond->stats_lock_key){+.+.}, at: bond_get_stats+0x90/0x4d0 [bonding]
[  316.361992][ T1170]
[  316.361992][ T1170] which lock already depends on the new lock.
[  316.361992][ T1170]
[  316.363446][ T1170]
[  316.363446][ T1170] the existing dependency chain (in reverse order) is:
[  316.364739][ T1170]
[  316.364739][ T1170] -> #1 (&bond->stats_lock_key){+.+.}:
[  316.366686][ T1170]        _raw_spin_lock+0x30/0x70
[  316.367394][ T1170]        bond_get_stats+0x90/0x4d0 [bonding]
[  316.368202][ T1170]        dev_get_stats+0x1ec/0x270
[  316.368890][ T1170]        bond_get_stats+0x1a5/0x4d0 [bonding]
[  316.370573][ T1170]        dev_get_stats+0x1ec/0x270
[  316.371227][ T1170]        rtnl_fill_stats+0x44/0xbe0
[  316.371891][ T1170]        rtnl_fill_ifinfo+0xeb2/0x3720
[  316.372619][ T1170]        rtmsg_ifinfo_build_skb+0xca/0x170
[  316.373371][ T1170]        rtmsg_ifinfo_event.part.33+0x1b/0xb0
[  316.374161][ T1170]        rtnetlink_event+0xcd/0x120
[  316.375112][ T1170]        notifier_call_chain+0x90/0x160
[  316.375680][ T1170]        netdev_change_features+0x74/0xa0
[  316.376417][ T1170]        bond_compute_features.isra.45+0x4e6/0x6f0 [bonding]
[  316.378357][ T1170]        bond_enslave+0x3639/0x47b0 [bonding]
[  316.379138][ T1170]        do_setlink+0xaab/0x2ef0
[  316.379757][ T1170]        __rtnl_newlink+0x9c5/0x1270
[  316.380486][ T1170]        rtnl_newlink+0x65/0x90
[  316.381271][ T1170]        rtnetlink_rcv_msg+0x4a8/0x890
[  316.382138][ T1170]        netlink_rcv_skb+0x121/0x350
[  316.382793][ T1170]        netlink_unicast+0x42e/0x610
[  316.383507][ T1170]        netlink_sendmsg+0x65a/0xb90
[  316.384398][ T1170]        ____sys_sendmsg+0x5ce/0x7a0
[  316.385084][ T1170]        ___sys_sendmsg+0x10f/0x1b0
[  316.385778][ T1170]        __sys_sendmsg+0xc6/0x150
[  316.386469][ T1170]        do_syscall_64+0x99/0x4f0
[  316.387185][ T1170]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  316.388000][ T1170]
[  316.388000][ T1170] -> #0 (&bond->stats_lock_key#2){+.+.}:
[  316.389019][ T1170]        __lock_acquire+0x2d8d/0x3de0
[  316.392598][ T1170]        lock_acquire+0x164/0x3b0
[  316.393309][ T1170]        _raw_spin_lock+0x30/0x70
[  316.393962][ T1170]        bond_get_stats+0x90/0x4d0 [bonding]
[  316.394787][ T1170]        dev_get_stats+0x1ec/0x270
[  316.395496][ T1170]        bond_get_stats+0x1a5/0x4d0 [bonding]
[  316.396285][ T1170]        dev_get_stats+0x1ec/0x270
[  316.396949][ T1170]        rtnl_fill_stats+0x44/0xbe0
[  316.400420][ T1170]        rtnl_fill_ifinfo+0xeb2/0x3720
[  316.401122][ T1170]        rtmsg_ifinfo_build_skb+0xca/0x170
[  316.401933][ T1170]        rtmsg_ifinfo_event.part.33+0x1b/0xb0
[  316.402739][ T1170]        rtnetlink_event+0xcd/0x120
[  316.403477][ T1170]        notifier_call_chain+0x90/0x160
[  316.404187][ T1170]        netdev_change_features+0x74/0xa0
[  316.404957][ T1170]        bond_compute_features.isra.45+0x4e6/0x6f0 [bonding]
[  316.405978][ T1170]        bond_enslave+0x3639/0x47b0 [bonding]
[  316.406780][ T1170]        do_setlink+0xaab/0x2ef0
[  316.407441][ T1170]        __rtnl_newlink+0x9c5/0x1270
[  316.408152][ T1170]        rtnl_newlink+0x65/0x90
[  316.408788][ T1170]        rtnetlink_rcv_msg+0x4a8/0x890
[  316.411550][ T1170]        netlink_rcv_skb+0x121/0x350
[  316.412230][ T1170]        netlink_unicast+0x42e/0x610
[  316.412897][ T1170]        netlink_sendmsg+0x65a/0xb90
[  316.413703][ T1170]        ____sys_sendmsg+0x5ce/0x7a0
[  316.414448][ T1170]        ___sys_sendmsg+0x10f/0x1b0
[  316.415129][ T1170]        __sys_sendmsg+0xc6/0x150
[  316.415801][ T1170]        do_syscall_64+0x99/0x4f0
[  316.416491][ T1170]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  316.417407][ T1170]
[  316.417407][ T1170] other info that might help us debug this:
[  316.417407][ T1170]
[  316.418728][ T1170]  Possible unsafe locking scenario:
[  316.418728][ T1170]
[  316.419693][ T1170]        CPU0                    CPU1
[  316.420400][ T1170]        ----                    ----
[  316.421096][ T1170]   lock(&bond->stats_lock_key);
[  316.421821][ T1170]                                lock(&bond->stats_lock_key#2);
[  316.422819][ T1170]                                lock(&bond->stats_lock_key);
[  316.424906][ T1170]   lock(&bond->stats_lock_key#2);
[  316.425596][ T1170]
[  316.425596][ T1170]  *** DEADLOCK ***
[  316.425596][ T1170]
[  316.426726][ T1170] 3 locks held by ip/1170:
[  316.427351][ T1170]  #0: ffffffffa2cf60f0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x457/0x890
[  316.428556][ T1170]  #1: ffff8880b12f2cd8 (&bond->stats_lock_key){+.+.}, at: bond_get_stats+0x90/0x4d0 [bondin]
[  316.431170][ T1170]  #2: ffffffffa29254c0 (rcu_read_lock){....}, at: bond_get_stats+0x5/0x4d0 [bonding]
[  316.432411][ T1170]
[  316.432411][ T1170] stack backtrace:
[  316.433341][ T1170] CPU: 3 PID: 1170 Comm: ip Not tainted 5.5.0+ #366
[  316.434208][ T1170] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  316.435367][ T1170] Call Trace:
[  316.435846][ T1170]  dump_stack+0x96/0xdb
[  316.436449][ T1170]  check_noncircular+0x371/0x450
[  316.437101][ T1170]  ? print_circular_bug.isra.35+0x310/0x310
[  316.437895][ T1170]  ? hlock_class+0x130/0x130
[  316.438531][ T1170]  ? __lock_acquire+0x2d8d/0x3de0
[  316.439241][ T1170]  __lock_acquire+0x2d8d/0x3de0
[  316.439889][ T1170]  ? register_lock_class+0x14d0/0x14d0
[  316.440602][ T1170]  ? check_chain_key+0x236/0x5d0
[  316.442135][ T1170]  lock_acquire+0x164/0x3b0
[  316.442789][ T1170]  ? bond_get_stats+0x90/0x4d0 [bonding]
[  316.443524][ T1170]  _raw_spin_lock+0x30/0x70
[  316.444112][ T1170]  ? bond_get_stats+0x90/0x4d0 [bonding]
[  316.445571][ T1170]  bond_get_stats+0x90/0x4d0 [bonding]
[  316.446320][ T1170]  ? bond_neigh_init+0x2d0/0x2d0 [bonding]
[  316.447330][ T1170]  ? rcu_read_lock_held+0x90/0xa0
[  316.448003][ T1170]  ? rcu_read_lock_sched_held+0xc0/0xc0
[  316.450802][ T1170]  ? bond_get_stats+0x5/0x4d0 [bonding]
[  316.451569][ T1170]  dev_get_stats+0x1ec/0x270
[  316.452206][ T1170]  bond_get_stats+0x1a5/0x4d0 [bonding]
[ ... ]

Fixes: 089bca2caed0 ("bonding: use dynamic lockdep key instead of subclass")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bonding/bond_alb.c  |  14 +-
 drivers/net/bonding/bond_main.c | 220 +++++++++++++++++---------------
 include/net/bond_alb.h          |   4 +-
 include/net/bonding.h           |  17 ++-
 4 files changed, 138 insertions(+), 117 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 1cc2cd894f87..28dc04c848ce 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1299,8 +1299,8 @@ void bond_alb_deinitialize(struct bonding *bond)
 		rlb_deinitialize(bond);
 }
 
-static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
-				    struct slave *tx_slave)
+static bool bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
+			     struct slave *tx_slave)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct ethhdr *eth_data = eth_hdr(skb);
@@ -1319,7 +1319,7 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 		}
 
 		bond_dev_queue_xmit(bond, skb, tx_slave->dev);
-		goto out;
+		return true;
 	}
 
 	if (tx_slave && bond->params.tlb_dynamic_lb) {
@@ -1330,11 +1330,11 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 
 	/* no suitable interface, frame not sent */
 	bond_tx_drop(bond->dev, skb);
-out:
-	return NETDEV_TX_OK;
+
+	return false;
 }
 
-netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
+bool bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct ethhdr *eth_data;
@@ -1372,7 +1372,7 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 	return bond_do_alb_xmit(skb, bond, tx_slave);
 }
 
-netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
+bool bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct ethhdr *eth_data;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1e9d5d35fc78..3e52fd25f783 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -251,8 +251,6 @@ static struct flow_dissector flow_keys_bonding __read_mostly;
 
 static int bond_init(struct net_device *bond_dev);
 static void bond_uninit(struct net_device *bond_dev);
-static void bond_get_stats(struct net_device *bond_dev,
-			   struct rtnl_link_stats64 *stats);
 static void bond_slave_arr_handler(struct work_struct *work);
 static bool bond_time_in_interval(struct bonding *bond, unsigned long last_act,
 				  int mod);
@@ -1258,8 +1256,10 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	 */
 	if (bond_should_deliver_exact_match(skb, slave, bond)) {
 		if (is_link_local_ether_addr(eth_hdr(skb)->h_dest))
-			return RX_HANDLER_PASS;
-		return RX_HANDLER_EXACT;
+			ret = RX_HANDLER_PASS;
+		else
+			ret = RX_HANDLER_EXACT;
+		goto out;
 	}
 
 	skb->dev = bond->dev;
@@ -1277,6 +1277,23 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 				  bond->dev->addr_len);
 	}
 
+out:
+	if (ret == RX_HANDLER_ANOTHER) {
+		struct bond_pcpu_stats *pcpu_stats;
+
+		pcpu_stats = this_cpu_ptr(bond->pcpu_stats);
+		u64_stats_update_begin(&pcpu_stats->syncp);
+		pcpu_stats->rx_packets++;
+		pcpu_stats->rx_bytes += skb->len;
+		if (skb->pkt_type == PACKET_MULTICAST)
+			pcpu_stats->rx_multicast++;
+		u64_stats_update_end(&pcpu_stats->syncp);
+	} else if (ret == RX_HANDLER_EXACT) {
+		this_cpu_inc(bond->pcpu_stats->rx_nohandler);
+	} else if (ret == RX_HANDLER_PASS) {
+		this_cpu_inc(bond->pcpu_stats->rx_dropped);
+	}
+
 	return ret;
 }
 
@@ -1608,8 +1625,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	}
 
 	slave_dev->priv_flags |= IFF_BONDING;
-	/* initialize slave stats */
-	dev_get_stats(new_slave->dev, &new_slave->slave_stats);
 
 	if (bond_is_lb(bond)) {
 		/* bond_alb_init_slave() must be called before all other stages since
@@ -1944,9 +1959,6 @@ static int __bond_release_one(struct net_device *bond_dev,
 
 	bond_sysfs_slave_del(slave);
 
-	/* recompute stats just before removing the slave */
-	bond_get_stats(bond->dev, &bond->bond_stats);
-
 	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
@@ -3497,60 +3509,39 @@ static int bond_close(struct net_device *bond_dev)
 	return 0;
 }
 
-/* fold stats, assuming all rtnl_link_stats64 fields are u64, but
- * that some drivers can provide 32bit values only.
- */
-static void bond_fold_stats(struct rtnl_link_stats64 *_res,
-			    const struct rtnl_link_stats64 *_new,
-			    const struct rtnl_link_stats64 *_old)
-{
-	const u64 *new = (const u64 *)_new;
-	const u64 *old = (const u64 *)_old;
-	u64 *res = (u64 *)_res;
-	int i;
-
-	for (i = 0; i < sizeof(*_res) / sizeof(u64); i++) {
-		u64 nv = new[i];
-		u64 ov = old[i];
-		s64 delta = nv - ov;
-
-		/* detects if this particular field is 32bit only */
-		if (((nv | ov) >> 32) == 0)
-			delta = (s64)(s32)((u32)nv - (u32)ov);
-
-		/* filter anomalies, some drivers reset their stats
-		 * at down/up events.
-		 */
-		if (delta > 0)
-			res[i] += delta;
-	}
-}
-
 static void bond_get_stats(struct net_device *bond_dev,
 			   struct rtnl_link_stats64 *stats)
 {
+	u64 rx_packets, rx_bytes, rx_multicast, tx_packets, tx_bytes;
+	u32 rx_dropped = 0, tx_dropped = 0, rx_nohandler = 0;
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct rtnl_link_stats64 temp;
-	struct list_head *iter;
-	struct slave *slave;
-
-	spin_lock(&bond->stats_lock);
-	memcpy(stats, &bond->bond_stats, sizeof(*stats));
-
-	rcu_read_lock();
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		const struct rtnl_link_stats64 *new =
-			dev_get_stats(slave->dev, &temp);
-
-		bond_fold_stats(stats, new, &slave->slave_stats);
-
-		/* save off the slave stats for the next run */
-		memcpy(&slave->slave_stats, new, sizeof(*new));
-	}
-	rcu_read_unlock();
+	struct bond_pcpu_stats *p;
+	unsigned int start;
+	int i;
 
-	memcpy(&bond->bond_stats, stats, sizeof(*stats));
-	spin_unlock(&bond->stats_lock);
+	for_each_possible_cpu(i) {
+		p = per_cpu_ptr(bond->pcpu_stats, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&p->syncp);
+			rx_packets      = p->rx_packets;
+			rx_bytes        = p->rx_bytes;
+			rx_multicast    = p->rx_multicast;
+			tx_packets      = p->tx_packets;
+			tx_bytes        = p->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+
+		stats->rx_packets       += rx_packets;
+		stats->rx_bytes         += rx_bytes;
+		stats->multicast        += rx_multicast;
+		stats->tx_packets       += tx_packets;
+		stats->tx_bytes         += tx_bytes;
+		rx_dropped		+= p->rx_dropped;
+		tx_dropped		+= p->tx_dropped;
+		rx_nohandler		+= p->rx_nohandler;
+	}
+	stats->rx_dropped       = rx_dropped;
+	stats->tx_dropped       = tx_dropped;
+	stats->rx_nohandler     = rx_nohandler;
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
@@ -3885,7 +3876,8 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
  * it fails, it tries to find the first available slave for transmission.
  * The skb is consumed in all cases, thus the function is void.
  */
-static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int slave_id)
+static bool bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb,
+			       int slave_id)
 {
 	struct list_head *iter;
 	struct slave *slave;
@@ -3896,7 +3888,7 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
 		if (--i < 0) {
 			if (bond_slave_can_tx(slave)) {
 				bond_dev_queue_xmit(bond, skb, slave->dev);
-				return;
+				return true;
 			}
 		}
 	}
@@ -3908,11 +3900,12 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
 			break;
 		if (bond_slave_can_tx(slave)) {
 			bond_dev_queue_xmit(bond, skb, slave->dev);
-			return;
+			return true;
 		}
 	}
 	/* no slave that can tx has been found */
 	bond_tx_drop(bond->dev, skb);
+	return false;
 }
 
 /**
@@ -3948,8 +3941,8 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
 	return slave_id;
 }
 
-static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
-					struct net_device *bond_dev)
+static bool bond_xmit_roundrobin(struct sk_buff *skb,
+				 struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
@@ -3972,11 +3965,12 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 		iph = ip_hdr(skb);
 		if (iph->protocol == IPPROTO_IGMP) {
 			slave = rcu_dereference(bond->curr_active_slave);
-			if (slave)
+			if (slave) {
 				bond_dev_queue_xmit(bond, skb, slave->dev);
-			else
-				bond_xmit_slave_id(bond, skb, 0);
-			return NETDEV_TX_OK;
+				return true;
+			} else {
+				return bond_xmit_slave_id(bond, skb, 0);
+			}
 		}
 	}
 
@@ -3984,29 +3978,28 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 	slave_cnt = READ_ONCE(bond->slave_cnt);
 	if (likely(slave_cnt)) {
 		slave_id = bond_rr_gen_slave_id(bond);
-		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-	} else {
-		bond_tx_drop(bond_dev, skb);
+		return bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
 	}
-	return NETDEV_TX_OK;
+	bond_tx_drop(bond_dev, skb);
+	return false;
 }
 
 /* In active-backup mode, we know that bond->curr_active_slave is always valid if
  * the bond has a usable interface.
  */
-static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
-					  struct net_device *bond_dev)
+static bool bond_xmit_activebackup(struct sk_buff *skb,
+				   struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 
 	slave = rcu_dereference(bond->curr_active_slave);
-	if (slave)
+	if (slave) {
 		bond_dev_queue_xmit(bond, skb, slave->dev);
-	else
-		bond_tx_drop(bond_dev, skb);
-
-	return NETDEV_TX_OK;
+		return true;
+	}
+	bond_tx_drop(bond_dev, skb);
+	return false;
 }
 
 /* Use this to update slave_array when (a) it's not appropriate to update
@@ -4137,8 +4130,8 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
  * usable slave array is formed in the control path. The xmit function
  * just calculates hash and sends the packet out.
  */
-static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
-				     struct net_device *dev)
+static bool bond_3ad_xor_xmit(struct sk_buff *skb,
+			      struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
 	struct slave *slave;
@@ -4150,20 +4143,20 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 	if (likely(count)) {
 		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
 		bond_dev_queue_xmit(bond, skb, slave->dev);
-	} else {
-		bond_tx_drop(dev, skb);
+		return true;
 	}
-
-	return NETDEV_TX_OK;
+	bond_tx_drop(dev, skb);
+	return false;
 }
 
 /* in broadcast mode, we send everything to all usable interfaces. */
-static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
-				       struct net_device *bond_dev)
+static bool bond_xmit_broadcast(struct sk_buff *skb,
+				struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave = NULL;
 	struct list_head *iter;
+	int ret = 0;
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (bond_is_last_slave(bond, slave))
@@ -4177,14 +4170,18 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 				continue;
 			}
 			bond_dev_queue_xmit(bond, skb2, slave->dev);
+			ret++;
 		}
 	}
-	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP)
+
+	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
 		bond_dev_queue_xmit(bond, skb, slave->dev);
-	else
-		bond_tx_drop(bond_dev, skb);
+		ret++;
+	}
 
-	return NETDEV_TX_OK;
+	if (!ret)
+		bond_tx_drop(bond_dev, skb);
+	return !!ret;
 }
 
 /*------------------------- Device initialization ---------------------------*/
@@ -4237,13 +4234,13 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return txq;
 }
 
-static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static bool __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
 
 	if (bond_should_override_tx_queue(bond) &&
 	    !bond_slave_override(bond, skb))
-		return NETDEV_TX_OK;
+		return true;
 
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_ROUNDROBIN:
@@ -4264,14 +4261,14 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
 		netdev_err(dev, "Unknown bonding mode %d\n", BOND_MODE(bond));
 		WARN_ON_ONCE(1);
 		bond_tx_drop(dev, skb);
-		return NETDEV_TX_OK;
+		return false;
 	}
 }
 
 static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
-	netdev_tx_t ret = NETDEV_TX_OK;
+	int len = skb->len;
 
 	/* If we risk deadlock from transmitting this in the
 	 * netpoll path, tell netpoll to queue the frame for later tx
@@ -4280,13 +4277,24 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 
 	rcu_read_lock();
-	if (bond_has_slaves(bond))
-		ret = __bond_start_xmit(skb, dev);
-	else
+	if (bond_has_slaves(bond)) {
+		if (__bond_start_xmit(skb, dev)) {
+			struct bond_pcpu_stats *pcpu_stats;
+
+			pcpu_stats = this_cpu_ptr(bond->pcpu_stats);
+			u64_stats_update_begin(&pcpu_stats->syncp);
+			pcpu_stats->tx_packets++;
+			pcpu_stats->tx_bytes += len;
+			u64_stats_update_end(&pcpu_stats->syncp);
+		} else {
+			this_cpu_inc(bond->pcpu_stats->tx_dropped);
+		}
+	} else {
 		bond_tx_drop(dev, skb);
+	}
 	rcu_read_unlock();
 
-	return ret;
+	return NETDEV_TX_OK;
 }
 
 static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
@@ -4368,8 +4376,10 @@ static const struct device_type bond_type = {
 static void bond_destructor(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+
 	if (bond->wq)
 		destroy_workqueue(bond->wq);
+	free_percpu(bond->pcpu_stats);
 }
 
 void bond_setup(struct net_device *bond_dev)
@@ -4445,7 +4455,6 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	list_del(&bond->bond_list);
 
-	lockdep_unregister_key(&bond->stats_lock_key);
 	bond_debug_unregister(bond);
 }
 
@@ -4845,13 +4854,13 @@ static int bond_init(struct net_device *bond_dev)
 
 	netdev_dbg(bond_dev, "Begin bond_init\n");
 
-	bond->wq = alloc_ordered_workqueue(bond_dev->name, WQ_MEM_RECLAIM);
-	if (!bond->wq)
+	bond->pcpu_stats = netdev_alloc_pcpu_stats(struct bond_pcpu_stats);
+	if (!bond->pcpu_stats)
 		return -ENOMEM;
 
-	spin_lock_init(&bond->stats_lock);
-	lockdep_register_key(&bond->stats_lock_key);
-	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
+	bond->wq = alloc_ordered_workqueue(bond_dev->name, WQ_MEM_RECLAIM);
+	if (!bond->wq)
+		goto err_alloc_workqueue;
 
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
@@ -4865,6 +4874,9 @@ static int bond_init(struct net_device *bond_dev)
 		eth_hw_addr_random(bond_dev);
 
 	return 0;
+err_alloc_workqueue:
+	free_percpu(bond->pcpu_stats);
+	return -ENOMEM;
 }
 
 unsigned int bond_get_num_tx_queues(void)
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index b3504fcd773d..89c0545458cd 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -156,8 +156,8 @@ int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link);
 void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
-int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
-int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+bool bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+bool bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 void bond_alb_monitor(struct work_struct *);
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
 void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 3d56b026bb9e..53106e59ff9c 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -111,6 +111,18 @@ static inline int is_netpoll_tx_blocked(struct net_device *dev)
 #define is_netpoll_tx_blocked(dev) (0)
 #endif
 
+struct bond_pcpu_stats {
+	u64                     rx_packets;
+	u64                     rx_bytes;
+	u64                     rx_multicast;
+	u64                     tx_packets;
+	u64                     tx_bytes;
+	struct u64_stats_sync   syncp;
+	u32                     rx_dropped;
+	u32                     tx_dropped;
+	u32                     rx_nohandler;
+};
+
 struct bond_params {
 	int mode;
 	int xmit_policy;
@@ -177,7 +189,6 @@ struct slave {
 #endif
 	struct delayed_work notify_work;
 	struct kobject kobj;
-	struct rtnl_link_stats64 slave_stats;
 };
 
 struct bond_up_slave {
@@ -213,7 +224,6 @@ struct bonding {
 	 * ALB mode (6) - to sync the use and modifications of its hash table
 	 */
 	spinlock_t mode_lock;
-	spinlock_t stats_lock;
 	u8	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
@@ -236,8 +246,7 @@ struct bonding {
 	/* debugging support via debugfs */
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
-	struct rtnl_link_stats64 bond_stats;
-	struct lock_class_key stats_lock_key;
+	struct   bond_pcpu_stats __percpu *pcpu_stats;
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.17.1

