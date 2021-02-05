Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C285C310B8F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBENIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:08:41 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:25949
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231421AbhBENGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:06:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqjDYZqeQmxmOe8baAw7LmNEbkVnDEEq3XLEM4+9MqHdu1Q9jbDgY+aPXplpkCkaKTq/B3pTxOe5QQP7+MIZXMoVf3mB5xND9YR74KsQMCmDiu86t+jYsH/Bx7nPXQppxotcctcHk6yXTd9XArsMCw5nsmvT0eJA4CnHmbXcCyGxMhPwuJsNaeFBfVqTug+b8neYWIGf9D2y4lhbpyWmpEhOrZVWDaVqoOkl2muEsAy+LUXbGFuyxrj44lxJ5aabcwsK8sG/oCXAmO8MVRQQEdrV9FlpQnxNPDKW3YHOPLux0+9XAd27qk79HNftwxwcm12rv/04SSPAwR0DjTrsaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkN+qjpUyhOHdEpjPVMthMuHol0+A0u+g9wleCPXRrI=;
 b=Mn1SxsnVklRH93SFheY3L1Qmfz4BZYIBTxX3fYhjm7/QlZzRSGIn7bb+o3UO/wvy79RXf5yX4MGl7av1lMVh4PY+R93mB4Wy7jfR1uEiPp9lW/E3VrCLeUG4AOLSB/uCrfiz7xT5rq9o5ptr5o4PPCX3bZfxEKu0BjVkSOWOuHfgvkFdFAtEUpzS8JNBK68YAnpsblOvTZ5QSc9qRtoakqanBoCT1nIILJNYy9L08QRhyLiJXcswp5zdjFcGWydl6w6SJT8Y64v/YAR8R1yIEGMlloNwGstc66jordenNE6wnSQ1yOPtR1AydrFsrprmWaRBA3ZJDT0kzO/LqNpnOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkN+qjpUyhOHdEpjPVMthMuHol0+A0u+g9wleCPXRrI=;
 b=hHKxAGld3zIDBF5qnpSi+Z22RXvsIvQBEzAFLkrT0zUygS8KVUG4bopkzYpGc5Rz1AIhSK80FF7HTgKtupu2Py7Vza2yqoyWLC81fnrjkN0XhuoYfEz8r/ClZPeT9QjNYb0n4HDj6ts0ri5zO96yXu3qGBdMesSDIINYdMtpPu0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 08/12] net: mscc: ocelot: drop the use of the "lags" array
Date:   Fri,  5 Feb 2021 15:02:36 +0200
Message-Id: <20210205130240.4072854-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 119075f3-804a-4bf2-f6d9-08d8c9d65faa
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863763E422B64D68D6C7FE0E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/8nYfzOKnd79JU4F89i0OYjShkWJPngMN5WpolnSAdPqK03Bk0NICt2P0COuhkaRqp7jGdBZD1wBtRcdhJNKIDaYOHHFf+Zw6FaJKXq37n+l/nPTCop67k634ZJCga4Qh3YHyYuwwRUBLu4EWqPhe3FoQQmVxWAXczNCtMmaeqs5o7e3G7fwzTs7ZNXgk2XkxUR6EvRMyR0DKf0mt58ylydvitW/m1osJKo1F1f/3GrQLaMvMz/9xfLSURsuFx68/671hlwumvk0tLugKy7cos5AgKxnCBGNCA90bOM84LMivkwNc+eIHgrd8L4D1Su6ct93ggS71bABZOMAThVsCaSRqU9GD4vHAZM4Qzv/HeOa2xmh7gGbCth+QDauNy9p7eSHkaBgGzLANYWQlSaCu0DC8BJXOTgqTvQWma9/Q/3U/bZNLOmu9btzL+Te0AC7rS9b/uO+nwcezfnQP1N1CQJVbepzjofDNtY5uAyFG4NQ1MSiz2/lhaUMh+AGm9qVs7wKLVm0dwTQ0qqbteVlWZ619G6/UsOpzxqzskn8kwVb6NEB8UPuSdNnbH8bXv8sYEfNKofSADpJXrdKQeFiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FLF484Z6lXGgukSTvveOhA0LgNnFz086jOjOL1pKsByUxp1CgUQ3JOvIkE3l?=
 =?us-ascii?Q?chgP6Qprv8OwC+nQXX0IacsqpPB7v8I2x90/Da2/EtK6o2e2PCFXCDsikQiQ?=
 =?us-ascii?Q?IHj7RyqfCSTNN7z18BquWvK5tq1B7uWFp0I8kwgXQkm2pymupYEyGZUFKol6?=
 =?us-ascii?Q?izAeYnWvtm+34PeFjSj0n41DtGzYuNgeg1AQy/5RJIuRAxeMnfUGmG5cuZjz?=
 =?us-ascii?Q?pCJZPNw5nE6cmqAfpwkJCYvipFZdyxH409C3o9cUOXy4b56CJGCA6b+Lsmqy?=
 =?us-ascii?Q?GNTbn5m5SsFsCyJCeCoUQytpPy0yiUmaz4HRLHYaE+tCC1MgJUDzFHtAfCda?=
 =?us-ascii?Q?A1Va4UVnR0DECuOLjS4G53eYcjIt1SajEKhzPybl56PcYorlgQzUJ/qHmNdq?=
 =?us-ascii?Q?6nXQhQiv4KLIHDHTYc6Di0F3wqTOmiaVxGOMomiWbvhDJymZsY2wgdESLqNm?=
 =?us-ascii?Q?pTYWgfcenkNQBrU+zjHZ+krz/tNTD4/jGNr7+nTuqvW8Feel94I+7AGvSTBl?=
 =?us-ascii?Q?RNA66dLEROvzi4TidrCOhGlFi908KNEAh41yx0uKhZu1XkMsdes61T44xFmL?=
 =?us-ascii?Q?opF0qcB7vsVQ5XgW/+KFGRpXFB1W7nzSQnQiAFGmsT5pQqxJEM7WO5/Hlhb2?=
 =?us-ascii?Q?ORp/3aQLixgGbWNgQee2rOJ0r3ebbP2ZnhmWP6lzC9HxwLwoDNp7G/9WaAEQ?=
 =?us-ascii?Q?c49Fdhdb4azrlf0FNNWP4yfJTknGsopFQnlh4QzZq4rUnjPjHnK9a/Ze8VgN?=
 =?us-ascii?Q?vYr2B7v2Dn6YuDq+jJKWoIUIRYnmUUMoeSH9SnEfsXPHiiuLtEOGvgqhit+H?=
 =?us-ascii?Q?kRP5LdgOqQhsr6eT+vBb9sI1c6UA8Ds5BgfK7IvB4iLQVemA2xbgV4G/b4sT?=
 =?us-ascii?Q?BJ1v6QybgiUMmJztzB0g/cHrST44VJW5O6lytxMwrMrUigfoxED0MyHlqLMw?=
 =?us-ascii?Q?kzS0ngEZkK2TOtAVCzjlb117ckhHMSuiGmcOLSlYGSKVz1baLpiuFsZpJmFY?=
 =?us-ascii?Q?bCEZuZ3lURBbSnU2c9C6ax9fA6gfDMDrup2cVwGV9jSzqXqfBKF/uxRgYbnW?=
 =?us-ascii?Q?iJl01JS3v6th+sZqN+MFPxwBcssCO+FZEsJPYT+/vxtegebP2KXW5YFqt2gu?=
 =?us-ascii?Q?NCIwCem1B4ogncP6O8AVf2YubVKDoP87KwSZbPfbri1GS+63l78NzJfpzZbL?=
 =?us-ascii?Q?TSgvxBrc8WYOHTLk4RfUMKW4NyHgoS6mljYHG6/V/nhSNVj876t2RQw6Oxc7?=
 =?us-ascii?Q?zaWbMpyqOd3nQdZ8CdCj3f5f1smYDQepAB+M+d0nbkxmRRhM+KqEtAmDEycH?=
 =?us-ascii?Q?bfEc08PdIq2Xow5tj7wcMGLj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 119075f3-804a-4bf2-f6d9-08d8c9d65faa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:03.9778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJ+5HAkSlsfDrrlvvQKLMCwcwTTJrdivW7sJW7piKeLQF47+pIOfLPat/SrYsEpV88n3YKvBKIWUtNWaL2s2pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can now simplify the implementation by always using ocelot_get_bond_mask
to look up the other ports that are offloading the same bonding interface
as us.

In ocelot_set_aggr_pgids, the code had a way to uniquely iterate through
LAGs. We need to achieve the same behavior by marking each LAG as visited,
which we do now by using a temporary 32-bit "visited" bitmask. This is
ok and we do not need dynamic memory allocation, because we know that
this switch architecture will not have more than 32 ports (the PGID port
masks are 32-bit anyway).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Using a "visited" bit mask to avoid memory allocation.

Changes in v2:
Context looks a bit different.

 drivers/net/ethernet/mscc/ocelot.c | 95 ++++++++++++------------------
 include/soc/mscc/ocelot.h          |  2 -
 2 files changed, 39 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5d765245c6d3..c906c449d2dd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -957,21 +957,11 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
 			mask &= ~cpu_fwd_mask;
 		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
-			int lag;
+			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot->bridge_fwd_mask & ~BIT(port);
-
-			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-				unsigned long bond_mask = ocelot->lags[lag];
-
-				if (!bond_mask)
-					continue;
-
-				if (bond_mask & BIT(port)) {
-					mask &= ~bond_mask;
-					break;
-				}
-			}
+			if (bond)
+				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -1277,6 +1267,7 @@ EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
 static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 {
+	unsigned long visited = GENMASK(ocelot->num_phys_ports - 1, 0);
 	int i, port, lag;
 
 	/* Reset destination and aggregation PGIDS */
@@ -1287,16 +1278,35 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		ocelot_write_rix(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
 				 ANA_PGID_PGID, i);
 
-	/* Now, set PGIDs for each LAG */
+	/* The visited ports bitmask holds the list of ports offloading any
+	 * bonding interface. Initially we mark all these ports as unvisited,
+	 * then every time we visit a port in this bitmask, we know that it is
+	 * the lowest numbered port, i.e. the one whose logical ID == physical
+	 * port ID == LAG ID. So we mark as visited all further ports in the
+	 * bitmask that are offloading the same bonding interface. This way,
+	 * we set up the aggregation PGIDs only once per bonding interface.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port || !ocelot_port->bond)
+			continue;
+
+		visited &= ~BIT(port);
+	}
+
+	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+		struct net_device *bond = ocelot->ports[lag]->bond;
 		unsigned long bond_mask;
 		int aggr_count = 0;
 		u8 aggr_idx[16];
 
-		bond_mask = ocelot->lags[lag];
-		if (!bond_mask)
+		if (!bond || (visited & BIT(lag)))
 			continue;
 
+		bond_mask = ocelot_get_bond_mask(ocelot, bond);
+
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
@@ -1313,6 +1323,19 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			ac |= BIT(aggr_idx[i % aggr_count]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
+
+		/* Mark all ports in the same LAG as visited to avoid applying
+		 * the same config again.
+		 */
+		for (port = lag; port < ocelot->num_phys_ports; port++) {
+			struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+			if (!ocelot_port)
+				continue;
+
+			if (ocelot_port->bond == bond)
+				visited |= BIT(port);
+		}
 	}
 }
 
@@ -1353,30 +1376,11 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
 {
-	u32 bond_mask = 0;
-	int lag;
-
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
 	ocelot->ports[port]->bond = bond;
 
-	bond_mask = ocelot_get_bond_mask(ocelot, bond);
-
-	lag = __ffs(bond_mask);
-
-	/* If the new port is the lowest one, use it as the logical port from
-	 * now on
-	 */
-	if (port == lag) {
-		ocelot->lags[port] = bond_mask;
-		bond_mask &= ~BIT(port);
-		if (bond_mask)
-			ocelot->lags[__ffs(bond_mask)] = 0;
-	} else {
-		ocelot->lags[lag] |= BIT(port);
-	}
-
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
@@ -1388,24 +1392,8 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
-	int i;
-
 	ocelot->ports[port]->bond = NULL;
 
-	/* Remove port from any lag */
-	for (i = 0; i < ocelot->num_phys_ports; i++)
-		ocelot->lags[i] &= ~BIT(port);
-
-	/* if it was the logical port of the lag, move the lag config to the
-	 * next port
-	 */
-	if (ocelot->lags[port]) {
-		int n = __ffs(ocelot->lags[port]);
-
-		ocelot->lags[n] = ocelot->lags[port];
-		ocelot->lags[port] = 0;
-	}
-
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
@@ -1587,11 +1575,6 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
-	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
-				    sizeof(u32), GFP_KERNEL);
-	if (!ocelot->lags)
-		return -ENOMEM;
-
 	ocelot->stats = devm_kcalloc(ocelot->dev,
 				     ocelot->num_phys_ports * ocelot->num_stats,
 				     sizeof(u64), GFP_KERNEL);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e36a1ed29c01..089e552719e0 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -657,8 +657,6 @@ struct ocelot {
 	enum ocelot_tag_prefix		npi_inj_prefix;
 	enum ocelot_tag_prefix		npi_xtr_prefix;
 
-	u32				*lags;
-
 	struct list_head		multicast;
 	struct list_head		pgids;
 
-- 
2.25.1

