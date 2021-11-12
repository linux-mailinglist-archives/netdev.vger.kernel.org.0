Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0544E408
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 10:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhKLJmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 04:42:37 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45286 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234833AbhKLJm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 04:42:29 -0500
X-UUID: 545a94a53af74a1290237e60eb662820-20211112
X-UUID: 545a94a53af74a1290237e60eb662820-20211112
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 584415706; Fri, 12 Nov 2021 17:39:36 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 12 Nov 2021 17:39:35 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Nov 2021 17:39:34 +0800
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
Subject: [PATCH v3 7/7] net-next: dt-bindings: dwmac: add support for mt8195
Date:   Fri, 12 Nov 2021 17:39:18 +0800
Message-ID: <20211112093918.11061-8-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211112093918.11061-1-biao.huang@mediatek.com>
References: <20211112093918.11061-1-biao.huang@mediatek.com>
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
index 2eb4781536f7..b27566ed01c6 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -19,12 +19,68 @@ select:
       contains:
         enum:
           - mediatek,mt2712-gmac
+          - mediatek,mt8195-gmac
   required:
     - compatible
 
 allOf:
   - $ref: "snps,dwmac.yaml#"
   - $ref: "ethernet-controller.yaml#"
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
@@ -33,22 +89,10 @@ properties:
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
@@ -63,6 +107,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
+      or will round down. Range 0~31*290.
 
   mediatek,rx-delay-ps:
     description:
@@ -71,6 +117,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
+      of 290, or will round down. Range 0~31*290.
 
   mediatek,rmii-rxc:
     type: boolean
@@ -104,6 +152,12 @@ properties:
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

