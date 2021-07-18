Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508EC3CCB27
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhGRVtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:45 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:53472
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233646AbhGRVtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkqtN1s0/3g+yUPJJGH8P3MOSCF7GA+7aNINKrxgibqiTQfw8wHnqw6XZeTm1KO94GqxXRIg7wusxmSIoa6W7KfZvh5hho2DI1pu98TJqVn8+r/wF+ymhykcsAJz/MVS03iNwVffuQEch9/XQ5AFxOPKRV+WNW81RfO+Uno2ZGdenM75HQELJr315GOnRPugwswRD3+CPUNy03ZBsHo5APP39Cp0De0bPThQqIypBgO/nfsthVmbmLSQtdv0vTO9qkJBpwtlW8YWEr9cKG6k4+BRbbA2lnpX0i6GYwgdLH5Pc3zxruCHq9nvUR2MELUce2fdRCJnXy1/qOWwtaeiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoptCvtMYckutX3UYnBp22q3YaR9C53XqvXQwtsth70=;
 b=U/THWPvT9LLd41GF8rq/kt/SZcnWCWFs1XgrMkZTz404BUP6+nyzS2hCInA2XEgBas/sfoFKQqtVL5iCgUJwnThAhzQyFB6I8RGm8aXgRKTe3UiDkhqkc1+ineTsx9AjB6cz1vdvIUPOXlKqNEq9HA2Cx/r5yMkEa7JHdLOmDBSVNt7nYWIf/d/WTjtv40V+Pcsb9zubSy/OGCzJ5eJqEymlAZBaN0X4Ql3CeERYpuMkSHFsRlIY56rUCqFRbONuB15LoM07lz36UD5jI8y+Km/Y0pu1dA/MXXVsD54fsTrVx+FJ3EKCOpWilYtPEpCUW2BIWzuHW9g+FvFqjnv47w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoptCvtMYckutX3UYnBp22q3YaR9C53XqvXQwtsth70=;
 b=U8uBUd8ke08amNOkpUgUd3CiTnvs1LyeWkUJbUMt99O9fSUKdPO31JnySmgvtn9ZdFiMVJYXofhvca4ItwVORHPctTLkxtK4NM/s++lLCJ9FndYQAkpI5lgNuSDvWW10me3YQf3SL6YtNi0pts25k3raTGuZPnSyi9EwxhO2Qdk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sun, 18 Jul
 2021 21:46:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:20 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v4 net-next 13/15] net: dsa: add support for bridge TX forwarding offload
Date:   Mon, 19 Jul 2021 00:44:32 +0300
Message-Id: <20210718214434.3938850-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4fe3740-5e1c-44d4-a2b9-08d94a357ada
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55028596301C0B6DCAF1A1B0E0E09@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wdr/B8JO5GNwXe5GPwxB79NfhDWeUiQa7WgpMN8d5wX5cAN4dn6P6l5ZnjKCUKrzLGcGnXyq+++fgZbFrq6EB9DxwRbPmLRs9rt8H3l+zygGYxShM6Z8n0TVHUDzTwj0xJb2ocX2i2ur70trEpg+nmF3T9M1QDJySfgsZQln9TTweR5gIQqQ2Yvm4uf2w279pQZcPspalVBTmsgYNjuAqM9gCaWYK5xFPKezOXVkldhyC1CZyqN1uhp/sYOZYgzz/U6AzvdDPyc59tHl98Q3zTDw3jShjwo5PiJx/yIZGdrmoRsvwfTKEZingfNs2pai8PlGVaOUqidO+yDwf2A48nEa8GNZtKOhYAiAtEFD7RHN5dGny2xac0uaEVxpThsc4vc3TJATKsWbO4Ohx/sg81aNQN2/OoGaRPiyMCbVaPpSxBalhgusfTQ7T+lHWe+X7MissTJonPTx5aKNCvd4Pp0nGLCc49jJwF5Im8VSZrpIKDOP/8idfC3BRqY6Gyim3v2eFdxccWQFD5ns6BwWUvw2b2E8uMf4aw4HRlSSnuT1hpLfxiuiktzejBliouVaEvE7iwgg5M6IXavID1tSHl35nh+K+zFv9BcKOuvQFK/IA++0eR5GaUIq/bn6pHNTHCaXHbb+1iAOVld184+xfZwVjjot3ITsXNeCukONAcRp5jqwEFWDtd12Lduw5hhBR2k2jxLFy/Az8xT+QZwcoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38100700002)(44832011)(52116002)(38350700002)(6486002)(956004)(508600001)(36756003)(2616005)(6512007)(1076003)(66476007)(66556008)(316002)(66946007)(26005)(6506007)(54906003)(30864003)(186003)(2906002)(86362001)(110136005)(7416002)(4326008)(83380400001)(6666004)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QBWzl6lhN/rTVHlzOrbKfpcx5KjSBaoptNfoWZKkNwUOyufqF598joYbWouo?=
 =?us-ascii?Q?J+M+RYSAsXK+9BVB0omeSwAdbxJFKmoYTUrW97DGpwhH288Sw58izL53WdVv?=
 =?us-ascii?Q?Kz99h+3PdLzgn32wpghWUcLRAd6OJb3o8DLQRmT2vPCAZy/mZyt0hgb7m9jT?=
 =?us-ascii?Q?Je6mU2hvoWY/l0dfIv+SA8J1Al5pErvn+Cr79q4Nkju2OWa8rXlHCmsJVmcZ?=
 =?us-ascii?Q?eMUXDjz9i3NxF1WpjrI3OxdF901WeityLM4z3GRmOLf8+6NAWrkRi6PW3Niv?=
 =?us-ascii?Q?niH0Qxa6ajwOaZRnyMWJJu/dlkZ19iYkLQQ8K92zMNNfEWNlcMtxLRV0Lx9Q?=
 =?us-ascii?Q?9kZFtFqRBjNzltpbQxYEFsvqseP7Ot2G1hmYVov6cmQ+WPcZOJe0/I2nt2Ot?=
 =?us-ascii?Q?xEM1hwdpXE3ZSGQuLVA0z0wg09Oyh8BOe/OAf+iYuY/tpQj890kw3D1gUtxL?=
 =?us-ascii?Q?V4EMYvUl9PTHb1+YHcZCoPeSocrwmMtfY8ueac7ynmQB4490Rbl/KVqeISxs?=
 =?us-ascii?Q?0R3j1602lGXSdlQMhzmA7/37qXHu71YKrgvY7k5b5LQydRLHHU9bKgxZPcOm?=
 =?us-ascii?Q?T3fY9VcJhY336/ijvjjNlKQ/EtN/oVJ4ZaxyUl7iANC93xhKmMMBbkE12djO?=
 =?us-ascii?Q?3GGQqXOqbSumMYqBpsib5yNxsie+xWj1QSDPOexR+Seg2LTOZbz8xiJTsJDR?=
 =?us-ascii?Q?mxfaVmtwr6rF1D7TwipsQatpIPHNTizVh8fdky6RKGJf3IaJXYbsF8QUUeDf?=
 =?us-ascii?Q?pAMibgTrSb/k7ZGGgJKjih+U4zniuv5e3L3UFso/0cUaYBjbupyrY+xPssnT?=
 =?us-ascii?Q?xxJV3lJeD4iIP+AdA/3SANLN+JL+NZVEfFocI/cSfduiq476dvhPGg25EDuK?=
 =?us-ascii?Q?5OoN744bAgbGmQ1tcao+MzDSCZ4arXlHZ+xqLNuS0eJTix85UT7tF0vH8FpG?=
 =?us-ascii?Q?ZO0SQDqnczaqMBtR9H0ab/ALYKcMt3UoMTcXZDhaDnKS872WviRN2hWXcvhu?=
 =?us-ascii?Q?K+AT0siF+YMOmWyJd8GFndykK4NI+DJNsdyQbN7Nt1fI4mqIR/NjvH85cBlC?=
 =?us-ascii?Q?W45JS0YCvtLlrbw0ErGCi/FYWNJegpcPR7LBD3WEyymJlvJ7dBbZKE0FJMT5?=
 =?us-ascii?Q?n9jPWELYBzNOlF8HUMBu6l4AV759d5LRqv1dtlKllx2L+kypjEpzB/ORBwLm?=
 =?us-ascii?Q?pnDWNkY6fXH0DihZv2ovggX0HMXdDtZw6/PZCK96YcekmhFP+ZA9Aof5W0+f?=
 =?us-ascii?Q?GMIOl9LUp2EnUq3P//RryEQpo6wqxSdimpEbzWC4FItFKLHR+3gXGPcO6X0B?=
 =?us-ascii?Q?AferR3LJFxXMaPQoPi6esEpN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fe3740-5e1c-44d4-a2b9-08d94a357ada
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:20.6105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMN8WTSPr6w0l2/4teMWLuJyemNb2m+aj9clnszwTBZWO1dHx8bdkorRnHwzKbW9nSyypFe3KnDdWeZk4+Gr4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a DSA switch, to offload the forwarding process of a bridge device
means to send the packets coming from the software bridge as data plane
packets. This is contrary to everything that DSA has done so far,
because the current taggers only know to send control packets (ones that
target a specific destination port), whereas data plane packets are
supposed to be forwarded according to the FDB lookup, much like packets
ingressing on any regular ingress port. If the FDB lookup process
returns multiple destination ports (flooding, multicast), then
replication is also handled by the switch hardware - the bridge only
sends a single packet and avoids the skb_clone().

DSA plays a substantial role in backing the forwarding offload, and
leaves relatively few things up to the switch driver. In particular, DSA
keeps for each bridge port a zero-based index (the number of the
bridge). Multiple ports enslaved to the same bridge have a pointer to
the same accel_priv structure.

The tagger can check if the packet that is being transmitted on has
skb->offload_fwd_mark = true or not. If it does, it can be sure that the
packet belongs to the data plane of a bridge, further information about
which can be obtained based on dp->bridge_dev and dp->bridge_num.
It can then compose a DSA tag for injecting a data plane packet into
that bridge number.

For the switch driver side, we offer two new dsa_switch_ops methods,
called .port_bridge_fwd_offload_{add,del}, which are modeled after
.port_bridge_{join,leave}.
These methods are provided in case the driver needs to configure the
hardware to treat packets coming from that bridge software interface as
data plane packets. The switchdev <-> bridge interaction happens during
the netdev_master_upper_dev_link() call, so to switch drivers, the
effect is that the .port_bridge_fwd_offload_add() method is called
immediately after .port_bridge_join().

If the bridge number exceeds the number of bridges for which the switch
driver can offload the TX data plane (and this includes the case where
the driver can offload none), DSA falls back to simply returning
tx_fwd_offload = false in the switchdev_bridge_port_offload() call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- signal the offloading capability via switchdev_bridge_port_offload()
- drop "bool bridge_fwd_offload" from the tagger
- drop "struct dsa_bridge_fwd_accel_priv" from struct dsa_port and
  replace it with a simple "int bridge_num"
- drop .crosschip_bridge_fwd_offload_{add,del}()
- drop the DSA_NOTIFIER_BRIDGE_FWD_OFFLOAD_{ADD,DEL} cross-chip notifier
  and call the driver directly on the port
v3->v4:
- use dsa_tree_find_bridge_dev() in the unprepare code path to allow the
  bridge_num to be properly reused when there is no port offloading a
  given bridge anymore
- drop the stray netif_set_real_num_tx_queues() change from v2
- properly call dsa_port_bridge_tx_fwd_unprepare() instead of prepare()
  in dsa_port_pre_bridge_leave()
- fix dp->bridge_num remaining -1 in dsa_port_bridge_tx_fwd_prepare() by
  removing the stray "int bridge_num" declaration which was shadowing
  the variable which had the function-wide scope

 include/net/dsa.h  |  18 ++++++++
 net/dsa/dsa2.c     |   1 +
 net/dsa/dsa_priv.h |   6 +++
 net/dsa/port.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 89626eab92b9..74f559ee517a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -162,6 +162,9 @@ struct dsa_switch_tree {
 
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
+
+	/* Track the bridges with forwarding offload enabled */
+	unsigned long fwd_offloading_bridges;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
@@ -262,6 +265,7 @@ struct dsa_port {
 	bool			vlan_filtering;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
+	int			bridge_num;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -410,6 +414,12 @@ struct dsa_switch {
 	 */
 	unsigned int		num_lag_ids;
 
+	/* Drivers that support bridge forwarding offload should set this to
+	 * the maximum number of bridges spanning the same switch tree that can
+	 * be offloaded.
+	 */
+	unsigned int		num_fwd_offloading_bridges;
+
 	size_t num_ports;
 };
 
@@ -693,6 +703,14 @@ struct dsa_switch_ops {
 				    struct net_device *bridge);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct net_device *bridge);
+	/* Called right after .port_bridge_join() */
+	int	(*port_bridge_fwd_offload_add)(struct dsa_switch *ds, int port,
+					       struct net_device *bridge,
+					       int bridge_num);
+	/* Called right before .port_bridge_leave() */
+	void	(*port_bridge_fwd_offload_del)(struct dsa_switch *ds, int port,
+					       struct net_device *bridge,
+					       int bridge_num);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index de5e93ba2a9d..c7fa85fb3086 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1044,6 +1044,7 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 	dp->ds = ds;
 	dp->index = index;
+	dp->bridge_num = -1;
 
 	INIT_LIST_HEAD(&dp->list);
 	list_add_tail(&dp->list, &dst->ports);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f201c33980bf..28a99a6a59ce 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -14,6 +14,8 @@
 #include <net/dsa.h>
 #include <net/gro_cells.h>
 
+#define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
+
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
@@ -197,6 +199,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
 			      struct netlink_ext_ack *extack);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
+int dsa_port_bridge_fwd_offload_add(struct dsa_port *dp,
+				    struct net_device *br, int bridge_num);
+void dsa_port_bridge_fwd_offload_del(struct dsa_port *dp,
+				     struct net_device *br, int bridge_num);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index fce69cf3f8e3..05072de9ddc0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -230,6 +230,87 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
+static int dsa_tree_find_bridge_num(struct dsa_switch_tree *dst,
+				    struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->bridge_dev == bridge_dev)
+			return dp->bridge_num;
+
+	return -1;
+}
+
+static struct net_device *dsa_tree_find_bridge_dev(struct dsa_switch_tree *dst,
+						   int bridge_num)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->bridge_num == bridge_num)
+			return dp->bridge_dev;
+
+	return NULL;
+}
+
+static void dsa_port_bridge_tx_fwd_unprepare(struct dsa_port *dp,
+					     struct net_device *bridge_dev)
+{
+	int bridge_num = dp->bridge_num;
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_switch_tree *dst;
+
+	dst = ds->dst;
+
+	dp->bridge_num = -1;
+
+	/* Check if the bridge is still in use, otherwise it is time to clean
+	 * it up. Note that we are in the pre_bridge_leave path, so
+	 * dp->bridge_dev is still a valid pointer. We need to search by
+	 * dp->bridge_num instead.
+	 */
+	if (!dsa_tree_find_bridge_dev(dst, bridge_num))
+		clear_bit(bridge_num, &dst->fwd_offloading_bridges);
+
+	/* Notify the chips only once the offload has been deactivated, so
+	 * that they can update their configuration accordingly.
+	 */
+	dsa_port_bridge_fwd_offload_del(dp, bridge_dev, bridge_num);
+}
+
+static bool dsa_port_bridge_tx_fwd_prepare(struct dsa_port *dp,
+					   struct net_device *bridge_dev)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_switch_tree *dst;
+	int bridge_num, err;
+
+	dst = ds->dst;
+
+	bridge_num = dsa_tree_find_bridge_num(dst, bridge_dev);
+	if (bridge_num < 0) {
+		/* First port that offloads TX forwarding for this bridge */
+		bridge_num = find_first_zero_bit(&dst->fwd_offloading_bridges,
+						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		if (bridge_num >= ds->num_fwd_offloading_bridges)
+			return false;
+
+		set_bit(bridge_num, &dst->fwd_offloading_bridges);
+	}
+
+	dp->bridge_num = bridge_num;
+
+	/* Notify the driver */
+	err = dsa_port_bridge_fwd_offload_add(dp, bridge_dev, bridge_num);
+	if (err) {
+		dsa_port_bridge_tx_fwd_unprepare(dp, bridge_dev);
+		return false;
+	}
+
+	return true;
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
@@ -241,6 +322,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
+	bool tx_fwd_offload;
 	int err;
 
 	/* Here the interface is already bridged. Reflect the current
@@ -254,10 +336,12 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_prepare(dp, br);
+
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
-					    false, extack);
+					    tx_fwd_offload, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
@@ -285,6 +369,8 @@ int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct net_device *dev = dp->slave;
 
+	dsa_port_bridge_tx_fwd_unprepare(dp, br);
+
 	return switchdev_bridge_port_unoffload(brport_dev, dev, dp,
 					       &dsa_slave_switchdev_notifier,
 					       &dsa_slave_switchdev_blocking_notifier,
@@ -313,6 +399,29 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_switchdev_unsync_attrs(dp);
 }
 
+int dsa_port_bridge_fwd_offload_add(struct dsa_port *dp,
+				    struct net_device *br, int bridge_num)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_bridge_fwd_offload_add)
+		return -EOPNOTSUPP;
+
+	return ds->ops->port_bridge_fwd_offload_add(ds, dp->index, br,
+						    bridge_num);
+}
+
+void dsa_port_bridge_fwd_offload_del(struct dsa_port *dp,
+				     struct net_device *br, int bridge_num)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_bridge_fwd_offload_del)
+		return;
+
+	ds->ops->port_bridge_fwd_offload_del(ds, dp->index, br, bridge_num);
+}
+
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo)
 {
-- 
2.25.1

