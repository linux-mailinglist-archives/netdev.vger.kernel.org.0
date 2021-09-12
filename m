Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14FF407E42
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhILQCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:02:24 -0400
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:22624
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229726AbhILQCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 12:02:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+dIWKgDJdmoBKn1LaECtBgxMia+XhMHRcs9C6B5l42gQVE481cZ93ZP8wZiaYHZlHNN5dz3/zUcayZPonOosfcue8kbItTqgrGbraU2Lip3mPefW3Y9Qokzcmg5aNlCIGwFYXrDx+37uTNXXxzYSlzxcEkmWFHXbIDMvv+Y2JV0JuE1rNmjdfEaCgsubd4H5oaOAp123f9NSB4S0iIoF6WuBO6UyqPyLd/vpq6E/yRZYvSIFsl+zJFYA6H9VOITElkqvI9jpRRAqtaQo92l60DnRvtUnfUAsAOhnX/abPrkNok8cpXMzwDsUSDk+SR13/ztCoueNtwOIbDf7JSKsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jsfO9aOSwqGP0ylL1nGQu50z4AxPmCfyBKi/89sudaA=;
 b=jmBy8hVbzWH2Y8V9Lptb/JV3G2BlwMLdrsRhYmdAyq1A6LtWHUSBNfqFhFEY1eSR1Z03rVAMakGLXmkijliQGK18BvsQRgxOogKiMM3BxQLFE8lBSQPssTvolxST+f93runaw3Q/1tZDYb93PgRQBbxq5ufZ2oI0pThb2tYigNYqRRLcL7exqa9ixnhyhvo9AIw/8UJPTADo9DefkS34OzKcF/1qHuB8Hm+m5840U9Wbd3obYfqnDBRNOyspLPDdtFyGoe+DjwmVDVgAOEPCTUv3v/3kTyJTHBea6zn/XGZJcHZz8UCEoDebWf9iC3iZ/5NCvg/EwEbc7ySViD94LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsfO9aOSwqGP0ylL1nGQu50z4AxPmCfyBKi/89sudaA=;
 b=lqDrJ1JKo0/w6SoU9u9F+ljctTGRkLu5fSKCO4fvo38jLQg7/Mkl9Nuqp3rzVyWQyDTtOTOXakodyCVZWGyHmBU76kjFlLhQo0xaf2LCc44ITqnhQ1BZ01rs26LNDNZTm0AijoP7BweyZHgkcSiIhQ/3kquxROf8ntqsxfxGy6w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Sun, 12 Sep
 2021 16:01:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 16:01:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH net] net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports
Date:   Sun, 12 Sep 2021 19:00:15 +0300
Message-Id: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0014.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR0401CA0014.eurprd04.prod.outlook.com (2603:10a6:800:4a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Sun, 12 Sep 2021 16:01:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23410192-73b2-4209-5f33-08d9760685c7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62705AB253D47FF14DCCEE89E0D89@VI1PR04MB6270.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vypF1DeikIF8xOK4eDusJmxWkCqo9H8fZq8HPS1JtKAA1Og3leACjHYh522FsDRK7sMd5ZjaLty38wmpEkjAVUuBIxxo90FWLKyGB2k+IlaE7CMG/6d9egpDCZL94lZbwYeYiTEyxtbCy5FeaDeA1oViAOmXTGfPTExCgK+CJZuSnLUBJE/FTY94LvqoK0TdQfy3q1aAdrLZ4LW2WTCroaFOWlOhjj+wOsMXJKkhzwqQpBFdtrB48peA3OpbGPDYIDOpRjW2nmME4Bmk6DbWkx/hW2Az3MOyOVjIyLiWYYsWxkDy/ncrb/WpbFDA2e29MNr1/sK8rbVWUtrI9r9bDR8teILjAlzdHwJMMG5rzw4xwEdGijARYEmWSuqIax0UAF/XWnEaGs+ZNRSNDPyCZ8Lm2yX7sVSTRO2XQ3/2diFiM+4I1rC+lWhzuIKFKlQ28Tf5g5vsdWZmCiRqE3JcDk2Eq+sT2SAEArvLWkA0CJK7mxyBQxqRJuL/9wb4WE9BROrfNaL13CKn1H0eslt/Kiggo+hlznDOe8bM8PQjIs7ohFg+6lOYsuJMJIOzWyvywpJA072/oucyNXIGWAP9iUqxSrbW//cxji7M3rTggeoEJYswtj1okAOg/ExNs8Uk276IJqpPIWetMtwuCe1JcA141n2mDYTR2m2XNiTZ8E6MdKg+Nyf3pten5JB8k9yNkkX5Sfy+Bij+S4T/5PJ2/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(6506007)(26005)(52116002)(316002)(44832011)(36756003)(86362001)(38350700002)(38100700002)(8936002)(6512007)(2906002)(6916009)(83380400001)(478600001)(5660300002)(6666004)(186003)(956004)(2616005)(8676002)(66946007)(6486002)(1076003)(54906003)(66556008)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U6lSC23UY/Y8id67IfQ2Pl4OP6XeibobebFts7XP84xPzmpxlon45rZjn/rs?=
 =?us-ascii?Q?1N1MJ2QN+smrITi+INxgfiAYq+hmUDXHV6qMu87CieDjGDp7yvBSeUmDNQBT?=
 =?us-ascii?Q?Xjc0OEe1z+0TtpgUr9V+eFqvWbghwwZdRbbEIw1EQQ5VQ8tM2MJs5mvawz7d?=
 =?us-ascii?Q?WYUhKD9gbsemh38rAk6tvptJDvYFx29Wv4lBZIFZswgco3FEK0/FKblIads0?=
 =?us-ascii?Q?7Hou2DVJkhkEqa3EnIhQJrTNeq+xM+OLcA3YIEYJk47CWVvtqc0aorwFVwM/?=
 =?us-ascii?Q?t4xqL4qzhDdURZnbscpYQ3rLLian/rb+lJrB8fzicVRz26qL+MUnV+/nHvnk?=
 =?us-ascii?Q?FZzH3/yqHqoeDuc55UEr9BA3DajbnQbZC/bY5T8e57GnShxd/+EjHHkDIqgC?=
 =?us-ascii?Q?KenGXq9PW3U8NVrJYkJbtFkSfhHeSHreJMGUZDAqopZa3diWwtjNP25rGtz+?=
 =?us-ascii?Q?66ZBW2claueKw+YSGyloEF8kwbyOXcaaZro2hORqelNyBRtQTzSYM3HPyGQB?=
 =?us-ascii?Q?himvaONK33ccKGL+OKycuASUpi/5y+dtHYa+4j8LtkWt7gFWSfDg05G1c2Uj?=
 =?us-ascii?Q?g8vpAm6GnvSzmNZ1KNqXksNAaIs0IdP0tZqkKUw7Eck8FI9S5Ba5Rjb2EJvY?=
 =?us-ascii?Q?4lnkMbY2MXwz24GNSPfUHbMaEronQG6/2NidjOGRfuZzmMnBfQ//7rVEFsmK?=
 =?us-ascii?Q?0OTVsjlFLknZ0u68Fl1jTSJSn0mo2EKN1PczZgzeBweZptgLoouYrLNdbbfk?=
 =?us-ascii?Q?9fJUXce5h0b3YAuqAFImugPpaVdphHbTL1LFydXLzxa7kqgaKJzEZbrwkPSO?=
 =?us-ascii?Q?nGxs6+acp+nvaY5AHB6up5UGH+23yyF3195vzs54P94cxwGN7ndaSmb9Zdvm?=
 =?us-ascii?Q?ABwIfI0oBEfEsa1OVJ+vrWU5+kKk+pg0gJ0+/lP+Xfhx1kdnB12Z57RpNYBk?=
 =?us-ascii?Q?jXzvB+FGaMr7KWbSAmeazrggCqBA/TuNg+gSfsxbdn3OLTtlmapnPAxOqotn?=
 =?us-ascii?Q?pJ5/gBOJVg+9a5e7ROm+NO13u9PaqRjyhp5hJM6B5nyG+RGTdbVlR7iocwa0?=
 =?us-ascii?Q?lJahVHNj9jvOEKJtkhhRDTBrcKG6pNmE2Mkpw3kpD6qBeEQFx/2KGjYNYwGV?=
 =?us-ascii?Q?TZmOIGhTEy/Im2AoBdrf3hyDr+5zasejmq9m6gCNElkdhVOFviSZNWkGu1Hm?=
 =?us-ascii?Q?wnKT5snSM48SoQ6nKT7+Bdm7PbgeoGqmhWMGrahpkRWedHVUUX2dtZekBiMy?=
 =?us-ascii?Q?ltNOZiyHEA54Lt6wk10odz5ERj0E1XomOPWoW21rGV1uKsOSTh56ZyA0qIiI?=
 =?us-ascii?Q?0r0L8B4xrhBqQQeMEDdLD3XF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23410192-73b2-4209-5f33-08d9760685c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 16:01:03.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OR7dAgrKzxSUnp9H15eI1QtrxJ82JaoHEG3gVZMSKRnDHgpbwjWW5XxnoH8ctG+qww0NOMItLM/R2audX/Al1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes when unbinding the mv88e6xxx driver on Turris MOX, these error
messages appear:

mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 1 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 0 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 100 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 1 from fdb: -2
mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 0 from fdb: -2

(and similarly for other ports)

What happens is that DSA has a policy "even if there are bugs, let's at
least not leak memory" and dsa_port_teardown() clears the dp->fdbs and
dp->mdbs lists, which are supposed to be empty.

But deleting that cleanup code, the warnings go away.

=> the FDB and MDB lists (used for refcounting on shared ports, aka CPU
and DSA ports) will eventually be empty, but are not empty by the time
we tear down those ports. Aka we are deleting them too soon.

The addresses that DSA complains about are host-trapped addresses: the
local addresses of the ports, and the MAC address of the bridge device.

The problem is that offloading those entries happens from a deferred
work item scheduled by the SWITCHDEV_FDB_DEL_TO_DEVICE handler, and this
races with the teardown of the CPU and DSA ports where the refcounting
is kept.

In fact, not only it races, but fundamentally speaking, if we iterate
through the port list linearly, we might end up tearing down the shared
ports even before we delete a DSA user port which has a bridge upper.

So as it turns out, we need to first tear down the user ports (and the
unused ones, for no better place of doing that), then the shared ports
(the CPU and DSA ports). In between, we need to ensure that all work
items scheduled by our switchdev handlers (which only run for user
ports, hence the reason why we tear them down first) have finished.

Fixes: 161ca59d39e9 ("net: dsa: reference count the MDB entries at the cross-chip notifier level")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  5 +++++
 net/dsa/dsa.c      |  5 +++++
 net/dsa/dsa2.c     | 46 +++++++++++++++++++++++++++++++---------------
 net/dsa/dsa_priv.h |  1 +
 4 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2c39dbac63bd..6e29c0e080f6 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -447,6 +447,11 @@ static inline bool dsa_port_is_user(struct dsa_port *dp)
 	return dp->type == DSA_PORT_TYPE_USER;
 }
 
+static inline bool dsa_port_is_unused(struct dsa_port *dp)
+{
+	return dp->type == DSA_PORT_TYPE_UNUSED;
+}
+
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
 {
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_UNUSED;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1dc45e40f961..41f36ad8b0ec 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -345,6 +345,11 @@ bool dsa_schedule_work(struct work_struct *work)
 	return queue_work(dsa_owq, work);
 }
 
+void dsa_flush_workqueue(void)
+{
+	flush_workqueue(dsa_owq);
+}
+
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 906ae566aa22..17d0437d72c0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -897,6 +897,33 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	ds->setup = false;
 }
 
+/* First tear down the non-shared, then the shared ports. This ensures that
+ * all work items scheduled by our switchdev handlers for user ports have
+ * completed before we destroy the refcounting kept on the shared ports.
+ */
+static void dsa_tree_teardown_ports(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp))
+			dsa_port_teardown(dp);
+
+	dsa_flush_workqueue();
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
+			dsa_port_teardown(dp);
+}
+
+static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_switch_teardown(dp->ds);
+}
+
 static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
@@ -923,26 +950,13 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 	return 0;
 
 teardown:
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_port_teardown(dp);
+	dsa_tree_teardown_ports(dst);
 
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_switch_teardown(dp->ds);
+	dsa_tree_teardown_switches(dst);
 
 	return err;
 }
 
-static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_port_teardown(dp);
-
-	list_for_each_entry(dp, &dst->ports, list)
-		dsa_switch_teardown(dp->ds);
-}
-
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
@@ -1052,6 +1066,8 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_master(dst);
 
+	dsa_tree_teardown_ports(dst);
+
 	dsa_tree_teardown_switches(dst);
 
 	dsa_tree_teardown_cpu_ports(dst);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 33ab7d7af9eb..a5c9bc7b66c6 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,6 +170,7 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
+void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
-- 
2.25.1

