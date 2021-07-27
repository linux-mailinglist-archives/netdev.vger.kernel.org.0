Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C369F3D76D6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhG0NcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:32:14 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:10217 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236960AbhG0Nap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:30:45 -0400
X-IronPort-AV: E=Sophos;i="5.84,273,1620658800"; 
   d="scan'208";a="88920787"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jul 2021 22:30:44 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 48C5A4270492;
        Tue, 27 Jul 2021 22:30:41 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v4 3/3] arm64: dts: renesas: r9a07g044: Add CANFD node
Date:   Tue, 27 Jul 2021 14:30:22 +0100
Message-Id: <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CANFD node to R9A07G044 (RZ/G2L) SoC DTSI.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
index 9a7489dc70d1..51655c09f1f8 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -13,6 +13,13 @@
 	#address-cells = <2>;
 	#size-cells = <2>;
 
+	/* External CAN clock - to be overridden by boards that provide it */
+	can_clk: can {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
 	/* clock can be either from exclk or crystal oscillator (XIN/XOUT) */
 	extal_clk: extal {
 		compatible = "fixed-clock";
@@ -89,6 +96,40 @@
 			status = "disabled";
 		};
 
+		canfd: can@10050000 {
+			compatible = "renesas,r9a07g044-canfd", "renesas,rzg2l-canfd";
+			reg = <0 0x10050000 0 0x8000>;
+			interrupts = <GIC_SPI 426 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 427 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 428 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 429 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "g_err", "g_recc",
+					  "ch0_err", "ch0_rec", "ch0_trx",
+					  "ch1_err", "ch1_rec", "ch1_trx";
+			clocks = <&cpg CPG_MOD R9A07G044_CANFD_PCLK>,
+				 <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>,
+				 <&can_clk>;
+			clock-names = "fck", "canfd", "can_clk";
+			assigned-clocks = <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>;
+			assigned-clock-rates = <50000000>;
+			resets = <&cpg R9A07G044_CANFD_RSTP_N>,
+				 <&cpg R9A07G044_CANFD_RSTC_N>;
+			reset-names = "rstp_n", "rstc_n";
+			power-domains = <&cpg>;
+			status = "disabled";
+
+			channel0 {
+				status = "disabled";
+			};
+			channel1 {
+				status = "disabled";
+			};
+		};
+
 		i2c0: i2c@10058000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.17.1

