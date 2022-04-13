Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD154FF8C3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiDMOTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiDMOTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:19:18 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C618A5F8DE;
        Wed, 13 Apr 2022 07:16:53 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id CEE6830000647;
        Wed, 13 Apr 2022 16:16:49 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id C2C89870B5; Wed, 13 Apr 2022 16:16:49 +0200 (CEST)
Message-Id: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 13 Apr 2022 16:16:19 +0200
Subject: [PATCH] usbnet: Fix use-after-free on disconnect
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jann Horn reports a use-after-free on disconnect of a USB Ethernet
(ax88179_178a.c).  Oleksij Rempel has witnessed the same issue with a
different driver (ax88172a.c).

Jann's report (linked below) explains the root cause in great detail.
Briefly, USB Ethernet drivers schedule work (usbnet_deferred_kevent())
which in turn schedules another work (linkwatch_event()).  The problem
is that usbnet_disconnect() first synchronizes with linkwatch_event()
and only then with usbnet_deferred_kevent().  That allows
usbnet_deferred_kevent() to schedule another linkwatch_event() after
synchronization with the latter.  In other words, scheduling happens
in AB order and synchronization on disconnect happens in BA order.

The correct order is to first synchronize with usbnet_deferred_kevent()
(and prevent any future execution), then with linkwatch_event(), i.e.
in AB order.

Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/usb/usbnet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 9a6450f796dc..6c67ae48afeb 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -469,6 +469,9 @@ static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
  */
 void usbnet_defer_kevent (struct usbnet *dev, int work)
 {
+	if (dev->intf->condition == USB_INTERFACE_UNBINDING)
+		return;
+
 	set_bit (work, &dev->flags);
 	if (!schedule_work (&dev->kevent))
 		netdev_dbg(dev->net, "kevent %s may have been dropped\n", usbnet_event_names[work]);
@@ -1619,11 +1622,11 @@ void usbnet_disconnect (struct usb_interface *intf)
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind(dev, intf);
 
+	cancel_work_sync(&dev->kevent);
+
 	net = dev->net;
 	unregister_netdev (net);
 
-	cancel_work_sync(&dev->kevent);
-
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
 	usb_kill_urb(dev->interrupt);
-- 
2.35.2

