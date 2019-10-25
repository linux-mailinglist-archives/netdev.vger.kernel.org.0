Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6FE49B4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440034AbfJYLSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:18:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42533 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439235AbfJYLSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:18:11 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iNxJV-0002cs-0I; Fri, 25 Oct 2019 10:59:25 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.net, oliver@neukum.org
Cc:     hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 1/2] r8152: Pass driver_info to REALTEK_USB_DEVICE() macro
Date:   Fri, 25 Oct 2019 18:59:18 +0800
Message-Id: <20191025105919.689-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

REALTEK_USB_DEVICE() in current form doesn't take driver_info as its
parameter.

However, driver_info can be useful to add device specific information so
let's adjust REALTEK_USB_DEVICE() macro to be able to do that.

It'll be used by later patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/usb/r8152.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d3c30ccc8577..1a987d4e45ab 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6725,12 +6725,13 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 	}
 }
 
-#define REALTEK_USB_DEVICE(vend, prod)	\
+#define REALTEK_USB_DEVICE(vend, prod, info)	\
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
 		       USB_DEVICE_ID_MATCH_INT_CLASS, \
 	.idVendor = (vend), \
 	.idProduct = (prod), \
-	.bInterfaceClass = USB_CLASS_VENDOR_SPEC \
+	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
+	.driver_info = (info) \
 }, \
 { \
 	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO | \
@@ -6739,25 +6740,26 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 	.idProduct = (prod), \
 	.bInterfaceClass = USB_CLASS_COMM, \
 	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET, \
-	.bInterfaceProtocol = USB_CDC_PROTO_NONE
+	.bInterfaceProtocol = USB_CDC_PROTO_NONE, \
+	.driver_info = (info) \
 
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff, 0)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601, 0)},
 	{}
 };
 
-- 
2.17.1

