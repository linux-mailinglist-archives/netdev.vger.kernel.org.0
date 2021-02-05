Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3B3115D4
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBEWnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:43:07 -0500
Received: from mail-eopbgr50062.outbound.protection.outlook.com ([40.107.5.62]:3953
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232470AbhBENGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:06:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jS7mcMYjs48DJUubfHa9eoqoOcfm0pgbJvDOUqgSowiPbUqPqzYaseJJZrc86gm69LiQUVD1bk9Hk0mVFAysKTR+zU+aCGLHPcqynd94CIgNI15GL4IIzUMDhSgVnusy8rNAmSXbGEtqLJ8Spj5BGX/+hY8sweXnoO0ktJJvJawmH86ZX9PSNBOvaxFDQHjTozMmYM733mgM7NjmC++VXJqW1LNEekLPxQX955jwyYZHuXgg0G9YeA8X4uWzog5wlz/plGAh31ZSb7VjxcyTN5tV/lskiOaqoEIYPdBE8+TM0LgLMdN4ge4J4LUVQkgzw2qj6xXvzRNTT3SU5RFhZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pe6McAGWClnSbrANbFnBwZDrpMnUa0RZD/lgH2I/Fw=;
 b=UHwsEC0IlI9thV7tuvU7AfYxR3ov2k17JtznzIb+23ddT1d5avVUKIQLpD/g9BpxH4ovsYwxdKM+ihHJZMiR4VO2CY5s7mSTpDTmSEDqIlPG8R5j35H2kzwF/Uj9fJP+0K9MMSIeuCDcR29Yz2cXjTOgWMU5IxOAJCeMXHvXK3+QUVqExYekN51jtcO7nFnjx/vcpa35JfABp4S8hDMNC7GTPN9SYzda6MAQ4+ZRvQMzaYghZUmUXGnUXHTzhUO7c6NkEcMCoUt23LWw5/B+KSMwYuNH5gu9BbwE1/jrq8GvqljgoSHM7T/8kdVCdnbqr/Q6UOE82B7g77NahX96jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pe6McAGWClnSbrANbFnBwZDrpMnUa0RZD/lgH2I/Fw=;
 b=PhyuxVaKnYwT6STpELcsmySzwv/MTg6plP1f6aUWG79wiUAoHhArVNuWd2bNokgGIs28YsEUZvAedRac5bY5YiniF5Y8acvzeATzRLgUWm/ZmmwkTjWAdB/WQ4fPq4Kb3hScwn8bNxMdB8bLSAc/7OOKUBN9VECPjPVquhXvfN0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:02 +0000
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
Subject: [PATCH v3 net-next 05/12] net: mscc: ocelot: set up the bonding mask in a way that avoids a net_device
Date:   Fri,  5 Feb 2021 15:02:33 +0200
Message-Id: <20210205130240.4072854-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1dd3285d-9029-4703-cbd4-08d8c9d65e72
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863E0E0A7665D04E7D22FA2E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yvIePtd9g8IDne87+tk3sWKaIEcNKBUfcJaduSFj8x3MM7YWw0c2dbzofeTu2WCfqFFETOZQqOr+X2rMQH02Fx2u2YINIOqQJQyIk1Pe4D1liBreD3wgvcLF+h4TA2qa850j+fZqo3IFB2ftLbj/U4aHsXMelLP0nQk0m3kw9XD9tymIErTDlTGZo7bKUvpmw53+DSEoQf7cGaIZL8eVZJ6oNwKLYbf4Jrp58r6KnTb11ExXBWICipR7RyYwB7IONQ6Ukq9fz5AdHdXcsG4kPWqvx/ttcUsDjfu/jBXzzaENRSRhq8PTKOMaPDssXk0sZ431VM9ONDa9KtoARWEBbsze26N/II3R+HpYGJCOLjDQSQ5yT8bGoRIzSvdw/GQB2dhQqiA4o0i+4woPQrTi07i5pPeWG2lCeXF5hFWyRIX0XT93+IWAPE+I5Lb+DxtviEwKGwp3/H7eTk5WftiemLnAhfBJzjhTxF7sghVERuCmw15A8sC1++TvbECbgRU7Q4dsEB6YU/5tmosBVRqC9AKBF+a/uFKHtag1EYYDJS1rbc2QvsSO/13oxvaUJ1H2bPybGuFbrCLqMEEeX910NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a1k72+NENy4Zm7ePTZ6kVB8HgEt2Epk00Ro021Aa5iuUeHU62x/z1A9YW6Lb?=
 =?us-ascii?Q?dAB4HtI2TCW21xBcDGYJz/eyJI1PO5OOn1Xh65JX0elz10RhmJugHyMK/jxo?=
 =?us-ascii?Q?5xGYllGyf3YDkzI9SX+1Us1XKsTnYtKhhMJ48keAZXIQkGPRcoW1hpe/O+du?=
 =?us-ascii?Q?KEQN2R4/QzsIy+KqfSPjHGE0mmHRAx7XYXpLWUZsb33FsgCiGFfcQ05WAiOZ?=
 =?us-ascii?Q?V+D/GgIszn7wuV1kHgcqC+RE5QRO53/drV1XL0/v0iwgfSZfxIQaFi3vTLah?=
 =?us-ascii?Q?+r3PeAxVXdr9meSnnbitmrYpEiwOCHQH4J92xRtUh5IU9GOMYgClQyhpgjd5?=
 =?us-ascii?Q?wWGZYT1+2sPm6D6I1IPe3xY6E7eF2Wt3eEJOuAP/g8VTc9PVMBjQC57YhDnS?=
 =?us-ascii?Q?bq0kZWxJyCzmp+3J+NYcVwcIEq1iYW00qxZF7kcei79hdx6CKOVWJkgBtTE3?=
 =?us-ascii?Q?3T724SgtGaeWwTeOBRMkUg6Y1Kz7vyn7iSjPwKgTjCx/yzWw/kLQ5hUZhxiv?=
 =?us-ascii?Q?0BPpRqqiEPHu1OenHwBSnrtVnAPzr81uiFxNFFL2KnQz5e4Q82tVn2HJyAvZ?=
 =?us-ascii?Q?s7Qb0Tc7fW65vKQqFTgxF7kJXN6aus85y1MLjthzHfZXdEXDn/GFOtr3JkKU?=
 =?us-ascii?Q?NpIErm/rMmFU48TB6ePpXiYLlTT9VewPVXajdH3Lqm+GqNYuajbe8q9R59t1?=
 =?us-ascii?Q?OYraFRNxcxI7Fz9mr+GxiFRib7KfYPIlCJqrEsfhA6DTQoBVD0kIisaW4n7M?=
 =?us-ascii?Q?nrG6McbKxyljtLJa+qjYSfJnqCfpyKpV+RMWtuf4tTw5fQimeoQX2CNS7Nr2?=
 =?us-ascii?Q?gBrAJIBj9sx9pPAn/2mNboCZ0EnTGCEEazYXdGr75npO1+fQkV2XxOAWNAmB?=
 =?us-ascii?Q?TArtETUeDR0j8tQmNSDYYWJhWyqHLu4Q/NXy2Elw6vU6KZWZSnttFCRdpSAy?=
 =?us-ascii?Q?8j4LcvYqGrT3Nii4JZ7pCkOnP2iYI3gOfp0Lb/PZDdA8xl2i1pe5drQEMkJb?=
 =?us-ascii?Q?5O0b4CwpkP7FQEwHYnV/fIRyewQfo/0nkd4eKhyWTggJVGMyBKGoaYQfWs4a?=
 =?us-ascii?Q?RVGFR6zLaJXA8HDR7YSY7se+te3ZV/lNcCb0Mq+4gbQ4dnzk/VyHsxN+U95z?=
 =?us-ascii?Q?gnFKkdqiXee+SeT++Kpjd5oZme5Lplxb7joy66Jftd5X81zTQwasUf5Kqkj6?=
 =?us-ascii?Q?dE4AloN+UrUbxsWMTBTzXC6VJq3Z3OqOMtJhcEbClzBWqRepG8lKS5tS9GCK?=
 =?us-ascii?Q?HIaS7is5Ufk1UyhyUq68hCwyoD/Pt2LP/bVLhFIorA5h4BGp4BY4mSdTzIR8?=
 =?us-ascii?Q?znERjPePGtPo/oaZ0V6regEL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd3285d-9029-4703-cbd4-08d8c9d65e72
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:01.9809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7arKT2k/E4A4MLU5pwVYQ9MIqBWuIESgwOkkr0q5roDZTnOR8FfZOx+F/W6GYdiCYm0I8hDVbTslMoqFc//KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this code should be called from pure switchdev as well as from
DSA, we must find a way to determine the bonding mask not by looking
directly at the net_device lowers of the bonding interface, since those
could have different private structures.

We keep a pointer to the bonding upper interface, if present, in struct
ocelot_port. Then the bonding mask becomes the bitwise OR of all ports
that have the same bonding upper interface. This adds a duplication of
functionality with the current "lags" array, but the duplication will be
short-lived, since further patches will remove the latter completely.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
Adapted to the merged version of the DSA API for LAG offload (i.e.
rejecting a bonding interface due to tx_type now done within the
.port_lag_join callback, caller is supposed to handle -EOPNOTSUPP).

 drivers/net/ethernet/mscc/ocelot.c | 29 ++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ef3f10f1e54f..127beedcccde 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,6 +889,24 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+{
+	u32 mask = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->bond == bond)
+			mask |= BIT(port);
+	}
+
+	return mask;
+}
+
 static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 {
 	u32 mask = 0;
@@ -1319,20 +1337,15 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
 {
-	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
-	rcu_read_lock();
-	for_each_netdev_in_bond_rcu(bond, ndev) {
-		struct ocelot_port_private *priv = netdev_priv(ndev);
+	ocelot->ports[port]->bond = bond;
 
-		bond_mask |= BIT(priv->chip_port);
-	}
-	rcu_read_unlock();
+	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 	lp = __ffs(bond_mask);
 
@@ -1366,6 +1379,8 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	u32 port_cfg;
 	int i;
 
+	ocelot->ports[port]->bond = NULL;
+
 	/* Remove port from any lag */
 	for (i = 0; i < ocelot->num_phys_ports; i++)
 		ocelot->lags[i] &= ~BIT(port);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6a61c499a30d..e36a1ed29c01 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -611,6 +611,8 @@ struct ocelot_port {
 
 	u8				*xmit_template;
 	bool				is_dsa_8021q_cpu;
+
+	struct net_device		*bond;
 };
 
 struct ocelot {
-- 
2.25.1

