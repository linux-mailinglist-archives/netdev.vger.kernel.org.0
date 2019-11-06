Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A958BF21E0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbfKFWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:37:26 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:59255 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfKFWg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:36:59 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6151623E47;
        Wed,  6 Nov 2019 23:36:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573079816;
        bh=EdbvQGdM0p5oOTJsa+Q5b8Lc8rQ+qghjkZlNz+Jx/ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ot0OwKLcpsF88oY6XVAJ3BziU7VSVA6lj7P7NnlbJwbxjT4dk1V+/SY5Ld80Gh1De
         iUDt5YwJDE5mMFj3RJe+o/tcqbNUMlsLpNCtS9/dGE1Q54o7wiRNeVVbUqC98oRXXN
         oH9Lz/6JHosNlq3w8KAk7TdotxB5qZuyx5ZRjj4M=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 2/6] dt-bindings: net: phy: Add support for AT803X
Date:   Wed,  6 Nov 2019 23:36:13 +0100
Message-Id: <20191106223617.1655-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106223617.1655-1-michael@walle.cc>
References: <20191106223617.1655-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Atheros AR803x PHY bindings.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/qca,ar803x.yaml   | 111 ++++++++++++++++++
 MAINTAINERS                                   |   2 +
 include/dt-bindings/net/qca-ar803x.h          |  13 ++
 3 files changed, 126 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qca,ar803x.yaml
 create mode 100644 include/dt-bindings/net/qca-ar803x.h

diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
new file mode 100644
index 000000000000..5a6c9d20c0ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
@@ -0,0 +1,111 @@
+# SPDX-License-Identifier: GPL-2.0+
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qca,ar803x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Atheros AR803x PHY
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Heiner Kallweit <hkallweit1@gmail.com>
+
+description: |
+  Bindings for Qualcomm Atheros AR803x PHYs
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  qca,clk-out-frequency:
+    description: Clock output frequency in Hertz.
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32
+      - enum: [ 25000000, 50000000, 62500000, 125000000 ]
+
+  qca,clk-out-strength:
+    description: Clock output driver strength.
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32
+      - enum: [ 0, 1, 2 ]
+
+  qca,keep-pll-enabled:
+    description: |
+      If set, keep the PLL enabled even if there is no link. Useful if you
+      want to use the clock output without an ethernet link.
+
+      Only supported on the AR8031.
+    type: boolean
+
+  vddio-supply:
+    description: |
+      RGMII I/O voltage regulator (see regulator/regulator.yaml).
+
+      The PHY supports RGMII I/O voltages of 1.5V, 1.8V and 2.5V. You can
+      either connect this to the vddio-regulator (1.5V / 1.8V) or the
+      vddh-regulator (2.5V).
+
+      Only supported on the AR8031.
+
+  vddio-regulator:
+    type: object
+    description:
+      Initial data for the VDDIO regulator. Set this to 1.5V or 1.8V.
+    allOf:
+      - $ref: /schemas/regulator/regulator.yaml
+
+  vddh-regulator:
+    type: object
+    description:
+      Dummy subnode to model the external connection of the PHY VDDH
+      regulator to VDDIO.
+    allOf:
+      - $ref: /schemas/regulator/regulator.yaml
+
+
+examples:
+  - |
+    #include <dt-bindings/net/qca-ar803x.h>
+
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        phy-mode = "rgmii-id";
+
+        ethernet-phy@0 {
+            reg = <0>;
+
+            qca,clk-out-frequency = <125000000>;
+            qca,clk-out-strength = <AR803X_STRENGTH_FULL>;
+
+            vddio-supply = <&vddio>;
+
+            vddio: vddio-regulator {
+                regulator-min-microvolt = <1800000>;
+                regulator-max-microvolt = <1800000>;
+            };
+        };
+    };
+  - |
+    #include <dt-bindings/net/qca-ar803x.h>
+
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        phy-mode = "rgmii-id";
+
+        ethernet-phy@0 {
+            reg = <0>;
+
+            qca,clk-out-frequency = <50000000>;
+            qca,keep-pll-enabled;
+
+            vddio-supply = <&vddh>;
+
+            vddh: vddh-regulator {
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index c0024b296158..709c60aacb58 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6155,10 +6155,12 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-class-net-phydev
 F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
+F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/phy/
 F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
+F:	include/dt-bindings/net/qca-ar803x.h
 F:	include/linux/*mdio*.h
 F:	include/linux/of_net.h
 F:	include/linux/phy.h
diff --git a/include/dt-bindings/net/qca-ar803x.h b/include/dt-bindings/net/qca-ar803x.h
new file mode 100644
index 000000000000..9c046c7242ed
--- /dev/null
+++ b/include/dt-bindings/net/qca-ar803x.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Device Tree constants for the Qualcomm Atheros AR803x PHYs
+ */
+
+#ifndef _DT_BINDINGS_QCA_AR803X_H
+#define _DT_BINDINGS_QCA_AR803X_H
+
+#define AR803X_STRENGTH_FULL		0
+#define AR803X_STRENGTH_HALF		1
+#define AR803X_STRENGTH_QUARTER		2
+
+#endif
-- 
2.20.1

