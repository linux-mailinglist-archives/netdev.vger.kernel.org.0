Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E98A595DD0
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiHPNzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiHPNyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:33 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10058.outbound.protection.outlook.com [40.107.1.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B534D254
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UML/eS/de1d2Dc/9AttSYZosY3su/GXXgHQkxIeBAw8Q5MPV1PRdbvJcKmGh56RYbJ9swT02iz6Igfom+oV5/F1cW6MVatg1ZSniZVHDWyCCHB2+a0uxCjP0OQ3NrtBBWKWpZPRMTqVN8hrAkUITkzo4cOzgMiIm+oSsAbM4C1UOanZug+O+ql48Y8Mr40yZt8HXe7qgt30cOyjM1i1FsNY34NgAsYumz4ta2qptEN0a6ER/qPPIoPMGVWBJSzhFeBgVKDjDWgHDmzDxh9IaQ5aPyFBYeMxkazhD364rCzVamYi8kD5tVCSYamFdb667wDq+fGW7BMW3TCYTqmJNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpZSwHgEsohabM32XmTLHf1+wFV8Ttxw4pOwYNudDJY=;
 b=L82GtjpeDFMiZEyBusQ5SPg5N09VyPKzZQlhhLzHV2xBiFQnkpY0DjT9bfW7Mj+2pkV8e+zUplwmRc+iH+a6ClgbOYZUIXo7nwa4LjretKSYn7yExN+28Rp1hih+GXf+scpuorJkZswcrQL9Tu/T2RXsYQ4XueB2/XiEev8RzlOlFAuxQ76NpV9cruvJEFW7SswDGe/nnGKPqolWDECPHQrSRr+/9X+pnaw+ScrG9Ee8S7DcRSdBc4jB+ByJyHzh5Mnnvjw1vsKInHWgKceA+MPew/jXU1qbQL34UDIl0JxwLexReqnwDIDwpm9XCSaaMjjXAheEtWneajqari/LeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpZSwHgEsohabM32XmTLHf1+wFV8Ttxw4pOwYNudDJY=;
 b=Ra25Zvr2T/gYmOkJ6Huzh7z3D8lQFoyrAnlUx1R2EyBsF/rqBhiP6YNyQBseh2OZ5L5QprvcP/6b651/Htdy+XJE3oFgXqkX3iKUbhZmnQWa/smd7SdtibvyeM4fUgKijIpGWn+4RWLeBnIRIWv8NP/fGtz7zkLJ9Qvw+g3XitY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5702.eurprd04.prod.outlook.com (2603:10a6:20b:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 13:54:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net 7/8] net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset
Date:   Tue, 16 Aug 2022 16:53:51 +0300
Message-Id: <20220816135352.1431497-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed44a2e1-3a4e-47cc-73f6-08da7f8ed0a3
X-MS-TrafficTypeDiagnostic: AM6PR04MB5702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPvH2usppS/P1VMDeIaLgrOwTsVquRlx0yT5dagBAaIrthdcJNLg18+fWa8rzj+oo0P7dneGmBgZ9loFEqjBHC+5y6GnjtAazZZ16jiQ3K9744HJxmzq6/ofnV7uS/8Ti1EnN93wZhqDqpCFGhJWUKnXDWarXduTtgVGqX3nDKWJeCDrBpnQyq0+8j/xLk0Za3J6NRLTP9ZVaVbS8qZ8Dt6Qw+VLNuEcrGzuNfkczbWcR4Qng3v6Fyloyho+124mkQMI+qMJoCIbXvkJr2jPkt8Xxm3Znr+4sFDFO1d1tkaOf7MwH4Z58AhLd0IeUbZQoHZhBR7FSWikR0kvwhv59TbOFJtpAsH0dasqaccS+i1psrujqCYTEKBBK+9R9oEiHL2BcVk647SUd+pEITfSGYJkB6LFOJcWcnPWGjGK5gy6KhCgzbEAY4byCNfNOpNkmj1cCT5Mzx343XvR4x6EMV0Td5BvhWVlPfTyxSvWTTRCGA+intvA+264wHtJs7kmGPnhuZzxksb246a49Tk3XOXwlHvAAeFVedbESP0ZIg3HhtEhznxdTUheXGMIKmjlAwmPn4moNDNOZFd3SkP58UUUmUABUG48MTZOIafEaFippZyFj1GUba+ERQZ/Lu0RkxW+K/Ow+7HTX/vjQdI356qO6N3JjKr2UIWRzDUXNlwyH/iYpj8T3lhTfEc6xpwsgr7Tx+b/0IJh45nraNCUrt65RLZlFF85UGxA+HOYBUzFomtJ2SdRkidph/MJTcNGMrIIsPYQd+iZTjs4Hjb67WFG5s5Fwu6z/KQdVMfe/ng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(54906003)(316002)(6916009)(83380400001)(52116002)(36756003)(1076003)(41300700001)(6512007)(6486002)(478600001)(7416002)(2616005)(186003)(6506007)(6666004)(5660300002)(26005)(8676002)(66946007)(2906002)(30864003)(38350700002)(66476007)(86362001)(44832011)(8936002)(66556008)(4326008)(38100700002)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EBNskHqkF24W/yV75CPwGmTuMDIPrUrbWMcg+gy11qUd8M+6bFT5gPLqKQE/?=
 =?us-ascii?Q?R4tQZiKb8aubinlBNvhK84bMlgRw7fJmZ7/DtHs4SIncle/6UiUIh12mGeSV?=
 =?us-ascii?Q?geD1QhVfpWr0wgI9r2X8Q+0DR8cKpWiElld8fGZqnyy+al4jgAaFzKjq5sNe?=
 =?us-ascii?Q?Z68CO2Tnz9UWJeI7gfp4o7dF867y1qOEY5MwLwOFIwqgVsTa89PhKloM7PBL?=
 =?us-ascii?Q?qC1HFQ+tSvsDTHEMN0y3j9hRxPe0DUu7AIfhDLxKrb5AEY0hUH2iDMU9Ip00?=
 =?us-ascii?Q?PvMaTBinpjyPbv2xCWwEtftaJ2ovnTy2+TFD9ANwQ0TG5Y0k4OAip+qvS/mr?=
 =?us-ascii?Q?e/e3acr2BauVNNvzLpECnuewD5oEpn99pWRnunCH5vkIPn0qHkMf/c5imIkR?=
 =?us-ascii?Q?SSLB55l1GhPRXShdGXAcLYhvZy8iHgGDL5iOItEKrhkEo5zM1G6RnfYDO3NX?=
 =?us-ascii?Q?UX9dEZv1pGzBAvRZTIjD3+yMvkKT7acEcmC0CGtz+o6WHBxmdzBBkC09qcEB?=
 =?us-ascii?Q?33lCsRjcdWVfthx6HEgB/ZjHJMgH3Z+NBz+730PSAc9kAYhPQ2ojD+j6tIB/?=
 =?us-ascii?Q?yIjbbx3p72b3xN369FLkliQK5AGOGMXIOCC4cN1kEkr41x2KHRSGBlTB2bTm?=
 =?us-ascii?Q?PqKqePPC430Hfwg0rfjbw1m/ZRRrkJM/rYO1PhBYV4sAUQtY2slJPguYWWnT?=
 =?us-ascii?Q?FuFHqN66wzywRzlTukBGEQZkWmB3STXAbDZnKjq7sa8SC1Msf1ZX/rKv1w99?=
 =?us-ascii?Q?pd9Nfv9ZKxaN3EPtvuO9DQKG7ROuEwvgScsj6/+Oi7uj8P9i5SAWCeuKcF99?=
 =?us-ascii?Q?VBMwcTmeECHUwHb8oxFFqP0tryrPlH6IdajOg3Fx1iiz+ivDhRj6N+z9oQdF?=
 =?us-ascii?Q?ahAKv7Cl6Tf6bdqW+JfTKldf4EetVxoZln2uZfAvSHApfL5lygmzBcfJrhW3?=
 =?us-ascii?Q?0zG9zfxM++hCl9f2Znp+WU9FbGeWWEAeXaxq8LWC6p9EamKHvfBw0sYcaPV2?=
 =?us-ascii?Q?z9Rgw5DVT7/rnGP81+hqRioL8dsm2z0rCg9TnzsOsoCWRNJFUPLgGf43RQ7X?=
 =?us-ascii?Q?0/X22H5Uk16XMWWKrQ6LUIHgUzuDCJkVtNZ7UYRLPj1wkcqWzKnMt6znfLne?=
 =?us-ascii?Q?KKd+LkqZCSwETsPvcrSOE1EP6RiQuFUfwBm7wTagpO2vNg3Fu9Y8WRqIfYe7?=
 =?us-ascii?Q?nxapwNiwdeWaOAVlMEqs9zKNuMz5zPWJ2/ZSW3msp27NqtN/TT2EPr/mScya?=
 =?us-ascii?Q?Wxgw6saZjPZ/4PhWj3pRoeumluv6lFtQedVFhYd3Cn7HUB5axglshocPJx9n?=
 =?us-ascii?Q?HEjapJrQaXtzcha+7csEF4RLx0ymxMpxD6ywVXQYlM54pgBrOTLFnAmcYRLg?=
 =?us-ascii?Q?67QGKWLgSqtjuBo9nEGUK27LVw5DTu+8WHkePSfzbS/l4OuT7bq5aiQrUPsU?=
 =?us-ascii?Q?jiHEQNJ4dr4AGB0s0sYchJr7f+JJ5zJWHYp8e162TlQTMV70gAVo9QPGnegj?=
 =?us-ascii?Q?Md43ygy00BXieFpa1q/CcVaVZ4RlKSaNzmjFexeLHIidVOod492v/IUICPYr?=
 =?us-ascii?Q?N9BRAC3nNJbTLAHfQzxbziSyHk4IYqWRcQ2ziyWt+657jl7WBK1CahDkIabi?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed44a2e1-3a4e-47cc-73f6-08da7f8ed0a3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:19.0990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alCYlzEYfx8aNwVGk0kMPX7zzbh1sZzVlLfOQBoVWeqvaLF05ms3QE+wRrkooYphl32DsG6lwxtsw9h6J6GvcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With so many counter addresses recently discovered as being wrong, it is
desirable to at least have a central database of information, rather
than two: one through the SYS_COUNT_* registers (used for
ndo_get_stats64), and the other through the offset field of struct
ocelot_stat_layout elements (used for ethtool -S).

The strategy will be to keep the SYS_COUNT_* definitions as the single
source of truth, but for that we need to expand our current definitions
to cover all registers. Then we need to convert the ocelot region
creation logic, and stats worker, to the read semantics imposed by going
through SYS_COUNT_* absolute register addresses, rather than offsets
of 32-bit words relative to SYS_COUNT_RX_OCTETS (which should have been
SYS_CNT, by the way).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 253 ++++++++++++--------
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 255 +++++++++++++--------
 drivers/net/ethernet/mscc/ocelot.c         |  11 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 186 +++++++--------
 drivers/net/ethernet/mscc/vsc7514_regs.c   |  58 +++++
 include/soc/mscc/ocelot.h                  |  66 +++++-
 6 files changed, 540 insertions(+), 289 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index c9f270f24b1c..1cdce8a98d1d 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -274,10 +274,14 @@ static const u32 vsc9959_rew_regmap[] = {
 
 static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_RX_OCTETS,		0x000000),
+	REG(SYS_COUNT_RX_UNICAST,		0x000004),
 	REG(SYS_COUNT_RX_MULTICAST,		0x000008),
+	REG(SYS_COUNT_RX_BROADCAST,		0x00000c),
 	REG(SYS_COUNT_RX_SHORTS,		0x000010),
 	REG(SYS_COUNT_RX_FRAGMENTS,		0x000014),
 	REG(SYS_COUNT_RX_JABBERS,		0x000018),
+	REG(SYS_COUNT_RX_CRC_ALIGN_ERRS,	0x00001c),
+	REG(SYS_COUNT_RX_SYM_ERRS,		0x000020),
 	REG(SYS_COUNT_RX_64,			0x000024),
 	REG(SYS_COUNT_RX_65_127,		0x000028),
 	REG(SYS_COUNT_RX_128_255,		0x00002c),
@@ -288,9 +292,38 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_RX_PAUSE,			0x000040),
 	REG(SYS_COUNT_RX_CONTROL,		0x000044),
 	REG(SYS_COUNT_RX_LONGS,			0x000048),
+	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,	0x00004c),
+	REG(SYS_COUNT_RX_RED_PRIO_0,		0x000050),
+	REG(SYS_COUNT_RX_RED_PRIO_1,		0x000054),
+	REG(SYS_COUNT_RX_RED_PRIO_2,		0x000058),
+	REG(SYS_COUNT_RX_RED_PRIO_3,		0x00005c),
+	REG(SYS_COUNT_RX_RED_PRIO_4,		0x000060),
+	REG(SYS_COUNT_RX_RED_PRIO_5,		0x000064),
+	REG(SYS_COUNT_RX_RED_PRIO_6,		0x000068),
+	REG(SYS_COUNT_RX_RED_PRIO_7,		0x00006c),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_0,		0x000070),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_1,		0x000074),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_2,		0x000078),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_3,		0x00007c),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_4,		0x000080),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_5,		0x000084),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_6,		0x000088),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_7,		0x00008c),
+	REG(SYS_COUNT_RX_GREEN_PRIO_0,		0x000090),
+	REG(SYS_COUNT_RX_GREEN_PRIO_1,		0x000094),
+	REG(SYS_COUNT_RX_GREEN_PRIO_2,		0x000098),
+	REG(SYS_COUNT_RX_GREEN_PRIO_3,		0x00009c),
+	REG(SYS_COUNT_RX_GREEN_PRIO_4,		0x0000a0),
+	REG(SYS_COUNT_RX_GREEN_PRIO_5,		0x0000a4),
+	REG(SYS_COUNT_RX_GREEN_PRIO_6,		0x0000a8),
+	REG(SYS_COUNT_RX_GREEN_PRIO_7,		0x0000ac),
 	REG(SYS_COUNT_TX_OCTETS,		0x000200),
+	REG(SYS_COUNT_TX_UNICAST,		0x000204),
+	REG(SYS_COUNT_TX_MULTICAST,		0x000208),
+	REG(SYS_COUNT_TX_BROADCAST,		0x00020c),
 	REG(SYS_COUNT_TX_COLLISION,		0x000210),
 	REG(SYS_COUNT_TX_DROPS,			0x000214),
+	REG(SYS_COUNT_TX_PAUSE,			0x000218),
 	REG(SYS_COUNT_TX_64,			0x00021c),
 	REG(SYS_COUNT_TX_65_127,		0x000220),
 	REG(SYS_COUNT_TX_128_255,		0x000224),
@@ -298,7 +331,41 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_TX_512_1023,		0x00022c),
 	REG(SYS_COUNT_TX_1024_1526,		0x000230),
 	REG(SYS_COUNT_TX_1527_MAX,		0x000234),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_0,		0x000238),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_1,		0x00023c),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_2,		0x000240),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_3,		0x000244),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_4,		0x000248),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_5,		0x00024c),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_6,		0x000250),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_7,		0x000254),
+	REG(SYS_COUNT_TX_GREEN_PRIO_0,		0x000258),
+	REG(SYS_COUNT_TX_GREEN_PRIO_1,		0x00025c),
+	REG(SYS_COUNT_TX_GREEN_PRIO_2,		0x000260),
+	REG(SYS_COUNT_TX_GREEN_PRIO_3,		0x000264),
+	REG(SYS_COUNT_TX_GREEN_PRIO_4,		0x000268),
+	REG(SYS_COUNT_TX_GREEN_PRIO_5,		0x00026c),
+	REG(SYS_COUNT_TX_GREEN_PRIO_6,		0x000270),
+	REG(SYS_COUNT_TX_GREEN_PRIO_7,		0x000274),
 	REG(SYS_COUNT_TX_AGING,			0x000278),
+	REG(SYS_COUNT_DROP_LOCAL,		0x000400),
+	REG(SYS_COUNT_DROP_TAIL,		0x000404),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,	0x000408),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_1,	0x00040c),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_2,	0x000410),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_3,	0x000414),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_4,	0x000418),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_5,	0x00041c),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_6,	0x000420),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,	0x000424),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_0,	0x000428),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_1,	0x00042c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_2,	0x000430),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_3,	0x000434),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_4,	0x000438),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_5,	0x00043c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_6,	0x000440),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_7,	0x000444),
 	REG(SYS_RESET_CFG,			0x000e00),
 	REG(SYS_SR_ETYPE_CFG,			0x000e04),
 	REG(SYS_VLAN_ETYPE_CFG,			0x000e08),
@@ -554,375 +621,375 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] = {
 	[OCELOT_STAT_RX_OCTETS] = {
 		.name = "rx_octets",
-		.offset = 0x00,
+		.reg = SYS_COUNT_RX_OCTETS,
 	},
 	[OCELOT_STAT_RX_UNICAST] = {
 		.name = "rx_unicast",
-		.offset = 0x01,
+		.reg = SYS_COUNT_RX_UNICAST,
 	},
 	[OCELOT_STAT_RX_MULTICAST] = {
 		.name = "rx_multicast",
-		.offset = 0x02,
+		.reg = SYS_COUNT_RX_MULTICAST,
 	},
 	[OCELOT_STAT_RX_BROADCAST] = {
 		.name = "rx_broadcast",
-		.offset = 0x03,
+		.reg = SYS_COUNT_RX_BROADCAST,
 	},
 	[OCELOT_STAT_RX_SHORTS] = {
 		.name = "rx_shorts",
-		.offset = 0x04,
+		.reg = SYS_COUNT_RX_SHORTS,
 	},
 	[OCELOT_STAT_RX_FRAGMENTS] = {
 		.name = "rx_fragments",
-		.offset = 0x05,
+		.reg = SYS_COUNT_RX_FRAGMENTS,
 	},
 	[OCELOT_STAT_RX_JABBERS] = {
 		.name = "rx_jabbers",
-		.offset = 0x06,
+		.reg = SYS_COUNT_RX_JABBERS,
 	},
 	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
 		.name = "rx_crc_align_errs",
-		.offset = 0x07,
+		.reg = SYS_COUNT_RX_CRC_ALIGN_ERRS,
 	},
 	[OCELOT_STAT_RX_SYM_ERRS] = {
 		.name = "rx_sym_errs",
-		.offset = 0x08,
+		.reg = SYS_COUNT_RX_SYM_ERRS,
 	},
 	[OCELOT_STAT_RX_64] = {
 		.name = "rx_frames_below_65_octets",
-		.offset = 0x09,
+		.reg = SYS_COUNT_RX_64,
 	},
 	[OCELOT_STAT_RX_65_127] = {
 		.name = "rx_frames_65_to_127_octets",
-		.offset = 0x0A,
+		.reg = SYS_COUNT_RX_65_127,
 	},
 	[OCELOT_STAT_RX_128_255] = {
 		.name = "rx_frames_128_to_255_octets",
-		.offset = 0x0B,
+		.reg = SYS_COUNT_RX_128_255,
 	},
 	[OCELOT_STAT_RX_256_511] = {
 		.name = "rx_frames_256_to_511_octets",
-		.offset = 0x0C,
+		.reg = SYS_COUNT_RX_256_511,
 	},
 	[OCELOT_STAT_RX_512_1023] = {
 		.name = "rx_frames_512_to_1023_octets",
-		.offset = 0x0D,
+		.reg = SYS_COUNT_RX_512_1023,
 	},
 	[OCELOT_STAT_RX_1024_1526] = {
 		.name = "rx_frames_1024_to_1526_octets",
-		.offset = 0x0E,
+		.reg = SYS_COUNT_RX_1024_1526,
 	},
 	[OCELOT_STAT_RX_1527_MAX] = {
 		.name = "rx_frames_over_1526_octets",
-		.offset = 0x0F,
+		.reg = SYS_COUNT_RX_1527_MAX,
 	},
 	[OCELOT_STAT_RX_PAUSE] = {
 		.name = "rx_pause",
-		.offset = 0x10,
+		.reg = SYS_COUNT_RX_PAUSE,
 	},
 	[OCELOT_STAT_RX_CONTROL] = {
 		.name = "rx_control",
-		.offset = 0x11,
+		.reg = SYS_COUNT_RX_CONTROL,
 	},
 	[OCELOT_STAT_RX_LONGS] = {
 		.name = "rx_longs",
-		.offset = 0x12,
+		.reg = SYS_COUNT_RX_LONGS,
 	},
 	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
 		.name = "rx_classified_drops",
-		.offset = 0x13,
+		.reg = SYS_COUNT_RX_CLASSIFIED_DROPS,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_0] = {
 		.name = "rx_red_prio_0",
-		.offset = 0x14,
+		.reg = SYS_COUNT_RX_RED_PRIO_0,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_1] = {
 		.name = "rx_red_prio_1",
-		.offset = 0x15,
+		.reg = SYS_COUNT_RX_RED_PRIO_1,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_2] = {
 		.name = "rx_red_prio_2",
-		.offset = 0x16,
+		.reg = SYS_COUNT_RX_RED_PRIO_2,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_3] = {
 		.name = "rx_red_prio_3",
-		.offset = 0x17,
+		.reg = SYS_COUNT_RX_RED_PRIO_3,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_4] = {
 		.name = "rx_red_prio_4",
-		.offset = 0x18,
+		.reg = SYS_COUNT_RX_RED_PRIO_4,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_5] = {
 		.name = "rx_red_prio_5",
-		.offset = 0x19,
+		.reg = SYS_COUNT_RX_RED_PRIO_5,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_6] = {
 		.name = "rx_red_prio_6",
-		.offset = 0x1A,
+		.reg = SYS_COUNT_RX_RED_PRIO_6,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_7] = {
 		.name = "rx_red_prio_7",
-		.offset = 0x1B,
+		.reg = SYS_COUNT_RX_RED_PRIO_7,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
 		.name = "rx_yellow_prio_0",
-		.offset = 0x1C,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
 		.name = "rx_yellow_prio_1",
-		.offset = 0x1D,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
 		.name = "rx_yellow_prio_2",
-		.offset = 0x1E,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
 		.name = "rx_yellow_prio_3",
-		.offset = 0x1F,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
 		.name = "rx_yellow_prio_4",
-		.offset = 0x20,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
 		.name = "rx_yellow_prio_5",
-		.offset = 0x21,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
 		.name = "rx_yellow_prio_6",
-		.offset = 0x22,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
 		.name = "rx_yellow_prio_7",
-		.offset = 0x23,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
 		.name = "rx_green_prio_0",
-		.offset = 0x24,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
 		.name = "rx_green_prio_1",
-		.offset = 0x25,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
 		.name = "rx_green_prio_2",
-		.offset = 0x26,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
 		.name = "rx_green_prio_3",
-		.offset = 0x27,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
 		.name = "rx_green_prio_4",
-		.offset = 0x28,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
 		.name = "rx_green_prio_5",
-		.offset = 0x29,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
 		.name = "rx_green_prio_6",
-		.offset = 0x2A,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
 		.name = "rx_green_prio_7",
-		.offset = 0x2B,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_7,
 	},
 	[OCELOT_STAT_TX_OCTETS] = {
 		.name = "tx_octets",
-		.offset = 0x80,
+		.reg = SYS_COUNT_TX_OCTETS,
 	},
 	[OCELOT_STAT_TX_UNICAST] = {
 		.name = "tx_unicast",
-		.offset = 0x81,
+		.reg = SYS_COUNT_TX_UNICAST,
 	},
 	[OCELOT_STAT_TX_MULTICAST] = {
 		.name = "tx_multicast",
-		.offset = 0x82,
+		.reg = SYS_COUNT_TX_MULTICAST,
 	},
 	[OCELOT_STAT_TX_BROADCAST] = {
 		.name = "tx_broadcast",
-		.offset = 0x83,
+		.reg = SYS_COUNT_TX_BROADCAST,
 	},
 	[OCELOT_STAT_TX_COLLISION] = {
 		.name = "tx_collision",
-		.offset = 0x84,
+		.reg = SYS_COUNT_TX_COLLISION,
 	},
 	[OCELOT_STAT_TX_DROPS] = {
 		.name = "tx_drops",
-		.offset = 0x85,
+		.reg = SYS_COUNT_TX_DROPS,
 	},
 	[OCELOT_STAT_TX_PAUSE] = {
 		.name = "tx_pause",
-		.offset = 0x86,
+		.reg = SYS_COUNT_TX_PAUSE,
 	},
 	[OCELOT_STAT_TX_64] = {
 		.name = "tx_frames_below_65_octets",
-		.offset = 0x87,
+		.reg = SYS_COUNT_TX_64,
 	},
 	[OCELOT_STAT_TX_65_127] = {
 		.name = "tx_frames_65_to_127_octets",
-		.offset = 0x88,
+		.reg = SYS_COUNT_TX_65_127,
 	},
 	[OCELOT_STAT_TX_128_255] = {
 		.name = "tx_frames_128_255_octets",
-		.offset = 0x89,
+		.reg = SYS_COUNT_TX_128_255,
 	},
 	[OCELOT_STAT_TX_256_511] = {
 		.name = "tx_frames_256_511_octets",
-		.offset = 0x8A,
+		.reg = SYS_COUNT_TX_256_511,
 	},
 	[OCELOT_STAT_TX_512_1023] = {
 		.name = "tx_frames_512_1023_octets",
-		.offset = 0x8B,
+		.reg = SYS_COUNT_TX_512_1023,
 	},
 	[OCELOT_STAT_TX_1024_1526] = {
 		.name = "tx_frames_1024_1526_octets",
-		.offset = 0x8C,
+		.reg = SYS_COUNT_TX_1024_1526,
 	},
 	[OCELOT_STAT_TX_1527_MAX] = {
 		.name = "tx_frames_over_1526_octets",
-		.offset = 0x8D,
+		.reg = SYS_COUNT_TX_1527_MAX,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
 		.name = "tx_yellow_prio_0",
-		.offset = 0x8E,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
 		.name = "tx_yellow_prio_1",
-		.offset = 0x8F,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
 		.name = "tx_yellow_prio_2",
-		.offset = 0x90,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
 		.name = "tx_yellow_prio_3",
-		.offset = 0x91,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
 		.name = "tx_yellow_prio_4",
-		.offset = 0x92,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
 		.name = "tx_yellow_prio_5",
-		.offset = 0x93,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
 		.name = "tx_yellow_prio_6",
-		.offset = 0x94,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
 		.name = "tx_yellow_prio_7",
-		.offset = 0x95,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
 		.name = "tx_green_prio_0",
-		.offset = 0x96,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
 		.name = "tx_green_prio_1",
-		.offset = 0x97,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
 		.name = "tx_green_prio_2",
-		.offset = 0x98,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
 		.name = "tx_green_prio_3",
-		.offset = 0x99,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
 		.name = "tx_green_prio_4",
-		.offset = 0x9A,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
 		.name = "tx_green_prio_5",
-		.offset = 0x9B,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
 		.name = "tx_green_prio_6",
-		.offset = 0x9C,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
 		.name = "tx_green_prio_7",
-		.offset = 0x9D,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_7,
 	},
 	[OCELOT_STAT_TX_AGED] = {
 		.name = "tx_aged",
-		.offset = 0x9E,
+		.reg = SYS_COUNT_TX_AGING,
 	},
 	[OCELOT_STAT_DROP_LOCAL] = {
 		.name = "drop_local",
-		.offset = 0x100,
+		.reg = SYS_COUNT_DROP_LOCAL,
 	},
 	[OCELOT_STAT_DROP_TAIL] = {
 		.name = "drop_tail",
-		.offset = 0x101,
+		.reg = SYS_COUNT_DROP_TAIL,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
 		.name = "drop_yellow_prio_0",
-		.offset = 0x102,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
 		.name = "drop_yellow_prio_1",
-		.offset = 0x103,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
 		.name = "drop_yellow_prio_2",
-		.offset = 0x104,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
 		.name = "drop_yellow_prio_3",
-		.offset = 0x105,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
 		.name = "drop_yellow_prio_4",
-		.offset = 0x106,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
 		.name = "drop_yellow_prio_5",
-		.offset = 0x107,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
 		.name = "drop_yellow_prio_6",
-		.offset = 0x108,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
 		.name = "drop_yellow_prio_7",
-		.offset = 0x109,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
 		.name = "drop_green_prio_0",
-		.offset = 0x10A,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
 		.name = "drop_green_prio_1",
-		.offset = 0x10B,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
 		.name = "drop_green_prio_2",
-		.offset = 0x10C,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
 		.name = "drop_green_prio_3",
-		.offset = 0x10D,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
 		.name = "drop_green_prio_4",
-		.offset = 0x10E,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
 		.name = "drop_green_prio_5",
-		.offset = 0x10F,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
 		.name = "drop_green_prio_6",
-		.offset = 0x110,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
 		.name = "drop_green_prio_7",
-		.offset = 0x111,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_7,
 	},
 };
 
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index fe5d4642d0bc..b34f4cdfe814 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -270,10 +270,14 @@ static const u32 vsc9953_rew_regmap[] = {
 
 static const u32 vsc9953_sys_regmap[] = {
 	REG(SYS_COUNT_RX_OCTETS,		0x000000),
+	REG(SYS_COUNT_RX_UNICAST,		0x000004),
 	REG(SYS_COUNT_RX_MULTICAST,		0x000008),
+	REG(SYS_COUNT_RX_BROADCAST,		0x00000c),
 	REG(SYS_COUNT_RX_SHORTS,		0x000010),
 	REG(SYS_COUNT_RX_FRAGMENTS,		0x000014),
 	REG(SYS_COUNT_RX_JABBERS,		0x000018),
+	REG(SYS_COUNT_RX_CRC_ALIGN_ERRS,	0x00001c),
+	REG(SYS_COUNT_RX_SYM_ERRS,		0x000020),
 	REG(SYS_COUNT_RX_64,			0x000024),
 	REG(SYS_COUNT_RX_65_127,		0x000028),
 	REG(SYS_COUNT_RX_128_255,		0x00002c),
@@ -281,10 +285,41 @@ static const u32 vsc9953_sys_regmap[] = {
 	REG(SYS_COUNT_RX_512_1023,		0x000034),
 	REG(SYS_COUNT_RX_1024_1526,		0x000038),
 	REG(SYS_COUNT_RX_1527_MAX,		0x00003c),
+	REG(SYS_COUNT_RX_PAUSE,			0x000040),
+	REG(SYS_COUNT_RX_CONTROL,		0x000044),
 	REG(SYS_COUNT_RX_LONGS,			0x000048),
+	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,	0x00004c),
+	REG(SYS_COUNT_RX_RED_PRIO_0,		0x000050),
+	REG(SYS_COUNT_RX_RED_PRIO_1,		0x000054),
+	REG(SYS_COUNT_RX_RED_PRIO_2,		0x000058),
+	REG(SYS_COUNT_RX_RED_PRIO_3,		0x00005c),
+	REG(SYS_COUNT_RX_RED_PRIO_4,		0x000060),
+	REG(SYS_COUNT_RX_RED_PRIO_5,		0x000064),
+	REG(SYS_COUNT_RX_RED_PRIO_6,		0x000068),
+	REG(SYS_COUNT_RX_RED_PRIO_7,		0x00006c),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_0,		0x000070),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_1,		0x000074),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_2,		0x000078),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_3,		0x00007c),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_4,		0x000080),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_5,		0x000084),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_6,		0x000088),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_7,		0x00008c),
+	REG(SYS_COUNT_RX_GREEN_PRIO_0,		0x000090),
+	REG(SYS_COUNT_RX_GREEN_PRIO_1,		0x000094),
+	REG(SYS_COUNT_RX_GREEN_PRIO_2,		0x000098),
+	REG(SYS_COUNT_RX_GREEN_PRIO_3,		0x00009c),
+	REG(SYS_COUNT_RX_GREEN_PRIO_4,		0x0000a0),
+	REG(SYS_COUNT_RX_GREEN_PRIO_5,		0x0000a4),
+	REG(SYS_COUNT_RX_GREEN_PRIO_6,		0x0000a8),
+	REG(SYS_COUNT_RX_GREEN_PRIO_7,		0x0000ac),
 	REG(SYS_COUNT_TX_OCTETS,		0x000100),
+	REG(SYS_COUNT_TX_UNICAST,		0x000104),
+	REG(SYS_COUNT_TX_MULTICAST,		0x000108),
+	REG(SYS_COUNT_TX_BROADCAST,		0x00010c),
 	REG(SYS_COUNT_TX_COLLISION,		0x000110),
 	REG(SYS_COUNT_TX_DROPS,			0x000114),
+	REG(SYS_COUNT_TX_PAUSE,			0x000118),
 	REG(SYS_COUNT_TX_64,			0x00011c),
 	REG(SYS_COUNT_TX_65_127,		0x000120),
 	REG(SYS_COUNT_TX_128_255,		0x000124),
@@ -292,7 +327,41 @@ static const u32 vsc9953_sys_regmap[] = {
 	REG(SYS_COUNT_TX_512_1023,		0x00012c),
 	REG(SYS_COUNT_TX_1024_1526,		0x000130),
 	REG(SYS_COUNT_TX_1527_MAX,		0x000134),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_0,		0x000138),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_1,		0x00013c),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_2,		0x000140),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_3,		0x000144),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_4,		0x000148),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_5,		0x00014c),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_6,		0x000150),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_7,		0x000154),
+	REG(SYS_COUNT_TX_GREEN_PRIO_0,		0x000158),
+	REG(SYS_COUNT_TX_GREEN_PRIO_1,		0x00015c),
+	REG(SYS_COUNT_TX_GREEN_PRIO_2,		0x000160),
+	REG(SYS_COUNT_TX_GREEN_PRIO_3,		0x000164),
+	REG(SYS_COUNT_TX_GREEN_PRIO_4,		0x000168),
+	REG(SYS_COUNT_TX_GREEN_PRIO_5,		0x00016c),
+	REG(SYS_COUNT_TX_GREEN_PRIO_6,		0x000170),
+	REG(SYS_COUNT_TX_GREEN_PRIO_7,		0x000174),
 	REG(SYS_COUNT_TX_AGING,			0x000178),
+	REG(SYS_COUNT_DROP_LOCAL,		0x000200),
+	REG(SYS_COUNT_DROP_TAIL,		0x000204),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,	0x000208),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_1,	0x00020c),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_2,	0x000210),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_3,	0x000214),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_4,	0x000218),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_5,	0x00021c),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_6,	0x000220),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,	0x000224),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_0,	0x000228),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_1,	0x00022c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_2,	0x000230),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_3,	0x000234),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_4,	0x000238),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_5,	0x00023c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_6,	0x000240),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_7,	0x000244),
 	REG(SYS_RESET_CFG,			0x000318),
 	REG_RESERVED(SYS_SR_ETYPE_CFG),
 	REG(SYS_VLAN_ETYPE_CFG,			0x000320),
@@ -548,375 +617,375 @@ static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
 static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STATS] = {
 	[OCELOT_STAT_RX_OCTETS] = {
 		.name = "rx_octets",
-		.offset = 0x00,
+		.reg = SYS_COUNT_RX_OCTETS,
 	},
 	[OCELOT_STAT_RX_UNICAST] = {
 		.name = "rx_unicast",
-		.offset = 0x01,
+		.reg = SYS_COUNT_RX_UNICAST,
 	},
 	[OCELOT_STAT_RX_MULTICAST] = {
 		.name = "rx_multicast",
-		.offset = 0x02,
+		.reg = SYS_COUNT_RX_MULTICAST,
 	},
 	[OCELOT_STAT_RX_BROADCAST] = {
 		.name = "rx_broadcast",
-		.offset = 0x03,
+		.reg = SYS_COUNT_RX_BROADCAST,
 	},
 	[OCELOT_STAT_RX_SHORTS] = {
 		.name = "rx_shorts",
-		.offset = 0x04,
+		.reg = SYS_COUNT_RX_SHORTS,
 	},
 	[OCELOT_STAT_RX_FRAGMENTS] = {
 		.name = "rx_fragments",
-		.offset = 0x05,
+		.reg = SYS_COUNT_RX_FRAGMENTS,
 	},
 	[OCELOT_STAT_RX_JABBERS] = {
 		.name = "rx_jabbers",
-		.offset = 0x06,
+		.reg = SYS_COUNT_RX_JABBERS,
 	},
 	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
 		.name = "rx_crc_align_errs",
-		.offset = 0x07,
+		.reg = SYS_COUNT_RX_CRC_ALIGN_ERRS,
 	},
 	[OCELOT_STAT_RX_SYM_ERRS] = {
 		.name = "rx_sym_errs",
-		.offset = 0x08,
+		.reg = SYS_COUNT_RX_SYM_ERRS,
 	},
 	[OCELOT_STAT_RX_64] = {
 		.name = "rx_frames_below_65_octets",
-		.offset = 0x09,
+		.reg = SYS_COUNT_RX_64,
 	},
 	[OCELOT_STAT_RX_65_127] = {
 		.name = "rx_frames_65_to_127_octets",
-		.offset = 0x0A,
+		.reg = SYS_COUNT_RX_65_127,
 	},
 	[OCELOT_STAT_RX_128_255] = {
 		.name = "rx_frames_128_to_255_octets",
-		.offset = 0x0B,
+		.reg = SYS_COUNT_RX_128_255,
 	},
 	[OCELOT_STAT_RX_256_511] = {
 		.name = "rx_frames_256_to_511_octets",
-		.offset = 0x0C,
+		.reg = SYS_COUNT_RX_256_511,
 	},
 	[OCELOT_STAT_RX_512_1023] = {
 		.name = "rx_frames_512_to_1023_octets",
-		.offset = 0x0D,
+		.reg = SYS_COUNT_RX_512_1023,
 	},
 	[OCELOT_STAT_RX_1024_1526] = {
 		.name = "rx_frames_1024_to_1526_octets",
-		.offset = 0x0E,
+		.reg = SYS_COUNT_RX_1024_1526,
 	},
 	[OCELOT_STAT_RX_1527_MAX] = {
 		.name = "rx_frames_over_1526_octets",
-		.offset = 0x0F,
+		.reg = SYS_COUNT_RX_1527_MAX,
 	},
 	[OCELOT_STAT_RX_PAUSE] = {
 		.name = "rx_pause",
-		.offset = 0x10,
+		.reg = SYS_COUNT_RX_PAUSE,
 	},
 	[OCELOT_STAT_RX_CONTROL] = {
 		.name = "rx_control",
-		.offset = 0x11,
+		.reg = SYS_COUNT_RX_CONTROL,
 	},
 	[OCELOT_STAT_RX_LONGS] = {
 		.name = "rx_longs",
-		.offset = 0x12,
+		.reg = SYS_COUNT_RX_LONGS,
 	},
 	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
 		.name = "rx_classified_drops",
-		.offset = 0x13,
+		.reg = SYS_COUNT_RX_CLASSIFIED_DROPS,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_0] = {
 		.name = "rx_red_prio_0",
-		.offset = 0x14,
+		.reg = SYS_COUNT_RX_RED_PRIO_0,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_1] = {
 		.name = "rx_red_prio_1",
-		.offset = 0x15,
+		.reg = SYS_COUNT_RX_RED_PRIO_1,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_2] = {
 		.name = "rx_red_prio_2",
-		.offset = 0x16,
+		.reg = SYS_COUNT_RX_RED_PRIO_2,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_3] = {
 		.name = "rx_red_prio_3",
-		.offset = 0x17,
+		.reg = SYS_COUNT_RX_RED_PRIO_3,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_4] = {
 		.name = "rx_red_prio_4",
-		.offset = 0x18,
+		.reg = SYS_COUNT_RX_RED_PRIO_4,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_5] = {
 		.name = "rx_red_prio_5",
-		.offset = 0x19,
+		.reg = SYS_COUNT_RX_RED_PRIO_5,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_6] = {
 		.name = "rx_red_prio_6",
-		.offset = 0x1A,
+		.reg = SYS_COUNT_RX_RED_PRIO_6,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_7] = {
 		.name = "rx_red_prio_7",
-		.offset = 0x1B,
+		.reg = SYS_COUNT_RX_RED_PRIO_7,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
 		.name = "rx_yellow_prio_0",
-		.offset = 0x1C,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
 		.name = "rx_yellow_prio_1",
-		.offset = 0x1D,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
 		.name = "rx_yellow_prio_2",
-		.offset = 0x1E,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
 		.name = "rx_yellow_prio_3",
-		.offset = 0x1F,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
 		.name = "rx_yellow_prio_4",
-		.offset = 0x20,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
 		.name = "rx_yellow_prio_5",
-		.offset = 0x21,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
 		.name = "rx_yellow_prio_6",
-		.offset = 0x22,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
 		.name = "rx_yellow_prio_7",
-		.offset = 0x23,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
 		.name = "rx_green_prio_0",
-		.offset = 0x24,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
 		.name = "rx_green_prio_1",
-		.offset = 0x25,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
 		.name = "rx_green_prio_2",
-		.offset = 0x26,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
 		.name = "rx_green_prio_3",
-		.offset = 0x27,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
 		.name = "rx_green_prio_4",
-		.offset = 0x28,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
 		.name = "rx_green_prio_5",
-		.offset = 0x29,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
 		.name = "rx_green_prio_6",
-		.offset = 0x2A,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
 		.name = "rx_green_prio_7",
-		.offset = 0x2B,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_7,
 	},
 	[OCELOT_STAT_TX_OCTETS] = {
 		.name = "tx_octets",
-		.offset = 0x40,
+		.reg = SYS_COUNT_TX_OCTETS,
 	},
 	[OCELOT_STAT_TX_UNICAST] = {
 		.name = "tx_unicast",
-		.offset = 0x41,
+		.reg = SYS_COUNT_TX_UNICAST,
 	},
 	[OCELOT_STAT_TX_MULTICAST] = {
 		.name = "tx_multicast",
-		.offset = 0x42,
+		.reg = SYS_COUNT_TX_MULTICAST,
 	},
 	[OCELOT_STAT_TX_BROADCAST] = {
 		.name = "tx_broadcast",
-		.offset = 0x43,
+		.reg = SYS_COUNT_TX_BROADCAST,
 	},
 	[OCELOT_STAT_TX_COLLISION] = {
 		.name = "tx_collision",
-		.offset = 0x44,
+		.reg = SYS_COUNT_TX_COLLISION,
 	},
 	[OCELOT_STAT_TX_DROPS] = {
 		.name = "tx_drops",
-		.offset = 0x45,
+		.reg = SYS_COUNT_TX_DROPS,
 	},
 	[OCELOT_STAT_TX_PAUSE] = {
 		.name = "tx_pause",
-		.offset = 0x46,
+		.reg = SYS_COUNT_TX_PAUSE,
 	},
 	[OCELOT_STAT_TX_64] = {
 		.name = "tx_frames_below_65_octets",
-		.offset = 0x47,
+		.reg = SYS_COUNT_TX_64,
 	},
 	[OCELOT_STAT_TX_65_127] = {
 		.name = "tx_frames_65_to_127_octets",
-		.offset = 0x48,
+		.reg = SYS_COUNT_TX_65_127,
 	},
 	[OCELOT_STAT_TX_128_255] = {
 		.name = "tx_frames_128_255_octets",
-		.offset = 0x49,
+		.reg = SYS_COUNT_TX_128_255,
 	},
 	[OCELOT_STAT_TX_256_511] = {
 		.name = "tx_frames_256_511_octets",
-		.offset = 0x4A,
+		.reg = SYS_COUNT_TX_256_511,
 	},
 	[OCELOT_STAT_TX_512_1023] = {
 		.name = "tx_frames_512_1023_octets",
-		.offset = 0x4B,
+		.reg = SYS_COUNT_TX_512_1023,
 	},
 	[OCELOT_STAT_TX_1024_1526] = {
 		.name = "tx_frames_1024_1526_octets",
-		.offset = 0x4C,
+		.reg = SYS_COUNT_TX_1024_1526,
 	},
 	[OCELOT_STAT_TX_1527_MAX] = {
 		.name = "tx_frames_over_1526_octets",
-		.offset = 0x4D,
+		.reg = SYS_COUNT_TX_1527_MAX,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
 		.name = "tx_yellow_prio_0",
-		.offset = 0x4E,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
 		.name = "tx_yellow_prio_1",
-		.offset = 0x4F,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
 		.name = "tx_yellow_prio_2",
-		.offset = 0x50,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
 		.name = "tx_yellow_prio_3",
-		.offset = 0x51,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
 		.name = "tx_yellow_prio_4",
-		.offset = 0x52,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
 		.name = "tx_yellow_prio_5",
-		.offset = 0x53,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
 		.name = "tx_yellow_prio_6",
-		.offset = 0x54,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
 		.name = "tx_yellow_prio_7",
-		.offset = 0x55,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
 		.name = "tx_green_prio_0",
-		.offset = 0x56,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
 		.name = "tx_green_prio_1",
-		.offset = 0x57,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
 		.name = "tx_green_prio_2",
-		.offset = 0x58,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
 		.name = "tx_green_prio_3",
-		.offset = 0x59,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
 		.name = "tx_green_prio_4",
-		.offset = 0x5A,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
 		.name = "tx_green_prio_5",
-		.offset = 0x5B,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
 		.name = "tx_green_prio_6",
-		.offset = 0x5C,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
 		.name = "tx_green_prio_7",
-		.offset = 0x5D,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_7,
 	},
 	[OCELOT_STAT_TX_AGED] = {
 		.name = "tx_aged",
-		.offset = 0x5E,
+		.reg = SYS_COUNT_TX_AGING,
 	},
 	[OCELOT_STAT_DROP_LOCAL] = {
 		.name = "drop_local",
-		.offset = 0x80,
+		.reg = SYS_COUNT_DROP_LOCAL,
 	},
 	[OCELOT_STAT_DROP_TAIL] = {
 		.name = "drop_tail",
-		.offset = 0x81,
+		.reg = SYS_COUNT_DROP_TAIL,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
 		.name = "drop_yellow_prio_0",
-		.offset = 0x82,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
 		.name = "drop_yellow_prio_1",
-		.offset = 0x83,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
 		.name = "drop_yellow_prio_2",
-		.offset = 0x84,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
 		.name = "drop_yellow_prio_3",
-		.offset = 0x85,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
 		.name = "drop_yellow_prio_4",
-		.offset = 0x86,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
 		.name = "drop_yellow_prio_5",
-		.offset = 0x87,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
 		.name = "drop_yellow_prio_6",
-		.offset = 0x88,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
 		.name = "drop_yellow_prio_7",
-		.offset = 0x89,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
 		.name = "drop_green_prio_0",
-		.offset = 0x8A,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
 		.name = "drop_green_prio_1",
-		.offset = 0x8B,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
 		.name = "drop_green_prio_2",
-		.offset = 0x8C,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
 		.name = "drop_green_prio_3",
-		.offset = 0x8D,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
 		.name = "drop_green_prio_4",
-		.offset = 0x8E,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
 		.name = "drop_green_prio_5",
-		.offset = 0x8F,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
 		.name = "drop_green_prio_6",
-		.offset = 0x90,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
 		.name = "drop_green_prio_7",
-		.offset = 0x91,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_7,
 	},
 };
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 68991b021c56..306026e6aa11 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1881,9 +1881,8 @@ static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
 
 	list_for_each_entry(region, &ocelot->stats_regions, node) {
-		err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
-					   region->offset, region->buf,
-					   region->count);
+		err = ocelot_bulk_read(ocelot, region->base, region->buf,
+				       region->count);
 		if (err)
 			return err;
 
@@ -1978,7 +1977,7 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 		if (ocelot->stats_layout[i].name[0] == '\0')
 			continue;
 
-		if (region && ocelot->stats_layout[i].offset == last + 1) {
+		if (region && ocelot->stats_layout[i].reg == last + 4) {
 			region->count++;
 		} else {
 			region = devm_kzalloc(ocelot->dev, sizeof(*region),
@@ -1986,12 +1985,12 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 			if (!region)
 				return -ENOMEM;
 
-			region->offset = ocelot->stats_layout[i].offset;
+			region->base = ocelot->stats_layout[i].reg;
 			region->count = 1;
 			list_add_tail(&region->node, &ocelot->stats_regions);
 		}
 
-		last = ocelot->stats_layout[i].offset;
+		last = ocelot->stats_layout[i].reg;
 	}
 
 	list_for_each_entry(region, &ocelot->stats_regions, node) {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 9ff910560043..9c488953f541 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -99,375 +99,375 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	[OCELOT_STAT_RX_OCTETS] = {
 		.name = "rx_octets",
-		.offset = 0x00,
+		.reg = SYS_COUNT_RX_OCTETS,
 	},
 	[OCELOT_STAT_RX_UNICAST] = {
 		.name = "rx_unicast",
-		.offset = 0x01,
+		.reg = SYS_COUNT_RX_UNICAST,
 	},
 	[OCELOT_STAT_RX_MULTICAST] = {
 		.name = "rx_multicast",
-		.offset = 0x02,
+		.reg = SYS_COUNT_RX_MULTICAST,
 	},
 	[OCELOT_STAT_RX_BROADCAST] = {
 		.name = "rx_broadcast",
-		.offset = 0x03,
+		.reg = SYS_COUNT_RX_BROADCAST,
 	},
 	[OCELOT_STAT_RX_SHORTS] = {
 		.name = "rx_shorts",
-		.offset = 0x04,
+		.reg = SYS_COUNT_RX_SHORTS,
 	},
 	[OCELOT_STAT_RX_FRAGMENTS] = {
 		.name = "rx_fragments",
-		.offset = 0x05,
+		.reg = SYS_COUNT_RX_FRAGMENTS,
 	},
 	[OCELOT_STAT_RX_JABBERS] = {
 		.name = "rx_jabbers",
-		.offset = 0x06,
+		.reg = SYS_COUNT_RX_JABBERS,
 	},
 	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
 		.name = "rx_crc_align_errs",
-		.offset = 0x07,
+		.reg = SYS_COUNT_RX_CRC_ALIGN_ERRS,
 	},
 	[OCELOT_STAT_RX_SYM_ERRS] = {
 		.name = "rx_sym_errs",
-		.offset = 0x08,
+		.reg = SYS_COUNT_RX_SYM_ERRS,
 	},
 	[OCELOT_STAT_RX_64] = {
 		.name = "rx_frames_below_65_octets",
-		.offset = 0x09,
+		.reg = SYS_COUNT_RX_64,
 	},
 	[OCELOT_STAT_RX_65_127] = {
 		.name = "rx_frames_65_to_127_octets",
-		.offset = 0x0A,
+		.reg = SYS_COUNT_RX_65_127,
 	},
 	[OCELOT_STAT_RX_128_255] = {
 		.name = "rx_frames_128_to_255_octets",
-		.offset = 0x0B,
+		.reg = SYS_COUNT_RX_128_255,
 	},
 	[OCELOT_STAT_RX_256_511] = {
 		.name = "rx_frames_256_to_511_octets",
-		.offset = 0x0C,
+		.reg = SYS_COUNT_RX_256_511,
 	},
 	[OCELOT_STAT_RX_512_1023] = {
 		.name = "rx_frames_512_to_1023_octets",
-		.offset = 0x0D,
+		.reg = SYS_COUNT_RX_512_1023,
 	},
 	[OCELOT_STAT_RX_1024_1526] = {
 		.name = "rx_frames_1024_to_1526_octets",
-		.offset = 0x0E,
+		.reg = SYS_COUNT_RX_1024_1526,
 	},
 	[OCELOT_STAT_RX_1527_MAX] = {
 		.name = "rx_frames_over_1526_octets",
-		.offset = 0x0F,
+		.reg = SYS_COUNT_RX_1527_MAX,
 	},
 	[OCELOT_STAT_RX_PAUSE] = {
 		.name = "rx_pause",
-		.offset = 0x10,
+		.reg = SYS_COUNT_RX_PAUSE,
 	},
 	[OCELOT_STAT_RX_CONTROL] = {
 		.name = "rx_control",
-		.offset = 0x11,
+		.reg = SYS_COUNT_RX_CONTROL,
 	},
 	[OCELOT_STAT_RX_LONGS] = {
 		.name = "rx_longs",
-		.offset = 0x12,
+		.reg = SYS_COUNT_RX_LONGS,
 	},
 	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
 		.name = "rx_classified_drops",
-		.offset = 0x13,
+		.reg = SYS_COUNT_RX_CLASSIFIED_DROPS,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_0] = {
 		.name = "rx_red_prio_0",
-		.offset = 0x14,
+		.reg = SYS_COUNT_RX_RED_PRIO_0,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_1] = {
 		.name = "rx_red_prio_1",
-		.offset = 0x15,
+		.reg = SYS_COUNT_RX_RED_PRIO_1,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_2] = {
 		.name = "rx_red_prio_2",
-		.offset = 0x16,
+		.reg = SYS_COUNT_RX_RED_PRIO_2,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_3] = {
 		.name = "rx_red_prio_3",
-		.offset = 0x17,
+		.reg = SYS_COUNT_RX_RED_PRIO_3,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_4] = {
 		.name = "rx_red_prio_4",
-		.offset = 0x18,
+		.reg = SYS_COUNT_RX_RED_PRIO_4,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_5] = {
 		.name = "rx_red_prio_5",
-		.offset = 0x19,
+		.reg = SYS_COUNT_RX_RED_PRIO_5,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_6] = {
 		.name = "rx_red_prio_6",
-		.offset = 0x1A,
+		.reg = SYS_COUNT_RX_RED_PRIO_6,
 	},
 	[OCELOT_STAT_RX_RED_PRIO_7] = {
 		.name = "rx_red_prio_7",
-		.offset = 0x1B,
+		.reg = SYS_COUNT_RX_RED_PRIO_7,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
 		.name = "rx_yellow_prio_0",
-		.offset = 0x1C,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
 		.name = "rx_yellow_prio_1",
-		.offset = 0x1D,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
 		.name = "rx_yellow_prio_2",
-		.offset = 0x1E,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
 		.name = "rx_yellow_prio_3",
-		.offset = 0x1F,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
 		.name = "rx_yellow_prio_4",
-		.offset = 0x20,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
 		.name = "rx_yellow_prio_5",
-		.offset = 0x21,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
 		.name = "rx_yellow_prio_6",
-		.offset = 0x22,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
 		.name = "rx_yellow_prio_7",
-		.offset = 0x23,
+		.reg = SYS_COUNT_RX_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
 		.name = "rx_green_prio_0",
-		.offset = 0x24,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
 		.name = "rx_green_prio_1",
-		.offset = 0x25,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
 		.name = "rx_green_prio_2",
-		.offset = 0x26,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
 		.name = "rx_green_prio_3",
-		.offset = 0x27,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
 		.name = "rx_green_prio_4",
-		.offset = 0x28,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
 		.name = "rx_green_prio_5",
-		.offset = 0x29,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
 		.name = "rx_green_prio_6",
-		.offset = 0x2A,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
 		.name = "rx_green_prio_7",
-		.offset = 0x2B,
+		.reg = SYS_COUNT_RX_GREEN_PRIO_7,
 	},
 	[OCELOT_STAT_TX_OCTETS] = {
 		.name = "tx_octets",
-		.offset = 0x40,
+		.reg = SYS_COUNT_TX_OCTETS,
 	},
 	[OCELOT_STAT_TX_UNICAST] = {
 		.name = "tx_unicast",
-		.offset = 0x41,
+		.reg = SYS_COUNT_TX_UNICAST,
 	},
 	[OCELOT_STAT_TX_MULTICAST] = {
 		.name = "tx_multicast",
-		.offset = 0x42,
+		.reg = SYS_COUNT_TX_MULTICAST,
 	},
 	[OCELOT_STAT_TX_BROADCAST] = {
 		.name = "tx_broadcast",
-		.offset = 0x43,
+		.reg = SYS_COUNT_TX_BROADCAST,
 	},
 	[OCELOT_STAT_TX_COLLISION] = {
 		.name = "tx_collision",
-		.offset = 0x44,
+		.reg = SYS_COUNT_TX_COLLISION,
 	},
 	[OCELOT_STAT_TX_DROPS] = {
 		.name = "tx_drops",
-		.offset = 0x45,
+		.reg = SYS_COUNT_TX_DROPS,
 	},
 	[OCELOT_STAT_TX_PAUSE] = {
 		.name = "tx_pause",
-		.offset = 0x46,
+		.reg = SYS_COUNT_TX_PAUSE,
 	},
 	[OCELOT_STAT_TX_64] = {
 		.name = "tx_frames_below_65_octets",
-		.offset = 0x47,
+		.reg = SYS_COUNT_TX_64,
 	},
 	[OCELOT_STAT_TX_65_127] = {
 		.name = "tx_frames_65_to_127_octets",
-		.offset = 0x48,
+		.reg = SYS_COUNT_TX_65_127,
 	},
 	[OCELOT_STAT_TX_128_255] = {
 		.name = "tx_frames_128_255_octets",
-		.offset = 0x49,
+		.reg = SYS_COUNT_TX_128_255,
 	},
 	[OCELOT_STAT_TX_256_511] = {
 		.name = "tx_frames_256_511_octets",
-		.offset = 0x4A,
+		.reg = SYS_COUNT_TX_256_511,
 	},
 	[OCELOT_STAT_TX_512_1023] = {
 		.name = "tx_frames_512_1023_octets",
-		.offset = 0x4B,
+		.reg = SYS_COUNT_TX_512_1023,
 	},
 	[OCELOT_STAT_TX_1024_1526] = {
 		.name = "tx_frames_1024_1526_octets",
-		.offset = 0x4C,
+		.reg = SYS_COUNT_TX_1024_1526,
 	},
 	[OCELOT_STAT_TX_1527_MAX] = {
 		.name = "tx_frames_over_1526_octets",
-		.offset = 0x4D,
+		.reg = SYS_COUNT_TX_1527_MAX,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
 		.name = "tx_yellow_prio_0",
-		.offset = 0x4E,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
 		.name = "tx_yellow_prio_1",
-		.offset = 0x4F,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
 		.name = "tx_yellow_prio_2",
-		.offset = 0x50,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
 		.name = "tx_yellow_prio_3",
-		.offset = 0x51,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
 		.name = "tx_yellow_prio_4",
-		.offset = 0x52,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
 		.name = "tx_yellow_prio_5",
-		.offset = 0x53,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
 		.name = "tx_yellow_prio_6",
-		.offset = 0x54,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
 		.name = "tx_yellow_prio_7",
-		.offset = 0x55,
+		.reg = SYS_COUNT_TX_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
 		.name = "tx_green_prio_0",
-		.offset = 0x56,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
 		.name = "tx_green_prio_1",
-		.offset = 0x57,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
 		.name = "tx_green_prio_2",
-		.offset = 0x58,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
 		.name = "tx_green_prio_3",
-		.offset = 0x59,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
 		.name = "tx_green_prio_4",
-		.offset = 0x5A,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
 		.name = "tx_green_prio_5",
-		.offset = 0x5B,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
 		.name = "tx_green_prio_6",
-		.offset = 0x5C,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
 		.name = "tx_green_prio_7",
-		.offset = 0x5D,
+		.reg = SYS_COUNT_TX_GREEN_PRIO_7,
 	},
 	[OCELOT_STAT_TX_AGED] = {
 		.name = "tx_aged",
-		.offset = 0x5E,
+		.reg = SYS_COUNT_TX_AGING,
 	},
 	[OCELOT_STAT_DROP_LOCAL] = {
 		.name = "drop_local",
-		.offset = 0x80,
+		.reg = SYS_COUNT_DROP_LOCAL,
 	},
 	[OCELOT_STAT_DROP_TAIL] = {
 		.name = "drop_tail",
-		.offset = 0x81,
+		.reg = SYS_COUNT_DROP_TAIL,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
 		.name = "drop_yellow_prio_0",
-		.offset = 0x82,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_0,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
 		.name = "drop_yellow_prio_1",
-		.offset = 0x83,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_1,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
 		.name = "drop_yellow_prio_2",
-		.offset = 0x84,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_2,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
 		.name = "drop_yellow_prio_3",
-		.offset = 0x85,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_3,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
 		.name = "drop_yellow_prio_4",
-		.offset = 0x86,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_4,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
 		.name = "drop_yellow_prio_5",
-		.offset = 0x87,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_5,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
 		.name = "drop_yellow_prio_6",
-		.offset = 0x88,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_6,
 	},
 	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
 		.name = "drop_yellow_prio_7",
-		.offset = 0x89,
+		.reg = SYS_COUNT_DROP_YELLOW_PRIO_7,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
 		.name = "drop_green_prio_0",
-		.offset = 0x8A,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_0,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
 		.name = "drop_green_prio_1",
-		.offset = 0x8B,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_1,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
 		.name = "drop_green_prio_2",
-		.offset = 0x8C,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_2,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
 		.name = "drop_green_prio_3",
-		.offset = 0x8D,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_3,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
 		.name = "drop_green_prio_4",
-		.offset = 0x8E,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_4,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
 		.name = "drop_green_prio_5",
-		.offset = 0x8F,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_5,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
 		.name = "drop_green_prio_6",
-		.offset = 0x90,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_6,
 	},
 	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
 		.name = "drop_green_prio_7",
-		.offset = 0x91,
+		.reg = SYS_COUNT_DROP_GREEN_PRIO_7,
 	},
 };
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 8ff935f7f150..9cf82ecf191c 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -188,6 +188,30 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_RX_CONTROL,			0x000044),
 	REG(SYS_COUNT_RX_LONGS,				0x000048),
 	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x00004c),
+	REG(SYS_COUNT_RX_RED_PRIO_0,			0x000050),
+	REG(SYS_COUNT_RX_RED_PRIO_1,			0x000054),
+	REG(SYS_COUNT_RX_RED_PRIO_2,			0x000058),
+	REG(SYS_COUNT_RX_RED_PRIO_3,			0x00005c),
+	REG(SYS_COUNT_RX_RED_PRIO_4,			0x000060),
+	REG(SYS_COUNT_RX_RED_PRIO_5,			0x000064),
+	REG(SYS_COUNT_RX_RED_PRIO_6,			0x000068),
+	REG(SYS_COUNT_RX_RED_PRIO_7,			0x00006c),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_0,			0x000070),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_1,			0x000074),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_2,			0x000078),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_3,			0x00007c),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_4,			0x000080),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_5,			0x000084),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_6,			0x000088),
+	REG(SYS_COUNT_RX_YELLOW_PRIO_7,			0x00008c),
+	REG(SYS_COUNT_RX_GREEN_PRIO_0,			0x000090),
+	REG(SYS_COUNT_RX_GREEN_PRIO_1,			0x000094),
+	REG(SYS_COUNT_RX_GREEN_PRIO_2,			0x000098),
+	REG(SYS_COUNT_RX_GREEN_PRIO_3,			0x00009c),
+	REG(SYS_COUNT_RX_GREEN_PRIO_4,			0x0000a0),
+	REG(SYS_COUNT_RX_GREEN_PRIO_5,			0x0000a4),
+	REG(SYS_COUNT_RX_GREEN_PRIO_6,			0x0000a8),
+	REG(SYS_COUNT_RX_GREEN_PRIO_7,			0x0000ac),
 	REG(SYS_COUNT_TX_OCTETS,			0x000100),
 	REG(SYS_COUNT_TX_UNICAST,			0x000104),
 	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
@@ -202,7 +226,41 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_TX_512_1023,			0x00012c),
 	REG(SYS_COUNT_TX_1024_1526,			0x000130),
 	REG(SYS_COUNT_TX_1527_MAX,			0x000134),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_0,			0x000138),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_1,			0x00013c),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_2,			0x000140),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_3,			0x000144),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_4,			0x000148),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_5,			0x00014c),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_6,			0x000150),
+	REG(SYS_COUNT_TX_YELLOW_PRIO_7,			0x000154),
+	REG(SYS_COUNT_TX_GREEN_PRIO_0,			0x000158),
+	REG(SYS_COUNT_TX_GREEN_PRIO_1,			0x00015c),
+	REG(SYS_COUNT_TX_GREEN_PRIO_2,			0x000160),
+	REG(SYS_COUNT_TX_GREEN_PRIO_3,			0x000164),
+	REG(SYS_COUNT_TX_GREEN_PRIO_4,			0x000168),
+	REG(SYS_COUNT_TX_GREEN_PRIO_5,			0x00016c),
+	REG(SYS_COUNT_TX_GREEN_PRIO_6,			0x000170),
+	REG(SYS_COUNT_TX_GREEN_PRIO_7,			0x000174),
 	REG(SYS_COUNT_TX_AGING,				0x000178),
+	REG(SYS_COUNT_DROP_LOCAL,			0x000200),
+	REG(SYS_COUNT_DROP_TAIL,			0x000204),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,		0x000208),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_1,		0x00020c),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_2,		0x000210),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_3,		0x000214),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_4,		0x000218),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_5,		0x00021c),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_6,		0x000220),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,		0x000214),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_0,		0x000218),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_1,		0x00021c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_2,		0x000220),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_3,		0x000224),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_4,		0x000228),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_5,		0x00022c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_6,		0x000230),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_7,		0x000234),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
 	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2428bc64cb1d..2edea901bbd5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -338,6 +338,30 @@ enum ocelot_reg {
 	SYS_COUNT_RX_CONTROL,
 	SYS_COUNT_RX_LONGS,
 	SYS_COUNT_RX_CLASSIFIED_DROPS,
+	SYS_COUNT_RX_RED_PRIO_0,
+	SYS_COUNT_RX_RED_PRIO_1,
+	SYS_COUNT_RX_RED_PRIO_2,
+	SYS_COUNT_RX_RED_PRIO_3,
+	SYS_COUNT_RX_RED_PRIO_4,
+	SYS_COUNT_RX_RED_PRIO_5,
+	SYS_COUNT_RX_RED_PRIO_6,
+	SYS_COUNT_RX_RED_PRIO_7,
+	SYS_COUNT_RX_YELLOW_PRIO_0,
+	SYS_COUNT_RX_YELLOW_PRIO_1,
+	SYS_COUNT_RX_YELLOW_PRIO_2,
+	SYS_COUNT_RX_YELLOW_PRIO_3,
+	SYS_COUNT_RX_YELLOW_PRIO_4,
+	SYS_COUNT_RX_YELLOW_PRIO_5,
+	SYS_COUNT_RX_YELLOW_PRIO_6,
+	SYS_COUNT_RX_YELLOW_PRIO_7,
+	SYS_COUNT_RX_GREEN_PRIO_0,
+	SYS_COUNT_RX_GREEN_PRIO_1,
+	SYS_COUNT_RX_GREEN_PRIO_2,
+	SYS_COUNT_RX_GREEN_PRIO_3,
+	SYS_COUNT_RX_GREEN_PRIO_4,
+	SYS_COUNT_RX_GREEN_PRIO_5,
+	SYS_COUNT_RX_GREEN_PRIO_6,
+	SYS_COUNT_RX_GREEN_PRIO_7,
 	SYS_COUNT_TX_OCTETS,
 	SYS_COUNT_TX_UNICAST,
 	SYS_COUNT_TX_MULTICAST,
@@ -352,7 +376,41 @@ enum ocelot_reg {
 	SYS_COUNT_TX_512_1023,
 	SYS_COUNT_TX_1024_1526,
 	SYS_COUNT_TX_1527_MAX,
+	SYS_COUNT_TX_YELLOW_PRIO_0,
+	SYS_COUNT_TX_YELLOW_PRIO_1,
+	SYS_COUNT_TX_YELLOW_PRIO_2,
+	SYS_COUNT_TX_YELLOW_PRIO_3,
+	SYS_COUNT_TX_YELLOW_PRIO_4,
+	SYS_COUNT_TX_YELLOW_PRIO_5,
+	SYS_COUNT_TX_YELLOW_PRIO_6,
+	SYS_COUNT_TX_YELLOW_PRIO_7,
+	SYS_COUNT_TX_GREEN_PRIO_0,
+	SYS_COUNT_TX_GREEN_PRIO_1,
+	SYS_COUNT_TX_GREEN_PRIO_2,
+	SYS_COUNT_TX_GREEN_PRIO_3,
+	SYS_COUNT_TX_GREEN_PRIO_4,
+	SYS_COUNT_TX_GREEN_PRIO_5,
+	SYS_COUNT_TX_GREEN_PRIO_6,
+	SYS_COUNT_TX_GREEN_PRIO_7,
 	SYS_COUNT_TX_AGING,
+	SYS_COUNT_DROP_LOCAL,
+	SYS_COUNT_DROP_TAIL,
+	SYS_COUNT_DROP_YELLOW_PRIO_0,
+	SYS_COUNT_DROP_YELLOW_PRIO_1,
+	SYS_COUNT_DROP_YELLOW_PRIO_2,
+	SYS_COUNT_DROP_YELLOW_PRIO_3,
+	SYS_COUNT_DROP_YELLOW_PRIO_4,
+	SYS_COUNT_DROP_YELLOW_PRIO_5,
+	SYS_COUNT_DROP_YELLOW_PRIO_6,
+	SYS_COUNT_DROP_YELLOW_PRIO_7,
+	SYS_COUNT_DROP_GREEN_PRIO_0,
+	SYS_COUNT_DROP_GREEN_PRIO_1,
+	SYS_COUNT_DROP_GREEN_PRIO_2,
+	SYS_COUNT_DROP_GREEN_PRIO_3,
+	SYS_COUNT_DROP_GREEN_PRIO_4,
+	SYS_COUNT_DROP_GREEN_PRIO_5,
+	SYS_COUNT_DROP_GREEN_PRIO_6,
+	SYS_COUNT_DROP_GREEN_PRIO_7,
 	SYS_RESET_CFG,
 	SYS_SR_ETYPE_CFG,
 	SYS_VLAN_ETYPE_CFG,
@@ -633,13 +691,13 @@ enum ocelot_stat {
 };
 
 struct ocelot_stat_layout {
-	u32 offset;
+	u32 reg;
 	char name[ETH_GSTRING_LEN];
 };
 
 struct ocelot_stats_region {
 	struct list_head node;
-	u32 offset;
+	u32 base;
 	int count;
 	u32 *buf;
 };
@@ -877,8 +935,8 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
-#define ocelot_bulk_read_rix(ocelot, reg, ri, buf, count) \
-	__ocelot_bulk_read_ix(ocelot, reg, reg##_RSZ * (ri), buf, count)
+#define ocelot_bulk_read(ocelot, reg, buf, count) \
+	__ocelot_bulk_read_ix(ocelot, reg, 0, buf, count)
 
 #define ocelot_read_ix(ocelot, reg, gi, ri) \
 	__ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-- 
2.34.1

