Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA36AC6CC
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394588AbfIGNp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:45:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43886 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbfIGNp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:45:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id d15so6383470pfo.10
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ps0gIofTlFcfdZfC4JRSnzND2si3Id1Kt0D0I9ATfy0=;
        b=p+pMQO0i3ilsU52ky1KizrzNlFUUUdLJYf+n7fBOPwJRYeMsxIB2cgP4sr8GpPHaxc
         POaZVkfRGMZUTi1mgytbfKHoILPvHyNmYESMUI2HaVe9GQhHe2Ow9dEyp4kVGw8A1vjF
         EYR9cmmJxk7OOm8mUbwZyHwBefvlGCpVeoh1KUA3Slg4npRA57XjrtAK9/GSEk72cGAf
         1LoWUo4z2Wab+Ln6RfioQOUk54wlEqXPlbBHpvFWoyEKcfHE/Dt3VBVN3mHkM384Mguz
         IAlS3ard+DDuxgu9dIs6kJAXfymApv9q8bd795SIOxtQAFSHj+bJ2boFKhz8XFO8ckxp
         ockg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ps0gIofTlFcfdZfC4JRSnzND2si3Id1Kt0D0I9ATfy0=;
        b=frHeoebDmYHD4FSlKlW5WDz+fmPH0HkF0XUrNL849YkANC6hu/6E/3OuzMqBoN5v9E
         rV5ozicpi0kvuBsAa2Shh8HZFO0G+bjDVd20FL6Co6uo7BN3QhZ/pLfTFqWkWrYXKjv/
         VdIKNBUOdoLAGh0rdBdcSeIwpoL1CIPHoSrgiEjuy9hHEA58Bbf2fB5WEhCUdBfGbq8u
         JsL7YIGB689vTDuSIx9uGmuTO0k6QDDVDdBsEDfsIk27zeMzhECe9qcwfXJf0HfE/0BP
         b0al51W0gL40Kf3MlGowPJmtYRSr2lfkpc9LaNJXdcD2nz3/MZS4zbfKbWys4799UPxb
         DW7A==
X-Gm-Message-State: APjAAAX7oshOn6tFHxMt4Iu4+kELWJI1LjxmyjM4vtnarySUlZbTYp0/
        bbDj/7eGzJcQHHIaxip4BFs=
X-Google-Smtp-Source: APXvYqw/Ht96idznp49eUsOhSmr5UXTiujWxEFMsITJQ2VVVijuoPYDbDOr5ve4q4xiD+G/yBM4uoQ==
X-Received: by 2002:a62:5c82:: with SMTP id q124mr17006774pfb.177.1567863958347;
        Sat, 07 Sep 2019 06:45:58 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id 136sm10576439pfz.123.2019.09.07.06.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:45:57 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 02/11] vlan: use dynamic lockdep key instead of subclass
Date:   Sat,  7 Sep 2019 22:45:48 +0900
Message-Id: <20190907134548.32071-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All VLAN device has same lockdep key and subclass is initialized with
nest_level.
But actual nest_level value can be changed when a lower device is attached.
And at this moment, the subclass should be updated but it seems to be
unsafe.
So this patch makes VLAN use dynamic lockdep key instead of the subclass.

Test commands:
   ip link add dummy0 type dummy
   ip link set dummy0 up
   ip link add bond0 type bond

   ip link add vlan_dummy1 link dummy0 type vlan id 1
   ip link add vlan_bond1 link bond0 type vlan id 2
   ip link set vlan_dummy1 master bond0

   ip link set bond0 up
   ip link set vlan_dummy1 up
   ip link set vlan_bond1 up

Both vlan_dummy1 and vlan_bond1 have the same subclass and it makes
unnecessary deadlock warning message.

Splat looks like:
[  149.244978] ============================================
[  149.244978] WARNING: possible recursive locking detected
[  149.244978] 5.3.0-rc7+ #322 Not tainted
[  149.244978] --------------------------------------------
[  149.244978] ip/1340 is trying to acquire lock:
[  149.244978] 000000001399b1a7 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[  149.279600]
[  149.279600] but task is already holding lock:
[  149.279600] 00000000b963d9b4 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[  149.279600]
[  149.279600] other info that might help us debug this:
[  149.305981]  Possible unsafe locking scenario:
[  149.305981]
[  149.305981]        CPU0
[  149.305981]        ----
[  149.305981]   lock(&vlan_netdev_addr_lock_key/1);
[  149.305981]   lock(&vlan_netdev_addr_lock_key/1);
[  149.326258]
[  149.326258]  *** DEADLOCK ***
[  149.326258]
[  149.326258]  May be due to missing lock nesting notation
[  149.326258]
[  149.326258] 4 locks held by ip/1340:
[  149.326258]  #0: 00000000927f0698 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  149.326258]  #1: 00000000b963d9b4 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[  149.326258]  #2: 0000000027395445 (&dev_addr_list_lock_key/3){+...}, at: dev_mc_sync+0xfa/0x1a0
[  149.369961]  #3: 00000000ce334932 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[  149.369961]
[  149.369961] stack backtrace:
[  149.369961] CPU: 1 PID: 1340 Comm: ip Not tainted 5.3.0-rc7+ #322
[  149.369961] Call Trace:
[  149.369961]  dump_stack+0x7c/0xbb
[  149.369961]  __lock_acquire+0x26a9/0x3de0
[  149.369961]  ? register_lock_class+0x14d0/0x14d0
[  149.369961]  ? register_lock_class+0x14d0/0x14d0
[  149.369961]  lock_acquire+0x164/0x3b0
[  149.433970]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  149.433970]  _raw_spin_lock_nested+0x2e/0x60
[  149.433970]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  149.433970]  dev_uc_sync_multiple+0xfa/0x1a0
[  149.433970]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[  149.433970]  ? bond_init+0x6f0/0x6f0 [bonding]
[  149.433970]  dev_mc_sync+0x15a/0x1a0
[  149.433970]  vlan_dev_set_rx_mode+0x37/0x80 [8021q]
[  149.433970]  dev_set_rx_mode+0x21/0x30
[  149.433970]  __dev_open+0x202/0x310
[  149.433970]  ? dev_set_rx_mode+0x30/0x30
[  149.433970]  ? mark_held_locks+0xa5/0xe0
[  149.433970]  ? __local_bh_enable_ip+0xe9/0x1b0
[  149.433970]  __dev_change_flags+0x3c3/0x500
[  ... ]

Fixes: 0fe1e567d0b4 ("[VLAN]: nested VLAN: fix lockdep's recursive locking warning")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

 include/linux/if_vlan.h |  3 +++
 net/8021q/vlan_dev.c    | 28 +++++++++++++++-------------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 244278d5c222..1aed9f613e90 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -183,6 +183,9 @@ struct vlan_dev_priv {
 	struct netpoll				*netpoll;
 #endif
 	unsigned int				nest_level;
+
+	struct lock_class_key			xmit_lock_key;
+	struct lock_class_key			addr_lock_key;
 };
 
 static inline struct vlan_dev_priv *vlan_dev_priv(const struct net_device *dev)
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 93eadf179123..12bc80650087 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -494,24 +494,24 @@ static void vlan_dev_set_rx_mode(struct net_device *vlan_dev)
  * "super class" of normal network devices; split their locks off into a
  * separate class since they always nest.
  */
-static struct lock_class_key vlan_netdev_xmit_lock_key;
-static struct lock_class_key vlan_netdev_addr_lock_key;
-
 static void vlan_dev_set_lockdep_one(struct net_device *dev,
 				     struct netdev_queue *txq,
-				     void *_subclass)
+				     void *_unused)
 {
-	lockdep_set_class_and_subclass(&txq->_xmit_lock,
-				       &vlan_netdev_xmit_lock_key,
-				       *(int *)_subclass);
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+
+	lockdep_set_class(&txq->_xmit_lock, &vlan->xmit_lock_key);
 }
 
-static void vlan_dev_set_lockdep_class(struct net_device *dev, int subclass)
+static void vlan_dev_set_lockdep_class(struct net_device *dev)
 {
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &vlan_netdev_addr_lock_key,
-				       subclass);
-	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, &subclass);
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+
+	lockdep_register_key(&vlan->addr_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &vlan->addr_lock_key);
+
+	lockdep_register_key(&vlan->xmit_lock_key);
+	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, NULL);
 }
 
 static int vlan_dev_get_lock_subclass(struct net_device *dev)
@@ -609,7 +609,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &vlan_type);
 
-	vlan_dev_set_lockdep_class(dev, vlan_dev_get_lock_subclass(dev));
+	vlan_dev_set_lockdep_class(dev);
 
 	vlan->vlan_pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->vlan_pcpu_stats)
@@ -630,6 +630,8 @@ static void vlan_dev_uninit(struct net_device *dev)
 			kfree(pm);
 		}
 	}
+	lockdep_unregister_key(&vlan->addr_lock_key);
+	lockdep_unregister_key(&vlan->xmit_lock_key);
 }
 
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
-- 
2.17.1

