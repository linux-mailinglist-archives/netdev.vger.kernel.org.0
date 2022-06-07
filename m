Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91753FD2C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbiFGLQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiFGLQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:16:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03FD63DD;
        Tue,  7 Jun 2022 04:16:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWXqZsvV74i5iTu5DM+ct2klXuWO6mA9fotf3FjE5IjCOiZlFpjvc+vrfbGIlnBLRaXdyyltfIg3fpr8iFuAxcx14GObRez1W+3l8yw/flN+k7gs4+QsNfvspfNk+P04HDUyhGqaEExR7BGQjHhyg7NYYIDWvtILp1Eq60OvEU2MtKN999ogVE59z2RRXv+CgTAO5ssl5HqQALTOBxSHiL/Ub1ONaWdapj6Nwhe/4rrXKC6hUaV2/soDLOhPvby0GZ2GktKQ3yMudAhNDfFmVjIJpxH1oTczZfuBhtSsuzXdBFJltb0Kkwn8HZtRtkR9usBa9djQKHofgE3c4rOGCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgZvRMWMcezSaLndly7JE5KLG0bm9E4JFbjHBcr2pIc=;
 b=k5Ot49JJ00z4AhcuMw3AhI445CsGVuorQ8jVd94MtZTXvquTyH2oe86dOJiFlAXoCY52YkfZcPlzSPaBZ03I83Q56xuK/RZL6uLsca00hNXp/xRFgN18w9q0fKnQpmVf1L8EaQVPAfWwNElUpI7Il1t0YYlBYt+A5vA13lS1snHxLz/dqnjGjBOjizblh01kRb7IMbvFsyxcOKROYVhKXCh18DsoLfeu6xoD59D04VT0M1GaAdluuxWKkuh2BJxxoHVMTeo1o+Byonf/0nDTqc6zE5WoaKfvyFV4O8zyAbN8Nuqiq/coSyS3ggUQ9/7YDElBjNJFHpR01kv1jebJ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgZvRMWMcezSaLndly7JE5KLG0bm9E4JFbjHBcr2pIc=;
 b=ZZUTnwTgLqXUwUgym4EiyxwdnReOPM7xoL9MUiAT3m3qZG6HaBZqkUeoKJosr/QW/wpYfXVP92r94pYSCDdSu6ZQZiGDCwdrsHbXQIb6AUEWXZuYHyHziHudIQDErhWvqyQ3tk2+tjHi0D6gfqQ8QphKU4mOz9bOEOChzXx81Kg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:16:49 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:16:49 +0000
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
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v9 00/12] arm64: dts: Add i.MX8DXL initial support
Date:   Tue,  7 Jun 2022 14:16:13 +0300
Message-Id: <20220607111625.1845393-1-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d534e5ee-e1a7-42cb-fe05-08da4877375d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB489095A259008597533EDB94F6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHYENbEcLl74DewRAV1eLRHFZGK+xbcA9E8EKhodQpURNu8SMhwn+YQu/QRHpRwhV1bwI+MN3VsB0HdvUEI6CAIm5VDilP2nINUN6K0EleV1YaM3fDGzl1A8JJEV2mntJmnQljxu3cKP4sAoohq3rIOlWn0oQJYAHaJ+KptHEGOXlnA8sEPiJb9RAIAFosDqJ0zWkYQvqx/YSSAzW1fO6qouasGHhXETBhRjx6K8i6gKhQs1dS13kwH0wLCQUhPMPbwwTXAbBGENl/EuJzDps43kSWtjLpZa1XQ33mXX/Ophe65x9I2Do8rF/ndeJ14UrdWJjRcBaKHj6k8vRFSYST0MvsRi7v02J78UKn1YQj1Lk6AD8FfonMjCvByiUnsMXYdvYGNbtBRu04+ttIbFnvpCThUYf7y8S27fbVIkTO7Z0upIVXBc7jUcB+kAoQQsYOITtclEzdM3NXxapdU9Nqv1pBwqzObxdhyOHm5g40/c549DMavn6/4K7MP0Cw72D+zDGCXp8JGmw8Hqge/SvieIkULiGOsPyZ+xSGF8nOhtbAnhcaVetAv5T4zxVvZqG8fGFpdpAFHbcaWwzBKV5dUSZcOgdXWY9XlI7sB/uFWj6CT2B47oVDGJItt6auJoNXO5cthDEhDp0zTpeAQKsnYEIkq25qDjiSIsIkcG2vYAO+pnBs6Kumqztr/3Gpb7aXXwa3hG1KfIv2/ejlsjXRtHls9DCNYSnDBcsItB5KGKQuQICxcZb5sxRoLjUS9rjdcXP85SJATFAIMG65U7Z9O15cqetMtkhM64HQSCiHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(966005)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QS7u3Ce0GhFY69yyeDbY7f37tbKIBsYNl4NQaieqe8PrE2ri0kgDQc3HlPzr?=
 =?us-ascii?Q?aIwlWUwSdCJ5tY3nUlWwg3iq36tDl+45nzOQccaVjXalWMQ1YXyQme054HAk?=
 =?us-ascii?Q?ETw2tcWCzUG+6+scmU/zu2dgKYwFdWHIJY/vuJUUS++Ol6v3hFJdsW84s+Aa?=
 =?us-ascii?Q?t4WLsv/oxhLxcKsTlmr0Gg1HAhfGuIOQAk/7ya5NV46ChhEzl2mvG5aj9VTh?=
 =?us-ascii?Q?9jxYS8jdj9evPL9EYyfF9EbdbuzS4dE27zeKPnCdQ7hALNr2tEUE/TSfwYBQ?=
 =?us-ascii?Q?Tainf/XzsNj4qnZsmuyDVE5kQbkgWZuJSWqfbCWKE5dENxswTju6h9dQoBH3?=
 =?us-ascii?Q?ldRe8W3LYxNBWCpMpQzs1O6HMGqZ5bAkmwXYH/6pG+SNyArPY2ipYOFz1ihK?=
 =?us-ascii?Q?I22WGtLY8dk/6AtgVvtR8CAFKCeads/sDcb8U4D9uqm1bZ9yhKxf+o1eIQbs?=
 =?us-ascii?Q?JyQJtcNav/c8MnHOhFEJEoF5yjePNVRqt3Ewiq7jvmT2wmYfq27FGzg8zjS2?=
 =?us-ascii?Q?WYCkizSxSc+/Uqh2uYgIE5MOwszfovDYdU/yaIXEpeHoX366cJmHEggTbWyK?=
 =?us-ascii?Q?5SHkYE77nHjuWtTHS0h1Ptv6AWLih0Y4EjrcO8+kw3TtO6seB3bvbid8Gv7r?=
 =?us-ascii?Q?YyQCC1FqjQuLfhRkcA5FOFwTLGBWM7ntFxFPwgUgny26t+c1cd6IZZTvzi6n?=
 =?us-ascii?Q?0EQK5KgnD5H9ohd2OfgvxV3K2OrxF06UlBARICIsj+BOmv5MXnBZSA2xYu71?=
 =?us-ascii?Q?hFMFvMZB+S8Rb6oR0J7Z4ZhMDtndj+QoDvHfku757sVHYYIk33Pf4+Iz3nOp?=
 =?us-ascii?Q?UvD0qbALw2r+pBekyD5mreIShOjSnaXVuga9QObU7rFvEGyxdg979lkkhi1l?=
 =?us-ascii?Q?PDuGs1cLhgg5x5K7NTdZzFeeK7/5gMFNe9yo0XjAOv1EJPeW4TYXNXs8+546?=
 =?us-ascii?Q?IsP4Ob/u5BMyKONPhhiVmVAoobP358CV2JsWEzs1MfKxNUpjh87obNDZekFK?=
 =?us-ascii?Q?3niqCKU64Y5WeEHrJwVHdpBzEBMunx8SehCBFKSEIY+dDnkLx1v8APnjG0Ts?=
 =?us-ascii?Q?ia9T5BidRFloWp2uxslWp+9G2iKe/bbtRh8LsdAHAyUZBB3wJ8cPmLJrYl4l?=
 =?us-ascii?Q?Q1CYoqSmhSP6OKMTu4bke7C0DbDKA2VLVBSRyI8gIVdIWrX70Vtf7+GACkW0?=
 =?us-ascii?Q?PwxlFh4O8GeIKyKWMW61xU6OTlbU+SK5HFPP9YrfbCphozJ4ZtfHw9W8LPvQ?=
 =?us-ascii?Q?aeykyTuizl/0pgnPBpXdaJOW/gF0sJUnmq4iRd7xU/lYxaDkNXKWvQr07sY+?=
 =?us-ascii?Q?JdyDEmpOJ5LsYpQEGhOPCxpASz+JO5CI1ieAt/HQtxN8c1ih/2zmO0ThbGBD?=
 =?us-ascii?Q?o1s9Yd3LGixdLJt7DIdlquPgona5+2rgd2Q0uvNcgMtfWA2/i3Imn1BNcpWt?=
 =?us-ascii?Q?a/LymoksIfJYL7S/J2K29ckaHMLljFirbKUYZuxGYtzwsPi/kiWtTGlbaDrb?=
 =?us-ascii?Q?XDrS+w7Yh/rN+wfztaa8g+9vBj0JmS5HggSOVVNTnHZfiEdP4p1jBB+tX5W2?=
 =?us-ascii?Q?fPvglQdS05HJZQ3CIJ/VU3oeuNHY5Rfgnxg1lF0zMS36FN2POXHKrmYQoR9A?=
 =?us-ascii?Q?OS0/C2sQakGCDX4LfPlOKDHqKF0PuuMpVWPcq8B0iB+VHQscBX/ah47M0h9Y?=
 =?us-ascii?Q?x9VQUYjxk/4J6hJJEaKn54onOTHO8KcBKIIbto96KKHnB8wsuxZ1bySKVxe9?=
 =?us-ascii?Q?ANWtfCeGtw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d534e5ee-e1a7-42cb-fe05-08da4877375d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:16:49.5279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1m9Ff6Sp2MHz94sgR7hlk38tQFvMJNAg3tvYSW6mbE/19F3uQU9kplOULuDKh9JC1qQceUHjbkFd4iSWNcOP5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v8:
 * addressed all comments from Krzysztof
 * documented scu ocotp and pd in the yaml [1]
 * added Rob's A-b tag to evk binding doc patch

This patchset relies on the following patchset:
[1] https://lore.kernel.org/all/20220607105951.1821519-1-abel.vesa@nxp.com/raw

Abel Vesa (8):
  arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
  dt-bindings: arm: Document i.MX8DXL EVK board binding
  dt-bindings: net: fec: Add i.MX8DXL compatible string
  dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
  dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
  dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string
  dt-bindings: arm: freescale: scu-ocotp: Add i.MX8DXL compatible string
  dt-bindings: arm: freescale: scu-pd: Add i.MX8DXL compatible string

Jacky Bai (4):
  arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
  arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
  arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
  arm64: dts: freescale: Add the top level dtsi support for imx8dxl

 .../bindings/arm/freescale/fsl,scu-ocotp.yaml |   2 +
 .../bindings/arm/freescale/fsl,scu-pd.yaml    |   1 +
 .../devicetree/bindings/arm/fsl.yaml          |   6 +
 .../devicetree/bindings/net/fsl,fec.yaml      |   4 +
 .../devicetree/bindings/phy/mxs-usb-phy.txt   |   1 +
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt  |   1 +
 .../devicetree/bindings/usb/usbmisc-imx.txt   |   1 +
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   |  52 ++++
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 ++++++++++
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    |  37 +++
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   |  78 ++++++
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi    | 241 ++++++++++++++++++
 12 files changed, 558 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

--
2.34.3

