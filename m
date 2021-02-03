Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FEC30D615
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhBCJRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:17:41 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44192 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbhBCJPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:15:42 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1139Ew3L2008969, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 1139Ew3L2008969
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 3 Feb 2021 17:14:58 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 3 Feb 2021
 17:14:57 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/2] r8152: replace several functions about phy patch request
Date:   Wed, 3 Feb 2021 17:14:28 +0800
Message-ID: <1394712342-15778-399-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-398-Taiwan-albertk@realtek.com>
References: <1394712342-15778-398-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace r8153_patch_request() with rtl_phy_patch_request().
Replace r8153_pre_ram_code() with rtl_pre_ram_code().
Replace r8153_post_ram_code() with rtl_post_ram_code().
Add rtl_patch_key_set().

The new functions have an additional parameter. It is used to wait
the patch request command finished. When the PHY is resumed from
the state of power cut, the PHY is at a safe mode and the
OCP_PHY_PATCH_STAT wouldn't be updated. For this situation, it is
safe to set patch request command without waiting OCP_PHY_PATCH_STAT.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 84 ++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 67cd6986634f..e792c1c69f14 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3470,59 +3470,76 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	ocp_write_word(tp, type, PLA_BP_BA, 0);
 }
 
-static int r8153_patch_request(struct r8152 *tp, bool request)
+static int rtl_phy_patch_request(struct r8152 *tp, bool request, bool wait)
 {
-	u16 data;
+	u16 data, check;
 	int i;
 
 	data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
-	if (request)
+	if (request) {
 		data |= PATCH_REQUEST;
-	else
+		check = 0;
+	} else {
 		data &= ~PATCH_REQUEST;
+		check = PATCH_READY;
+	}
 	ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
 
-	for (i = 0; request && i < 5000; i++) {
+	for (i = 0; wait && i < 5000; i++) {
+		u32 ocp_data;
+
 		usleep_range(1000, 2000);
-		if (ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)
+		ocp_data = ocp_reg_read(tp, OCP_PHY_PATCH_STAT);
+		if ((ocp_data & PATCH_READY) ^ check)
 			break;
 	}
 
-	if (request && !(ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)) {
-		netif_err(tp, drv, tp->netdev, "patch request fail\n");
-		r8153_patch_request(tp, false);
+	if (request && wait &&
+	    !(ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)) {
+		dev_err(&tp->intf->dev, "PHY patch request fail\n");
+		rtl_phy_patch_request(tp, false, false);
 		return -ETIME;
 	} else {
 		return 0;
 	}
 }
 
-static int r8153_pre_ram_code(struct r8152 *tp, u16 key_addr, u16 patch_key)
+static void rtl_patch_key_set(struct r8152 *tp, u16 key_addr, u16 patch_key)
 {
-	if (r8153_patch_request(tp, true)) {
-		dev_err(&tp->intf->dev, "patch request fail\n");
-		return -ETIME;
-	}
+	if (patch_key && key_addr) {
+		sram_write(tp, key_addr, patch_key);
+		sram_write(tp, SRAM_PHY_LOCK, PHY_PATCH_LOCK);
+	} else if (key_addr) {
+		u16 data;
 
-	sram_write(tp, key_addr, patch_key);
-	sram_write(tp, SRAM_PHY_LOCK, PHY_PATCH_LOCK);
+		sram_write(tp, 0x0000, 0x0000);
 
-	return 0;
+		data = ocp_reg_read(tp, OCP_PHY_LOCK);
+		data &= ~PATCH_LOCK;
+		ocp_reg_write(tp, OCP_PHY_LOCK, data);
+
+		sram_write(tp, key_addr, 0x0000);
+	} else {
+		WARN_ON_ONCE(1);
+	}
 }
 
-static int r8153_post_ram_code(struct r8152 *tp, u16 key_addr)
+static int
+rtl_pre_ram_code(struct r8152 *tp, u16 key_addr, u16 patch_key, bool wait)
 {
-	u16 data;
+	if (rtl_phy_patch_request(tp, true, wait))
+		return -ETIME;
 
-	sram_write(tp, 0x0000, 0x0000);
+	rtl_patch_key_set(tp, key_addr, patch_key);
 
-	data = ocp_reg_read(tp, OCP_PHY_LOCK);
-	data &= ~PATCH_LOCK;
-	ocp_reg_write(tp, OCP_PHY_LOCK, data);
+	return 0;
+}
 
-	sram_write(tp, key_addr, 0x0000);
+static int rtl_post_ram_code(struct r8152 *tp, u16 key_addr, bool wait)
+{
+	rtl_patch_key_set(tp, key_addr, 0);
 
-	r8153_patch_request(tp, false);
+	rtl_phy_patch_request(tp, false, wait);
 
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
 
@@ -4007,7 +4024,7 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
 	dev_dbg(&tp->intf->dev, "successfully applied %s\n", mac->info);
 }
 
-static void rtl8152_apply_firmware(struct r8152 *tp)
+static void rtl8152_apply_firmware(struct r8152 *tp, bool power_cut)
 {
 	struct rtl_fw *rtl_fw = &tp->rtl_fw;
 	const struct firmware *fw;
@@ -4038,12 +4055,11 @@ static void rtl8152_apply_firmware(struct r8152 *tp)
 		case RTL_FW_PHY_START:
 			key = (struct fw_phy_patch_key *)block;
 			key_addr = __le16_to_cpu(key->key_reg);
-			r8153_pre_ram_code(tp, key_addr,
-					   __le16_to_cpu(key->key_data));
+			rtl_pre_ram_code(tp, key_addr, __le16_to_cpu(key->key_data), !power_cut);
 			break;
 		case RTL_FW_PHY_STOP:
 			WARN_ON(!key_addr);
-			r8153_post_ram_code(tp, key_addr);
+			rtl_post_ram_code(tp, key_addr, !power_cut);
 			break;
 		case RTL_FW_PHY_NC:
 			rtl8152_fw_phy_nc_apply(tp, (struct fw_phy_nc *)block);
@@ -4248,7 +4264,7 @@ static void rtl8152_disable(struct r8152 *tp)
 
 static void r8152b_hw_phy_cfg(struct r8152 *tp)
 {
-	rtl8152_apply_firmware(tp);
+	rtl8152_apply_firmware(tp, false);
 	rtl_eee_enable(tp, tp->eee_en);
 	r8152_aldps_en(tp, true);
 	r8152b_enable_fc(tp);
@@ -4530,7 +4546,7 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 	/* disable EEE before updating the PHY parameters */
 	rtl_eee_enable(tp, false);
 
-	rtl8152_apply_firmware(tp);
+	rtl8152_apply_firmware(tp, false);
 
 	if (tp->version == RTL_VER_03) {
 		data = ocp_reg_read(tp, OCP_EEE_CFG);
@@ -4604,7 +4620,7 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 	/* disable EEE before updating the PHY parameters */
 	rtl_eee_enable(tp, false);
 
-	rtl8152_apply_firmware(tp);
+	rtl8152_apply_firmware(tp, false);
 
 	r8153b_green_en(tp, test_bit(GREEN_ETHERNET, &tp->flags));
 
@@ -4645,7 +4661,7 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
 
 	/* Advnace EEE */
-	if (!r8153_patch_request(tp, true)) {
+	if (!rtl_phy_patch_request(tp, true, true)) {
 		data = ocp_reg_read(tp, OCP_POWER_CFG);
 		data |= EEE_CLKDIV_EN;
 		ocp_reg_write(tp, OCP_POWER_CFG, data);
@@ -4662,7 +4678,7 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 		ocp_reg_write(tp, OCP_SYSCLK_CFG, clk_div_expo(5));
 		tp->ups_info._250m_ckdiv = true;
 
-		r8153_patch_request(tp, false);
+		rtl_phy_patch_request(tp, false, true);
 	}
 
 	if (tp->eee_en)
-- 
2.26.2

