Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D8BA7F7D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 11:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfIDJfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 05:35:22 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:35750 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfIDJfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 05:35:22 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x849ZKKk004654, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x849ZKKk004654
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 4 Sep 2019 17:35:20 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 4 Sep 2019
 17:35:18 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: adjust the settings of ups flags
Date:   Wed, 4 Sep 2019 17:34:38 +0800
Message-ID: <1394712342-15778-327-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The UPS feature only works for runtime suspend, so UPS flags only
need to be set before enabling runtime suspend. Therefore, I create
a struct to record relative information, and use it before runtime
suspend.

All chips could record such information, even though not all of
them support the feature of UPS. Then, some functions could be
combined.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 215 +++++++++++++++++++++++-----------------
 1 file changed, 125 insertions(+), 90 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 778d27d1fb15..86c403d12b6b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -445,18 +445,18 @@
 #define UPS_FLAGS_250M_CKDIV		BIT(2)
 #define UPS_FLAGS_EN_ALDPS		BIT(3)
 #define UPS_FLAGS_CTAP_SHORT_DIS	BIT(4)
-#define UPS_FLAGS_SPEED_MASK		(0xf << 16)
 #define ups_flags_speed(x)		((x) << 16)
 #define UPS_FLAGS_EN_EEE		BIT(20)
 #define UPS_FLAGS_EN_500M_EEE		BIT(21)
 #define UPS_FLAGS_EN_EEE_CKDIV		BIT(22)
+#define UPS_FLAGS_EEE_PLLOFF_100	BIT(23)
 #define UPS_FLAGS_EEE_PLLOFF_GIGA	BIT(24)
 #define UPS_FLAGS_EEE_CMOD_LV_EN	BIT(25)
 #define UPS_FLAGS_EN_GREEN		BIT(26)
 #define UPS_FLAGS_EN_FLOW_CTR		BIT(27)
 
 enum spd_duplex {
-	NWAY_10M_HALF = 1,
+	NWAY_10M_HALF,
 	NWAY_10M_FULL,
 	NWAY_100M_HALF,
 	NWAY_100M_FULL,
@@ -749,6 +749,23 @@ struct r8152 {
 		void (*autosuspend_en)(struct r8152 *tp, bool enable);
 	} rtl_ops;
 
+	struct ups_info {
+		u32 _10m_ckdiv:1;
+		u32 _250m_ckdiv:1;
+		u32 aldps:1;
+		u32 lite_mode:2;
+		u32 speed_duplex:4;
+		u32 eee:1;
+		u32 eee_lite:1;
+		u32 eee_ckdiv:1;
+		u32 eee_plloff_100:1;
+		u32 eee_plloff_giga:1;
+		u32 eee_cmod_lv:1;
+		u32 green:1;
+		u32 flow_control:1;
+		u32 ctap_short_off:1;
+	} ups_info;
+
 	atomic_t rx_count;
 
 	bool eee_en;
@@ -2857,14 +2874,76 @@ static void r8153_u2p3en(struct r8152 *tp, bool enable)
 	ocp_write_word(tp, MCU_TYPE_USB, USB_U2P3_CTRL, ocp_data);
 }
 
-static void r8153b_ups_flags_w1w0(struct r8152 *tp, u32 set, u32 clear)
+static void r8153b_ups_flags(struct r8152 *tp)
 {
-	u32 ocp_data;
+	u32 ups_flags = 0;
+
+	if (tp->ups_info.green)
+		ups_flags |= UPS_FLAGS_EN_GREEN;
+
+	if (tp->ups_info.aldps)
+		ups_flags |= UPS_FLAGS_EN_ALDPS;
+
+	if (tp->ups_info.eee)
+		ups_flags |= UPS_FLAGS_EN_EEE;
+
+	if (tp->ups_info.flow_control)
+		ups_flags |= UPS_FLAGS_EN_FLOW_CTR;
+
+	if (tp->ups_info.eee_ckdiv)
+		ups_flags |= UPS_FLAGS_EN_EEE_CKDIV;
+
+	if (tp->ups_info.eee_cmod_lv)
+		ups_flags |= UPS_FLAGS_EEE_CMOD_LV_EN;
+
+	if (tp->ups_info._10m_ckdiv)
+		ups_flags |= UPS_FLAGS_EN_10M_CKDIV;
+
+	if (tp->ups_info.eee_plloff_100)
+		ups_flags |= UPS_FLAGS_EEE_PLLOFF_100;
+
+	if (tp->ups_info.eee_plloff_giga)
+		ups_flags |= UPS_FLAGS_EEE_PLLOFF_GIGA;
+
+	if (tp->ups_info._250m_ckdiv)
+		ups_flags |= UPS_FLAGS_250M_CKDIV;
+
+	if (tp->ups_info.ctap_short_off)
+		ups_flags |= UPS_FLAGS_CTAP_SHORT_DIS;
+
+	switch (tp->ups_info.speed_duplex) {
+	case NWAY_10M_HALF:
+		ups_flags |= ups_flags_speed(1);
+		break;
+	case NWAY_10M_FULL:
+		ups_flags |= ups_flags_speed(2);
+		break;
+	case NWAY_100M_HALF:
+		ups_flags |= ups_flags_speed(3);
+		break;
+	case NWAY_100M_FULL:
+		ups_flags |= ups_flags_speed(4);
+		break;
+	case NWAY_1000M_FULL:
+		ups_flags |= ups_flags_speed(5);
+		break;
+	case FORCE_10M_HALF:
+		ups_flags |= ups_flags_speed(6);
+		break;
+	case FORCE_10M_FULL:
+		ups_flags |= ups_flags_speed(7);
+		break;
+	case FORCE_100M_HALF:
+		ups_flags |= ups_flags_speed(8);
+		break;
+	case FORCE_100M_FULL:
+		ups_flags |= ups_flags_speed(9);
+		break;
+	default:
+		break;
+	}
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_USB, USB_UPS_FLAGS);
-	ocp_data &= ~clear;
-	ocp_data |= set;
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPS_FLAGS, ocp_data);
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPS_FLAGS, ups_flags);
 }
 
 static void r8153b_green_en(struct r8152 *tp, bool enable)
@@ -2885,7 +2964,7 @@ static void r8153b_green_en(struct r8152 *tp, bool enable)
 	data |= GREEN_ETH_EN;
 	sram_write(tp, SRAM_GREEN_CFG, data);
 
-	r8153b_ups_flags_w1w0(tp, UPS_FLAGS_EN_GREEN, 0);
+	tp->ups_info.green = enable;
 }
 
 static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
@@ -2915,6 +2994,8 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 	u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_POWER_CUT);
 
 	if (enable) {
+		r8153b_ups_flags(tp);
+
 		ocp_data |= UPS_EN | USP_PREWAKE | PHASE2_EN;
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
 
@@ -3223,16 +3304,8 @@ static void r8153_eee_en(struct r8152 *tp, bool enable)
 
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
 	ocp_reg_write(tp, OCP_EEE_CFG, config);
-}
-
-static void r8153b_eee_en(struct r8152 *tp, bool enable)
-{
-	r8153_eee_en(tp, enable);
 
-	if (enable)
-		r8153b_ups_flags_w1w0(tp, UPS_FLAGS_EN_EEE, 0);
-	else
-		r8153b_ups_flags_w1w0(tp, 0, UPS_FLAGS_EN_EEE);
+	tp->ups_info.eee = enable;
 }
 
 static void rtl_eee_enable(struct r8152 *tp, bool enable)
@@ -3254,21 +3327,13 @@ static void rtl_eee_enable(struct r8152 *tp, bool enable)
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
-		if (enable) {
-			r8153_eee_en(tp, true);
-			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
-		} else {
-			r8153_eee_en(tp, false);
-			ocp_reg_write(tp, OCP_EEE_ADV, 0);
-		}
-		break;
 	case RTL_VER_08:
 	case RTL_VER_09:
 		if (enable) {
-			r8153b_eee_en(tp, true);
+			r8153_eee_en(tp, true);
 			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
 		} else {
-			r8153b_eee_en(tp, false);
+			r8153_eee_en(tp, false);
 			ocp_reg_write(tp, OCP_EEE_ADV, 0);
 		}
 		break;
@@ -3284,6 +3349,8 @@ static void r8152b_enable_fc(struct r8152 *tp)
 	anar = r8152_mdio_read(tp, MII_ADVERTISE);
 	anar |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
 	r8152_mdio_write(tp, MII_ADVERTISE, anar);
+
+	tp->ups_info.flow_control = true;
 }
 
 static void rtl8152_disable(struct r8152 *tp)
@@ -3477,22 +3544,8 @@ static void r8153_aldps_en(struct r8152 *tp, bool enable)
 				break;
 		}
 	}
-}
-
-static void r8153b_aldps_en(struct r8152 *tp, bool enable)
-{
-	r8153_aldps_en(tp, enable);
-
-	if (enable)
-		r8153b_ups_flags_w1w0(tp, UPS_FLAGS_EN_ALDPS, 0);
-	else
-		r8153b_ups_flags_w1w0(tp, 0, UPS_FLAGS_EN_ALDPS);
-}
 
-static void r8153b_enable_fc(struct r8152 *tp)
-{
-	r8152b_enable_fc(tp);
-	r8153b_ups_flags_w1w0(tp, UPS_FLAGS_EN_FLOW_CTR, 0);
+	tp->ups_info.aldps = enable;
 }
 
 static void r8153_hw_phy_cfg(struct r8152 *tp)
@@ -3569,11 +3622,11 @@ static u32 r8152_efuse_read(struct r8152 *tp, u8 addr)
 
 static void r8153b_hw_phy_cfg(struct r8152 *tp)
 {
-	u32 ocp_data, ups_flags = 0;
+	u32 ocp_data;
 	u16 data;
 
 	/* disable ALDPS before updating the PHY parameters */
-	r8153b_aldps_en(tp, false);
+	r8153_aldps_en(tp, false);
 
 	/* disable EEE before updating the PHY parameters */
 	rtl_eee_enable(tp, false);
@@ -3621,28 +3674,27 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 		data = ocp_reg_read(tp, OCP_POWER_CFG);
 		data |= EEE_CLKDIV_EN;
 		ocp_reg_write(tp, OCP_POWER_CFG, data);
+		tp->ups_info.eee_ckdiv = true;
 
 		data = ocp_reg_read(tp, OCP_DOWN_SPEED);
 		data |= EN_EEE_CMODE | EN_EEE_1000 | EN_10M_CLKDIV;
 		ocp_reg_write(tp, OCP_DOWN_SPEED, data);
+		tp->ups_info.eee_cmod_lv = true;
+		tp->ups_info._10m_ckdiv = true;
+		tp->ups_info.eee_plloff_giga = true;
 
 		ocp_reg_write(tp, OCP_SYSCLK_CFG, 0);
 		ocp_reg_write(tp, OCP_SYSCLK_CFG, clk_div_expo(5));
-
-		ups_flags |= UPS_FLAGS_EN_10M_CKDIV | UPS_FLAGS_250M_CKDIV |
-			     UPS_FLAGS_EN_EEE_CKDIV | UPS_FLAGS_EEE_CMOD_LV_EN |
-			     UPS_FLAGS_EEE_PLLOFF_GIGA;
+		tp->ups_info._250m_ckdiv = true;
 
 		r8153_patch_request(tp, false);
 	}
 
-	r8153b_ups_flags_w1w0(tp, ups_flags, 0);
-
 	if (tp->eee_en)
 		rtl_eee_enable(tp, true);
 
-	r8153b_aldps_en(tp, true);
-	r8153b_enable_fc(tp);
+	r8153_aldps_en(tp, true);
+	r8152b_enable_fc(tp);
 	r8153_u2p3en(tp, true);
 
 	set_bit(PHY_RESET, &tp->flags);
@@ -3793,18 +3845,9 @@ static void rtl8153_disable(struct r8152 *tp)
 	r8153_aldps_en(tp, true);
 }
 
-static void rtl8153b_disable(struct r8152 *tp)
-{
-	r8153b_aldps_en(tp, false);
-	rtl_disable(tp);
-	rtl_reset_bmu(tp);
-	r8153b_aldps_en(tp, true);
-}
-
 static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u16 speed, u8 duplex)
 {
 	u16 bmcr, anar, gbcr;
-	enum spd_duplex speed_duplex;
 	int ret = 0;
 
 	anar = r8152_mdio_read(tp, MII_ADVERTISE);
@@ -3821,43 +3864,46 @@ static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u16 speed, u8 duplex)
 		if (speed == SPEED_10) {
 			bmcr = 0;
 			anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
-			speed_duplex = FORCE_10M_HALF;
+			if (duplex == DUPLEX_FULL)
+				tp->ups_info.speed_duplex = FORCE_10M_FULL;
+			else
+				tp->ups_info.speed_duplex = FORCE_10M_HALF;
 		} else if (speed == SPEED_100) {
 			bmcr = BMCR_SPEED100;
 			anar |= ADVERTISE_100HALF | ADVERTISE_100FULL;
-			speed_duplex = FORCE_100M_HALF;
+			if (duplex == DUPLEX_FULL)
+				tp->ups_info.speed_duplex = FORCE_100M_FULL;
+			else
+				tp->ups_info.speed_duplex = FORCE_100M_HALF;
 		} else if (speed == SPEED_1000 && tp->mii.supports_gmii) {
 			bmcr = BMCR_SPEED1000;
 			gbcr |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
-			speed_duplex = NWAY_1000M_FULL;
+			tp->ups_info.speed_duplex = NWAY_1000M_FULL;
 		} else {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		if (duplex == DUPLEX_FULL) {
+		if (duplex == DUPLEX_FULL)
 			bmcr |= BMCR_FULLDPLX;
-			if (speed != SPEED_1000)
-				speed_duplex++;
-		}
 	} else {
 		if (speed == SPEED_10) {
 			if (duplex == DUPLEX_FULL) {
 				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
-				speed_duplex = NWAY_10M_FULL;
+				tp->ups_info.speed_duplex = NWAY_10M_FULL;
 			} else {
 				anar |= ADVERTISE_10HALF;
-				speed_duplex = NWAY_10M_HALF;
+				tp->ups_info.speed_duplex = NWAY_10M_HALF;
 			}
 		} else if (speed == SPEED_100) {
 			if (duplex == DUPLEX_FULL) {
 				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
 				anar |= ADVERTISE_100HALF | ADVERTISE_100FULL;
-				speed_duplex = NWAY_100M_FULL;
+				tp->ups_info.speed_duplex = NWAY_100M_FULL;
 			} else {
 				anar |= ADVERTISE_10HALF;
 				anar |= ADVERTISE_100HALF;
-				speed_duplex = NWAY_100M_HALF;
+				tp->ups_info.speed_duplex = NWAY_100M_HALF;
 			}
 		} else if (speed == SPEED_1000 && tp->mii.supports_gmii) {
 			if (duplex == DUPLEX_FULL) {
@@ -3869,7 +3915,7 @@ static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u16 speed, u8 duplex)
 				anar |= ADVERTISE_100HALF;
 				gbcr |= ADVERTISE_1000HALF;
 			}
-			speed_duplex = NWAY_1000M_FULL;
+			tp->ups_info.speed_duplex = NWAY_1000M_FULL;
 		} else {
 			ret = -EINVAL;
 			goto out;
@@ -3887,17 +3933,6 @@ static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u16 speed, u8 duplex)
 	r8152_mdio_write(tp, MII_ADVERTISE, anar);
 	r8152_mdio_write(tp, MII_BMCR, bmcr);
 
-	switch (tp->version) {
-	case RTL_VER_08:
-	case RTL_VER_09:
-		r8153b_ups_flags_w1w0(tp, ups_flags_speed(speed_duplex),
-				      UPS_FLAGS_SPEED_MASK);
-		break;
-
-	default:
-		break;
-	}
-
 	if (bmcr & BMCR_RESET) {
 		int i;
 
@@ -3982,12 +4017,12 @@ static void rtl8153b_up(struct r8152 *tp)
 
 	r8153b_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
-	r8153b_aldps_en(tp, false);
+	r8153_aldps_en(tp, false);
 
 	r8153_first_init(tp);
 	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
 
-	r8153b_aldps_en(tp, true);
+	r8153_aldps_en(tp, true);
 	r8153_u2p3en(tp, true);
 	r8153b_u1u2en(tp, true);
 }
@@ -4002,9 +4037,9 @@ static void rtl8153b_down(struct r8152 *tp)
 	r8153b_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
 	r8153b_power_cut_en(tp, false);
-	r8153b_aldps_en(tp, false);
+	r8153_aldps_en(tp, false);
 	r8153_enter_oob(tp);
-	r8153b_aldps_en(tp, true);
+	r8153_aldps_en(tp, true);
 }
 
 static bool rtl8152_in_nway(struct r8152 *tp)
@@ -5383,7 +5418,7 @@ static int rtl_ops_init(struct r8152 *tp)
 	case RTL_VER_09:
 		ops->init		= r8153b_init;
 		ops->enable		= rtl8153_enable;
-		ops->disable		= rtl8153b_disable;
+		ops->disable		= rtl8153_disable;
 		ops->up			= rtl8153b_up;
 		ops->down		= rtl8153b_down;
 		ops->unload		= rtl8153b_unload;
-- 
2.21.0

