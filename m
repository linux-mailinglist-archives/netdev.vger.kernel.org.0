Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA6350B1CA
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445024AbiDVHnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444917AbiDVHmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:42:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6C9517CB;
        Fri, 22 Apr 2022 00:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650613172; x=1682149172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ud1eKZ2w6i2EQsMUcCwNgZ6BRlq//P+NQjUhG6y063k=;
  b=gY2FrWhajEZMV1Vw/KNez+e7q+P20BSEBvCXh7iSvUCGzJb2P+T1WgNG
   c4QQf9Qu3Oa2sFnmy6TDvPQod7ZT2tqAup6Je5HIYjlQT8HmsP8j+KXO9
   aGKvanUiuI/AVlwVfchVl25o9C9EuItZQZ0CGpytbbU32m60Tm24dwBzQ
   ZgoVquU0TxGs1wIvu5T8hWgF4qdW8hQElEteXobpuG4BgFtJCKHvpWA+x
   MOyMS/1Lwqbi5DhKp0Co7nIoyhIonHHZPwJP65nJTF4aVvcmkIggG6Gae
   hHGNmma8n5YdVTjyjKjuHXGefhQxx4tJ/YfjW1W87QlRB8TOcisdQWq/b
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245180205"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="245180205"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:39:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="648516321"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Apr 2022 00:39:27 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/4] net: pcs: xpcs: add CL37 1000BASE-X AN support
Date:   Fri, 22 Apr 2022 15:35:02 +0800
Message-Id: <20220422073505.810084-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422073505.810084-1-boon.leong.ong@intel.com>
References: <20220422073505.810084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 174 ++++++++++++++++++++++++++++++++++-
 include/linux/pcs/pcs-xpcs.h |   3 +-
 2 files changed, 173 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 61418d4dc0c..7ba60944ba0 100644
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
@@ -239,6 +252,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 		break;
 	case DW_AN_C37_SGMII:
 	case DW_2500BASEX:
+	case DW_AN_C37_1000BASEX:
 		dev = MDIO_MMD_VEND2;
 		break;
 	default:
@@ -774,6 +788,58 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 	return ret;
 }
 
+static int xpcs_config_aneg_c37_1000basex(struct dw_xpcs *xpcs, unsigned int mode,
+					  const unsigned long *advertising)
+{
+	int ret, mdio_ctrl;
+
+	/* For AN for 1000BASE-X mode, the settings are :-
+	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 0b (Disable C37 AN in case
+	 *    it is already enabled)
+	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 00b (1000BASE-X C37)
+	 * 3) SR_MII_AN_ADV Bit(6)[FD] = 1b (Full Duplex)
+	 *    Note: Half Duplex is rarely used, so don't advertise.
+	 * 4) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] = 1b (Enable C37 AN)
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
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
+	ret |= ADVERTISE_1000XFULL;
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE, ret);
+	if (ret < 0)
+		return ret;
+
+	/* Clear CL37 AN complete status */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
+	if (ret < 0)
+		return ret;
+
+	if (phylink_autoneg_inband(mode) &&
+	    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising))
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
+				 mdio_ctrl | AN_CL37_EN);
+
+	return ret;
+}
+
 static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 {
 	int ret;
@@ -797,7 +863,7 @@ static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 }
 
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode)
+		   unsigned int mode, const unsigned long *advertising)
 {
 	const struct xpcs_compat *compat;
 	int ret;
@@ -819,6 +885,12 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
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
@@ -845,7 +917,7 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
-	return xpcs_do_config(xpcs, interface, mode);
+	return xpcs_do_config(xpcs, interface, mode, advertising);
 }
 
 static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
@@ -866,7 +938,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 
 		state->link = 0;
 
-		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND);
+		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
 	}
 
 	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
@@ -923,6 +995,50 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	return 0;
 }
 
+static int xpcs_get_state_c37_1000basex(struct dw_xpcs *xpcs,
+					struct phylink_link_state *state)
+{
+	int lpa, adv;
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (ret < 0)
+		return ret;
+
+	if (ret & AN_CL37_EN) {
+		/* Reset link_state */
+		state->link = false;
+		state->speed = SPEED_UNKNOWN;
+		state->duplex = DUPLEX_UNKNOWN;
+		state->pause = 0;
+
+		lpa = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_LPA);
+		if (lpa < 0 || lpa & LPA_RFAULT)
+			return false;
+
+		adv = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
+		if (adv < 0)
+			return false;
+
+		if (lpa & ADVERTISE_1000XFULL &&
+		    adv & ADVERTISE_1000XFULL) {
+			state->speed = SPEED_1000;
+			state->duplex = DUPLEX_FULL;
+			state->link = true;
+		}
+
+		/* Clear CL37 AN complete status */
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
+	} else {
+		state->link = true;
+		state->speed = SPEED_1000;
+		state->duplex = DUPLEX_FULL;
+		state->pause = 0;
+	}
+
+	return 0;
+}
+
 static void xpcs_get_state(struct phylink_pcs *pcs,
 			   struct phylink_link_state *state)
 {
@@ -950,6 +1066,13 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
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
@@ -985,6 +1108,32 @@ static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
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
@@ -994,9 +1143,21 @@ void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
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
+	ret |= BMCR_ANRESTART;
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
+}
+
 static u32 xpcs_get_id(struct dw_xpcs *xpcs)
 {
 	int ret;
@@ -1062,6 +1223,12 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
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
@@ -1117,6 +1284,7 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_validate = xpcs_validate,
 	.pcs_config = xpcs_config,
 	.pcs_get_state = xpcs_get_state,
+	.pcs_an_restart = xpcs_an_restart,
 	.pcs_link_up = xpcs_link_up,
 };
 
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 266eb26fb02..d2da1e0b4a9 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -17,6 +17,7 @@
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
 #define DW_2500BASEX			3
+#define DW_AN_C37_1000BASEX		4
 
 struct xpcs_id;
 
@@ -30,7 +31,7 @@ int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
 void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		  phy_interface_t interface, int speed, int duplex);
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode);
+		   unsigned int mode, const unsigned long *advertising);
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-- 
2.25.1

