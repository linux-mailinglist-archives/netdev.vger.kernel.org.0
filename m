Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9443F45E2
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 09:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhHWHiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 03:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbhHWHiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 03:38:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E566C061757
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 00:38:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mI4Wn-000377-OG; Mon, 23 Aug 2021 09:37:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mI4Wn-0005qI-9w; Mon, 23 Aug 2021 09:37:53 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net v2 2/2] net: usb: asix: do not call phy_disconnect() for ax88178
Date:   Mon, 23 Aug 2021 09:37:48 +0200
Message-Id: <20210823073748.22384-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823073748.22384-1-o.rempel@pengutronix.de>
References: <20210823073748.22384-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix crash on reboot on a system with ASIX AX88178 USB adapter attached
to it:
| asix 1-1.4:1.0 eth0: unregister 'asix' usb-ci_hdrc.0-1.4, ASIX AX88178 USB 2.0 Ethernet
| 8<--- cut here ---
| Unable to handle kernel NULL pointer dereference at virtual address 0000028c
| pgd = 5ec93aee
| [0000028c] *pgd=00000000
| Internal error: Oops: 5 [#1] PREEMPT SMP ARM
| Modules linked in:
| CPU: 1 PID: 1 Comm: systemd-shutdow Not tainted 5.14.0-rc1-20210811-1 #4
| Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
| PC is at phy_disconnect+0x8/0x48
| LR is at ax88772_unbind+0x14/0x20
| [<80650d04>] (phy_disconnect) from [<80741aa4>] (ax88772_unbind+0x14/0x20)
| [<80741aa4>] (ax88772_unbind) from [<8074e250>] (usbnet_disconnect+0x48/0xd8)
| [<8074e250>] (usbnet_disconnect) from [<807655e0>] (usb_unbind_interface+0x78/0x25c)
| [<807655e0>] (usb_unbind_interface) from [<805b03a0>] (__device_release_driver+0x154/0x20c)
| [<805b03a0>] (__device_release_driver) from [<805b0478>] (device_release_driver+0x20/0x2c)
| [<805b0478>] (device_release_driver) from [<805af944>] (bus_remove_device+0xcc/0xf8)
| [<805af944>] (bus_remove_device) from [<805ab26c>] (device_del+0x178/0x4b0)
| [<805ab26c>] (device_del) from [<807634a4>] (usb_disable_device+0xcc/0x178)
| [<807634a4>] (usb_disable_device) from [<8075a060>] (usb_disconnect+0xd8/0x238)
| [<8075a060>] (usb_disconnect) from [<8075a02c>] (usb_disconnect+0xa4/0x238)
| [<8075a02c>] (usb_disconnect) from [<8075a02c>] (usb_disconnect+0xa4/0x238)
| [<8075a02c>] (usb_disconnect) from [<80af3520>] (usb_remove_hcd+0xa0/0x198)
| [<80af3520>] (usb_remove_hcd) from [<807902e0>] (host_stop+0x38/0xa8)
| [<807902e0>] (host_stop) from [<8078d9e4>] (ci_hdrc_remove+0x3c/0x118)
| [<8078d9e4>] (ci_hdrc_remove) from [<805b27ec>] (platform_remove+0x20/0x50)
| [<805b27ec>] (platform_remove) from [<805b03a0>] (__device_release_driver+0x154/0x20c)
| [<805b03a0>] (__device_release_driver) from [<805b0478>] (device_release_driver+0x20/0x2c)
| [<805b0478>] (device_release_driver) from [<805af944>] (bus_remove_device+0xcc/0xf8)
| [<805af944>] (bus_remove_device) from [<805ab26c>] (device_del+0x178/0x4b0)

For this adapter we call ax88178_bind() and ax88772_unbind(), which is
related to different chip version and different counter part *bind()
function.

Since this chip is currently not ported to the PHYLIB, we do not need to
call phy_disconnect() here. So, to fix this crash, we need to add
ax88178_unbind().

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Reported-by: Robin van der Gracht <robin@protonic.nl>
Tested-by: Robin van der Gracht <robin@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_devices.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 15460d419e3f..f6f3955a3a0f 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -816,6 +816,12 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
+static void ax88178_unbind(struct usbnet *dev, struct usb_interface *intf)
+{
+	asix_rx_fixup_common_free(dev->driver_priv);
+	kfree(dev->driver_priv);
+}
+
 static const struct ethtool_ops ax88178_ethtool_ops = {
 	.get_drvinfo		= asix_get_drvinfo,
 	.get_link		= asix_get_link,
@@ -1224,7 +1230,7 @@ static const struct driver_info ax88772b_info = {
 static const struct driver_info ax88178_info = {
 	.description = "ASIX AX88178 USB 2.0 Ethernet",
 	.bind = ax88178_bind,
-	.unbind = ax88772_unbind,
+	.unbind = ax88178_unbind,
 	.status = asix_status,
 	.link_reset = ax88178_link_reset,
 	.reset = ax88178_reset,
-- 
2.30.2

