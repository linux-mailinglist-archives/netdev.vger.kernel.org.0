Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660F5351AB8
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhDASCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:02:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:59181 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236256AbhDAR5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 13:57:41 -0400
IronPort-SDR: hqhpiG/RizbXRHKfZ+W010E+HnntWjbvQl2AWjJQVidBdxQdfUSgeAvPaQGlHm5+M7VnCgMFg8
 SyJNt0dyHOoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191741856"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="191741856"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 08:07:23 -0700
IronPort-SDR: ofBm94j9Mw4CZVy5cmsG656vaAiUCEBQsuSgTBE6Vk+aKSnHBherureYJoGmIQo1v7NRrqvg6k
 Ac2f/hBd4GPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="446121281"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Apr 2021 08:07:18 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        qiangqing.zhang@nxp.com, vee.khee.wong@intel.com,
        fugang.duan@nxp.com, kim.tatt.chuah@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com
Subject: [PATCH net-next 2/2] net: pcs: configure xpcs 2.5G speed mode
Date:   Thu,  1 Apr 2021 23:01:52 +0800
Message-Id: <20210401150152.22444-3-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401150152.22444-1-michael.wei.hong.sit@intel.com>
References: <20210401150152.22444-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Besides setting 2.5G configuration, this patch will also disable
automatic speed mode change. This is due to the 2.5G mode is
using the same functionality as 1G mode except the clock rate is
2.5 times the original rate. Hence, auto-negotiation is disabled
to make sure it will only be in 2.5G mode.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  1 +
 drivers/net/pcs/pcs-xpcs.c                    | 29 +++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h                  |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e182f9be4247..23178651310e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5835,6 +5835,7 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->plat->speed_mode_2500) {
 		priv->plat->speed_2500_en = priv->plat->speed_mode_2500(ndev,
 									priv->plat->bsp_priv);
+		priv->hw->xpcs_args.speed_2500_en = priv->plat->speed_2500_en;
 	}
 
 	ret = stmmac_phy_setup(priv);
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 944ba105cac1..e7562cfcd7d5 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -60,10 +60,14 @@
 
 /* Clause 37 Defines */
 /* VR MII MMD registers offsets */
+#define DW_VR_MII_MMD_CTRL		0x0000
 #define DW_VR_MII_DIG_CTRL1		0x8000
 #define DW_VR_MII_AN_CTRL		0x8001
 #define DW_VR_MII_AN_INTR_STS		0x8002
 
+/* Enable 2.5G Mode */
+#define DW_VR_MII_DIG_CTRL1_2G5_EN	BIT(2)
+
 /* VR_MII_DIG_CTRL1 */
 #define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
 
@@ -86,6 +90,11 @@
 #define DW_VR_MII_C37_ANSGM_SP_1000		0x2
 #define DW_VR_MII_C37_ANSGM_SP_LNKSTS		BIT(4)
 
+/* SR MII MMD Control defines */
+#define AN_CL37_EN		BIT(12)	/* Enable Clause 37 auto-nego */
+#define SGMII_SPEED_SS13	BIT(13)	/* SGMII speed along with SS6 */
+#define SGMII_SPEED_SS6		BIT(6)	/* SGMII speed along with SS13 */
+
 static const int xpcs_usxgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -141,6 +150,7 @@ static const int xpcs_sgmii_features[] = {
 	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
 	ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
 	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
 	__ETHTOOL_LINK_MODE_MASK_NBITS,
 };
 
@@ -654,6 +664,25 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 {
 	int ret;
 
+	if (xpcs->speed_2500_en) {
+		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
+		if (ret < 0)
+			return ret;
+		ret |= DW_VR_MII_DIG_CTRL1_2G5_EN;
+		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
+		if (ret < 0)
+			return ret;
+
+		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
+		if (ret < 0)
+			return ret;
+		ret &= ~AN_CL37_EN;
+		ret |= SGMII_SPEED_SS6;
+		ret &= ~SGMII_SPEED_SS13;
+		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
+	}
+
 	/* For AN for C37 SGMII mode, the settings are :-
 	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] = 10b (SGMII AN)
 	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] = 0b (MAC side SGMII)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 2cb5188a7ef1..6b94b2a48e0c 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -19,6 +19,7 @@ struct mdio_xpcs_args {
 	struct mii_bus *bus;
 	int addr;
 	int an_mode;
+	bool speed_2500_en;
 };
 
 struct mdio_xpcs_ops {
-- 
2.17.1

