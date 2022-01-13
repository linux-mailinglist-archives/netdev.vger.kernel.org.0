Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650E048D54C
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiAMJ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 04:56:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:21256 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232227AbiAMJ4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 04:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642067815; x=1673603815;
  h=from:to:cc:subject:date:message-id;
  bh=1F6Syt4etkdduZ3B/BUPPh56aIVAn6EAxdLQbjXRbPs=;
  b=f18j+xNg93PbXTQgyZMih7OeLSigGr5wkk61PPQWpAtsofJysdrMw9k1
   2tfJVipAgMB/dBmuLSycLhS5QnRlcRswxihNLChrxtXsj9i2ohUOu4cLH
   MiPlpFc53U9a4t/gqDzQjqBOXXAUJs6eHxUzUqACZu8kJP3BPQPAK553O
   6HBdFB8Hlf1Z05tj+jbYz11CUHrtXuuqG60VVQ4rL9OCiifm6gEt34Jfy
   7uVMLa5+tMOS5hJk/oEgiQSC2kzKhmuoi0wAg82u7DUE7eZsAigUHS0AJ
   IeaWeCtMeDJN1kjM74utvFTb3SlRdgapld2EueIlyl71qxgdIo3dT94AC
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="307321915"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="307321915"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 01:56:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="613897881"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2022 01:56:52 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com, stable@vger.kernel.org
Subject: [PATCH net v3] net: phy: marvell: add Marvell specific PHY loopback
Date:   Thu, 13 Jan 2022 17:56:04 +0800
Message-Id: <20220113095604.31827-1-mohammad.athari.ismail@intel.com>
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
v3 changelog:
- Use phy_write() to configure speed for BMCR.
- Add error handling.
All commented by Russell King <linux@armlinux.org.uk>

v2 changelog:
- For loopback enabled, add bit-6 and bit-13 configuration in both Page
  0 Register 0 and Page 2 Register 21. Commented by Heiner Kallweit
<hkallweit1@gmail.com>.
- For loopback disabled, follow genphy_loopback() implementation
---
 drivers/net/phy/marvell.c | 56 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..5c371c2de9a0 100644
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
@@ -1932,6 +1934,58 @@ static void marvell_get_stats(struct phy_device *phydev,
 		data[i] = marvell_get_stat(phydev, i);
 }
 
+static int marvell_loopback(struct phy_device *phydev, bool enable)
+{
+	int err;
+
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
+		err = phy_write(phydev, MII_BMCR, bmcr_ctl);
+		if (err < 0)
+			return err;
+
+		if (phydev->speed == SPEED_1000)
+			mscr2_ctl = BMCR_SPEED1000;
+		else if (phydev->speed == SPEED_100)
+			mscr2_ctl = BMCR_SPEED100;
+
+		err = phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
+				       MII_88E1510_MSCR_2, BMCR_SPEED1000 |
+				       BMCR_SPEED100, mscr2_ctl);
+		if (err < 0)
+			return err;
+
+		/* Need soft reset to have speed configuration takes effect */
+		err = genphy_soft_reset(phydev);
+		if (err < 0)
+			return err;
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
+		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
+		if (err < 0)
+			return err;
+
+		return phy_config_aneg(phydev);
+	}
+}
+
 static int marvell_vct5_wait_complete(struct phy_device *phydev)
 {
 	int i;
@@ -3078,7 +3132,7 @@ static struct phy_driver marvell_drivers[] = {
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

