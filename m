Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C424C14FB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbiBWOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiBWOBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:41 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABE0B0E8D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNM3/qNLgT4P0r7yObOxqQ3QfQeREFSvQ5GWJd/zaKW/acHxGmznMyuEbsWGYtIzTNjFtKwWvZrZxIEmVfzShcXasbQkMKyptonNoNR7uxyokCI7Ws9ltXmtDrP8C2QJx5ZhTE9cElKIauZrvSBXxPFUHp32Dka/Dy1/3OLEKnlstLuTfSZ0vRXCZNEMtoplZwXZRULp419Z4Tj52RVMYsdYEehJq+Y42qxfLaBhbHXVFl0EuJnZIf2FHvjZrtUDb/RyfAcAFpHFa2oBN4ovXMkArdSF7YspnELs4PYWsb4p9k3rncyz89QTPQrUbxRdNtwrDjuDzzCGrTEkOd2zOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCRrMqn/c2iKDxS4yxzVmrPa+QDozdPuf2CHx4BHH9Y=;
 b=cX+OAvHnOia4tbgi256JEI9e4IKsf66m5EBV2W/pevFJ9OqmDjuBmv0DmmLifQbswUcL8GVqOlurmz0HUNHcwAgXF2kr4beyRQOW1ZlwIeN64Wo2BDwmsWzUfkmZu9QDcqhYGaka1yWFztps8Wo1QtLWFVabi7u74HthVcAUwsNbofLnUh/4Rkd6w4x51/57+mUdHpVyXcJ6jBIKxpg+3zCj6lSJ3soH3mfTefmS5bzfjusixW6ttHerhDyjdLenHfNEJFCGypOh+5S3m0XZUlPDnzVpFj849aYJgnLZvs13kb/rj+jTkLxWg6C8b2/y71b899P4P1Q+Gvdx9q0AXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCRrMqn/c2iKDxS4yxzVmrPa+QDozdPuf2CHx4BHH9Y=;
 b=ItsMzTt9cnEL++I47WxLdDojd6uuESaE4qM6bfaK8L/iVNY1Ulzv9nnBUWVetmCVsTEHd0mivwMKbMP5kQCFxQKA7NQoenIT13x6b7fQh4jxkBcacwWvybODqSR7YTMsUsCFDWQ8/4PODHLZwx773Y+H2GGS2xhVnGg7LsxIzqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 04/11] net: dsa: make LAG IDs one-based
Date:   Wed, 23 Feb 2022 16:00:47 +0200
Message-Id: <20220223140054.3379617-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faad787b-96dc-47db-3a1c-08d9f6d4f1b8
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8701127C330DF7B186711938E03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQ/LHOadAPOPdUsahK5p6oU/w0vUPerK7xZji3W0ykW9c6uZWjet1cMgHQG1r561iiaLDooQCOxClB8qcW5C6CgDOeJmVYLXtJRPOZww9bu+j+MDAfqv6hd8/6WHI2+2yoFGoXns64NKuzRi4ZznJNxokm8BUfvPnwKkm7kBqQSERfe8cL54urzU+2r+qWEmvSuFpNyZlkVU03Lz+a3NCkA86J3IqRKVVwG3/X7oe7hHwESc0I49D3Xa5n7jAeqmkMG4mIvsrejrw4JiwLcU2evUi/d+CAazSXoKVnu2pL1fa3tgij0U0yasn178IBJC4WSJTbHMMjMM9yny5sQLdkE4ENakz+rJcGrV8bAfNz/a1LkKAtxfap/74c9PrFJouocbeQH9XJoTUha1atZybiyF4Zz3nEJYarBBFn+wO6cyjtof2WUgdcD3B+FDSSJ0WkVKEchAHTqRYJvmuO5c0d6Fds3BkaonqDprBTseT3Hvrziqukj0YrzjF41A8IlHszV5eeyrLqV6h7lp76IYUmpSh0HR/4hjdc7KKvU7SqRHBA4+0gSJb3Uj8jlawZQlGdqBOH6e/g7oi3l6AqdLi28ixZIzdd5tCXKmK1+3f49ZrhLnzKeF2jDyVhMusxx53RlIT6PP3nyjgAwc9yeSw2JfIwr4S6k6JJxIUsD44GC4cO0eAf4epmx7LoOq6rSWDNp7u0mo9FIQoNZ5WDQXsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(8676002)(26005)(5660300002)(86362001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?smsmfhCZIRiKBWGxLXJ+uSCO4MBWVvMZuwATExHMG1NFX/LbJz2Pcl56H2rT?=
 =?us-ascii?Q?NCKReIVwCtpbojRDPuoLAsHWIHnwAIY32/qSw/zVHzjLDF2wyQSFynuEnQur?=
 =?us-ascii?Q?nwJ2LYDiWh7LdjcylqWRXRBigllaUXpzFgiF57Z3p9n8S4Fwgv8cvVsW04PY?=
 =?us-ascii?Q?krmWpze6g7+8CBarjpKPmORkZWycMi1kl59BkA2vCGJCsoQfVQhwH+ibV/wl?=
 =?us-ascii?Q?5BPREHc/xg8PenFz9+DUzUfC2xZu6GSOAo0eSTG1/ok3RXY3wdJBM4quTVIl?=
 =?us-ascii?Q?eRoTQPv3ALazGTKTyYeEfrXmzSpG6p0sFyAkvlF4Gg5Fsn5uwYlcwZJ2WmG0?=
 =?us-ascii?Q?mE0ePws79vBd8T9SwIa3YpLgRIw5tmGUp4d/bBc4tP4ta9yfwHWZMe85iJmi?=
 =?us-ascii?Q?/70y8F+e27ziS/uxZxC4LB+aXX6XMYEH/gp8RDJby5Y7UydVsQY9FbNPT/bs?=
 =?us-ascii?Q?owLMpDqBQSgIVQQhyzbZs8gy18q8kcqcbaKKunbZ012QjVu30gIBf8PPYgyD?=
 =?us-ascii?Q?Sf7JVXVW/RJwpUSB1wm1v2F6nZh3Zv8/LGQ8aDugaiNeID11NSkMsv/RsEiI?=
 =?us-ascii?Q?Pg0XKMXQkEYZUDZ15ghpB6JudID/ZcDVy5aH5Tzsd0fxnmt4/D2TmQJwaNCQ?=
 =?us-ascii?Q?Qw+AhSMl1PxVDXGihbooY+wkaLdsJvfGLQNmPRPtvmCBkcFdlWBljuYuiZXB?=
 =?us-ascii?Q?Z5vK3j+4dATOkYwwjZv7mNcS3Oo5GidQ1yn1cbIODluaLu5noKsMVOy+IBYS?=
 =?us-ascii?Q?FTKMdlRqzVUh0jBvMGD1EDBZeZ+oJ2UucXwF6Bdz/YXHunXpiFMPm0fqsMyA?=
 =?us-ascii?Q?QygkdJ4uKEJtde991yMxKVC4hAcJxEfsQB0cbFjIFWMg1pKKy26KDl1SyXNn?=
 =?us-ascii?Q?ZKI5cnBb9/mFqi1sTPTe4ycUuQkoTBe9zjx8rBS3C29IpV5TUjIxFoaa1WWC?=
 =?us-ascii?Q?7Vfd2tcg73SvfBJBi4JfscfN4nLobpXpr84x5rpcZUsFLgiJRdE7Bg5Nm2NJ?=
 =?us-ascii?Q?bS01guiCkFj7U3KjP1qO4ai+ALf1/sY/m5AmUQtsKVf6pD/pVVJLCzLjZmaM?=
 =?us-ascii?Q?VWtRU9B9leHVNDal4MRtUi3Tkeaqq1NEdu0d4yMnz23GOAStcGC8nHlHlrbh?=
 =?us-ascii?Q?QBaxiOBqiuoaFU4r7FfFwa04OA4Bb/polSzG3a7UV28gfBzgK0qzdX/07viN?=
 =?us-ascii?Q?mYdgQSC2cU8/D9i4ExVUNJnmLsuG70BTkYu9rcUs7/c1oK+DShkVS5PtrP4e?=
 =?us-ascii?Q?0dBxBLgCvKg2tZ5Hl47h8XrN2G3AR98hwaSft1zJ2mJ6XVyNA+j+eMKrKSeK?=
 =?us-ascii?Q?iducJTDgdDwzCJcMPoGe/2WgBX000uj+sWMCoSR3YK3hk/OpgfFknrD7uR/0?=
 =?us-ascii?Q?MbY2Ws0zKhHYfrTbg/K0lvHYcGfZbVfXltHxI4kEcNrCavJLaY2wH81UpY35?=
 =?us-ascii?Q?/0v31Hk3joZlPC2BTFZeH59z2cgA9tuqugGwAbFrQyyBqq3+1kv5PEIX6Q8W?=
 =?us-ascii?Q?qrucYNciRThqPUIks3HYlFOxAObnXb5SRTj5hKEMsYIv9YUKkOeOXwfGiLqY?=
 =?us-ascii?Q?1IuIf5J2SgyIaE74gne+cbZX1Hn2w7OcAeAs3V+VNbwbqTD5uTUD30m+9LZ0?=
 =?us-ascii?Q?BrJrU7NyAFMQmR97KK1v664=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faad787b-96dc-47db-3a1c-08d9f6d4f1b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:10.0236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/I2Lf4imOwOpTsK3EFgxeSd8B/yo9aVHJ60T9QcWE2G9fhcBQtiPoLHjgrY+M9ZwuCp37KkNYFL2Ccr1NTE3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++-----
 drivers/net/dsa/qca8k.c          |  5 +++--
 include/net/dsa.h                |  8 +++++---
 net/dsa/dsa2.c                   |  8 ++++----
 net/dsa/tag_dsa.c                |  2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4703506e8e85..23151287387c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1630,10 +1630,11 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
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
 
@@ -6186,7 +6187,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 		return false;
 
 	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id < 0 || id >= ds->num_lag_ids)
+	if (id <= 0 || id > ds->num_lag_ids)
 		return false;
 
 	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
@@ -6217,7 +6218,8 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
 	u16 map = 0;
 	int id;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
@@ -6361,7 +6363,8 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5691d193aa71..ed55e9357c2b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2654,7 +2654,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 	int id, members = 0;
 
 	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id < 0 || id >= ds->num_lag_ids)
+	if (id <= 0 || id > ds->num_lag_ids)
 		return false;
 
 	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
@@ -2732,7 +2732,8 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index ef7f446cbdf4..3ae93adda25d 100644
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
index 01a8efcaabac..4915abe0d4d2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -86,13 +86,13 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
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
@@ -124,7 +124,7 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 
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

