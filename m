Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D86F11A95B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbfLKK4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:56:38 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39544 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKK4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:56:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tbt38Yjv9nrnpwWlfJGDH+Xw+PXUg+yTQcRNtTg8v7c=; b=jtfYtqqO/iNhCh66xvpwm5QLy9
        f9PHQewtz4FEEfGzk93jyKQKPqqxHX+EF6X2fwgwzy9l0F7rY4NbpuOSreqfOaWyF9LUxDNyn71TF
        7YIsJfFhjpo6sbTQejtNHbISHLFyoaE+KXqT9z5QztEfG2Kkdc9j263q8KX7RLpdfIJbGBh6KPJ8G
        4J1UkddskbVb9nucknjBO84upLO/HvpN5qIp5XdUvNq5IflIWMg/5DL8yK9W46/EwgonSOe22WK3i
        Lo3Lq37h+iMeaRoXDdBncvm9X85WVbqRzOb46jg/L2Om1RIEbBnI5EXW/36qijLXabgVFAfbOIjOh
        AdiOKQwg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:44550 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfK-0007uv-L7; Wed, 11 Dec 2019 10:56:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfI-0002yD-2U; Wed, 11 Dec 2019 10:56:20 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 06/14] net: mdio-i2c: add support for Clause 45
 accesses
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfI-0002yD-2U@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:20 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFP+ modules have PHYs on them just like SFP modules do, except
they are Clause 45 PHYs.  The I2C protocol used to access them is
modified slightly in order to send the device address and 16-bit
register index.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio-i2c.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/phy/mdio-i2c.c
index 0dce67672548..0746e2cc39ae 100644
--- a/drivers/net/phy/mdio-i2c.c
+++ b/drivers/net/phy/mdio-i2c.c
@@ -33,17 +33,24 @@ static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msgs[2];
-	u8 data[2], dev_addr = reg;
+	u8 addr[3], data[2], *p;
 	int bus_addr, ret;
 
 	if (!i2c_mii_valid_phy_id(phy_id))
 		return 0xffff;
 
+	p = addr;
+	if (reg & MII_ADDR_C45) {
+		*p++ = 0x20 | ((reg >> 16) & 31);
+		*p++ = reg >> 8;
+	}
+	*p++ = reg;
+
 	bus_addr = i2c_mii_phy_addr(phy_id);
 	msgs[0].addr = bus_addr;
 	msgs[0].flags = 0;
-	msgs[0].len = 1;
-	msgs[0].buf = &dev_addr;
+	msgs[0].len = p - addr;
+	msgs[0].buf = addr;
 	msgs[1].addr = bus_addr;
 	msgs[1].flags = I2C_M_RD;
 	msgs[1].len = sizeof(data);
@@ -61,18 +68,23 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msg;
 	int ret;
-	u8 data[3];
+	u8 data[5], *p;
 
 	if (!i2c_mii_valid_phy_id(phy_id))
 		return 0;
 
-	data[0] = reg;
-	data[1] = val >> 8;
-	data[2] = val;
+	p = data;
+	if (reg & MII_ADDR_C45) {
+		*p++ = (reg >> 16) & 31;
+		*p++ = reg >> 8;
+	}
+	*p++ = reg;
+	*p++ = val >> 8;
+	*p++ = val;
 
 	msg.addr = i2c_mii_phy_addr(phy_id);
 	msg.flags = 0;
-	msg.len = 3;
+	msg.len = p - data;
 	msg.buf = data;
 
 	ret = i2c_transfer(i2c, &msg, 1);
-- 
2.20.1

