Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F66421D04
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 05:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhJEDlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 23:41:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:55059 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhJEDlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 23:41:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="225957957"
X-IronPort-AV: E=Sophos;i="5.85,347,1624345200"; 
   d="scan'208";a="225957957"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 20:39:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,347,1624345200"; 
   d="scan'208";a="544610054"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 04 Oct 2021 20:39:12 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id ABF72580A6C;
        Mon,  4 Oct 2021 20:39:09 -0700 (PDT)
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
Subject: [PATCH net v4 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Date:   Tue,  5 Oct 2021 11:45:21 +0800
Message-Id: <20211005034521.534125-1-vee.khee.wong@linux.intel.com>
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
v3 -> v4:
 - Removed redunctant 'changed' variable.
v2 -> v3:
 - Added error handling after xpcs_write().
 - Added 'changed' flag.
 - Added fixes tag.
v1 -> v2:
 - Removed use of xpcs_modify() helper function.
 - Add conditional check on inband auto-negotiation.
---
 drivers/net/pcs/pcs-xpcs.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fb0a83dc09ac..a3e806cfa684 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -697,14 +697,17 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
 static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 {
-	int ret;
+	int ret, mdio_ctrl;
 
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
@@ -712,6 +715,17 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	 *	 between PHY and Link Partner. There is also no need to
 	 *	 trigger AN restart for MAC-side SGMII.
 	 */
+	mdio_ctrl = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (mdio_ctrl < 0)
+		return mdio_ctrl;
+
+	if (mdio_ctrl & AN_CL37_EN) {
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 mdio_ctrl & ~AN_CL37_EN);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
 	if (ret < 0)
 		return ret;
@@ -736,7 +750,15 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	else
 		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 
-	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	if (ret < 0)
+		return ret;
+
+	if (phylink_autoneg_inband(mode))
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 mdio_ctrl | AN_CL37_EN);
+
+	return ret;
 }
 
 static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
-- 
2.25.1

