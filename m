Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF11128A75
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 17:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfLUQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 11:41:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbfLUQlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 11:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f1y3LdntkwceFsmX3+Zajq4BGTJ8eOqTDkuDdNh7nhw=; b=NgNbS6Zsb/0uFxM7Mj3NMiGiuR
        e69bafzWtI2bMzW9yBkZUqQXypTlTbl4MKuPb+z1zmpw95gP+YgummL5L04HgzHchhmlQMmBXz5Bb
        5RPxCGHD4UeXAP7nwlqt02wX4QgDP1fNaxY23lz6tdAMMzXmzCtMJonH2byLW2H/aNS0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iihoU-0004T3-3V; Sat, 21 Dec 2019 17:41:10 +0100
Date:   Sat, 21 Dec 2019 17:41:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20191221164110.GL30801@lunn.ch>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191218162919.5293-1-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

In your V1 patch, you had this diagram.

+/* Serial Management Interface (SMI) uses the following frame format:
+ *
+ *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
+ *               |frame| OP code  |address |address|  |                  |
+ * read | 32x1큦 | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
+ * write| 32x1큦 | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
+ *
+ */

I just compared this to plain MDIO:

+ *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
+ *               |frame| OP code  |address |address|  |                  |
+ * read | 32x1큦 | 01  |    10    | AAAA   | RRRRR |Z0| DDDDDDDDDDDDDDDD |  Z
+ * write| 32x1큦 | 01  |    01    | AAAA   | RRRRR |10| DDDDDDDDDDDDDDDD |  Z

So the only real issue here is the OP code? The rest you can do with a
layer on top of the standard API.

How about something like this. Totally untested, probably does not
even compile.....

     Andrew

From 6051479b218fd19942d702e3e051c6355fe2a11f Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Sat, 21 Dec 2019 10:31:19 -0600
Subject: [PATCH] net: phy: Add support for microchip SMI0 MDIO bus.

SMI0 is a mangled version of MDIO. The main low level difference is
the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
read/write information is instead encoded in the PHY address.

Extend the bit-bang code to allow the op code to be overridden, but
default to normal C22 values. Add an extra compatible to the mdio-gpio
driver, and when this compatible is present, set the op codes to 0.

A higher level driver, sitting on top of the basic MDIO bus driver can
then implement the rest of the microchip SMI0 odderties.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio-bitbang.c | 7 +++++--
 drivers/net/phy/mdio-gpio.c    | 7 +++++++
 include/linux/mdio-bitbang.h   | 2 ++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index 5136275c8e73..01f620889c78 100644
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
@@ -216,6 +216,9 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 	bus->write = mdiobb_write;
 	bus->priv = ctrl;
 
+	ctrl->op_c22_read = MDIO_READ;
+	ctrl->op_c22_write = MDIO_WRITE;
+
 	return bus;
 }
 EXPORT_SYMBOL(alloc_mdio_bitbang);
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 1b00235d7dc5..282bc38331d7 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -132,6 +132,12 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 		new_bus->phy_ignore_ta_mask = pdata->phy_ignore_ta_mask;
 	}
 
+	if (dev->of_node &&
+	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
+		bitbang->ctrl->op_c22_read = 0;
+		bitbang->ctrl->op_c22_write = 0;
+	}
+
 	dev_set_drvdata(dev, new_bus);
 
 	return new_bus;
@@ -196,6 +202,7 @@ static int mdio_gpio_remove(struct platform_device *pdev)
 
 static const struct of_device_id mdio_gpio_of_match[] = {
 	{ .compatible = "virtual,mdio-gpio", },
+	{ .compatible = "microchip,mdio-smi0" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mdio_gpio_of_match);
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index 5d71e8a8500f..8ae0b3835233 100644
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
2.24.0

