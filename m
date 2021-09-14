Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AF40AF7F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhINNs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:48:58 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:48097
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232989AbhINNs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:48:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CR6Kxg0pd1ljWMXP0Pc7XYuLMiQjWFB1HHOmmUZi+ftqp/RypJ8dQPxjPpIRbvRrENp2JFScpCJrnsr+S0Ozp0degAYAmU17lmyqHyqdv1ibsSDZj1XKTLs3bJCrngO1RDP+jP7gziOKVlj8yWmD1EIvmTxFtg5jYnXPCi2pZoSd8uQA+fCJS8yUvxeihUUv2x/DthLb37t0F2KJyPkJEqjNg4MOjijAMqLOiCNNgNgEToEOeefS+8p3dJqcvliFcKigmrAM0dB5a3v71gk9gVu9CyTApf4yfrhvlqNqtfXN/FSbaoWeWeWihd9Iu7PAjTr7s7JbnG3tcxcIuY3myQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DgWNLbfIN2RHQy6Igz/ruLJ47HGYBkS5V4xEn53HqU8=;
 b=k09N00EwFJ85ieAirS/KyPbwZR5Y0LtHLzIGwtcIqPAvedjiKfseXTMb1GZddnGiH9VDuJ5xsfocXwyq2s74OLlB20nRSIJ7EC4F10OoVNIU4dOHYVtvjdIZ6zfZhxQirr8OaN+Qcsjn4D9ziNdi+a4LbfSDZnmHj+sdaH0nUtFeydKHstAJPmWTFRUhJ4MQSRcgAKXZCD5eKcS8kPTIILSomk8BxFbCwsp9s4XWTqO2QIe3GJWVIMT49T7hGwAlJITk10fuasP0Xt2wnJeF10kvx8ZMBfTCmeRRPs9DS84R9KZNBVZh3G3Y+MXZoQUfp5s5Pp7of2rj/Ce9rwnOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgWNLbfIN2RHQy6Igz/ruLJ47HGYBkS5V4xEn53HqU8=;
 b=DGHilgg9rzhcM0rp5F8YmwhIn06tpriypVESX5Sj6OmP0jAenmaZgqzPaIrlTEZxlcIDCgvbbQFFADvuwkQgPgkHrVIzC9NOYeK03cFyUDrripa71dQWIVI54MOol4wNmTJgezCWurTZxLfigoTrj0TleOnPAAhzKYMMAa5CW9U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Tue, 14 Sep
 2021 13:47:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 13:47:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net] net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports
Date:   Tue, 14 Sep 2021 16:47:26 +0300
Message-Id: <20210914134726.2305133-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:208:14::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR03CA0026.eurprd03.prod.outlook.com (2603:10a6:208:14::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 14 Sep 2021 13:47:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cd64e56-9e68-4573-43e5-08d977863694
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687A39E7F7B553586733571E0DA9@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQuMXoYHWNyJ+CFZlAIu/0y/byMRw0sa/9E9HgcHphEm5ZKS8iIDzEG6V/Stun+wOJEGQ58nsFF+TJdIVRph6eZDBeA4VoVSXBwGH50S5D0X76V6ZhjrkGFYrph7t8pRqzxv5xqwYYNSZh+84K46o+XKkbZY3tlebAcKfYZUbK+y5UtEbmn33eE531tYGTxoWKaSaPA1rT2aNMTBvnIcmNFT9mn/Ju8MYmoHT4/zQcTRYbNwZcSwbtzvWi9hXRN7BNp71D7ia52zQFxf7P+9SfwSECekJpty3eQQ5gGC0tEwrtATejfwNBw2wH/vfukhyzvSQNpXkc4Jx+YnsJIXhYr2Hm2xWeSb3P+NJDwtGtdwq3ydDWA1Yc3bRgqQ723A7jXyFSN58UrMQDlzci1O9a5ymmT2W+Czwmi6dStQlbjuP0S5MNbsgDhdaFdiO2S6o4VREUVQy8ZkOswf629X5nClhS9WTYP4xk4EnaP1WfzEs7jgeWrYhjYzzMHQ3mifUug8YNMmho+zPjWgnRZr8GMaS0eH8ZjTVM8cDiljF7RoIYeo8i0m7G6QpvxZqWnt5IuLvbb+HcOevcKAoSDRoubOqT/16kcJxS+mpZ883uQo++t+wZ6BTP6l62g4Dllc+sGMmeAyprP4SDl7Cmjc1UiUwfncUgG0uqXHfINLA4hEyRIqXlRN6BgWVaxCZL7LCy9bw/0YiAZki4+RdyS+iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(66556008)(36756003)(66946007)(66476007)(6666004)(6512007)(6506007)(6486002)(186003)(52116002)(956004)(86362001)(5660300002)(2616005)(83380400001)(26005)(54906003)(44832011)(478600001)(8676002)(6916009)(4326008)(2906002)(1076003)(316002)(38100700002)(38350700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meL0cdfK5NM69D1C1ZEgthu/xNvYfI+A8iA1jhIkpKJTB2VRpBWn9YRdhfAW?=
 =?us-ascii?Q?U7n+JZQXzBWUmV4SUsVJIuS6FwL6yXf27DN2he1fKSnPjiK0tQP0c3EJDlRE?=
 =?us-ascii?Q?FTjyhrFlW/TPpwf85PxE2zgMF+VjELtRL5EVhC1PlBVWDevKZLqZcIelcRAP?=
 =?us-ascii?Q?kC0jVCP+ck0cyZeJhJ2WoCNvuUE5liwheITTIwmpoWyen3ynOPpAmB/+CYKn?=
 =?us-ascii?Q?pONB8L3cvmHd0c+MfDtQ0k7o1aHpRPPGIRwHzN+hAbAsLeWv9j9qTsD2psSh?=
 =?us-ascii?Q?p7ZnJDb3Fu6Nszqy/20B6FoBqrCDmuMsr1aha54trDIu0B7IoAsRGuvPJHVH?=
 =?us-ascii?Q?r6cg49sJx4qjD5J6aL/rKCz/i961jjhFPKpKL4w+gxxpJVY7NBJrwKLU6L/6?=
 =?us-ascii?Q?GcfKtGpAYJxE+YynvRovvGUyyOTzumx+oHbopbV50iPYPgkW03efjIOaE1mb?=
 =?us-ascii?Q?3TW9yA6SISNTTglMfKKJa9rHfq4dCCBe1jYQZof0RQZWhcfyXyNQVyufowBy?=
 =?us-ascii?Q?gxWZfBTWmM74p8GPS/8dahMFOHbx/E9hoYXDWYR0hdoz75WutImj9VZqFaj/?=
 =?us-ascii?Q?GEFiROxYQZ48hD6hORtk5w6PjY43B4fpGrmAP5omDKLS0+ef2Q8Uw6gndqGf?=
 =?us-ascii?Q?RGAH5sHx+VBfvGDgfW5S3BZ6sARBdgPG+aiJvrFfyiL53lxMF8L7LmPF9xzl?=
 =?us-ascii?Q?+MwLYMnmxLTZUFI+8EOaHsG+QcSINKNSRr4PCTSz68RI13Q0SDw1ht4eyJQs?=
 =?us-ascii?Q?YT7TQnfelPhgjm34Ef92FiaKfrXDkVKIfoXEzjLAtshj14zuIjX1cnWa9htE?=
 =?us-ascii?Q?mGiAb3d+hOMlTNN98ftsMGBT8iBgmOq0aRcQQcfLeESrxzfmCYoKf5UHO82U?=
 =?us-ascii?Q?LpmlMbBXvV3DVIOTnzGDU5IuTb3qf2DyfOmGuAZpNw7sDM/aSB7M7OY4QhTc?=
 =?us-ascii?Q?KVR5IZJjjdY4ZgIFfdVvqQ20YOzTKr23qf4P9pTojVZT7FtfnF72XsD8woJG?=
 =?us-ascii?Q?GpCVAi+UPoErVvZIllIXZPCPdY1jramB+rkIAk0cTYEWuJqVmwf+VwpzHGgO?=
 =?us-ascii?Q?EqGuG6vGWO0pOIpMKR11d+6JHkIbgR0fR0fcSsg05FxfDiM7F2mmZ7xyOPeE?=
 =?us-ascii?Q?EDLk2TWS5HLHGuttoHthXnpEP45Jv/1Ce52qn6e2oHbbtjYjJedNEjWLTREA?=
 =?us-ascii?Q?fG6csAnzBNUkpvmGDPZkEr7ka/0c0oUDAfs9I2ZFC7br2Vk++S9R9lJdLMWy?=
 =?us-ascii?Q?XEj1PHNJ3Gf1J4R14oc8bZJKSdceXV1AstRUcJoc1DxnohiKXCECsGz8W7Nc?=
 =?us-ascii?Q?zjEsihY+rsap0B0RzScYIyaj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd64e56-9e68-4573-43e5-08d977863694
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 13:47:37.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTT6p1PVp6gkbDmmm46Rq7culGojOmaYofTiHyve3geiGNb1CxmGBa8Bo/5ljspzr6dBvKvbn/6hOse33+cizQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 include/net/dsa.h  |  5 +++++
 net/dsa/dsa.c      |  5 +++++
 net/dsa/dsa2.c     | 46 +++++++++++++++++++++++++++++++---------------
 net/dsa/dsa_priv.h |  1 +
 4 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f9a17145255a..258867eff230 100644
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
index 1b2b25d7bd02..eef13cd20f19 100644
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

