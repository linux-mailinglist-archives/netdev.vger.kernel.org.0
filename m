Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE3B4BEA2D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiBUSFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiBUSDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:13 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5D265B8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCB1jCcrEXyKHN5R04tfEPwPlpwB3u4vhhGhM/DZxTJ6E/6mR58fG8ZlR6Ya/C0DU6hgYbGMs7WkUBJzhurqFcto8lAtIA1Q/OH5efOKUv4aLDez5FMdNaNS6z0kwRzpwt0zGVABO2ESJHUEs0ocdi6eu7uUBxT6i+l/wQWaq+i/pa/mEWzXpgZoeunHm7c3qj7+GEV05IOK6TyKHbED322St92yagG17OUqLhWYGjPsvb+NgdrFN+AvBu1ICsVlKbdHsBkacc4Q2JgJnSmNYrP9uFww1PZDWJW8rrYzh8h3zFxwf9liZ0CKDvYfgXmfVL3khR18DJGF8nJ86kubOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2eIwyLNvGLjTXBR8FXx1V+UFiTpzwh664Z4f7jbKYg=;
 b=FkVt44VRqk2gg4keH5BNw6agccZukxJWlGP8bLKAHfGoUSY7x5nGgMlwMoPim/8gUGLprxKt6ebs73AAkyHfgEBgiiDdsvLCzrJAojpkhXTeSkC6Qt7e23aMu6zYYK37HpyPMby9ObPbQ05MODKkfi+YBZ8kXHF7ehznHqtJjwFNvlGr49p6SS41/o5RvqkFu8wmbsyOlFISwn7EBhUo3YZboqM2j6WDN77DOCPODt02g8YVLtrgcAtm3idEVKObnEElBDZWxrUsL95eTX5jEiKqUg9KN9jYy7NYtardS9Ije0PMwP6ncjCO1ZxOFn6ZlAGKqb6AnoGf4YqTlFAifA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2eIwyLNvGLjTXBR8FXx1V+UFiTpzwh664Z4f7jbKYg=;
 b=jKRBF/fk0XyWqwIqmIN+51N21YgxdMjO8sKEbPMcyNVTCwwRa9ZJ9C7BV9ktgTbRuARx4gc0oQ71kL8e3YP4q+/NdLDHi2MRjrg9WdKVTFTPVz69P3K0GhDjoGo/fVdM56IvoupcpNzv1nj1rzOqT60+SoHiUvQLONxOopQskTY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:16 +0000
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
Subject: [PATCH v3 net-next 11/11] net: dsa: felix: support FDB entries on offloaded LAG interfaces
Date:   Mon, 21 Feb 2022 19:53:56 +0200
Message-Id: <20220221175356.1688982-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1787a3da-5874-4a5d-c7a0-08d9f5632d41
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3693A6820FA4707EB2CB697BE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8hue0Y0LKGf8UWFVA1wXI7UT7dujAwYIkQyse5VHFaX1JMN3MpOiYvepElago1q1LEOgnhETv0mJNOBZpPB0XslxX9bFU2jc9EqFptJhP1uaQIvQEfE/Y15yRHY5Rlh9ocJsgv8aDtORiCSgfqGpYWg4lEwSJ+TQFm9QKZ5xrcfHj34xNR/6cXJoVaeW2gaAuRf1t309/VUj68o1BD9+1xw8mikyFSVw8WAc6i4a700h8BI/H729dl7/6L1vrLBt2f+lqXAQtEB5R8hWu2ssrIns+3nNQA5MUBNiXG1Yl51daRRTcTiJ8/WhzuR4KnmO7UNUvh7a3lWfBd/OQMlzQhx5IUy86W15KHF46LO2na5z2VDnAtwz6zlJd3K3DgyE9Q1fS7Duq85ScAEY0FQFzOeL/4vkGDI1BPgNajq5fYuziP33L+i5gqRHkTowc6OXF3nwOiJZQBwA58CpXXXrLydXfmLO3nv5GCul0DktSaHBxnWdkbYB2JGL4wDmoLLcYSoAupQspXbleOlgNr/EP6QKVMUPhdFxsgnkttj4wuDH61AdXq49v8NTwVZBQfvbfKdIHrLUIFyIRjwiMTNacs2QNgXtLl2iD15pGUs3qoZXtp2LmME22Gj/fKZNAKq530cqENSVQXMddkTRmslxXIc+GoNh4Gw8hrJawz0L5Rg1UnvOr+JsxaJ87XsRecM5sOg8CZRjGXhIJ+rA8SMlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Tn2+dFryCXCSDgEHyHVDRu21WT0nRsW6aoom1t0vzz2DwoqOSsgU+2hPGBt?=
 =?us-ascii?Q?LlbzrqN2Sv4N5WylwFF5rRsbZC7WbpOKAof85jyifwzqcOMORwv7gLFgxHms?=
 =?us-ascii?Q?aXTTyIAdxrlmnz7reyOfZtKVTn6BCJEnSQ1joFO1oQ07Qng/rWKy/N+Izvnb?=
 =?us-ascii?Q?7uf2GIqm1/jOgUThh1Lr7S2yhyLJ/aINZvAB+foWkByiF+uA9mEgzW0DmhcU?=
 =?us-ascii?Q?zVnL0hWdgynJyQi1gRHCtPZJuiPYkRAjdUhbjvXLyR+ZrPj18MR3A1qXwP27?=
 =?us-ascii?Q?AQxUkhtOyfBu1RjO6DbMoRQksi6lyrkp5PPDsKW5tikdmK5q265zhFSvou3y?=
 =?us-ascii?Q?6p51iXtk9J+MvTWkKgcVKfDATAClMnpJh8yfhMHFvQYQy4W054jaBTpqx2mJ?=
 =?us-ascii?Q?0pOuxzuheuL0kaVIJSwiA/4yQZjtFSgSrO4iXNIIdOV/7fBpWNbM2PybThFm?=
 =?us-ascii?Q?dREyXMrOIy9PDIfER0Zq00l8Yx1Vuk3pA1oRb6ev7brlbWTVcg1svGnplsMA?=
 =?us-ascii?Q?Yh4yhAbZ/17fQFqtKIIJLf1p8HJwy1OuclEukSbXfOXuhMDiDRbyqxaGopN9?=
 =?us-ascii?Q?8e5CwvcxLrgPfF2r+Fwox2yupjoy5rs3lmI2xKZUwW5/6lVPcpY6W2dUhYwI?=
 =?us-ascii?Q?cncvHX/rzX32W+eldNclvc5TSRQYslMi38If8KxDon6EwI0KsSvxPRocBBH8?=
 =?us-ascii?Q?V65VGyaXpKvTVTQZDlcn6xNDyxvp5x7loMqdeCFVJ2upv+jbRxMcl1hYzW8x?=
 =?us-ascii?Q?/epAKBhrNi9Kfek0z6jBKafZCXl7Vwh/AZGlc01hcXWReWRWUtpagHcZJKkE?=
 =?us-ascii?Q?PhaPsYYJElSgha9IZBf/poSaUj0U7Cb2JDzXYlG3xv4+9qs6UogaSGnYEgvz?=
 =?us-ascii?Q?+CxoBmztPPjJP9sfUj8M07+28SHzxaPLuAqBnqJ7ZzVG1d03Xn9SYeVbNDne?=
 =?us-ascii?Q?RGX98pAlu86D4tq73WKc0AWqAKMrt0mYOYad1Ows5ZEz/yHx05t6vsIfbdDM?=
 =?us-ascii?Q?loGfvVk1MwYj278ekNnB4lAbgvvMwKASL+0oMNNIdMfe1ywfLTloF1CXwmw/?=
 =?us-ascii?Q?c3R2eJE0l1Pq3krDoymXM/L6jBjKj+8fTYfF0dMmb/clLeCK7qGVDcZmX1Wd?=
 =?us-ascii?Q?mIOphahlsabYkjloI8rkk9m/alhhM6y6gITWbgxggAnRGDKxKyPb5koJWloI?=
 =?us-ascii?Q?5R/AIsfp2n+C9ZnXzcI57oXZNyGWvxnztk9Q5WFv1iuNomGucZ4FcBdgFinw?=
 =?us-ascii?Q?Vm3hYIAGJDcnsMyfDPfW4JsOvfNCt6P82bhjxkTs4H8fmjujdxGWYKsIVKc/?=
 =?us-ascii?Q?hzv8YINZ8hhkVRgFCAZJxpru8z7qNRzwcNPQuz4uwypeOuj0Nvymwst1XOEe?=
 =?us-ascii?Q?hGdodJhMCnFVbUBqUXXAlubjrzerhL1UjCh0dNvrQBxoHCcjdMJfifvleeyX?=
 =?us-ascii?Q?lgSMD2OjfP7Up2JAzssUSz+ycneSvqZgjL0BmiISIC70Fj8AHJpKvoc8Pt1+?=
 =?us-ascii?Q?waGjc+0l5BQeBOfjeNXX6wTStVXffpejTcr49wu45jLHkdgy4O2XpE/k3CO8?=
 =?us-ascii?Q?KSnc1Svlsiy875WDckp1+l50KMVutLnvVP6nNpoxG6NZX4te16f4uQwxBpN2?=
 =?us-ascii?Q?/vWeUmu/Hp5rGyyAdH34Q8I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1787a3da-5874-4a5d-c7a0-08d9f5632d41
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:16.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /noEUuJ9u4obbjC6KbMh6ZUa9vdXJtsC6HmUn4NmbLn45MrLlzUkydIJrQlYEwsZRrDW8hmp2FT+D2sq6Aefmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
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
v1->v3: none

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

