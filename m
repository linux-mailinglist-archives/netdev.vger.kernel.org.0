Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12488249CE0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgHSL5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbgHSLtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 07:49:25 -0400
Received: from mail.kernel.org (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5AA422D2C;
        Wed, 19 Aug 2020 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597837584;
        bh=/WIWw2n/+wrDPjDLyfC24PkcUx0wQWmEH1MOT30QfuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3NnZzKx3Xxxwblo150+RFJw4mTAOvHmpL+6NXk8pSjkUeorhZf6Oc6HP8M7m4kRt
         3vH6G47mymUXenRfTYSOo4rpSd3YqnbDT4CJWTynANCLAmxnhDyW54aHsRZsr43BTA
         L4k0ZcigMoo/30tyGQDLeFMDRq7yW+MRaHROuFYA=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1k8MXt-00EucC-Mx; Wed, 19 Aug 2020 13:46:21 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Wei Xu <xuwei5@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 47/49] dts: add support for Hikey 970 DRM
Date:   Wed, 19 Aug 2020 13:46:15 +0200
Message-Id: <0f87d492431d4163873498c954d87595bf8776a0.1597833138.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1597833138.git.mchehab+huawei@kernel.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the needed bits for the DRM driver to work with the
Hikey 970 board.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../boot/dts/hisilicon/hi3670-hikey970.dts    |  52 +++++++
 arch/arm64/boot/dts/hisilicon/hi3670.dtsi     |   6 +
 .../boot/dts/hisilicon/hikey970-drm.dtsi      | 130 ++++++++++++++++++
 3 files changed, 188 insertions(+)
 create mode 100644 arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi

diff --git a/arch/arm64/boot/dts/hisilicon/hi3670-hikey970.dts b/arch/arm64/boot/dts/hisilicon/hi3670-hikey970.dts
index a9ad90e769ad..b3e16378182e 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3670-hikey970.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3670-hikey970.dts
@@ -13,6 +13,7 @@
 #include "hi3670.dtsi"
 #include "hikey970-pinctrl.dtsi"
 #include "hikey970-pmic.dtsi"
+#include "hikey970-drm.dtsi"
 
 / {
 	model = "HiKey970";
@@ -40,6 +41,27 @@ memory@0 {
 		reg = <0x0 0x0 0x0 0x0>;
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		drm_dma_reserved: drm_dma_mem_region {
+			compatible = "shared-dma-pool";
+			reg = <0 0x32200000 0 0x8000000>;
+			alignment = <0x400000>;
+			no-map;
+		};
+	};
+
+	fixed_3v3: regulator-3v3 {
+		compatible = "regulator-fixed";
+		regulator-name = "fixed-3.3V";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-always-on;
+	};
+
 	wlan_en: wlan-en-1-8v {
 		compatible = "regulator-fixed";
 		regulator-name = "wlan-en-regulator";
@@ -435,3 +457,33 @@ &uart6 {
 	label = "LS-UART1";
 	status = "okay";
 };
+
+&i2c4 {
+	status = "okay";
+
+	adv7533: adv7533@39 {
+		compatible = "adi,adv7533";
+		reg = <0x39>, <0x3f>, <0x3c>, <0x38>;
+		reg-names = "main", "edid", "cec", "packet";
+		v1p2-supply = <&ldo3>;
+		avdd-supply = <&ldo3>;
+		dvdd-supply = <&ldo3>;
+		pvdd-supply = <&ldo3>;
+		a2vdd-supply = <&ldo3>;
+		v3p3-supply = <&fixed_3v3>;
+
+		interrupt-parent = <&gpio1>;
+		interrupts = <1 2>;
+		pd-gpio = <&gpio27 1 0>;
+		sel-gpio = <&gpio25 7 0>;
+		adi,dsi-lanes = <4>;
+		adi,disable-timing-generator;
+		#sound-dai-cells = <0>;
+
+		port {
+			adv7533_in: endpoint {
+				remote-endpoint = <&dsi_out0>;
+			};
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
index 416f69c782d7..e2b2e21295a7 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
@@ -194,6 +194,12 @@ media2_crg: media2_crgctrl@e8900000 {
 			#clock-cells = <1>;
 		};
 
+		iomcu_rst: reset {
+			compatible = "hisilicon,hi3660-reset";
+			hisi,rst-syscon = <&iomcu>;
+			#reset-cells = <2>;
+		};
+
 		uart0: serial@fdf02000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x0 0xfdf02000 0x0 0x1000>;
diff --git a/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi b/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi
new file mode 100644
index 000000000000..3bd744b061ed
--- /dev/null
+++ b/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/ {
+	dpe: dpe@E8600000 {
+		compatible = "hisilicon,kirin970-dpe";
+		memory-region = <&drm_dma_reserved>;
+		// DSS, PERI_CRG, SCTRL, PCTRL, NOC_DSS_Service_Target, PMCTRL, MEDIA_CRG
+		reg = <0 0xE8600000 0 0xC0000>,
+			<0 0xFFF35000 0 0x1000>,
+			<0 0xFFF0A000 0 0x1000>,
+			<0 0xE8A09000 0 0x1000>,
+			<0 0xE86C0000 0 0x10000>,
+			<0 0xFFF31000 0 0x1000>,
+			<0 0xE87FF000 0 0x1000>;
+		// dss-pdp
+		interrupts = <0 245 4>;
+
+		clocks = <&media1_crg HI3670_ACLK_GATE_DSS>,
+			<&media1_crg HI3670_PCLK_GATE_DSS>,
+			<&media1_crg HI3670_CLK_GATE_EDC0>,
+			<&media1_crg HI3670_CLK_GATE_LDI0>,
+			<&media1_crg HI3670_CLK_GATE_DSS_AXI_MM>,
+			<&media1_crg HI3670_PCLK_GATE_MMBUF>,
+			<&crg_ctrl HI3670_PCLK_GATE_PCTRL>;
+
+		clock-names = "aclk_dss",
+			"pclk_dss",
+			"clk_edc0",
+			"clk_ldi0",
+			"clk_dss_axi_mm",
+			"pclk_mmbuf",
+			"pclk_pctrl";
+
+		dma-coherent;
+
+		port {
+			dpe_out: endpoint {
+				remote-endpoint = <&dsi_in>;
+			};
+		};
+
+		iommu_info {
+			start-addr = <0x8000>;
+			size = <0xbfff8000>;
+		};
+	};
+
+	dsi: dsi@E8601000 {
+		compatible = "hisilicon,kirin970-dsi";
+		reg = <0 0xE8601000 0 0x7F000>,
+			<0 0xFFF35000 0 0x1000>,
+			<0 0xE8A09000 0 0x1000>;
+
+		clocks = <&crg_ctrl HI3670_CLK_GATE_TXDPHY0_REF>,
+			<&crg_ctrl HI3670_CLK_GATE_TXDPHY1_REF>,
+			<&crg_ctrl HI3670_CLK_GATE_TXDPHY0_CFG>,
+			<&crg_ctrl HI3670_CLK_GATE_TXDPHY1_CFG>,
+			<&crg_ctrl HI3670_PCLK_GATE_DSI0>,
+			<&crg_ctrl HI3670_PCLK_GATE_DSI1>;
+		clock-names = "clk_txdphy0_ref",
+					"clk_txdphy1_ref",
+					"clk_txdphy0_cfg",
+					"clk_txdphy1_cfg",
+					"pclk_dsi0",
+					"pclk_dsi1";
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		mux-gpio = <&gpio25 7 0>;//HDMI_SEL(GPIO_207)
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				dsi_in: endpoint {
+					remote-endpoint = <&dpe_out>;
+				};
+			};
+
+			port@1 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <1>;
+
+				dsi_out0: endpoint@0 {
+					reg = <0>;
+					remote-endpoint = <&adv7533_in>;
+				};
+
+				dsi_out1: endpoint@1 {
+					reg = <1>;
+					remote-endpoint = <&panel0_in>;
+				};
+			};
+		};
+
+		panel@1 {
+			compatible = "hisilicon,mipi-hikey";
+			#address-cells = <2>;
+			#size-cells = <2>;
+			reg = <1>;
+			panel-width-mm = <94>;
+			panel-height-mm = <151>;
+			vdd-supply = <&ldo3>;
+			pwr-en-gpio = <&gpio21 3 0>;//GPIO_171
+			bl-en-gpio = <&gpio6 4 0>;//GPIO_052
+			pwm-gpio = <&gpio23 1 0>;//GPIO_185
+
+			port {
+				panel0_in: endpoint {
+					remote-endpoint = <&dsi_out1>;
+				};
+			};
+		};
+	};
+
+	panel_pwm {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		compatible = "hisilicon,hisipwm";
+		reg = <0 0xE8A04000 0 0x1000>,
+			<0 0xFFF35000 0 0x1000>;
+		clocks = <&crg_ctrl HI3670_CLK_GATE_PWM>;
+		clock-names = "clk_pwm";
+		pinctrl-names = "default","idle";
+		pinctrl-0 = <&gpio185_pmx_func &gpio185_cfg_func>;
+		pinctrl-1 = <&gpio185_pmx_idle &gpio185_cfg_idle>;
+	};
+};
-- 
2.26.2

