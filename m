Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D703E1FEC
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbhHFAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:20:56 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:14702
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230004AbhHFAUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 20:20:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJuI/kfRrSIaOn6qjNI+fl/4UcpVvcHeVvp77CuSlh2XwOYMpwTepBr7pjIEXAq4gfvIzhNGPYrLwtrN4ejf0uxy1S1JrXW3yYucTFBabo+XQJ5FhkoLrOUkSK+qenFAJj2S8Iq9WkWhSf7k4wSwyBDn6Nf7njmKPSKWJ0yMFjZrX5LrGbEsIOWQa2P5FvR0zvNGU1IXbuoTbD4zZivCLIo1Lxvo61KN2qDzXN06cyXPONzZW3GV1U4bCoX/7eKkw4LQhmRyOjTvG1JU5Vb5v3+r2XaeQffQK2wASvDucQ3Cz0pHspu7JfMnqwCR9W84cqzkqD+0LjTS0zc0xZ0F1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwQcZPabyfpyeuiOiiafMW/rmKOR4XDAFyOsWwMrMCM=;
 b=k6Dk3tZT9B1Cl/MONIEPs4XCN19RA61KaUP8RP6P2uAGsgYakGStkWmxY07BpXcglP6gDz/9dFI0HUD8xNUmnMdEb8W6SdrugBdpLkmiLUDqpsSrQwy6bh3TRJXwajHEXGK05F84McHeCYAQ0QJZ8QZLC7X27GtYXJsf+KVKbhAbA9GXJ800bpXNPMpXxffw00TdXXElrviNOeZOm2NrEwhYLP/dR+KKfRWbiQ5pB/sxBNl/hXwBRF6wPzCwaqkZRKqmxmkKsq6Ak5Mqk9sBKNYPCr6oM4oZCuc7mseM2qO90KZRULSynrvd333Yc+kLOHVxqf3oTtVa1Qr7BuLzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwQcZPabyfpyeuiOiiafMW/rmKOR4XDAFyOsWwMrMCM=;
 b=QE+cwnrhVNgdX5DjA5JSz0dgYMW7MjFSXJhcDJxucptU7NnxrvZKu8sLLhL60cGfpWixKUfRfb+aUrjg7IiHypUGM3E4BFCPTGGMlki9Dw7nZOh4o6ZDNVY2YO8sqj8vZrAL+YlS/FW9PlV6wkbsVA0XclpXANuEudkvbrJgTzw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 00:20:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Fri, 6 Aug 2021
 00:20:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 1/3] net: dsa: stop syncing the bridge mcast_router attribute at join time
Date:   Fri,  6 Aug 2021 03:20:06 +0300
Message-Id: <20210806002008.2577052-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
References: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0087.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0087.eurprd08.prod.outlook.com (2603:10a6:800:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 00:20:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce4b50b3-261b-48db-5fcc-08d9587003b4
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341A896677D12C4AC64D5EFE0F39@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ibO2Y0QESysVXRmHbiaitoT0izOTXdDt2ptplZdS2JPXPwnmnU9A6ElPLN9Ou2DJqjsW1EpjKsS6hBOZH8iaDaOavkiRQcHG3+AMnN2tDmyWXLQX8gNnBrUAGJblZfDvPRfz/5OxOlAEtfh7i9oxDBeJv/r1Auhm+w5Cn0fwvkkq3uZxmmZigE1yvLKMf2a1DU4JdrwMLRZPbrvmWhsc/BU5bKoBqmpfuNIaMRYiiVO3IzQAmc5JFv8HiI4Q//XLdxJ8jFZKFYaWUwwXyavn/uJvz9Pw46f75qbwCxgFRnx0l7ypt2eWVYt72ixKh1y8uHLI1z7FGjXgjoMkpiE5BLPlJG0MegL4KwqdH6CWtAZN8NCG8d46jUX02HUgj17XeQ2dsD8n1KKwblygD6lrvTlv0vcG5VmuUAMbH6aqLV2krK9FC/GhI+NLY4zJHOTVo6aKm2QXMJQgeRGTO/kOLOqbRdOq/UA6LFpIka9IUj06gLsD71Mgl5RjzwmnOvFVoUmLESnQ7zUU/reptgnEtJr7Qfgg9YIWcQcjjxm6Xft1W4LEimKO0JKjhATLUvEZRoQqTV/F6gXdTPvoxFgyIF9oWsDAvHB/ml8FlqRXnLJcEufpi03BbZ3uAVf0j4LW7gjq1biyAn0z9ZdYsi+57Mg6YqIXlezhhuhD4/I7GPvvwXra8q6wPUBEGxntITedWsOcjJxL8INwMRKt0tj5Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(8676002)(44832011)(478600001)(8936002)(6506007)(5660300002)(110136005)(86362001)(316002)(4326008)(54906003)(26005)(186003)(1076003)(2616005)(6512007)(66946007)(66574015)(956004)(83380400001)(66476007)(6666004)(6486002)(52116002)(7416002)(38100700002)(36756003)(66556008)(2906002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ax7FYHIYZqpVxYI3KhfycUpFimuoDg1XueW8dgBr/O9W50RvCZxCuMLFpiit?=
 =?us-ascii?Q?y5g9Hw9hvVyAM08w6Wii29JsYh6VlZYqA3wBBcJ87rQu3Kj19LuReVQK9Z3W?=
 =?us-ascii?Q?mSy6H6ntfi/St6AcXJZemwjLRVGZCjX5VEIGYtj97Z5xfkPW6h2mW+T8Mzdu?=
 =?us-ascii?Q?LqTRXpXkeOJ8XL4oVDU2M+T8rMHCCZDa8iaP0OttgpW9jjTjBf3ALSo6Rgoz?=
 =?us-ascii?Q?tblJKDJGHSGac/8CYiQBypvEE0LmLX6YZ99hvvYpSupMpeinerp4kaqKhyJr?=
 =?us-ascii?Q?E75KyfRh7AwMXAtNr17bdZW6ZdoobWNXvXR0vhmZfBs9uLEzXEGFuod+C8Re?=
 =?us-ascii?Q?MSj9C1d+2L/tZx+r2d9DkEpaOutdkj7cnPMxWMxwnIFmzDnQV6qoI0XTWLpC?=
 =?us-ascii?Q?Fu/EGbSz2fWIe+TXw5kM6/Ucsv8pTw+BaXrc1HgBXadaJ1M6YsAiW0z2rcfH?=
 =?us-ascii?Q?orC5/ng3wMbAE0OmxE/GxPKm9tAVWGOo4UZCk3k6IA9qKRJWD9Y6z5gPlxTH?=
 =?us-ascii?Q?uzlrlxeluvqMmt39tcHunuOo4nb9sDSCshOrZFVxaSf2Vcynw8uD3bEH+nZU?=
 =?us-ascii?Q?8Ul4czA2t8135HbCrX+4Z8LBOnTqcAicyGqsPI1JBBinlzy+9xQi+pNCRt0i?=
 =?us-ascii?Q?9vOqx4BGzmWWP7kdtibSiZi1OY5SFVpLlPEkpBByvFCJmJW2GAH2Wl8rb/9k?=
 =?us-ascii?Q?1Il+cBvvLTEC3xnTcXwu808n72caPyoAUL9f1aMDH8VuGZXbbX4QUcMwbIDp?=
 =?us-ascii?Q?ZnwIVilvpARWS7c8bHlpXhf3p/1mnTaYZJ/pkGwHBobXoeQn96Cl0wghXREd?=
 =?us-ascii?Q?JoMtYwezfyLARI/3i0/IwufEnXlOYv5L2/eXWUGGFFGB1akBAUssYjCJaE0x?=
 =?us-ascii?Q?zwY12DYJsQw0EZ65djBVNPWNO+T329a34Qp7ceW2Gi2wARpx+4NFQlm6d8Qs?=
 =?us-ascii?Q?PL3BfiCNGafidaYOFDt7Km2AXZGh+A/E9m1l6A/EXKcGPClbhJKrhdX1mSnz?=
 =?us-ascii?Q?gp03q/ogCBmgKM88Ete/ZQcGJrpHtAqvXlKIDMEzJ/ny/K259tYmI6GxvlwR?=
 =?us-ascii?Q?uqyDyvekfxOmTHPl1jR8/MSefOC58BoehX1quRqktFmSgoYxpKBjcaUuvmS0?=
 =?us-ascii?Q?ryUpEqL0+DvYxs66e8guIiwEpCx/rqKuN4Eop9tNaMuhxE5K0rn7GMTbdmJk?=
 =?us-ascii?Q?NnXS4EzSrpIBOjF++WWsipI8Gb6t9jS8hi+cv1wzzhIzCdCD7i2vfm5QNzb7?=
 =?us-ascii?Q?kQ7sxroAnkuhBhROKpOlZ/Rn4dEeapAs7IG2ngLwHzdcm2Yy3uGuu1w+IXFs?=
 =?us-ascii?Q?FuKY+LFb4e4NYbzCzmHq2cbF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4b50b3-261b-48db-5fcc-08d9587003b4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:20:37.2829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DiIDNgsh4t8USLofRrE3smfwpTdaf/jTuTasfCukv33682R6Ld2GMEAi1T4mO5iHF9CRoYKoq934CAikH7z5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qingfang points out that when a bridge with the default settings is
created and a port joins it:

ip link add br0 type bridge
ip link set swp0 master br0

DSA calls br_multicast_router() on the bridge to see if the br0 device
is a multicast router port, and if it is, it enables multicast flooding
to the CPU port, otherwise it disables it.

If we look through the multicast_router_show() sysfs or at the
IFLA_BR_MCAST_ROUTER netlink attribute, we see that the default mrouter
attribute for the bridge device is "1" (MDB_RTR_TYPE_TEMP_QUERY).

However, br_multicast_router() will return "0" (MDB_RTR_TYPE_DISABLED),
because an mrouter port in the MDB_RTR_TYPE_TEMP_QUERY state may not be
actually _active_ until it receives an actual IGMP query. So, the
br_multicast_router() function should really have been called
br_multicast_router_active() perhaps.

When/if an IGMP query is received, the bridge device will transition via
br_multicast_mark_router() into the active state until the
ip4_mc_router_timer expires after an multicast_querier_interval.

Of course, this does not happen if the bridge is created with an
mcast_router attribute of "2" (MDB_RTR_TYPE_PERM).

The point is that in lack of any IGMP query messages, and in the default
bridge configuration, unregistered multicast packets will not be able to
reach the CPU port through flooding, and this breaks many use cases
(most obviously, IPv6 ND, with its ICMP6 neighbor solicitation multicast
messages).

Leave the multicast flooding setting towards the CPU port down to a driver
level decision.

Fixes: 010e269f91be ("net: dsa: sync up switchdev objects and port attributes when joining the bridge")
Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/dsa/port.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 28b45b7e66df..d9ef2c2fbf88 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -186,10 +186,6 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
 	err = dsa_port_ageing_time(dp, br_get_ageing_time(br));
 	if (err && err != -EOPNOTSUPP)
 		return err;
@@ -272,12 +268,6 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 
-	/* Some drivers treat the notification for having a local multicast
-	 * router by allowing multicast to be flooded to the CPU, so we should
-	 * allow this in standalone mode too.
-	 */
-	dsa_port_mrouter(dp->cpu_dp, true, NULL);
-
 	/* Ageing time may be global to the switch chip, so don't change it
 	 * here because we have no good reason (or value) to change it to.
 	 */
-- 
2.25.1

