Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCE48B224
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343701AbiAKQ2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:28:40 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.103]:33173 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349961AbiAKQ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:28:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918161;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DBdydKDJXr4jLmklS5xq83gah+5FYR6KxbNfOtC5n44=;
    b=TPvvCJuEUfz2PPnZuEmLI6eAA2go14rjhtApmmtcGf2is6v3klu1JixPYeXQhbVlgU
    /0gmlEAFawhRvlF1Q6f/qtdtRKCqou/QyedTZJeECT2L1Vflt2PPiA/NcHwAusKYUtbD
    r4KM90hBtGL8nsjukZarXJdLiHDInsnMqOOi1gptaydDs0libtib9NKmoQgMQo6wygEV
    yxIIgWqqUxuj8dkGWC1Q4OAxIJNc4nr9tU7LJiCX4V0D9gZgLY7DuJluDALmNpi344Ne
    ptA8r5WsI35nR6ZUpEcWxoeQqzuo0l6eku8A749+l7Zxq1dXKZ/Rh3SCWrbXXU7FqFk5
    9/Rg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR8nxYa0aI"
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id a48ca5y0BGMfHKt
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:22:41 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v2 3/5] arm64: dts: renesas: r8a779a0: Add CANFD device node
Date:   Tue, 11 Jan 2022 17:22:29 +0100
Message-Id: <20220111162231.10390-4-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220111162231.10390-1-uli+renesas@fpond.eu>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a CANFD device node for r8a779a0.

Based on patch by Kazuya Mizuguchi.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 56 +++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index 1e7ed12ebc87..dfde33fa40e3 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -24,6 +24,13 @@
 		i2c6 = &i2c6;
 	};
 
+	/* External CAN clock - to be overridden by boards that provide it */
+	can_clk: can {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -581,6 +588,55 @@
 			status = "disabled";
 		};
 
+		canfd: can@e6660000 {
+			compatible = "renesas,r8a779a0-canfd";
+			reg = <0 0xe6660000 0 0x8000>;
+			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
+			clocks = <&cpg CPG_MOD 328>,
+				 <&cpg CPG_CORE R8A779A0_CLK_CANFD>,
+				 <&can_clk>;
+			clock-names = "fck", "canfd", "can_clk";
+			assigned-clocks = <&cpg CPG_CORE R8A779A0_CLK_CANFD>;
+			assigned-clock-rates = <80000000>;
+			power-domains = <&sysc R8A779A0_PD_ALWAYS_ON>;
+			resets = <&cpg 328>;
+			status = "disabled";
+
+			channel0 {
+				status = "disabled";
+			};
+
+			channel1 {
+				status = "disabled";
+			};
+
+			channel2 {
+				status = "disabled";
+			};
+
+			channel3 {
+				status = "disabled";
+			};
+
+			channel4 {
+				status = "disabled";
+			};
+
+			channel5 {
+				status = "disabled";
+			};
+
+			channel6 {
+				status = "disabled";
+			};
+
+			channel7 {
+				status = "disabled";
+			};
+		};
+
 		avb0: ethernet@e6800000 {
 			compatible = "renesas,etheravb-r8a779a0",
 				     "renesas,etheravb-rcar-gen3";
-- 
2.20.1

