Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8CA1E2420
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgEZObw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgEZObv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:31:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94604C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G3Idkwe8ypES0g9vtfOef5SEE/95VebTO311mQYGeEo=; b=I1TiL+3YbbS4WZ9lxls7Ic596Q
        gFBDYMIOAKrOHGBFtrJiZfhppKGeoSRVq1riwG9hqhLEIg4LlpmNmhBVaTFJzXtdsgDSnO2Mf2OAx
        M2nf9hQX805k89znyR9s30puSiGIXSMeggvhlPvZc/OvAEVUeTHSON47H9ZTunNd72TsDT6AC9rEM
        qLTToAXcYRBxwwxX4FXgKcxKPM2QJzGBYcPqGIL2n6BjxAau3MZLtLLgq0ZvL8dOFw47P+zsHnQn9
        YBny4jLHeFs3N5YshiqvUIw81YK9j86w6HgVNZSRTXj/MqVthlZZ+HnD0Z11sIzAXP51YjUkP9msW
        7xu+GoaA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37040 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdac5-00080w-LI; Tue, 26 May 2020 15:31:29 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdac2-0005sv-W5; Tue, 26 May 2020 15:31:27 +0100
In-Reply-To: <20200526142948.GY1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC 6/7] net: phy: split devices_in_package
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdac2-0005sv-W5@rmk-PC.armlinux.org.uk>
Date:   Tue, 26 May 2020 15:31:26 +0100
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

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy-c45.c    | 4 ++--
 drivers/net/phy/phy_device.c | 6 +++---
 drivers/net/phy/phylink.c    | 8 ++++----
 include/linux/phy.h          | 4 +++-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 8cd952950a75..4b5805e2bd0e 100644
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
@@ -397,7 +397,7 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
 	int val;
 
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
-	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
+	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
 		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
 		if (val < 0)
 			return val;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a483d79cfc87..1c948bbf4fa0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -707,9 +707,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
 		return -EIO;
 	*devices_in_package |= phy_reg;
 
-	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
-	*devices_in_package &= ~BIT(0);
-
 	return 0;
 }
 
@@ -788,6 +785,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 	}
 
 	c45_ids->devices_in_package = devs_in_pkg;
+	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
+	c45_ids->mmds_present = devs_in_pkg & ~BIT(0);
 
 	*phy_id = 0;
 	return 0;
@@ -842,6 +841,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	int r;
 
 	c45_ids.devices_in_package = 0;
+	c45_ids.mmds_present = 0;
 	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
 
 	if (is_c45)
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6defd5eddd58..b548e0418694 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1709,11 +1709,11 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
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
@@ -1749,11 +1749,11 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
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
index 41c046545354..0d41c710339a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -354,11 +354,13 @@ enum phy_state {
 
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

