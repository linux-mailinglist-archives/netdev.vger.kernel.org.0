Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FE24BEA26
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiBUSFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiBUSCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:02:48 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CB815A34
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=geZJsLZBs03CQwJFkjBqgfuWfjLSp/sBHYe4dl2RiDX7tRYmUSeMPEZrRumps2Ct6E0zuRltoqecOoNnwfpDjEzAr+/7unEJLqgkvzxDK/zlyOFpDSux7MLYaws2jwsefKJYL/W6d80zR2QVrLUfQmcCbEiMHeI9pJ2rgFt97E60uxPX3AStl6yZnlyz1J5LGUCvTDDpCoLVA5danb9R+wTL5jYD/LrOhI4lbYnG/Thi5INrrWztE0AOdLdlQEMrwA7YI9tZMMBHPJZ9dZTbTGUvjumjwJrWSg49ZvA4r8+jRnu0Z6/fOALApXWfHUSNOo/66aKazpXi2j7Lol465g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoxPyj5Y7meqDggcJXzMQrtGCP0t/ouHn7N3XZKZ0X8=;
 b=ekNIWKxga3PjiDxcj3CflepEbDSnp7/Q6Q1SWhkDzqMoRGFIMnKfE/G4mFt9nG6WoNkMFU1AOGjngp6j1NqURhgMNvgLrTBWzOqgJKiySbYMytw+OPUnluJTWUS1TiCJiMfadMq2RQs2F4NQJb1Tu/BttZltYWchsRrWs9xtVGsR+ISP+rdZ538GstfZ+0ur2UWOTssQjuJJ8MlECmvbxymNWQSea02HJYEAdTtUTmupo9PtHZezHc3JdI5WuXdkARiDb8XwnA4pPWhOeKrP9I75Znpgk5lOrP4xC2E3E0rICvpLBz4krHlfbio1ciaJYscsgVpBK9ISZNjUmNHYpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoxPyj5Y7meqDggcJXzMQrtGCP0t/ouHn7N3XZKZ0X8=;
 b=K6VofXKRvFICHQnTYa0APcXbRnVUqkCt5EDRa8KU57DB9rzCWbRpE1DcxR5U0f7p0AWUGnzWPEFixamll6ElOWE+VfWW81+DEx79sIvFZxn5/OPMMmKKgIWBZkzgR4QUfP6P5Ib+B6eQFHgJf63rqBUONyfqk6wPlbp5kstRQBg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:08 +0000
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
Subject: [PATCH v3 net-next 01/11] net: dsa: rename references to "lag" as "lag_dev"
Date:   Mon, 21 Feb 2022 19:53:46 +0200
Message-Id: <20220221175356.1688982-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 765709d4-4969-4a34-02ff-08d9f5632876
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3693A16E47A0B28D16DEC2DCE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rEw14o1tV3FG2hOhKxE1DWhUgKQnv1nns8YBoVRBgVq73FjwqnD/0h6nsrT+qTk4bGx9g/fvp2AHtjG2x5clEtQtGhHxiD6l/0iJV9Cv8JEWsZF5DzmDSC0v8REA0GtFM0MzrE7dd0lwDBM3mGQK34RurwRVDAi1L8j4oQSwW5zxK9ixGccVRd9ZFuLLQOOwLOChbN6dzg9cazBLSNYvxcCvIhjaCFwQ7taTQtv3xCRq1sdMRZSIuM47O3MYho0+c8eJU8S17hNb2AjhOxxTh6kgmY8loPMvL6s1NLFmSe7voj9xbJ9WYz/sWsRqIFI0hg5dDOMSezLgnV/FyR29B5923muk3vu/4k7HClmN85Vi2vKmrIQ8b48T03ntBwS2phnNrykGoMKPy17RX4LG2ScBPxr9ChttZdFJc833zElzkXSYluRit0W6yt6whzIlT2suNQeq+p3gTvC+UQLLhN9jIfJSmLJ3xXe9gxA2buw7UUYwGhVp079bIvwNi2tjFPdyatCrTGj6ATWvbpE2NnkbxXel60l4bLxXKNPlUwn3MOlV1mO/V4nVLtysb1tGz8EWZ9Fz2ukHg2G5m9Gr6Xxpw8qIu8T3CxlsQj5frM0b16GIvyWkoNAtzNBpIwxV2DH/CJb74m/207HLcyEpKkNjumuDyM8uJ/WkQovj3+V5qrQXLHxi8X5ik6yyjX2d293Ie0kNafU+bRxYwIXqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?McdYJr+mWPZuupyoV9+Bl3rHgNy3BPwvucO7br/J7svXTQ/1CkaG66SY/HjF?=
 =?us-ascii?Q?MVHP2NG8jVIlD3WGMELi1lNwrz5iyns5G9Z8E6NsneK6q72ULYVc9qadhEDs?=
 =?us-ascii?Q?5X12gu4bohHIVHBH9+vzEaiXsDT/8wpBv72K2pBH+AltV5ohbPE2MbeO/XvW?=
 =?us-ascii?Q?j4si2P+tj6+e+Yd8wKYRCsi4uxdVTcKAreTV/PHgUsFHQbmDQzCCMYvNA1Vo?=
 =?us-ascii?Q?gcpsJphs0TWEd+gGTBlvXwYLigxvpjbEAJoESbXhLnLb+XNrSImJDBO89zpw?=
 =?us-ascii?Q?1OlMLnS9+1DPeXewIQWpS9D77iTWm+2Rr/Jy0ieT0BeEhKjjGSt+tlZVB+Iq?=
 =?us-ascii?Q?FpFbuJp7UWRviyBecPcaOzlNphOYu2khDArdigf2tDFLh8MSEkQ5Vh0J9NLM?=
 =?us-ascii?Q?ya+nK+8WZb6RjSkUnW/ubFSP5mypmMLkjLXD5OM3MObagpxC1UMVwFNoyhH6?=
 =?us-ascii?Q?pCXZ1g4LRnTXsy1PTNokuL1SO3NoLUAJKHKUrvayqf6sWmX5noIaQPos4rdL?=
 =?us-ascii?Q?3AAZ+myNVoCbKdXnArbW1h7wpDVQWkomaLZGGnFXbBkmOqksziqpfqrAaoMw?=
 =?us-ascii?Q?lugwKcGF0f/3yUo+Jm3FQkw4KtMhXnh4Y0pX6mDFSo00xWjKo0kd+yVTEDfb?=
 =?us-ascii?Q?46MEeuIDXLYTeB0sSnmGiMhXgFZxrWOVIa453aj+9JVnOGf0ftdSTY0T14Nt?=
 =?us-ascii?Q?t0eBJc7gW+6LF8J9/G8ManP/ijtBdusYi4XRyKFMdJCrZcAESNJmSB8DwPlZ?=
 =?us-ascii?Q?c33g3dnBB9Xm1ljqYdzDUnNTxqIY4SuvVtbUtgrdGJ/fhjHeZx3D8uq0MGGi?=
 =?us-ascii?Q?ffVVzE+9EefAePOsFFE1lzvUg+eCVIialesdSBoy0jOUeK4mEveXY9mRG632?=
 =?us-ascii?Q?FjjFcIDOKBbuM8Yyko9AyHgPyx+N5/Wo4S8zGn6T1si9Mt8257/9k4NriD4E?=
 =?us-ascii?Q?UseDFOFuOyHuFfzTJafBcC9uS5aU8FfiBUMnfFv7+cM1PY3tEQN+8mxNIQ9c?=
 =?us-ascii?Q?yKpVZOfjnxKQ7oWIRcfwT1If65PLE9JfTeWjvkkFVgouxFssW3+Am4Jc0SKS?=
 =?us-ascii?Q?1syInop0S6dsnZ8+3Ml6tjiqnQzagdbShyCGHVg2jFVHnttmjuB3ZbPxNIC8?=
 =?us-ascii?Q?j29LznEEmiGCfl18OwPfLTIcmxcQqqP6XgnjiisSTLBCkHC74PKWix94fzJR?=
 =?us-ascii?Q?KtuoKqtevsXD/009vW5ljJbhXtBL9cOJdI9w0c3YCVR/USHAeG3EavlRG/7T?=
 =?us-ascii?Q?8psIhXeqZSJWuStemUP+ZHb7PBWkzc8U6jtLiJf4q9PO73yWOkGfj2imV29V?=
 =?us-ascii?Q?rJNplgl+XQsJgyvpuqgLiHz8JHTKyGI2fJvo4/V/ZtuOwlbPmLIjjwKJppNi?=
 =?us-ascii?Q?jr1XfMTpoj1SK+vsToFADRdLYEBDBCTxGSv/YVtJqH7CQNPJPj9eulBuc2fM?=
 =?us-ascii?Q?aBIJ7PXG+xe7LOkFSZ2lQQ3wZ1bnn3CQeUI4Sgbq4ZOSATR5nUm5qBdMjP2W?=
 =?us-ascii?Q?3cqsaxefYj51nGW3VofoG122DpWg9P6n85fVnEXLirZjynXqPlU3oZR2v1oI?=
 =?us-ascii?Q?W7ykjRm0Zax8YZMQCZPzRU9sNBMiDf5kS3yPQlfZ421kAapD7sdBE0HLTkrO?=
 =?us-ascii?Q?bt8IDYOqbca9gwNVZ5bbZLk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765709d4-4969-4a34-02ff-08d9f5632876
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:08.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIh5oY3McuOXeJJgUg//PkswSfd5ISPkiuelilrsp6v3ZelA/pMGlB8aCkFemedGKixUP7IGm0X3R/1Iyxup9w==
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

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in the DSA core to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: none

 include/net/dsa.h  | 12 ++++++------
 net/dsa/dsa2.c     | 16 ++++++++--------
 net/dsa/dsa_priv.h |  6 +++---
 net/dsa/port.c     | 20 ++++++++++----------
 net/dsa/switch.c   |  8 ++++----
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c8626dec970c..868914536e11 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -182,12 +182,12 @@ static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 }
 
 static inline int dsa_lag_id(struct dsa_switch_tree *dst,
-			     struct net_device *lag)
+			     struct net_device *lag_dev)
 {
 	unsigned int id;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag)
+		if (dsa_lag_dev(dst, id) == lag_dev)
 			return id;
 	}
 
@@ -968,10 +968,10 @@ struct dsa_switch_ops {
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
-				      int port, struct net_device *lag,
+				      int port, struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
-				       int port, struct net_device *lag);
+				       int port, struct net_device *lag_dev);
 
 	/*
 	 * PTP functionality
@@ -1043,10 +1043,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
-				 struct net_device *lag,
+				 struct net_device *lag_dev,
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
-				  struct net_device *lag);
+				  struct net_device *lag_dev);
 
 	/*
 	 * HSR integration
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 408b79a28cd4..01a8efcaabac 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -74,7 +74,7 @@ int dsa_broadcast(unsigned long e, void *v)
 /**
  * dsa_lag_map() - Map LAG netdev to a linear LAG ID
  * @dst: Tree in which to record the mapping.
- * @lag: Netdev that is to be mapped to an ID.
+ * @lag_dev: Netdev that is to be mapped to an ID.
  *
  * dsa_lag_id/dsa_lag_dev can then be used to translate between the
  * two spaces. The size of the mapping space is determined by the
@@ -82,17 +82,17 @@ int dsa_broadcast(unsigned long e, void *v)
  * it unset if it is not needed, in which case these functions become
  * no-ops.
  */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag) >= 0)
+	if (dsa_lag_id(dst, lag_dev) >= 0)
 		/* Already mapped */
 		return;
 
 	for (id = 0; id < dst->lags_len; id++) {
 		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id] = lag;
+			dst->lags[id] = lag_dev;
 			return;
 		}
 	}
@@ -108,22 +108,22 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
 /**
  * dsa_lag_unmap() - Remove a LAG ID mapping
  * @dst: Tree in which the mapping is recorded.
- * @lag: Netdev that was mapped.
+ * @lag_dev: Netdev that was mapped.
  *
  * As there may be multiple users of the mapping, it is only removed
  * if there are no other references to it.
  */
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	struct dsa_port *dp;
 	unsigned int id;
 
-	dsa_lag_foreach_port(dp, dst, lag)
+	dsa_lag_foreach_port(dp, dst, lag_dev)
 		/* There are remaining users of this mapping */
 		return;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag) {
+		if (dsa_lag_dev(dst, id) == lag_dev) {
 			dst->lags[id] = NULL;
 			break;
 		}
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a37f0883676a..0293a749b3ac 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -76,7 +76,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag;
+	struct net_device *lag_dev;
 	int sw_index;
 	int port;
 
@@ -487,8 +487,8 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index fa03beb5e5a4..0e5dfb1c12db 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -440,27 +440,27 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
 }
 
-int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
 	int err;
 
-	dsa_lag_map(dp->ds->dst, lag);
-	dp->lag_dev = lag;
+	dsa_lag_map(dp->ds->dst, lag_dev);
+	dp->lag_dev = lag_dev;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
 	if (err)
 		goto err_lag_join;
 
-	bridge_dev = netdev_master_upper_dev_get(lag);
+	bridge_dev = netdev_master_upper_dev_get(lag_dev);
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
@@ -474,11 +474,11 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
 	dp->lag_dev = NULL;
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 	return err;
 }
 
-void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 
@@ -486,13 +486,13 @@ void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 		dsa_port_pre_bridge_leave(dp, br);
 }
 
-void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 	};
 	int err;
 
@@ -514,7 +514,7 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
 
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 }
 
 /* Must be called under rcu_read_lock() */
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 0bb3987bd4e6..c71bade9269e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -468,12 +468,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag,
+		return ds->ops->port_lag_join(ds, info->port, info->lag_dev,
 					      info->info);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag,
+						   info->port, info->lag_dev,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -483,11 +483,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag);
+		return ds->ops->port_lag_leave(ds, info->port, info->lag_dev);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag);
+						    info->port, info->lag_dev);
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

