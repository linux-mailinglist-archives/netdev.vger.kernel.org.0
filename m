Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411F65BA1D7
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIOUgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIOUgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:36:49 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF2861713
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OssH6Hkxx6nSIIT4hXHzHCyFBTTfl8jHE9xItan9S9M=; b=wlx1QnMHKXOLcK3fvkEXpxUDGQ
        j4dAojzBP9bQHr8jg26fV2RBBWAGQIKCAMnvo1LF04HH6/yUCO4JXgz7OTIctT2KW/i1M2d8tDXZU
        jih2gTcCrzL8fZaSeJjjCqGicxzvCUUK2kZJvP8YIe6aE9AEnBbp8r5BA+nObNl94wFY=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oYvbI-00086K-UM; Thu, 15 Sep 2022 22:36:45 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 2/7] dt-bindings: net: tsnep: Allow additional interrupts
Date:   Thu, 15 Sep 2022 22:36:32 +0200
Message-Id: <20220915203638.42917-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220915203638.42917-1-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
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
 .../bindings/net/engleder,tsnep.yaml          | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index 37e08ee744a8..ce1f1bd413c2 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -20,7 +20,23 @@ properties:
     maxItems: 1
 
   interrupts:
-    maxItems: 1
+    minItems: 1
+    maxItems: 8
+
+  interrupt-names:
+    minItems: 1
+    maxItems: 8
+    items:
+      pattern: '^mac|txrx-[1-7]$'
+    description:
+      If more than one interrupt is available, then interrupts are
+      identified by their names.
+      "mac" is the main interrupt for basic MAC features and the first
+      TX/RX queue pair. If only a single interrupt is available, then
+      it is assumed that this interrupt is the "mac" interrupt.
+      "txrx-[1-7]" are the interrupts for additional TX/RX queue pairs.
+      These interrupt names shall start with index 1 and increment the
+      index by 1 with every further TX/RX queue pair.
 
   dma-coherent: true
 
@@ -78,4 +94,23 @@ examples:
                 };
             };
         };
+        tnsep1: ethernet@a0010000 {
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

