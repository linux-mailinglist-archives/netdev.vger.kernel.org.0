Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D80668A2E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjAMDef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjAMDec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:34:32 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF130DF5;
        Thu, 12 Jan 2023 19:34:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnFzZwgMNqTUqV3FYceyp9ea2Ihi/At6ePxc/+MtFpT4po62fT8v3GDYsXPzbCnWB+ko2mKVptf8dnzbXdHEsXzbIXiio6gXxsop9kkL8jAeWnMxV2HvN8Xe433MNQkJLT5FZmIR5+ITxo2ze3oM/EN8cZ94e8w4keR1sb/IqlTECk8fizRWFHl1loBvWboVBLKz5ewLFZNbIu7olzoKrljA6W9JHHpOe4/A9zZiszXubFu5Q/1Pot6NYAIz3RaWK2n/q3Em9P//xPsDEyt2oPNWHPsArn38mSfy7gZblnOK9niD0a2gZWm5ngAJVuk9F2I58auJjBel/dvh2sQldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjH8Ks5tcogILOJopFJgtunpf+oO424RJc5SXmvKM0Q=;
 b=UviHWrbDv2VQxFTZdxA5vfnqJ8QT/P+CQYZ4XtaXc0hm2mWh/km4cPEiIAETh0XjkeiUy7g0Ih2AWacEnsVrf2w/4ZjI1SipHBYtw/uBXu6+mawUyOrE4APT8zq/OwvOwRth1D5u8ZKEbZ8lQxDHodX9KClRyKjlXpWNZfrIhxjoqSwBF8z8fbLEKKDHla82qywD8AqaOrKlBXcxCA4kiujS+Mc8lVp9h3ls/+U9SAmo3eRmA+vC1KTefYHSRj4XkzT5xJhHKV6DTQjck55YETvyktdjXNnPs9ngM+yw2l3qaK247Qdpod7I40Ib61tyuC+ApRAAh2yxHZ5Zw5AFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjH8Ks5tcogILOJopFJgtunpf+oO424RJc5SXmvKM0Q=;
 b=aqqDV6l/YeGCC/Wh16XN60YuQtAT6usEAz5DjGNrY2HdaG1Kf8LRMlD6K3jvCW2T+c0t8QP5fZueb94EWjqy7aHQgnnVrTx17dGyfP9qsbFlOxxuRUuJPKjpYkA4fxn6nBwxCMmHpSaO9AuV0fjnYKXk+lIXpsc97oFNYY/0EAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8247.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 03:34:29 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%12]) with mapi id 15.20.5986.019; Fri, 13 Jan
 2023 03:34:29 +0000
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
Subject: [PATCH V2 0/7] Add eqos and fec support for imx93
Date:   Fri, 13 Jan 2023 11:33:40 +0800
Message-Id: <20230113033347.264135-1-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: f5c06a65-d70f-48a0-de46-08daf5171379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QlTUPqyTSdPXktw35AZiCLt1J8Yo53WzC2x8olzfQvC9TyDaRygS+mWKhx7FQL+pUrMc2SFyZdiHWPE9GFGjWOdVyuKWiKnbrs+svVEpkd/T+snIMzzH+5JXdacIljVDnXQn6rlAfsdMdvcn+b21RvBU5aO27KAMu5bNmCYT3PLUhfRZEQ2Tyd0Utwt+LyOXcMj/4lwOZSO5JMAE0z2yedl6v091lpTqmCZF0sVw/6AZn9GtUtOAn9NfOLWh+/h7c/waO6j6xefIjGZoI+mBFJQfKV3um5TKMGi61MbB9ej13WWDwy1VkDqI1sMqKB6YA07qlgO6XM8tADZMfC3tzV1FyqtwG26WR52IK+Kc4gevsJdKZn4gBv3YXP5NHEcIVbbrCBLIKLEiqb9lOXMQfSnEar3eqqO8FbBbLsPm996A9CVMKHYaoiB/ljHBugN1OLTos0yvBIXDlcaB+WutR5eqclxGzVN11UK94DZ9p0UTeaVdYlGjEYeVI90OeSbGmV/GdzqbO2nowsLmIr3rty3WCD0qOswFt6NPhKEI6AEKueymyX3MgNkacVn3nBwZsvMR+6rBvMfYONVXUwU7LoZMHBku9DY5bG3R5Cl8Onaz95r2VmGKc81KaKYcrd7uFFs27ZjESHOxLDxbr1B+bKAj1wZmMHyBQ/gxC3kvmeR+utIHXO4XqQSdnTzmG5r6R+/BlciErU8bIJaMl/GGwnDW8+8buaQefZTNF0wD/Xc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(4744005)(41300700001)(66556008)(8676002)(66476007)(66946007)(4326008)(5660300002)(7416002)(921005)(316002)(8936002)(2906002)(86362001)(38100700002)(478600001)(6486002)(36756003)(52116002)(38350700002)(6666004)(186003)(26005)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dzHP6DwW9K2hMxLbGaxxvhQDwLPs4dfN6AVkl35/ICIBxH013bE7lSXcLZ6o?=
 =?us-ascii?Q?NKlcCQ0CcD8LrePI+dLbYZAX2x/N5+RCGtkFyvx1mPBJRWcWElZlU7yV6q1O?=
 =?us-ascii?Q?R8vy5sH8vs6LJmZP34p6Dv33BeP9Ti0h9G1349pmwac9yN6zrN4/mST+sMe/?=
 =?us-ascii?Q?r3nLaHttHBg1GOxN8BtusA4MjcufNzmuIkX2rKMMixfSYqMB2Q2iE6xYeEe+?=
 =?us-ascii?Q?RNxOyZz1SFmCbo7OQoL9afJ5VK1bxcdtuEhjwXRcDA5BBeUdWzTZkaaMmjH/?=
 =?us-ascii?Q?KmLlp4faw+YKK/7clIttcmG1uPMKorZ1rNo9JWF7FKC9gQm2c79mbZJWjy4S?=
 =?us-ascii?Q?3arHcOiZBqNvqpp6fLvjuF0dzwyhINIR29pT8X9BSrccXECBf6VVlK4s4k0/?=
 =?us-ascii?Q?/48a4XruwupVbYj0rDlozmbwqL6xTfI53HtuDVGu236ORtLS0jhOiyOLkgFg?=
 =?us-ascii?Q?+iXL3C5dhopmMJY+UMp7xc4FvSPiXQBkAxGHTfiRdtowv5pTIzBN/ippQSD3?=
 =?us-ascii?Q?WqNzo5X9UZIV9Go/kfQOaZstfNjd45cafhGZ3AX13uyBUpCOyIL1BawteBb7?=
 =?us-ascii?Q?UUsamZJUxzWyAKh0L5VeLZB03FNljfGPWNSxk6/WMcUDmFveLeo5EH218B0I?=
 =?us-ascii?Q?S7uKV//KjksL9e2beK0wp7SQmVz8iApo+OAOcoq0bt9gxuTVBCrLr1nzfbfb?=
 =?us-ascii?Q?RJdCd1lZXH7JpownuFzy90FY+HM757iT9SOPhW7Aad3yTCfK1o0wI43b+Qa9?=
 =?us-ascii?Q?+2rimJiSTj1S/DTdcNNWAP3uVfkRxNI9ZgOemd4p3lHAObys3lacFzm/uH0n?=
 =?us-ascii?Q?qi2D9SuPRuJralH9JbE9RNRpciq1kNGDhwBY8d/HsK82yCL/XqGr4B/jmIz2?=
 =?us-ascii?Q?YepI2j6inqtkRMCyooRzHYH9DPMYgxaeHsNN49T6WQ6oiLALrfcKKD3mOrYB?=
 =?us-ascii?Q?k3LePKxE98Fp1RWlRjrFLeJjgj14Q8CHQjv5b4puGSC+vOUH2UcAtmTnb6ok?=
 =?us-ascii?Q?03vDu1RgYh2e6ScpdQiRERpQ4EfKI+s1UpUz9wtb11adWL1DwAMKvuVCOnRw?=
 =?us-ascii?Q?Y1AKTLuIxMPZpfQio8dVKjZ0XOtIbtpNqHLq9+OXOj143acOo0YyURcLVbDk?=
 =?us-ascii?Q?qcI6etqVnnapIUnHi/7DKdxQKvpEJluKRtpSmt0zr/XjdLUz43fUjrZyRgKJ?=
 =?us-ascii?Q?U8n7L0eYh3UPxfrSbY31Ms6WTCVez6vMuIOxsmnTJbBQjC9ytuiJjg2xckhf?=
 =?us-ascii?Q?9UGwbP8EtMTWMKmpX4gSQ+O/2PqbdiEzkDhAZCIOGGxyk6bIROc2YdQyJyxD?=
 =?us-ascii?Q?dqmciYEoA4vmXyaY88Lyp9OAB8iG2B6jsQgks+UdbuZCUigWTXwC/inJ360s?=
 =?us-ascii?Q?9ccz5nlyWazACODUDtaXM/YR7DpbogKVCJTngmHrb3oIl+BKuZFd/fm7sUDg?=
 =?us-ascii?Q?Nt/DO9oI1Qr/9b0hav893dFOPjmZPjpv85lWirHcfgTGu6qYCr3rEp3u3Giy?=
 =?us-ascii?Q?Cehel0Zdqlz6L0OoKLUOjOKMQHvn4kbVtahE6t6AeNweBlStKaBqtgLJ8Gej?=
 =?us-ascii?Q?jb6drt5MC6h+9w5IkuUnoDTSjTa13Awu2EZanmbSrw2UP5LhpbF4CzFXS2K7?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c06a65-d70f-48a0-de46-08daf5171379
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 03:34:29.1621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiFk4dGLti21nIkuoBWPWGON5War8iTxW3TOKErvTbDoEfqhbNPBnJbJz21UXWDTPI8D5OGdgjZte65nroxwyg==
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

Hi,

This patchset add imx93 support for dwmac-imx glue driver.
There are some changes of GPR implement.
And add fec and eqos nodes for imx93 dts.

Clark Wang (7):
  net: stmmac: add imx93 platform support
  dt-bindings: add mx93 description
  dt-bindings: net: fec: add mx93 description
  arm64: dts: imx93: add eqos support
  arm64: dts: imx93: add FEC support
  arm64: dts: imx93-11x11-evk: enable eqos
  arm64: dts: imx93-11x11-evk: enable fec function

 .../devicetree/bindings/net/fsl,fec.yaml      |  1 +
 .../bindings/net/nxp,dwmac-imx.yaml           |  4 +-
 .../boot/dts/freescale/imx93-11x11-evk.dts    | 78 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx93.dtsi      | 48 ++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 55 +++++++++++--
 5 files changed, 180 insertions(+), 6 deletions(-)

-- 
2.34.1

