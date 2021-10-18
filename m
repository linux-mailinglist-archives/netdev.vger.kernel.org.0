Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF024322BD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhJRPY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:26 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:36421
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232844AbhJRPYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOMQgvB0B8w3tCe7S7+sRWtor7n0eDWV7iIYboIMfH/nWvfUiN7Eke0ukFgKL+0SKUgudlJUTGUiCfYND+JvgvaH6ZJrFZajlZgGG7MYjZsfF0zoStEZ6CfMmF8/wUjmAqHmCytQO/dsimxUPQBSxt/8+MswQ4HUsoNEjLOgaCGlCPncYIbGUXavuDgysux8Kt1h31oCF8H5nrv4D1/tnLEaSIj8rzpmAw4k0n4gIAy9QscorfMYQVrLKZTBhpVgialu1P9lqv0bdqL2TiOWGva7YhLPpwuLcNj6aWfydJybsxqjHZEw0630eiKD3rmwTEwbdWmKPjZXjsuO5kF3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhDPqfCtMbrjhMKDsPWa6KGR4RWyVUJqTvm3fWNpQx8=;
 b=AQoNfDwvTvgJ/ksH+pjvj20+bcsgSmKbMU0JtXCvFoMuK3O6OpNliYPzGWBxDsUJeo6wOY4GUh7TbNZh8fJc7HZMm3Hds1y/buHDUcNvlYCDeDJcTdxp3qrJbm8jb6IshxWhjFRJjUfD32gCQj+14L8q35qPpcb7m/5+0KSJEjJcZEduFSwGQFTOFeiwEfeKxxB6tUDoiP9WPwJWdGgdu3fWqJLrseZQXB4lZhrkZHKnCqOk9jPCVsyEsOKJqPbgiSSrzCqwvRBuhY/Le5J5sIJ8AqwDSDb5Az1iyDivILmcNJ2PFuphrhbMxMqeF0WZhly0xEhs8nlI/n4Fquj9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhDPqfCtMbrjhMKDsPWa6KGR4RWyVUJqTvm3fWNpQx8=;
 b=AiBHicw6uv10VggXWZlReVVF4EvRfjznxvEzRaZ8Cix1cmrXEcx3FkjUy3ko+0eztxViBmOCGjlZ6sfRNw3iuxUOWYCBD4zYCjevB8CQA4RpDPWQJxWi0mTti0qhwfu10z+YBVEvnD/L4fEI5PCWk5GxbWTtv04gHpBuLC/1hMA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 15:21:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 3/7] net: dsa: do not open-code dsa_switch_for_each_port
Date:   Mon, 18 Oct 2021 18:21:32 +0300
Message-Id: <20211018152136.2595220-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eacae89e-f75e-47d4-61c9-08d9924b057a
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268861CD977A37B2BDCC48CEE0BC9@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Aqw3tKRP44tohllqqfJ3aXmEBFMHAyzy30Vpmtj5NK1DK4YDg41OFH5GKvaKxJzQgWv5xBd6dfCYpIrwu5/XmlvXL5+WVPpefnQrEgkWvk34XSWirdpbYAxNG8GyNjsSr/6VuUbaz0Sw7qK3nwyyYEOVebOQC/n7CCW/S+pIeQJk55ew7OoywUWFx3KfwUejnMLN/b0FHFyQFjNt2WyhMonTmX71CrQHimro1CHXmCzmAADXWHqSkQhk3M8WHHuKqvawb/fJDttZMma0sezxPXMR+BBfFvZi84PS9IAicOiwePxuOLTPkMqcO0gJaP+I1kvRhW9ssMEBS80aNRngC9PHN9U/XlhU/ixsx4dZJw/S0PQEYYCxOdCztg07dwJFdgo3ieawBY9+1iiw01sc6bNXOwT3FI9bcR2jHuBTiyYHVuP8bKSvZiW1l9y5P2wpqc4sBcrAiFIW6GNFffTseEsrslhXuTQs+qDdVgM9ra8q6GyRu8stQrqBfHHRwrKhgwUHEqj4tv4QoR1h3pBxX8clCU0W9NIQ5xCVzCpcA9AFoIeLPxy/nHx4gT967TbefXfcd9uYdZY/UxPWR89IHzVRHMdpmIINsfvTgZaSc1F0v6tGN3j0zafEt1C4wtrJ0Sj5uR9RSU0HgwmEqfMpj6yEaxk4Aj+QvZbZjbBbHrVda2Kk/gViDTrxBIjGaxG4bdJb/6qNTH1XyepRfy3kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(110136005)(956004)(2616005)(316002)(83380400001)(1076003)(54906003)(66476007)(8676002)(66946007)(66556008)(6512007)(508600001)(6506007)(6666004)(36756003)(2906002)(44832011)(6486002)(86362001)(38100700002)(52116002)(38350700002)(186003)(26005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z5JZalBQfQSW/cEWZof/i94BFqhUAhnnqRR7yA5772Ss3OC5FzMXHPCCWEXp?=
 =?us-ascii?Q?q/uXz2GzlI3HOE7/ngR7PdSw4BjihbvGRkjoFCkWAqf2ag1RElg8JYzme5bq?=
 =?us-ascii?Q?KWYjQrRMSfp897Rrcv2bMAERFZflsP71JzTIVz1DEiaJYugS+UlwNfkBHvst?=
 =?us-ascii?Q?6B0EYXdbODhbHtkaPpyRdwMI/fw0ndJabWK1PWRZSuiNxacySOCaua0mrs7q?=
 =?us-ascii?Q?JUiFAjWxYFVaPGYyJM0PCJphHGQXi3ORfJy3xlDTFiUu0UdhpaWaiCmduCf2?=
 =?us-ascii?Q?t0ak8ge6OXKAhkifNSr92KhTPPz63+PfkGqiZsaxWdc3GxElM1dz1Zq/azgi?=
 =?us-ascii?Q?kpDl5t8+KwHzYf+JsteU9kSLsCK8SNiYSlwzbW9L/oUFyb6Z9R4NxoZHCwFF?=
 =?us-ascii?Q?/u+RDJD9dX/S63TABzbi2Wjgo7L8NV8JyNEEvD4rBCgVrb1I0xCqsnMQu9b/?=
 =?us-ascii?Q?I2ugr9L1zq0ksBXLcwM0gsa02LimwuO3XixCAPrhf4i/Zck2sNJdKutU1rw3?=
 =?us-ascii?Q?OnQBeC2CMPBR+uNyU++OG+elQqPnIi/Tfm6gvde3Rez0CbmEIh0u0+jglLwZ?=
 =?us-ascii?Q?ImXO+caylSN3EGrnDHHD1dgz7or5ZuvYUwA04BbsiClYY8F9MDt8abdPZeGq?=
 =?us-ascii?Q?VEXtr4jemibLeNPt08DgzkeEUyHKLtR3Z/MuQ1Htnp70paSYUSWFZfcLOPsQ?=
 =?us-ascii?Q?XzFDn8zn7pjtF6GcmN4jDrvY0hA16Qp6sd7vsMxqQertF8Go2LtNbhe+1SL0?=
 =?us-ascii?Q?bEbQ7q++WnOYxVwLzx7Wp4pXoRazouweK9Ak84Cc93s0BvJB52Fmc8mGKQYt?=
 =?us-ascii?Q?OIueQKvNgxvsuI7b7HIzdK6hSLRh+pdK5r6R4AzV7q02reMaZV1iXlldHZ9F?=
 =?us-ascii?Q?zoqoH5uxKzC8vhCPaaRMASF0jnvitu/ydo+JtQj00XQtROTSxfGAlEaIw+LJ?=
 =?us-ascii?Q?kYhwFBZRY7/+lwR04azclD5Gs2imk2zmpax7eCqz55kxG8kCFj0uRfYPuP/S?=
 =?us-ascii?Q?fQNeJQe6H43PSiT/hNHcjgOFcbnKb+Bkt2PYVB42cGNsvm4FgVK2F7fjDAtu?=
 =?us-ascii?Q?mvtzshNiLCoMtcvJJgBOgEXYxIRbhZEvMex5i94z7eJCAuPoCj7gOtU+kA8N?=
 =?us-ascii?Q?O+UtFNRmn+ll6B3w/VTm+86h6hK/Q8LvK7gPlR4a7YC4V4VVGuB+m4OgWCIy?=
 =?us-ascii?Q?TAgdOSMAoEO6/otS5UXTxr90MlwzoVLoZ8CJw1jxtxtflorUHwiwTdCCyUmO?=
 =?us-ascii?Q?LRii9ciL8cFa2U7Gg63LVTT+q3GhkvL6OorgZguHkqNd5AP4TVxYt20R5dLt?=
 =?us-ascii?Q?3FbJhmiDik6DGdfLSK275EAC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacae89e-f75e-47d4-61c9-08d9924b057a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:56.3443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epXk7LqEYxheuNLjrAMc+Vrr48RVznDGMl00SHb3hRxQwK8Kbcwn+LBF0Ro+BeI2OeeuUZV4WiGbPJ+UbmM+gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the remaining iterators over dst->ports that only filter for the
ports belonging to a certain switch, and replace those with the
dsa_switch_for_each_port helper that we have now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1c09182b3644..2a339fb09f4e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -399,11 +399,8 @@ static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
 		if (!dsa_port_is_cpu(cpu_dp))
 			continue;
 
-		list_for_each_entry(dp, &dst->ports, list) {
-			/* Prefer a local CPU port */
-			if (dp->ds != cpu_dp->ds)
-				continue;
-
+		/* Prefer a local CPU port */
+		dsa_switch_for_each_port(dp, cpu_dp->ds) {
 			/* Prefer the first local CPU port found */
 			if (dp->cpu_dp)
 				continue;
@@ -852,12 +849,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	/* Setup devlink port instances now, so that the switch
 	 * setup() can register regions etc, against the ports
 	 */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (dp->ds == ds) {
-			err = dsa_port_devlink_setup(dp);
-			if (err)
-				goto unregister_devlink_ports;
-		}
+	dsa_switch_for_each_port(dp, ds) {
+		err = dsa_port_devlink_setup(dp);
+		if (err)
+			goto unregister_devlink_ports;
 	}
 
 	err = dsa_switch_register_notifier(ds);
@@ -901,9 +896,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:
-	list_for_each_entry(dp, &ds->dst->ports, list)
-		if (dp->ds == ds)
-			dsa_port_devlink_teardown(dp);
+	dsa_switch_for_each_port(dp, ds)
+		dsa_port_devlink_teardown(dp);
 	devlink_free(ds->devlink);
 	ds->devlink = NULL;
 	return err;
@@ -931,9 +925,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->devlink) {
-		list_for_each_entry(dp, &ds->dst->ports, list)
-			if (dp->ds == ds)
-				dsa_port_devlink_teardown(dp);
+		dsa_switch_for_each_port(dp, ds)
+			dsa_port_devlink_teardown(dp);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
 	}
@@ -1180,8 +1173,8 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp;
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds == ds && dp->index == index)
+	dsa_switch_for_each_port(dp, ds)
+		if (dp->index == index)
 			return dp;
 
 	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
@@ -1522,12 +1515,9 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 
 static void dsa_switch_release_ports(struct dsa_switch *ds)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *next;
 
-	list_for_each_entry_safe(dp, next, &dst->ports, list) {
-		if (dp->ds != ds)
-			continue;
+	dsa_switch_for_each_port_safe(dp, next, ds) {
 		list_del(&dp->list);
 		kfree(dp);
 	}
@@ -1619,13 +1609,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	mutex_lock(&dsa2_mutex);
 	rtnl_lock();
 
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (dp->ds != ds)
-			continue;
-
-		if (!dsa_port_is_user(dp))
-			continue;
-
+	dsa_switch_for_each_user_port(dp, ds) {
 		master = dp->cpu_dp->master;
 		slave_dev = dp->slave;
 
-- 
2.25.1

