Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2056B311E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjCIWkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjCIWjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:39:23 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDDA102853;
        Thu,  9 Mar 2023 14:38:16 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso4760873wmi.4;
        Thu, 09 Mar 2023 14:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=LY12PGb5U36RAyvwk4Ct7zflsozHYkIIlhvHkrKH2nJqMc1/DGhRpL+DhwyM44V+ww
         /gxLhY7o/Mmfcod8SAxZ56oZwzZdMte9cHXeNJUUbPOEv3u5tIfk5hz1dnOUgWv+bZ/1
         b+bebnttbuJXDFVwlTCZ9SReSjjc6Pn8cFCPBdAtHvZvX089U7xuIVxybi76pvJdIlHQ
         7w8ldSpPJqyiEGfaQEZ+HVN6uegxguD+uII7ppHbWZMYC3rCbjr/HsOEUr4RV548SaoR
         0FYIodjRM1LKZ0jqO9wT/XxZtJVVRnv/F1zsxgSN3S2Sj+6YuXysyf7xe+2aCSBOxBwc
         w6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=p8AoyjJjnesfazuBszubweOhzspMrwYYn3Dl2dB6rqsdxeJETKLAHeXO2RJs+/PTjH
         SmFgmdMlsmAY5N1/nsfIlKy/4WP8RdY6D2qm8hRUcDK/fJyB/iayjfMOJSe85Wk76yiE
         hbgc/V/hJrrL8VIgNbBvZGDre8hBMUBjcoktGXYqXW4Jz8m6LhpJflHGXmGwT+v2+A2a
         6xaCAxAf5E/0RvfahPslSfTLngb2Jb0WEp/y25IeTFEJKW45dyrt7RJ1JPUnKcH/DMX4
         u45LACWIk/Qw4evNlo39aBPgfWzyAPAA8IsXSWCXnBwY/wKD9TJjTTNdXDlkQI9AFMx7
         t+3w==
X-Gm-Message-State: AO0yUKXuWLlfNwv4AEia1ZE9KVeu4VcASs3ygx3OwHaC2iOxNqLWUadF
        WzlCweyhug4XO6l9j0+S7Y4=
X-Google-Smtp-Source: AK7set+2vOeNQz9KeLlNl7u5v25/ZpT4RBWDkuAWaG0mXnir/bYVDydsGHDBeUQlRnwL6szv3lP6Tw==
X-Received: by 2002:a05:600c:35cd:b0:3e9:f4c2:b604 with SMTP id r13-20020a05600c35cd00b003e9f4c2b604mr702682wmq.24.1678401495464;
        Thu, 09 Mar 2023 14:38:15 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:38:15 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v2 13/14] dt-bindings: net: phy: Document support for LEDs node
Date:   Thu,  9 Mar 2023 23:35:23 +0100
Message-Id: <20230309223524.23364-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309223524.23364-1-ansuelsmth@gmail.com>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for LEDs node in phy and add an example for it.
PHY LED will have to match led pattern and should be treated as a
generic led.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 1327b81f15a2..84e15cee27c7 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -197,6 +197,22 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  leds:
+    type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      '^led(@[a-f0-9]+)?$':
+        $ref: /schemas/leds/common.yaml#
+
+    additionalProperties: false
+
 required:
   - reg
 
@@ -204,6 +220,8 @@ additionalProperties: true
 
 examples:
   - |
+    #include <dt-bindings/leds/common.h>
+
     ethernet {
         #address-cells = <1>;
         #size-cells = <0>;
@@ -219,5 +237,18 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+
+            leds {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                led@0 {
+                    reg = <0>;
+                    color = <LED_COLOR_ID_WHITE>;
+                    function = LED_FUNCTION_LAN;
+                    function-enumerator = <1>;
+                    default-state = "keep";
+                };
+            };
         };
     };
-- 
2.39.2

