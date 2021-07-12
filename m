Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90923C5F2D
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhGLPZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:45 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:23552
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235535AbhGLPZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeskMXhhYvBxGuiQZSAruAjdGNikYwJw1FVi21LdYUDr0Kok+QueklILbX+xufbFOaCvTM7Mi7Q218pujiJR1iYKyuXohLVOvCvg8kILRtqQyVkgqvjIYzkwaXPK3BcI6ytnerI04v5Uj57BSzfX6ckhAn/iPxJ+1IOFE5SeUZNKh6pgSKnH1ScsoMzvAcqe/YIbGLybdkAdHf7tMZuJgnNMUcZ2uvnXzbj4/6H+Fw9xb86S+5LM6maCj+rC/UGIMZhrbiqKiVueiZx2wVhClkymyXJcs3dsqc9crT+fri38M8kz2ztOoSM144y9uyfBfujImukIai+oXc8MKyrcfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0upUWCaw89Y/tpgL57V14pBNZVHaTEDlb60A0JoBUYE=;
 b=UHM8q/7FBb3ZO4IM+xXrLRQDueXbzFtCHpsbZ0m98UbHtLHDu3269vn2G9wMO3jKiqsP+krc5Ch6Y3GJUOEdvnM6rKmf7jkjUEe6BY5tUC9REgzzBAIiYy27qYaDLB7TimjRXgH/AVjo/UgG0v/jT7GsMpTAvGLZhT8r25hH+6IiFyjyoEJ9oEh3jO9kBLyWhBOAWWzt4RyOk48JIhIQkXDp0YCP8VnszGmViEB19sVEjZDIANVCJ3Avw8ORw+cp/kE1IPRLOrzCaHQiDWmKCe4qS0LwdYj/Psyp2AJkpOTVIWszgddjw1pdRC4Bc6v6Ku9DC9aOHe24Oyfi7/MVTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0upUWCaw89Y/tpgL57V14pBNZVHaTEDlb60A0JoBUYE=;
 b=j67h4TYtbuC2olWn/M+fwz65xE954Nf8lX2q0qiovsCPLbNsWMQalTHnRQ2fMqpOsvDRjH79pls+FoluAbtLc7w9ITHLQ8LuET4r044SXrAJDxtdAnTB3Q7gNWq5wm+4NLokLy3OLkMzMheOapeRs2eClblMqgNjxelfJthhRn8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2798.eurprd04.prod.outlook.com (2603:10a6:800:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:39 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 23/24] net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT
Date:   Mon, 12 Jul 2021 18:21:41 +0300
Message-Id: <20210712152142.800651-24-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ffc0977-79d6-4d03-e3f5-08d94548e2c0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2798:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB27986F292FFB835C292841D3E0159@VI1PR0402MB2798.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APn4LA7YBP7HnWnVu0M+OohAaROhDANi19NBxYLTT39rZwlFZ5DdtPnpYo05RbXPv4AAUuoiXHPbCuKlg6ZpUEg0El7qI7d7pfgAo45VhJaYQDesLa8vX4+MYV6ljJktMqVS8iZKPNuVL0aZCl4y7Ay2sIfO7+Fx9jILyS1JyiQ2CUtE7V6YcRCGEziYqjcf1ExfKN+k2umXdrLrWFH1FkLyoFcxc7dG/57Kt8jb5Gg9hfC2kzRvnkm2EZWGdD+a4b60KH3huzkCYnldflJhyJafoTaxPqooDt6kLzM7+Q30Iaz6dv9IEVERJKsLi5SmXq5DiOBR2YsWrLBG4Y1SfvSeer1NhitCd1YTNsauDGGloATEYnc/hfEsihzHxDCDwI4Szx9CGnCV2FjG0mn7cSiM9cAmwbVqpBXGUIPGxdDFX9oaNuIv0ILpTm5x5ZinOrQJgj9gc8PymH+I2ZaHGn//s1lbT6f17xerrA3sDb0OIacmm1nX0gvfgKbUckWdwQe3laur+roJKzqSnOCpOVOSslTeNiNGgXKwKFP2v4PEQjXW71syFb9C9wyz6nzGpsHvG7GR8+YaVjSNmMKyTj70OAl1/yyj6L036hpXcfuTycttRVCSs+/S57P2bvlsQT8Z/zb3u6mVDKUg8ZbcUkAFYovt3ZVL9Id7UwV65T0OMBMbP3tKTS0OLClO5m4t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(83380400001)(66946007)(4326008)(110136005)(2906002)(52116002)(6506007)(54906003)(38350700002)(956004)(2616005)(186003)(8936002)(44832011)(316002)(1076003)(38100700002)(6666004)(478600001)(5660300002)(36756003)(6512007)(26005)(66476007)(6486002)(7416002)(8676002)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sbaB3xUgWLtmM4tYTbIEtsB5e/G40YBoVwh8dcNHzNvfF54qi1ps9ZyPAKLr?=
 =?us-ascii?Q?liT7OVMZ8fH+PInHqQP92itczfstFEoiojgKhLMLBZodv2RDyE72e/POEBE7?=
 =?us-ascii?Q?6/q4Ifdk/oGWz0bNbEIOWcBIS2XSvz3t/RT2LIv9ZuZLqrCexJe3WmnzaztT?=
 =?us-ascii?Q?H4b3nXyfvoNKqjQnrB5o+Ozt586CcbAKmi2v55II2SedqKZaVShqTz5Z0yH4?=
 =?us-ascii?Q?cs/HqXpAfVsEM3YnLqsCTxxR8DWoJLyOasygNh6EI6alH8vTEkq3mihU4A8z?=
 =?us-ascii?Q?jV+62WM0twYjSZ14JUsJBmcTpsdnkH+4iKyUKagML1gYGR2z9L23uvrXAgFW?=
 =?us-ascii?Q?SrkHE/uyUHaqfv4WRc8r/Q9INwUC4Y9bWmUEQL8eVrwQ+KcKPQUyzS9xW8hY?=
 =?us-ascii?Q?eVWj9wiVpDZs5UnDfehAmTmDcy3irF9rl7P2cAq0mYdG6IZYs+tZPbRxmKcF?=
 =?us-ascii?Q?sJNvZE062IMmpfgm1HYZFg9Q3hNLAmE7o7PhEFwtNePeWMSc8JSKd0IkjP2W?=
 =?us-ascii?Q?GWMvEfXUrmpUfukk0ZSog05xhfK9ioli4ewypQ6LzAylROU54H/yYFyoZqSL?=
 =?us-ascii?Q?6HLaA7CNFd8LfWkFnOa9G6NoRoi42ekQNpKYEN8pjWbVA10ewQYKCm+lwRjO?=
 =?us-ascii?Q?dOI+1PNvTTBG4X2IqQUtrOJa4DhGeOIBNdOpq2u+4Ia66y81jAVES9oc+XmW?=
 =?us-ascii?Q?RROV/nlEGSei4Z6ja5cnrMxAz2oK5gbrCVFlmRJeA6Vxm313FGdvf25mkjL9?=
 =?us-ascii?Q?HJSA/gzRVcK50slWAwaJoVfEnBwQrG3EupHX2Jj7fyz34k1xYMHZi2+4vhyJ?=
 =?us-ascii?Q?J88aXDxRvqSnWqcVS3GoOLdumejcK5DD3UotdP+FZSMDeNMB8pjO7ffERCFQ?=
 =?us-ascii?Q?LqtCbe1LQpLPuCjYT5wSBMXFtuifYrA3/c4BlCWKVzg3BLjCxja5eK3VOTRK?=
 =?us-ascii?Q?W0wJQ4Kq+Sc2ASaW3XXoDPG7XerjszBoCLWwpK/V0WrZh8avqJpSyQFZs9bk?=
 =?us-ascii?Q?wiBrq1AvJ1hvOmC4e+vVQf+3vPMmfkcVM+e1wvmXl3Qy67pil5hwkdacHjVG?=
 =?us-ascii?Q?4JLdoR3Dx4rPNgSO9o6+sB8DmJvVGeNBLol57sY+Y1MX7q52JubphRvGtd7d?=
 =?us-ascii?Q?bleJnWPNmdaBawU5Md3ZEfCcLYZikMgWBGSIQT/1WjoqcfShujYB/fn3kPGs?=
 =?us-ascii?Q?0OmAfL2juW+yOE1zY0ZAXZOVvEtuDJlMvQpgWXgZk6ZJrMb8FKz5GnSbt6Fi?=
 =?us-ascii?Q?vVYnCQvKE1aRqjFLrpdnRdkyzzOHZtnWaD5LcBplo2Qib4HQ0836N0SbsRV9?=
 =?us-ascii?Q?mc/WZ1saEnAZ0zE7gPkYC4O9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffc0977-79d6-4d03-e3f5-08d94548e2c0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:39.5189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGTpC48TNOXBOsaLBtr+udCokDj92dgPKvh+3mTA972bNJr2i2neIAyAn4CTTybjwuAW13zIsEAPjD5t7FJz9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2798
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
 drivers/net/dsa/mv88e6xxx/chip.c | 78 ++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index beb41572d04e..061271480e8a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1221,14 +1221,36 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
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
+			if (dp->bridge_num < 0)
+				continue;
+
+			if (dp->bridge_num + 1 + dst->last_switch != dev)
+				continue;
+
+			br = dp->bridge_dev;
 			found = true;
 			break;
 		}
 	}
 
-	/* Prevent frames from unknown switch or port */
+	/* Prevent frames from unknown switch or virtual bridge */
 	if (!found)
 		return 0;
 
@@ -1236,7 +1258,6 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
 		return mv88e6xxx_port_mask(chip);
 
-	br = dp->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
@@ -2422,6 +2443,44 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
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
 static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->reset)
@@ -3025,6 +3084,15 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
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
@@ -6128,6 +6196,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
+	.port_bridge_fwd_offload_add = mv88e6xxx_bridge_fwd_offload_add,
+	.port_bridge_fwd_offload_del = mv88e6xxx_bridge_fwd_offload_del,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
-- 
2.25.1

