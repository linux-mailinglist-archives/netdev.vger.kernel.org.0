Return-Path: <netdev+bounces-2424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AAF6701D2C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 13:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B5C281207
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 11:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5A54C95;
	Sun, 14 May 2023 11:58:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2B44C8C
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 11:58:23 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B881A1FC2
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 04:58:21 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50db91640d3so9746208a12.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 04:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684065499; x=1686657499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ueNUY+61RC+vr33b4+u6+BrfZ3BJJhhclw2Re6JpY94=;
        b=HL2l6tFwqcvaksx52yisq7RR0TRrXrwkOo8dOwyznXSYvgZPyuKE52NZ2FSkxurUoY
         H9hFJg0E1CxzU5GMJwPE8BJUge2Rf5sz5GK6VG+k9+cKf4Ool8T46BE6P3fq+TaJNakx
         WoyuSJNfRYecVKgg3LCS5/s32OI+xHx5rlbz9TFAhrW80O8mHPNcJsSMNpbnq/WDSHPo
         IAX5J1ZmsRFHQOEtp8kFZpMpnYuls63XJsesPTcv4zaH+byEB8O3qpiIqFyiyXsx+M5U
         W6Ph4TKH5qALtwZnjls6KlAQo+dOC/RoOr8NlN8IlZd3KL88uclJN709RtZMOZqxFf3r
         f3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684065499; x=1686657499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ueNUY+61RC+vr33b4+u6+BrfZ3BJJhhclw2Re6JpY94=;
        b=CMS+zK5sVq4vt/jfpuDMiNL9EIfUC3nZchFBIl0zATJQzmhTJNqzdrWM4cH5/syoY8
         KCldQwKJ/wrAxoxTvh4yh6nCQgZvW81ijhJT7k02MsQUvZA2T+iZRtqG6/lFTia8lc2C
         2K4ttoSWC8/bc9+SdcT6g1kv1u47hzEd6UcltnstlezENUA02DMVz4dDTVvp45Mky3Wc
         BJXnLqqVUu5+C3jrvwkrDAhhVxNAzNVv5CMQbMuoGUHlPHUPc3//kvOFp+lgYFO0X60y
         gUwnCjMJRYCyEHT94RW1vbn99ufYul/riPblZ8NPkBSbAVt3IMQpKg0PN7hEplMLUqo7
         GGAA==
X-Gm-Message-State: AC+VfDzv61pktuQ3ZDimRWhSA+fyQ5Vq9GD7h8DirJOdS74z9MNX0os/
	JzZGRy1ELcu6zTC+IfJ6pedBQw==
X-Google-Smtp-Source: ACHHUZ7xsDrMn8wajAMkmg1yh4SBoBjpfcp8VcuzhBb/J3uNhg9BgkGqNoFX7nma8bpIZP3t7rtMsA==
X-Received: by 2002:a17:907:928e:b0:96a:8412:a43d with SMTP id bw14-20020a170907928e00b0096a8412a43dmr8603542ejc.33.1684065498811;
        Sun, 14 May 2023 04:58:18 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:715f:ddce:f2ba:123b])
        by smtp.gmail.com with ESMTPSA id i24-20020a1709067a5800b00965aee5be9asm8223005ejo.170.2023.05.14.04.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 04:58:18 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v4] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Date: Sun, 14 May 2023 13:57:41 +0200
Message-Id: <20230514115741.40423-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:

  arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v3:
1. Rebase.
2. Require cpha/cpol properties on respective variants (thus update
   example).

Changes since v2:
1. Add allOf:if:then, based on feedback from Vladimir.

Changes since v1:
1. Add also cpha.
---
 .../bindings/net/dsa/nxp,sja1105.yaml         | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 9a64ed658745..991448962c93 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -12,10 +12,6 @@ description:
   cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
   depends on the SPI bus master driver.
 
-allOf:
-  - $ref: dsa.yaml#/$defs/ethernet-ports
-  - $ref: /schemas/spi/spi-peripheral-props.yaml#
-
 maintainers:
   - Vladimir Oltean <vladimir.oltean@nxp.com>
 
@@ -36,6 +32,9 @@ properties:
   reg:
     maxItems: 1
 
+  spi-cpha: true
+  spi-cpol: true
+
   # Optional container node for the 2 internal MDIO buses of the SJA1110
   # (one for the internal 100base-T1 PHYs and the other for the single
   # 100base-TX PHY). The "reg" property does not have physical significance.
@@ -109,6 +108,30 @@ $defs:
        1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020, 2040, 2060, 2080,
        2100, 2120, 2140, 2160, 2180, 2200, 2220, 2240, 2260]
 
+allOf:
+  - $ref: dsa.yaml#/$defs/ethernet-ports
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+  - if:
+      properties:
+        compatible:
+          enum:
+            - nxp,sja1105e
+            - nxp,sja1105t
+            - nxp,sja1105p
+            - nxp,sja1105q
+            - nxp,sja1105r
+            - nxp,sja1105s
+    then:
+      properties:
+        spi-cpol: false
+      required:
+        - spi-cpha
+    else:
+      properties:
+        spi-cpha: false
+      required:
+        - spi-cpol
+
 unevaluatedProperties: false
 
 examples:
@@ -120,6 +143,7 @@ examples:
             ethernet-switch@1 {
                     reg = <0x1>;
                     compatible = "nxp,sja1105t";
+                    spi-cpha;
 
                     ethernet-ports {
                             #address-cells = <1>;
-- 
2.34.1


