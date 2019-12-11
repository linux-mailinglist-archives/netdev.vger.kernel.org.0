Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDB811A962
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfLKK5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:57:20 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39626 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKK5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lsZmHwbh06aXamEHAQE69OWcnn7nMob90UIiQ5SZEyg=; b=YkKn1x++79fiR5uPLP3L8pv+/M
        b0/n9DDBVLfreqklzWCMwJ42ybzMyPoyKrN0bnXVHpEEAq/DMqW+zMxT7ynSQ4rj6b49YbRfX/pFL
        LLoiomA11ukAsj1xtYBos8US/kG8RH9QnsEXfSQz89LVBBGs3TmyZ5TfGjnJ5Kn7+/aXtaDpUBg3U
        UHLtrKi4jGJT0JmTbYvKGDyeeOa6y7ItDYzJ14xqAgmqxZXXi+M/+KaWQYmvsLo6az9lSnoN4t7bv
        5uRslnpBEF50JMVhTSyOL9DBN+00LZlRBU+QMubreJlENPOkkAIwCpEptnbot6daUfWSLR2IjDxGh
        8x8Ssiwg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56754 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfu-0007vp-Ra; Wed, 11 Dec 2019 10:56:59 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfs-0002z2-06; Wed, 11 Dec 2019 10:56:56 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 13/14] net: phy: add Broadcom BCM84881 PHY driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfs-0002z2-06@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:56 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a rudimentary Clause 45 driver for the BCM84881 PHY, found on
Methode DM7052 SFPs.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/Kconfig    |   6 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/bcm84881.c | 269 +++++++++++++++++++++++++++++++++++++
 3 files changed, 276 insertions(+)
 create mode 100644 drivers/net/phy/bcm84881.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index fe602648b99f..41272106dea9 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -329,6 +329,12 @@ config BROADCOM_PHY
 	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
 	  BCM5481, BCM54810 and BCM5482 PHYs.
 
+config BCM84881_PHY
+	bool "Broadcom BCM84881 PHY"
+	depends on PHYLIB=y
+	---help---
+	  Support the Broadcom BCM84881 PHY.
+
 config CICADA_PHY
 	tristate "Cicada PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a03437e091f3..d3b8152443e7 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+= bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
+obj-$(CONFIG_BCM84881_PHY)	+= bcm84881.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+= cortina.o
 obj-$(CONFIG_DAVICOM_PHY)	+= davicom.o
diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
new file mode 100644
index 000000000000..db59911b9b3c
--- /dev/null
+++ b/drivers/net/phy/bcm84881.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0
+// Broadcom BCM84881 NBASE-T PHY driver, as found on a SFP+ module.
+// Copyright (C) 2019 Russell King, Deep Blue Solutions Ltd.
+//
+// Like the Marvell 88x3310, the Broadcom 84881 changes its host-side
+// interface according to the operating speed between 10GBASE-R,
+// 2500BASE-X and SGMII (but unlike the 88x3310, without the control
+// word).
+//
+// This driver only supports those aspects of the PHY that I'm able to
+// observe and test with the SFP+ module, which is an incomplete subset
+// of what this PHY is able to support. For example, I only assume it
+// supports a single lane Serdes connection, but it may be that the PHY
+// is able to support more than that.
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+enum {
+	MDIO_AN_C22 = 0xffe0,
+};
+
+static int bcm84881_wait_init(struct phy_device *phydev)
+{
+	unsigned int tries = 20;
+	int ret, val;
+
+	do {
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
+		if (val < 0) {
+			ret = val;
+			break;
+		}
+		if (!(val & MDIO_CTRL1_RESET)) {
+			ret = 0;
+			break;
+		}
+		if (!--tries) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+		msleep(100);
+	} while (1);
+
+	if (ret)
+		phydev_err(phydev, "%s failed: %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int bcm84881_config_init(struct phy_device *phydev)
+{
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_2500BASEX:
+	case PHY_INTERFACE_MODE_10GKR:
+		break;
+	default:
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int bcm84881_probe(struct phy_device *phydev)
+{
+	/* This driver requires PMAPMD and AN blocks */
+	const u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
+
+	if (!phydev->is_c45 ||
+	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int bcm84881_get_features(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_c45_pma_read_abilities(phydev);
+	if (ret)
+		return ret;
+
+	/* Although the PHY sets bit 1.11.8, it does not support 10M modes */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+			   phydev->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+			   phydev->supported);
+
+	return 0;
+}
+
+static int bcm84881_config_aneg(struct phy_device *phydev)
+{
+	bool changed = false;
+	u32 adv;
+	int ret;
+
+	/* Wait for the PHY to finish initialising, otherwise our
+	 * advertisement may be overwritten.
+	 */
+	ret = bcm84881_wait_init(phydev);
+	if (ret)
+		return ret;
+
+	/* We don't support manual MDI control */
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
+	/* disabled autoneg doesn't seem to work with this PHY */
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return -EINVAL;
+
+	ret = genphy_c45_an_config_aneg(phydev);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = true;
+
+	adv = linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
+	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN,
+				     MDIO_AN_C22 + MII_CTRL1000,
+				     ADVERTISE_1000FULL | ADVERTISE_1000HALF,
+				     adv);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = true;
+
+	return genphy_c45_check_and_restart_aneg(phydev, changed);
+}
+
+static int bcm84881_aneg_done(struct phy_device *phydev)
+{
+	int bmsr, val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
+	if (bmsr < 0)
+		return val;
+
+	return !!(val & MDIO_AN_STAT1_COMPLETE) &&
+	       !!(bmsr & BMSR_ANEGCOMPLETE);
+}
+
+static int bcm84881_read_status(struct phy_device *phydev)
+{
+	unsigned int mode;
+	int bmsr, val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_AN_CTRL1_RESTART) {
+		phydev->link = 0;
+		return 0;
+	}
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
+	if (bmsr < 0)
+		return val;
+
+	phydev->autoneg_complete = !!(val & MDIO_AN_STAT1_COMPLETE) &&
+				   !!(bmsr & BMSR_ANEGCOMPLETE);
+	phydev->link = !!(val & MDIO_STAT1_LSTATUS) &&
+		       !!(bmsr & BMSR_LSTATUS);
+	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
+		phydev->link = false;
+
+	if (!phydev->link)
+		return 0;
+
+	linkmode_zero(phydev->lp_advertising);
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+	phydev->mdix = 0;
+
+	if (phydev->autoneg_complete) {
+		val = genphy_c45_read_lpa(phydev);
+		if (val < 0)
+			return val;
+
+		val = phy_read_mmd(phydev, MDIO_MMD_AN,
+				   MDIO_AN_C22 + MII_STAT1000);
+		if (val < 0)
+			return val;
+
+		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, val);
+
+		if (phydev->autoneg == AUTONEG_ENABLE)
+			phy_resolve_aneg_linkmode(phydev);
+	}
+
+	if (phydev->autoneg == AUTONEG_DISABLE) {
+		/* disabled autoneg doesn't seem to work, so force the link
+		 * down.
+		 */
+		phydev->link = 0;
+		return 0;
+	}
+
+	/* Set the host link mode - we set the phy interface mode and
+	 * the speed according to this register so that downshift works.
+	 * We leave the duplex setting as per the resolution from the
+	 * above.
+	 */
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, 0x4011);
+	mode = (val & 0x1e) >> 1;
+	if (mode == 1 || mode == 2)
+		phydev->interface = PHY_INTERFACE_MODE_SGMII;
+	else if (mode == 3)
+		phydev->interface = PHY_INTERFACE_MODE_10GKR;
+	else if (mode == 4)
+		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+	switch (mode & 7) {
+	case 1:
+		phydev->speed = SPEED_100;
+		break;
+	case 2:
+		phydev->speed = SPEED_1000;
+		break;
+	case 3:
+		phydev->speed = SPEED_10000;
+		break;
+	case 4:
+		phydev->speed = SPEED_2500;
+		break;
+	case 5:
+		phydev->speed = SPEED_5000;
+		break;
+	}
+
+	return genphy_c45_read_mdix(phydev);
+}
+
+static struct phy_driver bcm84881_drivers[] = {
+	{
+		.phy_id		= 0xae025150,
+		.phy_id_mask	= 0xfffffff0,
+		.name		= "Broadcom BCM84881",
+		.config_init	= bcm84881_config_init,
+		.probe		= bcm84881_probe,
+		.get_features	= bcm84881_get_features,
+		.config_aneg	= bcm84881_config_aneg,
+		.aneg_done	= bcm84881_aneg_done,
+		.read_status	= bcm84881_read_status,
+	},
+};
+
+module_phy_driver(bcm84881_drivers);
+
+/* FIXME: module auto-loading for Clause 45 PHYs seems non-functional */
+static struct mdio_device_id __maybe_unused bcm84881_tbl[] = {
+	{ 0xae025150, 0xfffffff0 },
+	{ },
+};
+MODULE_AUTHOR("Russell King");
+MODULE_DESCRIPTION("Broadcom BCM84881 PHY driver");
+MODULE_DEVICE_TABLE(mdio, bcm84881_tbl);
+MODULE_LICENSE("GPL");
-- 
2.20.1

