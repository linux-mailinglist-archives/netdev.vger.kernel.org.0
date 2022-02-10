Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4284B0DE8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbiBJMwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241827AbiBJMwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:25 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0558B2636
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWHD6DDFlzQdFL+fg9RSVQAhDe6CN93DK2na1FQ45f5/n2VHOfzWc7QJRXtj+25kFQtOEtho8InIy4yQU1bc+cMz2FGrtQ757jyci/q9Lqa6NyNGyKxDCrdqRdkaNrMA3u4PWYWphB97g1Ttlrbgd2ItaUFyX9vXwG6qPezhFBZ2GL2M83iIQUtgrPP/9AqzG3cqPNd6Q9J1T6Xw+gAPPU3WASSTLJdEYcjxqkKWtE8FHcJK9NoWj7W43O3Bmf0vxQT4iibJ5OPU1oJkyxQM1WzxljOM3Mxs9Hu+GN8ukfAeYeBHfICtCiQhTS1uqKVF7iIhGu5vlZkq5vGwI1S6SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEqhkNF+vLEwE/x+khD8HAiB/H1sR2Kssgi9S/Trk9Q=;
 b=lmSlQ5zQchyf4yVovn5uj9CWpsoZYT9vlpxNhzfPiD++AYZf08hrFCA7Mt54uQikCWCnJiHAK+i0UPx5bdaPwwF3daSGIzMt2kXXpbUNBh3An/ZD3ffFU6H/EkCMawV8Y4+blnPokQ6kMiGDmodamrR9dtjZceA9bWyOSrzaihKiKmp0lHrNit9fTLjOEPIsFwOVNnnfo3Q9R75cUIqjtLJUL/kKOsuOfZPsKEKn0e5McQJaBRURqu9Gonn6wp1j86SL+Lap/rywREGu96WbxvqBKe5M5jzOcA5dJqj91WsxYWP3QcmvcmAtrJ862Hn3ufag5IqG/EXzpFimsCjS8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEqhkNF+vLEwE/x+khD8HAiB/H1sR2Kssgi9S/Trk9Q=;
 b=WNew1ZsnYGB2WoALCqS0bfB+gzeepvcu6cWCt13bdbpBkpB4T0zseGEn4JXZFN8cdB8XzPkNlZH2Ceb14GoBMGgtIlPoiS5SowJGmtYpn8zI4l3wysHnhBjWHKC2ZFrPo8VwyMih3QSIr/DZb6YbmaF9Te1YRAZRBEsPba5SOxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:22 +0000
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
Subject: [PATCH v2 net-next 06/12] net: dsa: create a dsa_lag structure
Date:   Thu, 10 Feb 2022 14:51:55 +0200
Message-Id: <20220210125201.2859463-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 298c8641-814a-4c31-72fb-08d9ec942e1a
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8806EA290F318D349D4B6CB0E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVQ8ijv2NuqIC/vOEhStUIUIZD5V67KIK+pZS2mJff7Cmfl7iAn4SWaEVPXhvxdAvnVKnfUbKYGzZVfa1xhbrKqzfiYxoHoSKOTE6G/6548fcRoiemNbl/kg2EuPk+QVSJ6Ric6xxJSvEGMy5YSaKJ1yVCK9QGCGNnOsu4SJB0r8F5j/+pKsp/mgG5CzPrGAMD2GNwV2QX0q3kXw07zv8cydvoDY2UGzFGKhjQ+BeRq9adGOduiaicJUvgDvn1NLt4SFvrnGmN6iF3PSPzhOKwSc1st8gcYetAY8oSdyOrUCp+tCort0aXL6R8HpFG8jfQonzvtzC6+BJsvADQlNpTIPJrJQEVehMC2tTY2IHx7DbB6wX0bng1YUp6MzvxZN8jorUDaWmCXKeqyg/FlkMTHGD3DGglHBsYqI1klKDn2TN4PuVwMWF8RMrTDbntH2I7r7naZjd67r+s561JlskhGkm6bicb6XwVDJc4kyJXySkF/k3XD9YQmFlUVkFTS3mNvncc0E+ZQnF9p4UCjdierMlmdeA44aRTD9BhdapWqQwROXUgT39INsQpJJi/zYlk4xVUVWq5Td5piq2aqUHHQkAZVse05PhAYpfOwvSq10RyqGFHLIhgHuTtu9MyuU97ks8w1Inrtaurtpm1L78N64qctwX0ZRyBG/kbRVxNwSw92ZduPFuzMj0bY6bC7sCk1wqH6QOYBPOHqDbdOIXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(30864003)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8mz+n6NaybQCQz/LPVvO1bl9FQLhdnwN0zXBVDZFXRuzl9AAYWrWnT66UsCN?=
 =?us-ascii?Q?eRoxF/lRk/nBscygwXOC5VfSf8MX4AwDt17Jl56VUS9kN0Lv9J6EvmMQbtIx?=
 =?us-ascii?Q?+BYD3eOlegGG72RzokN0FlzQYWTJ07boPltC6Yomc3BjbEF8WWK9Lkw0WspV?=
 =?us-ascii?Q?cU5EX2WdMaUcO5dMacsXzRn4Jv+24Mu3R0Ht8S98m//kIE4tRn9YYCR+nB86?=
 =?us-ascii?Q?jWVTmWTqiQhUNSoACaaIVRpJrfehHyfSE92leUSzM1nbp62patGjJFMKyt4p?=
 =?us-ascii?Q?PDTXed8sqNE2UcTCPDiujlnyFJ2fY+ZzqmaM/LH39AcWLyZ27DoZ8yQuusiq?=
 =?us-ascii?Q?jkg0++/sV37oulUAU5hKrd6K4kdIlJV9LCPDS/TC5vBtFn39ntQMzs4AzCoA?=
 =?us-ascii?Q?NCPuUCduEm0S58HwQwpJBatOEoZqoeOx3EmH5yDR4f2qROM1wYDUsobpp9l4?=
 =?us-ascii?Q?8Qqpbnz56hL9i99s1pSirfPkhDVjZOoprrNpTtmLlhlKUXijz7Q/V2mdXXed?=
 =?us-ascii?Q?EX4dKblswZnNOALIr1QB/NetrF49qoiEyuZa+C4hamvG6vsnKi0MtSyl50aK?=
 =?us-ascii?Q?YQ5hHyhhuFyy9Lefkm74EVdsV3JTIriWeNKkUG4snQoPPmSyFqcmY6Ymyizj?=
 =?us-ascii?Q?SE6sCml9YwZNJG1Y8kkS9ybqX/KPaSCzSkuVNymP6wMgIiJEuMFXWM5Vf8Xj?=
 =?us-ascii?Q?JaFpMWY0qC8HNFK8EvUSgLc8K0DtFFf+o82VpGSVt7+LtQv7a/DiIjYuFDRq?=
 =?us-ascii?Q?iC8zwVyOtuDJiL6hCjsRZjUgEQ8B90jnFkvVhly3Rr/F/7+E68kX/daLT0MC?=
 =?us-ascii?Q?LLow6EYlyJq0FVbrVm5VdA6EjGubiMDIeV1qItWPoY36+tTjli8qxdfeb6GQ?=
 =?us-ascii?Q?KWKDun8RWuGjKxvAuq1TNZ9mRk2wcG33sxiL9HAIb657FFyqf8HG65Zxyu/8?=
 =?us-ascii?Q?O8VlhvFAoMDEGsfaO7j2C3X2d0hChG9/FCzSz/5XSivuFOiNoBwjCelmJVnc?=
 =?us-ascii?Q?t9SXlljYZZCkKWMEfpBxi3BEnpJOIwKxsTsVwAiVljmPTzMarEdMNXgQuvCI?=
 =?us-ascii?Q?1laB3hWd52+QgkHplx+sEIcL10iX3kUOPD+qvfdyR9ScaNT69WpPrNnhIRq4?=
 =?us-ascii?Q?BEktWcSHYqoxJLWJ+VQxPAQb+TyGTJ4rYJUa1LCTxf4vh1yT872TibrxA/10?=
 =?us-ascii?Q?BkfgeEIN7/Rd9eb8kGXMSJc8pzD9uEdzzl8yh3SDhtZlEAKnZCcNMJ3IyZGL?=
 =?us-ascii?Q?2WaXJwo2oc5qHQp4IuDbnpHWVvXd7thvrgpJ88fgyuCbpZnPywyx9IzzpxVm?=
 =?us-ascii?Q?HiXhW7HJ10n2PLFSjaLVyVRQMxoMMC6t/7dZ/cuWpnTzBee4jl2sNjkyZwO5?=
 =?us-ascii?Q?tx0PQ1MiQRjaqnsEj9H3rEAe9HEWojM8qQ4klf2xQEcSoGykAUdUv+o12WLr?=
 =?us-ascii?Q?vlKQIuEWwiyCOYfiQM4bU9JayHW7riE7DaxnEKoz4T9toiiyuuPK/MsLtikt?=
 =?us-ascii?Q?a4oIzioAMNfxIttzrPBbx0o1hmvBvO6UKfQ1F5odFXtht0A9T+EsvY5QJCz2?=
 =?us-ascii?Q?35Jntupq7oBg0V12pg0GNUsOId1WEEe8ENV9lSxeUVkKQ+lwN84ikPMuhMhS?=
 =?us-ascii?Q?tBoqNZ4w5Ai0HMArNRRAvF8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298c8641-814a-4c31-72fb-08d9ec942e1a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:22.6029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGUoAi4uadsTTZ7ilp5krkFThiB+4KW3o/qdJCxtjXT3qJvU4ogfajE7OMjba6cdgMQrSi0n1UInHQ3UBmb0mg==
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
index be4f185442bd..c1067352b695 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1606,7 +1606,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 
 		ds = dsa_switch_find(dst->index, dev);
 		dp = ds ? dsa_to_port(ds, port) : NULL;
-		if (dp && dp->lag_dev) {
+		if (dp && dp->lag) {
 			/* As the PVT is used to limit flooding of
 			 * FORWARD frames, which use the LAG ID as the
 			 * source port, we must translate dev/port to
@@ -1615,7 +1615,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 			 * (zero-based).
 			 */
 			dev = MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK;
-			port = dsa_lag_id(dst, dp->lag_dev) - 1;
+			port = dsa_port_lag_id_get(dp) - 1;
 		}
 	}
 
@@ -1653,7 +1653,7 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (dsa_to_port(ds, port)->lag_dev)
+	if (dsa_to_port(ds, port)->lag)
 		/* Hardware is incapable of fast-aging a LAG through a
 		 * regular ATU move operation. Until we have something
 		 * more fancy in place this is a no-op.
@@ -6115,21 +6115,20 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
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
 
@@ -6149,8 +6148,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
-				  struct net_device *lag_dev)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
@@ -6158,13 +6156,13 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
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
@@ -6208,9 +6206,9 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
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
@@ -6220,7 +6218,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
 	dsa_switch_for_each_port(dp, ds) {
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			continue;
 
 		ivec &= ~BIT(dp->index);
@@ -6233,12 +6231,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6247,7 +6245,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6269,14 +6267,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6293,17 +6291,17 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
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
 
@@ -6311,7 +6309,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6326,13 +6324,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
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
@@ -6351,18 +6349,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
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
 
@@ -6374,13 +6372,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
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
index e1e045ceec63..58a49e625c46 100644
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
index d0224f648777..1f3a5ac3fb96 100644
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
@@ -644,8 +652,8 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 	if (!dp->bridge)
 		return NULL;
 
-	if (dp->lag_dev)
-		return dp->lag_dev;
+	if (dp->lag)
+		return dp->lag->dev;
 	else if (dp->hsr_dev)
 		return dp->hsr_dev;
 
@@ -722,6 +730,22 @@ dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
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
@@ -960,10 +984,10 @@ struct dsa_switch_ops {
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
@@ -1035,10 +1059,10 @@ struct dsa_switch_ops {
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
index 5670b441419f..74a2ad1a4047 100644
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
index 9bc6dd4a5855..0853eed44fc9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -74,7 +74,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag_dev;
+	struct dsa_lag lag;
 	int sw_index;
 	int port;
 
@@ -481,8 +481,10 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
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
index 2b5b0f294233..974dc9f025e1 100644
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
index d0d59f2fd445..4866b58649e4 100644
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

