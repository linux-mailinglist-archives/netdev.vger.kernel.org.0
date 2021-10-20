Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2704351FC
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhJTRwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:35 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:48103
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230365AbhJTRwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNbBkhMN0MOb07Xh2P44wIPM3N6OCu5Qvs5jL7V/SDXPf2UNYqP/JfNJtdLvOzixepm5xw+AGkaTwOOyxrgyFuy1RIqViTrcF7a2PKXes/vU1f8VqiJA/koHD0elTZGrkEVdnfLWtEf0llIUMPQ5qQytWah23KA/zV5cjpk2yBbhpNKXZgPzPpumgv/HO96IowhYazUQ2Xly4QvSHbo9Eeq03EOpk6oxAIgPy25SXMGsY0hcSoOyUh0tdDWBeYqXwVchDX54FzRWy268/thfLmkuHsWAKpQpjTF0oF9vakkiu6ytOctLEGRTeu93rYj3xJDT+zuQ2eikDCVcIYckaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPiu5y4F7qklay9cjbfsoYOqNq7yr1l19FhxAzCAPAM=;
 b=EB5MJEsAvvde1krFdSPL2qlGl3FNC8PCxTRbZwoJMfpAb5PPtfmnQajQXpIIKgMbxxsD7Gv3R7bbeOWSSgzQ5Xlh9140Zad3YTNr/5AKqktvyeiw6Ir8ze7oA8cHixYP+FqarFeGXiYMKlIfR8GmGP7zsF7Jj8A9L9mcpvrkQDwcdGQ6Z4ltBC3zO2gDrDbNGIP9fDancimZYU5kIf3FTIhICQr9rQzmNV8xwfm13s+xgTm1S4bdnvuCqoT1uaD+rASa1kLAGXcRwngTFugW11BKejtNaHBM2lRkjIwAZcyQ/uVfQOuFW1O0u46Bk5yf75h0nOMGCV11I1Ek+Gamag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPiu5y4F7qklay9cjbfsoYOqNq7yr1l19FhxAzCAPAM=;
 b=DHTppI9mPb1n6dbOCgVpbeEl5GryIyTEhomCAs5fbjKb6c7gt7c5K1/BkNze/PbecREh6BZGrG+IS24j3a+QteiBB7ezI2FjRIBjRGr6QUHKSbBg4+4Z69tnWVandgYFnP9A5DQdPzt04Cd+Q7Al5M9SPPyul0GQTo/yPY8RiQc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:50:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 2/7] net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
Date:   Wed, 20 Oct 2021 20:49:50 +0300
Message-Id: <20211020174955.1102089-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 965f23c6-532c-4183-0a2b-08d993f211d8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28612C7EFF813715A6F7132EE0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8SAT/Ca9oVIWebc1erB1yCVwUq5v6gOQUmoC7IwoRPzxLwhlqGbwW2fnwQL42oiLPQkwHDJZ2dbUf0TK41m61aXlYBgITO1zc3WTWiem5k5Ac1kBngwL9Dn/vzB8CmJasoyYRUEjskH5HO0MNfH8HxxZwrPdiGZKpSVN/PJZ5zaNuaTur7fGkiwei8EQaka5tjlT+vSF3iCdagEH6ZZuJ/nkS0CtRP0qqBRLfRej6RsWyzH7qJUPDUuylR4GATK4MjwIddaBSVb4DtL56RL/M0jIWMIufG1YYVcoAMWILE4B2qSdWEALOyuPMPllbitbRJJTMu5L8nWeltEqu+H1vaHYwztuPnsDPzEIKbcV21CZRF4HbyZA6SgghaTpuE1e132TTtkhfkf+hDMIRl4OH34zV7jdOaNdflBFq2SHw1mTTySgq02D3U7voXePUnk6rznf5QTdQjiNhaR2NnzWOBtnFVEOOT1nk+83yNNgqk54/KiRvvjI2c33Dpz6Ed2rvV78jdiMKPhBoLOi48OQuabyWIFahpmIu58CGpVshFG4WYsuaaSlkngdWAnlWms2BFfWv4sPx+SlBkjWQdOpKncrZqXe0AoPoCyxESryJ7s+t4C/xMFn7puExtXUgynWuNXcYb6KKfmNa4L0sUaakcqdHC5HvvTGkOeiPokSEKzuKU4U8w/u6dcdVdBJvdIxMsrYldqGVe2mryxs5Ul3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G8wIa2URV5DVRD84XoUtCpm2e/DPn7hI5WU8/DbAl4qekJrbFFDQzPXqTiy0?=
 =?us-ascii?Q?Xzch/vFsNSbMnHgszd8yE06lbOBR37JsQEBhhDbAGQgv9tPUHuIgqQ4LKHaI?=
 =?us-ascii?Q?fdMxSVZnKGqWe6JGj+RnjaL3o+UHDUQfB8OtIwRiGPQfXG5ehmors+JrVamr?=
 =?us-ascii?Q?1cLsQMTsvwcTFDmZPNHlEXkNtnfNVaxN6A9UYfKJpwuoG6rMYKX3wFdRgQQB?=
 =?us-ascii?Q?uvlfETgtodLl77FZxOvJS/mRkBTXamB9Ew+qEI1PIRzR7V5ZXi71pzf0Ffhr?=
 =?us-ascii?Q?WeeWRdV5knco+MIGatJBaHzMqOlp3xa2G3tGuPEqCwogoCmmNPAUuYIvmG7B?=
 =?us-ascii?Q?G+vBr1lgei3hbpeHkXD3Y+qVT2FhIWmanGh8EHwNhzL2SPoZVGTKUdmHCHbm?=
 =?us-ascii?Q?0N1w9rXRJwGKs+Cz+QC2YqOzDgWEGex8luU+SEimO3JGeuHVC33EWwy3nlt1?=
 =?us-ascii?Q?FYBwHzjyARjbD3J5G9lpZYhL84VAWpaVC8uzLbIN8Aucmhi+JFTi0kDHJ7WD?=
 =?us-ascii?Q?i144Vr/mYfv7Tv6qcIliJ4K2+IrYDqjUJLHezqHnyHbOowqpY3NSQ6D1UYeQ?=
 =?us-ascii?Q?rtszY5fbb03kB5V0vTAwBLd0zSZIrpnPlcELYV3XlpKeQ5DtilNvulztxYjc?=
 =?us-ascii?Q?yEiLp4WlnYU8rHmhaPLOZJbmeIV1r+vUhi9yfyt4eNJGWn/pHrBLt7SEwYDX?=
 =?us-ascii?Q?adGBz0kQWdmsZTbdj3mZrEL+EE1/q+zDwHmH3EIptzotCKMojDu7T5MIji/y?=
 =?us-ascii?Q?Sz2Yv7yPFWHaFab+Cv8f1JMb95+gula3k9sGlUNmA7/KHVrFBE12z9paoDTr?=
 =?us-ascii?Q?Kl5xF8yZtNv6ZUNRG7nSYNUaMs3chHQZWy6ub1AXKeORQeYKz8W2YxFh88xI?=
 =?us-ascii?Q?QeRi7JfgLulVTGwb4hYmUoLErbUYOEq1NR+3UKQ2Xk+qKF5msTiB4cdyfgbm?=
 =?us-ascii?Q?r+ze68uArNnI5DhFlQAoW9Jd0vXNeBmKmKPz2sb62WaOKh3T16dV0mv+Ez47?=
 =?us-ascii?Q?690tsdkhSe4I57zfsUSMggY9at9geuUdsHPbFbwbmPKaQmybLYiRQP8K2ftg?=
 =?us-ascii?Q?eizJfypZF6vyNCg1ebTiv0/hWHmkkTZlOYtRKt5zTxu1o/XgW11oCfG6eL6y?=
 =?us-ascii?Q?eWAgO//H8j3SsQIo6xNDRInBxFaUgkzehBcMJPJrr852czdwiDYiw1B3PKQp?=
 =?us-ascii?Q?vVM5LaKjGpbZV6osZuDx4PJw+ocJBk0Vn1Marqgm8tgjR1IOPQFTigw/bDnB?=
 =?us-ascii?Q?KomE+R42BRGpG7yoCOqAu0pxc8fiEYHTbd+f3UuCLPduWrlSCXYh58fDKtq9?=
 =?us-ascii?Q?1UWXFh70+KHqQy5+cnMRY18Z?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965f23c6-532c-4183-0a2b-08d993f211d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:14.2114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHjII60vf9d4pIb3uE91xiIfhcuSCnmDhzoxiCvM3J8yQPE4kZOTXC6cnAC485h2Rd1Vh2T/lJ3aaqWuwCGGFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
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

