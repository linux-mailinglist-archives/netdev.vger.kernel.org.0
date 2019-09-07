Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09ACAC6D0
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394642AbfIGNqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:46:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36491 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733278AbfIGNqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:46:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so6417252pfr.3
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=96pFkduzmJrdb3ENbrleY2Qc+hL1joupTUsDyzf+3Jg=;
        b=CwMOtSxczx2eMZCriVDekc1d3NEnKQdSLqodeqhfgy1eTZh0s64gUYMHLP7sR+h2pz
         PpMuUWucbND0muzS5EsRAr5KSOiU5CJYfrtrrHdI8j9c5fE3jH6Cs2AXyui5UhrmBYgo
         5E/CCVknONawjItUGskD948PpGpdFbXUI35APW6Mx61Xvrygsv73vSEhD9IYveJZJ1ZF
         4TZ6cSwNRNaVKt3PUQAMqeVgge04WGFOcyayxhM7+gzuTToFppM49PdrBkyP2Kj9PUkC
         ND4vMFMpV7GNZQcaARJjpAXm+2k6gJpWyLBUYLDk6R2JI3h3Jn8r8OqLYzRgZ9hmnRw2
         JBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=96pFkduzmJrdb3ENbrleY2Qc+hL1joupTUsDyzf+3Jg=;
        b=V2MZu3kXND0+JbWT9EjmJB7v4XsE67wvajYE/q9CLPWeiTIkh1IZBxtdY/2oNU1buw
         euK3eyovyzFKBL6QvLFI06nBm0Z/vjS6vz2aDoswjjaWwsusgSse5mP5MknzFx0rH/fv
         0J3PQSJhNYR4uGzQGzWZRiZ4WZ+P0TTjdws9FcjrP30g1MwwlswrvXFn84kPGX+MkZcY
         SUzfGXZUY0gOMXElDNJjoKUBOvy0Ii2oVy5vBYeNl6DGpEL92bjac0fIVvmTSuaDskxo
         a4aNsQ/ihIxCkJJOaE2i8icv2PI2yogGUdVrFtMMtLrq3vzp5snaFtv1hCvOwgm5HDQd
         ob0g==
X-Gm-Message-State: APjAAAUp/lT+BSRjBSfmPQwprqGCEAXOGC4sgLaQ0fVGIvMgPUQUteHS
        fiQfqpwQ+Tp+7ek10PdFAiA=
X-Google-Smtp-Source: APXvYqwe3Lf+391JBdNfU+D4t9wcUGURPXbmUM/tY1v9z8vsepty6hZXJVRP4M2+q03ZJC1z+44e4g==
X-Received: by 2002:a63:9e54:: with SMTP id r20mr13005565pgo.64.1567864013423;
        Sat, 07 Sep 2019 06:46:53 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id d14sm14069210pfh.36.2019.09.07.06.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:46:52 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 06/11] macsec: use dynamic lockdep key instead of subclass
Date:   Sat,  7 Sep 2019 22:46:43 +0900
Message-Id: <20190907134643.32500-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
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
[  146.540123] ============================================
[  146.540123] WARNING: possible recursive locking detected
[  146.540123] 5.3.0-rc7+ #322 Not tainted
[  146.540123] --------------------------------------------
[  146.540123] ip/1340 is trying to acquire lock:
[  146.540123] 00000000446fd8bd (&macsec_netdev_addr_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[  146.540123]
[  146.540123] but task is already holding lock:
[  146.540123] 00000000a9ab6378 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[  146.540123]
[  146.540123] other info that might help us debug this:
[  146.540123]  Possible unsafe locking scenario:
[  146.540123]
[  146.540123]        CPU0
[  146.540123]        ----
[  146.540123]   lock(&macsec_netdev_addr_lock_key/1);
[  146.540123]   lock(&macsec_netdev_addr_lock_key/1);
[  146.623155]
[  146.623155]  *** DEADLOCK ***
[  146.623155]
[  146.623155]  May be due to missing lock nesting notation
[  146.623155]
[  146.623155] 4 locks held by ip/1340:
[  146.623155]  #0: 0000000026436ef0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  146.623155]  #1: 00000000a9ab6378 (&macsec_netdev_addr_lock_key/1){+...}, at: dev_set_rx_mode+0x19/0x30
[  146.623155]  #2: 00000000a8947dd0 (&dev_addr_list_lock_key/3){+...}, at: dev_mc_sync+0xfa/0x1a0
[  146.623155]  #3: 00000000b62011e9 (rcu_read_lock){....}, at: bond_set_rx_mode+0x5/0x3c0 [bonding]
[  146.674970]
[  146.674970] stack backtrace:
[  146.687145] CPU: 0 PID: 1340 Comm: ip Not tainted 5.3.0-rc7+ #322
[  146.693024] Call Trace:
[  146.693024]  dump_stack+0x7c/0xbb
[  146.693024]  __lock_acquire+0x26a9/0x3de0
[  146.693024]  ? register_lock_class+0x14d0/0x14d0
[  146.693024]  ? register_lock_class+0x14d0/0x14d0
[  146.693024]  lock_acquire+0x164/0x3b0
[  146.693024]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  146.693024]  _raw_spin_lock_nested+0x2e/0x60
[  146.693024]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  146.693024]  dev_uc_sync_multiple+0xfa/0x1a0
[  146.693024]  bond_set_rx_mode+0x269/0x3c0 [bonding]
[  146.751163]  ? bond_init+0x6f0/0x6f0 [bonding]
[  146.757006]  ? do_raw_spin_trylock+0xa9/0x170
[  146.757006]  dev_mc_sync+0x15a/0x1a0
[  146.757006]  macsec_dev_set_rx_mode+0x3a/0x50 [macsec]
[  146.757006]  dev_set_rx_mode+0x21/0x30
[  146.757006]  __dev_open+0x202/0x310
[  146.757006]  ? dev_set_rx_mode+0x30/0x30
[  146.757006]  ? mark_held_locks+0xa5/0xe0
[  146.757006]  ? __local_bh_enable_ip+0xe9/0x1b0
[  146.757006]  __dev_change_flags+0x3c3/0x500
[  146.757006]  ? dev_set_allmulti+0x10/0x10
[  146.757006]  ? sched_clock_local+0xd4/0x140
[  146.757006]  ? check_chain_key+0x236/0x5d0
[  146.757006]  dev_change_flags+0x7a/0x160
[  146.757006]  do_setlink+0xa26/0x2f20
[  146.757006]  ? sched_clock_local+0xd4/0x140
[  ... ]

Fixes: e20038724552 ("macsec: fix lockdep splats when nesting devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

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

