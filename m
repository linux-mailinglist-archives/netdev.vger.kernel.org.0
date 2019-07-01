Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786D05B622
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 09:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfGAHxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 03:53:47 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33209 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfGAHxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 03:53:46 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x617rh0D004617, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x617rh0D004617
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 1 Jul 2019 15:53:43 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.439.0; Mon, 1 Jul 2019
 15:53:42 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: fix the setting of detecting the linking change for runtime suspend
Date:   Mon, 1 Jul 2019 15:53:19 +0800
Message-ID: <1394712342-15778-286-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Rename r8153b_queue_wake() to r8153_queue_wake().

2. Correct the setting. The enable bit should be 0xd38c bit 0. Besides,
   the 0xd38a bit 0 and 0xd398 bit 8 have to be cleared for both enabled
   and disabled.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e0dcb681cfe5..101d1325f3f1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -53,6 +53,9 @@
 #define PAL_BDC_CR		0xd1a0
 #define PLA_TEREDO_TIMER	0xd2cc
 #define PLA_REALWOW_TIMER	0xd2e8
+#define PLA_SUSPEND_FLAG	0xd38a
+#define PLA_INDICATE_FALG	0xd38c
+#define PLA_EXTRA_STATUS	0xd398
 #define PLA_EFUSE_DATA		0xdd00
 #define PLA_EFUSE_CMD		0xdd02
 #define PLA_LEDSEL		0xdd90
@@ -336,6 +339,15 @@
 /* PLA_BOOT_CTRL */
 #define AUTOLOAD_DONE		0x0002
 
+/* PLA_SUSPEND_FLAG */
+#define LINK_CHG_EVENT		BIT(0)
+
+/* PLA_INDICATE_FALG */
+#define UPCOMING_RUNTIME_D3	BIT(0)
+
+/* PLA_EXTRA_STATUS */
+#define LINK_CHANGE_FLAG	BIT(8)
+
 /* USB_USB2PHY */
 #define USB2PHY_SUSPEND		0x0001
 #define USB2PHY_L1		0x0002
@@ -2806,20 +2818,24 @@ static void r8153b_power_cut_en(struct r8152 *tp, bool enable)
 	ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
 }
 
-static void r8153b_queue_wake(struct r8152 *tp, bool enable)
+static void r8153_queue_wake(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, 0xd38a);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_INDICATE_FALG);
 	if (enable)
-		ocp_data |= BIT(0);
+		ocp_data |= UPCOMING_RUNTIME_D3;
 	else
-		ocp_data &= ~BIT(0);
-	ocp_write_byte(tp, MCU_TYPE_PLA, 0xd38a, ocp_data);
+		ocp_data &= ~UPCOMING_RUNTIME_D3;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_INDICATE_FALG, ocp_data);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_SUSPEND_FLAG);
+	ocp_data &= ~LINK_CHG_EVENT;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_SUSPEND_FLAG, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, 0xd38c);
-	ocp_data &= ~BIT(0);
-	ocp_write_byte(tp, MCU_TYPE_PLA, 0xd38c, ocp_data);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+	ocp_data &= ~LINK_CHANGE_FLAG;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 }
 
 static bool rtl_can_wakeup(struct r8152 *tp)
@@ -2887,14 +2903,14 @@ static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
 static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 {
 	if (enable) {
-		r8153b_queue_wake(tp, true);
+		r8153_queue_wake(tp, true);
 		r8153b_u1u2en(tp, false);
 		r8153_u2p3en(tp, false);
 		rtl_runtime_suspend_enable(tp, true);
 		r8153b_ups_en(tp, true);
 	} else {
 		r8153b_ups_en(tp, false);
-		r8153b_queue_wake(tp, false);
+		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
 		r8153_u2p3en(tp, true);
 		r8153b_u1u2en(tp, true);
@@ -4221,7 +4237,7 @@ static void r8153b_init(struct r8152 *tp)
 
 	r8153b_power_cut_en(tp, false);
 	r8153b_ups_en(tp, false);
-	r8153b_queue_wake(tp, false);
+	r8153_queue_wake(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
 	r8153b_u1u2en(tp, true);
 	usb_enable_lpm(tp->udev);
-- 
2.21.0

