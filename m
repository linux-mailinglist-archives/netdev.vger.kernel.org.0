Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D802AD312F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfJJTNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:13:02 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43005 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfJJTNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:13:01 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46q1224Vmxz1rGRn;
        Thu, 10 Oct 2019 21:12:58 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46q1223hQjz1qqkH;
        Thu, 10 Oct 2019 21:12:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id b6sCyHTEg_-T; Thu, 10 Oct 2019 21:12:56 +0200 (CEST)
X-Auth-Info: BrBHUsNnTOAfbyPisCUUCfAeubqcEBkzIihwpJro9PI=
Received: from chi.lan (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 10 Oct 2019 21:12:56 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
Date:   Thu, 10 Oct 2019 21:12:48 +0200
Message-Id: <20191010191249.2112-1-marex@denx.de>
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
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
NOTE: It was also suggested to populate phydev->dev_flags to discern
      the PHY from the switch, this does not work for setups where
      the switch is used as a PHY without a DSA driver. Checking the
      BMSR Bit 0 for Extended Capability Register works for both DSA
      and non-DSA usecase.
---
 drivers/net/phy/micrel.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2fea5541c35a..54d483de024f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -341,6 +341,22 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static int ksz8051_match_phy_device(struct phy_device *phydev)
+{
+	int ret;
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
+	return ret & BMSR_ERCAP;
+}
+
 static int ksz8081_config_init(struct phy_device *phydev)
 {
 	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
@@ -364,6 +380,18 @@ static int ksz8061_config_init(struct phy_device *phydev)
 	return kszphy_config_init(phydev);
 }
 
+static int ksz8795_match_phy_device(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_BMSR);
+	if (ret < 0)
+		return ret;
+
+	/* See comment in ksz8051_match_phy_device() for details. */
+	return !(ret & BMSR_ERCAP);
+}
+
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
 				       const struct device_node *of_node,
 				       u16 reg,
@@ -1029,6 +1057,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
+	.match_phy_device = ksz8051_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -1148,6 +1177,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
 	.read_status	= ksz8873mll_read_status,
+	.match_phy_device = ksz8795_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-- 
2.23.0

