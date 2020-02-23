Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29625169462
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgBWCaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbgBWCXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5839B24653;
        Sun, 23 Feb 2020 02:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424631;
        bh=fJrLbaoVDfz1skjwKOOrwDeeTkKaxsNIPzDVJWuIYgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paQa6XlbRmMVPEU9CHfdxnrc4GzDeVYpr4A23A60chh4QSgvRqkqvlzeviAksVWfS
         AOv4ssvslEIQDtmOldkD0TQbV8+OIP0Er/DPplT2PpmpI3RftykvguDW0O8mg75JCJ
         OY+4LTDx4iLG5r0y6ymRcgVm9FTdIKummu+7wwTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/25] qmi_wwan: unconditionally reject 2 ep interfaces
Date:   Sat, 22 Feb 2020 21:23:23 -0500
Message-Id: <20200223022339.1885-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022339.1885-1-sashal@kernel.org>
References: <20200223022339.1885-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 00516d13d4cfa56ce39da144db2dbf08b09b9357 ]

We have been using the fact that the QMI and DIAG functions
usually are the only ones with class/subclass/protocol being
ff/ff/ff on Quectel modems. This has allowed us to match the
QMI function without knowing the exact interface number,
which can vary depending on firmware configuration.

The ability to silently reject the DIAG function, which is
usually handled by the option driver, is important for this
method to work.  This is done based on the knowledge that it
has exactly 2 bulk endpoints.  QMI function control interfaces
will have either 3 or 1 endpoint. This rule is universal so
the quirk condition can be removed.

The fixed layouts known from the Gobi1k and Gobi2k modems
have been gradually replaced by more dynamic layouts, and
many vendors now use configurable layouts without changing
device IDs.  Renaming the class/subclass/protocol matching
macro makes it more obvious that this is now not Quectel
specific anymore.

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 42 ++++++++++++++------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index f489df377f5d2..a04f8577d9f21 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -63,7 +63,6 @@ enum qmi_wwan_flags {
 
 enum qmi_wwan_quirks {
 	QMI_WWAN_QUIRK_DTR = 1 << 0,	/* needs "set DTR" request */
-	QMI_WWAN_QUIRK_QUECTEL_DYNCFG = 1 << 1,	/* check num. endpoints */
 };
 
 struct qmimux_hdr {
@@ -853,16 +852,6 @@ static const struct driver_info	qmi_wwan_info_quirk_dtr = {
 	.data           = QMI_WWAN_QUIRK_DTR,
 };
 
-static const struct driver_info	qmi_wwan_info_quirk_quectel_dyncfg = {
-	.description	= "WWAN/QMI device",
-	.flags		= FLAG_WWAN | FLAG_SEND_ZLP,
-	.bind		= qmi_wwan_bind,
-	.unbind		= qmi_wwan_unbind,
-	.manage_power	= qmi_wwan_manage_power,
-	.rx_fixup       = qmi_wwan_rx_fixup,
-	.data           = QMI_WWAN_QUIRK_DTR | QMI_WWAN_QUIRK_QUECTEL_DYNCFG,
-};
-
 #define HUAWEI_VENDOR_ID	0x12D1
 
 /* map QMI/wwan function by a fixed interface number */
@@ -883,14 +872,18 @@ static const struct driver_info	qmi_wwan_info_quirk_quectel_dyncfg = {
 #define QMI_GOBI_DEVICE(vend, prod) \
 	QMI_FIXED_INTF(vend, prod, 0)
 
-/* Quectel does not use fixed interface numbers on at least some of their
- * devices. We need to check the number of endpoints to ensure that we bind to
- * the correct interface.
+/* Many devices have QMI and DIAG functions which are distinguishable
+ * from other vendor specific functions by class, subclass and
+ * protocol all being 0xff. The DIAG function has exactly 2 endpoints
+ * and is silently rejected when probed.
+ *
+ * This makes it possible to match dynamically numbered QMI functions
+ * as seen on e.g. many Quectel modems.
  */
-#define QMI_QUIRK_QUECTEL_DYNCFG(vend, prod) \
+#define QMI_MATCH_FF_FF_FF(vend, prod) \
 	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_VENDOR_SPEC, \
 				      USB_SUBCLASS_VENDOR_SPEC, 0xff), \
-	.driver_info = (unsigned long)&qmi_wwan_info_quirk_quectel_dyncfg
+	.driver_info = (unsigned long)&qmi_wwan_info_quirk_dtr
 
 static const struct usb_device_id products[] = {
 	/* 1. CDC ECM like devices match on the control interface */
@@ -996,10 +989,10 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
@@ -1390,7 +1383,6 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 {
 	struct usb_device_id *id = (struct usb_device_id *)prod;
 	struct usb_interface_descriptor *desc = &intf->cur_altsetting->desc;
-	const struct driver_info *info;
 
 	/* Workaround to enable dynamic IDs.  This disables usbnet
 	 * blacklisting functionality.  Which, if required, can be
@@ -1426,12 +1418,8 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 	 * different. Ignore the current interface if the number of endpoints
 	 * equals the number for the diag interface (two).
 	 */
-	info = (void *)id->driver_info;
-
-	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
-		if (desc->bNumEndpoints == 2)
-			return -ENODEV;
-	}
+	if (desc->bNumEndpoints == 2)
+		return -ENODEV;
 
 	return usbnet_probe(intf, id);
 }
-- 
2.20.1

