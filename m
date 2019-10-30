Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488D3EA676
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfJ3WnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:43:07 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:52165 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfJ3WnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:43:06 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 834D622EE4;
        Wed, 30 Oct 2019 23:43:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572475383;
        bh=2nqBdwy/goa8bNtLuPpQtky+yG6Rfoal/1lI2pumSNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLeq02PKY8brujBPsziiI5NjHTblaCm4jqgLH0SoMxDX8AG2FjQVDFFE5qa1+Zp14
         RYf2jCLTxz0qJlr5W87w+u2kdkh3VxuxzDyA+Fd3Dx2c8eNHfRZI793eko1MH3lLQf
         fe7ZWvmM91gYAuxn95UFQU8H58MNjkzds+DMfBoA=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
Date:   Wed, 30 Oct 2019 23:42:50 +0100
Message-Id: <20191030224251.21578-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030224251.21578-1-michael@walle.cc>
References: <20191030224251.21578-1-michael@walle.cc>
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
---
 .../bindings/net/atheros,at803x.yaml          | 58 +++++++++++++++++++
 include/dt-bindings/net/atheros-at803x.h      | 13 +++++
 2 files changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/atheros,at803x.yaml
 create mode 100644 include/dt-bindings/net/atheros-at803x.h

diff --git a/Documentation/devicetree/bindings/net/atheros,at803x.yaml b/Documentation/devicetree/bindings/net/atheros,at803x.yaml
new file mode 100644
index 000000000000..60500fd90fd8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/atheros,at803x.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: GPL-2.0+
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/atheros,at803x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Atheros AR803x PHY
+
+maintainers:
+  - TBD
+
+description: |
+  Bindings for Atheros AR803x PHYs
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  atheros,clk-out-frequency:
+    description: Clock output frequency in Hertz.
+    enum: [ 25000000, 50000000, 62500000, 125000000 ]
+
+  atheros,clk-out-strength:
+    description: Clock output driver strength.
+    enum: [ 0, 1, 2 ]
+
+  atheros,keep-pll-enabled:
+    description: |
+      If set, keep the PLL enabled even if there is no link. Useful if you
+      want to use the clock output without an ethernet link.
+    type: boolean
+
+  atheros,rgmii-io-1v8:
+    description: |
+      The PHY supports RGMII I/O voltages of 2.5V, 1.8V and 1.5V. By default,
+      the PHY uses a voltage of 1.5V. If this is set, the voltage will changed
+      to 1.8V.
+      The 2.5V voltage is only supported with an external supply voltage.
+    type: boolean
+
+examples:
+  - |
+    #include <dt-bindings/net/atheros-at803x.h>
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
+            atheros,clk-out-frequency = <125000000>;
+            atheros,clk-out-strength = <AT803X_STRENGTH_FULL>;
+            atheros,rgmii-io-1v8;
+        };
+    };
diff --git a/include/dt-bindings/net/atheros-at803x.h b/include/dt-bindings/net/atheros-at803x.h
new file mode 100644
index 000000000000..63b4fd10b2c6
--- /dev/null
+++ b/include/dt-bindings/net/atheros-at803x.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Device Tree constants for the Atheros AR803x PHYs
+ */
+
+#ifndef _DT_BINDINGS_ATHEROS_AR803X_H
+#define _DT_BINDINGS_ATHEROS_AR803X_H
+
+#define AT803X_STRENGTH_FULL		0
+#define AT803X_STRENGTH_HALF		1
+#define AT803X_STRENGTH_QUARTER		2
+
+#endif
-- 
2.20.1

