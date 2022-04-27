Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DAE5110E9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbiD0GNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiD0GNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:13:04 -0400
X-Greylist: delayed 496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 23:09:54 PDT
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [176.9.242.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164AF67D2B;
        Tue, 26 Apr 2022 23:09:53 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 5CF4E101952EA;
        Wed, 27 Apr 2022 08:09:51 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 17DCA61ABA99;
        Wed, 27 Apr 2022 08:09:51 +0200 (CEST)
X-Mailbox-Line: From 276a1b50cf9fcca5168ca2770a863cb56069a277 Mon Sep 17 00:00:00 2001
Message-Id: <276a1b50cf9fcca5168ca2770a863cb56069a277.1651037513.git.lukas@wunner.de>
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 07:48:05 +0200
Subject: [PATCH net-next 5/7] usbnet: smsc95xx: Forward PHY interrupts to PHY
 driver to avoid polling
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link status of SMSC LAN95xx chips is polled once per second, even though
they're capable of signaling PHY interrupts through the MAC layer.

Forward those interrupts to the PHY driver to avoid polling.  Benefits
are reduced bus traffic, reduced CPU overhead and quicker interface
bringup.

Polling was introduced in 2016 by commit d69d16949346 ("usbnet:
smsc95xx: fix link detection for disabled autonegotiation").
Back then, the LAN95xx driver neglected to enable the ENERGYON interrupt,
hence couldn't detect link-up events when auto-negotiation was disabled.
The proper solution would have been to enable the ENERGYON interrupt
instead of polling.

Since then, PHY handling was moved from the LAN95xx driver to the SMSC
PHY driver with commit 05b35e7eb9a1 ("smsc95xx: add phylib support").
That PHY driver is capable of link detection with auto-negotiation
disabled because it enables the ENERGYON interrupt.

Note that signaling interrupts through the MAC layer not only works with
the integrated PHY, but also with an external PHY, provided its
interrupt pin is attached to LAN95xx's nPHY_INT pin.

In the unlikely event that the interrupt pin of an external PHY is
attached to a GPIO of the SoC (or not connected at all), the driver can
be amended to retrieve the irq from the PHY's of_node.

To forward PHY interrupts to phylib, it is not sufficient to call
phy_mac_interrupt().  Instead, the PHY's interrupt handler needs to run
so that PHY interrupts are cleared.  That's because according to page
119 of the LAN950x datasheet, "The source of this interrupt is a level.
The interrupt persists until it is cleared in the PHY."

https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf

Therefore, create an IRQ domain with a single IRQ for the PHY.  In the
future, the IRQ domain may be extended to support the 11 GPIOs on the
LAN95xx.

Normally the PHY interrupt should be masked until the PHY driver has
cleared it.  However masking requires a (sleeping) USB transaction and
interrupts are received in (non-sleepable) softirq context.  I decided
not to mask the interrupt at all (by using the dummy_irq_chip's noop
->irq_mask() callback):  The USB interrupt endpoint is polled in 1 msec
intervals and normally that's sufficient to wake the PHY driver's IRQ
thread and have it clear the interrupt.  If it does take longer, worst
thing that can happen is the IRQ thread is woken again.  No big deal.

Because PHY interrupts are now perpetually enabled, there's no need to
selectively enable them on suspend.  So remove all invocations of
smsc95xx_enable_phy_wakeup_interrupts().

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 118 +++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 52 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 36abfaeae3c6..1d376bad13e5 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -18,6 +18,8 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/of_net.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <net/selftests.h>
@@ -53,6 +55,9 @@
 #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
 					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
 
+#define SMSC95XX_NR_IRQS		(1) /* raise to 12 for GPIOs */
+#define PHY_HWIRQ 			(SMSC95XX_NR_IRQS - 1)
+
 struct smsc95xx_priv {
 	u32 mac_cr;
 	u32 hash_hi;
@@ -61,6 +66,9 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
+	struct irq_chip irqchip;
+	struct irq_domain *irqdomain;
+	struct fwnode_handle *irqfwnode;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
 };
@@ -595,6 +603,8 @@ static void smsc95xx_mac_update_fullduplex(struct usbnet *dev)
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
+	unsigned long flags;
 	u32 intdata;
 
 	if (urb->actual_length != 4) {
@@ -606,11 +616,20 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 	intdata = get_unaligned_le32(urb->transfer_buffer);
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
+	/* USB interrupts are received in softirq (tasklet) context.
+	 * Switch to hardirq context to make genirq code happy.
+	 */
+	local_irq_save(flags);
+	__irq_enter_raw();
+
 	if (intdata & INT_ENP_PHY_INT_)
-		;
+		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
+
+	__irq_exit_raw();
+	local_irq_restore(flags);
 }
 
 /* Enable or disable Tx & Rx checksum offload engines */
@@ -1078,8 +1097,9 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
 	bool is_internal_phy;
+	char usb_path[64];
+	int ret, phy_irq;
 	u32 val;
-	int ret;
 
 	printk(KERN_INFO SMSC_CHIPNAME " v" SMSC_DRIVER_VERSION "\n");
 
@@ -1119,10 +1139,38 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		goto free_pdata;
 
+	/* create irq domain for use by PHY driver and GPIO consumers */
+	usb_make_path(dev->udev, usb_path, sizeof(usb_path));
+	pdata->irqfwnode = irq_domain_alloc_named_fwnode(usb_path);
+	if (!pdata->irqfwnode) {
+		ret = -ENOMEM;
+		goto free_pdata;
+	}
+
+	pdata->irqdomain = irq_domain_create_linear(pdata->irqfwnode,
+						    SMSC95XX_NR_IRQS,
+						    &irq_domain_simple_ops,
+						    pdata);
+	if (!pdata->irqdomain) {
+		ret = -ENOMEM;
+		goto free_irqfwnode;
+	}
+
+	phy_irq = irq_create_mapping(pdata->irqdomain, PHY_HWIRQ);
+	if (!phy_irq) {
+		ret = -ENOENT;
+		goto remove_irqdomain;
+	}
+
+	pdata->irqchip = dummy_irq_chip;
+	pdata->irqchip.name = SMSC_CHIPNAME;
+	irq_set_chip_and_handler_name(phy_irq, &pdata->irqchip,
+				      handle_simple_irq, "phy");
+
 	pdata->mdiobus = mdiobus_alloc();
 	if (!pdata->mdiobus) {
 		ret = -ENOMEM;
-		goto free_pdata;
+		goto dispose_irq;
 	}
 
 	ret = smsc95xx_read_reg(dev, HW_CFG, &val);
@@ -1155,6 +1203,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto unregister_mdio;
 	}
 
+	pdata->phydev->irq = phy_irq;
 	pdata->phydev->is_internal = is_internal_phy;
 
 	/* detect device revision as different features may be available */
@@ -1197,6 +1246,15 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 free_mdio:
 	mdiobus_free(pdata->mdiobus);
 
+dispose_irq:
+	irq_dispose_mapping(phy_irq);
+
+remove_irqdomain:
+	irq_domain_remove(pdata->irqdomain);
+
+free_irqfwnode:
+	irq_domain_free_fwnode(pdata->irqfwnode);
+
 free_pdata:
 	kfree(pdata);
 	return ret;
@@ -1209,6 +1267,9 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phy_disconnect(dev->net->phydev);
 	mdiobus_unregister(pdata->mdiobus);
 	mdiobus_free(pdata->mdiobus);
+	irq_dispose_mapping(irq_find_mapping(pdata->irqdomain, PHY_HWIRQ));
+	irq_domain_remove(pdata->irqdomain);
+	irq_domain_free_fwnode(pdata->irqfwnode);
 	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 	kfree(pdata);
 }
@@ -1233,29 +1294,6 @@ static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 	return crc << ((filter % 2) * 16);
 }
 
-static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16 mask)
-{
-	int ret;
-
-	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
-
-	/* read to clear */
-	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
-	if (ret < 0)
-		return ret;
-
-	/* enable interrupt source */
-	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
-	if (ret < 0)
-		return ret;
-
-	ret |= mask;
-
-	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
-
-	return 0;
-}
-
 static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 {
 	int ret;
@@ -1422,7 +1460,6 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	int ret;
 
 	if (!netif_running(dev->net)) {
 		/* interface is ifconfig down so fully power down hw */
@@ -1441,27 +1478,10 @@ static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 		}
 
 		netdev_dbg(dev->net, "autosuspend entering SUSPEND1\n");
-
-		/* enable PHY wakeup events for if cable is attached */
-		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
-			PHY_INT_MASK_ANEG_COMP_);
-		if (ret < 0) {
-			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
-			return ret;
-		}
-
 		netdev_info(dev->net, "entering SUSPEND1 mode\n");
 		return smsc95xx_enter_suspend1(dev);
 	}
 
-	/* enable PHY wakeup events so we remote wakeup if cable is pulled */
-	ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
-		PHY_INT_MASK_LINK_DOWN_);
-	if (ret < 0) {
-		netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
-		return ret;
-	}
-
 	netdev_dbg(dev->net, "autosuspend entering SUSPEND3\n");
 	return smsc95xx_enter_suspend3(dev);
 }
@@ -1527,13 +1547,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	}
 
 	if (pdata->wolopts & WAKE_PHY) {
-		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
-			(PHY_INT_MASK_ANEG_COMP_ | PHY_INT_MASK_LINK_DOWN_));
-		if (ret < 0) {
-			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
-			goto done;
-		}
-
 		/* if link is down then configure EDPD and enter SUSPEND1,
 		 * otherwise enter SUSPEND0 below
 		 */
@@ -1767,11 +1780,12 @@ static int smsc95xx_resume(struct usb_interface *intf)
 			return ret;
 	}
 
+	phy_init_hw(pdata->phydev);
+
 	ret = usbnet_resume(intf);
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
-	phy_init_hw(pdata->phydev);
 	return ret;
 }
 
-- 
2.35.2

