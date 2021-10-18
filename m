Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7724F4322B6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhJRPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:12 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:18150
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231955AbhJRPYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Za26wbQoWFmJCwckF5lrXpTJ8DQBRbyGy5oHqRHogSS8ZdFXeDSw00wOqV34qJyWJEDotxKjy5wlgYCZIPZ56eSoZCb6OYWEIqNF5ftWUXUDKvSsx0zJFBmBl0Tss5cfpwA4E49c6JV9qamaW8tY5KyZ/MZOduGDvhwKQv73lplQx/CMTFzbthlcmZ8ZLV1seIwrqe92hiy7Tg3WWTRE2a/0D9pmRad286cGojeyqMV9XkiwkI2VGFLm4xKRUw10B8vDZx6RTLjS6sJuMryIvopWFzWcQIPRQSy3sCMwwEb5SgmIOppOGgATPBIDLbj4EXuxFRzxk4FX885VO8A1Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPiu5y4F7qklay9cjbfsoYOqNq7yr1l19FhxAzCAPAM=;
 b=R6GGU6eryZE3sSBDRLkYILeAEv39mB9RM9VCDihAZfLRHGSjW/fqooskDwQ3h/lr8YLegoTpAN993TbwvrnSPlxtIqZB+ZZy6etI6Mzt4zR9/iFH36ND2SLTQAFRVXSvdH9e5WNptQw8KagUnIPgAgz5R9ZevbGyF8ldgTk7mXdY2/U3rLcDw1hChRrUuQN4ix1G0UGj4LwfahxutCRxPQ14tKqA4Wa+O2PHb3OzzHMh4rj/qiV7xaLCkSOQ0XbDDhqvVShItmheAEEOpShG3ntUabG79L9L/5vWKxpOZO9BjvV/68gDakgBWBYaarFNWmYCga9BrgsL3TWUw1EoJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPiu5y4F7qklay9cjbfsoYOqNq7yr1l19FhxAzCAPAM=;
 b=SWtPH3434AFT0ioXJ+O8FVhdgKqcwelf1MnIGUuuaTzuK2fIoCREzWt2jySWLISNJHgTX6AA+0933uUU0/KpVc8s5uTlfcBWHYT82u1xJK5ZUj1K5X6G7GSxBKqqeDlgqxToXlSZq0n3yzW7TXjBEjGoHy/THi877CTRzGsvsrk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 15:21:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 2/7] net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
Date:   Mon, 18 Oct 2021 18:21:31 +0300
Message-Id: <20211018152136.2595220-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f411d9-3383-435c-8256-08d9924b04e0
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26880E7B5F1BA9C5F5116CC5E0BC9@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: du/5X8yG37C0qE7u+jVWRXP6PLln6EbkV8KNZBEmBeo+S3S7DxJ7yi1uCsJ+9nkUQsxejFxTkDPWl/DaUJhxmPHBovb9W1cDjYvLJ7KqJ3XCR0G0d68/X1EwR9x0Vh3trfo7DfwZBJTp+u+uUHV9UMq/ZeCorDjFRM9kF4I7iljBpDMGQh1gRIkyvmW9MIrVc+URjL6+7sEJ21/9BA1FwWDqdKABsWCDYflGTfqaUbFKPh85TPOFlnSG3wvRcTYn+B+g9EDYR3v407fSZ7kpr1Sj1NNAK6qV1ATXGbBCuMuRLLDWrL+gS9GQSRQRIl+40gGZYjJ09P2/c9hrvT6lJSSYYDJJ42fOIUsNGYked+AxdK1RlRCzrBje76efFebNRgnz0Z/GylGIukFFds9B9Cp8Os7x7YRKC9PgWxxgdPCI8c8J/sLlyuVyYy+dW08DpwkaONKyEXYRw0mlvm5c7jzj6oeEnJDLtn85UGsL8LSza75cPp8br2raoY3J0iIc0K2doUoCcHO+HjbuClnMRjHTwvKkOJacJHZyop7plq8b6WcQPwT783y8usqhzwUA6cNEZJzOePfddgJ/3H5vBl+mpls2kGsdUrGPijajaBGCT8EZ8IjfT6QA6KVLaeyTSfref4LRpNe6UyfRbFLYE1DCMn1DvkeDMsfALN2xhbtkPbNLpP9idr2Ai1W54hj/VYEaFxKkgmBRPkuXaz0oFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(110136005)(956004)(2616005)(316002)(83380400001)(1076003)(54906003)(66476007)(8676002)(66946007)(66556008)(6512007)(508600001)(6506007)(6666004)(36756003)(2906002)(44832011)(6486002)(86362001)(38100700002)(52116002)(38350700002)(186003)(26005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SJ5bT8+kXXm8FuTJcusIexmv7OIrJyLGrcRLxxDl6Iix9YJR0T+/dfDk28Vn?=
 =?us-ascii?Q?ShO+/9T+VQ7iMg8RDRqaSJ6PPk7VzMgS+0u6QDcI0ImWBlA40/u4o+NAp0i1?=
 =?us-ascii?Q?I6Ob0KfxOOOeiVLRMOQcaQIH+HBGcUgaXcgzKVoqyU7CVw5oUTknTLcKt9LV?=
 =?us-ascii?Q?3EWBN4geT8jllyuDvX2cATQcBZcT97+VP/ihVM6vE7Q9cHJcM5JnI6e9kR1I?=
 =?us-ascii?Q?LdRrKUXs+1MKVg3UfRizBY9tNV19bWpEw2NbLGkt9IpxqnlBvpcTyqM7zFju?=
 =?us-ascii?Q?iKbVjrh1+lp5Qcgci8cK4iEFLqpcF1VxCqbMVxxtw44rcZyq6fXSQghH0/UE?=
 =?us-ascii?Q?kJ5P4o731G34Tu54XTeYliFe5pHtWdAtVPMYT7EmABr3O9dneoS8OwNBPEYm?=
 =?us-ascii?Q?nS13wAHDAsioWS0RCYCZRpiEikbHSYWeOD6ercEtAtPP3O67T+TzfPR3zE7r?=
 =?us-ascii?Q?MkbiF3GOQ05ga4LaLCe6G3udMJpUkKNjrlS4Ohqv+U6ETKx828wuT/iSF9/+?=
 =?us-ascii?Q?uakAAJAJyELvIZK+JSWBCFhMozO5pv2XDpT/l2ZFxQUSFJxOsg5s1e4d1QiO?=
 =?us-ascii?Q?SdV5LkjQseZYS24VQAd9oEX9NpE7CRUNKwKGL1dX0/MXRYWW3O3xTfyOYlp9?=
 =?us-ascii?Q?Z0TfUlsSeL6v/dDRr7XmLCXyec37AvEtb8dg/MQG0JhGGWpj1f8ndAkEKgQE?=
 =?us-ascii?Q?VNOpCGHARAuRUGmxxMhUxwE9Rw3Qc2YsokoDF9cqz/VGXJHtGHFbfJIH1vX3?=
 =?us-ascii?Q?939LJbbSbjmp59jPuy3OOas8G98pZ6SKyF+U781R85GNzCHCZK7hmwetw5Av?=
 =?us-ascii?Q?EkT9RpuM/3fmL3Til84Mz+3nLLuCZy7U/HnfilS150QAQBf8oSg5eiuGOzB5?=
 =?us-ascii?Q?6tjs1E2LftFuqo8pBd/J6UAirBF05Jsit1hRV+H0C+QcZJMov46gRFT+M1Ps?=
 =?us-ascii?Q?K+HrKb5lxCWKfIWn4LRPORpCxKFy0gRk9s+rnad+Yhsn+mlle0CZZFNBGyxo?=
 =?us-ascii?Q?n6eRg50KSak27HdYo70WrE2RFLwawqjDgOv6TsTUxIGrKTvwppm7iZ/k6WI4?=
 =?us-ascii?Q?dGbd7eMGIJVHxM/vk7rE/plJMQ7XyI/wfjmjqkIK/qHmIZHFcJaoHi2JKMWu?=
 =?us-ascii?Q?nvZhIQkonmmf9TRE7eAHWfW2qTX0UlaDb9VOlDgLMXtToZ5kCL08vS4Yda/D?=
 =?us-ascii?Q?froAmacTBGWss7lD94foX7sQ68JVy8JIVMsfaABqX+wq+ePX9Dw0Fn9nZRM4?=
 =?us-ascii?Q?LrR8OF0ctVLGbufbV8YHbTWOmJPI8Cc430y87SEfnJHSmBAVhlVuBLuSVbop?=
 =?us-ascii?Q?Yf+Q8Raw88APtwQD7Y/UBwqU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f411d9-3383-435c-8256-08d9924b04e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:55.3009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6sSbtiEacSHYQ06036S9UCa0D8PQg0qOPDnAQDKkdjZPJr3vAHkkdihrm+mEpdF+SobtOXyTdZk2K0tHgu4TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ever since Vivien's conversion of the ds->ports array into a dst->ports
list, and the introduction of dsa_to_port, iterations through the ports
of a switch became quadratic whenever dsa_to_port was needed.

dsa_to_port can either be called directly, or indirectly through the
dsa_is_{user,cpu,dsa,unused}_port helpers.

Use the newly introduced dsa_switch_for_each_port() iteration macro
that works with the iterator variable being a struct dsa_port *dp
directly, and not an int i. It is an expensive variable to go from i to
dp, but cheap to go from dp to i.

This macro iterates through the entire ds->dst->ports list and filters
by the ports belonging just to the switch provided as argument.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  7 +++----
 net/dsa/dsa.c     | 22 +++++++++++-----------
 net/dsa/dsa2.c    | 13 ++++++-------
 net/dsa/port.c    | 17 +++++++----------
 net/dsa/slave.c   |  2 +-
 net/dsa/switch.c  | 40 +++++++++++++++++-----------------------
 6 files changed, 45 insertions(+), 56 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 440b6aca22c7..1cd9c2461f0d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -504,12 +504,11 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 
 static inline u32 dsa_user_ports(struct dsa_switch *ds)
 {
+	struct dsa_port *dp;
 	u32 mask = 0;
-	int p;
 
-	for (p = 0; p < ds->num_ports; p++)
-		if (dsa_is_user_port(ds, p))
-			mask |= BIT(p);
+	dsa_switch_for_each_user_port(dp, ds)
+		mask |= BIT(dp->index);
 
 	return mask;
 }
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 41f36ad8b0ec..ea5169e671ae 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -280,23 +280,22 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 }
 
 #ifdef CONFIG_PM_SLEEP
-static bool dsa_is_port_initialized(struct dsa_switch *ds, int p)
+static bool dsa_port_is_initialized(const struct dsa_port *dp)
 {
-	const struct dsa_port *dp = dsa_to_port(ds, p);
-
 	return dp->type == DSA_PORT_TYPE_USER && dp->slave;
 }
 
 int dsa_switch_suspend(struct dsa_switch *ds)
 {
-	int i, ret = 0;
+	struct dsa_port *dp;
+	int ret = 0;
 
 	/* Suspend slave network devices */
-	for (i = 0; i < ds->num_ports; i++) {
-		if (!dsa_is_port_initialized(ds, i))
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dsa_port_is_initialized(dp))
 			continue;
 
-		ret = dsa_slave_suspend(dsa_to_port(ds, i)->slave);
+		ret = dsa_slave_suspend(dp->slave);
 		if (ret)
 			return ret;
 	}
@@ -310,7 +309,8 @@ EXPORT_SYMBOL_GPL(dsa_switch_suspend);
 
 int dsa_switch_resume(struct dsa_switch *ds)
 {
-	int i, ret = 0;
+	struct dsa_port *dp;
+	int ret = 0;
 
 	if (ds->ops->resume)
 		ret = ds->ops->resume(ds);
@@ -319,11 +319,11 @@ int dsa_switch_resume(struct dsa_switch *ds)
 		return ret;
 
 	/* Resume slave network devices */
-	for (i = 0; i < ds->num_ports; i++) {
-		if (!dsa_is_port_initialized(ds, i))
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dsa_port_is_initialized(dp))
 			continue;
 
-		ret = dsa_slave_resume(dsa_to_port(ds, i)->slave);
+		ret = dsa_slave_resume(dp->slave);
 		if (ret)
 			return ret;
 	}
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 691d27498b24..1c09182b3644 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -802,17 +802,16 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 {
 	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
 	struct dsa_switch_tree *dst = ds->dst;
-	int port, err;
+	struct dsa_port *cpu_dp;
+	int err;
 
 	if (tag_ops->proto == dst->default_proto)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
 		rtnl_lock();
-		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
+						   tag_ops->proto);
 		rtnl_unlock();
 		if (err) {
 			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
@@ -1150,7 +1149,7 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 		goto out_unlock;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_is_user_port(dp->ds, dp->index))
+		if (!dsa_port_is_user(dp))
 			continue;
 
 		if (dp->slave->flags & IFF_UP)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 616330a16d31..3b14c9b6a922 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -515,7 +515,8 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 					      struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	int err, i;
+	struct dsa_port *other_dp;
+	int err;
 
 	/* VLAN awareness was off, so the question is "can we turn it on".
 	 * We may have had 8021q uppers, those need to go. Make sure we don't
@@ -557,10 +558,10 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * different ports of the same switch device and one of them has a
 	 * different setting than what is being requested.
 	 */
-	for (i = 0; i < ds->num_ports; i++) {
+	dsa_switch_for_each_port(other_dp, ds) {
 		struct net_device *other_bridge;
 
-		other_bridge = dsa_to_port(ds, i)->bridge_dev;
+		other_bridge = other_dp->bridge_dev;
 		if (!other_bridge)
 			continue;
 		/* If it's the same bridge, it also has same
@@ -607,20 +608,16 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 		return err;
 
 	if (ds->vlan_filtering_is_global) {
-		int port;
+		struct dsa_port *other_dp;
 
 		ds->vlan_filtering = vlan_filtering;
 
-		for (port = 0; port < ds->num_ports; port++) {
-			struct net_device *slave;
-
-			if (!dsa_is_user_port(ds, port))
-				continue;
+		dsa_switch_for_each_user_port(other_dp, ds) {
+			struct net_device *slave = dp->slave;
 
 			/* We might be called in the unbind path, so not
 			 * all slave devices might still be registered.
 			 */
-			slave = dsa_to_port(ds, port)->slave;
 			if (!slave)
 				continue;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 499f8d18c76d..9d9fef668eba 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2368,7 +2368,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		dst = cpu_dp->ds->dst;
 
 		list_for_each_entry(dp, &dst->ports, list) {
-			if (!dsa_is_user_port(dp->ds, dp->index))
+			if (!dsa_port_is_user(dp))
 				continue;
 
 			list_add(&dp->slave->close_list, &close_list);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 6466d0539af9..19651674c8c7 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -17,14 +17,11 @@
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
 {
-	int i;
-
-	for (i = 0; i < ds->num_ports; ++i) {
-		struct dsa_port *dp = dsa_to_port(ds, i);
+	struct dsa_port *dp;
 
+	dsa_switch_for_each_port(dp, ds)
 		if (dp->ageing_time && dp->ageing_time < ageing_time)
 			ageing_time = dp->ageing_time;
-	}
 
 	return ageing_time;
 }
@@ -120,7 +117,8 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	struct netlink_ext_ack extack = {0};
 	bool change_vlan_filtering = false;
 	bool vlan_filtering;
-	int err, port;
+	struct dsa_port *dp;
+	int err;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
@@ -150,10 +148,10 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 * VLAN-aware bridge.
 	 */
 	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
-		for (port = 0; port < ds->num_ports; port++) {
+		dsa_switch_for_each_port(dp, ds) {
 			struct net_device *bridge_dev;
 
-			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
+			bridge_dev = dp->bridge_dev;
 
 			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
 				change_vlan_filtering = false;
@@ -579,38 +577,34 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 				       struct dsa_notifier_tag_proto_info *info)
 {
 	const struct dsa_device_ops *tag_ops = info->tag_ops;
-	int port, err;
+	struct dsa_port *dp, *cpu_dp;
+	int err;
 
 	if (!ds->ops->change_tag_protocol)
 		return -EOPNOTSUPP;
 
 	ASSERT_RTNL();
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
-
-		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
+						   tag_ops->proto);
 		if (err)
 			return err;
 
-		dsa_port_set_tag_protocol(dsa_to_port(ds, port), tag_ops);
+		dsa_port_set_tag_protocol(cpu_dp, tag_ops);
 	}
 
 	/* Now that changing the tag protocol can no longer fail, let's update
 	 * the remaining bits which are "duplicated for faster access", and the
 	 * bits that depend on the tagger, such as the MTU.
 	 */
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_user_port(ds, port)) {
-			struct net_device *slave;
+	dsa_switch_for_each_user_port(dp, ds) {
+		struct net_device *slave = dp->slave;
 
-			slave = dsa_to_port(ds, port)->slave;
-			dsa_slave_setup_tagger(slave);
+		dsa_slave_setup_tagger(slave);
 
-			/* rtnl_mutex is held in dsa_tree_change_tag_proto */
-			dsa_slave_change_mtu(slave, slave->mtu);
-		}
+		/* rtnl_mutex is held in dsa_tree_change_tag_proto */
+		dsa_slave_change_mtu(slave, slave->mtu);
 	}
 
 	return 0;
-- 
2.25.1

