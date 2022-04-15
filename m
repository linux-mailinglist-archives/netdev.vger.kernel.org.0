Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8D7502D44
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355600AbiDOPtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355594AbiDOPtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:08 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014F54BED
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwDxRt/gznT+xEXkaSo4w5jqdXTAFWQlQTYcRNmt2wewouxw7mfRd1Oy9jp3X0XmdfklIuNlYMmOPkN+9gvFH7e1nxJyhhkzyxxzeY3rEq1o08PfUJ4keBaVN+65Rd5nqEUJT0qP7qh/SrGEcRx0O8M4XH0sbnWaqDKVxkvmAxIeWNzi8b559Os75gw0nRYAqpgDeShNBc4glWtB9dDrPqkz5+iNwphZQon0OGHYGAa63BEmmvUXbMHL2LDXus69P5Lg6we4gUzVVY0/vIdAnYObnyhjfCYferx5VIcF7Xkugz/jW3IJGZGPWHyPo5urI94gYwzJRI4hMPzVVqE3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FFFL4KrIGC1so5vzjXAbb8Ie7bEU3+J1j2VmjbZzN0=;
 b=g9ULf8q9O8ghJ0pN2/fYTdtWRo7TFsie56cfwG07tmcHwbIgBa+Iy+lhFzSDizxYX/g9E/IKC/t6a3pqODCkUFpwYJIrc14Ncu3wEBnDTcvPVWBdpp0W4VKYmovTMv00aE6EWL3x2FOMrVM21Hca5EGK/68iKlhdjCxbioXPYME/Mr0iNTGrhksqRiZySzzIuKt967MlBuvrp+W3PxvpOh1Wg3Y+lJoMa+q3rrMe6ycvgAq3+22KVgibzk336LnUQk5hhCTxhQsmNnpzf+qm1M4MIrLFMU4HsGIYjfQV/AMcO/wXH28ljbSuR1j+7GEaH637FnnTGcD/d2g8uXLxWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FFFL4KrIGC1so5vzjXAbb8Ie7bEU3+J1j2VmjbZzN0=;
 b=goadqscajLu0OrQSepYpM8Iae+J7SftLdaY+2tr/vjjx7S6oLmFLO3MSJ7scpLIHLCNgKgzQ4VGuHWY25FSehwF4aoq9AlPYZcbZ8xbZv1BmA7NtIxMvJPrbE5UAuFGrsULFGc6qA4CbpRt0hN31Zphy7JhOt8kbxtkSKlinGfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7715.eurprd04.prod.outlook.com (2603:10a6:20b:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/6] net: dsa: make cross-chip notifiers more efficient for host events
Date:   Fri, 15 Apr 2022 18:46:22 +0300
Message-Id: <20220415154626.345767-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e1f7bcc-cee5-4843-4a7d-08da1ef71f62
X-MS-TrafficTypeDiagnostic: AM9PR04MB7715:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB7715B46B24D29F9A41D08D19E0EE9@AM9PR04MB7715.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cA2nCLC6Y4TDub/zfpvJhh8NwLMYdR4V/tp9a9kxgbJSU6qJP2YlW9Zj9Wg/SQ8L8YJl2vZ1NsRrL+Z0RWCxA/3ZfBagWo69w0urppa3pAyUdtjlbw3O1GjY/HQzu/xEWZNBATYkycgCmucu7rkbyJ8B51stUnJxF2h5uRaquE4S0cLz4L0PDgYq1+bxnSloe1WAg1miVwGVLTk9qY4+o971VTm2zTs1TP/ce2J/04XyiNHbwLdTeKhhKjRQPUuoe0+kqA5U8QBOsvxedsqe1b4eLRe9Zj6OKF/uCrCXyVjMrxZFGMh1bD88s8t1rZWnGS6rvmyrTF9u+txM9PJoDtgVD1URzwuHeDgeoQ38LwFjacN3Veg2MjbaOFpT4kF76PfSioTOaLbICjZz6+5q2KIIcBkRgB5lA/rxmQR0IAhGFqQyIxDIuQqPPR/Iz8nIQ2YGeI7TqXQk4wGK9dzOixstknPpPiWuBZJeJ04FxDtBBr5ALLjDnQnoLA8Tcb3vEfGfRhu2lmXi4kOCjM4iLjg1hrEV1TJp5EWJ2J1FrZTuDG9w6jhzkWhKW55DQLr3KyQFcEcc2ViefnEf5RMmfU2ckTX4yj5F0iTYrCJJ2iRKQiDGgpGZ8EwVkT1t4lbKp2bdzVzOQchyfIC595iKG/Hbvx4XaBN8gVgv8RxAt7xUq+JkfvI7tlE4Pusqt4J9lVRrCbVw+eA9MG4HUMssDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(38100700002)(54906003)(30864003)(6916009)(8936002)(38350700002)(316002)(86362001)(26005)(6486002)(2616005)(1076003)(66946007)(66556008)(66476007)(8676002)(4326008)(6512007)(6666004)(83380400001)(2906002)(186003)(52116002)(6506007)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OK9vXx7HnxOVADFpu+pm6LXMm3l66xwiCd9avZ9ef+5kJet6ecz7uiEpK2Kw?=
 =?us-ascii?Q?PRUSpbGmxGqLIcWBTyFQ3QVDgyZIdpoqEG78zKDzpe+i1FZcizPv/7JfX7Um?=
 =?us-ascii?Q?KXvx3nj94mRa50NIMj1iZWOt+zyKbUdqaD9Dd7LKJbmX85MFWNyniWSQX8lJ?=
 =?us-ascii?Q?vChYoWai71Wr8ABGq44SIfYUg/IiP5lIA5/BLEMllBRjlHQtB/yyaCzBrv88?=
 =?us-ascii?Q?E/Xm3PQMyKeWu9uZA1wkwpA+gWxNVlTAuLBtScACeW7sjnmng2wvoHAd0dg6?=
 =?us-ascii?Q?tNm/NPtmjtx00fZFFi2oVA5oBE5J3m8XwFNfD0RNjLemVW1cz7leMBS8tFZT?=
 =?us-ascii?Q?m0ylwjYAEW8epGWc7ppszTJ9IYjia/oqE3Bi7OazxANi5hVqGxCMQ6QooQgl?=
 =?us-ascii?Q?azuud4j+vAgCXqsRjsouEGu+3TFnHHbf6++RfufwMNP1wYskzGZNTIt33FvL?=
 =?us-ascii?Q?1N5cChXjRLMoqj5ro77IvOzmz9JvnTg79RssOBq0TTU7Qn41I5z4XWSGW3MV?=
 =?us-ascii?Q?1fP/+AYbfSciG54k0+xlbsEHp/aZvOHuSajpvdRuXPHjloEVnGBFnW6F323M?=
 =?us-ascii?Q?TyLQnTyLG1Ovef1Ec0fzqrRNLqOGTbLTZlC6F4TfG3AeVnZU2nEyHyaxpicx?=
 =?us-ascii?Q?Jb9o5hZUIDghfia6qyYKP9XsicFSNCu+KR/vCnLkDzeojA7XwKhxfUz1ltNT?=
 =?us-ascii?Q?vOPYJ+TI/5B+6r+V5dP58gHyooyN+9F7Re7u2BKJFe6eBeiCy7ya0PuVuw1X?=
 =?us-ascii?Q?nWvNi2MJlKMA8QFA6DGi+o2wHtUx5CfIFnWY7lCaeVFnPOl9fQZT0EkDI9pv?=
 =?us-ascii?Q?E2Gtnz5En4/bFOUe4KFBuYaukdIeWKWYSYpiz899P/eav4TcRWFdli8SykBx?=
 =?us-ascii?Q?mkbpFdi/OZQo18GIApeeMe144n0pyf2mqD+nVpUueQj3tj8kq3eW4XT3fO7y?=
 =?us-ascii?Q?HlJf5hWylf7uiU8fCOxv1GihoyCeVqHOd/N7FK2RO+RNc6EYqe4k9RjbvfwC?=
 =?us-ascii?Q?kgk8UzMh+upxnO6e8bT40juHW0lcGmcsUlnSU5K233oyih0LrpwVOCNw4fGJ?=
 =?us-ascii?Q?hBS+ZxB8sBEuJX7FtSkcMTaTaP/O/Bstyq3FDtmx1PdQdQm3pFOSsFbZ78HM?=
 =?us-ascii?Q?7OZuZnhhj+rN+0+NuLK2k3+iQb4l18x/rGw40Sk7bBU1fnxEFZ20nmeOog+K?=
 =?us-ascii?Q?TZ32Cf3f+H+H8iKmflrbzaJqKOlmitNKyB/wgMnT/hqQg3LsYqRqnPloerMH?=
 =?us-ascii?Q?ry0mdGQK0WUjyb/Q979E9PyUvoEp8ZmID1Yc/glbxKc0lsFBEJAwh4F7KaWn?=
 =?us-ascii?Q?6myF4XAW9kZf8OrgLnb6pwHAfUr7iRfYt3pC3FTQZszsGFmn4wC05SHxFKGM?=
 =?us-ascii?Q?qcPQAs2lZ/HuwRA4mFYwjgN0FwYlxcAO6CDFxJeKj4W2HHGQGJ0fMO4u62GI?=
 =?us-ascii?Q?X+pR5Aqq6VfP1bQhXDmDKuf9Oapt7NqDpA0fXF/96OuWfmCHwGSqrHPk1eV8?=
 =?us-ascii?Q?LN2WxEHGwN2NDfg/w/p8FzouMVa4L9inlGG2Ky7w3owk3JQygZZd0Rocafcm?=
 =?us-ascii?Q?ApFIf4pU+gOT6iffd0bxmABVW3vws1ThbFqF4xgV3nIgl0cKZ17rULk/z2FZ?=
 =?us-ascii?Q?IkwAxPcFYGAUNSmjzXfejWIXD93Ir3Xu7v/0u3IsVKsdBtG936YkEI38aTL8?=
 =?us-ascii?Q?B4xxmMqdhuE47Jz377A5Etn9LM3Rpu/v8aZmBHv4DPww995ObjR0B1jFwZfm?=
 =?us-ascii?Q?smK245ZB7zw1dkD4KoU7yrWFl60RV7w=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1f7bcc-cee5-4843-4a7d-08da1ef71f62
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:36.0199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Rmgumv/vJfal/lEqAKhk8KJ1AC9qDi9FAHx/0puJJJngPpamU1l7f86DoQeVccxu+WsaD5pUGXpKtZESaPrMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7715
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To determine whether a given port should react to the port targeted by
the notifier, dsa_port_host_vlan_match() and dsa_port_host_address_match()
look at the positioning of the switch port currently executing the
notifier relative to the switch port for which the notifier was emitted.

To maintain stylistic compatibility with the other match functions from
switch.c, the host address and host VLAN match functions take the
notifier information about targeted port, switch and tree indices as
argument. However, these functions only use that information to retrieve
the struct dsa_port *targeted_dp, which is an invariant for the outer
loop that calls them. So it makes more sense to calculate the targeted
dp only once, and pass it to them as argument.

But furthermore, the targeted dp is actually known at the time the call
to dsa_port_notify() is made. It is just that we decide to only save the
indices of the port, switch and tree in the notifier structure, just to
retrace our steps and find the dp again using dsa_switch_find() and
dsa_to_port().

But both the above functions are relatively expensive, since they need
to iterate through lists. It appears more straightforward to make all
notifiers just pass the targeted dp inside their info structure, and
have the code that needs the indices to look at info->dp->index instead
of info->port, or info->dp->ds->index instead of info->sw_index, or
info->dp->ds->dst->index instead of info->tree_index.

For the sake of consistency, all cross-chip notifiers are converted to
pass the "dp" directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h  |  24 +++------
 net/dsa/port.c      |  64 ++++++++----------------
 net/dsa/switch.c    | 118 ++++++++++++++++++--------------------------
 net/dsa/tag_8021q.c |  10 +---
 4 files changed, 76 insertions(+), 140 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f4a67dce1..67982291a83b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -54,18 +54,15 @@ struct dsa_notifier_ageing_time_info {
 
 /* DSA_NOTIFIER_BRIDGE_* */
 struct dsa_notifier_bridge_info {
+	const struct dsa_port *dp;
 	struct dsa_bridge bridge;
-	int tree_index;
-	int sw_index;
-	int port;
 	bool tx_fwd_offload;
 	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_FDB_* */
 struct dsa_notifier_fdb_info {
-	int sw_index;
-	int port;
+	const struct dsa_port *dp;
 	const unsigned char *addr;
 	u16 vid;
 	struct dsa_db db;
@@ -81,34 +78,29 @@ struct dsa_notifier_lag_fdb_info {
 
 /* DSA_NOTIFIER_MDB_* */
 struct dsa_notifier_mdb_info {
+	const struct dsa_port *dp;
 	const struct switchdev_obj_port_mdb *mdb;
-	int sw_index;
-	int port;
 	struct dsa_db db;
 };
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
+	const struct dsa_port *dp;
 	struct dsa_lag lag;
-	int sw_index;
-	int port;
-
 	struct netdev_lag_upper_info *info;
 };
 
 /* DSA_NOTIFIER_VLAN_* */
 struct dsa_notifier_vlan_info {
+	const struct dsa_port *dp;
 	const struct switchdev_obj_port_vlan *vlan;
-	int sw_index;
-	int port;
 	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_MTU */
 struct dsa_notifier_mtu_info {
+	const struct dsa_port *dp;
 	bool targeted_match;
-	int sw_index;
-	int port;
 	int mtu;
 };
 
@@ -119,9 +111,7 @@ struct dsa_notifier_tag_proto_info {
 
 /* DSA_NOTIFIER_TAG_8021Q_VLAN_* */
 struct dsa_notifier_tag_8021q_vlan_info {
-	int tree_index;
-	int sw_index;
-	int port;
+	const struct dsa_port *dp;
 	u16 vid;
 };
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index af9a815c2639..711de8f09993 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -459,9 +459,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_bridge_info info = {
-		.tree_index = dp->ds->dst->index,
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.extack = extack,
 	};
 	struct net_device *dev = dp->slave;
@@ -530,9 +528,7 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
-		.tree_index = dp->ds->dst->index,
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 	};
 	int err;
 
@@ -562,8 +558,7 @@ int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo)
 {
 	struct dsa_notifier_lag_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 	};
 	bool tx_enabled;
 
@@ -632,8 +627,7 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
@@ -678,8 +672,7 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 	};
 	int err;
 
@@ -941,9 +934,8 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match)
 {
 	struct dsa_notifier_mtu_info info = {
-		.sw_index = dp->ds->index,
+		.dp = dp,
 		.targeted_match = targeted_match,
-		.port = dp->index,
 		.mtu = new_mtu,
 	};
 
@@ -954,8 +946,7 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid)
 {
 	struct dsa_notifier_fdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.addr = addr,
 		.vid = vid,
 		.db = {
@@ -978,8 +969,7 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid)
 {
 	struct dsa_notifier_fdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.addr = addr,
 		.vid = vid,
 		.db = {
@@ -999,8 +989,7 @@ static int dsa_port_host_fdb_add(struct dsa_port *dp,
 				 struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.addr = addr,
 		.vid = vid,
 		.db = db,
@@ -1051,8 +1040,7 @@ static int dsa_port_host_fdb_del(struct dsa_port *dp,
 				 struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.addr = addr,
 		.vid = vid,
 		.db = db,
@@ -1147,8 +1135,7 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.mdb = mdb,
 		.db = {
 			.type = DSA_DB_BRIDGE,
@@ -1166,8 +1153,7 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.mdb = mdb,
 		.db = {
 			.type = DSA_DB_BRIDGE,
@@ -1186,8 +1172,7 @@ static int dsa_port_host_mdb_add(const struct dsa_port *dp,
 				 struct dsa_db db)
 {
 	struct dsa_notifier_mdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.mdb = mdb,
 		.db = db,
 	};
@@ -1231,8 +1216,7 @@ static int dsa_port_host_mdb_del(const struct dsa_port *dp,
 				 struct dsa_db db)
 {
 	struct dsa_notifier_mdb_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.mdb = mdb,
 		.db = db,
 	};
@@ -1276,8 +1260,7 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_vlan_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.vlan = vlan,
 		.extack = extack,
 	};
@@ -1289,8 +1272,7 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan)
 {
 	struct dsa_notifier_vlan_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.vlan = vlan,
 	};
 
@@ -1302,8 +1284,7 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 			   struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_vlan_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.vlan = vlan,
 		.extack = extack,
 	};
@@ -1323,8 +1304,7 @@ int dsa_port_host_vlan_del(struct dsa_port *dp,
 			   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct dsa_notifier_vlan_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.vlan = vlan,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
@@ -1743,9 +1723,7 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
 {
 	struct dsa_notifier_tag_8021q_vlan_info info = {
-		.tree_index = dp->ds->dst->index,
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.vid = vid,
 	};
 
@@ -1758,9 +1736,7 @@ int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast)
 {
 	struct dsa_notifier_tag_8021q_vlan_info info = {
-		.tree_index = dp->ds->dst->index,
-		.sw_index = dp->ds->index,
-		.port = dp->index,
+		.dp = dp,
 		.vid = vid,
 	};
 	int err;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d8a80cf9742c..d3df168478ba 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -49,7 +49,7 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 static bool dsa_port_mtu_match(struct dsa_port *dp,
 			       struct dsa_notifier_mtu_info *info)
 {
-	if (dp->ds->index == info->sw_index && dp->index == info->port)
+	if (dp == info->dp)
 		return true;
 
 	/* Do not propagate to other switches in the tree if the notifier was
@@ -88,25 +88,26 @@ static int dsa_switch_mtu(struct dsa_switch *ds,
 static int dsa_switch_bridge_join(struct dsa_switch *ds,
 				  struct dsa_notifier_bridge_info *info)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	int err;
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index) {
+	if (info->dp->ds == ds) {
 		if (!ds->ops->port_bridge_join)
 			return -EOPNOTSUPP;
 
-		err = ds->ops->port_bridge_join(ds, info->port, info->bridge,
+		err = ds->ops->port_bridge_join(ds, info->dp->index,
+						info->bridge,
 						&info->tx_fwd_offload,
 						info->extack);
 		if (err)
 			return err;
 	}
 
-	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_join) {
-		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
-						     info->sw_index,
-						     info->port, info->bridge,
+	if (info->dp->ds != ds && ds->ops->crosschip_bridge_join) {
+		err = ds->ops->crosschip_bridge_join(ds,
+						     info->dp->ds->dst->index,
+						     info->dp->ds->index,
+						     info->dp->index,
+						     info->bridge,
 						     info->extack);
 		if (err)
 			return err;
@@ -118,16 +119,13 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
-	struct dsa_switch_tree *dst = ds->dst;
+	if (info->dp->ds == ds && ds->ops->port_bridge_leave)
+		ds->ops->port_bridge_leave(ds, info->dp->index, info->bridge);
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
-
-	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_leave)
-		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
-						info->sw_index, info->port,
+	if (info->dp->ds != ds && ds->ops->crosschip_bridge_leave)
+		ds->ops->crosschip_bridge_leave(ds, info->dp->ds->dst->index,
+						info->dp->ds->index,
+						info->dp->index,
 						info->bridge);
 
 	return 0;
@@ -138,16 +136,11 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
  * emitted and its dedicated CPU port.
  */
 static bool dsa_port_host_address_match(struct dsa_port *dp,
-					int info_sw_index, int info_port)
+					const struct dsa_port *targeted_dp)
 {
-	struct dsa_port *targeted_dp, *cpu_dp;
-	struct dsa_switch *targeted_ds;
-
-	targeted_ds = dsa_switch_find(dp->ds->dst->index, info_sw_index);
-	targeted_dp = dsa_to_port(targeted_ds, info_port);
-	cpu_dp = targeted_dp->cpu_dp;
+	struct dsa_port *cpu_dp = targeted_dp->cpu_dp;
 
-	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
+	if (dsa_switch_is_upstream_of(dp->ds, targeted_dp->ds))
 		return dp->index == dsa_towards_port(dp->ds, cpu_dp->ds->index,
 						     cpu_dp->index);
 
@@ -415,8 +408,7 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	dsa_switch_for_each_port(dp, ds) {
-		if (dsa_port_host_address_match(dp, info->sw_index,
-						info->port)) {
+		if (dsa_port_host_address_match(dp, info->dp)) {
 			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
 						  info->db);
 			if (err)
@@ -437,8 +429,7 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	dsa_switch_for_each_port(dp, ds) {
-		if (dsa_port_host_address_match(dp, info->sw_index,
-						info->port)) {
+		if (dsa_port_host_address_match(dp, info->dp)) {
 			err = dsa_port_do_fdb_del(dp, info->addr, info->vid,
 						  info->db);
 			if (err)
@@ -452,7 +443,7 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
-	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	int port = dsa_towards_port(ds, info->dp->ds->index, info->dp->index);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_fdb_add)
@@ -464,7 +455,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
-	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	int port = dsa_towards_port(ds, info->dp->ds->index, info->dp->index);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_fdb_del)
@@ -512,12 +503,12 @@ static int dsa_switch_lag_fdb_del(struct dsa_switch *ds,
 static int dsa_switch_lag_change(struct dsa_switch *ds,
 				 struct dsa_notifier_lag_info *info)
 {
-	if (ds->index == info->sw_index && ds->ops->port_lag_change)
-		return ds->ops->port_lag_change(ds, info->port);
+	if (info->dp->ds == ds && ds->ops->port_lag_change)
+		return ds->ops->port_lag_change(ds, info->dp->index);
 
-	if (ds->index != info->sw_index && ds->ops->crosschip_lag_change)
-		return ds->ops->crosschip_lag_change(ds, info->sw_index,
-						     info->port);
+	if (info->dp->ds != ds && ds->ops->crosschip_lag_change)
+		return ds->ops->crosschip_lag_change(ds, info->dp->ds->index,
+						     info->dp->index);
 
 	return 0;
 }
@@ -525,13 +516,13 @@ static int dsa_switch_lag_change(struct dsa_switch *ds,
 static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
-	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag,
+	if (info->dp->ds == ds && ds->ops->port_lag_join)
+		return ds->ops->port_lag_join(ds, info->dp->index, info->lag,
 					      info->info);
 
-	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
-		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag,
+	if (info->dp->ds != ds && ds->ops->crosschip_lag_join)
+		return ds->ops->crosschip_lag_join(ds, info->dp->ds->index,
+						   info->dp->index, info->lag,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -540,12 +531,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
-	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag);
+	if (info->dp->ds == ds && ds->ops->port_lag_leave)
+		return ds->ops->port_lag_leave(ds, info->dp->index, info->lag);
 
-	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
-		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag);
+	if (info->dp->ds != ds && ds->ops->crosschip_lag_leave)
+		return ds->ops->crosschip_lag_leave(ds, info->dp->ds->index,
+						    info->dp->index, info->lag);
 
 	return -EOPNOTSUPP;
 }
@@ -553,7 +544,7 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
-	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	int port = dsa_towards_port(ds, info->dp->ds->index, info->dp->index);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_mdb_add)
@@ -565,7 +556,7 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
-	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	int port = dsa_towards_port(ds, info->dp->ds->index, info->dp->index);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_mdb_del)
@@ -584,8 +575,7 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	dsa_switch_for_each_port(dp, ds) {
-		if (dsa_port_host_address_match(dp, info->sw_index,
-						info->port)) {
+		if (dsa_port_host_address_match(dp, info->dp)) {
 			err = dsa_port_do_mdb_add(dp, info->mdb, info->db);
 			if (err)
 				break;
@@ -605,8 +595,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	dsa_switch_for_each_port(dp, ds) {
-		if (dsa_port_host_address_match(dp, info->sw_index,
-						info->port)) {
+		if (dsa_port_host_address_match(dp, info->dp)) {
 			err = dsa_port_do_mdb_del(dp, info->mdb, info->db);
 			if (err)
 				break;
@@ -620,29 +609,18 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 static bool dsa_port_vlan_match(struct dsa_port *dp,
 				struct dsa_notifier_vlan_info *info)
 {
-	if (dp->ds->index == info->sw_index && dp->index == info->port)
-		return true;
-
-	if (dsa_port_is_dsa(dp))
-		return true;
-
-	return false;
+	return dsa_port_is_dsa(dp) || dp == info->dp;
 }
 
 /* Host VLANs match on the targeted port's CPU port, and on all DSA ports
  * (upstream and downstream) of that switch and its upstream switches.
  */
 static bool dsa_port_host_vlan_match(struct dsa_port *dp,
-				     struct dsa_notifier_vlan_info *info)
+				     const struct dsa_port *targeted_dp)
 {
-	struct dsa_port *targeted_dp, *cpu_dp;
-	struct dsa_switch *targeted_ds;
-
-	targeted_ds = dsa_switch_find(dp->ds->dst->index, info->sw_index);
-	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	cpu_dp = targeted_dp->cpu_dp;
+	struct dsa_port *cpu_dp = targeted_dp->cpu_dp;
 
-	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
+	if (dsa_switch_is_upstream_of(dp->ds, targeted_dp->ds))
 		return dsa_port_is_dsa(dp) || dp == cpu_dp;
 
 	return false;
@@ -800,7 +778,7 @@ static int dsa_switch_host_vlan_add(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	dsa_switch_for_each_port(dp, ds) {
-		if (dsa_port_host_vlan_match(dp, info)) {
+		if (dsa_port_host_vlan_match(dp, info->dp)) {
 			err = dsa_port_do_vlan_add(dp, info->vlan,
 						   info->extack);
 			if (err)
@@ -821,7 +799,7 @@ static int dsa_switch_host_vlan_del(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	dsa_switch_for_each_port(dp, ds) {
-		if (dsa_port_host_vlan_match(dp, info)) {
+		if (dsa_port_host_vlan_match(dp, info->dp)) {
 			err = dsa_port_do_vlan_del(dp, info->vlan);
 			if (err)
 				return err;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index a786569203f0..01a427800797 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -196,15 +196,7 @@ static bool
 dsa_port_tag_8021q_vlan_match(struct dsa_port *dp,
 			      struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	struct dsa_switch *ds = dp->ds;
-
-	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
-		return true;
-
-	if (ds->dst->index == info->tree_index && ds->index == info->sw_index)
-		return dp->index == info->port;
-
-	return false;
+	return dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp) || dp == info->dp;
 }
 
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
-- 
2.25.1

