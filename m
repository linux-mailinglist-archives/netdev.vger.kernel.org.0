Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5827B41C403
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343570AbhI2MBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:01:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:62642 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244864AbhI2MBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:01:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224578364"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="224578364"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 04:59:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="617472835"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2021 04:59:30 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 491AA580223;
        Wed, 29 Sep 2021 04:59:27 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wong Vee Khee <veekhee@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net v2 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Date:   Wed, 29 Sep 2021 20:05:34 +0800
Message-Id: <20210929120534.411157-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Synopsys DesignWare Cores Ethernet PCS databook, it is
required to disable Clause 37 auto-negotiation by programming bit-12
(AN_ENABLE) to 0 if it is already enabled, before programming various
fields of VR_MII_AN_CTRL registers.

After all these programming are done, it is then required to enable
Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.

Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
v1 -> v2:
 - Removed use of xpcs_modify() helper function.
 - Add conditional check on inband auto-negotiation.

 drivers/net/pcs/pcs-xpcs.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fb0a83dc09ac..f34d5caeaba1 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -700,11 +700,14 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	int ret;
 
 	/* For AN for C37 SGMII mode, the settings are :-
-	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
-	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
+	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 0b (Disable SGMII AN in case
+	      it is already enabled)
+	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
+	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
 	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
-	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
+	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] = 1b (Automatic
 	 *    speed/duplex mode change by HW after SGMII AN complete)
+	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable SGMII AN)
 	 *
 	 * Note: Since it is MAC side SGMII, there is no need to set
 	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
@@ -712,6 +715,12 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	 *	 between PHY and Link Partner. There is also no need to
 	 *	 trigger AN restart for MAC-side SGMII.
 	 */
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (ret < 0)
+		return ret;
+	ret &= ~AN_CL37_EN;
+	xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
+
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
 	if (ret < 0)
 		return ret;
@@ -736,7 +745,20 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	else
 		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 
-	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (ret < 0)
+		return ret;
+
+	if (phylink_autoneg_inband(mode))
+		ret |= AN_CL37_EN;
+	else
+		ret &= ~AN_CL37_EN;
+
+	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
 }
 
 static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
-- 
2.25.1

