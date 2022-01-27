Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5710C49DFCE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbiA0KtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiA0KtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:49:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7B6C061753
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:49:17 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kz-0007ko-3G; Thu, 27 Jan 2022 11:49:09 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kx-003lzO-RJ; Thu, 27 Jan 2022 11:49:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v1 4/4] usbnet: add support for label from device tree
Date:   Thu, 27 Jan 2022 11:49:05 +0100
Message-Id: <20220127104905.899341-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127104905.899341-1-o.rempel@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the option to set a netdev name in device tree for switch
ports by using the property "label" in the DSA framework, this patch
adds this functionality to the usbnet infrastructure.

This will help to name the interfaces properly throughout supported
devices. This provides stable interface names which are useful
especially in embedded use cases.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/usbnet.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 9a6450f796dc..3fdca0cfda88 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
 
 /*-------------------------------------------------------------------------*/
 
@@ -1762,6 +1763,20 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		if ((dev->driver_info->flags & FLAG_WWAN) != 0)
 			strscpy(net->name, "wwan%d", sizeof(net->name));
 
+		if (IS_ENABLED(CONFIG_OF)) {
+			const char *label = NULL;
+
+			/* try reading label from device tree node */
+			if (xdev->dev.of_node)
+				label = of_get_property(xdev->dev.of_node,
+							"label", NULL);
+			if (label) {
+				strscpy(net->name, label, sizeof(net->name));
+				dev_info(&udev->dev, "netdev name from dt: %s\n",
+					 net->name);
+			}
+		}
+
 		/* devices that cannot do ARP */
 		if ((dev->driver_info->flags & FLAG_NOARP) != 0)
 			net->flags |= IFF_NOARP;
-- 
2.30.2

