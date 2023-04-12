Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2046DF611
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjDLMtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjDLMtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:49:31 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648B0902E;
        Wed, 12 Apr 2023 05:49:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvVmphze+WI3/91uSXyQzhgpFi5tSLAxuNZl5VqNzMwjMfR6oFd57CKb4Ty2iGCC7KH0bEeXTOaoZ94Q3zPeEF7tKXNHrVP/lY0Toti1q37TKqkaK6+O5k/0wjugngH37xHasadtUTx5SmZluxwKzKcqxDPUPh7ykY2A2bECce6V0gH94Ut0BwEpcOpkNFR4Nnu9kkkLJo/GJlpRgxMcc6Qu4EDjnFb0qO45iuoc3wPa5DDU14ov4BWjaVZ27a6GvqfCc7eQ2HOrkDv3KP9DK9qEKvFSFSCIml5alydxgaUT6DaVKvswsW7cTs1ui995j1IN584rxJSgkPcs9uibAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svAK+bbox1JPdTCbwDQ2wcnYeISd/TP/86wtwXnG8Rs=;
 b=gDutUUv7bcfFTgoEliP6HeYXQ7P6ynQ7VIt3V91jmdGwXXvav5+TaX86Ebv0nzeNvnv8AD80ltVf3udUhffN5FDNyBikSOEcAzYYS9HG0jGfD52N9VY8ekA/KfqgqTFMv2TanWqi1BZ1VsOT5l1h7OtRBsygFj8+PWLa0qI4R/lYMHHC7qO6JH61kuNY4tseLqfmYYPEWf/CJ+qdWULBGYDzE2hp7pXIimcoWihvied1HXjUVK33BxppG467K+Bxowe4JYPDv3e8zL5rnDFlbNR/UHhYzr6ru/ogIKPMkRDCukDrwortIbxQlvBaqS5xWeI/pBfHnoYsTzGQLC+5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svAK+bbox1JPdTCbwDQ2wcnYeISd/TP/86wtwXnG8Rs=;
 b=IEjIAombJaoFTe/3htY+NcrFlYO7UW2Jt6LfD7e6Mp2icxfPiGOJhnqU5yWzTTUzbIL8qqwzReegR70dni1fothYRYHkdpdPRc2yzE6FuucyGf8ThUNK6CI+oluh0B3KPCHm+db3E6tk6rhmHCSvmuG4RtiLYXcbUmpEflIY0Io=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:52 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] Ocelot/Felix driver cleanup
Date:   Wed, 12 Apr 2023 15:47:29 +0300
Message-Id: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b07ec73-8e87-4b63-37f4-08db3b5420ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y43d4Bhv1S4BBaPHHaD2C8fntksLTVClu4X1+jmSg77I23bgEOIt7V8m6+xbwnztzkAF43OdiRvx2dRiVwBu0B4iVRZceMbkXjAvm/AnpTjdETJ84GZ080dGgOzZpU65GCc4xmgKTDba9CKZ+NJEzktw5AUCLvJ/bx0L1Hh2oUIUjNpTFlVjaW1G6vOfWURb37nk/Qepnu9UYyWs9eCxrqMw7CKadwnz91lZWi2ah0ytBfebqxVnwMCfz/dGKv1jvyAQuisRBTu+twIxU2ZXG1+ogF3ZeH13jInjoW3JhCIdpRPsI1beOINI89cHWmp0igN8G87ItZysoUeGxVI46GOukRGfpnZs7qQ02FnLQOw8jxbHoNkyOhaJptvn5FSHt8L6nt+WWePSb4OXjNRX9z2z+2Jgqe0k2KunH7YC1qqil6AuFY2cmav1czRkDkQh50JHpCXrGOlAyuNz7kb/9h0ZRugrjMliJPHyjjs8D/jNxIdPIeRzzv7cfzyiEwkaxsFVXzWZfzyQyq5hSMDfEBjiP5GaQWI85b6o7F0fhYl7+EJrnh5F5npobpROGu2ovl+B0pQGggrM5PNgVakWvr474wRe5ZimWi0iH8QlLwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(966005)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HAS/0jBDLlCzbv37P5DCi1NegcU8tRlgXRltNod6SeHUYgy6Vb86Fz6BqE8w?=
 =?us-ascii?Q?qk7gfma0npohBx6OzN3w4Kf365OzLg8QsR0L5SLKp0S8RPJZhOCflNKSMsR7?=
 =?us-ascii?Q?udh2kJcI5duSeDnZHPUvaIBNTj5TX/S4pazg725dki2VBRopr7nQlOh08m1G?=
 =?us-ascii?Q?5UN84jmx2sYg4AGihStY6i2KHHMZiskL8C2aA0VD/aDt7D5LW+d78GmLdOEk?=
 =?us-ascii?Q?v4j8COHZn3UUvKmygi9h9qmlTRvfBQ+73iJcqEXQw5X1eH4X0o+fRGhdzzns?=
 =?us-ascii?Q?34uk39mOlMKBHUp6Z/MI4BaZsrqm/QsdfvFMGl04Oo3u7YIStrxFiyCK45yS?=
 =?us-ascii?Q?iu1tzNnJ2xwe2UCUP5m3esphtjCuGaiASdQVaPvm4uWrM7Agg+zdO56t56aE?=
 =?us-ascii?Q?g+S6P/zFSn90WOBzQeNqQYDbZk1T1a+kgiPtTgpP0B1BucYInrkqqq8DJr6S?=
 =?us-ascii?Q?V62w2QVLLLrB5QmvZ/b1I1o9deqXGfjvAvGEGA4+qzLYx82bRS2vbRwGz5tH?=
 =?us-ascii?Q?gb8oTiN236Q/jFK91S7fkvsH2FaUVkGb3mztrOx10rV0ZKQiXo9/8tiUvop3?=
 =?us-ascii?Q?tCX3Bm0v8mTwh+/Dw22npnHb3v97XG4OK4DxGhmRiIkpXgnVwKrzJFELr/aB?=
 =?us-ascii?Q?5CgIUmr2z+17WyMRCMiWykGJ5YYeDaw1Ru3paEnztKIZDRX4D1lZP6BrHZyK?=
 =?us-ascii?Q?OnP/drIk2kTTL1ABfMFIOewPeMbdneGa6Y5M+lb2CGikoTz6R5sZ0/RIszky?=
 =?us-ascii?Q?sXq/EfqRl/w9WRfGS8QgCLuBfBiP4GXInUp+BXuxP1AIES9YYxr+tvEKNALx?=
 =?us-ascii?Q?8iIVPc2YTsqsZUxNqeyPVWP+JHA1Bj2XbT/y0fUDGdaGPPeovoTMYX8vX2dK?=
 =?us-ascii?Q?JzRyWH2ov1+DJdbE/3NoSjFbmrpI4DQZb6WOfnAPK2jvOE7DR1qjrKW2yICW?=
 =?us-ascii?Q?gUqBwCy5Do3RFtDY6dxgU68Fy4TwaQife01DC0NlpMvsGKrQJGcZg9b+cNi1?=
 =?us-ascii?Q?AYr08C/T6vUwj2lptvh1dLslTDwJTQTVTpwNrlo822Exkbf6Nila1cchJQt/?=
 =?us-ascii?Q?evhEShHEr0P71+l2T5SRO0og2feHUPSQPlFrBMXd2HmG/+Qr7K33ywKJiU0b?=
 =?us-ascii?Q?UPskh9QBlc/zRphcEZDB63uxP9VdWEc0jNKUmS5OwqqQ9WbLsTyyPCvwSvq+?=
 =?us-ascii?Q?c5e8OqdQOJzj5vaPVehsJZufzbWW8/kwwjowbp85gzPg2SRJl0WgIsdCSIaz?=
 =?us-ascii?Q?6Q8oi7F2S8YghhZa3vCtcqjPQm9btjKV27F7Nr0/RbAeYzIYW+FZx8pnhNPU?=
 =?us-ascii?Q?kZVQEPoyix8a0LJw09iY+00yjOn662mFY/ErA+e6pHOxLXdjAdzx2KYvDkeN?=
 =?us-ascii?Q?4WSbmB14+BLHsNdle6BtuaqkUKMyAf3C1TS24B1mAaKW5HOUKY3gZ6iW47Ux?=
 =?us-ascii?Q?reDcPVv6mUEO9POO5+UY22cCYWYEkGVSMILm5a4rteZVqVcdKe+EtnH/IFjd?=
 =?us-ascii?Q?z7sbOBtJkrFvNdZiYozHR5Y4yR2AAJnNVBYcoFIa1DhH1/6ka5eH4zn9latW?=
 =?us-ascii?Q?mtpCaph6I59A6tdprU1dBK84iMsDxooTwDZw8w9b55loS3SPXmZvvt5YBBcD?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b07ec73-8e87-4b63-37f4-08db3b5420ed
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:52.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcGm68RtcJ2DRrBcbkw/kvD3HvimIYfIep3pGhvMo24JgH92exsZVKtbpvpRYJWK6gyUnsNy1231JF70a9Vv9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cleanup mostly handles the statistics code path - some issues
regarding understandability became apparent after the series
"Fix trainwreck with Ocelot switch statistics counters":
https://lore.kernel.org/netdev/20230321010325.897817-1-vladimir.oltean@nxp.com/

There is also one patch which cleans up a misleading comment
in the DSA felix_setup().

Vladimir Oltean (8):
  net: mscc: ocelot: strengthen type of "u32 reg" in I/O accessors
  net: mscc: ocelot: refactor enum ocelot_reg decoding to helper
  net: mscc: ocelot: debugging print for statistics regions
  net: mscc: ocelot: remove blank line at the end of ocelot_stats.c
  net: dsa: felix: remove confusing/incorrect comment from felix_setup()
  net: mscc: ocelot: strengthen type of "u32 reg" and "u32 base" in
    ocelot_stats.c
  net: mscc: ocelot: strengthen type of "int i" in ocelot_stats.c
  net: mscc: ocelot: fix ineffective WARN_ON() in ocelot_stats.c

 drivers/net/dsa/ocelot/felix.c           |  5 ---
 drivers/net/ethernet/mscc/ocelot.h       |  9 +++++
 drivers/net/ethernet/mscc/ocelot_io.c    | 50 +++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_stats.c | 42 +++++++++++++-------
 include/soc/mscc/ocelot.h                | 20 +++++-----
 5 files changed, 75 insertions(+), 51 deletions(-)

-- 
2.34.1

