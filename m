Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8244750E4
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 03:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239144AbhLOCRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 21:17:12 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56252 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S239210AbhLOCRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 21:17:07 -0500
X-UUID: 9ffd97b65ba94c309ba3bb81a80fe5d6-20211215
X-UUID: 9ffd97b65ba94c309ba3bb81a80fe5d6-20211215
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2102345648; Wed, 15 Dec 2021 10:17:01 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 15 Dec 2021 10:17:00 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 15 Dec 2021 10:16:58 +0800
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
Subject: [PATCH net-next v9 6/6] net: dt-bindings: dwmac: add support for mt8195
Date:   Wed, 15 Dec 2021 10:16:52 +0800
Message-ID: <20211215021652.7270-7-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211215021652.7270-1-biao.huang@mediatek.com>
References: <20211215021652.7270-1-biao.huang@mediatek.com>
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
 .../bindings/net/mediatek-dwmac.yaml          | 42 ++++++++++++++-----
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
index 8ad6e19661b8..44d55146def4 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -19,6 +19,7 @@ select:
       contains:
         enum:
           - mediatek,mt2712-gmac
+          - mediatek,mt8195-gmac
   required:
     - compatible
 
@@ -27,26 +28,37 @@ allOf:
 
 properties:
   compatible:
-    items:
-      - enum:
-          - mediatek,mt2712-gmac
-      - const: snps,dwmac-4.20a
+    oneOf:
+      - items:
+          - enum:
+              - mediatek,mt2712-gmac
+          - const: snps,dwmac-4.20a
+      - items:
+          - enum:
+              - mediatek,mt8195-gmac
+          - const: snps,dwmac-5.10a
 
   clocks:
+    minItems: 5
     items:
       - description: AXI clock
       - description: APB clock
       - description: MAC Main clock
       - description: PTP clock
       - description: RMII reference clock provided by MAC
+      - description: MAC clock gate
 
   clock-names:
-    items:
-      - const: axi
-      - const: apb
-      - const: mac_main
-      - const: ptp_ref
-      - const: rmii_internal
+    minItems: 5
+    maxItems: 6
+    contains:
+      enum:
+        - axi
+        - apb
+        - mac_main
+        - ptp_ref
+        - rmii_internal
+        - mac_cg
 
   mediatek,pericfg:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -61,6 +73,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
+      or will round down. Range 0~31*290.
 
   mediatek,rx-delay-ps:
     description:
@@ -69,6 +83,8 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
+      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
+      of 290, or will round down. Range 0~31*290.
 
   mediatek,rmii-rxc:
     type: boolean
@@ -102,6 +118,12 @@ properties:
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

