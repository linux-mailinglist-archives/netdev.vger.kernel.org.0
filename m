Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE649249E8E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgHSMrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgHSMpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 08:45:41 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C488C061342
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 05:45:40 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id HQlg230044C55Sk06Qlgcw; Wed, 19 Aug 2020 14:45:40 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1k8NTI-0002Nb-5r; Wed, 19 Aug 2020 14:45:40 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1k8NTI-0005HL-4R; Wed, 19 Aug 2020 14:45:40 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] dt-bindings: net: renesas,ether: Improve schema validation
Date:   Wed, 19 Aug 2020 14:45:39 +0200
Message-Id: <20200819124539.20239-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - Remove pinctrl consumer properties, as they are handled by core
    dt-schema,
  - Document missing properties,
  - Document missing PHY child node,
  - Add "additionalProperties: false".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v2:
  - Add Reviewed-by.
---
 .../bindings/net/renesas,ether.yaml           | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
index 08678af5ed9364cd..8ce5ed8a58dd76e6 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -59,9 +59,15 @@ properties:
   clocks:
     maxItems: 1
 
-  pinctrl-0: true
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
 
-  pinctrl-names: true
+  phy-mode: true
+
+  phy-handle: true
 
   renesas,no-ether-link:
     type: boolean
@@ -74,6 +80,11 @@ properties:
       specify when the Ether LINK signal is active-low instead of normal
       active-high
 
+patternProperties:
+  "^ethernet-phy@[0-9a-f]$":
+    type: object
+    $ref: ethernet-phy.yaml#
+
 required:
   - compatible
   - reg
@@ -83,7 +94,8 @@ required:
   - '#address-cells'
   - '#size-cells'
   - clocks
-  - pinctrl-0
+
+additionalProperties: false
 
 examples:
   # Lager board
@@ -99,8 +111,6 @@ examples:
         clocks = <&mstp8_clks R8A7790_CLK_ETHER>;
         phy-mode = "rmii";
         phy-handle = <&phy1>;
-        pinctrl-0 = <&ether_pins>;
-        pinctrl-names = "default";
         renesas,ether-link-active-low;
         #address-cells = <1>;
         #size-cells = <0>;
@@ -109,7 +119,5 @@ examples:
             reg = <1>;
             interrupt-parent = <&irqc0>;
             interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
-            pinctrl-0 = <&phy1_pins>;
-            pinctrl-names = "default";
         };
     };
-- 
2.17.1

