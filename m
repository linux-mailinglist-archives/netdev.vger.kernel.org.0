Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF584547982
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 11:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiFLJLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 05:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbiFLJLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 05:11:46 -0400
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672D656437;
        Sun, 12 Jun 2022 02:11:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 8846A10043734;
        Sun, 12 Jun 2022 11:11:43 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 5AFDA61A0C1F;
        Sun, 12 Jun 2022 11:11:43 +0200 (CEST)
X-Mailbox-Line: From ecd2ab4160b700b99820ae91c35c30ffda3864e7 Mon Sep 17 00:00:00 2001
Message-Id: <ecd2ab4160b700b99820ae91c35c30ffda3864e7.1655024266.git.lukas@wunner.de>
In-Reply-To: <cover.1655024266.git.lukas@wunner.de>
References: <cover.1655024266.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 12 Jun 2022 11:08:47 +0200
Subject: [PATCH net-next v2 1/1] net: linkwatch: ignore events for
 unregistered netdevs
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon unregistering, a netdev is deleted from the linkwatch event list by
linkwatch_forget_dev(), but nothing prevents a driver from re-adding it.

Such belated events cause a use-after-free if the linkwatch queue
happens to run after free_netdev().  Jann Horn and Oleksij Rempel
independently report such use-after-frees with different USB Ethernet
adapters.

netdev_wait_allrefs_any() attempts to wait for belated events, but
cannot catch any after it has returned.  Additionally it can get stuck
in an infinite loop if a driver keeps signaling link events.

Avoid both problems by ignoring events in linkwatch_add_event() once a
netdev's state has been set to NETREG_UNREGISTERED.

This state change happens in netdev_run_todo() right before
linkwatch_forget_dev().  linkwatch_add_event() is serialized with
linkwatch_forget_dev() through lweventlist_lock.  By checking the netdev
state under that lock, linkwatch_add_event() is guaranteed to never add
a netdev to the linkwatch queue after linkwatch_forget_dev().

It thus becomes unnecessary to wait for belated events in
netdev_wait_allrefs_any(), allowing us to simplify and speed up
unregistration.

The rationale of ignoring belated events is that nobody cares about
operstate changes of a netdev once it's unregistered.

A belated event will cause a netdev's __LINK_STATE_LINKWATCH_PENDING bit
to remain set perpetually.  That will speed up processing of further
belated events, as they are immediately ignored through the
test_and_set_bit() call in linkwatch_fire_event().

Note that we already ignore linkwatch events of *not yet* registered
netdevs since commit b47300168e77 ("net: Do not fire linkwatch events
until the device is registered.").  The present commit does the same for
*no longer* registered netdevs.

As an alternative to the present commit, I've considered amending USB
Ethernet drivers to avoid signaling belated events:  That is achieved by
holding a reference on the netdev while calling linkwatch_fire_event().
A concurrent netdev_wait_allrefs_any() is thus forced to keep spinning.
To avoid calling linkwatch_fire_event() after netdev_wait_allrefs_any()
has returned, the netdev's state must not be NETREG_UNREGISTERED.
Here's the resulting patch:
https://lore.kernel.org/netdev/20220430100541.GA18507@wunner.de/

I consider that alternative approach to be inferior:  It puts the onus
on drivers to call linkwatch_fire_event() only under specific conditions,
which is error-prone.  The present approach instead changes the core API
to be defensive and avoid use-after-frees even if the driver neglected
these checks.  While I've examined all USB drivers and provided fixes in
the above-linked patch, other network drivers may well remain vulnerable.
Another disadvantage of the alternative approach is that it inflates
code size, whereas the solution presented herein *reduces* LoC and
complexity.

Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>
---
 net/core/dev.c        | 17 -----------------
 net/core/dev.h        |  1 -
 net/core/link_watch.c | 10 ++--------
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8958c4227b67..bbfcd70b3e7c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10242,23 +10242,6 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
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
diff --git a/net/core/dev.h b/net/core/dev.h
index cbb8a925175a..dd0a47ddaac3 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -30,7 +30,6 @@ int __init dev_proc_init(void);
 
 void linkwatch_init_dev(struct net_device *dev);
 void linkwatch_forget_dev(struct net_device *dev);
-void linkwatch_run_queue(void);
 
 void dev_addr_flush(struct net_device *dev);
 int dev_addr_init(struct net_device *dev);
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index aa6cb1f90966..20634a55e1ce 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -108,7 +108,8 @@ static void linkwatch_add_event(struct net_device *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&lweventlist_lock, flags);
-	if (list_empty(&dev->link_watch_list)) {
+	if (list_empty(&dev->link_watch_list) &&
+	    dev->reg_state < NETREG_UNREGISTERED) {
 		list_add_tail(&dev->link_watch_list, &lweventlist);
 		netdev_hold(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
 	}
@@ -251,13 +252,6 @@ void linkwatch_forget_dev(struct net_device *dev)
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

