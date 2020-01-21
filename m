Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC13143D19
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgAUMnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:43:02 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54704 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbgAUMnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:43:01 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00LCgv1Y011014, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00LCgv1Y011014
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 21 Jan 2020 20:42:57 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Tue, 21 Jan 2020
 20:42:56 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 6/9] r8152: disable test IO for RTL8153B
Date:   Tue, 21 Jan 2020 20:40:32 +0800
Message-ID: <1394712342-15778-344-Taiwan-albertk@realtek.com>
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

For RTL8153B with QFN32, disable test IO. Otherwise, it may casue
abnormal behavior for the device randomly.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index eabc7b43d48b..958c7c342bfb 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -312,6 +312,7 @@
 /* PLA_PHY_PWR */
 #define TX_10M_IDLE_EN		0x0080
 #define PFM_PWM_SWITCH		0x0040
+#define TEST_IO_OFF		BIT(4)
 
 /* PLA_MAC_PWR_CTRL */
 #define D3_CLK_GATED_EN		0x00004000
@@ -5537,6 +5538,15 @@ static void r8153b_init(struct r8152 *tp)
 	ocp_data &= ~PLA_MCU_SPDWN_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
 
+	if (tp->version == RTL_VER_09) {
+		/* Disable Test IO for 32QFN */
+		if (ocp_read_byte(tp, MCU_TYPE_PLA, 0xdc00) & BIT(5)) {
+			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+			ocp_data |= TEST_IO_OFF;
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+		}
+	}
+
 	set_bit(GREEN_ETHERNET, &tp->flags);
 
 	/* rx aggregation */
-- 
2.21.0

