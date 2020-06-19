Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20571201B03
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733171AbgFSTQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733120AbgFSTQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:16:08 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41110C0613EF
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:16:06 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed20:e0be:48f2:cba4:1407])
        by albert.telenet-ops.be with bizsmtp
        id t7Fx220084UASYb067Fx5g; Fri, 19 Jun 2020 21:16:04 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jmMUX-0002Jb-5e; Fri, 19 Jun 2020 21:15:57 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jmMUX-0006VK-4G; Fri, 19 Jun 2020 21:15:57 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 5/5] arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling
Date:   Fri, 19 Jun 2020 21:15:54 +0200
Message-Id: <20200619191554.24942-6-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619191554.24942-1-geert+renesas@glider.be>
References: <20200619191554.24942-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some EtherAVB variants support internal clock delay configuration, which
can add larger delays than the delays that are typically supported by
the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
properties).

Historically, the EtherAVB driver configured these delays based on the
"rgmii-*id" PHY mode.  This was wrong, as these are meant solely for the
PHY, not for the MAC.  Hence properties were introduced for explicit
configuration of these delays.

Convert the RZ/G2 DTS files from the old to the new scheme:
  - Add default "renesas,rxc-delay-ps" and "renesas,txc-delay-ps"
    properties to the SoC .dtsi files, to be overridden by board files
    where needed,
  - Convert board files from "rgmii-*id" PHY modes to "rgmii", adding
    the appropriate "renesas,rxc-delay-ps" and/or "renesas,txc-delay-ps"
    overrides.

Notes:
  - RZ/G2E does not support TX internal delay handling.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on "[PATCH/RFC 3/5] ravb: Add support for explicit internal
clock delay configuration" and must not be applied before that
dependency has hit upstream.
---
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi | 2 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi       | 2 ++
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi       | 2 ++
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi       | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
index acfcfd050a6cb2d5..c2ce2aaea6e6d64b 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
@@ -19,7 +19,7 @@
 	pinctrl-0 = <&avb_pins>;
 	pinctrl-names = "default";
 	phy-handle = <&phy0>;
-	phy-mode = "rgmii-txid";
+	renesas,txc-delay-ps = <2000>;
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index 51a572898fd68a7d..192900c716990860 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1115,6 +1115,8 @@
 			power-domains = <&sysc R8A774A1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			renesas,rxc-delay-ps = <0>;
+			renesas,txc-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index b221f2575e6328f9..3e50541750e93f88 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -989,6 +989,8 @@
 			power-domains = <&sysc R8A774B1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			renesas,rxc-delay-ps = <0>;
+			renesas,txc-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 5c72a7efbb035d02..a478450090f20e0b 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -960,6 +960,7 @@
 			power-domains = <&sysc R8A774C0_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			renesas,rxc-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.17.1

