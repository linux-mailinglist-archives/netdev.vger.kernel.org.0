Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366473BA8A0
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhGCMBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:23 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230282AbhGCMBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRTAQzcgqv0r9LmKhAdiXyRsC1Sjbf3BFjVPnkvLtIuYM57qWAz2jz/ryANOyNCaPR8tMrzkARSyh5pofriio0DQuGjZXuzJedW8+Jmy5/PpxZavP20TWh5czbMoTc/3S/1hfKt9kTc06oEgTIUJ4/Qdih//Zo/URo9+uYJW04fA3WRPJf/uBxFSp95c2yvNylxOgV8NLwD3EMpVN/ZNLO01VA4FOunE0YUrT0QFZMWYSjI0RTdtV0k9g+8tkouPe7t1iOT7oChjhDLRYHqmLgluozocN2mAhmXfvSxsEJpi0M4gziGSOhgT7ppxbYu3awkIMOrU/0maf0+OZOnVfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eu1sAgg7D4fTGIJBx5Bv/Zf9lqtWFAqVWzacPFz9uYA=;
 b=nAmhLdMhBWoOUULxXIaGhBgsaL+K8x+gRIHXghftAh8dgwRtn4iPlGCXnDQ7rBfcLus29QfSdMThOyJ7U39eVjN19p0FVbu+dmkC8Xx0vebl+FRzVVxbBEYyK9/3n+EACNIVpdh/5k77akJs2xYqYczpZLKUbkoUx8JQC3i55QT3+zhgkMIK1yfm3nBNGKSTWSRQP+cCKAUUYBm+ixEOOgsY6dLMxFHjg/84w2FMF/O8QGcAeZ1cjHhzsNbuVLFhH6v7dHKvuUDISOB9b0T6wmS/OZ/BA1Ok+y5LzPa4IGFGmOBmnirVbmnCkFZzZZR5eHPDZ0Rt/kFZ+YFe72k8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eu1sAgg7D4fTGIJBx5Bv/Zf9lqtWFAqVWzacPFz9uYA=;
 b=aHY2jehM9D4WnS4ZsbTT9gVwbKrz+TX5aQCqyZsdKPLnEc3yp2JvEpE0fPDKxdQfdgn1cXFsYoP59ISuKhqf0vfshRDa5ygGaWJBUEi128oLZk4T+NHb2TmIpnkNZTVPznKrPhSqdJczDirAj70kh+xNyCa8Q7VRWJuhO8VUaZ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 09/10] net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT
Date:   Sat,  3 Jul 2021 14:57:04 +0300
Message-Id: <20210703115705.1034112-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df13e2e0-937d-41fd-655d-08d93e19e546
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250989DA3B691F94BFA960C9E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CdrUMt056Rkb/gr2HAo9z9pm8NJMZp+8pnGi5ijEYlNkDUdNk+g6l5oSA/JAE2v66EPzK2h6A6K3V4zHnkwuehXE0Gnex4x4/fBcS9H890x0AGWMdkdeKhjR5l6K9U+bWuALmSWMbj5KhfPs5fGpYm0gXiObC12wm3odmWknM0DXdrzmxCbh8+MKVkbZtTBVlLqIsEy7wsYLIazHGctumOoVoDofCb2LObVsK9h8sNR5CjcuwylSmydL9ePB7c/8qneJXdOJG2a+n0+/xJrEm1KRY4c+vGshEE0LA5+6jOmBarexniWW+5vlzu8w4jk+3CQXqhydM5lv35du8qJ1yre0XZUwNJp9JwTXn7n8+0RvB9HePa7oa+JgQlyqOJQub9dge/507nI0i+z49fKtNkr/1JnVUS1+yFr63Y+wsFQcSPjVh16xeW8YHQCAXFKYVWpDaEXaCspiqk024icTG4/AqJ9FdZpABQZJo5gZE4LTsmOHRlMTlbLQDsAkwaZD17jNeE9+Ywgf1Y258qDKbrBVx3L1e0HucGKQQMaRsPit/zkb3yfvkx+6r82Ij6i+LlOHsij98lFP88kVsyLTdgfuBHXxx1NBEx3xdqGKSWJ+OhvBTKi1us5b2Y2f7+mOyxIMlqjlYg7AY1fKdcb1KE3K0TCzRPDRkZWW7jCS2bKa8ZNX1BqIaKomQO2xDwWE+/9EXe4iMLnckstfIQi3OfChew7U1dpCEMYjL6mYE7U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1yjdB7kTRnvl6GjynrOxDXVonsbkdRXSg+nJe4CThXtf30tNDeMm8f1gcJcc?=
 =?us-ascii?Q?SobD2oAe9FJKGPs/WhS8z2F2FodNfH794tV1NiUd6tm/zhPuqCb8W9LRYaE6?=
 =?us-ascii?Q?JGvuLS3/UbuBbXGMEF9YVmeEEr9Zh/7rBiZHHI42P+jt/6lznUP5LcDE1vzZ?=
 =?us-ascii?Q?wzwuS/kQh4VLr6Vi9gnXwWxLRIy2MctxG761dVAjTB/jK2oDLMzJrppdL+P2?=
 =?us-ascii?Q?69ha+v2ZiwJVTdCfo2N+bvRAfd0KDhXUTwufYL6AYpVoOU65cPB9/PcmTWEZ?=
 =?us-ascii?Q?U3Dt3iaQU9zZ6caGGlFfsEsGUL2wz5SZfnqpFekDCVVyxYmBwyxmTaQ50w+j?=
 =?us-ascii?Q?c3vQHfv098iqPinWUsPfNkkeWSJP5vFaSwLuvIJnoI5VaMDh1Em2SQEkDT0G?=
 =?us-ascii?Q?QKd6sIRFiDGmrucxyg+BCrQQAWa12hU4zj3HklS04EMFcc23N2pYbD0NiJw5?=
 =?us-ascii?Q?31TnEqQxqBkAcCf4YlkBYWzpvBd/UXBZZ55mj3TOPY1lM2SblIC/7Ut8KlV2?=
 =?us-ascii?Q?CycSDzbv5Bc+WaJ5Hk1pSr/u5oxREkKn94khAGpGb0MyytOqXsKwmGIOF4re?=
 =?us-ascii?Q?XjsoNoHlRbHvqY3iQbI4hDwXDgiDNTaz/Ra+7f1uQs6EaRBHIMhcGIUGxc9+?=
 =?us-ascii?Q?ApKrOcWrDa89tHcv0v5dQshLkG03UsrNEWBSpUs1hKvI5aimwqRhJryvHtGe?=
 =?us-ascii?Q?SPIIeD/FKz0VNkXICZtfiwRIVu7ri87mGO/WTp2l4xexqOUeBVESwfGXRhBp?=
 =?us-ascii?Q?L2NnbEuXFkG58exm1VqxxuP9RRJ0MACDH2ZeP3Gfd09OmVxdLR38CAc1H942?=
 =?us-ascii?Q?hf5T6RZaf7tPxY0flHFGmbna2+1Ymn3RyIAKSNAyx8WvPLVuTWRbmobg7PXf?=
 =?us-ascii?Q?8Ar/NkcbCkU7CRGktlhApviLyK1mBXnWuhU9Nr+mlIdrze/uvVDsexLLc16D?=
 =?us-ascii?Q?Qf/qEmrC1tQnUI9MOtqQ4ip3hjokMeEAMQa1GFQyDNT7rm1mBdsEoo93JtgB?=
 =?us-ascii?Q?ukNhS+0U/tgqTquflwoDRalTQCVbORHO8wRI6uUIQzvQ0sZYLBa+scf9dG84?=
 =?us-ascii?Q?PcCJUA94N3WkqGJ6+LzgwSBcZSuVy7CcV+vQi9kxhJNwH+e9kNQcPyzDRfXw?=
 =?us-ascii?Q?niPRW/1ZqyDQf0S1yJvDPmnHeFlpNdnrYoBnHCXl1Gi0eeFkEg71f616uts+?=
 =?us-ascii?Q?/KMS2kHfhd1Zj7kGMjvkBWqfULUCeSlCDLpCY7HYn+2ZoD2fq3Ixs1l0LP4e?=
 =?us-ascii?Q?EpRvTR+XjkHl7joJeE1GiYsNMOmI6/u1Jp/WlEUzh+amlMxs7qp2k32mPnty?=
 =?us-ascii?Q?ypKzNc0DmNdlSg5Isu1GEbSu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df13e2e0-937d-41fd-655d-08d93e19e546
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:39.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWdhviW9iqyxeijEDgornZjVyS+wae6MuStNbJfRxBSC3V36MFWc24ZoOrZy3+WvbSFxKZPJzWegDtYTg7foNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx switches have the ability to receive FORWARD (data plane)
frames from the CPU port and route them according to the FDB. We can use
this to offload the forwarding process of packets sent by the software
bridge.

Because DSA supports bridge domain isolation between user ports, just
sending FORWARD frames is not enough, as they might leak the intended
broadcast domain of the bridge on behalf of which the packets are sent.

It should be noted that FORWARD frames are also (and typically) used to
forward data plane packets on DSA links in cross-chip topologies. The
FORWARD frame header contains the source port and switch ID, and
switches receiving this frame header forward the packet according to
their cross-chip port-based VLAN table (PVT).

To address the bridging domain isolation in the context of offloading
the forwarding on TX, the idea is that we can reuse the parts of the PVT
that don't have any physical switch mapped to them, one entry for each
software bridge. The switches will therefore think that behind their
upstream port lie many switches, all in fact backed up by software
bridges through tag_dsa.c, which constructs FORWARD packets with the
right switch ID corresponding to each bridge.

The mapping we use is absolutely trivial: DSA gives us a unique bridge
number, and we add the number of the physical switches in the DSA switch
tree to that, to obtain a unique virtual bridge device number to use in
the PVT.

Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 106 +++++++++++++++++++++++++++++--
 1 file changed, 102 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index beb41572d04e..6b9c1a77d874 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1221,14 +1221,38 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	bool found = false;
 	u16 pvlan;
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->ds->index == dev && dp->index == port) {
+	/* dev is a physical switch */
+	if (dev <= dst->last_switch) {
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->ds->index == dev && dp->index == port) {
+				/* dp might be a DSA link or a user port, so it
+				 * might or might not have a bridge_dev
+				 * pointer. Use the "found" variable for both
+				 * cases.
+				 */
+				br = dp->bridge_dev;
+				found = true;
+				break;
+			}
+		}
+	/* dev is a virtual bridge */
+	} else {
+		list_for_each_entry(dp, &dst->ports, list) {
+			struct dsa_bridge_fwd_accel_priv *accel_priv = dp->accel_priv;
+
+			if (!accel_priv)
+				continue;
+
+			if (accel_priv->bridge_num + 1 + dst->last_switch != dev)
+				continue;
+
+			br = accel_priv->sb_dev;
 			found = true;
 			break;
 		}
 	}
 
-	/* Prevent frames from unknown switch or port */
+	/* Prevent frames from unknown switch or virtual bridge */
 	if (!found)
 		return 0;
 
@@ -1236,7 +1260,6 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
 		return mv88e6xxx_port_mask(chip);
 
-	br = dp->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
@@ -2422,6 +2445,68 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 	mv88e6xxx_reg_unlock(chip);
 }
 
+/* Treat the software bridge as a virtual single-port switch behind the
+ * CPU and map in the PVT. First dst->last_switch elements are taken by
+ * physical switches, so start from beyond that range.
+ */
+static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
+					       int bridge_num)
+{
+	u8 dev = bridge_num + ds->dst->last_switch + 1;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_pvt_map(chip, dev, 0);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_bridge_fwd_offload_add(struct dsa_switch *ds, int port,
+					    struct net_device *br,
+					    int bridge_num)
+{
+	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+}
+
+static void mv88e6xxx_bridge_fwd_offload_del(struct dsa_switch *ds, int port,
+					     struct net_device *br,
+					     int bridge_num)
+{
+	int err;
+
+	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	if (err) {
+		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
+			ERR_PTR(err));
+	}
+}
+
+static int
+mv88e6xxx_crosschip_bridge_fwd_offload_add(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
+					   int port, struct net_device *br,
+					   int bridge_num)
+{
+	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+}
+
+static void
+mv88e6xxx_crosschip_bridge_fwd_offload_del(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
+					   int port, struct net_device *br,
+					   int bridge_num)
+{
+	int err;
+
+	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	if (err) {
+		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
+			ERR_PTR(err));
+	}
+}
+
 static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->reset)
@@ -3025,6 +3110,15 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
 
+	/* Since virtual bridges are mapped in the PVT, the number we support
+	 * depends on the physical switch topology. We need to let DSA figure
+	 * that out and therefore we cannot set this at dsa_register_switch()
+	 * time.
+	 */
+	if (mv88e6xxx_has_pvt(chip))
+		ds->num_fwd_offloading_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
+						 ds->dst->last_switch - 1;
+
 	mv88e6xxx_reg_lock(chip);
 
 	if (chip->info->ops->setup_errata) {
@@ -6128,6 +6222,10 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
+	.port_bridge_fwd_offload_add = mv88e6xxx_bridge_fwd_offload_add,
+	.port_bridge_fwd_offload_del = mv88e6xxx_bridge_fwd_offload_del,
+	.crosschip_bridge_fwd_offload_add = mv88e6xxx_crosschip_bridge_fwd_offload_add,
+	.crosschip_bridge_fwd_offload_del = mv88e6xxx_crosschip_bridge_fwd_offload_del,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
-- 
2.25.1

