Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14104483B1B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiADDkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:40:00 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:59642 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232678AbiADDj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:39:56 -0500
X-UUID: 248c0e17e5a04d56b759596ab87ee96e-20220104
X-UUID: 248c0e17e5a04d56b759596ab87ee96e-20220104
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 872503568; Tue, 04 Jan 2022 11:39:52 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 4 Jan 2022 11:39:51 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Jan 2022 11:39:50 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: [PATCH net-next v11 6/6] net: dt-bindings: dwmac: add support for mt8195
Date:   Tue, 4 Jan 2022 11:39:40 +0800
Message-ID: <20220104033940.5497-7-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104033940.5497-1-biao.huang@mediatek.com>
References: <20220104033940.5497-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for the ethernet on mt8195.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../bindings/net/mediatek-dwmac.yaml          | 95 +++++++++++++++----
 1 file changed, 75 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
index 8ad6e19661b8..fb04166404d8 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -19,34 +19,79 @@ select:
       contains:
         enum:
           - mediatek,mt2712-gmac
+          - mediatek,mt8195-gmac
   required:
     - compatible
 
 allOf:
   - $ref: "snps,dwmac.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - mediatek,mt2712-gmac
+
+    then:
+      properties:
+        clocks:
+          minItems: 5
+          items:
+            - description: AXI clock
+            - description: APB clock
+            - description: MAC Main clock
+            - description: PTP clock
+            - description: RMII reference clock provided by MAC
+
+        clock-names:
+          minItems: 5
+          items:
+            - const: axi
+            - const: apb
+            - const: mac_main
+            - const: ptp_ref
+            - const: rmii_internal
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - mediatek,mt8195-gmac
+
+    then:
+      properties:
+        clocks:
+          minItems: 6
+          items:
+            - description: AXI clock
+            - description: APB clock
+            - description: MAC clock gate
+            - description: MAC Main clock
+            - description: PTP clock
+            - description: RMII reference clock provided by MAC
+
+        clock-names:
+          minItems: 6
+          items:
+            - const: axi
+            - const: apb
+            - const: mac_cg
+            - const: mac_main
+            - const: ptp_ref
+            - const: rmii_internal
 
 properties:
   compatible:
-    items:
-      - enum:
-          - mediatek,mt2712-gmac
-      - const: snps,dwmac-4.20a
-
-  clocks:
-    items:
-      - description: AXI clock
-      - description: APB clock
-      - description: MAC Main clock
-      - description: PTP clock
-      - description: RMII reference clock provided by MAC
-
-  clock-names:
-    items:
-      - const: axi
-      - const: apb
-      - const: mac_main
-      - const: ptp_ref
-      - const: rmii_internal
+    oneOf:
+      - items:
+          - enum:
+              - mediatek,mt2712-gmac
+          - const: snps,dwmac-4.20a
+      - items:
+          - enum:
+              - mediatek,mt8195-gmac
+          - const: snps,dwmac-5.10a
 
   mediatek,pericfg:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -61,6 +106,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
+      or will round down. Range 0~31*290.
 
   mediatek,rx-delay-ps:
     description:
@@ -69,6 +116,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
+      of 290, or will round down. Range 0~31*290.
 
   mediatek,rmii-rxc:
     type: boolean
@@ -102,6 +151,12 @@ properties:
       3. the inside clock, which be sent to MAC, will be inversed in RMII case when
          the reference clock is from MAC.
 
+  mediatek,mac-wol:
+    type: boolean
+    description:
+      If present, indicates that MAC supports WOL(Wake-On-LAN), and MAC WOL will be enabled.
+      Otherwise, PHY WOL is perferred.
+
 required:
   - compatible
   - reg
-- 
2.25.1

