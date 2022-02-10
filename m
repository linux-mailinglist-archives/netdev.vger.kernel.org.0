Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171004B0DEC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbiBJMwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiBJMwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:34 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30050.outbound.protection.outlook.com [40.107.3.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6300E2654
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCdj4Fbp6x61V9z6DAuqUwXoIOOlOChyjALYZYKAgjFX9n3x9Ax0cEpToAxjNnXhrKl/Y4pjND0jmSqodWO2RMXo5oaUAxpVbcsu0JnD+pY3P0YZxptVm9pX3364/nUjM0EKSmqYwZNEQGsCh3lmyd6KLy4qPrC1HeC4KNdythJSfrni6mmoFXbOGg9HJfULxDNtlSczbJXNdx6cZHu7ars56HHESJyMv9sQySK4scIjnbJiE8+SxJsvO4L9K/lW/tpP042fTf2oXRlJnyUllJkeLZwVVlTN8k+rIkMK9WxqokxbIhQDAPHn+MDGCAZpRGOrKbdo6mGD9G7Af/IPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AR7sSsuh4a5zQxSu/JLk/mYPP6BaZx2Bj4q2TPd6HoI=;
 b=Pflp49irrIfPQhvbV+FtPDL89is00DiQ5x2Sbagp5wvB5FCDOUe3B9PPLWyeen6sGYJ/tSu/soKz2IV2+oWvHhoNPr55k9mm+CxAc2jiVk6cEBJ/CiXhW9nhPeMGG2Qm5Wcla9kgPQnk7W5vnPbTJ6VQ0MC1uHJNaj5xDR930DDAOnVmIZgug52YiWaObkkajyzBmGXqvhY8RT4/qP3+4pqI1+LcgE1gfil3OdzSi5bvHRMe3h4nuXk2fF878kSh1TD4oW7jmE0GTbiOIUhXoUduPqe8grhiSr4ny1ZqMGUONtWvYaDZGgayCp5DKNxm7EW7vHrPfaqAxEyGi1+7fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AR7sSsuh4a5zQxSu/JLk/mYPP6BaZx2Bj4q2TPd6HoI=;
 b=opgiwga3dyL86i8fSPSvMyB4kmBN0diuq72TqtV0HLuf1XeitUEgaj+O8LROCqgdmXbCnpQdSTk1LQ7U8Vfq2JmrAWElqc3vgsYPsv8jj5JOc0OhSocZTCp/6YiceAW0cwbojqoKALxn8H8tUOf218TLNL7fNVGGaLzkj/+Mm+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 12/12] net: dsa: felix: support FDB entries on offloaded LAG interfaces
Date:   Thu, 10 Feb 2022 14:52:01 +0200
Message-Id: <20220210125201.2859463-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0a11e9d-046d-4ae3-809f-08d9ec943351
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB88064BDA5E925ED592E08063E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GOSsxusKEdVyQRMIJrYivXe86qEhJnex3hCqpFulKA4Sn1VjtB13F1hkgthRc+H/a/jbBTWBihjKvOmrH+FOIK9ZvahxwMi+AIFy8gqkX/sfTM6ekaU/GNovPEOyuQ1XTZiGC8p6tYXJ6WbgXKAU88VeX6jG9x8hYaNkBxytjf3NP7REUrXVvnbJWftNbUBvWJfW0UHU30ArCE1+aAt7LbSTzsw3Lqd74TOk0sqR4yysHA4V/yZWNDsULEsAmH4NhKzDgBn/24REYEaqwJptmzYC1K9wrfV4+sm1zmpQ0whVht7lidOmyzACjQlWgzutIRv3MSFUPGSGU9YcYv0vPPrDfw2AKAp1GbZWnBpPpEvUV1GizKZak4NTdxtlRTNLPVJy4iLXHoKxNTlecxhsemSkhOyvfibdFArrL6qvJrotc7LEVZDTd8ToNWIpqoyDtzlZBoo5ohztod7NAugKZ/hjf7oj41A+94y68C48mICCHeadL+MSp51qDN+8tSDWN9avcDE548RlyCumAR4T5I6hcDn24p7S5vfCokStezwKsa+/z2wpRP6x60/y3CgtyAA09EvvFtoP3K8+FxJexaS8UQBlSQqb3MNeNGhtJdIcTR5F2lPxchz/igXG+ULBNS3tM69v5ThlVmKgTgegTxMo6zKM0vE3X/VIzHJ7Qp/7THKkka+SiOMbymllQa8poqjxeArSWhCCnwTKOMFIcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JxJdYDGMTIVNW1kyitT9qazTpE7kIT9M2x3UetTuVJXr7DlafxnXug3p9D54?=
 =?us-ascii?Q?2/7VaU4BPGUu32paQXlndtqvAqo6e+/78HemSEZWHreM4PRIHXHsEdIMQaMh?=
 =?us-ascii?Q?/CNa9kBmC7GaA0watR2p+24BvK0hGFc5XjLtAmmCjhyDJ5WpGHGM8+MuduQg?=
 =?us-ascii?Q?1k0aUgFg0eAaa7UtV8u2h27nkdyiSmYWz2v50JoswqL2qBgkG+dwXTZ++TNL?=
 =?us-ascii?Q?kqGQ0n5qVG0ylMiedAcUUJE1pZcmVV4MTfBNuEf50UnL7b3AptyyyuoWwWSZ?=
 =?us-ascii?Q?U7AtbShIidGS0vDWCu8QSSZEb6c+X4ev6Vm2gEg4LjZRf39HWLoxovapAHRI?=
 =?us-ascii?Q?KcxDI+I35bKtP8UZNM0mhbGUDVXG9wXaC9yc+SG9kOFEPtaka1Q5wdp4iSBv?=
 =?us-ascii?Q?9YGGxTU7yTcbB/aWEJ27Hap6f5WeXuRC21GA1bAJTfIK/17lMViDxqzqC8GO?=
 =?us-ascii?Q?wP3noqnBoPlB50wm/eBCEDGi/Zpd+4pvM0HrQevPZr8BqU6MmTm1Usdw6/ur?=
 =?us-ascii?Q?S6xZpKsLrFD9d8AgT7QL3gma5LtmLIX8wucJ14Qi0DyDVsxsusY7aJL7K2+O?=
 =?us-ascii?Q?fAoQqufOEKmCN1boFk9XgxkJv13OTcFBB4PMAxBdhM1NdtjnaMCMdg10ja9R?=
 =?us-ascii?Q?Ofm9Zv+XDbnFZpJPDKMvFzEWJwbi/r/5l6RcPoHvJxE8jAF93hEs/VIljLl/?=
 =?us-ascii?Q?H8qT/thAobzaTDACPWJsKEtilN6L1FuGxBJB3pr/pA+3Zy0Yrbl8LGZZryZz?=
 =?us-ascii?Q?p+U/oaraE+kHhAKwMEOJYzCzN/bzy80PL0BAZtavXu8AM/SsGBUKcQv7b0G9?=
 =?us-ascii?Q?6BWQzTHpHkZUHLWzssl5VEkN4Fwf7lc1L5Nfdu8uVtuGF1BKv1oYtGCAhaF4?=
 =?us-ascii?Q?uXpKDr8Q0o9Zd4bQY51287sgZjniGgLsqtgsaVuhjlj+y8LRo+Ey/KTlZIZH?=
 =?us-ascii?Q?JiT33odH/bzosMpmP9LSmkGu0d+Y5QBYQy1Myf6GYV9ZgJSnNQx34k2VMEV+?=
 =?us-ascii?Q?MrzhwuoslZoTpWrIf26u/Vbip/atTNQyF8fj+OC0KdpKpyozCIneBR1PLcNj?=
 =?us-ascii?Q?94OW6X0Zf9UXzCcPZO0q9xJaGAhRNSZQRybouvBCJSx1zoW/NDuDeqVSiZM+?=
 =?us-ascii?Q?cJiPpjl4A5QPmtExnjOjSwFLCbz4ldN+gj1K0CppgKqqO5MsSy2Ktz9ocjX/?=
 =?us-ascii?Q?d/3CyRwhjprFaGveJ0jpHW5WhLWQxPEDlKv9UlhHXFVf2Ag+fK6UiNctxwjo?=
 =?us-ascii?Q?qtKCf3XW2kacz6x0P0iDv8Hapb7tBjEpP5GkJjbsJcGCy9D5TWM6TDad+ovl?=
 =?us-ascii?Q?7sO+5fjv8m6BpEX9EyQtLC24xI0/DvYDNU1xvSPZwhawQxKbb6BREhq3Boqu?=
 =?us-ascii?Q?lNySTelu0QwwwguQ9gkjQp6NUnHARfv8LovHmh3FMZxE0xDmVegDiCA5MmCJ?=
 =?us-ascii?Q?IzJI9TAJO4EPKHgOFraBDEHFwS/Z5/eg8ltzhuLf9daohZOXPojI7wcc8YPU?=
 =?us-ascii?Q?70UfaTgsD58USOC1NdVdXnOrgAndoygkNw/6pad8zSjCQ2A97CW/cFrLuEIq?=
 =?us-ascii?Q?11aZrbwNdwRVOrvwM3wczwaZm/vvjjzHgO6rI3r27QMjwVpzS0j3XzHw4p32?=
 =?us-ascii?Q?J0fQVh6fyrb7KPJ5wnVpwpE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a11e9d-046d-4ae3-809f-08d9ec943351
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:31.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BlYi5OUX/9+rYYbG9dS4/2X7TE6IWDSnogThPYuNZF+fN1Di3MjZymLSUR1hxU4X6S/JPIXn7haKI0vNsPwQvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
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
 drivers/net/dsa/ocelot/felix.c     |  18 ++++
 drivers/net/ethernet/mscc/ocelot.c | 128 ++++++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h          |  12 +++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4624d51a9b0a..e766ee14dc33 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -674,6 +674,22 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
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
@@ -1637,6 +1653,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
 	.port_fdb_del			= felix_fdb_del,
+	.lag_fdb_add			= felix_lag_fdb_add,
+	.lag_fdb_del			= felix_lag_fdb_del,
 	.port_mdb_add			= felix_mdb_add,
 	.port_mdb_del			= felix_mdb_del,
 	.port_pre_bridge_flags		= felix_pre_bridge_flags,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 455293aa6343..0243b9e7ff39 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1832,6 +1832,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	u32 mask = 0;
 	int port;
 
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -1845,6 +1847,19 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
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
@@ -2338,7 +2353,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = ocelot_bond_get_id(ocelot, bond);
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -2353,6 +2368,46 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
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
@@ -2377,14 +2432,23 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
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
@@ -2393,13 +2457,74 @@ void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
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
@@ -2694,6 +2819,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
 	INIT_LIST_HEAD(&ocelot->vlans);
+	INIT_LIST_HEAD(&ocelot->lag_fdbs);
 	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5c3a3597f1d2..8dfe1a827097 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -630,6 +630,13 @@ enum macaccess_entry_type {
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
 
@@ -683,6 +690,7 @@ struct ocelot {
 	u8				base_mac[ETH_ALEN];
 
 	struct list_head		vlans;
+	struct list_head		lag_fdbs;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
@@ -840,6 +848,10 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
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

