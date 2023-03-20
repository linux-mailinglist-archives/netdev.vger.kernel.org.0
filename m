Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5D6C1D35
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjCTRGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjCTRF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B548269B;
        Mon, 20 Mar 2023 10:00:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 781CB61711;
        Mon, 20 Mar 2023 16:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85043C4339B;
        Mon, 20 Mar 2023 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331553;
        bh=RPN5GKehZn7MatCJiaJVlbKQyXSE1v+L4syKACvc6v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7kE/g/grJp2TGih7tfNFWvm5Zt0eLUv2hxrd2188xBXqzJ6sBudotFlJKy0C/GtZ
         pmXPtBVNjnmLmgduzdwMEeCCSEa/UssLmNYIwEmuQI4TWoUV/El7UJx/r/v7cu6n/l
         BRORfrJnUCJXUmYLaFU/gJq4ki/gsUGDVLVOh2+BUqPtgbA7skFuMGIIuvFJDWU/gV
         qjJaYDoqQ85yg/+h9smoXjsBVdi2+7FhwuTpKQ0UKkS8PWrW+Ph52n/Bc/vbNnX4XA
         6nQllJRFo9bvz6kzWnJARyO+VyNIK0SjUS+JsXU8906UvEvEtNtpEjneT79ZVfdi5A
         IWRC0XoPA0XoQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 06/10] dt-bindings: soc: mediatek: move ilm in a dedicated dts node
Date:   Mon, 20 Mar 2023 17:58:00 +0100
Message-Id: <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
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

Since the cpuboot memory region is not part of the RAM SoC, move ilm in
a deidicated syscon node.
This patch helps to keep backward-compatibility with older version of
uboot codebase where we have a limit of 8 reserved-memory dts child
nodes.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
 .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++++
 2 files changed, 53 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 7f6638d43854..5d2397ec5891 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -32,14 +32,12 @@ properties:
   memory-region:
     items:
       - description: firmware EMI region
-      - description: firmware ILM region
       - description: firmware DLM region
       - description: firmware CPU DATA region
 
   memory-region-names:
     items:
       - const: wo-emi
-      - const: wo-ilm
       - const: wo-dlm
       - const: wo-data
 
@@ -51,6 +49,10 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: mediatek wed-wo cpuboot controller interface.
 
+  mediatek,wo-ilm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: mediatek wed-wo ilm interface.
+
 allOf:
   - if:
       properties:
@@ -63,6 +65,7 @@ allOf:
         memory-region: false
         mediatek,wo-ccif: false
         mediatek,wo-cpuboot: false
+        mediatek,wo-ilm: false
 
 required:
   - compatible
@@ -97,11 +100,10 @@ examples:
         reg = <0 0x15010000 0 0x1000>;
         interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
 
-        memory-region = <&wo_emi>, <&wo_ilm>, <&wo_dlm>,
-                        <&wo_data>;
-        memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
-                              "wo-data";
+        memory-region = <&wo_emi>, <&wo_dlm>, &wo_data>;
+        memory-region-names = "wo-emi", "wo-dlm", "wo-data";
         mediatek,wo-ccif = <&wo_ccif0>;
         mediatek,wo-cpuboot = <&wo_cpuboot>;
+        mediatek,wo-ilm = <&wo_ilm>;
       };
     };
diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
new file mode 100644
index 000000000000..2a3775cd941e
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-ilm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch (WED) WO ILM firmware interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The MediaTek wo-ilm (Information Lifecycle Management) provides a configuration
+  interface for WiFi critical data used by WED WO firmware. WED WO controller is
+  used to perform offload rx packet processing (e.g. 802.11 aggregation packet
+  reordering or rx header translation) on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-ilm
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
+      syscon@151e0000 {
+        compatible = "mediatek,mt7986-wo-ilm", "syscon";
+        reg = <0 0x151e0000 0 0x8000>;
+      };
+    };
-- 
2.39.2

