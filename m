Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBB76DE551
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDKUGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDKUF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7FD4C21
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681243484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q3NnvVuLlL0DF9zj913pLjOYbeCyB2YctaCAm9deSc0=;
        b=TWcEJNJXMqH6VX0L6j/mjxixFxJ4dk6QD83pvboxoPhTqPRuOn/nuoiDQ7wefi/sQxD8AR
        pi1d369q82WXxpSTakr1JoozwBiEWgTEZIGg12JIrcJLvI4W1lICJfUImpn7UuBU4tOC6m
        cgCCQhOOx2uwFmkGnz3AHtSm3jylfFg=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-m-JNHLEtPFW6bkLM-BaH0A-1; Tue, 11 Apr 2023 16:04:43 -0400
X-MC-Unique: m-JNHLEtPFW6bkLM-BaH0A-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1840d4e9758so6701418fac.11
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3NnvVuLlL0DF9zj913pLjOYbeCyB2YctaCAm9deSc0=;
        b=OLkoxjs7WNX9HJ5wECU7TnkfQPZrzPDvmMaLR6esEjQRYOTIN6Gbikr9PxoTUkhTBI
         eL4rdlI3JvnNjTcVY2EAVVqKVuozax1K8Ut8sRlqiTn3dSM+e16Uf053q+8xBEqYyP9Q
         Ejvf4Kb0pxHpif4e+lBfqXnug1cgYFpUbxon3WSwzLGUoVbYgIg1vNl1VIY2leLeA5WX
         xOdqVH9zI1Tuc24d+NQ8L7bFGYspfylx1F7Qz/pBmM46ONIL9Gp8py+24xdO/6DHa6bY
         BQDVjx9Ufglp9WpyxN5T6/qXaytIZdjUSPhuHefwemazIQR+EatvN3WqOLuN3MFaiHPZ
         /BSw==
X-Gm-Message-State: AAQBX9efMZzbyzpEDZF0cKBjQbyxwWB/3wn3M1s3L71vpORh0gfOxSLT
        Hx7TkkLtozymozO5IbkpJsGgjL2Z8Fne9voqcvc3vH7LMvjaBORu6gRs99yYSGK3O2DI32fSL9o
        QWs0f4yyf6WUammdJ
X-Received: by 2002:a05:6870:4686:b0:17e:13e9:1e4a with SMTP id a6-20020a056870468600b0017e13e91e4amr2694419oap.17.1681243482494;
        Tue, 11 Apr 2023 13:04:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350aqs3TvzPHoWLog8KEU5yBrOpPGXVg7bre6Q6dsImqUB42LBUNfxcnWlWDkNolu+XbapjSJOQ==
X-Received: by 2002:a05:6870:4686:b0:17e:13e9:1e4a with SMTP id a6-20020a056870468600b0017e13e91e4amr2694402oap.17.1681243482242;
        Tue, 11 Apr 2023 13:04:42 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id e20-20020a056808149400b00387764759a3sm5868545oiw.24.2023.04.11.13.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:04:41 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v4 03/12] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
Date:   Tue, 11 Apr 2023 15:04:00 -0500
Message-Id: <20230411200409.455355-4-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.
In doing so add a new property for iommus since newer platforms support
using one, and without such make dtbs_check fails on them.

While at it, also update the MAINTAINERS file to point to the yaml
version of the bindings.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[halaney: Remove duplicated properties, add MAINTAINERS and iommus]
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v3:
    * None

Changes since v2:
    * Add Krzysztof's Reviewed-by tag

Changes since v1:
    * Drop redundant wording in binding description (Krzysztof)
    * Document iommus addition explicitly in commit message (Krzysztof)

 .../devicetree/bindings/net/qcom,ethqos.txt   |  66 -----------
 .../devicetree/bindings/net/qcom,ethqos.yaml  | 110 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 111 insertions(+), 67 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.txt b/Documentation/devicetree/bindings/net/qcom,ethqos.txt
deleted file mode 100644
index 1f5746849a71..000000000000
--- a/Documentation/devicetree/bindings/net/qcom,ethqos.txt
+++ /dev/null
@@ -1,66 +0,0 @@
-Qualcomm Ethernet ETHQOS device
-
-This documents dwmmac based ethernet device which supports Gigabit
-ethernet for version v2.3.0 onwards.
-
-This device has following properties:
-
-Required properties:
-
-- compatible: Should be one of:
-		"qcom,qcs404-ethqos"
-		"qcom,sm8150-ethqos"
-
-- reg: Address and length of the register set for the device
-
-- reg-names: Should contain register names "stmmaceth", "rgmii"
-
-- clocks: Should contain phandle to clocks
-
-- clock-names: Should contain clock names "stmmaceth", "pclk",
-		"ptp_ref", "rgmii"
-
-- interrupts: Should contain phandle to interrupts
-
-- interrupt-names: Should contain interrupt names "macirq", "eth_lpi"
-
-Rest of the properties are defined in stmmac.txt file in same directory
-
-
-Example:
-
-ethernet: ethernet@7a80000 {
-	compatible = "qcom,qcs404-ethqos";
-	reg = <0x07a80000 0x10000>,
-		<0x07a96000 0x100>;
-	reg-names = "stmmaceth", "rgmii";
-	clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
-	clocks = <&gcc GCC_ETH_AXI_CLK>,
-		<&gcc GCC_ETH_SLAVE_AHB_CLK>,
-		<&gcc GCC_ETH_PTP_CLK>,
-		<&gcc GCC_ETH_RGMII_CLK>;
-	interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
-			<GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq", "eth_lpi";
-	snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
-	snps,reset-active-low;
-
-	snps,txpbl = <8>;
-	snps,rxpbl = <2>;
-	snps,aal;
-	snps,tso;
-
-	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
-
-	mdio {
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		compatible = "snps,dwmac-mdio";
-		phy1: phy@4 {
-			device_type = "ethernet-phy";
-			reg = <0x4>;
-		};
-	};
-
-};
diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
new file mode 100644
index 000000000000..88234a2010b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
@@ -0,0 +1,110 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ethqos.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Ethernet ETHQOS device
+
+maintainers:
+  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
+
+description:
+  dwmmac based Qualcomm ethernet devices which support Gigabit
+  ethernet (version v2.3.0 and onwards).
+
+allOf:
+  - $ref: snps,dwmac.yaml#
+
+properties:
+  compatible:
+    enum:
+      - qcom,qcs404-ethqos
+      - qcom,sm8150-ethqos
+
+  reg:
+    maxItems: 2
+
+  reg-names:
+    items:
+      - const: stmmaceth
+      - const: rgmii
+
+  interrupts:
+    items:
+      - description: Combined signal for various interrupt events
+      - description: The interrupt that occurs when Rx exits the LPI state
+
+  interrupt-names:
+    items:
+      - const: macirq
+      - const: eth_lpi
+
+  clocks:
+    maxItems: 4
+
+  clock-names:
+    items:
+      - const: stmmaceth
+      - const: pclk
+      - const: ptp_ref
+      - const: rgmii
+
+  iommus:
+    maxItems: 1
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+  - reg-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/qcom,gcc-qcs404.h>
+    #include <dt-bindings/gpio/gpio.h>
+
+    ethernet: ethernet@7a80000 {
+      compatible = "qcom,qcs404-ethqos";
+      reg = <0x07a80000 0x10000>,
+            <0x07a96000 0x100>;
+      reg-names = "stmmaceth", "rgmii";
+      clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
+      clocks = <&gcc GCC_ETH_AXI_CLK>,
+               <&gcc GCC_ETH_SLAVE_AHB_CLK>,
+               <&gcc GCC_ETH_PTP_CLK>,
+               <&gcc GCC_ETH_RGMII_CLK>;
+      interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+                   <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "macirq", "eth_lpi";
+
+      rx-fifo-depth = <4096>;
+      tx-fifo-depth = <4096>;
+
+      snps,tso;
+      snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
+      snps,reset-active-low;
+      snps,reset-delays-us = <0 10000 10000>;
+
+      pinctrl-names = "default";
+      pinctrl-0 = <&ethernet_defaults>;
+
+      phy-handle = <&phy1>;
+      phy-mode = "rgmii";
+      mdio {
+        #address-cells = <0x1>;
+        #size-cells = <0x0>;
+
+        compatible = "snps,dwmac-mdio";
+        phy1: phy@4 {
+          compatible = "ethernet-phy-ieee802.3-c22";
+          device_type = "ethernet-phy";
+          reg = <0x4>;
+
+          #phy-cells = <0>;
+        };
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 0b19a3fb266c..fdcef63fa9a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17304,7 +17304,7 @@ M:	Vinod Koul <vkoul@kernel.org>
 R:	Bhupesh Sharma <bhupesh.sharma@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/qcom,ethqos.txt
+F:	Documentation/devicetree/bindings/net/qcom,ethqos.yaml
 F:	drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
 
 QUALCOMM FASTRPC DRIVER
-- 
2.39.2

