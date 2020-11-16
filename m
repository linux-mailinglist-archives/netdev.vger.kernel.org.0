Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39572B4267
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgKPLPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgKPLPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 06:15:22 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C05222E8;
        Mon, 16 Nov 2020 11:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605525321;
        bh=OXl/Y8KaA6zkrte6GUrI8Ylkg1mUc9hAEebRvDNulek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+vnGLFZzSzBwsZ1vSGcckies+JmJhkv1W15HCnfYp/zrWfWlJLgas/hayFK+xPpv
         Jobd49ONCKPndlvYvlmhqDmDYyJSJBksWWYxDm1AZ0pkX43OP1TMmqBIyVcCmBMHdm
         Jp/vDZS9KdrNAaZesTeWdpGJYSjFu4TmgtecxSiE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 1/5] net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
Date:   Mon, 16 Nov 2020 12:15:07 +0100
Message-Id: <20201116111511.5061-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201116111511.5061-1-kabel@kernel.org>
References: <20201116111511.5061-1-kabel@kernel.org>
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
Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
selected to 3 and the password must be filled with 0xff bytes for this
PHY communication to work.

This extends the mdio-i2c driver to support this protocol by adding a
special parameter to mdio_i2c_alloc function via which this RollBall
protocol can be selected.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/mdio/mdio-i2c.c   | 236 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/sfp.c         |   2 +-
 include/linux/mdio/mdio-i2c.h |   8 +-
 3 files changed, 239 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
index 09200a70b315..2e26bf1c81d1 100644
--- a/drivers/net/mdio/mdio-i2c.c
+++ b/drivers/net/mdio/mdio-i2c.c
@@ -3,6 +3,7 @@
  * MDIO I2C bridge
  *
  * Copyright (C) 2015-2016 Russell King
+ * Copyright (C) 2020 Marek Behun
  *
  * Network PHYs can appear on I2C buses when they are part of SFP module.
  * This driver exposes these PHYs to the networking PHY code, allowing
@@ -12,6 +13,7 @@
 #include <linux/i2c.h>
 #include <linux/mdio/mdio-i2c.h>
 #include <linux/phy.h>
+#include <linux/sfp.h>
 
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
@@ -28,7 +30,7 @@ static unsigned int i2c_mii_phy_addr(int phy_id)
 	return phy_id + 0x40;
 }
 
-static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
+static int i2c_mii_read_default(struct mii_bus *bus, int phy_id, int reg)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msgs[2];
@@ -62,7 +64,8 @@ static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
 	return data[0] << 8 | data[1];
 }
 
-static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
+static int i2c_mii_write_default(struct mii_bus *bus, int phy_id, int reg,
+				 u16 val)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msg;
@@ -91,9 +94,214 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	return ret < 0 ? ret : 0;
 }
 
-struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
+/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
+ * instead via address 0x51, when SFP page is set to 0x03 and password to
+ * 0xffffffff.
+ * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
+ * bus creation time, and expect it to remain set to 0x03 throughout the
+ * lifetime of the module plugged into the system. If the SFP code starts
+ * modifying SFP_PAGE in the future, this code will need to change.
+ *
+ * address  size  contents  description
+ * -------  ----  --------  -----------
+ * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
+ * 0x81     1     DEV       Clause 45 device
+ * 0x82     2     REG       Clause 45 register
+ * 0x84     2     VAL       Register value
+ */
+#define ROLLBALL_PHY_I2C_ADDR		0x51
+#define ROLLBALL_SFP_PASSWORD_ADDR	0x7b
+
+#define ROLLBALL_CMD_ADDR		0x80
+#define ROLLBALL_DATA_ADDR		0x81
+
+#define ROLLBALL_CMD_WRITE		0x01
+#define ROLLBALL_CMD_READ		0x02
+#define ROLLBALL_CMD_DONE		0x04
+
+static int i2c_rollball_mii_poll(struct mii_bus *bus, int bus_addr, u8 *buf,
+				 size_t len)
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
+	/* By experiment it takes up to 70 ms to access a register for these
+	 * SFPs. Sleep 20ms between iteratios and try 10 times.
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
+static int i2c_rollball_mii_cmd(struct mii_bus *bus, int bus_addr, u8 cmd,
+				u8 *data, size_t len)
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
+	bus_addr = i2c_mii_phy_addr(phy_id);
+	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
+		return 0xffff;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+
+	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_READ, buf,
+				   sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, bus_addr, res, sizeof(res));
+	if (ret == -ETIMEDOUT)
+		return 0xffff;
+	else if (ret < 0)
+		return ret;
+
+	val = res[4] << 8 | res[5];
+
+	dev_dbg(&bus->dev, "read reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f,
+		reg & 0xffff, val);
+
+	return val;
+}
+
+static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg,
+				  u16 val)
+{
+	int bus_addr, ret;
+	u8 buf[6];
+
+	if (!(reg & MII_ADDR_C45))
+		return -EOPNOTSUPP;
+
+	bus_addr = i2c_mii_phy_addr(phy_id);
+	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
+		return 0;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+	buf[4] = val >> 8;
+	buf[5] = val & 0xff;
+
+	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_WRITE, buf,
+				   sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, bus_addr, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(&bus->dev, "write reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f,
+		reg & 0xffff, val);
+
+	return 0;
+}
+
+static int i2c_mii_init_rollball(struct i2c_adapter *i2c)
+{
+	u8 page_buf[2], pw_buf[5];
+	struct i2c_msg msgs[2];
+	int ret;
+
+	page_buf[0] = SFP_PAGE;
+	page_buf[1] = 3;
+
+	msgs[0].addr = ROLLBALL_PHY_I2C_ADDR;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(page_buf);
+	msgs[0].buf = page_buf;
+
+	pw_buf[0] = ROLLBALL_SFP_PASSWORD_ADDR;
+	pw_buf[1] = 0xff;
+	pw_buf[2] = 0xff;
+	pw_buf[3] = 0xff;
+	pw_buf[4] = 0xff;
+
+	msgs[1].addr = ROLLBALL_PHY_I2C_ADDR;
+	msgs[1].flags = 0;
+	msgs[1].len = sizeof(pw_buf);
+	msgs[1].buf = pw_buf;
+
+	ret = i2c_transfer(i2c, msgs, ARRAY_SIZE(msgs));
+	if (ret < 0)
+		return ret;
+	else if (ret != ARRAY_SIZE(msgs))
+		return -EIO;
+
+	return 0;
+}
+
+struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
+			       enum mdio_i2c_proto protocol)
 {
 	struct mii_bus *mii;
+	int ret;
 
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return ERR_PTR(-EINVAL);
@@ -104,10 +312,28 @@ struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
 
 	snprintf(mii->id, MII_BUS_ID_SIZE, "i2c:%s", dev_name(parent));
 	mii->parent = parent;
-	mii->read = i2c_mii_read;
-	mii->write = i2c_mii_write;
 	mii->priv = i2c;
 
+	switch (protocol) {
+	case MDIO_I2C_ROLLBALL:
+		ret = i2c_mii_init_rollball(i2c);
+		if (ret < 0) {
+			dev_err(parent,
+				"Cannot initialize RollBall MDIO I2C protocol: %d\n",
+				ret);
+			mdiobus_free(mii);
+			return ERR_PTR(ret);
+		}
+
+		mii->read = i2c_mii_read_rollball;
+		mii->write = i2c_mii_write_rollball;
+		break;
+	default:
+		mii->read = i2c_mii_read_default;
+		mii->write = i2c_mii_write_default;
+		break;
+	}
+
 	return mii;
 }
 EXPORT_SYMBOL_GPL(mdio_i2c_alloc);
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 34aa196b7465..3a4f34e5365a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -409,7 +409,7 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	sfp->read = sfp_i2c_read;
 	sfp->write = sfp_i2c_write;
 
-	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c);
+	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c, MDIO_I2C_DEFAULT);
 	if (IS_ERR(i2c_mii))
 		return PTR_ERR(i2c_mii);
 
diff --git a/include/linux/mdio/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
index b1d27f7cd23f..53eedb0dc1d3 100644
--- a/include/linux/mdio/mdio-i2c.h
+++ b/include/linux/mdio/mdio-i2c.h
@@ -11,6 +11,12 @@ struct device;
 struct i2c_adapter;
 struct mii_bus;
 
-struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c);
+enum mdio_i2c_proto {
+	MDIO_I2C_DEFAULT,
+	MDIO_I2C_ROLLBALL,
+};
+
+struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
+			       enum mdio_i2c_proto protocol);
 
 #endif
-- 
2.26.2

