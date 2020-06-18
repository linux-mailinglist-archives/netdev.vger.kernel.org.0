Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEAD1FF399
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgFRNqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:46:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A4EC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c5EYXBUA6JHOW++t9/AVmLJY5WpXj+zVIvj3AvtRrRo=; b=o1MV7SH7ZMFC2FDaLerIakIXFl
        yJzCQbQ31+luvi//W93ykIOtOPnsICYr7AJHjp0uSRFr+2xpXeXwYqqWy7N4Wn2ijdcTwLHBD3XRN
        2tCtN3qoHLT0m8wTTiVa9DRD8mf+Mcr4nocUi8kdH0a+6TUe6fV3tg8MU0i2ODSG8aRRPooCE/CeI
        y0inBQs9hAOYHOyaVeQXkLpe1SKEwxB+qALpgwxC9xd8vJkbUsvaz5W3Q8EbSaBPX7211XHVRjh9t
        CSrnweznPgDKONEXNDahyOig8Qwr+8snMQamLRksyJzt3iq3K1Me5DDbwqNw2C3ZaqUz/y9/G+SS+
        B+j1NVMQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37658 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jluro-0005BQ-Se; Thu, 18 Jun 2020 14:46:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jluro-0004kr-Kl; Thu, 18 Jun 2020 14:46:08 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 8/9] net: phy: split devices_in_package
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jluro-0004kr-Kl@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:46:08 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have two competing requirements for the devices_in_package field.
We want to use it as a bit array indicating which MMDs are present, but
we also want to know if the Clause 22 registers are present.

Since "devices in package" is a term used in the 802.3 specification,
keep this as the as-specified values read from the PHY, and introduce
a new member "mmds_present" to indicate which MMDs are actually
present in the PHY, derived from the "devices in package" value.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy-c45.c    | 4 ++--
 drivers/net/phy/phy_device.c | 6 +++---
 drivers/net/phy/phylink.c    | 8 ++++----
 include/linux/phy.h          | 4 +++-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index defe09d94422..bd11e62bfdfe 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -219,7 +219,7 @@ int genphy_c45_read_link(struct phy_device *phydev)
 	int val, devad;
 	bool link = true;
 
-	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
+	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
 		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
 		if (val < 0)
 			return val;
@@ -409,7 +409,7 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
 	int val;
 
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
-	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
+	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
 		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
 		if (val < 0)
 			return val;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8e11e3d3a801..c1f81c4d0bb3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -709,9 +709,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
 		return -EIO;
 	*devices_in_package |= phy_reg;
 
-	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
-	*devices_in_package &= ~BIT(0);
-
 	return 0;
 }
 
@@ -789,6 +786,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 	}
 
 	c45_ids->devices_in_package = devs_in_pkg;
+	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
+	c45_ids->mmds_present = devs_in_pkg & ~BIT(0);
 
 	return 0;
 }
@@ -857,6 +856,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	int r;
 
 	c45_ids.devices_in_package = 0;
+	c45_ids.mmds_present = 0;
 	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
 
 	if (is_c45)
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0ab65fb75258..7ce787c227b3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1638,11 +1638,11 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
 		case MII_BMSR:
 		case MII_PHYSID1:
 		case MII_PHYSID2:
-			devad = __ffs(phydev->c45_ids.devices_in_package);
+			devad = __ffs(phydev->c45_ids.mmds_present);
 			break;
 		case MII_ADVERTISE:
 		case MII_LPA:
-			if (!(phydev->c45_ids.devices_in_package & MDIO_DEVS_AN))
+			if (!(phydev->c45_ids.mmds_present & MDIO_DEVS_AN))
 				return -EINVAL;
 			devad = MDIO_MMD_AN;
 			if (reg == MII_ADVERTISE)
@@ -1678,11 +1678,11 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
 		case MII_BMSR:
 		case MII_PHYSID1:
 		case MII_PHYSID2:
-			devad = __ffs(phydev->c45_ids.devices_in_package);
+			devad = __ffs(phydev->c45_ids.mmds_present);
 			break;
 		case MII_ADVERTISE:
 		case MII_LPA:
-			if (!(phydev->c45_ids.devices_in_package & MDIO_DEVS_AN))
+			if (!(phydev->c45_ids.mmds_present & MDIO_DEVS_AN))
 				return -EINVAL;
 			devad = MDIO_MMD_AN;
 			if (reg == MII_ADVERTISE)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index abe318387331..19d9e040ad84 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -392,11 +392,13 @@ enum phy_state {
 
 /**
  * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
- * @devices_in_package: Bit vector of devices present.
+ * @devices_in_package: IEEE 802.3 devices in package register value.
+ * @mmds_present: bit vector of MMDs present.
  * @device_ids: The device identifer for each present device.
  */
 struct phy_c45_device_ids {
 	u32 devices_in_package;
+	u32 mmds_present;
 	u32 device_ids[8];
 };
 
-- 
2.20.1

