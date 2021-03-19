Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE5342160
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhCSP5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCSP5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:57:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325DFC06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:57:13 -0700 (PDT)
Received: from [2a0a:edc0:0:c01:1d::a2] (helo=drehscheibe.grey.stw.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUt-0007z2-LG; Fri, 19 Mar 2021 16:57:11 +0100
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUs-00011E-DO; Fri, 19 Mar 2021 16:57:10 +0100
Received: from mtr by dude03.red.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUs-00BilS-CG; Fri, 19 Mar 2021 16:57:10 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc:     m.tretter@pengutronix.de, kernel@pengutronix.de,
        robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        dmurphy@ti.com
Subject: [PATCH 1/2] dt-bindings: dp83867: Add binding for LED mode configuration
Date:   Fri, 19 Mar 2021 16:57:09 +0100
Message-Id: <20210319155710.2793637-2-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210319155710.2793637-1-m.tretter@pengutronix.de>
References: <20210319155710.2793637-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83867 supports four configurable LED pins. Describe the
multiplexing of functions to the LEDs via device tree.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 .../devicetree/bindings/net/ti,dp83867.yaml   | 24 +++++++++++++++++++
 include/dt-bindings/net/ti-dp83867.h          | 16 +++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index 047d757e8d82..d09e1cf42462 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -106,6 +106,30 @@ properties:
       Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
       values.
 
+  ti,dp83867-led-mode-names:
+    $ref: /schemas/types.yaml#/definitions/string-array
+    description: |
+      A list of led name strings sorted in the same order as the
+      ti,dp83867-led-modes property.
+    items:
+      anyOf:
+        items:
+          - const: led-0
+          - const: led-1
+          - const: led-2
+          - const: led-gpio
+    maxItems: 4
+
+  ti,dp83867-led-modes:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    description: |
+      The DP83867 supports four configurable LED pins. Several functions can
+      be multiplexed onto the LEDs for different modes of operation.
+
+      Must contain an entry for each entry in ti,dp83867-led-mode-names.
+      See dt-bindings/net/ti-dp83867.h for applicable values.
+    maxItems: 4
+
 required:
   - reg
 
diff --git a/include/dt-bindings/net/ti-dp83867.h b/include/dt-bindings/net/ti-dp83867.h
index 6fc4b445d3a1..fc3891f37fd1 100644
--- a/include/dt-bindings/net/ti-dp83867.h
+++ b/include/dt-bindings/net/ti-dp83867.h
@@ -50,4 +50,20 @@
 #define DP83867_CLK_O_SEL_REF_CLK		0xC
 /* Special flag to indicate clock should be off */
 #define DP83867_CLK_O_SEL_OFF			0xFFFFFFFF
+
+/* LED configuration */
+#define DP83867_LED_LINK_EST			0x0
+#define DP83867_LED_RX_TX_ACT			0x1
+#define DP83867_LED_TX_ACT			0x2
+#define DP83867_LED_RX_ACT			0x3
+#define DP83867_LED_COLLISION_DET		0x4
+#define DP83867_LED_1000_BT_LINK		0x5
+#define DP83867_LED_100_BT_LINK			0x6
+#define DP83867_LED_10_BT_LINK			0x7
+#define DP83867_LED_10_100_BT_LINK		0x8
+#define DP83867_LED_100_1000_BT_LINK		0x9
+#define DP83867_LED_FULL_DUPLEX			0xa
+#define DP83867_LED_LINK_EST_RX_TX_ACT		0xb
+#define DP83867_LED_RX_TX_ERR			0xd
+#define DP83867_LED_RX_ERR			0xe
 #endif
-- 
2.29.2

