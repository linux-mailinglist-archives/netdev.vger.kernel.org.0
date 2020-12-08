Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B022D2A67
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgLHMK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:56 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:17934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728225AbgLHMK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VX6fkBSW+PDEzfPBmRMswccN5i0AKKMwBZtSyXYQ1lRwrccHL+svLyMcslq8cKv4tGuIIwsmc/2W3J0h/cSQrN35NQew3KXDs4hVw9ehrUYz6+9zD4TG+zGF6ykx2pKcaGDIXEuC+gB7/fmU12YXbamteANrRs/6qJR3wHBGdqwitm9old5ynTbNc3ZxCrGf4YRvgomDGgVw/YLgwWP//zMFH7ZxcmllsioXchmHSnDhIcOXTh+G3dGGHsXsm3kloOG3398bsYcdSztrzgUFJfjVJ+aUsIt7Hpnozab2Am2Zcy3l6QPA751a7wwcJSXqeMOlnDadbK151XdTvpT1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkX35sVFOq2OvFjHDuCNIrj0kVichhKGPeUZl7On4jQ=;
 b=kHatDfvC9Kv/mkoVAQ0gSoaHBpAgIM3gpjP9ifgAswEhRiWAeJxAG4S8abGo0FancOB34vtPm8LDwnZlkzl5LXxyYTngsaUncEpmkH6Ffk5OOPtqlg52UwuRk1aw8S6VKaDVUBqBN13g5s5NkcVlf+DX8pAEoUz3fD8LC3ivsFSzGwX7qBdIo7tdr/lBAdnOquFoGu2OMI+mX7mWNRSiVZngxQfcpyVBywAGaIIQmq7ZWUMyj6qVqMyj8sExBY5XzPQ7W5YXgTFL8pdId8KuzBllL6IaALcp14BzTlXTOragcekN7ceBX52XF/aHKXBwm6QV7g+Ql9y6mzFCvH0c8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkX35sVFOq2OvFjHDuCNIrj0kVichhKGPeUZl7On4jQ=;
 b=VvYdlK7PY76yr9eQ+1+wBescIVmM/kpQB4zcXizkeD26S1Jl18DMVTpxlDXmXg4306PqB2j7qM2DHluzkqHBRE5OBN0dTfge7wtJM1Ev2eK9EJHb6jdddxzt4h68N8trg3RfJzVKDsN4jG/88tapXlGnCDBQ+B2MXk2XydC5GSE=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 14/16] net: mscc: ocelot: rebalance LAGs on link up/down events
Date:   Tue,  8 Dec 2020 14:08:00 +0200
Message-Id: <20201208120802.1268708-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45220bb2-8d85-4638-0b8f-08d89b71ffb0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB56937621675C192B28490C0BE0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iavvUG/Rzq2A6aEKm3PFS+CfKbFdVLurjCJsCdv021dgQ7IbkN55Xu/QCqo9jA5Cfb/DMp/ml1ckmB/9QMWmLV86UxnaEG5HWsnDbMhB+K7w1GsiAZbufucU622Z/e/VPsQTTliNAAAFF+VmluKMGkjJRiUMsbW39ZshEfRZptvR7lXo+xgh++CXPRQGAm0TPlmIJBHyjDjNIrNwVR4i/ZwwJ9Xedc16hY9kiVcysR7ipYzsaR79c8Ur4hbMSbIoNHSVuaeJNYqNTom/ySIRRdSajW6WAFVRoGhE/jKN0XVtaB+VwHdbryZS3ws4GFqomz7/2K7JwTcDR3iKrNr7z1sgEwYhprNbdGgte+VFZDX+HbR/Yu3QWqjAWzppqJty
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sBr/u6YqWOoYWkultN/Sir1uAGSP3NE/QqdrH2qimscS2TY3jdPPCKn4u6Sn?=
 =?us-ascii?Q?9vH47TcdDKBaCb92voLSesuWOxUVFpSoN/+hIDj+C66NG11bQxDxylsgtK03?=
 =?us-ascii?Q?owCLLo5+r97+bAGCeWJGqtlbOkH+GH/ey7iGiuy3ObxNHh+v0rFGRuub4o8s?=
 =?us-ascii?Q?HlDFew9JtqxsLshY+h44phXuqxhJcIvldWsK82KAgFuxuptgfCQCS6/h7rFy?=
 =?us-ascii?Q?xzAuh7cGNE8Kp1QB1nDm42SEftDIIyR09S0U8pkxl4DSWY9tSsb3om1TmZc/?=
 =?us-ascii?Q?sT++NK1R2/l+xeqv5v4pdLe10jZikKiZ1OPQcqI+wLHvIeNZqAmBJTCiKJ2n?=
 =?us-ascii?Q?zYu/nQouIl1HCgdR0RDac6ScIRULvEDAaAbrm6srX4v+JepfE6ZVLGuvP8+0?=
 =?us-ascii?Q?1sjVEB0ZiMWkG4PYL1aA2p+sHrmPfXppDHelSBnCOD/gRHENIMR/rBjff+24?=
 =?us-ascii?Q?xjvpPFjxY0QRPcW0iQ0IFp4fyxVGRUIu/fIv6DsJuicRLUmYjKWvbHLEeoX4?=
 =?us-ascii?Q?thcCzrPr6tzAnvMaN5UX4kACJT3vNKBlI/TYcattRefS2924VIpSiBWNmjzQ?=
 =?us-ascii?Q?Smu9RrSQ2mqweXFb+a6CKydzrUF63eETmrA4bkTJfaAHRGs8/DA9067nZwR7?=
 =?us-ascii?Q?yoVqJ48POM1FlYAvgeRfHpM836ZpFm8Pd81nMNYlle0lXZ+JAvd0cneS6BvJ?=
 =?us-ascii?Q?uJ4w8hMmCNyQBPtU9hxyFuEX7z5hJBHeSJ/ZYfCXr7hcMYigOMGelD2GqsRB?=
 =?us-ascii?Q?VsEr8lavv6hBiLUossCdhO/nRnOQg0vTgtWaHnT+U5IYWptLwtMyZuXwuFVW?=
 =?us-ascii?Q?DUKbGzIAN3Dbj3JoTKoHwKaOSRDxA97GIIGaj1bfwNDgW3JlbTYdW7KNmYME?=
 =?us-ascii?Q?zizgR2Nh218yvxFQiGfDwmRZtcEQtbze0BhmjtcV2YCnJi7urIad2W/b7YsX?=
 =?us-ascii?Q?xSmlWWYqc3lJRNWrgCTgwKgozFmOFcop5c475tBZp4wRAU+8akqr56WQP9DK?=
 =?us-ascii?Q?sRzF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45220bb2-8d85-4638-0b8f-08d89b71ffb0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:39.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjC84fhcPGKXQlwjoV+X4rmvNoZjke5LKb5Y/kAHe/Q43IBtpdpINPhIqDtjGptL4IZnxhdvqf/cbrISJWssfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
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
 drivers/net/ethernet/mscc/ocelot.c     | 43 ++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.h     |  2 ++
 drivers/net/ethernet/mscc/ocelot_net.c | 26 ++++++++++++++++
 include/soc/mscc/ocelot.h              |  1 +
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d87e80a15ca5..5c71d121048d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -881,7 +881,8 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
+				bool just_active_ports)
 {
 	u32 bond_mask = 0;
 	int port;
@@ -892,8 +893,12 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond)
+		if (ocelot_port->bond == bond) {
+			if (just_active_ports && !ocelot_port->lag_tx_active)
+				continue;
+
 			bond_mask |= BIT(port);
+		}
 	}
 
 	return bond_mask;
@@ -919,7 +924,7 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			if (bond)
-				mask &= ~ocelot_get_bond_mask(ocelot, bond);
+				mask &= ~ocelot_get_bond_mask(ocelot, bond, false);
 
 			ocelot_write_rix(ocelot, mask,
 					 ANA_PGID_PGID, PGID_SRC + port);
@@ -1261,22 +1266,22 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		bonds[port] = ocelot_port->bond;
 	}
 
-	/* Now, set PGIDs for each LAG */
+	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-		int num_ports_in_lag = 0;
+		int num_active_ports = 0;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
 		if (!bonds[lag])
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag]);
+		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag], true);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_ports_in_lag++] = port;
+			aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1284,7 +1289,11 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
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
 
@@ -1320,7 +1329,8 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
+							     false));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -1357,6 +1367,21 @@ int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
 
+int ocelot_port_lag_change(struct ocelot *ocelot, int port,
+			   struct netdev_lag_lower_state_info *info)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	bool is_active = info->link_up && info->tx_enabled;
+
+	if (ocelot_port->lag_tx_active == is_active)
+		return 0;
+
+	ocelot_port->lag_tx_active = is_active;
+
+	/* Rebalance the LAGs */
+	return ocelot_set_aggr_pgids(ocelot);
+}
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index bef8d5f8e6e5..0860125b623c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -116,6 +116,8 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond);
 int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			  struct net_device *bond);
+int ocelot_port_lag_change(struct ocelot *ocelot, int port,
+			   struct netdev_lag_lower_state_info *info);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 93aaa631e347..714fc99f8339 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1065,6 +1065,23 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+ocelot_netdevice_changelowerstate(struct net_device *dev,
+				  struct netdev_lag_lower_state_info *linfo)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+	int err;
+
+	if (!ocelot_port->bond)
+		return NOTIFY_DONE;
+
+	err = ocelot_port_lag_change(ocelot, port, linfo);
+	return notifier_from_errno(err);
+}
+
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
@@ -1082,6 +1099,15 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 
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
index 0cd45659430f..8a44b9064789 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -599,6 +599,7 @@ struct ocelot_port {
 	u8				*xmit_template;
 
 	struct net_device		*bond;
+	bool				lag_tx_active;
 };
 
 struct ocelot {
-- 
2.25.1

