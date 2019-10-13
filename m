Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA09D584F
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 23:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfJMVYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 17:24:14 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50805 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMVYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 17:24:14 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46rvp24Q45z1qqkc;
        Sun, 13 Oct 2019 23:24:10 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46rvp23TN3z1qqkC;
        Sun, 13 Oct 2019 23:24:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id F7C6tESZE0NI; Sun, 13 Oct 2019 23:24:08 +0200 (CEST)
X-Auth-Info: ZvhpMPp/CNpIy2Go/7ean5kJPfrwyMpQvwBnT7K4HWw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 13 Oct 2019 23:24:08 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH net V4 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
Date:   Sun, 13 Oct 2019 23:24:03 +0200
Message-Id: <20191013212404.31708-1-marex@denx.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
in the micrel PHY driver, it is used even with the KSZ87xx switch. This
is wrong, since the KSZ8051 configures registers of the PHY which are
not present on the simplified KSZ87xx switch PHYs and misconfigures
other registers of the KSZ87xx switch PHYs.

Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
KSZ87xx switch by checking the Basic Status register Bit 0, which is
read-only and indicates presence of the Extended Capability Registers.
The KSZ8051 PHY has those registers while the KSZ87xx switch does not.

This patch implements simple check for the presence of this bit for
both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
PHY driver instance.

Signed-off-by: Marek Vasut <marex@denx.de>
Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
NOTE: It was also suggested to populate phydev->dev_flags to discern
      the PHY from the switch, this does not work for setups where
      the switch is used as a PHY without a DSA driver. Checking the
      BMSR Bit 0 for Extended Capability Register works for both DSA
      and non-DSA usecase.
V2: Move phy_id check into ksz8051_match_phy_device() and
    ksz8795_match_phy_device() and drop phy_id{,_mask} from the
    ksphy_driver[] list to avoid matching on other PHY IDs.
V3: Pull the logic behind discerning the KSZ8051 PHY and KSZ87xx switch
    into common ksz8051_ksz8795_match_phy_device() function. Add Fixes
    tag.
V4: No functional change at all. Just reorder the Fixes: tag to the
    correct place above the Cc tags and add another net tag after
    PATCH into subject.
---
 drivers/net/phy/micrel.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2fea5541c35a..a0444e28c6e7 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -341,6 +341,35 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
+					    const u32 ksz_phy_id)
+{
+	int ret;
+
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
+		return 0;
+
+	ret = phy_read(phydev, MII_BMSR);
+	if (ret < 0)
+		return ret;
+
+	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
+	 * exact PHY ID. However, they can be told apart by the extended
+	 * capability registers presence. The KSZ8051 PHY has them while
+	 * the switch does not.
+	 */
+	ret &= BMSR_ERCAP;
+	if (ksz_phy_id == PHY_ID_KSZ8051)
+		return ret;
+	else
+		return !ret;
+}
+
+static int ksz8051_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+}
+
 static int ksz8081_config_init(struct phy_device *phydev)
 {
 	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
@@ -364,6 +393,11 @@ static int ksz8061_config_init(struct phy_device *phydev)
 	return kszphy_config_init(phydev);
 }
 
+static int ksz8795_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8795);
+}
+
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
 				       const struct device_node *of_node,
 				       u16 reg,
@@ -1017,8 +1051,6 @@ static struct phy_driver ksphy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8051,
-	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8051",
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ksz8051_type,
@@ -1029,6 +1061,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
+	.match_phy_device = ksz8051_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8795,
-	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8795",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
 	.read_status	= ksz8873mll_read_status,
+	.match_phy_device = ksz8795_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-- 
2.23.0

