Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC81CB3BF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEHPnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEHPny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:43:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9387BC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:43:54 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jX5AH-0004qn-3i; Fri, 08 May 2020 17:43:53 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jX5AB-0003X5-7A; Fri, 08 May 2020 17:43:47 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v3 1/5] net: phy: Add support for microchip SMI0 MDIO bus
Date:   Fri,  8 May 2020 17:43:39 +0200
Message-Id: <20200508154343.6074-2-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

SMI0 is a mangled version of MDIO. The main low level difference is
the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
read/write information is instead encoded in the PHY address.

Extend the bit-bang code to allow the op code to be overridden, but
default to normal C22 values. Add an extra compatible to the mdio-gpio
driver, and when this compatible is present, set the op codes to 0.

A higher level driver, sitting on top of the basic MDIO bus driver can
then implement the rest of the microchip SMI0 odderties.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/phy/mdio-bitbang.c |  7 ++-----
 drivers/net/phy/mdio-gpio.c    | 13 +++++++++++++
 include/linux/mdio-bitbang.h   |  2 ++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index 5136275c8e7399..11255460ecb933 100644
--- a/drivers/net/phy/mdio-bitbang.c
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -19,9 +19,6 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 
-#define MDIO_READ 2
-#define MDIO_WRITE 1
-
 #define MDIO_C45 (1<<15)
 #define MDIO_C45_ADDR (MDIO_C45 | 0)
 #define MDIO_C45_READ (MDIO_C45 | 3)
@@ -158,7 +155,7 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
 	} else
-		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
+		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
 
 	ctrl->ops->set_mdio_dir(ctrl, 0);
 
@@ -189,7 +186,7 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
 	} else
-		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
+		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
 
 	/* send the turnaround (10) */
 	mdiobb_send_bit(ctrl, 1);
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 1b00235d7dc5b5..d85bc1a98647e2 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -27,6 +27,9 @@
 #include <linux/gpio/consumer.h>
 #include <linux/of_mdio.h>
 
+#define MDIO_READ 2
+#define MDIO_WRITE 1
+
 struct mdio_gpio_info {
 	struct mdiobb_ctrl ctrl;
 	struct gpio_desc *mdc, *mdio, *mdo;
@@ -132,6 +135,15 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 		new_bus->phy_ignore_ta_mask = pdata->phy_ignore_ta_mask;
 	}
 
+	if (dev->of_node &&
+	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
+		bitbang->ctrl.op_c22_read = 0;
+		bitbang->ctrl.op_c22_write = 0;
+	} else {
+		bitbang->ctrl.op_c22_read = MDIO_READ;
+		bitbang->ctrl.op_c22_write = MDIO_WRITE;
+	}
+
 	dev_set_drvdata(dev, new_bus);
 
 	return new_bus;
@@ -196,6 +208,7 @@ static int mdio_gpio_remove(struct platform_device *pdev)
 
 static const struct of_device_id mdio_gpio_of_match[] = {
 	{ .compatible = "virtual,mdio-gpio", },
+	{ .compatible = "microchip,mdio-smi0" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mdio_gpio_of_match);
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index 5d71e8a8500f5e..8ae0b383523371 100644
--- a/include/linux/mdio-bitbang.h
+++ b/include/linux/mdio-bitbang.h
@@ -33,6 +33,8 @@ struct mdiobb_ops {
 
 struct mdiobb_ctrl {
 	const struct mdiobb_ops *ops;
+	u8 op_c22_read;
+	u8 op_c22_write;
 };
 
 /* The returned bus is not yet registered with the phy layer. */
-- 
2.26.2

