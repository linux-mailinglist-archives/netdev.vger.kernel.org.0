Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8753B3F3C78
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 23:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhHUVBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 17:01:19 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:58336
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230234AbhHUVBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 17:01:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dItnrOJ6KCC2aXHejMcAhKcE4WFJSZrAgHHX651a6vPe2fWMUFpiSxr/DxxqRJ+/6ynsbJShKZIk4UK2wjvuCnfPDe0NwXuZOwLaaRdluEFR+UyFrZu7QHKHblQoZ7FeIhOEmmulDVC7ILKUZ2/xuSwJmSFTFtxHmfspPMgLeQaL4M466bZAU8aNWfgqoWUxseGOp3hm6rtAfqo7ZguOWfgkmeESZP9TdRBsx9pV3UliNyBFgIeCT3Vf2XdQrqOMTzr809wzJHodlsW6j1cpiT4zIMhdlYpnLu0LArd60u2F892sZpcI5ImRxldjaBtyKFvN2E1ZAoqn4FQF1y6bVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urIEGDLWPnm2c3PkmMeyB8TMldMsRxjELTAvm2zxqag=;
 b=RYMNSUgwpXMGTrxEBIrnoAFJIWisxCK1Aq6HwShv8oj/2rONoCkcv0XKonlyr8/E8fuEKEuoDjbkglVTMJkqJ8PjwTXcD2im2xrklqk2YRvisKZWJTw0y6bCzp4lO+tV6dFAJ7ZwZvENO5BCN6b8vgjO3C3AnMmWY2Yy4XwaT692t2FkbW123YviJAtOVk/xuP6epvFrSH/0p+l3o4pdhY788I6KYoU77v76ZXc7Op0L3PhIlBd8ro/d8YVXunm1co4yYJeA3LEu4KmwAvHMYzv/yGe3MwcExZ6ySBzawW4sHp2qU9Ukplbx/a0vbaZRiQxXAUopTAS/SK0xPUc6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urIEGDLWPnm2c3PkmMeyB8TMldMsRxjELTAvm2zxqag=;
 b=YDSOmqcLeQjfn/jYlf5TZ5LRQt3QKfg8xuW9/MH5dkXRA4USxaDFMlNnzyrdI9ct9apjAZsZ/Otksg0bN3VSj7jc5NYkbExtbSkjMCAYj5sAkFwJIjRs4XCk2T5+oylrQgBy7PLa9n9iWxRPfZOO3g+numq8liAi5ufplByzI/k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 21 Aug
 2021 21:00:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 21:00:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [RFC PATCH 1/4] net: rtnetlink: create a netlink cb context struct for fdb dump
Date:   Sun, 22 Aug 2021 00:00:15 +0300
Message-Id: <20210821210018.1314952-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0010.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0010.eurprd06.prod.outlook.com (2603:10a6:800:1e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 21:00:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3e69408-dbed-4759-e4f6-08d964e6b729
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268733377C77150AF71EBE30E0C29@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWz60P9eTpHhlqDSjKOXwvJP5sq5pxMV/06tGbHJk+4/1UZeD1KvQq7GKT1yaFLsB6W6KNZmu9GUDzyhJeOa6vVDlDP8Ks8p5PHVplNpfRQzWLOpsUh7W1tBvC/dmGOmXYocpzD6kcvbb1qFN+ElirjLvljRICMdJl2h9UuNeneK+3WAy0g3CUv3WtJ6o6fmp5F4/1ulyeLKRfIZQg+YRkqlMb+zWodEtpUOzlrudrIy8h7u8QkSBHbir3XrLeztxBlqYXjEIAyi/mo20NRiz74SKazjDkZ+RWK3NidSOKEva8PYnBeXaubJBy/moT+WCLR3H5ogsP83se0y/1qrukmf1Z/ASF7BB8yPbKsO6axpw4G2W/vvvYZ402zwIRjU2vHgJKX4sOx7tD/eS5rd2buX1La6j2zEZFdKDPC7TbelNEQ8f9lovocXDhGwS2Yex/zq+NAPA7e+dryU5oMXYSHzx3NCCcf0EfCYU2WH9ke1Prh6+oRzPpNKDaCi7cVQgCaRxsTpwe90lKGPirILryMBjP4swK6iHDDAzSLAq7/PVaFHXaGTLTuX/wIVAlJdK/bCzuywYCyW1R8CVDZCDSihFvp/e0m5txPyTpxEyrXr0G6hyBfkfqgz8yl2ru98yCR8TTR1t4UC6lDoaq2MWGkWOkYLvK89dVXb8Qd7uN8G8+oFbsu82tkZZz62C0FmqZSQ2uFFOOYisqPKXgosag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(6666004)(86362001)(6486002)(6506007)(6512007)(83380400001)(66946007)(66556008)(66476007)(52116002)(26005)(8936002)(478600001)(36756003)(316002)(956004)(8676002)(44832011)(5660300002)(38100700002)(2616005)(38350700002)(186003)(6916009)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jw4j45Ik88i3wk5lQXlwkGmFoRbkIwjWV8gdRxNFzTlSAjXHOBXJnWbs3Fmy?=
 =?us-ascii?Q?KCu4qJXjG2Dl8bw4iN0yqhlOrwW/BwLYjewDURQTaVn1MkbjZl6LIkbL9odK?=
 =?us-ascii?Q?urYApKZRZoI0fX3KoBMVPASY1TA9zjU8soHnPxyyS5PYhcQCD/NX88JT9gw3?=
 =?us-ascii?Q?hDCxTb4fUaF1Mvdmu71TNcN3RhPcc3niQFf3bvtuwYFkebJO+XHhc3Rlva7k?=
 =?us-ascii?Q?jgRTRwBtyBty0utAJ2rSxOt6LVbzvm442nG9pZPoEtKILhTtf7P2OX2IUDFL?=
 =?us-ascii?Q?pRHnl3z39lTfQEIuYK43bwPkGt3xItDIy7UnR5vejHThyCTlv4qrKjIgcWBU?=
 =?us-ascii?Q?Ut/IMnRCinkbmYl5hcJHR33BKqYpmKghf4lbTvj783eg2R3uQpfg2v4dEf6n?=
 =?us-ascii?Q?wpWvAy4+H+urpBaVbOz/n/+rRaFdZQFrgwDndTaX/lr9Vdb/FXhDia37j/Be?=
 =?us-ascii?Q?m5UqgEjmAt5HDs22AP9L11om0wgRwC/ZsJUTObPrYQyTS3v04HSFqpBP9c5D?=
 =?us-ascii?Q?JZZcAp7YQWG03vf5q/jy23CrhHeg3260+Pjd7Wqv1804wJ2uLPS1nauJrgxV?=
 =?us-ascii?Q?K3S4qu2msTs9MCCrN9RmOxgmECZGqszJd0pX2ad+/MAkIfkb5v9AOoCxwskX?=
 =?us-ascii?Q?wkPVwRwSeMVLThD9vR8+vnFrmZ6jqi9aoRywfq3NCHagcfjGpX1AwdE/8mVy?=
 =?us-ascii?Q?OA/3ViyPiiN/8RRA7K82Tten6lfkvbYoErZVZL5e/8zFx2JXNrvGy3C+f5b3?=
 =?us-ascii?Q?CsBBiCjkpea8o24Fq1Ksk6eyyNoW7viSr1fIdl6NLH//msU9MwSzu36Reakp?=
 =?us-ascii?Q?iQ6fD7Mg/6Uz7nLcgQUohcAFA0vESTvdcWH3chv2dSKWTuKy1K3sjiRFdv1e?=
 =?us-ascii?Q?t+yAUL8cthx6zjUdS/+DzRag4D9StSnu8aCjvi3qwpNmS7lVEwjkDewW4PgM?=
 =?us-ascii?Q?+VN7lT+2tGMeLUV358NBPHfgDwbWu+62okr6RrWGWHnzKJtXjqPbzhs4avW3?=
 =?us-ascii?Q?1qDofBPj0A/iY9vspm3TIeyQCQ2lnhwDFVyxcWy+khxJB3Qb1bxKOLxSq9Xt?=
 =?us-ascii?Q?K/KPjZ6aOzU5S6Mu3eN1J+Gi7ediSR3pksgRcMbtuM2Jd1Sa48zLOOVOjCor?=
 =?us-ascii?Q?aFpriaodg8529kLPcT7rLiE9fpUTQeVA0XUkQx3xQ3N164fR9yJZzSpjCJkX?=
 =?us-ascii?Q?QAD5yoHok9QPDauOa7I5xYR8254+GnneFMyHHMDoYiKOWcdwJRS9QJa5eaFk?=
 =?us-ascii?Q?Sd3i3oywojK2X5qDAaSgxFJ/eSefoFxXcli1wE2gEy81/DETSACHXBUgMJiz?=
 =?us-ascii?Q?xEZgtCTdh6y9/SatE8qPRXp9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e69408-dbed-4759-e4f6-08d964e6b729
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 21:00:32.8827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKd0B+feCTG5aSsMR6S57LofWAmuGAiRmV9EJcLKUa/xylNxPqF2Y0kGd4YKzh+MSAu6PkUK0Wwgsb5hu4wtJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the ability to grep for proper structure/variable names, if for
nothing else, use the more modern struct netlink_callback::ctx as
opposed to args to hold the stateful data over the course of an FDB dump
operation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c    |  5 ++++-
 drivers/net/ethernet/mscc/ocelot.c             |  5 ++++-
 drivers/net/vxlan.c                            |  5 +++--
 include/linux/rtnetlink.h                      | 18 ++++++++++++++++++
 net/bridge/br_fdb.c                            |  3 ++-
 net/core/rtnetlink.c                           | 16 +++++++++-------
 net/dsa/slave.c                                |  5 ++++-
 7 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d260993ab2dc..dd018dfb25ee 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -771,10 +771,13 @@ static int dpaa2_switch_fdb_dump_nl(struct fdb_dump_entry *entry,
 	int is_dynamic = entry->type & DPSW_FDB_ENTRY_DINAMIC;
 	u32 portid = NETLINK_CB(dump->cb->skb).portid;
 	u32 seq = dump->cb->nlh->nlmsg_seq;
+	struct rtnl_fdb_dump_ctx *ctx;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
 
-	if (dump->idx < dump->cb->args[2])
+	ctx = (struct rtnl_fdb_dump_ctx *)dump->cb->ctx;
+
+	if (dump->idx < ctx->fidx)
 		goto skip;
 
 	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5209650fd25f..44a56f9cda07 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -971,10 +971,13 @@ int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 	struct ocelot_dump_ctx *dump = data;
 	u32 portid = NETLINK_CB(dump->cb->skb).portid;
 	u32 seq = dump->cb->nlh->nlmsg_seq;
+	struct rtnl_fdb_dump_ctx *ctx;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
 
-	if (dump->idx < dump->cb->args[2])
+	ctx = (struct rtnl_fdb_dump_ctx *)dump->cb->ctx;
+
+	if (dump->idx < ctx->fidx)
 		goto skip;
 
 	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5a8df5a195cb..8c9371bf8195 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1371,6 +1371,7 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			  struct net_device *dev,
 			  struct net_device *filter_dev, int *idx)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	unsigned int h;
 	int err = 0;
@@ -1383,7 +1384,7 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			struct vxlan_rdst *rd;
 
 			if (rcu_access_pointer(f->nh)) {
-				if (*idx < cb->args[2])
+				if (*idx < ctx->fidx)
 					goto skip_nh;
 				err = vxlan_fdb_info(skb, vxlan, f,
 						     NETLINK_CB(cb->skb).portid,
@@ -1400,7 +1401,7 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			}
 
 			list_for_each_entry_rcu(rd, &f->remotes, list) {
-				if (*idx < cb->args[2])
+				if (*idx < ctx->fidx)
 					goto skip;
 
 				err = vxlan_fdb_info(skb, vxlan, f,
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..f14cda6939c6 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -110,6 +110,24 @@ void rtnl_kfree_skbs(struct sk_buff *head, struct sk_buff *tail);
 	WARN_ONCE(!rtnl_is_locked(), \
 		  "RTNL: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
 
+struct rtnl_fdb_dump_ctx {
+	/* Last bucket in the dev_index_head hash list that was checked.
+	 * Used by rtnl_fdb_dump to resume in case the procedure is
+	 * interrupted.
+	 */
+	int pos_hash;
+	/* Last interface within bucket @pos_hash that was checked.
+	 * Used by rtnl_fdb_dump to resume in case the procedure is
+	 * interrupted.
+	 */
+	int pos_idx;
+	/* Last FDB entry number that was dumped for the current interface.
+	 * Updated by implementers of .ndo_fdb_dump and used to resume in case
+	 * the dump procedure is interrupted.
+	 */
+	int fidx;
+};
+
 extern int ndo_dflt_fdb_dump(struct sk_buff *skb,
 			     struct netlink_callback *cb,
 			     struct net_device *dev,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 46812b659710..2f6527d1df27 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -821,6 +821,7 @@ int br_fdb_dump(struct sk_buff *skb,
 		struct net_device *filter_dev,
 		int *idx)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_fdb_entry *f;
 	int err = 0;
@@ -836,7 +837,7 @@ int br_fdb_dump(struct sk_buff *skb,
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
-		if (*idx < cb->args[2])
+		if (*idx < ctx->fidx)
 			goto skip;
 		if (filter_dev && (!f->dst || f->dst->dev != filter_dev)) {
 			if (filter_dev != dev)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2dcf1c084b20..06cd59b6260a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4184,6 +4184,7 @@ static int nlmsg_populate_fdb(struct sk_buff *skb,
 			      int *idx,
 			      struct netdev_hw_addr_list *list)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct netdev_hw_addr *ha;
 	int err;
 	u32 portid, seq;
@@ -4192,7 +4193,7 @@ static int nlmsg_populate_fdb(struct sk_buff *skb,
 	seq = cb->nlh->nlmsg_seq;
 
 	list_for_each_entry(ha, &list->list, list) {
-		if (*idx < cb->args[2])
+		if (*idx < ctx->fidx)
 			goto skip;
 
 		err = nlmsg_populate_fdb_fill(skb, dev, ha->addr, 0,
@@ -4331,6 +4332,7 @@ static int valid_fdb_dump_legacy(const struct nlmsghdr *nlh,
 
 static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct net_device *dev;
 	struct net_device *br_dev = NULL;
 	const struct net_device_ops *ops = NULL;
@@ -4361,8 +4363,8 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		ops = br_dev->netdev_ops;
 	}
 
-	s_h = cb->args[0];
-	s_idx = cb->args[1];
+	s_h = ctx->pos_hash;
+	s_idx = ctx->pos_idx;
 
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
@@ -4414,7 +4416,7 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			cops = NULL;
 
 			/* reset fdb offset to 0 for rest of the interfaces */
-			cb->args[2] = 0;
+			ctx->fidx = 0;
 			fidx = 0;
 cont:
 			idx++;
@@ -4422,9 +4424,9 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 
 out:
-	cb->args[0] = h;
-	cb->args[1] = idx;
-	cb->args[2] = fidx;
+	ctx->pos_hash = h;
+	ctx->pos_idx = idx;
+	ctx->fidx = fidx;
 
 	return skb->len;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index eb9d9e53c536..f25cd48a75ee 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -193,10 +193,13 @@ dsa_slave_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 	struct dsa_slave_dump_ctx *dump = data;
 	u32 portid = NETLINK_CB(dump->cb->skb).portid;
 	u32 seq = dump->cb->nlh->nlmsg_seq;
+	struct rtnl_fdb_dump_ctx *ctx;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
 
-	if (dump->idx < dump->cb->args[2])
+	ctx = (struct rtnl_fdb_dump_ctx *)dump->cb->ctx;
+
+	if (dump->idx < ctx->fidx)
 		goto skip;
 
 	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
-- 
2.25.1

