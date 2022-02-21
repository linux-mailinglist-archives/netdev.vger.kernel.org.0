Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6CC4BEA21
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiBUSE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:04:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiBUSC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:02:56 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3860A65B5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiXhprw7NMxxJMLkH9FeodnwlBBTiAeolQ/vYxNqMXd6NJhzouhxwS4G730auY+BcSmKZ0g2IHvMGLg7yfkifX/4ahp4jZt7QqVh8AnH+CKUC5hVk529otWQgwbGjQTC+EXiMJq5am0uZeWue4BdYRrbH4ChUm9aCcH8JwClvpYprZyFS+azrpqH5WV3en+utnm4/yEQDLVMUVR7m5hy3KzVaNiN4b0fpQt0/NKOCKvsLbdnTuPEsTrwd7olbeaNASSOkz5S26+awPELM9ahfwwmR/UOLsA24xWSoGgiBcoL+ZNuJwqCXQDWZSiEtvwLUcOP3zgGltHHzsrz+qzrlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtLKc5kki5b1HtlGUJ8rcDT6iTLrifEDxhUttYpIXJY=;
 b=PQoSFzoI7CucxH/PjYNjpLcwxllbxSJdaHNWtNrZNBCWQiAD9Fs2lAb9vOZ41ONsCoQlXfDM+ppPFTuuT1W4DdEMnpl+TuiLDCdTZCIK9PExxfx6T0d3DSX9iSCJRgSmSN8NXw73K4hL6d7xsK+AiUMggdA+tUlsnNBkutl4reNiVv5tpKJvD91S375HspwpWV5RYt+51DjtryXGmo1r1oCpOS3GcF/KgDEP1iMUrCR8PdF6L2KckaXI0Sq7XXoWrtNBUtfLWMyfetqPZMvxP3JAodN1m0eT7CI1SNdE1TgLeDjU/2l9/qsszRMsrSRV65QSIjOhhd/dQK8t6cCgTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtLKc5kki5b1HtlGUJ8rcDT6iTLrifEDxhUttYpIXJY=;
 b=IMCw+Id73IKH/enDRloPj2UzM6l2EftYTWXGakIJnD9SFLiaNNXzi67eLsRnAZTdxiCd5+N5t4O/6EicdH5J+FRl0XcyJ5sDKI3u29QzNXjUc2egdQs2eMCbPND8MnhyGfUCYXai1FyO3DG++u/fxJtd6hLzHh0P/jtIaLpYXQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:10 +0000
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
Subject: [PATCH v3 net-next 04/11] net: dsa: make LAG IDs one-based
Date:   Mon, 21 Feb 2022 19:53:49 +0200
Message-Id: <20220221175356.1688982-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3c1a859-f708-4af3-af9e-08d9f56329ee
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB369305CCACA336A6F62B1CB7E03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qMmyxSarvh2idWtqAzpxcp2sA3RVLozNxT0I5GnKWAK3geEPD/nX4bxjmCQpHvLCgmj6gVkhgaEu84k0AZ+KM9C9GzmKBJTpNKVTkkYRl31/akNHbhC2lRuH1ADzqCpyWp3lN48fsBOPV+SlhlPmEAjcP/CWLwyXgiQLMe25mI8hwjVYH/HPLrbfOwchsHNFrczYGlWS0upd0QshqAReue/NqoysgvvQj12kbodcmlwuficfjd2tAI6si63HEXvOEK+QPa+E+8z2p4TBKWmrOTiMHeUdYXcxmOKtr7tQEnxiI9bG+4vFelFf4R5Tc45pW+ANnS84cmL3ImfZsVaevZGUDb67sRmC+gTni1gpQVnWQUhHJeMN4J752nIVmjft37EVFlb+SNv6RvLcbTPe2YtuLgUhF1WHCzmhpgqOTob1etlQy6Yb8EpP67BLqlaU+t2Xcg8uG2BNZl1HkCBaoKjOBnmP2XSX1fT+kidffckGuUF5puJWZBTRvahHmmYt7EufzCoFtT83CPHv/4u5cOFDxjt+ToISDLt+kZhEMCmSqHQronheavdOmXrzN/Rz/qEARcaWwWNSeDGbzC08K68e+uOZqJfc6Fb+P1RFXYkRK+DGsOBTijpb8NUKpfhXCLq5CzM0i4dzvyb1Spi9SFAa8F9I1ihji+8gT8YbV5U2AwC8LVWJqhDmp3p6nz0bI/mMXANm5sR78zAX/usUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IBPkspgPYNR9IsxkqQJUFPv+rgw5LQkErmMm3avqB6JGYcB9Qxoo/vu+Y06f?=
 =?us-ascii?Q?charjcHK0Qf2BU91/6K6luRDrPKJgxWXuH9cguLFQjcjVW2NROf0WDjwnSyJ?=
 =?us-ascii?Q?6qcXCfylnkq9OApMEhQwWV9EvZRx+/ddNQlQAq6Yfqyj6difsz9QecD5Rgys?=
 =?us-ascii?Q?sOZAij9R5FDIY+2lBPdn6qnfON9d8BvnDS2rLkzmYb3jueASwys4FFfWfo1W?=
 =?us-ascii?Q?i5PhXlxq9JJVij3x9RI72KBRaz7aeZ98emvqtu7/AZuTwM8bxuJgFMnTunjM?=
 =?us-ascii?Q?B+D2ZaPDq6hQlZnAC5/9+R27dxGy4Q02Hk6raQLnvywZlx8vHTqNY4mLB7/D?=
 =?us-ascii?Q?WLXhXllc72CepYnf9SyE3liuJp/KHyiWP1LnuHNUlpJadxwOfvYt2iViWoTh?=
 =?us-ascii?Q?Z5Gy8NHRG+YvPWkWiFR2anWLfFi2BISs83D3gVYLZq79Gk798Y8mU6JB3CGI?=
 =?us-ascii?Q?QDrfXuIqtGvBCzofeqyBacgXsYsvsQeyS4E1HInoSCpUqEARP97M+V01u9sN?=
 =?us-ascii?Q?nedWWblCGmW3MNyUgmN6KOJ4YF1FSut+F0LcvCgTP8apGoxje8e8kvsP1s4K?=
 =?us-ascii?Q?InHv5YEjopvzGRqmaToXt+EQPeNo2Y0Uxn+OEgkHCo5zCixzctSeugrEMaBN?=
 =?us-ascii?Q?WPG+Dt7E6aIr/4PPxU35mLMtXhHPCUAeuWhKs8KjXHoQEs/yNjUmqqy8mRgr?=
 =?us-ascii?Q?xRGCGcxvG/eJ19WfduqHoooiEcfTmUjJ22Lja++KvU6z+kgWpSfN1411cpca?=
 =?us-ascii?Q?6oHczaiSvgG8Kcdke5RTlLYW7yK1SLDdOUaYtP59+AyaAlXNYEINfcAin1uK?=
 =?us-ascii?Q?gSFo3PoJdqkHNKBOiKhUGXpTwJz+Z726YjOIRgGjNLUMJE4VuBdOCVd2p5vl?=
 =?us-ascii?Q?jlR0881fTQ+i3NFbXpLS0eHGX+ETgnjavJwkFvAKGtHjudnjtDobaDS1S0ua?=
 =?us-ascii?Q?70eBHuToRMWOMPFFc/9m0R24VZ5Um55sX+l4TaNAGTAyRjEDIq+2kJIjuX+9?=
 =?us-ascii?Q?sijPhIgcaE1U0+OiWZtYCf70Ia1sZHnqaFFjI2nRhZAnZd8JGGNhJ5B43hW6?=
 =?us-ascii?Q?xi+G2n1et6qun4L2qildSyfQmlx0vIUTUTIfXV+uC8RVv100S+LTq4V1H4fh?=
 =?us-ascii?Q?LXCrQgKJDNxAWKmhahuF7MOcV2JguDaWliiA1neZxhj67/eqeTLsSPPpRPIO?=
 =?us-ascii?Q?1hxU6ipmltuJHFu6tQd0F/kaqZO2XxX+ehR5v+KQVQP51qhuJ5YjMLO4JnN9?=
 =?us-ascii?Q?fsSsFbRyD+Nljo9SNmiXWvd4B/246ZWnYA3lHcJ0dUrFrhuYDL2S5mZ2UWdx?=
 =?us-ascii?Q?ckS+NbwFEjALzMqcji5rq1Nz9zvkcc1rE/0ZipwnxWTdY5RZLms0cibrBgvU?=
 =?us-ascii?Q?kbCH/yo+0QRr67MVv6dqRUEH8pQ03pNrxccBfk0fOl7/rGRjW9+kJFRFbcdB?=
 =?us-ascii?Q?+EV4aD2mJN/5fvXxrZysrHWB6Naeh1zLVzxrTKQncheRRJjE1HDeUs/BaNMZ?=
 =?us-ascii?Q?LdlzymCnqd+2cyi76urMMXBYGtHP9L6aDX/dDlOSmnqJpw/L3ZU3Fgv9EGQn?=
 =?us-ascii?Q?vgZLsIKVt1Svu6PXbC2kZFNfGyEULGFWqq70q+paRyigtQdw142163SoFodJ?=
 =?us-ascii?Q?PEtWdTddLfG9Sckybs/5tDk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c1a859-f708-4af3-af9e-08d9f56329ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:10.5430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ireqMzLz8YepMHT9Y+RZTryJLrIu1xhMj2jScczUTZ/c9GRdbjfbsO7xo37bww6IcOa2t87k70/4zQEZfMjyYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
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
v1->v3: none

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
index b2927cd776dc..89a65f5d5302 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2787,7 +2787,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 	int id, members = 0;
 
 	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id < 0 || id >= ds->num_lag_ids)
+	if (id <= 0 || id > ds->num_lag_ids)
 		return false;
 
 	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
@@ -2865,7 +2865,8 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = dsa_lag_id(ds->dst, lag_dev) - 1;
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 868914536e11..7c6befb88c82 100644
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

