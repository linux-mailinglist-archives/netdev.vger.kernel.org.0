Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E6E31F647
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBSJJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:09:00 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44430 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhBSJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:06:07 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11J95BBI0013696, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11J95BBI0013696
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Feb 2021 17:05:11 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Feb
 2021 17:05:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 4/4] r8152: spilt rtl_set_eee_plus and r8153b_green_en
Date:   Fri, 19 Feb 2021 17:04:43 +0800
Message-ID: <1394712342-15778-345-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-341-Taiwan-albertk@realtek.com>
References: <1394712342-15778-341-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rtl_eee_plus_en() and rtl_green_en().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 43 ++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 82a129264e31..b246817f3405 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2632,21 +2632,24 @@ static inline u8 rtl8152_get_speed(struct r8152 *tp)
 	return ocp_read_byte(tp, MCU_TYPE_PLA, PLA_PHYSTATUS);
 }
 
-static void rtl_set_eee_plus(struct r8152 *tp)
+static void rtl_eee_plus_en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
-	u8 speed;
 
-	speed = rtl8152_get_speed(tp);
-	if (speed & _10bps) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR);
+	if (enable)
 		ocp_data |= EEEP_CR_EEEP_TX;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR, ocp_data);
-	} else {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR);
+	else
 		ocp_data &= ~EEEP_CR_EEEP_TX;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR, ocp_data);
-	}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR, ocp_data);
+}
+
+static void rtl_set_eee_plus(struct r8152 *tp)
+{
+	if (rtl8152_get_speed(tp) & _10bps)
+		rtl_eee_plus_en(tp, true);
+	else
+		rtl_eee_plus_en(tp, false);
 }
 
 static void rxdy_gated_en(struct r8152 *tp, bool enable)
@@ -3150,10 +3153,22 @@ static void r8153b_ups_flags(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPS_FLAGS, ups_flags);
 }
 
-static void r8153b_green_en(struct r8152 *tp, bool enable)
+static void rtl_green_en(struct r8152 *tp, bool enable)
 {
 	u16 data;
 
+	data = sram_read(tp, SRAM_GREEN_CFG);
+	if (enable)
+		data |= GREEN_ETH_EN;
+	else
+		data &= ~GREEN_ETH_EN;
+	sram_write(tp, SRAM_GREEN_CFG, data);
+
+	tp->ups_info.green = enable;
+}
+
+static void r8153b_green_en(struct r8152 *tp, bool enable)
+{
 	if (enable) {
 		sram_write(tp, 0x8045, 0);	/* 10M abiq&ldvbias */
 		sram_write(tp, 0x804d, 0x1222);	/* 100M short abiq&ldvbias */
@@ -3164,11 +3179,7 @@ static void r8153b_green_en(struct r8152 *tp, bool enable)
 		sram_write(tp, 0x805d, 0x2444);	/* 1000M short abiq&ldvbias */
 	}
 
-	data = sram_read(tp, SRAM_GREEN_CFG);
-	data |= GREEN_ETH_EN;
-	sram_write(tp, SRAM_GREEN_CFG, data);
-
-	tp->ups_info.green = enable;
+	rtl_green_en(tp, true);
 }
 
 static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
-- 
2.26.2

