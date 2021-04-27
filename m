Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F536BFD6
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhD0HKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhD0HKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:10:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08414C06138C
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:09:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqK-00011z-9M; Tue, 27 Apr 2021 09:09:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqI-0003mv-I9; Tue, 27 Apr 2021 09:09:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v8 7/9] net: phy: Add support for microchip SMI0 MDIO bus
Date:   Tue, 27 Apr 2021 09:09:07 +0200
Message-Id: <20210427070909.14434-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427070909.14434-1-o.rempel@pengutronix.de>
References: <20210427070909.14434-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
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
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---
v1 -> v2: - patch not present
v2 -> v3: - first patch
v3 -> v4: - added override_c22_op
v4 -> v5: - moved override_c22_op out of else case
---
 drivers/net/mdio/mdio-bitbang.c | 8 ++++++--
 drivers/net/mdio/mdio-gpio.c    | 8 ++++++++
 include/linux/mdio-bitbang.h    | 3 +++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
index 0f457c436335..07609114a26b 100644
--- a/drivers/net/mdio/mdio-bitbang.c
+++ b/drivers/net/mdio/mdio-bitbang.c
@@ -158,7 +158,7 @@ int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
 	} else
-		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
+		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
 
 	ctrl->ops->set_mdio_dir(ctrl, 0);
 
@@ -190,7 +190,7 @@ int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
 	} else
-		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
+		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
 
 	/* send the turnaround (10) */
 	mdiobb_send_bit(ctrl, 1);
@@ -217,6 +217,10 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 	bus->read = mdiobb_read;
 	bus->write = mdiobb_write;
 	bus->priv = ctrl;
+	if (!ctrl->override_op_c22) {
+		ctrl->op_c22_read = MDIO_READ;
+		ctrl->op_c22_write = MDIO_WRITE;
+	}
 
 	return bus;
 }
diff --git a/drivers/net/mdio/mdio-gpio.c b/drivers/net/mdio/mdio-gpio.c
index 56c8f914f893..0fb3c2de0845 100644
--- a/drivers/net/mdio/mdio-gpio.c
+++ b/drivers/net/mdio/mdio-gpio.c
@@ -132,6 +132,13 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 		new_bus->phy_ignore_ta_mask = pdata->phy_ignore_ta_mask;
 	}
 
+	if (dev->of_node &&
+	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
+		bitbang->ctrl.op_c22_read = 0;
+		bitbang->ctrl.op_c22_write = 0;
+		bitbang->ctrl.override_op_c22 = 1;
+	}
+
 	dev_set_drvdata(dev, new_bus);
 
 	return new_bus;
@@ -196,6 +203,7 @@ static int mdio_gpio_remove(struct platform_device *pdev)
 
 static const struct of_device_id mdio_gpio_of_match[] = {
 	{ .compatible = "virtual,mdio-gpio", },
+	{ .compatible = "microchip,mdio-smi0" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mdio_gpio_of_match);
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index aca4dc037b70..373630fe5c28 100644
--- a/include/linux/mdio-bitbang.h
+++ b/include/linux/mdio-bitbang.h
@@ -33,6 +33,9 @@ struct mdiobb_ops {
 
 struct mdiobb_ctrl {
 	const struct mdiobb_ops *ops;
+	unsigned int override_op_c22;
+	u8 op_c22_read;
+	u8 op_c22_write;
 };
 
 int mdiobb_read(struct mii_bus *bus, int phy, int reg);
-- 
2.29.2

