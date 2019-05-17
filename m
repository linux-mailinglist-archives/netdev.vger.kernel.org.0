Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D8B220CF
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 01:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfEQXvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 19:51:38 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52677 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfEQXvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 19:51:37 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 455Q6q6qhCz1rZRv;
        Sat, 18 May 2019 01:51:31 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 455Q6q62lGz1qqkP;
        Sat, 18 May 2019 01:51:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 2ZgfvBOhpp3x; Sat, 18 May 2019 01:51:30 +0200 (CEST)
X-Auth-Info: t2aCb93UpHGfe47ESJfcO94vcf4uDjpEYWFim8SipWg=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 18 May 2019 01:51:29 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
Date:   Sat, 18 May 2019 01:51:23 +0200
Message-Id: <20190517235123.32261-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
BroadRReach 100BaseT1 PHYs used in automotive.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
---
V2: - Use phy_modify(), phy_{set,clear}_bits()
    - Drop enable argument of tja11xx_enable_link_control()
    - Use PHY_BASIC_T1_FEATURES and dont modify supported/advertised
      features in config_init callback
    - Use genphy_soft_reset() instead of opencoding the reset sequence.
    - Drop the aneg parts, since the PHY datasheet claims it does not
      support aneg
V3: - Replace clr with mask
    - Add hwmon support
    - Check commstat in tja11xx_read_status() only if link is up
    - Use PHY_ID_MATCH_MODEL()
V4: - Use correct bit in tja11xx_hwmon_read() hwmon_temp_crit_alarm
    - Use ENOMEM if devm_kstrdup() fails
    - Check $type in tja11xx_hwmon_read() in addition to $attr
V5: - Drop assignment of phydev->irq,pause,asym_pause
---
 drivers/net/phy/Kconfig       |   6 +
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/nxp-tja11xx.c | 423 ++++++++++++++++++++++++++++++++++
 3 files changed, 430 insertions(+)
 create mode 100644 drivers/net/phy/nxp-tja11xx.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index d6299710d634..31478d8b3c0c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -415,6 +415,12 @@ config NATIONAL_PHY
 	---help---
 	  Currently supports the DP83865 PHY.
 
+config NXP_TJA11XX_PHY
+	tristate "NXP TJA11xx PHYs support"
+	depends on HWMON
+	---help---
+	  Currently supports the NXP TJA1100 and TJA1101 PHY.
+
 config QSEMI_PHY
 	tristate "Quality Semiconductor PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 27d7f9f3b0de..bac339e09042 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
+obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
 obj-$(CONFIG_RENESAS_PHY)	+= uPD60620.o
diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
new file mode 100644
index 000000000000..11b8701e78fd
--- /dev/null
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -0,0 +1,423 @@
+// SPDX-License-Identifier: GPL-2.0
+/* NXP TJA1100 BroadRReach PHY driver
+ *
+ * Copyright (C) 2018 Marek Vasut <marex@denx.de>
+ */
+#include <linux/delay.h>
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/hwmon.h>
+#include <linux/bitfield.h>
+
+#define PHY_ID_MASK			0xfffffff0
+#define PHY_ID_TJA1100			0x0180dc40
+#define PHY_ID_TJA1101			0x0180dd00
+
+#define MII_ECTRL			17
+#define MII_ECTRL_LINK_CONTROL		BIT(15)
+#define MII_ECTRL_POWER_MODE_MASK	GENMASK(14, 11)
+#define MII_ECTRL_POWER_MODE_NO_CHANGE	(0x0 << 11)
+#define MII_ECTRL_POWER_MODE_NORMAL	(0x3 << 11)
+#define MII_ECTRL_POWER_MODE_STANDBY	(0xc << 11)
+#define MII_ECTRL_CONFIG_EN		BIT(2)
+#define MII_ECTRL_WAKE_REQUEST		BIT(0)
+
+#define MII_CFG1			18
+#define MII_CFG1_AUTO_OP		BIT(14)
+#define MII_CFG1_SLEEP_CONFIRM		BIT(6)
+#define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
+#define MII_CFG1_LED_MODE_LINKUP	0
+#define MII_CFG1_LED_ENABLE		BIT(3)
+
+#define MII_CFG2			19
+#define MII_CFG2_SLEEP_REQUEST_TO	GENMASK(1, 0)
+#define MII_CFG2_SLEEP_REQUEST_TO_16MS	0x3
+
+#define MII_INTSRC			21
+#define MII_INTSRC_TEMP_ERR		BIT(1)
+#define MII_INTSRC_UV_ERR		BIT(3)
+
+#define MII_COMMSTAT			23
+#define MII_COMMSTAT_LINK_UP		BIT(15)
+
+#define MII_GENSTAT			24
+#define MII_GENSTAT_PLL_LOCKED		BIT(14)
+
+#define MII_COMMCFG			27
+#define MII_COMMCFG_AUTO_OP		BIT(15)
+
+struct tja11xx_priv {
+	char		*hwmon_name;
+	struct device	*hwmon_dev;
+};
+
+struct tja11xx_phy_stats {
+	const char	*string;
+	u8		reg;
+	u8		off;
+	u16		mask;
+};
+
+static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
+	{ "phy_symbol_error_count", 20, 0, GENMASK(15, 0) },
+	{ "phy_polarity_detect", 25, 6, BIT(6) },
+	{ "phy_open_detect", 25, 7, BIT(7) },
+	{ "phy_short_detect", 25, 8, BIT(8) },
+	{ "phy_rem_rcvr_count", 26, 0, GENMASK(7, 0) },
+	{ "phy_loc_rcvr_count", 26, 8, GENMASK(15, 8) },
+};
+
+static int tja11xx_check(struct phy_device *phydev, u8 reg, u16 mask, u16 set)
+{
+	int i, ret;
+
+	for (i = 0; i < 200; i++) {
+		ret = phy_read(phydev, reg);
+		if (ret < 0)
+			return ret;
+
+		if ((ret & mask) == set)
+			return 0;
+
+		usleep_range(100, 150);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int phy_modify_check(struct phy_device *phydev, u8 reg,
+			    u16 mask, u16 set)
+{
+	int ret;
+
+	ret = phy_modify(phydev, reg, mask, set);
+	if (ret)
+		return ret;
+
+	return tja11xx_check(phydev, reg, mask, set);
+}
+
+static int tja11xx_enable_reg_write(struct phy_device *phydev)
+{
+	return phy_set_bits(phydev, MII_ECTRL, MII_ECTRL_CONFIG_EN);
+}
+
+static int tja11xx_enable_link_control(struct phy_device *phydev)
+{
+	return phy_set_bits(phydev, MII_ECTRL, MII_ECTRL_LINK_CONTROL);
+}
+
+static int tja11xx_wakeup(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_ECTRL);
+	if (ret < 0)
+		return ret;
+
+	switch (ret & MII_ECTRL_POWER_MODE_MASK) {
+	case MII_ECTRL_POWER_MODE_NO_CHANGE:
+		break;
+	case MII_ECTRL_POWER_MODE_NORMAL:
+		ret = phy_set_bits(phydev, MII_ECTRL, MII_ECTRL_WAKE_REQUEST);
+		if (ret)
+			return ret;
+
+		ret = phy_clear_bits(phydev, MII_ECTRL, MII_ECTRL_WAKE_REQUEST);
+		if (ret)
+			return ret;
+		break;
+	case MII_ECTRL_POWER_MODE_STANDBY:
+		ret = phy_modify_check(phydev, MII_ECTRL,
+				       MII_ECTRL_POWER_MODE_MASK,
+				       MII_ECTRL_POWER_MODE_STANDBY);
+		if (ret)
+			return ret;
+
+		ret = phy_modify(phydev, MII_ECTRL, MII_ECTRL_POWER_MODE_MASK,
+				 MII_ECTRL_POWER_MODE_NORMAL);
+		if (ret)
+			return ret;
+
+		ret = phy_modify_check(phydev, MII_GENSTAT,
+				       MII_GENSTAT_PLL_LOCKED,
+				       MII_GENSTAT_PLL_LOCKED);
+		if (ret)
+			return ret;
+
+		return tja11xx_enable_link_control(phydev);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int tja11xx_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = tja11xx_enable_reg_write(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_soft_reset(phydev);
+}
+
+static int tja11xx_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = tja11xx_enable_reg_write(phydev);
+	if (ret)
+		return ret;
+
+	phydev->autoneg = AUTONEG_DISABLE;
+	phydev->speed = SPEED_100;
+	phydev->duplex = DUPLEX_FULL;
+
+	switch (phydev->phy_id & PHY_ID_MASK) {
+	case PHY_ID_TJA1100:
+		ret = phy_modify(phydev, MII_CFG1,
+				 MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_MASK |
+				 MII_CFG1_LED_ENABLE,
+				 MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_LINKUP |
+				 MII_CFG1_LED_ENABLE);
+		if (ret)
+			return ret;
+		break;
+	case PHY_ID_TJA1101:
+		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = phy_clear_bits(phydev, MII_CFG1, MII_CFG1_SLEEP_CONFIRM);
+	if (ret)
+		return ret;
+
+	ret = phy_modify(phydev, MII_CFG2, MII_CFG2_SLEEP_REQUEST_TO,
+			 MII_CFG2_SLEEP_REQUEST_TO_16MS);
+	if (ret)
+		return ret;
+
+	ret = tja11xx_wakeup(phydev);
+	if (ret < 0)
+		return ret;
+
+	/* ACK interrupts by reading the status register */
+	ret = phy_read(phydev, MII_INTSRC);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int tja11xx_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_update_link(phydev);
+	if (ret)
+		return ret;
+
+	if (phydev->link) {
+		ret = phy_read(phydev, MII_COMMSTAT);
+		if (ret < 0)
+			return ret;
+
+		if (!(ret & MII_COMMSTAT_LINK_UP))
+			phydev->link = 0;
+	}
+
+	return 0;
+}
+
+static int tja11xx_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(tja11xx_hw_stats);
+}
+
+static void tja11xx_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tja11xx_hw_stats); i++) {
+		strncpy(data + i * ETH_GSTRING_LEN,
+			tja11xx_hw_stats[i].string, ETH_GSTRING_LEN);
+	}
+}
+
+static void tja11xx_get_stats(struct phy_device *phydev,
+			      struct ethtool_stats *stats, u64 *data)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(tja11xx_hw_stats); i++) {
+		ret = phy_read(phydev, tja11xx_hw_stats[i].reg);
+		if (ret < 0)
+			data[i] = U64_MAX;
+		else {
+			data[i] = ret & tja11xx_hw_stats[i].mask;
+			data[i] >>= tja11xx_hw_stats[i].off;
+		}
+	}
+}
+
+static int tja11xx_hwmon_read(struct device *dev,
+			      enum hwmon_sensor_types type,
+			      u32 attr, int channel, long *value)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	int ret;
+
+	if (type == hwmon_in && attr == hwmon_in_lcrit_alarm) {
+		ret = phy_read(phydev, MII_INTSRC);
+		if (ret < 0)
+			return ret;
+
+		*value = !!(ret & MII_INTSRC_TEMP_ERR);
+		return 0;
+	}
+
+	if (type == hwmon_temp && attr == hwmon_temp_crit_alarm) {
+		ret = phy_read(phydev, MII_INTSRC);
+		if (ret < 0)
+			return ret;
+
+		*value = !!(ret & MII_INTSRC_UV_ERR);
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static umode_t tja11xx_hwmon_is_visible(const void *data,
+					enum hwmon_sensor_types type,
+					u32 attr, int channel)
+{
+	if (type == hwmon_in && attr == hwmon_in_lcrit_alarm)
+		return 0444;
+
+	if (type == hwmon_temp && attr == hwmon_temp_crit_alarm)
+		return 0444;
+
+	return 0;
+}
+
+static u32 tja11xx_hwmon_in_config[] = {
+	HWMON_I_LCRIT_ALARM,
+	0
+};
+
+static const struct hwmon_channel_info tja11xx_hwmon_in = {
+	.type		= hwmon_in,
+	.config		= tja11xx_hwmon_in_config,
+};
+
+static u32 tja11xx_hwmon_temp_config[] = {
+	HWMON_T_CRIT_ALARM,
+	0
+};
+
+static const struct hwmon_channel_info tja11xx_hwmon_temp = {
+	.type		= hwmon_temp,
+	.config		= tja11xx_hwmon_temp_config,
+};
+
+static const struct hwmon_channel_info *tja11xx_hwmon_info[] = {
+	&tja11xx_hwmon_in,
+	&tja11xx_hwmon_temp,
+	NULL
+};
+
+static const struct hwmon_ops tja11xx_hwmon_hwmon_ops = {
+	.is_visible	= tja11xx_hwmon_is_visible,
+	.read		= tja11xx_hwmon_read,
+};
+
+static const struct hwmon_chip_info tja11xx_hwmon_chip_info = {
+	.ops		= &tja11xx_hwmon_hwmon_ops,
+	.info		= tja11xx_hwmon_info,
+};
+
+static int tja11xx_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct tja11xx_priv *priv;
+	int i;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	if (!priv->hwmon_name)
+		return -ENOMEM;
+
+	for (i = 0; priv->hwmon_name[i]; i++)
+		if (hwmon_is_bad_char(priv->hwmon_name[i]))
+			priv->hwmon_name[i] = '_';
+
+	priv->hwmon_dev =
+		devm_hwmon_device_register_with_info(dev, priv->hwmon_name,
+						     phydev,
+						     &tja11xx_hwmon_chip_info,
+						     NULL);
+
+	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
+}
+
+static struct phy_driver tja11xx_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_TJA1100),
+		.name		= "NXP TJA1100",
+		.features       = PHY_BASIC_T1_FEATURES,
+		.probe		= tja11xx_probe,
+		.soft_reset	= tja11xx_soft_reset,
+		.config_init	= tja11xx_config_init,
+		.read_status	= tja11xx_read_status,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.set_loopback   = genphy_loopback,
+		/* Statistics */
+		.get_sset_count = tja11xx_get_sset_count,
+		.get_strings	= tja11xx_get_strings,
+		.get_stats	= tja11xx_get_stats,
+	}, {
+		PHY_ID_MATCH_MODEL(PHY_ID_TJA1101),
+		.name		= "NXP TJA1101",
+		.features       = PHY_BASIC_T1_FEATURES,
+		.probe		= tja11xx_probe,
+		.soft_reset	= tja11xx_soft_reset,
+		.config_init	= tja11xx_config_init,
+		.read_status	= tja11xx_read_status,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.set_loopback   = genphy_loopback,
+		/* Statistics */
+		.get_sset_count = tja11xx_get_sset_count,
+		.get_strings	= tja11xx_get_strings,
+		.get_stats	= tja11xx_get_stats,
+	}
+};
+
+module_phy_driver(tja11xx_driver);
+
+static struct mdio_device_id __maybe_unused tja11xx_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, tja11xx_tbl);
+
+MODULE_AUTHOR("Marek Vasut <marex@denx.de>");
+MODULE_DESCRIPTION("NXP TJA11xx BoardR-Reach PHY driver");
+MODULE_LICENSE("GPL");
-- 
2.20.1

