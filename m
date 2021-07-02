Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C2A3B9D4F
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhGBIHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:07:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:3639 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhGBIHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 04:07:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="189075908"
X-IronPort-AV: E=Sophos;i="5.83,316,1616482800"; 
   d="scan'208";a="189075908"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 01:05:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,316,1616482800"; 
   d="scan'208";a="455878774"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by orsmga008.jf.intel.com with ESMTP; 02 Jul 2021 01:05:12 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marek Behun <marek.behun@nic.cz>, weifeng.voon@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        pei.lee.ling@intel.com
Subject: [PATCH net-next V3] net: phy: marvell10g: enable WoL for 88X3310 and 88E2110
Date:   Fri,  2 Jul 2021 16:04:54 +0800
Message-Id: <20210702080454.1688190-1-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Implement Wake-on-LAN feature for 88X3310 and 88E2110.

This is done by enabling WoL interrupt and WoL detection and
configuring MAC address into WoL magic packet registers

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ling PeiLee <pei.lee.ling@intel.com>
---
Change Log:
 V3: 
 (1) Update the commit message which is suggested by Marek.
 (2) Change patch title.
 (3) Remove MV_V2_WOL_STS register definition where it is not used.
 (4) Rename MV_V2_WOL_INTR_EN, MV_V2_WOL_CLEAR_STS and 
     MV_V2_WOL_MAGIC_PKT_EN.
 (5) Move change log to signedoff below.
 (6) Fix indention problem in code.
 (7) Reorganize newly added register definition in recommeded order.
 (8) Change function name from mv2110{get|set}_wol to mv3110{get|set}_wol.
 (9) Fix mv3110{get|set}_wol characters exceed 80.
 V2:
 (1) Reviewer Marek request to rorganize code to readable way.
 (2) Reviewer Rusell request to put phy_clear_bits_mmd() outside of if(){}else{}
     and modify return ret to return phy_clear_bits_mmd().
 (3) Reviewer Rusell request to add return on phy_read_mmd() in set_wol().
 (4) Reorganize register layout to be put before MV_V2_TEMP_CTRL.
 (5) Add the .{get|set}_wol for 88E3110 too as per feedback from Russell.

 drivers/net/phy/marvell10g.c | 89 ++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bbbc6ac8fa82..926a08635938 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -28,6 +28,7 @@
 #include <linux/marvell_phy.h>
 #include <linux/phy.h>
 #include <linux/sfp.h>
+#include <linux/netdevice.h>
 
 #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
@@ -99,6 +100,16 @@ enum {
 	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN	= 0x5,
 	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
 	MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII			= 0x7,
+	MV_V2_PORT_INTR_STS	= 0xf040,
+	MV_V2_PORT_INTR_MASK	= 0xf043,
+	MV_V2_PORT_INTR_STS_WOL_EN	= BIT(8),
+	MV_V2_MAGIC_PKT_WORD0	= 0xf06b,
+	MV_V2_MAGIC_PKT_WORD1	= 0xf06c,
+	MV_V2_MAGIC_PKT_WORD2	= 0xf06d,
+	/* Wake on LAN registers */
+	MV_V2_WOL_CTRL		= 0xf06e,
+	MV_V2_WOL_CTRL_CLEAR_STS	= BIT(15),
+	MV_V2_WOL_CTRL_MAGIC_PKT_EN	= BIT(0),
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -991,6 +1002,80 @@ static int mv2111_match_phy_device(struct phy_device *phydev)
 	return mv211x_match_phy_device(phydev, false);
 }
 
+static void mv3110_get_wol(struct phy_device *phydev,
+			   struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	wol->supported = WAKE_MAGIC;
+	wol->wolopts = 0;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_WOL_CTRL);
+	if (ret < 0)
+		return;
+
+	if (ret & MV_V2_WOL_CTRL_MAGIC_PKT_EN)
+		wol->wolopts |= WAKE_MAGIC;
+}
+
+static int mv3110_set_wol(struct phy_device *phydev,
+			  struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	if (wol->wolopts & WAKE_MAGIC) {
+		/* Enable the WOL interrupt */
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+				       MV_V2_PORT_INTR_MASK,
+				       MV_V2_PORT_INTR_STS_WOL_EN);
+		if (ret < 0)
+			return ret;
+
+		/* Store the device address for the magic packet */
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MV_V2_MAGIC_PKT_WORD2,
+				    ((phydev->attached_dev->dev_addr[5] << 8) |
+				    phydev->attached_dev->dev_addr[4]));
+		if (ret < 0)
+			return ret;
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MV_V2_MAGIC_PKT_WORD1,
+				    ((phydev->attached_dev->dev_addr[3] << 8) |
+				    phydev->attached_dev->dev_addr[2]));
+		if (ret < 0)
+			return ret;
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MV_V2_MAGIC_PKT_WORD0,
+				    ((phydev->attached_dev->dev_addr[1] << 8) |
+				    phydev->attached_dev->dev_addr[0]));
+		if (ret < 0)
+			return ret;
+
+		/* Clear WOL status and enable magic packet matching */
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+				       MV_V2_WOL_CTRL,
+				       MV_V2_WOL_CTRL_MAGIC_PKT_EN |
+				       MV_V2_WOL_CTRL_CLEAR_STS);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* Disable magic packet matching & reset WOL status bit */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
+				     MV_V2_WOL_CTRL,
+				     MV_V2_WOL_CTRL_MAGIC_PKT_EN,
+				     MV_V2_WOL_CTRL_CLEAR_STS);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Reset the clear WOL status bit as it does not self-clear */
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+				  MV_V2_WOL_CTRL,
+				  MV_V2_WOL_CTRL_CLEAR_STS);
+}
+
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
@@ -1009,6 +1094,8 @@ static struct phy_driver mv3310_drivers[] = {
 		.set_tunable	= mv3310_set_tunable,
 		.remove		= mv3310_remove,
 		.set_loopback	= genphy_c45_loopback,
+		.get_wol	= mv3110_get_wol,
+		.set_wol	= mv3110_set_wol,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3340,
@@ -1045,6 +1132,8 @@ static struct phy_driver mv3310_drivers[] = {
 		.set_tunable	= mv3310_set_tunable,
 		.remove		= mv3310_remove,
 		.set_loopback	= genphy_c45_loopback,
+		.get_wol	= mv3110_get_wol,
+		.set_wol	= mv3110_set_wol,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
-- 
2.25.1

