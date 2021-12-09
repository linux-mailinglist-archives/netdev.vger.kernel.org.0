Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB2246F77F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhLIXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:49 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhLIXis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOZmBCCvOzdhLnvyayMNUn6Y4vqtbFuFqImtlt47K3HBxaENmfFunOkqMBdFXbWmSyLElwNkl/BfzVs3iJiEQgFCyqlsYQO5BgTAOjs7CdAJ3VbNahWunmfbkeiDKcu2kwYfj4usieRlFwbqHw68TFQMgY03zimc9eiHAMaBLVwl1/twC3pS/cLJo+jfWqrX8Gv7EKeExsixzoMjzaXBJTgxQ8PK8Ssr6faMmE/wOAb4yRenTB+k6wcC+fom+mruSozauxScEfrsfGjBhp/gajyBdV0OXA/yg4QyLftvIylDN7VSmzH0vGVhNazj3hCzRyUO2FmcbTb/31m2SUCm9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHHkj4FMHZMkt0GPnW/jAgLzKYGtmBiRCkpMPum5vCY=;
 b=lVPudBxOo6ZU/5ga1U30gHuYmGQXOSOwR2u8wniYM8RXkAIYUrGkre2i+KhHoOdU6IvT0eo0jQGbiVg1DDC/JNM5klGKIYR5rZ6SElExfGyqFEf8q2/LqC1oEZoOWf40gaVNzbohsMSiFsUhVAfmrp7fL1Bu9HiTeLNkca1SBRBagBsZu6NAaPkZrI/PBLKTwEXrvKcpOeOnLnQ9MHAi6V5bo+WfJ83qYCiAO+eL+kPSMeRnnZnPNEiA2U9GDtj38UHA/GJlca89ghRLGSzp4GMo0NIf9+uIw8f3kqweyXg5cAJz7B08ErR9oL9Vy19/xHO4hIekVMs2LmojM/+7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHHkj4FMHZMkt0GPnW/jAgLzKYGtmBiRCkpMPum5vCY=;
 b=We8kTnjNoVkqDzW9rwayr63UoLfst7iq9LjB5fn5TyXJzdvpkl8iaxMEmCehwlareHcF1kt1uMTrXiw4bJV3LA1K1yuSO60m91k8aiblfvJtOxYcpgpym1pzFPV8A2hsuyX2UiHjxbcFMtqqgQrTTHeQhpZepvDhgwH/6DN5OR0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 01/11] net: dsa: introduce tagger-owned storage for private and shared data
Date:   Fri, 10 Dec 2021 01:34:37 +0200
Message-Id: <20211209233447.336331-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48f6c2d6-c074-4bee-fa48-08d9bb6c899e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34088EE0E5A0979352F211D3E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PDzFCd2hZleuThFTRjepbA1QfH41o0WrUitccQA7gB20x5FChm95oBMzDUducZCXIeombGTvqDYC7D7PhN6ZJSeLTwiBVqvRnh2IUdqsMzZxiyf6IAs4AubLAROmjrBWFKopGk46qx3D2Zgbz15IZgvFwael8BnbL3xQtX09CGyTwumHJBiIWl63CZKPcTg4Es6EHKqbMtCxUnCoCO0SWVWG8BHUAaZd2B97kLInmbhAtkNOSg9t/Yf5jTWQqtKZOO1Bn2dtVgfR1KKkqH5Ts22a0nDXRcAgruDjA0HINn37V4gAriJyvQDZRHC5MQr908p3KC465bGduBZd+8Vb5f6mUlIhti8SsSsfiDG+FB1+SyR09Fa6yFCsOOOqeVSnhkaWfEE6FRYDhK6sv74FAmYkViX07VHBZ/QdwyKegCkjjAKD+jo9U5XCYJbBpvwvzOs68qF7yE0M31GODbUG9FqYaoKnk2iEnl4CPDFTWVNe0xcu2ifpJ6BT+HDGRZDgD0TVg+jmPX9dqcP8t3EvOjh6VaGDg6434D/yZIAC93reJu/uhj6vHsF4ugrFUgWp+3Hhgsg6dgn1D8/ZzUl46SZ2I5T7SmMIHgU788qmzI2KBCXXSEcgSNMBeeg10n+uGgatPTW3CNxR79ei2poyFLEydcCJc1a2QcDpN/K1svtUnJ7eixpTX4RVZqDGQkhq8241bHkfZwsxwc8PNVdWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4TkpD4rXWTPJivTFCHo3I1MzXnDOWZQSDPz1WxyhSd+O6zlf4qtrI91HhQtB?=
 =?us-ascii?Q?VT9Xgq/BEKt0sMFLjDtu5n2rz/xxz0tyRN/CkCXVZ9CqekU48isSPdsdYWga?=
 =?us-ascii?Q?G9dBFfWz4Y9RERXWomhX+GQFQRBdoTCyKtmJU/wFA+KWNTEcDS5EMdujL7sK?=
 =?us-ascii?Q?w28oFaZRrYxuoxMts++nHmnypWpIE6ZQ7RLb9slZ4G11vUKXQ20LHcxPuDWG?=
 =?us-ascii?Q?LmmG6xP37lJS7eN2d1PTJLoWlQFS+RdkO//Kpz6H/e2GhpeGbbieS72axIvm?=
 =?us-ascii?Q?MVZHh0lXo8141ueasn0G/b5O7jwNcoo4izQK6xNPlC6WFpnFDA1m2BwJ35vP?=
 =?us-ascii?Q?Ih+z5wVXzJzuXY3OBVEW7xTAlswiqLPWoDk+OlSvHMK+xnzpDtaLo4Ce6yEE?=
 =?us-ascii?Q?i9bsthekqCJYOC59iQ/tIBr4Hf92Kn21op9e1+iV+XP5pSqIayWI+3DwcQR9?=
 =?us-ascii?Q?ye1pXSnRRdcdfbmCirWKGAbplVQcvNfH72rgoMkpPdlN56375+2vILD7tigp?=
 =?us-ascii?Q?Cd4ZhnG6jJIWmQnZ7CjO6Zr8AFouRZFs5g5aje+RH3hHjEvKNw0lJtZj7Q0b?=
 =?us-ascii?Q?WrF4QtE00gElSf4SEPwehRF4dEJ9bvzuNLAlXzzNVhS+AJzAmka0qQhVrR2p?=
 =?us-ascii?Q?aX5lZsMNmFLnhWjLV4ZAansrZkrJutwXajSeNDM7rXjVyAwnoG0tZxuYayqq?=
 =?us-ascii?Q?2NDYU1iqFOZXxiCd/dbBRpSd0Xfg1oTKVV2G6oLzz3DL79rXL0fMFQmQUeCi?=
 =?us-ascii?Q?E/u1imfX9K5FsjM8Wq6r1Z3Rm8ReYoaje6nZhA4IhNEDHW1s3euu1HSslOkm?=
 =?us-ascii?Q?XDn0C8YaUKCMGK7bEb+r4gLbJedljZ9viWI5YDU8svfJ7ACgyzwxD6vcDnAK?=
 =?us-ascii?Q?bkBjvNbWeq9M+fCWiO7EPFF2pCXt10+2rhb5keZ7CZbcU3izssWO1/9UEWX3?=
 =?us-ascii?Q?5bvLSGcP/fpHd/uMrLq7uWysRvc4Z7q33ivVnUVOjl6PAhH3zQX9qbI0bb7Q?=
 =?us-ascii?Q?XR/5J3i24eU7NOPiqP2GtSR4NrGacUDA7BR6Ysnd/I7hvYQd6PmvRQLBW/k2?=
 =?us-ascii?Q?MVwFCMnk7YfT7iN0aOj5Q6DhuvCqmXoPaSJDdjg3S44elFXk2frd7j32tQJY?=
 =?us-ascii?Q?MT27WCmgDmThpd3BwFcht/qs83IpSufL2Puy4kMXB33ptz0uhwd42esViM6z?=
 =?us-ascii?Q?HbI+IvzqZnEOyAyU/CjiO/wvnezg+zHqNqVK+/+jK0+aE7WbXTdhd19MYymh?=
 =?us-ascii?Q?3Oz1zWadLK2iUews4xrC9f8RbxQQpZxzh0rKfyqqup8oscK/xQt5vFOLtlrQ?=
 =?us-ascii?Q?7drVU47yA2+J948cVigsMBTtyRj6Lgm32tjlZNwXd+ZwSYN26SjyvNsGl4sP?=
 =?us-ascii?Q?IJAJ9wF/C9JuTCkGMjFlnjoR7JX+VE2h2iyuY1UsrEj3Df25VJwHvpiAzTOy?=
 =?us-ascii?Q?1pv8Pv2DynuclM9SJLC+6KBGXdXtTf1uoWuhAoFBHPCqxdQ/GsLIVwoICMRU?=
 =?us-ascii?Q?NSheuZbtirisQqEzzWVSlOZ3iNGrk8UM43p+ljoF/W/qvCpvGfvCiuSD3Xnx?=
 =?us-ascii?Q?SxVoE9o5ZS0okWxRUDyFmOEwHJoDPMREafUGvgTzMLNV+ar1xWYxRLMUUzk8?=
 =?us-ascii?Q?NWFOIlwTitbodiQCoR0HGuE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f6c2d6-c074-4bee-fa48-08d9bb6c899e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:09.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HCW0Q0k8773HJod/7iWQRKnYiJHiNE3spRB3MM2xy/JS+gPsgshFKm2wFua8c/ZVKde/AMfvfI/LJ18mq9YVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ansuel is working on register access over Ethernet for the qca8k switch
family. This requires the qca8k tagging protocol driver to receive
frames which aren't intended for the network stack, but instead for the
qca8k switch driver itself.

The dp->priv is currently the prevailing method for passing data back
and forth between the tagging protocol driver and the switch driver.
However, this method is riddled with caveats.

The DSA design allows in principle for any switch driver to return any
protocol it desires in ->get_tag_protocol(). The dsa_loop driver can be
modified to do just that. But in the current design, the memory behind
dp->priv has to be allocated by the switch driver, so if the tagging
protocol is paired to an unexpected switch driver, we may end up in NULL
pointer dereferences inside the kernel, or worse (a switch driver may
allocate dp->priv according to the expectations of a different tagger).

The latter possibility is even more plausible considering that DSA
switches can dynamically change tagging protocols in certain cases
(dsa <-> edsa, ocelot <-> ocelot-8021q), and the current design lends
itself to mistakes that are all too easy to make.

This patch proposes that the tagging protocol driver should manage its
own memory, instead of relying on the switch driver to do so.
After analyzing the different in-tree needs, it can be observed that the
required tagger storage is per switch, therefore a ds->tagger_data
pointer is introduced. In principle, per-port storage could also be
introduced, although there is no need for it at the moment. Future
changes will replace the current usage of dp->priv with ds->tagger_data.

We define a "binding" event between the DSA switch tree and the tagging
protocol. During this binding event, the tagging protocol's ->connect()
method is called first, and this may allocate some memory for each
switch of the tree. Then a cross-chip notifier is emitted for the
switches within that tree, and they are given the opportunity to fix up
the tagger's memory (for example, they might set up some function
pointers that represent virtual methods for consuming packets).
Because the memory is owned by the tagger, there exists a ->disconnect()
method for the tagger (which is the place to free the resources), but
there doesn't exist a ->disconnect() method for the switch driver.
This is part of the design. The switch driver should make minimal use of
the public part of the tagger data, and only after type-checking it
using the supplied "proto" argument.

In the code there are in fact two binding events, one is the initial
event in dsa_switch_setup_tag_protocol(). At this stage, the cross chip
notifier chains aren't initialized, so we call each switch's connect()
method by hand. Then there is dsa_tree_bind_tag_proto() during
dsa_tree_change_tag_proto(), and here we have an old protocol and a new
one. We first connect to the new one before disconnecting from the old
one, to simplify error handling a bit and to ensure we remain in a valid
state at all times.

Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 12 ++++++++
 net/dsa/dsa2.c     | 73 +++++++++++++++++++++++++++++++++++++++++++---
 net/dsa/dsa_priv.h |  1 +
 net/dsa/switch.c   | 14 +++++++++
 4 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bdf308a5c55e..8b496c7e62ef 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -82,12 +82,15 @@ enum dsa_tag_protocol {
 };
 
 struct dsa_switch;
+struct dsa_switch_tree;
 
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
+	int (*connect)(struct dsa_switch_tree *dst);
+	void (*disconnect)(struct dsa_switch_tree *dst);
 	unsigned int needed_headroom;
 	unsigned int needed_tailroom;
 	const char *name;
@@ -337,6 +340,8 @@ struct dsa_switch {
 	 */
 	void *priv;
 
+	void *tagger_data;
+
 	/*
 	 * Configuration data for this switch.
 	 */
@@ -689,6 +694,13 @@ struct dsa_switch_ops {
 						  enum dsa_tag_protocol mprot);
 	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
 				       enum dsa_tag_protocol proto);
+	/*
+	 * Method for switch drivers to connect to the tagging protocol driver
+	 * in current use. The switch driver can provide handlers for certain
+	 * types of packets for switch management.
+	 */
+	int	(*connect_tag_protocol)(struct dsa_switch *ds,
+					enum dsa_tag_protocol proto);
 
 	/* Optional switch-wide initialization and destruction methods */
 	int	(*setup)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8814fa0e44c8..cf6566168620 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -248,8 +248,12 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 static void dsa_tree_free(struct dsa_switch_tree *dst)
 {
-	if (dst->tag_ops)
+	if (dst->tag_ops) {
+		if (dst->tag_ops->disconnect)
+			dst->tag_ops->disconnect(dst);
+
 		dsa_tag_driver_put(dst->tag_ops);
+	}
 	list_del(&dst->list);
 	kfree(dst);
 }
@@ -822,7 +826,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	int err;
 
 	if (tag_ops->proto == dst->default_proto)
-		return 0;
+		goto connect;
 
 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
 		rtnl_lock();
@@ -836,6 +840,17 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 		}
 	}
 
+connect:
+	if (ds->ops->connect_tag_protocol) {
+		err = ds->ops->connect_tag_protocol(ds, tag_ops->proto);
+		if (err) {
+			dev_err(ds->dev,
+				"Unable to connect to tag protocol \"%s\": %pe\n",
+				tag_ops->name, ERR_PTR(err));
+			return err;
+		}
+	}
+
 	return 0;
 }
 
@@ -1136,6 +1151,46 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	dst->setup = false;
 }
 
+static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
+				   const struct dsa_device_ops *tag_ops)
+{
+	const struct dsa_device_ops *old_tag_ops = dst->tag_ops;
+	struct dsa_notifier_tag_proto_info info;
+	int err;
+
+	dst->tag_ops = tag_ops;
+
+	/* Notify the new tagger about the connection to this tree */
+	if (tag_ops->connect) {
+		err = tag_ops->connect(dst);
+		if (err)
+			goto out_revert;
+	}
+
+	/* Notify the switches from this tree about the connection
+	 * to the new tagger
+	 */
+	info.tag_ops = tag_ops;
+	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_CONNECT, &info);
+	if (err && err != -EOPNOTSUPP)
+		goto out_disconnect;
+
+	/* Notify the old tagger about the disconnection from this tree */
+	if (old_tag_ops->disconnect)
+		old_tag_ops->disconnect(dst);
+
+	return 0;
+
+out_disconnect:
+	/* Revert the new tagger's connection to this tree */
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(dst);
+out_revert:
+	dst->tag_ops = old_tag_ops;
+
+	return err;
+}
+
 /* Since the dsa/tagging sysfs device attribute is per master, the assumption
  * is that all DSA switches within a tree share the same tagger, otherwise
  * they would have formed disjoint trees (different "dsa,member" values).
@@ -1168,12 +1223,15 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			goto out_unlock;
 	}
 
+	/* Notify the tag protocol change */
 	info.tag_ops = tag_ops;
 	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 	if (err)
-		goto out_unwind_tagger;
+		return err;
 
-	dst->tag_ops = tag_ops;
+	err = dsa_tree_bind_tag_proto(dst, tag_ops);
+	if (err)
+		goto out_unwind_tagger;
 
 	rtnl_unlock();
 
@@ -1260,6 +1318,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	struct dsa_switch_tree *dst = ds->dst;
 	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
+	int err;
 
 	/* Find out which protocol the switch would prefer. */
 	default_proto = dsa_get_tag_protocol(dp, master);
@@ -1307,6 +1366,12 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 		 */
 		dsa_tag_driver_put(tag_ops);
 	} else {
+		if (tag_ops->connect) {
+			err = tag_ops->connect(dst);
+			if (err)
+				return err;
+		}
+
 		dst->tag_ops = tag_ops;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 38ce5129a33d..0db2b26b0c83 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -37,6 +37,7 @@ enum {
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
+	DSA_NOTIFIER_TAG_PROTO_CONNECT,
 	DSA_NOTIFIER_MRP_ADD,
 	DSA_NOTIFIER_MRP_DEL,
 	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9c92edd96961..06948f536829 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -647,6 +647,17 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
+static int dsa_switch_connect_tag_proto(struct dsa_switch *ds,
+					struct dsa_notifier_tag_proto_info *info)
+{
+	const struct dsa_device_ops *tag_ops = info->tag_ops;
+
+	if (!ds->ops->connect_tag_protocol)
+		return -EOPNOTSUPP;
+
+	return ds->ops->connect_tag_protocol(ds, tag_ops->proto);
+}
+
 static int dsa_switch_mrp_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mrp_info *info)
 {
@@ -766,6 +777,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_PROTO:
 		err = dsa_switch_change_tag_proto(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO_CONNECT:
+		err = dsa_switch_connect_tag_proto(ds, info);
+		break;
 	case DSA_NOTIFIER_MRP_ADD:
 		err = dsa_switch_mrp_add(ds, info);
 		break;
-- 
2.25.1

