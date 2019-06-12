Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7453142043
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408175AbfFLJIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:08:23 -0400
Received: from nsg-static-220.246.72.182.airtel.in ([182.72.246.220]:15744
        "EHLO swlab-raju.vitesse.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407719AbfFLJIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:08:22 -0400
Received: by swlab-raju.vitesse.org (Postfix, from userid 1001)
        id 8847F15225D2; Wed, 12 Jun 2019 14:27:10 +0530 (IST)
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, f.fainelli@gmail.com, andrew@lunn.ch,
        Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Subject: [RFC, net-next v0 2/2] net: phy: mscc: Add PHY driver for Cable Diagnostics command
Date:   Wed, 12 Jun 2019 14:27:07 +0530
Message-Id: <1560329827-6345-3-git-send-email-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
References: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Add the Cable diagnostics command to VSC85xx PHYs.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/phy/mscc.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 28676af..98e3925 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -153,9 +153,29 @@ enum rgmii_rx_clock_delay {
 #define MSCC_PHY_EXT_PHY_CNTL_4		  23
 #define PHY_CNTL_4_ADDR_POS		  11
 
+#define MSCC_PHY_VERIPHY_CNTL_1           24
+#define VERIPHY_TRIGGER_CNTL_MASK	  0x8000
+#define VERIPHY_VALID_MASK		  0x4000
+#define VERIPHY_PAIR_A_DISTANCE_MASK	  0x2F00
+#define VERIPHY_PAIR_A_DISTANCE_POS	  8
+#define VERIPHY_PAIR_B_DISTANCE_MASK	  0x002F
+#define VERIPHY_PAIR_B_DISTANCE_POS	  0
+
 #define MSCC_PHY_VERIPHY_CNTL_2		  25
+#define VERIPHY_PAIR_C_DISTANCE_MASK	  0x2F00
+#define VERIPHY_PAIR_C_DISTANCE_POS	  8
+#define VERIPHY_PAIR_D_DISTANCE_MASK	  0x002F
+#define VERIPHY_PAIR_D_DISTANCE_POS	  0
 
 #define MSCC_PHY_VERIPHY_CNTL_3		  26
+#define VERIPHY_PAIR_A_STATUS_MASK	  0xF000
+#define VERIPHY_PAIR_A_STATUS_POS	  12
+#define VERIPHY_PAIR_B_STATUS_MASK	  0x0F00
+#define VERIPHY_PAIR_B_STATUS_POS	  8
+#define VERIPHY_PAIR_C_STATUS_MASK	  0x00F0
+#define VERIPHY_PAIR_C_STATUS_POS	  4
+#define VERIPHY_PAIR_D_STATUS_MASK	  0x000F
+#define VERIPHY_PAIR_D_STATUS_POS	  0
 
 /* Extended Page 2 Registers */
 #define MSCC_PHY_CU_PMD_TX_CNTL		  16
@@ -442,6 +462,107 @@ static int vsc85xx_phy_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, MSCC_EXT_PAGE_ACCESS, page);
 }
 
+static int vsc85xx_cabdiag_request(struct phy_device *phydev,
+				   struct phy_cabdiag_req *cfg)
+{
+	u16 reg_val;
+	u8 timeout_cnt = 0;
+	int rc;
+
+	if (cfg->pairs_bitmask < CABDIAG_PAIR_A_MASK   ||
+	    (cfg->pairs_bitmask > (CABDIAG_PAIR_A_MASK |
+				   CABDIAG_PAIR_B_MASK |
+				   CABDIAG_PAIR_C_MASK |
+				   CABDIAG_PAIR_D_MASK))) {
+		cfg->op_status = CD_REQ_INVALID_PAIR_MASK;
+		return 0;
+	}
+	if (cfg->timeout_cnt == 0) {
+		cfg->op_status = CD_REQ_INVALID_TIMEOUT;
+		return 0;
+	}
+
+	mutex_lock(&phydev->lock);
+	rc = phy_select_page(phydev, MSCC_PHY_PAGE_EXTENDED);
+	if (rc < 0)
+		goto out_unlock;
+
+	reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_1);
+	if (reg_val & VERIPHY_TRIGGER_CNTL_MASK) {
+		cfg->op_status = CD_REQ_REJECTED_BUSY;
+		goto out_unlock;
+	}
+	/* Start Cable Diagnostics operation */
+	reg_val |= VERIPHY_TRIGGER_CNTL_MASK;
+	__phy_write(phydev, MSCC_PHY_VERIPHY_CNTL_1, reg_val);
+
+	/* Wait till VeriPHY has completed */
+	do {
+		msleep(30);
+		reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_1);
+	} while ((reg_val & VERIPHY_TRIGGER_CNTL_MASK) &&
+		 (timeout_cnt++ < cfg->timeout_cnt));
+
+	if (timeout_cnt >= cfg->timeout_cnt) {
+		cfg->op_status = CD_STATUS_FAILED_TIMEOUT;
+		goto out_unlock;
+	}
+	cfg->timeout_cnt = timeout_cnt;
+
+	if (reg_val & VERIPHY_VALID_MASK) {
+		/* VeriPHY results are valid */
+		if (cfg->pairs_bitmask & CABDIAG_PAIR_A_MASK) {
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_1);
+			cfg->pairs[CABDIAG_PAIR_A].length =
+			(reg_val & VERIPHY_PAIR_A_DISTANCE_MASK) >>
+			VERIPHY_PAIR_A_DISTANCE_POS;
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_3);
+			cfg->pairs[CABDIAG_PAIR_A].status =
+			(reg_val & VERIPHY_PAIR_A_STATUS_MASK) >>
+			VERIPHY_PAIR_A_STATUS_POS;
+		}
+		if (cfg->pairs_bitmask & CABDIAG_PAIR_B_MASK) {
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_1);
+			cfg->pairs[CABDIAG_PAIR_B].length =
+			(reg_val & VERIPHY_PAIR_B_DISTANCE_MASK) >>
+			VERIPHY_PAIR_B_DISTANCE_POS;
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_3);
+			cfg->pairs[CABDIAG_PAIR_B].status =
+			(reg_val & VERIPHY_PAIR_B_STATUS_MASK) >>
+			VERIPHY_PAIR_B_STATUS_POS;
+		}
+		if (cfg->pairs_bitmask & CABDIAG_PAIR_C_MASK) {
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_2);
+			cfg->pairs[CABDIAG_PAIR_C].length =
+			(reg_val & VERIPHY_PAIR_C_DISTANCE_MASK) >>
+			VERIPHY_PAIR_C_DISTANCE_POS;
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_3);
+			cfg->pairs[CABDIAG_PAIR_C].status =
+			(reg_val & VERIPHY_PAIR_C_STATUS_MASK) >>
+			VERIPHY_PAIR_C_STATUS_POS;
+		}
+		if (cfg->pairs_bitmask & CABDIAG_PAIR_D_MASK) {
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_2);
+			cfg->pairs[CABDIAG_PAIR_D].length =
+			(reg_val & VERIPHY_PAIR_D_DISTANCE_MASK) >>
+			VERIPHY_PAIR_D_DISTANCE_POS;
+			reg_val = __phy_read(phydev, MSCC_PHY_VERIPHY_CNTL_3);
+			cfg->pairs[CABDIAG_PAIR_D].status =
+			(reg_val & VERIPHY_PAIR_D_STATUS_MASK) >>
+			VERIPHY_PAIR_D_STATUS_POS;
+		}
+		cfg->op_status = CD_STATUS_SUCCESS;
+	} else {
+		cfg->op_status = CD_STATUS_FAILED_INVALID;
+	}
+
+out_unlock:
+	phy_restore_page(phydev, rc, rc > 0 ? 0 : rc);
+	mutex_unlock(&phydev->lock);
+
+	return rc;
+}
+
 static int vsc85xx_get_sset_count(struct phy_device *phydev)
 {
 	struct vsc8531_private *priv = phydev->priv;
@@ -2343,6 +2464,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 },
 {
 	.phy_id		= PHY_ID_VSC8530,
@@ -2368,6 +2490,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 },
 {
 	.phy_id		= PHY_ID_VSC8531,
@@ -2393,6 +2516,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 },
 {
 	.phy_id		= PHY_ID_VSC8540,
@@ -2418,6 +2542,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 },
 {
 	.phy_id		= PHY_ID_VSC8541,
@@ -2443,6 +2568,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 },
 {
 	.phy_id		= PHY_ID_VSC8574,
@@ -2469,6 +2595,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 },
 {
 	.phy_id		= PHY_ID_VSC8584,
@@ -2493,6 +2620,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.request_cable_diag = &vsc85xx_cabdiag_request,
 }
 
 };
-- 
2.7.4

