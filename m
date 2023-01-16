Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508CB66B89B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjAPIBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjAPIBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:01:17 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB1651205D;
        Mon, 16 Jan 2023 00:00:52 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30G806AA0003786, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30G806AA0003786
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 16 Jan 2023 16:00:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 16 Jan 2023 16:00:06 +0800
Received: from fc34.localdomain (172.22.228.98) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Mon, 16 Jan
 2023 16:00:05 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <bjorn@mork.no>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: avoid to change cfg for all devices
Date:   Mon, 16 Jan 2023 15:59:51 +0800
Message-ID: <20230116075951.1988-1-hayeswang@realtek.com>
X-Mailer: git-send-email 2.38.1
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
X-KSE-Antiphishing-Bases: 01/16/2023 07:09:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMTYgpFekyCAwNjowMDowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtl8152_cfgselector_probe() should set the USB configuration to the
vendor mode only for the devices which the driver (r8152) supports.
Otherwise, no driver would be used for such devices.

Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 66e70b5f8417..24be9449e4fc 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9500,9 +9500,8 @@ static int rtl_fw_init(struct r8152 *tp)
 	return 0;
 }
 
-u8 rtl8152_get_version(struct usb_interface *intf)
+static u8 __rtl_get_hw_ver(struct usb_device *udev)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
 	u32 ocp_data = 0;
 	__le32 *tmp;
 	u8 version;
@@ -9571,10 +9570,19 @@ u8 rtl8152_get_version(struct usb_interface *intf)
 		break;
 	default:
 		version = RTL_VER_UNKNOWN;
-		dev_info(&intf->dev, "Unknown version 0x%04x\n", ocp_data);
+		dev_info(&udev->dev, "Unknown version 0x%04x\n", ocp_data);
 		break;
 	}
 
+	return version;
+}
+
+u8 rtl8152_get_version(struct usb_interface *intf)
+{
+	u8 version;
+
+	version = __rtl_get_hw_ver(interface_to_usbdev(intf));
+
 	dev_dbg(&intf->dev, "Detected version 0x%04x\n", version);
 
 	return version;
@@ -9869,6 +9877,12 @@ static int rtl8152_cfgselector_probe(struct usb_device *udev)
 	struct usb_host_config *c;
 	int i, num_configs;
 
+	/* Swtich the device to vendor mode, if and only if the vendor mode
+	 * driver supports it.
+	 */
+	if (__rtl_get_hw_ver(udev) == RTL_VER_UNKNOWN)
+		return 0;
+
 	/* The vendor mode is not always config #1, so to find it out. */
 	c = udev->config;
 	num_configs = udev->descriptor.bNumConfigurations;
-- 
2.38.1

