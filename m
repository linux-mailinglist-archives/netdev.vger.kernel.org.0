Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466D36B3129
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjCIWjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCIWi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:38:56 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D24C5D880;
        Thu,  9 Mar 2023 14:38:11 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso2248645wms.5;
        Thu, 09 Mar 2023 14:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WgoBUd5mOfOzbUIgE9ennXfu8Bk6ZG8n46SEtwJM8yA=;
        b=H+NsYENR+8EzbAxFKg+zIE/cBeVSmrDAAzXByhMLc8G2et1gp51FNU0M66oY4Rb+0c
         f7TB14Z6bW/0FhzqUOlPJnDoSBcGUOgIdolmunAjYFtmcQ1MlFfIqxIf3avdkA7IbRJZ
         Llzz+Se3pMWOF+i24TcNidZ4QBnJc25hrrBbrkfHKjRnh1aexUealsE/XtsmfGoBeX1q
         /bEoWAt0z1cHWdD5GUNojHoR2OG4P+byRrLt+FfPMKg9sV+xIgcPqmRQINdhT4Os3KeC
         XazOQ0Mvfaljp/ahmfO7IeN4mA15gpqKEcjqG7hb6vGm7bCOKeQib1FD3RIsbbeDLb7V
         ZTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WgoBUd5mOfOzbUIgE9ennXfu8Bk6ZG8n46SEtwJM8yA=;
        b=wUYzShfb9FWa0kfH7Vr9tCB4vRwA8naHzA9QR9CISqn0NHilKKaKctGkbnkb2JC2yG
         f0z0MTXl/6ldyCEGkWOVHY84IYgrfV7szo2BIvZcc8Wfx6Fc0pZgjiBuDDyuFq81rc8a
         mLt0IFaOAVldEbN0CvhpU26yMQwO2BO2UK/vBzYGr7pnzoim7EWx5loW4QpuXLYpqx65
         Sbeba5CyXGkyS965d7kcdjVDa806LmsPltWi9gBwAAiaXeGGJ42QX5MpeJj2kxz98gBH
         cod6vWaMwMAH3A9S1MbsypWJhCKVqXFYjsFRLXlw5nEpX7XPOXJKdxSDsxSgVy0rLEML
         +prQ==
X-Gm-Message-State: AO0yUKX0xAdRvo+S6YQZIRnNse0i9dUnonl1Ol0JG7rQFxBj0XtmwFHQ
        75qakF4SFOi0VWYU2JkLWbU=
X-Google-Smtp-Source: AK7set/xkJYrlukP7VDZms/s2HBBUZPEGkDWRfMfDWH8VQaTTTwHp82KiOOoKZQUXJb+Z/YqGSPV4Q==
X-Received: by 2002:a1c:e913:0:b0:3eb:3912:5ae9 with SMTP id q19-20020a1ce913000000b003eb39125ae9mr689396wmc.24.1678401489517;
        Thu, 09 Mar 2023 14:38:09 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:38:09 -0800 (PST)
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
Subject: [net-next PATCH v2 09/14] dt-bindings: net: dsa: dsa-port: Document support for LEDs node
Date:   Thu,  9 Mar 2023 23:35:19 +0100
Message-Id: <20230309223524.23364-10-ansuelsmth@gmail.com>
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

Document support for LEDs node in dsa port.
Switch may support different LEDs that can be configured for different
operation like blinking on traffic event or port link.

Also add some Documentation to describe the difference of these nodes
compared to PHY LEDs, since dsa-port LEDs are controllable by the switch
regs and the possible intergated PHY doesn't have control on them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 480120469953..1bf4151e5155 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -59,6 +59,27 @@ properties:
       - rtl8_4t
       - seville
 
+  leds:
+    type: object
+    description:
+      Describes the LEDs associated by the Switch Port and controllable
+      in its MACs. These LEDs are not integrated in the PHY and PHY
+      doesn't have any control on them. Switch regs are used to control
+      these Switch Port LEDs.
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
 # CPU and DSA ports must have phylink-compatible link descriptions
 if:
   oneOf:
-- 
2.39.2

