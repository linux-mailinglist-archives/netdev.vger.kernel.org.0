Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAB4487A9E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348330AbiAGQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:43:50 -0500
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:65507
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240060AbiAGQnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 11:43:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiwbvhBM+wQuPaYEQmtgRIo+WQmmtEBhVHipEy6VSHFqpeltl3056V1R246B/K0ldPdkQT21mCdMh+f4LuNFoyYGQZLHLnKfKGDSMWF1qWK/IyaNWWjpnTHOUwc7zee8rvVqG/DCdkCXhO+DQ1I+z2P6fmg6yNu2/rjD+Kfb68SAjHA77yOkR1AgYKzAXSbgRud/4Og9huWDAHdDTtNeBf9aM5pNZFhiZK2R/RugoKWxF7GZFJQtujcq61KmUEC+Ju2qmRIQ8k6JXKDoWMY+RtF4kDhIQFsYgfx+glATAr1+TtCJN9I/xWR/SO3gy/p+R3r665CH8UC6CnHpKfEN3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wcf2eKzwThwC2DDgKB6DnTIlHfbsbLrSBd+3mJPy77k=;
 b=JJNeB36bHRwMnYQftwp/Hm8FRk1mwoI9fFJU3ukznkQeDenBAqoKe+7+rpCAkPVxO7XGW9pdfLlpdeREXlKpEQCW/P0oo+lOj6EJV4iI8NWuSBSwe1LbHjdP+Hvfo433YLu8BB8h9ilvgUqEhG8QadAvRWjDX3XTrC7J3VOfqm7J4WKAfK7b2YurCrT/ny7gtnJjCEgA467sPjtJ56r8ckZ4il8SAyoxq7Tcc9c0QkkJLJev1glWv/cVmow5fkwaBgVsNRHe8+xm/iZsj+E8Pu4Hrj3IrVvXDoWg15QG2xmay0wz4PKFhru34jAI/1xLqono7nZxOwD/7bwNG/QkXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wcf2eKzwThwC2DDgKB6DnTIlHfbsbLrSBd+3mJPy77k=;
 b=NBNamPhnowBXBJc1Bhp88qENHlPfkvqmMud4FleLjMfNRURscrUGK7mMSNCiyhS3PApqRf3g718bnqdqUIn6ZJxxSay5boNV3XqaDh8VExTY5LtChySGHg0HZJIy7S0B0A+WfOO4OpAzNbM3McPjhsUVwYerMRqtgAqLkio0RDo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2799.eurprd04.prod.outlook.com (2603:10a6:800:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Fri, 7 Jan
 2022 16:43:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 16:43:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next] net: mscc: ocelot: fix incorrect balancing with down LAG ports
Date:   Fri,  7 Jan 2022 18:43:32 +0200
Message-Id: <20220107164332.402133-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0021.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17de97ab-4457-482d-4c9b-08d9d1fcdf30
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2799:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2799E9E3CDAC31BA328936C2E04D9@VI1PR0402MB2799.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCj0VeflFVCVrvSy5EOKRp7eUSxg+C03dmbKJVPos2bpmuQeFhPRXVZ0IxfyBYPiV+qGbuPZWx/deJqYZckqHXrs5W6SiLS2MjGnFCZmSIAaoZ8iJbMxF5ui4wQwKHuP5A3yvEzGBd/CnSOuHykfgspiW2oqPioFlyfr4VSj5YqglzOLjesH05QlFJk3li9alisQhl34ztlvmi47HpG5irApLeMu3cW+sBeIOHB8BLfG/yCv2928H5j0+Lc3WG64d9mhVG5GPgmVOCUzWuf1lBvNM2XUKQjRCNWqaW0bnRZNuH6wnD7xgwjK2hE+pqm+KB778aWay7AmZlSBo0gDORJlHDvoUBFi82e6I4N0hnoHcBMS4ZDTFG8+XlKRIyiiOigw3DdW1dizldNF0o4D/0F4KmCVaJzt4ADbmBQnFqQAndT4y2BkdxLF1QqO2Gw1FbD3tSWQOKGu50HI5KdDEz3HLWxkDJOX5FtWd3c6Se2Hvx8cv9W/GegRhQYWDEKEWq7t+OZ1Ufr5lYenr3ehFmsuF9dPoke7+9/mCbJxp3mpWcS5oRHDKU+WbscOUJTITwUhmIwl0Q0gR8OeBe2gUR3o83aScbJjpTNximT+Z7suz8MVDRcjw8As1XYTJK2L/ANLZnQwjk58jrtIzb9QZH0PdMwNrlqFzsIn2rbk5A0XieYWtA5QvP1dPaHkK9lJNtiguH0l/01vlYOsA9sLkizrCiKv/5bqqSihKNS6LuH9z93Rvl9QxCFM+774awcDSTU2yiB9BFQ3noY6YX2RWpRw1nmoHVia9dsLuFVt+Pc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(6506007)(38350700002)(6916009)(6512007)(186003)(8676002)(36756003)(8936002)(508600001)(2616005)(52116002)(86362001)(1076003)(316002)(4326008)(66476007)(66556008)(6486002)(26005)(2906002)(38100700002)(5660300002)(6666004)(54906003)(44832011)(966005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FNhXeb4YWnmPhLIjmCikPA+Rs89RWPdlUamSCBZyllmnhhDTcJQacwfDRv9R?=
 =?us-ascii?Q?Xq6iLdu9IZyPCH0e/fJWCB2n1ccjudoHcUQjzPKFTHmhXAOGCdSo5PSFYxs3?=
 =?us-ascii?Q?rVzws2jikEtHMFx/QuSwbL0mDTT0T40uJZ8FcUod1d1EclvwternFm3JyrxA?=
 =?us-ascii?Q?fQMU5HpTNHC2ub6bWRFC9+4Vw09Xza1EVP50EUfyzN1bwnTYYwKFUHcK4zk2?=
 =?us-ascii?Q?phadDzNvBoLda0bRv5Yl8kPHZztiG+ii5mCGL1Wgi1qBT4j1vpqlMLY6x7vr?=
 =?us-ascii?Q?eQ9irZbi/oluan2Mk0oEH/88OIg5y6VIbda8DqM711FFzlTuqhnOP0Z0eGXd?=
 =?us-ascii?Q?HXy7LZcue3sRB1P+cnZUb5hBA2igxJzQ8SvLSiktkNBTFlGb7rVA+TRtgMHR?=
 =?us-ascii?Q?R9yY31d5uoojrt/gxBfr6watQT1+SmudgehvezJA/bcFph8xoHg10wISfqG9?=
 =?us-ascii?Q?Xyxso/4gL24sBGlzyseHpGio3UJeyaigS+vhWss4ERDpJrvE3NUJXUrP/rvd?=
 =?us-ascii?Q?4he3mrz4A8rTOoRWB0mS94t97vCycImhvjRQ5xHas2FUToPCTiQs1uoQkXPn?=
 =?us-ascii?Q?5RIuI4fUyGgLsFSk4slsWV9kNPxjXlZ92UQn62NTAbbKrVU2eGPr2yJcCKBl?=
 =?us-ascii?Q?fHVHm+vJvU5IlzRKJe/dmzYBjlQucY6Wkox+pS0tJaSzPSHTnwV+6xflo4cZ?=
 =?us-ascii?Q?lN8BZw5NxchH5QbT6gRivSVsGKbwDTu91ZzuNUZNzWzFjE1Z0cozDU9UC5QS?=
 =?us-ascii?Q?PESVLwPeyM8KboxSpRYhmrX6w/ack/qmjfFQ2r0dboHxinIM/smefWJHrXgF?=
 =?us-ascii?Q?iwuhTwsUdv5Cc9slYwrI+JabNN2lJ5dBpKefUoP0UWmBjhFU6RpHuG56+yka?=
 =?us-ascii?Q?ri2HxblZPkU34+9h6PUXzL+ZICECvxtIhYGEI6UaA6raCc3Pp4HE8c1JLAnR?=
 =?us-ascii?Q?e9fMOH8E5KzoyBABs4RjUsYrAvJFobRLIWYLxwuZXlKwE+zVvc1nfd5ZWP4j?=
 =?us-ascii?Q?QTHholf2qac5B5HuqSLlpA+o5KpF69dbrBHRKedITPYWHUZYOINMX58OQepj?=
 =?us-ascii?Q?P8UNz/fYT92h1rvogDRyES3dS5LUejxKrVgXOTfik53svLhv3eElAVnh+B50?=
 =?us-ascii?Q?enFa97bKXfxYZT04d28dYTSY9GvlAOQ3vEmKHc4qJly0Mo0/4o73F4Jc7g/v?=
 =?us-ascii?Q?oRpYSZPyJx8Xi3+RyIo9XNFxEcwZykHpr9yVXvBrgWNWDP/pU6e8He0ssbqA?=
 =?us-ascii?Q?2Qfg5JD2FoR2OHuSLxiFAPe+j+hrpDXJoNnRpiQvpVkMrI8YdnQbcWCsWq1k?=
 =?us-ascii?Q?CRmaWK0OoC1zMZQYndfbIYxKgJHgEuDucaJeUrWHzQzQ2ZSCi5yr+7ZpAziV?=
 =?us-ascii?Q?PG9wUl3daqxxjzRJHk3M2jiFIW4ICnktYC0c2N/BWIwA5WycuX1rJlQUjZf3?=
 =?us-ascii?Q?gmvgtSxvA7Slzc54kFtUNZgKnuEjRs0ZPxWC1GEx7QWNlZzzVU3PpyxR4lUA?=
 =?us-ascii?Q?J7vW5z9S3jBRs7MQWlONzHpt+hhNrSltUMB1jPSzijBXnRqezgl4Xcvx4T2S?=
 =?us-ascii?Q?k97pK9y66LmmdGJkPit8FRTqjTCNzLtI/F78zrAPzw8twKRco7JzGcMW+zJl?=
 =?us-ascii?Q?jJ8WOfaAC5drmSI8oo2vaag=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17de97ab-4457-482d-4c9b-08d9d1fcdf30
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 16:43:45.7646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d8RAvmAd6kwdEO4TNylqif0ZKrv3XNKwRiar9p+ZCvJMkIMeVks0KXiP3Ax4LHXyuxFoHkNz1l+BIB2981Q9ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assuming the test setup described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/
(swp1 and swp2 are in bond0, and bond0 is in a bridge with swp0)

it can be seen that when swp1 goes down (on either board A or B), then
traffic that should go through that port isn't forwarded anywhere.

A dump of the PGID table shows the following:

PGID_DST[0] = ports 0
PGID_DST[1] = ports 1
PGID_DST[2] = ports 2
PGID_DST[3] = ports 3
PGID_DST[4] = ports 4
PGID_DST[5] = ports 5
PGID_DST[6] = no ports
PGID_AGGR[0] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[1] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[2] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[3] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[4] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[5] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[6] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[7] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[8] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[9] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[10] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[11] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[12] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[13] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[14] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[15] = ports 0, 1, 2, 3, 4, 5
PGID_SRC[0] = ports 1, 2
PGID_SRC[1] = ports 0
PGID_SRC[2] = ports 0
PGID_SRC[3] = no ports
PGID_SRC[4] = no ports
PGID_SRC[5] = no ports
PGID_SRC[6] = ports 0, 1, 2, 3, 4, 5

Whereas a "good" PGID configuration for that setup should have looked
like this:

PGID_DST[0] = ports 0
PGID_DST[1] = ports 1, 2
PGID_DST[2] = ports 1, 2
PGID_DST[3] = ports 3
PGID_DST[4] = ports 4
PGID_DST[5] = ports 5
PGID_DST[6] = no ports
PGID_AGGR[0] = ports 0, 2, 3, 4, 5
PGID_AGGR[1] = ports 0, 2, 3, 4, 5
PGID_AGGR[2] = ports 0, 2, 3, 4, 5
PGID_AGGR[3] = ports 0, 2, 3, 4, 5
PGID_AGGR[4] = ports 0, 2, 3, 4, 5
PGID_AGGR[5] = ports 0, 2, 3, 4, 5
PGID_AGGR[6] = ports 0, 2, 3, 4, 5
PGID_AGGR[7] = ports 0, 2, 3, 4, 5
PGID_AGGR[8] = ports 0, 2, 3, 4, 5
PGID_AGGR[9] = ports 0, 2, 3, 4, 5
PGID_AGGR[10] = ports 0, 2, 3, 4, 5
PGID_AGGR[11] = ports 0, 2, 3, 4, 5
PGID_AGGR[12] = ports 0, 2, 3, 4, 5
PGID_AGGR[13] = ports 0, 2, 3, 4, 5
PGID_AGGR[14] = ports 0, 2, 3, 4, 5
PGID_AGGR[15] = ports 0, 2, 3, 4, 5
PGID_SRC[0] = ports 1, 2
PGID_SRC[1] = ports 0
PGID_SRC[2] = ports 0
PGID_SRC[3] = no ports
PGID_SRC[4] = no ports
PGID_SRC[5] = no ports
PGID_SRC[6] = ports 0, 1, 2, 3, 4, 5

In other words, in the "bad" configuration, the attempt is to remove the
inactive swp1 from the destination ports via PGID_DST. But when a MAC
table entry is learned, it is learned towards PGID_DST 1, because that
is the logical port id of the LAG itself (it is equal to the lowest
numbered member port). So when swp1 becomes inactive, if we set
PGID_DST[1] to contain just swp1 and not swp2, the packet will not have
any chance to reach the destination via swp2.

The "correct" way to remove swp1 as a destination is via PGID_AGGR
(remove swp1 from the aggregation port groups for all aggregation
codes). This means that PGID_DST[1] and PGID_DST[2] must still contain
both swp1 and swp2. This makes the MAC table still treat packets
destined towards the single-port LAG as "multicast", and the inactive
ports are removed via the aggregation code tables.

The change presented here is a design one: the ocelot_get_bond_mask()
function used to take an "only_active_ports" argument. We don't need
that. The only call site that specifies only_active_ports=true,
ocelot_set_aggr_pgids(), must retrieve the entire bonding mask, because
it must program that into PGID_DST. Additionally, it must also clear the
inactive ports from the bond mask here, which it can't do if bond_mask
just contains the active ports:

	ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
	ac &= ~bond_mask;  <---- here
	/* Don't do division by zero if there was no active
	 * port. Just make all aggregation codes zero.
	 */
	if (num_active_ports)
		ac |= BIT(aggr_idx[i % num_active_ports]);
	ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);

So it becomes the responsibility of ocelot_set_aggr_pgids() to take
ocelot_port->lag_tx_active into consideration when populating the
aggr_idx array.

Fixes: 23ca3b727ee6 ("net: mscc: ocelot: rebalance LAGs on link up/down events")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: reposted against net-next at Jakub's suggestion, since we are
        close to the merge window

 drivers/net/ethernet/mscc/ocelot.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9b42187a026a..79e7df837740 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1787,8 +1787,7 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
-				bool only_active_ports)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 {
 	u32 mask = 0;
 	int port;
@@ -1799,12 +1798,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond) {
-			if (only_active_ports && !ocelot_port->lag_tx_active)
-				continue;
-
+		if (ocelot_port->bond == bond)
 			mask |= BIT(port);
-		}
 	}
 
 	return mask;
@@ -1904,10 +1899,8 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 			mask = ocelot_get_bridge_fwd_mask(ocelot, port);
 			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
-			if (bond) {
-				mask &= ~ocelot_get_bond_mask(ocelot, bond,
-							      false);
-			}
+			if (bond)
+				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -2246,13 +2239,17 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		if (!bond || (visited & BIT(lag)))
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bond, true);
+		bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
+			struct ocelot_port *ocelot_port = ocelot->ports[port];
+
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_active_ports++] = port;
+
+			if (ocelot_port->lag_tx_active)
+				aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -2301,8 +2298,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
-							     false));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-- 
2.25.1

