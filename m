Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0A4BEA20
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiBUSEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:04:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiBUSDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:02 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CBE15A3B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRwGFSbbItrmlHFkhSCarIbsunYlOkAzYu1IYLpVM8P2l71KXms6m5fsO3ZidrK8uxm3Tqq/Ddxp1vsNWmndzrsWWvHQjGjMOBhcTGAdQRkZ13O1ZMZY+QxPREdgttYOjFYjwU4rFHquyPJf5QPAl7VisU8JukLhcw+9D4WMwmSVcIiCIoLH9yx7HiwDxS5TeK9qdcGv4HLl8/oQM1pJFs3o6qjyKmJKsCTJGYzC8ZZpWC2voTNeo1W7N+bxrFTygGcFO9+ZhAwOZv7WbQdDjoKffqV5mL/xFw2gthY+KCJ1Vs3e/1/4oTd4X27FsRLzRSq0VUeA0z+9j5IO2wVLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qSTr2BImFZ0R7PprHWVSWxmMfraPoWbZ74Rh9ttSYE=;
 b=mqQNCX6xXlFtzVuU4Ti4hklr7LKllrBESAig33d1Pt1ZJ4QQbK8WHJAlvgrZDv3ZoVw5sDt4tOyBwIr71m6Oju2u4WSkTGW4VUw8Jb178ryYt8h30367lMvqhBjowWUZ2U5G1frJY7DNvpaHh7iiMX0jEUHje72bxooPm9IXVDh5uw/FEH/j8OqVe+jGqVHgp7Lowlygw59LK5rVkMaPlXWeyYr9VU7IlVzU4aFEld44+duMrrivvbvzuo/kdBXmUs8uFRTwZU/BT6YYk0cs/moYOyvrGs/woHWzQLhrxaE6afCDx5kZBKelYJWwvt+z9g9qetALoiTXy6GXs+FduA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qSTr2BImFZ0R7PprHWVSWxmMfraPoWbZ74Rh9ttSYE=;
 b=KgykWoL3D+qaE18Na8lNORUluAuY0/rhqlKfxgEsGK1v2B9jQHbbj/tDTBHh6LaTKyimY2kSmAgkLXAoUh0Gwoj/RlEpr3xzm6KwZthvGGwACoTVL/zDmV8xn1C4RJLJV6q0RSLs259lGf8OxQPk3aWRFELnxUMxHsLfLMMl36g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:12 +0000
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
Subject: [PATCH v3 net-next 06/11] net: dsa: create a dsa_lag structure
Date:   Mon, 21 Feb 2022 19:53:51 +0200
Message-Id: <20220221175356.1688982-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 855663a6-456e-4d27-db18-08d9f5632ae1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB369369AB81D63D66413E66FEE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jlV9RXilCe5HAyI1M2iOo7mft6q529qvZ2OvpDX61L1mAGnKYJPf/XjXRlDnyMd2hDqFaZelHKzNVAzj5VzkhqIanYGlTdZVFPAFyIVKCJXmiEVpJc1o0ayOHzYyByCxK/nm5vGNFyOUf8fCCOAbSPxmVGbIfwnff95UPvekzYzPjfWSxZAwhSkRW+l6lwzuYKmO2COkyFaZTIscurW69+sPZ6Y3++z3BfW+WN6uSw8mb2HqrIPWqd1dzpOU1q3MHd66GY30IZFHBmobXQfDCqf55QB5q4uC+Srb1wycNONhVeBY3srMbawlyio4LVNhw1TH7OWNEH8PP+4J8wsUjA0TjCnY/iovzYGwtmaF4xIEmfreSq1tRxugsBV291AwJNVfzE2WaMXPtN8Fq4AAhgvaoiK4WqMLLh0uahfdpneLaTKeLOxqEvnwiyYLCx13/FWd8YBTpBcnop+FCRm7HA9Mwg55NEDi1V8N0olJ9WzHnF2AdB2Lr+5E0wcBMoAbFOnzwNTPrgHGT8IyigPNNoF9S+k6qsdDUGlPWIFQvNlssPtgSnqn4Ml2iJ44vuDjAYMPijodVyQgtwtJOir6Mzvijlj1JRKumLBiEiv9RLOf4RDSjaeWQIPxt8t8w02TMbQgSv2aoAzU9lt0OXPNA+c5skbCpoSxZaIkidqMRgvygyH+u04i6gbS2yrvb/6xiDVSEkk+6kdn+4g5wA40NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(30864003)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYx1uBLR7hJLobqTt4m1SMRdh7g3XwD3h4GUZJCfX6w5uiSgAYAyEZZHSVSX?=
 =?us-ascii?Q?ihyrxENdIiXzlihqDh6HtKYllhWZMvecqqo9Syk5uEfjDpaKrAzo4a5AXZb6?=
 =?us-ascii?Q?OAuwnrM2AXs+v4FVn/lqmUkjd8Kun6wwY1zhsTTYwukcHtG8cVhq0/qzuueA?=
 =?us-ascii?Q?r48z3M2cqLBHQvm0Aq19MjhpC0lva3xY+5cYPk8e1u1BLHLza5CE6qu3b5rh?=
 =?us-ascii?Q?YHEhEMInV2sjGXAoZJXCxMiEbr4kT0xBOjd6AXauuo2PMXC6Neevd5ZRHwrG?=
 =?us-ascii?Q?cJJbuEzOxYozxSMwT2pBRBPk/+tru+Bjx907lCo5P4X8ulK1YDeRvJVGg4jW?=
 =?us-ascii?Q?AMh3xG18KAvrOGLpaT7c0xQAGaJlFs1xbFOs0tips6laC+eUkEpqihyvaS5H?=
 =?us-ascii?Q?Ur/1S+4zMHrTONLrN9aJYlKMcMzPJPtr/2ABZrTarkk/pyRs8ZC4QFn7PR0w?=
 =?us-ascii?Q?hlEnt5LC5sSKGqRZKt9EPhYRDlRSlig15sth8fZHXlmPJDThsiv9AtPpP0ST?=
 =?us-ascii?Q?PoYXPJD3BnA0XW5jzwqzPvH0mM3gtDRDlbhiQVG/bQMx5/RZSzOSGhowYuxx?=
 =?us-ascii?Q?JhPbJzZqjwqfjTRogH0CQQ31pkxCHpIc2zaJlwxAbN/2erYiRQ91UWGBEBbu?=
 =?us-ascii?Q?cALKl2p4aSPc0th6vTdpjxi3PV9Sy/4t0kU4tvqRE9IaF2V9wTinPRlUVxB7?=
 =?us-ascii?Q?7LULtLoi6tCDbl7PnrfCuiUjYuaKK1DwwCH7o/Say6IChvK89SrmbZ9pNZS3?=
 =?us-ascii?Q?1ZdwiSWoXpY8GzUSHyGfaNzKFum4Im7xJUsfx0fCmPohuI95BIO3FYrRHXEH?=
 =?us-ascii?Q?qox7Pxl4ctGLN2Eaa3xmgdQetv3tbJejRFGpVoHTbaoyEJlTIkP8o+ie68I3?=
 =?us-ascii?Q?c8kRwm1be8rlKuvwLB3hAAnZTndG96xOdheyxPAdVZ3NrKZmZTVF+bzH0Fa7?=
 =?us-ascii?Q?bM3eeaRtaXtaRXE2Pm/ZTpd7q3BkDyWk6fAVcdzZQ5p8XaOqc/OclEG+LTuN?=
 =?us-ascii?Q?Jhf+OHQYqkFjxYZvjilyCMVmft8HQUX3MZI73aWRtFDUNFzEw0jv7ApVmfMd?=
 =?us-ascii?Q?IOzV+NTKr15SSNQYZnLp/esgkqYToegY1YWBhAjO57+2R9nC4NFgJ5ks7I+H?=
 =?us-ascii?Q?eQM+664a8utqqfK5EECDfwR/n3jgXVIY+8DNg8ONrlbnVEGSfsQ7tKeRxISa?=
 =?us-ascii?Q?TcVaRU6dSuyU82cRX1XUMeSJJ6VVZYEFhwpv4dvxRHvZMYxqzt7ctrYUUGXM?=
 =?us-ascii?Q?/fI69/OeHY0Q3R7VYD7Sk8b86Auj1uq+GKL65A/Hrmvc/mG4lHfNWvZyGnao?=
 =?us-ascii?Q?KfVmEFauF6YCv+zSx6e1oLJPEiVqb0gCfeJnpzqjs1DQRLYbWzMaEnggmDR2?=
 =?us-ascii?Q?ALmvr+pVGyaVMXyUUNWjD3CUJTmrKi4fA1HpYBAD0pH2Cz5KKIFZJ1+o1eCo?=
 =?us-ascii?Q?Gi2qxXGQwhu2PUNDOCJd4fRiDMVDZySHJD0QGhRP/oFsYxNjqMlook5I5iMF?=
 =?us-ascii?Q?ZVdJg7gIWobGnga9rwbgthczdLHJszj/OQX29+Bnj2by8To3PD+bFeKNqq+R?=
 =?us-ascii?Q?Y4xbh5doU9IXH1jSSlBqnU4jD+icI6F7JsvthyOiGFqzLlerMl1dcwv68RYK?=
 =?us-ascii?Q?Tf5uanes/JhVY+lmDNBT/ZI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 855663a6-456e-4d27-db18-08d9f5632ae1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:12.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNaFdeU2dVDQquyO+a2eHAiLCKZ88NpjGY805FaFn5Pfpzml6CuiQZoAnMcbzCJ+MsQ4ZQbi3pwFlG8um30meA==
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
v1->v3: none

 drivers/net/dsa/mv88e6xxx/chip.c | 60 +++++++++++++++----------------
 drivers/net/dsa/ocelot/felix.c   |  8 ++---
 drivers/net/dsa/qca8k.c          | 37 +++++++++----------
 include/net/dsa.h                | 50 +++++++++++++++++++-------
 net/dsa/dsa2.c                   | 41 +++++++++++----------
 net/dsa/dsa_priv.h               |  8 +++--
 net/dsa/port.c                   | 61 +++++++++++++++++++++++++-------
 net/dsa/slave.c                  |  4 +--
 net/dsa/switch.c                 |  8 ++---
 net/dsa/tag_dsa.c                |  4 ++-
 10 files changed, 172 insertions(+), 109 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d96db9825033..da7b38b1a3b8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1625,7 +1625,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 
 		ds = dsa_switch_find(dst->index, dev);
 		dp = ds ? dsa_to_port(ds, port) : NULL;
-		if (dp && dp->lag_dev) {
+		if (dp && dp->lag) {
 			/* As the PVT is used to limit flooding of
 			 * FORWARD frames, which use the LAG ID as the
 			 * source port, we must translate dev/port to
@@ -1634,7 +1634,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 			 * (zero-based).
 			 */
 			dev = MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK;
-			port = dsa_lag_id(dst, dp->lag_dev) - 1;
+			port = dsa_port_lag_id_get(dp) - 1;
 		}
 	}
 
@@ -1672,7 +1672,7 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (dsa_to_port(ds, port)->lag_dev)
+	if (dsa_to_port(ds, port)->lag)
 		/* Hardware is incapable of fast-aging a LAG through a
 		 * regular ATU move operation. Until we have something
 		 * more fancy in place this is a no-op.
@@ -6169,21 +6169,20 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
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
 
@@ -6203,8 +6202,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
-				  struct net_device *lag_dev)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
@@ -6212,13 +6210,13 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
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
@@ -6262,9 +6260,9 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
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
@@ -6274,7 +6272,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
 	dsa_switch_for_each_port(dp, ds) {
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			continue;
 
 		ivec &= ~BIT(dp->index);
@@ -6287,12 +6285,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6301,7 +6299,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6323,14 +6321,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6347,17 +6345,17 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
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
 
@@ -6365,7 +6363,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6380,13 +6378,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
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
@@ -6405,18 +6403,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
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
 
@@ -6428,13 +6426,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
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
index 9ffd5491bf2d..6d483887af04 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -677,20 +677,20 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
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
index 89a65f5d5302..0c21cd679a10 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2779,18 +2779,16 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
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
 
@@ -2808,16 +2806,14 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
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
@@ -2834,7 +2830,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 	/* Check if we are the unique configured LAG */
 	dsa_lags_foreach_id(i, ds->dst)
-		if (i != id && dsa_lag_dev(ds->dst, i)) {
+		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
 			unique_lag = false;
 			break;
 		}
@@ -2859,14 +2855,14 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
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
@@ -2928,27 +2924,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
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
 
 static void
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7c6befb88c82..30ef064080b1 100644
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
@@ -293,7 +301,7 @@ struct dsa_port {
 	struct devlink_port	devlink_port;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
-	struct net_device	*lag_dev;
+	struct dsa_lag		*lag;
 	struct net_device	*hsr_dev;
 
 	struct list_head list;
@@ -648,14 +656,30 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 		return dp->vlan_filtering;
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
 static inline
 struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 {
 	if (!dp->bridge)
 		return NULL;
 
-	if (dp->lag_dev)
-		return dp->lag_dev;
+	if (dp->lag)
+		return dp->lag->dev;
 	else if (dp->hsr_dev)
 		return dp->hsr_dev;
 
@@ -970,10 +994,10 @@ struct dsa_switch_ops {
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
@@ -1045,10 +1069,10 @@ struct dsa_switch_ops {
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
index 4915abe0d4d2..030d5f26715a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -72,27 +72,24 @@ int dsa_broadcast(unsigned long e, void *v)
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
@@ -108,28 +105,36 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
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
index 0293a749b3ac..8612ff8ea7fe 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -76,7 +76,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag_dev;
+	struct dsa_lag lag;
 	int sw_index;
 	int port;
 
@@ -487,8 +487,10 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
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
index 0e5dfb1c12db..2d174a1a0ac6 100644
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
index f61e6b72ffbb..e31c7710fee9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2134,7 +2134,7 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 			continue;
 
 		dp = dsa_slave_to_port(lower);
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			/* Software LAG */
 			continue;
 
@@ -2163,7 +2163,7 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 			continue;
 
 		dp = dsa_slave_to_port(lower);
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			/* Software LAG */
 			continue;
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c71bade9269e..0bb3987bd4e6 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -468,12 +468,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
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
@@ -483,11 +483,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
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

