Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76D2580BD2
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiGZGqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiGZGp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:45:57 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A03320BD6;
        Mon, 25 Jul 2022 23:45:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9hLSui0PEkuw2YPb4Ydx9kEPKpIFfAt48wP/12yHLTaC+RjyJGAskQiBPdwL/OHVFGY3XxxlOUCidmSQDIGjacjO6US1LwudjmcyjGjo7cv5sP73SGsBMUWiahCXcpwAPJ/tjKXBTxttjJmOJ4pnAZeDKISm4Ult9j9TN7HUQU3qYije+5lLgDbGOpQM4LlEAKxIw5ij2Ou7FPazZTxXn+mFo0FgM6+4t50woOadI896SeUa9zfHyHacYOFGsYIC2+Pfj8hJnw+alI10Zwfz5KNWbLy/bRhmcGq7u7HGILxCWvP5KXLlE6pTd7yOQLwI1LSgD3LAfsmRVkqh9ZQnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlXIpfRZB7DEn5CS+BDtMxj+y1o25GZe4aBuWpJ1QNQ=;
 b=dp1n88mP3Ou64ph0WEp/tO4ylzDrMCktYlqe+bVxEMXRsZw2Z9ezN13oDgblwqvjDrAYNDw9zxF3hIpzdaGS0TrPdkLi3hyGJEuTyevaBMiND+DMFX8FKZHMd6zeMT6zfO8dLfRW/ynUdhASd9TVHoEpY/qkKWEIpZ52TFIMrxCNV+U8V37S9iV6iaMHtSLIoVVU9LJ7Hxg9i0FU2W9n9NU4dzN8B1YW3lNfWYXS7anQU8UeJNDf/vebB+zgWWDzSgr+67BhEGTtc2AmvMKDgYuKUnL45W1FNntk9wOcDPO/zLvke/sbLBHoxZOmTDtAhSECFwpprmPjcERwjK2n7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlXIpfRZB7DEn5CS+BDtMxj+y1o25GZe4aBuWpJ1QNQ=;
 b=FQxoQ3wEGFpAt/L+vUWcV4KUasTfsw8mcs+XAKvto1cRX8yNNYi+fPq3bZXpbuXGDAmnaLl5j56W9CDJASmhW8ZDNEWhcWNIZw49MdCFfY1FSlNkNY5H0whLT4fWweezuzlfLorBZoTX0HiguFY+AuxIKnPG2wV/xlW7y2S2Imw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by VI1PR04MB3247.eurprd04.prod.outlook.com (2603:10a6:802:8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 06:45:53 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%8]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 06:45:53 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V4 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Date:   Wed, 27 Jul 2022 00:38:53 +1000
Message-Id: <20220726143853.23709-4-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726143853.23709-1-wei.fang@nxp.com>
References: <20220726143853.23709-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::20) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84325a7a-18e6-4416-e694-08da6ed27c21
X-MS-TrafficTypeDiagnostic: VI1PR04MB3247:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5lb0FggFwWOeQA+wYMG0ILGZLBf/ibSO+rQy+kC+HxaGBbZsx6zYlGs4xrIhUC/FmH0WeR44AHRM4euXcvspVALg3cJ6oPL1oAAOqq9g7lkRRm+IyeC+XuWahVk+y4MFrG9rmo+0PMAsoIk+62f+CMe3k264rpE6b1/LE6ZLJ2V8I328PhLkVpiVBUf5a7sKH6F8+M+LYI8BnRShdYa89KTwnIsLCisi3fA6HTONpOYj0EyA0AWOARtvaxcbUuSFvkgc8mPpV4EhUO6iIPK4vwKzPBxBLgykVR8WVU0hdP6FN31/ZU/qI+RUkmy/LxPMo5rjYIH27AlrA4XLQnskw232cfXVlLXygZnMTy0HdKHAGIQykDo3OwA5iqljjURMm94+vz7vd7ZjNWkei0+fo7AyEGJ1n2IYmgtzbayjOp22p/fQliDPgchPgbaUrrYqkYHbvO5wXF1dQmrItjhe2gJPyu67Qzz8urBwBl9T6EGitzXBQH3XHcGvdEXvt7d/ttrzzRXTqaHGNK/L2A/pLmwM/GtGm6lINXSd4OSsJ/AE9ZxmgprFgCOtbGuNreDN3OwLIJT1INkBGV8u7A3vezRjzjf2l1VYpwVoOQuYt2Bbg2Xxq+DvVBg/O6ImvnxJDHOm1H6YjFXCvelEQ50VL32b7ZgMP+Xdn+8kNxWXVqFdwZP3CPAMhxuWr5GxyAaL6MLe4aamyY0jT7P68whzPtaFQI7UhQ9Fq3rjpxJJmFuqoyfpCxWxER3bOxodPkQ+Q0LIQqQQaxecjZ63FyOcV1uC+czhYInBMrPTm2us7soQilm29C4IgKuFofcwltH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(36756003)(1076003)(186003)(86362001)(2616005)(83380400001)(2906002)(5660300002)(7416002)(4326008)(38100700002)(8676002)(66946007)(66556008)(66476007)(38350700002)(8936002)(41300700001)(316002)(6506007)(52116002)(9686003)(6512007)(26005)(6486002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hLlUKDKy7EJ53D8GjRGZpYuAEC8SBeElu2q7SB8egeiocqpqwQbyolaQC1lr?=
 =?us-ascii?Q?nczoTmjSwmP57RFfl0KP8vNeszpIxm+QCzypNAd5tXx+YFQb5B4DBakamR5r?=
 =?us-ascii?Q?Yxqgw16/xLXXn1ufxSyUwj4cV7ItMeu4FlzDIcjZn8G4yZLchZlr+eMgB7Af?=
 =?us-ascii?Q?58S077DZfy6cfJ3DASadpyoEL+KsXkJOLk+tGjt0UXgeN815eZKFj+hqzwgN?=
 =?us-ascii?Q?FSwY1O6Qy3vK77wSPM/rpNHBhFwGGC6lhCRIDePF4B88/obfi6Sx0pLjWL5l?=
 =?us-ascii?Q?iOrA2uIh4o2ED7+4mRTyzn3IYDhyadDLotuQRu956GN3+m75Yt36udImYg2o?=
 =?us-ascii?Q?ubb7h1fu8Fs/9cLTDDBE5TS+PHNVx7QPqd6AdexPEFotNJDldyMV4jUxWDu1?=
 =?us-ascii?Q?o++8XUc+vixgEmey++3758jeHEzeKhADcbK3vdyIEdXztoEtk0fmMtjNA0GU?=
 =?us-ascii?Q?sYAcOrJg+lwLpDBxC7fJTFSNvV87Zkhh/mqnk7L34Cp0YB0oU3S59LXpz5NN?=
 =?us-ascii?Q?rAV7pSAOJ7KXLdF10EPZ16ghNg9cfDzXp+AjWBddUKfBYV1lDxPGjHdNB5GA?=
 =?us-ascii?Q?zhoNpkR+gxEPUlIz5BrOvupZzag3OyTMDxlzyT4EKXc5yEHwOgnObboDCvaX?=
 =?us-ascii?Q?ev0PL8us7xC3lvPre+TwQbvkrdMzjWLYLgh1WYbVis6TdrqPMXeP2t5LfEKY?=
 =?us-ascii?Q?bIRQafKoDm18ronee9WBf0Wvf3mMNSWVkfBjnscq9KBAmqCy8Fsbwak9ltaf?=
 =?us-ascii?Q?L8REipdnkyTsbD7zlqlXyWZFsVjfoNc1Bce6BsPpwXPGz5jaCpyamHBYurMq?=
 =?us-ascii?Q?qGCWH3l0J2Ovqcu0GTtzaJ378BmvZ8+7Z/FBY1igsnsuGYpTRrdLswX1cad0?=
 =?us-ascii?Q?Z7KWEZ4bRZHQ4t5cwt/VPKoXDCXwQFqNpXOxGVHa2gvhdhDzFerKXrcQS394?=
 =?us-ascii?Q?u3SVqSTIsVDmjT+AFfTj5TA2YF/CRH0D118+jnX0y/iLn5rIWT0zU52Sfu3g?=
 =?us-ascii?Q?IKcsIaxN1jXOV8k/j5fhVT2zf5K4CneayTyv0z6Ws9PhFcxUwuSm1XNe9dwb?=
 =?us-ascii?Q?AdtOjbmhlxG5fcVe+L3la7Oxb/5SlkWcbj88MXyvHaa1mLvijz5A1xey/INX?=
 =?us-ascii?Q?8Xxni4VxZPPxan2IpbNUZeJTv573qWaT9lvHptkZy+H45TxBs/5/96kXwSCJ?=
 =?us-ascii?Q?9p5KxbwCL9nwEVJfVddDAtuT/OVPspD4FWZsMC6AI4GNWdFRFJ6lV/ei435w?=
 =?us-ascii?Q?ERUm+pDgzzb4Yn6gLKhUsf30YCQPpYUQYrr5DXafQ4GDvX1UJ0pryIU4xxyY?=
 =?us-ascii?Q?dYn9iYNRuZ1HqZkV3NobvF9kRZAf4ovdP8+IOvoxJP+ZZ0GVkada52AKniGr?=
 =?us-ascii?Q?scLChBHsloxy/MWC9M550nOj3IZZIoZyOuCX6hw03GoA5tbloSQGC5YE4CwG?=
 =?us-ascii?Q?a++oYkDm1ueqsnvS7viSOHXOhpEgjJyaGy7sZkCOrCfHNYeF/qxosNU5sP/P?=
 =?us-ascii?Q?6dkCoz5btUolLGyjXvkrRFBWuSnHZ9uefrcpOJwGJXPWcGCz3usGJWagNvUY?=
 =?us-ascii?Q?I3UsjVdy2MlMEvJQtE+DuP4Kj/jPtxU+Txt6XWy0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84325a7a-18e6-4416-e694-08da6ed27c21
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 06:45:53.2848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z02NgQ+FlQFzT8SMygi1KNUAvLVoHKgM/IvgjA31V06Tlk4fvp7iM33YqYcBXXJQr9csphOujgbEiit9m6r8aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3247
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Enable the fec on i.MX8ULP EVK board.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Add clock_ext_rmii and clock_ext_ts. They are both related to EVK board.
V3 change:
No change.
V4 change:
Add ethernet-phy address "@1".
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 33e84c4e9ed8..f1c6d933a17c 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -19,6 +19,21 @@ memory@80000000 {
 		device_type = "memory";
 		reg = <0x0 0x80000000 0 0x80000000>;
 	};
+
+	clock_ext_rmii: clock-ext-rmii {
+		compatible = "fixed-clock";
+		clock-frequency = <50000000>;
+		clock-output-names = "ext_rmii_clk";
+		#clock-cells = <0>;
+	};
+
+	clock_ext_ts: clock-ext-ts {
+		compatible = "fixed-clock";
+		/* External ts clock is 50MHZ from PHY on EVK board. */
+		clock-frequency = <50000000>;
+		clock-output-names = "ext_ts_clk";
+		#clock-cells = <0>;
+	};
 };
 
 &lpuart5 {
@@ -38,7 +53,49 @@ &usdhc0 {
 	status = "okay";
 };
 
+&fec {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&pinctrl_enet>;
+	pinctrl-1 = <&pinctrl_enet>;
+	clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
+		 <&pcc4 IMX8ULP_CLK_ENET>,
+		 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
+		 <&clock_ext_rmii>;
+	clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
+	assigned-clocks = <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>;
+	assigned-clock-parents = <&clock_ext_ts>;
+	phy-mode = "rmii";
+	phy-handle = <&ethphy>;
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy@1 {
+			reg = <1>;
+			micrel,led-mode = <1>;
+		};
+	};
+};
+
 &iomuxc1 {
+	pinctrl_enet: enetgrp {
+		fsl,pins = <
+			MX8ULP_PAD_PTE15__ENET0_MDC     0x43
+			MX8ULP_PAD_PTE14__ENET0_MDIO    0x43
+			MX8ULP_PAD_PTE17__ENET0_RXER    0x43
+			MX8ULP_PAD_PTE18__ENET0_CRS_DV  0x43
+			MX8ULP_PAD_PTF1__ENET0_RXD0     0x43
+			MX8ULP_PAD_PTE20__ENET0_RXD1    0x43
+			MX8ULP_PAD_PTE16__ENET0_TXEN    0x43
+			MX8ULP_PAD_PTE23__ENET0_TXD0    0x43
+			MX8ULP_PAD_PTE22__ENET0_TXD1    0x43
+			MX8ULP_PAD_PTE19__ENET0_REFCLK  0x43
+			MX8ULP_PAD_PTF10__ENET0_1588_CLKIN 0x43
+		>;
+	};
+
 	pinctrl_lpuart5: lpuart5grp {
 		fsl,pins = <
 			MX8ULP_PAD_PTF14__LPUART5_TX	0x3
-- 
2.25.1

