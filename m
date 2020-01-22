Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE26C14496F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 02:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVBnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 20:43:43 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56870 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAVBnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 20:43:43 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00M1ftA4019847, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00M1ftA4019847
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 22 Jan 2020 09:41:59 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV02.realtek.com.tw
 (172.21.6.19) with Microsoft SMTP Server id 14.3.468.0; Wed, 22 Jan 2020
 09:41:54 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v2 3/9] r8152: get default setting of WOL before initializing
Date:   Wed, 22 Jan 2020 09:41:15 +0800
Message-ID: <1394712342-15778-351-Taiwan-albertk@realtek.com>
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

Initailization would reset runtime suspend by tp->saved_wolopts, so
the tp->saved_wolopts should be set before initializing.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 504db2348a3e..c3217a5c2fe1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6739,6 +6739,11 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	intf->needs_remote_wakeup = 1;
 
+	if (!rtl_can_wakeup(tp))
+		__rtl_set_wol(tp, 0);
+	else
+		tp->saved_wolopts = __rtl_get_wol(tp);
+
 	tp->rtl_ops.init(tp);
 #if IS_BUILTIN(CONFIG_USB_RTL8152)
 	/* Retry in case request_firmware() is not ready yet. */
@@ -6756,10 +6761,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 		goto out1;
 	}
 
-	if (!rtl_can_wakeup(tp))
-		__rtl_set_wol(tp, 0);
-
-	tp->saved_wolopts = __rtl_get_wol(tp);
 	if (tp->saved_wolopts)
 		device_set_wakeup_enable(&udev->dev, true);
 	else
-- 
2.21.0

