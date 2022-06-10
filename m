Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B5545AB1
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345885AbiFJDlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345711AbiFJDlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:41:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4048C2194F4;
        Thu,  9 Jun 2022 20:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832460; x=1686368460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MXw/zChD1a8mVZCgKOqdhbMJAHYRSVeEBL3gFQMJIeA=;
  b=cwyGjq7hga3SOHSmZuaoEqeEpHWFm7mpZmF98rTPURvPBMMYCXwPURPJ
   Nldi+cLgNnd31uq2YV1h9Dac1NwdNLQH+M0Gs+YNTOh5fJet/8t7LJqns
   rUWuqxvjaNMPy1nbOn/eHQfv85bC56bfUFz6ctpYv0FxyR1O3DLVlmoL3
   w8SmwUpE29EpzBApg7Pj/qejnpAx8EL9DSMy9zDGXjIUkv5UPEQ2NMHAg
   OkxbXk2Fz0jb3Fx7tAwIiZrEOK6scfMaItcx2dbLPq9aQOWb6wfDjWSiG
   EPYMRiV5/65/5lZfuSkWohqz0rRtu+UDktjo+qyQDzsY5/LLa2K07r6nx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278305252"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="278305252"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:40:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="827993979"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2022 20:40:54 -0700
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
Subject: [PATCH net-next v3 4/7] net: pcs: xpcs: add CL37 1000BASE-X AN support
Date:   Fri, 10 Jun 2022 11:36:07 +0800
Message-Id: <20220610033610.114084-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610033610.114084-1-boon.leong.ong@intel.com>
References: <20220610033610.114084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

v2: Fixes to issues spotted by Russell King in v1. Thanks!
    https://patchwork.kernel.org/comment/24826650/
    Use phylink_mii_c22_pcs_encode_advertisement() and implement
    C45 MII ADV handling since IP only support C45 access.

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 180 +++++++++++++++++++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h |   1 +
 2 files changed, 181 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 48d81c40aab..5f75ad503ef 100644
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
@@ -921,6 +1013,40 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	return 0;
 }
 
+static int xpcs_get_state_c37_1000basex(struct dw_xpcs *xpcs,
+					struct phylink_link_state *state)
+{
+	int lpa, adv;
+	int ret;
+
+	if (state->an_enabled) {
+		/* Reset link state */
+		state->link = false;
+
+		lpa = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_LPA);
+		if (lpa < 0 || lpa & LPA_RFAULT)
+			return lpa;
+
+		adv = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
+		if (adv < 0)
+			return adv;
+
+		if (lpa & ADVERTISE_1000XFULL &&
+		    adv & ADVERTISE_1000XFULL) {
+			state->link = true;
+			state->speed = SPEED_1000;
+			state->duplex = DUPLEX_FULL;
+		}
+
+		/* Clear CL37 AN complete status */
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static void xpcs_get_state(struct phylink_pcs *pcs,
 			   struct phylink_link_state *state)
 {
@@ -948,6 +1074,13 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
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
@@ -983,6 +1116,32 @@ static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
 }
 
+static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, int speed,
+				   int duplex)
+{
+	int val, ret;
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
@@ -992,9 +1151,23 @@ void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		return xpcs_config_usxgmii(xpcs, speed);
 	if (interface == PHY_INTERFACE_MODE_SGMII)
 		return xpcs_link_up_sgmii(xpcs, mode, speed, duplex);
+	if (interface == PHY_INTERFACE_MODE_1000BASEX)
+		return xpcs_link_up_1000basex(xpcs, speed, duplex);
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
@@ -1060,6 +1233,12 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
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
@@ -1115,6 +1294,7 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_validate = xpcs_validate,
 	.pcs_config = xpcs_config,
 	.pcs_get_state = xpcs_get_state,
+	.pcs_an_restart = xpcs_an_restart,
 	.pcs_link_up = xpcs_link_up,
 };
 
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

