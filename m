Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506DE2D2A55
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgLHMJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:30 -0500
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:44741
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729286AbgLHMJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hU+zQ47QX7BJ1D0qmuQFjyOpSiZO6hrJharEM7qR6bIPjdfga4HmbMaUekLbUyzTuAcdBw+ZqfnsmHGTV08r9skP36x1/ZXNrjANqTmAl8jVvny3v6HTlDjrUaw1WokCUKQ3J+z/TNEX6b0hbaCuD6HPtDcCp20ptk756JOwKFOrXd81FNwOZP8etu4UZpOs5Bf5l1qFdhJAvHg7JIVEibzE4Vvmt0wmf7r95PQCz0+1xx+6DSdIsxRgol50T7t1NMlwMDRZ7AuZiQVD4E2OqZKZJtvbDKPWw9Oj7YK5oHKj6j2adNv9kMx3aiLZbOcnsqwU325EEvRR7qY/id1Rjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOgyI5iApfuztVH4SMENpM3XW2UpBgRTVLoiHrm64uM=;
 b=DHAzjJ/DlvqeVf4HIHXwjpiuoLhd2Ja+TQHiK6Oj6BDik48tcUHJ+Q2jTKp+5ONOb/DkDbVj174TrV1Nrwq4IT5a2xzr2jRAhft7dTme54MksUyrden35G+6k0j74j+7e2MOuKaY/gKdtI4JhFM+NEwDQ3w0L0ROHhnsYj32HRhjwZGYpSQ4aRIVhUig1GQcLpb7r3ROMSUPAeY2MiGQtQY3jOWiGtonvPq0YQnRwgaMlicBTSO24SNTG+dG/L4mLa2ZxSd5UIB9J9pk+IY2AoeH29COMMaGIJ69a8NZBl5QriZGWm+MXLib/VUs7kg1pnPuATBvNWD4OAGPAUWjuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOgyI5iApfuztVH4SMENpM3XW2UpBgRTVLoiHrm64uM=;
 b=X2VTGOZQFn4azqWAhX2T7n5WVTDEwrK1eB7sdmzRs9/EIGmAEUN4jzNRX3otE9bG9aPwtjxNC8hufFQzkWfMYzc+cjU3K4S7py/9Qm1/HuPW1CcvAvpOzaY+9wZCAc2hmIh6ctHHUa0EVAvgLHlJ64p/bSjERLwXGM9QNZNyMCY=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5853.eurprd04.prod.outlook.com (2603:10a6:803:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Tue, 8 Dec
 2020 12:08:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:41 +0000
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
Subject: [RFC PATCH net-next 15/16] net: dsa: felix: propagate the LAG offload ops towards the ocelot lib
Date:   Tue,  8 Dec 2020 14:08:01 +0200
Message-Id: <20201208120802.1268708-16-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ddfe25d-978d-4a1c-5781-08d89b72008b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB585319529015EB21F4C5DC12E0CD0@VI1PR04MB5853.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wH+8KQSF5PZ48qT/1BRfL64aY5fmuJwpRQJgg/H3N5D+8k2BhUF7tl8i4p4qxyqnAD+lnABR82Z99Fp1Z8YqD4YzNlwsEI2JWvlHAMlQR0A3CqIUz3hsoZ2WtLkxv/SAiAiPRGA2d1uShZuRBaHkkWJCIUurRY+6lNgHg8I3ysrs4ztEvtYFUTe6zlj/Be9O0inQR1N0wUko+7Nv3kZDp4RG+iMxnKY2+hTcw4oA0+MCR0Xx95Ayc6/tus1wSeecl+7x1qjSk5shohxNBXtnaO8ErLsgigEoRWFnSxIoHBcky6zeOZAs7P1zzkKR9pCLl2+nIlbDnKAmIAgt1VYXZzFb0euaHdC50omSiIgWNzat/35Sn5dbNKxXtFE8B15h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(52116002)(6512007)(44832011)(6666004)(54906003)(186003)(26005)(6506007)(2906002)(5660300002)(86362001)(16526019)(8676002)(66556008)(4326008)(83380400001)(36756003)(8936002)(6916009)(956004)(498600001)(66476007)(69590400008)(6486002)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+jmuCiph+507D7jWg8Z4qwWg0xWylIPPs6qgM+D4XV9NbYe7MrRnNEvvV1hN?=
 =?us-ascii?Q?OH4zKLRv3KEQ67Fbp/tD5pIj+B+SxE4WJMUBoqsWCk3o287UDk2enzpRtnuz?=
 =?us-ascii?Q?dRmZpCv8qdjWDN0UIDQ4edtI9MFVNU7hff3bEYzbP6BwMAqzQZrOtbNNtPhw?=
 =?us-ascii?Q?AiFZNFODo4hZcZciUHAP486uNu3BbDmZrLdbxfFdQnq2+UVVA4jLqm90Jy0W?=
 =?us-ascii?Q?5j3dwXBaqbztpgOG/nC7aOb8qF6cDAXFq5HYQwWhgn6orfCF/bF0fVHDp0uN?=
 =?us-ascii?Q?1TLYbwJA/iMA6lSEcgRh9baS/fh5yK1OoYlbFKuqoFR/GCyFos8FJZc0lMHz?=
 =?us-ascii?Q?zWtbI8/Ej1oRCr5MQ2vmFUUDms2llobjhyEX3UQ853pu+IJlGqmD1GqS21p4?=
 =?us-ascii?Q?q1J/Zz33Bb6wgeL94IfPHaQ8XsqdJtpW8XyZtMN8WuTp2F0DTK0S5ffPYPbg?=
 =?us-ascii?Q?19vUkaotD6w6aXyoTCpIjULQchS1Ut3ryagolybAolpE+QScZD3v+8rqTFd9?=
 =?us-ascii?Q?iUfplfT4uOe2ex3kAo+3j8LDEsH9QKei+1hPU3t2rKICn7uYJCabVbnaGGpn?=
 =?us-ascii?Q?ANb7tJYPY6UEO/vTkTcyZSqhQf6P1woXQqYhJ2A4+0DX7g6Rp+Gt5iakTyfj?=
 =?us-ascii?Q?CxNuC2TPCTz2NhTPA5u+WU9OL6csp+GCS554TtS4xR2pSWB7WaWAh7TYSxQZ?=
 =?us-ascii?Q?nTNFqHqgyFc6Mo7yZj7b4kqqHphHi25hqLOxtL9ztuzmHEe/ooZluN7QpArH?=
 =?us-ascii?Q?slftxlSoWW8YlTclqmMoMPgtxIkqCNQkDa4uRrcMb0/De8Y92Doc+L/BTi9v?=
 =?us-ascii?Q?JATMYPIzHb7VIRuci/TCEwGAlJi8DGxI9hL3llpBWbX3iymxbdifCvEk8Y1z?=
 =?us-ascii?Q?9kt8Vz0VFlwW4BOMqX9MSYVxfuYkbUqD21Fm8FSZRi5ra63yZbBLbSjzSHsu?=
 =?us-ascii?Q?7YmldFBi4XqMKO/Tepl5ENLLMAWcXgquUHG17O9mvbMbR1UdRcz67QW1Q2Wf?=
 =?us-ascii?Q?7Evw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddfe25d-978d-4a1c-5781-08d89b72008b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:41.2912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vkA7dG+/fdaiP1aqloib5Jiy5mOSPss2ql6gqDbp5CYO1kZ/1JVoR5f2gy60cMHTJ7ZR5GIYy+qf5RyXBUkVDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5853
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switch has been supporting LAG offload since its initial
commit, however felix could not make use of that, due to lack of a LAG
abstraction in DSA. Now that we have that, let's forward DSA's calls
towards the ocelot library, who will deal with setting up the bonding.

Note that ocelot_port_lag_leave can return an error due to memory
allocation but we are currently ignoring that, because the DSA method
returns void.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 27 +++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c |  1 +
 drivers/net/ethernet/mscc/ocelot.h |  6 ------
 include/soc/mscc/ocelot.h          |  6 ++++++
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7dc230677b78..53ed182fac12 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -112,6 +112,30 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 	ocelot_port_bridge_leave(ocelot, port, br);
 }
 
+static int felix_lag_join(struct dsa_switch *ds, int port,
+			  struct net_device *lag_dev)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_join(ocelot, port, lag_dev);
+}
+
+static void felix_lag_leave(struct dsa_switch *ds, int port,
+			    struct net_device *lag_dev)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_lag_leave(ocelot, port, lag_dev);
+}
+
+static int felix_lag_change(struct dsa_switch *ds, int port,
+			    struct netdev_lag_lower_state_info *linfo)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_change(ocelot, port, linfo);
+}
+
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
@@ -803,6 +827,9 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_mdb_del		= felix_mdb_del,
 	.port_bridge_join	= felix_bridge_join,
 	.port_bridge_leave	= felix_bridge_leave,
+	.port_lag_join		= felix_lag_join,
+	.port_lag_leave		= felix_lag_leave,
+	.port_lag_change	= felix_lag_change,
 	.port_stp_state_set	= felix_bridge_stp_state_set,
 	.port_vlan_prepare	= felix_vlan_prepare,
 	.port_vlan_filtering	= felix_vlan_filtering,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5c71d121048d..cd7a2e558301 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1381,6 +1381,7 @@ int ocelot_port_lag_change(struct ocelot *ocelot, int port,
 	/* Rebalance the LAGs */
 	return ocelot_set_aggr_pgids(ocelot);
 }
+EXPORT_SYMBOL(ocelot_port_lag_change);
 
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 0860125b623c..3141ccde6a66 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -112,12 +112,6 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      unsigned int vid, enum macaccess_entry_type type);
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
-int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond);
-int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			  struct net_device *bond);
-int ocelot_port_lag_change(struct ocelot *ocelot, int port,
-			   struct netdev_lag_lower_state_info *info);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8a44b9064789..7c104f08796d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -780,5 +780,11 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
+int ocelot_port_lag_join(struct ocelot *ocelot, int port,
+			 struct net_device *bond);
+int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			  struct net_device *bond);
+int ocelot_port_lag_change(struct ocelot *ocelot, int port,
+			   struct netdev_lag_lower_state_info *info);
 
 #endif
-- 
2.25.1

