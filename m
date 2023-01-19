Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FCA6732B5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 08:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjASHmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 02:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjASHmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 02:42:20 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A26CB676C6;
        Wed, 18 Jan 2023 23:42:18 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30J7fviA7008106, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30J7fviA7008106
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 19 Jan 2023 15:41:57 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 19 Jan 2023 15:41:58 +0800
Received: from fc34.localdomain (172.22.228.98) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Thu, 19 Jan
 2023 15:41:57 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/2] r8152: remove rtl_vendor_mode function
Date:   Thu, 19 Jan 2023 15:40:42 +0800
Message-ID: <20230119074043.10021-398-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119074043.10021-397-nic_swsd@realtek.com>
References: <20230119074043.10021-397-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.22.228.98]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/19/2023 07:27:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMTkgpFekyCAwNjowMDowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit ec51fbd1b8a2 ("r8152: add USB device driver for
config selection"), the code about changing USB configuration
in rtl_vendor_mode() wouldn't be run anymore. Therefore, the
function could be removed.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4c5c1df5d7a4..6e5e12d90d47 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8232,43 +8232,6 @@ static bool rtl_check_vendor_ok(struct usb_interface *intf)
 	return true;
 }
 
-static bool rtl_vendor_mode(struct usb_interface *intf)
-{
-	struct usb_host_interface *alt = intf->cur_altsetting;
-	struct usb_device *udev;
-	struct usb_host_config *c;
-	int i, num_configs;
-
-	if (alt->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC)
-		return rtl_check_vendor_ok(intf);
-
-	/* The vendor mode is not always config #1, so to find it out. */
-	udev = interface_to_usbdev(intf);
-	c = udev->config;
-	num_configs = udev->descriptor.bNumConfigurations;
-	if (num_configs < 2)
-		return false;
-
-	for (i = 0; i < num_configs; (i++, c++)) {
-		struct usb_interface_descriptor	*desc = NULL;
-
-		if (c->desc.bNumInterfaces > 0)
-			desc = &c->intf_cache[0]->altsetting->desc;
-		else
-			continue;
-
-		if (desc->bInterfaceClass == USB_CLASS_VENDOR_SPEC) {
-			usb_driver_set_configuration(udev, c->desc.bConfigurationValue);
-			break;
-		}
-	}
-
-	if (i == num_configs)
-		dev_err(&intf->dev, "Unexpected Device\n");
-
-	return false;
-}
-
 static int rtl8152_pre_reset(struct usb_interface *intf)
 {
 	struct r8152 *tp = usb_get_intfdata(intf);
@@ -9629,7 +9592,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	if (intf->cur_altsetting->desc.bInterfaceClass != USB_CLASS_VENDOR_SPEC)
 		return -ENODEV;
 
-	if (!rtl_vendor_mode(intf))
+	if (!rtl_check_vendor_ok(intf))
 		return -ENODEV;
 
 	usb_reset_device(udev);
-- 
2.38.1

