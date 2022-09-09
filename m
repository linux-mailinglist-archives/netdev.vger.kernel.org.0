Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CC5B3BD6
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiIIPZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiIIPZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:25:20 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188E2754B0;
        Fri,  9 Sep 2022 08:25:15 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4B686FF80D;
        Fri,  9 Sep 2022 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662737113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59+6ULtGFNywxRd7fqK+8cW0a5MhZ6Z4qdRlVJWr/+Q=;
        b=icbckqlVb77Vx5vubaXKqzdSEI9nGCBmHfqmGl+LEjIScMzJBb4H+SJ/0VHQHaDk/P+nyg
        uimydJrx2gdq8CuFU83rePUP3sS3zmHMaEKFA2jwJnJER9pysUcegLvE1tF0usHeaVTq0C
        9UfBYSNYcre78P7BLb67ukir/5+s4SWHMtv8f8gjLgeVu3bbDq/vY3+R9S/OH7IxFoVOnL
        ZUDgRe4FSI1o0UYXr7C0zW3FmnR4RXM0idZeQtKYKKnJ8tg3w5vv2PzaelmnLAiIHn0jrX
        hsucugBFTa/1Uu+jcotA/Na7/p+h+WIzDnvQjzA3Zpb2mEsSLVAKfKDkj/fd4Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v4 4/5] net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
Date:   Fri,  9 Sep 2022 17:24:53 +0200
Message-Id: <20220909152454.7462-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the DT binding for the IPQESS Ethernet Controller. This is a simple
controller, only requiring the phy-mode, interrupts, clocks, and
possibly a MAC address setting.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4:
 - Fix a binding typo in the compatible string
V2->V3:
 - Cleanup on reset and clock names
V1->V2:
 - Fixed the example
 - Added reset and clocks
 - Removed generic ethernet attributes

 .../devicetree/bindings/net/qcom,ipqess.yaml  | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipqess.yaml b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
new file mode 100644
index 000000000000..3d2f790647cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
@@ -0,0 +1,95 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipqess.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm IPQ ESS EDMA Ethernet Controller
+
+maintainers:
+  - Maxime Chevallier <maxime.chevallier@bootlin.com>
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+properties:
+  compatible:
+    const: qcom,ipq4019-ess-edma
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 2
+    maxItems: 32
+    description: One interrupt per tx and rx queue, with up to 16 queues.
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - resets
+  - phy-mode
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,gcc-ipq4019.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    gmac: ethernet@c080000 {
+        compatible = "qcom,ipq4019-ess-edma";
+        reg = <0xc080000 0x8000>;
+        resets = <&gcc ESS_RESET>;
+        clocks = <&gcc GCC_ESS_CLK>;
+        interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
+                     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
+
+        phy-mode = "internal";
+        fixed-link {
+            speed = <1000>;
+            full-duplex;
+            pause;
+            asym-pause;
+        };
+    };
+
+...
-- 
2.37.2

