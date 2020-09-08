Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5326202D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgIHUK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730269AbgIHPQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:16:19 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5ED822C9C;
        Tue,  8 Sep 2020 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599577202;
        bh=5e2FeFGeBsQ08Xbq+c6ro2JvZjXm8XuuPBlwX6Hax+g=;
        h=From:To:Subject:Date:From;
        b=qgJeyzEPOC/OZb4p2XNSaZQ1LKhhDQM0wSLJswkbINraU//gjo2q3iNVapN3KlpoX
         LD+GSH763ArX4beMKDc/0Nj2S3pV0mCEZWbQmWOXULN3x+JV5TJFK99hlwhsNBhvOo
         gvUcAsfw4BUb54G+Juq4Zw3m4IWCuT7C6nZvAl08=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: Correct interrupt flags in examples
Date:   Tue,  8 Sep 2020 16:59:39 +0200
Message-Id: <20200908145939.4569-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning:
1. GPIO_ACTIVE_HIGH = 0 = IRQ_TYPE_NONE
2. GPIO_ACTIVE_LOW  = 1 = IRQ_TYPE_EDGE_RISING

Correct the interrupt flags, assuming the author of the code wanted some
logical behavior behind the name "ACTIVE_xxx", this is:
  ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW
  ACTIVE_HIGH => IRQ_TYPE_LEVEL_HIGH

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt  | 2 +-
 Documentation/devicetree/bindings/net/nfc/pn544.txt    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index 3613c2c8f75d..0968b40aef1e 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -33,7 +33,7 @@ tcan4x5x: tcan4x5x@0 {
 		spi-max-frequency = <10000000>;
 		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <14 GPIO_ACTIVE_LOW>;
+		interrupts = <14 IRQ_TYPE_LEVEL_LOW>;
 		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 		device-wake-gpios = <&gpio1 15 GPIO_ACTIVE_HIGH>;
 		reset-gpios = <&gpio1 27 GPIO_ACTIVE_HIGH>;
diff --git a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
index cfaf88998918..9e4dc510a40a 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
+++ b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
@@ -25,7 +25,7 @@ Example (for ARM-based BeagleBone with NPC100 NFC controller on I2C2):
 		clock-frequency = <100000>;
 
 		interrupt-parent = <&gpio1>;
-		interrupts = <29 GPIO_ACTIVE_HIGH>;
+		interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
 
 		enable-gpios = <&gpio0 30 GPIO_ACTIVE_HIGH>;
 		firmware-gpios = <&gpio0 31 GPIO_ACTIVE_HIGH>;
diff --git a/Documentation/devicetree/bindings/net/nfc/pn544.txt b/Documentation/devicetree/bindings/net/nfc/pn544.txt
index 92f399ec22b8..2bd82562ce8e 100644
--- a/Documentation/devicetree/bindings/net/nfc/pn544.txt
+++ b/Documentation/devicetree/bindings/net/nfc/pn544.txt
@@ -25,7 +25,7 @@ Example (for ARM-based BeagleBone with PN544 on I2C2):
 		clock-frequency = <400000>;
 
 		interrupt-parent = <&gpio1>;
-		interrupts = <17 GPIO_ACTIVE_HIGH>;
+		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
 
 		enable-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 		firmware-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
-- 
2.17.1

