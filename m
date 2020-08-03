Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A9239F39
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgHCFpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgHCFpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A780C0617A2
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005J3-F7; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THK-0005Tw-T1; Mon, 03 Aug 2020 07:44:54 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 01/11] net: phy: Add support for microchip SMI0 MDIO bus
Date:   Mon,  3 Aug 2020 07:44:32 +0200
Message-Id: <20200803054442.20089-2-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
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
v1 -> v2: - patch not present
v2 -> v3: - first patch
v3 -> v4: - added override_c22_op

 drivers/net/phy/mdio-bitbang.c | 8 ++++++--
 drivers/net/phy/mdio-gpio.c    | 9 +++++++++
 include/linux/mdio-bitbang.h   | 3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index 5136275c8e7399f..528e255d1ffe77f 100644
--- a/drivers/net/phy/mdio-bitbang.c
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -158,7 +158,7 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
 	} else
-		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
+		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
 
 	ctrl->ops->set_mdio_dir(ctrl, 0);
 
@@ -189,7 +189,7 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
 	} else
-		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
+		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
 
 	/* send the turnaround (10) */
 	mdiobb_send_bit(ctrl, 1);
@@ -215,6 +215,10 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 	bus->read = mdiobb_read;
 	bus->write = mdiobb_write;
 	bus->priv = ctrl;
+	if (!ctrl->override_op_c22) {
+		ctrl->op_c22_read = MDIO_READ;
+		ctrl->op_c22_write = MDIO_WRITE;
+	}
 
 	return bus;
 }
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 1b00235d7dc5b56..e8d83cee1bc17e1 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -132,6 +132,14 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 		new_bus->phy_ignore_ta_mask = pdata->phy_ignore_ta_mask;
 	}
 
+	if (dev->of_node &&
+	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
+		bitbang->ctrl.op_c22_read = 0;
+		bitbang->ctrl.op_c22_write = 0;
+	} else {
+		bitbang->ctrl.override_op_c22 = 1;
+	}
+
 	dev_set_drvdata(dev, new_bus);
 
 	return new_bus;
@@ -196,6 +204,7 @@ static int mdio_gpio_remove(struct platform_device *pdev)
 
 static const struct of_device_id mdio_gpio_of_match[] = {
 	{ .compatible = "virtual,mdio-gpio", },
+	{ .compatible = "microchip,mdio-smi0" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mdio_gpio_of_match);
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index 5d71e8a8500f5ed..5016e6f60de38af 100644
--- a/include/linux/mdio-bitbang.h
+++ b/include/linux/mdio-bitbang.h
@@ -33,6 +33,9 @@ struct mdiobb_ops {
 
 struct mdiobb_ctrl {
 	const struct mdiobb_ops *ops;
+	unsigned int override_op_c22;
+	u8 op_c22_read;
+	u8 op_c22_write;
 };
 
 /* The returned bus is not yet registered with the phy layer. */
-- 
2.28.0

