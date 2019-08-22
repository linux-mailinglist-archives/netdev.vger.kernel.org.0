Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D013798D02
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbfHVIHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:07:47 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33281 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfHVIHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 04:07:47 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7M87iPY023756, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7M87iPY023756
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 22 Aug 2019 16:07:44 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Thu, 22 Aug 2019
 16:07:43 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: saving the settings of EEE
Date:   Thu, 22 Aug 2019 16:07:18 +0800
Message-ID: <1394712342-15778-304-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saving the settings of EEE to avoid they become the default settings
after reset_resume().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 86 +++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 30 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1aa61610f0bb..bbc65a94a83f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -751,6 +751,7 @@ struct r8152 {
 
 	atomic_t rx_count;
 
+	bool eee_en;
 	int intr_interval;
 	u32 saved_wolopts;
 	u32 msg_enable;
@@ -762,6 +763,7 @@ struct r8152 {
 
 	u16 ocp_base;
 	u16 speed;
+	u16 eee_adv;
 	u8 *intr_buff;
 	u8 version;
 	u8 duplex;
@@ -3202,8 +3204,13 @@ static void r8152_eee_en(struct r8152 *tp, bool enable)
 
 static void r8152b_enable_eee(struct r8152 *tp)
 {
-	r8152_eee_en(tp, true);
-	r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, MDIO_EEE_100TX);
+	if (tp->eee_en) {
+		r8152_eee_en(tp, true);
+		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, tp->eee_adv);
+	} else {
+		r8152_eee_en(tp, false);
+		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+	}
 }
 
 static void r8152b_enable_fc(struct r8152 *tp)
@@ -3495,8 +3502,13 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 	sram_write(tp, SRAM_10M_AMP1, 0x00af);
 	sram_write(tp, SRAM_10M_AMP2, 0x0208);
 
-	r8153_eee_en(tp, true);
-	ocp_reg_write(tp, OCP_EEE_ADV, MDIO_EEE_1000T | MDIO_EEE_100TX);
+	if (tp->eee_en) {
+		r8153_eee_en(tp, true);
+		ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+	} else {
+		r8153_eee_en(tp, false);
+		ocp_reg_write(tp, OCP_EEE_ADV, 0);
+	}
 
 	r8153_aldps_en(tp, true);
 	r8152b_enable_fc(tp);
@@ -3599,8 +3611,13 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 
 	r8153b_ups_flags_w1w0(tp, ups_flags, 0);
 
-	r8153b_eee_en(tp, true);
-	ocp_reg_write(tp, OCP_EEE_ADV, MDIO_EEE_1000T | MDIO_EEE_100TX);
+	if (tp->eee_en) {
+		r8153b_eee_en(tp, true);
+		ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+	} else {
+		r8153b_eee_en(tp, false);
+		ocp_reg_write(tp, OCP_EEE_ADV, 0);
+	}
 
 	r8153b_aldps_en(tp, true);
 	r8153b_enable_fc(tp);
@@ -4891,7 +4908,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 
 static int r8152_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
-	u32 ocp_data, lp, adv, supported = 0;
+	u32 lp, adv, supported = 0;
 	u16 val;
 
 	val = r8152_mmd_read(tp, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
@@ -4903,13 +4920,10 @@ static int r8152_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 	val = r8152_mmd_read(tp, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
 	lp = mmd_eee_adv_to_ethtool_adv_t(val);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
-	ocp_data &= EEE_RX_EN | EEE_TX_EN;
-
-	eee->eee_enabled = !!ocp_data;
+	eee->eee_enabled = tp->eee_en;
 	eee->eee_active = !!(supported & adv & lp);
 	eee->supported = supported;
-	eee->advertised = adv;
+	eee->advertised = tp->eee_adv;
 	eee->lp_advertised = lp;
 
 	return 0;
@@ -4919,19 +4933,22 @@ static int r8152_set_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
 	u16 val = ethtool_adv_to_mmd_eee_adv_t(eee->advertised);
 
-	r8152_eee_en(tp, eee->eee_enabled);
+	tp->eee_en = eee->eee_enabled;
+	tp->eee_adv = val;
 
-	if (!eee->eee_enabled)
-		val = 0;
+	r8152_eee_en(tp, eee->eee_enabled);
 
-	r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, val);
+	if (eee->eee_enabled)
+		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, val);
+	else
+		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
 
 	return 0;
 }
 
 static int r8153_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
-	u32 ocp_data, lp, adv, supported = 0;
+	u32 lp, adv, supported = 0;
 	u16 val;
 
 	val = ocp_reg_read(tp, OCP_EEE_ABLE);
@@ -4943,13 +4960,10 @@ static int r8153_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 	val = ocp_reg_read(tp, OCP_EEE_LPABLE);
 	lp = mmd_eee_adv_to_ethtool_adv_t(val);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
-	ocp_data &= EEE_RX_EN | EEE_TX_EN;
-
-	eee->eee_enabled = !!ocp_data;
+	eee->eee_enabled = tp->eee_en;
 	eee->eee_active = !!(supported & adv & lp);
 	eee->supported = supported;
-	eee->advertised = adv;
+	eee->advertised = tp->eee_adv;
 	eee->lp_advertised = lp;
 
 	return 0;
@@ -4959,12 +4973,15 @@ static int r8153_set_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
 	u16 val = ethtool_adv_to_mmd_eee_adv_t(eee->advertised);
 
-	r8153_eee_en(tp, eee->eee_enabled);
+	tp->eee_en = eee->eee_enabled;
+	tp->eee_adv = val;
 
-	if (!eee->eee_enabled)
-		val = 0;
+	r8153_eee_en(tp, eee->eee_enabled);
 
-	ocp_reg_write(tp, OCP_EEE_ADV, val);
+	if (eee->eee_enabled)
+		ocp_reg_write(tp, OCP_EEE_ADV, val);
+	else
+		ocp_reg_write(tp, OCP_EEE_ADV, 0);
 
 	return 0;
 }
@@ -4973,12 +4990,15 @@ static int r8153b_set_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
 	u16 val = ethtool_adv_to_mmd_eee_adv_t(eee->advertised);
 
-	r8153b_eee_en(tp, eee->eee_enabled);
+	tp->eee_en = eee->eee_enabled;
+	tp->eee_adv = val;
 
-	if (!eee->eee_enabled)
-		val = 0;
+	r8153b_eee_en(tp, eee->eee_enabled);
 
-	ocp_reg_write(tp, OCP_EEE_ADV, val);
+	if (eee->eee_enabled)
+		ocp_reg_write(tp, OCP_EEE_ADV, val);
+	else
+		ocp_reg_write(tp, OCP_EEE_ADV, 0);
 
 	return 0;
 }
@@ -5353,6 +5373,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->hw_phy_cfg		= r8152b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl_runtime_suspend_enable;
 		tp->rx_buf_sz		= 16 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_100TX;
 		break;
 
 	case RTL_VER_03:
@@ -5371,6 +5393,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
 		tp->rx_buf_sz		= 32 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
 		break;
 
 	case RTL_VER_08:
@@ -5387,6 +5411,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153b_runtime_enable;
 		tp->rx_buf_sz		= 32 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
 		break;
 
 	default:
-- 
2.21.0

