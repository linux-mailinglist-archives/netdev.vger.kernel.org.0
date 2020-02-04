Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBD151578
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 06:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgBDFda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 00:33:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41224 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgBDFda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 00:33:30 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iyqpu-0003v6-4X; Tue, 04 Feb 2020 05:33:22 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.net, hayeswang@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] r8152: Add MAC passthrough support to new device
Date:   Tue,  4 Feb 2020 13:33:13 +0800
Message-Id: <20200204053315.21866-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device 0xa387 also supports MAC passthrough, therefore add it to the
whitelst.

BugLink: https://bugs.launchpad.net/bugs/1827961/comments/30
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Use switch case to match device id.
 - Use macro instead of hex for device id.

 drivers/net/usb/r8152.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e8cd8c05b156..78ddbaf6401b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -698,6 +698,9 @@ enum rtl8152_flags {
 #define VENDOR_ID_NVIDIA		0x0955
 #define VENDOR_ID_TPLINK		0x2357
 
+#define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
+#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
+
 #define MCU_TYPE_PLA			0x0100
 #define MCU_TYPE_USB			0x0000
 
@@ -6759,9 +6762,13 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO &&
-	    le16_to_cpu(udev->descriptor.idProduct) == 0x3082)
-		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
+	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
+			set_bit(LENOVO_MACPASSTHRU, &tp->flags);
+		}
+	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
 	    (!strcmp(udev->serial, "000001000000") ||
-- 
2.17.1

