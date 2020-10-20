Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A43C293F3B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgJTPGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbgJTPGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:06:22 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E7732224B;
        Tue, 20 Oct 2020 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603206381;
        bh=cvzb1If9FYswWAqYO4wD3+3txvlUf04/ebS44G9EivU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDAk+5Ft7OTwmMMCiWuDNY1hdDMKjv3H8tEru1b7Z2Ie2I++4WZqTKFlVjg8/gfSX
         XQ5L66AgMf0iKT7knKW2fx/ssHjPTlaaD97AZS++4k7JHK5RrTH12Ru9tgRutGBZ4/
         Sho8S7b7qY2OXPFIqpM0W3lIucFU37dFFhNRXupE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue v2 1/3] net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
Date:   Tue, 20 Oct 2020 17:06:13 +0200
Message-Id: <20201020150615.11969-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020150615.11969-1-kabel@kernel.org>
References: <20201020150615.11969-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some multigig SFPs from RollBall and Hilink do not expose functional
MDIO access to the internal PHY of the SFP via I2C address 0x56
(although there seems to be read-only clause 22 access on this address).

Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
Digital Diagnostic Interface - I2C address 0x51.

This extends the mdio-i2c driver so that when SFP PHY address 17 is used
(which in mdio-i2c terms corresponds to I2C address 0x51), then this
different protocol is used for MDIO access.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/mdio-i2c.c | 196 +++++++++++++++++++++++++++++++++++--
 1 file changed, 186 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/phy/mdio-i2c.c
index 0746e2cc39ae..1468f50e35a9 100644
--- a/drivers/net/phy/mdio-i2c.c
+++ b/drivers/net/phy/mdio-i2c.c
@@ -3,6 +3,7 @@
  * MDIO I2C bridge
  *
  * Copyright (C) 2015-2016 Russell King
+ * Copyright (C) 2020 Marek Behun
  *
  * Network PHYs can appear on I2C buses when they are part of SFP module.
  * This driver exposes these PHYs to the networking PHY code, allowing
@@ -17,11 +18,17 @@
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
  * specified to be present in SFP modules.  These correspond with PHY
- * addresses 16 and 17.  Disallow access to these "phy" addresses.
+ * addresses 16 and 17.  Disallow access to 0x50 "phy" address.
+ * Use RollBall protocol when accessing via the 0x51 address.
  */
 static bool i2c_mii_valid_phy_id(int phy_id)
 {
-	return phy_id != 0x10 && phy_id != 0x11;
+	return phy_id != 0x10;
+}
+
+static bool i2c_mii_rollball_phy_id(int phy_id)
+{
+	return phy_id == 0x11;
 }
 
 static unsigned int i2c_mii_phy_addr(int phy_id)
@@ -29,16 +36,13 @@ static unsigned int i2c_mii_phy_addr(int phy_id)
 	return phy_id + 0x40;
 }
 
-static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
+static int i2c_mii_read_default(struct mii_bus *bus, int phy_id, int reg)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msgs[2];
 	u8 addr[3], data[2], *p;
 	int bus_addr, ret;
 
-	if (!i2c_mii_valid_phy_id(phy_id))
-		return 0xffff;
-
 	p = addr;
 	if (reg & MII_ADDR_C45) {
 		*p++ = 0x20 | ((reg >> 16) & 31);
@@ -63,16 +67,13 @@ static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
 	return data[0] << 8 | data[1];
 }
 
-static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
+static int i2c_mii_write_default(struct mii_bus *bus, int phy_id, int reg, u16 val)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msg;
 	int ret;
 	u8 data[5], *p;
 
-	if (!i2c_mii_valid_phy_id(phy_id))
-		return 0;
-
 	p = data;
 	if (reg & MII_ADDR_C45) {
 		*p++ = (reg >> 16) & 31;
@@ -92,6 +93,181 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	return ret < 0 ? ret : 0;
 }
 
+/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
+ * instead via address 0x51, when SFP page is set to 0x03 and password to
+ * 0xffffffff:
+ *
+ * address  size  contents  description
+ * -------  ----  --------  -----------
+ * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
+ * 0x81     1     DEV       Clause 45 device
+ * 0x82     2     REG       Clause 45 register
+ * 0x84     2     VAL       Register value
+ */
+#define ROLLBALL_CMD_ADDR		0x80
+#define ROLLBALL_DATA_ADDR		0x81
+
+#define ROLLBALL_CMD_WRITE		0x01
+#define ROLLBALL_CMD_READ		0x02
+#define ROLLBALL_CMD_DONE		0x04
+
+static int i2c_rollball_mii_poll(struct mii_bus *bus, int bus_addr, u8 *buf, size_t len)
+{
+	struct i2c_adapter *i2c = bus->priv;
+	struct i2c_msg msgs[2];
+	u8 buf0[2], *res;
+	int i, ret;
+
+	buf0[0] = ROLLBALL_CMD_ADDR;
+
+	msgs[0].addr = bus_addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = &buf0[0];
+
+	res = buf ? buf : &buf0[1];
+
+	msgs[1].addr = bus_addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = buf ? len : 1;
+	msgs[1].buf = res;
+
+	/* By experiment it takes up to 70 ms to access a register for these SFPs. Sleep 20ms
+	 * between iteratios and try 10 times.
+	 */
+	i = 10;
+	do {
+		msleep(20);
+
+		ret = i2c_transfer(i2c, msgs, ARRAY_SIZE(msgs));
+		if (ret < 0)
+			return ret;
+		else if (ret != ARRAY_SIZE(msgs))
+			return -EIO;
+
+		if (*res == ROLLBALL_CMD_DONE)
+			return 0;
+	} while (i-- > 0);
+
+	dev_dbg(&bus->dev, "poll timed out\n");
+
+	return -ETIMEDOUT;
+}
+
+static int i2c_rollball_mii_cmd(struct mii_bus *bus, int bus_addr, u8 cmd, u8 *data, size_t len)
+{
+	struct i2c_adapter *i2c = bus->priv;
+	struct i2c_msg msgs[2];
+	u8 cmdbuf[2];
+	int ret;
+
+	msgs[0].addr = bus_addr;
+	msgs[0].flags = 0;
+	msgs[0].len = len;
+	msgs[0].buf = data;
+
+	cmdbuf[0] = ROLLBALL_CMD_ADDR;
+	cmdbuf[1] = cmd;
+
+	msgs[1].addr = bus_addr;
+	msgs[1].flags = 0;
+	msgs[1].len = sizeof(cmdbuf);
+	msgs[1].buf = cmdbuf;
+
+	ret = i2c_transfer(i2c, msgs, 2);
+	if (ret < 0)
+		return ret;
+
+	return ret == ARRAY_SIZE(msgs) ? 0 : -EIO;
+}
+
+static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
+{
+	u8 buf[4], res[6];
+	int bus_addr, ret;
+	u16 val;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EOPNOTSUPP;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+
+	bus_addr = i2c_mii_phy_addr(phy_id);
+
+	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_READ, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, bus_addr, res, sizeof(res));
+	if (ret == -ETIMEDOUT)
+		return 0xffff;
+	else if (ret < 0)
+		return ret;
+
+	val = res[4];
+	val <<= 8;
+	val |= res[5];
+
+	dev_dbg(&bus->dev, "read reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f, reg & 0xffff, val);
+
+	return val;
+}
+
+static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg, u16 val)
+{
+	int bus_addr, ret;
+	u8 buf[6];
+
+	if (!(reg & MII_ADDR_C45))
+		return -EOPNOTSUPP;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+	buf[4] = val >> 8;
+	buf[5] = val & 0xff;
+
+	bus_addr = i2c_mii_phy_addr(phy_id);
+
+	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_WRITE, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, bus_addr, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(&bus->dev, "write reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f, reg & 0xffff, val);
+
+	return 0;
+}
+
+static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
+{
+	if (!i2c_mii_valid_phy_id(phy_id))
+		return 0xffff;
+
+	if (i2c_mii_rollball_phy_id(phy_id))
+		return i2c_mii_read_rollball(bus, phy_id, reg);
+	else
+		return i2c_mii_read_default(bus, phy_id, reg);
+}
+
+static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
+{
+	if (!i2c_mii_valid_phy_id(phy_id))
+		return 0;
+
+	if (i2c_mii_rollball_phy_id(phy_id))
+		return i2c_mii_write_rollball(bus, phy_id, reg, val);
+	else
+		return i2c_mii_write_default(bus, phy_id, reg, val);
+}
+
 struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
 {
 	struct mii_bus *mii;
-- 
2.26.2

