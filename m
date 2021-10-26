Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB1743B720
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhJZQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:29:20 -0400
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:18188
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231880AbhJZQ3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:29:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYSV763fFg1+kSiIVmV8Z18SHTjHik6gfumSI1bUxYurCotJqsJseL/B72zwY08Nt7+Ku7xPLHCIkaMbMLimvULTA1LgFyqC5Fv2qt7uWSzqzDkCmdgOFVCAAdUMDEIdpaS++v3XEkAUuPiI8crAFG2OPJViEas1AScBI2Coz7n05qyGIrQ0dMem+9hLksf81X9OyXqgAdxSbJU5ZBR+dtNIx0nJcBGhziL5kjh7spVI5jLsQHXKAqBYUlBzZVNGKyIHX92RMmHfQZyebkeJUId0+wLpWsIUQP4bgFHwEIoqERNyvUHu7c/rPErZAVRf9RBT+nZiJYtOFeRQAGhlMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtIUonAX3PY2QmnNbmone/7T70Npy5w8S0NfhLUkYTI=;
 b=l4TqPt5gZuzsxfiuyG3ofWGBjF0fOxk3ZhKTiah73iF0dyzFUpEQK5kP8yf4FXnkzIXL9JH3ghHg7EVENpyOup5pNV8U/p+25Jcr3HaHAPj4+J3ewc/I7lJuWBp7znVgRH/jpIG3df9b/3bSroZyT3GY4/xP6zmz58JVRt0S8CC3WxmdNCT2xK+usT+BQV4PgdbUCrR8hX+NiYJ58EVFPP99VFKJkLEsMjvfaXyXPXv0ilhOg1gFV+M0SCcXhQfTuTYRRvYWo7Fk7fXqsaWjjxOG76MvVmUGq57cewc0Hq7uwQhhoABPHVuJSk7gIogvMcf+HRlPUXoDkEG+4LOdYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtIUonAX3PY2QmnNbmone/7T70Npy5w8S0NfhLUkYTI=;
 b=sgJVFAQPDfzfni10F37Nai90b+ee0oyI4N8WG44jKmP+/etBCIfbV1o1Qor8ViYZNvGmAjZi5zQ20O6jz9Jks+o+huszvlhafL1kXOySddAW7QzPn0cVrt5bUOxWVIiHLb9RnADD1P12vNTaL7xyQpXRkQEDGspmxFD3EUyqskM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:26:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:26:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [RFC PATCH net-next 2/6] net: dsa: assign a bridge number even without TX forwarding offload
Date:   Tue, 26 Oct 2021 19:26:21 +0300
Message-Id: <20211026162625.1385035-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 16:26:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7771a1b7-fda5-451d-3b1f-08d9989d6a1e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4686218C2498947234FF74B7E0849@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vBjaT2RYAO2crBSYWTh9X2nerWMOpuVatxr7wHcI/SNNmfu5IAlnU1LcO5MafZpCfW5QJ0vYTsrgJucXgqx6XXxtYDCq9Ybn7ZMmR+a/PP+zPlYCoq5p69uulBh2FaDyWlv3rYVagbV+jz9XHst4IO8fl/aMlboFgEyZA7p6zSnR0SbONsElWdclUSyGrTOutvgA73G5MCyAJg5mQH7PTKYWgQxhGEIHm/abAQlacBS3n3MZIbug2nVg2TwC1CskmkAXYsvQXg2Q1cP4aL5srrSm6fmOqKiV0xVdY4fahCJPFnVyjXdkQ4M8CHdrB8MRprsa90HZlbD5z54IVn5LxXQTOEno3vdEzgAtHC3HM8IFh7XJ0pE8H3WrTDvW4htlAwtCd9du5gBY7N8Fzoo9ENqm0xrsytU29Ci1Dd9A1eiauZAwLhusCLu5Ba24cBgBJymBrINaB0EkXmVNayPcy1PxV9D7iGwUQ2BkjLXNMbjfo9ARiSDieWW2mtZXBAB5mpF/HCtKlWqkQPnV5HW8Y9H21oNaR4+P5kEfyfks/0u0Mhe7PyW861rRV+dt6qh7xQJ5Z4rN8CKLiLr+7ZkXdHg7LekF6eAhnX9s0TL/3F4OZvJO7FJ7kJpSs3MJ4tf5AhrKikq6LTnYSemWqU6Jsqkr6Ew3CEalDbk3hOaHQnt+puYqBZOQmjSZ8OwL0p2kVpBWWrKadzuUHYg6o9Bymw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(6916009)(956004)(8676002)(66556008)(6506007)(1076003)(2616005)(508600001)(186003)(6512007)(38100700002)(26005)(5660300002)(6666004)(66946007)(86362001)(44832011)(6486002)(54906003)(52116002)(38350700002)(2906002)(66476007)(83380400001)(316002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5T2s3+95gPb7VXgzE2ccZGR4xYnK6mipApkEBUWKs39JKcPshoWX3Vi5mdes?=
 =?us-ascii?Q?RwsSdOv7BjMhb/w/od7eCFmH7vBfSioUH/X0dV5jvG2L3HGKwQXtjOh12EHD?=
 =?us-ascii?Q?2gV+qM6ju0G4nW9phX2gvyfaMzI2yGNtK4NGG2bZgXVVEM+uwiM1RCpk1foh?=
 =?us-ascii?Q?h8fW4boHNdF3ARBcuTLF1q23MRqSZTX4PMMeIqDkGSaAi04V4PVmOXjuSZlX?=
 =?us-ascii?Q?XaZJwrbwwjbU5p8OeWaInvoTTJVsqVsqTVfVlT9AG4RxsHzUU7eC11pbHi3L?=
 =?us-ascii?Q?2zJ9DY06XChaMgK57uMy/pM6GRnMTnuEBn8Oav85ps5T1GSfxgAwvnOw8sPW?=
 =?us-ascii?Q?nTf52dF0nn6alcgGNRlhjTtkmFEOARJZVHKuGShnyQ0v8GMySebJM+oH3MQq?=
 =?us-ascii?Q?DKzRUFRsEb91VAgsaKqOmfSMLhYAYphuCHvMdjN0IMvfzQc7ycKLkyGff70F?=
 =?us-ascii?Q?Ru1WzPZTEXuN6Addbhb/hxxfqE3IAGsE14rw6UrTD76Tyu2BmsrKhyGNHtKC?=
 =?us-ascii?Q?rJ9DYIGdmg1uaaffUyNIyFkRZp94/TmD1Ws8z99eY9AyEKjxd6DSTv00HpaU?=
 =?us-ascii?Q?KlKUCbvz365DrIS0wLW2as6Y3/luVMHjbTEz82vfjW7KQBs+QSFu3v5xiLbH?=
 =?us-ascii?Q?wgdkYiRFXkAvaPfwhvCG1ty1wONuERfiL3DZjD55X5kyZuCxmHBL4gdQRSza?=
 =?us-ascii?Q?Jt6CfIHowjZSLRNiPueq7hHlnXo/Ptodxvv1iQ21RksuQsm8QE1GS09A2ka5?=
 =?us-ascii?Q?TJ81AL9RRFBbTsFwLiIItLSQm5blu6TlXBqvYGmoS3BEAkRjnxmcbOFxWb8t?=
 =?us-ascii?Q?GQiotbcJF28ML3GLH4q5r+lsOj/FWDv9ZGIlWrFYofYueNZfTe3oyetf15sF?=
 =?us-ascii?Q?0UkYHvgEYWSVUbWcY/IAPSN7KIgi+2oN+4ynZUFtru4Tx/B7pdexzjmuaXSV?=
 =?us-ascii?Q?eOOkzUluth0eAQvSbit79wGKzcQHUOV7JB+ma42MQHHE5hVDFfq0bpaVBX4R?=
 =?us-ascii?Q?o+atx4uOlS2YoIF+lrd9zuxlF2zeLMe6mlShMM0su6HRTG+iaQWMbvZHaFyD?=
 =?us-ascii?Q?gSJlNt2jYYjrQnL1h+TctK2NCod9/cswv+moZXgm0tavyjKwF8i4O0Mjeqqx?=
 =?us-ascii?Q?/oKIp/YOifeHkR+5hqol0rYU0HE1fjE3gZBob0orhJcrBNNt2TdSiaQ3a915?=
 =?us-ascii?Q?9SNe9FWP+VZiuQm0B5rJpJsv2ef0LrhWGgJ/MDNy6CClja/ok2i6mgNpwxFz?=
 =?us-ascii?Q?ySNQjZ8pEMZsQUqNqaUGNpB1fq3zZeA49M+bDsCGWbfQ/GGadz2Al2bj7BCt?=
 =?us-ascii?Q?adtZi84GsDsDTdQi1WhdP5m38JChC35bjyIA1n24n2422KxlYtdvkDfjJCQR?=
 =?us-ascii?Q?EQkHFyTaG4LajIkp7YG8THjclPjU9GBUjiMCrz3RLq84qb2K8U4kefhYQVy3?=
 =?us-ascii?Q?wVkMd7Giy9Bd9gS98dJo+DvVEuouBOylH0EaBSH29yX0/Xpbo57inwXtpuk8?=
 =?us-ascii?Q?EcRlQNYMHU2ZNZ3O+wKYkMZLOifMc/wBd07/QtyhYViqkSD9bvuT8cDVVmu4?=
 =?us-ascii?Q?zR3BUuVijkBi4eQDuU8XOBACDrernSk2Tu7EHf51vu9oRfZNz6dtJA/h/lxp?=
 =?us-ascii?Q?3bzltHuXdqPIumSijkfRIi8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7771a1b7-fda5-451d-3b1f-08d9989d6a1e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:26:50.8398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ariU4KiGzLlRwVWXobf8HLkutti8Z7eIMTMq14fq4XGLymp+yAysD5PUQrdpacJ+leys+LWvE638W078jrj6/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The service where DSA assigns a unique bridge number for each forwarding
domain is useful even for drivers which do not implement the TX
forwarding offload feature.

For example, drivers might use the dp->bridge_num for FDB isolation.

So rename ds->num_fwd_offloading_bridges to ds->max_num_bridges, and
calculate a unique bridge_num for all drivers that set this value.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c       |  4 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  2 +-
 include/net/dsa.h                      | 10 ++--
 net/dsa/port.c                         | 81 +++++++++++++++++---------
 4 files changed, 63 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0d0ccb7f8ccd..ae09cbc2f42f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3183,8 +3183,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	 * time.
 	 */
 	if (mv88e6xxx_has_pvt(chip))
-		ds->num_fwd_offloading_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
-						 ds->dst->last_switch - 1;
+		ds->max_num_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
+				      ds->dst->last_switch - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c343effe2e96..355b56cf94d8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3139,7 +3139,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->vlan_filtering_is_global = true;
 	ds->untag_bridge_pvid = true;
 	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
-	ds->num_fwd_offloading_bridges = 7;
+	ds->max_num_bridges = 7;
 
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 56a90f05df49..970bc89a0062 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -413,12 +413,12 @@ struct dsa_switch {
 	 */
 	unsigned int		num_lag_ids;
 
-	/* Drivers that support bridge forwarding offload should set this to
-	 * the maximum number of bridges spanning the same switch tree (or all
-	 * trees, in the case of cross-tree bridging support) that can be
-	 * offloaded.
+	/* Drivers that support bridge forwarding offload or FDB isolation
+	 * should set this to the maximum number of bridges spanning the same
+	 * switch tree (or all trees, in the case of cross-tree bridging
+	 * support) that can be offloaded.
 	 */
-	unsigned int		num_fwd_offloading_bridges;
+	unsigned int		max_num_bridges;
 
 	size_t num_ports;
 };
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1772817a1214..b7867746af15 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -271,19 +271,15 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 }
 
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct net_device *bridge_dev)
+					     struct net_device *bridge_dev,
+					     unsigned int bridge_num)
 {
-	unsigned int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || !dp->bridge_num)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge_num)
 		return;
 
-	dp->bridge_num = 0;
-
-	dsa_bridge_num_put(bridge_dev, bridge_num);
-
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
 	 */
@@ -292,31 +288,60 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 }
 
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct net_device *bridge_dev)
+					   struct net_device *bridge_dev,
+					   unsigned int bridge_num)
 {
 	struct dsa_switch *ds = dp->ds;
-	unsigned int bridge_num;
 	int err;
 
-	if (!ds->ops->port_bridge_tx_fwd_offload)
-		return false;
-
-	bridge_num = dsa_bridge_num_get(bridge_dev,
-					ds->num_fwd_offloading_bridges);
-	if (!bridge_num)
+	/* FDB isolation is required for TX forwarding offload */
+	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge_num)
 		return false;
 
-	dp->bridge_num = bridge_num;
-
 	/* Notify the driver */
 	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge_dev,
 						  bridge_num);
-	if (err) {
-		dsa_port_bridge_tx_fwd_unoffload(dp, bridge_dev);
-		return false;
+
+	return err ? false : true;
+}
+
+static int dsa_port_bridge_create(struct dsa_port *dp,
+				  struct net_device *br,
+				  struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dp->ds;
+	unsigned int bridge_num;
+
+	dp->bridge_dev = br;
+
+	if (!ds->max_num_bridges)
+		return 0;
+
+	bridge_num = dsa_bridge_num_get(br, ds->max_num_bridges);
+	if (!bridge_num) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Range of offloadable bridges exceeded");
+		return -EOPNOTSUPP;
 	}
 
-	return true;
+	dp->bridge_num = bridge_num;
+
+	return 0;
+}
+
+static void dsa_port_bridge_destroy(struct dsa_port *dp,
+				    const struct net_device *br)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	dp->bridge_dev = NULL;
+
+	if (ds->max_num_bridges) {
+		int bridge_num = dp->bridge_num;
+
+		dp->bridge_num = 0;
+		dsa_bridge_num_put(br, bridge_num);
+	}
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
@@ -336,7 +361,9 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
-	dp->bridge_dev = br;
+	err = dsa_port_bridge_create(dp, br, extack);
+	if (err)
+		return err;
 
 	brport_dev = dsa_port_to_bridge_port(dp);
 
@@ -344,7 +371,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br);
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
+							dp->bridge_num);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -366,7 +394,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 out_rollback:
-	dp->bridge_dev = NULL;
+	dsa_port_bridge_destroy(dp, br);
 	return err;
 }
 
@@ -393,14 +421,15 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 		.port = dp->index,
 		.br = br,
 	};
+	int bridge_num = dp->bridge_num;
 	int err;
 
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
-	dp->bridge_dev = NULL;
+	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, br);
+	dsa_port_bridge_tx_fwd_unoffload(dp, br, bridge_num);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
-- 
2.25.1

