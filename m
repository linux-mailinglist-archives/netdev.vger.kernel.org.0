Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61624564084
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiGBOB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiGBOBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:01:52 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 043E3DEFF;
        Sat,  2 Jul 2022 07:01:48 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,240,1650898800"; 
   d="scan'208";a="124846492"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Jul 2022 23:01:48 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 0353143676A2;
        Sat,  2 Jul 2022 23:01:43 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
Date:   Sat,  2 Jul 2022 15:01:26 +0100
Message-Id: <20220702140130.218409-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
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

Add CAN binding documentation for Renesas RZ/N1 SoC.

The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
to others like it has no clock divider register (CDR) support and it has
no HW loopback(HW doesn't see tx messages on rx), so introduced a new
compatible 'renesas,rzn1-sja1000' to handle these differences.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 .../bindings/net/can/nxp,sja1000.yaml         | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
index 91d0f1b25d10..d0d374b979ec 100644
--- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
+++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
@@ -16,6 +16,12 @@ properties:
         const: nxp,sja1000
       - description: Technologic Systems SJA1000 CAN Controller
         const: technologic,sja1000
+      - description: Renesas RZ/N1 SJA1000 CAN Controller
+        items:
+          - enum:
+              - renesas,r9a06g032-sja1000 # RZ/N1D
+              - renesas,r9a06g033-sja1000 # RZ/N1S
+          - const: renesas,rzn1-sja1000 # RZ/N1
 
   reg:
     maxItems: 1
@@ -23,6 +29,12 @@ properties:
   interrupts:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: can_clk
+
   reg-io-width:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: I/O register width (in bytes) implemented by this device
@@ -91,6 +103,16 @@ allOf:
       required:
         - reg-io-width
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,rzn1-sja1000
+    then:
+      required:
+        - clocks
+        - clock-names
+
 unevaluatedProperties: false
 
 examples:
-- 
2.25.1

