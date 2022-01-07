Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA78E48796C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347998AbiAGPBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:23 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347969AbiAGPBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMsJhdLl6TVaheSHSFDFnJVAL2t7R8gdEwHwQEQdu/jB6vugHrSj/1GX0BmmTYoec/AOmX4vRhT68mcARYwK7jseVUymBg2Q1ySNhqSf9axGUYEjR6S9TZ0fVL31XlZx+ANqnwrjiJsH/gsJOvqyGdPtPRjqdzqzv9MNF0YUv7prl9tMIqO+9ZvN6cCa/xxL9yDYPWolsQJQtIYMDiToG7xFvqEA57vHhuFd7yxUqEChqBg+QLN9yTuIYssYiEP8K8Imdf9alX/BRx26v4am3Xqj+OcD66j8NdrtP9oKhRB7w/JqL1YawLSPtoPNlmadNJbmwf0dbj8aOJe4Q3OTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7IBSdp8XX7ASk76leB6AIaPYGHPYjiFq+9mEU9EvEQ=;
 b=fU+azpqvvBRxoU9gvkV7Y4Pu1WBzkuk5YzJO+cLsn7FV6Ip2SXCF+VnTTcKK7q2+hs5lN286Pw3Py9SvKAO7qn7Mf9n+0gFKVXECzg5xkQnCLebpSlil2+bRwaD4KZvEntjXPDrGhpL+8Zm1EZyGunaxLgWgyhdwNrHYwp4sD96ZOq6Ep/PgzQnR9/PgtuC88lRvj35HBnIq/jJNjExIegJLPvu0Xk5rf/5nFDeC/4H5RgZZVCNWPa/k6fzwsskcQt2Cw9PoStUw9y5/df5hFPH5Q9hm4tJUeRGzkszkdO+VUnc3PXZbpf3u94jcbBlxUsfdBPfRpYjlCtDSJELPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7IBSdp8XX7ASk76leB6AIaPYGHPYjiFq+9mEU9EvEQ=;
 b=Ga0Vk/WVgN2x35jJA+MyQ9rNkr0BoH1q9VFqebRD8kU0uplC25qCserz3QHVkpCAfOmE2vX67ylQvTtYWQk9Le2M3S2Xc69U84NBwq6n/R8aLRhoocZaNBrJOB6NLBuzwIjneV8zLJa5TZfI1uXLosSE5BOwCbqEpmuF+SmNNs4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 04/12] net: dsa: make LAG IDs one-based
Date:   Fri,  7 Jan 2022 17:00:48 +0200
Message-Id: <20220107150056.250437-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9269e05-602e-4f08-9e08-08d9d1ee8a62
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34083597B40D0CC45EC6C8AFE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3TYUOChJRbprTPK5ATa+fqqbXiTbS+oIMtD2rvuhEvOKoQc2njozKGqDrKEFtVIb+sUODGap/yFrp7kssHTPRr585k6Vv0AXnY5YXclBLF1LYkmW+22U7A6sLtHMgJ13nISzczkMzbW+BjMEw1uQoZvvJRNLyL+UvqOxAAVjUagZVZd2avJo4s8uXjp46UtzzW+Kbnud2M7b9AEPancXCvET5gtUaOKy2hXLxPVsk2OQeTb0WbyemgFvtZcrwuT3wcmt57hubzXrXWM75+9bSz5eH7sf17V4RKl2PJiiYX7eey4c1kkRqWM++aT1/bz8niXlwc0GmhDqil6lR1r9Vzy2Jr9sSfabMkUNnIVZ64A93YOd4wz8q15eLO3MavN3IXa4FOqSaEMntOIMkZPq/4FzBxcF9ryKx0cwYoy9frGDrlWxRtthQ8ndu56nSvq9xwh8Hx8ev6zuLd7ZiHm2zhwvUUg6LaAXh6Fs95ASaiXxex4JJD6WwiwEdQS88xZnLDns0k9ZUy5zMRRwcwtd3lErXFIujzVkBwanhyAjull8wgoDXY3YbxfRcAg9i4UjTMiH9IQKgOhduP149Tywwx3vFXSburqozJJMupPveU3irguaO+AlkZUlNxqeMbqZwjcPtTC+IjZbfEoC/fdOZ8cTLU5k299X4Qeyaq9I3SRZolL+cbN5pRlkLa+Kqqs0W8BDZnhNTioB2/X0v4HMtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfWT09oeBhueiRkPidouh+kjHCD7oSlD8sp0m3RSctpa+2LEE810oJHgX/cJ?=
 =?us-ascii?Q?y4uw+MbjCqLDYF9ZkHODIrNczF5Fuo8/1o5jxoj1jE9Z6wUzdwZI2OIiUZrK?=
 =?us-ascii?Q?sFjJXOLIBu/ZvYdB6n98Dwv0kcxxgni8ifmT6vNwKyTN9IKtdU26ZMBCxbo+?=
 =?us-ascii?Q?Itunn9kVG3SKFYnQ37Xp2lQL+WkOGo4AR6AFyGC4CiNZ0iXVlAmTkwpD0sLu?=
 =?us-ascii?Q?xA0CxjNIWOz+k6tEVY1Wo2sOGHacoP7X4MS++Z5ZTrEtQMTahBIzMb3PDhvO?=
 =?us-ascii?Q?d9aE55fPwl5glFjCP21WBeT0ei1Nblmz1jWyTFOvT0bZEhzbBTsVMc9GNGzi?=
 =?us-ascii?Q?2GqWV20XQEmmzIXpLpLG3fq4Et5SH3nmTJs72g/tx2/9BOzozCrpGiGek1M5?=
 =?us-ascii?Q?P3hEAZboWG/UdE0qXXs6bHXcqVLcFusDjmcxK+9+kCNpO6SB9L60eH1CgZ6+?=
 =?us-ascii?Q?I+RUByiSh2XbcviP0WtOVq4icAWvDT76e3cyRo90+sldGQR2xtjm8RKf9DEc?=
 =?us-ascii?Q?s2W6DtEB4QgWOCa/N8NpfSzHftk/EAeqvc+WvFMjslzZ6+E7GDdyAX3hqRO/?=
 =?us-ascii?Q?Lrer9N1+MRO5K3NePVfhJJYmGTupF6hwk6GGgKE/LURRJYO0QUGnTYzEibvw?=
 =?us-ascii?Q?3POH4FoTnMozam6LzX+56RJzaeEcpvzWsoBtyJ061khUdudssvcbHRRCjqkx?=
 =?us-ascii?Q?8xVGyks2hx+iiG/ZKv7YlM69zCZsxe2B2em74Qmcg/43hKLKPrETj367box9?=
 =?us-ascii?Q?TZVVJfiqixy2mYEbCdnQLqtsbI0lHRyUziqO+33tOiqBKNJekdv4i6MzBMrX?=
 =?us-ascii?Q?tl+xK/C2SQOmADZE7jsd6HCEwLl6SJJD2wIZbWhSYF9gHCb3YOoe2styx7Et?=
 =?us-ascii?Q?7zao7tQ1cT/FZQd8cwxw19Xl6Hv9kK6LNHvNGfK6oKYdHvQ6vcinNZ3JObLZ?=
 =?us-ascii?Q?grFqXxoPqirGGJDKSbE6B7gaeyRE/ImXcUf14kQPPZdoaPOPvu78t7fwy2DV?=
 =?us-ascii?Q?pQixWa1olnCYCZoH5k1BLvr3O4k0IgIZ88Ph645tjCbet7s1O9G9jhJJQSR4?=
 =?us-ascii?Q?qSh+X/5pliP7KpTPx7piGNpmywjJ82CfbJnKUvXEmGiUmXVccfIHzaf17US3?=
 =?us-ascii?Q?TzYDiNEUGO2fYlh6ln9my2fY62bSTqYyGnw5ZFvwsTUS1q7kXTKaaLhYnzi/?=
 =?us-ascii?Q?oTNmxWcQyWnFGXyKyeaN3UFk9IwbG2ML/ZBpHOvxzkkqAENXc7BgkdvHrcz9?=
 =?us-ascii?Q?XYOGhdUdQkwX8nLTMEn8iNYXr31PIHDiFaITFqxTq5d7A2cg+ZGN5pGDf2IQ?=
 =?us-ascii?Q?knoglhc1Ar/BiGlxH+IxNcjI178cv5h5CCaHshwNkA/i/xF1Aczu9b6qfusn?=
 =?us-ascii?Q?SiA2WaRQrlb/6+tCTOlKY7b8fbR0lehVPjkISvPsxlnODoTzChSq7Hotc//u?=
 =?us-ascii?Q?n8mN0dQCxfYkuVlB5HzfWE0E3VmhzBcurz69r8NGTVmqtZdVL5ea6xSTJDu9?=
 =?us-ascii?Q?3mGWBMzYwRaonaf+fg48k5LIZVbPbHjXp07YRQjmauNG2K/c38OA5w+ckoTS?=
 =?us-ascii?Q?uBeSSd3DPHrHjhx4bocgNveQX9VMJFlAVjgLAaCbS23CUUC4o8D8BC1V6pqk?=
 =?us-ascii?Q?EsYaQth2KXCGF66jzrAca6Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9269e05-602e-4f08-9e08-08d9d1ee8a62
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:10.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8HL7Md36kOJRkAfDhmrPlzI5dvyqX3apEItzNV0qiOJRYuiT/IzbkpnA7uswkX/B1rc1S9fIbZy8gJhFlGMUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA LAG API will be changed to become more similar with the bridge
data structures, where struct dsa_bridge holds an unsigned int num,
which is generated by DSA and is one-based. We have a similar thing
going with the DSA LAG, except that isn't stored anywhere, it is
calculated dynamically by dsa_lag_id() by iterating through dst->lags.

The idea of encoding an invalid (or not requested) LAG ID as zero for
the purpose of simplifying checks in drivers means that the LAG IDs
passed by DSA to drivers need to be one-based too. So back-and-forth
conversion is needed when indexing the dst->lags array, as well as in
drivers which assume a zero-based index.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++-----
 drivers/net/dsa/qca8k.c          |  5 +++--
 include/net/dsa.h                |  8 +++++---
 net/dsa/dsa2.c                   |  8 ++++----
 net/dsa/tag_dsa.c                |  2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ba56c79b43d6..365a03d0f251 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1481,10 +1481,11 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 			 * FORWARD frames, which use the LAG ID as the
 			 * source port, we must translate dev/port to
 			 * the special "LAG device" in the PVT, using
-			 * the LAG ID as the port number.
+			 * the LAG ID (one-based) as the port number
+			 * (zero-based).
 			 */
 			dev = MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK;
-			port = dsa_lag_id(dst, dp->lag_dev);
+			port = dsa_lag_id(dst, dp->lag_dev) - 1;
 		}
 	}
 
@@ -5957,7 +5958,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 		return false;
 
 	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id < 0 || id >= ds->num_lag_ids)
+	if (id <= 0 || id > ds->num_lag_ids)
 		return false;
 
 	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
@@ -5988,7 +5989,8 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
 	u16 map = 0;
 	int id;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
@@ -6132,7 +6134,8 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 253de3993a95..5befe3382d73 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2220,7 +2220,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 	int id, members = 0;
 
 	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id < 0 || id >= ds->num_lag_ids)
+	if (id <= 0 || id > ds->num_lag_ids)
 		return false;
 
 	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
@@ -2298,7 +2298,8 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9af3a8952256..28d657d3d807 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -163,9 +163,10 @@ struct dsa_switch_tree {
 	unsigned int last_switch;
 };
 
+/* LAG IDs are one-based, the dst->lags array is zero-based */
 #define dsa_lags_foreach_id(_id, _dst)				\
-	for ((_id) = 0; (_id) < (_dst)->lags_len; (_id)++)	\
-		if ((_dst)->lags[(_id)])
+	for ((_id) = 1; (_id) <= (_dst)->lags_len; (_id)++)	\
+		if ((_dst)->lags[(_id) - 1])
 
 #define dsa_lag_foreach_port(_dp, _dst, _lag)			\
 	list_for_each_entry((_dp), &(_dst)->ports, list)	\
@@ -178,7 +179,8 @@ struct dsa_switch_tree {
 static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 					     unsigned int id)
 {
-	return dst->lags[id];
+	/* DSA LAG IDs are one-based, dst->lags is zero-based */
+	return dst->lags[id - 1];
 }
 
 static inline int dsa_lag_id(struct dsa_switch_tree *dst,
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 16ba252d1417..c1e40ff559e3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -85,13 +85,13 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag_dev) >= 0)
+	if (dsa_lag_id(dst, lag_dev) > 0)
 		/* Already mapped */
 		return;
 
-	for (id = 0; id < dst->lags_len; id++) {
+	for (id = 1; id <= dst->lags_len; id++) {
 		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id] = lag_dev;
+			dst->lags[id - 1] = lag_dev;
 			return;
 		}
 	}
@@ -123,7 +123,7 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 
 	dsa_lags_foreach_id(id, dst) {
 		if (dsa_lag_dev(dst, id) == lag_dev) {
-			dst->lags[id] = NULL;
+			dst->lags[id - 1] = NULL;
 			break;
 		}
 	}
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 8abf39dcac64..26435bc4a098 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -251,7 +251,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 		 * so we inject the frame directly on the upper
 		 * team/bond.
 		 */
-		skb->dev = dsa_lag_dev(cpu_dp->dst, source_port);
+		skb->dev = dsa_lag_dev(cpu_dp->dst, source_port + 1);
 	} else {
 		skb->dev = dsa_master_find_slave(dev, source_device,
 						 source_port);
-- 
2.25.1

