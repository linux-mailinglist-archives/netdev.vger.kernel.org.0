Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9126066E657
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbjAQSpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjAQScy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:32:54 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3252D53F96
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:04:42 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r30so7058169wrr.10
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTEzWcyopbvNEIuRFviJ7QrP0DeW/l7YuCAbT31QOnU=;
        b=3DK9RqutnQ+wCIeovUXqgRdh1HV+xqHDGosPl6Qn/rMhmh0h/nWfhvT20jnx35QMim
         7sUWzCOUXrIBhkGctloMEab4DlXL9Sdt2uUdOV+2kOj03T7QBdAr3YvDWsJj43QJ42Ok
         AdCebc9af3DqmvRr++Q9pSBCY7CdFMRqWrvENOFYQ3XgivKeFZmz61V9VjT0jH/yWHer
         w3BsETzPFznJIldipLDyaNysJNl0rYtn8J7QwVGVDDT1mPUIoA7Bir4r7vWxfO4NLE0R
         piHxAmCBj6tdnrhp7A5EWG01koVTD5k+Lk3NyBRu6i9p18j6W5afVZ9MkILMWOQDoQew
         bKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTEzWcyopbvNEIuRFviJ7QrP0DeW/l7YuCAbT31QOnU=;
        b=yU8oMZj/wokBKzrpvoDS0fU7QVG5ucOC4ORllAh/ZqW/Jff6je1Tc9XvTwiQeLBHzI
         ODI8NBc5ATJKLZYVQ4em7/I2ikHHe4UskQewd8CVLy6Z7MAr2SpRYWGu1l5ZVr9pRj/Y
         xy0NzIQWeRslnJ3e8625lMubkxS9lx4B6lewsEq8qQuUr6/wQ38H/MkXffuGYz5740J5
         VEzWEfae9/d5FbLMpWFA5cCW0qjtra2uZJ0qOPnKEc9KaQxncBS9ccvUy4YEmP3Vzeo9
         2F/YfAWFDIKokwzN7o9q2kZPOiwYZsPWt1YIuaXXERzqdmXpXIZoEnfiFo/JmbaYuL5B
         pgdg==
X-Gm-Message-State: AFqh2kr1ybjM4hmxSe3pCg0EJurT86ncCrb5SAHEigKGLzfRmWt40igh
        eUa39yk5m3tvLTRa4ND7AjUfMg==
X-Google-Smtp-Source: AMrXdXv5RGG16bLl1teVn0CW+giHmjid6RJqQZrRvq6LH1LDSvak4Ft5jOnhxqoq0SDhIjvKiVoF/A==
X-Received: by 2002:adf:de81:0:b0:2bd:dc5c:7e4c with SMTP id w1-20020adfde81000000b002bddc5c7e4cmr3461352wrl.15.1673978680695;
        Tue, 17 Jan 2023 10:04:40 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:9236:abcb:4905:a64e])
        by smtp.gmail.com with ESMTPSA id bp28-20020a5d5a9c000000b00273cd321a1bsm29356681wrb.107.2023.01.17.10.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 10:04:40 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v2 1/2] dt-bindings: clock: qcom: document the GCC clock on Qualcomm sa8775p
Date:   Tue, 17 Jan 2023 19:04:28 +0100
Message-Id: <20230117180429.305266-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230117180429.305266-1-brgl@bgdev.pl>
References: <20230117180429.305266-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add DT bindings for the GCC clock on SA8775P platforms. Add relevant
DT include definitions as well.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../bindings/clock/qcom,sa8775p-gcc.yaml      |  79 +++++
 include/dt-bindings/clock/qcom,sa8775p-gcc.h  | 320 ++++++++++++++++++
 2 files changed, 399 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,sa8775p-gcc.yaml
 create mode 100644 include/dt-bindings/clock/qcom,sa8775p-gcc.h

diff --git a/Documentation/devicetree/bindings/clock/qcom,sa8775p-gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sa8775p-gcc.yaml
new file mode 100644
index 000000000000..dae65ebc5557
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/qcom,sa8775p-gcc.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/qcom,sa8775p-gcc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Global Clock & Reset Controller on sa8775p
+
+maintainers:
+  - Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
+
+description: |
+  Qualcomm global clock control module provides the clocks, resets and
+  power domains on sa8775p.
+
+  See also:: include/dt-bindings/clock/qcom,sa8775p-gcc.h
+
+properties:
+  compatible:
+    const: qcom,sa8775p-gcc
+
+  clocks:
+    items:
+      - description: XO reference clock
+      - description: Sleep clock
+      - description: UFS memory first RX symbol clock
+      - description: UFS memory second RX symbol clock
+      - description: UFS memory first TX symbol clock
+      - description: UFS card first RX symbol clock
+      - description: UFS card second RX symbol clock
+      - description: UFS card first TX symbol clock
+      - description: Primary USB3 PHY wrapper pipe clock
+      - description: Secondary USB3 PHY wrapper pipe clock
+      - description: PCIe 0 pipe clock
+      - description: PCIe 1 pipe clock
+      - description: PCIe PHY clock
+      - description: First EMAC controller reference clock
+      - description: Second EMAC controller reference clock
+
+  protected-clocks:
+    maxItems: 240
+
+required:
+  - compatible
+  - clocks
+
+allOf:
+  - $ref: qcom,gcc.yaml#
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,rpmh.h>
+
+    gcc: clock-controller@100000 {
+        compatible = "qcom,sa8775p-gcc";
+        reg = <0x100000 0xc7018>;
+        clocks = <&rpmhcc RPMH_CXO_CLK>,
+                 <&sleep_clk>,
+                 <&ufs_phy_rx_symbol_0_clk>,
+                 <&ufs_phy_rx_symbol_1_clk>,
+                 <&ufs_phy_tx_symbol_0_clk>,
+                 <&ufs_card_rx_symbol_0_clk>,
+                 <&ufs_card_rx_symbol_1_clk>,
+                 <&ufs_card_tx_symbol_0_clk>,
+                 <&usb_0_ssphy>,
+                 <&usb_1_ssphy>,
+                 <&pcie_0_pipe_clk>,
+                 <&pcie_1_pipe_clk>,
+                 <&pcie_phy_pipe_clk>,
+                 <&rxc0_ref_clk>,
+                 <&rxc1_ref_clk>;
+
+        #clock-cells = <1>;
+        #reset-cells = <1>;
+        #power-domain-cells = <1>;
+    };
+...
diff --git a/include/dt-bindings/clock/qcom,sa8775p-gcc.h b/include/dt-bindings/clock/qcom,sa8775p-gcc.h
new file mode 100644
index 000000000000..01f54234963d
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,sa8775p-gcc.h
@@ -0,0 +1,320 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2022, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2023, Linaro Limited
+ */
+
+#ifndef _DT_BINDINGS_CLK_QCOM_GCC_SA8775P_H
+#define _DT_BINDINGS_CLK_QCOM_GCC_SA8775P_H
+
+/* GCC clocks */
+#define GCC_GPLL0					0
+#define GCC_GPLL0_OUT_EVEN				1
+#define GCC_GPLL1					2
+#define GCC_GPLL4					3
+#define GCC_GPLL5					4
+#define GCC_GPLL7					5
+#define GCC_GPLL9					6
+#define GCC_AGGRE_NOC_QUPV3_AXI_CLK			7
+#define GCC_AGGRE_UFS_CARD_AXI_CLK			8
+#define GCC_AGGRE_UFS_PHY_AXI_CLK			9
+#define GCC_AGGRE_USB2_PRIM_AXI_CLK			10
+#define GCC_AGGRE_USB3_PRIM_AXI_CLK			11
+#define GCC_AGGRE_USB3_SEC_AXI_CLK			12
+#define GCC_AHB2PHY0_CLK				13
+#define GCC_AHB2PHY2_CLK				14
+#define GCC_AHB2PHY3_CLK				15
+#define GCC_BOOT_ROM_AHB_CLK				16
+#define GCC_CAMERA_AHB_CLK				17
+#define GCC_CAMERA_HF_AXI_CLK				18
+#define GCC_CAMERA_SF_AXI_CLK				19
+#define GCC_CAMERA_THROTTLE_XO_CLK			20
+#define GCC_CAMERA_XO_CLK				21
+#define GCC_CFG_NOC_USB2_PRIM_AXI_CLK			22
+#define GCC_CFG_NOC_USB3_PRIM_AXI_CLK			23
+#define GCC_CFG_NOC_USB3_SEC_AXI_CLK			24
+#define GCC_DDRSS_GPU_AXI_CLK				25
+#define GCC_DISP1_AHB_CLK				26
+#define GCC_DISP1_HF_AXI_CLK				27
+#define GCC_DISP1_XO_CLK				28
+#define GCC_DISP_AHB_CLK				29
+#define GCC_DISP_HF_AXI_CLK				30
+#define GCC_DISP_XO_CLK					31
+#define GCC_EDP_REF_CLKREF_EN				32
+#define GCC_EMAC0_AXI_CLK				33
+#define GCC_EMAC0_PHY_AUX_CLK				34
+#define GCC_EMAC0_PHY_AUX_CLK_SRC			35
+#define GCC_EMAC0_PTP_CLK				36
+#define GCC_EMAC0_PTP_CLK_SRC				37
+#define GCC_EMAC0_RGMII_CLK				38
+#define GCC_EMAC0_RGMII_CLK_SRC				39
+#define GCC_EMAC0_SLV_AHB_CLK				40
+#define GCC_EMAC1_AXI_CLK				41
+#define GCC_EMAC1_PHY_AUX_CLK				42
+#define GCC_EMAC1_PHY_AUX_CLK_SRC			43
+#define GCC_EMAC1_PTP_CLK				44
+#define GCC_EMAC1_PTP_CLK_SRC				45
+#define GCC_EMAC1_RGMII_CLK				46
+#define GCC_EMAC1_RGMII_CLK_SRC				47
+#define GCC_EMAC1_SLV_AHB_CLK				48
+#define GCC_GP1_CLK					49
+#define GCC_GP1_CLK_SRC					50
+#define GCC_GP2_CLK					51
+#define GCC_GP2_CLK_SRC					52
+#define GCC_GP3_CLK					53
+#define GCC_GP3_CLK_SRC					54
+#define GCC_GP4_CLK					55
+#define GCC_GP4_CLK_SRC					56
+#define GCC_GP5_CLK					57
+#define GCC_GP5_CLK_SRC					58
+#define GCC_GPU_CFG_AHB_CLK				59
+#define GCC_GPU_GPLL0_CLK_SRC				60
+#define GCC_GPU_GPLL0_DIV_CLK_SRC			61
+#define GCC_GPU_MEMNOC_GFX_CLK				62
+#define GCC_GPU_SNOC_DVM_GFX_CLK			63
+#define GCC_GPU_TCU_THROTTLE_AHB_CLK			64
+#define GCC_GPU_TCU_THROTTLE_CLK			65
+#define GCC_PCIE_0_AUX_CLK				66
+#define GCC_PCIE_0_AUX_CLK_SRC				67
+#define GCC_PCIE_0_CFG_AHB_CLK				68
+#define GCC_PCIE_0_MSTR_AXI_CLK				69
+#define GCC_PCIE_0_PHY_AUX_CLK				70
+#define GCC_PCIE_0_PHY_AUX_CLK_SRC			71
+#define GCC_PCIE_0_PHY_RCHNG_CLK			72
+#define GCC_PCIE_0_PHY_RCHNG_CLK_SRC			73
+#define GCC_PCIE_0_PIPE_CLK				74
+#define GCC_PCIE_0_PIPE_CLK_SRC				75
+#define GCC_PCIE_0_PIPE_DIV_CLK_SRC			76
+#define GCC_PCIE_0_PIPEDIV2_CLK				77
+#define GCC_PCIE_0_SLV_AXI_CLK				78
+#define GCC_PCIE_0_SLV_Q2A_AXI_CLK			79
+#define GCC_PCIE_1_AUX_CLK				80
+#define GCC_PCIE_1_AUX_CLK_SRC				81
+#define GCC_PCIE_1_CFG_AHB_CLK				82
+#define GCC_PCIE_1_MSTR_AXI_CLK				83
+#define GCC_PCIE_1_PHY_AUX_CLK				84
+#define GCC_PCIE_1_PHY_AUX_CLK_SRC			85
+#define GCC_PCIE_1_PHY_RCHNG_CLK			86
+#define GCC_PCIE_1_PHY_RCHNG_CLK_SRC			87
+#define GCC_PCIE_1_PIPE_CLK				88
+#define GCC_PCIE_1_PIPE_CLK_SRC				89
+#define GCC_PCIE_1_PIPE_DIV_CLK_SRC			90
+#define GCC_PCIE_1_PIPEDIV2_CLK				91
+#define GCC_PCIE_1_SLV_AXI_CLK				92
+#define GCC_PCIE_1_SLV_Q2A_AXI_CLK			93
+#define GCC_PCIE_CLKREF_EN				94
+#define GCC_PCIE_THROTTLE_CFG_CLK			95
+#define GCC_PDM2_CLK					96
+#define GCC_PDM2_CLK_SRC				97
+#define GCC_PDM_AHB_CLK					98
+#define GCC_PDM_XO4_CLK					99
+#define GCC_QMIP_CAMERA_NRT_AHB_CLK			100
+#define GCC_QMIP_CAMERA_RT_AHB_CLK			101
+#define GCC_QMIP_DISP1_AHB_CLK				102
+#define GCC_QMIP_DISP1_ROT_AHB_CLK			103
+#define GCC_QMIP_DISP_AHB_CLK				104
+#define GCC_QMIP_DISP_ROT_AHB_CLK			105
+#define GCC_QMIP_VIDEO_CVP_AHB_CLK			106
+#define GCC_QMIP_VIDEO_VCODEC_AHB_CLK			107
+#define GCC_QMIP_VIDEO_VCPU_AHB_CLK			108
+#define GCC_QUPV3_WRAP0_CORE_2X_CLK			109
+#define GCC_QUPV3_WRAP0_CORE_CLK			110
+#define GCC_QUPV3_WRAP0_S0_CLK				111
+#define GCC_QUPV3_WRAP0_S0_CLK_SRC			112
+#define GCC_QUPV3_WRAP0_S1_CLK				113
+#define GCC_QUPV3_WRAP0_S1_CLK_SRC			114
+#define GCC_QUPV3_WRAP0_S2_CLK				115
+#define GCC_QUPV3_WRAP0_S2_CLK_SRC			116
+#define GCC_QUPV3_WRAP0_S3_CLK				117
+#define GCC_QUPV3_WRAP0_S3_CLK_SRC			118
+#define GCC_QUPV3_WRAP0_S4_CLK				119
+#define GCC_QUPV3_WRAP0_S4_CLK_SRC			120
+#define GCC_QUPV3_WRAP0_S5_CLK				121
+#define GCC_QUPV3_WRAP0_S5_CLK_SRC			122
+#define GCC_QUPV3_WRAP0_S6_CLK				123
+#define GCC_QUPV3_WRAP0_S6_CLK_SRC			124
+#define GCC_QUPV3_WRAP1_CORE_2X_CLK			125
+#define GCC_QUPV3_WRAP1_CORE_CLK			126
+#define GCC_QUPV3_WRAP1_S0_CLK				127
+#define GCC_QUPV3_WRAP1_S0_CLK_SRC			128
+#define GCC_QUPV3_WRAP1_S1_CLK				129
+#define GCC_QUPV3_WRAP1_S1_CLK_SRC			130
+#define GCC_QUPV3_WRAP1_S2_CLK				131
+#define GCC_QUPV3_WRAP1_S2_CLK_SRC			132
+#define GCC_QUPV3_WRAP1_S3_CLK				133
+#define GCC_QUPV3_WRAP1_S3_CLK_SRC			134
+#define GCC_QUPV3_WRAP1_S4_CLK				135
+#define GCC_QUPV3_WRAP1_S4_CLK_SRC			136
+#define GCC_QUPV3_WRAP1_S5_CLK				137
+#define GCC_QUPV3_WRAP1_S5_CLK_SRC			138
+#define GCC_QUPV3_WRAP1_S6_CLK				139
+#define GCC_QUPV3_WRAP1_S6_CLK_SRC			140
+#define GCC_QUPV3_WRAP2_CORE_2X_CLK			141
+#define GCC_QUPV3_WRAP2_CORE_CLK			142
+#define GCC_QUPV3_WRAP2_S0_CLK				143
+#define GCC_QUPV3_WRAP2_S0_CLK_SRC			144
+#define GCC_QUPV3_WRAP2_S1_CLK				145
+#define GCC_QUPV3_WRAP2_S1_CLK_SRC			146
+#define GCC_QUPV3_WRAP2_S2_CLK				147
+#define GCC_QUPV3_WRAP2_S2_CLK_SRC			148
+#define GCC_QUPV3_WRAP2_S3_CLK				149
+#define GCC_QUPV3_WRAP2_S3_CLK_SRC			150
+#define GCC_QUPV3_WRAP2_S4_CLK				151
+#define GCC_QUPV3_WRAP2_S4_CLK_SRC			152
+#define GCC_QUPV3_WRAP2_S5_CLK				153
+#define GCC_QUPV3_WRAP2_S5_CLK_SRC			154
+#define GCC_QUPV3_WRAP2_S6_CLK				155
+#define GCC_QUPV3_WRAP2_S6_CLK_SRC			156
+#define GCC_QUPV3_WRAP3_CORE_2X_CLK			157
+#define GCC_QUPV3_WRAP3_CORE_CLK			158
+#define GCC_QUPV3_WRAP3_QSPI_CLK			159
+#define GCC_QUPV3_WRAP3_S0_CLK				160
+#define GCC_QUPV3_WRAP3_S0_CLK_SRC			161
+#define GCC_QUPV3_WRAP3_S0_DIV_CLK_SRC			162
+#define GCC_QUPV3_WRAP_0_M_AHB_CLK			163
+#define GCC_QUPV3_WRAP_0_S_AHB_CLK			164
+#define GCC_QUPV3_WRAP_1_M_AHB_CLK			165
+#define GCC_QUPV3_WRAP_1_S_AHB_CLK			166
+#define GCC_QUPV3_WRAP_2_M_AHB_CLK			167
+#define GCC_QUPV3_WRAP_2_S_AHB_CLK			168
+#define GCC_QUPV3_WRAP_3_M_AHB_CLK			169
+#define GCC_QUPV3_WRAP_3_S_AHB_CLK			170
+#define GCC_SDCC1_AHB_CLK				171
+#define GCC_SDCC1_APPS_CLK				172
+#define GCC_SDCC1_APPS_CLK_SRC				173
+#define GCC_SDCC1_ICE_CORE_CLK				174
+#define GCC_SDCC1_ICE_CORE_CLK_SRC			175
+#define GCC_SGMI_CLKREF_EN				176
+#define GCC_TSCSS_AHB_CLK				177
+#define GCC_TSCSS_CNTR_CLK_SRC				178
+#define GCC_TSCSS_ETU_CLK				179
+#define GCC_TSCSS_GLOBAL_CNTR_CLK			180
+#define GCC_UFS_CARD_AHB_CLK				181
+#define GCC_UFS_CARD_AXI_CLK				182
+#define GCC_UFS_CARD_AXI_CLK_SRC			183
+#define GCC_UFS_CARD_ICE_CORE_CLK			184
+#define GCC_UFS_CARD_ICE_CORE_CLK_SRC			185
+#define GCC_UFS_CARD_PHY_AUX_CLK			186
+#define GCC_UFS_CARD_PHY_AUX_CLK_SRC			187
+#define GCC_UFS_CARD_RX_SYMBOL_0_CLK			188
+#define GCC_UFS_CARD_RX_SYMBOL_0_CLK_SRC		189
+#define GCC_UFS_CARD_RX_SYMBOL_1_CLK			190
+#define GCC_UFS_CARD_RX_SYMBOL_1_CLK_SRC		191
+#define GCC_UFS_CARD_TX_SYMBOL_0_CLK			192
+#define GCC_UFS_CARD_TX_SYMBOL_0_CLK_SRC		193
+#define GCC_UFS_CARD_UNIPRO_CORE_CLK			194
+#define GCC_UFS_CARD_UNIPRO_CORE_CLK_SRC		195
+#define GCC_UFS_PHY_AHB_CLK				196
+#define GCC_UFS_PHY_AXI_CLK				197
+#define GCC_UFS_PHY_AXI_CLK_SRC				198
+#define GCC_UFS_PHY_ICE_CORE_CLK			199
+#define GCC_UFS_PHY_ICE_CORE_CLK_SRC			200
+#define GCC_UFS_PHY_PHY_AUX_CLK				201
+#define GCC_UFS_PHY_PHY_AUX_CLK_SRC			202
+#define GCC_UFS_PHY_RX_SYMBOL_0_CLK			203
+#define GCC_UFS_PHY_RX_SYMBOL_0_CLK_SRC			204
+#define GCC_UFS_PHY_RX_SYMBOL_1_CLK			205
+#define GCC_UFS_PHY_RX_SYMBOL_1_CLK_SRC			206
+#define GCC_UFS_PHY_TX_SYMBOL_0_CLK			207
+#define GCC_UFS_PHY_TX_SYMBOL_0_CLK_SRC			208
+#define GCC_UFS_PHY_UNIPRO_CORE_CLK			209
+#define GCC_UFS_PHY_UNIPRO_CORE_CLK_SRC			210
+#define GCC_USB20_MASTER_CLK				211
+#define GCC_USB20_MASTER_CLK_SRC			212
+#define GCC_USB20_MOCK_UTMI_CLK				213
+#define GCC_USB20_MOCK_UTMI_CLK_SRC			214
+#define GCC_USB20_MOCK_UTMI_POSTDIV_CLK_SRC		215
+#define GCC_USB20_SLEEP_CLK				216
+#define GCC_USB30_PRIM_MASTER_CLK			217
+#define GCC_USB30_PRIM_MASTER_CLK_SRC			218
+#define GCC_USB30_PRIM_MOCK_UTMI_CLK			219
+#define GCC_USB30_PRIM_MOCK_UTMI_CLK_SRC		220
+#define GCC_USB30_PRIM_MOCK_UTMI_POSTDIV_CLK_SRC	221
+#define GCC_USB30_PRIM_SLEEP_CLK			222
+#define GCC_USB30_SEC_MASTER_CLK			223
+#define GCC_USB30_SEC_MASTER_CLK_SRC			224
+#define GCC_USB30_SEC_MOCK_UTMI_CLK			225
+#define GCC_USB30_SEC_MOCK_UTMI_CLK_SRC			226
+#define GCC_USB30_SEC_MOCK_UTMI_POSTDIV_CLK_SRC		227
+#define GCC_USB30_SEC_SLEEP_CLK				228
+#define GCC_USB3_PRIM_PHY_AUX_CLK			229
+#define GCC_USB3_PRIM_PHY_AUX_CLK_SRC			230
+#define GCC_USB3_PRIM_PHY_COM_AUX_CLK			231
+#define GCC_USB3_PRIM_PHY_PIPE_CLK			232
+#define GCC_USB3_PRIM_PHY_PIPE_CLK_SRC			233
+#define GCC_USB3_SEC_PHY_AUX_CLK			234
+#define GCC_USB3_SEC_PHY_AUX_CLK_SRC			235
+#define GCC_USB3_SEC_PHY_COM_AUX_CLK			236
+#define GCC_USB3_SEC_PHY_PIPE_CLK			237
+#define GCC_USB3_SEC_PHY_PIPE_CLK_SRC			238
+#define GCC_USB_CLKREF_EN				239
+#define GCC_VIDEO_AHB_CLK				240
+#define GCC_VIDEO_AXI0_CLK				241
+#define GCC_VIDEO_AXI1_CLK				242
+#define GCC_VIDEO_XO_CLK				243
+#define GCC_AGGRE_UFS_PHY_AXI_HW_CTL_CLK		244
+#define GCC_UFS_PHY_AXI_HW_CTL_CLK			245
+#define GCC_UFS_PHY_ICE_CORE_HW_CTL_CLK			246
+#define GCC_UFS_PHY_PHY_AUX_HW_CTL_CLK			247
+#define GCC_UFS_PHY_UNIPRO_CORE_HW_CTL_CLK		248
+
+/* GCC resets */
+#define GCC_CAMERA_BCR					0
+#define GCC_DISPLAY1_BCR				1
+#define GCC_DISPLAY_BCR					2
+#define GCC_EMAC0_BCR					3
+#define GCC_EMAC1_BCR					4
+#define GCC_GPU_BCR					5
+#define GCC_MMSS_BCR					6
+#define GCC_PCIE_0_BCR					7
+#define GCC_PCIE_0_LINK_DOWN_BCR			8
+#define GCC_PCIE_0_NOCSR_COM_PHY_BCR			9
+#define GCC_PCIE_0_PHY_BCR				10
+#define GCC_PCIE_0_PHY_NOCSR_COM_PHY_BCR		11
+#define GCC_PCIE_1_BCR					12
+#define GCC_PCIE_1_LINK_DOWN_BCR			13
+#define GCC_PCIE_1_NOCSR_COM_PHY_BCR			14
+#define GCC_PCIE_1_PHY_BCR				15
+#define GCC_PCIE_1_PHY_NOCSR_COM_PHY_BCR		16
+#define GCC_PDM_BCR					17
+#define GCC_QUPV3_WRAPPER_0_BCR				18
+#define GCC_QUPV3_WRAPPER_1_BCR				19
+#define GCC_QUPV3_WRAPPER_2_BCR				20
+#define GCC_QUPV3_WRAPPER_3_BCR				21
+#define GCC_SDCC1_BCR					22
+#define GCC_TSCSS_BCR					23
+#define GCC_UFS_CARD_BCR				24
+#define GCC_UFS_PHY_BCR					25
+#define GCC_USB20_PRIM_BCR				26
+#define GCC_USB2_PHY_PRIM_BCR				27
+#define GCC_USB2_PHY_SEC_BCR				28
+#define GCC_USB30_PRIM_BCR				29
+#define GCC_USB30_SEC_BCR				30
+#define GCC_USB3_DP_PHY_PRIM_BCR			31
+#define GCC_USB3_DP_PHY_SEC_BCR				32
+#define GCC_USB3_PHY_PRIM_BCR				33
+#define GCC_USB3_PHY_SEC_BCR				34
+#define GCC_USB3_PHY_TERT_BCR				35
+#define GCC_USB3_UNIPHY_MP0_BCR				36
+#define GCC_USB3_UNIPHY_MP1_BCR				37
+#define GCC_USB3PHY_PHY_PRIM_BCR			38
+#define GCC_USB3PHY_PHY_SEC_BCR				39
+#define GCC_USB3UNIPHY_PHY_MP0_BCR			40
+#define GCC_USB3UNIPHY_PHY_MP1_BCR			41
+#define GCC_USB_PHY_CFG_AHB2PHY_BCR			42
+#define GCC_VIDEO_BCR					43
+#define GCC_VIDEO_AXI0_CLK_ARES				44
+#define GCC_VIDEO_AXI1_CLK_ARES				45
+
+/* GCC GDSCs */
+#define PCIE_0_GDSC					0
+#define PCIE_1_GDSC					1
+#define UFS_CARD_GDSC					2
+#define UFS_PHY_GDSC					3
+#define USB20_PRIM_GDSC					4
+#define USB30_PRIM_GDSC					5
+#define USB30_SEC_GDSC					6
+#define EMAC0_GDSC					7
+#define EMAC1_GDSC					8
+
+#endif /* _DT_BINDINGS_CLK_QCOM_GCC_SA8775P_H */
-- 
2.37.2

