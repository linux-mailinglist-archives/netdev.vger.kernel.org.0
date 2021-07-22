Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2228D3D2555
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhGVNeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:02 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:54735 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232290AbhGVNdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:33:37 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414730"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:03 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9B922401224A;
        Thu, 22 Jul 2021 23:13:59 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next 01/18] dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
Date:   Thu, 22 Jul 2021 15:13:34 +0100
Message-Id: <20210722141351.13668-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
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

