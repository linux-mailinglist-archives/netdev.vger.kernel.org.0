Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82D9487970
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348013AbiAGPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:53 -0500
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:43678
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347974AbiAGPBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSoxJfvMXWI91IFaMxCboeviIBkHQlFLRAy/LqsfrCpsOReX6R2e2B0U3VbBmanOXb9dLXYeCR6lJ7eqxnoqIG0Pzxaagk2M3YGE5zwzssBZURfrbROQm5RLCBpuuXh1/qfCS0gkL9fEEhQh4JpAxzI9IlvDJBOvftCLYVEV+dVW/WchzfSWCkIVSVTuh5GjoBjuv5yDS6puenep0XjG4YOsPbmDm6HlwZLIEEy1GTi331mDSgTHP0/ItnYHDAPq1S67+lbKxnDrYhM+GRiCcIvD5y/aZ5uoXXnqkOcmo0mBV1cJW1IMYb4KmyV0jJjUWu3xdcyH8CayqxMahpdzaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx8IC4NKG1VIrSr84Q18Tc9zlWMxDp/YuoPbfw4yi8c=;
 b=QlhvA8wVbPzRQemuiuHW0I41vM1Y5HTZHfDxIB0qYiFKe2FBRnKmJeAhtg7WANnXhjqLc07BsOANC+IrhZ7yKPuXX8auZKg+bEVMnwQWHO4ASUfqk6AeJ15hgj9qaJCB1RbO2bVtdoc9VV1UBDviWDhz0s8N1iN970ziuaZebwaR9JRyylvj760Nqg/F1JQLAvPVkkcbjxuzdspA42fbRTcjmkNV84vmsjlOto8ANVvRn8lWzTJHw8NBnX/JI17DjEhKRjE7g8YgjznDpTs8+jkS+qSnWsy04jPFmG8laUOlfsT1qvuux3vcdR64s50v17IdpIFLXdJbjcFjaDIwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx8IC4NKG1VIrSr84Q18Tc9zlWMxDp/YuoPbfw4yi8c=;
 b=N95Pn23VIMVvnvoqhjYrol74QIXmHFUQvNII0PFbyBrWrgWi9b0LNKASfKycPMtSUXS7atfDhLAseuf6241G5SNOc4tdX+6uR5feuEqwYQojfa8v/r0C9VM8sxmaQX+imkInveKKgR7wJ72JtWGgMFKcPgFHW3Llby0YbI0z4hg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 06/12] net: dsa: create a dsa_lag structure
Date:   Fri,  7 Jan 2022 17:00:50 +0200
Message-Id: <20220107150056.250437-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a375b2b1-5541-47a5-79a7-08d9d1ee8b66
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408336B8F0706808D1B4C81E04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJoZrSYfzxWcNrFA71dw7mPQjGAObOXqLF9d4oN+ZnmL6YfYdBr27hpJ2T1NQcUWUXr2OWxVe5Oq6AKsAYPc9A8vzgQgE/5dtzfEoBO7RNWDWmHRwyGbbAb//goGSmh0HyJRQpgL8NErISU5Ta3JrJ6iB1nLQw/2n+v/djf+6LndDGBzFld3UDq5DQe6vbseqexTl/SbNSCfeWu3H7946uMGY+bAUSiicWmUl+UvHytZAt0aij1EFmVT0Z4T+W7vxTIcHh4KUnQQDpv2XcS4BtKxPy8whKdcbqUERKlUm7X1OAIPRJSEisakrvf8i/4TuijQPSstKQSwU3CjMEY/H2K/jL9IjuCQ3JKU9xbRwWu2x2YwswYyAxoTFWy0fbUGVkLOqOR/bzDLOWSaqBLgq73BUVQJs/LRT4WWP5er9rGPZAJzOsJCBvTLsZXJ5VsWHulaxzRdObi91VPesPbV0CZ9nsOlvZgGmBJIgubEYd28sHitpOzWxsW5NZLMVrPfojxE3/uhG7sFEdXzAsmqgZjTLTsJ6eGh9eYnluOBgKC52vJ64c/wz03MyIxRlplzVGXtNGFklr9XP2hnXH4WAru54Hyh6dtTg4E3Ztk/ozhQfR39uM+oYfMj4F0DnD4FOKtB3BMYclOhjW+5nsyGnSS4gMKfDdO5vPBTexj7ZWR1OqJbamFPgJKWHkJklhhKB7A6sBtAB5vlcliIinN38Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(30864003)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vfvSOrMV0znKg7Z4wcTEblOFn1bfqq84VLrih+zRUPDicV8tg1TMhqr9taWN?=
 =?us-ascii?Q?4UdQ8uHBCCdOsR85lJ59cAStvg7453rhWxx0Z3JXLoHBYShbiPy5WIUAAQGi?=
 =?us-ascii?Q?vC0GvCbQfXpknmhr08f7yf/4q2MQGcI8uehIvebKTxVNyUOkmVtYmPr1R2Iz?=
 =?us-ascii?Q?cedfDhpfuvxEeKi3DUUkAxX5UeX4m8YBlkZuEMuv5B74MX1NRnyNI6BiLObd?=
 =?us-ascii?Q?PhXK5N3/CNHZXi1uaPVJWawmw1j+N19Jdomiql9fONeKU29Boofex5iqS+y/?=
 =?us-ascii?Q?jdN8/ic5RVL8z57ek7ujRad8GjsSJaRtMjMx8cEKmy8BpEGIYMDabSYM5MPb?=
 =?us-ascii?Q?gsn24mF9PTA8AoW/MzyOioLnB/i0Ek/geE7LNF9BL/zqbCRx1JfI9U2y2CAD?=
 =?us-ascii?Q?lGgXrwEeQlq8m8sopCuX5qs84phFAKRaz+xvLPLIXdvggCQiOdWTznQYPqmL?=
 =?us-ascii?Q?I6bgDnUTJUfVhUyrrBNfuHpMn1wckpxONpHrQh6+q4flOdTjB2F99qghNdcE?=
 =?us-ascii?Q?uTB5owbi6uTgaAVNUKyb9w4hN25CXe4tfoszTzDAqNfc/xHoJo+nyZOJcgyX?=
 =?us-ascii?Q?psA3TBoiYbhfZaeDb0wl1s1gERlO/b/bR9M25y3S5bthNVoKjN6Cm5030MOQ?=
 =?us-ascii?Q?Z47P75VHQX0yki+iDTWpNiltPc5cocSWa0gvmCYgPDWtvmn/lh29tdbiCnaX?=
 =?us-ascii?Q?K3a/OkaGkN7OtvYjs25eeY+/O4yx2tSUQF2Cr8nmHn+EdqM8r51gPSMG3g1O?=
 =?us-ascii?Q?UlV2BflSQ3nBVUCBKqDd0NFoTsgvqR0iD3XWDH7ngTZY4XLfynk+DnHQ2Aqx?=
 =?us-ascii?Q?ENYFMib9ufxWRTAvcXC3Y7izZELThvlDosb8hh6lGXPxC3gV+7wZh96whS14?=
 =?us-ascii?Q?2IVgSiESdXo/QBYj7pORFjoNjxdF5OGZmaIGMOs2TzPg+ADyyO68Rb3uRV4m?=
 =?us-ascii?Q?wIJnzn7TGZ2XpdESBqY/63wr9PFsVB9TXm15vbZth0pErLDlxKGB0qYZHJwP?=
 =?us-ascii?Q?L0EDv7+7+ndDMl/Ef0Dco2ETf+Bgxonep4j7jUYN8/SstNM/yiXc2Uva5in/?=
 =?us-ascii?Q?o5xR+uBye7LE/ke24KSZIrKqd/5ne8VBoqd85IgFhE68wgyVX/z7kLmRgAjV?=
 =?us-ascii?Q?THmFLiCJr7KgF9mZmQH0sk76GMWzPgUWRpjFpQprAjEIqtaZmKERZnFidB/P?=
 =?us-ascii?Q?7/nzkF7cZkZGkrkzymmj4NGHc/Z1xF/FmSGpSEGiTvV4QbxiOHqwi/ku1bMn?=
 =?us-ascii?Q?R5bBOLiwLSqTKI7F54URtEmHv8FsbKM9BLOsJHCk5r8xTg3i8lYcFy8oiQP/?=
 =?us-ascii?Q?XOY7crYyvmaf6AYRZPtb+gtXBrXx5X4v3Wit6/k9tDKG12Z7EMOnHG51qNC6?=
 =?us-ascii?Q?4G1ir56zTKU40YR/dHXXYOILUlxqFwVPHjvOaJiy629FkUbp2Negkkr8ZXyS?=
 =?us-ascii?Q?bH33A7y6XZscqjijSrmuiulbQKasW2etMCHaiYy3ELrPPv3Wt1KsfKAS/CTw?=
 =?us-ascii?Q?lm5qvSmdUzBS/EjUVOo++2lxE3PgoOjDXyJfwhy2wr6Mpehxa9DM4KrJnNXV?=
 =?us-ascii?Q?MO84rXDwD+2ZwkIe8PCmb2FGTDWMuv7+ej/qwCJLXxk6j6x/KOvrBbP418eT?=
 =?us-ascii?Q?rLeHNhrfXqxYdSL8ZBMigCs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a375b2b1-5541-47a5-79a7-08d9d1ee8b66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:12.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IO9c49U6sEeMYJLJc4cPcAcfmHYzwbqlU9qda3p6ZulfNJ0XO3gqRtEDsqjD++WxUpnHVBF/21crL1H0BCXBGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this change is to create a data structure for a LAG
as seen by DSA. This is similar to what we have for bridging - we pass a
copy of this structure by value to ->port_lag_join and ->port_lag_leave.
For now we keep the lag_dev, id and a reference count in it. Future
patches will add a list of FDB entries for the LAG (these also need to
be refcounted to work properly).

The LAG structure is created using dsa_port_lag_create() and destroyed
using dsa_port_lag_destroy(), just like we have for bridging.

Because now, the dsa_lag itself is refcounted, we can simplify
dsa_lag_map() and dsa_lag_unmap(). These functions need to keep a LAG in
the dst->lags array only as long as at least one port uses it. The
refcounting logic inside those functions can be removed now - they are
called only when we should perform the operation.

dsa_lag_dev() is renamed to dsa_lag_by_id() and now returns the dsa_lag
structure instead of the lag_dev net_device.

dsa_lag_foreach_port() now takes the dsa_lag structure as argument.

dst->lags holds an array of dsa_lag structures.

dsa_lag_map() now also saves the dsa_lag->id value, so that linear
walking of dst->lags in drivers using dsa_lag_id() is no longer
necessary. They can just look at lag.id.

dsa_port_lag_id_get() is a helper, similar to dsa_port_bridge_num_get(),
which can be used by drivers to get the LAG ID assigned by DSA to a
given port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 60 +++++++++++++++----------------
 drivers/net/dsa/ocelot/felix.c   |  8 ++---
 drivers/net/dsa/qca8k.c          | 39 +++++++++-----------
 include/net/dsa.h                | 50 +++++++++++++++++++-------
 net/dsa/dsa2.c                   | 41 +++++++++++----------
 net/dsa/dsa_priv.h               |  8 +++--
 net/dsa/port.c                   | 61 +++++++++++++++++++++++++-------
 net/dsa/slave.c                  |  4 +--
 net/dsa/switch.c                 |  8 ++---
 net/dsa/tag_dsa.c                |  4 ++-
 10 files changed, 173 insertions(+), 110 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8d248842feb0..fc5d1586b0af 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1476,7 +1476,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 
 		ds = dsa_switch_find(dst->index, dev);
 		dp = ds ? dsa_to_port(ds, port) : NULL;
-		if (dp && dp->lag_dev) {
+		if (dp && dp->lag) {
 			/* As the PVT is used to limit flooding of
 			 * FORWARD frames, which use the LAG ID as the
 			 * source port, we must translate dev/port to
@@ -1485,7 +1485,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 			 * (zero-based).
 			 */
 			dev = MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK;
-			port = dsa_lag_id(dst, dp->lag_dev) - 1;
+			port = dsa_port_lag_id_get(dp) - 1;
 		}
 	}
 
@@ -1523,7 +1523,7 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (dsa_to_port(ds, port)->lag_dev)
+	if (dsa_to_port(ds, port)->lag)
 		/* Hardware is incapable of fast-aging a LAG through a
 		 * regular ATU move operation. Until we have something
 		 * more fancy in place this is a no-op.
@@ -5947,21 +5947,20 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag_dev,
+				      struct dsa_lag lag,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
-	int id, members = 0;
+	int members = 0;
 
 	if (!mv88e6xxx_has_lag(chip))
 		return false;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id <= 0 || id > ds->num_lag_ids)
+	if (!lag.id)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -5981,8 +5980,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
-				  struct net_device *lag_dev)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
@@ -5990,13 +5988,13 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
 	int id;
 
 	/* DSA LAG IDs are one-based, hardware is zero-based */
-	id = dsa_lag_id(ds->dst, lag_dev) - 1;
+	id = lag.id - 1;
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
 	 * port if the LAG port is on a remote chip.
 	 */
-	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
 		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
 
 	return mv88e6xxx_g2_trunk_mapping_write(chip, id, map);
@@ -6040,9 +6038,9 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	struct net_device *lag_dev;
 	unsigned int id, num_tx;
 	struct dsa_port *dp;
+	struct dsa_lag *lag;
 	int i, err, nth;
 	u16 mask[8];
 	u16 ivec;
@@ -6052,7 +6050,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
 	dsa_switch_for_each_port(dp, ds) {
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			continue;
 
 		ivec &= ~BIT(dp->index);
@@ -6065,12 +6063,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	 * are in the Tx set.
 	 */
 	dsa_lags_foreach_id(id, ds->dst) {
-		lag_dev = dsa_lag_dev(ds->dst, id);
-		if (!lag_dev)
+		lag = dsa_lag_by_id(ds->dst, id);
+		if (!lag)
 			continue;
 
 		num_tx = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
 			if (dp->lag_tx_enabled)
 				num_tx++;
 		}
@@ -6079,7 +6077,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6101,14 +6099,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 }
 
 static int mv88e6xxx_lag_sync_masks_map(struct dsa_switch *ds,
-					struct net_device *lag_dev)
+					struct dsa_lag lag)
 {
 	int err;
 
 	err = mv88e6xxx_lag_sync_masks(ds);
 
 	if (!err)
-		err = mv88e6xxx_lag_sync_map(ds, lag_dev);
+		err = mv88e6xxx_lag_sync_map(ds, lag);
 
 	return err;
 }
@@ -6125,17 +6123,17 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
-				   struct net_device *lag_dev,
+				   struct dsa_lag lag,
 				   struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err, id;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
 		return -EOPNOTSUPP;
 
 	/* DSA LAG IDs are one-based */
-	id = dsa_lag_id(ds->dst, lag_dev) - 1;
+	id = lag.id - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -6143,7 +6141,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6158,13 +6156,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
-				    struct net_device *lag_dev)
+				    struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_trunk;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	err_trunk = mv88e6xxx_port_set_trunk(chip, port, false, 0);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_trunk;
@@ -6183,18 +6181,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
-					int port, struct net_device *lag_dev,
+					int port, struct dsa_lag lag,
 					struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	if (err)
 		goto unlock;
 
@@ -6206,13 +6204,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
-					 int port, struct net_device *lag_dev)
+					 int port, struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_pvt;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	err_pvt = mv88e6xxx_pvt_map(chip, sw_index, port);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_pvt;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9957772201d5..4624d51a9b0a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -737,20 +737,20 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 }
 
 static int felix_lag_join(struct dsa_switch *ds, int port,
-			  struct net_device *bond,
+			  struct dsa_lag lag,
 			  struct netdev_lag_upper_info *info)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_lag_join(ocelot, port, bond, info);
+	return ocelot_port_lag_join(ocelot, port, lag.dev, info);
 }
 
 static int felix_lag_leave(struct dsa_switch *ds, int port,
-			   struct net_device *bond)
+			   struct dsa_lag lag)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_lag_leave(ocelot, port, bond);
+	ocelot_port_lag_leave(ocelot, port, lag.dev);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5befe3382d73..5e818df6ea5b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2212,18 +2212,16 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 }
 
 static bool
-qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag_dev,
+qca8k_lag_can_offload(struct dsa_switch *ds, struct dsa_lag lag,
 		      struct netdev_lag_upper_info *info)
 {
 	struct dsa_port *dp;
-	int id, members = 0;
+	int members = 0;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id <= 0 || id > ds->num_lag_ids)
+	if (!lag.id)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -2241,16 +2239,14 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 }
 
 static int
-qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag_dev,
+qca8k_lag_setup_hash(struct dsa_switch *ds, struct dsa_lag lag,
 		     struct netdev_lag_upper_info *info)
 {
+	struct net_device *lag_dev = lag.dev;
 	struct qca8k_priv *priv = ds->priv;
 	bool unique_lag = true;
+	unsigned int i;
 	u32 hash = 0;
-	int i, id;
-
-	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2267,7 +2263,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 	/* Check if we are the unique configured LAG */
 	dsa_lags_foreach_id(i, ds->dst)
-		if (i != id && dsa_lag_dev(ds->dst, i)) {
+		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
 			unique_lag = false;
 			break;
 		}
@@ -2282,7 +2278,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	if (unique_lag) {
 		priv->lag_hash_mode = hash;
 	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2292,14 +2288,14 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 static int
 qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag_dev, bool delete)
+			  struct dsa_lag lag, bool delete)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret, id, i;
 	u32 val;
 
 	/* DSA LAG IDs are one-based, hardware is zero-based */
-	id = dsa_lag_id(ds->dst, lag_dev) - 1;
+	id = lag.id - 1;
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
@@ -2361,27 +2357,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 }
 
 static int
-qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag_dev,
+qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
 		    struct netdev_lag_upper_info *info)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag_dev, info))
+	if (!qca8k_lag_can_offload(ds, lag, info))
 		return -EOPNOTSUPP;
 
-	ret = qca8k_lag_setup_hash(ds, lag_dev, info);
+	ret = qca8k_lag_setup_hash(ds, lag, info);
 	if (ret)
 		return ret;
 
-	return qca8k_lag_refresh_portmap(ds, port, lag_dev, false);
+	return qca8k_lag_refresh_portmap(ds, port, lag, false);
 }
 
 static int
 qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag_dev)
+		     struct dsa_lag lag)
 {
-	return qca8k_lag_refresh_portmap(ds, port, lag_dev, true);
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
 
 static const struct dsa_switch_ops qca8k_switch_ops = {
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 28d657d3d807..9ddcdbf8e41c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -116,6 +116,12 @@ struct dsa_netdevice_ops {
 #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
 
+struct dsa_lag {
+	struct net_device *dev;
+	unsigned int id;
+	refcount_t refcount;
+};
+
 struct dsa_switch_tree {
 	struct list_head	list;
 
@@ -134,7 +140,7 @@ struct dsa_switch_tree {
 	/* Maps offloaded LAG netdevs to a zero-based linear ID for
 	 * drivers that need it.
 	 */
-	struct net_device **lags;
+	struct dsa_lag **lags;
 
 	/* Tagging protocol operations */
 	const struct dsa_device_ops *tag_ops;
@@ -170,14 +176,14 @@ struct dsa_switch_tree {
 
 #define dsa_lag_foreach_port(_dp, _dst, _lag)			\
 	list_for_each_entry((_dp), &(_dst)->ports, list)	\
-		if ((_dp)->lag_dev == (_lag))
+		if (dsa_port_offloads_lag((_dp), (_lag)))
 
 #define dsa_hsr_foreach_port(_dp, _ds, _hsr)			\
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list)	\
 		if ((_dp)->ds == (_ds) && (_dp)->hsr_dev == (_hsr))
 
-static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
-					     unsigned int id)
+static inline struct dsa_lag *dsa_lag_by_id(struct dsa_switch_tree *dst,
+					    unsigned int id)
 {
 	/* DSA LAG IDs are one-based, dst->lags is zero-based */
 	return dst->lags[id - 1];
@@ -189,8 +195,10 @@ static inline int dsa_lag_id(struct dsa_switch_tree *dst,
 	unsigned int id;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag_dev)
-			return id;
+		struct dsa_lag *lag = dsa_lag_by_id(dst, id);
+
+		if (lag->dev == lag_dev)
+			return lag->id;
 	}
 
 	return -ENODEV;
@@ -289,7 +297,7 @@ struct dsa_port {
 	struct devlink_port	devlink_port;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
-	struct net_device	*lag_dev;
+	struct dsa_lag		*lag;
 	struct net_device	*hsr_dev;
 
 	struct list_head list;
@@ -616,8 +624,8 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 	if (!dp->bridge)
 		return NULL;
 
-	if (dp->lag_dev)
-		return dp->lag_dev;
+	if (dp->lag)
+		return dp->lag->dev;
 	else if (dp->hsr_dev)
 		return dp->hsr_dev;
 
@@ -694,6 +702,22 @@ dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
 	return false;
 }
 
+static inline unsigned int dsa_port_lag_id_get(struct dsa_port *dp)
+{
+	return dp->lag ? dp->lag->id : 0;
+}
+
+static inline struct net_device *dsa_port_lag_dev_get(struct dsa_port *dp)
+{
+	return dp->lag ? dp->lag->dev : NULL;
+}
+
+static inline bool dsa_port_offloads_lag(struct dsa_port *dp,
+					 const struct dsa_lag *lag)
+{
+	return dsa_port_lag_dev_get(dp) == lag->dev;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
@@ -932,10 +956,10 @@ struct dsa_switch_ops {
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
-				      int port, struct net_device *lag_dev,
+				      int port, struct dsa_lag lag,
 				      struct netdev_lag_upper_info *info);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
-				       int port, struct net_device *lag_dev);
+				       int port, struct dsa_lag lag);
 
 	/*
 	 * PTP functionality
@@ -1007,10 +1031,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
-				 struct net_device *lag_dev,
+				 struct dsa_lag lag,
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
-				  struct net_device *lag_dev);
+				  struct dsa_lag lag);
 
 	/*
 	 * HSR integration
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c1e40ff559e3..8ae449fd0985 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -71,27 +71,24 @@ int dsa_broadcast(unsigned long e, void *v)
 }
 
 /**
- * dsa_lag_map() - Map LAG netdev to a linear LAG ID
+ * dsa_lag_map() - Map LAG structure to a linear LAG array
  * @dst: Tree in which to record the mapping.
- * @lag_dev: Netdev that is to be mapped to an ID.
+ * @lag: LAG structure that is to be mapped to the tree's array.
  *
- * dsa_lag_id/dsa_lag_dev can then be used to translate between the
+ * dsa_lag_id/dsa_lag_by_id can then be used to translate between the
  * two spaces. The size of the mapping space is determined by the
  * driver by setting ds->num_lag_ids. It is perfectly legal to leave
  * it unset if it is not needed, in which case these functions become
  * no-ops.
  */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
+void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag_dev) > 0)
-		/* Already mapped */
-		return;
-
 	for (id = 1; id <= dst->lags_len; id++) {
-		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id - 1] = lag_dev;
+		if (!dsa_lag_by_id(dst, id)) {
+			dst->lags[id - 1] = lag;
+			lag->id = id;
 			return;
 		}
 	}
@@ -107,28 +104,36 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 /**
  * dsa_lag_unmap() - Remove a LAG ID mapping
  * @dst: Tree in which the mapping is recorded.
- * @lag_dev: Netdev that was mapped.
+ * @lag: LAG structure that was mapped.
  *
  * As there may be multiple users of the mapping, it is only removed
  * if there are no other references to it.
  */
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag)
 {
-	struct dsa_port *dp;
 	unsigned int id;
 
-	dsa_lag_foreach_port(dp, dst, lag_dev)
-		/* There are remaining users of this mapping */
-		return;
-
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag_dev) {
+		if (dsa_lag_by_id(dst, id) == lag) {
 			dst->lags[id - 1] = NULL;
+			lag->id = 0;
 			break;
 		}
 	}
 }
 
+struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
+				  const struct net_device *lag_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_lag_dev_get(dp) == lag_dev)
+			return dp->lag;
+
+	return NULL;
+}
+
 struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
 					const struct net_device *br)
 {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9a5cca9a42ce..be1b4c7cfbdc 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -73,7 +73,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag_dev;
+	struct dsa_lag lag;
 	int sw_index;
 	int port;
 
@@ -474,8 +474,10 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
+struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
+				  const struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bb42ac7ed53f..e3e5f6de11c8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -422,7 +422,7 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	};
 	bool tx_enabled;
 
-	if (!dp->lag_dev)
+	if (!dp->lag)
 		return 0;
 
 	/* On statically configured aggregates (e.g. loadbalance
@@ -440,6 +440,45 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
 }
 
+static int dsa_port_lag_create(struct dsa_port *dp,
+			       struct net_device *lag_dev)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_lag *lag;
+
+	lag = dsa_tree_lag_find(ds->dst, lag_dev);
+	if (lag) {
+		refcount_inc(&lag->refcount);
+		dp->lag = lag;
+		return 0;
+	}
+
+	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
+	if (!lag)
+		return -ENOMEM;
+
+	refcount_set(&lag->refcount, 1);
+	lag->dev = lag_dev;
+	dsa_lag_map(ds->dst, lag);
+	dp->lag = lag;
+
+	return 0;
+}
+
+static void dsa_port_lag_destroy(struct dsa_port *dp)
+{
+	struct dsa_lag *lag = dp->lag;
+
+	dp->lag = NULL;
+	dp->lag_tx_enabled = false;
+
+	if (!refcount_dec_and_test(&lag->refcount))
+		return;
+
+	dsa_lag_unmap(dp->ds->dst, lag);
+	kfree(lag);
+}
+
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack)
@@ -447,15 +486,16 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag_dev = lag_dev,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
 	int err;
 
-	dsa_lag_map(dp->ds->dst, lag_dev);
-	dp->lag_dev = lag_dev;
+	err = dsa_port_lag_create(dp, lag_dev);
+	if (err)
+		goto err_lag_create;
 
+	info.lag = *dp->lag;
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
 	if (err)
 		goto err_lag_join;
@@ -473,8 +513,8 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 err_bridge_join:
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
-	dp->lag_dev = NULL;
-	dsa_lag_unmap(dp->ds->dst, lag_dev);
+	dsa_port_lag_destroy(dp);
+err_lag_create:
 	return err;
 }
 
@@ -492,11 +532,11 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag_dev = lag_dev,
+		.lag = *dp->lag,
 	};
 	int err;
 
-	if (!dp->lag_dev)
+	if (!dp->lag)
 		return;
 
 	/* Port might have been part of a LAG that in turn was
@@ -505,16 +545,13 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 	if (br)
 		dsa_port_bridge_leave(dp, br);
 
-	dp->lag_tx_enabled = false;
-	dp->lag_dev = NULL;
+	dsa_port_lag_destroy(dp);
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 	if (err)
 		dev_err(dp->ds->dev,
 			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
-
-	dsa_lag_unmap(dp->ds->dst, lag_dev);
 }
 
 /* Must be called under rcu_read_lock() */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 22241afcac81..1d8fe70e0ce3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2172,7 +2172,7 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 			continue;
 
 		dp = dsa_slave_to_port(lower);
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			/* Software LAG */
 			continue;
 
@@ -2201,7 +2201,7 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 			continue;
 
 		dp = dsa_slave_to_port(lower);
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			/* Software LAG */
 			continue;
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 51d7045a573e..e3c7d2627a61 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -454,12 +454,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag_dev,
+		return ds->ops->port_lag_join(ds, info->port, info->lag,
 					      info->info);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag_dev,
+						   info->port, info->lag,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -469,11 +469,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag_dev);
+		return ds->ops->port_lag_leave(ds, info->port, info->lag);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag_dev);
+						    info->port, info->lag);
 
 	return -EOPNOTSUPP;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 26435bc4a098..c8b4bbd46191 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -246,12 +246,14 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 
 	if (trunk) {
 		struct dsa_port *cpu_dp = dev->dsa_ptr;
+		struct dsa_lag *lag;
 
 		/* The exact source port is not available in the tag,
 		 * so we inject the frame directly on the upper
 		 * team/bond.
 		 */
-		skb->dev = dsa_lag_dev(cpu_dp->dst, source_port + 1);
+		lag = dsa_lag_by_id(cpu_dp->dst, source_port + 1);
+		skb->dev = lag ? lag->dev : NULL;
 	} else {
 		skb->dev = dsa_master_find_slave(dev, source_device,
 						 source_port);
-- 
2.25.1

