Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EC61B1459
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgDTSVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgDTSVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:21:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868C1C061A0F;
        Mon, 20 Apr 2020 11:21:28 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4D22523EE0;
        Mon, 20 Apr 2020 20:21:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587406886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWxU9H6Xeyv9XL1rP0yhtzvrlQ47nz4CyePECYGDfe0=;
        b=g6mAxOcdZAw1ZezYUohgXdZGOETXbVYPwrlYav3W+u4t7O3qRt8Jw/1kurweZLHL9CW7Le
        gx5r84bBPFvWskzNLVGZrUBBVPqZNVCbL/GBTYb3Vob1LlxYlq1eKksFsJCiXMBJxEv7rd
        86WtBRqRfmV03oALwcIreozjr5N+9cE=
From:   Michael Walle <michael@walle.cc>
To:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 2/3] net: phy: add Broadcom BCM54140 support
Date:   Mon, 20 Apr 2020 20:21:12 +0200
Message-Id: <20200420182113.22577-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200420182113.22577-1-michael@walle.cc>
References: <20200420182113.22577-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 4D22523EE0
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.842];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[11];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[suse.com,roeck-us.net,lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom BCM54140 is a Quad SGMII/QSGMII Copper/Fiber Gigabit
Ethernet transceiver.

This also adds support for tunables to set and get downshift and
energy detect auto power-down.

The PHY has four ports and each port has its own PHY address.
There are per-port registers as well as global registers.
Unfortunately, the global registers can only be accessed by reading
and writing from/to the PHY address of the first port. Further,
there is no way to find out what port you actually are by just
reading the per-port registers. We therefore, have to scan the
bus on the PHY probe to determine the port and thus what address
we need to access the global registers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v2:
 - consistent naming eg. bcm54140_phy_xx -> bcm54140_xx
 - add comment about the errata
 - corrected comment about the LED mode
 - convert dev_info() to phydev_dbg()

changes since v1:
 none

 drivers/net/phy/Kconfig    |  10 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/bcm54140.c | 481 +++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h    |   1 +
 4 files changed, 493 insertions(+)
 create mode 100644 drivers/net/phy/bcm54140.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3fa33d27eeba..cb7936b577de 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -346,6 +346,16 @@ config BROADCOM_PHY
 	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
 	  BCM5481, BCM54810 and BCM5482 PHYs.
 
+config BCM54140_PHY
+	tristate "Broadcom BCM54140 PHY"
+	depends on PHYLIB
+	select BCM_NET_PHYLIB
+	help
+	  Support the Broadcom BCM54140 Quad SGMII/QSGMII PHY.
+
+	  This driver also supports the hardware monitoring of this PHY and
+	  exposes voltage and temperature sensors.
+
 config BCM84881_PHY
 	tristate "Broadcom BCM84881 PHY"
 	depends on PHYLIB
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 2f5c7093a65b..cd345b75d127 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+= bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
+obj-$(CONFIG_BCM54140_PHY)	+= bcm54140.o
 obj-$(CONFIG_BCM84881_PHY)	+= bcm84881.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+= cortina.o
diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
new file mode 100644
index 000000000000..0eeb60de67f8
--- /dev/null
+++ b/drivers/net/phy/bcm54140.c
@@ -0,0 +1,481 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Broadcom BCM54140 Quad SGMII/QSGMII Copper/Fiber Gigabit PHY
+ *
+ * Copyright (c) 2020 Michael Walle <michael@walle.cc>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/brcmphy.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#include "bcm-phy-lib.h"
+
+/* RDB per-port registers
+ */
+#define BCM54140_RDB_ISR		0x00a	/* interrupt status */
+#define BCM54140_RDB_IMR		0x00b	/* interrupt mask */
+#define  BCM54140_RDB_INT_LINK		BIT(1)	/* link status changed */
+#define  BCM54140_RDB_INT_SPEED		BIT(2)	/* link speed change */
+#define  BCM54140_RDB_INT_DUPLEX	BIT(3)	/* duplex mode changed */
+#define BCM54140_RDB_SPARE1		0x012	/* spare control 1 */
+#define  BCM54140_RDB_SPARE1_LSLM	BIT(2)	/* link speed LED mode */
+#define BCM54140_RDB_SPARE2		0x014	/* spare control 2 */
+#define  BCM54140_RDB_SPARE2_WS_RTRY_DIS BIT(8) /* wirespeed retry disable */
+#define  BCM54140_RDB_SPARE2_WS_RTRY_LIMIT GENMASK(4, 2) /* retry limit */
+#define BCM54140_RDB_SPARE3		0x015	/* spare control 3 */
+#define  BCM54140_RDB_SPARE3_BIT0	BIT(0)
+#define BCM54140_RDB_LED_CTRL		0x019	/* LED control */
+#define  BCM54140_RDB_LED_CTRL_ACTLINK0	BIT(4)
+#define  BCM54140_RDB_LED_CTRL_ACTLINK1	BIT(8)
+#define BCM54140_RDB_C_APWR		0x01a	/* auto power down control */
+#define  BCM54140_RDB_C_APWR_SINGLE_PULSE	BIT(8)	/* single pulse */
+#define  BCM54140_RDB_C_APWR_APD_MODE_DIS	0 /* ADP disable */
+#define  BCM54140_RDB_C_APWR_APD_MODE_EN	1 /* ADP enable */
+#define  BCM54140_RDB_C_APWR_APD_MODE_DIS2	2 /* ADP disable */
+#define  BCM54140_RDB_C_APWR_APD_MODE_EN_ANEG	3 /* ADP enable w/ aneg */
+#define  BCM54140_RDB_C_APWR_APD_MODE_MASK	GENMASK(6, 5)
+#define  BCM54140_RDB_C_APWR_SLP_TIM_MASK BIT(4)/* sleep timer */
+#define  BCM54140_RDB_C_APWR_SLP_TIM_2_7 0	/* 2.7s */
+#define  BCM54140_RDB_C_APWR_SLP_TIM_5_4 1	/* 5.4s */
+#define BCM54140_RDB_C_PWR		0x02a	/* copper power control */
+#define  BCM54140_RDB_C_PWR_ISOLATE	BIT(5)	/* super isolate mode */
+#define BCM54140_RDB_C_MISC_CTRL	0x02f	/* misc copper control */
+#define  BCM54140_RDB_C_MISC_CTRL_WS_EN BIT(4)	/* wirespeed enable */
+
+/* RDB global registers
+ */
+#define BCM54140_RDB_TOP_IMR		0x82d	/* interrupt mask */
+#define  BCM54140_RDB_TOP_IMR_PORT0	BIT(4)
+#define  BCM54140_RDB_TOP_IMR_PORT1	BIT(5)
+#define  BCM54140_RDB_TOP_IMR_PORT2	BIT(6)
+#define  BCM54140_RDB_TOP_IMR_PORT3	BIT(7)
+
+#define BCM54140_DEFAULT_DOWNSHIFT 5
+#define BCM54140_MAX_DOWNSHIFT 9
+
+struct bcm54140_priv {
+	int port;
+	int base_addr;
+};
+
+static int bcm54140_base_read_rdb(struct phy_device *phydev, u16 rdb)
+{
+	struct bcm54140_priv *priv = phydev->priv;
+	struct mii_bus *bus = phydev->mdio.bus;
+	int ret;
+
+	mutex_lock(&bus->mdio_lock);
+	ret = __mdiobus_write(bus, priv->base_addr, MII_BCM54XX_RDB_ADDR, rdb);
+	if (ret < 0)
+		goto out;
+
+	ret = __mdiobus_read(bus, priv->base_addr, MII_BCM54XX_RDB_DATA);
+
+out:
+	mutex_unlock(&bus->mdio_lock);
+	return ret;
+}
+
+static int bcm54140_base_write_rdb(struct phy_device *phydev,
+				   u16 rdb, u16 val)
+{
+	struct bcm54140_priv *priv = phydev->priv;
+	struct mii_bus *bus = phydev->mdio.bus;
+	int ret;
+
+	mutex_lock(&bus->mdio_lock);
+	ret = __mdiobus_write(bus, priv->base_addr, MII_BCM54XX_RDB_ADDR, rdb);
+	if (ret < 0)
+		goto out;
+
+	ret = __mdiobus_write(bus, priv->base_addr, MII_BCM54XX_RDB_DATA, val);
+
+out:
+	mutex_unlock(&bus->mdio_lock);
+	return ret;
+}
+
+/* Under some circumstances a core PLL may not lock, this will then prevent
+ * a successful link establishment. Restart the PLL after the voltages are
+ * stable to workaround this issue.
+ */
+static int bcm54140_b0_workaround(struct phy_device *phydev)
+{
+	int spare3;
+	int ret;
+
+	spare3 = bcm_phy_read_rdb(phydev, BCM54140_RDB_SPARE3);
+	if (spare3 < 0)
+		return spare3;
+
+	spare3 &= ~BCM54140_RDB_SPARE3_BIT0;
+
+	ret = bcm_phy_write_rdb(phydev, BCM54140_RDB_SPARE3, spare3);
+	if (ret)
+		return ret;
+
+	ret = phy_modify(phydev, MII_BMCR, 0, BMCR_PDOWN);
+	if (ret)
+		return ret;
+
+	ret = phy_modify(phydev, MII_BMCR, BMCR_PDOWN, 0);
+	if (ret)
+		return ret;
+
+	spare3 |= BCM54140_RDB_SPARE3_BIT0;
+
+	return bcm_phy_write_rdb(phydev, BCM54140_RDB_SPARE3, spare3);
+}
+
+/* The BCM54140 is a quad PHY where only the first port has access to the
+ * global register. Thus we need to find out its PHY address.
+ *
+ */
+static int bcm54140_get_base_addr_and_port(struct phy_device *phydev)
+{
+	struct bcm54140_priv *priv = phydev->priv;
+	struct mii_bus *bus = phydev->mdio.bus;
+	int addr, min_addr, max_addr;
+	int step = 1;
+	u32 phy_id;
+	int tmp;
+
+	min_addr = phydev->mdio.addr;
+	max_addr = phydev->mdio.addr;
+	addr = phydev->mdio.addr;
+
+	/* We scan forward and backwards and look for PHYs which have the
+	 * same phy_id like we do. Step 1 will scan forward, step 2
+	 * backwards. Once we are finished, we have a min_addr and
+	 * max_addr which resembles the range of PHY addresses of the same
+	 * type of PHY. There is one caveat; there may be many PHYs of
+	 * the same type, but we know that each PHY takes exactly 4
+	 * consecutive addresses. Therefore we can deduce our offset
+	 * to the base address of this quad PHY.
+	 */
+
+	while (1) {
+		if (step == 3) {
+			break;
+		} else if (step == 1) {
+			max_addr = addr;
+			addr++;
+		} else {
+			min_addr = addr;
+			addr--;
+		}
+
+		if (addr < 0 || addr >= PHY_MAX_ADDR) {
+			addr = phydev->mdio.addr;
+			step++;
+			continue;
+		}
+
+		/* read the PHY id */
+		tmp = mdiobus_read(bus, addr, MII_PHYSID1);
+		if (tmp < 0)
+			return tmp;
+		phy_id = tmp << 16;
+		tmp = mdiobus_read(bus, addr, MII_PHYSID2);
+		if (tmp < 0)
+			return tmp;
+		phy_id |= tmp;
+
+		/* see if it is still the same PHY */
+		if ((phy_id & phydev->drv->phy_id_mask) !=
+		    (phydev->drv->phy_id & phydev->drv->phy_id_mask)) {
+			addr = phydev->mdio.addr;
+			step++;
+		}
+	}
+
+	/* The range we get should be a multiple of four. Please note that both
+	 * the min_addr and max_addr are inclusive. So we have to add one if we
+	 * subtract them.
+	 */
+	if ((max_addr - min_addr + 1) % 4) {
+		dev_err(&phydev->mdio.dev,
+			"Detected Quad PHY IDs %d..%d doesn't make sense.\n",
+			min_addr, max_addr);
+		return -EINVAL;
+	}
+
+	priv->port = (phydev->mdio.addr - min_addr) % 4;
+	priv->base_addr = phydev->mdio.addr - priv->port;
+
+	return 0;
+}
+
+static int bcm54140_probe(struct phy_device *phydev)
+{
+	struct bcm54140_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	ret = bcm54140_get_base_addr_and_port(phydev);
+	if (ret)
+		return ret;
+
+	phydev_dbg(phydev, "probed (port %d, base PHY address %d)\n",
+		   priv->port, priv->base_addr);
+
+	return 0;
+}
+
+static int bcm54140_config_init(struct phy_device *phydev)
+{
+	u16 reg = 0xffff;
+	int ret;
+
+	/* Apply hardware errata */
+	ret = bcm54140_b0_workaround(phydev);
+	if (ret)
+		return ret;
+
+	/* Unmask events we are interested in. */
+	reg &= ~(BCM54140_RDB_INT_DUPLEX |
+		 BCM54140_RDB_INT_SPEED |
+		 BCM54140_RDB_INT_LINK);
+	ret = bcm_phy_write_rdb(phydev, BCM54140_RDB_IMR, reg);
+	if (ret)
+		return ret;
+
+	/* LED1=LINKSPD[1], LED2=LINKSPD[2], LED3=LINK/ACTIVITY */
+	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_SPARE1,
+				 0, BCM54140_RDB_SPARE1_LSLM);
+	if (ret)
+		return ret;
+
+	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_LED_CTRL,
+				 0, BCM54140_RDB_LED_CTRL_ACTLINK0);
+	if (ret)
+		return ret;
+
+	/* disable super isolate mode */
+	return bcm_phy_modify_rdb(phydev, BCM54140_RDB_C_PWR,
+				  BCM54140_RDB_C_PWR_ISOLATE, 0);
+}
+
+int bcm54140_did_interrupt(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = bcm_phy_read_rdb(phydev, BCM54140_RDB_ISR);
+
+	return (ret < 0) ? 0 : ret;
+}
+
+int bcm54140_ack_intr(struct phy_device *phydev)
+{
+	int reg;
+
+	/* clear pending interrupts */
+	reg = bcm_phy_read_rdb(phydev, BCM54140_RDB_ISR);
+	if (reg < 0)
+		return reg;
+
+	return 0;
+}
+
+int bcm54140_config_intr(struct phy_device *phydev)
+{
+	struct bcm54140_priv *priv = phydev->priv;
+	static const u16 port_to_imr_bit[] = {
+		BCM54140_RDB_TOP_IMR_PORT0, BCM54140_RDB_TOP_IMR_PORT1,
+		BCM54140_RDB_TOP_IMR_PORT2, BCM54140_RDB_TOP_IMR_PORT3,
+	};
+	int reg;
+
+	if (priv->port >= ARRAY_SIZE(port_to_imr_bit))
+		return -EINVAL;
+
+	reg = bcm54140_base_read_rdb(phydev, BCM54140_RDB_TOP_IMR);
+	if (reg < 0)
+		return reg;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		reg &= ~port_to_imr_bit[priv->port];
+	else
+		reg |= port_to_imr_bit[priv->port];
+
+	return bcm54140_base_write_rdb(phydev, BCM54140_RDB_TOP_IMR, reg);
+}
+
+static int bcm54140_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val;
+
+	val = bcm_phy_read_rdb(phydev, BCM54140_RDB_C_MISC_CTRL);
+	if (val < 0)
+		return val;
+
+	if (!(val & BCM54140_RDB_C_MISC_CTRL_WS_EN)) {
+		*data = DOWNSHIFT_DEV_DISABLE;
+		return 0;
+	}
+
+	val = bcm_phy_read_rdb(phydev, BCM54140_RDB_SPARE2);
+	if (val < 0)
+		return val;
+
+	if (val & BCM54140_RDB_SPARE2_WS_RTRY_DIS)
+		*data = 1;
+	else
+		*data = FIELD_GET(BCM54140_RDB_SPARE2_WS_RTRY_LIMIT, val) + 2;
+
+	return 0;
+}
+
+static int bcm54140_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	u16 mask, set;
+	int ret;
+
+	if (cnt > BCM54140_MAX_DOWNSHIFT && cnt != DOWNSHIFT_DEV_DEFAULT_COUNT)
+		return -EINVAL;
+
+	if (!cnt)
+		return bcm_phy_modify_rdb(phydev, BCM54140_RDB_C_MISC_CTRL,
+					  BCM54140_RDB_C_MISC_CTRL_WS_EN, 0);
+
+	if (cnt == DOWNSHIFT_DEV_DEFAULT_COUNT)
+		cnt = BCM54140_DEFAULT_DOWNSHIFT;
+
+	if (cnt == 1) {
+		mask = 0;
+		set = BCM54140_RDB_SPARE2_WS_RTRY_DIS;
+	} else {
+		mask = BCM54140_RDB_SPARE2_WS_RTRY_DIS;
+		mask |= BCM54140_RDB_SPARE2_WS_RTRY_LIMIT;
+		set = FIELD_PREP(BCM54140_RDB_SPARE2_WS_RTRY_LIMIT, cnt - 2);
+	}
+	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_SPARE2,
+				 mask, set);
+	if (ret)
+		return ret;
+
+	return bcm_phy_modify_rdb(phydev, BCM54140_RDB_C_MISC_CTRL,
+				  0, BCM54140_RDB_C_MISC_CTRL_WS_EN);
+}
+
+static int bcm54140_get_edpd(struct phy_device *phydev, u16 *tx_interval)
+{
+	int val;
+
+	val = bcm_phy_read_rdb(phydev, BCM54140_RDB_C_APWR);
+	if (val < 0)
+		return val;
+
+	switch (FIELD_GET(BCM54140_RDB_C_APWR_APD_MODE_MASK, val)) {
+	case BCM54140_RDB_C_APWR_APD_MODE_DIS:
+	case BCM54140_RDB_C_APWR_APD_MODE_DIS2:
+		*tx_interval = ETHTOOL_PHY_EDPD_DISABLE;
+		break;
+	case BCM54140_RDB_C_APWR_APD_MODE_EN:
+	case BCM54140_RDB_C_APWR_APD_MODE_EN_ANEG:
+		switch (FIELD_GET(BCM54140_RDB_C_APWR_SLP_TIM_MASK, val)) {
+		case BCM54140_RDB_C_APWR_SLP_TIM_2_7:
+			*tx_interval = 2700;
+			break;
+		case BCM54140_RDB_C_APWR_SLP_TIM_5_4:
+			*tx_interval = 5400;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int bcm54140_set_edpd(struct phy_device *phydev, u16 tx_interval)
+{
+	u16 mask, set;
+
+	mask = BCM54140_RDB_C_APWR_APD_MODE_MASK;
+	if (tx_interval == ETHTOOL_PHY_EDPD_DISABLE)
+		set = FIELD_PREP(BCM54140_RDB_C_APWR_APD_MODE_MASK,
+				 BCM54140_RDB_C_APWR_APD_MODE_DIS);
+	else
+		set = FIELD_PREP(BCM54140_RDB_C_APWR_APD_MODE_MASK,
+				 BCM54140_RDB_C_APWR_APD_MODE_EN_ANEG);
+
+	/* enable single pulse mode */
+	set |= BCM54140_RDB_C_APWR_SINGLE_PULSE;
+
+	/* set sleep timer */
+	mask |= BCM54140_RDB_C_APWR_SLP_TIM_MASK;
+	switch (tx_interval) {
+	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
+	case ETHTOOL_PHY_EDPD_DISABLE:
+	case 2700:
+		set |= BCM54140_RDB_C_APWR_SLP_TIM_2_7;
+		break;
+	case 5400:
+		set |= BCM54140_RDB_C_APWR_SLP_TIM_5_4;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return bcm_phy_modify_rdb(phydev, BCM54140_RDB_C_APWR, mask, set);
+}
+
+static int bcm54140_get_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return bcm54140_get_downshift(phydev, data);
+	case ETHTOOL_PHY_EDPD:
+		return bcm54140_get_edpd(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int bcm54140_set_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return bcm54140_set_downshift(phydev, *(const u8 *)data);
+	case ETHTOOL_PHY_EDPD:
+		return bcm54140_set_edpd(phydev, *(const u16 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct phy_driver bcm54140_drivers[] = {
+	{
+		.phy_id         = PHY_ID_BCM54140,
+		.phy_id_mask    = 0xfffffff0,
+		.name           = "Broadcom BCM54140",
+		.features       = PHY_GBIT_FEATURES,
+		.config_init    = bcm54140_config_init,
+		.did_interrupt	= bcm54140_did_interrupt,
+		.ack_interrupt  = bcm54140_ack_intr,
+		.config_intr    = bcm54140_config_intr,
+		.probe		= bcm54140_probe,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.get_tunable	= bcm54140_get_tunable,
+		.set_tunable	= bcm54140_set_tunable,
+	},
+};
+module_phy_driver(bcm54140_drivers);
+
+static struct mdio_device_id __maybe_unused bcm54140_tbl[] = {
+	{ PHY_ID_BCM54140, 0xfffffff0 },
+	{ }
+};
+
+MODULE_AUTHOR("Michael Walle");
+MODULE_DESCRIPTION("Broadcom BCM54140 PHY driver");
+MODULE_DEVICE_TABLE(mdio, bcm54140_tbl);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 897b69309964..8be150e69c7c 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -25,6 +25,7 @@
 #define PHY_ID_BCM5461			0x002060c0
 #define PHY_ID_BCM54612E		0x03625e60
 #define PHY_ID_BCM54616S		0x03625d10
+#define PHY_ID_BCM54140			0xae025019
 #define PHY_ID_BCM57780			0x03625d90
 #define PHY_ID_BCM89610			0x03625cd0
 
-- 
2.20.1

