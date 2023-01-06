Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABB865F9D2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjAFDAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAFDAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:00:12 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62CB65AFC;
        Thu,  5 Jan 2023 19:00:07 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 9130B24E1D3;
        Fri,  6 Jan 2023 11:00:05 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 6 Jan
 2023 11:00:05 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 6 Jan 2023 11:00:04 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v3 2/7] dt-bindings: net: snps,dwmac: Update the maxitems number of resets and reset-names
Date:   Fri, 6 Jan 2023 10:59:56 +0800
Message-ID: <20230106030001.1952-3-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some boards(such as StarFive VisionFive v2) require more than one value
which defined by resets property, so the original definition can not
meet the requirements. In order to adapt to different requirements,
adjust the maxitems number definition.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 36 ++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e26c3e76ebb7..f7693e8c8d6d 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -132,14 +132,6 @@ properties:
         - pclk
         - ptp_ref
 
-  resets:
-    maxItems: 1
-    description:
-      MAC Reset signal.
-
-  reset-names:
-    const: stmmaceth
-
   power-domains:
     maxItems: 1
 
@@ -463,6 +455,34 @@ allOf:
             Enables the TSO feature otherwise it will be managed by
             MAC HW capability register.
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: starfive,jh7110-dwmac
+
+    then:
+      properties:
+        resets:
+          minItems: 2
+          maxItems: 2
+        reset-names:
+          items:
+            - const: stmmaceth
+            - const: ahb
+      required:
+        - resets
+        - reset-names
+    else:
+      properties:
+        resets:
+          maxItems: 1
+          description:
+            MAC Reset signal.
+
+        reset-names:
+          const: stmmaceth
+
 additionalProperties: true
 
 examples:
-- 
2.17.1

