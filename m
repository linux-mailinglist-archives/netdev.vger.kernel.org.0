Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A793BB3BC4
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbfIPNs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:48:29 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41346 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfIPNs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:48:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id t10so1309193plr.8
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ynW3rd5xcj3F3em15sYI7a+15sdwKfWkfP33xIZ/VSw=;
        b=c/pVpbFgUkOh9ygY6duZQ0tgiVOxrMwQAQQLuxPAhRFXSKHfQc6WURsPSo9FzvNPBt
         A6I5slw/btQDu0kc3fOaOrHJazyu9vyIOMcwSPmjD21bGtSShanv1CUDt6mwHAvVQg+l
         RBodth8GJcy81/Q/59r9tAwaqxCEpEBZ4df6u/aRcXRRZE6gv2ctpOVvbduaPw+APMKN
         5sbjQRscmwoM5nVjKxxaO861d4AWIcRC7DmObktNTlO0qArhVKMTwO9BgexjgpUBhVhj
         mLuoAVnQsrnH4Fky9RelMJggLYrgNChZrtVVGBSBjwR4w352hYQtmS/+uFET9/+GplU2
         l0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ynW3rd5xcj3F3em15sYI7a+15sdwKfWkfP33xIZ/VSw=;
        b=TodyIgxUxbnJrJSu+iH4BQFVcO/5xeSPBU40/YsQR0qfwtcKAvyCcLejmNijDpBxVP
         UHcebSE+iHqOe4uRwWmInxFPwRiSowzQ3SqHFZGicEihVirHjAR2oOwAQgpiwAUfNg/L
         bNF4TzAzXLzy1jO6kxNJ7LCMKcRzX0eGqWumLB3iLXAK8FXl5flTJifO8aqja3bLeA70
         plzkmpXfsD8PZdQQBY+6nDT11oYLNXjnlfGUxM9YmUwaNl2kCYyoQa3eq0JYsjzQ7iSQ
         s9OcawRbXzkHAYoi66CrY91bZcZceAW15mzeYRDXe1Z0DtEZC2/v8hyFPmGNgB2AByKV
         2t/A==
X-Gm-Message-State: APjAAAW24sIJgeDxhrMD1uqUMfQrCFgugJ5eOonJIfY2iRwwh1qcwwyG
        WR1z2bViJDTNc0BGIaG7vqs=
X-Google-Smtp-Source: APXvYqwfgKOcSLN7HflPU/z1jZrYxpnH+Q/4H1iITJgLeTfazEAEPW023WNZXFnk9bma4kXx9KO6kQ==
X-Received: by 2002:a17:902:7c13:: with SMTP id x19mr65153129pll.322.1568641707716;
        Mon, 16 Sep 2019 06:48:27 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:48:26 -0700 (PDT)
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
Subject: [PATCH net v3 02/11] vlan: use dynamic lockdep key instead of subclass
Date:   Mon, 16 Sep 2019 22:47:53 +0900
Message-Id: <20190916134802.8252-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
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
[   66.163164] WARNING: possible recursive locking detected
[   66.163858] 5.3.0-rc8+ #179 Not tainted
[   66.165520] --------------------------------------------
[   66.166110] ip/983 is trying to acquire lock:
[   66.166603] 000000009b85ba3e (&vlan_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   66.194006]
[   66.194006] but task is already holding lock:
[   66.194636] 00000000cc752363 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   66.205191]
[   66.205191] other info that might help us debug this:
[   66.205903]  Possible unsafe locking scenario:
[   66.205903]
[   66.206504]        CPU0
[   66.206781]        ----
[   66.208737]   lock(&vlan_netdev_addr_lock_key/1);
[   66.257676]   lock(&vlan_netdev_addr_lock_key/1);
[   66.282069]
[   66.282069]  *** DEADLOCK ***
[   66.282069]
[   66.283708]  May be due to missing lock nesting notation
[   66.283708]
[   66.284588] 4 locks held by ip/983:
[   66.285035]  #0: 000000002989e16e (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   66.286051]  #1: 00000000cc752363 (&vlan_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   66.287217]  #2: 00000000eddac627 (&dev_addr_list_lock_key/3){+...}, at: dev_mc_sync+0xfa/0x1a0
[   66.288327]  #3: 000000001a459ff7 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[   66.289453]
[   66.289453] stack backtrace:
[   66.290019] CPU: 1 PID: 983 Comm: ip Not tainted 5.3.0-rc8+ #179
[   66.290802] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   66.297639] Call Trace:
[   66.298009]  dump_stack+0x7c/0xbb
[   66.298447]  __lock_acquire+0x26a9/0x3de0
[   66.298965]  ? register_lock_class+0x14d0/0x14d0
[   66.299547]  ? register_lock_class+0x14d0/0x14d0
[   66.300151]  lock_acquire+0x164/0x3b0
[   66.300621]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   66.301198]  _raw_spin_lock_nested+0x2e/0x60
[   66.301743]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   66.302311]  dev_uc_sync_multiple+0xfa/0x1a0
[   66.307650]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[   66.308175]  ? bond_init+0x6f0/0x6f0 [bonding]
[   66.308585]  dev_mc_sync+0x15a/0x1a0
[   66.308927]  vlan_dev_set_rx_mode+0x37/0x80 [8021q]
[   66.309375]  dev_set_rx_mode+0x21/0x30
[   66.309727]  __dev_open+0x202/0x310
[   66.310100]  ? dev_set_rx_mode+0x30/0x30
[   66.310513]  ? mark_held_locks+0xa5/0xe0
[   66.310934]  ? __local_bh_enable_ip+0xe9/0x1b0
[   66.311387]  __dev_change_flags+0x3c3/0x500
[   66.311839]  ? dev_set_allmulti+0x10/0x10
[   66.312248]  ? kmem_cache_alloc_trace+0x12c/0x320
[   66.312746]  dev_change_flags+0x7a/0x160
[   66.313161]  vlan_device_event+0x846/0x20d0 [8021q]
[ ... ]

Fixes: 0fe1e567d0b4 ("[VLAN]: nested VLAN: fix lockdep's recursive locking warning")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - This patch is not changed
v1 -> v2 :
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

