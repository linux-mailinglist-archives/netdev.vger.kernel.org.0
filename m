Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792104BEC8F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiBUVYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiBUVYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:37 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A6C1117C
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz6JR0EcjOw15JeX/WM2C5IgovAovaumzFdmNAgArwKl+3fpKu3mZH9FXMQvXg5tDBJUD8fTRUKB9wJ5iA6n/iY+9/1KEyK0JwP8X+tu0nxCSwA2XYWIAsROfkXR0fH20gdeBYfiMn0OXXZ/yxz6yz0x7w4D7ygh/8QK92bYp0o+cEXIZdnBX1LhhBUk4ZsogzYpEYSxqgX4eFaAJyisbsu1vPDCgn3ffa9K2oqEK4Zm7YUG6QfFFUjJho8eJD/hIF5r2brjcjDdwlOYLVhWhZI+4KSwGM/lJBTWCaMFb15eekOf1lOha4v48UthnE7aUPQHEoL1AUykyzDBa1dh6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bA8iOwR2OIuX2CaBp276PPS2HyKtHQ2zRst2jkRF0A=;
 b=c19/PWEog6tBKl4OLa8HIgJEBcm4wUBGgJNFshb2Yps6zf2yFuT/zuy+Aw8fqwY7ZlUubgZs2ht346brn6joTUbXV63Rvc03oeJyh1wgCdde3I5XkcqtwgnEK4GvvEzyRW2siQavkm5DgZ/bnxtw11UWylvVO4XE6q5ZvU5hXM69JgxfJZb4KAyp/d8uaXyBHiRtLT+TEeRzXcpq5Nmog67WFk69SQUMwSuVHOOzg9WQwcxkYdjUI6hDSWPb/K+g/KQ4g7bMgnHWAV+XXnM8pE2LbXvtfD28rGKF/Pz2Q8XkqCLtb6hd+mC7ZEv5IenU/aoGQiqxYZk2yKDA7MvW5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bA8iOwR2OIuX2CaBp276PPS2HyKtHQ2zRst2jkRF0A=;
 b=MaQmCdrAWJ30tKZXehZ/UeEv/fK9Lx8aoQFNsHFT8+V1yj29AlkAlJ+HwaLqs8UiY2hgO7s5qZ99PNE2Bq8eaiONTQUxzhvbNUaksCHabOyf8gC5uFIAinYK/AoBFaqeQEw9YkCSmnY9zvzbYlxbmrsg0rd3z7GEIywhH+FQxb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:07 +0000
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
Subject: [PATCH v4 net-next 04/11] net: dsa: make LAG IDs one-based
Date:   Mon, 21 Feb 2022 23:23:30 +0200
Message-Id: <20220221212337.2034956-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 264373c3-a010-4c62-75a7-08d9f5807df4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB56452DC23F70DF88D057F8E8E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRVnrcCB4x5dO0GkVHr/HMk2Wx39JEUeJlGfFUgxODyQ7kb3BCJRITOVwjRWHX9lyzhhbEPkJP4pUOZgWf5SHJiwbAo/t9u2U3vNyylIG85DrNTFgsvnDPIZDqaBwirdkXHlivceGg8q8VFHceLexSm99KfNVDzbcmTUjgdSNI4CDWH66/dZo7Fu4Xiw1ehWv0NWnJI6o+J6svBVgrup8RIOlCQxeO5i/lPZ1apr5c2SEC73PL5zsci59wyAy7MhjJebKHPYQolvrdIECAf44hYs/ac/H2HrZwyR84RUe4QO6NDhV939+ISFVAR49QcVnciw73CoHqLIbVeCFj/k/eyJsks159F3+wcCoOZP1I/QHNIVCIn03lrEAWt1cBn9E0em0CbpA0MZxdWFeSLBQ/8jnvhSWPgAOPNWusPT0PwtIe42U/TwdvJLSb2TlIRIGWtF2kM1lR9KXyGo1zWpNXrncGGm8TvJGOvyvoWOKz7irPFwx4xxjJeE5RVr4UaCCQ0GPOd57TQJ1vgf+K8gbZnaaLoPCTBKbUlrb7H/sCaXKLGvjBbW2uwTK+0Zb7BUFPh/eYtfUhEhpeIiO2dDbAHBvF0hOeU25CEZWS8MtmBUdw39+5Zh0VkjD7UuY8GrMaJNrm30W4sU5svmas25JtkCAHRHcEMc4a3IyPTnypV1pihaPnSVIZNWIgGEyUljLHdMBrtWF5AIanCxKtRHVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WVse/amkdy92rV5YXg0taX9mt3v5GXeX4v5cVRHwN2GcxjLDG2kYptCCAQZJ?=
 =?us-ascii?Q?51TbWIK/BV8EKEyIEY8T49fHXr0SH95YxdLf1UZhdaWVCMyPG0zysT7h7Dp1?=
 =?us-ascii?Q?j/kcjlPgLj6Vm3dJIXxgpoSRI7h5q3HhcoRAsg7egBgyd2AWF1NZ0ZMZQzTv?=
 =?us-ascii?Q?2hOzgDuDUICVSnsbn0meAzgIeGd7EtXMx1FFW/Mn6y/MitiilIQke4EHqYrH?=
 =?us-ascii?Q?fuSEYV/Mzw8EUp/E2KOIsxkjBqLLX7Zy+zimg0xCKxyR/0gcNHR+nctDo4QH?=
 =?us-ascii?Q?ODXlI75GXpkDqE9gQ+OtaZhj8+njOp5LdzTrYJ8BHKS6pkDNnbdebyXlV2VX?=
 =?us-ascii?Q?samm5T2Gklsj2NirXs28eE738kb1YJQ2CYwMv+XKVosQoZnBuT5S0Kh96zxj?=
 =?us-ascii?Q?5c1mmyfy0HZS+A1ZFOsOmM1k9RyUlD/AzE8DuqLBfmbiylk7Vo7VJlxxq9EI?=
 =?us-ascii?Q?T5aJvjnNFvyfrvfXJXQGMaTOZBffUstmMFDtTJgZWCaB/PNoJc4RkIewk6j2?=
 =?us-ascii?Q?hBRQZlz4ZJmlw5VR2L+J13VfJKMFKfH1ipywBHstHKG2mquNBt5ivHOEsKCD?=
 =?us-ascii?Q?i83/ktN9cv1tbTv9S77l3sPFvBArL7/7XnXSm5wdsmEIZA9ByhkGcdrbuWJR?=
 =?us-ascii?Q?ghy4NILoqi5lLeiszxKtXdKVMIYN6pUqZ1jAyt45ePqIcwf3RXas4e8uTOVZ?=
 =?us-ascii?Q?5M00phMCzVESLLf9ySy7zhSbfagenrYIVYk7YdVLa3xqoqNeCSmfmv1MWyXR?=
 =?us-ascii?Q?Rv31Ja2KmnrrSI5tq20tgg+nAqlnOjqvV5RUDmOYkZs+X8oIvoCUaOQ9LLeW?=
 =?us-ascii?Q?OwccJ8etGVKJHgzEbxrN/QRZ7l2pCWnAizwWUpQWIknsigag+vMbWJpAJHPz?=
 =?us-ascii?Q?N9NpDQ4bFHxoHy1VNHbDC7hC+DDaI5+HPOh4M9X74OrJ7JcOkNOB9jxQLkko?=
 =?us-ascii?Q?D9XqLcZ7xVIZSPBYyl1ssxgqD7Rh8tgM8ahrgz28+PnF/fIfNt3OWo82/n42?=
 =?us-ascii?Q?eu3DMAXwhecQXNLVjbDk63lveZLMxixumu1b80FKP8J7fejoRz1M8UOmSqq/?=
 =?us-ascii?Q?lcDh8ljBZ8vWpB2G6mHfbGhTiqBMVVd6eSbop3eaOuiQLsndD2O38sgdgCOe?=
 =?us-ascii?Q?683hs47EINQZAoSRy7HRmBXAcMN1QXuIb9YSl7aXrZgQJmbSlh+oUIemXGTM?=
 =?us-ascii?Q?O3+yZlaXfZEELe7REAYXke87/5hFeZqv5naTpGBA6DbIeSDw8J1rGbxAGSWW?=
 =?us-ascii?Q?7gkcHKvEnsN4Xv+o6N/6gKJw0KCx2UXWLFl9P/vGu5sAG0juo63NZDWH4okE?=
 =?us-ascii?Q?OIvACFzIQQPMkI1qmMZQzqsf4HUj5f1698J9wBFeZQkrJiRboGzxmTTv4S0v?=
 =?us-ascii?Q?lzZE6r6ceHYe5pSWCAiTeKfTcpIPrqXYFEOQiem0ElklAucldwYuu0kUdUv7?=
 =?us-ascii?Q?MY5VZLLYlf7V5YpyCW1/te/TSEHGHG0R9nQzGIQZWGr14P+VLRfawCmkYDur?=
 =?us-ascii?Q?E2cR94U5WHTzRb+oqbGhjRVdLvsCNexV24uBBoJ1LYmn3cMe94mI/06eMWfI?=
 =?us-ascii?Q?HYEsFRURhSGVglX/r1qqZf1CVDm0pjlxsSDWSrhAhqje3TcDh8ar3Slxycs8?=
 =?us-ascii?Q?FfpDRTvoyT4tIiEi1Z6jVcI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 264373c3-a010-4c62-75a7-08d9f5807df4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:06.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbWloCv169jspLQnrcMuJSt7HmzAhQSxSBw52n2FxHiwnPn2p8Xw0xEzMGFihRIpmiyN4iLA4E3oGnePayUu9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
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
---
v1->v4: none

 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++-----
 drivers/net/dsa/qca8k.c          |  5 +++--
 include/net/dsa.h                |  8 +++++---
 net/dsa/dsa2.c                   |  8 ++++----
 net/dsa/tag_dsa.c                |  2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 24da1aa56546..a4f2e9b65d4e 100644
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
 
@@ -6179,7 +6180,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 		return false;
 
 	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id < 0 || id >= ds->num_lag_ids)
+	if (id <= 0 || id > ds->num_lag_ids)
 		return false;
 
 	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
@@ -6210,7 +6211,8 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
 	u16 map = 0;
 	int id;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
@@ -6354,7 +6356,8 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
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

