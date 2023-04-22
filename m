Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE796EB781
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 07:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDVE77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDVE7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:59:55 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3F62702;
        Fri, 21 Apr 2023 21:59:48 -0700 (PDT)
X-QQ-mid: bizesmtp66t1682139548ty0fxbhr
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Apr 2023 12:59:07 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: D2GZf6M6C/jsTOe4cSk5yhs/GQ2aXQZrd5tONkSBTvDOaf7Z0rP+K/Tgi90uv
        Y4MeuJi10pqwbjfaXG5pWxjzscuxFZqjxUcwhdhZ60tYLiOeYQjM5LERPf4e1O8edBw0MA4
        5uTTYiQvN8NPzEJRpfEfpk3txs6/DTltZWj6exYgDEVGuXqTNdlRRyWk9kM18Uon99RnTEg
        x2JpwWQD2hknS/e/XP1gpcvTrzflMZPq4+1NF1bHQFLdMtLzA4TaasDvvGxAUJGvjyn5UlM
        UplfpTOPnWpOAaGEyIXtTI5MyoVs110ehyp5Y927VBH/uHTa/kRgxJkQcj/EqQF4V7Y7xu2
        4IKcWYj65Ez3NNjWNcyz+Bb4srNH2bxbnBE9Eoe/7be03RwCGgpPAiIXdDQZccDOLqPlLOp
        Qpxdr2Zk1uk=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 281790733503861956
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next v4 6/8] net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
Date:   Sat, 22 Apr 2023 12:56:19 +0800
Message-Id: <20230422045621.360918-7-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230422045621.360918-1-jiawenwu@trustnetic.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support for XPCS using 10GBASE-R interface. This mode will
be extended to use interrupt, so set pcs.poll false. And avoid soft
reset so that the device using this mode is in the default configuration.

Cc: Jose Abreu <Jose.Abreu@synopsys.com>

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 56 ++++++++++++++++++++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h |  1 +
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 539cd43eae8d..9ddaceda1fe9 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -64,6 +64,16 @@ static const int xpcs_xlgmii_features[] = {
 	__ETHTOOL_LINK_MODE_MASK_NBITS,
 };
 
+static const int xpcs_10gbaser_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+	__ETHTOOL_LINK_MODE_MASK_NBITS,
+};
+
 static const int xpcs_sgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -106,6 +116,10 @@ static const phy_interface_t xpcs_xlgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_XLGMII,
 };
 
+static const phy_interface_t xpcs_10gbaser_interfaces[] = {
+	PHY_INTERFACE_MODE_10GBASER,
+};
+
 static const phy_interface_t xpcs_sgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_SGMII,
 };
@@ -123,6 +137,7 @@ enum {
 	DW_XPCS_USXGMII,
 	DW_XPCS_10GKR,
 	DW_XPCS_XLGMII,
+	DW_XPCS_10GBASER,
 	DW_XPCS_SGMII,
 	DW_XPCS_1000BASEX,
 	DW_XPCS_2500BASEX,
@@ -246,6 +261,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 
 	switch (compat->an_mode) {
 	case DW_AN_C73:
+	case DW_10GBASER:
 		dev = MDIO_MMD_PCS;
 		break;
 	case DW_AN_C37_SGMII:
@@ -872,6 +888,8 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		return -ENODEV;
 
 	switch (compat->an_mode) {
+	case DW_10GBASER:
+		break;
 	case DW_AN_C73:
 		if (phylink_autoneg_inband(mode)) {
 			ret = xpcs_config_aneg_c73(xpcs, compat);
@@ -919,6 +937,27 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	return xpcs_do_config(xpcs, interface, mode, advertising);
 }
 
+static int xpcs_get_state_10gbaser(struct dw_xpcs *xpcs,
+				   struct phylink_link_state *state)
+{
+	int ret;
+
+	state->link = false;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_STAT1_LSTATUS) {
+		state->link = true;
+		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
+		state->duplex = DUPLEX_FULL;
+		state->speed = SPEED_10000;
+	}
+
+	return 0;
+}
+
 static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 			      struct phylink_link_state *state,
 			      const struct xpcs_compat *compat)
@@ -1033,6 +1072,14 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 		return;
 
 	switch (compat->an_mode) {
+	case DW_10GBASER:
+		ret = xpcs_get_state_10gbaser(xpcs, state);
+		if (ret) {
+			pr_err("xpcs_get_state_10gbaser returned %pe\n",
+			       ERR_PTR(ret));
+			return;
+		}
+		break;
 	case DW_AN_C73:
 		ret = xpcs_get_state_c73(xpcs, state, compat);
 		if (ret) {
@@ -1188,6 +1235,12 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 		.num_interfaces = ARRAY_SIZE(xpcs_xlgmii_interfaces),
 		.an_mode = DW_AN_C73,
 	},
+	[DW_XPCS_10GBASER] = {
+		.supported = xpcs_10gbaser_features,
+		.interface = xpcs_10gbaser_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_10gbaser_interfaces),
+		.an_mode = DW_10GBASER,
+	},
 	[DW_XPCS_SGMII] = {
 		.supported = xpcs_sgmii_features,
 		.interface = xpcs_sgmii_interfaces,
@@ -1290,6 +1343,9 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 		}
 
 		xpcs->pcs.ops = &xpcs_phylink_ops;
+		if (compat->an_mode == DW_10GBASER)
+			return xpcs;
+
 		xpcs->pcs.poll = true;
 
 		ret = xpcs_soft_reset(xpcs, compat);
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index d2da1e0b4a92..61df0c717a0e 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -18,6 +18,7 @@
 #define DW_AN_C37_SGMII			2
 #define DW_2500BASEX			3
 #define DW_AN_C37_1000BASEX		4
+#define DW_10GBASER			5
 
 struct xpcs_id;
 
-- 
2.27.0

