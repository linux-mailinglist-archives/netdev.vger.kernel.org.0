Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FCCAC6D1
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394647AbfIGNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:47:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45080 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733278AbfIGNrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:47:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id 4so5118035pgm.12
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B7E9bBHZyVVv5TtX3JVfbSqlSS3ZRozPxNl9tmfA3/U=;
        b=LDS5+OMrJ4D5zDWS8wmzPM7QM0Y7amqoaQxygQem2UhcICqLPwxeR4oKUfRbMGpAnn
         pbtgW9xOOGQXrSjK9rrYopqJ65mwuDcalT04LZMmkJXoborJ9mKAI7OcJCnPGQGLxmNE
         XZqUszdlGKOaOYBZZ8ZP8rOXpovNFnpqzD9B1NrUr97EhQWzaVHoWLYlWyzbycCfolZg
         TnI+yE+xx0+/+UEBYBSyTgTLkoUsyEoJT9nQPlGG3X9d6h6503hxFQ2WANAtkogBAuIw
         wz0gepjAV7FEbjY+y5VE5Zl6FImO8hcGuy6Pka0jnlFanXE1HlQjLH5YHlw5FkrL4D3R
         Uj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B7E9bBHZyVVv5TtX3JVfbSqlSS3ZRozPxNl9tmfA3/U=;
        b=FoPvGsQm3hH7zbySxjAFlK7eSZFjNjhpfi/1GDVwnRmU3eTconYDSkOGjMOUh9gABO
         htERW3uCHd4Q/xzP1OuxI1uKGZ5YvUf5LHuaidXlUUfIGKAeR7B1ujDXrFGVMi7TcTld
         sKrn+im+iJTAApjrwcnHDm18dfAFZE47gGMICfkVIszYiQF/vFshNdeIehNXEbpXQU4T
         dGF/LsiH71C8i5sfmfQ97b0s9+Fzj/tRVEKNijUn0t2pUkpnW2ZGHOv7GztRGr/attpu
         ZV4Tir2SboiW2UP8kR0g/ELXgi/INLhQJek8nE4QnsUQN3vxFILyicWUJbpyCwDtE0HB
         FXVQ==
X-Gm-Message-State: APjAAAWMjHyZ3sf2xMdJpHMU78CVIAFS3uNaNRg3vTv7balbse3/Gwp4
        PuhyFDxveDO4ixfoGf9bBoE=
X-Google-Smtp-Source: APXvYqzqVSRIzmW/Pk15fq1CIGHJ3th4kP+pXzwNa4k45PVEHURt9PcwvWlQDpozpPHOCnNIngqaPw==
X-Received: by 2002:a62:87c8:: with SMTP id i191mr16929000pfe.133.1567864027573;
        Sat, 07 Sep 2019 06:47:07 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id s97sm5025446pjc.4.2019.09.07.06.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:47:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 07/11] macvlan: use dynamic lockdep key instead of subclass
Date:   Sat,  7 Sep 2019 22:46:55 +0900
Message-Id: <20190907134655.32639-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All macvlan device has same lockdep key and subclass is initialized with
nest_level.
But actual nest_level value can be changed when a lower device is attached.
And at this moment, the subclass should be updated but it seems to be
unsafe.
So this patch makes macvlan use dynamic lockdep key instead of the
subclass.

Test commands:
    ip link add bond0 type bond
    ip link add dummy0 type dummy
    ip link add macvlan0 link bond0 type macvlan mode bridge
    ip link add macvlan1 link dummy0 type macvlan mode bridge
    ip link set bond0 mtu 1000
    ip link set macvlan1 master bond0

    ip link set bond0 up
    ip link set macvlan0 up
    ip link set dummy0 up
    ip link set macvlan1 up

Splat looks like:
[  165.677603] ============================================
[  165.679642] WARNING: possible recursive locking detected
[  165.679642] 5.3.0-rc7+ #322 Not tainted
[  165.679642] --------------------------------------------
[  165.679642] ip/1812 is trying to acquire lock:
[  165.679642] 00000000ae6a8a03 (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[  165.679642]
[  165.679642] but task is already holding lock:
[  165.679642] 00000000cec5da0b (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[  165.679642]
[  165.679642] other info that might help us debug this:
[  165.679642]  Possible unsafe locking scenario:
[  165.679642]
[  165.679642]        CPU0
[  165.679642]        ----
[  165.679642]   lock(&macvlan_netdev_addr_lock_key/1);
[  165.679642]   lock(&macvlan_netdev_addr_lock_key/1);
[  165.679642]
[  165.679642]  *** DEADLOCK ***
[  165.679642]
[  165.679642]  May be due to missing lock nesting notation
[  165.679642]
[  165.679642] 4 locks held by ip/1812:
[  165.679642]  #0: 0000000088d10bd8 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  165.679642]  #1: 00000000cec5da0b (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[  165.679642]  #2: 000000000ca6fdb5 (&dev_addr_list_lock_key/3){+...}, at: dev_uc_sync+0xfa/0x1a0
[  165.679642]  #3: 00000000dc1495a2 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[  165.679642]
[  165.679642] stack backtrace:
[  165.679642] CPU: 1 PID: 1812 Comm: ip Not tainted 5.3.0-rc7+ #322
[  165.679642] Call Trace:
[  165.679642]  dump_stack+0x7c/0xbb
[  165.679642]  __lock_acquire+0x26a9/0x3de0
[  165.679642]  ? register_lock_class+0x14d0/0x14d0
[  165.679642]  ? mark_held_locks+0xa5/0xe0
[  165.679642]  ? trace_hardirqs_on_thunk+0x1a/0x20
[  165.679642]  ? register_lock_class+0x14d0/0x14d0
[  165.679642]  lock_acquire+0x164/0x3b0
[  165.679642]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  165.679642]  _raw_spin_lock_nested+0x2e/0x60
[  165.679642]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  165.679642]  dev_uc_sync_multiple+0xfa/0x1a0
[  165.679642]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[  165.679642]  ? bond_init+0x6f0/0x6f0 [bonding]
[  165.679642]  dev_uc_sync+0x15a/0x1a0
[  165.679642]  macvlan_set_mac_lists+0x55/0x110 [macvlan]
[  165.679642]  dev_set_rx_mode+0x21/0x30
[  165.679642]  __dev_open+0x202/0x310
[  165.679642]  ? dev_set_rx_mode+0x30/0x30
[  165.679642]  ? mark_held_locks+0xa5/0xe0
[  165.679642]  ? __local_bh_enable_ip+0xe9/0x1b0
[  165.679642]  __dev_change_flags+0x3c3/0x500
[  165.679642]  ? dev_set_allmulti+0x10/0x10
[  165.679642]  dev_change_flags+0x7a/0x160
[  ...]

Fixes: c674ac30c549 ("macvlan: Fix lockdep warnings with stacked macvlan devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

 drivers/net/macvlan.c      | 35 +++++++++++++++++++++++++++--------
 include/linux/if_macvlan.h |  2 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 940192c057b6..dae368a2e8d1 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -852,8 +852,6 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
  * "super class" of normal network devices; split their locks off into a
  * separate class since they always nest.
  */
-static struct lock_class_key macvlan_netdev_addr_lock_key;
-
 #define ALWAYS_ON_OFFLOADS \
 	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE | \
 	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL)
@@ -874,12 +872,30 @@ static int macvlan_get_nest_level(struct net_device *dev)
 	return ((struct macvlan_dev *)netdev_priv(dev))->nest_level;
 }
 
-static void macvlan_set_lockdep_class(struct net_device *dev)
+static void macvlan_dev_set_lockdep_one(struct net_device *dev,
+					struct netdev_queue *txq,
+					void *_unused)
+{
+	struct macvlan_dev *macvlan = netdev_priv(dev);
+
+	lockdep_set_class(&txq->_xmit_lock, &macvlan->xmit_lock_key);
+}
+
+static struct lock_class_key qdisc_tx_busylock_key;
+static struct lock_class_key qdisc_running_key;
+
+static void macvlan_dev_set_lockdep_class(struct net_device *dev)
 {
-	netdev_lockdep_set_classes(dev);
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &macvlan_netdev_addr_lock_key,
-				       macvlan_get_nest_level(dev));
+	struct macvlan_dev *macvlan = netdev_priv(dev);
+
+	dev->qdisc_tx_busylock = &qdisc_tx_busylock_key;
+	dev->qdisc_running_key = &qdisc_running_key;
+
+	lockdep_register_key(&macvlan->addr_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &macvlan->addr_lock_key);
+
+	lockdep_register_key(&macvlan->xmit_lock_key);
+	netdev_for_each_tx_queue(dev, macvlan_dev_set_lockdep_one, NULL);
 }
 
 static int macvlan_init(struct net_device *dev)
@@ -900,7 +916,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
 
-	macvlan_set_lockdep_class(dev);
+	macvlan_dev_set_lockdep_class(dev);
 
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->pcpu_stats)
@@ -922,6 +938,9 @@ static void macvlan_uninit(struct net_device *dev)
 	port->count -= 1;
 	if (!port->count)
 		macvlan_port_destroy(port->dev);
+
+	lockdep_unregister_key(&vlan->addr_lock_key);
+	lockdep_unregister_key(&vlan->xmit_lock_key);
 }
 
 static void macvlan_dev_get_stats64(struct net_device *dev,
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 2e55e4cdbd8a..ea5b41823287 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -31,6 +31,8 @@ struct macvlan_dev {
 	u16			flags;
 	int			nest_level;
 	unsigned int		macaddr_count;
+	struct lock_class_key xmit_lock_key;
+	struct lock_class_key addr_lock_key;
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct netpoll		*netpoll;
 #endif
-- 
2.17.1

