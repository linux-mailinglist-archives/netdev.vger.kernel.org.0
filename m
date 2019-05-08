Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7E18189
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfEHVOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:14:20 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55733 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbfEHVOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:14:19 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hOTtH-0005Zw-R2; Wed, 08 May 2019 23:14:15 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92-RC6)
        (envelope-from <mgr@pengutronix.de>)
        id 1hOTtH-00063J-Jf; Wed, 08 May 2019 23:14:15 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     Tristram.Ha@microchip.com
Cc:     kernel@pengutronix.de, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [RFC 3/3] dt-bindings: net: dsa: document additional Microchip KSZ8863 family switches
Date:   Wed,  8 May 2019 23:13:30 +0200
Message-Id: <20190508211330.19328-4-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document additional Microchip KSZ8863 family switches.

Show how KSZ8863 switch should be configured as the host port is port 3.

Cc: devicetree@vger.kernel.org
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 .../devicetree/bindings/net/dsa/ksz.txt       | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
index e7db7268fd0fd..4ac576e1cc34e 100644
--- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
@@ -5,6 +5,8 @@ Required properties:
 
 - compatible: For external switch chips, compatible string must be exactly one
   of the following:
+  - "microchip,ksz8863"
+  - "microchip,ksz8873"
   - "microchip,ksz9477"
   - "microchip,ksz9897"
   - "microchip,ksz9896"
@@ -31,6 +33,48 @@ Ethernet switch connected via SPI to the host, CPU port wired to eth0:
 		};
 	};
 
+	mdio0: mdio-gpio {
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_mdio_1>;
+		compatible = "virtual,mdio-gpio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		gpios = <&gpio1 31 0 &gpio1 22 0>;
+
+		ksz8863@3 {
+			compatible = "microchip,ksz8863";
+			interrupt-parrent = <&gpio3>;
+			interrupt = <30 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0>;
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				ports@0 {
+					reg = <0>;
+					label = "lan1";
+				};
+
+				ports@1 {
+					reg = <1>;
+					label = "lan2";
+				};
+
+				ports@2 {
+					reg = <2>;
+					label = "cpu";
+					ethernet = <&eth0>;
+
+					fixed-link {
+						speed = <100>;
+						full-duplex;
+					};
+				};
+			};
+		};
+	};
+
 	spi1: spi@f8008000 {
 		pinctrl-0 = <&pinctrl_spi_ksz>;
 		cs-gpios = <&pioC 25 0>;
-- 
2.20.1

