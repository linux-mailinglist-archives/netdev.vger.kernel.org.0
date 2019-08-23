Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BD99A8E5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 09:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbfHWHeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 03:34:15 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33745 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387651AbfHWHeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 03:34:15 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7N7YCJF025726, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7N7YCJF025726
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 23 Aug 2019 15:34:13 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Fri, 23 Aug 2019
 15:34:11 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v4 2/2] r8152: add a helper function about setting EEE
Date:   Fri, 23 Aug 2019 15:33:41 +0800
Message-ID: <1394712342-15778-313-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-311-Taiwan-albertk@realtek.com>
References: <1394712342-15778-304-Taiwan-albertk@realtek.com>
 <1394712342-15778-311-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper function "rtl_eee_enable" for setting EEE. Besides, I
move r8153_eee_en() and r8153b_eee_en(). And, I remove r8152b_enable_eee(),
r8153_set_eee(), and r8153b_set_eee().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 168 ++++++++++++++++++----------------------
 1 file changed, 77 insertions(+), 91 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a7aa48bee732..17f0e9e98697 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3202,14 +3202,75 @@ static void r8152_eee_en(struct r8152 *tp, bool enable)
 	ocp_reg_write(tp, OCP_EEE_CONFIG3, config3);
 }
 
-static void r8152b_enable_eee(struct r8152 *tp)
+static void r8153_eee_en(struct r8152 *tp, bool enable)
 {
-	if (tp->eee_en) {
-		r8152_eee_en(tp, true);
-		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, tp->eee_adv);
+	u32 ocp_data;
+	u16 config;
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
+	config = ocp_reg_read(tp, OCP_EEE_CFG);
+
+	if (enable) {
+		ocp_data |= EEE_RX_EN | EEE_TX_EN;
+		config |= EEE10_EN;
 	} else {
-		r8152_eee_en(tp, false);
-		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
+		config &= ~EEE10_EN;
+	}
+
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
+	ocp_reg_write(tp, OCP_EEE_CFG, config);
+}
+
+static void r8153b_eee_en(struct r8152 *tp, bool enable)
+{
+	r8153_eee_en(tp, enable);
+
+	if (enable)
+		r8153b_ups_flags_w1w0(tp, UPS_FLAGS_EN_EEE, 0);
+	else
+		r8153b_ups_flags_w1w0(tp, 0, UPS_FLAGS_EN_EEE);
+}
+
+static void rtl_eee_enable(struct r8152 *tp, bool enable)
+{
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+		if (enable) {
+			r8152_eee_en(tp, true);
+			r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV,
+					tp->eee_adv);
+		} else {
+			r8152_eee_en(tp, false);
+			r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+		}
+		break;
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+		if (enable) {
+			r8153_eee_en(tp, true);
+			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+		} else {
+			r8153_eee_en(tp, false);
+			ocp_reg_write(tp, OCP_EEE_ADV, 0);
+		}
+		break;
+	case RTL_VER_08:
+	case RTL_VER_09:
+		if (enable) {
+			r8153b_eee_en(tp, true);
+			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+		} else {
+			r8153b_eee_en(tp, false);
+			ocp_reg_write(tp, OCP_EEE_ADV, 0);
+		}
+		break;
+	default:
+		break;
 	}
 }
 
@@ -3231,7 +3292,7 @@ static void rtl8152_disable(struct r8152 *tp)
 
 static void r8152b_hw_phy_cfg(struct r8152 *tp)
 {
-	r8152b_enable_eee(tp);
+	rtl_eee_enable(tp, tp->eee_en);
 	r8152_aldps_en(tp, true);
 	r8152b_enable_fc(tp);
 
@@ -3425,36 +3486,6 @@ static void r8153b_aldps_en(struct r8152 *tp, bool enable)
 		r8153b_ups_flags_w1w0(tp, 0, UPS_FLAGS_EN_ALDPS);
 }
 
-static void r8153_eee_en(struct r8152 *tp, bool enable)
-{
-	u32 ocp_data;
-	u16 config;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
-	config = ocp_reg_read(tp, OCP_EEE_CFG);
-
-	if (enable) {
-		ocp_data |= EEE_RX_EN | EEE_TX_EN;
-		config |= EEE10_EN;
-	} else {
-		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
-		config &= ~EEE10_EN;
-	}
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
-	ocp_reg_write(tp, OCP_EEE_CFG, config);
-}
-
-static void r8153b_eee_en(struct r8152 *tp, bool enable)
-{
-	r8153_eee_en(tp, enable);
-
-	if (enable)
-		r8153b_ups_flags_w1w0(tp, UPS_FLAGS_EN_EEE, 0);
-	else
-		r8153b_ups_flags_w1w0(tp, 0, UPS_FLAGS_EN_EEE);
-}
-
 static void r8153b_enable_fc(struct r8152 *tp)
 {
 	r8152b_enable_fc(tp);
@@ -3470,8 +3501,7 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 	r8153_aldps_en(tp, false);
 
 	/* disable EEE before updating the PHY parameters */
-	r8153_eee_en(tp, false);
-	ocp_reg_write(tp, OCP_EEE_ADV, 0);
+	rtl_eee_enable(tp, false);
 
 	if (tp->version == RTL_VER_03) {
 		data = ocp_reg_read(tp, OCP_EEE_CFG);
@@ -3502,10 +3532,8 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 	sram_write(tp, SRAM_10M_AMP1, 0x00af);
 	sram_write(tp, SRAM_10M_AMP2, 0x0208);
 
-	if (tp->eee_en) {
-		r8153_eee_en(tp, true);
-		ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
-	}
+	if (tp->eee_en)
+		rtl_eee_enable(tp, true);
 
 	r8153_aldps_en(tp, true);
 	r8152b_enable_fc(tp);
@@ -3545,8 +3573,7 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 	r8153b_aldps_en(tp, false);
 
 	/* disable EEE before updating the PHY parameters */
-	r8153b_eee_en(tp, false);
-	ocp_reg_write(tp, OCP_EEE_ADV, 0);
+	rtl_eee_enable(tp, false);
 
 	r8153b_green_en(tp, test_bit(GREEN_ETHERNET, &tp->flags));
 
@@ -3608,10 +3635,8 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 
 	r8153b_ups_flags_w1w0(tp, ups_flags, 0);
 
-	if (tp->eee_en) {
-		r8153b_eee_en(tp, true);
-		ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
-	}
+	if (tp->eee_en)
+		rtl_eee_enable(tp, true);
 
 	r8153b_aldps_en(tp, true);
 	r8153b_enable_fc(tp);
@@ -4930,12 +4955,7 @@ static int r8152_set_eee(struct r8152 *tp, struct ethtool_eee *eee)
 	tp->eee_en = eee->eee_enabled;
 	tp->eee_adv = val;
 
-	r8152_eee_en(tp, eee->eee_enabled);
-
-	if (eee->eee_enabled)
-		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, val);
-	else
-		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+	rtl_eee_enable(tp, tp->eee_en);
 
 	return 0;
 }
@@ -4963,40 +4983,6 @@ static int r8153_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 	return 0;
 }
 
-static int r8153_set_eee(struct r8152 *tp, struct ethtool_eee *eee)
-{
-	u16 val = ethtool_adv_to_mmd_eee_adv_t(eee->advertised);
-
-	tp->eee_en = eee->eee_enabled;
-	tp->eee_adv = val;
-
-	r8153_eee_en(tp, eee->eee_enabled);
-
-	if (eee->eee_enabled)
-		ocp_reg_write(tp, OCP_EEE_ADV, val);
-	else
-		ocp_reg_write(tp, OCP_EEE_ADV, 0);
-
-	return 0;
-}
-
-static int r8153b_set_eee(struct r8152 *tp, struct ethtool_eee *eee)
-{
-	u16 val = ethtool_adv_to_mmd_eee_adv_t(eee->advertised);
-
-	tp->eee_en = eee->eee_enabled;
-	tp->eee_adv = val;
-
-	r8153b_eee_en(tp, eee->eee_enabled);
-
-	if (eee->eee_enabled)
-		ocp_reg_write(tp, OCP_EEE_ADV, val);
-	else
-		ocp_reg_write(tp, OCP_EEE_ADV, 0);
-
-	return 0;
-}
-
 static int
 rtl_ethtool_get_eee(struct net_device *net, struct ethtool_eee *edata)
 {
@@ -5382,7 +5368,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->down		= rtl8153_down;
 		ops->unload		= rtl8153_unload;
 		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8153_set_eee;
+		ops->eee_set		= r8152_set_eee;
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
@@ -5400,7 +5386,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->down		= rtl8153b_down;
 		ops->unload		= rtl8153b_unload;
 		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8153b_set_eee;
+		ops->eee_set		= r8152_set_eee;
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153b_runtime_enable;
-- 
2.21.0

