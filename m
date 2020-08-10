Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4832412CD
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 00:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgHJWGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 18:06:50 -0400
Received: from mail.nic.cz ([217.31.204.67]:42702 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgHJWGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 18:06:49 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 9E916140A40;
        Tue, 11 Aug 2020 00:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597097206; bh=6BOC1zCN1oMHIunKiOabSn4wsZ1pIM8I6+T4PsP57dA=;
        h=From:To:Date;
        b=fx+tx1ABg5pO7mxLBv1dnrkIsi6YUVATZbh+5EvrnlIN9UZ6qFR0g6R5ib4xxTnCg
         tp3nVjPcGdBkJ+kn5GpIbQMYDXArZiIbbFMTnLxENDGAqRc8eYOSuClHT+P3EJKSCl
         /taqiS9nuhSpI+X2thTp2IFxxf7Q3FISkQ0aAtQE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC russell-king 1/4] net: phy: add I2C mdio bus for RollBall compatible SFPs
Date:   Tue, 11 Aug 2020 00:06:42 +0200
Message-Id: <20200810220645.19326-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200810220645.19326-1-marek.behun@nic.cz>
References: <20200810220645.19326-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some multigig SFPs from RollBall and Hilink do not expose functional
MDIO access to the internal PHY of the SFP via I2C address 0x56
(although there seems to be read-only clause 22 access on this address).

Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
Digital Diagnostic Interface - I2C address 0x51.

This driver adds support for this as a MDIO bus.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Makefile            |   2 +-
 drivers/net/phy/mdio-i2c-rollball.c | 238 ++++++++++++++++++++++++++++
 drivers/net/phy/mdio-i2c.h          |   1 +
 drivers/net/phy/sfp.c               |   5 -
 include/linux/sfp.h                 |   5 +
 5 files changed, 245 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/phy/mdio-i2c-rollball.c

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 4500050faf64f..ce12d5bf02b1e 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_MDIO_BUS_MUX_MULTIPLEXER) += mdio-mux-multiplexer.o
 obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
 obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
 obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
-obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
+obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o mdio-i2c-rollball.o
 obj-$(CONFIG_MDIO_IPQ4019)	+= mdio-ipq4019.o
 obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
diff --git a/drivers/net/phy/mdio-i2c-rollball.c b/drivers/net/phy/mdio-i2c-rollball.c
new file mode 100644
index 0000000000000..8355d19fe4192
--- /dev/null
+++ b/drivers/net/phy/mdio-i2c-rollball.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0
+/* MDIO I2C bridge for RollBall compatible SFPs
+ *
+ * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
+ *
+ * RollBall compatible SFPs expose their internal PHY in a different way
+ * from the one handled by mdio-i2c.c. This driver exposes interface for
+ * this RollBall interface.
+ */
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/phy.h>
+#include <linux/sfp.h>
+
+#include "mdio-i2c.h"
+
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
+#define SFP_DIAG_I2C_ADDR		0x51
+
+#define ROLLBALL_SFP_PASSWORD_ADDR	0x7b
+
+#define ROLLBALL_SFP_MDIO_PAGE		0x03
+
+#define ROLLBALL_CMD_ADDR		0x80
+#define ROLLBALL_DATA_ADDR		0x81
+
+#define ROLLBALL_CMD_WRITE		0x01
+#define ROLLBALL_CMD_READ		0x02
+#define ROLLBALL_CMD_DONE		0x04
+
+static int i2c_rollball_mii_poll(struct mii_bus *bus, u8 *buf, size_t len)
+{
+	struct i2c_adapter *i2c = bus->priv;
+	struct i2c_msg msgs[2];
+	u8 buf0[2], *res;
+	int i, ret;
+
+	buf0[0] = ROLLBALL_CMD_ADDR;
+
+	msgs[0].addr = SFP_DIAG_I2C_ADDR;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = &buf0[0];
+
+	res = buf ? buf : &buf0[1];
+
+	msgs[1].addr = SFP_DIAG_I2C_ADDR;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = buf ? len : 1;
+	msgs[1].buf = res;
+
+	/* It takes up to 70 ms to access a register for these SFPs. */
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
+static int i2c_rollball_mii_cmd(struct mii_bus *bus, u8 cmd, u8 *data, size_t len)
+{
+	struct i2c_adapter *i2c = bus->priv;
+	struct i2c_msg msgs[2];
+	u8 cmdbuf[2];
+	int ret;
+
+	msgs[0].addr = SFP_DIAG_I2C_ADDR;
+	msgs[0].flags = 0;
+	msgs[0].len = len;
+	msgs[0].buf = data;
+
+	cmdbuf[0] = ROLLBALL_CMD_ADDR;
+	cmdbuf[1] = cmd;
+
+	msgs[1].addr = SFP_DIAG_I2C_ADDR;
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
+static int i2c_rollball_mii_read(struct mii_bus *bus, int phy_id, int reg)
+{
+	u8 buf[4], res[6];
+	u16 val;
+	int ret;
+
+	if (phy_id != SFP_PHY_ADDR)
+		return 0xffff;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EOPNOTSUPP;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+
+	ret = i2c_rollball_mii_cmd(bus, ROLLBALL_CMD_READ, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, res, sizeof(res));
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
+static int i2c_rollball_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
+{
+	u8 buf[6];
+	int ret;
+
+	if (phy_id != SFP_PHY_ADDR)
+		return 0;
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
+	ret = i2c_rollball_mii_cmd(bus, ROLLBALL_CMD_WRITE, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(&bus->dev, "write reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f, reg & 0xffff, val);
+
+	return 0;
+}
+
+static int i2c_rollball_init(struct i2c_adapter *i2c)
+{
+	struct i2c_msg msgs[2];
+	u8 page[2], password[5];
+	int ret;
+
+	page[0] = SFP_PAGE;
+	page[1] = ROLLBALL_SFP_MDIO_PAGE;
+
+	msgs[0].addr = SFP_DIAG_I2C_ADDR;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(page);
+	msgs[0].buf = page;
+
+	password[0] = ROLLBALL_SFP_PASSWORD_ADDR;
+	password[1] = 0xff;
+	password[2] = 0xff;
+	password[3] = 0xff;
+	password[4] = 0xff;
+
+	msgs[1].addr = SFP_DIAG_I2C_ADDR;
+	msgs[1].flags = 0;
+	msgs[1].len = sizeof(password);
+	msgs[1].buf = password;
+
+	ret = i2c_transfer(i2c, msgs, ARRAY_SIZE(msgs));
+	if (ret < 0)
+		return ret;
+
+	return ret == ARRAY_SIZE(msgs) ? 0 : -EIO;
+}
+
+struct mii_bus *mdio_i2c_rollball_alloc(struct device *parent, struct i2c_adapter *i2c)
+{
+	struct mii_bus *mii;
+	int ret;
+
+	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
+		return ERR_PTR(-EINVAL);
+
+	mii = mdiobus_alloc();
+	if (!mii)
+		return ERR_PTR(-ENOMEM);
+
+	ret = i2c_rollball_init(i2c);
+	if (ret < 0) {
+		dev_err(parent, "cannot initialize SFP for MDIO access\n");
+		return ERR_PTR(ret);
+	}
+
+	snprintf(mii->id, MII_BUS_ID_SIZE, "i2c-rollball:%s", dev_name(parent));
+	mii->parent = parent;
+	mii->read = i2c_rollball_mii_read;
+	mii->write = i2c_rollball_mii_write;
+	mii->priv = i2c;
+
+	return mii;
+}
+EXPORT_SYMBOL_GPL(mdio_i2c_rollball_alloc);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MDIO I2C bridge library for RollBall compatible SFPs");
+MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
diff --git a/drivers/net/phy/mdio-i2c.h b/drivers/net/phy/mdio-i2c.h
index b1d27f7cd23fb..d96fcfa9637e0 100644
--- a/drivers/net/phy/mdio-i2c.h
+++ b/drivers/net/phy/mdio-i2c.h
@@ -12,5 +12,6 @@ struct i2c_adapter;
 struct mii_bus;
 
 struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c);
+struct mii_bus *mdio_i2c_rollball_alloc(struct device *parent, struct i2c_adapter *i2c);
 
 #endif
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c24b0e83dd329..a62fa2e5ae4e6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -202,11 +202,6 @@ static const enum gpiod_flags gpio_flags[] = {
 #define T_PROBE_RETRY_SLOW	msecs_to_jiffies(5000)
 #define R_PROBE_RETRY_SLOW	12
 
-/* SFP modules appear to always have their PHY configured for bus address
- * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
- */
-#define SFP_PHY_ADDR	22
-
 struct sff_data {
 	unsigned int gpios;
 	bool (*module_supported)(const struct sfp_eeprom_id *id);
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 2da1a5181779e..035b665ca702e 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -3,6 +3,11 @@
 
 #include <linux/phy.h>
 
+/* SFP modules appear to always have their PHY configured for bus address
+ * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
+ */
+#define SFP_PHY_ADDR	22
+
 struct sfp_eeprom_base {
 	u8 phys_id;
 	u8 phys_ext_id;
-- 
2.26.2

