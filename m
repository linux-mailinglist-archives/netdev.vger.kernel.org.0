Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC53D9547
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhG1S2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:28:07 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:42390
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhG1S2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aD+X/+rr8UkYBH46s6jjumWfxjntICeE06e4SD0OpqcDEJnTyvLgzTfLBUuQErHRkYb0NnsFk0gzEUoA/QTNZxaqTHKvCoksZkXRhMqk5QVFsirPPjb6ry45pgcqKsL7AkSoWNyt1ajlxqqmJ1SBcyxMtoC/SpM0RSmtQ7qCjNehn6HtdHKmBDaA0awD78auoFWA0dKZua/PumSLxi2y9fC7ci81uFOGFVnvVwi6jEbzKVOJNpfahoFFoWKMHf+YEGYU2Ou339Sa5yUs0Glk+ORfN/VJkcb3NxPbKeIc/lDhy1n4Re1BdrU7TDzo938PV2idJXGYQzfUQSNOKcjhCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U16KE2U5SQl7ttT4NRu7RC7pVKpSwO9dyEnuVgJWjbU=;
 b=F5OMu+E2m1hA62bOFT7r5lXxj0a5hm2O3d5ewKVeNN+pzFFYYM+zMTR+2VYGWt3udGQz2102MLrUy/WOhxtdGBl5hYho7RmmqiehP1XW8HYcvxsHbK/RLf+WM9ja+BZCXX8EOLQYkRJYD+vZCNfbrtlmzBtONK0umsjl90/Mi8qBLXa+cJW39Fas/dUBgvMzeNlio/p6cwZjONSVBQ1dKd26e61eytNeG2qr4ty7F08yLey/t3z2qP3WJWUfxAI27kIvCVxb+ceajTgdvTCeoet9egn5i+fiwSnIQlAsOVXc9HGYsok6rSfhtrAedbKvPgtKt4MIZFKaaGnVcVOJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U16KE2U5SQl7ttT4NRu7RC7pVKpSwO9dyEnuVgJWjbU=;
 b=UV/x25wM/4n11sAa9f7ZZ0iwQ75v1FL01aqquS/wX7v5Qiq3y4x0giRbXjVUU/lv6gZV5PRfve6J140kd7zAXyIn/aW0Fhp2ihC91weDgSR8FHNiYrRqqwrVAmrLXXdgaUa7hpfimfCv9RYBxAq98cX0PBPEBUGJKHs1WWL+eCw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 18:28:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 18:28:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 1/2] net: bridge: switchdev: replay the entire FDB for each port
Date:   Wed, 28 Jul 2021 21:27:47 +0300
Message-Id: <20210728182748.3564726-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
References: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Wed, 28 Jul 2021 18:28:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9acb023e-e700-431e-e2a0-08d951f56f76
X-MS-TrafficTypeDiagnostic: VI1PR04MB6944:
X-Microsoft-Antispam-PRVS: <VI1PR04MB69446AE46991BA8C44371956E0EA9@VI1PR04MB6944.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vR9DlBbmvUpeKsR0qc9noXKMgqlVURQJNOaHHfqzbi+EUXf9j4UDjHYzxkDQtqrqMzQpn4CzYJ6Sjf2G/5r/7hiypXEGDhnV/Z0q2AvXcSNJJA4zI2nUDKD1LgxIqCgK5SHNiWeYUJ7l4+9Ioa2ZiELRGVyQ9NWByGebKjmEbkHPopoCLXI1RuaU2WUcxsOsHXKOMHBEwXHy+Zc8N15SwpK3/ueGe90KcZFn6575MYIDmYuhSMD163cbm8140XKHDAWAAMGVrcomsIxS//iFqbST0PdqhsZC4OC+9O+j+U/rhThBjtgF48HayhFody9dNqcZWVlfF527bJE6ukGGr46DYt80Ilqm4scCSxG7nfGvpUGNfmrQM6lgbltm1A5t8nFzvS35EDT6dv3AAN9d5GKYkEvet53tazaVUGXGiXT45ncJuzJdFbP1sirNTXZKpWUB+ciVXgGBKM/S4/X2zm6KpPp61e2+qZTfUPZcTWNomYjPzvcCON4sJRRpolTs0bpovckcZFTaDpq/2bOwL1m130SualFAcUm731e5bW22uMclV0+GGopaPHexvMb0Xu+rc2U5fPcVs8RiLK3xUmsEt7CMooZc9AS9b+rudf5DuUjS9rmrkTbKeMcKjaCUlliUNY29jwiZhTTO3QTplSMyBvdE2fw8sM/7xPflXeb6Ke/TEuGYmMBcEMkZVCQViF8oxsQxDmXtaMQMDQqz3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(346002)(136003)(376002)(396003)(5660300002)(8936002)(8676002)(478600001)(1076003)(2906002)(4326008)(36756003)(86362001)(83380400001)(7416002)(6512007)(38100700002)(44832011)(52116002)(38350700002)(66556008)(110136005)(26005)(66476007)(316002)(956004)(6486002)(2616005)(54906003)(66946007)(6666004)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MD8czoekr1RR834UwhUdx7uAhJo8HUii7evs9N8Nn1gR+DmuDssZEwv01tb9?=
 =?us-ascii?Q?1ImB3Uc9UpCJLvNqpNikBH0uel0ggOBE0RLZfWm4ie6ICLXG0e5H97nJCfTi?=
 =?us-ascii?Q?0NQpNeUHNc7PJcONVyvi9qis+8xrR26RqDOGyrMxX8JAk6JwXsirgVwUW4os?=
 =?us-ascii?Q?FxNDUCTZNXbRVpbabd453zqgUNcTK61ID/BQiHBctmUBSlKavuCx9gV2yRjl?=
 =?us-ascii?Q?qjQLEX1hU3oaCSQ0NES7LGfYodDYOXdDB4I9YOYCshotiLLie8kpGjMA2ICa?=
 =?us-ascii?Q?rr75ulxmPiGAIhP/kX/zKMIhuyEsR3+NA29TCdv72NvNcTDwjd0I7CKvvKFu?=
 =?us-ascii?Q?+I9MRHF33+us4J8fu/mIq+xW2ts/p47epQ2OC2w1W5fKC8xB/UdHPIYepFgc?=
 =?us-ascii?Q?7sOmuuBRorn6n87ZdedC7joAby1pQp9OyPXrA1byWBVUoRFJyJJmnZfmgdSh?=
 =?us-ascii?Q?ekm6kJWJNGQJeXAlj+SEFPHE6MLjS9Yxy7oBU7Fw2cirgPYeFMfQH1tJUZdU?=
 =?us-ascii?Q?5H8mzHcgKaE2VFvUn+EzdVvZmzr1x5QhY2H+giBcA9Tuhub4oJWiqAAIwdM/?=
 =?us-ascii?Q?ZwRZ+e0C4kMxKh6fOXI+9M+TfXvZoHvJCDHXii1weVNg0b+r2+GfT+3XA0hG?=
 =?us-ascii?Q?mgRRLfdyBzHq8SRBfVwqCVJNfEguRbVzjEQ+UNZxvmJ0QsrgWujgk7w8wahm?=
 =?us-ascii?Q?utrTfVHVaIFDEz2y63KasqprUI7dltx8dE3glvMhk64yOfVTRILNUXEIPvPB?=
 =?us-ascii?Q?8mUyMCaeywR5/7WwqJrkI6/U3z1TZQgEiA77z+/koH+z96FDuOXZ175lbG1X?=
 =?us-ascii?Q?hbaDk5DWz6wi9GIur1vah+eCjbN4E5VQiW19CSY6IesWPFWKd+YDT8p7ObIO?=
 =?us-ascii?Q?fZZkgnNZ8DSu6wd9MTWv0LE3OaJpsr7jOpgkdfSqBCdQDbNToFVmGBmBgwFI?=
 =?us-ascii?Q?eqMBXaNKGFAxS95X69xfRC67srG2B7jDSYf1LAbSg0ToNNtPyUHe93LqCZOl?=
 =?us-ascii?Q?bF9A9vx1DycDMwrNuy4gZ0qLSt5gbrE1bB862mQGMkDNpMt07XEgdvQlMQGa?=
 =?us-ascii?Q?o6PjKR47jmVeft+NC7xpkCDr6XcMhaJqnf9954lYclTojxmpAJ3/9Q9IUqW7?=
 =?us-ascii?Q?RGbM3hiyry0s4jaOO9FuIjaoKrsrTsimSd/XfKw+32Fqm0/8RnbuwZVTk3ZJ?=
 =?us-ascii?Q?ph3QIekXiXMxm+3fa4r4lTE7x0hM3RYMk79KUQ8ui4r0bfdmAHw5sUztydis?=
 =?us-ascii?Q?dTqZz5lTUraH0/0Ik8LuTa01WISLbusOMu/kmcSIrY0AoHxRU/ZDQpCtBfhw?=
 =?us-ascii?Q?yH6A1leQNgo9saHEK2WoyR3W?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acb023e-e700-431e-e2a0-08d951f56f76
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 18:28:03.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MaN1HCst8eYpBg4QT5Fn6bzkpbSNW/IM7adgTC3cedeZcOqQlnSE5IAx9FtHsOFJ8J6QmRBWXllLWH1rFPEBiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when a switchdev port joins a bridge, we replay all FDB
entries pointing towards that port or towards the bridge.

However, this is insufficient in certain situations:

(a) DSA, through its assisted_learning_on_cpu_port logic, snoops
    dynamically learned FDB entries on foreign interfaces.
    These are FDB entries that are pointing neither towards the newly
    joined switchdev port, nor towards the bridge. So these addresses
    would be missed when joining a bridge where a foreign interface has
    already learned some addresses, and they would also linger on if the
    DSA port leaves the bridge before the foreign interface forgets them.
    None of this happens if we replay the entire FDB when the port joins.

(b) There is a desire to treat local FDB entries on a port (i.e. the
    port's termination MAC address) identically to FDB entries pointing
    towards the bridge itself. More details on the reason behind this in
    the next patch. The point is that this cannot be done given the
    current structure of br_fdb_replay() in this situation:
      ip link set swp0 master br0  # br0 inherits its MAC address from swp0
      ip link set swp1 master br0
    What is desirable is that when swp1 joins the bridge, br_fdb_replay()
    also notifies swp1 of br0's MAC address, but this won't in fact
    happen because the MAC address of br0 does not have fdb->dst == NULL
    (it doesn't point towards the bridge), but it has fdb->dst == swp0.
    So our current logic makes it impossible for that address to be
    replayed. But if we dump the entire FDB instead of just the entries
    with fdb->dst == swp1 and fdb->dst == NULL, then the inherited MAC
    address of br0 will be replayed too, which is what we need.

A natural question arises: say there is an FDB entry to be replayed,
like a MAC address dynamically learned on a foreign interface that
belongs to a bridge where no switchdev port has joined yet. If 10
switchdev ports belonging to the same driver join this bridge, one by
one, won't every port get notified 10 times of the foreign FDB entry,
amounting to a total of 100 notifications for this FDB entry in the
switchdev driver?

Well, yes, but this is where the "void *ctx" argument for br_fdb_replay
is useful: every port of the switchdev driver is notified whenever any
other port requests an FDB replay, but because the replay was initiated
by a different port, its context is different from the initiating port's
context, so it ignores those replays.

So the foreign FDB entry will be installed only 10 times, once per port.
This is done so that the following 4 code paths are always well balanced:
(a) addition of foreign FDB entry is replayed when port joins bridge
(b) deletion of foreign FDB entry is replayed when port leaves bridge
(c) addition of foreign FDB entry is notified to all ports currently in bridge
(c) deletion of foreign FDB entry is notified to all ports currently in bridge

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       | 23 +++++++----------------
 net/bridge/br_private.h   |  4 ++--
 net/bridge/br_switchdev.c | 14 ++------------
 3 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 5b345bb72078..be75889ceeba 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -732,11 +732,12 @@ static inline size_t fdb_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
 }
 
-static int br_fdb_replay_one(struct notifier_block *nb,
+static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 			     const struct net_bridge_fdb_entry *fdb,
-			     struct net_device *dev, unsigned long action,
-			     const void *ctx)
+			     unsigned long action, const void *ctx)
 {
+	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
+	struct net_device *dev = p ? p->dev : br->dev;
 	struct switchdev_notifier_fdb_info item;
 	int err;
 
@@ -752,8 +753,8 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
-int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb)
+int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
+		  struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
@@ -766,9 +767,6 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 	if (!netif_is_bridge_master(br_dev))
 		return -EINVAL;
 
-	if (!netif_is_bridge_port(dev) && !netif_is_bridge_master(dev))
-		return -EINVAL;
-
 	br = netdev_priv(br_dev);
 
 	if (adding)
@@ -779,14 +777,7 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-		struct net_device *dst_dev;
-
-		dst_dev = dst ? dst->dev : br->dev;
-		if (dst_dev && dst_dev != dev)
-			continue;
-
-		err = br_fdb_replay_one(nb, fdb, dst_dev, action, ctx);
+		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
 		if (err)
 			break;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f2d34ea1ea37..c939631428b9 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -777,8 +777,8 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
-int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb);
+int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
+		  struct notifier_block *nb);
 
 /* br_forward.c */
 enum br_pkt_type {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 9cf9ab320c48..8bc3c7fc415f 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -287,13 +287,7 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br_dev, dev, ctx, true, atomic_nb);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br_dev, br_dev, ctx, true, atomic_nb);
+	err = br_fdb_replay(br_dev, ctx, true, atomic_nb);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -312,11 +306,7 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 
 	br_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	/* Forwarding and termination FDB entries on the port */
-	br_fdb_replay(br_dev, dev, ctx, false, atomic_nb);
-
-	/* Termination FDB entries on the bridge itself */
-	br_fdb_replay(br_dev, br_dev, ctx, false, atomic_nb);
+	br_fdb_replay(br_dev, ctx, false, atomic_nb);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.25.1

