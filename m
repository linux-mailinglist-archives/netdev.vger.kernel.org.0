Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B4EC1162
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfI1QuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:50:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34578 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1QuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:50:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id k7so2261581pll.1;
        Sat, 28 Sep 2019 09:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ODpmrXLn5S687oEyUC8qGycaIYQf/xOsGOKK8D7XnDE=;
        b=ZvbIh7kqho+ncXgu8KAOkEvheJshficVaFZSWBd2oJgDy7VgPvqP7hdJOGbkB+amZb
         qi/vABGcqF+OXJ6e6xJAf0INFWMlFpw0rEKiFCvahTXVW+Mg326nPdHdO5NRle6L5kn1
         l6bLT+9P+jxs3wHo2UrVe7aDq0sDJdfJqAkf7Rc4UufPMgzDx1mHSvoR20v3xeM2ME6m
         jo7KWpwbtJahkAW+cbh3y06RB3XbSYIed1KkLN5gyyKnCg5reyoETaOz17GQDIaeQx+p
         THcOnUpq+LMUlWKea1PH+IbvELZJ9CBNNfiyEIOfPYncGh6yfLGxmWOJ1kkMwzfvFB2B
         WxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ODpmrXLn5S687oEyUC8qGycaIYQf/xOsGOKK8D7XnDE=;
        b=au/IDJHLc6L9OXjc3F7MI2S1c8e+6F5Czo2zF90uJsLpKVXg0Ao/f/xtN3ggxTnxQN
         EED93hG7q8G1IXxt++wy9uUL1RY3gSIXKVKkblo7BqXOxk6v7qD/N+sjeeWDcWxqpNGM
         P19n1WlxqHcBjHDOpZe26NybIdm0mgZWdRlOfVBS5nIjnouEAmLe1TCfg3Fx+Kae2DyQ
         CRbulqWB1efkvgT86Fb+ZdmWXOfZwwOxebkYIh0NACNQcpQhg1ZNLj8s4htPNib2DIpv
         J1AeuhVeef54/sljx/VB3Idj+g0LcfRPw55YgX9HFrlCiuzDlv7Bscm6CJXjUAjUqcG3
         k3dw==
X-Gm-Message-State: APjAAAVixHg24dLNyNzcD5Zz80c9ALoQIB9PNhl8yZ3tO7HaOURDkZ5k
        8MGJDdipJZZnlAFIqjfwhyI=
X-Google-Smtp-Source: APXvYqxRxG18735Jgxmd8lUJinh3+WBGjMU6ehvmfQKC28kY5TvDpX0Kc5vXDBzg2hbpoE+n7EXhFw==
X-Received: by 2002:a17:902:868a:: with SMTP id g10mr11458268plo.235.1569689403184;
        Sat, 28 Sep 2019 09:50:03 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:50:02 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 07/12] macvlan: use dynamic lockdep key instead of subclass
Date:   Sat, 28 Sep 2019 16:48:38 +0000
Message-Id: <20190928164843.31800-8-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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
[   30.281866] WARNING: possible recursive locking detected                                                              
[   30.282374] 5.3.0+ #3 Not tainted                                                                                     
[   30.282673] --------------------------------------------                                                              
[   30.283138] ip/643 is trying to acquire lock:                                                                         
[   30.283522] ffff88806750c818 (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0             
[   30.284363]                                                                                                           
[   30.284363] but task is already holding lock:                                                                         
[   30.284878] ffff88806853ead8 (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30                   
[   30.285680]                                                                                                           
[   30.285680] other info that might help us debug this:                                                                 
[   30.286274]  Possible unsafe locking scenario:                                                                        
[   30.286274]                                                                                                           
[   30.286903]        CPU0                                                                                               
[   30.287192]        ----                                                                                               
[   30.287475]   lock(&macvlan_netdev_addr_lock_key/1);                                                                  
[   30.288121]   lock(&macvlan_netdev_addr_lock_key/1);                                                                  
[   30.288818]                                                                                                           
[   30.288818]  *** DEADLOCK ***                                                                                         
[   30.288818]                                                                   
[   30.294651]  May be due to missing lock nesting notation                             
[   30.294651]                                                     
[   30.295660] 4 locks held by ip/643:           
[   30.296076]  #0: ffffffff93ec7a30 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   30.297030]  #1: ffff88806853ead8 (&macvlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   30.298749]  #2: ffff888063b8a3f8 (&dev_addr_list_lock_key/3){+...}, at: dev_uc_sync+0xfa/0x1a0
[   30.299727]  #3: ffffffff93b22780 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[   30.302803]                                  
[   30.302803] stack backtrace:                                                                             
[   30.303254] CPU: 1 PID: 643 Comm: ip Not tainted 5.3.0+ #3
[   30.303907] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   30.310458] Call Trace:                                                                            
[   30.310694]  dump_stack+0x7c/0xbb                   
[   30.311016]  __lock_acquire+0x26a9/0x3df0            
[   30.311390]  ? register_lock_class+0x14d0/0x14d0
[   30.311815]  lock_acquire+0x164/0x3b0          
[   30.312237]  ? dev_uc_sync_multiple+0xfa/0x1a0 
[   30.312776]  ? rcu_read_lock_held+0x90/0xa0  
[   30.313293]  _raw_spin_lock_nested+0x2e/0x60        
[   30.313819]  ? dev_uc_sync_multiple+0xfa/0x1a0      
[   30.314429]  dev_uc_sync_multiple+0xfa/0x1a0
[   30.314950]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[   30.315541]  ? bond_init+0x6f0/0x6f0 [bonding]
[   30.316075]  dev_uc_sync+0x15a/0x1a0                    
[ ... ]
Fixes: c674ac30c549 ("macvlan: Fix lockdep warnings with stacked macvlan devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v4 :
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

