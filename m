Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF7585DEB
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 09:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiGaHWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 03:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiGaHWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 03:22:22 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9294112D23;
        Sun, 31 Jul 2022 00:22:21 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 40647425AB;
        Sun, 31 Jul 2022 07:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1659252137; bh=+03uZQ7uzhbq0R4Yb43G4uX1y6g8wuj6rIgz/M6Bstc=;
        h=From:To:Cc:Subject:Date;
        b=txgEk3u9hmfDoCoqGbfOjrXORWysKtgF0zVxygqq26lGWXIeD8cFw/CLJ3T0eG63r
         xNIq1ULd9weZJQY+vxvg+nQbPEDLfWxE3qfOzUeFUl9UobAUpYSHRytZeR8xe/Idik
         db5tMVzcCdNzuoGHP52z18f0FZrrQKj/vSi6R18guBMR0uHzNMgHzUpAZQyrlZiy2h
         RCW/CgzUF6P3gvsMe8bgPsuFv4UPVZ4WDe1W15I5EAEQE8g8Bk1o6G7r+7CgQgcjLa
         hdiYC1JMzZP6JqwqXocxey50svOrkthrW9iV4Hs3WejoVW/gvBYrJJLXq9aKkjxYpD
         l3drvgEuBEXbg==
From:   Hector Martin <marcan@marcan.st>
To:     Jacky Chou <jackychou@asix.com.tw>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH v4] net: usb: ax88179_178a: Bind only to vendor-specific interface
Date:   Sun, 31 Jul 2022 16:22:09 +0900
Message-Id: <20220731072209.45504-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
chipset, but exposes CDC Ethernet configurations as well as the
vendor specific one. This driver tries to bind by PID:VID
unconditionally and ends up picking up the CDC configuration, which
is supposed to be handled by the class driver. To make things even
more confusing, it sees both of the CDC class interfaces and tries
to bind twice, resulting in two broken Ethernet devices.

Change all the ID matches to specifically match the vendor-specific
interface. By default the device comes up in CDC mode and is bound by
that driver (which works fine); users may switch it to the vendor
interface using sysfs to set bConfigurationValue, at which point the
device actually goes through a reconnect cycle and comes back as a
vendor specific only device, and then this driver binds and works too.

The affected device uses VID/PID 0b95:1790, but we might as well change
all of them for good measure, since there is no good reason for this
driver to bind to standard CDC Ethernet interfaces.

v3: Added VID/PID info to commit message

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/usb/ax88179_178a.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index e2fa56b92685..7c7c2f31d9f1 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1914,55 +1914,55 @@ static const struct driver_info at_umc2000sp_info = {
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
-	USB_DEVICE(0x0b95, 0x1790),
+	USB_DEVICE_AND_INTERFACE_INFO(0x0b95, 0x1790, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&ax88179_info,
 }, {
 	/* ASIX AX88178A 10/100/1000 */
-	USB_DEVICE(0x0b95, 0x178a),
+	USB_DEVICE_AND_INTERFACE_INFO(0x0b95, 0x178a, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&ax88178a_info,
 }, {
 	/* Cypress GX3 SuperSpeed to Gigabit Ethernet Bridge Controller */
-	USB_DEVICE(0x04b4, 0x3610),
+	USB_DEVICE_AND_INTERFACE_INFO(0x04b4, 0x3610, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&cypress_GX3_info,
 }, {
 	/* D-Link DUB-1312 USB 3.0 to Gigabit Ethernet Adapter */
-	USB_DEVICE(0x2001, 0x4a00),
+	USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x4a00, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&dlink_dub1312_info,
 }, {
 	/* Sitecom USB 3.0 to Gigabit Adapter */
-	USB_DEVICE(0x0df6, 0x0072),
+	USB_DEVICE_AND_INTERFACE_INFO(0x0df6, 0x0072, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&sitecom_info,
 }, {
 	/* Samsung USB Ethernet Adapter */
-	USB_DEVICE(0x04e8, 0xa100),
+	USB_DEVICE_AND_INTERFACE_INFO(0x04e8, 0xa100, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&samsung_info,
 }, {
 	/* Lenovo OneLinkDock Gigabit LAN */
-	USB_DEVICE(0x17ef, 0x304b),
+	USB_DEVICE_AND_INTERFACE_INFO(0x17ef, 0x304b, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&lenovo_info,
 }, {
 	/* Belkin B2B128 USB 3.0 Hub + Gigabit Ethernet Adapter */
-	USB_DEVICE(0x050d, 0x0128),
+	USB_DEVICE_AND_INTERFACE_INFO(0x050d, 0x0128, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&belkin_info,
 }, {
 	/* Toshiba USB 3.0 GBit Ethernet Adapter */
-	USB_DEVICE(0x0930, 0x0a13),
+	USB_DEVICE_AND_INTERFACE_INFO(0x0930, 0x0a13, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&toshiba_info,
 }, {
 	/* Magic Control Technology U3-A9003 USB 3.0 Gigabit Ethernet Adapter */
-	USB_DEVICE(0x0711, 0x0179),
+	USB_DEVICE_AND_INTERFACE_INFO(0x0711, 0x0179, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&mct_info,
 }, {
 	/* Allied Telesis AT-UMC2000 USB 3.0/USB 3.1 Gen 1 to Gigabit Ethernet Adapter */
-	USB_DEVICE(0x07c9, 0x000e),
+	USB_DEVICE_AND_INTERFACE_INFO(0x07c9, 0x000e, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&at_umc2000_info,
 }, {
 	/* Allied Telesis AT-UMC200 USB 3.0/USB 3.1 Gen 1 to Fast Ethernet Adapter */
-	USB_DEVICE(0x07c9, 0x000f),
+	USB_DEVICE_AND_INTERFACE_INFO(0x07c9, 0x000f, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&at_umc200_info,
 }, {
 	/* Allied Telesis AT-UMC2000/SP USB 3.0/USB 3.1 Gen 1 to Gigabit Ethernet Adapter */
-	USB_DEVICE(0x07c9, 0x0010),
+	USB_DEVICE_AND_INTERFACE_INFO(0x07c9, 0x0010, 0xff, 0xff, 0),
 	.driver_info = (unsigned long)&at_umc2000sp_info,
 },
 	{ },
-- 
2.35.1

