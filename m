Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E56144CE7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVID5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:03:57 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:33440 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgAVIDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:03:34 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00M83VYi009789, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (smtpsrv.realtek.com[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00M83VYi009789
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 16:03:31 +0800
Received: from RTEXMB06.realtek.com.tw (172.21.6.99) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 16:03:31 +0800
Received: from RTITCASV01.realtek.com.tw (172.21.6.18) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.1779.2
 via Frontend Transport; Wed, 22 Jan 2020 16:03:31 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 22 Jan 2020
 16:03:29 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v3 7/9] r8152: don't enable U1U2 with USB_SPEED_HIGH for RTL8153B
Date:   Wed, 22 Jan 2020 16:02:11 +0800
Message-ID: <1394712342-15778-365-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-358-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
 <1394712342-15778-358-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For certain platforms, it causes USB reset periodically.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 7efeddad1fc8..b1a00f29455b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3391,7 +3391,8 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 		r8153b_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
-		r8153b_u1u2en(tp, true);
+		if (tp->udev->speed != USB_SPEED_HIGH)
+			r8153b_u1u2en(tp, true);
 	}
 }
 
@@ -5024,7 +5025,9 @@ static void rtl8153b_up(struct r8152 *tp)
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
 
 	r8153_aldps_en(tp, true);
-	r8153b_u1u2en(tp, true);
+
+	if (tp->udev->speed != USB_SPEED_HIGH)
+		r8153b_u1u2en(tp, true);
 }
 
 static void rtl8153b_down(struct r8152 *tp)
@@ -5527,7 +5530,9 @@ static void r8153b_init(struct r8152 *tp)
 		ocp_data &= ~CUR_LINK_OK;
 	ocp_data |= POLL_LINK_CHG;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
-	r8153b_u1u2en(tp, true);
+
+	if (tp->udev->speed != USB_SPEED_HIGH)
+		r8153b_u1u2en(tp, true);
 	usb_enable_lpm(tp->udev);
 
 	/* MAC clock speed down */
-- 
2.21.0

