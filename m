Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08343A671
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhJYW07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:26:59 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233044AbhJYW05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:26:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzKmfnZSG+57lh5J39dynY8XvPG/6YKEhuNoARUcwg681AoqYbW+EzqEhxU5WElvVjbhUXSgDm3nbihnZf/cz4fDUTL19Kflg1vLm0/kjURXo2SCc6SPe9MoyTqXY54DLtAA3p4/9vKu7EHI+okUw6Or77Q6Bgf3LcMMvAHHupSgtrUzC0MwTy2vB8PcmVCQwpL+KeS2IofMWjBace0WwG2Z50RFQWEn5IdR3vVopMvjTMqNp7bE46YSFufnzU8lS5N4jTZUaqqUrVeTlcg1OVjP0FJTlB/WY6iCEBOlldHBdObqhgU4kWNEL7CnbOowbqYZyP+heri/QULJjKPnww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TR2phey9KYaWl4WYVySxK1GFhAJSnMSmJwVBuj+yxQ=;
 b=Z7rkpg/ILC3FyL9NYBrjgL8GOGgiZ8DEsvlq0TfGXWWJpdaytZ04/PL5wI9BwxTvlhD6kueBUP6+ZDHH3q4JMYjHOx7N5Dt86j0D65lbzfn7igKZ3Ejqf8ahISVj1a4F2q1Ae4WcOUdP0j1NgPWMorP1wUNxmSqWBw+Fq0V33i62eDjow7O19kxBw6AlN4GkSWeoppF6FOGyoawYMiXX7FyBDZvDB9mi9kGp3u5b9djssgCn5t/WX43EexaL72t244POP+FFuLp7chJIdxqDjPN0RJWKcUlojnoKD1/oODBg6G0Tn1e4wNurIPamky0BAdpbuSKak2xQaWq2SEpUqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TR2phey9KYaWl4WYVySxK1GFhAJSnMSmJwVBuj+yxQ=;
 b=cknSU0Q27e9O4IdqE7rkGZtcsbeZEJVXJjNfBS7fukGdc5cQ1zv3BYirP9pt9x9j2ch8jX06bLr80b338U70aftHwm6/EouXgmAly9qcfKF44e6bgKNEjloWbsNrZo2O1xnMoMgkKbGMiv+Cu7IX7QJAl+VMEgkHlk8FvHrU9R8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:32 +0000
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
Subject: [RFC PATCH net-next 02/15] net: bridge: remove fdb_insert forward declaration
Date:   Tue, 26 Oct 2021 01:24:02 +0300
Message-Id: <20211025222415.983883-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b042cac-943e-414b-e7bd-08d99806379b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2304DD70AEF6BABD9953F052E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:215;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4WZQgrHP3xm60Hpm23O7IypCY3TcGTDFS7tq00zpl9VTim1ytl4APLr2oBAEPtC5Iu6U96JDZ5TRGO1eYz5NHlo5ud22Zx/hVGuV5cib4vL9edl3zXqT5EQ49dQ/JJO6dTqkw/SouO63CnCItUt9PD8dZ/CYo+RC87WQtyPVd4c9j1ft4JNqcMbpvTGFiR9SLC/K/muugoUWKSw11XInBhEz/XKaq57vt7Y3Pe90cRnEc6gBSWAPu3Kl4JsDgSifZPYhUjoAoFE/be5dpLY/WXRucCNsFV+0ut7k8TyaUM9WYIa6P0XTWLMYvHAnNE1m8LkGzFdkRIfSPfZGy8HXM8Ho//rkfd1vi18jh7AzIrwQpHWqmjXix+r3hHjWlDivBeB8y5YhwWxb5Mw/B23azAsbmUrA85Ww7BTZyyyBuCKkb5N7vMpCdxo7UZvk3mWVkreTVB9yVGZLXcbZ0v3MMv4MRKGpYThkT/oAqAMLATR8FXPlKA750bK6scfwFD77yyCQWQCV68h/3hBc2NbrpiR3e4nVR70M102bc1QI4zL3ALieywBI0ZEAggiwrP7rOo5AItV1xXdA7/5KD5UW9v+cUteO5Lt4MmggVHkw7JLfdjvQyYytOk7LkCrpWyL2qfEfsvzM7WiTi9ECgfo6HZnWWTlVd+DJj7SVhHHzBu650p1hgXK48bwivotqTeivwlDEujW7R6xvcWzGmC+qUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QOI7j1wLTYpVkHXBvPy+MtZE8l7RzjnBp47h6tTTF9wOYOsSJTB55F3mtRV2?=
 =?us-ascii?Q?JmWU9C0aul0QJZNyXjsMDUGu389mUbue2zkitg99T0ucVS/VJBaunQ3iP7Qp?=
 =?us-ascii?Q?yb9JZhwY4ftMsO5VvrNaw4wkDkmT5dCym6wSco2rTx9OPZwKQV1/fGNojQuf?=
 =?us-ascii?Q?kdP2HCQm/rdlxemdw9E7PRQvJh59TZLnCJy+gViY+hBrHyEIM7NfRmpb//G+?=
 =?us-ascii?Q?oIaGn/X7v/TqyFmOwtquAflWt0XNGI+vdIH0d4wS3Dw117d3qGx6P7vwPP3e?=
 =?us-ascii?Q?ok2wM1ttQJIQVkQ7FLzUrxbNUU4N1Ks+DbP1Hx4gkOQUMDoQpAnMhC8qA6NH?=
 =?us-ascii?Q?g6WQ02GZpLrPxY3UDZbLbPfLevSGsJaNsNs7i4QzUl1tT6oasoIPRAZOyDrN?=
 =?us-ascii?Q?WKKzExGT0JCWXExhOt7d7PKaEjlOUqeGinvVMxchy4WaPjHArd7fRTWs/UTc?=
 =?us-ascii?Q?65RSvqd0aZVvKzoeVYL8b6aO8hSSt0mt/MXfq4R073QLFqYb73kBX66aOt9w?=
 =?us-ascii?Q?hWab0P09N3rJZEm/R16W5g20uk4yKwOoP9tqEYDAHfaWsAmMJpszC0FzTNC3?=
 =?us-ascii?Q?CN3gg5XKVzW9xWdC6PUZc3L2HV1820n8hdm6ayI5yE+Af7jc6X1OrM9yYf7e?=
 =?us-ascii?Q?ia1POcNNYqN7Yo8T3JY6Odpj2bdzjv+ggfyLy0AjgbUVoG0fXEimMZ9/68Gc?=
 =?us-ascii?Q?7MyGEB56A3W+d6DZ4mbASBVKw9PQanVIA7KMkJBADdyaTsn4zmZmvPrq+yZm?=
 =?us-ascii?Q?wILAVNeln0/UWMsjwGS4GYL59L72MrDUa4KnRzdhDx9LqwUB3rLxIhT4+Ugo?=
 =?us-ascii?Q?dfWvYx+KmgAYMOZw801w2HJSF09lDub9/OuK7rj4wvj6Bo1zaIDVav/naTfe?=
 =?us-ascii?Q?6y3Dnzpbq8jP9eyyx+ve/rTNjNRsyrnBYKa3VHtK2GZQNi70JKF+y4aG7UXs?=
 =?us-ascii?Q?5SCSJKbc4546IaiBvWE7FR1ieKBLMQtS16IDX6biEE28rGUJ6dgGL4TxW4OU?=
 =?us-ascii?Q?SCqRFLqqaoQDO6AY5gV4spbMqxv81D3kYDWlja4oVaRCemWTLdpKGZCSKEfD?=
 =?us-ascii?Q?8tOAdV5LnoJ+OS+hmM9IBQGRCGlilVBtOG+zyiht8E/m5iF0gNrt4EjHTXqj?=
 =?us-ascii?Q?miP7BaI9+xYneDYLrDGV/qlLxconkx21ZI37GPtVkyh8J/0ZILYUS3s4DgGm?=
 =?us-ascii?Q?kU7EaXUqgiTx+ejbrdPNcVnFGWnf2xjXz+nmFqQN3NoLMTD5IEGvWqrkrrG+?=
 =?us-ascii?Q?uqtVfGRZAmoL8e1uYKKC7wdwGHX20LYHe28qDpGCf7WnEDl93S5+tco4uQnM?=
 =?us-ascii?Q?re/1j1nlcNHWauO+a4g4glo15I8vDGKcetXg0UvcpeVV7jFfhPOlxE7F+OyL?=
 =?us-ascii?Q?GfP287gN8S/MmQt5LICmBuCyQabelyfGS+DlOnJygeWmdJ099YWCWnxiRoEm?=
 =?us-ascii?Q?mLoDarP8fVAe9cjZ3GSpV3YJKu/Dp/2S4h+GWS7u2R1cIbPApe7KiHzsZKJY?=
 =?us-ascii?Q?MmlraKpbkwlNzr+NJgaSgzKfSqYHrNDMiG1SfiECRLm5MF5cUiJZin9Et1ZO?=
 =?us-ascii?Q?1+RxvzC2upGI/YOmoEKfbhfoCt2TpLpdNsoaQyPWuOzflWXM33uhK7wqH38f?=
 =?us-ascii?Q?guS8y3qfujnuNwt/0Av8u1E=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b042cac-943e-414b-e7bd-08d99806379b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:32.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwRVbf5vAfxIUnKGTcrSCCWq7v9GGWLkZsWIEQBISqVFii+xQXhisnQQ4EqQNHn5kOkfyPAaocTHE/zbbjEjdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fdb_insert() has a forward declaration because its first caller,
br_fdb_changeaddr(), is declared before fdb_create(), a function which
fdb_insert() needs.

This patch moves the 2 functions above br_fdb_changeaddr() and deletes
the forward declaration for fdb_insert().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 116 ++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 59 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index bfb28a24ea81..4fe2e958573e 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -32,8 +32,6 @@ static const struct rhashtable_params br_fdb_rht_params = {
 };
 
 static struct kmem_cache *br_fdb_cache __read_mostly;
-static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		      const unsigned char *addr, u16 vid);
 
 int __init br_fdb_init(void)
 {
@@ -377,6 +375,63 @@ void br_fdb_find_delete_local(struct net_bridge *br,
 	spin_unlock_bh(&br->hash_lock);
 }
 
+static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
+					       struct net_bridge_port *source,
+					       const unsigned char *addr,
+					       __u16 vid,
+					       unsigned long flags)
+{
+	struct net_bridge_fdb_entry *fdb;
+
+	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
+	if (fdb) {
+		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
+		WRITE_ONCE(fdb->dst, source);
+		fdb->key.vlan_id = vid;
+		fdb->flags = flags;
+		fdb->updated = fdb->used = jiffies;
+		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
+						  &fdb->rhnode,
+						  br_fdb_rht_params)) {
+			kmem_cache_free(br_fdb_cache, fdb);
+			fdb = NULL;
+		} else {
+			hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
+		}
+	}
+	return fdb;
+}
+
+static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
+		      const unsigned char *addr, u16 vid)
+{
+	struct net_bridge_fdb_entry *fdb;
+
+	if (!is_valid_ether_addr(addr))
+		return -EINVAL;
+
+	fdb = br_fdb_find(br, addr, vid);
+	if (fdb) {
+		/* it is okay to have multiple ports with same
+		 * address, just use the first one.
+		 */
+		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
+			return 0;
+		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
+		       source ? source->dev->name : br->dev->name, addr, vid);
+		fdb_delete(br, fdb, true);
+	}
+
+	fdb = fdb_create(br, source, addr, vid,
+			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
+	if (!fdb)
+		return -ENOMEM;
+
+	fdb_add_hw_addr(br, addr);
+	fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+	return 0;
+}
+
 void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 {
 	struct net_bridge_vlan_group *vg;
@@ -623,63 +678,6 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 	return num;
 }
 
-static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
-					       struct net_bridge_port *source,
-					       const unsigned char *addr,
-					       __u16 vid,
-					       unsigned long flags)
-{
-	struct net_bridge_fdb_entry *fdb;
-
-	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
-	if (fdb) {
-		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
-		WRITE_ONCE(fdb->dst, source);
-		fdb->key.vlan_id = vid;
-		fdb->flags = flags;
-		fdb->updated = fdb->used = jiffies;
-		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
-						  &fdb->rhnode,
-						  br_fdb_rht_params)) {
-			kmem_cache_free(br_fdb_cache, fdb);
-			fdb = NULL;
-		} else {
-			hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
-		}
-	}
-	return fdb;
-}
-
-static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		  const unsigned char *addr, u16 vid)
-{
-	struct net_bridge_fdb_entry *fdb;
-
-	if (!is_valid_ether_addr(addr))
-		return -EINVAL;
-
-	fdb = br_fdb_find(br, addr, vid);
-	if (fdb) {
-		/* it is okay to have multiple ports with same
-		 * address, just use the first one.
-		 */
-		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
-			return 0;
-		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
-		       source ? source->dev->name : br->dev->name, addr, vid);
-		fdb_delete(br, fdb, true);
-	}
-
-	fdb = fdb_create(br, source, addr, vid,
-			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
-	if (!fdb)
-		return -ENOMEM;
-
-	fdb_add_hw_addr(br, addr);
-	fdb_notify(br, fdb, RTM_NEWNEIGH, true);
-	return 0;
-}
-
 /* Add entry for local address of interface */
 int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		  const unsigned char *addr, u16 vid)
-- 
2.25.1

