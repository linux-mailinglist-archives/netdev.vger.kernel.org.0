Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12E59AD35
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405144AbfHWKb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:31:57 -0400
Received: from vps.xff.cz ([195.181.215.36]:52706 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404951AbfHWKbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566556307; bh=Zdq7TsrioBhNJ4nRUcC5Dq41WDeZro1CErpIBoxFFlk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=DigB5/Gzg4cMrhlQlNhoXSWgNEMQ/gOr13IQAEJPfmCfyuvFKk5RkTyngZexthmXD
         cWRc7Bt8hLxmIZnn8syMNxhbnV5Dx6C6abzysI5JS2x2i7SQzf3pja8slt5n9qTegq
         XPMIUi+Zb8xRoPCqp0/U5RYZcWlYz7ESLPVo/bEU=
From:   megous@megous.com
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, Ondrej Jirman <megous@megous.com>
Subject: [RESEND PATCH 5/5] arm64: dts: allwinner: orange-pi-3: Enable UART1 / Bluetooth
Date:   Fri, 23 Aug 2019 12:31:39 +0200
Message-Id: <20190823103139.17687-6-megous@megous.com>
In-Reply-To: <20190823103139.17687-1-megous@megous.com>
References: <20190823103139.17687-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

The board contains AP6256 WiFi/BT module that has its bluetooth part
connected to SoC's UART1 port. Enable this port, and add node for the
bluetooth device.

Bluetooth part is named bcm4345c5.

You'll need a BCM4345C5.hcd firmware file that can be found in the
Xulongs's repository for H6:

https://github.com/orangepi-xunlong/OrangePiH6_external/tree/master/ap6256

The driver expects the firmware at the following path relative to the
firmware directory:

  brcm/BCM4345C5.hcd

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
index 49d954369087..a9e776446c35 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
@@ -15,6 +15,7 @@
 
 	aliases {
 		serial0 = &uart0;
+		serial1 = &uart1;
 	};
 
 	chosen {
@@ -271,6 +272,24 @@
 	status = "okay";
 };
 
+/* There's the BT part of the AP6256 connected to that UART */
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
+	uart-has-rtscts;
+	status = "okay";
+
+	bluetooth {
+		compatible = "brcm,bcm4345c5";
+		clocks = <&rtc 1>;
+		clock-names = "lpo";
+		device-wakeup-gpios = <&r_pio 1 2 GPIO_ACTIVE_HIGH>; /* PM2 */
+		host-wakeup-gpios = <&r_pio 1 1 GPIO_ACTIVE_HIGH>; /* PM1 */
+		shutdown-gpios = <&r_pio 1 4 GPIO_ACTIVE_HIGH>; /* PM4 */
+		max-speed = <1500000>;
+	};
+};
+
 &usb2otg {
 	/*
 	 * This board doesn't have a controllable VBUS even though it
-- 
2.23.0

