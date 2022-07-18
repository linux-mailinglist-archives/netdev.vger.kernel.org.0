Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9301577AF3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiGRG2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiGRG2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:28:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC03140F7;
        Sun, 17 Jul 2022 23:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpjxP3v1CJWJHWyCjL81H8uKN3xoxLMsMoLyYabLqCHpQgQw3zZ9eP4VA7reVTFgcF2rJDKkeozOQaZU/3cVWggEzYCLHNQ6cskJIeqkQ+cO8Y0HrbiJTkaJUHJqYn6AOHjofekd6+n7u4dNxHlTt2W7+LVQAgK0ZDDbFXaCZfoHFitXq/FX7YiHj8XW+Hy8blz4MiQxZ6J2C/yT+APnmVQ//p2xH8CqUN0GWdl0j6hmev3jssjBPtxblMKqcLJa8WDuxSM2/rKaBkSuAeEbm7kdZPo+iHaCT6X661nL0X9Jc4BqdOghYwa7qa5dF48bDqR8l1EtvKHybae7W8czcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e32YoqYJUzntvyRkTnhTrXn8Pyy57SuHrjriNNp2l5A=;
 b=IIjp1TXnD2+LMrWrcFocvARij5ZsVRB9X0frQD1fXGE+XauVgTOv+87xdgVSyKRlX4Eq+gDouLKmHZPJF3H367XWnP9yAtBrnycS+3Z3L/VUuKUK7e9u+/nzQvfLIVdy+MSBs3r4gpXOnG0PwDt60r8xdIkd24Fnd0KW4qEIvGTTRwb339Kqu2u6/0N7LC/bQLHfKt225IoIGimM2Cld/Of1f+QDPfwWrFBeWeoD1I015qiw4MkQWSAOYaKJ7k+nwV/2PEQCp3+XeBY1itzUWLm7r7cqUkxoWMp8WJwjg3xE3JRxbzQ+x35Ig6++KIcOS0bbX7H1oBqSAKajjSx8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e32YoqYJUzntvyRkTnhTrXn8Pyy57SuHrjriNNp2l5A=;
 b=s0kIaCLYQG84005J3flrEUfKTyt4DO45tmjf13ex7nyDlnoWMG0x1G4ywLwZ7QfecSXGwkLy5qvjubF3kFHksqbfxOODUUn/vjs4HN9tpIV4uJONOrUR5BjJf3zcpsTurhh0uXLtVdxXUMKGo4L3SD3FcaTk4CeeFucu5/P9UjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AS8PR04MB7704.eurprd04.prod.outlook.com (2603:10a6:20b:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 06:28:34 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 06:28:34 +0000
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
Subject: [PATCH V3 2/3] arm64: dts: imx8ulp: Add the fec support
Date:   Tue, 19 Jul 2022 00:22:56 +1000
Message-Id: <20220718142257.556248-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718142257.556248-1-wei.fang@nxp.com>
References: <20220718142257.556248-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KL1PR01CA0118.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::34) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e340b059-683b-42c8-bce1-08da6886bd4e
X-MS-TrafficTypeDiagnostic: AS8PR04MB7704:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVBgl7C8j4Gx3tkfsjFSJY0IrsOvHghjjlFJEFF3SgX3pISc0325JHBLsShf/yKsivJxL7NcQd62DvxBNZF837xz/s8lSHgAb1Jb2Sja4JtKqLhTyvk3PjSdxizmFEO4xobje7zc2R1gxkD5FG0lP5A+Yv+p6JL6ff3NazSKIpxOo8LO8TqU6dRChKHHnQBvgRef0JBdmAeyn960z+VGCSrwUixwWDHDbAKylaE4ZmDYF/h9FZYlcTG3WPTpMIPkMpJcETTgMSO2VBTBk2HJc4J5wkrXTG761K7xJPc6PCAQfIj77zPJ/zY9AUbPwcXx5NCJ3Hul9koJUBABRJjLYMU+x18/hxtaTZsKtZd847ydGZrqTQv9mPu2F3CbanRtLjOKtYjhGODLWvaqJHnnAC0t/RuwHpLeqEOHAowPsQZaNllL7kzlZGqzrngwnb1Y81/EX9HcxpK9pRPLyYt6kDwTIIbh1uMUDRbE376CyaGjD7KhaY4QLCPmnHZ0X4AIotHXFQ6xSH1Ik2khaXmNeWQNQdOIARt/n8Jj9iIqqjfwHy+4LP3o5G1nLCmw4Gg2ydsiYORP1bYAdUAQTizj1QlYvTAWIW6aC7Fylwvb3JRzmuFaP4xzY4k8D2JBZuOeeNNqu5ebDxfm+Wi5swZNCMgmS9+sX28vxu44ILmRjnPsv2XydAfHlYDnfPKMADhM/NNEQUOi7ZfKINevipvt0YS+t5kz+X1bO8VIqQJnW013zc4Iv8CTQrgwJQywa12Gnp1RQkc6l2fb7/Sp+rTRre3rwuzA6ZNcW7M2Q+iPDSrRWQPlMlISQUYuK/hxG6xGdEfFTi2ABqjdG6XDrCXjJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(6512007)(9686003)(186003)(26005)(41300700001)(6666004)(2906002)(86362001)(52116002)(6506007)(478600001)(1076003)(6486002)(7416002)(2616005)(5660300002)(8936002)(38100700002)(38350700002)(316002)(36756003)(66476007)(66556008)(66946007)(4326008)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?stTw3IAe3DDULnZEe7AZYtTu6kbJYgjbbagB//TjEBpQ789DHSwmIsuSy/jx?=
 =?us-ascii?Q?Z/DCMymFzHUnzYSOwfj89ez/UNih7lC3gOxmK8hRfctoHVWM3WVBB8zIIbzz?=
 =?us-ascii?Q?wOr/4kz1FY5ZSDzvMJpK5uKtodlS586/aVjQkoj4GwtSuQCHD1JQI/ZNqwfx?=
 =?us-ascii?Q?FGNaK8rJbaBV4YuUDcE2HidEH/R8iELRaLV5aBCO5X1ld0UrCzeUVBkTqja9?=
 =?us-ascii?Q?aDmS/VArL5db4eVeoRiP+cpBeIX+e+3S7gcTsYHmUkpgC0WNLKcotceYlDLM?=
 =?us-ascii?Q?QS9RAkwLC8WcmIQ7MJ5nVLKqWa2xeFSXqM2jePJdr/4d+u61d5tS3vcUfysL?=
 =?us-ascii?Q?pVUj6JcgWGvQjXsLZ9GhUpFtHQHfYQboSnVHs6RK1A4upe5Ma1WaJrN3i2AN?=
 =?us-ascii?Q?7Hhsq7SKRMT7qoRAYpxbOkCSeE5Jo0f4o6EprsxCAO/0D9oqdZ/ZnKITJa7r?=
 =?us-ascii?Q?KbRqifquwh3OtGMEhJobALdOUrsXMjzMintzmuf8ejSE2pAK0khywPYXccRv?=
 =?us-ascii?Q?XVModS2tYLhI5MMA8iEvM6yz+Oke1qZNYw+dSz61ZH9+QKzMqGFaXof6PZLq?=
 =?us-ascii?Q?eWSj8ElvoxampmH+De57HFfkwgo4A0TYGH4AP384xvoJ38XXZfhw9WytC5el?=
 =?us-ascii?Q?oTQ8d/iLL3P/3yEut6hjEg9ahyHrM4YEtkQDfWLMv2zmst4ntS0h7J9inQTH?=
 =?us-ascii?Q?dHKJ6hMVZVQgMaGOluKP6CjoeIjqekMK9zWX3zBA2m+mA/8mDTOBlXmlHz95?=
 =?us-ascii?Q?3LbP/8zazOe/2y8oILWI9gBEqolLZPj9544obscoQ9tEGDHFEJjcvzh+vNiQ?=
 =?us-ascii?Q?Y6fmJIZKWOlIpwqM/DgUBA7o8K/mVZpne2iyyO8qKqktSAQRqkHmc5MU/R9D?=
 =?us-ascii?Q?6QsXZrzDmOvJw9qpY5qvrfxUtDKh+enR0mLUw8PYpLIfBMwYrzwUlybXK9Or?=
 =?us-ascii?Q?Hk+8kwTQb1451JHYJnzohPUqCjhRbwg75c9zJxmkXiQjOPjJi6FZXDhZenEA?=
 =?us-ascii?Q?7RCtOyB5+xbXrf0/KoNb80aZ25t78KtRNEL3LoznbB5EGhjO6cihMAl63pfg?=
 =?us-ascii?Q?wctKpCenangQ80Nj8LnwC4liS1i6a1e2Y7G3U6MrClUaNO8mL5WTNJu5Ux9a?=
 =?us-ascii?Q?n+hCzexGxAmlwGLcLmvzaGMtKgnT/wzRX8d+poa2cQM7bKd2oVLcYdEuttc+?=
 =?us-ascii?Q?GgIWosNnqoUZC9lj58ccKZL2fhQUxuAzpTkQHv/3tbKuMSPqXs4gRIApTL9w?=
 =?us-ascii?Q?DlXmMLi29izCRzXtQBVjyrKYck6xVp4cNKXfSmgA5o1UtLk0Ki5Hyh0q7QCP?=
 =?us-ascii?Q?DDGPMQQf6o8KLDKLgxDd1zGNelYVBqUpbJUv9T69pCy+22BrrS57WLr1h1n3?=
 =?us-ascii?Q?Xht7iFzzgqGHxp4bkwKQ+9H8Ws/scaCLR44Bno5QOJ8nxZPCjS75nZ2gjEgf?=
 =?us-ascii?Q?KQiRLuSue9GVVHXTHFcRzkgeFL9OFsFXHA5oK9X5xvDjsqS0XRrSuh5E6a5h?=
 =?us-ascii?Q?1tfuEZia/mFHP60D8ewiXWMHWMfcXJY1IcFcBvp6a3zHisaDB5dgKHhR3URF?=
 =?us-ascii?Q?IQlsgA4Yvqm+HVqwvdtyaQOlhH3irJ9NOukdZAof?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e340b059-683b-42c8-bce1-08da6886bd4e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 06:28:34.1368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NN1Km0nDdO85+mWkQzuqmcEHTLeysXDNhqApao5QxaDt2pWQjcYQUmMMamWjtyl3ueqIan5eRsJxm0IAFADnYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7704
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

Add the fec support on i.MX8ULP platforms.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Remove the external clocks which is related to specific board.
V3 change:
No change.
---
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
index 60c1b018bf03..3e8a1e4f0fc2 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
@@ -16,6 +16,7 @@ / {
 	#size-cells = <2>;
 
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpiod;
 		gpio1 = &gpioe;
 		gpio2 = &gpiof;
@@ -365,6 +366,16 @@ usdhc2: mmc@298f0000 {
 				bus-width = <4>;
 				status = "disabled";
 			};
+
+			fec: ethernet@29950000 {
+				compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec", "fsl,imx6q-fec";
+				reg = <0x29950000 0x10000>;
+				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "int0";
+				fsl,num-tx-queues = <1>;
+				fsl,num-rx-queues = <1>;
+				status = "disabled";
+			};
 		};
 
 		gpioe: gpio@2d000080 {
-- 
2.25.1

