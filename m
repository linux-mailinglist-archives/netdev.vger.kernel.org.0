Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326C93D1A31
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGUWZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:25:43 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:59617
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230478AbhGUWZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 18:25:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bumlNpcEkUnXZL4ElaFOOvH4vlZsJ84PEzfFTHxU9kt7xZsVrGnRsJTj2TVWrACwgBxPCmCQLhy234ERvrYQxGgEw2i9dpmUOGk+9CO/gyflAXJrSDwj6SpbFnm39yB9AY7IUhRG6c6/AQM+l6u1SKxihVRVAtU11bP3FlycOpuVynaB/kQz3r3XUwyOAJGHas2AphfFtUeTMFKGS8VJXB+dVBVgyluDeC0nITAbTP8S0zKEtIU+XeRgiAgKWSebxBxygHXwEr7re/VsadlKD/lljICbZip2VKWcbtYZoFX6+5kNEPh7qzzKMQxg5ZDET9ysjf2pCSbotoaBUkN8yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMlAATUQNoiSpSLH6nwNifBU3P3Yztf287tfE98zNq0=;
 b=UtUtz5KAtGauQ4+437whIlWwf9QXGHc4p2AkBki2VdJhDUYk9Nm9DQq1q/zjwTbOfdO1Rh5mkAYDOi3d5jIrInUziAdPAkJYS+QjVJYrFpHHxMmysgH2CZWcdVJHTffBYG4p8y6FDTU4vMyJcxlZ2HSSQ0+5nxrPdEml1VRarZMlzlkuQVWqsMeInZTf4GCaUJui0G6w+CDKJkAGty5wNaHkUHWtpP5BjPbutqc+Dac4gZcILtKptmK9KJeee6SrK0701m9XfSaLK/7yVXHewpogthKXfp+YZ6i8m9+xuAntH4oU+mDuPNidV53bDBLuA3ymwU0eO6gqlgC1ns3qvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMlAATUQNoiSpSLH6nwNifBU3P3Yztf287tfE98zNq0=;
 b=nL1BeQIi/hYAN11fQrVG/AhMjitSXPJ0/16oXxbAUFmZG6jAnYMBEZjYFC/Qw4AAF4oSKfLjN19bikHsXsImzDI0hKJORBHgLriUVGM0+xzy360z8J7IN4/b+IdxiA168V5p5qA7TPSnuYyJ/3ccZb5tjObf0rzlqLQFZOSXtTo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Wed, 21 Jul
 2021 23:06:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 23:06:05 +0000
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
        DENG Qingfang <dqfext@gmail.com>,
        Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH net-next] net: switchdev: fix FDB entries towards foreign ports not getting propagated to us
Date:   Thu, 22 Jul 2021 02:05:55 +0300
Message-Id: <20210721230555.2207542-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0077.eurprd03.prod.outlook.com
 (2603:10a6:208:69::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR03CA0077.eurprd03.prod.outlook.com (2603:10a6:208:69::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25 via Frontend Transport; Wed, 21 Jul 2021 23:06:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77a4fa34-3ee0-4fbf-9255-08d94c9c1e17
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:
X-Microsoft-Antispam-PRVS: <VE1PR04MB72162092A78CED11D06FA2C8E0E39@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QS3BERzol+7m2wJcTROiQammEKlvs/kBkJO6Qhy4R6lXAot4T4YiZxxtdma76CKbB33vmpdjZSwLrPjR24o30XzS6sY8HCLahqLjZOHx0KGWI5beDnb/3d8q2vWqnlneVtCkIpoGGEUwethu/rvLmtBXcBzr3SiIz9NftbvLm4s9Z8zXenQ20OxmKTkmwhjRWZ/tc4tDav8zKrnYkczL6a0NfBQLw+oMlt5X16e5Ko/AWRyhiaUoNk9jkfQQmC0y83lzkQc/1JKDQj132oJ+N7W33L1y/x63h0k86lKcIiz1TV3XxCgSC7hbTXKzMrTkOjrua1+L+fDrVKZbDgQ3/bbieAiWxhrB3Qz2qAV7247UV/VhGlC2qnEa9OYT3QcPAQu2cAggHBIFBN9PjVrMqeb32tMmDKBdV/jR+ROD2b5ZdmA5yMFIyTelcUSgmlbTHaq+rxI3a2pG+SivqnMvXwIV6UPvOcoRs//cy54T8LZJOqNuLISjIukvusaMRo1Fj3SSX1C0g6Bt/hrNGEwd9mFtJ1J+/36r9BenljaPL3zsutDFuifkHd1y+9nJTBE7P/R6KgJc7VZX4ACnT5/ae5UVPoOYHpwc3Gfo+5F69R7cR/87rMAiXw3iUFKIvAOJJfZ1LOvEmVGcvOqTfxW0qxMUJSOY3M+TJt+UC5cEV0vpIpTp3k433W2ASJDGCWkMGc8Sxf9jmXQyY4SAo7FwUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(346002)(366004)(396003)(6666004)(6506007)(316002)(478600001)(7416002)(110136005)(8936002)(66946007)(4326008)(36756003)(86362001)(66476007)(6512007)(186003)(54906003)(66556008)(38350700002)(8676002)(83380400001)(38100700002)(6486002)(2616005)(2906002)(26005)(52116002)(44832011)(5660300002)(956004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R/LHn7KijhjqDm3ZMFwmpHdgmRdRWOHGBenIxVFnOi7sQWt49gR5tUTLnRFX?=
 =?us-ascii?Q?RyKN68hZNB4zmL6BSg6QzOC4A38EUgFD8N4LbtixGLm5/Le06FTjWHYVN5kT?=
 =?us-ascii?Q?HT29kV78HXaqttChSDUm5dzTZo3ycwEj7QWtQuvvgiAfrunDiEKc3u8EqAcS?=
 =?us-ascii?Q?q03TIift6UqlcORYM/wN6ElGPIbjECiKH77Y19TBUyA2iNgyIaXeB+Pv8FbK?=
 =?us-ascii?Q?B4/zQT7TJnX9qDW7PNUAdZlQIDrFbJI4DKb4e0VXTas+hAeS8aX0wqti1mAO?=
 =?us-ascii?Q?DGxpL8JZVsJso6F3dFO0JesMXkeT1cHPlCbh3QU993Ulpqhm+PP8yjunbfpU?=
 =?us-ascii?Q?PuYYgxre8YP0tecbO8LCFcvtTvNcLF9UV7847YZiOyT0DOKhU3/IUbR962GF?=
 =?us-ascii?Q?szJMhW6z4qKm6aUoIJzD6RQIH9zjMK17ywU5X8H81QSgwWAQjIslr92VJ/Ge?=
 =?us-ascii?Q?vNazpydjHddhKRikv0wC9bECkOu7WMKPDOjF7cjMiqNdgMUPqzM0rSsJPMNm?=
 =?us-ascii?Q?W2v1chRJWNFsuyedccSvMri827LNJCK48ZZKsWUUToBY+CsEALAOziL8H5cC?=
 =?us-ascii?Q?9Gr87a1RHYDJ9ezpGjn5dMdOIjKz8K60GuGTLMIwyZZuv+YHyUt9/rd+oJAS?=
 =?us-ascii?Q?LJOCpF3cmoH7/tvro/g4ow7/76qbWC3sm5jcX7UAuvppVCdCUtpLItal5U/U?=
 =?us-ascii?Q?Kr4Z/8B+BjvGgc0N4+XHcqydkrkCEFgq/QYnmixQYg+PVfOSMVCWMyWbEFKV?=
 =?us-ascii?Q?aV2UOXU6PkLgYrHOjyDv2pCR/ol80T3FsVJlQRpqn6ifOVdr6IpwFavjt9P1?=
 =?us-ascii?Q?gD+Ky1CVyo02hp1oFgcUnTZXeLu2aBP76IeR5H8B6N13ua1eQ8RT26oDT1Bs?=
 =?us-ascii?Q?GgVrFZXJpwXMrqh8pEQQju+uJeDbSnD0AenXbuZAWj+7OBwN0b6gB58LNcBV?=
 =?us-ascii?Q?7KnP6SbaSXcQkFvAclqnADnnKsPNcD7tUmKIt/3Pr02hvNzAyN41sAIrAYsq?=
 =?us-ascii?Q?1iCBR7YxqsfeFEZMbcWfzLyXY3PPpm4FBWI0f/sa5571RkkJdYQ/8wvUqLgM?=
 =?us-ascii?Q?VLTqCeupbBRhX2KLczdz+vhpR5JCkVMrRpLbKjAYfhKDdlMcHQ/PpbLiAOPR?=
 =?us-ascii?Q?7qDT8eyhyaTr1ju5kGGSTHYSdN6cn71CVTdUT6yhkESzUFlRmaaFBElaVgu+?=
 =?us-ascii?Q?EU4+fqQh+S3TO65w1CFb+71Gh4pOldaEmfOORP5f4J+eY/zQNGwL6mwPjJRz?=
 =?us-ascii?Q?uQxWcrP2BIak5EFwBRuzqmWUCV9cQZNRsEg3y7tRmkuEWQKI8nWvLUQxqRMv?=
 =?us-ascii?Q?Y99Nk/UJ/bSJlvQ5wbo4YoGA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a4fa34-3ee0-4fbf-9255-08d94c9c1e17
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 23:06:05.5834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fucEIG0uqU0BsGN5dsIK3O6NLyxcLNJGgz7+8OZce9rDsG0E/gPtjG7Atn1yMEzq/2ZNf1YDZn/oapOGs95WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly introduced switchdev_handle_fdb_{add,del}_to_device helpers
solved a problem but introduced another one. They have a severe design
bug: they do not propagate FDB events on foreign interfaces to us, i.e.
this use case:

         br0
        /   \
       /     \
      /       \
     /         \
   swp0       eno0
(switchdev)  (foreign)

when an address is learned on eno0, what is supposed to happen is that
this event should also be propagated towards swp0. Somehow I managed to
convince myself that this did work correctly, but obviously it does not.

The trouble with foreign interfaces is that we must reach a switchdev
net_device pointer through a foreign net_device that has no direct
upper/lower relationship with it. So we need to do exploratory searching
through the lower interfaces of the foreign net_device's bridge upper
(to reach swp0 from eno0, we must check its upper, br0, for lower
interfaces that pass the check_cb and foreign_dev_check_cb). This is
something that the previous code did not do, it just assumed that "dev"
will become a switchdev interface at some point, somehow, probably by
magic.

With this patch, assisted address learning on the CPU port works again
in DSA:

ip link add br0 type bridge
ip link set swp0 master br0
ip link set eno0 master br0
ip link set br0 up

[   46.708929] mscc_felix 0000:00:00.5 swp0: Adding FDB entry towards eno0, addr 00:04:9f:05:f4:ab vid 0 as host address

Fixes: 8ca07176ab00 ("net: switchdev: introduce a fanout helper for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE")
Reported-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/switchdev/switchdev.c | 214 +++++++++++++++++++++++++-------------
 1 file changed, 142 insertions(+), 72 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 42e88d3d66a7..0ae3478561f4 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -378,6 +378,56 @@ int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
 
+struct switchdev_nested_priv {
+	bool (*check_cb)(const struct net_device *dev);
+	bool (*foreign_dev_check_cb)(const struct net_device *dev,
+				     const struct net_device *foreign_dev);
+	const struct net_device *dev;
+	struct net_device *lower_dev;
+};
+
+static int switchdev_lower_dev_walk(struct net_device *lower_dev,
+				    struct netdev_nested_priv *priv)
+{
+	struct switchdev_nested_priv *switchdev_priv = priv->data;
+	bool (*foreign_dev_check_cb)(const struct net_device *dev,
+				     const struct net_device *foreign_dev);
+	bool (*check_cb)(const struct net_device *dev);
+	const struct net_device *dev;
+
+	check_cb = switchdev_priv->check_cb;
+	foreign_dev_check_cb = switchdev_priv->foreign_dev_check_cb;
+	dev = switchdev_priv->dev;
+
+	if (check_cb(lower_dev) && !foreign_dev_check_cb(lower_dev, dev)) {
+		switchdev_priv->lower_dev = lower_dev;
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct net_device *
+switchdev_lower_dev_find(struct net_device *dev,
+			 bool (*check_cb)(const struct net_device *dev),
+			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						      const struct net_device *foreign_dev))
+{
+	struct switchdev_nested_priv switchdev_priv = {
+		.check_cb = check_cb,
+		.foreign_dev_check_cb = foreign_dev_check_cb,
+		.dev = dev,
+		.lower_dev = NULL,
+	};
+	struct netdev_nested_priv priv = {
+		.data = &switchdev_priv,
+	};
+
+	netdev_walk_all_lower_dev_rcu(dev, switchdev_lower_dev_walk, &priv);
+
+	return switchdev_priv.lower_dev;
+}
+
 static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 		const struct net_device *orig_dev,
 		const struct switchdev_notifier_fdb_info *fdb_info,
@@ -392,37 +442,18 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *lower_dev;
+	struct net_device *br, *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
-	if (check_cb(dev)) {
-		/* Handle FDB entries on foreign interfaces as FDB entries
-		 * towards the software bridge.
-		 */
-		if (foreign_dev_check_cb && foreign_dev_check_cb(dev, orig_dev)) {
-			struct net_device *br = netdev_master_upper_dev_get_rcu(dev);
-
-			if (!br || !netif_is_bridge_master(br))
-				return 0;
-
-			/* No point in handling FDB entries on a foreign bridge */
-			if (foreign_dev_check_cb(dev, br))
-				return 0;
-
-			return __switchdev_handle_fdb_add_to_device(br, orig_dev,
-								    fdb_info, check_cb,
-								    foreign_dev_check_cb,
-								    add_cb, lag_add_cb);
-		}
-
+	if (check_cb(dev))
 		return add_cb(dev, orig_dev, info->ctx, fdb_info);
-	}
 
-	/* If we passed over the foreign check, it means that the LAG interface
-	 * is offloaded.
-	 */
 	if (netif_is_lag_master(dev)) {
+		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+			goto maybe_bridged_with_us;
+
+		/* This is a LAG interface that we offload */
 		if (!lag_add_cb)
 			return -EOPNOTSUPP;
 
@@ -432,20 +463,49 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	/* Recurse through lower interfaces in case the FDB entry is pointing
 	 * towards a bridge device.
 	 */
-	netdev_for_each_lower_dev(dev, lower_dev, iter) {
-		/* Do not propagate FDB entries across bridges */
-		if (netif_is_bridge_master(lower_dev))
-			continue;
+	if (netif_is_bridge_master(dev)) {
+		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+			return 0;
+
+		/* This is a bridge interface that we offload */
+		netdev_for_each_lower_dev(dev, lower_dev, iter) {
+			/* Do not propagate FDB entries across bridges */
+			if (netif_is_bridge_master(lower_dev))
+				continue;
+
+			/* Bridge ports might be either us, or LAG interfaces
+			 * that we offload.
+			 */
+			if (!check_cb(lower_dev) &&
+			    !switchdev_lower_dev_find(lower_dev, check_cb,
+						      foreign_dev_check_cb))
+				continue;
+
+			err = __switchdev_handle_fdb_add_to_device(lower_dev, orig_dev,
+								   fdb_info, check_cb,
+								   foreign_dev_check_cb,
+								   add_cb, lag_add_cb);
+			if (err && err != -EOPNOTSUPP)
+				return err;
+		}
 
-		err = __switchdev_handle_fdb_add_to_device(lower_dev, orig_dev,
-							   fdb_info, check_cb,
-							   foreign_dev_check_cb,
-							   add_cb, lag_add_cb);
-		if (err && err != -EOPNOTSUPP)
-			return err;
+		return 0;
 	}
 
-	return err;
+maybe_bridged_with_us:
+	/* Event is neither on a bridge nor a LAG. Check whether it is on an
+	 * interface that is in a bridge with us.
+	 */
+	br = netdev_master_upper_dev_get_rcu(dev);
+	if (!br || !netif_is_bridge_master(br))
+		return 0;
+
+	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+		return 0;
+
+	return __switchdev_handle_fdb_add_to_device(br, orig_dev, fdb_info,
+						    check_cb, foreign_dev_check_cb,
+						    add_cb, lag_add_cb);
 }
 
 int switchdev_handle_fdb_add_to_device(struct net_device *dev,
@@ -487,37 +547,18 @@ static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *lower_dev;
+	struct net_device *br, *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
-	if (check_cb(dev)) {
-		/* Handle FDB entries on foreign interfaces as FDB entries
-		 * towards the software bridge.
-		 */
-		if (foreign_dev_check_cb && foreign_dev_check_cb(dev, orig_dev)) {
-			struct net_device *br = netdev_master_upper_dev_get_rcu(dev);
-
-			if (!br || !netif_is_bridge_master(br))
-				return 0;
-
-			/* No point in handling FDB entries on a foreign bridge */
-			if (foreign_dev_check_cb(dev, br))
-				return 0;
-
-			return __switchdev_handle_fdb_del_to_device(br, orig_dev,
-								    fdb_info, check_cb,
-								    foreign_dev_check_cb,
-								    del_cb, lag_del_cb);
-		}
-
+	if (check_cb(dev))
 		return del_cb(dev, orig_dev, info->ctx, fdb_info);
-	}
 
-	/* If we passed over the foreign check, it means that the LAG interface
-	 * is offloaded.
-	 */
 	if (netif_is_lag_master(dev)) {
+		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+			goto maybe_bridged_with_us;
+
+		/* This is a LAG interface that we offload */
 		if (!lag_del_cb)
 			return -EOPNOTSUPP;
 
@@ -527,20 +568,49 @@ static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
 	/* Recurse through lower interfaces in case the FDB entry is pointing
 	 * towards a bridge device.
 	 */
-	netdev_for_each_lower_dev(dev, lower_dev, iter) {
-		/* Do not propagate FDB entries across bridges */
-		if (netif_is_bridge_master(lower_dev))
-			continue;
+	if (netif_is_bridge_master(dev)) {
+		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+			return 0;
+
+		/* This is a bridge interface that we offload */
+		netdev_for_each_lower_dev(dev, lower_dev, iter) {
+			/* Do not propagate FDB entries across bridges */
+			if (netif_is_bridge_master(lower_dev))
+				continue;
+
+			/* Bridge ports might be either us, or LAG interfaces
+			 * that we offload.
+			 */
+			if (!check_cb(lower_dev) &&
+			    !switchdev_lower_dev_find(lower_dev, check_cb,
+						      foreign_dev_check_cb))
+				continue;
+
+			err = __switchdev_handle_fdb_del_to_device(lower_dev, orig_dev,
+								   fdb_info, check_cb,
+								   foreign_dev_check_cb,
+								   del_cb, lag_del_cb);
+			if (err && err != -EOPNOTSUPP)
+				return err;
+		}
 
-		err = __switchdev_handle_fdb_del_to_device(lower_dev, orig_dev,
-							   fdb_info, check_cb,
-							   foreign_dev_check_cb,
-							   del_cb, lag_del_cb);
-		if (err && err != -EOPNOTSUPP)
-			return err;
+		return 0;
 	}
 
-	return err;
+maybe_bridged_with_us:
+	/* Event is neither on a bridge nor a LAG. Check whether it is on an
+	 * interface that is in a bridge with us.
+	 */
+	br = netdev_master_upper_dev_get_rcu(dev);
+	if (!br || !netif_is_bridge_master(br))
+		return 0;
+
+	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+		return 0;
+
+	return __switchdev_handle_fdb_del_to_device(br, orig_dev, fdb_info,
+						    check_cb, foreign_dev_check_cb,
+						    del_cb, lag_del_cb);
 }
 
 int switchdev_handle_fdb_del_to_device(struct net_device *dev,
-- 
2.25.1

