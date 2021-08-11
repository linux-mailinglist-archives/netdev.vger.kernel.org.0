Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7B3E92F4
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhHKNqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:46:52 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:23137
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231714AbhHKNqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:46:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm2lZUk6wwdsztDHVy9RUsSKlCT0x+nesNJzpaYhEzXXWw6cjvt38FdbjhMHt5E50df/ex2gE9oBBNL27BBkSYKFw9IDhTSOH8jIbStotxQ1CuRTSlnpG6oLDe3WPM6Xo1d5MAJ7y+5TIf8X5sFmq8U0tNxIKdCquYF/8682cuLY2SW825mw/YqhFGdqOcanqtxJPNhx9TlBU66lAWKuMfanUcH7e/LeJ6eaeHP0sQeKeJco28BGLM7eQKIDbVgfHx4fhfrHuJwwEnwE1jCBuk/p/jDs9tjn/JY9wE16l/9GkvVXZDc4O7E3UDPNBA/Qc6EFohOobRumys0cFuaMWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b97J45kVHJyqqWTO9W8hxWzz8i+Zd6Mu4zCCRX0aBx8=;
 b=Q4F53f7WSktbZpnEeNnFEZmZ0XABkdJC5bbvKaNRnft2QQOK6MglGqU0rDCybuwN7GG/C5Nvtj0Mel9FckgQoXjCQchcoCJxkuYakdiLYVQdGeYRa4xtiK4t4LYiTG7BNBYC9zCRVF0w91hBVPT7hXjPr5vI3FLHfcKPYlHwWTiKFeKDhRxhan2VqaPkQd/stDCjfQX7zNDuI4YIkku+66FXcc86L7PthKJI0iEunwGaargABvpG5wCtX+HGo8ttuSIdNBkGBJGtW0N4q1CtKrUENNon9P9A3GZ+uyBTmPOsaIah8nLFihGUbE3cAOAYdOzPy+BtrDHfpRLFIUkKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b97J45kVHJyqqWTO9W8hxWzz8i+Zd6Mu4zCCRX0aBx8=;
 b=oQZs2rOsPOaN1q1IN32L8RawHUxfcUsDzEoVWD33nQuhnZ6y815tFET8rOzB7Z423e5uACz0ph3CekIJZHl1aDwD3bDlSEJ6QEcgYwzps4f0iqUOi0qcjDU4teE4+XmIUjXksYe8o0/hYRdvl1CXTgoU4hRZO3rGKR447Ht0OTU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Wed, 11 Aug
 2021 13:46:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 13:46:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: tag_8021q: don't broadcast during setup/teardown
Date:   Wed, 11 Aug 2021 16:46:06 +0300
Message-Id: <20210811134606.2777146-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
References: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Wed, 11 Aug 2021 13:46:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e1847a7-211a-48f2-5363-08d95cce65ea
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-Microsoft-Antispam-PRVS: <VI1PR04MB694221085825B210501DBA1FE0F89@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBvqQIruDbqFS/PpZae20eQGhpnEWSNOOuC7LnWkLJHdxRZcenkfPM06YD2OQlb/Bacel3t3oVTwAWfAPNkJDWhcykFeK3/G1x6tJYTFvB/bHde2Kx+1MJuC6rqLPy3gTASGJjJWdF3YAO4F3oYSwgSCAK3nK+eJKZ4ZzjSfD/K/wO6vz6p2CZiFEsW79ZIVJGOG/GzoWIryADLSFgYWfORgIu8pPvgrg/D1VYwtZ72V5+pd/GhY/8UFPCuLX/JhZnK82yvAi0J/LFQyI9ce1vT9Du4Wedf2B5IMFGLZAzA0DHeLqWKq6e9saPmPhdg+ZGQ2Kp6UdikcEdWu09Pkiu1JrAOfJrv7Q7JBX3y5eTrde38Z33cisWGgfddWsgdDajUc0z1wM3R7rHFQZlSt+cF5ZrzXPb5hW4JofXnmvLn2HeRmj/i4LTF9FFJFoCv/2FcDBG3SWojeAJH/BmHXffalDNW031vSEnYz7hGRXqqv3hj1KSYT3CIdc1B9Id37rLM9obO8R/QiC5asHBiHSUyDY8JtJe2nWZCtoglbBIZSbjPpoAmLfLXnWb62Sf7yYwpuKFVDIR23ibzeZ6zlVjd2b31f2o/bkDKC75smWRvbKNT7PDCX4H7x+h0CpaPiRFXYMMfFeA3trpq6cuffZZ7ObIjq6/J+rULB/s1h1h5+hds95X854rk3KE2SbneSwQAg0HOw+hbMVVgzQsc7Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(8936002)(478600001)(54906003)(6486002)(316002)(110136005)(6506007)(186003)(26005)(1076003)(2616005)(956004)(8676002)(66556008)(66476007)(83380400001)(66946007)(4326008)(6666004)(2906002)(52116002)(36756003)(44832011)(86362001)(38350700002)(38100700002)(6512007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hc1jgRU4IlEVfNLJuFmBPueCHktv0tXt6oKfW1jbU0wjrSxrB8PX4po4vZji?=
 =?us-ascii?Q?qHckeqLuvA2oqc877K1AKmuNygIYVQVIJYZYmA+UPMgaxuGBgCeTX0jUoaEj?=
 =?us-ascii?Q?XCKwwR1ey6rrvn/iblNU7dkzcCEoI5UgHD8PflnAqXbKXxn2VKMCuFCj+cC+?=
 =?us-ascii?Q?LnMTmOtfjPS/nGzQcXXbjbhWOGuViP/OWf3nDAXvl6iMyzxAgwYFosHV8ToK?=
 =?us-ascii?Q?0+bzumn7qSM8MxjtMcRUjXh07YI68cjxgRs6KBlp5gSgHel9RxBCuLQYh9NN?=
 =?us-ascii?Q?doQg0CiRU/+tBFUSZ+7JTEazl4FO4EARQZcpo5EK7ncuwyv8tCDnDN3sqe2x?=
 =?us-ascii?Q?5Ip442DXrMXWKaT9dgS5Sja2GURq7YwBYtkoX1TXAUWmf62kD1nznLoXsfG3?=
 =?us-ascii?Q?5TU8+ZGWSjcKTDRYCSTyDLicOu8vxtvW3o1BjeAXLhW5J4CZ46Ber+M4V1d+?=
 =?us-ascii?Q?kWwTW1ggHs9xycic81C2xFtBzo1y/z8DP6aw5ibUvl1/2d6POB1ZlnpN8c2p?=
 =?us-ascii?Q?10HFKC4eOqO0AzhIYbw7Zqf1GOcSV2LPH3nVwxqQM+0Ip75rzFVZ1LkMsF7z?=
 =?us-ascii?Q?mIYwwCdA6tjP5Ti4I/k0u/+YCfR2M0Oos9gKyreHQ07E7bqaYQdTNLaovCZO?=
 =?us-ascii?Q?Rlu8s9ifA8Y5ds6aTfX+fcKvA/2INDBYSTHxqHlrj2jbKiXec/UfHTCutFa+?=
 =?us-ascii?Q?iSFM9VNsQxiCYEygwBDSzK8J7odnbk3iZEYBHV/EKx6upJv4SkWISuAPFIth?=
 =?us-ascii?Q?uOmcOyfsHwUG0gx5GPGoaGWA5gxfW0n6nmPXdkIWZZeijQcSfJx+aMaDVvUd?=
 =?us-ascii?Q?tEJHKXbiUDGBP91LCQL9Z76T/ZGSQrdZ9U1hWc3Rl31M6lreslpalxebOm2X?=
 =?us-ascii?Q?OPzatpgvvhvu7eq+GQ19BgHmVbmG4DdZ9FV1PB0NUhitnPvo6sySxfEdBM8O?=
 =?us-ascii?Q?68jQgsKCem4Oy6Q6AdCu7x/EMXp0g3S0cvXZs/BOY95iEEVh84tvuRvEhyz5?=
 =?us-ascii?Q?btinT58cJIAJ5sgayhGNUVCBObwExMeIpJa/g4h8SbmdS3zxYr69oSze8QDz?=
 =?us-ascii?Q?XNbng0w0nblsgXo2dSeCbkmYfPoVYMiMA/7Uy/BVxkNh2r93DYWYkx+TirvB?=
 =?us-ascii?Q?WiQGuYzIDAjJaaA9ffJl4ih0QptvdiADPBtmslJ+oCPBCueOgEX5aNYtm9x0?=
 =?us-ascii?Q?9aBRmzHTvpX4DO//0yPy4pnrzmAsWihD/OzcG2db8HbnKrlW696GyxntSGHD?=
 =?us-ascii?Q?5C5hWtPJMIMBKn45AciNhPgNBBOksA1m7xJwRYBqQfdayDp6qFtU7lAxpHDl?=
 =?us-ascii?Q?zYn4OO23lUWPfs1GduJO9aIx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1847a7-211a-48f2-5363-08d95cce65ea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 13:46:19.4208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DD4ouV+qQXbdglXACmNdSOj2QAtgAW039yram66JtLm25MC1y4n87RQrh1HIdzPr/oWbkapgFeKCOhXf2JvFRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, on my board with multiple sja1105 switches in disjoint trees
described in commit f66a6a69f97a ("net: dsa: permit cross-chip bridging
between all trees in the system"), rebooting the board triggers the
following benign warnings:

[   12.345566] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 1088 deletion: -ENOENT
[   12.353804] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 2112 deletion: -ENOENT
[   12.362019] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 1089 deletion: -ENOENT
[   12.370246] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 2113 deletion: -ENOENT
[   12.378466] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 1090 deletion: -ENOENT
[   12.386683] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 2114 deletion: -ENOENT

Basically switch 1 calls dsa_tag_8021q_unregister, and switch 1's TX and
RX VLANs cannot be found on switch 2's CPU port.

But why would switch 2 even attempt to delete switch 1's TX and RX
tag_8021q VLANs from its CPU port? Well, because we use dsa_broadcast,
and it is supposed that it had added those VLANs in the first place
(because in dsa_port_tag_8021q_vlan_match, all CPU ports match
regardless of their tree index or switch index).

The two trees probe asynchronously, and when switch 1 probed, it called
dsa_broadcast which did not notify the tree of switch 2, because that
didn't probe yet. But during unbind, switch 2's tree _is_ probed, so it
_is_ notified of the deletion.

Before jumping to introduce a synchronization mechanism between the
probing across disjoint switch trees, let's take a step back and see
whether we _need_ to do that in the first place.

The RX and TX VLANs of switch 1 would be needed on switch 2's CPU port
only if switch 1 and 2 were part of a cross-chip bridge. And
dsa_tag_8021q_bridge_join takes care precisely of that (but if probing
was synchronous, the bridge_join would just end up bumping the VLANs'
refcount, because they are already installed by the setup path).

Since by the time the ports are bridged, all DSA trees are already set
up, and we don't need the tag_8021q VLANs of one switch installed on the
other switches during probe time, the answer is that we don't need to
fix the synchronization issue.

So make the setup and teardown code paths call dsa_port_notify, which
notifies only the local tree, and the bridge code paths call
dsa_broadcast, which let the other trees know as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c      |  3 +++
 net/dsa/dsa_priv.h  |  4 ++--
 net/dsa/port.c      | 14 ++++++++++----
 net/dsa/tag_8021q.c | 21 +++++++++++----------
 4 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8150e16aaa55..dcd67801eca4 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -49,6 +49,9 @@ int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
  * Can be used to notify the switching fabric of events such as cross-chip
  * bridging between disjoint trees (such as islands of tagger-compatible
  * switches bridged by an incompatible middle switch).
+ *
+ * WARNING: this function is not reliable during probe time, because probing
+ * between trees is asynchronous and not all DSA trees might have probed.
  */
 int dsa_broadcast(unsigned long e, void *v)
 {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9575cabd3ec3..d9cc1ffcca10 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -261,8 +261,8 @@ int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
-int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid);
-void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid);
+int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
+void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ee1c6bfcb386..979042a64d1a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1314,7 +1314,7 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
 			dp->index, ERR_PTR(err));
 }
 
-int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid)
+int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
 {
 	struct dsa_notifier_tag_8021q_vlan_info info = {
 		.tree_index = dp->ds->dst->index,
@@ -1323,10 +1323,13 @@ int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid)
 		.vid = vid,
 	};
 
-	return dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
+	if (broadcast)
+		return dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
 }
 
-void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
+void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast)
 {
 	struct dsa_notifier_tag_8021q_vlan_info info = {
 		.tree_index = dp->ds->dst->index,
@@ -1336,7 +1339,10 @@ void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 	};
 	int err;
 
-	err = dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
+	if (broadcast)
+		err = dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
+	else
+		err = dsa_port_notify(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 	if (err)
 		dev_err(dp->ds->dev,
 			"port %d failed to notify tag_8021q VLAN %d deletion: %pe\n",
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 654697ebb6f3..e6d5f3b4fd89 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -362,12 +362,12 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 			continue;
 
 		/* Install the RX VID of the targeted port in our VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid);
+		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid, false);
 		if (err)
 			return err;
 
 		/* Install our RX VID into the targeted port's VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid);
+		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid, false);
 		if (err)
 			return err;
 	}
@@ -398,10 +398,10 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 			continue;
 
 		/* Remove the RX VID of the targeted port from our VLAN table */
-		dsa_port_tag_8021q_vlan_del(dp, targeted_rx_vid);
+		dsa_port_tag_8021q_vlan_del(dp, targeted_rx_vid, true);
 
 		/* Remove our RX VID from the targeted port's VLAN table */
-		dsa_port_tag_8021q_vlan_del(targeted_dp, rx_vid);
+		dsa_port_tag_8021q_vlan_del(targeted_dp, rx_vid, true);
 	}
 
 	return 0;
@@ -413,7 +413,8 @@ int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 {
 	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
-	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid);
+	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid,
+					   true);
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
 
@@ -423,7 +424,7 @@ void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 {
 	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
-	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid);
+	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid, true);
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_unoffload);
 
@@ -450,7 +451,7 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	 * L2 forwarding rules still take precedence when there are no VLAN
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
-	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid);
+	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid, true);
 	if (err) {
 		dev_err(ds->dev,
 			"Failed to apply RX VID %d to port %d: %pe\n",
@@ -462,7 +463,7 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	vlan_vid_add(master, ctx->proto, rx_vid);
 
 	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid);
+	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid, true);
 	if (err) {
 		dev_err(ds->dev,
 			"Failed to apply TX VID %d on port %d: %pe\n",
@@ -489,11 +490,11 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 
 	master = dp->cpu_dp->master;
 
-	dsa_port_tag_8021q_vlan_del(dp, rx_vid);
+	dsa_port_tag_8021q_vlan_del(dp, rx_vid, false);
 
 	vlan_vid_del(master, ctx->proto, rx_vid);
 
-	dsa_port_tag_8021q_vlan_del(dp, tx_vid);
+	dsa_port_tag_8021q_vlan_del(dp, tx_vid, false);
 }
 
 static int dsa_tag_8021q_setup(struct dsa_switch *ds)
-- 
2.25.1

