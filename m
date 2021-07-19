Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717453CE87E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351144AbhGSQlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:41:55 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:25006
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355210AbhGSQgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhHeqeOoT4ForMjr+ySiX0W6IQtDXqGymxC/AT6vy7WJ2tA0E8yQEBKpeWeaq28UmUzu8H2BaTSmn06S+GdrgETFBCGpFQVJY7jF2ppPyS3huDjBZfeoTzc+8253ogopfA52ID/40vUTzmt49vpXyLi2NbUzWSfkHDT5ur0ylJTZVPrM/NBW2PqsdHPmJv79tc9CcLaCnepq5GfLjajiQfUjiXGm1zvQOS4Y8fVTKL5Jg1iQ7l/CmMBUYleiPpbAesxKtQE15DWPTCm/c6i/xZHfsblnENEDlJAKGydZGK21vwm14gkKw8cXLSXoeDHjLdszE+oBTdVP5mwtpCdm/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4MYLY7D0KitytZZulKcckN7CIJ5cnYG2d/lPjXl2Ms=;
 b=KSZwc6tFsVNjeb85YFfj9W4oQLoJxsIUV2yjHbcQChIwdJ6vOv9BPS1IzB2BIzeGMIte6/xQlJXQFDDoz10y9xLRXR9hwRJSPIc5g4wTWm4eyoQ3J5qqUBXa540C9oiD1G4TvDGvSs64S3745j9wDhdtJtdQnlvug8Ko7JDbPk6kOx0zf9CyIxZ6CLAQJM9tEJJ3Ztc+xEuRY6M+efgAfo5/tXcHTFrXDW5OPZwyXlBo/fIrfKXPcfOgSRpYgEQwEQZ48caKlGnUrUwSlvDAeZsBC+Sps1Rh3zE1IZBOWwsJqtfOwQ5TL0pJ5metCQoLgwXKVKhA4YD4aM60H/xEXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4MYLY7D0KitytZZulKcckN7CIJ5cnYG2d/lPjXl2Ms=;
 b=S2HwJIDW8XCJMLlrBXa8GtAlxpZ/zoajQAGoBkHbHHN0IHLwJ5etxYhZYjx5Xw6ymMXkVa2+bMtD2QFh31iT2Gob6O3vqJ3KLU1MLc4p66IVYEcSk7DFpFGoPsjUR2PEqJbI3Wb4stgswHNEn7aGCiRiZBMEUwZ9R5E2RpR/FNc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 10/11] net: dsa: tag_8021q: manage RX VLANs dynamically at bridge join/leave time
Date:   Mon, 19 Jul 2021 20:14:51 +0300
Message-Id: <20210719171452.463775-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83820bdf-113d-4d0a-9fc1-08d94ad8e918
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407225E382A08BF3F61A241E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WuZ1O2jGF4U4lFytKvB9PNYFFa+M/KTfcNvaZrS35rjvOKxfzyguI4YPUnKbEkjuZtURA8Eje8mVUdMoq7C6d0Tm4/d0YpyNyT0Ny6s5mMp/1BQNIArb9hTINZJm3HSFv0QotJtK42gltqClVNvzr5G/9VbQV5JPr9RQTdZcLZkpAcLgEvB1Y9sDVU5QZtYENGDC8NgWUnv17DS194OT+s8+nn08Gy7iB80p3RFFI4vtfKhz0NS7gPXTOs3oVBFL3iFX5ORqLikfoCZvxwHDC/AvGoXqKTSQTIyuYQRWCaGz0v99nx5Qx9WcCwEKbpfFi40lsmQdaN514edtmfQKl6NkIKOXJ1r+feHkrXyctB4N2KjiOkNEGTKkmJ6sKlObRHP5NS2szxA/o/oI9JW3clm+QcbAGMZmSkrgQ+s7mD35XT6x+lOMBfZzWAA2wb7RpzqmZpU/qoCnr2DSAxWv//WYlgnPJyL97gcV1mozwaQQM++1/b9tDXTxR+BPJmMMOBnAb1Yr8VXChNgLMmsIsdEaYtbGqy2q5U7cMV7jec8X7Z19ROGKMSl6xYt3W1UA+yd7YKJZ9i5IGKGNgVCU97w1ZnrbFtOCkDEhAr3mK4zhBTUSBhHPdXXTg+fZJ0yZM9Wl1J5gug8oggfJS8qiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(30864003)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NBKF8p12u9NhWQlBhZucN74MaHvqN28IwnEKOCAnCrl3dS3Ll8x1vZ+0vpSI?=
 =?us-ascii?Q?C6BSxlfiBma8JKELAi2f511NelB0L5TDWVmXwZg5lYZcfn7AKSUsZY8LXMYW?=
 =?us-ascii?Q?PB1ULpG0phhuMcOAE40tWB511g5fuHfRLexKn1xsAvJGgZnTUtZtczA042lP?=
 =?us-ascii?Q?qXHWS4hOPJMgHHa+Pkk/UKz7FDTT11iXMIF9fRg/MyE3WTBxGEy/J3uRsIl/?=
 =?us-ascii?Q?4vqVP92apBmGXelQHbkrSTII+v8hprBxd4tjqKVNYPw/WkbWakNg/EVHvJbR?=
 =?us-ascii?Q?xdC204m/cMi0npipNDqKx6PFGKl7OefC0bXO53ph3ptI1rOpPJZCjP0Fkgu0?=
 =?us-ascii?Q?Q7ryGBh+4yDX26ipQocM404fZY2sAzLbEcW8Rye/Cp0xr8khH7KbeIZxn15/?=
 =?us-ascii?Q?F7Cds1CE8oJxi0ci4jdA3H9peu3FR2+7Ks/ManGU8ONRFghWatXMmRH+2qsF?=
 =?us-ascii?Q?aVVpUArCowWAFHI25EQwoj8MipIn/vZHAamvchOt6QRQ2bDwn1e28Zs6W2i1?=
 =?us-ascii?Q?n2ZcsRHFqwTxqj1iInrwQRPS6t3kK/JiL6WXPMx7qjdC77Erq61SUrqhF0nx?=
 =?us-ascii?Q?IY5UpCQaILEmjqiOctcCAfmM6rCN+YTSMOHCnyY/k/sAz3YK/POfxJvUv/Tw?=
 =?us-ascii?Q?CrNm32KeHrttXi6HcdljTboZfBf9T9JVnKW/2reJ7bc7TqRsKRKp1GMCcgTx?=
 =?us-ascii?Q?6v6BvsxqVHfJkg+xB3G0qD1+8xhhytsavect7iodM11o0GX6AXzKY86m1wmn?=
 =?us-ascii?Q?jp/OoW9l2Sb8qjz4lkOXOOtLhFaeam1qfB0ByWYxnweRdpohLdHFgC1GJYdr?=
 =?us-ascii?Q?FiY6S+j4LSc1Exfi0RNHVtuw6iQXgA4stfoDU3ntNajKpXTNf3VkCJkMXVkE?=
 =?us-ascii?Q?DmnljVjLPlUEJSGFnoGACmmoA2b5dsg26DgV/oN7YVVYtzNHbdA7prKHPU37?=
 =?us-ascii?Q?VllKBTQ2+tmr8jHWjdYYY4zvJBQHF/jTebqlv02swOd4kT6gedOjsgwmbKrV?=
 =?us-ascii?Q?DG1DlcTt6VNI0vpd0+HQso2LH9nH8B8tp9vCfZMLS5RAvUyNJbq1yUYIPZz8?=
 =?us-ascii?Q?5pAxwFlhLWozKIFuQv4cVB4rEUSNSzEk0iGTbbV4uFj8FrAICH5d5GngUwTA?=
 =?us-ascii?Q?6UPenZ/CWAk2e4tY6MYio8gdA7rmT4t3aEhflu3CejN8UwpT1yp665lsd0es?=
 =?us-ascii?Q?7CeSVL0gRLUJZb2udBefPDJC1r7ZeW4c0+dwrXQHQj1tYLIs9OP+pTk5F72Q?=
 =?us-ascii?Q?4DqELHd7aRLVBZm+PjWy/8qyfvlUEeND8BC/1GyYe28yhTZPLvy7Ay8PVTjA?=
 =?us-ascii?Q?AyPIzD7fZqh8yS+naQBOEwml?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83820bdf-113d-4d0a-9fc1-08d94ad8e918
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:13.5561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ic1cmQLb5/RvwcAiS8b/wnvvta9dncz3EO2NE9dFk6WQHwx1J1CC+eBlywbDTuRzk6z8ToSMG6BDzOuQjkwJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been at least one wasted opportunity for tag_8021q to be used
by a driver:

https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-3-kurt@linutronix.de/#2484272

because of a design decision: the declared purpose of tag_8021q is to
offer source port/switch identification for a tagging driver for packets
coming from a switch with no hardware DSA tagging support. It is not
intended to provide VLAN-based port isolation, because its first user,
sja1105, had another mechanism for bridging domain isolation, the L2
Forwarding Table. So even if 2 ports are in the same VLAN but they are
separated via the L2 Forwarding Table, they will not communicate with
one another. The L2 Forwarding Table is managed by the
sja1105_bridge_join() and sja1105_bridge_leave() methods.

As a consequence, today tag_8021q does not bother too much with hooking
into .port_bridge_join() and .port_bridge_leave() because that would
introduce yet another degree of freedom, it just iterates statically
through all ports of a switch and adds the RX VLAN of one port to all
the others. In this way, whenever .port_bridge_join() is called,
bridging will magically work because the RX VLANs are already installed
everywhere they need to be.

This is not to say that the reason for the change in this patch is to
satisfy the hellcreek and similar use cases, that is merely a nice side
effect. Instead it is to make sja1105 cross-chip links work properly
over a DSA link.

For context, sja1105 today supports a degenerate form of cross-chip
bridging, where the switches are interconnected through their CPU ports
("disjoint trees" topology). There is some code which has been
generalized into dsa_8021q_crosschip_link_{add,del}, but it is not
enough, and frankly it is impossible to build upon that.
Real multi-switch DSA trees, like daisy chains or H trees, which have
actual DSA links, do not work.

The problem is that sja1105 is unlike mv88e6xxx, and does not have a PVT
for cross-chip bridging, which is a table by which the local switch can
select the forwarding domain for packets from a certain ingress switch
ID and source port. The sja1105 switches cannot parse their own DSA
tags, because, well, they don't really have support for DSA tags, it's
all VLANs.

So to make something like cross-chip bridging between sw0p0 and sw1p0 to
work over the sw0p3/sw1p3 DSA link to work with sja1105 in the topology
below:

                         |                                  |
    sw0p0     sw0p1     sw0p2     sw0p3          sw1p3     sw1p2     sw1p1     sw1p0
 [  user ] [  user ] [  cpu  ] [  dsa  ] ---- [  dsa  ] [  cpu  ] [  user ] [  user ]

we need to ask ourselves 2 questions:

(1) how should the L2 Forwarding Table be managed?
(2) how should the VLAN Lookup Table be managed?

i.e. what should prevent packets from going to unwanted ports?

Since as mentioned, there is no PVT, the L2 Forwarding Table only
contains forwarding rules for local ports. So we can say "all user ports
are allowed to forward to all CPU ports and all DSA links".

If we allow forwarding to DSA links unconditionally, this means we must
prevent forwarding using the VLAN Lookup Table. This is in fact
asymmetric with what we do for tag_8021q on ports local to the same
switch, and it matters because now that we are making tag_8021q a core
DSA feature, we need to hook into .crosschip_bridge_join() to add/remove
the tag_8021q VLANs. So for symmetry it makes sense to manage the VLANs
for local forwarding in the same way as cross-chip forwarding.

Note that there is a very precise reason why tag_8021q hooks into
dsa_switch_bridge_join() which acts at the cross-chip notifier level,
and not at a higher level such as dsa_port_bridge_join(). We need to
install the RX VLAN of the newly joining port into the VLAN table of all
the existing ports across the tree that are part of the same bridge, and
the notifier already does the iteration through the switches for us.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h  |   6 ++
 net/dsa/switch.c    |  24 +++++---
 net/dsa/tag_8021q.c | 134 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 126 insertions(+), 38 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f201c33980bf..28c4d1107b6d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -386,6 +386,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
 
+/* tag_8021q.c */
+int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
+			      struct dsa_notifier_bridge_info *info);
+int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
+			       struct dsa_notifier_bridge_info *info);
+
 extern struct list_head dsa_tree_list;
 
 #endif
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 5ece05dfd8f2..38560de99b80 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -90,18 +90,25 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 				  struct dsa_notifier_bridge_info *info)
 {
 	struct dsa_switch_tree *dst = ds->dst;
+	int err;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_join)
-		return ds->ops->port_bridge_join(ds, info->port, info->br);
+	    ds->ops->port_bridge_join) {
+		err = ds->ops->port_bridge_join(ds, info->port, info->br);
+		if (err)
+			return err;
+	}
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_join)
-		return ds->ops->crosschip_bridge_join(ds, info->tree_index,
-						      info->sw_index,
-						      info->port, info->br);
+	    ds->ops->crosschip_bridge_join) {
+		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
+						     info->sw_index,
+						     info->port, info->br);
+		if (err)
+			return err;
+	}
 
-	return 0;
+	return dsa_tag_8021q_bridge_join(ds, info);
 }
 
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
@@ -151,7 +158,8 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 		if (err && err != EOPNOTSUPP)
 			return err;
 	}
-	return 0;
+
+	return dsa_tag_8021q_bridge_leave(ds, info);
 }
 
 /* Matches for all upstream-facing ports (the CPU port and all upstream-facing
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 9785c8497039..0946169033a5 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -137,12 +137,6 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
  *    force all switched traffic to pass through the CPU. So we must also make
  *    the other front-panel ports members of this VID we're adding, albeit
  *    we're not making it their PVID (they'll still have their own).
- *    By the way - just because we're installing the same VID in multiple
- *    switch ports doesn't mean that they'll start to talk to one another, even
- *    while not bridged: the final forwarding decision is still an AND between
- *    the L2 forwarding information (which is limiting forwarding in this case)
- *    and the VLAN-based restrictions (of which there are none in this case,
- *    since all ports are members).
  *  - On TX (ingress from CPU and towards network) we are faced with a problem.
  *    If we were to tag traffic (from within DSA) with the port's pvid, all
  *    would be well, assuming the switch ports were standalone. Frames would
@@ -156,9 +150,10 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
  *    a member of the VID we're tagging the traffic with - the desired one.
  *
  * So at the end, each front-panel port will have one RX VID (also the PVID),
- * the RX VID of all other front-panel ports, and one TX VID. Whereas the CPU
- * port will have the RX and TX VIDs of all front-panel ports, and on top of
- * that, is also tagged-input and tagged-output (VLAN trunk).
+ * the RX VID of all other front-panel ports that are in the same bridge, and
+ * one TX VID. Whereas the CPU port will have the RX and TX VIDs of all
+ * front-panel ports, and on top of that, is also tagged-input and
+ * tagged-output (VLAN trunk).
  *
  *               CPU port                               CPU port
  * +-------------+-----+-------------+    +-------------+-----+-------------+
@@ -176,6 +171,98 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
+static bool dsa_tag_8021q_bridge_match(struct dsa_switch *ds, int port,
+				       struct dsa_notifier_bridge_info *info)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+
+	/* Don't match on self */
+	if (ds->dst->index == info->tree_index &&
+	    ds->index == info->sw_index &&
+	    port == info->port)
+		return false;
+
+	if (dsa_port_is_user(dp))
+		return dp->bridge_dev == info->br;
+
+	return false;
+}
+
+int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
+			      struct dsa_notifier_bridge_info *info)
+{
+	struct dsa_switch *targeted_ds;
+	u16 targeted_rx_vid;
+	int err, port;
+
+	if (!ds->tag_8021q_ctx)
+		return 0;
+
+	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
+	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+
+		if (!dsa_tag_8021q_bridge_match(ds, port, info))
+			continue;
+
+		/* Install the RX VID of the targeted port in our VLAN table */
+		err = dsa_8021q_vid_apply(ds, port, targeted_rx_vid,
+					  BRIDGE_VLAN_INFO_UNTAGGED, true);
+		if (err)
+			return err;
+
+		/* Install our RX VID into the targeted port's VLAN table */
+		err = dsa_8021q_vid_apply(targeted_ds, info->port, rx_vid,
+					  BRIDGE_VLAN_INFO_UNTAGGED, true);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
+			       struct dsa_notifier_bridge_info *info)
+{
+	struct dsa_switch *targeted_ds;
+	u16 targeted_rx_vid;
+	int err, port;
+
+	if (!ds->tag_8021q_ctx)
+		return 0;
+
+	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
+	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+
+		if (!dsa_tag_8021q_bridge_match(ds, port, info))
+			continue;
+
+		/* Remove the RX VID of the targeted port from our VLAN table */
+		err = dsa_8021q_vid_apply(ds, port, targeted_rx_vid,
+					  BRIDGE_VLAN_INFO_UNTAGGED, false);
+		if (err)
+			dev_err(ds->dev,
+				"port %d failed to delete tag_8021q VLAN: %pe\n",
+				port, ERR_PTR(err));
+
+		/* Remove our RX VID from the targeted port's VLAN table */
+		err = dsa_8021q_vid_apply(targeted_ds, info->port, rx_vid,
+					  BRIDGE_VLAN_INFO_UNTAGGED, false);
+		if (err)
+			dev_err(targeted_ds->dev,
+				"port %d failed to delete tag_8021q VLAN: %pe\n",
+				info->port, ERR_PTR(err));
+	}
+
+	return 0;
+}
+
+/* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
 static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
@@ -183,7 +270,7 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
 	struct net_device *master;
-	int i, err;
+	int err;
 
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
@@ -198,26 +285,13 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	 * L2 forwarding rules still take precedence when there are no VLAN
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
-	for (i = 0; i < ds->num_ports; i++) {
-		u16 flags;
-
-		if (i == upstream)
-			continue;
-		else if (i == port)
-			/* The RX VID is pvid on this port */
-			flags = BRIDGE_VLAN_INFO_UNTAGGED |
-				BRIDGE_VLAN_INFO_PVID;
-		else
-			/* The RX VID is a regular VLAN on all others */
-			flags = BRIDGE_VLAN_INFO_UNTAGGED;
-
-		err = dsa_8021q_vid_apply(ds, i, rx_vid, flags, enabled);
-		if (err) {
-			dev_err(ds->dev,
-				"Failed to apply RX VID %d to port %d: %pe\n",
-				rx_vid, port, ERR_PTR(err));
-			return err;
-		}
+	err = dsa_8021q_vid_apply(ds, port, rx_vid, BRIDGE_VLAN_INFO_UNTAGGED |
+				  BRIDGE_VLAN_INFO_PVID, enabled);
+	if (err) {
+		dev_err(ds->dev,
+			"Failed to apply RX VID %d to port %d: %pe\n",
+			rx_vid, port, ERR_PTR(err));
+		return err;
 	}
 
 	/* CPU port needs to see this port's RX VID
-- 
2.25.1

