Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5679A32C40F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhCDAKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:42 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:59074 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240080AbhCCK2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:28:08 -0500
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1238eOTu9009089, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 1238eOTu9009089
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 3 Mar 2021 16:40:24 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 3 Mar 2021
 16:40:24 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
Date:   Wed, 3 Mar 2021 16:39:47 +0800
Message-ID: <1394712342-15778-347-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 134f98bcf1b898fb9d6f2b91bc85dd2e5478b4b8.

The r8153_mac_clk_spd() is used for RTL8153A only, because the register
table of RTL8153B is different from RTL8153A. However, this function would
be called when RTL8153B calls r8153_first_init() and r8153_enter_oob().
That causes RTL8153B becomes unstable when suspending and resuming. The
worst case may let the device stop working.

Besides, revert this commit to disable MAC clock speed down for RTL8153A.
It would avoid the known issue when enabling U1. The data of the first
control transfer may be wrong when exiting U1.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b246817f3405..90f1c0200042 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3021,29 +3021,6 @@ static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
 		device_set_wakeup_enable(&tp->udev->dev, false);
 }
 
-static void r8153_mac_clk_spd(struct r8152 *tp, bool enable)
-{
-	/* MAC clock speed down */
-	if (enable) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL,
-			       ALDPS_SPDWN_RATIO);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2,
-			       EEE_SPDWN_RATIO);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3,
-			       PKT_AVAIL_SPDWN_EN | SUSPEND_SPDWN_EN |
-			       U1U2_SPDWN_EN | L1_SPDWN_EN);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4,
-			       PWRSAVE_SPDWN_EN | RXDV_SPDWN_EN | TX10MIDLE_EN |
-			       TP100_SPDWN_EN | TP500_SPDWN_EN | EEE_SPDWN_EN |
-			       TP1000_SPDWN_EN);
-	} else {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
-	}
-}
-
 static void r8153_u1u2en(struct r8152 *tp, bool enable)
 {
 	u8 u1u2[8];
@@ -3338,11 +3315,9 @@ static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
 	if (enable) {
 		r8153_u1u2en(tp, false);
 		r8153_u2p3en(tp, false);
-		r8153_mac_clk_spd(tp, true);
 		rtl_runtime_suspend_enable(tp, true);
 	} else {
 		rtl_runtime_suspend_enable(tp, false);
-		r8153_mac_clk_spd(tp, false);
 
 		switch (tp->version) {
 		case RTL_VER_03:
@@ -4718,7 +4693,6 @@ static void r8153_first_init(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	r8153_mac_clk_spd(tp, false);
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 
@@ -4769,8 +4743,6 @@ static void r8153_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	r8153_mac_clk_spd(tp, true);
-
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
@@ -5496,10 +5468,15 @@ static void r8153_init(struct r8152 *tp)
 
 	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
 
+	/* MAC clock speed down */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
+
 	r8153_power_cut_en(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
 	r8153_u1u2en(tp, true);
-	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-- 
2.26.2

