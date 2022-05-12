Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F5524C02
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353411AbiELLrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353404AbiELLrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:47:51 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C24B4E3B1;
        Thu, 12 May 2022 04:47:48 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,219,1647270000"; 
   d="scan'208";a="120774508"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 12 May 2022 20:47:47 +0900
Received: from localhost.localdomain (unknown [10.226.93.50])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id A6DF740062AC;
        Thu, 12 May 2022 20:47:43 +0900 (JST)
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH v4 1/5] dt-bindings: net: renesas,etheravb: Document RZ/V2M SoC
Date:   Thu, 12 May 2022 12:47:18 +0100
Message-Id: <20220512114722.35965-2-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220512114722.35965-1-phil.edworthy@renesas.com>
References: <20220512114722.35965-1-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Ethernet AVB IP found on RZ/V2M SoC.
It includes the Ethernet controller (E-MAC) and Dedicated Direct memory
access controller (DMAC) for transferring transmitted Ethernet frames
to and received Ethernet frames from respective storage areas in the
RAM at high speed.
The AVB-DMAC is compliant with IEEE 802.1BA, IEEE 802.1AS timing and
synchronization protocol, IEEE 802.1Qav real-time transfer, and the
IEEE 802.1Qat stream reservation protocol.

R-Car has a pair of combined interrupt lines:
 ch22 = Line0_DiA | Line1_A | Line2_A
 ch23 = Line0_DiB | Line1_B | Line2_B
Line0 for descriptor interrupts (which we call dia and dib).
Line1 for error related interrupts (which we call err_a and err_b).
Line2 for management and gPTP related interrupts (mgmt_a and mgmt_b).

RZ/V2M hardware has separate interrupt lines for each of these.

It has 3 clocks; the main AXI clock, the AMBA CHI (Coherent Hub
Interface) clock and a gPTP reference clock.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v4:
 - Added Reviewed-by tags
v3:
 - No change
v2:
 - Instead of reusing ch22 and ch24 interupt names, use the proper names
---
 .../bindings/net/renesas,etheravb.yaml        | 82 ++++++++++++++-----
 1 file changed, 61 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index ee2ccacc39ff..acf347f3cdbe 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -43,6 +43,11 @@ properties:
               - renesas,etheravb-r8a779a0     # R-Car V3U
           - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
 
+      - items:
+          - enum:
+              - renesas,etheravb-r9a09g011 # RZ/V2M
+          - const: renesas,etheravb-rzv2m  # RZ/V2M compatible
+
       - items:
           - enum:
               - renesas,r9a07g043-gbeth # RZ/G2UL
@@ -160,16 +165,33 @@ allOf:
             - const: arp_ns
         rx-internal-delay-ps: false
     else:
-      properties:
-        interrupts:
-          minItems: 25
-          maxItems: 25
-        interrupt-names:
-          items:
-            pattern: '^ch[0-9]+$'
-      required:
-        - interrupt-names
-        - rx-internal-delay-ps
+      if:
+        properties:
+          compatible:
+            contains:
+              const: renesas,etheravb-rzv2m
+      then:
+        properties:
+          interrupts:
+            minItems: 29
+            maxItems: 29
+          interrupt-names:
+            items:
+              pattern: '^(ch(1?)[0-9])|ch20|ch21|dia|dib|err_a|err_b|mgmt_a|mgmt_b|line3$'
+          rx-internal-delay-ps: false
+        required:
+          - interrupt-names
+      else:
+        properties:
+          interrupts:
+            minItems: 25
+            maxItems: 25
+          interrupt-names:
+            items:
+              pattern: '^ch[0-9]+$'
+        required:
+          - interrupt-names
+          - rx-internal-delay-ps
 
   - if:
       properties:
@@ -231,17 +253,35 @@ allOf:
             - const: chi
             - const: refclk
     else:
-      properties:
-        clocks:
-          minItems: 1
-          items:
-            - description: AVB functional clock
-            - description: Optional TXC reference clock
-        clock-names:
-          minItems: 1
-          items:
-            - const: fck
-            - const: refclk
+      if:
+        properties:
+          compatible:
+            contains:
+              const: renesas,etheravb-rzv2m
+      then:
+        properties:
+          clocks:
+            items:
+              - description: Main clock
+              - description: Coherent Hub Interface clock
+              - description: gPTP reference clock
+          clock-names:
+            items:
+              - const: axi
+              - const: chi
+              - const: gptp
+      else:
+        properties:
+          clocks:
+            minItems: 1
+            items:
+              - description: AVB functional clock
+              - description: Optional TXC reference clock
+          clock-names:
+            minItems: 1
+            items:
+              - const: fck
+              - const: refclk
 
 additionalProperties: false
 
-- 
2.34.1

