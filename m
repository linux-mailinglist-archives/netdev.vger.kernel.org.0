Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C588E46CD5D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbhLHFvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:51:17 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:55912 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S236334AbhLHFvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:51:10 -0500
X-UUID: dff4018382af4a58a86d2e74ec6a8378-20211208
X-UUID: dff4018382af4a58a86d2e74ec6a8378-20211208
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 62367869; Wed, 08 Dec 2021 13:47:35 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 8 Dec 2021 13:47:33 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 8 Dec 2021 13:47:32 +0800
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
Subject: [PATCH net-next v7 6/6] net: dt-bindings: dwmac: add support for mt8195
Date:   Wed, 8 Dec 2021 13:47:16 +0800
Message-ID: <20211208054716.603-7-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208054716.603-1-biao.huang@mediatek.com>
References: <20211208054716.603-1-biao.huang@mediatek.com>
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
 .../bindings/net/mediatek-dwmac.yaml          | 86 +++++++++++++++----
 1 file changed, 70 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
index 9207266a6e69..fb04166404d8 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -19,11 +19,67 @@ select:
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
@@ -32,22 +88,10 @@ properties:
           - enum:
               - mediatek,mt2712-gmac
           - const: snps,dwmac-4.20a
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
+      - items:
+          - enum:
+              - mediatek,mt8195-gmac
+          - const: snps,dwmac-5.10a
 
   mediatek,pericfg:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -62,6 +106,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
+      or will round down. Range 0~31*290.
 
   mediatek,rx-delay-ps:
     description:
@@ -70,6 +116,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
+      of 290, or will round down. Range 0~31*290.
 
   mediatek,rmii-rxc:
     type: boolean
@@ -103,6 +151,12 @@ properties:
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

