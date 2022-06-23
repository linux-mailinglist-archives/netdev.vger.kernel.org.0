Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A793B557AB4
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiFWMvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiFWMvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:51:52 -0400
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDFA46CB1;
        Thu, 23 Jun 2022 05:51:51 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 22EA4103B3F0B;
        Thu, 23 Jun 2022 14:51:49 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id E8B8E6021256;
        Thu, 23 Jun 2022 14:51:48 +0200 (CEST)
X-Mailbox-Line: From d1c87ebe9fc502bffcd1576e238d685ad08321e4 Mon Sep 17 00:00:00 2001
Message-Id: <d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 23 Jun 2022 14:50:59 +0200
Subject: [PATCH net-next v2] usbnet: Fix linkwatch use-after-free on
 disconnect
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

usbnet uses the work usbnet_deferred_kevent() to perform tasks which may
sleep.  On disconnect, completion of the work was originally awaited in
->ndo_stop().  But in 2003, that was moved to ->disconnect() by historic
commit "[PATCH] USB: usbnet, prevent exotic rtnl deadlock":

  https://git.kernel.org/tglx/history/c/0f138bbfd83c

The change was made because back then, the kernel's workqueue
implementation did not allow waiting for a single work.  One had to wait
for completion of *all* work by calling flush_scheduled_work(), and that
could deadlock when waiting for usbnet_deferred_kevent() with rtnl_mutex
held in ->ndo_stop().

The commit solved one problem but created another:  It causes a
use-after-free in USB Ethernet drivers aqc111.c, asix_devices.c,
ax88179_178a.c, ch9200.c and smsc75xx.c:

* If the drivers receive a link change interrupt immediately before
  disconnect, they raise EVENT_LINK_RESET in their (non-sleepable)
  ->status() callback and schedule usbnet_deferred_kevent().
* usbnet_deferred_kevent() invokes the driver's ->link_reset() callback,
  which calls netif_carrier_{on,off}().
* That in turn schedules the work linkwatch_event().

Because usbnet_deferred_kevent() is awaited after unregister_netdev(),
netif_carrier_{on,off}() may operate on an unregistered netdev and
linkwatch_event() may run after free_netdev(), causing a use-after-free.

In 2010, usbnet was changed to only wait for a single instance of
usbnet_deferred_kevent() instead of *all* work by commit 23f333a2bfaf
("drivers/net: don't use flush_scheduled_work()").

Unfortunately the commit neglected to move the wait back to
->ndo_stop().  Rectify that omission at long last.

Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>
---
 This seems to be Jakub's preferred way to solve the use-after-free.
 I've tagged the patch for net-next so that it can bake in linux-next
 for a few weeks, but it alternatively applies cleanly to net (in case
 maintainers are eager to get it into mainline).
 
 The patch supersedes the following prior attempts:
 
 usbnet: Fix use-after-free on disconnect
 https://lore.kernel.org/netdev/127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de/

 net: linkwatch: ignore events for unregistered netdevs
 https://lore.kernel.org/netdev/18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de/

 net: linkwatch: ignore events for unregistered netdevs (v2)
 https://lore.kernel.org/netdev/cover.1655024266.git.lukas@wunner.de/

 drivers/net/usb/usbnet.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dc79811535c2..63868c1fbea4 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -849,13 +849,11 @@ int usbnet_stop (struct net_device *net)
 
 	mpn = !test_and_clear_bit(EVENT_NO_RUNTIME_PM, &dev->flags);
 
-	/* deferred work (task, timer, softirq) must also stop.
-	 * can't flush_scheduled_work() until we drop rtnl (later),
-	 * else workers could deadlock; so make workers a NOP.
-	 */
+	/* deferred work (timer, softirq, task) must also stop */
 	dev->flags = 0;
 	del_timer_sync (&dev->delay);
 	tasklet_kill (&dev->bh);
+	cancel_work_sync(&dev->kevent);
 	if (!pm)
 		usb_autopm_put_interface(dev->intf);
 
@@ -1619,8 +1617,6 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
-	cancel_work_sync(&dev->kevent);
-
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
 	if (dev->driver_info->unbind)
-- 
2.35.2

