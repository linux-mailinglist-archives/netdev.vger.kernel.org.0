Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1327E57F074
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 18:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiGWQrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 12:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiGWQrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 12:47:24 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00057.outbound.protection.outlook.com [40.107.0.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22190B85A
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 09:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdjlsPsdRvO4azSwXz8bsPV/I1yaoxrNmfCjRvpFtCwtfRkcCE2m5VvhfaNOfTyPGnIkJHA0j1hPEj1D1aZbRWhMLvTt1WQxVqdNbHXVR+Nrw4VOh8tim0VbYNQRJlK0VjJeeqsIm38cDLH/yEcp2e5v/salQTubo4ZxGjmDw7o9BIS2aGKQGBRBUPFtf/QW8KawdLKr2Fd/Z8DM0wsD9G2M+YrQFTfXp8G/DXt6nxEvxR79dgM3tAjjf1iLc2PSByQpiHAw/jysL4piI4ymvTwovYfCGmlwh3apO6emVg3MOpxHA3OrK9iOVM28Hg3t63TyjvLT5YIrPu0jdUxz8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVDAq5nDy+2ygcCr6rGGByW1u9Dnpr7Atcxs/G9fNME=;
 b=QQ0vWvQ8XQ21+mM54ptZbm2ruIktJ8TE85J2IgbPFXAD/27HRUmA4enPBfPPhoTMAv6v6ejcSEEK4r9pojPynjjR1ItqGaeVhu1xXhzjibm4cJmlzM9JJ5wHxguTRl5asoXX5IE2Ood8jCoLOofga4HBWde3MZAyfqAcYKC34iee9vwOB4km40QkU8UXR1roeZrf5Ddh1BWkVx/Qnx7One+1/F875mMDmDE1GXtjjWVFNG4ZUm5Bx2IAODhyXAkUWm4rKXw71OtyDNqScULrm2DhWbIFh5IAG6nCg/hbCWSwrukFTtc9a0CTpWd0M2HXPN88FRHZc2fwJDQC+tZKyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVDAq5nDy+2ygcCr6rGGByW1u9Dnpr7Atcxs/G9fNME=;
 b=B0+B9x2UNevS3CuPOFBRkrBs1/+nOQ/0BSnOTgpYJNhKsYSTk07RWLMF0hwQyhVHd7P6XgKs1X8PTsguNnzcGgCWpFiQZ1Krv9XY8ssiugyTAhJs86/Z3g7OWq0DSk4WAffB4Qta36e/pa9eHOMviv0LCjCYGhnEiuRZy0yy2rc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4350.eurprd04.prod.outlook.com (2603:10a6:803:3e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Sat, 23 Jul
 2022 16:47:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Sat, 23 Jul 2022
 16:47:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next] net: dsa: validate that DT nodes of shared ports have the properties they need
Date:   Sat, 23 Jul 2022 19:46:35 +0300
Message-Id: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21d7cd56-67e0-4574-8f10-08da6ccb00ca
X-MS-TrafficTypeDiagnostic: VI1PR04MB4350:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GB7GXgEGpAPkZKQeG365W9vBUDk5RZp8hWF+vZyq1GzCjx3DHVNzmao7UuNBYkjXk2ycyO0lMrEx1Fof5re49OrfWYSivjEMjFb0YMSbMq70Newwpk39oND+XCq1MLTW5VG4qpxUcS75LlcoOFt2XLxOb2VPwuWF2GOrR2l/6Maui0KKEAB4cs5w3UpGoat4flbVTeHfMhxA9JFPMtLo6+pBH9L3iNzAafR/ilRk41OQ+2cc+vnFsR33njmsMimsIHlflS6tYjKZPhs94FI7s/Rz48s/xvzjf8W96AXsoy6no3Zt07APGCZK7rnkG7x/ZWRe3iweBh/W4e0qrUKUaMWxOH+58P3ZmR6n1B1jpcigaSZe/JgW50o/gdPRn8zdYtQLGpee/JACHuknoGQN4GmU3vm8IhJkscfgxKV2FeYMx/mo+1pz8FcXDnX/zYb2sxqqNQH7MrHMV+X/sEvn552WRhbr6VwXvBlQHCnfmzT7dEiDuzzr3CaWC63UQafsC9DRGVLQ/IUnZycLTRczvGiCkt6oMrgZPtAgb7dLukCd/ME9YcBBJ5cSNERhx7H9ttHFtr7iBnfTnTHq1TzVu0GBzOU+CbcnC+BNcvomUvRkFQmOw2uOFU6obLyff6ygxb6YQfwruLtK2NhzjtChV+7zc5f4XcxJ1qEAN/q0CrZP2v0Q4R021y4Oin+kD3e3Qpazh5xIdtnjTrppBSm5uXjqjPP4YnuD3N7GHkv0nxjn5hr+FwB+DiPRG56DyLWRgNEgH2+mhg0SW2KCWYnBngv3PBrW6a7VJuNZokovMJRxbIK9AwrU0agvH66GG6iLsT52RzdSjQvkX4oe+/u+UA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(15650500001)(5660300002)(2906002)(86362001)(38100700002)(30864003)(38350700002)(44832011)(7416002)(1076003)(316002)(6916009)(54906003)(7406005)(66476007)(186003)(66946007)(4326008)(8676002)(8936002)(6512007)(6666004)(478600001)(66556008)(52116002)(26005)(6486002)(6506007)(2616005)(36756003)(41300700001)(966005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AnaxFh9Foop8IaTbD0xzvX/qtcdrCyRGAcAB7k2UHCQD0byZFmBBZz0G99h4?=
 =?us-ascii?Q?NV20ItCLo3Co0xPuae7kuADfuhC9sMBYG0XuCGlPuA7W4lCvYTucefifNJ2x?=
 =?us-ascii?Q?KWW1RT4VFN2AhEN3vstfspuIjnKanzhVXqToWpnIfKK5/JJ0Mo+A1kRvOoRX?=
 =?us-ascii?Q?CPc7z9hkR8OD2cUPY9iPzujRu89+PSCutCScezdK7eQELQecAwOYKPt/g5hh?=
 =?us-ascii?Q?f+mdsslRsSaQyHqsRok5y/r5XUI3Oh7vvgHj35n+pa3gMtVTF4lBYAEygGz/?=
 =?us-ascii?Q?VZoIo6EfwfnfPHYVlco7N7SusqQnCvTYhYONnokFMZ6xJKRPoTXydzXLvPcM?=
 =?us-ascii?Q?p5dYpRSXEPpcyauaYQyyoQ+MH9BeFaAS7DRst/g24ufdX0lNVwC4qZb4fTG9?=
 =?us-ascii?Q?wN1jOntw1yb2x8sMbJyBbl325+65pRHfJGBCaLzEKS9Q6fg4LIqpFnh2HTkC?=
 =?us-ascii?Q?fo3Agn3eZi+xKx+jfXBDMcJr8v2rA1y/Yoiw91t3HxaHjJ6W4ZOE2vj92pQE?=
 =?us-ascii?Q?ziR44crjBy5CqtiX10h38GQgEiBnxM2iwA6UeuVLswpPQOo8pvIdTku4Ygni?=
 =?us-ascii?Q?t2DOTWAzuik34UGjHPvlKUo9+A/5sGhiWlQ2M2arrvko+4fphxGEMuwcQbyU?=
 =?us-ascii?Q?f1ld8wNSKNEMGrPFNOISVpz2HiDwEszcZPHI2B4/Mo681f6hV5KDUcoNxH0G?=
 =?us-ascii?Q?fgs3myGgRgISLMEOdIc+D1zigrgFdwjq4kG4Mw8nr1sUSY3kDhkMmqaW5gh9?=
 =?us-ascii?Q?kFNswhGCLLCQTxzcKC+VR0/81rjo74tSb26KdimjnIWt5etYq3/eqlUf931/?=
 =?us-ascii?Q?IjWkYU2H5kyAuNhA2CWzxW1n0bqX5GK33tHh3/LqTNA+AASPOTBgyXImL9U4?=
 =?us-ascii?Q?g87arBdCwC+ujHnBgBkBfh1OG5Aj9DAcIge6kUiAPi4qMbdpTVsPgUgTYiv7?=
 =?us-ascii?Q?Ir5BQqZiXCiYiTZnJucOnGGRXn62O3F6tGNWEk2yKCH46tbttY4oMp89TCCa?=
 =?us-ascii?Q?mQ2nPPsPvP/PjTMNHvgSokMkL1uQ6XkwPGt6nJZWryPyRp4xoK5sz8hHZqAE?=
 =?us-ascii?Q?bm2BxkHGf7TBc/Ig9rvDP32wbFgQ4eFrbl2OJlehfSj8ncW8TWlya0sCiIQw?=
 =?us-ascii?Q?s7L4mEiN5/CMlQOh0trAWYQV1/68YMIDgt5zbfDXZTd5Sx4ic+1w+NkNafzX?=
 =?us-ascii?Q?6McpTBBeuxj2JtbM2i7RQxs5qmd7mBrPStoHXqhGylmF5DfOahw8WOLGKn4e?=
 =?us-ascii?Q?RT/thtdlzj0yiEw3prEMlptnWsCazvqgJaDxccfS00fU3/XImXsHyNG3RUks?=
 =?us-ascii?Q?SM5PCrqpstIBKlZuXeIReEFqRjl0fG2Ss5sS3/IP7CqB8yUxMPEHqavRkk5R?=
 =?us-ascii?Q?NNUPRZBNWfjTDj5yD70FDt+vZgz0wdj7CyX08kb09imYHSeDPNZ0SduXZ4oo?=
 =?us-ascii?Q?afHi0pGNnKhT+3blUf5zKGpvWmECeyQ41Ph7yhP8ViMOzGxvW0HgpyptNitF?=
 =?us-ascii?Q?DpMqY087Dm6AT1HEAtix58nPDteH4/qwhM1ElE7fXkdZ5IoBaRXUg962veuQ?=
 =?us-ascii?Q?M6je+7sflu3/EBApV1T2O06jb/gwoOwt8ba8OvTrvq/eLIQJ26hJMZoUtxnW?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d7cd56-67e0-4574-8f10-08da6ccb00ca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2022 16:47:17.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvHbr2u0WOtNuRgvWjKsYhaqbTv61O0goK474fR9cAA7hOtu5KvyN0YuNi6667U6KuTjoHiOmqSaImmZqEw5uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4350
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King points out that the phylink_pcs conversion of DSA drivers
he is working on is likely to break drivers, because of the movement of
code that didn't use to depend on phylink towards phylink callbacks.

One example is mv88e6xxx, where DSA and CPU ports are configured during
mv88e6xxx_setup() -> mv88e6xxx_setup_port() (therefore outside of phylink).

DSA was not always integrated with phylink, and when the early drivers
were converted from platform data to the new DSA bindings, there was no
information kept in the platform data structures about port link speeds,
so as a result, there was no information translated into the first DT
bindings.

https://lore.kernel.org/all/YtXFtTsf++AeDm1l@lunn.ch/

DSA first became integrated with phylink for user ports, where the
interpretation of a port OF node with lacking information is different.
Then there was an initial attempt to integrate phylink with CPU and DSA
ports as well (these have no net devices), which was fixed up by a
workaround added in commit a20f997010c4 ("net: dsa: Don't instantiate
phylink for CPU/DSA ports unless needed").

The above workaround checks for the presence of phy-handle/fixed-link/
managed properties inside the OF nodes of CPU and DSA ports, and avoids
registering phylink if they're missing.

This is the state of things today, but what the workaround commit could
have done better is that it didn't stop the proliferation of port OF
nodes with lacking information.

Today we have drivers introduced years after the phylink migration of
CPU/DSA ports, and yet we're still not completely sure whether all new
drivers use phylink, because this depends on dynamic information
(DT blob, which may very well not be upstream, because why would it).
Driver maintainers may even be unaware about the fact that not
specifying fixed-link/phy-handle for CPU/DSA ports is legal for the old
drivers, and even works.

In this change we add central validation in DSA for the OF properties
required by phylink, in an attempt to sanitize the environment for
future driver writers, and as much as possible for existing driver
maintainers.

Technically no driver except sja1105 and felix (partially) validates
these properties, but perhaps due to subtle reasons, some of the
other existing drivers may not actually work properly with a port OF
node that lacks a complete description. There isn't any way to know
except by deleting the fixed-link (or phy-mode or both) on a CPU port
and trying.

There isn't a desire to make drivers that never worked start working
with these DT blobs, but rather to eventually move all drivers towards
using phylink on shared ports, including when the DT information is
lacking. There is a parallel effort to artificially create a description
for phylink for these ports; however it involves guesswork and may get
things wrong. This is where this change comes in: drivers which do not
opt out of strict validation do not need to concern themselves with how
to artificially create the description, and how to configure themselves
for the "maximum speed" mode.

We can't fully know what is the situation with downstream DT blobs,
but we can guess the overall trend by studying the DT blobs that were
submitted upstream. If there are upstream blobs that have lacking
descriptions, we take it as very likely that there are many more
downstream blobs that do so too. If all upstream blobs have complete
descriptions, we take that as a hint that the driver is a candidate for
strict validation (considering that most bindings are copy-pasted).
If there are no upstream DT blobs, we take the conservative route of
skipping validation, unless the driver maintainer instructs us
otherwise.

The driver situation is as follows:

mv88e6xxx
~~~~~~~~~

    compatible strings:
    - marvell,mv88e6085
    - marvell,mv88e6190
    - marvell,mv88e6250

    Device trees that have incomplete descriptions of CPU or DSA ports:
    arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
    - lacks phy-mode
    arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-spb4.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-cfu1.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
    - lacks phy-mode on CPU port, fixed-link on DSA ports
    arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
    - lacks phy-mode on CPU port
    arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-scu4-aib.dts
    - lacks fixed-link on xgmii DSA ports and/or in-band-status on
      2500base-x DSA ports, and phy-mode on CPU port
    arch/arm/boot/dts/imx6qdl-gw5904.dtsi
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-dir665.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/armada-388-clearfog.dts
    - lacks phy-mode
    arch/arm/boot/dts/armada-xp-linksys-mamba.dts
    - lacks phy-mode
    arch/arm/boot/dts/armada-385-linksys.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/imx6q-b450v3.dts
    arch/arm/boot/dts/imx6q-b850v3.dts
    - has a phy-handle but not a phy-mode?
    arch/arm/boot/dts/armada-370-rd.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-linksys-viper.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx51-zii-rdu1.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
    - lacks phy-mode and fixed-link

    Verdict: opt out of validation.

ar9331
~~~~~~

    compatible strings:
    - qca,ar9331-switch

    1 occurrence in mainline device trees, part of SoC dtsi
    (arch/mips/boot/dts/qca/ar9331.dtsi), description is not problematic.

    Verdict: opt into validation.

qca8k
~~~~~

    compatible strings:
    - qca,qca8327
    - qca,qca8328
    - qca,qca8334
    - qca,qca8337

    5 occurrences in mainline device trees, none of the descriptions are
    problematic.

    Verdict: opt into validation.

hellcreek
~~~~~~~~~

    compatible strings:
    - hirschmann,hellcreek-de1soc-r1

    No occurrence in mainline device trees, we don't know.

    Verdict: opt out of validation.

lan9303
~~~~~~~

    compatible strings:
    - smsc,lan9303-mdio
    - smsc,lan9303-i2c

    1 occurrence in mainline device trees:
    arch/arm/boot/dts/imx53-kp-hsc.dts
    - no phy-mode, no fixed-link

    Verdict: opt out of validation.

microchip ksz
~~~~~~~~~~~~~

    compatible strings:
    - microchip,ksz8765
    - microchip,ksz8794
    - microchip,ksz8795
    - microchip,ksz8863
    - microchip,ksz8873
    - microchip,ksz9477
    - microchip,ksz9897
    - microchip,ksz9893
    - microchip,ksz9563
    - microchip,ksz8563
    - microchip,ksz9567
    - microchip,lan9370
    - microchip,lan9371
    - microchip,lan9372
    - microchip,lan9373
    - microchip,lan9374

    5 occurrences in mainline device trees, all descriptions are valid.
    But we had a snafu for the ksz8795 and ksz9477 drivers where the
    phy-mode property would be expected to be located directly under the
    'switch' node rather than under a port OF node. It was fixed by
    commit edecfa98f602 ("net: dsa: microchip: look for phy-mode in port
    nodes"). The driver still has compatibility with the old DT blobs.
    The lan937x support was added later than the above snafu was fixed,
    and even though it has support for the broken DT blobs by virtue of
    sharing a common probing function, I'll take it that its DT blobs
    are correct.

    Verdict: opt lan937x into validation, and the others out.

bcm_sf2
~~~~~~~

    compatible strings:
    - brcm,bcm4908-switch
    - brcm,bcm7445-switch-v4.0
    - brcm,bcm7278-switch-v4.0
    - brcm,bcm7278-switch-v4.8

    A single occurrence in mainline
    (arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi), part of a SoC
    dtsi, valid description.

    Verdict: opt into strict validation the switch we know, and opt out
    the ones we don't.

ocelot
~~~~~~

    compatible strings:
    - mscc,vsc9953-switch
    - felix (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi) is a PCI
      device, has no compatible string

    2 occurrences in mainline, both are part of SoC dtsi and complete.

    Verdict: opt into strict validation.

mv88e6060
~~~~~~~~~

    compatible string:
    - marvell,mv88e6060

    no occurrences in mainline, nobody knows anybody who uses it.

    Verdict: opt out of strict validation.

xrs700x
~~~~~~~

    compatible strings:
    - arrow,xrs7003e
    - arrow,xrs7003f
    - arrow,xrs7004e
    - arrow,xrs7004f

    no occurrences in mainline

    Verdict: opt out of strict validation.

mt7530
~~~~~~

    compatible strings
    - mediatek,mt7621
    - mediatek,mt7530
    - mediatek,mt7531

    Multiple occurrences in mainline device trees, one is part of an SoC
    dtsi (arch/mips/boot/dts/ralink/mt7621.dtsi), all descriptions are
    fine.

    Verdict: opt into strict validation.

lantiq_gswip
~~~~~~~~~~~~

    compatible strings:
    - lantiq,xrx200-gswip
    - lantiq,xrx300-gswip
    - lantiq,xrx330-gswip

    No occurrences in mainline device trees.

    Verdict: opt out of validation, because we don't know.

vsc73xx
~~~~~~~

    compatible strings:
    - vitesse,vsc7385
    - vitesse,vsc7388
    - vitesse,vsc7395
    - vitesse,vsc7398

    2 occurrences in mainline device trees, both descriptions are fine.

    Verdict: opt into validation.

rzn1_a5psw
~~~~~~~~~~

    compatible strings:
    - renesas,rzn1-a5psw

    One single occurrence, part of SoC dtsi
    (arch/arm/boot/dts/r9a06g032.dtsi), description is fine.

    Verdict: opt into validation.

sja1105
~~~~~~~

    Driver already validates its port OF nodes in
    sja1105_parse_ports_node().

    Verdict: opt into validation.

realtek
~~~~~~~

    compatible strings:
    - realtek,rtl8366rb
    - realtek,rtl8365mb

    2 occurrences in mainline, both descriptions are fine, additionally
    rtl8365mb.c has a comment "The device tree firmware should also
    specify the link partner of the extension port - either via a
    fixed-link or other phy-handle."

    Verdict: opt into validation.

b53
~~~

    compatible strings:
    - brcm,bcm5325
    - brcm,bcm53115
    - brcm,bcm53125
    - brcm,bcm53128
    - brcm,bcm5365
    - brcm,bcm5389
    - brcm,bcm5395
    - brcm,bcm5397
    - brcm,bcm5398

    - brcm,bcm53010-srab
    - brcm,bcm53011-srab
    - brcm,bcm53012-srab
    - brcm,bcm53018-srab
    - brcm,bcm53019-srab
    - brcm,bcm5301x-srab
    - brcm,bcm11360-srab
    - brcm,bcm58522-srab
    - brcm,bcm58525-srab
    - brcm,bcm58535-srab
    - brcm,bcm58622-srab
    - brcm,bcm58623-srab
    - brcm,bcm58625-srab
    - brcm,bcm88312-srab
    - brcm,cygnus-srab
    - brcm,nsp-srab
    - brcm,omega-srab

    - brcm,bcm3384-switch
    - brcm,bcm6328-switch
    - brcm,bcm6368-switch
    - brcm,bcm63xx-switch

    I've found at least these mainline DT blobs with problems:

    arch/arm/boot/dts/bcm47094-linksys-panamera.dts
    - lacks phy-mode
    arch/arm/boot/dts/bcm47189-tenda-ac9.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
    arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
    arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
    arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
    arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
    arch/arm/boot/dts/bcm953012er.dts
    arch/arm/boot/dts/bcm4708-netgear-r6250.dts
    arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
    arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
    arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm53016-meraki-mr32.dts
    - lacks phy-mode

    Verdict: opt all switches out of strict validation.

Because there is a pattern where newly added switches reuse existing
drivers more often than introducing new ones, I've opted for deciding
who gets to skip validation based on an OF compatible match table in the
DSA core. The alternative would have been to add another boolean
property to struct dsa_switch, like configure_vlan_while_not_filtering.
But this avoids situations where sometimes driver maintainers obfuscate
what goes on by sharing a common probing function, and therefore
making new switches inherit old quirks.

This change puts an upper bound to the number of switches for which a
link management description must be faked, and also makes it clearer
which switches need to be tested using that logic and which don't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This patch shouldn't need testing per se (I've tested it on a validating
and on a non-validating driver), but it would still benefit from some
ACKs/NACKs from driver maintainers ("hey, move me from this camp to that
camp", or "I'm ok in this camp, thanks"). It seems a pity especially to
opt out of validation just because we don't know what DT blobs of a
driver generally look like.

Don't be shy if you aren't in the MAINTAINERS file or even copied to
this email but stumbled upon it; some switch drivers don't have a
dedicated maintainer of their own. I've selected some people in CC based
on their past contributions.

 net/dsa/dsa2.c | 172 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..f1ffdbdfd6a1 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1360,6 +1360,167 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	return dp;
 }
 
+/* During the initial DSA driver migration to OF, port nodes were sometimes
+ * added to device trees with no indication of how they should operate from a
+ * link management perspective (phy-handle, fixed-link, etc). Additionally, the
+ * phy-mode may be absent. The interpretation of these port OF nodes depends on
+ * their type.
+ *
+ * User ports with no phy-handle or fixed-link are expected to connect to an
+ * internal PHY located on the ds->slave_mii_bus at an MDIO address equal to
+ * the port number. This description is still actively supported.
+ *
+ * Shared (CPU and DSA) ports with no phy-handle or fixed-link are expected to
+ * operate at the maximum speed that their phy-mode is capable of. If the
+ * phy-mode is absent, they are expected to operate using the phy-mode
+ * supported by the port that gives the highest link speed. It is unspecified
+ * if the port should use flow control or not, half duplex or full duplex, or
+ * if the phy-mode is a SERDES link, whether in-band autoneg is expected to be
+ * enabled or not.
+ *
+ * In the latter case of shared ports, omitting the link management description
+ * from the firmware node is deprecated and strongly discouraged. DSA uses
+ * phylink, which rejects the firmware nodes of these ports for lacking
+ * required properties.
+ *
+ * For switches in this table, DSA will skip validation and will later omit
+ * registering a phylink instance for the shared ports, if they lack a
+ * fixed-link, a phy-handle, or a managed = "in-band-status" property.
+ * It becomes the responsibility of the driver to ensure that these ports
+ * operate at the maximum speed (whatever this means) and will interoperate
+ * with the DSA master or other cascade port, since phylink methods will not be
+ * invoked for them.
+ *
+ * If you are considering expanding this table for newly introduced switches,
+ * think again. It is OK to remove switches from this table if there aren't DT
+ * blobs in circulation which rely on defaulting the shared ports.
+ */
+static const char * const dsa_switches_skipping_validation[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_XRS700X)
+	"arrow,xrs7003e",
+	"arrow,xrs7003f",
+	"arrow,xrs7004e",
+	"arrow,xrs7004f",
+#endif
+#if IS_ENABLED(CONFIG_B53)
+	"brcm,bcm5325",
+	"brcm,bcm53115",
+	"brcm,bcm53125",
+	"brcm,bcm53128",
+	"brcm,bcm5365",
+	"brcm,bcm5389",
+	"brcm,bcm5395",
+	"brcm,bcm5397",
+	"brcm,bcm5398",
+	"brcm,bcm53010-srab",
+	"brcm,bcm53011-srab",
+	"brcm,bcm53012-srab",
+	"brcm,bcm53018-srab",
+	"brcm,bcm53019-srab",
+	"brcm,bcm5301x-srab",
+	"brcm,bcm11360-srab",
+	"brcm,bcm58522-srab",
+	"brcm,bcm58525-srab",
+	"brcm,bcm58535-srab",
+	"brcm,bcm58622-srab",
+	"brcm,bcm58623-srab",
+	"brcm,bcm58625-srab",
+	"brcm,bcm88312-srab",
+	"brcm,cygnus-srab",
+	"brcm,nsp-srab",
+	"brcm,omega-srab",
+	"brcm,bcm3384-switch",
+	"brcm,bcm6328-switch",
+	"brcm,bcm6368-switch",
+	"brcm,bcm63xx-switch",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_BCM_SF2)
+	"brcm,bcm7445-switch-v4.0",
+	"brcm,bcm7278-switch-v4.0",
+	"brcm,bcm7278-switch-v4.8",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)
+	"hirschmann,hellcreek-de1soc-r1",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_LANTIQ_GSWIP)
+	"lantiq,xrx200-gswip",
+	"lantiq,xrx300-gswip",
+	"lantiq,xrx330-gswip",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MV88E6060)
+	"marvell,mv88e6060",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MV88E6XXX)
+	"marvell,mv88e6085",
+	"marvell,mv88e6190",
+	"marvell,mv88e6250",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)
+	"microchip,ksz8765",
+	"microchip,ksz8794",
+	"microchip,ksz8795",
+	"microchip,ksz8863",
+	"microchip,ksz8873",
+	"microchip,ksz9477",
+	"microchip,ksz9897",
+	"microchip,ksz9893",
+	"microchip,ksz9563",
+	"microchip,ksz8563",
+	"microchip,ksz9567",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_MDIO)
+	"smsc,lan9303-mdio",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_I2C)
+	"smsc,lan9303-i2c",
+#endif
+	NULL,
+};
+
+static int dsa_shared_port_validate_of_node(struct dsa_port *dp,
+					    const char *description)
+{
+	struct device_node *dn = dp->dn, *phy_np;
+	struct dsa_switch *ds = dp->ds;
+	phy_interface_t mode;
+
+	/* Suppress validation if using platform data */
+	if (!dn)
+		return 0;
+
+	if (of_device_compatible_match(ds->dev->of_node,
+				       dsa_switches_skipping_validation))
+		return 0;
+
+	if (of_get_phy_mode(dn, &mode)) {
+		dev_err(ds->dev,
+			"%s port %d lacks the required \"phy-mode\" property\n",
+			description, dp->index);
+		return -EINVAL;
+	}
+
+	phy_np = of_parse_phandle(dn, "phy-handle", 0);
+	if (phy_np) {
+		of_node_put(phy_np);
+		return 0;
+	}
+
+	/* Note: of_phy_is_fixed_link() also returns true for
+	 * managed = "in-band-status"
+	 */
+	if (of_phy_is_fixed_link(dn))
+		return 0;
+
+	/* TODO support SFP cages on DSA/CPU ports,
+	 * here and in dsa_port_link_register_of()
+	 */
+	dev_err(ds->dev,
+		"%s port %d lacks the required \"phy-handle\", \"fixed-link\" or \"managed\" properties\n",
+		description, dp->index);
+
+	return -EINVAL;
+}
+
 static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
 {
 	if (!name)
@@ -1373,6 +1534,12 @@ static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
 
 static int dsa_port_parse_dsa(struct dsa_port *dp)
 {
+	int err;
+
+	err = dsa_shared_port_validate_of_node(dp, "DSA");
+	if (err)
+		return err;
+
 	dp->type = DSA_PORT_TYPE_DSA;
 
 	return 0;
@@ -1411,6 +1578,11 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	struct dsa_switch_tree *dst = ds->dst;
 	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
+	int err;
+
+	err = dsa_shared_port_validate_of_node(dp, "CPU");
+	if (err)
+		return err;
 
 	/* Find out which protocol the switch would prefer. */
 	default_proto = dsa_get_tag_protocol(dp, master);
-- 
2.34.1

