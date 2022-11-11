Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31C0626333
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiKKUtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiKKUto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:49:44 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2103.outbound.protection.outlook.com [40.107.244.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2CB845F4;
        Fri, 11 Nov 2022 12:49:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaWo30r9TyHH3HISDx8Lmce7dZPzbrmAun6UZ73vXuMbzpnpIVCRCc93fldfs4TZQHcp/Y7MmqNV8p60OiFDTsmkFhTJ6bHpUS1jpXzRdZzLopiJtvQZxBeWz4OqzjzYswAXKHUhiQkZnHN+C3m4sd6/cUhvdX0qeLAY7yKveImI7RBHR7v/BZc6i2ZBVQsfSptPD2hMMMvNo39MPOhkZoh/CenHrDtUvJyRy1GEcEthwpqvSrlrE5I9+ZSW6j7Wi2oOFALqp+5qW1kGc3cfzNnXckulb6bzhLONsCc0MCj9/1K2eY8Pbd6r8tuKP02uFBz/+fPR71lBscV3oSvRmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+/z7qIZWuh6SEmTvAUqqry98EjpE+FsvrPmi73Davc=;
 b=nj0e55QbcKUBbgyc+6ytmkdCI2wemOpJnEjZJeNfAABKkVRFiIERfDfuBCuyGCfyJzk1zLgMZdsDZcHGq1ce7S7Ui5hH9aOpR1yDoGTyOfR+5pEAug/K59d29sQ0oYHM4LzhHCOiQpmwBcrNzKwDhqoKopxbLLcEXk+otc/b8Lr9sqVM6dFcXecUN9Fd4y8zVrS/ttAYNGNq/QsYSo9frM/HV42GNfCbiSWMQ6lSThq8iQOldsyIW1+olXMkHKo2epeNUG3dV98DdgyhQcB3m9ndtka5DZFKCfwesvOOhftWTUrfXN1xxwd+DmvNJhjGz/HDCqv3fwgWJv2kG2046A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+/z7qIZWuh6SEmTvAUqqry98EjpE+FsvrPmi73Davc=;
 b=znkRZUIbHlQnQWCPYHZiYMGhQgr+MI82FrDPmGL1ww9T7JedpGNOyc+LdQj1UMyRxU4lgkAUVIemC8WEiu7QeY7c6F3P9SJ1aXe14WOL5Uhrf4Lktd/tz0H3uVhpjEbKwFfbNEh2lClvy6gxNSGDhx90Y9e7QIngeGlOnEgFhtI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4588.namprd10.prod.outlook.com
 (2603:10b6:806:f8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 20:49:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 20:49:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 2/2] net: mscc: ocelot: remove unnecessary exposure of stats structures
Date:   Fri, 11 Nov 2022 12:49:24 -0800
Message-Id: <20221111204924.1442282-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221111204924.1442282-1-colin.foster@in-advantage.com>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: b10ff471-460a-49a0-466f-08dac42640c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0+851MKmbLa23CY+z/mzJlC0exepgRCve3En6GuZ7Ue2tRx00OldXYQJ+b9/flzKh63Pwo+Kes5DdbhgOjXPCkJ8LqbU5INz5EaT3NuCXgHGQynGSCz5XUxNhzEDE/DHXoWnTwLw2Q3q+CB6dobN2IdgBl8HgfUm+oBxRXByem5eTiI0l8XTQ2fzW0W2ucR8o9OyYngfF6QJVD7kU4kEfminuQXcpcMMavxQD89jI0SRUO/hGxXjs1TcJm8/QVHQBdnACJGcLJS/9s7aS7/5WsBjXiJ91YRvT8lp0zywgR8/Xeex8IhyWzIqKHodq3N+80CHggflUpSB+sp8afjyGpQVSypdrgmV3634yPytUwJ5Ia3cpqXswzGJ+Is54ANO4zpR1vGxYP9Osflc2xrMFnyKfZsvjULV9HCdo45FAqyTRznuAMgfOYFMu0HSEysTaLZSchTS+pdACvnGr+9d+vEGhZ5/tjB4OBjW2BQLqwcOe0SUloi/KfSeOaU0lj0zTLQTH/S5DXUKqfxbEjioBJlCSGitduIhiOOwQivPw6FrVlT+dKk3MKeHiR/iFPfcRTtOwP0JOxswr1DKmAUdKtw8Q280mco1wUgNrqA+TqsNAWHgG3Yb1eepbBUGAtHKmGhxlYcT8Hx4ljVYaZPl2U3+NmqLbcQkbsXK2TRyOl3I3CjO+KLNfD2NgXGN+8Rd0TpqImdEgM3NHbzSmN7hjpI3bmvw+mMByMqWOK4VputqwOpIpEaIQ89qgFxKpig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199015)(54906003)(6666004)(86362001)(6512007)(26005)(36756003)(2616005)(4326008)(66476007)(1076003)(5660300002)(66946007)(186003)(66556008)(30864003)(41300700001)(7416002)(8676002)(2906002)(83380400001)(316002)(44832011)(8936002)(6506007)(52116002)(38350700002)(38100700002)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iwDAcneZFkQ8mr9HEK+lN1IcnaQPq/tXIvcRDXOh6Y1W9uzh7RxGctlQTk7X?=
 =?us-ascii?Q?uSpqo+TGxQ1NSalw/h1FIBfnCEPp5prA6N/GBjiTnc+bHa7GM015rU0LEmGH?=
 =?us-ascii?Q?gym2IW4qQcghpVRIoD/Vj6mocKfuGuivrRMUZ+kUi5+iAoSAit5U437oO0DK?=
 =?us-ascii?Q?sbPHvzWNuQUVfBMvyHqsVDwHtRhupM09IWk/oOdEKApSFvvoi7qzUWVQEkYm?=
 =?us-ascii?Q?jS1G4BiQRG2ZTMk1G33jY4oVhaxCRB5X+yEfI+900fu10DDXO4hmItpbBauN?=
 =?us-ascii?Q?zcp7Kzfu0Ddt+/UsnIiCw/BIR6h4HoSEC+uSKuU8FvjALU7lqtBQo5TTQXA2?=
 =?us-ascii?Q?QTVLqqDSExNkNFvToBrAvKIxZJqj97QpumMNJ2WMGamJmJx/1nPl3LGPBz/U?=
 =?us-ascii?Q?jfFzQsC5PYLJtZ8V/vmRAXKvxCWEFe3+n9/uqR2LbyeCCWoaQamjAjKLcB7u?=
 =?us-ascii?Q?us+4DWoGSuqgeoc2Oyoga+EPIIBF6MKWTvQll+wOCvWKrgP7JJxzUIfUYxGm?=
 =?us-ascii?Q?0kZYtzws9LxGAiOvEhmgwU0o9ciGkhR7GDbO3VT/ureAcoi914opIDHW4X46?=
 =?us-ascii?Q?YStn5X7ORKau0LuJwJD0E0g2UibKlf0L0wPKd8giAAdSim56UUiWxjA1oGNf?=
 =?us-ascii?Q?Cj8TbN+0GcngCnsU0EwTLSlXFozPjOGcy2nq1gSQW6dxTWQbkdaHeaxAtnHt?=
 =?us-ascii?Q?5cTLWyPmNHriuiyJNfTHDiEs8FgQon1dpppYwJKP2jALExnNpHzEYEMAoUhl?=
 =?us-ascii?Q?m/iHDQEl0+0ZX1jH5F48u8SuPTapAwOr8BMBe/y0L2tESQIeeBBrMytJNNiK?=
 =?us-ascii?Q?DCduKbop8xRZF6iG8cGppqn4LbKbFqhntUtXsN3kV4EOaYmuAkyw8Pfff0Tr?=
 =?us-ascii?Q?6kXDBB2voYYLM0AC+Su/jJKmgdKSrK04V4OBtTC1IT7f6MqoClqtUCpQWg/5?=
 =?us-ascii?Q?hT1NNecBAJL/xBb7GQzdcZq5uaYz9oZkWMNuDnnkAdwluNu1zCuwznHsLnsH?=
 =?us-ascii?Q?pF0z4JjA38HHMlKz5cFcahibCxivqIttXxgyGOqi3m+shtwxxyhXI7YXCDFr?=
 =?us-ascii?Q?zkRw1E7mTcaJkXeszhfUSu0yjAMNAARkezt9fXaD5ORhCzB8NZYmYUAfBbiW?=
 =?us-ascii?Q?x2pngCzBdqU20cKdImZWaHW//hTm3foJELPgi627xcMlMbrG0xP0k0Xm9JIl?=
 =?us-ascii?Q?pVci/kAMB36SXLK2uRsb6OUlGIlJ58+OOZnq3vfq0awdZFZCexHjMc4TknVQ?=
 =?us-ascii?Q?WkuzLJe8UiJaCLkxpz7tqdHIIHLnocD/lM+MUfVajfltZEr4wdY3ZuIh4yT0?=
 =?us-ascii?Q?tnAxl9eFnWH7+kVh+EwL3lYK0TyG69PTwHnpL4dZrKsUi4bC2H/oWPgk5aTZ?=
 =?us-ascii?Q?xUd1cYK3LNq0bu7bgTzQmUeZBPcMfXrcJBi6pjGqOKaB6X4qLH7OOM8uUTYB?=
 =?us-ascii?Q?WI9xumJkUKZ23tYBUpnnS/91a+toTGrjbZX4iWflalYL3oAQWrPH/b8KWNSM?=
 =?us-ascii?Q?F4PABF5yuHFmPqQ6W+i1HnVXiZhDYJA4woGYq7FfzI97oiKOs1G3R7lOkv2y?=
 =?us-ascii?Q?AM/4UXGQPF6uLX+B6O5xRZ0Y8HlnBGTZRKbZOE2QC1iW5gbkeEjh+Pv43BMi?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10ff471-460a-49a0-466f-08dac42640c8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 20:49:40.3202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NTnJ4PE78267UCBc6JVgBtj6EK8/gmtE3W+clK96dGkdG1zaKPabdHyIhyxxfC1RivalFcBLcsaPZ55en1iXxDRzTyA4OL+vjvL5nViWi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4588
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
definitions between all drivers") there is no longer a need to share the
stats structures to the world. Relocate these definitions to inside
ocelot_stats.c instead of a global include header.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 216 +++++++++++++++++++++++
 include/soc/mscc/ocelot.h                | 215 ----------------------
 2 files changed, 216 insertions(+), 215 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 5dc132f61d6a..68e9f450c468 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -9,6 +9,221 @@
 #include <linux/workqueue.h>
 #include "ocelot.h"
 
+enum ocelot_stat {
+	OCELOT_STAT_RX_OCTETS,
+	OCELOT_STAT_RX_UNICAST,
+	OCELOT_STAT_RX_MULTICAST,
+	OCELOT_STAT_RX_BROADCAST,
+	OCELOT_STAT_RX_SHORTS,
+	OCELOT_STAT_RX_FRAGMENTS,
+	OCELOT_STAT_RX_JABBERS,
+	OCELOT_STAT_RX_CRC_ALIGN_ERRS,
+	OCELOT_STAT_RX_SYM_ERRS,
+	OCELOT_STAT_RX_64,
+	OCELOT_STAT_RX_65_127,
+	OCELOT_STAT_RX_128_255,
+	OCELOT_STAT_RX_256_511,
+	OCELOT_STAT_RX_512_1023,
+	OCELOT_STAT_RX_1024_1526,
+	OCELOT_STAT_RX_1527_MAX,
+	OCELOT_STAT_RX_PAUSE,
+	OCELOT_STAT_RX_CONTROL,
+	OCELOT_STAT_RX_LONGS,
+	OCELOT_STAT_RX_CLASSIFIED_DROPS,
+	OCELOT_STAT_RX_RED_PRIO_0,
+	OCELOT_STAT_RX_RED_PRIO_1,
+	OCELOT_STAT_RX_RED_PRIO_2,
+	OCELOT_STAT_RX_RED_PRIO_3,
+	OCELOT_STAT_RX_RED_PRIO_4,
+	OCELOT_STAT_RX_RED_PRIO_5,
+	OCELOT_STAT_RX_RED_PRIO_6,
+	OCELOT_STAT_RX_RED_PRIO_7,
+	OCELOT_STAT_RX_YELLOW_PRIO_0,
+	OCELOT_STAT_RX_YELLOW_PRIO_1,
+	OCELOT_STAT_RX_YELLOW_PRIO_2,
+	OCELOT_STAT_RX_YELLOW_PRIO_3,
+	OCELOT_STAT_RX_YELLOW_PRIO_4,
+	OCELOT_STAT_RX_YELLOW_PRIO_5,
+	OCELOT_STAT_RX_YELLOW_PRIO_6,
+	OCELOT_STAT_RX_YELLOW_PRIO_7,
+	OCELOT_STAT_RX_GREEN_PRIO_0,
+	OCELOT_STAT_RX_GREEN_PRIO_1,
+	OCELOT_STAT_RX_GREEN_PRIO_2,
+	OCELOT_STAT_RX_GREEN_PRIO_3,
+	OCELOT_STAT_RX_GREEN_PRIO_4,
+	OCELOT_STAT_RX_GREEN_PRIO_5,
+	OCELOT_STAT_RX_GREEN_PRIO_6,
+	OCELOT_STAT_RX_GREEN_PRIO_7,
+	OCELOT_STAT_TX_OCTETS,
+	OCELOT_STAT_TX_UNICAST,
+	OCELOT_STAT_TX_MULTICAST,
+	OCELOT_STAT_TX_BROADCAST,
+	OCELOT_STAT_TX_COLLISION,
+	OCELOT_STAT_TX_DROPS,
+	OCELOT_STAT_TX_PAUSE,
+	OCELOT_STAT_TX_64,
+	OCELOT_STAT_TX_65_127,
+	OCELOT_STAT_TX_128_255,
+	OCELOT_STAT_TX_256_511,
+	OCELOT_STAT_TX_512_1023,
+	OCELOT_STAT_TX_1024_1526,
+	OCELOT_STAT_TX_1527_MAX,
+	OCELOT_STAT_TX_YELLOW_PRIO_0,
+	OCELOT_STAT_TX_YELLOW_PRIO_1,
+	OCELOT_STAT_TX_YELLOW_PRIO_2,
+	OCELOT_STAT_TX_YELLOW_PRIO_3,
+	OCELOT_STAT_TX_YELLOW_PRIO_4,
+	OCELOT_STAT_TX_YELLOW_PRIO_5,
+	OCELOT_STAT_TX_YELLOW_PRIO_6,
+	OCELOT_STAT_TX_YELLOW_PRIO_7,
+	OCELOT_STAT_TX_GREEN_PRIO_0,
+	OCELOT_STAT_TX_GREEN_PRIO_1,
+	OCELOT_STAT_TX_GREEN_PRIO_2,
+	OCELOT_STAT_TX_GREEN_PRIO_3,
+	OCELOT_STAT_TX_GREEN_PRIO_4,
+	OCELOT_STAT_TX_GREEN_PRIO_5,
+	OCELOT_STAT_TX_GREEN_PRIO_6,
+	OCELOT_STAT_TX_GREEN_PRIO_7,
+	OCELOT_STAT_TX_AGED,
+	OCELOT_STAT_DROP_LOCAL,
+	OCELOT_STAT_DROP_TAIL,
+	OCELOT_STAT_DROP_YELLOW_PRIO_0,
+	OCELOT_STAT_DROP_YELLOW_PRIO_1,
+	OCELOT_STAT_DROP_YELLOW_PRIO_2,
+	OCELOT_STAT_DROP_YELLOW_PRIO_3,
+	OCELOT_STAT_DROP_YELLOW_PRIO_4,
+	OCELOT_STAT_DROP_YELLOW_PRIO_5,
+	OCELOT_STAT_DROP_YELLOW_PRIO_6,
+	OCELOT_STAT_DROP_YELLOW_PRIO_7,
+	OCELOT_STAT_DROP_GREEN_PRIO_0,
+	OCELOT_STAT_DROP_GREEN_PRIO_1,
+	OCELOT_STAT_DROP_GREEN_PRIO_2,
+	OCELOT_STAT_DROP_GREEN_PRIO_3,
+	OCELOT_STAT_DROP_GREEN_PRIO_4,
+	OCELOT_STAT_DROP_GREEN_PRIO_5,
+	OCELOT_STAT_DROP_GREEN_PRIO_6,
+	OCELOT_STAT_DROP_GREEN_PRIO_7,
+	OCELOT_NUM_STATS,
+};
+
+struct ocelot_stat_layout {
+	u32 reg;
+	char name[ETH_GSTRING_LEN];
+};
+
+/* 32-bit counter checked for wraparound by ocelot_port_update_stats()
+ * and copied to ocelot->stats.
+ */
+#define OCELOT_STAT(kind) \
+	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind }
+/* Same as above, except also exported to ethtool -S. Standard counters should
+ * only be exposed to more specific interfaces rather than by their string name.
+ */
+#define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
+	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind, .name = ethtool_name }
+
+#define OCELOT_COMMON_STATS \
+	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
+	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
+	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
+	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
+	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
+	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
+	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
+	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
+	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
+	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
+	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
+	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
+	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
+	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
+	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
+	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
+	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
+	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
+	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
+	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")
+
+struct ocelot_stats_region {
+	struct list_head node;
+	u32 base;
+	int count;
+	u32 *buf;
+};
+
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
@@ -460,3 +675,4 @@ void ocelot_stats_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 }
+
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 995b5950afe6..df62be80a193 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -596,221 +596,6 @@ enum ocelot_ptp_pins {
 	TOD_ACC_PIN
 };
 
-enum ocelot_stat {
-	OCELOT_STAT_RX_OCTETS,
-	OCELOT_STAT_RX_UNICAST,
-	OCELOT_STAT_RX_MULTICAST,
-	OCELOT_STAT_RX_BROADCAST,
-	OCELOT_STAT_RX_SHORTS,
-	OCELOT_STAT_RX_FRAGMENTS,
-	OCELOT_STAT_RX_JABBERS,
-	OCELOT_STAT_RX_CRC_ALIGN_ERRS,
-	OCELOT_STAT_RX_SYM_ERRS,
-	OCELOT_STAT_RX_64,
-	OCELOT_STAT_RX_65_127,
-	OCELOT_STAT_RX_128_255,
-	OCELOT_STAT_RX_256_511,
-	OCELOT_STAT_RX_512_1023,
-	OCELOT_STAT_RX_1024_1526,
-	OCELOT_STAT_RX_1527_MAX,
-	OCELOT_STAT_RX_PAUSE,
-	OCELOT_STAT_RX_CONTROL,
-	OCELOT_STAT_RX_LONGS,
-	OCELOT_STAT_RX_CLASSIFIED_DROPS,
-	OCELOT_STAT_RX_RED_PRIO_0,
-	OCELOT_STAT_RX_RED_PRIO_1,
-	OCELOT_STAT_RX_RED_PRIO_2,
-	OCELOT_STAT_RX_RED_PRIO_3,
-	OCELOT_STAT_RX_RED_PRIO_4,
-	OCELOT_STAT_RX_RED_PRIO_5,
-	OCELOT_STAT_RX_RED_PRIO_6,
-	OCELOT_STAT_RX_RED_PRIO_7,
-	OCELOT_STAT_RX_YELLOW_PRIO_0,
-	OCELOT_STAT_RX_YELLOW_PRIO_1,
-	OCELOT_STAT_RX_YELLOW_PRIO_2,
-	OCELOT_STAT_RX_YELLOW_PRIO_3,
-	OCELOT_STAT_RX_YELLOW_PRIO_4,
-	OCELOT_STAT_RX_YELLOW_PRIO_5,
-	OCELOT_STAT_RX_YELLOW_PRIO_6,
-	OCELOT_STAT_RX_YELLOW_PRIO_7,
-	OCELOT_STAT_RX_GREEN_PRIO_0,
-	OCELOT_STAT_RX_GREEN_PRIO_1,
-	OCELOT_STAT_RX_GREEN_PRIO_2,
-	OCELOT_STAT_RX_GREEN_PRIO_3,
-	OCELOT_STAT_RX_GREEN_PRIO_4,
-	OCELOT_STAT_RX_GREEN_PRIO_5,
-	OCELOT_STAT_RX_GREEN_PRIO_6,
-	OCELOT_STAT_RX_GREEN_PRIO_7,
-	OCELOT_STAT_TX_OCTETS,
-	OCELOT_STAT_TX_UNICAST,
-	OCELOT_STAT_TX_MULTICAST,
-	OCELOT_STAT_TX_BROADCAST,
-	OCELOT_STAT_TX_COLLISION,
-	OCELOT_STAT_TX_DROPS,
-	OCELOT_STAT_TX_PAUSE,
-	OCELOT_STAT_TX_64,
-	OCELOT_STAT_TX_65_127,
-	OCELOT_STAT_TX_128_255,
-	OCELOT_STAT_TX_256_511,
-	OCELOT_STAT_TX_512_1023,
-	OCELOT_STAT_TX_1024_1526,
-	OCELOT_STAT_TX_1527_MAX,
-	OCELOT_STAT_TX_YELLOW_PRIO_0,
-	OCELOT_STAT_TX_YELLOW_PRIO_1,
-	OCELOT_STAT_TX_YELLOW_PRIO_2,
-	OCELOT_STAT_TX_YELLOW_PRIO_3,
-	OCELOT_STAT_TX_YELLOW_PRIO_4,
-	OCELOT_STAT_TX_YELLOW_PRIO_5,
-	OCELOT_STAT_TX_YELLOW_PRIO_6,
-	OCELOT_STAT_TX_YELLOW_PRIO_7,
-	OCELOT_STAT_TX_GREEN_PRIO_0,
-	OCELOT_STAT_TX_GREEN_PRIO_1,
-	OCELOT_STAT_TX_GREEN_PRIO_2,
-	OCELOT_STAT_TX_GREEN_PRIO_3,
-	OCELOT_STAT_TX_GREEN_PRIO_4,
-	OCELOT_STAT_TX_GREEN_PRIO_5,
-	OCELOT_STAT_TX_GREEN_PRIO_6,
-	OCELOT_STAT_TX_GREEN_PRIO_7,
-	OCELOT_STAT_TX_AGED,
-	OCELOT_STAT_DROP_LOCAL,
-	OCELOT_STAT_DROP_TAIL,
-	OCELOT_STAT_DROP_YELLOW_PRIO_0,
-	OCELOT_STAT_DROP_YELLOW_PRIO_1,
-	OCELOT_STAT_DROP_YELLOW_PRIO_2,
-	OCELOT_STAT_DROP_YELLOW_PRIO_3,
-	OCELOT_STAT_DROP_YELLOW_PRIO_4,
-	OCELOT_STAT_DROP_YELLOW_PRIO_5,
-	OCELOT_STAT_DROP_YELLOW_PRIO_6,
-	OCELOT_STAT_DROP_YELLOW_PRIO_7,
-	OCELOT_STAT_DROP_GREEN_PRIO_0,
-	OCELOT_STAT_DROP_GREEN_PRIO_1,
-	OCELOT_STAT_DROP_GREEN_PRIO_2,
-	OCELOT_STAT_DROP_GREEN_PRIO_3,
-	OCELOT_STAT_DROP_GREEN_PRIO_4,
-	OCELOT_STAT_DROP_GREEN_PRIO_5,
-	OCELOT_STAT_DROP_GREEN_PRIO_6,
-	OCELOT_STAT_DROP_GREEN_PRIO_7,
-	OCELOT_NUM_STATS,
-};
-
-struct ocelot_stat_layout {
-	u32 reg;
-	char name[ETH_GSTRING_LEN];
-};
-
-/* 32-bit counter checked for wraparound by ocelot_port_update_stats()
- * and copied to ocelot->stats.
- */
-#define OCELOT_STAT(kind) \
-	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind }
-/* Same as above, except also exported to ethtool -S. Standard counters should
- * only be exposed to more specific interfaces rather than by their string name.
- */
-#define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
-	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind, .name = ethtool_name }
-
-#define OCELOT_COMMON_STATS \
-	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
-	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
-	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
-	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
-	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
-	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
-	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
-	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
-	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
-	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
-	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
-	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
-	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
-	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
-	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
-	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
-	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
-	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
-	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
-	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
-	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
-	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")
-
-struct ocelot_stats_region {
-	struct list_head node;
-	u32 base;
-	int count;
-	u32 *buf;
-};
-
 enum ocelot_tag_prefix {
 	OCELOT_TAG_PREFIX_DISABLED	= 0,
 	OCELOT_TAG_PREFIX_NONE,
-- 
2.25.1

