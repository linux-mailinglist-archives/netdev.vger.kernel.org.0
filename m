Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C941D26D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 06:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347348AbhI3EkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 00:40:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:53099 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhI3EkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 00:40:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="247634428"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="247634428"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 21:38:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="479667061"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 29 Sep 2021 21:38:16 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 923475807C8;
        Wed, 29 Sep 2021 21:38:13 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Date:   Thu, 30 Sep 2021 12:44:21 +0800
Message-Id: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
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

Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
v2 -> v3:
 - Added error handling after xpcs_write().
 - Added 'changed' flag.
 - Added fixes tag.
v1 -> v2:
 - Removed use of xpcs_modify() helper function.
 - Add conditional check on inband auto-negotiation.
---
 drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fb0a83dc09ac..d2126f5d5016 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -697,14 +697,18 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
 static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 {
-	int ret;
+	int ret, reg_val;
+	int changed = 0;
 
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
@@ -712,6 +716,19 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	 *	 between PHY and Link Partner. There is also no need to
 	 *	 trigger AN restart for MAC-side SGMII.
 	 */
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (ret < 0)
+		return ret;
+
+	if (ret & AN_CL37_EN) {
+		changed = 1;
+		reg_val = ret & ~AN_CL37_EN;
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 reg_val);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
 	if (ret < 0)
 		return ret;
@@ -736,7 +753,21 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	else
 		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 
-	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	if (ret < 0)
+		return ret;
+
+	if (changed) {
+		if (phylink_autoneg_inband(mode))
+			reg_val |= AN_CL37_EN;
+		else
+			reg_val &= ~AN_CL37_EN;
+
+		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				  reg_val);
+	}
+
+	return ret;
 }
 
 static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
-- 
2.25.1

