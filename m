Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEADB144968
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 02:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAVBlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 20:41:55 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56777 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgAVBly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 20:41:54 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00M1fnsf019833, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00M1fnsf019833
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 22 Jan 2020 09:41:51 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV02.realtek.com.tw
 (172.21.6.19) with Microsoft SMTP Server id 14.3.468.0; Wed, 22 Jan 2020
 09:41:47 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v2 1/9] r8152: fix runtime resume for linking change
Date:   Wed, 22 Jan 2020 09:41:13 +0800
Message-ID: <1394712342-15778-349-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-348-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
 <1394712342-15778-348-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the runtime resume doesn't work normally for linking change.

1. Reset the settings and status of runtime suspend.
2. Sync the linking status.
3. Poll the linking change.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 031cb8fff909..115559707683 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -365,8 +365,10 @@
 #define DEBUG_LTSSM		0x0082
 
 /* PLA_EXTRA_STATUS */
+#define CUR_LINK_OK		BIT(15)
 #define U3P3_CHECK_EN		BIT(7)	/* RTL_VER_05 only */
 #define LINK_CHANGE_FLAG	BIT(8)
+#define POLL_LINK_CHG		BIT(0)
 
 /* USB_USB2PHY */
 #define USB2PHY_SUSPEND		0x0001
@@ -5387,6 +5389,16 @@ static void r8153_init(struct r8152 *tp)
 		else
 			ocp_data |= DYNAMIC_BURST;
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
+
+		r8153_queue_wake(tp, false);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+		if (rtl8152_get_speed(tp) & LINK_STATUS)
+			ocp_data |= CUR_LINK_OK;
+		else
+			ocp_data &= ~CUR_LINK_OK;
+		ocp_data |= POLL_LINK_CHG;
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 	}
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2);
@@ -5416,6 +5428,7 @@ static void r8153_init(struct r8152 *tp)
 	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
 
 	r8153_power_cut_en(tp, false);
+	rtl_runtime_suspend_enable(tp, false);
 	r8153_u1u2en(tp, true);
 	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
@@ -5484,6 +5497,14 @@ static void r8153b_init(struct r8152 *tp)
 	r8153b_ups_en(tp, false);
 	r8153_queue_wake(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+	if (rtl8152_get_speed(tp) & LINK_STATUS)
+		ocp_data |= CUR_LINK_OK;
+	else
+		ocp_data &= ~CUR_LINK_OK;
+	ocp_data |= POLL_LINK_CHG;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 	r8153b_u1u2en(tp, true);
 	usb_enable_lpm(tp->udev);
 
-- 
2.21.0

