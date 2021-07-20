Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF4A3CFB33
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhGTNIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:08:55 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:24800
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239127AbhGTNH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:07:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT1OCMTE/MXwDhOg7W5HTYrRnwJ9uMYaAEbB4vBMKHq9YXgEQMU7jjcTI5o188kIzfdXi/1hfn+ooLZ3gWZUpz3U8kTn0OdIYyUAiAGYNqNPVj7eJZp6Al2F5hsoAP/5TWljTn7fZmLg7hVgrNSMmy/x16QbnTx+WLISQBa2w9wd9Qo6mCLyGHQjLIel5jSiYQ3KRwU/sOmQF94HQeyIph09mpkCayIpZW1q+9wxUU74wW7Gq0ebcjcKFu2MGqE8lbY4er/iJTKfvqI41VW65BBc0AAJC4FCWqiXclLnZ03Jajk6ycKggMxQxi0UHw4R6+b6pUfdXl0swupnUJxZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZeVkdUo9AgVcRq5x3qHUTusEo8IboIcSbT6PnN2pdQ=;
 b=fKntnBfAmZqK+CfmhUEXxcdW9F6XssyvklFk+OOJG4A0FgAmNozDnwVwzytMBD7K3SroZUGscv8thASTiLSYHZNaMbtYzoTYWjge6prrqwx7MgHufVBJ2IG4C3JTGNBcCNVaglSCbEmhrAbxC3BzlZ7dEGtm5mZekOjF2mBXXjj6NDwAUx9G83Zs4W//d27pMqGQSwoZaWzc4J01Yr6FIAV88DylQlUbQ3FhS6W4ah6IUVCNPwIq5FxK/djelfGgaQLsicoLQ7XrtzIgXXGC9L4zg9RuRaAVERXNgoLOqrvmNzOrdwAaGgmGSfgSzi7iz1emF+cyXGzMAn1gZsiwLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZeVkdUo9AgVcRq5x3qHUTusEo8IboIcSbT6PnN2pdQ=;
 b=FcbtibWpJvXgXtZ5Nfp9llJTgccT94BF4F+iAd+rDCREX+4bDk4nTjeOsUfhBrjWWDsfh8P4+mbC6aIUiYXyxCitOv85+x4LJdTxYKHp0Jo8RSFZh8JZElAN5fo9doqGw55q1uxyBQSYWc7cOZzd1OMuQnq8jSbzSgxMy7pbkgg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 08/10] net: bridge: switchdev: recycle unused hwdoms
Date:   Tue, 20 Jul 2021 16:46:53 +0300
Message-Id: <20210720134655.892334-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef202e85-a795-4790-07c3-08d94b84e692
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355172AAD97DEAED0C71B5F3E0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6WNXLeqhHcj3T0YH7VwjCgYfzzF2rB8WjRvC+lTTcCrLmnVqOlTlELKfF2iVJznYS2PiOz7tRJOjC4PsUOXcmdocjvwoTkVFpFQrJKW5s2UPJvh5Tp7wGWLYWuvEm48psddwsEH4g5otilEmJHLoxV73T30HLAm2SLVDMLRJvWe128jbh0ZMCdg7wUOOyEqE8gdYxJg65EKncaS9oMcGMsz+MJAXPeOB0cYVtK9iTUts4/1RGk4q8BLynzfO4zywWVjmi4N7FFGjAyrLQkSllRpKfbxoIXDdOZlrKpxjA2u/pyhO8NaoUDF11uFbBrgvVtPxR4o6AVih2JrnaTc/XPvnL6JegUKV0m+Vbv+RpDx8k+sN+Tdf6y20sJEWWhe+XgNvzmlRQbCb3+Nvb7dZywxK/tx24zQF7y777YNsWx7bO8rBCsSbUGTFC7xpLQmFpEii0ndpjp3639dpH108cOJPevCvbW4BWij1M214j4nmebc8bPaRpldVkqzkR3ctCpK0++mEoI3PWNQ8q4LQQmJlqTjJUnWguBhHNwZ/JvoXj3a0OJuLhMxP5WrhKaGfv0gNbERN1RsGTIPWbnsZHoUSxKSsHeSUPMw7KQEP4EVAXHelJm1FF4i6ePHo4xZqdOybNy7ORX/Q14dJ26tAZbFy3jolbtUG8CuMGdZ32ugsna7MPDTfkVHk7nkCI3A82vyA/jcwFjvyN0TtypgVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(83380400001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GMzL/Jx2nUR1M23LkBm153bFsoFAi5txLKkut47GlSgH2xujmjtIo6Tp3jUr?=
 =?us-ascii?Q?VIrWLA4XuE5IRZZeunkFJbnp5C3xSbhbs/XYbZRjP8LXRRnbTfCbqgZtl5Zp?=
 =?us-ascii?Q?TM4Qr8w4jmDtGmTEbx7KJqdZUZaQ4aETFOfKSm64gLnnH7fCe/lsshOCSvxY?=
 =?us-ascii?Q?kpLKT0sUItG2VIcel2ubMMXkDulyNoI5+icrV5ETv0GuDnO+Z595qY/6Zg9B?=
 =?us-ascii?Q?Zb/Ij5GxgrLErPJYYo45Cyb/1qmEk3sYqjPYi1yPMX2eSsIZZFPWGqvBnlPd?=
 =?us-ascii?Q?h74gWqRCWFmCRbHPX3rwfjKn5h3eJgGg12fZcSE71jr/7HLLfX6GJwH0+ICZ?=
 =?us-ascii?Q?fFSOjL/m8ZdVwZ492TEZxrihHmfFC11tUff1wRoggudwJcS9bGFjRH9EZFhC?=
 =?us-ascii?Q?hwZJaWianSYEzcLlIfW8kn0Uh5PiS2S8A1LSosbeDSD7Ls3JZSuKY3RnIIfI?=
 =?us-ascii?Q?KJRDILOW6Re5kWLWE2EBIgF65vL4NZ7fP+jPVBFNcRuQNIkynsZzsCZwF3zl?=
 =?us-ascii?Q?rujdcY1u1jz0B6phL5tEi+XTgpRbu6g3Oz5PokPcfvS5MUwNcrbCPApA/3g/?=
 =?us-ascii?Q?WV5sY8/LjoOXpa/XRQBpCaz/H7FHmsRnw8XVDJ44nzNvjawKWOkCTTd6j5jt?=
 =?us-ascii?Q?2wuRyLGaFJh7Vf+HxmUOGmyDtRkkcFtR9Ku0HXegfbvhOjnTcGWU83wrYhjj?=
 =?us-ascii?Q?KGlKXOGUjqAQRlyAMQixcPFM2LwOnhpEP1D+VTcj4iutW2pYD+290wd2XzRC?=
 =?us-ascii?Q?WGYm4KfLSevc5Lz+9Xq0HgGNBfuPOq9RyJ1kqPmQmwapYcRtXU2NOFKODiEY?=
 =?us-ascii?Q?ijU6/oi/3+QYEzlxiRl8W7YMgSe0nwUAOtALMHMa+admRlHeq/dcv1yOx592?=
 =?us-ascii?Q?xa018as7M2hpGGx3Dwq2QGdd9bp+cLbnmddrrxdPWwexTngXFIbCsOzeFuiv?=
 =?us-ascii?Q?9KtW//g8Pw43PUEBf1qJgiLhVYE4PFqUJKXA1KH955EjSlpfs3VTVgHCdo2O?=
 =?us-ascii?Q?SK/xg10voNbBhtmtQSn3Ly2dsZ+U4Df5hLhFrz+JrPNepXpbQZEp9QGqhhi/?=
 =?us-ascii?Q?7bOOPNKoHkstfSYGyzOjVBrsC4jLZwLixlINFAuKFb/UeeuhFEhbDZmcM0wZ?=
 =?us-ascii?Q?gsiRoPl64SioPsvhXVM6M7tTdKQlEuz5EhYL7rUQk7QtM3M//OSnrK+j+aKf?=
 =?us-ascii?Q?pa/4XJUEBwVu/2Dz7ilJQjZGDfds+Ehn8na5q+nPRXh/uuNeqwMsA7kAFkW/?=
 =?us-ascii?Q?1BYsKnhbsNuZuieaPadzVoYrfK7ZxRpV/w8NT6ZMyVP0P3qFxBlKvSTYhcSP?=
 =?us-ascii?Q?iyDGE1jK9/MTQK0BQV0b6+H/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef202e85-a795-4790-07c3-08d94b84e692
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:22.7221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErD69bjEUA3QEOc8dZrcVQT8e+q4qplHDmzeRRE3+9z/hiBEnAqVl3i77bIQfVxPmj2msvpt+QYzmiPPEUuQow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Since hwdoms have only been used thus far for equality comparisons, the
bridge has used the simplest possible assignment policy; using a
counter to keep track of the last value handed out.

With the upcoming transmit offloading, we need to perform set
operations efficiently based on hwdoms, e.g. we want to answer
questions like "has this skb been forwarded to any port within this
hwdom?"

Move to a bitmap-based allocation scheme that recycles hwdoms once all
members leaves the bridge. This means that we can use a single
unsigned long to keep track of the hwdoms that have received an skb.

v1->v2: convert the typedef DECLARE_BITMAP(br_hwdom_map_t, BR_HWDOM_MAX)
        into a plain unsigned long.
v2->v5: none

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c        |  4 +-
 net/bridge/br_private.h   | 27 ++++++++---
 net/bridge/br_switchdev.c | 94 ++++++++++++++++++++++++++-------------
 3 files changed, 86 insertions(+), 39 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 838a277e3cf7..c0df50e4abbb 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -349,6 +349,7 @@ static void del_nbp(struct net_bridge_port *p)
 	nbp_backup_clear(p);
 
 	nbp_update_port_count(br);
+	nbp_switchdev_del(p);
 
 	netdev_upper_dev_unlink(dev, br->dev);
 
@@ -643,7 +644,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_hwdom_set(p);
+	err = nbp_switchdev_add(p);
 	if (err)
 		goto err6;
 
@@ -719,6 +720,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);
+	nbp_switchdev_del(p);
 err6:
 	netdev_upper_dev_unlink(dev, br->dev);
 err5:
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 54e29a8576a1..a23c565b8970 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -29,6 +29,8 @@
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 
+#define BR_HWDOM_MAX BITS_PER_LONG
+
 #define BR_VERSION	"2.3"
 
 /* Control of forwarding link local multicast */
@@ -483,6 +485,8 @@ struct net_bridge {
 	 * identifiers in case a bridge spans multiple switchdev instances.
 	 */
 	int				last_hwdom;
+	/* Bit mask of hardware domain numbers in use */
+	unsigned long			busy_hwdoms;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -1656,7 +1660,6 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1670,17 +1673,15 @@ void br_switchdev_fdb_notify(struct net_bridge *br,
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
+int nbp_switchdev_add(struct net_bridge_port *p);
+void nbp_switchdev_del(struct net_bridge_port *p);
+void br_switchdev_init(struct net_bridge *br);
 
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 {
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
-{
-	return 0;
-}
-
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
@@ -1721,6 +1722,20 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 {
 }
+
+static inline int nbp_switchdev_add(struct net_bridge_port *p)
+{
+	return 0;
+}
+
+static inline void nbp_switchdev_del(struct net_bridge_port *p)
+{
+}
+
+static inline void br_switchdev_init(struct net_bridge *br)
+{
+}
+
 #endif /* CONFIG_NET_SWITCHDEV */
 
 /* br_arp_nd_proxy.c */
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 833fd30482c2..f3120f13c293 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,38 +8,6 @@
 
 #include "br_private.h"
 
-static int br_switchdev_hwdom_get(struct net_bridge *br, struct net_device *dev)
-{
-	struct net_bridge_port *p;
-
-	/* dev is yet to be added to the port list. */
-	list_for_each_entry(p, &br->port_list, list) {
-		if (netdev_port_same_parent_id(dev, p->dev))
-			return p->hwdom;
-	}
-
-	return ++br->last_hwdom;
-}
-
-int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
-{
-	struct netdev_phys_item_id ppid = { };
-	int err;
-
-	ASSERT_RTNL();
-
-	err = dev_get_port_parent_id(p->dev, &ppid, true);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-
-	p->hwdom = br_switchdev_hwdom_get(p->br, p->dev);
-
-	return 0;
-}
-
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
@@ -156,3 +124,65 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 
 	return switchdev_port_obj_del(dev, &v.obj);
 }
+
+static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
+{
+	struct net_bridge *br = joining->br;
+	struct net_bridge_port *p;
+	int hwdom;
+
+	/* joining is yet to be added to the port list. */
+	list_for_each_entry(p, &br->port_list, list) {
+		if (netdev_port_same_parent_id(joining->dev, p->dev)) {
+			joining->hwdom = p->hwdom;
+			return 0;
+		}
+	}
+
+	hwdom = find_next_zero_bit(&br->busy_hwdoms, BR_HWDOM_MAX, 1);
+	if (hwdom >= BR_HWDOM_MAX)
+		return -EBUSY;
+
+	set_bit(hwdom, &br->busy_hwdoms);
+	joining->hwdom = hwdom;
+	return 0;
+}
+
+static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
+{
+	struct net_bridge *br = leaving->br;
+	struct net_bridge_port *p;
+
+	/* leaving is no longer in the port list. */
+	list_for_each_entry(p, &br->port_list, list) {
+		if (p->hwdom == leaving->hwdom)
+			return;
+	}
+
+	clear_bit(leaving->hwdom, &br->busy_hwdoms);
+}
+
+int nbp_switchdev_add(struct net_bridge_port *p)
+{
+	struct netdev_phys_item_id ppid = { };
+	int err;
+
+	ASSERT_RTNL();
+
+	err = dev_get_port_parent_id(p->dev, &ppid, true);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	return nbp_switchdev_hwdom_set(p);
+}
+
+void nbp_switchdev_del(struct net_bridge_port *p)
+{
+	ASSERT_RTNL();
+
+	if (p->hwdom)
+		nbp_switchdev_hwdom_put(p);
+}
-- 
2.25.1

