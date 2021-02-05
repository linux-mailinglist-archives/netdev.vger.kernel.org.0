Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA93115E1
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhBEWoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:44:15 -0500
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:30318
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230153AbhBENGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:06:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1qAEryDhrCq5GyxJFZLZ7+sWvvZFi/xZEou6sqh6EBjRxOGFqZ3qVY8NfJDS2ycLOOxn9N1rUbQir/rBpW9PDxbXc4MNXyK9LatKICJ5EON3SfeFBa8XUfOpLEZ1svY0D5F1CDvYLFsferPdtYeSSFeyyL5hy2a2f56OkL+q378lrnY25yIrmFmbkDr4O4KQBJxcrfhbBRddytB5L24C7C64gMIR/O/U8235eElTl3mL+ayOi098WU4UXiRBWTuLv4jVmNmAy9FVATPsT8E+k6kmF4y50daQu8tffLHqYQ+cQEwxHgsQ9FbiqxFguT4GAPUBTVft388StT95IlL/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wQLnD2xdS5p7rfBRmHeekvQgNTu0JrJ9oQdMDGZ5js=;
 b=DSf5QLyemHqf6TV00ZiQkcXLUBa6OCuo2N8GqSpbINBL+/rMU4YQBjduyihIoZmZOky7GbWeZPpk8SS5qVoVpIW1qXhhu7EdWhqaW7q1cbUzKTBXFC0jqc9VNOB8zWrjXaiJAXk4MZCqw88yuZQowVV3qhZ6pVTX/UgVvXVQIXl6EYQ3SSwudPVTCe6sj5qzFaFmS8oyEvcj547sgpQ7lqhAXT9i6ckLyA5F6dxQvb89DCAFVq94u93VQvSqnBY3tkCJK4VTRjG1VRZVIvZ23yvBvPlmkCHdpTR835Zh3D5xi/BRE70ALOcc0M5joiJJMyCX1+Azsb2E2seleHdV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wQLnD2xdS5p7rfBRmHeekvQgNTu0JrJ9oQdMDGZ5js=;
 b=lj36Qh2LjUHx4hNj0i+RMJS+zEczdBkhS/TC6uZ1xXYVfJD67Ee1Osmp9RI8eVTvPV777lIOdTqPinRGD2bbG3aQ3Bf4CYU7qlU6UP0YTm/g3SlBq/vkAZSqF8p+jFcmV1mnLda+iOuGrUWwBxB0hblxrbe+MOg6e+xn0H7N85Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:05 +0000
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
Subject: [PATCH v3 net-next 10/12] net: mscc: ocelot: rebalance LAGs on link up/down events
Date:   Fri,  5 Feb 2021 15:02:38 +0200
Message-Id: <20210205130240.4072854-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cb3bee1-f073-4c7a-bd5a-08d8c9d660af
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28636C65CBFFDA51AC443641E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKdDgfW6GnP+oF3bkPGLtJeHmBRhavCMrU8qmC7e939JobkS/3cbAARYZ3qEZWPEzukpz1kSQ4xl8o302Qu8DKb41gAg2bZbkufT2c37qBOzaSv/LLgKLLtwc09KHubTzj/CHinRlY4Wk7F6UVQDFC+/2Fp5k/lj2YeNkCGn0w5h0zoVVAm41hB7Xy1kpKE/KV+5WViLaBmMzkjc5Nm3lbWyGsXVOeFSoeX27BkwvyadA1Hcnt6BP8v1Gf3QDRqS+L9NII9+kULfnYofmBJH1eEmbfWIAY4Q865rESLXOwoCMUFwCpZY0flGj7gpB7ixHbsK0mmm5baLqA/+CtaqiI+P3RoLWGm96EWZIyzmyN8ExrblDiPYMcl2HQ7MAsl101fuW3fvqSHS8xQN34eXi4FT6yOC07hl8BJ1MkA+dnE5wUeXy/u4e5qSDTVRJ2BgfvkTJYUL/W0uq0a2izj5peb6yUp079pR7ivJGSTb9CIMjGIaWLKG1CtxOIljJdHfX6WsUURp9eASq3hjAebndwnMCu8NymKl3Nv8B9bq6P9gie6XQhhf/W7qeQpcK8veWwhQgBCausLeOXSO2PTlPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZP3DoWyAPaNMIRQL/SZU1DftP0oiyDPs9qjQJ0ogWFZwtjeXShkz3mLrDrgZ?=
 =?us-ascii?Q?Izpg7pKBmISRvlpue3r4J1N+UHCSHI/WHG+eBn1yw9Z8pg9ItDpGiyZD5xpo?=
 =?us-ascii?Q?dF4LbwxjoDFJTo6Uvswi0X4ojwtzJzlkw/2TjrXFskirEN8wl4anM9uDfZIT?=
 =?us-ascii?Q?lmUHEXt+G60elUYCtMkzGZjlcqWuQKpvKYrZoRHEXg1TH/cHQipA1PxZr653?=
 =?us-ascii?Q?V/3JnXb26DQa1wT1p6YuoEU7Uk97alnrHMJE4QHYpD7/FiNG9CKNS37RRyX/?=
 =?us-ascii?Q?/2sUMxoQtUz1wgGwQi76KrOg4v9fQOdJF+SM+6qA5gKvn4Yu4jp1SFzrufTQ?=
 =?us-ascii?Q?UsjiQjzQb2DO0guLoPWdmzZ432UTxXV+CSdBv4GAOlgzDrBSs91xMK74XU6M?=
 =?us-ascii?Q?zaRlLICJrgy3wo2smftrWImdPRyqdicdTXsiSzsgGtbuGHqePPSWHyW2fX4b?=
 =?us-ascii?Q?fiUkW8eiXGwOUKgbKmV3HiF4+pDz3wEtIcent7ELB+HKCmS6QU/4i53Tq8qB?=
 =?us-ascii?Q?G/EjP7lI/H141kyo/WZHwSzKRoprl5zYn84Ez+8qNTExhAg+TrrQkYB90yeh?=
 =?us-ascii?Q?kopjSFZVCHekGj4s8jyewYTRfn1DsKD2CxuL40oNnm56K8gqvue2S6b/PtHZ?=
 =?us-ascii?Q?jNMhmNa0r4Omrtljji+jbuR7RU/PiLIuiUunoPz/ekChXqILLtUwyClEHwAX?=
 =?us-ascii?Q?wuGHxNsi2QTsAvQ/bRtfVPUKeiXSuA1Nj6tofmI3f9imp6iBQv6dXF3QPnL6?=
 =?us-ascii?Q?2HjGKopRk2+G1i20KSj9D0PCEZopn57yLhAgRUkPXJZocsv5oNKTzTcqSZ+2?=
 =?us-ascii?Q?iHb79nR9lM5QuISIFBJCBUGX+/3Z/hiHM3tiPRdSlESfCcn8N/nKNZQmyrUp?=
 =?us-ascii?Q?wF/kjMt4+fUZDp8NIipTP1BUBfGvlHriSEA72EGO6T7VXAHbO7VdjVVazKwW?=
 =?us-ascii?Q?tpGhuIFyOhEnq5ByAQ1QrUZCaRuDo8xbXyd3WU0pjOBKI91t908jH47xqMou?=
 =?us-ascii?Q?pSdsIWpnizn3xvyqmi8jizTsbx2JXdZMZ5KiNzKIzN2P+DPGngty7PQrTMp8?=
 =?us-ascii?Q?hYqi+9kg3ym9PAqaBeBgbIAmQo/sj7yUh6pxhWqySKe2QTMmAy/Sy6gZUz/A?=
 =?us-ascii?Q?srzo/dfAuUQQm0wzt6J7Fh7cum71OJJABwjhSndmSop4qPcUkeK+BDcMDyxD?=
 =?us-ascii?Q?75i1s7x/kla/d/ZmDvul4Q3dhmBuJPtZY0I54ke4vS+rfseyDLSHCkcIlkEy?=
 =?us-ascii?Q?jzi0KptpE9KCuAgYjp5MSpCIqQylHDgy6aqm+qaZW3+zVsjNxMzH5t2oZzZI?=
 =?us-ascii?Q?dqrDi7XdyOjyooXdTO7Q4ynV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb3bee1-f073-4c7a-bd5a-08d8c9d660af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:05.7028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOJz4RAgvrhq8WSHLW4GWWjpyVESX5hzja78YYcdELleLYtcgpK5nFu68+lNyoC4FtgeLryHrgY7CSuGCltHNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present there is an issue when ocelot is offloading a bonding
interface, but one of the links of the physical ports goes down. Traffic
keeps being hashed towards that destination, and of course gets dropped
on egress.

Monitor the netdev notifier events emitted by the bonding driver for
changes in the physical state of lower interfaces, to determine which
ports are active and which ones are no longer.

Then extend ocelot_get_bond_mask to return either the configured bonding
interfaces, or the active ones, depending on a boolean argument. The
code that does rebalancing only needs to do so among the active ports,
whereas the bridge forwarding mask and the logical port IDs still need
to look at the permanently bonded ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Return a proper notifier error code in
  ocelot_netdevice_changelowerstate.
- Export ocelot_port_lag_change.
- Adapt to changes in ocelot_apply_bridge_fwd_mask.

Changes in v2:
- Adapt to the merged version of the DSA API, which now passes just a
  bool lag_tx_active in .port_lag_change instead of the full struct
  netdev_lag_lower_state_info *info.
- Renamed "just_active_ports" -> "only_active_ports"

 drivers/net/ethernet/mscc/ocelot.c     | 41 ++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.h     |  1 +
 drivers/net/ethernet/mscc/ocelot_net.c | 30 +++++++++++++++++++
 include/soc/mscc/ocelot.h              |  1 +
 4 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 380a5a661702..f8b85ab8be5d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,7 +889,8 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
+				bool only_active_ports)
 {
 	u32 mask = 0;
 	int port;
@@ -900,8 +901,12 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond)
+		if (ocelot_port->bond == bond) {
+			if (only_active_ports && !ocelot_port->lag_tx_active)
+				continue;
+
 			mask |= BIT(port);
+		}
 	}
 
 	return mask;
@@ -960,8 +965,10 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot->bridge_fwd_mask & ~BIT(port);
-			if (bond)
-				mask &= ~ocelot_get_bond_mask(ocelot, bond);
+			if (bond) {
+				mask &= ~ocelot_get_bond_mask(ocelot, bond,
+							      false);
+			}
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -1298,20 +1305,20 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 		struct net_device *bond = ocelot->ports[lag]->bond;
-		int num_ports_in_lag = 0;
+		int num_active_ports = 0;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
 		if (!bond || (visited & BIT(lag)))
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bond);
+		bond_mask = ocelot_get_bond_mask(ocelot, bond, true);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_ports_in_lag++] = port;
+			aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1319,7 +1326,11 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
+			/* Don't do division by zero if there was no active
+			 * port. Just make all aggregation codes zero.
+			 */
+			if (num_active_ports)
+				ac |= BIT(aggr_idx[i % num_active_ports]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
@@ -1356,7 +1367,8 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
+							     false));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -1399,6 +1411,17 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
 
+void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port->lag_tx_active = lag_tx_active;
+
+	/* Rebalance the LAGs */
+	ocelot_set_aggr_pgids(ocelot);
+}
+EXPORT_SYMBOL(ocelot_port_lag_change);
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 12dc74453076..b18f6644726a 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -114,6 +114,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct netdev_lag_upper_info *info);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
+void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 0a4de949f4d9..8f12fa45b1b5 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1164,6 +1164,27 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+ocelot_netdevice_changelowerstate(struct net_device *dev,
+				  struct netdev_lag_lower_state_info *info)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	bool is_active = info->link_up && info->tx_enabled;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	if (!ocelot_port->bond)
+		return NOTIFY_DONE;
+
+	if (ocelot_port->lag_tx_active == is_active)
+		return NOTIFY_DONE;
+
+	ocelot_port_lag_change(ocelot, port, is_active);
+
+	return NOTIFY_OK;
+}
+
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
@@ -1181,6 +1202,15 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 
 		break;
 	}
+	case NETDEV_CHANGELOWERSTATE: {
+		struct netdev_notifier_changelowerstate_info *info = ptr;
+
+		if (!ocelot_netdevice_dev_check(dev))
+			break;
+
+		return ocelot_netdevice_changelowerstate(dev,
+							 info->lower_state_info);
+	}
 	default:
 		break;
 	}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 089e552719e0..6e806872cd24 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -613,6 +613,7 @@ struct ocelot_port {
 	bool				is_dsa_8021q_cpu;
 
 	struct net_device		*bond;
+	bool				lag_tx_active;
 };
 
 struct ocelot {
-- 
2.25.1

