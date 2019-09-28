Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4BC115F
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfI1Qt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:49:56 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35624 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1Qt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:49:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id y10so2261411plp.2;
        Sat, 28 Sep 2019 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fG2ag5Kn+p57OLQ5yCzXYuHH56rcNXzarRBtRO20Www=;
        b=a0c0VTeVoBWPTuzhkKeNHy9HgVzD3pZ7De/RAUduwZo7/7Nx6FPY7cIlOCI9wYKb9G
         e98oRuPFR6XSD4ikKZ0mYaDNEfBAGlkbZUddGbLks/Pi42o78+aBKsTxR+jGSfq2ftiy
         S0L9rDucCRN18a4UpjqoiAxcZWa7xKmfLaAeZZRoewlQ7qez9x0XAggmud/54xVhsdIM
         5MXQIk98m+Hpargw14EcxvIIPHs036uLGOhVRQCASIYIaUkL24h7Z4bsnCrMx7NPbY/F
         GG88HchJAZNVY5w3pU0LHPAmDAQWArIaVziQ/K2KVEnv9vFm4BdnP0yQvsviNe8iOFTp
         g0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fG2ag5Kn+p57OLQ5yCzXYuHH56rcNXzarRBtRO20Www=;
        b=qgVCAGYI/2n5iTOm6E0obu0RKBKFwfMmqzr7Mw/KxapUyNi152k0fCPJLVMPcaCnZ0
         +2uyl2VnhEyI8GPIh7u+C+y4rhm8De5nUZs0yQzX1CPZJob7gA+ZN/40HQS7OaLdM8Cm
         isa1uX05+4UEGody6zftFjVvLgmtpN2drYep3lXoZ0YpI4CrGOusl2qvM/EUqOdY9ecU
         V5igoZ5KbC63rUD90pNvZxp9Vn5AJuEd2Q/z87TSYHS4yXtldJy9AeD2vDYLhvJmyar9
         nEArM7PPcYM/D4OF1iOgWx6y/DBjnE+X41pWr2OWe2T+pCWmRUSjJRzQhqjyQKo3CwH9
         LWvg==
X-Gm-Message-State: APjAAAUCQbORfoSRMYDkadDqiORTD3YXE5x+72Qxk+gwxT2V0aoX2Vs3
        fxV7R9kqAeRKpXcenFaHu70=
X-Google-Smtp-Source: APXvYqzuVMZwzShhM3z9qLTnZM+OtA9QZCVHUBVL/huTKpVVHxji6xMAqbeLoaSFU1rvBbLiZd81rw==
X-Received: by 2002:a17:902:7485:: with SMTP id h5mr11382348pll.240.1569689394958;
        Sat, 28 Sep 2019 09:49:54 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:49:53 -0700 (PDT)
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
Subject: [PATCH net v4 06/12] macsec: use dynamic lockdep key instead of subclass
Date:   Sat, 28 Sep 2019 16:48:37 +0000
Message-Id: <20190928164843.31800-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All macsec device has same lockdep key and subclass is initialized with
nest_level.
But actual nest_level value can be changed when a lower device is attached.
And at this moment, the subclass should be updated but it seems to be
unsafe.
So this patch makes macsec use dynamic lockdep key instead of the subclass.

Test commands:
    ip link add bond0 type bond
    ip link add dummy0 type dummy
    ip link add macsec0 link bond0 type macsec
    ip link add macsec1 link dummy0 type macsec
    ip link set bond0 mtu 1000
    ip link set macsec1 master bond0

    ip link set bond0 up
    ip link set macsec0 up
    ip link set dummy0 up
    ip link set macsec1 up

Splat looks like:
[   29.758606] WARNING: possible recursive locking detected                                               
[   29.759626] 5.3.0+ #3 Not tainted                                                              
[   29.760670] --------------------------------------------                                         
[   29.761385] ip/639 is trying to acquire lock: 
[   29.761938] ffff888067680298 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   29.763073]                                               
[   29.763073] but task is already holding lock:                                            
[   29.763840] ffff888060148298 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   29.764931]                                         
[   29.764931] other info that might help us debug this:
[   29.765721]  Possible unsafe locking scenario:   
[   29.765721]                               
[   29.766615]        CPU0                        
[   29.766914]        ----                        
[   29.767256]   lock(&macsec_netdev_addr_lock_key/1);
[   29.767847]   lock(&macsec_netdev_addr_lock_key/1);
[   29.768441]                                  
[   29.768441]  *** DEADLOCK ***                      
[   29.768441]                                    
[   29.769158]  May be due to missing lock nesting notation
[   29.769158]                            
[   29.770083] 4 locks held by ip/639:                   
[   29.770908]  #0: ffffffff93ec7a30 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   29.771970]  #1: ffff888060148298 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   29.773216]  #2: ffff888063e58298 (&dev_addr_list_lock_key/3){+...}, at: dev_mc_sync+0xfa/0x1a0
[   29.774324]  #3: ffffffff93b22780 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[   29.775459]                                   
[   29.775459] stack backtrace:               
[   29.775986] CPU: 0 PID: 639 Comm: ip Not tainted 5.3.0+ #3
[   29.776719] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   29.777707] Call Trace:                                                                                               
[   29.778012]  dump_stack+0x7c/0xbb                                                 
[   29.778434]  __lock_acquire+0x26a9/0x3df0                                    
[   29.778920]  ? register_lock_class+0x14d0/0x14d0                             
[   29.779537]  lock_acquire+0x164/0x3b0                                        
[   29.779981]  ? dev_uc_sync_multiple+0xfa/0x1a0                               
[   29.780523]  ? rcu_read_lock_held+0x90/0xa0                                  
[   29.781028]  _raw_spin_lock_nested+0x2e/0x60                          
[   29.781550]  ? dev_uc_sync_multiple+0xfa/0x1a0                      
[   29.782311]  dev_uc_sync_multiple+0xfa/0x1a0 
[   29.782832]  bond_set_rx_mode+0x269/0x3c0 [bonding]                                                                  
[ ... ]

Fixes: e20038724552 ("macsec: fix lockdep splats when nesting devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v4 :
 - This patch is not changed

 drivers/net/macsec.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index cb7637364b40..c4a41b90c846 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -267,6 +267,8 @@ struct macsec_dev {
 	struct pcpu_secy_stats __percpu *stats;
 	struct list_head secys;
 	struct gro_cells gro_cells;
+	struct lock_class_key xmit_lock_key;
+	struct lock_class_key addr_lock_key;
 	unsigned int nest_level;
 };
 
@@ -2750,7 +2752,32 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 
 #define MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
-static struct lock_class_key macsec_netdev_addr_lock_key;
+
+static void macsec_dev_set_lockdep_one(struct net_device *dev,
+				       struct netdev_queue *txq,
+				       void *_unused)
+{
+	struct macsec_dev *macsec = macsec_priv(dev);
+
+	lockdep_set_class(&txq->_xmit_lock, &macsec->xmit_lock_key);
+}
+
+static struct lock_class_key qdisc_tx_busylock_key;
+static struct lock_class_key qdisc_running_key;
+
+static void macsec_dev_set_lockdep_class(struct net_device *dev)
+{
+	struct macsec_dev *macsec = macsec_priv(dev);
+
+	dev->qdisc_tx_busylock = &qdisc_tx_busylock_key;
+	dev->qdisc_running_key = &qdisc_running_key;
+
+	lockdep_register_key(&macsec->addr_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &macsec->addr_lock_key);
+
+	lockdep_register_key(&macsec->xmit_lock_key);
+	netdev_for_each_tx_queue(dev, macsec_dev_set_lockdep_one, NULL);
+}
 
 static int macsec_dev_init(struct net_device *dev)
 {
@@ -2781,6 +2808,7 @@ static int macsec_dev_init(struct net_device *dev)
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	macsec_dev_set_lockdep_class(dev);
 	return 0;
 }
 
@@ -2790,6 +2818,9 @@ static void macsec_dev_uninit(struct net_device *dev)
 
 	gro_cells_destroy(&macsec->gro_cells);
 	free_percpu(dev->tstats);
+
+	lockdep_unregister_key(&macsec->addr_lock_key);
+	lockdep_unregister_key(&macsec->xmit_lock_key);
 }
 
 static netdev_features_t macsec_fix_features(struct net_device *dev,
@@ -3264,10 +3295,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	dev_hold(real_dev);
 
 	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
-	netdev_lockdep_set_classes(dev);
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &macsec_netdev_addr_lock_key,
-				       macsec_get_nest_level(dev));
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
 	if (err < 0)
-- 
2.17.1

