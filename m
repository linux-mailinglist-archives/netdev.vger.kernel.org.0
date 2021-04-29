Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D8536E75F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbhD2Iw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:52:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:11275 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239885AbhD2Iw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 04:52:26 -0400
IronPort-SDR: ab6AhTibhgUZlE3h6wxncH+uPBSpPO8fenTcH2QTO6kKyAYleI2J9HkBit8xIgyMYiMvjGX0Wb
 sGEcs/P9/u2g==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="217684129"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="217684129"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 01:51:40 -0700
IronPort-SDR: rWRoVGz2fLWSDReUiC1eG8YD8U/dLtKEJhGSM/L8fX+8p2XaymkKxQY0GFy7EqbJ17ci0N/1SE
 esW6WX+u2A5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="605198503"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2021 01:51:36 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet
Date:   Thu, 29 Apr 2021 16:46:35 +0800
Message-Id: <20210429084636.24752-2-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210429084636.24752-1-michael.wei.hong.sit@intel.com>
References: <20210429084636.24752-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DWC xpcs EEE support callbacks.The callback function is used to
set EEE registers on xpcs.

xpcs transparent mode is enabled to allow PHY to detect MAC EEE status.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 51 ++++++++++++++++++++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 944ba105cac1..aa985a5aae8d 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -63,6 +63,9 @@
 #define DW_VR_MII_DIG_CTRL1		0x8000
 #define DW_VR_MII_AN_CTRL		0x8001
 #define DW_VR_MII_AN_INTR_STS		0x8002
+/* EEE Mode Control Register */
+#define DW_VR_MII_EEE_MCTRL0		0x8006
+#define DW_VR_MII_EEE_MCTRL1		0x800b
 
 /* VR_MII_DIG_CTRL1 */
 #define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
@@ -86,6 +89,20 @@
 #define DW_VR_MII_C37_ANSGM_SP_1000		0x2
 #define DW_VR_MII_C37_ANSGM_SP_LNKSTS		BIT(4)
 
+/* VR MII EEE Control 0 defines */
+#define DW_VR_MII_EEE_LTX_EN		BIT(0)  /* LPI Tx Enable */
+#define DW_VR_MII_EEE_LRX_EN		BIT(1)  /* LPI Rx Enable */
+#define DW_VR_MII_EEE_TX_QUIET_EN		BIT(2)  /* Tx Quiet Enable */
+#define DW_VR_MII_EEE_RX_QUIET_EN		BIT(3)  /* Rx Quiet Enable */
+#define DW_VR_MII_EEE_TX_EN_CTRL		BIT(4)  /* Tx Control Enable */
+#define DW_VR_MII_EEE_RX_EN_CTRL		BIT(7)  /* Rx Control Enable */
+
+#define DW_VR_MII_EEE_MULT_FACT_100NS_SHIFT	8
+#define DW_VR_MII_EEE_MULT_FACT_100NS		GENMASK(11, 8)
+
+/* VR MII EEE Control 1 defines */
+#define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
+
 static const int xpcs_usxgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -650,6 +667,39 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
+static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+			   int enable)
+{
+	int ret;
+
+	if (enable) {
+	/* Enable EEE */
+		ret = DW_VR_MII_EEE_LTX_EN | DW_VR_MII_EEE_LRX_EN |
+		      DW_VR_MII_EEE_TX_QUIET_EN | DW_VR_MII_EEE_RX_QUIET_EN |
+		      DW_VR_MII_EEE_TX_EN_CTRL | DW_VR_MII_EEE_RX_EN_CTRL |
+		      mult_fact_100ns << DW_VR_MII_EEE_MULT_FACT_100NS_SHIFT;
+	} else {
+		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL0);
+		if (ret < 0)
+			return ret;
+		ret &= ~(DW_VR_MII_EEE_LTX_EN | DW_VR_MII_EEE_LRX_EN |
+		       DW_VR_MII_EEE_TX_QUIET_EN | DW_VR_MII_EEE_RX_QUIET_EN |
+		       DW_VR_MII_EEE_TX_EN_CTRL | DW_VR_MII_EEE_RX_EN_CTRL |
+		       DW_VR_MII_EEE_MULT_FACT_100NS);
+	}
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL0, ret);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1);
+	if (ret < 0)
+		return ret;
+
+	ret |= DW_VR_MII_EEE_TRN_LPI;
+	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1, ret);
+}
+
 static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 {
 	int ret;
@@ -908,6 +958,7 @@ static struct mdio_xpcs_ops xpcs_ops = {
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
 	.probe = xpcs_probe,
+	.config_eee = xpcs_config_eee,
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 2cb5188a7ef1..5938ced805f4 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -32,6 +32,8 @@ struct mdio_xpcs_ops {
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
 	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
+	int (*config_eee)(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+			  int enable);
 };
 
 #if IS_ENABLED(CONFIG_PCS_XPCS)
-- 
2.17.1

