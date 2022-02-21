Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783974BEC96
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiBUVYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiBUVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D98412A9C
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiUUZZjMhmv53N/0oLaeNhylmvbug98zsKojzhU34zOqf37s3i6oR4rI7K/C6qHSz5xS0U5tJUyzCXt3YQpY9TEbTzjYxQKWJUtDfCN171KgQLG45aHs2/U5J9G13WxHMte7KBsm6saghG+k6pwZzf8R9lUXL9M9YKZ6Hpd2wADFOZZmcjX9Apfxv85PPdGf2GJWNptK7I2aKoevXfXGWW7xR9MWuYBO+H5AQeAXGCXWikH3df+da4NvVfeqkMu3uAc6jXZq7IRoK/h+mXwXkB0c6hfOABpZx2knYf5rA/IKM2BBrqf1AOJfIDtKid4PEPm9KP7cGMAlmHUMvkWNEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/vCkqGx+L6HeNgDR+ThgPU1obwVanJPoXMcx0Bvtew=;
 b=TedJIMvcvWdzFRhCmMmyG8pAjHVIVbRIDBD16U24cSmhx0N1ZIak9GwK5ue3bRql0l6TMaNwTqVkRJ18LykQ+95/HJ5qAnluNSzJlGQXofMIABDOZWRGvZX8oktPgdy+Xp5B9WhqnJasRRSIjxU/bJukeQU6vjALMJOFd7Da98W9EvG6Um3zCHt2YDcVz/IxYGX5hEP34WozOq8vikyh5ZBMqG7H0VZBsuQeN4lnsk7E6Ja7Z+JwcwQaRAcYfDy73NfuHg06hN2uugFIyBKtOw2/3RIXhL4SMiIhdSTmetck4WzmqxuDCQ9yw1eDK/rdN8Zj81hbu8rfFWBVm+HynA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/vCkqGx+L6HeNgDR+ThgPU1obwVanJPoXMcx0Bvtew=;
 b=ajmTCx6X/SNIkmzoIccksMPB+hXNDd8V5yijf7utOqyjUKtVi9IeQAezZyKbwzgU1hQtupVxFjHX9Mepjgrrg8tZN9WlOBwDDiDec1BeFwe9ccE0Uknz1cPgFXawPir5PoYe9P4W5WVDflha6lLdpDLx9rVLMgiMny6bhkpsueQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 11/11] net: dsa: felix: support FDB entries on offloaded LAG interfaces
Date:   Mon, 21 Feb 2022 23:23:37 +0200
Message-Id: <20220221212337.2034956-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 677fef19-436d-4fdf-56dd-08d9f580848c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB56459DCDE5F1B60BE6DD90B9E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnSQyAb7dQJkbiZw7AwDUwczplv4/nY4oTIgpbTh2lHZ2aHTi+7uXPgy5p3m/83aUwz/c7dbAMP9RRWny0m/yJf23oqG316SUFG/df1SiJIF2cZoZWaHipAJzSJZYmOgQzvmLXmz39SrfuRK6SAiSP5U3D+SPsSazuXiUx7xitUo2zly8U+Cu1x/yAsjHQ2F9M0GJCEBLyOFAMryNX+0RC1A9xmA81MXBQgBm02lssHZcQbLRiDXwayoESuCrg3kkEEG/x8HOKvClNfLQE2je+2NqZ2GHTC/S9xdn+X1qhiJiStM9ZaTm//9Q9QQcfRZ8COp2oo9mYcR7LDWLE3UM13cUbNcxkMDhiFbTYijtqzHiShu0uh2Xb/wpjQkNtg7f2zNCckA1QuqClZbwLdMw4j4lXL8toBmDZL9HRhcrDBpah7CyWcuEDqj9l5GZxxFlix/TtMXp1JcMzv6yruCcH+AJRMGMFIrSV5zbHeADxb6lrGQ9zI9T4qDwOnLIpElfI/g1OqMTKKuHSaLCVOpM8b4cAYFoQ8TdOxuu8BGi7yVlcFeUl87mvuTOYrSR/NCO5bA3g+e8lFTn4KeoZWh+MIkzhrwe7Rrvmo9WdUc61NUFApqj2K/rFFn7jr57hWqbaMhBBAX/5BitI5qU9zcCI2Kmv+L3Ze7KgqulI3Ma2uDXd/s1OvCO1Leet6wV8Hnn6lAjShCnjb+ty1HwyWGCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/5P7H9T6Ew77LnaUv0MecQEg1LV1CmCSt2xPEdQxRecekSz2Qa4UfUC7Zf2k?=
 =?us-ascii?Q?XsIbNdqktJxTIYiPdXAw9/n+V8HNn3Lyo+hoCp/2CHd2k7iBpa7st1naGgIg?=
 =?us-ascii?Q?ElK1vV2nKUlOUImKEN8WQed7HTrXLEWsWhL536YZeqDScgV0y5vAuRQTBn/d?=
 =?us-ascii?Q?WSU3p2zSgWei1TXYIKWD+euadBKV8bSGr9kiR+Qe1iBgMI9PdcyPoO0O9IDw?=
 =?us-ascii?Q?SXFSQRVX8BzveeDtXPOSjj0l5o9cJLGjaofoM9MVhNl+DO4DgtymDQOFdMm+?=
 =?us-ascii?Q?SkIM/z5RrqF5Z9v8YlbYhKooKNQvJmddT35gzVoljy6xG1xXoeofFTmoZyIf?=
 =?us-ascii?Q?BK/KDuJCAkLS/KmtYJAxIqnfzTz7OV7ckYE3r9yCh+N7h2BgIcu1TJEh67zp?=
 =?us-ascii?Q?ng/hVxjiq1CShR88IvdZLvHhpnpRvcNQxXjjyLRMuQ8DdXOOvtvVch0te5DF?=
 =?us-ascii?Q?AbDiSs1YITHD9VHb5mgLHfyHVJXteQ8LQOKH4w2+sRkWWaxj0bpn6fzboWHq?=
 =?us-ascii?Q?JHYgoJ6+ok+FJ6g2Ik0gsFHDZKLlWKzk5BVXkXgZqrS/AtR3zl3tcRP9Xfny?=
 =?us-ascii?Q?43Om6Dw/7LLSbjrkeq+iQDU/lpmFGnw4Jkuwkd+s80N+lVDgATHjD9ePCOaM?=
 =?us-ascii?Q?bxj7E3w82u+/97UXXjch5TrXqYvy+xrQ1nsHNAIao2Bb8u1yqI18qENmtgH4?=
 =?us-ascii?Q?jjOax5+2UcFRe5OscCKcoMSBWRi5X1l3WvIDaHdb+7yMzIHhH3oTJW7Xovhw?=
 =?us-ascii?Q?hV8XkSU/fNcIaXTOcW7SXXxEJrBLBfb7l0Fdsf8U3TSChUJujWJTanP3Wxlt?=
 =?us-ascii?Q?iQ0vjwMUk8EMUBqDz3F/STcjkOo9I+m+5dBNHAfHTODcr9yxj394BReQqJSp?=
 =?us-ascii?Q?CpU54Q9RxlZVglGsrn57WC6b/VBZHb19gLUyAJzR9Bgo8rCuGrj5onS13kMM?=
 =?us-ascii?Q?JF+ONh/eC3pog/YaXpLWhVKmJpKo1f+m0+4JCATQ9FOKOPXKkuBwAXIE+Axn?=
 =?us-ascii?Q?Jrnus5uSou863ftrzBjNQ6xP+56nn9H/39CiK1MQ3xFdslJhCT7sROrSB6cE?=
 =?us-ascii?Q?KgqwnlMuHrBF9Ql86+DJvroSKkJC263h7dn7GFJwqe5cEprfmuLYxU9lZ1eM?=
 =?us-ascii?Q?o6uHASO5MYX3KPd8N7OTtEWGhl8Gvv3cqdiAGKBzmOWmZlK1LG/XCoEI6ZLg?=
 =?us-ascii?Q?XtRQIS/xJ+/Tu7k+EN6ZybP6fqULFCY9JqTi37kuCiygnKanHUdQ+b1TRp2C?=
 =?us-ascii?Q?CbJLIAmx3D2FPrcW4DeJzL2hLng/mkpKBJImAKpB5rGiK/OOQRVx6MVZ5zI1?=
 =?us-ascii?Q?IgW8RQ/Zqu2P6ZVIlIdwIJAfgoAXrJLL5I2lvhiImq6fjh3jGq+OBo/z3xSV?=
 =?us-ascii?Q?fgopNjsBpXPufwX6KvFXKsxmL7XsduOPZZWdTPywmxsRQuAbnoMqSiwUyqZA?=
 =?us-ascii?Q?s4HpXzgZqEoOlVy+JTECqnZTeJUrq+TEDtdedxmXeiy6TvYidr3hVquZ9fdo?=
 =?us-ascii?Q?RKNB17tEwoxkX7GIBzTu/1pHyyOYZhis9reZDc8JM9oGCzwUFsMQ2vmv/Tx2?=
 =?us-ascii?Q?HS8NzpuI64HzjiVhaAm1Ztvl6f5XTq0EX+fjD7nnmyoat/P4BEBKyyjSuadN?=
 =?us-ascii?Q?wQJVx394QdlLnosFv7RnX6c=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677fef19-436d-4fdf-56dd-08d9f580848c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:17.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqk1Oy6ScJkPSyXwO1idtXJFN1OTH9is4h0W+t1Cp/v+OL2YWL+MtJtzDLG3+3CL2L9kN/HPQl4QAJc1ug/9DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the logic in the Felix DSA driver and Ocelot switch library.
For Ocelot switches, the DEST_IDX that is the output of the MAC table
lookup is a logical port (equal to physical port, if no LAG is used, or
a dynamically allocated number otherwise). The allocation we have in
place for LAG IDs is different from DSA's, so we can't use that:
- DSA allocates a continuous range of LAG IDs starting from 1
- Ocelot appears to require that physical ports and LAG IDs are in the
  same space of [0, num_phys_ports), and additionally, ports that aren't
  in a LAG must have physical port id == logical port id

The implication is that an FDB entry towards a LAG might need to be
deleted and reinstalled when the LAG ID changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v4: none

 drivers/net/dsa/ocelot/felix.c     |  18 ++++
 drivers/net/ethernet/mscc/ocelot.c | 128 ++++++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h          |  12 +++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6d483887af04..9959407fede8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -614,6 +614,22 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
+static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
+			     const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_lag_fdb_add(ocelot, lag.dev, addr, vid);
+}
+
+static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
+			     const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_lag_fdb_del(ocelot, lag.dev, addr, vid);
+}
+
 static int felix_mdb_add(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_mdb *mdb)
 {
@@ -1579,6 +1595,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
 	.port_fdb_del			= felix_fdb_del,
+	.lag_fdb_add			= felix_lag_fdb_add,
+	.lag_fdb_del			= felix_lag_fdb_del,
 	.port_mdb_add			= felix_mdb_add,
 	.port_mdb_del			= felix_mdb_del,
 	.port_pre_bridge_flags		= felix_pre_bridge_flags,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2fb713e9baa4..0e8fa0a4fc69 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1907,6 +1907,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	u32 mask = 0;
 	int port;
 
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -1920,6 +1922,19 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	return mask;
 }
 
+/* The logical port number of a LAG is equal to the lowest numbered physical
+ * port ID present in that LAG. It may change if that port ever leaves the LAG.
+ */
+static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
+{
+	int bond_mask = ocelot_get_bond_mask(ocelot, bond);
+
+	if (!bond_mask)
+		return -ENOENT;
+
+	return __ffs(bond_mask);
+}
+
 u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
@@ -2413,7 +2428,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = ocelot_bond_get_id(ocelot, bond);
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -2428,6 +2443,46 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 	}
 }
 
+/* Documentation for PORTID_VAL says:
+ *     Logical port number for front port. If port is not a member of a LLAG,
+ *     then PORTID must be set to the physical port number.
+ *     If port is a member of a LLAG, then PORTID must be set to the common
+ *     PORTID_VAL used for all member ports of the LLAG.
+ *     The value must not exceed the number of physical ports on the device.
+ *
+ * This means we have little choice but to migrate FDB entries pointing towards
+ * a logical port when that changes.
+ */
+static void ocelot_migrate_lag_fdbs(struct ocelot *ocelot,
+				    struct net_device *bond,
+				    int lag)
+{
+	struct ocelot_lag_fdb *fdb;
+	int err;
+
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
+	list_for_each_entry(fdb, &ocelot->lag_fdbs, list) {
+		if (fdb->bond != bond)
+			continue;
+
+		err = ocelot_mact_forget(ocelot, fdb->addr, fdb->vid);
+		if (err) {
+			dev_err(ocelot->dev,
+				"failed to delete LAG %s FDB %pM vid %d: %pe\n",
+				bond->name, fdb->addr, fdb->vid, ERR_PTR(err));
+		}
+
+		err = ocelot_mact_learn(ocelot, lag, fdb->addr, fdb->vid,
+					ENTRYTYPE_LOCKED);
+		if (err) {
+			dev_err(ocelot->dev,
+				"failed to migrate LAG %s FDB %pM vid %d: %pe\n",
+				bond->name, fdb->addr, fdb->vid, ERR_PTR(err));
+		}
+	}
+}
+
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
@@ -2452,14 +2507,23 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
+	int old_lag_id, new_lag_id;
+
 	mutex_lock(&ocelot->fwd_domain_lock);
 
+	old_lag_id = ocelot_bond_get_id(ocelot, bond);
+
 	ocelot->ports[port]->bond = NULL;
 
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot, false);
 	ocelot_set_aggr_pgids(ocelot);
 
+	new_lag_id = ocelot_bond_get_id(ocelot, bond);
+
+	if (new_lag_id >= 0 && old_lag_id != new_lag_id)
+		ocelot_migrate_lag_fdbs(ocelot, bond, new_lag_id);
+
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
@@ -2468,13 +2532,74 @@ void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot_port->lag_tx_active = lag_tx_active;
 
 	/* Rebalance the LAGs */
 	ocelot_set_aggr_pgids(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_change);
 
+int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_lag_fdb *fdb;
+	int lag, err;
+
+	fdb = kzalloc(sizeof(*fdb), GFP_KERNEL);
+	if (!fdb)
+		return -ENOMEM;
+
+	ether_addr_copy(fdb->addr, addr);
+	fdb->vid = vid;
+	fdb->bond = bond;
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+	lag = ocelot_bond_get_id(ocelot, bond);
+
+	err = ocelot_mact_learn(ocelot, lag, addr, vid, ENTRYTYPE_LOCKED);
+	if (err) {
+		mutex_unlock(&ocelot->fwd_domain_lock);
+		kfree(fdb);
+		return err;
+	}
+
+	list_add_tail(&fdb->list, &ocelot->lag_fdbs);
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_lag_fdb_add);
+
+int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_lag_fdb *fdb, *tmp;
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	list_for_each_entry_safe(fdb, tmp, &ocelot->lag_fdbs, list) {
+		if (!ether_addr_equal(fdb->addr, addr) || fdb->vid != vid ||
+		    fdb->bond != bond)
+			continue;
+
+		ocelot_mact_forget(ocelot, addr, vid);
+		list_del(&fdb->list);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+		kfree(fdb);
+
+		return 0;
+	}
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(ocelot_lag_fdb_del);
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
@@ -2769,6 +2894,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
 	INIT_LIST_HEAD(&ocelot->vlans);
+	INIT_LIST_HEAD(&ocelot->lag_fdbs);
 	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 78f56502bc09..dd4fc34d2992 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -635,6 +635,13 @@ enum macaccess_entry_type {
 #define OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION	BIT(0)
 #define OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP		BIT(1)
 
+struct ocelot_lag_fdb {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	struct net_device *bond;
+	struct list_head list;
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -690,6 +697,7 @@ struct ocelot {
 
 	struct list_head		vlans;
 	struct list_head		traps;
+	struct list_head		lag_fdbs;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
@@ -866,6 +874,10 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
+int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid);
+int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-- 
2.25.1

