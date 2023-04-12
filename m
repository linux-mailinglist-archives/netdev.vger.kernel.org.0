Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC0A6DF61C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjDLMu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDLMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:50:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91A2136;
        Wed, 12 Apr 2023 05:49:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGMSPVXm6YkJzMykY44BFuMGA/HG4yKPe4ggbaiVTK8lP+D0imAN2ZReL596i/s58wcYvBDFHLcED4zwm+5Nk0uCouLXBc2AX/P8mrdFUSTItysOrqP/k1CBZ3aYSipp3ExwIbYHT5ZyrUfvWJ6/tMHc9GHmBOyhr8k//FljQHJ0tIvEkUjozH1F2GCrgrE5Jt8l15tPXfMRfXfP7QouUSyJutMuO7OaavzZ5XlOzreuKqfJAuAfo9LGpUib29vIlTeRYnd7P10pw0nX1x1Wh0kMhJQxMOHslFNh5j/p8UnxuTTWN9V81hmIAjeDicT4yXCNeDsMS6NsgtxU6jRQoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnmNMpuh9UU9gdg3p3oYozM1mlgGEylNuPOANWgIrlk=;
 b=jiRtfoVg+lHFFfni/AQeqwWB/1YcvauqT15/NJphTk60XUsmj6FLsmSQO3TR/HOqbXUFGUitwlanT0D33lvrXMCB989QoP4v2skMp4z0QGjvwqWjRA9kdyrl3Pe6Y/f2X8ZaDJ7jrbLu6xwYUd9gJ5AxrUSTmFqmt22q2h8Vp5nYuC5FERzAMo5u/QumA+57CwjL8NCTZq6zRWjf3Y/z+DcAVCGvSbjb7vB9lTkY6bikOcfNigQ3kTUA/9XCb2IAMgcpR8Seo2mu6Vdsf4E1J69fZCJq0SKRrmC8iv413Y1aQ40po1tCunmlUlciWzsz9sg76wlsjnKXKq5iT5DJlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnmNMpuh9UU9gdg3p3oYozM1mlgGEylNuPOANWgIrlk=;
 b=XbsQ2sCnJ7EnYUG6R2nAlUeqUxTiQJH51mFDuiW6lHe041QLDqGtkRpKehtExZWxIn8hpAdnjiQZ7i/unpDCSWllo2q7uQkA9kNtWMjzFEQRIOQ8QF5P4lrOn/q1KDh+e0fhL8eN4OA6m4/MjUO2zsQcqabLheCgo5kqCGwo4zY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:48:00 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:48:00 +0000
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
Subject: [PATCH net-next 8/8] net: mscc: ocelot: fix ineffective WARN_ON() in ocelot_stats.c
Date:   Wed, 12 Apr 2023 15:47:37 +0300
Message-Id: <20230412124737.2243527-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: dcee1635-8bd0-42da-f09a-08db3b5425c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sI8B/2z+QKPv91tuZa+AsdCwSSoRiIic8SUxjWatlgqLW06eHoRUnmd+/EdVfVOOhVHhLh32+qZzQG5vF5mlAOR94U8Zvg4rILmkcjofDvAFM8OX/aW1hthPyZ5fD88SDZdYyYUrrPfKTqDzdMZxXruko1NZC1SAERpdom2lyaVjIRt0HPtUM3c/8eYPo+MeEMPrYeXrTW0y+DrBUCvCCZw/BvV6eGmA/b2+pKUMgXHIblqpIK5Wwe886x0YoArOorJfVvPVgNpWTPSfq94OsV+UjUMHqjBtqyf5GZHb7bVmJyIqce9W8QmPzYngRTlUTIcEwtSR+ZslJWRbPEzgiRWj8vSfbN4r/xI6ZkjidAPX3JZ+86SGBf96jX293nj/rtBkfne0yvmWk5LfXtnbb+Cgy3/wBvWQREFlApo4BqhJn9oausPimc3Dz4THd3bOe2c2zgLRMbOxYteseQNIolaUtPziaQVwmtNl1bMLoozSXF4GftBVn0bWhyGsPwFzvloFGR/rhv91lIkIDwAF2fQUouRJqQCYilKGTm59qLLNYQw3tOP3BR0RHPOEnwj/qM3ZywtY7C8K2Qc2sZq80HIWdzcXbSLlr8QkCkjDLcnrpdXLKrsmrbkp9aUu4lCy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MvYcJ0w9mNfEqgWnkMszceoffGuplbqLs9tJOENUMKQ59ijPOchw6KHhhJfF?=
 =?us-ascii?Q?2a7jaPZsuj4+W0pTtHeCeX/3V4e1cHfmPzk2fo2Ph1QSiX1Tm7BTVPM7U1KJ?=
 =?us-ascii?Q?ZmOg2cLXUOyWfbSC8qKAcbEwgbI8cCzyHbJ837cA+qpVF3CEvY8AAK/OOfCa?=
 =?us-ascii?Q?kYJ8/SPuu+jOh8/jfF/BD7qcXIAHrRTRiNI25UMN3K3ArfnyiB1753zrp53p?=
 =?us-ascii?Q?tgtGnwj7TMF6GAwAJKQi8z9VoBkh5G8mmsPMxRuKDWEXqsHUeFde/UBSvizp?=
 =?us-ascii?Q?4yJq3McXFxvkWwcA9CvT3BUztxg4n3SNAlGilGnEDUpxOWwz16qLlwoHMWYM?=
 =?us-ascii?Q?aEw7PVxhuGAQylO+ilSit9n/TohDZHSF073eL/legQ1fTRqUSNi/cK1iCJ7W?=
 =?us-ascii?Q?TwrrU51BhtGQN9iqdwB+4sFPaIm2Bj04illGJhgq2U52vhL59KSYFgob9g4u?=
 =?us-ascii?Q?3inNThc5fRZw7EvOl23Et+9aUVy/v6OUjLMwejM0soAnLOxJ0XG2rg7osCj4?=
 =?us-ascii?Q?UlPtJF2xQwxga2Dggd0pqrCICh5Z+k/wNcFY9gkAs+dQpHWE8S5V+J18gzO3?=
 =?us-ascii?Q?WipP4HtTw676cCa4IdFHVW6zMeHzV4JAC++eFZwSJB7Pt9lVDQklh1/sqzhf?=
 =?us-ascii?Q?N/994e6BtBCqQYDaHp3+m4AGRXyHzLJ7Xy3sIITC+UzgSImbCtWON3U/bN9a?=
 =?us-ascii?Q?RFLD9iOlM747VN6OicVmUmYTTUo7j2rGywl2tA5eAh1pLSXVR1ig3uh9mdAZ?=
 =?us-ascii?Q?hTx5A8Se+CdghlAViK1T9SnvOz0lwzEqrGPURU5Mf0IueBr6l3iq3nqSN2Eb?=
 =?us-ascii?Q?poTMXHbaEUN5xGZgQ51SE/KpEimZQ1nTyJ1tFsNf+tE0JPu6ZWDc8E2rZImv?=
 =?us-ascii?Q?TmbrLn8y3JdFn/ueLjavAWYeN8rW9EFli1wgcvP96Htg3TZWkHgNlq+jyPeU?=
 =?us-ascii?Q?YGpuvipV7dbtGJEprIeaJJJhV3IoFr9DN72rrsc/fFs++p5I2A3gF2QtafMj?=
 =?us-ascii?Q?rhD0LnQCBgWTbzaxQBxhIsopfu3BRuyA/Yjdq4HwZV6k4um/pvoisnXUiBaK?=
 =?us-ascii?Q?6ftpJ39WMqnJEv9bA1KkyCHInYUZ5agrFws1X6ufQKsMEWb/YUcOF7UwuP/4?=
 =?us-ascii?Q?JNed7ZIp6z2a9ZBWRjKGDpfNmZDiULGzw44t4QjdqQZEvAIVSAPP+71pOIjJ?=
 =?us-ascii?Q?C1OVzpL8EdOyOxeKmrMJutiIyHwGY/HfUSie0E4jTxHJh8cC5rvX7n2v9XyS?=
 =?us-ascii?Q?ws9lsXxugr/aqw7U3P2vbcE9+loiOpXv//w1QWeMCxNKi0qf4WCeMwg5z3lx?=
 =?us-ascii?Q?K8ptXFHmlArj7JRGEw6iYK8JARLgBv94vnwRciGwSi6RTjRWbYd8xejXU7y7?=
 =?us-ascii?Q?QZDmjXmfqEFsanBsHLkMJdNFEyrCN4x4V6bMWJlnx8BrTzSOKsNGpQPlXZwr?=
 =?us-ascii?Q?Zsdjq8v4Iq0mjpLvG+nIqF7abhvsJ97sViS05CHy3tCuqOduN24sZg+6DTrk?=
 =?us-ascii?Q?iYiZ5kHcnIP+QTvuVqNn/2pl0sjFxr043Mg8rWZC2zVjNFDSrhnKajeqK/TO?=
 =?us-ascii?Q?KVHeYbhwDDkHIJ8r0LccQgbCsLXD4a2HOMp6ZH9tgXJ+HpygPO/JzYnpiM9i?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcee1635-8bd0-42da-f09a-08db3b5425c4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:48:00.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cfa9IPEp/YWY4gQmGA5dKPUw937HsLYWAZwwXIR/gTH4+dTROIycKmRKDKhK4zXlTfwzZoAhuli4DnpHIb5BA==
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

Since it is hopefully now clear that, since "last" and "layout[i].reg"
are enum types and not addresses, the existing WARN_ON() is ineffective
in checking that the _addresses_ are sorted in the proper order.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index e82c9d9d0ad3..5c55197c7327 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -901,6 +901,17 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 		if (!layout[i].reg)
 			continue;
 
+		/* enum ocelot_stat must be kept sorted in the same order
+		 * as the addresses behind layout[i].reg in order to have
+		 * efficient bulking
+		 */
+		if (last) {
+			WARN(ocelot->map[SYS][last & REG_MASK] >= ocelot->map[SYS][layout[i].reg & REG_MASK],
+			     "reg 0x%x had address 0x%x but reg 0x%x has address 0x%x, bulking broken!",
+			     last, ocelot->map[SYS][last & REG_MASK],
+			     layout[i].reg, ocelot->map[SYS][layout[i].reg & REG_MASK]);
+		}
+
 		if (region && ocelot->map[SYS][layout[i].reg & REG_MASK] ==
 		    ocelot->map[SYS][last & REG_MASK] + 4) {
 			region->count++;
@@ -910,12 +921,6 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 			if (!region)
 				return -ENOMEM;
 
-			/* enum ocelot_stat must be kept sorted in the same
-			 * order as layout[i].reg in order to have efficient
-			 * bulking
-			 */
-			WARN_ON(last >= layout[i].reg);
-
 			region->base = layout[i].reg;
 			region->first_stat = i;
 			region->count = 1;
-- 
2.34.1

