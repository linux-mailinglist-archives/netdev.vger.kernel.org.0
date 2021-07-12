Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79CD3C5F2A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbhGLPZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:36 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235509AbhGLPZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lySAc19OJealltLvkcQxvq36hVkWNXM778LxK7k+WyDxtyV4Mucq3z8QJHioPbIiI5quTvrqv7aIK7r+6fgvX+reoclUIr/5mo+Yxs7wgKwIaHdRnoO0mhGKtoB5ZuTmeJLSdfjU8d5s83OrlKhwv1MWsYqZBy/XAulPn093Wv/Njpb4+H3gjpn3uioFFq+vwBN3B3cJVWOzpQ/WPUHMaUaghG2+ydZ5C0ALwfyYzmEehMvPKZY2X/9AFbV0im+1SYy/sQDJgbvWgR39T/HrZpe3weGCO112bz4E1Rbrh0dx8o2sMsVIVL05UcERpZmgxjeeO7EFn2t8XMO6JYl79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVuzK7reJCuI4yRzD9WG98378U703iZhMxQNX+fD/gs=;
 b=NmQVOA+1wDJG/c+3JdwoQloswGW4t7inVN05SR1kjOvwojAJg4dMMRKXZgmjVWBtnn0vzk/fA1AA+gniZLjpUV80KijzlrTUylmod/cE0oV4kllTdWEvfmF0F/b6HqYFALyePLiSN6o5l4n2gbPPvCXTUhkt44mmsJ0pk8mr0a6KcyCEJBTnb8/LbUhx/o1azFFbw/iWORTL+wAJiNeOgdgviKQjjw3KFZVkmpbJ70stLXOmRhX20TUYYy6lvsMyDoGnwHAkoxbLubaYNYlVi5ahZgPhpnNpMkN56HglpMac+PFKQI/TZTiYSTRUNpko7YRkllYcYjaJOEuURLD16w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVuzK7reJCuI4yRzD9WG98378U703iZhMxQNX+fD/gs=;
 b=UYM/yjg5dQDUM2scXlqIp090obfJHKa+ao78wQVIahHJZbch7tjdBqF8Lq44aBQiURmciguQMlOMjEbbblWPAQbu3fTDXdG3HalEF1Trb8XRFJ7aOGF1gwga8rbuSPI1W93utfssWUTI6W0iGz/PRPWtfhJtcQEWcWxHqtqt5uw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:30 +0000
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
Subject: [RFC PATCH v3 net-next 17/24] net: bridge: replay mdb entries on the public switchdev notifier chain
Date:   Mon, 12 Jul 2021 18:21:35 +0300
Message-Id: <20210712152142.800651-18-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e692b106-4664-425d-f874-08d94548dd8a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62714A1B2C4FB022AD59DC79E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w3Kq3H5Ab+rMRFSt9e5REWfApXdsOz7vgNLDUkB4cVLxI/yk+5wWgwwsq7M4ThUFvJQjg5nIFpIQ1mAS7UUHNfcv6fsKTOCd31MNkwaiMIACm3+y/2H5YQ7V3PpPPC9RKgWCgzDaGJt3RTDgyLcKkiKe9vDKXNYWvNUr2BjZfJLc3iQ7s+2m18mhHwTjhlBHtlOZigI4W0wl/JFvGI3GikdSC7YzDiECiNDKToLV371zLgwAcnaB2qcDF8MoUNZGxSAFRAipNB41aQGaL8w6wAn4fKIH0oYqMPFRBb0n/9FXdwdDhy8M99sWcvBw6aaRyjWSZEzahOfskzQxoKEsysSmAYtW4MTY5f5VsyaSXNkEr0f1x6tpM5cANraq0ttaVXg0ktTVuWY6Had9B6Hiwgh/S03fbLaofU8C+JOcqPBLUatjGXr/fhxPF8QGfP2NYeltRdP/OqcIFQJXrgKmpJWVCqiNSFB4fPNgvbVU9OmseptGWiECk6+I/kSW7wKxLjGXX8W4Um9vV57H04IlXrP4K2Cy10JpaizFpqYVuawQE/VCZ70LS88VGSxjxQIrh7o7edeEVG3k3o+bE/YM78iAuNRsaPUOQsPBeCTk4Un3KmPisJ/DO4e6+TiTDozgaustkw4QRbN1ITMoGV6DQ4cifM9l8+x+urkPfM79Xr9SkiZNUyrLX9e4gnC1MaFr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(66574015)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?djdPFPLAFCAT6SQV3UVzpguQMvp3wm1ztkAe3Sp3tgAV7mZxTouXFPOQlAmX?=
 =?us-ascii?Q?RuEg/wzrTeZ7EBJ9On1rIcEk3QAjYA1iGkR58Jx/k3Nf0NgCXg0j8CF4AKgz?=
 =?us-ascii?Q?jO/mYSSbUDLbJJ8juu7VEPRw8uY7R3y9YYte1lmzOw9lZ41wI4ugzLkeXSwK?=
 =?us-ascii?Q?7XcpKy5PC5hgvktkRXp75xPF7+qTXqYTn69aHwfif00++lENSXx3yfgAE6wn?=
 =?us-ascii?Q?a1/0Xczs93KAqdQrV4c5WGfpek3H6/3Tu2+lBOj3rZE6dqzEgV5chcDT3bm3?=
 =?us-ascii?Q?xeUxDhz6LhBbArkku/EDNI3EOf6Q88Linaaq87ahDBJjYzgjtBDtjdF/aT4P?=
 =?us-ascii?Q?DJepiHkfckZ76j30EuwZGWHVJb6VfAYanzjrZgUL4P3ZblQtPvY5/LRlNzhy?=
 =?us-ascii?Q?Um3oxdMFFfBrTEqHnmZwiK+9n8XqpHSMt8m8U6JjMTeuvsrlcPT5hHgK6Re5?=
 =?us-ascii?Q?sOJfvFpdnwg3m9U3Eu01/8N+oOxQBiDfdW/iWq/8VwHlyptBj/AXbgdTKUvt?=
 =?us-ascii?Q?fkTixQVHHCykOFiqIKfCUOSNHHfRKJ0/TxflwEduVwJyOVc0/oWs91HW7nUj?=
 =?us-ascii?Q?dtWj36PzUGYMfKEySOa3ZUOcnsQxk0+C5Oz/84xaZTvOjpGX8GMvJj1oEF2x?=
 =?us-ascii?Q?DXHBiBdpJdMetnnHg7L0LBWtRZ3WHdEejicGcaiN3/OPwigSkvanfvqgPIn+?=
 =?us-ascii?Q?YAF0cPxn5roxzA3qmYszn7NitKvjxVjOwVrJRAezI+7ErTR0GjCc+WzmGJkU?=
 =?us-ascii?Q?JhryUr2kGCLMYhiBSip3Z1vdZlQLHDSj4K6rSRjmfew0g7epoqNN+FNO51Do?=
 =?us-ascii?Q?E/B+Prde92Odv0oVidhz3P45JAdRtsTCdcyZCuYH4mrBnGYrF8uEHiEYe4Kb?=
 =?us-ascii?Q?+wzOZhYRW/GFjOPruf8m8ikA7zXswCFdq37jWdNfHCm0DE+7myVRoPjQDKTS?=
 =?us-ascii?Q?QwYvWkI1GuSgX6wybisGX6GItHWUHCeWpYUUHLOSaHz6Mcopt9Z0tqiseSir?=
 =?us-ascii?Q?Git1+Ui2EHRB32xYKq7IybIAYxaCc0jCOHu/SFmEAHUCg48nlljLNmR1Go5v?=
 =?us-ascii?Q?CmUg1MEpJrRM4lsV686csjCju+1vETYv+4a3CxjbGWs9fQEjc7H/faFBV5yP?=
 =?us-ascii?Q?lraBGE52S9+j35oryQ6NljgypNLVxEghMewgw7m9IIm7LNhRw7Ymhjw2A20r?=
 =?us-ascii?Q?PU1HmtDZIJN11/ziPTnYo1o/WgVClC1XS4HJGL0+2EhWq2DQPfKtL8/jXG/V?=
 =?us-ascii?Q?jLcu9YZV4fNvRm+AxUUciolinh5VlyR7KDIH2kngfEZDIc3CE/mSICW526BU?=
 =?us-ascii?Q?QsAyXnwnSpdYj1VcMRTccNel?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e692b106-4664-425d-f874-08d94548dd8a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:30.8079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eu0n2o6Q0X1L8YFZTXymaKDcDqoTxGNIE5XCtM1gXfEbo/qgES7HpoVRNuzXpbCIN2v5bDDwJxoblie15LUpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of making br_mdb_replay() be called automatically for
every switchdev driver, we need to drop the extra argument to the
blocking notifier block so it becomes a less bureaucratic process, and
just emit the replayed events on the public chain.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c |  3 +-
 include/linux/if_bridge.h              |  6 ++--
 net/bridge/br_mdb.c                    | 40 +++++++++++++-------------
 net/dsa/port.c                         |  6 ++--
 4 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index dcb393a35c0e..863437990f92 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1175,8 +1175,7 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	ageing_time = br_get_ageing_time(bridge_dev);
 	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
 
-	err = br_mdb_replay(bridge_dev, brport_dev, priv, true,
-			    &ocelot_switchdev_blocking_nb, extack);
+	err = br_mdb_replay(bridge_dev, brport_dev, priv, true, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 8d4a157d249d..c7ed22b22256 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -71,8 +71,7 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb,
-		  struct netlink_ext_ack *extack);
+		  const void *ctx, bool adding, struct netlink_ext_ack *extack);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
 					     struct list_head *br_ip_list)
@@ -106,8 +105,7 @@ static inline bool br_multicast_router(const struct net_device *dev)
 }
 static inline int br_mdb_replay(const struct net_device *br_dev,
 				const struct net_device *dev, const void *ctx,
-				bool adding, struct notifier_block *nb,
-				struct netlink_ext_ack *extack)
+				bool adding, struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 209aea7de6a8..7753510a2099 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -566,23 +566,25 @@ static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
 	mdb->vid = mp->addr.vid;
 }
 
-static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
+static int br_mdb_replay_one(struct net_device *dev,
 			     const struct switchdev_obj_port_mdb *mdb,
-			     unsigned long action, const void *ctx,
+			     int type, const void *ctx,
 			     struct netlink_ext_ack *extack)
 {
-	struct switchdev_notifier_port_obj_info obj_info = {
-		.info = {
-			.dev = dev,
-			.extack = extack,
-			.ctx = ctx,
-		},
-		.obj = &mdb->obj,
-	};
 	int err;
 
-	err = nb->notifier_call(nb, action, &obj_info);
-	return notifier_to_errno(err);
+	switch (type) {
+	case RTM_NEWMDB:
+		err = switchdev_port_obj_add(dev, &mdb->obj, ctx, extack);
+		break;
+	case RTM_DELMDB:
+		err = switchdev_port_obj_del(dev, &mdb->obj, ctx);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
 }
 
 static int br_mdb_queue_one(struct list_head *mdb_list,
@@ -605,15 +607,13 @@ static int br_mdb_queue_one(struct list_head *mdb_list,
 }
 
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb,
-		  struct netlink_ext_ack *extack)
+		  const void *ctx, bool adding, struct netlink_ext_ack *extack)
 {
 	const struct net_bridge_mdb_entry *mp;
 	struct switchdev_obj *obj, *tmp;
 	struct net_bridge *br;
-	unsigned long action;
 	LIST_HEAD(mdb_list);
-	int err = 0;
+	int type, err = 0;
 
 	ASSERT_RTNL();
 
@@ -667,13 +667,13 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 	rcu_read_unlock();
 
 	if (adding)
-		action = SWITCHDEV_PORT_OBJ_ADD;
+		type = RTM_NEWMDB;
 	else
-		action = SWITCHDEV_PORT_OBJ_DEL;
+		type = RTM_DELMDB;
 
 	list_for_each_entry(obj, &mdb_list, list) {
-		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					action, ctx, extack);
+		err = br_mdb_replay_one(dev, SWITCHDEV_OBJ_PORT_MDB(obj),
+					type, ctx, extack);
 		if (err)
 			goto out_free_mdb;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ccf11bc518fe..c86121e9d87d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -194,8 +194,7 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_mdb_replay(br, brport_dev, dp, true,
-			    &dsa_slave_switchdev_blocking_notifier, extack);
+	err = br_mdb_replay(br, brport_dev, dp, true, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -225,8 +224,7 @@ static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
 	int err;
 
 	/* Delete the switchdev objects left on this port */
-	err = br_mdb_replay(br, brport_dev, dp, false,
-			    &dsa_slave_switchdev_blocking_notifier, extack);
+	err = br_mdb_replay(br, brport_dev, dp, false, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-- 
2.25.1

