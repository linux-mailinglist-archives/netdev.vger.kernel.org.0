Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CFB1391D7
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMNLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:11:21 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:35686 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbgAMNLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:11:21 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9770D404BE;
        Mon, 13 Jan 2020 13:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578921079; bh=fJomAroWLsy0VlfS3yrrg1fMpOD8qbPLGRgJ6L1MXQ0=;
        h=From:To:Cc:Subject:Date:From;
        b=cVXwzIEV33ndGkpK4R494LpypmKqSORXdUute5b9WMPxGsAm/23LXWpDIbvqXj2bM
         shM1yixTR126fJc3A/phK28q5Kd+mgoiHu/Di3y1TpJB85mGHD5TXqM7/H7HjccZO0
         rrrlN5SuSj1jyF9ykBKpx073rBXWfIgbgtzpRhpNAFUjxY52L44mr3r7wa4tE8bSpc
         DA2d/LMC8KvwIVIHY03XQxH/29CdqjpAA2JRYLaCM0w3VZzt8GG2uOW/RP6h9awTiI
         LRRYztaGvB1myT2GV/+rtol37tromg62alAuJLK5YBbRBWAmyPfaqE1sp+KZuGu/Pq
         xgkasePtapMwg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 60FDDA005B;
        Mon, 13 Jan 2020 13:11:14 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC net-next] net: phy: Add basic support for Synopsys XPCS using a PHY driver
Date:   Mon, 13 Jan 2020 14:11:08 +0100
Message-Id: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the basic support for XPCS including support for USXGMII.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 MAINTAINERS                |   6 +
 drivers/net/phy/Kconfig    |   5 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/synopsys.c | 634 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 646 insertions(+)
 create mode 100644 drivers/net/phy/synopsys.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2549f10eb0b1..923a6425084a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15956,6 +15956,12 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/synopsys/
 
+SYNOPSYS DESIGNWARE ETHERNET PHY DRIVER
+M:	Jose Abreu <Jose.Abreu@synopsys.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/phy/synopsys.c
+
 SYNOPSYS DESIGNWARE I2C DRIVER
 M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
 R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 2e016271e126..9762b2f68256 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -492,6 +492,11 @@ config TERANETICS_PHY
 	---help---
 	  Currently supports the Teranetics TN2020
 
+config SYNOPSYS_PHY
+	tristate "Synopsys PHYs"
+	---help---
+	  This is the driver for all Synopsys Ethernet PHYs.
+
 config VITESSE_PHY
 	tristate "Vitesse PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index fe5badf13b65..01a453101b21 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_RENESAS_PHY)	+= uPD60620.o
 obj-$(CONFIG_ROCKCHIP_PHY)	+= rockchip.o
 obj-$(CONFIG_SMSC_PHY)		+= smsc.o
 obj-$(CONFIG_STE10XP)		+= ste10Xp.o
+obj-$(CONFIG_SYNOPSYS_PHY)	+= synopsys.o
 obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
 obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
 obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
diff --git a/drivers/net/phy/synopsys.c b/drivers/net/phy/synopsys.c
new file mode 100644
index 000000000000..fed94a0ce47f
--- /dev/null
+++ b/drivers/net/phy/synopsys.c
@@ -0,0 +1,634 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright (c) 2019 Synopsys, Inc. and/or its affiliates.
+ * Synopsys DesignWare PHYs driver
+ *
+ * Author: Jose Abreu <joabreu@synopsys.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/mdio.h>
+#include <linux/phy.h>
+
+#define SYNOPSYS_XPHY_ID		0x7996ced0
+#define SYNOPSYS_XPHY_MASK		0xffffffff
+
+/* Vendor regs access */
+#define DW_VENDOR			BIT(15)
+
+/* VR_XS_PCS */
+#define DW_VR_XS_PCS_DIG_CTRL1		0x8000
+#define DW_USXGMII_RST			BIT(10)
+#define DW_USXGMII_EN			BIT(9)
+
+/* SR_MII */
+#define DW_USXGMII_FULL			BIT(8)
+#define DW_USXGMII_SS_MASK		(BIT(13) | BIT(6) | BIT(5))
+#define DW_USXGMII_10000		(BIT(13) | BIT(6))
+#define DW_USXGMII_5000			(BIT(13) | BIT(5))
+#define DW_USXGMII_2500			(BIT(5))
+#define DW_USXGMII_1000			(BIT(6))
+#define DW_USXGMII_100			(BIT(13))
+#define DW_USXGMII_10			(0)
+
+/* SR_AN */
+#define DW_SR_AN_ADV1			0x10
+#define DW_SR_AN_ADV2			0x11
+#define DW_SR_AN_ADV3			0x12
+#define DW_SR_AN_LP_ABL1		0x13
+#define DW_SR_AN_LP_ABL2		0x14
+#define DW_SR_AN_LP_ABL3		0x15
+
+/* Clause 73 Defines */
+/* AN_LP_ABL1 */
+#define DW_C73_PAUSE			BIT(10)
+#define DW_C73_ASYM_PAUSE		BIT(11)
+/* AN_LP_ABL2 */
+#define DW_C73_1000KX			BIT(5)
+#define DW_C73_10000KX4			BIT(6)
+#define DW_C73_10000KR			BIT(7)
+/* AN_LP_ABL3 */
+#define DW_C73_2500KX			BIT(0)
+#define DW_C73_5000KR			BIT(1)
+
+static int dw_read_vendor(struct phy_device *phydev, int dev, int reg)
+{
+	return phy_read_mmd(phydev, dev, DW_VENDOR | reg);
+}
+
+static int dw_write_vendor(struct phy_device *phydev, int dev, int reg, int val)
+{
+	return phy_write_mmd(phydev, dev, DW_VENDOR | reg, val);
+}
+
+static int dw_write_vpcs(struct phy_device *phydev, int reg, int val)
+{
+	return dw_write_vendor(phydev, MDIO_MMD_PCS, reg, val);
+}
+
+static int dw_read_vpcs(struct phy_device *phydev, int reg)
+{
+	return dw_read_vendor(phydev, MDIO_MMD_PCS, reg);
+}
+
+static int dw_poll_reset(struct phy_device *phydev, int dev)
+{
+	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
+	unsigned int retries = 12;
+	int ret;
+
+	do {
+		msleep(50);
+		ret = phy_read_mmd(phydev, dev, MDIO_CTRL1);
+		if (ret < 0)
+			return ret;
+	} while (ret & MDIO_CTRL1_RESET && --retries);
+	if (ret & MDIO_CTRL1_RESET)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int __dw_soft_reset(struct phy_device *phydev, int dev, int reg)
+{
+	int val;
+
+	val = phy_write_mmd(phydev, dev, reg, MDIO_CTRL1_RESET);
+	if (val < 0)
+		return val;
+
+	val = dw_poll_reset(phydev, dev);
+	if (val < 0)
+		return val;
+
+	return 0;
+}
+
+static int dw_soft_reset(struct phy_device *phydev, u32 mmd_mask)
+{
+	int val, devad;
+
+	while (mmd_mask) {
+		devad = __ffs(mmd_mask);
+		mmd_mask &= ~BIT(devad);
+
+		val = __dw_soft_reset(phydev, devad, MDIO_CTRL1);
+		if (val < 0)
+			return val;
+	}
+
+	return 0;
+}
+
+static int dw_read_link(struct phy_device *phydev, u32 mmd_mask)
+{
+	bool link = true;
+	int val, devad;
+
+	while (mmd_mask) {
+		devad = __ffs(mmd_mask);
+		mmd_mask &= ~BIT(devad);
+
+		val = phy_read_mmd(phydev, devad, MDIO_STAT1);
+		if (val < 0)
+			return val;
+
+		if (!(val & MDIO_STAT1_LSTATUS))
+			link = false;
+	}
+
+	return link;
+}
+
+#define dw_warn(__phy, __args...) \
+({ \
+	if ((__phy)->link) \
+		dev_warn(&(__phy)->mdio.dev, ##__args); \
+})
+
+static int dw_read_fault(struct phy_device *phydev)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_STAT1_FAULT) {
+		dw_warn(phydev, "Link fault condition detected!\n");
+		return -EFAULT;
+	}
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT2);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_STAT2_RXFAULT) {
+		dw_warn(phydev, "Receiver fault detected!\n");
+		return -EFAULT;
+	}
+	if (val & MDIO_STAT2_TXFAULT) {
+		dw_warn(phydev, "Transmitter fault detected!\n");
+		return -EFAULT;
+	}
+
+	val = dw_read_vendor(phydev, MDIO_MMD_PCS, 0x10);
+	if (val < 0)
+		return val;
+
+	if (val & GENMASK(6, 5)) {
+		dw_warn(phydev, "FIFO fault condition detected!\n");
+		return -EFAULT;
+	}
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10GBRT_STAT1);
+	if (val < 0)
+		return val;
+
+	if (!(val & MDIO_PCS_10GBRT_STAT1_BLKLK))
+		dw_warn(phydev, "Link is not locked!\n");
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10GBRT_STAT2);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_PCS_10GBRT_STAT2_ERR) {
+		dw_warn(phydev, "Link has errors!\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int dw_read_pma(struct phy_device *phydev)
+{
+	int val;
+
+	/* Read USXGMII Mode if any */
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, DW_VR_XS_PCS_DIG_CTRL1);
+	if (val < 0)
+		return val;
+
+	if (val & DW_USXGMII_EN) {
+		val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_CTRL1);
+		if (val < 0)
+			return val;
+
+		switch (val & DW_USXGMII_SS_MASK) {
+		case DW_USXGMII_5000:
+			phydev->speed = SPEED_5000;
+			break;
+		case DW_USXGMII_2500:
+			phydev->speed = SPEED_2500;
+			break;
+		case DW_USXGMII_10000:
+			phydev->speed = SPEED_10000;
+			break;
+		case DW_USXGMII_1000:
+			phydev->speed = SPEED_1000;
+			break;
+		case DW_USXGMII_100:
+			phydev->speed = SPEED_100;
+			break;
+		case DW_USXGMII_10:
+			phydev->speed = SPEED_10;
+			break;
+		default:
+			phydev->speed = SPEED_UNKNOWN;
+			break;
+		}
+	}
+
+	phydev->duplex = DUPLEX_FULL;
+	return 0;
+}
+
+static int dw_config_usxgmii(struct phy_device *phydev)
+{
+	int val, speed_sel = 0x0;
+
+	/* USXGMII only supports Full Duplex modes */
+	if (phydev->duplex != DUPLEX_FULL)
+		return 0;
+
+	switch (phydev->speed) {
+	case SPEED_10:
+		speed_sel = DW_USXGMII_10;
+		break;
+	case SPEED_100:
+		speed_sel = DW_USXGMII_100;
+		break;
+	case SPEED_1000:
+		speed_sel = DW_USXGMII_1000;
+		break;
+	case SPEED_2500:
+		speed_sel = DW_USXGMII_2500;
+		break;
+	case SPEED_5000:
+		speed_sel = DW_USXGMII_5000;
+		break;
+	case SPEED_10000:
+		speed_sel = DW_USXGMII_10000;
+		break;
+	default:
+		/* Nothing to do here */
+		return 0;
+	}
+
+	val = dw_read_vpcs(phydev, MDIO_CTRL1);
+	if (val < 0)
+		return val;
+
+	val = dw_write_vpcs(phydev, MDIO_CTRL1, val | DW_USXGMII_EN);
+	if (val < 0)
+		return val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_CTRL1);
+	if (val < 0)
+		return val;
+
+	val &= ~DW_USXGMII_SS_MASK;
+	val |= speed_sel | DW_USXGMII_FULL;
+
+	val = phy_write_mmd(phydev, MDIO_MMD_VEND2, MDIO_CTRL1, val);
+	if (val < 0)
+		return val;
+
+	val = dw_read_vpcs(phydev, MDIO_CTRL1);
+	if (val < 0)
+		return val;
+
+	val = dw_write_vpcs(phydev, MDIO_CTRL1, val | DW_USXGMII_RST);
+	if (val < 0)
+		return val;
+
+	return 0;
+}
+
+static int dw_get_features(struct phy_device *phydev)
+{
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+			 phydev->supported);
+	phydev->interface = PHY_INTERFACE_MODE_USXGMII;
+	return 0;
+}
+
+static int dw_config_aneg_c73(struct phy_device *phydev)
+{
+	u32 adv = 0;
+	int ret;
+
+	/* SR_AN_ADV3 */
+	adv = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV3);
+	if (adv < 0)
+		return adv;
+
+	adv &= ~DW_C73_2500KX;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+			      phydev->supported))
+		adv |= DW_C73_2500KX;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV3, adv);
+	if (ret < 0)
+		return ret;
+
+	/* SR_AN_ADV2 */
+	adv = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV2);
+	if (adv < 0)
+		return adv;
+
+	adv &= ~(DW_C73_1000KX | DW_C73_10000KX4 | DW_C73_10000KR);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+			      phydev->supported))
+		adv |= DW_C73_1000KX;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+			      phydev->supported))
+		adv |= DW_C73_10000KX4;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			      phydev->supported))
+		adv |= DW_C73_10000KR;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV2, adv);
+	if (ret < 0)
+		return ret;
+
+	/* SR_AN_ADV1 */
+	adv = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV1);
+	if (adv < 0)
+		return adv;
+
+	adv &= ~(DW_C73_PAUSE | DW_C73_ASYM_PAUSE);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported))
+		adv |= DW_C73_PAUSE;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      phydev->supported))
+		adv |= DW_C73_ASYM_PAUSE;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV1, adv);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int dw_config_aneg(struct phy_device *phydev)
+{
+	unsigned int retries = 12;
+	int val;
+
+	val = dw_config_aneg_c73(phydev);
+	if (val < 0)
+		return val;
+
+	val = phy_modify_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+			     MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART,
+			     MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
+	if (val < 0)
+		return val;
+
+	do {
+		msleep(50);
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		if (val < 0)
+			return val;
+	} while (val & MDIO_AN_CTRL1_RESTART && --retries);
+
+	if (val & MDIO_AN_CTRL1_RESTART)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int dw_aneg_done(struct phy_device *phydev)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_AN_STAT1_COMPLETE) {
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
+		if (val < 0)
+			return val;
+
+		/* Check if Aneg outcome is valid */
+		if (!(val & 0x1))
+			goto fault;
+
+		return 1;
+	}
+
+	if (val & MDIO_AN_STAT1_RFAULT)
+		goto fault;
+
+	return 0;
+fault:
+	dev_err(&phydev->mdio.dev, "Invalid Autoneg result!\n");
+	dev_err(&phydev->mdio.dev, "CTRL1=0x%x, STAT1=0x%x\n",
+		phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1),
+		phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1));
+	dev_err(&phydev->mdio.dev, "ADV1=0x%x, ADV2=0x%x, ADV3=0x%x\n",
+		phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV1),
+		phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV2),
+		phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV3));
+	dev_err(&phydev->mdio.dev, "LP_ADV1=0x%x, LP_ADV2=0x%x, LP_ADV3=0x%x\n",
+		phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL1),
+		phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL2),
+		phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL3));
+
+	val = dw_soft_reset(phydev, MDIO_DEVS_PCS);
+	if (val < 0)
+		return val;
+
+	return dw_config_aneg(phydev);
+}
+
+static int dw_read_lpa(struct phy_device *phydev)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	if (!(val & MDIO_AN_STAT1_COMPLETE)) {
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				   phydev->lp_advertising);
+		mii_10gbt_stat_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
+		mii_adv_mod_linkmode_adv_t(phydev->lp_advertising, 0);
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
+
+		return 0;
+	}
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising,
+			 val & MDIO_AN_STAT1_LPABLE);
+
+	/* Clause 73 outcome */
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL3);
+	if (val < 0)
+		return val;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+			 phydev->lp_advertising, val & DW_C73_2500KX);
+	/* TODO: 5G-KR */
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL2);
+	if (val < 0)
+		return val;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+			 phydev->lp_advertising, val & DW_C73_1000KX);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+			 phydev->lp_advertising, val & DW_C73_10000KX4);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			 phydev->lp_advertising, val & DW_C73_10000KR);
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
+	if (val < 0)
+		return val;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->lp_advertising,
+			 val & DW_C73_PAUSE);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 phydev->lp_advertising, val & DW_C73_ASYM_PAUSE);
+
+	phydev->pause = val & DW_C73_PAUSE ? 1 : 0;
+	phydev->asym_pause = val & DW_C73_ASYM_PAUSE ? 1 : 0;
+
+	linkmode_and(phydev->lp_advertising, phydev->lp_advertising,
+		     phydev->advertising);
+	return 0;
+}
+
+static int dw_read_status(struct phy_device *phydev)
+{
+	int val, stat, prev_link = phydev->link;
+	u32 mmd_mask = MDIO_DEVS_PCS;
+
+	phydev->link = false;
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		if (val < 0)
+			return val;
+
+		if (val & MDIO_AN_CTRL1_RESTART)
+			return 0;
+
+		mmd_mask |= MDIO_DEVS_AN;
+	}
+
+	val = dw_read_link(phydev, mmd_mask);
+	if (val < 0)
+		return val;
+
+	phydev->link = val;
+
+	stat = dw_read_fault(phydev);
+	if (stat) {
+		val = dw_soft_reset(phydev, MDIO_DEVS_PCS);
+		if (val < 0)
+			return val;
+
+		phydev->link = false;
+
+		return dw_config_aneg(phydev);
+	}
+
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		val = dw_aneg_done(phydev);
+		if (val <= 0) {
+			phydev->link = false;
+			return val;
+		}
+
+		val = dw_read_lpa(phydev);
+		if (val < 0)
+			return val;
+
+		phy_resolve_aneg_linkmode(phydev);
+	} else {
+		val = dw_read_pma(phydev);
+		if (val < 0)
+			return val;
+	}
+
+	if (phydev->link && !prev_link) {
+		val = dw_config_usxgmii(phydev);
+		if (val < 0)
+			return val;
+	}
+
+	return 0;
+}
+
+static int dw_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	val = dw_soft_reset(phydev, MDIO_DEVS_PCS);
+	if (val < 0)
+		return val;
+
+	return dw_config_aneg(phydev);
+}
+
+static int dw_suspend(struct phy_device *phydev)
+{
+	return 0;
+}
+
+static int dw_resume(struct phy_device *phydev)
+{
+	int val;
+
+	val = dw_soft_reset(phydev, MDIO_DEVS_PCS);
+	if (val < 0)
+		return val;
+
+	return dw_config_aneg(phydev);
+}
+
+static struct phy_driver dw_drivers[] = {
+	{
+		.phy_id		= SYNOPSYS_XPHY_ID,
+		.phy_id_mask	= SYNOPSYS_XPHY_MASK,
+		.name		= "Synopsys 10G",
+		.get_features	= dw_get_features,
+		.soft_reset	= genphy_no_soft_reset,
+		.config_init	= dw_config_init,
+		.suspend	= dw_suspend,
+		.resume		= dw_resume,
+		.config_aneg	= dw_config_aneg,
+		.aneg_done	= dw_aneg_done,
+		.read_status	= dw_read_status,
+	},
+};
+module_phy_driver(dw_drivers);
+
+static struct mdio_device_id __maybe_unused dw_tbl[] = {
+	{ SYNOPSYS_XPHY_ID, SYNOPSYS_XPHY_MASK },
+	{ },
+};
+MODULE_DEVICE_TABLE(mdio, dw_tbl);
+MODULE_DESCRIPTION("Synopsys DesignWare PHYs driver");
+MODULE_LICENSE("GPL");
-- 
2.7.4

