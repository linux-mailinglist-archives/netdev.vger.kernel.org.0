Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF7439B681
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFDKE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:04:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:53411 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhFDKE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 06:04:28 -0400
IronPort-SDR: 3+LbJUpgqxw4WlZ5fLpQ8xgIVfqw4KxJhD8n1UvA74xNPZDyO3UGt68olFC8nhK98Hh0/77JEg
 30pWxxUo1+9g==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="202404523"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="202404523"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 03:02:42 -0700
IronPort-SDR: 9mi1Ro1tY9PLkmbCCsOvh4FsJu6IrEtRQa4PsMmQw75COnVylIQRdLnAe6RpFfHGd/lAWLdrmc
 5WedTRP8p38Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="633994105"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2021 03:02:37 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: [PATCH net-next v5 2/3] net: pcs: add 2500BASEX support for Intel mGbE controller
Date:   Fri,  4 Jun 2021 17:58:00 +0800
Message-Id: <20210604095801.1033-3-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604095801.1033-1-michael.wei.hong.sit@intel.com>
References: <20210604095801.1033-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

XPCS IP supports 2500BASEX as PHY interface. It is configured as
autonegotiation disable to cater for PHYs that does not supports 2500BASEX
autonegotiation.

v2: Add supported link speed masking.
v3: Restructure to introduce xpcs_config_2500basex() used to configure the
    xpcs for 2.5G speeds. Added 2500BASEX specific information for
    configuration.
v4: Fix indentation error

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 56 ++++++++++++++++++++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h |  1 +
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 34164437c135..98c4a3973402 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -57,9 +57,12 @@
 
 /* Clause 37 Defines */
 /* VR MII MMD registers offsets */
+#define DW_VR_MII_MMD_CTRL		0x0000
 #define DW_VR_MII_DIG_CTRL1		0x8000
 #define DW_VR_MII_AN_CTRL		0x8001
 #define DW_VR_MII_AN_INTR_STS		0x8002
+/* Enable 2.5G Mode */
+#define DW_VR_MII_DIG_CTRL1_2G5_EN	BIT(2)
 /* EEE Mode Control Register */
 #define DW_VR_MII_EEE_MCTRL0		0x8006
 #define DW_VR_MII_EEE_MCTRL1		0x800b
@@ -86,6 +89,11 @@
 #define DW_VR_MII_C37_ANSGM_SP_1000		0x2
 #define DW_VR_MII_C37_ANSGM_SP_LNKSTS		BIT(4)
 
+/* SR MII MMD Control defines */
+#define AN_CL37_EN		BIT(12)	/* Enable Clause 37 auto-nego */
+#define SGMII_SPEED_SS13	BIT(13)	/* SGMII speed along with SS6 */
+#define SGMII_SPEED_SS6		BIT(6)	/* SGMII speed along with SS13 */
+
 /* VR MII EEE Control 0 defines */
 #define DW_VR_MII_EEE_LTX_EN		BIT(0)  /* LPI Tx Enable */
 #define DW_VR_MII_EEE_LRX_EN		BIT(1)  /* LPI Rx Enable */
@@ -161,6 +169,14 @@ static const int xpcs_sgmii_features[] = {
 	__ETHTOOL_LINK_MODE_MASK_NBITS,
 };
 
+static const int xpcs_2500basex_features[] = {
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_Autoneg_BIT,
+	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+	ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+	__ETHTOOL_LINK_MODE_MASK_NBITS,
+};
+
 static const phy_interface_t xpcs_usxgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_USXGMII,
 };
@@ -177,11 +193,17 @@ static const phy_interface_t xpcs_sgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_SGMII,
 };
 
+static const phy_interface_t xpcs_2500basex_interfaces[] = {
+	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_MAX,
+};
+
 enum {
 	DW_XPCS_USXGMII,
 	DW_XPCS_10GKR,
 	DW_XPCS_XLGMII,
 	DW_XPCS_SGMII,
+	DW_XPCS_2500BASEX,
 	DW_XPCS_INTERFACE_MAX,
 };
 
@@ -306,6 +328,7 @@ static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs,
 		dev = MDIO_MMD_PCS;
 		break;
 	case DW_AN_C37_SGMII:
+	case DW_2500BASEX:
 		dev = MDIO_MMD_VEND2;
 		break;
 	default:
@@ -804,6 +827,28 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
 
+static int xpcs_config_2500basex(struct mdio_xpcs_args *xpcs)
+{
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
+	if (ret < 0)
+		return ret;
+	ret |= DW_VR_MII_DIG_CTRL1_2G5_EN;
+	ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+	if (ret < 0)
+		return ret;
+	ret &= ~AN_CL37_EN;
+	ret |= SGMII_SPEED_SS6;
+	ret &= ~SGMII_SPEED_SS13;
+	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
+}
+
 static int xpcs_do_config(struct mdio_xpcs_args *xpcs,
 			  phy_interface_t interface, unsigned int mode)
 {
@@ -827,6 +872,11 @@ static int xpcs_do_config(struct mdio_xpcs_args *xpcs,
 		if (ret)
 			return ret;
 		break;
+	case DW_2500BASEX:
+		ret = xpcs_config_2500basex(xpcs);
+		if (ret)
+			return ret;
+		break;
 	default:
 		return -1;
 	}
@@ -1023,6 +1073,12 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
 		.an_mode = DW_AN_C37_SGMII,
 	},
+	[DW_XPCS_2500BASEX] = {
+		.supported = xpcs_2500basex_features,
+		.interface = xpcs_2500basex_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_2500basex_features),
+		.an_mode = DW_2500BASEX,
+	},
 };
 
 static const struct xpcs_id xpcs_id_list[] = {
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 0860a5b59f10..4d815f03b4b2 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -13,6 +13,7 @@
 /* AN mode */
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
+#define DW_2500BASEX			3
 
 struct xpcs_id;
 
-- 
2.17.1

