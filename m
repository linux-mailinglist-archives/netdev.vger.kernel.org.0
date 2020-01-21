Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D102143D1B
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgAUMnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:43:07 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54713 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbgAUMnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:43:05 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00LCh1k0011023, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00LCh1k0011023
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 21 Jan 2020 20:43:01 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Tue, 21 Jan 2020
 20:42:59 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 8/9] r8152: avoid the MCU to clear the lanwake
Date:   Tue, 21 Jan 2020 20:40:34 +0800
Message-ID: <1394712342-15778-346-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-338-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the MCU to clear the lanwake after suspending. It may cause the
WOL fail. Disable LANWAKE_CLR_EN before suspending. Besides,enable it
and reset the lanwake status when resuming or initializing.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 73256dfe77d7..0998b9587943 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -68,6 +68,7 @@
 #define PLA_LED_FEATURE		0xdd92
 #define PLA_PHYAR		0xde00
 #define PLA_BOOT_CTRL		0xe004
+#define PLA_LWAKE_CTRL_REG	0xe007
 #define PLA_GPHY_INTR_IMR	0xe022
 #define PLA_EEE_CR		0xe040
 #define PLA_EEEP_CR		0xe080
@@ -95,6 +96,7 @@
 #define PLA_TALLYCNT		0xe890
 #define PLA_SFF_STS_7		0xe8de
 #define PLA_PHYSTATUS		0xe908
+#define PLA_CONFIG6		0xe90a /* CONFIG6 */
 #define PLA_BP_BA		0xfc26
 #define PLA_BP_0		0xfc28
 #define PLA_BP_1		0xfc2a
@@ -300,6 +302,9 @@
 #define LINK_ON_WAKE_EN		0x0010
 #define LINK_OFF_WAKE_EN	0x0008
 
+/* PLA_CONFIG6 */
+#define LANWAKE_CLR_EN		BIT(0)
+
 /* PLA_CONFIG5 */
 #define BWF_EN			0x0040
 #define MWF_EN			0x0020
@@ -356,6 +361,9 @@
 /* PLA_BOOT_CTRL */
 #define AUTOLOAD_DONE		0x0002
 
+/* PLA_LWAKE_CTRL_REG */
+#define LANWAKE_PIN		BIT(7)
+
 /* PLA_SUSPEND_FLAG */
 #define LINK_CHG_EVENT		BIT(0)
 
@@ -4967,6 +4975,8 @@ static void rtl8152_down(struct r8152 *tp)
 
 static void rtl8153_up(struct r8152 *tp)
 {
+	u32 ocp_data;
+
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
@@ -4974,6 +4984,15 @@ static void rtl8153_up(struct r8152 *tp)
 	r8153_u2p3en(tp, false);
 	r8153_aldps_en(tp, false);
 	r8153_first_init(tp);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+
 	r8153_aldps_en(tp, true);
 
 	switch (tp->version) {
@@ -4992,11 +5011,17 @@ static void rtl8153_up(struct r8152 *tp)
 
 static void rtl8153_down(struct r8152 *tp)
 {
+	u32 ocp_data;
+
 	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
 		rtl_drop_queued_tx(tp);
 		return;
 	}
 
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data &= ~LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
 	r8153_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
 	r8153_power_cut_en(tp, false);
@@ -5457,6 +5482,14 @@ static void r8153_init(struct r8152 *tp)
 	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+
 	/* rx aggregation */
 	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-- 
2.21.0

