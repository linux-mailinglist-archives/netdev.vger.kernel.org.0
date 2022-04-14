Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E7C500AF9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242222AbiDNKWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 06:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiDNKWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 06:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2139C3BA6C;
        Thu, 14 Apr 2022 03:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D37A5B82893;
        Thu, 14 Apr 2022 10:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B1EC385A1;
        Thu, 14 Apr 2022 10:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649931592;
        bh=Dzl+uevoigqNdudLuvE4qC7+smltmSP9yUMl4FTRifw=;
        h=From:To:Cc:Subject:Date:From;
        b=WO0ehTsjJQwgxvEjJy8YFkt4+2k4F9uDpys3ENLSnTuF5S2mF55uxOWIvNAIYjfSC
         WdMraMwhthlTFrmL0ACVRb+UwQkwgCF9N7ks1mp8IwXjxgE9+aRFXSg11Fpu1RB7r1
         UnmzRGUx88cTnfRv9mfBOAHSOXenp52fOT4ZqpPFVGPxUvbE0rooopUlIGYJOGesP9
         5Q70uCPmW13CeV98+ZLb5WKgjTw5ylYg0EOo6l/+WzKkrAw/6h8vqSfd90l2hU8Woi
         Cj5bbjAE4+PV64mW3fFUqSJ6Cfq+U/hCNCsvex4S2rSCLrUwq/56aypdqfJmAaATe9
         s7NRkyD7ywPiw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        devicetree@vger.kernel.org, robh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, john@phrozen.org
Subject: [PATCH net-next] dt-bindings: net: mediatek,net: convert to the json-schema
Date:   Thu, 14 Apr 2022 12:19:28 +0200
Message-Id: <a01e3acda892ea0dd46edad024d91f213a9db27c.1649931322.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the existing mediatek-net.txt binding file
in yaml format.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../devicetree/bindings/net/mediatek,net.yaml | 294 ++++++++++++++++++
 .../devicetree/bindings/net/mediatek-net.txt  | 108 -------
 2 files changed, 294 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,net.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-net.txt

diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
new file mode 100644
index 000000000000..6c7696a5b8e7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -0,0 +1,294 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mediatek,net.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Frame Engine Ethernet controller
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The frame engine ethernet controller can be found on MediaTek SoCs. These SoCs
+  have dual GMAC ports.
+
+properties:
+  compatible:
+    enum:
+      - mediatek,mt2701-eth
+      - mediatek,mt7623-eth
+      - mediatek,mt7622-eth
+      - mediatek,mt7629-eth
+      - ralink,rt5350-eth
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 3
+    maxItems: 3
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: fe
+      - const: gmac
+      - const: ppe
+
+  mediatek,ethsys:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the syscon node that handles the port setup.
+
+  cci-control-port: true
+
+  mediatek,hifsys:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the mediatek hifsys controller used to provide various clocks
+      and reset to the system.
+
+  dma-coherent: true
+
+  mdio-bus:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - mediatek,mt2701-eth
+              - mediatek,mt7623-eth
+    then:
+      properties:
+        clocks:
+          minItems: 4
+          maxItems: 4
+
+        clock-names:
+          additionalItems: false
+          items:
+            - const: ethif
+            - const: esw
+            - const: gp1
+            - const: gp2
+
+        mediatek,pctl:
+          $ref: /schemas/types.yaml#/definitions/phandle
+          description:
+            Phandle to the syscon node that handles the ports slew rate and
+            driver current.
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7622-eth
+    then:
+      properties:
+        clocks:
+          minItems: 11
+          maxItems: 11
+
+        clock-names:
+          additionalItems: false
+          items:
+            - const: ethif
+            - const: esw
+            - const: gp0
+            - const: gp1
+            - const: gp2
+            - const: sgmii_tx250m
+            - const: sgmii_rx250m
+            - const: sgmii_cdr_ref
+            - const: sgmii_cdr_fb
+            - const: sgmii_ck
+            - const: eth2pll
+
+        mediatek,sgmiisys:
+          $ref: /schemas/types.yaml#/definitions/phandle-array
+          maxItems: 1
+          description:
+            A list of phandle to the syscon node that handles the SGMII setup which is required for
+            those SoCs equipped with SGMII.
+
+        mediatek,wed:
+          $ref: /schemas/types.yaml#/definitions/phandle-array
+          minItems: 2
+          maxItems: 2
+          description:
+            List of phandles to wireless ethernet dispatch nodes.
+
+        mediatek,pcie-mirror:
+          $ref: /schemas/types.yaml#/definitions/phandle
+          description:
+            Phandle to the mediatek pcie-mirror controller.
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7629-eth
+    then:
+      properties:
+        clocks:
+          minItems: 17
+          maxItems: 17
+
+        clock-names:
+          additionalItems: false
+          items:
+            - const: ethif
+            - const: sgmiitop
+            - const: esw
+            - const: gp0
+            - const: gp1
+            - const: gp2
+            - const: fe
+            - const: sgmii_tx250m
+            - const: sgmii_rx250m
+            - const: sgmii_cdr_ref
+            - const: sgmii_cdr_fb
+            - const: sgmii2_tx250m
+            - const: sgmii2_rx250m
+            - const: sgmii2_cdr_ref
+            - const: sgmii2_cdr_fb
+            - const: sgmii_ck
+            - const: eth2pll
+
+        mediatek,infracfg:
+          $ref: /schemas/types.yaml#/definitions/phandle
+          description:
+            Phandle to the syscon node that handles the path from GMAC to
+            PHY variants.
+
+        mediatek,sgmiisys:
+          $ref: /schemas/types.yaml#/definitions/phandle-array
+          maxItems: 2
+          description:
+            A list of phandle to the syscon node that handles the SGMII setup which is required for
+            those SoCs equipped with SGMII.
+
+patternProperties:
+  "^mac@[0-1]$":
+    type: object
+    additionalProperties: false
+    allOf:
+      - $ref: ethernet-controller.yaml#
+    description:
+      Ethernet MAC node
+    properties:
+      compatible:
+        const: mediatek,eth-mac
+
+      reg:
+        maxItems: 1
+
+      phy-handle: true
+
+      phy-mode: true
+
+    required:
+      - reg
+      - compatible
+      - phy-handle
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - power-domains
+  - mediatek,ethsys
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/clock/mt7622-clk.h>
+    #include <dt-bindings/power/mt7622-power.h>
+
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      ethernet: ethernet@1b100000 {
+        compatible = "mediatek,mt7622-eth";
+        reg = <0 0x1b100000 0 0x20000>;
+        interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_LOW>,
+                     <GIC_SPI 224 IRQ_TYPE_LEVEL_LOW>,
+                     <GIC_SPI 225 IRQ_TYPE_LEVEL_LOW>;
+        clocks = <&topckgen CLK_TOP_ETH_SEL>,
+                 <&ethsys CLK_ETH_ESW_EN>,
+                 <&ethsys CLK_ETH_GP0_EN>,
+                 <&ethsys CLK_ETH_GP1_EN>,
+                 <&ethsys CLK_ETH_GP2_EN>,
+                 <&sgmiisys CLK_SGMII_TX250M_EN>,
+                 <&sgmiisys CLK_SGMII_RX250M_EN>,
+                 <&sgmiisys CLK_SGMII_CDR_REF>,
+                 <&sgmiisys CLK_SGMII_CDR_FB>,
+                 <&topckgen CLK_TOP_SGMIIPLL>,
+                 <&apmixedsys CLK_APMIXED_ETH2PLL>;
+        clock-names = "ethif", "esw", "gp0", "gp1", "gp2",
+                      "sgmii_tx250m", "sgmii_rx250m",
+                      "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck",
+                      "eth2pll";
+        power-domains = <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
+        mediatek,ethsys = <&ethsys>;
+        mediatek,sgmiisys = <&sgmiisys>;
+        cci-control = <&cci_control2>;
+        mediatek,pcie-mirror = <&pcie_mirror>;
+        mediatek,hifsys = <&hifsys>;
+        dma-coherent;
+
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio0: mdio-bus {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          phy0: ethernet-phy@0 {
+            reg = <0>;
+          };
+
+          phy1: ethernet-phy@1 {
+            reg = <1>;
+          };
+        };
+
+        gmac0: mac@0 {
+          compatible = "mediatek,eth-mac";
+          phy-mode = "rgmii";
+          phy-handle = <&phy0>;
+          reg = <0>;
+        };
+
+        gmac1: mac@1 {
+          compatible = "mediatek,eth-mac";
+          phy-mode = "rgmii";
+          phy-handle = <&phy1>;
+          reg = <1>;
+        };
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
deleted file mode 100644
index f18d70189375..000000000000
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ /dev/null
@@ -1,108 +0,0 @@
-MediaTek Frame Engine Ethernet controller
-=========================================
-
-The frame engine ethernet controller can be found on MediaTek SoCs. These SoCs
-have dual GMAC each represented by a child node..
-
-* Ethernet controller node
-
-Required properties:
-- compatible: Should be
-		"mediatek,mt2701-eth": for MT2701 SoC
-		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
-		"mediatek,mt7622-eth": for MT7622 SoC
-		"mediatek,mt7629-eth": for MT7629 SoC
-		"ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the three frame engines interrupts in numeric
-	order. These are fe_int0, fe_int1 and fe_int2.
-- clocks: the clock used by the core
-- clock-names: the names of the clock listed in the clocks property. These are
-	"ethif", "esw", "gp2", "gp1" : For MT2701 and MT7623 SoC
-        "ethif", "esw", "gp0", "gp1", "gp2", "sgmii_tx250m", "sgmii_rx250m",
-	"sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck", "eth2pll" : For MT7622 SoC
-	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "sgmii_tx250m",
-	"sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii2_tx250m",
-	"sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb", "sgmii_ck",
-	"eth2pll" : For MT7629 SoC.
-- power-domains: phandle to the power domain that the ethernet is part of
-- resets: Should contain phandles to the ethsys reset signals
-- reset-names: Should contain the names of reset signal listed in the resets
-		property
-		These are "fe", "gmac" and "ppe"
-- mediatek,ethsys: phandle to the syscon node that handles the port setup
-- mediatek,infracfg: phandle to the syscon node that handles the path from
-	GMAC to PHY variants, which is required for MT7629 SoC.
-- mediatek,sgmiisys: a list of phandles to the syscon node that handles the
-	SGMII setup which is required for those SoCs equipped with SGMII such
-	as MT7622 and MT7629 SoC. And MT7622 have only one set of SGMII shared
-	by GMAC1 and GMAC2; MT7629 have two independent sets of SGMII directed
-	to GMAC1 and GMAC2, respectively.
-- mediatek,pctl: phandle to the syscon node that handles the ports slew rate
-	and driver current: only for MT2701 and MT7623 SoC
-
-Optional properties:
-- dma-coherent: present if dma operations are coherent
-- mediatek,cci-control: phandle to the cache coherent interconnect node
-- mediatek,hifsys: phandle to the mediatek hifsys controller used to provide
-	various clocks and reset to the system.
-- mediatek,wed: a list of phandles to wireless ethernet dispatch nodes for
-	MT7622 SoC.
-- mediatek,pcie-mirror: phandle to the mediatek pcie-mirror controller for
-	MT7622 SoC.
-
-* Ethernet MAC node
-
-Required properties:
-- compatible: Should be "mediatek,eth-mac"
-- reg: The number of the MAC
-- phy-handle: see ethernet.txt file in the same directory and
-	the phy-mode "trgmii" required being provided when reg
-	is equal to 0 and the MAC uses fixed-link to connect
-	with internal switch such as MT7530.
-
-Example:
-
-eth: ethernet@1b100000 {
-	compatible = "mediatek,mt7623-eth";
-	reg = <0 0x1b100000 0 0x20000>;
-	clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
-		 <&ethsys CLK_ETHSYS_ESW>,
-		 <&ethsys CLK_ETHSYS_GP2>,
-		 <&ethsys CLK_ETHSYS_GP1>;
-	clock-names = "ethif", "esw", "gp2", "gp1";
-	interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_LOW
-		      GIC_SPI 199 IRQ_TYPE_LEVEL_LOW
-		      GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>;
-	power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
-	resets = <&ethsys MT2701_ETHSYS_ETH_RST>;
-	reset-names = "eth";
-	mediatek,ethsys = <&ethsys>;
-	mediatek,pctl = <&syscfg_pctl_a>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	gmac1: mac@0 {
-		compatible = "mediatek,eth-mac";
-		reg = <0>;
-		phy-handle = <&phy0>;
-	};
-
-	gmac2: mac@1 {
-		compatible = "mediatek,eth-mac";
-		reg = <1>;
-		phy-handle = <&phy1>;
-	};
-
-	mdio-bus {
-		phy0: ethernet-phy@0 {
-			reg = <0>;
-			phy-mode = "rgmii";
-		};
-
-		phy1: ethernet-phy@1 {
-			reg = <1>;
-			phy-mode = "rgmii";
-		};
-	};
-};
-- 
2.35.1

