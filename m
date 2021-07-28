Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0198E3D9548
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhG1S2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:28:08 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:44162
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229920AbhG1S2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:28:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWW06JcqLrgsPR2sLKlRN4OAxwh14U4Hrv292OF3Hg40L9xaZYOTOvraOPIFURNUeVTlaJ1DtqF1AWRceKjP3FPjbQx6EXw1sZDyksbTbWyVaAHhQXZkLcrR79InJgsO640Mrw8nQvFQIOMcFI5Lg0g1HitbO25aTz4wCl+I9xNFwOPyfUpsFWjimiIDFNtTez1BybCJHYxCLkBxQ0Q4rz0dqHrFr0TILavWJSaWZejjQdbFSvIOX6JdthR769SLp66Q9alsdLghlvjPx2nN0SyBbAIo3qguityPGwZc0CUtn9L+EZLzTYadmaEOdKSr79PBfA1yly+/ibo9v1oRjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Mtyt5e5JJ4RJhHzDG3g8Pi/s7ua/LJ0XzW1M+9PJ+c=;
 b=Ys9wfTdFJjbDcKnmUqazSMzHYIWhYMt/9P+UYasDIHnfikKhCNXknqjSwEi9WU0VFn87C/Sp9NocF/nd+NPWaTzRzx22hHSzbXb7NGaY0mDn3ZehkrC5TD488K/Fs89vwuKRexsR74N8khOJ3UwL7RBAWU8nfdAwv+JgZPQb6dkD1hCDhkZ9fM9Gv1KqZ6+n22IWLX2d8ABZBHnQxErxMc0+rEFW9fxOAbjeLqKPbsCtSjRdu2IPghujFrxkKN9rC1mRGYFnjX8Yux8QhCeNuMIAd1Zs7u9X3+uvu3s/IqsmkZo/qRDl99iw+cQrs+Ok58WxlUja1Eric9fFbDVMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Mtyt5e5JJ4RJhHzDG3g8Pi/s7ua/LJ0XzW1M+9PJ+c=;
 b=mJ0MJJ5/U2Qeyjil+3wYSTS7klYH3gk7iNgDwsk/Ezan8DjKUvALCU8jtYWRfmx5ox0ZJP8G8UYdkazHxS7oEn0ydC0we/7Ec0kA+WdgD+p6nYEMs8HNa+vg2hlbzA6EaezpuruMObkNUscV7e20ljZzO2IJzOVh3fAtMcfPoDY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 18:28:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 18:28:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 2/2] net: bridge: switchdev: treat local FDBs the same as entries towards the bridge
Date:   Wed, 28 Jul 2021 21:27:48 +0300
Message-Id: <20210728182748.3564726-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
References: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Wed, 28 Jul 2021 18:28:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 872f395e-12e0-4450-9407-08d951f57036
X-MS-TrafficTypeDiagnostic: VI1PR04MB6944:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6944009F2BD6CDBC7D16810CE0EA9@VI1PR04MB6944.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JkG6H0nG+ZH4Fi6J60rv8aZ7F6K8zbNJ0WOaH2YrWHiEsEji/uYtvDp/iA38GzTIsTdG8eHbs8qOLmgSWrH4K6rVKi6uXw1tWnmokCc3xZgbKXKlKvNJokdfNblQ6ouw6MQl/3y81/vmj1YDEPe6nSlJrJIBcCiPvASrLww61h8JD0mvKOZ9sPbN4lxjL4UmZW9djTm5dRjMs4Zq5J+PsBvNwmu5u+P9t+IivguLeuBcThZRjgEZRQB/lfE8YEWyU6BSVcZVzGaL3fpXseitTzFK7o1ECIaqi4LU1TWgzu4fjJy+E/WH6QY37z7KmfmKQsdIECUPf/R/QASv2ukUIG4tKVNHthRSUGAr2tRyDpPEvWBIl8rxSchpV8Sml4h2nPtoqCr3Wy6v5bLRZwIXDToeb1jJwEsrb6UXiD7XoIzozofC7CVFhL1JmaXPnLIqT/Qn2WW9KwTaoWmp4liqhC4gamRd8PrT/t5pYcRloicMYJQho0zChoPuu4AeVzcIJttdFrgwBc5vuVKvljGAfk2Kmo6DfIaW6JuiSEn/gCY12qDOsdlOILrCutObDPPQj7hSTgG1EPJjnGlKuEoVYmFQpqUNDywIXCXTXbnpVtIbNH4EEmk6SISka1XUwPFzRyAd3DT1aDOc4hW/zGLabJNetiKBVRm9Ii8u0cFeo5Ct84EBenJQznmjaq6H2DIwYAB/aRX250gBiLrtCTVG4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(346002)(136003)(376002)(396003)(5660300002)(8936002)(8676002)(478600001)(1076003)(2906002)(4326008)(36756003)(86362001)(83380400001)(7416002)(6512007)(38100700002)(44832011)(52116002)(38350700002)(66556008)(110136005)(26005)(66476007)(316002)(956004)(6486002)(2616005)(54906003)(66946007)(6666004)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vyg49f1sgIDG6b2e0BqRFTzBdITWp/NlCPrtaOqhnIiH9npdHA8q9MXPlp4b?=
 =?us-ascii?Q?UmgAd+wS7A4+GE82Isd1VV4Qou1PzvGBmEQt6kUrhbhs8G8RFDSUpa+bRFBB?=
 =?us-ascii?Q?lx9h7Ctxuy2uUwec2fW3uQrUnxmMyEFytrWsfwzgwTZDbNv6YKGze58n0rL3?=
 =?us-ascii?Q?xl7wzGy4BYgAxlyNSYUVhrBRKR3S0xHmo5PemxM0134yEBg6xpl5aHdTX0Sd?=
 =?us-ascii?Q?Xl36jq6Rqgy8saRaCipzknuPB9NWeu5ZuYeiNvQ+NiNU/AgamOhNerXvhUnm?=
 =?us-ascii?Q?BCuxYBIIiTavDA9lpoXYHAzBRiRk64gZsNw+12nhfU9m73EBqZIqaT9S2QJn?=
 =?us-ascii?Q?/SC+ptq2sK2d4MC5QMsnmH5SmevrsRGbGN9fnlRa9OQjGAB1huvv/r46Ouf1?=
 =?us-ascii?Q?k8PeOiXqaI53fgf93kBhTZXaogttTbZ6NlE0EGD52EQVefafu0Tj5SkYNgE1?=
 =?us-ascii?Q?dNiNH35zGnf7C9Sms74ORTdzaiP5Nh9fO3OAUk7yBtVhg9osvH41M1FOBrQs?=
 =?us-ascii?Q?4WhNna/MEPfG4H7PECuZ+srPGgzHLCc6acC3uzK0h83kvND+B/XCDNyyBlm/?=
 =?us-ascii?Q?eyO6U28CLSvKBVth5J0HrBpYAybshBw5WSkh1HzexMCc3aZQ0xGLTA18hlO4?=
 =?us-ascii?Q?WnXX+lXMD6xnA0iQGAaE+XNm1u7wXO9hOsOvCybFPd/9aGiN5qLqbfkEsVX2?=
 =?us-ascii?Q?w+QDqVNb0T9le2nku4GGMQQkQx3qXMuoCAgOPp/uF6nlaA+Uy01u5xHF+J8L?=
 =?us-ascii?Q?yLZx+YGjj34M/BoWG2gMKsPiT0ZjZPvN+VT3QmuUNjxK35bck+qrzGwQEedE?=
 =?us-ascii?Q?utxmltRv7WyPiiqjxocmj+EW4VzQP0hd0OeXT+o1JngzgK0aEaWcXnqAH10S?=
 =?us-ascii?Q?FgytmwnU2WfiShwy9zgwbCYe/LNw98dcVqOL1nRTrSeMlP2pxsO6uWXD6wbp?=
 =?us-ascii?Q?kkT21V7FPUba9VC/8g+QOpsFfT+9X4GIud60h/zMraTk8iwIIwM4kVQbr6n+?=
 =?us-ascii?Q?R0BlHe7lfPsZWm170mxwrRPBBYm2byMOfpWCyhHAwCu2XF9Tir54MG7qReOI?=
 =?us-ascii?Q?Nbp48wS/pLlAz6Jham1CKr3gvoPfsIg9bp4mi8J+0ycsylmeiqqJsP0+cu7x?=
 =?us-ascii?Q?YQLo/0SllM8MVppW+xMKaSG38Ytm7oEVt/K4MFiFLIrY6zNB1pASZryCpb7R?=
 =?us-ascii?Q?cI686L0OQ6exllwFphEpV1TFdwhPyd8nJ7ZlzPNN6MZ1PglJqpKFs5+f+v8A?=
 =?us-ascii?Q?BJd203/vjB+VvrK+VJJfJWJwgyzwNgXTS2DmE7EMxAaZOds0ugRHoD6KrbZc?=
 =?us-ascii?Q?PG2/E/aGuN686vpwhzCW3qr4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872f395e-12e0-4450-9407-08d951f57036
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 18:28:04.3456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAe6Xq2KuGfdRlSjD7kMAR50vE1LLq8aJpzY777Xo82ZFhCDiwML6RifRKxMzoKxLL5g/u9OKg02hKPhFr5e/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the following script:

1. ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
2. ip link set swp2 up && ip link set swp2 master br0
3. ip link set swp3 up && ip link set swp3 master br0
4. ip link set swp4 up && ip link set swp4 master br0
5. bridge vlan del dev swp2 vid 1
6. bridge vlan del dev swp3 vid 1
7. ip link set swp4 nomaster
8. ip link set swp3 nomaster

produces the following output:

[  641.010738] sja1105 spi0.1: port 2 failed to delete 00:1f:7b:63:02:48 vid 1 from fdb: -2

[ swp2, swp3 and br0 all have the same MAC address, the one listed above ]

In short, this happens because the number of FDB entry additions
notified to switchdev is unbalanced with the number of deletions.

At step 1, the bridge has a random MAC address. At step 2, the
br_fdb_replay of swp2 receives this initial MAC address. Then the bridge
inherits the MAC address of swp2 via br_fdb_change_mac_address(), and it
notifies switchdev (only swp2 at this point) of the deletion of the
random MAC address and the addition of 00:1f:7b:63:02:48 as a local FDB
entry with fdb->dst == swp2, in VLANs 0 and the default_pvid (1).

During step 7:

del_nbp
-> br_fdb_delete_by_port(br, p, vid=0, do_all=1);
   -> fdb_delete_local(br, p, f);

br_fdb_delete_by_port() deletes all entries towards the ports,
regardless of vid, because do_all is 1.

fdb_delete_local() has logic to migrate local FDB entries deleted from
one port to another port which shares the same MAC address and is in the
same VLAN, or to the bridge device itself. This migration happens
without notifying switchdev of the deletion on the old port and the
addition on the new one, just fdb->dst is changed and the added_by_user
flag is cleared.

In the example above, the del_nbp(swp4) causes the
"addr 00:1f:7b:63:02:48 vid 1" local FDB entry with fdb->dst == swp4
that existed up until then to be migrated directly towards the bridge
(fdb->dst == NULL). This is because it cannot be migrated to any of the
other ports (swp2 and swp3 are not in VLAN 1).

After the migration to br0 takes place, swp4 requests a deletion replay
of all FDB entries. Since the "addr 00:1f:7b:63:02:48 vid 1" entry now
point towards the bridge, a deletion of it is replayed. There was just
a prior addition of this address, so the switchdev driver deletes this
entry.

Then, the del_nbp(swp3) at step 8 triggers another br_fdb_replay, and
switchdev is notified again to delete "addr 00:1f:7b:63:02:48 vid 1".
But it can't because it no longer has it, so it returns -ENOENT.

There are other possibilities to trigger this issue, but this is by far
the simplest to explain.

To fix this, we must avoid the situation where the addition of an FDB
entry is notified to switchdev as a local entry on a port, and the
deletion is notified on the bridge itself.

Considering that the 2 types of FDB entries are completely equivalent
and we cannot have the same MAC address as a local entry on 2 bridge
ports, or on a bridge port and pointing towards the bridge at the same
time, it makes sense to hide away from switchdev completely the fact
that a local FDB entry is associated with a given bridge port at all.
Just say that it points towards the bridge, it should make no difference
whatsoever to the switchdev driver and should even lead to a simpler
overall implementation, will less cases to handle.

This also avoids any modification at all to the core bridge driver, just
what is reported to switchdev changes. With the local/permanent entries
on bridge ports being already reported to user space, it is hard to
believe that the bridge behavior can change in any backwards-incompatible
way such as making all local FDB entries point towards the bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       | 3 +--
 net/bridge/br_switchdev.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index be75889ceeba..4ff8c67ac88f 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -737,7 +737,6 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 			     unsigned long action, const void *ctx)
 {
 	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
-	struct net_device *dev = p ? p->dev : br->dev;
 	struct switchdev_notifier_fdb_info item;
 	int err;
 
@@ -746,7 +745,7 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = dev;
+	item.info.dev = item.is_local ? br->dev : p->dev;
 	item.info.ctx = ctx;
 
 	err = nb->notifier_call(nb, action, &item);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8bc3c7fc415f..023de0e958f1 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -127,7 +127,6 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 			const struct net_bridge_fdb_entry *fdb, int type)
 {
 	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-	struct net_device *dev = dst ? dst->dev : br->dev;
 	struct switchdev_notifier_fdb_info info = {
 		.addr = fdb->key.addr.addr,
 		.vid = fdb->key.vlan_id,
@@ -135,6 +134,7 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
+	struct net_device *dev = info.is_local ? br->dev : dst->dev;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-- 
2.25.1

