Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E21E313418
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhBHN6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:58:09 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:56784 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhBHN5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:57:01 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 03/24] dt-bindings: net: dwmac: Fix the TSO property declaration
Date:   Mon, 8 Feb 2021 16:55:47 +0300
Message-ID: <20210208135609.7685-4-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed the STMMAC driver doesn't take the vendor-specific compatible
string into account to parse the "snps,tso" boolean property. It just
makes sure the node is compatible with DW MAC 4.x, 5.x and DW xGMAC
IP-cores. The original allwinner sunXi bindings file also didn't have the
TSO-related property declared. Taking all of that into account fix the
conditional statement so the TSO-property would be evaluated for the
compatibles having the corresponding IP-core version.

While at it move the whole allOf-block from the tail of the binding file
to the head of it, as it's normally done in the most of the DT schemas.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Note this won't break the bindings description, since the "snps,tso"
property isn't parsed by the Allwinner SunX GMAC glue driver, but only
by the generic platform DT-parser.

Changelog v2:
- Use correct syntax of the JSON pointers, so the later would begin
  with a '/' after the '#'.
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 52 +++++++++----------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index cb68a8dcafd7..03d58bf9965f 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -37,6 +37,30 @@ select:
   required:
     - compatible
 
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - snps,dwmac-4.00
+              - snps,dwmac-4.10a
+              - snps,dwmac-4.20a
+              - snps,dwmac-5.10a
+              - snps,dwxgmac
+              - snps,dwxgmac-2.10
+
+      required:
+        - compatible
+    then:
+      properties:
+        snps,tso:
+          $ref: /schemas/types.yaml#/definitions/flag
+          description:
+            Enables the TSO feature otherwise it will be managed by
+            MAC HW capability register.
+
 properties:
 
   # We need to include all the compatibles from schemas that will
@@ -317,34 +341,6 @@ dependencies:
   snps,reset-active-low: ["snps,reset-gpio"]
   snps,reset-delay-us: ["snps,reset-gpio"]
 
-allOf:
-  - $ref: "ethernet-controller.yaml#"
-  - if:
-      properties:
-        compatible:
-          contains:
-            enum:
-              - allwinner,sun7i-a20-gmac
-              - allwinner,sun8i-a83t-emac
-              - allwinner,sun8i-h3-emac
-              - allwinner,sun8i-r40-emac
-              - allwinner,sun8i-v3s-emac
-              - allwinner,sun50i-a64-emac
-              - snps,dwmac-4.00
-              - snps,dwmac-4.10a
-              - snps,dwmac-4.20a
-              - snps,dwxgmac
-              - snps,dwxgmac-2.10
-              - st,spear600-gmac
-
-    then:
-      properties:
-        snps,tso:
-          $ref: /schemas/types.yaml#/definitions/flag
-          description:
-            Enables the TSO feature otherwise it will be managed by
-            MAC HW capability register.
-
 additionalProperties: true
 
 examples:
-- 
2.29.2

