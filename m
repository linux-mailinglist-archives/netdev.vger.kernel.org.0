Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D699F31F63D
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhBSJIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:08:16 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44426 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhBSJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:06:07 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11J95ABF0013696, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11J95ABF0013696
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Feb 2021 17:05:10 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Feb
 2021 17:05:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/4] r8152: enable U1/U2 for USB_SPEED_SUPER
Date:   Fri, 19 Feb 2021 17:04:40 +0800
Message-ID: <1394712342-15778-342-Taiwan-albertk@realtek.com>
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

U1/U2 shoued be enabled for USB 3.0 or later. The USB 2.0 doesn't
support it.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2d7cc63bef89..4bfee289aa6f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3360,7 +3360,7 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 		r8153b_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
-		if (tp->udev->speed != USB_SPEED_HIGH)
+		if (tp->udev->speed >= USB_SPEED_SUPER)
 			r8153b_u1u2en(tp, true);
 	}
 }
@@ -5056,7 +5056,7 @@ static void rtl8153b_up(struct r8152 *tp)
 
 	r8153_aldps_en(tp, true);
 
-	if (tp->udev->speed != USB_SPEED_HIGH)
+	if (tp->udev->speed >= USB_SPEED_SUPER)
 		r8153b_u1u2en(tp, true);
 }
 
@@ -5572,8 +5572,9 @@ static void r8153b_init(struct r8152 *tp)
 	ocp_data |= POLL_LINK_CHG;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 
-	if (tp->udev->speed != USB_SPEED_HIGH)
+	if (tp->udev->speed >= USB_SPEED_SUPER)
 		r8153b_u1u2en(tp, true);
+
 	usb_enable_lpm(tp->udev);
 
 	/* MAC clock speed down */
-- 
2.26.2

