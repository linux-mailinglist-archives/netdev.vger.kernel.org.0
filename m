Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 089F8B3BC9
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfIPNtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:49:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41726 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387751AbfIPNtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:49:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id q7so1504778pfh.8
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9ryfwz8+CO4vKa8AgZEqIHnA9yEV1ieQHqj9PJgnOK4=;
        b=m+p+l5qcicoFxmpSfrz3p7M+6jwa+JOqvg6PHwfsuA+YbdBKIZM4huk5RGctiCEJve
         8KrTLSkModmqFyjORDTD7UxHl/QXpeWrdN8WBok+O/C+fupXRtqdE69xXjSXsE0Fzle8
         oKsRLdZy2drlDL8XEJWcv/Ptd42nCQ6xnEI3mplmxEiOq0i/m9jLY9ZZkd2nV75PkXHy
         BvKr0UrkN7jDUui2Nx1nNb+jfAjJUiYmbLn3RCfyaJGcecosknnh+RQItMtFkFsUEJiX
         AKLoVhHcSy5AeeC7eBzMgizMVWUeCMUimHIJKq1fJyIOdudnf7ZMeGt3NASzJkAEIMXU
         Enlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9ryfwz8+CO4vKa8AgZEqIHnA9yEV1ieQHqj9PJgnOK4=;
        b=nAMJTWjy++OqYEIS8CEBed566npIPRIw5oYG/U3MCiXBTf073p+Ph/7bex31dhYgcp
         TVztjo1PwU8a8NGRW5WLMA8n5eOHxSN7RXVorpZUwk0i+59vAGrV5v98eW+QvP47zkRq
         ZRgfymF2eOftkP+Qa1ZnDICVJhta6O4q/lGqO6ZRPP6y5O10K/WKH0f5FI3HpVdq+L9J
         dBRDbtGI7OtpjgQ7y1ylIbya9jBpHSygUecwD0lSXz1mFoydH3klP/cA1smL/yBzt+eh
         U3tR7oBd1jgi8oktU06luFLhyCZdI1VgNlIQ629n7TRuqYWP/8UchV6Rq/RzKcb3xty8
         6ZFQ==
X-Gm-Message-State: APjAAAWoBK8RFiz/Vn59lzpa5HOeGKwyci2ma+CTYcFJ6Yb0vI1p1XEy
        Lx+gJUS8BsJAghjyZaC1k+c=
X-Google-Smtp-Source: APXvYqxmVVYk/4VHtoMm5AJAF/kRXHQVspJxwcBsT4XM1/xDtF854s+Pq8QVlrkLz+6QIANfI0Y/OQ==
X-Received: by 2002:a63:ee04:: with SMTP id e4mr55953382pgi.53.1568641743159;
        Mon, 16 Sep 2019 06:49:03 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:49:02 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 07/11] macvlan: use dynamic lockdep key instead of subclass
Date:   Mon, 16 Sep 2019 22:47:58 +0900
Message-Id: <20190916134802.8252-8-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
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
[   55.694677] WARNING: possible recursive locking detected
[   55.695420] 5.3.0-rc8+ #179 Not tainted
[   55.709918] --------------------------------------------
[   55.711814] ip/982 is trying to acquire lock:
[   55.712387] 0000000023ca93f4 (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   55.713621]
[   55.713621] but task is already holding lock:
[   55.714364] 0000000070c93e9d (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   55.715548]
[   55.715548] other info that might help us debug this:
[   55.716428]  Possible unsafe locking scenario:
[   55.716428]
[   55.717231]        CPU0
[   55.717563]        ----
[   55.717907]   lock(&macvlan_netdev_addr_lock_key/1);
[   55.718574]   lock(&macvlan_netdev_addr_lock_key/1);
[   55.719149]
[   55.719149]  *** DEADLOCK ***
[   55.719149]
[   55.719865]  May be due to missing lock nesting notation
[   55.719865]
[   55.720607] 4 locks held by ip/982:
[   55.721056]  #0: 0000000096ab2afb (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   55.722031]  #1: 0000000070c93e9d (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   55.791914]  #2: 000000005409683b (&dev_addr_list_lock_key/3){+...}, at: dev_uc_sync+0xfa/0x1a0
[   55.792718]  #3: 0000000085f78eaf (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[   55.793533]
[   55.793533] stack backtrace:
[   55.793939] CPU: 0 PID: 982 Comm: ip Not tainted 5.3.0-rc8+ #179
[   55.794489] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   55.795227] Call Trace:
[   55.795493]  dump_stack+0x7c/0xbb
[   55.795809]  __lock_acquire+0x26a9/0x3de0
[   55.796184]  ? register_lock_class+0x14d0/0x14d0
[   55.797496]  ? register_lock_class+0x14d0/0x14d0
[   55.797971]  lock_acquire+0x164/0x3b0
[   55.838601]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   55.839281]  _raw_spin_lock_nested+0x2e/0x60
[   55.840289]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   55.841308]  dev_uc_sync_multiple+0xfa/0x1a0
[   55.841868]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[   55.842500]  ? bond_init+0x6f0/0x6f0 [bonding]
[   55.843076]  dev_uc_sync+0x15a/0x1a0
[   55.843567]  macvlan_set_mac_lists+0x55/0x110 [macvlan]
[   55.844247]  dev_set_rx_mode+0x21/0x30
[   55.844733]  __dev_open+0x202/0x310
[   55.845186]  ? dev_set_rx_mode+0x30/0x30
[   55.845707]  ? mark_held_locks+0xa5/0xe0
[   55.846219]  ? __local_bh_enable_ip+0xe9/0x1b0
[   55.846805]  __dev_change_flags+0x3c3/0x500
[   55.847376]  ? dev_set_allmulti+0x10/0x10
[   55.847906]  ? check_chain_key+0x236/0x5d0
[   55.848881]  dev_change_flags+0x7a/0x160
[   55.850015]  do_setlink+0xa49/0x2f40
[ ... ]

Fixes: c674ac30c549 ("macvlan: Fix lockdep warnings with stacked macvlan devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - This patch is not changed
v1 -> v2 :
 - This patch is not changed

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

