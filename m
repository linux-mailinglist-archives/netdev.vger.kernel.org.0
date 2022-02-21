Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76FB4BEC8E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiBUVYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiBUVYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:34 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B1711141
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brwVD/DaMFaeKvOqcc0NYmNsVp/iRAEDJ8oP0czpEHlhSxDDRB5bLhVcOE2Go84N9FawwABJoLdJYxinaXt5994wayUU3NiVrgUpEX7Mp8EDwmXKePkLNwDbXYbukYujMPdAkvP/N83aGtuR9l2uX6LpGNTEJhLVlrYqoiNF17ohjjDHXrXr0e7cN2JLE5wI3faCK4Ch6iPDi524Ik9gs0rWW7MD1DbeaPVM6u1KPnFv0RGhearizvY+0HGGLr04N+b6uKCM7HDM4syIQxMaH8EypzBseuT93AlkuzuOVOqVmwQmxtIVtrJxtMzxelslBoBTrN+HfOFzHw6UQDaCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpuVCPjEE5Lr9r5eHEIonJUHNYR89ezMFoFu+jvPQcY=;
 b=QxdKcLIfiQh04L0GQfk70rwcr7/XviebA3DqgPA/KAV01DZD2vdrAzF/cZwwWziO3+ATphiGcJWoSc4UY+6n4nUT2fSjfWJOUXPoUHh1wQW5jifbMZFvArh9O+Ilk044h39aRo+PqzbzpfUomXYVhLCBzrhIlwRcA+mDQy5vizVnk9+Djpy3uTIPKBCc2kPxlKD1VUXRvpIR9cvoRo55KCCj4RrRFiHizA9eFnDQIQFD3SbsiY5xeddzRwpDoNliqQyM7hki7yDgley+hCOX9RNlNdj5ODpBSWfmdejZ73qxhy8GyY6ZvRpCzeTIV7DiZ925cjJHZcp8LD/gqEFPZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpuVCPjEE5Lr9r5eHEIonJUHNYR89ezMFoFu+jvPQcY=;
 b=dZgGYQcPUPvgt54xC7xav6nNaxp7xVeC7zIuEoM38WrPaCa2+Ruty6G8vCSzUSHQuiHPjU2RakYBh1y3fPvVqVPeYidtA8AMWqkmGgz/JTTgahvLBQQA8T1wg47wnAEK/TH69D3VaXnhuifrmBCI/OUrlbps6KsFj17DeUuyvUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:05 +0000
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
Subject: [PATCH v4 net-next 03/11] net: dsa: qca8k: rename references to "lag" as "lag_dev"
Date:   Mon, 21 Feb 2022 23:23:29 +0200
Message-Id: <20220221212337.2034956-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 10b9bcb0-7fb3-45e7-9726-08d9f5807d0f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5645A350AA05561988188316E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QDQQDov9HW056DZHMtnAoDwzHx+WnBqR95Nuf2kOoNH8AS51EKG7p1VAbHLkivKieTi2m7A/Fa94dhjDd9BYjdS3NlVTFKv0CjJu/+GNiqxesaXizApKSLZWSykYBa8Dki6L24Ig65CNhm8djlb9c+jO6uWTHtfeKOF/COtIeA73IDUlZwfRy3sZ1KoN5Hir2mt1dXvzw3AASARv7PlvZOvHtiSwpQpmZYgl8cx8/znPtOWjZd7j4w7T7Teu3sKOBZ9g4dsRKBFIDtP1y7wey2YzKz8lwKr8nKAO42T8XX0my6PFdOfPgZCtUPkmBC2DgJ64BxeWrkdZvgRFU7MSYVYpS+3zzIpjh7zBiLqdYVEuq77NBaihH4NkXHRUQ1owxI7UipbFLlgeketeuTmGHXSvNwE7RrMJd2dbNGtgUodYJc/9QtvffOkngDIew5D71taiOHlxcuQSV9oAEloop7Moc22mUhPLfHtWuClt38G4YmgmNBnpDfJSnJ0kwxg7BiTnmaVoem54loQyecN7YtSQ9K7a4fgGYasXsNX4PYITIrOVspdllgmEw9nfgOeaTvZSks2/KBbbViy1Roz59mvZXY150BHrpkJIzGeAlYfT7OuleUucF5yoSr3FAsUZVkcCOVnsaCM9hLnyyV+0qf+8Ovq8EsWsdH+HhiQZoG40yUBQxbc/jMu81cNc1oyM7yLHOJJO6Dp3Ez3gMdHmU2zpdXvrjyz1uO2heH+yXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sO82i+Gw041cs1WrvcfHlG+Tp727nR7vLZJIol93v6DahsOr2k/B5v46FDlO?=
 =?us-ascii?Q?lUM67utD7LV95Ds4kP1faqYK8C0AVuKtANrYcTpGXSv+z5ypX52MqimA1PFm?=
 =?us-ascii?Q?GKhc5njzqRA/vinAy/Co59qj2ehf6snqYrswACdpsS0ef/wkWfN0k8+oUf6u?=
 =?us-ascii?Q?sGeC2a2GW7xiOjz2BdDDwz8aikIBgAQ0jtvQYK+BtsqNqhZqYzPdKX8BaedF?=
 =?us-ascii?Q?33NOcKUd1a/6ZuejrTO4CQ8FcnAmvF2TLXt0xuDo9B3rQ2wNriB4YPl94KK2?=
 =?us-ascii?Q?pkKST7XXP6jh8fCDEqY1Epa9/DN7N5GB5zjdn1aEKWeOi0WfvsNu5h1IaUXh?=
 =?us-ascii?Q?F+Xag6uPeYsrU/4KUWJUb26Eu6mST6Ked8SWFwhcp9J7SelpxEfS9VhOR0j1?=
 =?us-ascii?Q?5ON9WSyNMlWa2rWlquMbyNpFolYHuCPbPVtvnBwdrzsoUc3BNguhiBgrgGEa?=
 =?us-ascii?Q?BOSO2PlxvdIY68yDg4n6rYr8kWAm5zygtuXCTnuymz6o7ZtruwSdD73qW4fK?=
 =?us-ascii?Q?6prN9MayUt8XeVmpJEL/bLfvp59VqQ36sxTTpSHJecw7GPFcPtUXyflZvlve?=
 =?us-ascii?Q?fruorpyoKlTk0OQtDMtmqlrcqsp/tIhhK5gfG8RtYPLW4qbQBBSop8d5nW1E?=
 =?us-ascii?Q?fakfFLT76SfbY7uY12WO+jsj3Kt3LNPw2Un6WMuUHZro4RZRTSa8D3nvJHS2?=
 =?us-ascii?Q?X2b9cjdhPwzu47TTwXRA1TC8EkPBWNzIQbYINqxXzoaCzb+KemZgiCcOWjbP?=
 =?us-ascii?Q?W21xztyya5M2SBrHrq1iUxfZ/rMBpn5SQYNd3np8AjIci8bMO4nZILJKrCMu?=
 =?us-ascii?Q?o/vSy3os0SstQp7lh/BhlQpdBRfIfssRre/51YM6uhKz468K9xUJfc/ap+Qb?=
 =?us-ascii?Q?nW2glG0D+s7AB4H1gWdiD1QYzxQ9yxkXHYgjqQHYUiAh6Q6qCtdlSUE40f8N?=
 =?us-ascii?Q?QKDcUFfz5yXpTRv48PUOm8Gh2Gu/MS4LEk7BQeBZtwaS31ErYYboo1N4T/Sc?=
 =?us-ascii?Q?H8sR1l+USVjQKb0LoZ2D2j8tX1eeIOH2NfW49oDvkU7GMjuyvxHJ8WX8eDWA?=
 =?us-ascii?Q?lihEvRWUGJhNkAdmNjndjPrXXNZAeQPQYlp7XLOftxsoTsi5RSwhr3QXg3Jk?=
 =?us-ascii?Q?LHoROviBWuUD9U9WMjP6qlRbX3vSxFoF1axxz+uOZB8OORAECoC61bIE1WuL?=
 =?us-ascii?Q?ybL/3/rF7CX1ceBJhYoShMbUqIlR7gUJEmnm1i31KoozosQnnG/jYxOAb/V1?=
 =?us-ascii?Q?Y/3LoOIOQrVZIEMQXbsriN9Q9vnbg28Yaf8VKbKAH01a6AcXfVwwjHDlHa4t?=
 =?us-ascii?Q?n6k+//eHxFSZHT5q/RvksgfLhVOSAq/+RCCR6WtS8jm+jmTRNZLgG/R21DsM?=
 =?us-ascii?Q?uJPUDv21TXm70rWxmu3twSzR9xg3bCmYIYS341jvkuqwy3tqPpe3jHouraxk?=
 =?us-ascii?Q?6f129sTkj0WWODcKljkM3VWRFvxWoL3rVyNCRhOZGoGB9A8/jTitnnBnbrvH?=
 =?us-ascii?Q?+rNMiBEHsf+r8w7nQPpGBentrcRSg/Uq7aC6HH6yt7gieUNGzq+FEfUUTENp?=
 =?us-ascii?Q?vBJf+bmTLfGsMA3pb/mN3PEh6tq4PA2prmU67VhT22WdJhnpl5YyqUN+oCvL?=
 =?us-ascii?Q?0b43/EYNKCpGlBvwcLOi3n8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b9bcb0-7fb3-45e7-9726-08d9f5807d0f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:05.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3PUbhIJTJJO+CZ56xfHwFlmv7081PDxoeiDdw1LVR/k+SoKjP8v3iuS1It1aDAEC9D3bxN2ZpMWJxdu8imx/w==
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

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in qca8k to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v4: none

 drivers/net/dsa/qca8k.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 04fa21e37dfa..5691d193aa71 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2647,17 +2647,17 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 
 static bool
 qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag,
+		      struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *info)
 {
 	struct dsa_port *dp;
 	int id, members = 0;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -2676,7 +2676,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 
 static int
 qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag,
+		     struct net_device *lag_dev,
 		     struct netdev_lag_upper_info *info)
 {
 	struct qca8k_priv *priv = ds->priv;
@@ -2684,7 +2684,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	u32 hash = 0;
 	int i, id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2716,7 +2716,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	if (unique_lag) {
 		priv->lag_hash_mode = hash;
 	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2726,13 +2726,13 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 static int
 qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag, bool delete)
+			  struct net_device *lag_dev, bool delete)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
@@ -2795,26 +2795,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag,
+		    struct net_device *lag_dev,
 		    struct netdev_lag_upper_info *info)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag, info))
+	if (!qca8k_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	ret = qca8k_lag_setup_hash(ds, lag, info);
+	ret = qca8k_lag_setup_hash(ds, lag_dev, info);
 	if (ret)
 		return ret;
 
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, false);
 }
 
 static int
 qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag)
+		     struct net_device *lag_dev)
 {
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, true);
 }
 
 static void
-- 
2.25.1

