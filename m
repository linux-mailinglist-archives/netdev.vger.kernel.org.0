Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007CA43CE9F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbhJ0QYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:24:03 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57505
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233877AbhJ0QYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:24:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuOnZPh9HyLKaEG5t0uChPx4pQCDSfoEcEY1GXZbfKwQmB2Gic7+IT+4Q047MOqJJOEN8iizs6JUB443GYB4/nJDZiAh0hmXId2JCwfn36yI0MpFM6dFPj83ODuX8MrO+IaUHUj7BlJKcG1UQBJHS22Fbx+IMXj42AQYa0mDD81CkSAFuoM6czFXAwaRSTyr3Zr/qNS0rAZRCkJnfHb3eBlpfBWsxlA/ZqZJUyJyNJUqGPS1uofaWTw3pZxhgjFy+LKTFjvOsYn3pYZx2bHeX69NyTqUA+eQvhOABG1YpDc3I7lfoTt46zGz2NgCYbhVC1lzXCgKLsesL176vEvZwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4N+/rVD13lDW+FjTT/PsRzwBxHNi4Tlfid7GGDH8ms=;
 b=n1tngINdMeI+EZqrjiypFICSpgOEsf8l6dJ6a9hGmTnJPS+t256ZkKfqBL9lu6uP6Ehvg8aqAUDVPI4iODjGH++qWchxn0SHHEUSaZzItFJUwTKMpgKnqcbQQetBq1zGjbq6/WiTFGU/y+tvR92pehrNUyIMTuydaaQWgAZeEZa4hgSWzHQEupRXjzVBB8bbO7aot7BBrJSDVzY55al+b8BzvDUAzIracPH1YRyCyysgiorgbxdnyGbrjwhbrU4eOmERjF1VDxibEC8yDQpHAfJuJdq5CCjAagqkbbNcf8mzonK+1LBMUY1+QGkt50vVrdx/GBBRJ9TN8HdXmPAIKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4N+/rVD13lDW+FjTT/PsRzwBxHNi4Tlfid7GGDH8ms=;
 b=Ge/8bv0bx8m1YRrbgTF1Vt37Qr9HId1O65aVeP2jBPMPYICZumEVq1HHj2AFYwYFgslLDg0tgQVw3UzKo6IQ3e7XGpiLBtW/z4wzAB4GBJO7WyGlBnyk5ydTif3e2ibh1oXC9YqbYJj+1HOk6m+oq1wvrT8Zzw5+RJwxL4pdAeY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:21:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:21:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] net: bridge: split out the switchdev portion of br_mdb_notify
Date:   Wed, 27 Oct 2021 19:21:17 +0300
Message-Id: <20211027162119.2496321-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0057.eurprd05.prod.outlook.com
 (2603:10a6:200:68::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM4PR0501CA0057.eurprd05.prod.outlook.com (2603:10a6:200:68::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:21:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c4063bb-683d-4541-507d-08d99965d6d7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6014F1549113E3780CEE75A4E0859@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKZdM52ozuXNNyGz6UPtqm0sdqU5iCn1FELLoty4fRax+ur7ZVZlTzjYGkMEMfiHVbEO0SyTNE9TNffx9IXFHnTLGHcp7JEg8P/HvosezpT6nZQ0jaGo9GS8RwYvNNnzd8zs8bYiDQwJAsCDOBAgJZKNykFAddoPhRkfy7SYhumYeY94Sg2glItQwWFEp+VdD58XU4LeahPOMWBAoBB/KdpU8yjyKp17wFLW+uRPTCybGGUcOEqZzXaVDwiBE7Mgn8Fi099wA4wmR4+ACnhVfX14zXs3t5VNoYeparjMqzo9v+tlRtX2tRLRSblRmWqgnLDlEGuP44rBBRGrdnXLqlSZAKXryIxJOOTCbQR4VAXQxEGQCXq8AOU4mN72bZaqux7YJ1YMTohv6u0xDWWaAfERTuMCuF24t7PX6NJ6tZtLzldqHJTqP3NSTBL0ozN1ZFzLg39kgMoMSVbW+9jmsL5v4O24tYx5LG/G6nSzcgFzUjR2L24siXQOFML0Fk3UCWNr376eyReHOkCJF6Z+zOvNrLWpEPWOSEYMW49rCAcRKbzbYMGXesGQBhzR5xYeoDXAqmK+BqToLaAl4KGz1jVQqzQpb3ioTfKQ42bu1h/1keC1Z32Y9KuGSjPUV51/biLVB5rkA0csJ/bqtlyh976vvIBmVJA10wORR2YJoxKef05ckTMuA5CZIx981Gc4M+Cv3rAFt5hVFNfY4AyEOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(52116002)(6506007)(2616005)(316002)(86362001)(6512007)(83380400001)(508600001)(26005)(6916009)(4326008)(8676002)(66556008)(66946007)(5660300002)(8936002)(186003)(38100700002)(36756003)(54906003)(2906002)(38350700002)(6486002)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wDIch8ybjKO1Xf3cRT1plOrkIsfsx0hQH31IdoK+G+LpWNRPi2EDHXIVssHj?=
 =?us-ascii?Q?baPQczfhSkyKvXirzzkAJ+a1gK4Xcf6/tqEnyVvYb3mOVynZbXY3O8ydJ7WF?=
 =?us-ascii?Q?ovIQb3zS2+m/KORxB7MtL/rVhScYl5fprW9pNEnEfTJ2BrVVYBDqBY88Bnay?=
 =?us-ascii?Q?wjA3THt+7SnbpHNFgM4BR02m+P4u2tzDIfdGLAdb5QSGOiIk2P3K7Yc3jbYi?=
 =?us-ascii?Q?xxkbj5fzHrqHTYbEphEy6qw0Ak2fQOupturCmP0GrVHVmQZPEWXBnypPHSod?=
 =?us-ascii?Q?qqr3IP8FAo1W641HogpevNJ4ttRf2dLWmeArPi52McSZ+W+NUvpHmFR0piiN?=
 =?us-ascii?Q?Aboz5B1cTRjdR/ycttSVpNBlG0WVVG+q89aYN/Q1rVqzXSjcTPiF+v3X/mgy?=
 =?us-ascii?Q?72F+6ONLsk0rhH9TG/7ADAf9v/NVSFfh6xXZTSxQb+YRr0lHLfuab1k6+CSi?=
 =?us-ascii?Q?J9x+eUzHIowfL/A8FS+rrOIDz75v0FbjAzYF8ziYvOuYI9IA23iNZ4FDkxD3?=
 =?us-ascii?Q?TaM2HL1gquB73Lqwta30maDhl78ZIArOULhNZDqeCS6Vibbmvgl8Gjj+C/WT?=
 =?us-ascii?Q?/LZr5TStBsJWkORvXp3BKFCxDYbggxIqcrQsOcUK/ixmulBuYSvb5gF2HMFD?=
 =?us-ascii?Q?2NZHEuIy0CN8YefpAk3i55I2LxnoS3KTeXS9k9Mkm4zXREgk3gMbXxjrrQOF?=
 =?us-ascii?Q?YU2zc5UFYhqw4rl3gl2o/T1JzRWA5cSxih72EYr3ZHhF4eLYaGVxihv5VfjQ?=
 =?us-ascii?Q?4tTIkJu5juNqPotW4R/Kry0m7CR5bWiN8DFvIv/uFUlJbtwdx/VqSE+kfBWn?=
 =?us-ascii?Q?0OgFiYKqYFFeR9RdZ4XQWqu3+rbc9WWMaQIrMzF8kEK0ke1U6D7GRv+lIINp?=
 =?us-ascii?Q?r+7Bdi4Q/LvdoJc2NmR6tgARsPJvweuWfg2ueFfRJZOINxTKDwP3DQOWslhP?=
 =?us-ascii?Q?IGDygFEaAVzW0tVz/kKPz/yg1e43hwbeW5zxpxzi8FrnhmiBQCJB97zTvuL8?=
 =?us-ascii?Q?rNNh5IITkKnvMFDl4H6clMCTeunxDFlyhWk0FgiFEQJI1JsTOPwm94EFitnL?=
 =?us-ascii?Q?EDDIb+fQau4exNd9PlC992MyqBF/1uskmKyrHQHt8l87Q3heJyDQdwxWP8/k?=
 =?us-ascii?Q?zRt1Raj9Z6tIGlFhGH97oeKIpHoA3lW36TqGWNKhjmOUHW2oUrUdXbDtg2tu?=
 =?us-ascii?Q?/nnlaXFIIwMF6u8vJvSvNhnc5zaJ0uG619togznO4uljPGfQdBVLwBt7VwwK?=
 =?us-ascii?Q?TGUDXvZtpjF3rXtlOtIQ+dz/3BndAouFqB+GZtSlfGylC1gCqybJvCP6swII?=
 =?us-ascii?Q?/kW/wgSqlk8BGlF2CcytpeZfZsuaZMOkAcZkaTy7phsXNZZQajYOFreQzlwy?=
 =?us-ascii?Q?WnzPk1A2wjTaqPwUrf1JbVo6KZs3hdmj8t753Eg/ERkFV0MZi2zppC8FUY+P?=
 =?us-ascii?Q?rvqslxY7TtLx9r3bozhAjgcXgns/b5l8Gw31uLlFFzp+C9bGJ84c7t70x/9r?=
 =?us-ascii?Q?KDRC04fKDapfVFGLfmNTrWWVs7QTuK6wb00ILJnhvqRk5KB9XgwddK/uP6Ai?=
 =?us-ascii?Q?Lu4R1f8ShTn/h9uww3tWl4f9kEgj604Jd2MLofqFM54VB6Yc8hKjxhbbw6Nu?=
 =?us-ascii?Q?sGuBjA1Fs7H5W4ewD320Yys=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4063bb-683d-4541-507d-08d99965d6d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:21:32.5976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ER8I3hexb6/tWLEYPCRHalHQ36ytbGak7Ma9Is/s+uCZ0D9Kz1XkXuOoclNCML11JVXqaXcqIK/r/YYAmtHDvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to fdb_notify() and br_switchdev_fdb_notify(), split the
switchdev specific logic from br_mdb_notify() into a different function.
This will be moved later in br_switchdev.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_mdb.c | 62 +++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 61ccf46fcc21..9513f0791c3d 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -759,10 +759,10 @@ static void br_mdb_switchdev_host(struct net_device *dev,
 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
 }
 
-void br_mdb_notify(struct net_device *dev,
-		   struct net_bridge_mdb_entry *mp,
-		   struct net_bridge_port_group *pg,
-		   int type)
+static void br_switchdev_mdb_notify(struct net_device *dev,
+				    struct net_bridge_mdb_entry *mp,
+				    struct net_bridge_port_group *pg,
+				    int type)
 {
 	struct br_mdb_complete_info *complete_info;
 	struct switchdev_obj_port_mdb mdb = {
@@ -771,33 +771,41 @@ void br_mdb_notify(struct net_device *dev,
 			.flags = SWITCHDEV_F_DEFER,
 		},
 	};
-	struct net *net = dev_net(dev);
-	struct sk_buff *skb;
-	int err = -ENOBUFS;
 
-	if (pg) {
-		br_switchdev_mdb_populate(&mdb, mp);
+	if (!pg)
+		return br_mdb_switchdev_host(dev, mp, type);
 
-		mdb.obj.orig_dev = pg->key.port->dev;
-		switch (type) {
-		case RTM_NEWMDB:
-			complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
-			if (!complete_info)
-				break;
-			complete_info->port = pg->key.port;
-			complete_info->ip = mp->addr;
-			mdb.obj.complete_priv = complete_info;
-			mdb.obj.complete = br_mdb_complete;
-			if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
-				kfree(complete_info);
-			break;
-		case RTM_DELMDB:
-			switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
+	br_switchdev_mdb_populate(&mdb, mp);
+
+	mdb.obj.orig_dev = pg->key.port->dev;
+	switch (type) {
+	case RTM_NEWMDB:
+		complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
+		if (!complete_info)
 			break;
-		}
-	} else {
-		br_mdb_switchdev_host(dev, mp, type);
+		complete_info->port = pg->key.port;
+		complete_info->ip = mp->addr;
+		mdb.obj.complete_priv = complete_info;
+		mdb.obj.complete = br_mdb_complete;
+		if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
+			kfree(complete_info);
+		break;
+	case RTM_DELMDB:
+		switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
+		break;
 	}
+}
+
+void br_mdb_notify(struct net_device *dev,
+		   struct net_bridge_mdb_entry *mp,
+		   struct net_bridge_port_group *pg,
+		   int type)
+{
+	struct net *net = dev_net(dev);
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	br_switchdev_mdb_notify(dev, mp, pg, type);
 
 	skb = nlmsg_new(rtnl_mdb_nlmsg_size(pg), GFP_ATOMIC);
 	if (!skb)
-- 
2.25.1

