Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C663115E7
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhBEWon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:44:43 -0500
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:49991
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231215AbhBENGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:06:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/f9VFKE8/fMOueeWDwKQvTfYB0xEVLjAXnByfzxRy32b8KNuoAps09WRjUYlchR2sYjhUdzcBHfFtNFSQ0unkDCQb4XQCQFCDEnX5lESi/XWfYja6kMUT8wLgMG7ePYR7/odZQr4BleVKbEvgJGFwr+qK5yNKHQwlHYyfuOYQpzvSXkM5HJF2NTkHHK2alaQwtBXihl0trwupNC2l1ILPxSQXwE7wJKygZmOfdpv4omHXy6nyEFvtAdZRpjEM4Yl2oGOdXQ3YO9PYAtD2CvwV6latOqtTIF/BwTDhDbORaZ9zNZP2M4D3FUQzCUiEuw+/5iSL45FsUPaKs1oFrI3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEw+5hJeZoW8KHz+cU5PVXKNkRn9X3J5TU4/p+7Ce7g=;
 b=G48ptRz9Xp1HZquzpj+SOtbks6kJiOjLUxcLsmWQcXpI4RBKdF8UUOSt1qiXtApTCDuE3lobdxFepCfBUeuuTdgVg1eGwOBsLkb7pOx2fDtFqXmFJAp62V4S38lBkbCI2NB2e1dhY/0Q9C9VqiiR5gPfDsqDvZiTc0Bhmouv1HG0x1PjIKC1NhQDF7wgQIFReIKusmzLvi3Dryp032zXmF3x03rXFtk9sa6o/X6iQvBHzfAgCbmD+h3pO/P5ctbtMj9T7/F4vdamsYLn1znLTz+dBaqiRaP4tsGcoalKS0DS3kmSE5t6sf1a4f8lmkhJjTLJPPVNbM09t/xj3uHuGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEw+5hJeZoW8KHz+cU5PVXKNkRn9X3J5TU4/p+7Ce7g=;
 b=p4KRWsrPJ7JL7HeDoDiPvmTaa5OFzeiCCCjs/FSZafTEPRMZZwZQR1zgUEszKU9HFh30taVFjfMKdYxhbf94AgUeWU1gEHIJoXoPJUDcfqEWwA1Wqtm1R6OOpCHGqWsVxC1uzo2ir1bLNWbgiE9xIar2Bwfc3djj6vy9s6wQ5tU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:03 +0000
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
Subject: [PATCH v3 net-next 07/12] net: mscc: ocelot: set up logical port IDs centrally
Date:   Fri,  5 Feb 2021 15:02:35 +0200
Message-Id: <20210205130240.4072854-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a501e28f-55d3-4d12-d6cc-08d8c9d65f47
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28638715811F9A88C1D2635AE0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sy0dmh06Rrb2oys46cYQ+7nXvWJKHBHReWgGewy1mPyqXKu/CyUI4+yfdMZmHExh+C2zMMdiIYI0tR+LXbnsoWjFnDzFKRnqsC5LvG1Wbd61WTB/GymxnkBmquymK05asZjpVpLFr6hVntlqhCxrwxMO2qD6xTnLg1GXEie03PlXqisCAyGuVdxR8pjRcZwdyh7VrLdcoHV3qRpPTNv5nyFGWy/FQtkXo0SlcEd2CAA+l8mREdmms0bPf2ADAu4rAfKsI1ATfTnO0e4tj32au7wNU1t8LiMgCE2LPa5LYw8yRmBXbhV4pDbLjE8JZXf83bnxLlwMr6HUNMd5V2sh31Nh6iDooybesAea7MJ8gIUHyH/T7of3wJ43go++qiWtUqCPSL4uIGdJ7h0GYYX327cUh7WRoLjTz7p5nshmap3T3+o7U3lSoyrZ3NC7TB6s6NlV8uBirBA/F7ob98O4HLIfnkuk4ojkY0bcEL3b01x/67IJLp3Gy1Kf0W6iuI/W5nhjyznQo+D/kInmCMCxvMFRPAm6C95uT+dy3/5iFhoA/RAbNVLycGVYtj+BHAwOnEcRd+wOYw4V8o6oojif6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5IoeWtrOVtVsUwRsBTwzJt/0rN1Nm0zb9FJG7+jlyTetprNkd88QGSBGRu2C?=
 =?us-ascii?Q?+ETX3kkOUFSEaUl/+bbT0ln53Vyxoa6dNHwBV3TNixnaW4R0EKNOrfnhua+a?=
 =?us-ascii?Q?9gwA+ZJD1+9gXo6wOsFcFJf3x3vAaAm7Sm3KDE0OCEgbf0TVZmtIvCeZlySN?=
 =?us-ascii?Q?o/ERhrQVEHET9wEhcO9KUT6FAEgmFLs38LRA67HoTx7tLBL0sGOQZWqrStnt?=
 =?us-ascii?Q?eNmLn8Mn+7czBWvQDwzDSv6AOMQbgH0wcwaAQMS0TsIuEeVVTiRbLDTglI6h?=
 =?us-ascii?Q?TKkTXisFBpQJKI8LVdDSJJxmXkcGJgjGragWzihsgJuR8g2Dv2jR6HiPzFPZ?=
 =?us-ascii?Q?869ive4Ueyjx/dplxCs1LPUL+LmOWEMOlVO5zqg3/5vicairOA/LUabnzexY?=
 =?us-ascii?Q?RNEuSBwJ5FXxQxqWMaLYiX1TDpV0fPzN+voTihpjTPJ1lipLvC03LyrngfjN?=
 =?us-ascii?Q?DVJZWyuzkitqOj63t/2IFVEK0+rSXFMqdqgGFwi9NPbpqMYhOlHHcwihsXbK?=
 =?us-ascii?Q?RgnRqsDarDl+kFnsAPBbC4eKVED7fLraQxSOypFe6/TEVj+RMVwSZ9KWA++H?=
 =?us-ascii?Q?g43e1KKJthOZZqY8rizP9tSRx9+o2TrdDisJfa0nSFnKUcyWD6zClMTlsflb?=
 =?us-ascii?Q?OycJRQJZUEVIdGAfv3+EzMPCp97fmJFjVI08YFHAqKubHTqkHA5vXXJlhOVJ?=
 =?us-ascii?Q?esiGSdrIX/nmzzK3kmyPyKWh/YBLhYok9QzWy3BEWq2qIYNHLrv72t2qV7QU?=
 =?us-ascii?Q?w4Dmvq8VbVSnzTjYRA5N6dMuFIWpF7T1Qbf88hKSZu7MyMnT5/NjXQORP6L2?=
 =?us-ascii?Q?mgxPq0ikZIrUk/77Bkq+mj/MyiLnZfvRp8+hunGzZUaWdQdt8qGizDwfHWZ2?=
 =?us-ascii?Q?kz2HwbcsrUFq5m7wUGoN0Bnqu/9tnAgUsuSZRnwLe9dZXYCcMijVqoLsyeHN?=
 =?us-ascii?Q?v/tUp2N83D/8iJXzsKlO2Fy4eB1uurMuDnb8GbbMDMgh7NjirFZeMi2VNwGX?=
 =?us-ascii?Q?0+y/BoJSHW9eFJ+pEUhgG7d6AGqnOx2d0gPXhpms1pZ4rdjVmY52JHN2DPoo?=
 =?us-ascii?Q?pmD2+7oh+vTKaLyrVf3KKqloFYkNY6LpP1/G5YsV2+AXmzTSpvqLWm884RFG?=
 =?us-ascii?Q?lf9NWXbjyge003Q1gFWPZsNA8I7OsiZcup5APqvCZFfAaVpENo3b2Mubj0F3?=
 =?us-ascii?Q?MPp9Blns38tqqvN3O1RiWZ9wCC7rFTHAykbEiVBqu1YXPMVsZSfORYizM24B?=
 =?us-ascii?Q?1+oWokqSu7nbVUr+sFt/dVMtNi8cutJ6ru/aio79g2b84+hruBQounhKUW2D?=
 =?us-ascii?Q?y7zuNty0+t75Q9cNibP1DSRb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a501e28f-55d3-4d12-d6cc-08d8c9d65f47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:03.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zRgVZ83JOAow+igPunsFxBO4BUJktiz46MwaBPLGsch92wII89DALdr+EsYEmSeytHRC/9YfpMhXmntDWEJ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setup of logical port IDs is done in two places: from the inconclusively
named ocelot_setup_lag and from ocelot_port_lag_leave, a function that
also calls ocelot_setup_lag (which apparently does an incomplete setup
of the LAG).

To improve this situation, we can rename ocelot_setup_lag into
ocelot_setup_logical_port_ids, and drop the "lag" argument. It will now
set up the logical port IDs of all switch ports, which may be just
slightly more inefficient but more maintainable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7f6fb872f588..5d765245c6d3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1316,20 +1316,36 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	}
 }
 
-static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
+/* When offloading a bonding interface, the switch ports configured under the
+ * same bond must have the same logical port ID, equal to the physical port ID
+ * of the lowest numbered physical port in that bond. Otherwise, in standalone/
+ * bridged mode, each port has a logical port ID equal to its physical port ID.
+ */
+static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 {
-	unsigned long bond_mask = ocelot->lags[lag];
-	unsigned int p;
+	int port;
 
-	for_each_set_bit(p, &bond_mask, ocelot->num_phys_ports) {
-		u32 port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, p);
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct net_device *bond;
+
+		if (!ocelot_port)
+			continue;
 
-		port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
+		bond = ocelot_port->bond;
+		if (bond) {
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
-		/* Use lag port as logical port for port i */
-		ocelot_write_gix(ocelot, port_cfg |
-				 ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-				 ANA_PORT_PORT_CFG, p);
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		} else {
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(port),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		}
 	}
 }
 
@@ -1361,7 +1377,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 		ocelot->lags[lag] |= BIT(port);
 	}
 
-	ocelot_setup_lag(ocelot, lag);
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
@@ -1372,7 +1388,6 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
-	u32 port_cfg;
 	int i;
 
 	ocelot->ports[port]->bond = NULL;
@@ -1389,15 +1404,9 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 
 		ocelot->lags[n] = ocelot->lags[port];
 		ocelot->lags[port] = 0;
-
-		ocelot_setup_lag(ocelot, n);
 	}
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
-	port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
-	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
-			 ANA_PORT_PORT_CFG, port);
-
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
-- 
2.25.1

