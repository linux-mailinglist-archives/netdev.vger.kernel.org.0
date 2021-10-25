Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C2143A678
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhJYW1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:16 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:7454
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233654AbhJYW1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkELetGLdp3Z1kn2k28N/XZE6sIAUVeTYEk/SUHjYHUJ2UPpt1svwQJvEu4BPRQ9Lci1tXGgnjoLEQzDYbZpjdKVl5eAePmZHOrLtXyupGv4IZWW3vvhPxqwB5qWqbNVMMKDMp5b4ciAcvJ5vVd+sZhvUSjQFCmx5XbezV50czzrklloS4hDQKGSUQEM53yruvPZss4CFKeAZzFibqi8GT3bh8SQ7b4S5a5dijsRTb8BG+laxCgQwnZcXFZ47t1wiWNTWWR4kQCcWZ9Lup4CZWQhZhb9DZyRRHHXMcvIPedf35y3x/phQ2bStKRDkIRCet/VL3hKO7dp/mqdyqpQOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5AGbbbjdCgPIh0dKFVvnLyxc/vPxsF7lPQTR6mUiNE=;
 b=kukEXdfC/aLWSPHos991vgOsiPMqECr62xlFG6Nvl67rJG3u7LRdT+fuxmeWZ3gtiaz2hqBMM5itgVCjTreK4boY9KdvqCYCpefqGzH2jX6dmQw6ouYCJFUZFTV4z+HFfha2B4+QC5fEesj6536cR9RWahnXYj/TfJnHsLURVh6RXId82t7jLbkGkDgh2jt8j0oaxEtlyZXF0gkRAFjEapry9lmJW4RXQPCC85qKiywqwQnl0fvl8scz7hGieEI9MUnGSdHoRww5OT/wHSKUgJlhVgol+kBeBCXEDcvwPC2oKy6cXIkoXP4qBP8SvTGEBEIyh7bkbgxuD9F6uEI2nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5AGbbbjdCgPIh0dKFVvnLyxc/vPxsF7lPQTR6mUiNE=;
 b=p8spctmk1mloOXKNPqyfpxF8gNjvN0JZRf5ZrK6rKzPJLNQX68UoVFh0UWKz0XY8Qqj9gM1Mc1ReFNpSpQqkjW9huBRG4V1npEwt/qiCxD1oq8Cyr6ZCWcjr8huGCMEhsoQdX4HxHSk6RpuCYTstadxac+1NOvOJLAnDz05NNTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 05/15] net: bridge: move br_fdb_replay inside br_switchdev.c
Date:   Tue, 26 Oct 2021 01:24:05 +0300
Message-Id: <20211025222415.983883-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0179efed-bf24-4ca4-204e-08d9980639c2
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23047D7ED6A780E222E6E942E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2i9xV7l5LnM0XVR5RdM7dlwScKczqrHJLXC+gw+G2h8vrEXRvalCEqaMgeTatwZ5vXDyDmSrvJl5Sx+IM78B4JOm5DXQ3GwPLrdLGS/sYMmtLlPEpgkHF5dnCAB+5N6/hHmLRJwhFHPSyIuyV9mq5327uVYPcCQAjxIC7n2b4EWRQ7ggqJgEyo/JKQ0OgJ7EgmWH0JlXDrsD34mGMFfbHpYGurkUxa5n8jDhShXqReEy+4fFy9w2Ix2yTil6rr0/2HwW2kDblZCOY7kY4n6i26EGzC+a7d4++9j1yApbfXbwh70DmilnIKM9XaqgJDq8n8n2ErfW7tfiMyBkILGEfP7qtRPUQmn1K/2OASRP7Gu1XvRZdDEbRIZv+VWPxa7Gpw/V5n+T+AaOItzs0zYU/WL549w1GusDmzmmTlAB4wjTRc0j+Lqeemd7ooxrkjayIxxk2SZeuaPBraij+V/5rR4hzjMMnv4LRvRtEIY8RnrVGHPx1qseoDR+OlQR83E5RbgJzFH2YuRRMtIFX2qAqJ2rrFnmZcSwIfRUWFHOWx/XOj2uFT4QoIT7h3FnO5Au3qcy/2myzZLhWME7kixUndAs3AVESdcfu+5IXxtCUbGl2+qN3NbV/wSm5YmseZWbfP8Dl1pEZRqAebEHKCql+ZGhainudB8ndQNCYtAL37NG9HULnmKdjJh0ZD6oPz/ZnWwT240+8W1Wl6X9eTyOQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h43LIf25CVLiIIVyzHFQBM4dkYlK7QeywQX3dtWODjNYxBLEUCCIdHWUnaq1?=
 =?us-ascii?Q?qKZUOThqiaGKfeIL+4OPCOTYGbHDcNHO2lto71Hemwnbu+IAKxD1/Sguub7R?=
 =?us-ascii?Q?JTu4Y8FYfANa6gfe598yPAs6jBkbs9N8a1yIT+ifBwn34uOyoQDcSdDH/Rrl?=
 =?us-ascii?Q?CuKuYIu9UgqCxIEvm8qjMkWq2lnSKj0kRMxn3MvrxHFzVSBy8vMrHZ+MWaqj?=
 =?us-ascii?Q?Aq0V0mQSpKZvhwYJUBNRmAOz7EzA4/5Hi9yRbsmOk+8vvq5TMbLR8DDahfxQ?=
 =?us-ascii?Q?/FJuCpPvsgELjy7tWs03fsOvdkP2UH6DSe75AvzHrDGDMF3chnqYJZ19XlcY?=
 =?us-ascii?Q?nxnHhbX+LHydl0O1VWZPKpt7Y3zAEcJ/kU5lhyUp0MdM+UsKc+TuVWptpB8J?=
 =?us-ascii?Q?1s7EDrHcwmJB54Til3t06BguvvzBqFIf+mkprg/2HRc3f3ZM5FCX5Hu+2hid?=
 =?us-ascii?Q?iJwScvc9ANvj+LAq4i96LH0hYBm92m04ZNfFHFmGg+EHTuxrJt1Y5lyLyNFE?=
 =?us-ascii?Q?+24nZFghqtG45WHiKs4PHEu1isgPsNUa+6uLhZnS1/CV2zW+Fq5ZSG2Lm8hO?=
 =?us-ascii?Q?R5v2ImHg+9aG1LvJ4qfnHfGtpd9zkm5TnWhtNTFy9uR9/6d8Z1JAYglnRzj8?=
 =?us-ascii?Q?ZH+jW0EriFLmNZiKnMxM+XGWipimPSpEhmeim97rW9SK5aZIbHBtpVO/EoUd?=
 =?us-ascii?Q?W8HUlTS8ZX9f61SRcH7ZziXzyS3UcPiIkyKdhhI1rz/N6OD++FSmd9RwEBSi?=
 =?us-ascii?Q?59ayksQnQzgTtmRUm/S2el+1g7OAIG17W8vGV9Dc3kLPAdPvTpNww5biXxXl?=
 =?us-ascii?Q?GqKkiMy1+JwAfiZCvnNuxIwpSAzH3e0miUs2GluneF7AZNpaes4h7PwqAiDI?=
 =?us-ascii?Q?NuMSdjhR5g7HoSYclHBlqssLOLEd7eIYiD/ONxmn0NBLx9nWSCIQ81Fn66cI?=
 =?us-ascii?Q?bzxOG/KPPoIQ/2s4cjNO/X8DV+KIxDOra5Dn4KzGR562VvOCUa4RjAMPctm6?=
 =?us-ascii?Q?0otXhjucXLrPBbrPG+4aB6zvbqhq0/d2VQ/4lXHnqTydFQhjioiKue8RMEv2?=
 =?us-ascii?Q?JjhJGYnuSqkPnt7ZX58lMVwJSxViI0pyG18L4nLjUnvvmuVvYeAN24mnyNnW?=
 =?us-ascii?Q?D6WM5zlDgSVDy0b4RW+EyvxaQLi4jUU+Oe/1Bw6naPiVUYHGXdVUPZAlZioG?=
 =?us-ascii?Q?juJxKheHcHBEP+pBXTJGNW095IgYiYyf7JXKpWMOpwFd2JaYbaDItTBQRCT4?=
 =?us-ascii?Q?UWMa9lcmfz6X8IjWsAyB5DOxx0GSFeY90R+kmHW7vJUNx2HOo9gxyWJyP4qB?=
 =?us-ascii?Q?WxhSZ5Fq5pppAUP5gYVSyBEtVZMlSpsAdRVlAGN+3beSNZspSkmnMqzRkDj8?=
 =?us-ascii?Q?kojbJK7FUP726Lc7ZZU8Q6H9DvYFmDoWkPY++kBOMB6Ux0aRsriH+GmeyrJO?=
 =?us-ascii?Q?Vitc9WsvwzF0hW/VzZJuAxd+qQcum8+jAmjfl/CZ7zEl82vzytnkT2VUqtHz?=
 =?us-ascii?Q?9zxSLFExncLKzeXVCVhlUIL77sLtthW4hUDOsDgbib3ZdF5/lGpisfXMx5FR?=
 =?us-ascii?Q?Rmy6O+tJQva18h4zXFwN/mjcEZc0Jf/xK74Es2+HFhzg7SiwA8dDQoYOxp+3?=
 =?us-ascii?Q?+jlL93bhA56uUSZKsv0p5eI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0179efed-bf24-4ca4-204e-08d9980639c2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:35.7114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXv3oZ5H0JUvL76t48yWzZID0A2FP/vf2dIntBW0YXniLPibxrMEJGLNhzF7DZxqTAC0SM6L8OPU9k8Y+/noyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_fdb_replay is only called from switchdev code paths, so it makes
sense to be disabled if switchdev is not enabled in the first place.

As opposed to br_mdb_replay and br_vlan_replay which might be turned off
depending on bridge support for multicast and VLANs, FDB support is
always on. So moving br_mdb_replay and br_vlan_replay inside
br_switchdev.c would mean adding some #ifdef's in br_switchdev.c, so we
keep those where they are.

The reason for the movement is that in future changes there will be some
code reuse between br_switchdev_fdb_notify and br_fdb_replay.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       | 54 ---------------------------------------
 net/bridge/br_private.h   |  2 --
 net/bridge/br_switchdev.c | 54 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index d955deea1b4d..9c57040d8341 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -756,60 +756,6 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 	}
 }
 
-static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
-			     const struct net_bridge_fdb_entry *fdb,
-			     unsigned long action, const void *ctx)
-{
-	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info item;
-	int err;
-
-	item.addr = fdb->key.addr.addr;
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
-	item.info.ctx = ctx;
-
-	err = nb->notifier_call(nb, action, &item);
-	return notifier_to_errno(err);
-}
-
-int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
-		  struct notifier_block *nb)
-{
-	struct net_bridge_fdb_entry *fdb;
-	struct net_bridge *br;
-	unsigned long action;
-	int err = 0;
-
-	if (!nb)
-		return 0;
-
-	if (!netif_is_bridge_master(br_dev))
-		return -EINVAL;
-
-	br = netdev_priv(br_dev);
-
-	if (adding)
-		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
-	else
-		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
-
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
-		if (err)
-			break;
-	}
-
-	rcu_read_unlock();
-
-	return err;
-}
-
 /* Dump information about entries, in response to GETNEIGH */
 int br_fdb_dump(struct sk_buff *skb,
 		struct netlink_callback *cb,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 705606fc2237..3c9327628060 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -792,8 +792,6 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
-int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
-		  struct notifier_block *nb);
 
 /* br_forward.c */
 enum br_pkt_type {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..8a45b1cfe06f 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -270,6 +270,60 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 	}
 }
 
+static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
+			     const struct net_bridge_fdb_entry *fdb,
+			     unsigned long action, const void *ctx)
+{
+	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
+	struct switchdev_notifier_fdb_info item;
+	int err;
+
+	item.addr = fdb->key.addr.addr;
+	item.vid = fdb->key.vlan_id;
+	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
+	item.info.ctx = ctx;
+
+	err = nb->notifier_call(nb, action, &item);
+	return notifier_to_errno(err);
+}
+
+static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
+			 bool adding, struct notifier_block *nb)
+{
+	struct net_bridge_fdb_entry *fdb;
+	struct net_bridge *br;
+	unsigned long action;
+	int err = 0;
+
+	if (!nb)
+		return 0;
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (adding)
+		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
+	else
+		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
+		if (err)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
-- 
2.25.1

