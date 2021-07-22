Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009403D271F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhGVPPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:15:39 -0400
Received: from mail-eopbgr40086.outbound.protection.outlook.com ([40.107.4.86]:15366
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232691AbhGVPPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:15:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zq2mKolcHJusQFuz6nD7I+ZV0Eoe4XQTQ37BxC9mlbC6wwLQhj8NpsThFpsln5TDK69CyzMYXk4r+PXsI7X+uwGgF56gXNCe161YBZO1nr9zSqV3MWpkmEBW9AeMne6ybwhAEzZPZMfCkeGockX81mAJPRTz3xEehlII13Y7bE3c13p0YSnDM0/aUHiBfe+LGDJ/29m53Qu5CLROjIajWsxmr1n5AO7Je8RCIAMIF6tcPl0HgYNArZFc8XC9FP+0vPHv33OQqDpT2xiRQaan5j5eC0UiBkLhO7TeqQNSLpK6tt28e+Fj6Ny27Arh1vZApNeMrKKpaDYieKNCiBZxQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AR6WD//KZxTUypdrDFJcein6r6LNsvooxui9tCi46OE=;
 b=N+TwFl3MbjQK3xc2RKoXNZjLGpU+98u1sgsP9Ik8oxKjokI5bSigxzerGlQHPdNDCUX/c+KcebufW10Ju8vqO3AnIMpTMlYoX+0+A2ZHGklZYNz7JU9MHKHVZsyd9U4DV29+7Ni7BKWHvP1QhZFu8g2iI1ndYJz9zf2ho6tjRZosT74p8MpvMrvNqk1IGpfhJKBynYwarUzyQOTvbFF3LhVrrhUlPCWHQHX6xqSVGoKdQ6x8KCTDipeHH66MMaaTOqiWYe6GrXl+gyF83SV2mgtOys7fo8Bde5ZbGBsheRqxltUhOPvnAO5qEZre6J2Riu2KivwhL6NGQ+J5/dPryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AR6WD//KZxTUypdrDFJcein6r6LNsvooxui9tCi46OE=;
 b=lCJ5Eyk/QfO5IqZgx3M68GKOYqipGfBgBsE4nra2ALtvvcReVA5RtwhWm95RA4Kb0KHZcBc66j1OmxaRJnuAPEbtp4eCKPbEbfrYXov1D1R0eZJ4xpOPZcB0eUa/7sK0oteOTPK+65WLaYIJyST0UIpdIZU/SSYiEPADITXdWyQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 15:56:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 15:56:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 2/5] net: dsa: track the number of switches in a tree
Date:   Thu, 22 Jul 2021 18:55:39 +0300
Message-Id: <20210722155542.2897921-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
References: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:56:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1129896-9236-4da7-9c16-08d94d293645
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6639529674F68845F60D08BDE0E49@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9PHUGV72Ul+xR1Rc0cNQ9Ms86N41Eg695mbENAQ39tkBYTmSYuMFdA8bP5Z7GmAXxcSDx3vQCwKl6tw1SVc2OM6bDlHK7PjV/zavSXY3Ok2BzrXze2Q7D7qa0K+pnzJVQ/09YaeY/RoZjU/RMIiXKGKN0Cqm5EzZsHpLGYHazj1vpUW52t/xJRSUBD0R58C73TiYmVYzz1jSSNCQfqf1GLISKiSd9cs4BA9tD+vZrTaLBdJO2Dx3rVBfJvrXJ+StP+GKPkzsQxt73/p0fNEkBwaR8YIa1h/lTZn/Wcu1pt/FV8NLKO4rvZ8j1KAV7jtDFAFklBzQCTlt3Ne3tfSUwwX36OaXhZNMYwbAswz9KWDFeLXMxRxytrY3yf1q80A0L7JD5c/ECZ/p9A1uBKssylrdPQ47fJqf9MODqTgAYSRo/fntr1wPWMHzQru4h3dDfLT2yZsJcslF7lide07BC6JQ6ZAGJCl+93uou2tPLnNZcsAtL8zdJo7BVg3JhQd5EBrB2KxF1mnWUadjltWXrwhhRARlURC0MPP25vmZbBeIyUhuLQeEnhgovKDtokWai6xG/XR0voK3ZzYkVF4eLfTdRf2Tzu8ncjxqj/Sr/ne/adXYyO+TK5D/rDlQyq/0oVtlEZVmeCbBk9X9s6Hnqj7q1l9L4do4/6Xa3953s73qlUuyo7p0wSKSOYHmEH21zGFPnVh9sjVSsMTfKkRIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(110136005)(6506007)(1076003)(4326008)(8936002)(478600001)(52116002)(6486002)(6666004)(36756003)(44832011)(66556008)(38350700002)(66946007)(316002)(38100700002)(86362001)(5660300002)(8676002)(26005)(7416002)(54906003)(66476007)(956004)(6512007)(2906002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rvcp1vBCMqbUGG9ImLQC4dYyn/fuWb4lzMu8cqE0xJao847bIXLVYBgrIzv5?=
 =?us-ascii?Q?rG4QqrYk2+mmXU3tGpDZenbOGAEiqGv6vg91Uempk7RzrCxfVidX8Ht06b2p?=
 =?us-ascii?Q?5GfsZWUrZM6jSV7bHVWTgFZMRqXiWm04N4IcPShu2RQKuREjtgCXqOTXrqlI?=
 =?us-ascii?Q?bxtYR1FruxZhG4/enAI8vJ6k1QXVexAmXEWDziqxJgpC8QljOS8HUQK9CoHj?=
 =?us-ascii?Q?qzmOs+Bjx3MTtVBZQl+wNl/ULr7+anrzpDyt9Xea9BNzbDW9SS0zuH59GcQY?=
 =?us-ascii?Q?j2s/KX7yLPujm2baDrtglfK+GUvZQuaxKhJw4lSpSyFp8U1y9mPU6cvzU4Yf?=
 =?us-ascii?Q?vMfEjL/fkIcc8ybfqSZ5F8SKXHqtMipGZ8HiGWA0sdUndCLi1Mb3IxSWFh1q?=
 =?us-ascii?Q?IbvoGG1X8AkOV8+9kvVV/o8ZSjHEVE05kFL+T0JFSaOr4XQjgikQtKFcp6+/?=
 =?us-ascii?Q?7iPbMhndssOGqhxPOPswg2QWI4qzufZndqqqlKQaENF746jEPuKI+Bvc6/fq?=
 =?us-ascii?Q?0lKZ8l3IoHNHU7CARQYGKq9TOdYwB1chU4niP8TPUjL+exsMIxwoRT4c/QBc?=
 =?us-ascii?Q?xJS3lrriFBFGuCZjzifxQARLdjq5ugofKQw+leJSSEZaaUzwAKFZcOInb/jr?=
 =?us-ascii?Q?34YTDKGuERrU6LkTUl0H/eGjqDhbxNjUCyjh5PzF9M+PZ0Tdytdw+zufrNQu?=
 =?us-ascii?Q?IPDwEs/QbNqCGVM23ARp8gTE/c6I3/ppDKdnohxET9gif5WJzlWKBQOydMJ2?=
 =?us-ascii?Q?ws3R5OnOjRKQ9tDSoIVClm4lZGsai2TZ8T0BgHN3nKTx9vWsce480fRlwmcQ?=
 =?us-ascii?Q?57W78k8Ofj29fllvodnO5rN1nYmZl7ip27i9Tsh4rDGuaHT66uNTZyOr/+Z7?=
 =?us-ascii?Q?dvLBGUcfEWtUjY9/3WSbwY0p9Tm3tjg2yPjBAxbQ5DE4Znfqd7vudNQR8iI/?=
 =?us-ascii?Q?39aA9fYq84NdG7qSwyr+B2nY0RXLsMq/ZIPgm6F0DMj8PXCgm0sPxaQiWvA7?=
 =?us-ascii?Q?bysF160/FvyweZtekrOVZhMtsJQr1+Q1cie3buZN52cDFVOhhdk0tAyHy0Tk?=
 =?us-ascii?Q?NXJAq0BN+GBJyEC6AiRHylN+qsCPLtfziM89PaFO3V5b64FMaLfhxWMecdrx?=
 =?us-ascii?Q?03Ab/rcDUyBJeSvwlcsCLJKMOxzndsLsh8YC34aLk04aPtUela2n7aW1pSfU?=
 =?us-ascii?Q?+4BksnmewHulTGQOcyD0x9la0Rr+JNJrBNRRlX967kbLez8l8DlGR+fDlkA1?=
 =?us-ascii?Q?r/htxKk3yb9RS2fXtb1UKaTs+8qA++u5oNFTnAlwXhLLaoOfTSgzgZgYGWYS?=
 =?us-ascii?Q?Ody0LzIwHkzZv7alkGsZVde+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1129896-9236-4da7-9c16-08d94d293645
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:56:05.0934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJZNTpvz/eON7Op/G/SD4yNiNV+91OEqZTShe7qjvx7J2dNvFciPPQVjzUSYKO1pD6DlEiHHLZEpxHJc9LAVZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of supporting data plane forwarding on behalf of a
software bridge, some drivers might need to view bridges as virtual
switches behind the CPU port in a cross-chip topology.

Give them some help and let them know how many physical switches there
are in the tree, so that they can count the virtual switches starting
from that number on.

Note that the first dsa_switch_ops method where this information is
reliably available is .setup(). This is because of how DSA works:
in a tree with 3 switches, each calling dsa_register_switch(), the first
2 will advance until dsa_tree_setup() -> dsa_tree_setup_routing_table()
and exit with error code 0 because the topology is not complete. Since
probing is parallel at this point, one switch does not know about the
existence of the other. Then the third switch comes, and for it,
dsa_tree_setup_routing_table() returns complete = true. This switch goes
ahead and calls dsa_tree_setup_switches() for everybody else, calling
their .setup() methods too. This acts as the synchronization point.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3: patch is new
v3->v5: none

 include/net/dsa.h | 3 +++
 net/dsa/dsa2.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9e5593885357..929bcaec4d41 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -159,6 +159,9 @@ struct dsa_switch_tree {
 	 */
 	struct net_device **lags;
 	unsigned int lags_len;
+
+	/* Track the largest switch index within a tree */
+	unsigned int last_switch;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 185629f27f80..de5e93ba2a9d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1265,6 +1265,9 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 		return -EEXIST;
 	}
 
+	if (ds->dst->last_switch < ds->index)
+		ds->dst->last_switch = ds->index;
+
 	return 0;
 }
 
-- 
2.25.1

