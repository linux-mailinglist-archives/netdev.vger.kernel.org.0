Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF20B41ED2D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354241AbhJAMPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354271AbhJAMPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 08:15:09 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75ADC06177B
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 05:13:24 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id 0cDN2600R4C55Sk06cDN5W; Fri, 01 Oct 2021 14:13:23 +0200
Received: from rox.of.borg ([192.168.97.57] helo=rox)
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mWHPm-0010wW-34; Fri, 01 Oct 2021 14:13:22 +0200
Received: from geert by rox with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mWHPl-00BIkI-L3; Fri, 01 Oct 2021 14:13:21 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: renesas,ether: Update example to match reality
Date:   Fri,  1 Oct 2021 14:13:20 +0200
Message-Id: <a1cf8a6ccca511e948075c4e20eea2e2ba001c2c.1633090323.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - Drop unneeded interrupt-parent,
  - Convert to new style CPG/MSSR bindings,
  - Add missing power-domains and resets properties,
  - Update PHY subnode:
      - Add example compatible values,
      - Add micrel,led-mode and reset-gpios examples.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 .../devicetree/bindings/net/renesas,ether.yaml  | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
index c101a1ec846ea8e9..06b38c9bc6ec38e4 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -100,15 +100,18 @@ additionalProperties: false
 examples:
   # Lager board
   - |
-    #include <dt-bindings/clock/r8a7790-clock.h>
-    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/clock/r8a7790-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a7790-sysc.h>
+    #include <dt-bindings/gpio/gpio.h>
 
     ethernet@ee700000 {
         compatible = "renesas,ether-r8a7790", "renesas,rcar-gen2-ether";
         reg = <0xee700000 0x400>;
-        interrupt-parent = <&gic>;
-        interrupts = <0 162 IRQ_TYPE_LEVEL_HIGH>;
-        clocks = <&mstp8_clks R8A7790_CLK_ETHER>;
+        interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&cpg CPG_MOD 813>;
+        power-domains = <&sysc R8A7790_PD_ALWAYS_ON>;
+        resets = <&cpg 813>;
         phy-mode = "rmii";
         phy-handle = <&phy1>;
         renesas,ether-link-active-low;
@@ -116,8 +119,12 @@ examples:
         #size-cells = <0>;
 
         phy1: ethernet-phy@1 {
+            compatible = "ethernet-phy-id0022.1537",
+                         "ethernet-phy-ieee802.3-c22";
             reg = <1>;
             interrupt-parent = <&irqc0>;
             interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+            micrel,led-mode = <1>;
+            reset-gpios = <&gpio5 31 GPIO_ACTIVE_LOW>;
         };
     };
-- 
2.25.1

