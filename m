Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCB84177EE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 17:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347174AbhIXPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 11:38:58 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:23391 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347159AbhIXPi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 11:38:57 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2021 11:38:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1632497481;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=EAxKmsQFwHo6vhBBfWN6HdxEvk7esbuk+rLIBQ3Iw3Q=;
    b=I2o4ntuz/1R9sfi8cRBPv8jFmXi1a0KW/9eTzZ8bMZHmKxVqDwKdllf2jN0JLUrJlw
    mobx6dLgk5f0AR2dJimQpY5Al8CDDsozVWEHuQpL3K/JPOtn0UG5AdDo92htED0p1LWl
    ZF+Xu/NYrw4jN+B2clezHs3xDNrtGdIi8NBMQMlzompnYHXKLSIq1Pih/Gt+T1PjWvKT
    nNtulA5pkE2sQL8Bq660y8FFi81C9pz4Y/ZPl7tOvU8BTmKPI1J52qeKAbAozMibzV/q
    1bwjsC5zQo4C/OjI+3w1fGB86OdW5gX1s3fQzPO4aMMMZpNkCw1swvW82KorWFmao5k0
    ErHA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR92BEa52Otg=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.33.8 DYNA|AUTH)
    with ESMTPSA id c00f85x8OFVKN4S
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 24 Sep 2021 17:31:20 +0200 (CEST)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH 3/3] arm64: dts: r8a779a0: Add CANFD device node
Date:   Fri, 24 Sep 2021 17:31:13 +0200
Message-Id: <20210924153113.10046-4-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210924153113.10046-1-uli+renesas@fpond.eu>
References: <20210924153113.10046-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds CANFD device node for r8a779a0.

Based on patch by Kazuya Mizuguchi.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 55 +++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index f9a882b34f82..c54c06473248 100644
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
@@ -236,6 +243,54 @@
 			#interrupt-cells = <2>;
 		};
 
+		canfd: can@e6660000 {
+			compatible = "renesas,r8a779a0-canfd";
+			reg = <0 0xe6660000 0 0x8000>;
+			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 328>,
+				 <&cpg CPG_CORE R8A779A0_CLK_CANFD>,
+				 <&can_clk>;
+			clock-names = "fck", "canfd", "can_clk";
+			assigned-clocks = <&cpg CPG_CORE R8A779A0_CLK_CANFD>;
+			assigned-clock-rates = <40000000>;
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
 		cmt0: timer@e60f0000 {
 			compatible = "renesas,r8a779a0-cmt0",
 				     "renesas,rcar-gen3-cmt0";
-- 
2.20.1

