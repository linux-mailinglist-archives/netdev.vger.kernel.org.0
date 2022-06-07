Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA97753FD3F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbiFGLRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242790AbiFGLRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:31 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC1EEE;
        Tue,  7 Jun 2022 04:17:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aM4ITnEhj9+iDBmEWNgC+IkLxWsJawVh7tibyg0Fat0bPEQC7EtziWRUzpJT4bTXj1Ik3HurW7DO3ml/CyQy6fz2kDVox2pLVclEFX1vWg40ZiabUVy0OXhLCZok1NITgNlMCUdjOWp0Bqo7OYIrxhxEcadUdajJix6vaY2aDrEK3l5VVPWjRAoI/IefEnlkJGsW9SuEMAn4Nz4dbWoXiGc3ogZ5m5rgAdTtmcmd8LFD5Xd6ndXpmmK216GNS/XryS+GLHv9AgSXMkv56tkrYHzalxRPGPn0ZT3Af4Hj3gZ2w/eO6PZKGRRfvbja1qBFsmGnlwsQuXywUZEfMyFTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEkFXTNb3tmp1SQhBVy22yqcRZux6G86QibAvaN30JQ=;
 b=HvdVeYneJI0/CcZ2xHyBQE4dpQFnL3Y9SOvdeYQ0M8CJfu9Q4wcxNneKRiI4Y3ThqTlGuVzPSrBh/zpZ3DpyFQ2iV6xlzaHh1Mv325Mm9krvqKPoDhZKUzWZie+Vlpd8A3nc2tYHayAya/7fiFfgdPvZXZI8vbH3V6VzmjRrIO/xWJ0ZjSZWa0h0nXvNq4ks8pG66f++02s8egbM/gAJmi5ye5e4e6Sd7F3I05whYmaBk6xovSYYaaOsY932M61vNEW8EHBnQajwH/9NVlaVKkqJyyjQ1d2DPSVrY9H5RH2oTrSLrHLyG6mFGnYsMxMgqeDaWfvxqgBHl8kfx4MKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEkFXTNb3tmp1SQhBVy22yqcRZux6G86QibAvaN30JQ=;
 b=Qxz9wz7HyrvCc9RBI4JjMq82aLiHzXJ08kiTmCnRMCsL60oLOIRO1oba8XwjzR26MSvGfwSQHS6MZRQBCDDBt212W75mvNhPOKaXkFzGK1sP7/s5jfmZfTlH5tn3TATtAlJZq+tASG7mH6a3LBjWAXUW1OxbHTvmLDsk44QsJ1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:09 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:09 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v9 05/12] arm64: dts: freescale: Add the top level dtsi support for imx8dxl
Date:   Tue,  7 Jun 2022 14:16:18 +0300
Message-Id: <20220607111625.1845393-6-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f7241e7-e54b-480b-ee0d-08da487742ee
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4890A93CB90760A800FE428AF6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NslPB311cum9y12uanwgmcbAClfbw6KIQmSUAoBwsAKk4RpMKCBqDRwvFBx2i2izAhn9vgI8Ecrj/dX0Vr8LY0GLVJdN4/GP3djWW5GwIRk3K1B3kR28xDnxYEGgEILexEBmfUeFWITKfUQo9+Am6jYj1T/kTwsGcnKTG48C5XaoCMNGjPGVleHDAJ5TEhE5JGuw0D09DqaLVb8CTN09mUphRp4yPlGL2BIJW3kfJ6A8CXWTAngTPiROlv+v74Bg1CwSohSJR6ZvBUDFPRsdZB6KfTeqFKzMyEbjQAnBdRZxXZAF/OU/tzq1WIdIYVU8gGTZmB3Gf6QciCj5daRroXOZiIXvHbG/A7o6YS+vgrkoY7KT+QSyTweWD4IvctkHJnP4q+1UMiy/WdHUs/j5M3u+TuI1efvuJKWNCyXYIv7G7Ki1kAVhsKcyGistAJKQ4qdMiPHPYPQxoZ/vWC60xfN+NDO/GkOXFe4EIwz3vHICSQnLhAJgX1Higk262EWq0I1Fr9L40gho7p6YChV7PBT/NzXS2JbfPl/KAjbc2+TgQuwrx2/sxSsVIgQqGMF/42qoOIcV/VJ2GFkYxqz7WZNhRIKBhHq7Arocg+U9xkG50Hq0JM2/f0O+Xu1ivWMfqxC81LUnHbGiK5h6UXnKVW/QXlwn5+Z6lW+vSC7cY8mmg+vYwPykgODsGoDX+fGrOtTKUevB4OLj35lVPJmLf4Ra2PQIc/5Cj+LFZI/VY14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(83380400001)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M56DO5578L8BkCoWAL5iEiPp+UQQA71c16TvDK6Nq672mKBNFi+gytHwJatr?=
 =?us-ascii?Q?N8RO6TORV+E9V3wIJXzfSqTV2tDdiz7cXE0yd5Y23OijsX9An+HtE0chBjWo?=
 =?us-ascii?Q?Hi4gyIcGtCPzEW/iY5RfKW4krFLolaTf13am7PH5xvNpC3ZePMjTXplGTU98?=
 =?us-ascii?Q?c3YoB0Jl/7P1vIKNZrSoQLM+HYUbM1cAWFGpVImtLLT9r3BBLmhye/dCr4IX?=
 =?us-ascii?Q?2aq5g3j4+1snPmqPel3HBoS4uS6duEXnXvcQBKjukcCyGFpaVnqtBi6mu4e9?=
 =?us-ascii?Q?M6+QONkEzStFwKGI6aDA2aTiJw18uS+Dhwj1+pMzSWT2xfomGBAK45+dGPEm?=
 =?us-ascii?Q?XTYCHkZMb8nWCY/U0f+loCD9tASg3EYGK9DHtyi3wnvd2FC75xb2ViZJdy06?=
 =?us-ascii?Q?LdNK2UCN/5XxjwmpQY5iKy54WCl9FH7G6ickZqL6oWbdFSH99Wgdpc6XQjoI?=
 =?us-ascii?Q?vzyJRPZLb8GoaIF6/xl71nAghyBY4PDbYccJ1PJDPlsUQVLweqYS3mwIEmj7?=
 =?us-ascii?Q?vOeUBRPYs/uoAma+5muz1uRBmXL6YD/BzLsfkMuoQHI/oYin3T76EwJ1auxK?=
 =?us-ascii?Q?segQtF8ypSIkUFt238qbEm30jUDTAg6QHAUQIhJj4KrT0IFk8jM9MhZtU8Hm?=
 =?us-ascii?Q?BfwC1S2VRmv0Wz370rvv0oERMWBhy+CjXAkXerEzhkQ8EgYrN3ZysAllEtDK?=
 =?us-ascii?Q?tGN0fuPeg2NSaBc8pLyD879jpxBzCuj/XtH2WxVuwiYjF4oCA0LWTBn6zi/j?=
 =?us-ascii?Q?SQGSZvTqEkTBQtM6zd34OMpBWbedmAYv7P/CyKU6v8axEThxdMykTSJEYFBv?=
 =?us-ascii?Q?XWQNj/u9aEyOhCEySN+GtD0+qHuxCLYoJ5L6K2vP5xyULWuqyCBeRmvo0Kpu?=
 =?us-ascii?Q?BNESuZUa/TDLPC8s9vzP79XsCjTWit8+7nGux5h9lqzRBrTZJTPGJiDyOrAE?=
 =?us-ascii?Q?eXPGKmrgMWb/LlSilDgzIO4ZSKuvHIQ3ov4y2/x6q9jL+ly6ZaUoxicaCtBR?=
 =?us-ascii?Q?y2z3T3/f+3Ktc1L2NaEWsrJAUV7zj6Y/Mmlx3ffdkvzKsMaBUvgGRkVDhxcZ?=
 =?us-ascii?Q?I755+Sxj/GgXaSZaOGhaSuL9O/CAiBGmQ2O6C1ulG2WZCNISDc6yfNrEIcKV?=
 =?us-ascii?Q?X+t+7IT30dCzNFoBPtYmReNGXaLNjlNlRLTq+0x8Ej3MvPiQkOiSukvBr0Bx?=
 =?us-ascii?Q?BF77nFCPcNQ454TYUCA1LsLYz77GQxwwd6h3mzM87IwN/V4vitL3NLpKcFvL?=
 =?us-ascii?Q?EhKEw+5hHrob5t1iK4pkdp4FS6XlO82VjMsG2I1+gCxzuAlZhpV0Vm7inwJX?=
 =?us-ascii?Q?SHI6x38C7CjJWnFCk19gC5oQWyw2NvrwoXysp7puIUUk9+qhcIT30wBjhtRT?=
 =?us-ascii?Q?shCHQvE6bmB3LKWe/wsaiuTl6zRtQjyGqV8PJyZYVF/huz21HUrDEO5CLvev?=
 =?us-ascii?Q?dqIxLNPyURwCwNsAlv6Yp7RnvjFVpXaQYeprecpMzsGYloyCcUn07DiWqKjG?=
 =?us-ascii?Q?BWOWb+FqdwZt5Dsuo8odsFzSFi7ZEm1ZalOmqzp/YYaPn+8mbV52xLN5mdwI?=
 =?us-ascii?Q?3WPreMQooPGhxEqi9D6zC8ZJNNoKTcoeeEWBL8a8tImz1VrIs7kS7i5d31/R?=
 =?us-ascii?Q?X4tn4jy4AxJ/u1m2JKA1Ei3tWjU7coJjv5LJ6ytRobA7Jtm6ZWFliP1csxPL?=
 =?us-ascii?Q?1OaCC8zH45ZqUXZWLyatV9EXIlL6sCMqtMc2zV416F5tIHUHk+N86pNnn+2v?=
 =?us-ascii?Q?tgIeI7crzA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7241e7-e54b-480b-ee0d-08da487742ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:08.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUJfDQhjVpU1nXSOHbA4e4orFykqzO+ql2fHHoN2hIZSowRCYWmIaEHBweCn9n/4Lr/Kn6CBkl6ELPeksMu8XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

The i.MX8DXL is a device targeting the automotive and industrial
market segments. The flexibility of the architecture allows for
use in a wide variety of general embedded applications. The chip
is designed to achieve both high performance and low power consumption.
The chip relies on the power efficient dual (2x) Cortex-A35 cluster.

Add the reserved memory node property for dsp reserved memory,
the wakeup-irq property for SCU node, the rpmsg and the cm4 rproc
support.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi | 241 +++++++++++++++++++++
 1 file changed, 241 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
new file mode 100644
index 000000000000..6ed5f42b6f05
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+#include <dt-bindings/clock/imx8-clock.h>
+#include <dt-bindings/firmware/imx/rsrc.h>
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/input/input.h>
+#include <dt-bindings/pinctrl/pads-imx8dxl.h>
+#include <dt-bindings/thermal/thermal.h>
+
+/ {
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	aliases {
+		ethernet0 = &fec1;
+		ethernet1 = &eqos;
+		gpio0 = &lsio_gpio0;
+		gpio1 = &lsio_gpio1;
+		gpio2 = &lsio_gpio2;
+		gpio3 = &lsio_gpio3;
+		gpio4 = &lsio_gpio4;
+		gpio5 = &lsio_gpio5;
+		gpio6 = &lsio_gpio6;
+		gpio7 = &lsio_gpio7;
+		i2c2 = &i2c2;
+		i2c3 = &i2c3;
+		mmc0 = &usdhc1;
+		mmc1 = &usdhc2;
+		mu1 = &lsio_mu1;
+		serial0 = &lpuart0;
+		serial1 = &lpuart1;
+		serial2 = &lpuart2;
+		serial3 = &lpuart3;
+	};
+
+	cpus: cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		/* We have 1 cluster with 2 Cortex-A35 cores */
+		A35_0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a35";
+			reg = <0x0 0x0>;
+			enable-method = "psci";
+			next-level-cache = <&A35_L2>;
+			clocks = <&clk IMX_SC_R_A35 IMX_SC_PM_CLK_CPU>;
+			#cooling-cells = <2>;
+			operating-points-v2 = <&a35_opp_table>;
+		};
+
+		A35_1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a35";
+			reg = <0x0 0x1>;
+			enable-method = "psci";
+			next-level-cache = <&A35_L2>;
+			clocks = <&clk IMX_SC_R_A35 IMX_SC_PM_CLK_CPU>;
+			#cooling-cells = <2>;
+			operating-points-v2 = <&a35_opp_table>;
+		};
+
+		A35_L2: l2-cache0 {
+			compatible = "cache";
+		};
+	};
+
+	a35_opp_table: opp-table {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-900000000 {
+			opp-hz = /bits/ 64 <900000000>;
+			opp-microvolt = <1000000>;
+			clock-latency-ns = <150000>;
+		};
+
+		opp-1200000000 {
+			opp-hz = /bits/ 64 <1200000000>;
+			opp-microvolt = <1100000>;
+			clock-latency-ns = <150000>;
+			opp-suspend;
+		};
+	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		dsp_reserved: dsp@92400000 {
+			reg = <0 0x92400000 0 0x2000000>;
+			no-map;
+		};
+	};
+
+	gic: interrupt-controller@51a00000 {
+		compatible = "arm,gic-v3";
+		reg = <0x0 0x51a00000 0 0x10000>, /* GIC Dist */
+		      <0x0 0x51b00000 0 0xc0000>; /* GICR (RD_base + SGI_base) */
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	psci {
+		compatible = "arm,psci-1.0";
+		method = "smc";
+	};
+
+	scu {
+		compatible = "fsl,imx-scu";
+		mbox-names = "tx0",
+			     "rx0",
+			     "gip3";
+		mboxes = <&lsio_mu1 0 0
+			  &lsio_mu1 1 0
+			  &lsio_mu1 3 3>;
+
+		pd: imx8qx-pd {
+			compatible = "fsl,imx8dxl-scu-pd", "fsl,scu-pd";
+			#power-domain-cells = <1>;
+		};
+
+		clk: clock-controller {
+			compatible = "fsl,imx8dxl-clk", "fsl,scu-clk";
+			#clock-cells = <2>;
+			clocks = <&xtal32k &xtal24m>;
+			clock-names = "xtal_32KHz", "xtal_24Mhz";
+		};
+
+		iomuxc: pinctrl {
+			compatible = "fsl,imx8dxl-iomuxc";
+		};
+
+		ocotp: imx8qx-ocotp {
+			compatible = "fsl,imx8dxl-scu-ocotp", "fsl,imx8qxp-scu-ocotp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			fec_mac0: mac@2c4 {
+				reg = <0x2c4 6>;
+			};
+
+			fec_mac1: mac@2c6 {
+				reg = <0x2c6 6>;
+			};
+		};
+
+		watchdog {
+			compatible = "fsl,imx-sc-wdt";
+			timeout-sec = <60>;
+		};
+
+		tsens: thermal-sensor {
+			compatible = "fsl,imx-sc-thermal";
+			#thermal-sensor-cells = <1>;
+		};
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>, /* Physical Secure */
+			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>, /* Physical Non-Secure */
+			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>, /* Virtual */
+			     <GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>; /* Hypervisor */
+	};
+
+	thermal_zones: thermal-zones {
+		cpu0-thermal {
+			polling-delay-passive = <250>;
+			polling-delay = <2000>;
+			thermal-sensors = <&tsens IMX_SC_R_SYSTEM>;
+
+			trips {
+				cpu_alert0: trip0 {
+					temperature = <107000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+
+				cpu_crit0: trip1 {
+					temperature = <127000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+				map0 {
+					trip = <&cpu_alert0>;
+					cooling-device =
+					<&A35_0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+					<&A35_1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+				};
+			};
+		};
+	};
+
+	clk_dummy: clock-dummy {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+		clock-output-names = "clk_dummy";
+	};
+
+	xtal32k: clock-xtal32k {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+		clock-output-names = "xtal_32KHz";
+	};
+
+	xtal24m: clock-xtal24m {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24000000>;
+		clock-output-names = "xtal_24MHz";
+	};
+
+	/* sorted in register address */
+	#include "imx8-ss-adma.dtsi"
+	#include "imx8-ss-conn.dtsi"
+	#include "imx8-ss-ddr.dtsi"
+	#include "imx8-ss-lsio.dtsi"
+};
+
+#include "imx8dxl-ss-adma.dtsi"
+#include "imx8dxl-ss-conn.dtsi"
+#include "imx8dxl-ss-lsio.dtsi"
+#include "imx8dxl-ss-ddr.dtsi"
-- 
2.34.3

