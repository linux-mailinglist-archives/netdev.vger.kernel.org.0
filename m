Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854453D141F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhGUPpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:38 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:37513
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234872AbhGUPpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:45:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/cTBEB5OVp/37dMj1l3xMdRkthO2HDbAmxyzSbtr66y9FDjaBXMyOYxdSkXIxSJek3KUgXqaoG+JjR2f9mi68/+JsztD9NSXvhIHpArnQnDub6cbgMyQqvnU/tl3Jgi54TSLdsxt+3vNt1nFdLfCaz2KNRaeFK47AxoSKpwFReFBFP7ycx11Mr3Gx/i3KS8WIt9G3VBCuAYV8/G1alD6Uz2EQsVokZ9ePvs8d+JbnkY9j/73IUzRnqBIpdwCm6oGbigQLxQryq5Zz3Wzwy7fagJaX40Q7HDO7l5hzoU+IkE4DNbyc185Rct+nQo++QarGjfJglBGIOPZaA9UA7BQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL760jQgMQ6Q2QGTVFIIaQoZu+6rx1qOKazSNa/RPfY=;
 b=FL3OKei+XoBV7WA2gexDHGSD4PCzl+Qoc83Dh5cc1o7kriLqdclHf2Q9IoBafiL4jIxMsjI7wuxDnqgM6+Jy3LjMlPC1gBSwGghDLeCJTIBhUTZZy67h/PFiF7YuRN8X9UPdLi+tlyI6yg/HzDtrGfzivRYbtA3iMnel+MyHLwhtbd2RIqA1hbh4/Nb4CH30+EjHCdT04EuQ9O4+/w5HQoio1A+IARwEVZi4RZWta8XnZV8wnNlav3/m3tf5nqzblsRmzogWFraWV0wf+1tPvUSnz+h2rtT/Bed4nbYy+3FMYu5zaqEPeHh4QiS0N02YmLcXFiWjLockQYYIzlcbkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL760jQgMQ6Q2QGTVFIIaQoZu+6rx1qOKazSNa/RPfY=;
 b=rPv66ZwqHdsuCMIxL7yYxANMF7xmRJ97sW62954znSephcDSxSvj1/x02zofj75MxMvUqImgKlG1D/mkkrlvy8ZhsWN60YTbbgr+7XFOjAS6KTBs7GKIQOtIOzv2z6yo8+GZq/ENx0VjlpogCd8zXV38z/gZ+usJrI/Xkg2AR8I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:25:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:23 +0000
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
Subject: [PATCH v6 net-next 4/7] net: bridge: switchdev: recycle unused hwdoms
Date:   Wed, 21 Jul 2021 19:24:00 +0300
Message-Id: <20210721162403.1988814-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c97fb76-b417-41bf-9672-08d94c642432
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343A9CB48CBCDE2D4255DC2E0E39@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7+HlHPdTRgTNUaFSqAyRiaQ4CCzWCpEvwV5XkMQ3m4/7MslKNkgOYJXex+m66uBEbnp6XGiZqyB/uS3qToOk20zGcFmExOkYb2Yuez3Sl66R/ujfuSLFEjuOCJcw+QzwSxyS7oZ3m/PPGYwmQQI6qswlNxLxwgs5rcNnzTNKQBQEjB7WnS0jPjD0chhJGendZvIJ0P3DHbWdbiGJNbA+XFfDA+w0adMhgY5C1UIPe6fy0ZbgZcJ84ZVHVSdL2v4irdPbDdKw719gfHQYB+i516k95gHTCod+35W9MKDrKZ9ZYLxLvDCD7CgxZ+HlKlXWkMscjGCRH97aa67JFCOYRi3rTMPNCdn4vcdocv0PWh10U1FNH9fCge67sYcEmkMku03IF8mjfyS4aXH6abhS3TTBcGIZIjScOzKTRehDOlnQxhi2Z1F0OSqeKVVvoX3rxrzLCoa74YrP/iSRadr7TLHFEp6ZGvb7lZc8avz/L5+EVXP/fgIjSp52fB/4NjG3hzEvvRylXaqUaB668RxE/KsVuhFNThIauoGCBZ+SimxHWx+xZlnkq+KTZXtrU9V9QdS25ECbXkLs9xPokxPQsjBZXA9obxwxgYP2C9/UWI1VNmtTNLzqduJ1myMjVyoyzhbXUul0SmpWSx3A1CUd6HV1tZazUnF2hlgvNvv1SKdxCSwAxhhPgbrfJYuQJdpIkwwJlv4OJ8KReSqykGcbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(186003)(110136005)(956004)(4326008)(44832011)(316002)(2616005)(54906003)(8676002)(8936002)(478600001)(83380400001)(36756003)(7416002)(2906002)(6486002)(6512007)(52116002)(1076003)(5660300002)(66946007)(66476007)(6666004)(38100700002)(6506007)(66556008)(38350700002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7NQV1fU3ngZr6ABc4BCKljQgWZLSBNH4j8mOvGS1oV3FNGiRA8vIUnV2XaNg?=
 =?us-ascii?Q?5mTRc7XcXl8421D10iSJsP7ip8GizqtezK5Qwq0SKJhWxu58yVPn0Y0iZEKN?=
 =?us-ascii?Q?SU0D5G1P7jPzBoUdyLzVOHUBJz26xr6OOFrBeReSNtujHYpS5L1DZFKSN7s/?=
 =?us-ascii?Q?ssZ0pX1NB/YvEBzQ8mf2Mn0gh7F/CkOlp/A57h+Nf0e9Pr5C+21hQPuql7LZ?=
 =?us-ascii?Q?heHZP7iZRHoiRMo3UBI+ZDJG69jNLaWGkZd7SQlPWhee/gXx6Tv2lZ5YHea0?=
 =?us-ascii?Q?NWwdKq3/gPTYPr2KI9iN2l/2dJiDump8zCigsZesc3cKrxmHTYLR9pBMIDKt?=
 =?us-ascii?Q?6Mj6rkxqMCfY9u3lHAIinHTihr6iI9HmPni1T34ieCZNAjHBSn85R2L4QnjY?=
 =?us-ascii?Q?GfKka7keE9HR/0wTB84GBgPVP32ADgRDnMoPYTTQElJGZtKrb7YbPQQA3bH6?=
 =?us-ascii?Q?eIkPDYhIbfuCHi9sws8JkN8B1VnRySaJtypeSJmyrc56lFmRoR6s2fj7PdcL?=
 =?us-ascii?Q?eDjfG4I1d2pp9z0k98TRARt4xM2+uxpn7/a7f/jRSMypu7W1UKtANBgiJ5iY?=
 =?us-ascii?Q?B0uSMafKezlgGsx049Mal/Ik4MvzO1nSbn7n3goBwEK4M2dtWlREHJunm73X?=
 =?us-ascii?Q?pPXl+i9e/HYTZvXZt+a5i/cVAPSxjM+yoCHravbZuY2sGJBGWnOLi2C/c9dS?=
 =?us-ascii?Q?PrKYv6xr8r3gd8R9Syv6tKTc5fj0B9VHj4W78/VfbG8keLOdXoGYcGL5eXVg?=
 =?us-ascii?Q?/nNQvbNHaGIcyn1tBX52ukzhZ65YMUugZ0HjtWH7mJMuIrTKk6m68QUKKA4u?=
 =?us-ascii?Q?lpXcT16FT1SSyItF4lXF2l5P8XX9Cs2snkNP8ddXXfkE/N3KXsUiIRf4IneL?=
 =?us-ascii?Q?rsoHetlHMcII5gENXZb/4boPovANqk4ItjWVVyBl9SwMaLHi+l6++1kz0LcZ?=
 =?us-ascii?Q?vghAD+nFTnO9IJVqKLwNUypyv4n/+ARU5AvT/4sT/maLjcVwnyjGDJ3q9nuM?=
 =?us-ascii?Q?b7GdksdmR979fx2lA1FfEuV1hnR5urFuYgMzMQcX0JQjs1Le4mDPqz2mAwRt?=
 =?us-ascii?Q?IxxDNZ4UjWbWFxT7sMvZ/j29qRR60szs2rwLRAo6vctAi3vrmEN61EZrJpGC?=
 =?us-ascii?Q?gepWLC2SLnyzHb/hxBllzDSyjHCD3dkh1gAY7Hvph1HJU43dZnFcGSQaAx/p?=
 =?us-ascii?Q?odE1tINXDbjKJ+FRo5TB4ucXhykESdeJxAYlfKrrlvVXx3InPfMHysB66tHp?=
 =?us-ascii?Q?LvwZV2HpIFbtJLoNXeHDlXLtdg63mFLA4GPlQxS5NQ3RCWQ8hm1ccCq5J/F4?=
 =?us-ascii?Q?8D7j3FyYiSULPyCHj7cLqT7X?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c97fb76-b417-41bf-9672-08d94c642432
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:23.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsLLnugwM0a4In1wlkNL6lgbwkXgHlj0aARSSKfmFrVViQVGAk55AHZTl9HL5pQL2MefAmddWIaGDmAgsz1pXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
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
v2->v6: none

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
index 4afba7da17ae..1c1732d7212a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -29,6 +29,8 @@
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 
+#define BR_HWDOM_MAX BITS_PER_LONG
+
 #define BR_VERSION	"2.3"
 
 /* Control of forwarding link local multicast */
@@ -517,6 +519,8 @@ struct net_bridge {
 	 * identifiers in case a bridge spans multiple switchdev instances.
 	 */
 	int				last_hwdom;
+	/* Bit mask of hardware domain numbers in use */
+	unsigned long			busy_hwdoms;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -1839,7 +1843,6 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1853,17 +1856,15 @@ void br_switchdev_fdb_notify(struct net_bridge *br,
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
@@ -1904,6 +1905,20 @@ br_switchdev_fdb_notify(struct net_bridge *br,
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

