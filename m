Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2638C3F3C7A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 23:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhHUVBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 17:01:22 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:58336
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230376AbhHUVBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 17:01:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFvyOQLs6H4jakyCb8kZ4TPY5HOvrkvmKmlpSLxE/gtjeJV61up9yOI4G2Dc3aPgPUAtBkzRGTuK0N8+TAgzxoMGHrXeX37acgYWBpCbvdIbcVdzQzBZT7x03ETb1bdyr/uGJQjjpFfb3T1/pO2FiTlt+RrUFNd6CYiyKHbBQvWIk2hjSisa+zAeawltkP3CM/H+CRZNZOdZ32YekmodQvkMTUNht2sfWQ0qrmGNM7UqElKTWCGlquGf4NuQwqOkq5/Lcg9GCYpuiAKMA0ZBE4Llw3Tp5Rd/I1SREx9OS0CNPGuCrLzjirJ8svhobzLmCw2VrLEfwN0ffIVfM3U0kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AO1CC4MEKOv3ddlsxX0r7WS0FtFtxvd764mJ7DcaP0=;
 b=AQsP7SvRbjTsZuUrOd4ZsZfuaDrIjBP9NSJde5nmiHdym8zyYlMJULYcjN2lolLtlBCSPxlN9B48/a2+PkWbpS9Wo3ANcrundvWhk3mSBubMONUYuqYFo6gmnm4SbkAbvpf5ILxTqYv/tZLN3gj1tFHxJbTZqsLQ301kBW4Zlkil3ajQRnBcd/GRYFLFVdXVgmCiJzaW4MqZ2X9LkdKh4sIUYBNuhKQTQu2lqYeieEENXGzsH2KzDTD7tZfrzdrSMq22lxgj0sOAyovGefWLPkyAJxvN+OjIyyMrXa2DibbmS+g8dsFrjejH9kEwRvs6oQ45tP/9zas2TgmETuzQQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AO1CC4MEKOv3ddlsxX0r7WS0FtFtxvd764mJ7DcaP0=;
 b=lVLenzMWdktd0gmEMbGuQmrhyMmOssiCM5p7R6Eyka80+V9T0kA1BYjzQyp2vMphw3yMEulW++jGnkZRkx4PSNzjkLbXyvay0TBEXUdSauhS3Ed/sfvYb3J+wH2+15YU7beA6OvXPAnKR8SoTk+CCKQYphMQ+5pjVR+zNiGPpZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 21 Aug
 2021 21:00:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 21:00:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [RFC PATCH 3/4] net: dsa: implement a shared FDB dump procedure
Date:   Sun, 22 Aug 2021 00:00:17 +0300
Message-Id: <20210821210018.1314952-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0010.eurprd06.prod.outlook.com (2603:10a6:800:1e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 21:00:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a62dcd3-bf89-4641-b975-08d964e6b7a5
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687DFCAE93351048DBFA8D9E0C29@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDfXGzJeFhUi+8Iarn0ehcKI5Yr80EOlqIy6YQO3joEsZVABNDVDf/RH4CdZ+NU6QHbvyjiJP7kvTsfsPecxOp0pYA8GL5gTjlUkO3a4ikDprGppx4qtIrkPMzVI6Uqq2y2B0NbyTactzyAqMn1XigLCjHKO5ZOmFIV8cEs34MWBxsVzWAv0r4w3n+T4hOEHT2eqLfFRMxYtRKPKrb/+x8bMzCF9rRd43OsM80EIYKQNql2vAcCGa9DbadeT4JXoDe+dqr1RcK8SiFj6SFs20B8kTCZBLgfY33F4qqos0Ye/Pn43iNPiiFD3QlBO2VmKwv5oYjbDlsLd+4Dsn5OWW+0LxYtxjZQXYjXrB0kcowfvGk9b5EYPYYI272f1hii44YlfHRbBM0VmczGZYSfaFmCLiWLVP17LXifyyENxXvB+dgiGUl4ZexdKsNyBSTHI9g2fVrJNCyRE6IyOT/fGTIhUVypE2b9lM2eqzmQSBbgkaXWnIe/nWHn6uI0zV9MAyV6tp3Eui4bIVUQSSJLai3QVWr/VSNTn7CgZKWFaTQHstiM1vqqGKheNQvp8bzXGPSGzmkz603ivZ6GtNVidAxvLF5Na2MNgvDy3rINewM7gN75nsZtdATvZq3mfpFOjP2QUm/zsJUtkfc0PEwGi7LQamcm1o1obpemCBhzRsx+j3yDJWlslyU4Ngkgwnfq1E2Fh+MAtfh7PyXFXasnvug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(6666004)(86362001)(6486002)(6506007)(6512007)(83380400001)(66946007)(66556008)(66476007)(52116002)(26005)(8936002)(478600001)(36756003)(316002)(956004)(8676002)(44832011)(5660300002)(38100700002)(2616005)(38350700002)(186003)(6916009)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AcuExKj/hHm+ryIsHXr96UwpX/yIBrH0z3slivvaEujcO38pPG8VY//t6aP2?=
 =?us-ascii?Q?6t7ryqXfQAHI5Kxt8Su+rGV6HbKfLjIYMm7Kms+xEAVCBK4t39tknbyhW9Nh?=
 =?us-ascii?Q?FTUxOoMHz+Oe5XaUayrIV0FwAX1YEdXU/pCtDiy1y3r3OjnsBh81HCQuskNU?=
 =?us-ascii?Q?EKG57AfZeEqKZmGd+5V447Ub6CokQd3bdVXXkmWOCOIC//QhGi+QtUGKhxRG?=
 =?us-ascii?Q?lpMemQx4Vbe8NeB2QSF+eFvmPDcgiWVi96Z9uimIJLYC0fNZLwyAy1H2lX1N?=
 =?us-ascii?Q?kqDTOAZX8S95qxoEYY7M/+WTTZiC5yZat/SS9E4Mmd/uI8nneVw0qwxnPzck?=
 =?us-ascii?Q?pqJIBTKDilKIJTvSVwRNgXKbIa7yfc6FLF6DNG1R4FnD13u3OgzyCEqmDWQo?=
 =?us-ascii?Q?aM6P9HSaZoEgZ6rbtZz/6EVQlYbnOGoFsU1QITcd5mamKjbZjX5eRzVf069v?=
 =?us-ascii?Q?WL9ijxa4yIdO7x0HG6dKDM9CBwfGjq9IatHx7p7wncfzfHVbIJTpO1gxQtdx?=
 =?us-ascii?Q?Vh5OJnDT3tbZYbWnPbEHII9T1qshOs+zeMm9vGoAXnagVnKrFrFD+YTMp75f?=
 =?us-ascii?Q?nj2A8BcTJ2qwja7DCqpyDrDjMu1D0wzuPJ1qB3u7CNS735ThhAGfEhQQVS+n?=
 =?us-ascii?Q?Pmb1W7riDk+wOWv3GB9sJJeoi0UUbH7qVUg9Whmy0HFvFKCBFvHlp03g7umT?=
 =?us-ascii?Q?QvhREj6e5HFGp8pDpRsppb/1SZ/TAikR4dyLvsa+8YU40mTb+8qZHr33u/A/?=
 =?us-ascii?Q?IpjEAGQz+xoBPijtIgrlJSlRhrYnUjuoY1C64bxMxOUJNjgT38KGxkZYHpqk?=
 =?us-ascii?Q?6bmcWiyDBDLxAZKYQwiOYo/bFbiswc9hHt/7y4XUJKG9w3ocOsvQlJZKW/LX?=
 =?us-ascii?Q?FZ1TvY+Sn7RgnhvIotTeBuQQDTH8h3An4ZK1cfWDuviKU7xSyUfvG8XE6lg0?=
 =?us-ascii?Q?J1s66rsJrTj74kfwhUgqZt33KFts9WX8xrXqo+90VnidYJmcBSAw1CDTvx2+?=
 =?us-ascii?Q?fEbLzF/9zkDKG2L5BcHWUYWnw2YD0LTyLR72teLA0Vj/XURXAA4km2EKpUJf?=
 =?us-ascii?Q?wbauYCbTnkXLKvQHhCKcIm+XFrl/a+1gC2qphlhblkIcLTA67Ut0yoyiQ4fl?=
 =?us-ascii?Q?2SVorJbisU/jNwlj4jPu1mtKVozmGBZ5YwdhQCBCiGyFUhwvnxicxwVOak55?=
 =?us-ascii?Q?Ujoa34/5Jvw2ZzN6QAb3X1kcYUCDSmlEUD56JMAj+VUr0O8inXf/PLYEGey/?=
 =?us-ascii?Q?lT5xKnQysVoLCNwS+0nnqjy401HATCB5m9fINEwEx4hIqrjqB9KpcQQbHZ/r?=
 =?us-ascii?Q?qRtY3ElrUGqLg6N7qIi77tjY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a62dcd3-bf89-4641-b975-08d964e6b7a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 21:00:33.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b1cvY2BOjKRy0lgLFJIxF3AvX9oBF/U0Z8oaNLVQzQhgEDWOgaw2QkHmADrJNXJRa60WPT6unnSB45M8xmE3Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a list of FDB entries per switch that will be:

- populated during the ndo_fdb_dump prepare phase
- looked up during the ndo_fdb_dump commit phase
- freed during the ndo_fdb_dump finish phase

Also a bool ds->shared_fdb_dump_in_progress to denote whether we should
perform the shared FDB dump or the normal FDB dump procedure (since the
shared FDB dump needs more memory, we prefer the per-port procedure for
dumps that target a single port).

Introduce a new dsa_switch_ops method for the shared FDB dump. This is
"switch_fdb_dump" and lacks a "port" argument - instead, the switch is
supposed to provide the port for each FDB entry it finds.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  17 ++++
 net/dsa/dsa2.c     |   2 +
 net/dsa/dsa_priv.h |   1 +
 net/dsa/slave.c    | 194 ++++++++++++++++++++++++++++++++++++++-------
 net/dsa/switch.c   |   8 ++
 5 files changed, 195 insertions(+), 27 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0c2cba45fa79..23b675f843f4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -312,8 +312,17 @@ struct dsa_mac_addr {
 	struct list_head list;
 };
 
+struct dsa_fdb_entry {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	bool is_static;
+	struct net_device *dev;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	bool setup;
+	bool shared_fdb_dump_in_progress;
 
 	struct device *dev;
 
@@ -355,6 +364,9 @@ struct dsa_switch {
 	/* Storage for drivers using tag_8021q */
 	struct dsa_8021q_context *tag_8021q_ctx;
 
+	/* Storage for shared FDB dumps */
+	struct list_head	fdb_list;
+
 	/* devlink used to represent this switch device */
 	struct devlink		*devlink;
 
@@ -565,6 +577,9 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
+typedef int dsa_switch_fdb_dump_cb_t(struct dsa_switch *ds, int port,
+				     const unsigned char *addr, u16 vid,
+				     bool is_static);
 struct dsa_switch_ops {
 	/*
 	 * Tagging protocol helpers called for the CPU ports and DSA links.
@@ -737,6 +752,8 @@ struct dsa_switch_ops {
 				const unsigned char *addr, u16 vid);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
+	int	(*switch_fdb_dump)(struct dsa_switch *ds,
+				   dsa_switch_fdb_dump_cb_t *cb);
 
 	/*
 	 * Multicast database
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index dcd67801eca4..99b5aad46b02 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -801,6 +801,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 			goto teardown;
 	}
 
+	INIT_LIST_HEAD(&ds->fdb_list);
+
 	ds->setup = true;
 
 	return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b7a269e0513f..c8306b1f1c11 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -533,6 +533,7 @@ static inline void *dsa_etype_header_pos_tx(struct sk_buff *skb)
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
+int dsa_switch_fdb_dump(struct dsa_switch *ds, dsa_switch_fdb_dump_cb_t *cb);
 
 /* dsa2.c */
 void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9331093a84dd..ba864c5d1350 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -186,23 +186,18 @@ struct dsa_slave_dump_ctx {
 	int idx;
 };
 
-static int
-dsa_slave_port_fdb_do_dump(const unsigned char *addr, u16 vid,
-			   bool is_static, void *data)
-{
-	struct dsa_slave_dump_ctx *dump = data;
-	u32 portid = NETLINK_CB(dump->cb->skb).portid;
-	u32 seq = dump->cb->nlh->nlmsg_seq;
-	struct rtnl_fdb_dump_ctx *ctx;
+static int dsa_nlmsg_populate_fdb(struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct net_device *dev,
+				  const unsigned char *addr, u16 vid,
+				  bool is_static)
+{
+	u32 portid = NETLINK_CB(cb->skb).portid;
+	u32 seq = cb->nlh->nlmsg_seq;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
 
-	ctx = (struct rtnl_fdb_dump_ctx *)dump->cb->ctx;
-
-	if (dump->idx < ctx->fidx)
-		goto skip;
-
-	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
+	nlh = nlmsg_put(skb, portid, seq, RTM_NEWNEIGH,
 			sizeof(*ndm), NLM_F_MULTI);
 	if (!nlh)
 		return -EMSGSIZE;
@@ -213,32 +208,152 @@ dsa_slave_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 	ndm->ndm_pad2    = 0;
 	ndm->ndm_flags   = NTF_SELF;
 	ndm->ndm_type    = 0;
-	ndm->ndm_ifindex = dump->dev->ifindex;
+	ndm->ndm_ifindex = dev->ifindex;
 	ndm->ndm_state   = is_static ? NUD_NOARP : NUD_REACHABLE;
 
-	if (nla_put(dump->skb, NDA_LLADDR, ETH_ALEN, addr))
+	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, addr))
 		goto nla_put_failure;
 
-	if (vid && nla_put_u16(dump->skb, NDA_VLAN, vid))
+	if (vid && nla_put_u16(skb, NDA_VLAN, vid))
 		goto nla_put_failure;
 
-	nlmsg_end(dump->skb, nlh);
+	nlmsg_end(skb, nlh);
 
-skip:
-	dump->idx++;
 	return 0;
 
 nla_put_failure:
-	nlmsg_cancel(dump->skb, nlh);
+	nlmsg_cancel(skb, nlh);
 	return -EMSGSIZE;
 }
 
+static int dsa_switch_shared_fdb_save_one(struct dsa_switch *ds, int port,
+					  const unsigned char *addr, u16 vid,
+					  bool is_static)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_fdb_entry *fdb;
+
+	if (!dsa_port_is_user(dp))
+		return 0;
+
+	/* Will be freed during the finish phase */
+	fdb = kzalloc(sizeof(*fdb), GFP_KERNEL);
+	if (!fdb)
+		return -ENOMEM;
+
+	ether_addr_copy(fdb->addr, addr);
+	fdb->vid = vid;
+	fdb->is_static = is_static;
+	fdb->dev = dp->slave;
+	list_add_tail(&fdb->list, &ds->fdb_list);
+
+	return 0;
+}
+
+/* If the switch does not support shared FDB dump, do nothing and do the work
+ * in the commit phase.
+ */
+static int dsa_shared_fdb_dump_prepare(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->switch_fdb_dump)
+		return 0;
+
+	if (ds->shared_fdb_dump_in_progress)
+		return 0;
+
+	/* If this switch's FDB has not been dumped before during this
+	 * prepare/commit/finish cycle, dump it now and save the results.
+	 */
+	err = dsa_switch_fdb_dump(ds, dsa_switch_shared_fdb_save_one);
+	if (err)
+		return err;
+
+	ds->shared_fdb_dump_in_progress = true;
+
+	return 0;
+}
+
 static int
-dsa_slave_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
-		   struct net_device *dev, struct net_device *filter_dev,
-		   int *idx)
+dsa_shared_fdb_dump_commit(struct sk_buff *skb, struct netlink_callback *cb,
+			   struct net_device *dev, int *idx)
 {
 	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_fdb_entry *fdb;
+	int err;
+
+	/* Dump the FDB entries corresponding to the requested port from the
+	 * saved results.
+	 */
+	list_for_each_entry(fdb, &ds->fdb_list, list) {
+		if (fdb->dev != dev)
+			continue;
+
+		if (*idx < ctx->fidx)
+			goto skip;
+
+		err = dsa_nlmsg_populate_fdb(skb, cb, dev, fdb->addr, fdb->vid,
+					     fdb->is_static);
+		if (err)
+			return err;
+
+skip:
+		*idx += 1;
+	}
+
+	return 0;
+}
+
+/* Tear down the context stored during the shared FDB dump */
+static void dsa_shared_fdb_dump_finish(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_fdb_entry *fdb, *tmp;
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->shared_fdb_dump_in_progress)
+		return;
+
+	list_for_each_entry_safe(fdb, tmp, &ds->fdb_list, list) {
+		list_del(&fdb->list);
+		kfree(fdb);
+	}
+
+	ds->shared_fdb_dump_in_progress = false;
+}
+
+static int
+dsa_slave_port_fdb_do_dump(const unsigned char *addr, u16 vid,
+			   bool is_static, void *data)
+{
+	struct dsa_slave_dump_ctx *dump = data;
+	struct rtnl_fdb_dump_ctx *ctx;
+	int err;
+
+	ctx = (struct rtnl_fdb_dump_ctx *)dump->cb->ctx;
+
+	if (dump->idx < ctx->fidx)
+		goto skip;
+
+	err = dsa_nlmsg_populate_fdb(dump->skb, dump->cb, dump->dev, addr, vid,
+				     is_static);
+	if (err)
+		return err;
+
+skip:
+	dump->idx++;
+	return 0;
+}
+
+static int
+dsa_slave_fdb_dump_single(struct sk_buff *skb, struct netlink_callback *cb,
+			  struct net_device *dev, int *idx)
+{
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_dump_ctx dump = {
 		.dev = dev,
@@ -248,15 +363,40 @@ dsa_slave_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	};
 	int err;
 
-	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
-		return 0;
-
 	err = dsa_port_fdb_dump(dp, dsa_slave_port_fdb_do_dump, &dump);
 	*idx = dump.idx;
 
 	return err;
 }
 
+static int
+dsa_slave_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
+		   struct net_device *dev, struct net_device *filter_dev,
+		   int *idx)
+{
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	switch (ctx->state) {
+	case RTNL_FDB_DUMP_PREPARE:
+		err = dsa_shared_fdb_dump_prepare(dev);
+		break;
+	case RTNL_FDB_DUMP_COMMIT:
+		if (ds->shared_fdb_dump_in_progress)
+			err = dsa_shared_fdb_dump_commit(skb, cb, dev, idx);
+		else
+			err = dsa_slave_fdb_dump_single(skb, cb, dev, idx);
+		break;
+	case RTNL_FDB_DUMP_FINISH:
+		dsa_shared_fdb_dump_finish(dev);
+		break;
+	}
+
+	return err;
+}
+
 static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index fd1a1c6bf9cf..a64613e1f99e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -655,6 +655,14 @@ dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
 	return 0;
 }
 
+int dsa_switch_fdb_dump(struct dsa_switch *ds, dsa_switch_fdb_dump_cb_t *cb)
+{
+	if (!ds->ops->switch_fdb_dump)
+		return -EOPNOTSUPP;
+
+	return ds->ops->switch_fdb_dump(ds, cb);
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
-- 
2.25.1

