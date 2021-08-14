Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E221D3EC46C
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhHNSSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:18:33 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:59256 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhHNSSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:18:32 -0400
Received: (qmail 6045 invoked from network); 14 Aug 2021 18:11:21 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 14 Aug 2021 18:11:21 -0000
From:   David Bauer <mail@david-bauer.net>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 2/2] r8152: add LED configuration from OF
Date:   Sat, 14 Aug 2021 20:11:07 +0200
Message-Id: <20210814181107.138992-2-mail@david-bauer.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210814181107.138992-1-mail@david-bauer.net>
References: <20210814181107.138992-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the ability to configure the LED configuration register using
OF. This way, the correct value for board specific LED configuration can
be determined.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/usb/r8152.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e09b107b5c99..6f92e8bb2f1a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -11,6 +11,7 @@
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/usb.h>
+#include <linux/of.h>
 #include <linux/crc32.h>
 #include <linux/if_vlan.h>
 #include <linux/uaccess.h>
@@ -6791,6 +6792,22 @@ static void rtl_tally_reset(struct r8152 *tp)
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY, ocp_data);
 }
 
+static int r8152_led_configuration(struct r8152 *tp)
+{
+	u32 led_data;
+	int ret;
+
+	ret = of_property_read_u32(tp->udev->dev.of_node, "realtek,led-data",
+				   &led_data);
+
+	if (ret)
+		return ret;
+
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_LEDSEL, led_data);
+
+	return 0;
+}
+
 static void r8152b_init(struct r8152 *tp)
 {
 	u32 ocp_data;
@@ -6832,6 +6849,8 @@ static void r8152b_init(struct r8152 *tp)
 	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
+
+	r8152_led_configuration(tp);
 }
 
 static void r8153_init(struct r8152 *tp)
@@ -7988,6 +8007,8 @@ static void r8156_init(struct r8152 *tp)
 	rtl_tally_reset(tp);
 
 	tp->coalesce = 15000;	/* 15 us */
+
+	r8152_led_configuration(tp);
 }
 
 static void r8156b_init(struct r8152 *tp)
@@ -8117,6 +8138,8 @@ static void r8156b_init(struct r8152 *tp)
 	rtl_tally_reset(tp);
 
 	tp->coalesce = 15000;	/* 15 us */
+
+	r8152_led_configuration(tp);
 }
 
 static bool rtl_check_vendor_ok(struct usb_interface *intf)
-- 
2.32.0

