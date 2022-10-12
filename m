Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F305FC404
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJLKyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiJLKyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:54:01 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80070.outbound.protection.outlook.com [40.107.8.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9423BBEAF7;
        Wed, 12 Oct 2022 03:53:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj9D+zjfPzBeq+iyHC97CkpQ+8pdG2SC7VPEfcE4Vhx2/Vy4ZwVFITFs3FYDVO3n0w2WH71bBPYwX2CbZyRpyeP8NCT4++rVJNz70Xp034641el7MYv3bvDlu7QqCbRcJTRSoF51t4n3/tFKRmjRo4FTDfZNiH008XhK7VnoIvyVkM0MNuCekNEciDCPdtPxVdOTMgSAP6EAR8HJkYGjzzddOUDDZiJ8SdkX4y67+Vz72DBdGieK9KaPlDjXQWZOqTcTikYAXFTpzJ3ZRqf+4evNYStkIDshueauzprmw3+BZWzww/pHveBPDhecHQZJ1KJ0dBGAypFup/yPNh29Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdvXlDjjS9kPlUPbPjrpPZ70LUH528KWu/+X/M3xPWc=;
 b=QOjK1LkL/ckNzJuCFDAnbDuVD+JabUg29l1E2dZDkl4DQDRDFegiDJBPAmRplT7OvylkjvtkqAHTiI3Bqvq79MDPWm1csKk+jYovgwT72zYVQuyjoDtZ0W1pFBQ1CwRHXTebuIvmjdFvJC27UmoyWr7G9EO0M2epkZoVOyEIQyaSrPkAzGnjHCSVDw3hmEpMcVDdgEwF00EIHOjyPvxBjkkRWae54zRXFJKHkvIOcL5k6bNKE1m8JuYFvmjiupo4Li/FbEESmjWtvD/s5ivc5adhZQ0vmMVQaksQ5EhlPK4ePhsQPdQcctq2OjleG5O8L5SmEtGU4aCMdOLmE3wcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdvXlDjjS9kPlUPbPjrpPZ70LUH528KWu/+X/M3xPWc=;
 b=kxdHVxNKv6okREKBBkPYzbME9r3SAk8AMWm4YlrOerEj0kjA24GF12fmKqRTj5Mpn3Log2yJOJOLGgMGL2qVfxhVjy4snUyJS6ppIQ+E1GQLa+xLMHQYEAkBpM+sycEUyybezdp921N9M1lwCTE/ClLWR+7JcvUlY3/pAM1XUZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 10:53:46 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 10:53:46 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 3/3] arm64: dts: imx93: add fec and eqos support
Date:   Wed, 12 Oct 2022 18:51:29 +0800
Message-Id: <20221012105129.3706062-4-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
References: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0107.apcprd03.prod.outlook.com
 (2603:1096:4:7c::35) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|DBBPR04MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: ddc7a5e5-a2bc-4640-c16c-08daac40093e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iXMVSSrlk5bLWNJK5QOtFNJDp0JSEyKTDc/KW5C5820r+rvoejH0xnednSOrKfMwRvmR99CCXuX2mAZAnmiIncOSLI9Pqho3hRI0ayhNd4PvgxKkIUEaFGuBC8gzQHw6FwI7VOFrOh6HXQZ8BYQuMAPoGfpwcqonMGTmyQ8pwKDEwsI2Q6ABoTB21VdhrpHDGUd//YVzpqam4rrkhgwAArd2YZ5n3DmX6bJS6BKa4fO4hmcCQn4jh1426LVhgJvUjSsxrYuJ8GEiXm0ThHW34CCH2+n7P0knY3MA5lvYNNsaJUHbjYn1TYCS2ixlnicMsdw3Vx8YJvCL3bQ3xkwHUEtFTcnqrBTeNCkwqFs5Ayx7ip/yMzGXBdsstTw/djVabI9qKqAzjzDXf/QBNiSQQ2hviP+7jgoiiPu+jVww5T2N/plvg9ZGtTimKAultMKH9fuU9S2ffjYzrVsBgPbxqvq6c+3HIj37dbpRhGe7T7QLZtBk9id1qL1Zx63uL4mnPg5YemEBG6mkb96G39SRmJ9A7QWV0a1YE7LiQbXPnl80rojLRnOj2KQhNrgrSoN8iM055KqbgrC4OYZ/iqsm+FIlUYABEgcOSI3elG8yy1ykMpuViZKVhrtwHkBe30Y7WXqrKzzwII62t4QOUyP+XOgcnoE/5H6j63wsYfoAguVnpatbLkmPuqrDkK9eUGFVD3YATLhGQ6SwUyVYZLg9zG9CdbRMK+5yw61oq5wcf+NUtl9k6sptzYEuPDIFCRfJrmYneYesZHerL9Qqf5oUzsfEyYLWhaad6RwJ51XQ/Yi60MgqCHX1yITgc0rakJqF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199015)(6666004)(921005)(478600001)(6506007)(36756003)(52116002)(6486002)(86362001)(38100700002)(38350700002)(2616005)(6512007)(186003)(1076003)(83380400001)(4326008)(2906002)(41300700001)(8676002)(316002)(26005)(5660300002)(66946007)(7416002)(66476007)(8936002)(66556008)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iChq3T7ZsApYwm+0ztV3FFY9nUq64eMawMXO0xBXsSyO4pxM3b2zct9k5Rg6?=
 =?us-ascii?Q?JGlDd923Sfp8D9bGT2uwhfnwU/8vI7cKRrfk0Dx3YzeQGLF4FxrIFGw/L1NT?=
 =?us-ascii?Q?Qc3aOZwdl0ZdnBR1SGy0tWbLz7ic2p1NrB4tkWr1z9qw3MVGPya2/FIejiz2?=
 =?us-ascii?Q?woR4w166pB6y26cQmwHV6mnts0VaczO5ClLR6v6dVYNLG2a/wi/DB8+bTXDB?=
 =?us-ascii?Q?dAfg/Ol0u8Xxdy8h2o8Whbu+3cJycTO5ygVMeZFYUnqj1f9FNypaYtEwj1FV?=
 =?us-ascii?Q?U3XNxCpmE1h5sf4NJZKALzOZGCW0yHKTXMysrtGgyHLAHNd1zmVWM4bd9eA0?=
 =?us-ascii?Q?DJXUVmUprv1UawZ6NzD2uKpMMdVDJYJJQLHx2ZhfMl5Fi+d202MS2RFWwG4I?=
 =?us-ascii?Q?bU0IL73FdJDMScP4ZuNqNFR/eUtivTcnUdxsGNw7UbCaedvV/z+AR/onRIH9?=
 =?us-ascii?Q?3KRP5aNEgakNCcRIEAmuImUjXSAj9eR4PXGN0BwsiN4Fbqy9Sc+A48SPIPm4?=
 =?us-ascii?Q?YQGH8zbP25yrvuHWjnFh6cUv7W5v88FTi9c0mYoxULCRtZRcoWRK0wdHCwbY?=
 =?us-ascii?Q?+zLrY3wGnTKApYmk2H3k8kZjVWdaPBFn4aypWUwwPjAdxkguDtVaG7PxRZY9?=
 =?us-ascii?Q?+EhqciQyHvIjsKREPzIkjc5jJFwNKSSLy6JyVBHHTrpTakDm+t7+f/ZpEAeb?=
 =?us-ascii?Q?dX8Jk49Wkjd4BlA/q+MlNy6p0S40Rfus3pTnGCnGWdBtwgTgFknEKAs+x/A9?=
 =?us-ascii?Q?frJLbdtMLwWJyI57Pxi7sJijoDW6aWNO+O+vnqT10coknfBM/IX9kXkMYDNZ?=
 =?us-ascii?Q?G3MYNzjnsK7w9nEjlZlXZX4xU+te2gd6ZO8i0aygwUNB6+EHt94tSQRdySpt?=
 =?us-ascii?Q?i2qT4xilgeUODD1TmXmWLIwkuybCckT3v4IJu3b0jlS6NzyBiXxaCaNN4UKr?=
 =?us-ascii?Q?ilI0gIfrOm+F33Kur1GwfG1GNNv4JkiH3K9K3jessYG06OVahmrOYbWJ8esn?=
 =?us-ascii?Q?++C1rCAiTUAbVwKFeyRfoLHw9Zh/coKpyWSww3vrMHShlybBm7vPkFuylR7d?=
 =?us-ascii?Q?EnE+e2e7lgfSxlMQagr5oONgsnFltwbhNY3pUAIqBeZZWm/jVesGx03gl+4S?=
 =?us-ascii?Q?eCLAk1rFCdhPyfZGeOJoHgN0iOU6CPXtMIti/WJdwdtNo0treyDUVHJ6T3Ef?=
 =?us-ascii?Q?XTUfuOS7GcQo4Fz8InnyJIjAgHCOsmfrcz9d+TzWEWtd3pgUmVB0RNUaYGnt?=
 =?us-ascii?Q?KP+0nqKSCtixPYokRZt03NTrTGuqEvU5UouSYkt/903Qm+B/0b2Qz19BDQM1?=
 =?us-ascii?Q?QRg0NfKNrdM9JgCXFsrltP26u+g0Tvq7cwbLUhpj1u59SRhOGybhbOB1Yrnz?=
 =?us-ascii?Q?g9flT+mda7v5C6zQvhmmjpHXmjXjZ+NntuDIIkLVKFvxiwuW0dH4X37j3MVX?=
 =?us-ascii?Q?93o5QxVqN9fNLofgIuaJfK3JPMesD4WI+YoI4dWcfo0A7k0RThhhZAgE/dE2?=
 =?us-ascii?Q?xb4N9yPwBJVjzl6/Ws+BJSXRuvM+jhAJwmSm01M5+RVVxzEMBD115YVE0UxO?=
 =?us-ascii?Q?WejUIA9Vdb3C9D9OZmDTZSxp4iSfCv8+vU9Rc6Tq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc7a5e5-a2bc-4640-c16c-08daac40093e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 10:53:46.2150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bzl/8GD2DmD79O0y/IAB5hOMdo45DBAu4eTeu7vcAdiZl0RFTRy5nc8DM5GLazBUlPru12Xm8DM+fwyG6lySCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable EQoS functions for imx93 platform.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 .../boot/dts/freescale/imx93-11x11-evk.dts    | 40 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx93.dtsi      | 22 ++++++++++
 2 files changed, 62 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
index 69786c326db0..837f8b47ee4f 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
@@ -35,6 +35,27 @@ &mu2 {
 	status = "okay";
 };
 
+&eqos {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_eqos>;
+	phy-mode = "rgmii-id";
+	phy-handle = <&ethphy1>;
+	status = "okay";
+
+	mdio {
+		compatible = "snps,dwmac-mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clock-frequency = <5000000>;
+
+		ethphy1: ethernet-phy@1 {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			reg = <1>;
+			eee-broken-1000t;
+		};
+	};
+};
+
 &lpuart1 { /* console */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
@@ -65,6 +86,25 @@ &usdhc2 {
 };
 
 &iomuxc {
+	pinctrl_eqos: eqosgrp {
+		fsl,pins = <
+			MX93_PAD_ENET1_MDC__ENET_QOS_MDC			0x57e
+			MX93_PAD_ENET1_MDIO__ENET_QOS_MDIO			0x57e
+			MX93_PAD_ENET1_RD0__ENET_QOS_RGMII_RD0			0x57e
+			MX93_PAD_ENET1_RD1__ENET_QOS_RGMII_RD1			0x57e
+			MX93_PAD_ENET1_RD2__ENET_QOS_RGMII_RD2			0x57e
+			MX93_PAD_ENET1_RD3__ENET_QOS_RGMII_RD3			0x57e
+			MX93_PAD_ENET1_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x5fe
+			MX93_PAD_ENET1_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x57e
+			MX93_PAD_ENET1_TD0__ENET_QOS_RGMII_TD0			0x57e
+			MX93_PAD_ENET1_TD1__ENET_QOS_RGMII_TD1			0x57e
+			MX93_PAD_ENET1_TD2__ENET_QOS_RGMII_TD2			0x57e
+			MX93_PAD_ENET1_TD3__ENET_QOS_RGMII_TD3			0x57e
+			MX93_PAD_ENET1_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x5fe
+			MX93_PAD_ENET1_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x57e
+		>;
+	};
+
 	pinctrl_uart1: uart1grp {
 		fsl,pins = <
 			MX93_PAD_UART1_RXD__LPUART1_RX			0x31e
diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 3a5713bb4880..8cb7d7d88086 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -425,6 +425,28 @@ usdhc2: mmc@42860000 {
 				status = "disabled";
 			};
 
+			eqos: ethernet@428a0000 {
+				compatible = "nxp,imx93-dwmac-eqos", "snps,dwmac-5.10a";
+				reg = <0x428a0000 0x10000>;
+				interrupts = <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "eth_wake_irq", "macirq";
+				clocks = <&clk IMX93_CLK_ENET_QOS_GATE>,
+					 <&clk IMX93_CLK_ENET_QOS_GATE>,
+					 <&clk IMX93_CLK_ENET_TIMER2>,
+					 <&clk IMX93_CLK_ENET>,
+					 <&clk IMX93_CLK_ENET_QOS_GATE>;
+				clock-names = "stmmaceth", "pclk", "ptp_ref", "tx", "mem";
+				assigned-clocks = <&clk IMX93_CLK_ENET_TIMER2>,
+						  <&clk IMX93_CLK_ENET>;
+				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>,
+							 <&clk IMX93_CLK_SYS_PLL_PFD0_DIV2>;
+				assigned-clock-rates = <100000000>, <250000000>;
+				intf_mode = <&wakeupmix_gpr 0x28>;
+				clk_csr = <0>;
+				status = "disabled";
+			};
+
 			usdhc3: mmc@428b0000 {
 				compatible = "fsl,imx93-usdhc", "fsl,imx8mm-usdhc";
 				reg = <0x428b0000 0x10000>;
-- 
2.34.1

