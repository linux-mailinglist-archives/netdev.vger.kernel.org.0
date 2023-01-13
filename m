Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0A1668A45
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbjAMDg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbjAMDfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:35:31 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2083.outbound.protection.outlook.com [40.107.20.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB3563F6B;
        Thu, 12 Jan 2023 19:35:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJST/MWouw9Sy30Tk+K1GSvSakEUsjc2/LS7QRsXQP7RKD0HFTZ6Cj/3JtTTq68z5FEcnPmjmJJ0HVtZLiS1Lm6Bu/COPDOIdfiaO1ylqdIUo4BbkpTiOFY3VWawzl+GI3BFD86IKc+Cq8lBiyjrw3WqkU5haFB93l3+HYiUhqV7aOW6ggVSo0pePCpQwSPZ7Kko3wFxdk9wttjKYecrYCiV8dtTFtubdFdLGXysulxVLbsWWF57suH+IAzgVFvJSroZdsKqnEJLQ5YeogJo/cR+UrqEMxG1mFDuWeaOOrcGS0vv5kGTjk7ECACXmKwh6mtvMx33D+fC78PUbtlTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5iHK2LoDlEv2s3dTLu8Qv2qejvPYPDwPyDoG5Vpqmc=;
 b=KNYgDjRGwot43NPZhR2df/ojSfkxPdE2JTsSXI/1n4HvRPzMjJjBvkFzv6le/rJrM9DVgKApsnwN02Ve5xBrVDKYYEyPjlkx3g+RkFdwhxnY5WiY1e0yCuwRw5v8Rs6Pm7D+WOID1SC5Fs929t8qbHb8JECWMPmIjqkOje3K9lZKybFgB4DdP3KaZ0Cc+L9Czvh0+xPLkbPNlnB4QmjOacwe6WuuRFqMj2kkbTPfUGoXb84gLV2y2bfdW2ivEy0v361OykpY21H5yY743l1LT3xPc+nHuFKn0t8WrF7rKwP1ujeDCJD0arACBThU3mQ+rQKQ9DoZvUuiuUiinIE12A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5iHK2LoDlEv2s3dTLu8Qv2qejvPYPDwPyDoG5Vpqmc=;
 b=GyJ33vk7iZJmwJRP5rmvJB1TmQLTpo+oR6emQeGuerY8JMbn8xLFJClU1Gtijg3NR8RFqLpwfyGuqQvwZ4CWGCJFJjcPWg8YaiOxDfkEb6pJ9ZU/l6RhYMm5tk3gLQpgxfBRkM9TNx+on5qLfo5L/74OgNug8cMK4PdqV0gHvzM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8247.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 03:35:13 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%12]) with mapi id 15.20.5986.019; Fri, 13 Jan
 2023 03:35:13 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     wei.fang@nxp.com, shenwei.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH V2 6/7] arm64: dts: imx93-11x11-evk: enable eqos
Date:   Fri, 13 Jan 2023 11:33:46 +0800
Message-Id: <20230113033347.264135-7-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113033347.264135-1-xiaoning.wang@nxp.com>
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ffbb11-e8a8-4e83-f1fa-08daf5172df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54JkgwSr5r0o2iyDuWQ/uogoVuN2ZzCMXhJwX2Gw2kuclAzH5piJt+WSDDaO+G/ErSUsuHYWWh/oQV1eUsrqTiifKNBuWWEM3PldHJwUUyKuss+BBTdVo9jTSDGPW2bv2BKzenp8U+gPu02ASoshMZI5mX7ZdcCIU+wQcSTXeKJCafoBFG21slUmkHe4/WyhE/fVTMG/oQ6/tAUbZDvVyv78uhUE5vMFiH5PDUCr3Zm4Cp5MkSWBna3AnLTH0CbZGUIYOB+Zngr+psI++tl+ircg2bG8Zuji9DCai+fFLUSL5PtkHQCgl2UiXOKsCw2sJv7T/ugW5OSwVn1h4qSuCPUPwvgHjzr+jLp1sPQYsS12IYbuPbkjQyjJeqm0dd2B4rWzSV6RPiKJDMe5tv7PEIeMF0czlJMAcNdUzjcX5pyhWFO72c57QHVSokaURaZ8U+zjENQsXPiVOX+Pm3VXqoLN72Ytmb75dNm7+YLtcY2B1pZ1GXn9+qoRMud5dpj7ImrjBi2b8beqNaV4ixB2MRE1Sug0GcpJg5J+043VUq2Gsqwq4q7EjrS+H2G8BPQl5R8Ofz9t1lzoN82p3L1YjUTWC7YKLleN+kyazXUe8DnJztGp73AioUjnMYXCQzl/AdcyFm5fwTyi2zRNkJ+vSknJJco8My2UROGAOwYoszrSHvRNWcxzjRihSnn21IvzKNHkeMVIq7fVO9cwUEtRvp+bKM9+ZMe99aI3BICcaohtRvuCnQGgtdslwLtXMMDf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(41300700001)(66556008)(8676002)(66476007)(66946007)(4326008)(5660300002)(7416002)(921005)(316002)(8936002)(2906002)(86362001)(38100700002)(478600001)(6486002)(36756003)(52116002)(38350700002)(6666004)(186003)(26005)(6506007)(1076003)(2616005)(6512007)(83380400001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EcnGkfDnBL1FIL6TKFH5Jvaq5DIb0F1AAJx2TXvcA00qALuirnEJIANy8fno?=
 =?us-ascii?Q?MhmsihGL/PUat5bcGC5eciVjiGogtkYVXUcqSBbQVagLU5KpbKV6u46u6iD0?=
 =?us-ascii?Q?Rkdb92UesMzpn9gVqVj4+3lMYgX9995b1+hqYHvLza3gmVx4SvgeUIauE4DE?=
 =?us-ascii?Q?SvQGadLHN05LSvzuETOYUaT7dwnGytNPWnHNn8BLxbi5WQijKOr+CEx7e/Pj?=
 =?us-ascii?Q?SlDtZ6mR0nx2CsQhUTr0xBbk2Jp+D74DpNhpy0XlGIKlOPX5Kfd22CXdnuI9?=
 =?us-ascii?Q?z4oIzbaSbNOvjVYETVZ9XuThrO6bD5jGH69QXxBcLmX1G3U2/OWEfWlE9W6T?=
 =?us-ascii?Q?iyNt18wBuY1P2NIxxXd/4B1uBk5GUCqtixBcfde+O9glr5S4JPyrWct8nBbP?=
 =?us-ascii?Q?7WsxQ7NhRhe14wNfEulVyOFf5yNIMaZ9RymMxgMtpKRo9VSGcyyNVbEi6YmR?=
 =?us-ascii?Q?Nn1rNWROKIQtO01bnpFf+nWHOTJM7PM1QXYCnK+hpPXGdeipzVCLH9LQeOkx?=
 =?us-ascii?Q?ZeAyfNz5pcadcPBmyPRteyT131CtWuN57uC3EZl6qU4+neUJnhl1QYDQmFCV?=
 =?us-ascii?Q?zn+5MRULnkHLbieCi0kpUxlOrMdOw20O/9e7/PcWKf+OBm9lo7e9/IFbh7Wd?=
 =?us-ascii?Q?/5qEYGd5mqeTw4v2EFnLBq4OuLa2LTW9bee3wVeRaqL0TvaSgkX3nmQxISLb?=
 =?us-ascii?Q?mhiwPl0I/IBaHBlEzpmMejBd08/tImPRBsgBQBih0iWKA+w8mjG+3G92Pg9W?=
 =?us-ascii?Q?43sG2oOkJEk11NbEsZh0owCTHMhifQ6agZwozV98rmLfvol6TAqjjRBT5rkl?=
 =?us-ascii?Q?2GwC5DnBv7zO/u9Nwbp209AtFV1mMnDSfLsTTAtoK9WhkIHkIixupG9IIsLY?=
 =?us-ascii?Q?JR56M8qMviVVjXHVXeNqcECkdXlrFj2k8lWcq59BGzbqNz6tb4Eh/SIzmt3P?=
 =?us-ascii?Q?532SdzYGx5tZYYE8Th3MLe+SfTjQkw2YGR+M3n5mb+PLZ/qZHwkNhQTBHheL?=
 =?us-ascii?Q?czhM+BnRP79JvCqFuLbAMgAsCwBHKjFCDWE/jk/g2H8aoWpl5XNHlkQl6RoA?=
 =?us-ascii?Q?vx38R0df9g7p6Pk4zedXQaJPmRPsvQfU42qS63aiFT1AA0s4VqMcnJh5S4PJ?=
 =?us-ascii?Q?nV40BXS7IVB3Rg5zwIeypYOAqpRZvx4UZcKi6q33cMsPP6QPruflYts+0BAP?=
 =?us-ascii?Q?g0E7+fISmrPb9OT5GjWDV0l6Z+mqT2YC1JfLjsj5LCt5eArYcil/GBQYbYTU?=
 =?us-ascii?Q?05X/A/npUDHefwq6hbezS3OTdK0fvMk3xiw6aEcz1HrjzdYvABmmq0h/nv/X?=
 =?us-ascii?Q?5ZE0XFyA+OOUTjGTPug6H+qs4f5TdaKp527Ov7Y0Lunfm8C8oBmhvGQk1SKO?=
 =?us-ascii?Q?tOpb8f7QZ+De8jrXZ2EjWKdahFJ5XVjwSf362iXWFV5WcW5dKHAtq3hvcxoH?=
 =?us-ascii?Q?oRmqhpJ2qBgNJ33vEOQquzUTqDCXw0JMXcEEPZ+CF5VUvHG0x9YJu2Wqal+F?=
 =?us-ascii?Q?yJkjkP099FDZPu8TyccsaYxFO1nV+qL/2MKc4CQxNznNKArNIoqlBG2PRH6n?=
 =?us-ascii?Q?GitEpqx1ZmGHUpdMkYK6N/hyS3X8yCvEGFHLbIkY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ffbb11-e8a8-4e83-f1fa-08daf5172df5
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 03:35:13.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gk4d/ZyVMdhCtpJjerWj+XcnOq7uPgOO5yIP6/vPVt9DGfONb/2Q80YQ7AfA1SdqlEQBBo/30XXo1CQ1FIsQdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable EQoS function for imx93-11x11-evk board.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
New patch added in V2, split dtsi and dts changes into separate patches
---
 .../boot/dts/freescale/imx93-11x11-evk.dts    | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
index 27f9a9f33134..6f7f1974cbb7 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
@@ -35,6 +35,26 @@ &mu2 {
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
+			reg = <1>;
+			eee-broken-1000t;
+		};
+	};
+};
+
 &lpuart1 { /* console */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
@@ -65,6 +85,25 @@ &usdhc2 {
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
-- 
2.34.1

