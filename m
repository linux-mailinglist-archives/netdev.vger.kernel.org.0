Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2889C3D751C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhG0Me7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:34:59 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:15864 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232013AbhG0Me5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 08:34:57 -0400
X-IronPort-AV: E=Sophos;i="5.84,273,1620658800"; 
   d="scan'208";a="88916629"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jul 2021 21:34:55 +0900
Received: from localhost.localdomain (unknown [10.226.92.236])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 10499425F871;
        Tue, 27 Jul 2021 21:34:52 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v2] dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
Date:   Tue, 27 Jul 2021 13:34:50 +0100
Message-Id: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Gigabit Ethernet IP found on RZ/G2L SoC.

Gigabit Ethernet Interface includes Ethernet controller (E-MAC),
Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
access controller (DMAC) for transferring transmitted Ethernet
frames to and received Ethernet frames from respective storage
areas in the URAM at high speed.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v1->v2:
 * No change. Seperated binding patch from driver patch series as per [1]
 [1]
  https://www.spinics.net/lists/linux-renesas-soc/msg59067.html
v1:-
 * New patch
---
 .../bindings/net/renesas,etheravb.yaml        | 57 +++++++++++++++----
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 005868f703a6..5e12a759004f 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -43,23 +43,20 @@ properties:
               - renesas,etheravb-r8a779a0     # R-Car V3U
           - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
 
+      - items:
+          - enum:
+              - renesas,r9a07g044-gbeth # RZ/G2{L,LC}
+          - const: renesas,rzg2l-gbeth  # RZ/G2L
+
   reg: true
 
   interrupts: true
 
   interrupt-names: true
 
-  clocks:
-    minItems: 1
-    items:
-      - description: AVB functional clock
-      - description: Optional TXC reference clock
+  clocks: true
 
-  clock-names:
-    minItems: 1
-    items:
-      - const: fck
-      - const: refclk
+  clock-names: true
 
   iommus:
     maxItems: 1
@@ -145,14 +142,20 @@ allOf:
       properties:
         compatible:
           contains:
-            const: renesas,etheravb-rcar-gen2
+            enum:
+              - renesas,etheravb-rcar-gen2
+              - renesas,rzg2l-gbeth
     then:
       properties:
         interrupts:
-          maxItems: 1
+          minItems: 1
+          maxItems: 3
         interrupt-names:
+          minItems: 1
           items:
             - const: mux
+            - const: int_fil_n
+            - const: int_arp_ns_n
         rx-internal-delay-ps: false
     else:
       properties:
@@ -208,6 +211,36 @@ allOf:
         tx-internal-delay-ps:
           const: 2000
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,rzg2l-gbeth
+    then:
+      properties:
+        clocks:
+          items:
+            - description: Main clock
+            - description: Register access clock
+            - description: Reference clock for RGMII
+        clock-names:
+          items:
+            - const: axi
+            - const: chi
+            - const: refclk
+    else:
+      properties:
+        clocks:
+          minItems: 1
+          items:
+            - description: AVB functional clock
+            - description: Optional TXC reference clock
+        clock-names:
+          minItems: 1
+          items:
+            - const: fck
+            - const: refclk
+
 additionalProperties: false
 
 examples:
-- 
2.17.1

