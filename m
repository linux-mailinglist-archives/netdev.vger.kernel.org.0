Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8155043CE9E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhJ0QYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:24:02 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57505
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232596AbhJ0QYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:24:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fetVNfS/WHbMRNFnTAqYVBIb1TdamUSw9r+v0MoEfkGY6wmI9pVRtkVYtpuY/JyT8x7PMk8P/W9sbNctFo4sTJDDyqxYg0+aMSzexyn4nDMy4CzeVOaClLaNarX9fYjj37tVSVfxaiygbxbfI3PlICyf4PMUASfY2Lssr1mF253ZAS134DjjsyEe3GFiROIkTE0ZgjSLgMYeLmyzDde050B9C8w7SVT8nUqp0DslZdW/X4y6AjFlWuob5pZbarbySH6W9obqmCb9YlNKr95hLspyLrQF0o1l1eyciZ01CfoAlLwjups9vyYUF3vF7Vh5iS3bJkBrhnPGdmC4mIRP5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haA6AJfx3SclTSlo3elnMRoU7Uo32t2wpYGmAYVmnLk=;
 b=OesEd/NEDTNXn4VafSxAbqGp/5fsLQ/AxwfAwwt+ETi8F2y1q192BgdQWuG601nAuVzzUi9rHrFzpq96k2uYHxlSOIVg0u7W0yeqAjZtgdSzPp2WpHsJh8p8owElMySL/vOkgcTP38iffsP+tDJl00gFrJhgJK2h7OFhxS+3TXL0XM+zUjMqyCLlT4x8D8MukHnAohgsqaPXOtpMv0C/0v1Di9yoeaYUB8RoaQM+bE5G2/Cg1/Yq6D0XaLrehty3GSaL1K8FW7do2YNB1JLeBk7YIRIzCYvylwMl6JDPc6DNRExGeIbOd+mY9pcAGsTuwnbLBmCRkzEbiRdRu8iWeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haA6AJfx3SclTSlo3elnMRoU7Uo32t2wpYGmAYVmnLk=;
 b=F/Yv4Nt9EucTy7oshAk0cguG58fS+Z7aagtXnU8qR+FB0WEi+LKZ4wWp7KKuxCOnpXriE6RQzdMLq5u/SOIPZ0KtZRm0thp+eQUlsgmaaxqh4ohVU9NAVZlw3lSc++M4ky5RLldDwzRdSWUDZ3KTUEPfbN2H2J1p8AtsRiGcwjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:21:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:21:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] net: bridge: move br_vlan_replay to br_switchdev.c
Date:   Wed, 27 Oct 2021 19:21:16 +0300
Message-Id: <20211027162119.2496321-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0057.eurprd05.prod.outlook.com
 (2603:10a6:200:68::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM4PR0501CA0057.eurprd05.prod.outlook.com (2603:10a6:200:68::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:21:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b25e1460-b561-492f-1aa4-08d99965d638
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60145802B24AD167E443A5C8E0859@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: inhdKqkrdN5pxcDLKjHzYGxaSZ4sxt7wbjd7PQL2K869GzWQieWr6nJYgte58KtU1rLWAjERuL6dUp4o9gjNuWUXAGJRno0oyQVHxtUq8bk31uUmZu1Oy7X8aOdiKyx335BxGbYvzJRLm6el2LD/AErK4ih2sodfYG7hIvVealGpHrv92gOKGvWd5LjabY+Gq6YDE+dCLrKhZVj/ZqTS/11HV3VA1cFwkaDGq+FCIJsfPKz895X0gSKIAEZfGD1y0FJSO6GUqV1vv3vVXkp61L+1HqWQ8o6dUz23vYSnKHTdN+dWPzMinnAArAgIVcHaSG/jqlRC7Dg2PYSyH3au5MnkL4MaLBOqMWn0DrengoRFjXyqOOmO92jqkPHbDi30YcrdO1SFFM7WAg/x9JBH/6k6rX6dTSjsCaloys8xwqhQiX2YcxnxUnzYNlIXeIlW6CoeSyEF6lw6FnEVmyYl/ABtg7TN+adWJsz6fedYTBV28JC4Jh7hGi9ZBprdSGWxv6xletwV9JvYGNwHCcvf2kAp44hmKSNXNZoLglRJyCcwxR7eCxygoIp4q1Ua8P+YWkujUyJ+fVXrrzYnhS8zgfjClNd15fNVsZOaEzGASiDVdMC9RH6xdajF5cTDYrUQtwANSD+o9M6GNhZNxn2C8qa/L0rV51HbqZmv8iCaka+jFHZ19v/8pJxnnzuVzge5a3QMssYCShl4rLKxBMLCrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(52116002)(6506007)(2616005)(316002)(86362001)(6512007)(83380400001)(508600001)(26005)(6916009)(4326008)(8676002)(66556008)(66946007)(5660300002)(8936002)(186003)(38100700002)(36756003)(54906003)(2906002)(38350700002)(6486002)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b7qPgVQgon+CnapXILxdrOxnfLFOHSaaXtgrmWI12CyfLbm8HaEJJTD6KaPF?=
 =?us-ascii?Q?lud/NX4BlWqwGLwXIi6KuSn1Ty99KvcKA+nj7XMwygT2sFc4FgTvsk2jXg/c?=
 =?us-ascii?Q?ewIbSMj42FfAfuYDTKqsOxCXI0vZjlZULt8P3D8RoF8alFkU4gZgDAg2+pBu?=
 =?us-ascii?Q?+l9DKApHWXiZSr3EQ510JkOmJUUkyMprA5B91G3M/kUCz5JTGRkOvAHoWkYW?=
 =?us-ascii?Q?SFGalcV3UwAWD+lW9tA6jLz0mdk+hw1Z7cIOk7AvbruDWwyNm29eoREgq0rU?=
 =?us-ascii?Q?4XGXU8Hd/V2HFfxGmzlTwE7I3or6ZVEUe9wJx9L6Qc6hBWhYwYUWcKjVjCFV?=
 =?us-ascii?Q?rwGiQykIpJ6bds7SxKZIz2zYxIIqtdDHoIYgYM0wo9I+5FutFO6aBBofdAyL?=
 =?us-ascii?Q?bm71GaAD/RbnADKLU8gs+RYkiW7j4EGfqmhz/G/mPQJBuldB3UQbrFGrFO8V?=
 =?us-ascii?Q?BCHMseSAQ1OerMA5iOTh02lyrRAuL73PtL87uUnAHelHvpZV0Z1k/AIIndYn?=
 =?us-ascii?Q?cg9dPtbNmzUIUzO//mJi3ER4Xnf6050gDLNQDW3rzpmAB6yn/rotttTjJOoF?=
 =?us-ascii?Q?exOBiSVL2Js03GqoQBLSWZzNQkr2xbzei84xCKrRVlBRWVt1nZJqZhFtpct8?=
 =?us-ascii?Q?GikvGr3AK35sH+PRQ7cu3s6rRPq4OSfcHKu4GJvmu/RsuMxdaAfxqqL+i+y3?=
 =?us-ascii?Q?gumqybvnIIhNG6hrssRZO/5qOl3O8cNH5KhuapZiZQGBYxsxn+XHXH/8cmbL?=
 =?us-ascii?Q?iiEaK4dg4t9g+K/xPb28aNg7ODEP3ERk/hRX7B/whVSGp5C1G0eLdrAvVLM3?=
 =?us-ascii?Q?wEIYJTjz86iacSoGulf+BcfM4VPz8KiXjQOzSt9UKAS0bh1gbq2L24iyRC8t?=
 =?us-ascii?Q?Lh2Ko2D8GWaG+JI5rARZ2YxCXyZ5zPuhb3lBxjKqa2X7Y6ZL/o82qOEGYx7S?=
 =?us-ascii?Q?GP+ak4Z+58L4Bztb277ATEUPRy5aEqP99Qg49QjOM87uILhaOrwMhjt7fOai?=
 =?us-ascii?Q?oaAeUytYYySIM1i3eDDRN6TpAlUO6XCiqtzVbb4NTilB6yl2Kzg3OqpeKKOG?=
 =?us-ascii?Q?FCH4oLkpyf1bkuxR712TyRrvtYHMYQl+yMP3OUghmgLg1RbOeFGl3HiXKbzA?=
 =?us-ascii?Q?Y5rcHWtxmZXHfCf9A/MITEfhXbIeOPjzZ30jKzioxnBU7WGO3kxvsAxItKsJ?=
 =?us-ascii?Q?1MXte2cXD7CRgRWqdhv/qcixHWOHhl4uUlX+kWLYLZ82o9zs6eZl11XUWe1F?=
 =?us-ascii?Q?Cq1TbzHtVRKlAJpXulZroyNenvyt+h6bscDjlMAyzlVgJw6rfQgcF/LYXAfP?=
 =?us-ascii?Q?WgecKSsygrPg4Em+hRdzQ/6P123HXAZn+P0ZSz4MyaKxbhZpo3HF51s4+3Cj?=
 =?us-ascii?Q?B+4VQHDICulr1a2pyM59eXHerwHAlxlv4Lq6Nthy0pOuPvv3u4wZSTg7GdDQ?=
 =?us-ascii?Q?7tIsCQHFY/0jBdKVbjBLxJ78YaLTxQkAFiuY4EsyKKbAFB3MwSdp4Hjh/MOO?=
 =?us-ascii?Q?eBOMwaCL4vAP1vrKfCNolyqHpE7SbALTxtIdQkps9tqTFrorMB82OetpVZ03?=
 =?us-ascii?Q?EavaLCxYuOoXXF8gQWDRKRCcMXb2u1EJJdeDJuHP9TlaRI4yydXzoJudjxv/?=
 =?us-ascii?Q?NQpubzh04ltpA5+aFSivfso=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25e1460-b561-492f-1aa4-08d99965d638
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:21:31.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7iokIxt0DF5AXaliV6ianqoCkAYkZDkTg67qnzVqHrsn8zBOyexLAFTEaVT8dy1L2CdT2ABvmjYPB9Pgoh97A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_vlan_replay() is relevant only if CONFIG_NET_SWITCHDEV is enabled, so
move it to br_switchdev.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_private.h   | 10 -----
 net/bridge/br_switchdev.c | 85 +++++++++++++++++++++++++++++++++++++++
 net/bridge/br_vlan.c      | 84 --------------------------------------
 3 files changed, 85 insertions(+), 94 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cc31c3fe1e02..b16c83e10356 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1459,9 +1459,6 @@ void br_vlan_notify(const struct net_bridge *br,
 		    const struct net_bridge_port *p,
 		    u16 vid, u16 vid_range,
 		    int cmd);
-int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, bool adding, struct notifier_block *nb,
-		   struct netlink_ext_ack *extack);
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
@@ -1713,13 +1710,6 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
 	return 0;
 }
 
-static inline int br_vlan_replay(struct net_device *br_dev,
-				 struct net_device *dev, const void *ctx,
-				 bool adding, struct notifier_block *nb,
-				 struct netlink_ext_ack *extack)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 /* br_vlan_options.c */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 2fbe881cdfe2..d773d819a867 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -327,6 +327,91 @@ static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 	return err;
 }
 
+static int br_vlan_replay_one(struct notifier_block *nb,
+			      struct net_device *dev,
+			      struct switchdev_obj_port_vlan *vlan,
+			      const void *ctx, unsigned long action,
+			      struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_obj_info obj_info = {
+		.info = {
+			.dev = dev,
+			.extack = extack,
+			.ctx = ctx,
+		},
+		.obj = &vlan->obj,
+	};
+	int err;
+
+	err = nb->notifier_call(nb, action, &obj_info);
+	return notifier_to_errno(err);
+}
+
+static int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
+			  const void *ctx, bool adding,
+			  struct notifier_block *nb,
+			  struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	struct net_bridge_port *p;
+	struct net_bridge *br;
+	unsigned long action;
+	int err = 0;
+	u16 pvid;
+
+	ASSERT_RTNL();
+
+	if (!nb)
+		return 0;
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	if (netif_is_bridge_master(dev)) {
+		br = netdev_priv(dev);
+		vg = br_vlan_group(br);
+		p = NULL;
+	} else {
+		p = br_port_get_rtnl(dev);
+		if (WARN_ON(!p))
+			return -EINVAL;
+		vg = nbp_vlan_group(p);
+		br = p->br;
+	}
+
+	if (!vg)
+		return 0;
+
+	if (adding)
+		action = SWITCHDEV_PORT_OBJ_ADD;
+	else
+		action = SWITCHDEV_PORT_OBJ_DEL;
+
+	pvid = br_get_pvid(vg);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		struct switchdev_obj_port_vlan vlan = {
+			.obj.orig_dev = dev,
+			.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+			.flags = br_vlan_flags(v, pvid),
+			.vid = v->vid,
+		};
+
+		if (!br_vlan_should_use(v))
+			continue;
+
+		err = br_vlan_replay_one(nb, dev, &vlan, ctx, action, extack);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 57bd6ee72a07..49e105e0a447 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1860,90 +1860,6 @@ void br_vlan_notify(const struct net_bridge *br,
 	kfree_skb(skb);
 }
 
-static int br_vlan_replay_one(struct notifier_block *nb,
-			      struct net_device *dev,
-			      struct switchdev_obj_port_vlan *vlan,
-			      const void *ctx, unsigned long action,
-			      struct netlink_ext_ack *extack)
-{
-	struct switchdev_notifier_port_obj_info obj_info = {
-		.info = {
-			.dev = dev,
-			.extack = extack,
-			.ctx = ctx,
-		},
-		.obj = &vlan->obj,
-	};
-	int err;
-
-	err = nb->notifier_call(nb, action, &obj_info);
-	return notifier_to_errno(err);
-}
-
-int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, bool adding, struct notifier_block *nb,
-		   struct netlink_ext_ack *extack)
-{
-	struct net_bridge_vlan_group *vg;
-	struct net_bridge_vlan *v;
-	struct net_bridge_port *p;
-	struct net_bridge *br;
-	unsigned long action;
-	int err = 0;
-	u16 pvid;
-
-	ASSERT_RTNL();
-
-	if (!nb)
-		return 0;
-
-	if (!netif_is_bridge_master(br_dev))
-		return -EINVAL;
-
-	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
-		return -EINVAL;
-
-	if (netif_is_bridge_master(dev)) {
-		br = netdev_priv(dev);
-		vg = br_vlan_group(br);
-		p = NULL;
-	} else {
-		p = br_port_get_rtnl(dev);
-		if (WARN_ON(!p))
-			return -EINVAL;
-		vg = nbp_vlan_group(p);
-		br = p->br;
-	}
-
-	if (!vg)
-		return 0;
-
-	if (adding)
-		action = SWITCHDEV_PORT_OBJ_ADD;
-	else
-		action = SWITCHDEV_PORT_OBJ_DEL;
-
-	pvid = br_get_pvid(vg);
-
-	list_for_each_entry(v, &vg->vlan_list, vlist) {
-		struct switchdev_obj_port_vlan vlan = {
-			.obj.orig_dev = dev,
-			.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
-			.flags = br_vlan_flags(v, pvid),
-			.vid = v->vid,
-		};
-
-		if (!br_vlan_should_use(v))
-			continue;
-
-		err = br_vlan_replay_one(nb, dev, &vlan, ctx, action, extack);
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
 /* check if v_curr can enter a range ending in range_end */
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end)
-- 
2.25.1

