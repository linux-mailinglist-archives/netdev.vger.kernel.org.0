Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7D5B23EA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiIHQt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiIHQtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:19 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20087.outbound.protection.outlook.com [40.107.2.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4284A1316FE;
        Thu,  8 Sep 2022 09:49:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU71JROAaSIcpWtHe6ks+x+yDdaTDV77wLtsb/7OkuFh7+RxY/R/i1jxHecukpJEvNlOk1Y38BLhDPi0Q0j1Ftp0DDRYsSm3vy/4J1JrJ+QbbK5pVKGq3arq3T3AN01D/dF8YJBtP1VnxgYvqIoRwKSqZ4SptcWLr22t41jKGQ+yTMSd3NdYhf8AgX8CtlX2Hl3d7N7Pfjzh/5XWsW+MG1u1L+dg+QZpvqMmtg8tHQq+RkAdYxiJ6jstQce9NYWe64U4xjgrKUGwpgndizeYkIuE8IK16HXK56Ma5HRg4ZCK1RqIRWIsfBq84zaQaP3B0OoU2pWKnYwo2+E/zqjjng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/V+5XwogyZMzXOChyy5ExwQ6mjkhYTGhJTs3NRISur8=;
 b=l8/MZPhc+iGlS7c/+2Xg0xFhHFKcN0QaYrzBGVHv5N6Vf/UF4HH2vvurKSQKMu0GduJdrIdnapQwbR2u+tZh7zEiBi/tbbz/YVW1xWsagMb+odrYGbZbod0kIGxJZoxmmFtL3PNEPy3UBQ5mZTysS92wC9hQucG3X0K9vlvKsB4I9LbZBdr+WSTKS7bl8JNCPaL71jOD2GzgE8hc7uh0xVuT8SS2BcFp+n2giSXWyWt+iKtllHeNIIcoKj0CC39gvwI/GpbXmwObYYOeQHkEYweKCh5NvKCnmDI85kPju2G/IVLyqZOerXKL1em2LV2J0uQDKBQrRpthmicWwwDK3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/V+5XwogyZMzXOChyy5ExwQ6mjkhYTGhJTs3NRISur8=;
 b=Ao0TvPZfDfBwTtmQUWxsVTnVISauDRuskCmI+LenKVfyWScfsVODPR2DN+CueePNN8ZFJAn0+k6y2J8qvpJJgfMUDrSyPpoDJxxzJo0jbJSfc0D862mWZVSCSQ0Me3DU4ePw+jFuxG0ElnanHROr6d4oDq/sgiwU0f5/AZs8TWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5154.eurprd04.prod.outlook.com (2603:10a6:208:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 16:48:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/14] net: dsa: felix: add definitions for the stream filter counters
Date:   Thu,  8 Sep 2022 19:48:03 +0300
Message-Id: <20220908164816.3576795-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c01336a-8104-4ed4-51ac-08da91b9f438
X-MS-TrafficTypeDiagnostic: AM0PR04MB5154:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Vst4mcWz2qIuUQP5ooJMcEy1jlXFLRMAtItFwNnZR4uVwRW7IJHF/QSpzc9u4fxirOrAdnH1HsldOi4L2PzFf3JykaE11Flw6aN68gSnFIK/tnqqLyq7L/3L/uFhIb0m8JtRHtfavi6qdv5YilMecZiiJgEWHsDZtWAqMpWEzfs7W9djpB1hAwWybjqtzMinM5K+PlkQ9zUzmgDnwklVE7p1512lG0eZ9/zU6UwrCDc0x856xiZfXjUxcSlLwvfyhZA0KuAoR4t5TJP1S9pV5gYCAnvv5U7jI6nk1Ysw7HHrYvX3WSnjTfxYzlUKa3luSmHQfw+eBm5gusNHICuJ3OvSma6OeRUAeBg1gICN7R5hYGEWz5Li/p4kuSqpqt4gpi7Z/0yPN3awxSjBW/9I3kZiqr7AFJ6K59Z5FJmiA7qQ6Q8V0C88oRvJ25sjwSJi2nkkP9UqHxX8bigcn6w0SaMBYyC0ja4l0V5MW5kMM1u13xmxlIt01KHhU0qqAgLYsxCNz0T1bvmVPsW3y2I1T6RUf7Nxns1kQk6RSyRsCyg6v4BaUJ1eF26DAw9oDgcx3RyKIFO3Lpbxs9zcwrYfjE2Keulx/4kmpnfFdwdD4XYxXdBod3rZn1MT6NYxw0abi7IypxLc/1PJFaMPGw+L6GkuIErc8+V96MWbH79jQCh5+T+x9l/KGyfXwOIyqA/uFP+1LvLCwhCCOWeojbOdz5149oCt8Ru3SgnrlTQxDS6aohLfLONn676htTfJmWcy8CAP+vWHTjrDRQid7ZIMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(6506007)(41300700001)(1076003)(6512007)(6666004)(478600001)(6486002)(2616005)(26005)(52116002)(38100700002)(86362001)(38350700002)(5660300002)(83380400001)(54906003)(316002)(44832011)(4326008)(8676002)(2906002)(8936002)(66476007)(66556008)(66946007)(6916009)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dgp3P5OjMsqYvMZW3DHK9ncEMkm2PplOoN1razS/sY+pPUmQsi0c8ko0YEGj?=
 =?us-ascii?Q?PptJAas84UzKFMT8zB+wD/NJevJ4SNUN0uB5rtkSkZx5SjZlZcqEyRo85pKM?=
 =?us-ascii?Q?srHig2e76yU/MB2J6zZf3IX+VhuIbKocJkGPeR1zLvpOUurKt9RxV/32wXKw?=
 =?us-ascii?Q?Ar/nLchRK3cWyb8gqxKwNBKj3JiSvYCjIaUgcGeJMhBSdy86m1afitSsUsWZ?=
 =?us-ascii?Q?fA/gx3k6ivmKFErisszuDWNZqdYX6JARHxBHCc0b9+A6JZJnNCffyIXFJiTu?=
 =?us-ascii?Q?6dsPVJD3tYmVdCvzfbGpjwhQnahduiESJyaD2/dKl5KwmQastIgrJ0CH+KC+?=
 =?us-ascii?Q?sJGcLaZu2j0oD5XeQaNWYMmswLG7hx6PvpMwDae4orVXo2Nx03cPs+3iYwiA?=
 =?us-ascii?Q?4Q6I8MDHTa+L1z2jpGEaw1sOiNPTnj8BJ4nY5Bl31JqasESGauxpjr5LCa3X?=
 =?us-ascii?Q?vShrZK19KDXJhG0L87lMqQjSxsriB2/MmjOvTHh1a0h9MkpBc4rfXWoCpJZS?=
 =?us-ascii?Q?opz8ykOPLEwvV9lPLJuisC2Y2bTzjByhS2t/Bp/sWvWxeXBb7WzvbMG4SP1W?=
 =?us-ascii?Q?O4DMBdYOmIHQE4G2sEpFSyG40QGiZBVuwstlSIz8GpSi0r0QIzThSCuwWHhV?=
 =?us-ascii?Q?p5UFP4qqx5ZFd4psqVhhNIgsQw+iQEg38caANbqOomgvCZSPFXvaXurY6fgj?=
 =?us-ascii?Q?Y9tJVICdmliTUXorh464b/B1xKq399fRqtcbZ2UQDTOn/ghHk5rIzRCfD4me?=
 =?us-ascii?Q?Cgp7Oui8nu1tHsjbALp8fnUO5GiwKGl8FlFt44/7jXuAinmwzFjC7PdXt3tv?=
 =?us-ascii?Q?Yv6D8+zmIUYRViy2GX5qCup53fhRu0Jy539YS83yOVCpnPGt03vkrhjrA6jo?=
 =?us-ascii?Q?DGUQoxC+ii3/k5CAVgYImLN5/DWgNbn0aJxCmdtfJLyfjFEwvLCfRNCFC9Gk?=
 =?us-ascii?Q?7PPH5OhrtS0+hTM8tOQ0AZb3Czrle9c5VrLkJrQsH8xT+cI81bZVedLzx3Pq?=
 =?us-ascii?Q?I6jeiuTJ8T79piHPP0PPnmiivbAh98zrY94xqSsXKtiEkmskIEBwrMeVrxEP?=
 =?us-ascii?Q?hhoevrYYrBiFwiKt8izntF7O4S8DpVGUuNFSNDb7vpOcXaaMCQ004gZ3yz4a?=
 =?us-ascii?Q?ctT2zX+i8V9l1OmicK91ROnB76LlXWHKfKIUG2s3WhCheJ5LK9Noo5iamWmR?=
 =?us-ascii?Q?QnxJgsSGgZblSs+O1P0+0IhOSio1eqlMVFwQCCDTQiY7oyMORTMgV/pmEXWI?=
 =?us-ascii?Q?IsMD2GvhvpJl5GNmGuHgp6KSQcnmPak/olzQAKTswc4KTzeWevbW5jVrnYOk?=
 =?us-ascii?Q?c3QfFk2kN8PWs0ogQ9S0+C0W1PHPQpen6FHf9nYS4Dg0fPt0V9k83HbQmbi/?=
 =?us-ascii?Q?QSbWcJ6zoWRMpaeVPKparQf81731Nfr7vN64j6VbAv1vbpjQaRarX6hEDdT0?=
 =?us-ascii?Q?7u8c9sMv/4HqOiqa0gQReLybnC/7DNwpVCrAeJTZIpr4p1KSenEh8eWLV9kd?=
 =?us-ascii?Q?GCoyKBPjLF/Ord73P1TNGVCka2mnxj5ojeeTUE4+YjY6KH29K03Jr31zzazM?=
 =?us-ascii?Q?NCrEeDPU/oYPiPG99PVz7C8xUMoT0AQoYHR9qpcDaL01/+lxAhZgUgVNE65L?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c01336a-8104-4ed4-51ac-08da91b9f438
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:28.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJ90UZ3di6TgNeyoxhQHYWNvYVwmFg7aOYoMl+wlOufydQGZzIff9/yAOgUxq+jnXfjp18sVpminRexdZo3GWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TSN stream (802.1Qci, 802.1CB) filters are also accessed through
STAT_VIEW, just like the port registers, but these counters are per
stream, rather than per port. So we don't keep them in
ocelot_port_update_stats().

What we can do, however, is we can create register definitions for them
just like we have for the port counters, and delete the last remaining
user of the SYS_CNT register + a group index (read_gix).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 15 ++++++++++-----
 drivers/net/dsa/ocelot/seville_vsc9953.c |  1 -
 drivers/net/ethernet/mscc/vsc7514_regs.c |  1 -
 include/soc/mscc/ocelot.h                |  5 ++++-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1cdce8a98d1d..10db0b69b681 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -366,6 +366,10 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_DROP_GREEN_PRIO_5,	0x00043c),
 	REG(SYS_COUNT_DROP_GREEN_PRIO_6,	0x000440),
 	REG(SYS_COUNT_DROP_GREEN_PRIO_7,	0x000444),
+	REG(SYS_COUNT_SF_MATCHING_FRAMES,	0x000800),
+	REG(SYS_COUNT_SF_NOT_PASSING_FRAMES,	0x000804),
+	REG(SYS_COUNT_SF_NOT_PASSING_SDU,	0x000808),
+	REG(SYS_COUNT_SF_RED_FRAMES,		0x00080c),
 	REG(SYS_RESET_CFG,			0x000e00),
 	REG(SYS_SR_ETYPE_CFG,			0x000e04),
 	REG(SYS_VLAN_ETYPE_CFG,			0x000e08),
@@ -387,7 +391,6 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG_RESERVED(SYS_MMGT_FAST),
 	REG_RESERVED(SYS_EVENTS_DIF),
 	REG_RESERVED(SYS_EVENTS_CORE),
-	REG(SYS_CNT,				0x000000),
 	REG(SYS_PTP_STATUS,			0x000f14),
 	REG(SYS_PTP_TXSTAMP,			0x000f18),
 	REG(SYS_PTP_NXT,			0x000f1c),
@@ -2522,10 +2525,12 @@ static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 		   SYS_STAT_CFG_STAT_VIEW_M,
 		   SYS_STAT_CFG);
 
-	counters->match = ocelot_read_gix(ocelot, SYS_CNT, 0x200);
-	counters->not_pass_gate = ocelot_read_gix(ocelot, SYS_CNT, 0x201);
-	counters->not_pass_sdu = ocelot_read_gix(ocelot, SYS_CNT, 0x202);
-	counters->red = ocelot_read_gix(ocelot, SYS_CNT, 0x203);
+	counters->match = ocelot_read(ocelot, SYS_COUNT_SF_MATCHING_FRAMES);
+	counters->not_pass_gate = ocelot_read(ocelot,
+					      SYS_COUNT_SF_NOT_PASSING_FRAMES);
+	counters->not_pass_sdu = ocelot_read(ocelot,
+					     SYS_COUNT_SF_NOT_PASSING_SDU);
+	counters->red = ocelot_read(ocelot, SYS_COUNT_SF_RED_FRAMES);
 
 	/* Clear the PSFP counter. */
 	ocelot_write(ocelot,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b34f4cdfe814..26fdd0d90724 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -383,7 +383,6 @@ static const u32 vsc9953_sys_regmap[] = {
 	REG_RESERVED(SYS_MMGT_FAST),
 	REG_RESERVED(SYS_EVENTS_DIF),
 	REG_RESERVED(SYS_EVENTS_CORE),
-	REG_RESERVED(SYS_CNT),
 	REG_RESERVED(SYS_PTP_STATUS),
 	REG_RESERVED(SYS_PTP_TXSTAMP),
 	REG_RESERVED(SYS_PTP_NXT),
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 9cf82ecf191c..bd062203a6b2 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -283,7 +283,6 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_MMGT_FAST,				0x0006a0),
 	REG(SYS_EVENTS_DIF,				0x0006a4),
 	REG(SYS_EVENTS_CORE,				0x0006b4),
-	REG(SYS_CNT,					0x000000),
 	REG(SYS_PTP_STATUS,				0x0006b8),
 	REG(SYS_PTP_TXSTAMP,				0x0006bc),
 	REG(SYS_PTP_NXT,				0x0006c0),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2a7e18ee5577..99d679235070 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -411,6 +411,10 @@ enum ocelot_reg {
 	SYS_COUNT_DROP_GREEN_PRIO_5,
 	SYS_COUNT_DROP_GREEN_PRIO_6,
 	SYS_COUNT_DROP_GREEN_PRIO_7,
+	SYS_COUNT_SF_MATCHING_FRAMES,
+	SYS_COUNT_SF_NOT_PASSING_FRAMES,
+	SYS_COUNT_SF_NOT_PASSING_SDU,
+	SYS_COUNT_SF_RED_FRAMES,
 	SYS_RESET_CFG,
 	SYS_SR_ETYPE_CFG,
 	SYS_VLAN_ETYPE_CFG,
@@ -433,7 +437,6 @@ enum ocelot_reg {
 	SYS_MMGT_FAST,
 	SYS_EVENTS_DIF,
 	SYS_EVENTS_CORE,
-	SYS_CNT,
 	SYS_PTP_STATUS,
 	SYS_PTP_TXSTAMP,
 	SYS_PTP_NXT,
-- 
2.34.1

