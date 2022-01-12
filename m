Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EDC48C111
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352098AbiALJen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:34:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:61179 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238079AbiALJee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 04:34:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641980074; x=1673516074;
  h=from:to:cc:subject:date:message-id;
  bh=7Ihay+nY/RB67tVnwCfgoiyLdn5DEIMTvTTTafjGIF8=;
  b=RCxI39Noj70U/2xGxKx340ojDl+c+2vMgf1RET7nbqSlGPbh6/cEzKY8
   9JAwR16ZTpe5z6Qmm8zJHc8MUKqlgVtwdUlf/O9tWrB2OYkgEa6RlN7vb
   UANW4GGC3KfwQTX6DvCI8ql0XxwJw+FoD6+fmsOKGqMyD5RiRNXkiC49a
   pmpkAcGYgMRT7Ds6OYcVTC71o5BuniZpVKo6oCNXceWUVYxKuozLTGPPf
   C64cWNam2tr6dJXUSMCn0RLvFIOQ5XEU/V5FkBPv7cM41qV3n4kLLRAab
   gFpP9YbhQ0pmJQEiHLpMvz84KNGRobKf5Svky6j0RTL53ZEu0lMg3Aipj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="304436339"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="304436339"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 01:34:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="474852142"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by orsmga006.jf.intel.com with ESMTP; 12 Jan 2022 01:34:31 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com, stable@vger.kernel.org
Subject: [PATCH net v2] net: phy: marvell: add Marvell specific PHY loopback
Date:   Wed, 12 Jan 2022 17:33:44 +0800
Message-Id: <20220112093344.27894-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing genphy_loopback() is not applicable for Marvell PHY. Besides
configuring bit-6 and bit-13 in Page 0 Register 0 (Copper Control
Register), it is also required to configure same bits  in Page 2
Register 21 (MAC Specific Control Register 2) according to speed of
the loopback is operating.

Tested working on Marvell88E1510 PHY for all speeds (1000/100/10Mbps).

FIXME: Based on trial and error test, it seem 1G need to have delay between
soft reset and loopback enablement.

Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
v2 changelog:
- For loopback enabled, add bit-6 and bit-13 configuration in both Page
  0 Register 0 and Page 2 Register 21. Commented by Heiner Kallweit
<hkallweit1@gmail.com>.
- For loopback disabled, follow genphy_loopback() implementation. 
---
 drivers/net/phy/marvell.c | 46 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..51ca2cc05e10 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -189,6 +189,8 @@
 #define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_SGMII	0x4
 #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
 
+#define MII_88E1510_MSCR_2		0x15
+
 #define MII_VCT5_TX_RX_MDI0_COUPLING	0x10
 #define MII_VCT5_TX_RX_MDI1_COUPLING	0x11
 #define MII_VCT5_TX_RX_MDI2_COUPLING	0x12
@@ -1932,6 +1934,48 @@ static void marvell_get_stats(struct phy_device *phydev,
 		data[i] = marvell_get_stat(phydev, i);
 }
 
+static int marvell_loopback(struct phy_device *phydev, bool enable)
+{
+	if (enable) {
+		u16 bmcr_ctl = 0, mscr2_ctl = 0;
+
+		if (phydev->speed == SPEED_1000)
+			bmcr_ctl = BMCR_SPEED1000;
+		else if (phydev->speed == SPEED_100)
+			bmcr_ctl = BMCR_SPEED100;
+
+		if (phydev->duplex == DUPLEX_FULL)
+			bmcr_ctl |= BMCR_FULLDPLX;
+
+		phy_modify(phydev, MII_BMCR, ~0, bmcr_ctl);
+
+		if (phydev->speed == SPEED_1000)
+			mscr2_ctl = BMCR_SPEED1000;
+		else if (phydev->speed == SPEED_100)
+			mscr2_ctl = BMCR_SPEED100;
+
+		phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
+				 MII_88E1510_MSCR_2, BMCR_SPEED1000 |
+				 BMCR_SPEED100, mscr2_ctl);
+
+		/* Need soft reset to have speed configuration takes effect */
+		genphy_soft_reset(phydev);
+
+		/* FIXME: Based on trial and error test, it seem 1G need to have
+		 * delay between soft reset and loopback enablement.
+		 */
+		if (phydev->speed == SPEED_1000)
+			msleep(1000);
+
+		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+				  BMCR_LOOPBACK);
+	} else {
+		phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
+
+		return phy_config_aneg(phydev);
+	}
+}
+
 static int marvell_vct5_wait_complete(struct phy_device *phydev)
 {
 	int i;
@@ -3078,7 +3122,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
-		.set_loopback = genphy_loopback,
+		.set_loopback = marvell_loopback,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,
-- 
2.17.1

