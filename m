Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF833C5F29
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhGLPZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:34 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:42723
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235529AbhGLPZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx3ocUsrva9iq8QIvHNksmVNdTOE7SE0UOyyFOBT8yAS/dn33XPsnegBl4aBtAguhejLOn6wUTEsnjCZg/8FnKkV/wisa1vwbgqFxzI4rgDPnXgAbcI824E1mpS25HzH7lieVC2S1uUhctYYTuRUTPX/zLD2hMANI7k3f1shXR0tl1EyhQpDtWh4yGZj9PPRVUp2CexQzZ4682ZPdHcY8WR/an0vF8lXpZr/ZyZSckwgTdXxuL2vCfA/fzh8WJ+9sgPWUUhJ9t/jWRoq4Bab+731m2TXh9uOWng9vKD/SaVfLqo+sVLkSEJzu4Set7gFXoalCrf51VejWRe4NBBg/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO5GO8v4tjOgZUiRtjtciq9L3Y+FWYdUxnxBxmGQESM=;
 b=mB0jMuvSsK3wCuzCIgeJ44aMNn11gNH6chbq0+KpB65jBbIMgqzNkoxzSwr82CBgx771G2BROYLOJMTSGVFNkr5pfrQWt9HQIphKJaSI98oEyN5UhFaoYFWZKUw65ZE0G2Im+Dkc4sApVFq5ZWOhIdOuc3BPiE2W0nTxOiqVOpv3SRtdcy2LvTdjqL7+hc6Pt0/0CtRj3yO9oJkvfvgHLDBrjEtHZw8M4kiZGIGqizoVvlkBTjPGYYWeSfuuiMifvhgKdcHToMrKelfdXMsXGeH1qWk0UWhYsxRNth4Q64XcdIrSeigQ/brb+IWd4OKJvWU9UNiizf5liL2XZZaq9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO5GO8v4tjOgZUiRtjtciq9L3Y+FWYdUxnxBxmGQESM=;
 b=j28MwkjWthzmhT7bf4y2E/LpNCLknuEItz5NpX3WH8EVM6pUioIJ8EqrBalxFmKYcgF6PtIEqyIa1/tgm6mYvSUjqr3KtoXdvnMBDdXMBtollZ/3pKua+nDJeNuUItz1L0vvQ4nG0DS47Je3kAW1FkTU9vapUN+P515VIMqtZPY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:29 +0000
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
Subject: [RFC PATCH v3 net-next 16/24] net: bridge: propagate ctx to br_switchdev_port_vlan_{add,del}
Date:   Mon, 12 Jul 2021 18:21:34 +0300
Message-Id: <20210712152142.800651-17-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 697902a4-3228-40c3-0c30-08d94548dcb1
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62710CAD3FA5C659CE289B07E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3FreaHOUI2lOoM4wdZWTRXVFjMlGfAVeZRHJDn86X8iOtJTncEmdxbQw2z3IP+u8AVpdgjo27DUCwqLWUcllC5HlJeBO54H0fdbAF1BrXqubHTmew9v7MRv7EegGl8Xp3RlBt0CvDruX6M3ocl8e10Ij5q5EOLoDqtpkqWid3fSyPBWR4uXnl2plFQvHj+hcvoMD1/louur5HHmU7C7ByL955MP+V7cbpXnHNACRRBP9QJOCVZbMWjGfVPF1d4JoI7kONJfSb46uer9Ywcb8zxD3wB8vneWd/2C6Tm+GVMlA5IA41SGcygjQ0CgG767nIyzVvgfUwC8qWqrY5o2MWa7YzAeNLfNRMd4IEG8eCJQDQYac92ZU5sLVEaKb+I0JOmpOJhMGEC+/0+tjvOJcdYhetj2eDUu4bvlRfudgQXwZpuTfUmXftNIO3m4S4ZcCVWRv/D4KU57+f7uD3Fp0BUac471APCDtclgUZGC5GXO2P6EDWCRmk43JIQMyYWSQSqEnWYNrqUa7vC9NWD8KkXLYTqEd+qgkBW1YKXyvG+D6xRqUmAVq/5cJJMVngh8LP89J2ablXKfPRzw7GkLkGksr2F6jfQtMPZHLVU8vedrGp0e3UCXNZ8BSkZLq5GWNKXuzy5RZ8+d01Yr/kxo24Yoq721ZTRZRoKN7DTV8wvk5AARqjjSC6QI8UZLgtY5nx4XzAQlK9AEQzAaiNMOxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E4Q8uqDDjgrPWv/3ZuYhD9Am6UrmgXPw0xgK/NTpM5elmuT7L7aDgLwur3oT?=
 =?us-ascii?Q?HiePw9mdPyUDpdPJxpfN5uTSVI34JUbYldUbDT3CtloH30JWV5SrCRYLHvS6?=
 =?us-ascii?Q?YK5I3hNLqaOxy2Y4Y4bbGT0pScKqaJQvmA0GKuc9a3e2vjrs/q0Ig7lBXBgV?=
 =?us-ascii?Q?04lq8wRJE/qrC2ygY5jDy0pAZe91PCC6NUJQq2Wv3bnqdux/TtvdEu2zRO0f?=
 =?us-ascii?Q?acIp8OHSyEcuQDdy1eUVtt3IDuXscWgxsBepIfClljuExRs8ag3dwJvBxCQc?=
 =?us-ascii?Q?L4db5lw+w6zJbBGlktwghWiHMq4cjKYhLCiOuX2h8B32X2jdTNq471ui/8zD?=
 =?us-ascii?Q?uj0/TrJhG9eX4zVrthUbStoyg812zLZhJDEbW3I2y1Nb1AMFNZQazzJgHKnm?=
 =?us-ascii?Q?77g9M9sKDT1bWaoEKe4eOaX0BaQFKeMAa4OvgdzJYUAUjROZlfAKqB+Q7mEk?=
 =?us-ascii?Q?y5INiH0hilkibXCafzxkQkZtHK1H9eMMu3o5C4YtL8HpsvuiyQR7j8WQzsay?=
 =?us-ascii?Q?d0L5OpdGcC6oNYnaiKmMvk4DLKNnSGPc5Jtzz4LOOsOdJzfaKjjRkJ3mjGBv?=
 =?us-ascii?Q?vBrvbuspoAZyGOd+wyWiuu1brNgaZXVDl4ZZIogMAvyLO9qjLquJ/CbhblsT?=
 =?us-ascii?Q?We/HMm3hDJGQ/S9HVkenSuuMzSgw71hhcns00Hr65odRUPtvlmjH6WSaAkpu?=
 =?us-ascii?Q?gMx2L3EzxWYJYyrt6XrPIa0j4tJbPKT5U/R9KRBWSS2x2ljsxwHh9na0nuqp?=
 =?us-ascii?Q?94gurGrdauuIzojOG6LHQKlNyyCOj1iLbP/Odw8xoZ3L9CqHfzApRnQTITWe?=
 =?us-ascii?Q?q0jikOVd+MZgVLZqcEazR7d14iyyPIFB24eEfezU6bN6hccLCLLIFZ5Bbi1U?=
 =?us-ascii?Q?HekRnWbjGfdQLGVEfdlowmj2OLy/MvETu1KXeUoBsO4+wfzIMM6bZnjcKHPc?=
 =?us-ascii?Q?QAlHXY/tS3dMkcZ4wPlTHklVM/SoWFWUCrGHVDEVFjIYNV8C0C/zQxoFDJh5?=
 =?us-ascii?Q?wj4rSF3WsroSHB5zVADeYQvXbDP4qQPEffGNlC6seHJs5f88R3yiGvA68Vn8?=
 =?us-ascii?Q?0WRcg6md9yxKV6UzV9Ir0d9Wz2tC2wnv7yGQa3fL5bhj8SQ8WM9Byx2Sjevv?=
 =?us-ascii?Q?gszK5u+8E4PvuqsnwONhBcJqGwOT2Wyp7Dcg3RXZ6sDfwv/2ZM4UzW7wWwg3?=
 =?us-ascii?Q?B0nRCFHU0YdkUnyyeJLDzbdd5wf2CFctze6gjjzt4XFsUZG15l5EtSS4OvuH?=
 =?us-ascii?Q?7b+c1wPWCl+QfqNgawoEBD1d9ottPqlecHY229MwxmeHR5JUBram0wYawtsa?=
 =?us-ascii?Q?C/piq5WcDbt8GYo+r27k13Yk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697902a4-3228-40c3-0c30-08d94548dcb1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:29.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJ5EDeZvpT76J6wHFweqUcw6Q4wGI/aL3upPO2FSWj3ZkBhEKt3X2s2AfHn2XyoObN6DFPmyPivs0UvAD5N/DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make br_switchdev_port_vlan_add() and br_switchdev_port_vlan_del()
callable by br_vlan_replay() too, by exposing a void *ctx argument.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_private.h   |  8 ++++++--
 net/bridge/br_switchdev.c |  8 +++++---
 net/bridge/br_vlan.c      | 19 +++++++++++--------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 46236302eed5..763de4a503d9 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1673,8 +1673,10 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 void br_switchdev_fdb_notify(struct net_bridge *br,
 			     const struct net_bridge_fdb_entry *fdb, int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
+			       const void *ctx,
 			       struct netlink_ext_ack *extack);
-int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
+int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid,
+			       const void *ctx);
 void br_switchdev_init(struct net_bridge *br);
 
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
@@ -1703,12 +1705,14 @@ static inline int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 static inline int br_switchdev_port_vlan_add(struct net_device *dev,
 					     u16 vid, u16 flags,
+					     const void *ctx,
 					     struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
+static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid,
+					     const void *ctx)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index c961d86bc323..90aad6a4c32c 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -102,6 +102,7 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 }
 
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
+			       const void *ctx,
 			       struct netlink_ext_ack *extack)
 {
 	struct switchdev_obj_port_vlan v = {
@@ -111,10 +112,11 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 		.vid = vid,
 	};
 
-	return switchdev_port_obj_add(dev, &v.obj, NULL, extack);
+	return switchdev_port_obj_add(dev, &v.obj, ctx, extack);
 }
 
-int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
+int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid,
+			       const void *ctx)
 {
 	struct switchdev_obj_port_vlan v = {
 		.obj.orig_dev = dev,
@@ -122,7 +124,7 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 		.vid = vid,
 	};
 
-	return switchdev_port_obj_del(dev, &v.obj, NULL);
+	return switchdev_port_obj_del(dev, &v.obj, ctx);
 }
 
 static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a08e9f193009..14f10203d121 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -92,7 +92,7 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
 	/* Try switchdev op first. In case it is not supported, fallback to
 	 * 8021q add.
 	 */
-	err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
+	err = br_switchdev_port_vlan_add(dev, v->vid, flags, NULL, extack);
 	if (err == -EOPNOTSUPP)
 		return vlan_vid_add(dev, br->vlan_proto, v->vid);
 	v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
@@ -132,7 +132,7 @@ static int __vlan_vid_del(struct net_device *dev, struct net_bridge *br,
 	/* Try switchdev op first. In case it is not supported, fallback to
 	 * 8021q del.
 	 */
-	err = br_switchdev_port_vlan_del(dev, v->vid);
+	err = br_switchdev_port_vlan_del(dev, v->vid, NULL);
 	if (!(v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV))
 		vlan_vid_del(dev, br->vlan_proto, v->vid);
 	return err == -EOPNOTSUPP ? 0 : err;
@@ -281,7 +281,8 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 			v->stats = masterv->stats;
 		}
 	} else {
-		err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
+		err = br_switchdev_port_vlan_add(dev, v->vid, flags, NULL,
+						 extack);
 		if (err && err != -EOPNOTSUPP)
 			goto out;
 	}
@@ -330,7 +331,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 			v->brvlan = NULL;
 		}
 	} else {
-		br_switchdev_port_vlan_del(dev, v->vid);
+		br_switchdev_port_vlan_del(dev, v->vid, NULL);
 	}
 
 	goto out;
@@ -357,7 +358,7 @@ static int __vlan_del(struct net_bridge_vlan *v)
 		if (err)
 			goto out;
 	} else {
-		err = br_switchdev_port_vlan_del(v->br->dev, v->vid);
+		err = br_switchdev_port_vlan_del(v->br->dev, v->vid, NULL);
 		if (err && err != -EOPNOTSUPP)
 			goto out;
 		err = 0;
@@ -650,7 +651,8 @@ static int br_vlan_add_existing(struct net_bridge *br,
 {
 	int err;
 
-	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
+	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, NULL,
+					 extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -681,7 +683,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
 
 err_fdb_insert:
 err_flags:
-	br_switchdev_port_vlan_del(br->dev, vlan->vid);
+	br_switchdev_port_vlan_del(br->dev, vlan->vid, NULL);
 	return err;
 }
 
@@ -1219,7 +1221,8 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 	vlan = br_vlan_find(nbp_vlan_group(port), vid);
 	if (vlan) {
 		/* Pass the flags to the hardware bridge */
-		ret = br_switchdev_port_vlan_add(port->dev, vid, flags, extack);
+		ret = br_switchdev_port_vlan_add(port->dev, vid, flags, NULL,
+						 extack);
 		if (ret && ret != -EOPNOTSUPP)
 			return ret;
 		*changed = __vlan_add_flags(vlan, flags);
-- 
2.25.1

