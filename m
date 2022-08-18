Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F308A5982AF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiHRL4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244407AbiHRLzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:55 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2074.outbound.protection.outlook.com [40.107.104.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DDFADCEA;
        Thu, 18 Aug 2022 04:55:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8k+AxzSmr6HNUyEfZNDXc9eTCh76T3oCLWj4krSPA5sSDHjOGX2kA3RfmsjUdQn/+R852GFRzQUj40Ha27VXxZUqncZ01kExYWwGYd9NHMs0712YP5trXRQX0hxrf+gj77CiYs44mksqM0uoseN7uUyHcts0X6fw5nxNcvwR6jNg/5MH30xYJwhQlSpGd9TKFgyde5LLdh4SeR7hgvCy5pR/XcLsDJdcBJp7v3Z3sVmiA2QoxfvjQ8mg5xtA0eXFltpQEuFWvz7WFxNp4+I5dcco9xrfAYMiu4FoppqLT5l2UfWde3Tc+J3gHKf9BRTu2apqSjNiLJFOgz8C9WJZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2/5YnvgL0FSAHyMLHeNOmVoMMYKpAEtD4Ix+stmxAw=;
 b=MpdPUUnjwMfzEuXhgDXhM4r9e6EAFztxb/oMqFq64M+1RQ8MEEdW2hGEl27mE1qZYDxvrprMunfQs9XvB9f4vQBXqbCN4QORRFvLxxATsBlc1HrJWhrsZv5qPoIe9YRFWdJgVk7VxIS1p/xKJjrJgu8vZLbHHJdu2L0cvT+DGeqYDyI4VakeyLdOJDG5VLO80RuEtC6gRWCV+uAJvMPBpJtlp+oM6RFslcRK3X74t4LlNMZhaY7WlKvbRql01bBk0O8aJs1D4kzXPJa9Zs2e2xlmpOl4zJxenhM/TD6K7KYqj+tA8Oua2YfWQ8OxwUeM9RsERyKcUJyQSpTs1SmZcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2/5YnvgL0FSAHyMLHeNOmVoMMYKpAEtD4Ix+stmxAw=;
 b=YA70/7FzzMiOnXrteo9zKqHT3lt6s0nz2D67aDgB3P/GXUqrqY2Wk60ikqcw7s2bly2eoIz2bZb2JvCvdp727p70gzHS+lEtINJlzl4+9OzURtm2FmzEQi9mxhzSgH3dLu/3S7QD8r0ZDMep6C7LrH8pQ4k5+yAN8kHwlkDPosA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v4 net-next 07/10] of: base: export of_device_compatible_match() for use in modules
Date:   Thu, 18 Aug 2022 14:54:57 +0300
Message-Id: <20220818115500.2592578-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
References: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bdda304-0653-4996-172d-08da8110986a
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbMlUQAKvoiwK81ecIQmvqUSUpFO9wRL22dmgp5CmMsT5+zhsSROkmUfEAZQdzYdejrgP9cKJuoqdQu0Fq6AW+vEhh4eA64Op7frX/qkKHhnFfnLgakFXprHTS1lXjGrqJbeMavIZEnjDc1Td8S67DVkPES5PCa5fMSVeFAPupPBeFeaBh20YluG5hM9Z1rkEIJ9hKrY9kXHTMnlQltwVUq++RV/JaxfSdSZBS4N5mXO0yOyls4ruBlXJZS3WPFGtRthEtJTgu+nsKSYH3d5BbdjK4I7MVLoNNj16vRanKAmKRsFM3jaUFZnC8QnkafH0XpBRq17dYasXUx7lFHXro/IeLDD7boQcaVBSsPG7dfcUJjwhfAk5KHUZF9Xhp5kLGyTPaaisQUC2R3+jRFScQ2l2k/gNCk0l6WbXrusur2URqbKgtTxu7AXHx87C0EENnujJdPZ7cB83mY4iQrMFF141h0mfGNe2mmWZqFrNbekS1XgAsvqa90T/bjp7VA53yeKuNbNoaETgdAfAuE1sxe91G72NEi4OqBUQvXnefWSYDrM76tPNXKdjESZj+dt0UXQxLMC+cl2leAecd+aQNbYV3d1yobvlowVyZ08//+/f4HX0ib1l44TyspMVWGXJSGGPX3ZyCw7q8YjZDG8KqCEvJyi5B1z1alhRRxyFShEwA/TT8jKNuQPefHCMoUeVIKa4wmpBN7M+3ZISSEIN4Eqd8yRialJLhm4hgEcnaO9mivSaZgy1M9571tDoJ1N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6512007)(186003)(6486002)(52116002)(83380400001)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(4744005)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Id50Yl41MN6mDekdutIAK1VJarupwee/FkSs8OdbAGpQfOoEK+PqwdsrYyu3?=
 =?us-ascii?Q?+oInIjUzCEUqvVIlhJ+rOskOxTnY0P/Es6kEEZezU3yn8zVOuHx5F7HOVdZ7?=
 =?us-ascii?Q?Xl4QZ8mgyZAW8qjdWcvSgM9FxvwHnuo5N+p7m9JBxrsmNYMknhxggyiKhOKC?=
 =?us-ascii?Q?ugQQQjAr3PUubWhWBCATmdLhbmdgdzkxt1f8Nh3EN2prytCzUbLPZxzxJMw/?=
 =?us-ascii?Q?QQ9uT5I5Ey7VEwhR4om46tZOHH3tcvtAhPwRcrS9fMZfHU8eTMDVfihWnR6b?=
 =?us-ascii?Q?SWwLlSL0+CDP9apbETvVU6GID2iCeV4LvZQk2m9tLUfGcPCDLFZhQYGb1v76?=
 =?us-ascii?Q?KU7ZZ0wGAAp2BkroY4iFBc8wyiRxDkQJdAnrUd6Ls99TgGk69XxVdmev/cjq?=
 =?us-ascii?Q?Lm+J+JCSJqpXwEMfLkzepvzmHIEf0gDJ/2Hcd0kQVgt5COWXAO74ydmJJFoG?=
 =?us-ascii?Q?/WaTNfyoa1eMx7Rg31YKO0DeleU1hNLA/1vhBZ2/LCgas9xtuAQlr5lUZizi?=
 =?us-ascii?Q?qv4hS22bvVNDiuzJ6yVwdcFmHKJry5PcOQ6afO2AQjFISrq++7U8omqQtypl?=
 =?us-ascii?Q?9V6FRzy2/CU9hNugT78HEXQQqIUgCbNOKab8DfZmDLT/DxZp9cn9odbZawu1?=
 =?us-ascii?Q?1nZcn5qHQZP+wwX5FKdl3FWN6oJanWQECPC3mqcoQnXonFt1yXMvGEOCVJPe?=
 =?us-ascii?Q?cAK9Eb2T7pTseKaA/hoRvZbfC5lD88JmwjTvq3cpvgBVeUmwC0iLp10tRl/7?=
 =?us-ascii?Q?KJ/TK+XdsoHAAr/FKre/ePGDi9mVZqSHLWId7klH243qE/dsI2G/5kXZmhNK?=
 =?us-ascii?Q?Y7nuPy5QBIn/v+9p1hfeFhF7j19IEUixYUXnCrOxhfTsQtbapqHXIl1vR4u+?=
 =?us-ascii?Q?fNrqrbA9wOTZJLYDnQhh2QK+EXPlkQpQzyZY8nFqt2LlSpmwrDgBoqK4tKkg?=
 =?us-ascii?Q?uqc59IK2CpF9A3/xV2ABeecpoUMe1+hUn2LZI6lHPtNZUqVsb4It/wx2cAMp?=
 =?us-ascii?Q?CeTE8LyZkyqYX3aWp482rSWBMe+ncNoJpP8b4Xmxo40gcad/ILZ/V9jHW++d?=
 =?us-ascii?Q?j3j9b+qot+/Bh4De+Sas3I6OjMtMdwJqNsmjnQYRf/bk+DFQGPxAwvFtgLBZ?=
 =?us-ascii?Q?NmTUePBw9W6dzu4nXvtAo41bGqOl07YQZlfJmm1SJ71OVp6DewvLytocvP0H?=
 =?us-ascii?Q?SLKfeHxuoYSibo9AcMUyRDA0pRCPqXAKUs9JJxhFDM6qr3GJA1RQJCUbZWGD?=
 =?us-ascii?Q?LRiWUXpJerap5nSedCD9NyeMRlFn9nQYIPY5nqMDqYy0Bm6LLg/dbxGefI+3?=
 =?us-ascii?Q?8Q9mYylLI57uLyvDSPaCIGCsketQgqpEUxKC71gcBqQRvwHtmqPzoQUS6gx1?=
 =?us-ascii?Q?KdmFN3UzsfTSwrI9Hk6z4/aiOSblqHccLnXtfdyVF2hc1eswUhC/LXrJpneY?=
 =?us-ascii?Q?+n1VYHupSxjeB45BVzF4b9+LNJz5icINUyUfvNdqXpfMDKOYSV8BmuOPCM7f?=
 =?us-ascii?Q?vU2/QVUVkfk2w3V9dtVVKISpeZTv/Y+gBfCHSWSawMq/taxq/gb5mO/w+QOO?=
 =?us-ascii?Q?yHRnxp7HBHibexW9LJBT25vRPbv0f5Mm49zoMDlAIp/HNz7o50BJZqNCAHdW?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdda304-0653-4996-172d-08da8110986a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:50.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKeA22jB+ivBLbRPF2jnrr6FtAC7WT4MEC7HCuqNtlNXhnQddWgNyMCdFJkFaChafQlR3FGjvUVxqoSbZr8ZAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modules such as net/dsa/dsa_core.ko might want to iterate through an
array of compatible strings for things such as validation (or rather,
skipping it for some potentially broken drivers).

of_device_is_compatible() is exported, by of_device_compatible_match()
isn't. Export the latter as well, so we don't have to open-code the
iteration.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v1->v2: patch is new
v2->v4: none

 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7fa960bd3df1..42da760e0f45 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -578,6 +578,7 @@ int of_device_compatible_match(struct device_node *device,
 
 	return score;
 }
+EXPORT_SYMBOL_GPL(of_device_compatible_match);
 
 /**
  * of_machine_is_compatible - Test root of device tree for a given compatible value
-- 
2.34.1

