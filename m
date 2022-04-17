Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FB65046E8
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiDQHNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 03:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiDQHNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 03:13:19 -0400
X-Greylist: delayed 379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 17 Apr 2022 00:10:42 PDT
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FD83E5F3;
        Sun, 17 Apr 2022 00:10:42 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 6ADFD101E9E63;
        Sun, 17 Apr 2022 09:04:21 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 2449D621EA2E;
        Sun, 17 Apr 2022 09:04:21 +0200 (CEST)
X-Mailbox-Line: From 18b3541e5372bc9b9fc733d422f4e698c089077c Mon Sep 17 00:00:00 2001
Message-Id: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 17 Apr 2022 09:04:19 +0200
Subject: [PATCH] net: linkwatch: ignore events for unregistered netdevs
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jann Horn reports a use-after-free on disconnect of a USB Ethernet
(ax88179_178a.c).  Oleksij Rempel has witnessed the same issue with a
different driver (ax88172a.c).

Jann's report (linked below) explains the root cause in great detail,
but the gist is that USB Ethernet drivers call linkwatch_fire_event()
between unregister_netdev() and free_netdev().  The asynchronous work
linkwatch_event() may thus access the netdev after it's been freed.

USB Ethernet may not even be the only culprit.  To address the problem
in the most general way, ignore link events once a netdev's state has
been set to NETREG_UNREGISTERED.

That happens in netdev_run_todo() immediately before the call to
linkwatch_forget_dev().  Note that lweventlist_lock (and its implied
memory barrier) guarantees that a linkwatch_add_event() running after
linkwatch_forget_dev() will see the netdev's new state and bail out.
An unregistered netdev is therefore never added to link_watch_list
(but may have its __LINK_STATE_LINKWATCH_PENDING bit set, which should
not matter).  That obviates the need to invoke linkwatch_run_queue() in
netdev_wait_allrefs(), so drop it.

In a sense, the present commit is to *no longer* registered netdevs as
commit b47300168e77 ("net: Do not fire linkwatch events until the device
is registered.") is to *not yet* registered netdevs.

Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/netdevice.h |  2 --
 net/core/dev.c            | 17 -----------------
 net/core/link_watch.c     | 10 ++--------
 3 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59e27a2b7bf0..5d950b45b59d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4805,8 +4805,6 @@ extern const struct kobj_ns_type_operations net_ns_type_operations;
 
 const char *netdev_drivername(const struct net_device *dev);
 
-void linkwatch_run_queue(void);
-
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 8c6c08446556..0ee56965ff76 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10140,23 +10140,6 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 			list_for_each_entry(dev, list, todo_list)
 				call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
 
-			__rtnl_unlock();
-			rcu_barrier();
-			rtnl_lock();
-
-			list_for_each_entry(dev, list, todo_list)
-				if (test_bit(__LINK_STATE_LINKWATCH_PENDING,
-					     &dev->state)) {
-					/* We must not have linkwatch events
-					 * pending on unregister. If this
-					 * happens, we simply run the queue
-					 * unscheduled, resulting in a noop
-					 * for this device.
-					 */
-					linkwatch_run_queue();
-					break;
-				}
-
 			__rtnl_unlock();
 
 			rebroadcast_time = jiffies;
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 95098d1a49bd..9a0ea7cd68e4 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -107,7 +107,8 @@ static void linkwatch_add_event(struct net_device *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&lweventlist_lock, flags);
-	if (list_empty(&dev->link_watch_list)) {
+	if (list_empty(&dev->link_watch_list) &&
+	    dev->reg_state < NETREG_UNREGISTERED) {
 		list_add_tail(&dev->link_watch_list, &lweventlist);
 		dev_hold_track(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
 	}
@@ -250,13 +251,6 @@ void linkwatch_forget_dev(struct net_device *dev)
 }
 
 
-/* Must be called with the rtnl semaphore held */
-void linkwatch_run_queue(void)
-{
-	__linkwatch_run_queue(0);
-}
-
-
 static void linkwatch_event(struct work_struct *dummy)
 {
 	rtnl_lock();
-- 
2.35.2

