Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4C56C1D50
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjCTRHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbjCTRHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0313866D;
        Mon, 20 Mar 2023 10:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4356616DF;
        Mon, 20 Mar 2023 16:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD997C4339B;
        Mon, 20 Mar 2023 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331565;
        bh=JGceNNPm2h9mHgqAOqJItA9A7Xxmjgx4sH2gAUDtI54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9GiySGkaU7sK05Sv6JaUINHJhaM1UxUFiMHs2i8Qsnw7RW5qEE7NJeLbqDYdRgJM
         j6y4u64NGy0//Pg1+8AK4hq+jBYqYnzLHx/UyAU3h5lmAmkTk0UP6R2B+aiUppVNHw
         EXSBQN+8Ltr3uGexYTHaqun4LHNHC4xU0ogo3ubpXDVSbiD4H43n5ZEd/ehuyigC1z
         y8CW3C/jgvH+MRJ2jpL/kDDOHP0Pa0dESP9YDY1cjxuopRarRPURSMakBlgUT3Jv3j
         6SZ49QCoMCRxqXyadEgq+TIO6wSNYHgLPRlwiqPjTffLKxnJEj3UqFPf71g3Qb1l8T
         4n7Luj0vyVaog==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 09/10] dt-bindings: soc: mediatek: move dlm in a dedicated dts node
Date:   Mon, 20 Mar 2023 17:58:03 +0100
Message-Id: <63bf6061ec5ee6d706a18b45a0b3714b891cb439.1679330630.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679330630.git.lorenzo@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the cpuboot memory region is not part of the RAM SoC, move dlm in
a deidicated syscon node.
This patch helps to keep backward-compatibility with older version of
uboot codebase where we have a limit of 8 reserved-memory dts child
nodes.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 12 +++--
 .../soc/mediatek/mediatek,mt7986-wo-dlm.yaml  | 46 +++++++++++++++++++
 2 files changed, 54 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 5d2397ec5891..e4707880eca7 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -32,13 +32,11 @@ properties:
   memory-region:
     items:
       - description: firmware EMI region
-      - description: firmware DLM region
       - description: firmware CPU DATA region
 
   memory-region-names:
     items:
       - const: wo-emi
-      - const: wo-dlm
       - const: wo-data
 
   mediatek,wo-ccif:
@@ -53,6 +51,10 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: mediatek wed-wo ilm interface.
 
+  mediatek,wo-dlm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: mediatek wed-wo dlm interface.
+
 allOf:
   - if:
       properties:
@@ -66,6 +68,7 @@ allOf:
         mediatek,wo-ccif: false
         mediatek,wo-cpuboot: false
         mediatek,wo-ilm: false
+        mediatek,wo-dlm: false
 
 required:
   - compatible
@@ -100,10 +103,11 @@ examples:
         reg = <0 0x15010000 0 0x1000>;
         interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
 
-        memory-region = <&wo_emi>, <&wo_dlm>, &wo_data>;
-        memory-region-names = "wo-emi", "wo-dlm", "wo-data";
+        memory-region = <&wo_emi>, <&wo_data>;
+        memory-region-names = "wo-emi", "wo-data";
         mediatek,wo-ccif = <&wo_ccif0>;
         mediatek,wo-cpuboot = <&wo_cpuboot>;
         mediatek,wo-ilm = <&wo_ilm>;
+        mediatek,wo-dlm = <&wo_dlm>;
       };
     };
diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml
new file mode 100644
index 000000000000..2b9c6a8ef918
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-dlm.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-dlm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch (WED) WO DLM firmware interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The MediaTek wo-dlm (Data Lifecycle Management) provides a configuration
+  interface for WED WO firmware rx rings, including firmware I/O descriptor
+  ring, feedback command ring. WED WO controller is used to perform offload
+  rx packet processing (e.g. 802.11 aggregation packet reordering or rx
+  header translation) on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-dlm
+      - const: syscon
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      syscon@151e8000 {
+        compatible = "mediatek,mt7986-wo-dlm", "syscon";
+        reg = <0 0x151e8000 0 0x2000>;
+      };
+    };
-- 
2.39.2

