Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0068B3AE08C
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 23:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhFTVKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 17:10:00 -0400
Received: from phobos.denx.de ([85.214.62.61]:39232 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhFTVKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 17:10:00 -0400
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 246A7800B2;
        Sun, 20 Jun 2021 23:07:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624223265;
        bh=ZNUN7SzjM1tvOh5JWGNk0MaBKe/RjNUyY/rlFYKjXXM=;
        h=From:To:Cc:Subject:Date:From;
        b=j5GpeAQSeWOEVms/tw39mULNYThSWsAqU3qm9RYCbZ7iZBfkSCTS+8Qp7pVXZk8oh
         7RhEImPBexw3iOXGFC2J/M+qheKiuWEUWS2UffqNtlQFJCzxpuugAaSIVgsaKBjczF
         MsqcD9ZQmcGMB0ATcdCYlFI7NnOW7lZ4gvbce3NzIGy4s0B6YhvzYvpxa1f2LTwhyG
         cCj698pk4P2Ie2FtkceZsD6edfXQ7fMd9qOjiDt7qURw6LhyJxCgPvdyXSBHc+xGyb
         uEEo3w+FyINpY3WhBVjQ7SZePK9mDhl4Pqzt/tG0e3bRqnngH0nkC7jmqLKFqWd+E/
         P8jC48XhMuuXg==
From:   Marek Vasut <marex@denx.de>
To:     devicetree@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        Rob Herring <robh+dt@kernel.org>, linux@dh-electronics.com,
        netdev@vger.kernel.org
Subject: [PATCH v3] dt-bindings: net: ks8851: Convert to YAML schema
Date:   Sun, 20 Jun 2021 23:07:41 +0200
Message-Id: <20210620210741.100206-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Micrel KSZ8851 DT bindings to YAML schema.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux@dh-electronics.com
Cc: netdev@vger.kernel.org
To: devicetree@vger.kernel.org
---
V2: - Explicitly state the bindings are for both SPI and parallel bus options
    - Switch the license to (GPL-2.0-only OR BSD-2-Clause)
V3: - Drop quotes, use enum: instead of oneOf+const
    - Add reg: items list describing what each reg entry is
    - Drop regulator.yaml reference
---
 .../bindings/net/micrel,ks8851.yaml           | 97 +++++++++++++++++++
 .../devicetree/bindings/net/micrel-ks8851.txt | 18 ----
 2 files changed, 97 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/micrel,ks8851.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/micrel-ks8851.txt

diff --git a/Documentation/devicetree/bindings/net/micrel,ks8851.yaml b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
new file mode 100644
index 000000000000..98f022cdd44d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
@@ -0,0 +1,97 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/micrel,ks8851.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Micrel KS8851 Ethernet MAC (SPI and Parallel bus options)
+
+maintainers:
+  - Marek Vasut <marex@denx.de>
+
+properties:
+  compatible:
+    enum:
+      - micrel,ks8851      # SPI bus option
+      - micrel,ks8851-mll  # Parallel bus option
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: SPI or Parallel bus hardware address
+      - description: Parallel bus command mode address
+
+  reset-gpios:
+    maxItems: 1
+    description:
+      The reset_n input pin
+
+  vdd-supply:
+    description: |
+      Analog 3.3V supply for Ethernet MAC
+
+  vdd-io-supply:
+    description: |
+      Digital 1.8V IO supply for Ethernet MAC
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: micrel,ks8851
+    then:
+      properties:
+        reg:
+          maxItems: 1
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: micrel,ks8851-mll
+    then:
+      properties:
+        reg:
+          minItems: 2
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    /* SPI bus option */
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        ethernet@0 {
+            compatible = "micrel,ks8851";
+            reg = <0>;
+            interrupt-parent = <&msmgpio>;
+            interrupts = <90 8>;
+            vdd-supply = <&ext_l2>;
+            vdd-io-supply = <&pm8921_lvs6>;
+            reset-gpios = <&msmgpio 89 0>;
+        };
+    };
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    /* Parallel bus option */
+    memory-controller {
+        #address-cells = <2>;
+        #size-cells = <1>;
+        ethernet@1,0 {
+            compatible = "micrel,ks8851-mll";
+            reg = <1 0x0 0x2>, <1 0x2 0x20000>;
+            interrupt-parent = <&gpioc>;
+            interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/micrel-ks8851.txt b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
deleted file mode 100644
index bbdf9a7359a2..000000000000
--- a/Documentation/devicetree/bindings/net/micrel-ks8851.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-Micrel KS8851 Ethernet mac (MLL)
-
-Required properties:
-- compatible = "micrel,ks8851-mll" of parallel interface
-- reg : 2 physical address and size of registers for data and command
-- interrupts : interrupt connection
-
-Micrel KS8851 Ethernet mac (SPI)
-
-Required properties:
-- compatible = "micrel,ks8851" or the deprecated "ks8851"
-- reg : chip select number
-- interrupts : interrupt connection
-
-Optional properties:
-- vdd-supply: analog 3.3V supply for Ethernet mac
-- vdd-io-supply: digital 1.8V IO supply for Ethernet mac
-- reset-gpios: reset_n input pin
-- 
2.30.2

