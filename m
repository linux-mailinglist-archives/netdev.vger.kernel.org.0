Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50392D2A53
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgLHMJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:19 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:17934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727650AbgLHMJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvBn1G7Mt5Czl6tUOeRP51J0ChUqMY5GifuQgLNVogT/XFlkncXyCxVtHpozQcBChg0ghfVopCXCDuHGStztDXbtd0IAeawFofSGm3q3jcHfeYKFFUMZo8acHt0bFXRqV7zHCadEeDFHn4g7eGKUg+AHPMZiikDANA4hElX3hkRonmmT4ErsZQZAchpwJtWjrZAgyB3CSJtxrXYxQaFzjKRUExTVhSUxHfAz6qIneKM89I+gpvRnkN3opxabESOegzr+zVMUgRvbMvsq42a5dtynojwWFo5v9DkQ3aWUagPjQv2X8XbMeC3gnTu4kGKaQdl3Hs1fk/CAtLAukczDEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcxTilh+gt1aD6xeu9SHqJKWmikkvjsGBD30XcM3pBk=;
 b=b54ocslh6Yb+aP/m9k+E4ZSNFVAK+QsrftvCyIfXdWmreUih9CBSuFBuErek3tGyv6sTNH+pj2h0uKU2R/cknHqew1kr9BE8GuPcZ45/MDaINJAuYtgS4d11f7u85ylg6JlYXMgdtaDxIY+YH5Az1j/arK3JacRcnSdqSYg6JMWLTZzaAP638hOkVchdOlashHkWdfOtQaKJBHQBbexEg4B0FSu+iFdTvVJeMiiyuWWwDICyp35S+h7A83lWQAv9xi/RGJVbOJMG0uyrmoWkBVjvF9r/AHigtKOjpLE1PZYq2igqnzaZJCHrrrZVmzGQXezws9bR0T6sG+OIEjnN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcxTilh+gt1aD6xeu9SHqJKWmikkvjsGBD30XcM3pBk=;
 b=N4iUX1/Li/HOxAuR4APdd44DJy27yIOrNMAo8KrE+Ao73jI0YDfOJ12KbEyIV8zWbQugFWvJmJ4f8ahVwk8jHrm2WiZUaxP7NRhiS/CQb1SPyBzbKYxh+FbXKZ5USH90KjRxTQCF9REvr5bsE742Alg+PCHnkVpaGqzqKExw+3c=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:21 +0000
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
Subject: [RFC PATCH net-next 01/16] net: mscc: ocelot: offload bridge port flags to device
Date:   Tue,  8 Dec 2020 14:07:47 +0200
Message-Id: <20201208120802.1268708-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47eda28a-182f-424a-2e02-08d89b71f46b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB56931652D413F11A613B4411E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1f9dTmeJJQrkYoh0sFRZsmYARm38B1scXZbsnFO3AYhFK1Ul3aM2CPxXdYa0le+Q4NSjETaOnXv8i0d0Egg2tRAEQmZ2j0XOmxyFnvpC/bXi4TOtxOr9rmm7xunceX24pRfh0TY/knki29HLCj5tkajfBq1xMs8mZmyUEK8ZCsQEclrtaEmZ3ahxn6b7O8EMgG/yczRwUDYtl6IvTICKw7wlaH0WUW05cncU/y/kGKXDfSWHUOCxklqkrGNlZ7Ygi8NNVdpZjkfbUGe/vQ2Qht7TL+RQn1q8nB+ZNyWBWx45gS3r2O2hteHLg85HIlz4V4kKVqcz4H/ygvVpeFLGANUbPMXmgyfiOU0JN3Zop5gbTzlgxkDALCnYcqRkn7M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AYVFVgz+0og/uJlPmwseOk/5117tyA0SizNl2Rak5ihJoVzi4bHOGiQiUjdA?=
 =?us-ascii?Q?TleNUi7vq/FKDlJ6d/CYcsW2EYL4d34fG1ePfGn17aXBuI/p2cZ2ZnYrQw+2?=
 =?us-ascii?Q?0YKmHmGLrn6Sy4381FwvUFclUPYRWkN0ezkjLMnHpmdS33KNgaWpgMN2rk1P?=
 =?us-ascii?Q?PoWKYy1gUFRcq38EWo79nNp8j6Rg7M8OxJnxXxYyfnGO3nHkP7gzpdV50QJH?=
 =?us-ascii?Q?dJw2QT91X58uP/NqJtjnJflwMTHMtxkIVw1OOINCcnFALYDWPeCYQtIYXkOc?=
 =?us-ascii?Q?dXjGUbhxcRXxa8I9EdzEXU4iak9O699bhCP7CH/KtdjjTcoEhWCpxhMHYNX9?=
 =?us-ascii?Q?6FnLwkl8UG8k6r4K9kOPAzdhhiB6noEnhXyQ53ra2aEgDZkVO2Xg+sHxwhFs?=
 =?us-ascii?Q?mEOQM7No4rPCSrEBw4qR9JX0ssz8tGVycFB+IE2/5BzXMCufGeqS6wCyJ5no?=
 =?us-ascii?Q?R6Ata3aSW/sGrRUAkl0Pi0WRtkStTRsDFlk4azKxS2/PhZbGrWYnY8NSvasX?=
 =?us-ascii?Q?m9AeFCo4wyB+rmB0f6Bo9n55luywwVxkP3MV3LAckSlyYyu+Akj+zISYlYaH?=
 =?us-ascii?Q?9BK+2dUv91K2Ti2rlHcq3TAxesV+qYyc0qZ6pGJruqqn+47BFAJ0KO+kaY7x?=
 =?us-ascii?Q?WCa8wbLm+MO9ty2cRLg0xiTObEYOvwE0bR09baDmkr3KvSK9THWJfXRC3c3i?=
 =?us-ascii?Q?mb3Sesh6a/dcvbOTyQAN9iluDK+XtE34HlhdwHvlLhxgLYzkJYr/Nn4bNYGH?=
 =?us-ascii?Q?O3xiX1a6AbcmXnBTeZmzzev5FGUI2Mz2ceLmmJwGZ7sysRum+WrgMyyYBQMn?=
 =?us-ascii?Q?X4wyXFcOgue58z0jkfPvuJPcnJeXLukeGog7Arh7dU7CZf3FM9qSXxWIU7Kx?=
 =?us-ascii?Q?EWZ1qFMsl0rEh+H+IeeqBs6Nm5VpwJfNkw/Gh2Xc1rh0LsX58B+7E41GIx3O?=
 =?us-ascii?Q?rCkdn2ky2e/mJrYnAnA+4J/aRXcfGIQhUfZcluaxRkve2CHZtbFxw3mhZfUT?=
 =?us-ascii?Q?v9ah?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47eda28a-182f-424a-2e02-08d89b71f46b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:20.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2jXSS/8Kyzo6jq4Hwvsy5eO0Jofu/t0uHZK5nw7vYhKlfk1S5VH9ByqOMpVHfbAjJx3vYg4qPtq39/GiOabew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not be unconditionally enabling address learning, since doing
that is actively detrimential when a port is standalone and not offloading
a bridge. Namely, if a port in the switch is standalone and others are
offloading the bridge, then we could enter a situation where we learn an
address towards the standalone port, but the bridged ports could not
forward the packet there, because the CPU is the only path between the
standalone and the bridged ports. The solution of course is to not
enable address learning unless the bridge asks for it. Currently this is
the only bridge port flag we are looking at. The others (flooding etc)
are TBD.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 21 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h     |  3 +++
 drivers/net/ethernet/mscc/ocelot_net.c |  4 ++++
 include/soc/mscc/ocelot.h              |  2 ++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b9626eec8db6..7a5c534099d3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -883,6 +883,7 @@ EXPORT_SYMBOL(ocelot_get_ts_info);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 port_cfg;
 	int p, i;
 
@@ -896,7 +897,8 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 		ocelot->bridge_fwd_mask |= BIT(port);
 		fallthrough;
 	case BR_STATE_LEARNING:
-		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
+		if (ocelot_port->brport_flags & BR_LEARNING)
+			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
 		break;
 
 	default:
@@ -1178,6 +1180,7 @@ EXPORT_SYMBOL(ocelot_port_bridge_join);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			     struct net_device *bridge)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
 	struct switchdev_trans trans;
 	int ret;
@@ -1200,6 +1203,10 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 	ocelot_port_set_pvid(ocelot, port, pvid);
 	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
 
+	ocelot_port->brport_flags = 0;
+	ocelot_rmw_gix(ocelot, 0, ANA_PORT_PORT_CFG_LEARN_ENA,
+		       ANA_PORT_PORT_CFG, port);
+
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
@@ -1391,6 +1398,18 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_get_max_mtu);
 
+void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
+			      unsigned long flags,
+			      struct switchdev_trans *trans)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	if (switchdev_trans_ph_prepare(trans))
+		return;
+
+	ocelot_port->brport_flags = flags;
+}
+
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 291d39d49c4e..739bd201d951 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -102,6 +102,9 @@ struct ocelot_multicast {
 	struct ocelot_pgid *pgid;
 };
 
+void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
+			      unsigned long flags,
+			      struct switchdev_trans *trans);
 int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9ba7e2b166e9..93ecd5274156 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -882,6 +882,10 @@ static int ocelot_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		ocelot_port_bridge_flags(ocelot, port, attr->u.brport_flags,
+					 trans);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f4cd3288bcc..50514c087231 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -581,6 +581,8 @@ struct ocelot_port {
 
 	struct regmap			*target;
 
+	unsigned long			brport_flags;
+
 	bool				vlan_aware;
 	/* VLAN that untagged frames are classified to, on ingress */
 	struct ocelot_vlan		pvid_vlan;
-- 
2.25.1

