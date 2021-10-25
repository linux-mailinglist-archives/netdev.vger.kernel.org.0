Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42F43A67B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhJYW1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:22 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233709AbhJYW1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxdQc+voe7vFUD2rwqKCqayI2Ge6DDM00MXQOmUbyCciPrEoFnLwO8seUqmDchZ/xgXaNl2V+GmzHdcP2Hrhz9CiBqnUQ87+isB5SrPCwhuPCpKAcEwix3TigksOIvk9DpRqmrIcxLZuEIS6MM9zb/3oCXQPoNaU5tFwU+sYSXaKab39amyj8R5tHG43O8DfGfVaoz+b/hbUyUOEOMOtL8QRu8O52qjtNEKpd4jI9meDkcWo7UHBYobSbsfx3FYSNnneA4mu9h5uIiCbNfUcb73FMM5aWmLbT7h3sNBza75Hm5A9SRVorvp/00AiY4s9n0xL+lYZMkagMAD8XB6UPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My8Q0DmW8shSEpWA9XdPKVfvL9snaQR433yxNMCpXVs=;
 b=UR/AeSnxijz12/4BW4tulai1QcGGfYvv8/GfpZOetTJWGuD0Ki2OtrkXnDIeqmTeWEwj6UIPYw12Q3IIC66IeOQTBmwGSYyOcmNeSCS8RmITfTlR3W7IlWSCxMf1g/65DjSvFKiS0qmfo6QmDOs9K+ftt/Rc1zoeC6mKLTYgVr7yUvh0PedY9zOfPzWpptxhPkzZ4SSpM+TypBKP2GJqv7OYsfU+pmugOlm16fsilGjPu+BavjUE/itsMBUGi/fp5cTFv0bnVjVtft1998LPilYz+flboHGye9WuMtpWAJOmsK5YZ6k3U9ipVNj0N1dvlZDRzzz+llbyQTKEYNIBuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My8Q0DmW8shSEpWA9XdPKVfvL9snaQR433yxNMCpXVs=;
 b=WHbQ9q251yI2TcpWyfBrBenmHGUmZB355USqKQbXTijQsussheKtOKdbZAS5diNPCfeS0UuitHogWWuw3wqxwdtqRysDFqvJzrJ1I4/jt6CWaSO/i2H6gETtuuXSZYlszlZ+B/gBgym3JAH5YNnm7l6QRkWClhU78AlslbjIyO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:40 +0000
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
Subject: [RFC PATCH net-next 09/15] net: bridge: rename fdb_notify to br_fdb_notify
Date:   Tue, 26 Oct 2021 01:24:09 +0300
Message-Id: <20211025222415.983883-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56a066f0-2636-409e-a28e-08d998063ca1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2304520D35E2C731910A8944E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rl1LT/4MfGwYcgxQhjPBq6thvKgYK71qDGlbbjHEjMvibp9NVdCRE+foJboCJMvw4tl4p6QwyhxT/BiGPbqBrZRl3MuBAdIgTN+u74OHrsDlVhnVjhWdf6LbvXEpCQQ4ECUvcJDYKm19NrYSxrbwGBBz+YU34M5uSxydZHXHxk2k84KMxOIrGhER8eluidJAVXmSn6ODKNLqRNQfw7EoCbHWag+Ny+IwjMPpKXVNQLc7luZ8pmNBrd7GD06W434uu6SMSv3IAjJ4hyDdWTQvfdfIOv1vGnYbqtgXFsrFu4I9LBe81TsF5Ni7FdP1Bw8yXCLR8feay+Sn83biXjmogWrBi8iQE0yZyFHgwvMK+NFtism2bn70SnOmo3tJeZBIMNJ4h/o1GAyybKHX2m9VEarqIL3870A5Jwq9x4O3wCp71G80wazI2LF7ppu1nty93h9lZ6DVMfTE1RIwIZe9iebqn6FXtpB3FLRWf6IyyF4zZCHN78/g4HwCxs8A9BmQmp1BzMc76wefGNToxEnKMZrOXea07EMF1Ciz2Sk56sPblogeb+eXWyHPqUO/Lsuc+l6aDD0NbrNd/ZRZMD/M7blIRWL4gnCgHWKCqPzww+SKZpOqWRpxSxMNvOhHae5yxyUFqHk/Dt6tVOzrDnvFIr98VLCkkMv1dJ5RSSbpklvLNIFDqrHLNQ+9zs1agoAeyf09NbYK+/Pg+2j5kXgiCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tn4NhkPFkn5sGTaFn4xfXqN3CKbeYShmeIGBwg1rEkMHd/ozZoYqpO7kAn8U?=
 =?us-ascii?Q?A1mXe3ZvcWtHjX7q8gCU0p0kjHEMDAH2B79z68qrALYGP3A9/W+nvKzNMqkP?=
 =?us-ascii?Q?C6WoR6ttu0OhSBycR0U7LYWrKPwWsgGtu5DPoLLCCfrdDVOrQonM1M6SgsJi?=
 =?us-ascii?Q?rYqMc2/N/rBmgpTe4cEMJDKFZnn3eBegJ3Zl6+UTsmW9pIUS9XsYWDxEaoWz?=
 =?us-ascii?Q?yn9I03hCJfUcvUeZacMjJ6+Mi00+XBes4GD+Y1pu6v1t8vIiV0LCKdQ5eVCw?=
 =?us-ascii?Q?HCzvUzdC3dPLrOSLaLd3WiHlb54uXLvpUnhHsgIl6JP1FqvNUAeyIb1RJbJ9?=
 =?us-ascii?Q?kSrMYQeclReiKuu91qUgfCDfK66JxQ8gmsiAxw7vRFw7tLJas0yBxP4Eb4T1?=
 =?us-ascii?Q?rl5GE9z62bGs/iWpL2YKzbsKGThixqW+2f8safILbl1qlcNg1Uv6nuj97erc?=
 =?us-ascii?Q?yt0BuBRhR2jo1r/WGt2ciACBlpoec8c8uHS6OHpPyG0t9H97TbtrfrXs3pyc?=
 =?us-ascii?Q?I7pBuCC7glUnUntzd30fqwZXTLS1UGtBDpufqnXOtK9z361w+9qZYvi1En/N?=
 =?us-ascii?Q?9aP3jxnCbT8RsXE+PQEy5Qa98nA0gbZL+DClEBkGCTh2ORUHi1pMOmg2I2pm?=
 =?us-ascii?Q?8G/11O8UcmQXSXWa1ocZmvcZ4oE6843CfR9O/e6CZ+H+KCnz59wZ2Pv40W2H?=
 =?us-ascii?Q?kGLDjkdzHvA4U6y0ZRYW4dbtP/oAfBSVZvT49/NPgFbbSssoww5jalHPFaYc?=
 =?us-ascii?Q?hNiIFqvOj2gNJ7DhMLYdypxXjw9Y3KPzxMIqhjskR6PSjjYboM5R6Fmppruy?=
 =?us-ascii?Q?Fl++1y8fy/33hGwp7wz+SlTtGGgMa5bybkXKX97/tMnL8/+IwUA8BZOS7xaf?=
 =?us-ascii?Q?l/wBJIoPViCzc07jq3CN6VpasW9xafHrIJF3xH2EBwmb/HGUvjiP+Cilf7FI?=
 =?us-ascii?Q?LL7Mv/u/0gLAEF5HIAegBr8gnaSw4Cr5n+bCxub6DvE1y+mzfggdu/7fwSgO?=
 =?us-ascii?Q?iIEep+PFy4EmknVnOyTjqqMRRvXjel9XRP8Z3866peuCN0jZrA3Oj13bPdpb?=
 =?us-ascii?Q?nd7xUo/6nQLAkn/E9MRrhAO04JjPddBMrg7kIlktaV25ROb7EYTuZ2s2BuqB?=
 =?us-ascii?Q?pODVrRjQe3ro/wm9WnlRRI1bu4ucvefRHrDX4IUoEEiBjTKxfvxOCb+4ZnRn?=
 =?us-ascii?Q?6jWyOnjRcHbCFmS9CWrHhFygIvHc8uJLJGeJflCDwQq9qUKQDyCYQimsB83G?=
 =?us-ascii?Q?cRN11H4kf7UlXuin8jGdM26D7YIP0bzWAHbePzp2cNha2AaPftQ1n4IA9rIW?=
 =?us-ascii?Q?YLbeYljDhiIci3IruJlWw9njvoniIpzejklUYqRaKBbIBIg0GMBESVYhQFKh?=
 =?us-ascii?Q?zo8/MoQxNyXPKbEjwWKCaogovT9qom+SOe7qG+C2pt4gSkwRcWVUMpLdEfsK?=
 =?us-ascii?Q?f8aiUXVeDI+KTaYdNXfeje7TprehqBEvIHkLM5XBWuRnzblEQLFQDN5EsAtM?=
 =?us-ascii?Q?ZEzjLcWlXxsggllLmhgs3GYW1etjG014bBl5xC+1ud2knGL8XPG6Pl/iqYxs?=
 =?us-ascii?Q?W85S5RDZGamSfvEmjeUWYnbUJ64GQsMD8DqPxlSjwosjVxGLqTB2aR4yx0sW?=
 =?us-ascii?Q?W7unO6tXeMiQ3XllrVwUziI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a066f0-2636-409e-a28e-08d998063ca1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:40.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NXsnkMP9yD+9BV51sw0HrcXFQXBUxmAwfZUKCX/cktfN3OGrkflnuOEUa7m7gmbAvnkGDs7Gnp6sK5L6PNLeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change creates a wrapper over fdb_notify() called br_fdb_notify(),
with the same behavior.

A future change will introduce another variant, br_fdb_notify_async(),
that actually cares about the deferred return code of
br_switchdev_fdb_notify().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 421b8960945a..2095bdf24e42 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -178,16 +178,12 @@ static inline size_t fdb_nlmsg_size(void)
 }
 
 static void fdb_notify(struct net_bridge *br,
-		       const struct net_bridge_fdb_entry *fdb, int type,
-		       bool swdev_notify)
+		       const struct net_bridge_fdb_entry *fdb, int type)
 {
 	struct net *net = dev_net(br->dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	if (swdev_notify)
-		br_switchdev_fdb_notify(br, fdb, type);
-
 	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
 	if (skb == NULL)
 		goto errout;
@@ -205,6 +201,16 @@ static void fdb_notify(struct net_bridge *br,
 	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
 }
 
+static void br_fdb_notify(struct net_bridge *br,
+			  const struct net_bridge_fdb_entry *fdb, int type,
+			  bool swdev_notify)
+{
+	if (swdev_notify)
+		br_switchdev_fdb_notify(br, fdb, type);
+
+	fdb_notify(br, fdb, type);
+}
+
 static struct net_bridge_fdb_entry *fdb_find_rcu(struct rhashtable *tbl,
 						 const unsigned char *addr,
 						 __u16 vid)
@@ -322,7 +328,7 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 	hlist_del_init_rcu(&f->fdb_node);
 	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
 			       br_fdb_rht_params);
-	fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
+	br_fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
 	call_rcu(&f->rcu, fdb_rcu_free);
 }
 
@@ -428,7 +434,7 @@ static int fdb_add_local(struct net_bridge *br, struct net_bridge_port *source,
 		return -ENOMEM;
 
 	fdb_add_hw_addr(br, addr);
-	fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+	br_fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 	return 0;
 }
 
@@ -534,7 +540,7 @@ void br_fdb_cleanup(struct work_struct *work)
 							 this_timer - now);
 				else if (!test_and_set_bit(BR_FDB_NOTIFY_INACTIVE,
 							   &f->flags))
-					fdb_notify(br, f, RTM_NEWNEIGH, false);
+					br_fdb_notify(br, f, RTM_NEWNEIGH, false);
 			}
 			continue;
 		}
@@ -739,7 +745,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 			if (unlikely(fdb_modified)) {
 				trace_br_fdb_update(br, source, addr, vid, flags);
-				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+				br_fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 			}
 		}
 	} else {
@@ -747,7 +753,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		fdb = fdb_create(br, source, addr, vid, flags);
 		if (fdb) {
 			trace_br_fdb_update(br, source, addr, vid, flags);
-			fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+			br_fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 		}
 		/* else  we lose race and someone else inserts
 		 * it first, don't bother updating
@@ -953,7 +959,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 	if (modified) {
 		if (refresh)
 			fdb->updated = jiffies;
-		fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+		br_fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 	}
 
 	spin_unlock_bh(&br->hash_lock);
@@ -1240,7 +1246,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			err = -ENOMEM;
 			goto err_unlock;
 		}
-		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
+		br_fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
 		fdb->updated = jiffies;
 
@@ -1265,7 +1271,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 
 		if (modified)
-			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
+			br_fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	}
 
 err_unlock:
-- 
2.25.1

