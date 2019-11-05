Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467E1EF70D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbfKEIPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:15:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40454 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387686AbfKEIPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:15:38 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iRtzw-0006Uu-Cv; Tue, 05 Nov 2019 08:15:33 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.net, oliver@neukum.org
Cc:     hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v2] r8152: Add macpassthru support for ThinkPad Thunderbolt 3 Dock Gen 2
Date:   Tue,  5 Nov 2019 16:15:26 +0800
Message-Id: <20191105081526.4206-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ThinkPad Thunderbolt 3 Dock Gen 2 is another docking station that uses
RTL8153 based USB ethernet.

The device supports macpassthru, but it failed to pass the test of -AD,
-BND and -BD. Simply bypass these tests since the device supports this
feature just fine.

Also the ACPI objects have some differences between Dell's and Lenovo's,
so make those ACPI infos no longer hardcoded.

BugLink: https://bugs.launchpad.net/bugs/1827961

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
- Use idVendor and idProduct directly.

 drivers/net/usb/cdc_ether.c |  7 +++++
 drivers/net/usb/r8152.c     | 63 ++++++++++++++++++++++++++-----------
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index fe630438f67b..0cdb2ce47645 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -766,6 +766,13 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
+/* ThinkPad Thunderbolt 3 Dock Gen 2 (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3082, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* Lenovo Thinkpad USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x7205, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b9f526ed0d30..ff9fe45901e4 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -670,6 +670,7 @@ enum rtl8152_flags {
 	SCHEDULE_TASKLET,
 	GREEN_ETHERNET,
 	DELL_TB_RX_AGG_BUG,
+	LENOVO_MACPASSTHRU,
 };
 
 /* Define these values to match your device */
@@ -1408,38 +1409,57 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	int ret = -EINVAL;
 	u32 ocp_data;
 	unsigned char buf[6];
-
-	/* test for -AD variant of RTL8153 */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
-	if ((ocp_data & AD_MASK) == 0x1000) {
-		/* test for MAC address pass-through bit */
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
-		if ((ocp_data & PASS_THRU_MASK) != 1) {
-			netif_dbg(tp, probe, tp->netdev,
-				  "No efuse for RTL8153-AD MAC pass through\n");
-			return -ENODEV;
-		}
+	bool bypass_test;
+	char *mac_obj_name;
+	acpi_object_type mac_obj_type;
+	int mac_strlen;
+
+	if (test_bit(LENOVO_MACPASSTHRU, &tp->flags)) {
+		bypass_test = true;
+		mac_obj_name = "\\MACA";
+		mac_obj_type = ACPI_TYPE_STRING;
+		mac_strlen = 0x16;
 	} else {
-		/* test for RTL8153-BND and RTL8153-BD */
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
-		if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
-			netif_dbg(tp, probe, tp->netdev,
-				  "Invalid variant for MAC pass through\n");
-			return -ENODEV;
+		bypass_test = false;
+		mac_obj_name = "\\_SB.AMAC";
+		mac_obj_type = ACPI_TYPE_BUFFER;
+		mac_strlen = 0x17;
+	}
+
+	if (!bypass_test) {
+		/* test for -AD variant of RTL8153 */
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+		if ((ocp_data & AD_MASK) == 0x1000) {
+			/* test for MAC address pass-through bit */
+			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
+			if ((ocp_data & PASS_THRU_MASK) != 1) {
+				netif_dbg(tp, probe, tp->netdev,
+						"No efuse for RTL8153-AD MAC pass through\n");
+				return -ENODEV;
+			}
+		} else {
+			/* test for RTL8153-BND and RTL8153-BD */
+			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
+			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
+				netif_dbg(tp, probe, tp->netdev,
+						"Invalid variant for MAC pass through\n");
+				return -ENODEV;
+			}
 		}
 	}
 
 	/* returns _AUXMAC_#AABBCCDDEEFF# */
-	status = acpi_evaluate_object(NULL, "\\_SB.AMAC", NULL, &buffer);
+	status = acpi_evaluate_object(NULL, mac_obj_name, NULL, &buffer);
 	obj = (union acpi_object *)buffer.pointer;
 	if (!ACPI_SUCCESS(status))
 		return -ENODEV;
-	if (obj->type != ACPI_TYPE_BUFFER || obj->string.length != 0x17) {
+	if (obj->type != mac_obj_type || obj->string.length != mac_strlen) {
 		netif_warn(tp, probe, tp->netdev,
 			   "Invalid buffer for pass-thru MAC addr: (%d, %d)\n",
 			   obj->type, obj->string.length);
 		goto amacout;
 	}
+
 	if (strncmp(obj->string.pointer, "_AUXMAC_#", 9) != 0 ||
 	    strncmp(obj->string.pointer + 0x15, "#", 1) != 0) {
 		netif_warn(tp, probe, tp->netdev,
@@ -6629,6 +6649,10 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
+	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO &&
+	    le16_to_cpu(udev->descriptor.idProduct) == 0x3082)
+		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
+
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
 	    (!strcmp(udev->serial, "000001000000") ||
 	     !strcmp(udev->serial, "000002000000"))) {
@@ -6755,6 +6779,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
-- 
2.17.1

