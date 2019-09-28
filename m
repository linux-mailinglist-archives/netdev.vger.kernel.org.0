Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F324C1156
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfI1QtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:49:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44758 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1QtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:49:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so3210836pfn.11;
        Sat, 28 Sep 2019 09:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WSz6brKkd9K89pT0qtUsH4QbRz26iGOxP3ApCY+qFQg=;
        b=uXszXltvxjTlx4tlAmzQ3Yhcya1WPXY+4MqFXDmmQHFj5S/ATNW1C7wLpns4fARlYf
         5BjU0OBxRIQKQjpcf2VLf8ZkpRhXGdLQdgBUopjgLjY4ExVFv7IjSp6iFuASdQurDenx
         /ZQDuvG4vpYeu113TU4YzoY+UhYnTG9AgiaQzLwSlHGdOyW4rbUFmAyZe5DjGaYSo+SV
         ux/XghQZzC4+/7fd2TrrSLfpr8Bb8LE6u1lFJvAN9ly6MjDd3+e0QZ6lT+YKz6DL1qLR
         tNmZG6Ex2cO8LB25xmVrMXJME4FEJCSXh8XhywWkIkftuFobAEVAN54SbOu29PGhvuAY
         mMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WSz6brKkd9K89pT0qtUsH4QbRz26iGOxP3ApCY+qFQg=;
        b=J6GQFaX723NspJd/rjxyW4ba9/8/SrQViecSaq1oPav+YcBcSTsbN+2qa3tbod3Zc7
         RMJgnqPiyE+eftVn3ehB5HuSxyR7Z6T5Gsea10Ze84yhaSu++NuTxMN0LL0dgVO7ei4t
         1k28qy6/7OTTOK+aXgXMgN6AFgNY8RViqTDWTkzBAaA0h3gKHF3SXWlMyD08KwMyJJmN
         Na1G8s5mOvZ8UOFsSL1M7r+udYA1AOYKIGi0Z3dxeOiQxCMsSUOIg1jPh4jx/X0tPGtu
         j2bidhKGxnFYrrcSPPR0OoXTeapsw03glHFAG+w0leFJRp8Tuw9SXSYuJoywk0yR1sWg
         oasg==
X-Gm-Message-State: APjAAAWSqzMOpkQ/Orbo7HyuC0p9F3Guv4bmeUkSHbDLF9P+ZkFUNyNL
        Wspj3OPRac8hBnhUEKqYNlA=
X-Google-Smtp-Source: APXvYqz+RllPo7XtJLUhand4l4vkq7qH+mS2pQIYFkZlVVakUeA6vo7Fk1XHLGUKiotbHifDGPhEpQ==
X-Received: by 2002:a63:1918:: with SMTP id z24mr14981048pgl.94.1569689361717;
        Sat, 28 Sep 2019 09:49:21 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:49:20 -0700 (PDT)
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
Subject: [PATCH net v4 02/12] vlan: use dynamic lockdep key instead of subclass
Date:   Sat, 28 Sep 2019 16:48:33 +0000
Message-Id: <20190928164843.31800-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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
[   75.879233] WARNING: possible recursive locking detected                                             
[   75.879881] 5.3.0+ #3 Not tainted                                                                                     
[   75.880285] --------------------------------------------                                         
[   75.880933] ip/634 is trying to acquire lock:                                
[   75.881463] ffff8880673c2558 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   75.882714]                                                                  
[   75.882714] but task is already holding lock:                                            
[   75.883502] ffff8880645193f8 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   75.884707]                                                              
[   75.884707] other info that might help us debug this:               
[   75.885742]  Possible unsafe locking scenario:                  
[   75.885742]                             
[   75.887013]        CPU0                               
[   75.887415]        ----                               
[   75.887723]   lock(&vlan_netdev_addr_lock_key/1);      
[   75.888280]   lock(&vlan_netdev_addr_lock_key/1);                                                                    
[   75.888852]
[   75.888852]  *** DEADLOCK ***
[   75.888852]
[   75.889569]  May be due to missing lock nesting notation
[   75.889569]
[   75.890453] 4 locks held by ip/634:
[   75.890992]  #0: ffffffff96ec7a30 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   75.892021]  #1: ffff8880645193f8 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   75.893387]  #2: ffff8880694c4558 (&dev_addr_list_lock_key/3){+...}, at: dev_mc_sync+0xfa/0x1a0
[   75.894545]  #3: ffffffff96b22780 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[   75.895558]
[   75.895558] stack backtrace:
[   75.896003] CPU: 0 PID: 634 Comm: ip Not tainted 5.3.0+ #3
[   75.896566] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   75.897549] Call Trace:
[   75.897916]  dump_stack+0x7c/0xbb
[   75.898287]  __lock_acquire+0x26a9/0x3df0
[   75.898664]  ? register_lock_class+0x14d0/0x14d0
[   75.899255]  lock_acquire+0x164/0x3b0
[   75.899718]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   75.900245]  ? rcu_read_lock_held+0x90/0xa0
[   75.900707]  _raw_spin_lock_nested+0x2e/0x60
[   75.901149]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   75.901629]  dev_uc_sync_multiple+0xfa/0x1a0
[   75.902116]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[   75.903135]  ? bond_init+0x6f0/0x6f0 [bonding]
[   75.903696]  dev_mc_sync+0x15a/0x1a0
[ ... ]

Fixes: 0fe1e567d0b4 ("[VLAN]: nested VLAN: fix lockdep's recursive locking warning")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v4 :
  - This patch is not changed

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

