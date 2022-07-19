Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F84157A969
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 23:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiGSVvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 17:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiGSVvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 17:51:09 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5145C37D;
        Tue, 19 Jul 2022 14:51:08 -0700 (PDT)
Received: by mail-io1-f48.google.com with SMTP id y2so12941508ior.12;
        Tue, 19 Jul 2022 14:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I8c2TFEN+S/0gvT4p6LXKR0gvKXF+DViHab2/NYh2mU=;
        b=Igxe429jjjha5qR/kKPqDWH/56wruFKnzEnR9w6YiqQxLmbuJNrylIWQQ5c2U1X9SB
         XKsVbr+kdyWlZm3feC4yH6fD06QVcPXuACxGC0Wpd/8l3DVKskSesha9ThkOc6Fq7OyK
         jyRc4Xh6qQJYaXBN0YpSfDXinkXvfgqz5W6SXyZfy/N2WsqlHVEvzZQAqNcDNpSKgpLN
         SA0kBy64g61a+Mt/dM8V0uhUO7O5ZO+iJB4OIXulrvoXt5MQVKmUHt03eQwnPJtCCrJm
         mPb2mUHassPi8RkUvmvzWCmUbQBpn/j+QaZEJtz3mITJV7H4+3YVHF5zkLn+ec1xZDBh
         is3Q==
X-Gm-Message-State: AJIora9+soq7o08z6hSwdKhOLdsQbB/0cjpNIvmBUTpC9XcljUdnKdy6
        csbSBP+X2SzyyPYT5goNWg==
X-Google-Smtp-Source: AGRyM1uaIxpWFrSiQqMgE6pamK4CCrWyA40fkLr6Me73ZMW7txiNJRGKx3WrtcZIuAsgOj0G0QjfmQ==
X-Received: by 2002:a05:6638:238a:b0:341:55ac:193b with SMTP id q10-20020a056638238a00b0034155ac193bmr10876991jat.208.1658267467478;
        Tue, 19 Jul 2022 14:51:07 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id a13-20020a92d58d000000b002dc616d93acsm6171367iln.28.2022.07.19.14.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 14:51:07 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: ethernet-controller: Rework 'fixed-link' schema
Date:   Tue, 19 Jul 2022 15:50:59 -0600
Message-Id: <20220719215100.1876577-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the if/then schemas mostly work, there's a few issues. The 'allOf'
schema will also be true if 'fixed-link' is not an array or object as a
false 'if' schema (without an 'else') will be true. In the array case
doesn't set the type (uint32-array) in the 'then' clause. In the node case,
'additionalProperties' is missing.

Rework the schema to use oneOf with each possible type.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/ethernet-controller.yaml     | 123 +++++++++---------
 1 file changed, 59 insertions(+), 64 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4f15463611f8..170cd201adc2 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -167,70 +167,65 @@ properties:
       - in-band-status
 
   fixed-link:
-    allOf:
-      - if:
-          type: array
-        then:
-          deprecated: true
-          items:
-            - minimum: 0
-              maximum: 31
-              description:
-                Emulated PHY ID, choose any but unique to the all
-                specified fixed-links
-
-            - enum: [0, 1]
-              description:
-                Duplex configuration. 0 for half duplex or 1 for
-                full duplex
-
-            - enum: [10, 100, 1000, 2500, 10000]
-              description:
-                Link speed in Mbits/sec.
-
-            - enum: [0, 1]
-              description:
-                Pause configuration. 0 for no pause, 1 for pause
-
-            - enum: [0, 1]
-              description:
-                Asymmetric pause configuration. 0 for no asymmetric
-                pause, 1 for asymmetric pause
-
-
-      - if:
-          type: object
-        then:
-          properties:
-            speed:
-              description:
-                Link speed.
-              $ref: /schemas/types.yaml#/definitions/uint32
-              enum: [10, 100, 1000, 2500, 10000]
-
-            full-duplex:
-              $ref: /schemas/types.yaml#/definitions/flag
-              description:
-                Indicates that full-duplex is used. When absent, half
-                duplex is assumed.
-
-            pause:
-              $ref: /schemas/types.yaml#definitions/flag
-              description:
-                Indicates that pause should be enabled.
-
-            asym-pause:
-              $ref: /schemas/types.yaml#/definitions/flag
-              description:
-                Indicates that asym_pause should be enabled.
-
-            link-gpios:
-              maxItems: 1
-              description:
-                GPIO to determine if the link is up
-
-          required:
-            - speed
+    oneOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32-array
+        deprecated: true
+        items:
+          - minimum: 0
+            maximum: 31
+            description:
+              Emulated PHY ID, choose any but unique to the all
+              specified fixed-links
+
+          - enum: [0, 1]
+            description:
+              Duplex configuration. 0 for half duplex or 1 for
+              full duplex
+
+          - enum: [10, 100, 1000, 2500, 10000]
+            description:
+              Link speed in Mbits/sec.
+
+          - enum: [0, 1]
+            description:
+              Pause configuration. 0 for no pause, 1 for pause
+
+          - enum: [0, 1]
+            description:
+              Asymmetric pause configuration. 0 for no asymmetric
+              pause, 1 for asymmetric pause
+      - type: object
+        additionalProperties: false
+        properties:
+          speed:
+            description:
+              Link speed.
+            $ref: /schemas/types.yaml#/definitions/uint32
+            enum: [10, 100, 1000, 2500, 10000]
+
+          full-duplex:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              Indicates that full-duplex is used. When absent, half
+              duplex is assumed.
+
+          pause:
+            $ref: /schemas/types.yaml#definitions/flag
+            description:
+              Indicates that pause should be enabled.
+
+          asym-pause:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              Indicates that asym_pause should be enabled.
+
+          link-gpios:
+            maxItems: 1
+            description:
+              GPIO to determine if the link is up
+
+        required:
+          - speed
 
 additionalProperties: true
 
-- 
2.34.1

