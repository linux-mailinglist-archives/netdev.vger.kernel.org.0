Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B69DB3BC8
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbfIPNs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:48:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35094 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387751AbfIPNs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:48:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so23058372pfw.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g8eaDZnnKT+l+rr+X6QJHo4HKbmXnQXglT66ibBbMp4=;
        b=F0wIK8upbYiB8Y6BJnd+X2TrGZtDw/+FO2bGa6A3/MJZM3ZeCFtqAp7BLrMaYOMMhJ
         b76GD5DBNOq8uinHPM12MtXNAH7je3nFgxfzoatGg1oZEMVfV9OE2duJnQeqzx2OyxUb
         pB2yPzNq0N5Tbv+qoTCmNfR4xX18PlIg88g0AWZZfAcOsbhx+hzcizUjIeUzkL+mmuk4
         qLt5ONSko6P5seA25MREyrZRGI+DAum2QOB1L6Zm7WM4l6pTqxErVSB2tX65qBGMs/AJ
         WEct8uzDsI9WTkMI45cQnCapAnEiNprAKZf+YqU6ZPbnhdwodVTmEcW/QS94S2hNVVqy
         JEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g8eaDZnnKT+l+rr+X6QJHo4HKbmXnQXglT66ibBbMp4=;
        b=hx2XskO10t1zQ9jDc6V2zpLFVFP1DSRBMPJJM++j8su5rrkCF18400Nz7o0nRk/Tmg
         0W2Dc3eOBVdnus0T2xTUJw0suS93f5TG51/wyIkmcrDT+hv/P2SWJy1+p7M473kPnl+B
         UeEeOr4TrhFwBTou1PsKRMLLC/QOmbomZTUqCZqbxhz5pCAtGJ8whonrIpNRYVoadDCI
         nc16CF3Nl0vYTVn3cE7tIzaatfqZbagIKOncOTaelOK9QKD6u7Iqhii61wgSiusNpAus
         aO6TRyoGf1g86RLqihDeBi9aUyougpUO/h1/eCgafjGmh7Yu7MPrXyMHolUoy2qSWyKP
         E0Cw==
X-Gm-Message-State: APjAAAWOoqeuw7k03Q57m3cnGhN1fPuckUhDI3qktYRZXduGvrn2lyV1
        9YhLFKGwOju1PFv1XMfDLYM=
X-Google-Smtp-Source: APXvYqxhPsokTXyP1AUxL30hai+oOYMOl4RQGPSUc9TRwF1/FBHDv8qV1VoqaX5GdkExKLi6ek8dzg==
X-Received: by 2002:aa7:8d4b:: with SMTP id s11mr44701659pfe.132.1568641736874;
        Mon, 16 Sep 2019 06:48:56 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:48:55 -0700 (PDT)
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
Subject: [PATCH net v3 06/11] macsec: use dynamic lockdep key instead of subclass
Date:   Mon, 16 Sep 2019 22:47:57 +0900
Message-Id: <20190916134802.8252-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
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
[   57.903193] WARNING: possible recursive locking detected
[   57.913011] 5.3.0-rc8+ #179 Not tainted
[   57.915008] --------------------------------------------
[   57.916707] ip/964 is trying to acquire lock:
[   57.917102] 000000007f1963bf (&macsec_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   57.918476]
[   57.918476] but task is already holding lock:
[   57.918996] 000000006f6fbc66 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   57.919790]
[   57.919790] other info that might help us debug this:
[   57.920367]  Possible unsafe locking scenario:
[   57.920367]
[   57.920894]        CPU0
[   57.921119]        ----
[   57.921366]   lock(&macsec_netdev_addr_lock_key/1);
[   57.921813]   lock(&macsec_netdev_addr_lock_key/1);
[   57.922250]
[   57.922250]  *** DEADLOCK ***
[   57.922250]
[   57.924742]  May be due to missing lock nesting notation
[   57.924742]
[   57.925620] 4 locks held by ip/964:
[   57.926067]  #0: 00000000bf0ca196 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   57.927070]  #1: 000000006f6fbc66 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[   57.928241]  #2: 00000000e5b874a1 (&dev_addr_list_lock_key/3){+...}, at: dev_mc_sync+0xfa/0x1a0
[   57.929851]  #3: 000000002c43dd91 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[   57.930983]
[   57.930983] stack backtrace:
[   57.931582] CPU: 1 PID: 964 Comm: ip Not tainted 5.3.0-rc8+ #179
[   57.932439] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   57.935333] Call Trace:
[   57.935659]  dump_stack+0x7c/0xbb
[   57.936088]  __lock_acquire+0x26a9/0x3de0
[   57.936590]  ? register_lock_class+0x14d0/0x14d0
[   57.937694]  ? register_lock_class+0x14d0/0x14d0
[   57.938269]  lock_acquire+0x164/0x3b0
[   57.938734]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   57.939291]  _raw_spin_lock_nested+0x2e/0x60
[   57.940112]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   57.940672]  dev_uc_sync_multiple+0xfa/0x1a0
[   57.941730]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[   57.942340]  ? bond_init+0x6f0/0x6f0 [bonding]
[   57.942895]  ? do_raw_spin_trylock+0xa9/0x170
[   57.943435]  dev_mc_sync+0x15a/0x1a0
[   57.943891]  macsec_dev_set_rx_mode+0x3a/0x50 [macsec]
[   57.944560]  dev_set_rx_mode+0x21/0x30
[   57.945051]  __dev_open+0x202/0x310
[ ... ]

Fixes: e20038724552 ("macsec: fix lockdep splats when nesting devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - This patch is not changed
v1 -> v2 :
 - This patch is not changed

 drivers/net/macsec.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 8f46aa1ddec0..25a4fc88145d 100644
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
 
@@ -2749,7 +2751,32 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 
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
@@ -2780,6 +2807,7 @@ static int macsec_dev_init(struct net_device *dev)
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	macsec_dev_set_lockdep_class(dev);
 	return 0;
 }
 
@@ -2789,6 +2817,9 @@ static void macsec_dev_uninit(struct net_device *dev)
 
 	gro_cells_destroy(&macsec->gro_cells);
 	free_percpu(dev->tstats);
+
+	lockdep_unregister_key(&macsec->addr_lock_key);
+	lockdep_unregister_key(&macsec->xmit_lock_key);
 }
 
 static netdev_features_t macsec_fix_features(struct net_device *dev,
@@ -3263,10 +3294,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
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

