Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B155E43A676
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhJYW1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:14 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233385AbhJYW1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DssVRUdhI+HFt78Z75IA6eKGNcsgTyigqjme6NDHfRf9+y9QsOpdnahhhJnT/TlHImVE02IZ5g98R6j+rgUvnFhF6Ou+2EeYXDFvtJe/BmBbEvujtc8WZH2bgVdsv7HKTx4fEpg8wte+NEITJWb078e0S6CY4gFujoNdX68JSeab/vxr7DKnEPXJRGKRcSz/2ShO8WHVZUJFeiBdJi+EDOJe8w1B0biXrIJHZSWDJsBFiO4fVOre2suXjDqqewrKir9l2t5AyknP90BNZbrRR2DTvN4HyeVKlLzgQ4l0YHP3AxR+zKwSc8zGUsPI7SSxJNy/tzcs/JYgWh4O3wDJ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5nR19mNnV8u2H1uvZkP9pWk3V2t74K2rRbftmh1R8w=;
 b=XExqGnBjrQuBkdrFtM2i3g00ZTulR1Qc1gum5pwOXYfD9QnFYPQ1FIiPhw2N3X54Q98mtBKSspE/PU95R62Ck9taCg0du7HVpBmNDfntWz6ymIj1+1kUqqYTAnpwLDhzMyqULAhCvBiqmqytVgD7IGoUO7fktc/4uJmG3+n7AQZHUanKhXBAvnKzLhHgpXKR9hmFCpzDfoORlM376r4YISjcSA+kgOj/KpXSNNvuHwosrm5vkVkhQRmZj1s7tVyr/Pq+O0zut2786SjFJhX78u3mwLJhIwxKxfoIIiw+1Dg2CieKgUYH9x+P2qzcYbFzKs+MCBv4+iXSHqLDfQeleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5nR19mNnV8u2H1uvZkP9pWk3V2t74K2rRbftmh1R8w=;
 b=PCat8hRu/igqetmhIzlOVWA6wpUqJjk+ZvPnro3v3U+0O+RPRwPqDMaUWjp5wgYnK9z/DKUASB63Gx1K8tPJd7/Gk3Wd9Qv+AW0h3pUo9qkXYIPQcoqreFIIpUHnezFELr6X4J16imGc+M6QbuLWYrzvrp03rvbkAIDOFQd3Q6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:37 +0000
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
Subject: [RFC PATCH net-next 06/15] net: bridge: create a common function for populating switchdev FDB entries
Date:   Tue, 26 Oct 2021 01:24:06 +0300
Message-Id: <20211025222415.983883-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e85b7ed0-6322-4ae0-b815-08d998063a7b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23044416D46CEB7100928E74E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHC61hxMPuuzTWZVLU6vHxcpZ4b2oIZ/PLxOKAUhGSQgDYKB2Vp7K44D4aUDAWguf96VTDkU8z1WRRnGETUqk8wwnoTrSu6Hurr6km3q8UlkTluPnVhcXMz56Niq/ZEWHPbk6beNSl40ztnH3PHvMGD2HpOzEy6XhXKfDvtiVU828jef4RL9W9MMwsg1gGPvaUk9l0F6IQGG9WKSfmN1NVDCg1eb8OQqoT/xJjWNOFEG1DPEwT9skARp/qKOrCeXPO9d+5Kdq3XlyJTZsUpire78CQyxpBad4IsDDZHKR5XgSr7iJ0hJhSle5okqAO0Eg8razXDdFnpIo3b19LZBMONK4SDYlOotwKdpqUGBXXeOFFLHbpTP9zO9RwO3gTMLa5lJrjLPPyekQCmg2KVuTF781MUBfp+bbR7bR9i/NOsFlquE3jis4oiQ4H1E/uofluGKYOxPkGWjV7lBpVCrVGSH4BF9Uau7dg2jrZQZmcoCXW0ePOHvq+KjuIVGo+qAIAygjjxNVKP9bKcQyBUCzeEgZM99UTcv+T/KTQq5XV/PM+X1qvy/6gk+hiKsIVCJ28MhFQVSpb5viCvtT+fFAHqE6vpDKi04hct9wtBWp58fVTuwSNR09WaSCCRAlwteHWpjTFu/94IpR/evlgshIrp82npjOMPgHHDLi/C10cuKEqSdTunJ/W7leg/RfDNRgFkr8VrY/L7ZBMFuQbKaUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?05Wi0ajJfjBHs/lghl0qjnLZg4UOh3SWmR0Ej40F4CLBvfXXmPRjvo16ILmU?=
 =?us-ascii?Q?j1DGNssLKEAg8xrqoIsP/elVS86LAcvmWLq+E/BC9JF2TlU+/YCwzRDWtq7M?=
 =?us-ascii?Q?/+QHyi+cCXipmrg9yGcjB+luI8UnknwmhMHisWaBanp+6v8me97tkj9wzdvC?=
 =?us-ascii?Q?H6/BmDsMBvmwubKvZwlHBxESEEAcqiepcJEJeo8MlSF8L+BiO8K8XJJALl/b?=
 =?us-ascii?Q?g8+y6fuhyO3Ll1XjgeU1MdCAx7nmC7A9XKPckU9HVqrrSb/2oxnUV0E+voo2?=
 =?us-ascii?Q?7aAv6WsopwZgYf3nK00QixS5domBVZOg/WaKZl1gVEwRhLbYQUWHKHRkpDJQ?=
 =?us-ascii?Q?Vz0uzooBM5gulUsdxEVfe8/5cD3SwlFtM+zJ9YAnEHu0KpBbRpvZrLGnxUki?=
 =?us-ascii?Q?kh39Uej3ul1pxs5bpXhrNKC8fkSilkecedOrVqbgmIdgwsbMtu1P8NmKpUiw?=
 =?us-ascii?Q?hBVuy0MCH3mnom2gWrhgL01ISbLKl06D7SfUTFn7REPUK4581ZJOsYQlWWYr?=
 =?us-ascii?Q?VEB0nA1x0rtM7psu2g2BDaIw/XcDN0hKSl8YfBs4oiYY0Y3m/h+BX3u+Gxr+?=
 =?us-ascii?Q?4gHi4xwf4Q9ZUdw3TlprCiowqq8ePuzDqweYyFDFexbTWqijC1+Exqp3hHYh?=
 =?us-ascii?Q?v6UeioBOj/cSWId1PlgjtSWS8f1zN/fi/ltB71VW40xX783S5NZuY16ejP11?=
 =?us-ascii?Q?tsUOBql2Yo9gGQelGs+Z2+P6fytb90g8MTZr3wSDazeqq8I5CMoBTWHZGIWk?=
 =?us-ascii?Q?+AGvDyTSrHdSTnG0FUicDBi5UjdxeiicBMdsdOfYOqsIZyagjj+mJNdhk9AB?=
 =?us-ascii?Q?AhWHzuzmP1oA7lc7b9ooAXpja+qThOtkUsimUcu45F1xLJpbV9KGus159rjb?=
 =?us-ascii?Q?1vxTZE5Y17srmN593WrBMA7qJu4wEft63awSM+k6FlTGaXjGf/7QYxHiYIJW?=
 =?us-ascii?Q?dVuJCT1l6Q4by6DyZllDs2HjKc0cLkd+MHbFPWZEWp5DylS1N7ANHvcj+vTw?=
 =?us-ascii?Q?xEHpCBGSdSTlyYL8sDsd7sInK6f8i1vaYxXBehEVZOCoe6yBOK9pZwb5Z9CZ?=
 =?us-ascii?Q?OgdrB6bvW+WqNHfmiqRH4ESxS6DAAhz0EOiJ7T+aPuoWXHL5xfbpFxOvnLYo?=
 =?us-ascii?Q?oCbkeVsIvi7c74wuMPZUqu7ompxhKiXnkoHd/Mi0LCgnn4YKVzJL0mdh1LEk?=
 =?us-ascii?Q?ve/p9SEY/oQBaqpxpbrvgbYbUIptgjMD2kvaBcP8wJwtTK6KN9vfdqj05j/m?=
 =?us-ascii?Q?jz1T95tfnURw0WyeuzDXScLZeuqND8IaP+BAlnPjCmg01ejHNub06vCvFVCk?=
 =?us-ascii?Q?ecuQ1y9KOksW870yceWDIo/yB+rZrC7izcoZUcgaIIlvJrYf8yOkYbCeqcUo?=
 =?us-ascii?Q?KPbpx12LGX7PUNWoFJju/ow5pstVkhP/XyGpHSCI5KN6SL1eysZ5H+H3ta5q?=
 =?us-ascii?Q?hljZM6//PJh79eblgXq0gXuf5kq80lbtvPBFZDGK3lCv25DFLP7cdgObs6zy?=
 =?us-ascii?Q?J0p++JIN+1tNhmqv2IJY9apF5j44fjO2B5YgmIuoitZwGarp4rF47rqsu6/7?=
 =?us-ascii?Q?lUkDwNyiiymqULuzN9uEtXABYILg/N5CeJxnG9/zjKdK3mlJogPSMlDDfmks?=
 =?us-ascii?Q?fvkQSAlhOWPwm8EDGZsHnaA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85b7ed0-6322-4ae0-b815-08d998063a7b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:36.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsZgHclFnJkAzEPB/bBwNOgckM2HTT9h9rTPzh9qwfPtYFfvbYC0scKCrCT8wFlnd0VgX7BvlzNU4NfiBpnYwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two places where a switchdev FDB entry is constructed, one is
br_switchdev_fdb_notify() and the other is br_fdb_replay(). One uses a
struct initializer, and the other declares the structure as
uninitialized and populates the elements one by one.

One problem when introducing new members of struct
switchdev_notifier_fdb_info is that there is a risk for one of these
functions to run with an uninitialized value.

So centralize the logic of populating such structure into a dedicated
function. Being the primary location where these structures are created,
using an uninitialized variable and populating the members one by one
should be fine, since this one function is supposed to assign values to
all its members.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 41 +++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8a45b1cfe06f..2fbe881cdfe2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -122,28 +122,38 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
+static void br_switchdev_fdb_populate(struct net_bridge *br,
+				      struct switchdev_notifier_fdb_info *item,
+				      const struct net_bridge_fdb_entry *fdb,
+				      const void *ctx)
+{
+	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
+
+	item->addr = fdb->key.addr.addr;
+	item->vid = fdb->key.vlan_id;
+	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
+	item->info.ctx = ctx;
+}
+
 void
 br_switchdev_fdb_notify(struct net_bridge *br,
 			const struct net_bridge_fdb_entry *fdb, int type)
 {
-	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info info = {
-		.addr = fdb->key.addr.addr,
-		.vid = fdb->key.vlan_id,
-		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
-		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
-		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
-	};
-	struct net_device *dev = (!dst || info.is_local) ? br->dev : dst->dev;
+	struct switchdev_notifier_fdb_info item;
+
+	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 dev, &info.info, NULL);
+					 item.info.dev, &item.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 dev, &info.info, NULL);
+					 item.info.dev, &item.info, NULL);
 		break;
 	}
 }
@@ -274,17 +284,10 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 			     const struct net_bridge_fdb_entry *fdb,
 			     unsigned long action, const void *ctx)
 {
-	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
 	struct switchdev_notifier_fdb_info item;
 	int err;
 
-	item.addr = fdb->key.addr.addr;
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
-	item.info.ctx = ctx;
+	br_switchdev_fdb_populate(br, &item, fdb, ctx);
 
 	err = nb->notifier_call(nb, action, &item);
 	return notifier_to_errno(err);
-- 
2.25.1

