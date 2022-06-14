Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D32F54A75E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 05:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiFNDF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 23:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351675AbiFNDFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 23:05:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC9C2AE15;
        Mon, 13 Jun 2022 20:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655175929; x=1686711929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTih4n+LUKkMXxjri4Y8ogF4Hm7HSCKIapLEftReW7s=;
  b=VYucFaPYCSOfuhIdSsbnySzxOSZxl7e5KcqqEzZ1zw23SW0iPCJK2h/P
   /Wi91+SgMW5qpdXx+As79dX47bf2QxYC5Ps2dR/WtPLlDsmYvJ2hdSnx0
   k80mrXq92JTry1HakL5fs8FORrzgR/pqL3iZ6sV7O7I17HERWwJFXdGnf
   jkNqsMrOlXMW7EnVvBDuU4KsUVGOb0AmlOHQrj6asISd8a0UmjZPO2o2T
   4hlSjj43UM1arS8X+TUCQwCzA8gucf9x9ioLOeOljqlMCmimo0hZoq1me
   r1SZ/a8ROVRDjfn+BGPZskpxED9a7ZgNvDw5MWWy5mhaqziWljJZTQTE0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="278518776"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="278518776"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 20:05:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="761787727"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2022 20:05:16 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v4 3/5] net: pcs: xpcs: add CL37 1000BASE-X AN support
Date:   Tue, 14 Jun 2022 11:00:28 +0800
Message-Id: <20220614030030.1249850-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614030030.1249850-1-boon.leong.ong@intel.com>
References: <20220614030030.1249850-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For CL37 1000BASE-X AN, DW xPCS does not support C22 method but offers
C45 vendor-specific MII MMD for programming.

We also add the ability to disable Autoneg (through ethtool for certain
network switch that supports 1000BASE-X (1000Mbps and Full-Duplex) but
not Autoneg capability.

v3: Fixes to issues spotted by Russell King. Thanks!
    https://patchwork.kernel.org/comment/24890210/
    Use phylink_mii_c22_pcs_decode_state(), remove unnecessary
    interrupt clearing and skip speed & duplex setting if AN
    is enabled.

v2: Fixes to issues spotted by Russell King in v1. Thanks!
    https://patchwork.kernel.org/comment/24826650/
    Use phylink_mii_c22_pcs_encode_advertisement() and implement
    C45 MII ADV handling since IP only support C45 access.

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 172 +++++++++++++++++++++++++++++++++++
 drivers/net/pcs/pcs-xpcs.h   |   3 +-
 include/linux/pcs/pcs-xpcs.h |   1 +
 3 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 48d81c40aab..edd0c1e40a7 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -77,6 +77,14 @@ static const int xpcs_sgmii_features[] = {
 	__ETHTOOL_LINK_MODE_MASK_NBITS,
 };
 
+static const int xpcs_1000basex_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_Autoneg_BIT,
+	ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+	__ETHTOOL_LINK_MODE_MASK_NBITS,
+};
+
 static const int xpcs_2500basex_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -102,6 +110,10 @@ static const phy_interface_t xpcs_sgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_SGMII,
 };
 
+static const phy_interface_t xpcs_1000basex_interfaces[] = {
+	PHY_INTERFACE_MODE_1000BASEX,
+};
+
 static const phy_interface_t xpcs_2500basex_interfaces[] = {
 	PHY_INTERFACE_MODE_2500BASEX,
 	PHY_INTERFACE_MODE_MAX,
@@ -112,6 +124,7 @@ enum {
 	DW_XPCS_10GKR,
 	DW_XPCS_XLGMII,
 	DW_XPCS_SGMII,
+	DW_XPCS_1000BASEX,
 	DW_XPCS_2500BASEX,
 	DW_XPCS_INTERFACE_MAX,
 };
@@ -189,6 +202,16 @@ int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 	return mdiobus_c45_write(bus, addr, dev, reg, val);
 }
 
+int xpcs_modify_changed(struct dw_xpcs *xpcs, int dev, u32 reg,
+			u16 mask, u16 set)
+{
+	u32 reg_addr = mdiobus_c45_addr(dev, reg);
+	struct mii_bus *bus = xpcs->mdiodev->bus;
+	int addr = xpcs->mdiodev->addr;
+
+	return mdiobus_modify_changed(bus, addr, reg_addr, mask, set);
+}
+
 static int xpcs_read_vendor(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
 	return xpcs_read(xpcs, dev, DW_VENDOR | reg);
@@ -237,6 +260,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 		break;
 	case DW_AN_C37_SGMII:
 	case DW_2500BASEX:
+	case DW_AN_C37_1000BASEX:
 		dev = MDIO_MMD_VEND2;
 		break;
 	default:
@@ -772,6 +796,68 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	return ret;
 }
 
+static int xpcs_config_aneg_c37_1000basex(struct dw_xpcs *xpcs, unsigned int mode,
+					  const unsigned long *advertising)
+{
+	phy_interface_t interface = PHY_INTERFACE_MODE_1000BASEX;
+	int ret, mdio_ctrl, adv;
+	bool changed = 0;
+
+	/* According to Chap 7.12, to set 1000BASE-X C37 AN, AN must
+	 * be disabled first:-
+	 * 1) VR_MII_MMD_CTRL Bit(12)[AN_ENABLE] = 0b
+	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 00b (1000BASE-X C37)
+	 */
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
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
+	if (ret < 0)
+		return ret;
+
+	ret &= ~DW_VR_MII_PCS_MODE_MASK;
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL, ret);
+	if (ret < 0)
+		return ret;
+
+	/* Check for advertising changes and update the C45 MII ADV
+	 * register accordingly.
+	 */
+	adv = phylink_mii_c22_pcs_encode_advertisement(interface,
+						       advertising);
+	if (adv >= 0) {
+		ret = xpcs_modify_changed(xpcs, MDIO_MMD_VEND2,
+					  MII_ADVERTISE, 0xffff, adv);
+		if (ret < 0)
+			return ret;
+
+		changed = ret;
+	}
+
+	/* Clear CL37 AN complete status */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
+	if (ret < 0)
+		return ret;
+
+	if (phylink_autoneg_inband(mode) &&
+	    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) {
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 mdio_ctrl | AN_CL37_EN);
+		if (ret < 0)
+			return ret;
+	}
+
+	return changed;
+}
+
 static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 {
 	int ret;
@@ -817,6 +903,12 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		if (ret)
 			return ret;
 		break;
+	case DW_AN_C37_1000BASEX:
+		ret = xpcs_config_aneg_c37_1000basex(xpcs, mode,
+						     advertising);
+		if (ret)
+			return ret;
+		break;
 	case DW_2500BASEX:
 		ret = xpcs_config_2500basex(xpcs);
 		if (ret)
@@ -921,6 +1013,29 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	return 0;
 }
 
+static int xpcs_get_state_c37_1000basex(struct dw_xpcs *xpcs,
+					struct phylink_link_state *state)
+{
+	int lpa, bmsr;
+
+	if (state->an_enabled) {
+		/* Reset link state */
+		state->link = false;
+
+		lpa = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_LPA);
+		if (lpa < 0 || lpa & LPA_RFAULT)
+			return lpa;
+
+		bmsr = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_BMSR);
+		if (bmsr < 0)
+			return bmsr;
+
+		phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
+	}
+
+	return 0;
+}
+
 static void xpcs_get_state(struct phylink_pcs *pcs,
 			   struct phylink_link_state *state)
 {
@@ -948,6 +1063,13 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 			       ERR_PTR(ret));
 		}
 		break;
+	case DW_AN_C37_1000BASEX:
+		ret = xpcs_get_state_c37_1000basex(xpcs, state);
+		if (ret) {
+			pr_err("xpcs_get_state_c37_1000basex returned %pe\n",
+			       ERR_PTR(ret));
+		}
+		break;
 	default:
 		return;
 	}
@@ -983,6 +1105,35 @@ static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
 }
 
+static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, unsigned int mode,
+				   int speed, int duplex)
+{
+	int val, ret;
+
+	if (phylink_autoneg_inband(mode))
+		return;
+
+	switch (speed) {
+	case SPEED_1000:
+		val = BMCR_SPEED1000;
+		break;
+	case SPEED_100:
+	case SPEED_10:
+	default:
+		pr_err("%s: speed = %d\n", __func__, speed);
+		return;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		val |= BMCR_FULLDPLX;
+	else
+		pr_err("%s: half duplex not supported\n", __func__);
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);
+	if (ret)
+		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
+}
+
 void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		  phy_interface_t interface, int speed, int duplex)
 {
@@ -992,9 +1143,23 @@ void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		return xpcs_config_usxgmii(xpcs, speed);
 	if (interface == PHY_INTERFACE_MODE_SGMII)
 		return xpcs_link_up_sgmii(xpcs, mode, speed, duplex);
+	if (interface == PHY_INTERFACE_MODE_1000BASEX)
+		return xpcs_link_up_1000basex(xpcs, mode, speed, duplex);
 }
 EXPORT_SYMBOL_GPL(xpcs_link_up);
 
+static void xpcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1);
+	if (ret >= 0) {
+		ret |= BMCR_ANRESTART;
+		xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
+	}
+}
+
 static u32 xpcs_get_id(struct dw_xpcs *xpcs)
 {
 	int ret;
@@ -1060,6 +1225,12 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
 		.an_mode = DW_AN_C37_SGMII,
 	},
+	[DW_XPCS_1000BASEX] = {
+		.supported = xpcs_1000basex_features,
+		.interface = xpcs_1000basex_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_1000basex_interfaces),
+		.an_mode = DW_AN_C37_1000BASEX,
+	},
 	[DW_XPCS_2500BASEX] = {
 		.supported = xpcs_2500basex_features,
 		.interface = xpcs_2500basex_interfaces,
@@ -1115,6 +1286,7 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_validate = xpcs_validate,
 	.pcs_config = xpcs_config,
 	.pcs_get_state = xpcs_get_state,
+	.pcs_an_restart = xpcs_an_restart,
 	.pcs_link_up = xpcs_link_up,
 };
 
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
index 35651d32a22..5164f2e9584 100644
--- a/drivers/net/pcs/pcs-xpcs.h
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -109,7 +109,8 @@
 
 int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg);
 int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val);
-
+int xpcs_modify_changed(struct dw_xpcs *xpcs, int dev, u32 reg,
+			u16 mask, u16 set);
 int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs);
 int nxp_sja1110_sgmii_pma_config(struct dw_xpcs *xpcs);
 int nxp_sja1110_2500basex_pma_config(struct dw_xpcs *xpcs);
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 37eb97cc228..d2da1e0b4a9 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -17,6 +17,7 @@
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
 #define DW_2500BASEX			3
+#define DW_AN_C37_1000BASEX		4
 
 struct xpcs_id;
 
-- 
2.25.1

