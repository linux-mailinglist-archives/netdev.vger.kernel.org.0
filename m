Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708633F3C7B
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 23:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhHUVBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 17:01:24 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:58336
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230234AbhHUVBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 17:01:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hi1d8N3t4wgKUldtCxMjR6m6JoR5iqk7rDWwaSe7l09Eu25vO24/5Dn/dYpTLJgMBiyyk+Np4NVGGZr5+z9/eh5pfpfLugmmeUetncDe30NXHtPtIF1tBlni/YPr7VOHyf7eY1OW1ACZxOFHezpBQ7aHGEMjpar3dXc1COVdhtJeJt3vuV8TT0PN9IbdLtPxHCdjpVkFhTGBEvx3s6YfCBOe7lyTNe8lGtTdFL2M3pGPUSHXtM+AnJamcx28K74cYRQj/wagCbEnCcrYAnDPSWK1PBdV6mMduzZ6WGwqT5hxPzZD68LKrokmnmLddBKC5QHkWrKle3whCQlcVRco4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtwHRrTZVlf9jMbvr3cZIM+ei7ueaiRSHea6g2SZo94=;
 b=mFOXIdGLuVLDLXReDOZiRsxvE8tHUpxWnKgnT2bozo21E+A8F67xZ5e95kFBwQmEaSy0e0i1fd/3VmgqxPlsItb2NlQNBur5dnvMDrxwPnuvGPBFlZje98Cy9VhhjkQEja9ZwjaIYIExhHZ8+/GcBrXS4sbQ0aEoy54wqY7neQT2n8hXzoTetcbxijUPEA/gYaWJLaHX8K7qDtZjV8RConHwidPFl43+n2oXpasPTGI8LO/D52FPCjqR5TwIcvWlAOr8WKuW1iVIZLznfkr7qghUVfuAUscvCfiPId5K6E53X5UHiT1k8gXVOUmpQd1eCJ5h0/zPD54/G+TQcI2RHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtwHRrTZVlf9jMbvr3cZIM+ei7ueaiRSHea6g2SZo94=;
 b=G7nWYBBYGwN1Oj+14ThYu7Bue816ndKZECnQk2SI2BorSg5xmobeR/MZVrTgjrAL//cVKN91lRO5agpCobWuHrapswhmjXAL8JXU7Tl1j+JjhGEetBglwNNuSgSvni6rv7uqzHMzxDRnbeC/O0QFJmKQpYvZKO3FLlZo5gyNk34=
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
Subject: [RFC PATCH 2/4] net: rtnetlink: add a minimal state machine for dumping shared FDBs
Date:   Sun, 22 Aug 2021 00:00:16 +0300
Message-Id: <20210821210018.1314952-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 93aed08d-56d4-414f-b188-08d964e6b763
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26878FD8E8A15324D8EF3AFFE0C29@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2NGEl2wdtxJtI8vMgnGjgcvYkQdz86DtJi7AKBcE6Prc8Y1fGhewFIb9tQa7HQo2D6qfquwC5iULQaKHzyUNhL3dokm/IICi5DUbCTTX0vPv058buoZgoEEXvT/mRXvJIMS36CwPB5R8sWMOECNEGgSnuM1sVdeqJGF0zFbG/bPJcyW2hZMt/tD/CN57BbJJd+eqIYpHHaqR+92yT+DdHRZbn3ICg1acuK8bgKzQQFSF62dyhfc64+E7lbmH2jzlH2zhTyxEifb9fMzpfwGIvDBBoxOqSH7n0t+OtQDjcEF6JsWoPIQGhLnqznMtXS4kCGwrZY9TeEZ6ne6PUvO7ztM10+P+EcHJ9Cm1VfwnHnRVfkkOthSsH/huTTfT5RFyfGVKQVaP1NHENqPQPvX5lfmDeRnU6Iu3FYFZJzr2EcMrZRhGAL4et6q3xRHgDfEnmI3vWUHKvZro0MKSRbt9/hmmDasP3rrXteBE/isZkqgdPcSnmm9sTQUvakRT+Zr7bkqjaLAu0rirfhGXB9PfuvckPBKkEAfUBWfmkNOUf+9lZoLMClA7oNZ5/7bLTU5PItw0B6NyyKRNyb31Ejd5OYyWldWXAgvtD0VPtq0AY2B3ZI3HPyuC86fmuNtFO7uB9ip5tvWv+GW16H4bCJRD1hXQTu0ASMy4YV+vf57rtYhcvJ5yKF5HB0RJnZAq4YzFzaBV6qUw1lJ03/k3NHdn9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(6666004)(86362001)(6486002)(6506007)(6512007)(83380400001)(66946007)(66556008)(66476007)(52116002)(30864003)(26005)(8936002)(478600001)(36756003)(316002)(956004)(8676002)(44832011)(5660300002)(38100700002)(2616005)(38350700002)(186003)(6916009)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOr7gJS3OW0Ab+1L8ZEM/fSZ7Ugt1oIA1UHvrcEx/CZcMfd27I9op5wpJLCT?=
 =?us-ascii?Q?Cx4/lqBD/2Arme2p9pQ6uf8/b1Oq9RWdHsmH25oQ1efeTsAuZxEezHeYSpnB?=
 =?us-ascii?Q?oJS84dxjU0h1BNveoKzBd5nFObHppICY6nBX6psmysrY0ZpQBFTOyuRn5yOu?=
 =?us-ascii?Q?XmT9b3g7M8b7y6neNVPkRRi7N4nHsG9oCpMtwyS1RA5k2Piv0mw1cr+SOWI+?=
 =?us-ascii?Q?wdHJPnBXIhQcphA9daTzPk4QoV6bH/IPx/RZcWs9yA21QiuR87KLjCRkKp55?=
 =?us-ascii?Q?2+F2p/ayoD7VDb0pZSeXUjXwHQNepR6CeytYIu7VJY2d9l6HocKxDRvWA1cJ?=
 =?us-ascii?Q?JIDeIy3X3mc8oWMZ/KjdBBz5oXYHg9BCj948j5jMeaOfJgTOiuQIL6DL4Fw3?=
 =?us-ascii?Q?aEnd7Six0ZSFMIGRJ+CIqzZrbXLSU8SyQ48DcDBXUAQF/WbuguVNLfhOEIdg?=
 =?us-ascii?Q?xy4P+AlY7VV7v/CE+md1zUndr5bLB7laSBzjlpj5gx7DlCIGeAMDf8s8xfUK?=
 =?us-ascii?Q?AoLel+5DqaPmKos25yLUSLEaD7IjVixhlxXV7h03ltNFU3ZgQuawU8rapREz?=
 =?us-ascii?Q?XBTKcTihNcmrHID+q3NCoTKjUlUMn1mvvUbu9g5TyVJrdgOg+eCVzvfIk1TD?=
 =?us-ascii?Q?CTeZ9hXMBVtq5fOBnLHUPsro510FBq57sJVJKbEj7BkZpYlM7VQOhKqASt7T?=
 =?us-ascii?Q?dZdG56JKXKp+V8N6zZa3BhSOus5QNRqoQmGlM9FLAEwbfbyS+MBcdvmSQoBK?=
 =?us-ascii?Q?NmjbXSGzq6sk9L60ft1rh4m+MxcOAOFch+PF2tBqDCkFUO0gISjhWQFcY10w?=
 =?us-ascii?Q?QitMB+W4OGlSZLI37WXmpIumYtXEVmCNw8vj9+Fw5jjyvEKpaXQAvdShJ9Um?=
 =?us-ascii?Q?q7WaRjQSuDsYi4FdhAG3ZS0uJcVAZvXo5w0posvzsZ4YKV2I6wjZjfD0XU5e?=
 =?us-ascii?Q?zFKiYCAhxolfdtIoe2GyxaJNJwQdnaj0btsD0hRDn1Bb7Odjof30uvocvyiC?=
 =?us-ascii?Q?c+TKDPLmmFOV5HQjUMLBJXFdPMGL7etB7kbJdlb0FhlGBY1OVFM3c+v507IP?=
 =?us-ascii?Q?bu2m8MPq5KGM63Xh+T9+NR054npXGXxvWSPnFgwZ+rfZ37fLCLk8gDY4FO1d?=
 =?us-ascii?Q?LQCxkEkVdM/aeuUhCKmcxCO5UtPIy3nfAsd/9XNAFbLwqGwNPBUJYXYziof7?=
 =?us-ascii?Q?eOsl/AOXb/4g58gQWmKzv3oQV0sK8bc6Y1IyYjJCCd6ZKD7hDyrEka+p3dXV?=
 =?us-ascii?Q?LgXW797QHVquaolj67nW74boFYACZdL5mvAF0FFlnIpMpbG/zxxP2jelcCqh?=
 =?us-ascii?Q?ZEoulhb+yY6kgNowx8xUdfnY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93aed08d-56d4-414f-b188-08d964e6b763
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 21:00:33.2734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4cjewe/JeQ9SBXweAwFYmkU/0wlMpySrn462Abhc8Ay1/+6Km0/or5KB72DrFdi4pQXhNMT4axCPMKo1NJHyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers which offload the bridge do not have the ability to
synchronize their hardware FDB with the bridge's software FDB, but they
perform autonomous address learning nonetheless. These drivers implement
.ndo_fdb_dump and report their hardware learned entries as 'self' to
netlink.

The FDB dump procedure for these drivers is wasteful, since many times,
the FDB is shared across all ports of a bridge (or even globally shared
across all ports of a switch in some cases). So since an FDB dump means
to walk the entire FDB, and .ndo_fdb_dump is per netdev, we end up
walking an FDB shared by 10 netdevices 10 times, once for each port.

If on top of that, the access to the FDB is also slow (which is actually
not all that uncommon, since this is one of the reasons these drivers do
not bother to synchronize their hardware FDB in the first place), it
means that an FDB dump is a very inefficient and slow operation - it may
take minutes or more.

This change keeps the .ndo_fdb_dump function prototype as is, but:

- introduces a "prepare" and a "finish" phase. The phase that exists in
  the code base right now is retroactively named "commit" phase.

- if the rtnl_fdb_dump request is specific to a single port, nothing
  changes. We jump straight to the commit phase of that specific port.

- if the rtnl_fdb_dump request is imprecise (no brport_idx or br_idx
  specified), that is when there is an opportunity for improvement.
  rtnl_fdb_dump first enters the "prepare" phase, where it notifies
  _all_ netdev drivers that have the .ndo_fdb_dump method implemented.
  It only enters the "commit" phase once all netdevs were prepared.
  The "commit" phase may be interrupted by lack of space in the netlink
  skb. No problem, when user space comes back with a new buffer we
  return to the commit phase, just like in the code that exists now.
  After the commit phase ends for all netdevs, rtnl_fdb_dump proceeds to
  call the "finish" phase for all drivers.

In the envisioned use case, a multi-port [ switch ] driver will dump its
shared FDB in the "prepare" phase: for .ndo_fdb_dump(dev), it checks
what is the FDB corresponding to "dev", and if the FDB has been already
dumped, do nothing, otherwise dump it and just save the FDB entries
collected (in a list, array, whatever), no matter which port they
correspond to.

Then, in the "commit" phase, the FDB entries collected above are
filtered by the "dev" in .ndo_fdb_dump(dev). Only those are reported
inside the netlink skb.

Then, in the "finish" phase, any allocated memory can be freed.

All drivers are modified to ignore any other phase except the "commit"
phase, to preserve existing functionality.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  4 +
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +
 drivers/net/vxlan.c                           |  3 +
 include/linux/rtnetlink.h                     |  7 ++
 net/bridge/br_fdb.c                           |  3 +
 net/core/rtnetlink.c                          | 91 +++++++++++++++----
 net/dsa/slave.c                               |  4 +
 7 files changed, 99 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index dd018dfb25ee..bca3a9c05b18 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -895,6 +895,7 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 				      struct net_device *net_dev,
 				      struct net_device *filter_dev, int *idx)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
 	struct ethsw_dump_ctx dump = {
 		.dev = net_dev,
@@ -904,6 +905,9 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	};
 	int err;
 
+	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
+		return 0;
+
 	err = dpaa2_switch_fdb_iterate(port_priv, dpaa2_switch_fdb_entry_dump, &dump);
 	*idx = dump.idx;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5e8965be968a..02efe452106f 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -687,6 +687,7 @@ static int ocelot_port_fdb_dump(struct sk_buff *skb,
 				struct net_device *dev,
 				struct net_device *filter_dev, int *idx)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	struct ocelot_dump_ctx dump = {
@@ -698,6 +699,9 @@ static int ocelot_port_fdb_dump(struct sk_buff *skb,
 	int port = priv->chip_port;
 	int ret;
 
+	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
+		return 0;
+
 	ret = ocelot_fdb_dump(ocelot, port, ocelot_port_fdb_do_dump, &dump);
 
 	*idx = dump.idx;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 8c9371bf8195..09f5d796c26b 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1376,6 +1376,9 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	unsigned int h;
 	int err = 0;
 
+	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
+		return 0;
+
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		struct vxlan_fdb *f;
 
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index f14cda6939c6..e4773ebde8fc 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -110,6 +110,12 @@ void rtnl_kfree_skbs(struct sk_buff *head, struct sk_buff *tail);
 	WARN_ONCE(!rtnl_is_locked(), \
 		  "RTNL: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
 
+enum rtnl_fdb_dump_state {
+	RTNL_FDB_DUMP_PREPARE,
+	RTNL_FDB_DUMP_COMMIT,
+	RTNL_FDB_DUMP_FINISH,
+};
+
 struct rtnl_fdb_dump_ctx {
 	/* Last bucket in the dev_index_head hash list that was checked.
 	 * Used by rtnl_fdb_dump to resume in case the procedure is
@@ -126,6 +132,7 @@ struct rtnl_fdb_dump_ctx {
 	 * the dump procedure is interrupted.
 	 */
 	int fidx;
+	enum rtnl_fdb_dump_state state;
 };
 
 extern int ndo_dflt_fdb_dump(struct sk_buff *skb,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2f6527d1df27..cbbd291edb66 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -826,6 +826,9 @@ int br_fdb_dump(struct sk_buff *skb,
 	struct net_bridge_fdb_entry *f;
 	int err = 0;
 
+	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
+		return 0;
+
 	if (!(dev->priv_flags & IFF_EBRIDGE))
 		return err;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 06cd59b6260a..57d58f3824b0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4225,8 +4225,12 @@ int ndo_dflt_fdb_dump(struct sk_buff *skb,
 		      struct net_device *filter_dev,
 		      int *idx)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	int err;
 
+	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
+		return 0;
+
 	if (dev->type != ARPHRD_ETHER)
 		return -EINVAL;
 
@@ -4330,30 +4334,40 @@ static int valid_fdb_dump_legacy(const struct nlmsghdr *nlh,
 	return 0;
 }
 
-static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
+static void rtnl_fdb_dump_prepare_finish(struct sk_buff *skb,
+					 struct netlink_callback *cb)
 {
-	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
+	struct net *net = sock_net(skb->sk);
+	struct hlist_head *head;
 	struct net_device *dev;
-	struct net_device *br_dev = NULL;
-	const struct net_device_ops *ops = NULL;
+	int h, fidx = 0;
+
+	for (h = 0; h < NETDEV_HASHENTRIES; h++) {
+		head = &net->dev_index_head[h];
+		hlist_for_each_entry(dev, head, index_hlist) {
+			if (!dev->netdev_ops->ndo_fdb_dump)
+				continue;
+
+			dev->netdev_ops->ndo_fdb_dump(skb, cb, dev,
+						      NULL, &fidx);
+		}
+	}
+}
+
+static int rtnl_fdb_dump_commit(struct sk_buff *skb, struct netlink_callback *cb,
+				int br_idx, int brport_idx)
+{
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	const struct net_device_ops *cops = NULL;
+	const struct net_device_ops *ops = NULL;
 	struct net *net = sock_net(skb->sk);
+	struct net_device *br_dev = NULL;
 	struct hlist_head *head;
-	int brport_idx = 0;
-	int br_idx = 0;
-	int h, s_h;
+	struct net_device *dev;
 	int idx = 0, s_idx;
-	int err = 0;
 	int fidx = 0;
-
-	if (cb->strict_check)
-		err = valid_fdb_dump_strict(cb->nlh, &br_idx, &brport_idx,
-					    cb->extack);
-	else
-		err = valid_fdb_dump_legacy(cb->nlh, &br_idx, &brport_idx,
-					    cb->extack);
-	if (err < 0)
-		return err;
+	int err = 0;
+	int h, s_h;
 
 	if (br_idx) {
 		br_dev = __dev_get_by_index(net, br_idx);
@@ -4431,6 +4445,49 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
+	int brport_idx = 0;
+	int br_idx = 0;
+	int err;
+
+	if (cb->strict_check)
+		err = valid_fdb_dump_strict(cb->nlh, &br_idx, &brport_idx,
+					    cb->extack);
+	else
+		err = valid_fdb_dump_legacy(cb->nlh, &br_idx, &brport_idx,
+					    cb->extack);
+	if (err < 0)
+		return err;
+
+	/* user did not specify a bridge or a bridge port */
+	if (!brport_idx && !br_idx) {
+		switch (ctx->state) {
+		case RTNL_FDB_DUMP_PREPARE:
+			rtnl_fdb_dump_prepare_finish(skb, cb);
+			ctx->state = RTNL_FDB_DUMP_COMMIT;
+			fallthrough;
+		case RTNL_FDB_DUMP_COMMIT:
+			err = rtnl_fdb_dump_commit(skb, cb, br_idx, brport_idx);
+			if (err)
+				return err;
+			ctx->state = RTNL_FDB_DUMP_FINISH;
+			fallthrough;
+		case RTNL_FDB_DUMP_FINISH:
+			rtnl_fdb_dump_prepare_finish(skb, cb);
+			break;
+		}
+	} else {
+		ctx->state = RTNL_FDB_DUMP_COMMIT;
+		err = rtnl_fdb_dump_commit(skb, cb, br_idx, brport_idx);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
 static int valid_fdb_get_strict(const struct nlmsghdr *nlh,
 				struct nlattr **tb, u8 *ndm_flags,
 				int *br_idx, int *brport_idx, u8 **addr,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f25cd48a75ee..9331093a84dd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -238,6 +238,7 @@ dsa_slave_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		   struct net_device *dev, struct net_device *filter_dev,
 		   int *idx)
 {
+	struct rtnl_fdb_dump_ctx *ctx = (struct rtnl_fdb_dump_ctx *)cb->ctx;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_dump_ctx dump = {
 		.dev = dev,
@@ -247,6 +248,9 @@ dsa_slave_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	};
 	int err;
 
+	if (ctx->state != RTNL_FDB_DUMP_COMMIT)
+		return 0;
+
 	err = dsa_port_fdb_dump(dp, dsa_slave_port_fdb_do_dump, &dump);
 	*idx = dump.idx;
 
-- 
2.25.1

