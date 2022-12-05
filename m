Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC53B642935
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiLENVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiLENVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:21:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037361C128
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 05:21:15 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p2BP7-0002oO-Nc; Mon, 05 Dec 2022 14:21:05 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p2BP4-002U1D-UU; Mon, 05 Dec 2022 14:21:03 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p2BP5-00CLIZ-00; Mon, 05 Dec 2022 14:21:03 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 1/1] net: asix: add support for the Linux Automation GmbH USB 10Base-T1L
Date:   Mon,  5 Dec 2022 14:21:02 +0100
Message-Id: <20221205132102.2941732-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ASIX based USB 10Base-T1L adapter support:
https://linux-automation.com/en/products/usb-t1l.html

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_devices.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 0fe3773c5bca..1a2302dd5ff8 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -1350,6 +1350,20 @@ static const struct driver_info ax88772b_info = {
 	.data = FLAG_EEPROM_MAC,
 };
 
+static const struct driver_info lxausb_t1l_info = {
+	.description = "Linux Automation GmbH USB 10Base-T1L",
+	.bind = ax88772_bind,
+	.unbind = ax88772_unbind,
+	.status = asix_status,
+	.reset = ax88772_reset,
+	.stop = ax88772_stop,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+	         FLAG_MULTI_PACKET,
+	.rx_fixup = asix_rx_fixup_common,
+	.tx_fixup = asix_tx_fixup,
+	.data = FLAG_EEPROM_MAC,
+};
+
 static const struct driver_info ax88178_info = {
 	.description = "ASIX AX88178 USB 2.0 Ethernet",
 	.bind = ax88178_bind,
@@ -1538,6 +1552,10 @@ static const struct usb_device_id	products [] = {
 	 */
 	USB_DEVICE(0x066b, 0x20f9),
 	.driver_info = (unsigned long) &hg20f9_info,
+}, {
+	// Linux Automation GmbH USB 10Base-T1L
+	USB_DEVICE(0x33f7, 0x0004),
+	.driver_info = (unsigned long) &lxausb_t1l_info,
 },
 	{ },		// END
 };
-- 
2.30.2

