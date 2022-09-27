Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4E5ECD79
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiI0T7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiI0T6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:55 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD651D139F;
        Tue, 27 Sep 2022 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tE4KkoUEqQIwIWrba62zX4wPMgJux+t/M00hmzIx2Gk=; b=RLX91GF2S391r8MFbBlTT8H/o7
        AIqvWlQrw0I9M5biPTpfpfAkerqdBgFpENQyYke6DPHj4l10yw5XEozSBB8aW/eBMgmpyRiUQUvjU
        AMhIs1qJWKtS+ddLaG68UjX5XR3hOKjDio+XED+bJ9I23LvjSVWGmnBKFa3uFdwnEQNk=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGj8-0005u7-Qs; Tue, 27 Sep 2022 21:58:46 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 2/6] dt-bindings: net: tsnep: Allow additional interrupts
Date:   Tue, 27 Sep 2022 21:58:38 +0200
Message-Id: <20220927195842.44641-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927195842.44641-1-gerhard@engleder-embedded.com>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Additional TX/RX queue pairs require dedicated interrupts. Extend
binding with additional interrupts.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 .../bindings/net/engleder,tsnep.yaml          | 41 ++++++++++++++++++-
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index 37e08ee744a8..5bd964a46a9d 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -20,7 +20,24 @@ properties:
     maxItems: 1
 
   interrupts:
-    maxItems: 1
+    minItems: 1
+    maxItems: 8
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: mac
+      - const: txrx-1
+      - const: txrx-2
+      - const: txrx-3
+      - const: txrx-4
+      - const: txrx-5
+      - const: txrx-6
+      - const: txrx-7
+    description:
+      The main interrupt for basic MAC features and the first TX/RX queue pair
+      is named "mac". "txrx-[1-7]" are the interrupts for additional TX/RX
+      queue pairs.
 
   dma-coherent: true
 
@@ -60,7 +77,7 @@ examples:
     axi {
         #address-cells = <2>;
         #size-cells = <2>;
-        tnsep0: ethernet@a0000000 {
+        tsnep0: ethernet@a0000000 {
             compatible = "engleder,tsnep";
             reg = <0x0 0xa0000000 0x0 0x10000>;
             interrupts = <0 89 1>;
@@ -78,4 +95,24 @@ examples:
                 };
             };
         };
+
+        tsnep1: ethernet@a0010000 {
+            compatible = "engleder,tsnep";
+            reg = <0x0 0xa0010000 0x0 0x10000>;
+            interrupts = <0 93 1>, <0 94 1>, <0 95 1>, <0 96 1>;
+            interrupt-names = "mac", "txrx-1", "txrx-2", "txrx-3";
+            interrupt-parent = <&gic>;
+            local-mac-address = [00 00 00 00 00 00];
+            phy-mode = "rgmii";
+            phy-handle = <&phy1>;
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                suppress-preamble;
+                phy1: ethernet-phy@1 {
+                    reg = <1>;
+                    rxc-skew-ps = <1080>;
+                };
+            };
+        };
     };
-- 
2.30.2

