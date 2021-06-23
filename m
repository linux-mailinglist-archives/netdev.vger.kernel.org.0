Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E923B1AC9
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFWNMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:12:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:44388 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhFWNMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 09:12:03 -0400
IronPort-SDR: K7DGkeF+0S3RHlDnQxQnJ8AThy31G7ZKdaGX4zPwj8bcrmDq4TaB0aJNI0Qi8a3HjHVhDwOptr
 Fq/V7t5BBQ1A==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="207298336"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="207298336"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 06:09:43 -0700
IronPort-SDR: 2Ww2ltAuTia9bEXIEITK6bMG3yryraNj/ALZPhjl0EP0LIDbqlM4jW780cX+L5EK4KkwU16Bwb
 Ohu1C6R4Cejg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="641979134"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jun 2021 06:09:39 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marek Behun <marek.behun@nic.cz>, weifeng.voon@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        pei.lee.ling@intel.com
Subject: [PATCH net-next] net: phy: marvell10g: enable WoL for mv2110
Date:   Wed, 23 Jun 2021 21:09:29 +0800
Message-Id: <20210623130929.805559-1-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Basically it is just to enable to WoL interrupt and enable WoL detection.
Then, configure the MAC address into address detection register.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ling PeiLee <pei.lee.ling@intel.com>
---
 drivers/net/phy/marvell10g.c | 102 +++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bbbc6ac8fa82..93410ece83af 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -28,6 +28,7 @@
 #include <linux/marvell_phy.h>
 #include <linux/phy.h>
 #include <linux/sfp.h>
+#include <linux/netdevice.h>
 
 #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
@@ -106,6 +107,17 @@ enum {
 	MV_V2_TEMP_CTRL_DISABLE	= 0xc000,
 	MV_V2_TEMP		= 0xf08c,
 	MV_V2_TEMP_UNKNOWN	= 0x9600, /* unknown function */
+	MV_V2_MAGIC_PKT_WORD0	= 0xf06b,
+	MV_V2_MAGIC_PKT_WORD1	= 0xf06c,
+	MV_V2_MAGIC_PKT_WORD2	= 0xf06d,
+	/* Wake on LAN registers */
+	MV_V2_WOL_CTRL		= 0xf06e,
+	MV_V2_WOL_STS		= 0xf06f,
+	MV_V2_WOL_CLEAR_STS	= BIT(15),
+	MV_V2_WOL_MAGIC_PKT_EN	= BIT(0),
+	MV_V2_PORT_INTR_STS	= 0xf040,
+	MV_V2_PORT_INTR_MASK	= 0xf043,
+	MV_V2_WOL_INTR_EN	= BIT(8),
 };
 
 struct mv3310_chip {
@@ -991,6 +1003,94 @@ static int mv2111_match_phy_device(struct phy_device *phydev)
 	return mv211x_match_phy_device(phydev, false);
 }
 
+static void mv2110_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
+{
+	int ret = 0;
+
+	wol->supported = WAKE_MAGIC;
+	wol->wolopts = 0;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_WOL_CTRL);
+
+	if (ret & MV_V2_WOL_MAGIC_PKT_EN)
+		wol->wolopts |= WAKE_MAGIC;
+}
+
+static int mv2110_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
+{
+	int ret = 0;
+
+	if (wol->wolopts & WAKE_MAGIC) {
+		/* Enable the WOL interrupt */
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+				       MV_V2_PORT_INTR_MASK,
+				       MV_V2_WOL_INTR_EN);
+
+		if (ret < 0)
+			return ret;
+
+		/* Store the device address for the magic packet */
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MV_V2_MAGIC_PKT_WORD2,
+				    ((phydev->attached_dev->dev_addr[5] << 8) |
+				    phydev->attached_dev->dev_addr[4]));
+
+		if (ret < 0)
+			return ret;
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MV_V2_MAGIC_PKT_WORD1,
+				    ((phydev->attached_dev->dev_addr[3] << 8) |
+				    phydev->attached_dev->dev_addr[2]));
+
+		if (ret < 0)
+			return ret;
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MV_V2_MAGIC_PKT_WORD0,
+				    ((phydev->attached_dev->dev_addr[1] << 8) |
+				    phydev->attached_dev->dev_addr[0]));
+
+		if (ret < 0)
+			return ret;
+
+		/* Clear WOL status and enable magic packet matching */
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+				       MV_V2_WOL_CTRL,
+				       MV_V2_WOL_MAGIC_PKT_EN |
+				       MV_V2_WOL_CLEAR_STS);
+
+		if (ret < 0)
+			return ret;
+
+		/* Reset the clear WOL status bit as it does not self-clear */
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+					 MV_V2_WOL_CTRL,
+					 MV_V2_WOL_CLEAR_STS);
+
+		if (ret < 0)
+			return ret;
+	} else {
+		/* Disable magic packet matching & reset WOL status bit */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
+				     MV_V2_WOL_CTRL,
+				     MV_V2_WOL_MAGIC_PKT_EN,
+				     MV_V2_WOL_CLEAR_STS);
+
+		if (ret < 0)
+			return ret;
+
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+					 MV_V2_WOL_CTRL,
+					 MV_V2_WOL_CLEAR_STS);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
@@ -1045,6 +1145,8 @@ static struct phy_driver mv3310_drivers[] = {
 		.set_tunable	= mv3310_set_tunable,
 		.remove		= mv3310_remove,
 		.set_loopback	= genphy_c45_loopback,
+		.get_wol	= mv2110_get_wol,
+		.set_wol	= mv2110_set_wol,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
-- 
2.25.1

