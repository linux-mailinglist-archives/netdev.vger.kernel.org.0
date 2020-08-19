Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6297824A086
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgHSNtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgHSNoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 09:44:01 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACD5C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 06:43:59 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id HRjl2300H4C55Sk01RjlxX; Wed, 19 Aug 2020 15:43:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1k8ONV-0003Dq-Dq; Wed, 19 Aug 2020 15:43:45 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1k8ONV-0007FV-CD; Wed, 19 Aug 2020 15:43:45 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 2/7] dt-bindings: net: renesas,ravb: Document internal clock delay properties
Date:   Wed, 19 Aug 2020 15:43:39 +0200
Message-Id: <20200819134344.27813-3-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819134344.27813-1-geert+renesas@glider.be>
References: <20200819134344.27813-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some EtherAVB variants support internal clock delay configuration, which
can add larger delays than the delays that are typically supported by
the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
properties).

Add properties for configuring the internal MAC delays.
These properties are mandatory, even when specified as zero, to
distinguish between old and new DTBs.

Update the (bogus) example accordingly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v3:
  - Add Reviewed-by,

v2:
  - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
  - Add "(bogus)" to the example update, to avoid people considering it
    a one-to-one conversion.
---
 .../devicetree/bindings/net/renesas,ravb.txt  | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ravb.txt b/Documentation/devicetree/bindings/net/renesas,ravb.txt
index 032b76f14f4fdb38..4a62dd11d5c488f4 100644
--- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
+++ b/Documentation/devicetree/bindings/net/renesas,ravb.txt
@@ -64,6 +64,18 @@ Optional properties:
 			 AVB_LINK signal.
 - renesas,ether-link-active-low: boolean, specify when the AVB_LINK signal is
 				 active-low instead of normal active-high.
+- rx-internal-delay-ps: Internal RX clock delay.
+			This property is mandatory and valid only on R-Car Gen3
+			and RZ/G2 SoCs.
+			Valid values are 0 and 1800.
+			A non-zero value is allowed only if phy-mode = "rgmii".
+			Zero is not supported on R-Car D3.
+- tx-internal-delay-ps: Internal TX clock delay.
+			This property is mandatory and valid only on R-Car H3,
+			M3-W, M3-W+, M3-N, V3M, and V3H, and RZ/G2M and RZ/G2N.
+			Valid values are 0 and 2000.
+			A non-zero value is allowed only if phy-mode = "rgmii".
+			Zero is not supported on R-Car V3H.
 
 Example:
 
@@ -105,8 +117,10 @@ Example:
 				  "ch24";
 		clocks = <&cpg CPG_MOD 812>;
 		power-domains = <&cpg>;
-		phy-mode = "rgmii-id";
+		phy-mode = "rgmii";
 		phy-handle = <&phy0>;
+		rx-internal-delay-ps = <0>;
+		tx-internal-delay-ps = <2000>;
 
 		pinctrl-0 = <&ether_pins>;
 		pinctrl-names = "default";
@@ -115,18 +129,7 @@ Example:
 		#size-cells = <0>;
 
 		phy0: ethernet-phy@0 {
-			rxc-skew-ps = <900>;
-			rxdv-skew-ps = <0>;
-			rxd0-skew-ps = <0>;
-			rxd1-skew-ps = <0>;
-			rxd2-skew-ps = <0>;
-			rxd3-skew-ps = <0>;
-			txc-skew-ps = <900>;
-			txen-skew-ps = <0>;
-			txd0-skew-ps = <0>;
-			txd1-skew-ps = <0>;
-			txd2-skew-ps = <0>;
-			txd3-skew-ps = <0>;
+			rxc-skew-ps = <1500>;
 			reg = <0>;
 			interrupt-parent = <&gpio2>;
 			interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
-- 
2.17.1

