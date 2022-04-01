Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495B84EFC7A
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 00:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353177AbiDAWBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 18:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352882AbiDAWAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 18:00:51 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71961C1EF9;
        Fri,  1 Apr 2022 14:59:00 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9438922246;
        Fri,  1 Apr 2022 23:58:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648850337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtYXoB9k65DDzh/3GNKkILqrWJ73ElQye4xmaYveacg=;
        b=AOttoDHVGKNrIW9SkuZqEPzuVRaCEQqLdMmGpytqH+LYUJhScJXTebbcswvDHJKIVy3gKs
        f/U5EmJQdAHPyjUDSI2x1edDHRAiF3mw/LQ/3YPwK4Hy0A67KMtr4DC0uSGDy0L+y7VtpV
        1YK++om7YQ60ZZP5BpW/kNVetXqS7C0=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 1/3] dt-bindings: net: convert mscc-miim to YAML format
Date:   Fri,  1 Apr 2022 23:58:32 +0200
Message-Id: <20220401215834.3757692-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220401215834.3757692-1-michael@walle.cc>
References: <20220401215834.3757692-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the mscc-miim device tree binding to the new YAML format.

The original binding don't mention if the interrupt property is optional
or not. But on the SparX-5 SoC, for example, the interrupt property isn't
used, thus in the new binding that property is optional. FWIW the driver
doesn't use interrupts at all.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../devicetree/bindings/net/mscc,miim.yaml    | 56 +++++++++++++++++++
 .../devicetree/bindings/net/mscc-miim.txt     | 26 ---------
 2 files changed, 56 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mscc,miim.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-miim.txt

diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
new file mode 100644
index 000000000000..cdc39aa20683
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mscc,miim.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microsemi MII Management Controller (MIIM)
+
+maintainers:
+  - Alexandre Belloni <alexandre.belloni@bootlin.com>
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    enum:
+      - mscc,ocelot-miim
+      - microchip,lan966x-miim
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  reg:
+    items:
+      - description: base address
+      - description: associated reset register for internal PHYs
+    minItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio@107009c {
+      compatible = "mscc,ocelot-miim";
+      reg = <0x107009c 0x36>, <0x10700f0 0x8>;
+      interrupts = <14>;
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      phy0: ethernet-phy@0 {
+        reg = <0>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt b/Documentation/devicetree/bindings/net/mscc-miim.txt
deleted file mode 100644
index 70e0cb1ee485..000000000000
--- a/Documentation/devicetree/bindings/net/mscc-miim.txt
+++ /dev/null
@@ -1,26 +0,0 @@
-Microsemi MII Management Controller (MIIM) / MDIO
-=================================================
-
-Properties:
-- compatible: must be "mscc,ocelot-miim" or "microchip,lan966x-miim"
-- reg: The base address of the MDIO bus controller register bank. Optionally, a
-  second register bank can be defined if there is an associated reset register
-  for internal PHYs
-- #address-cells: Must be <1>.
-- #size-cells: Must be <0>.  MDIO addresses have no size component.
-- interrupts: interrupt specifier (refer to the interrupt binding)
-
-Typically an MDIO bus might have several children.
-
-Example:
-	mdio@107009c {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "mscc,ocelot-miim";
-		reg = <0x107009c 0x36>, <0x10700f0 0x8>;
-		interrupts = <14>;
-
-		phy0: ethernet-phy@0 {
-			reg = <0>;
-		};
-	};
-- 
2.30.2

