Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935972D89FF
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404918AbgLLUkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:40:06 -0500
Received: from mail-vi1eur05on2073.outbound.protection.outlook.com ([40.107.21.73]:23136
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726348AbgLLUkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 15:40:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5o+k6/YEQPDERK5vblgAv8UyHuugkuWiBLmk6loWltp5w1TJuscLszJonTtS0qWlUHy6I56agk2g3gr3Ad0ZyB5PrwYaAoMNB0u/kx+wtZaCWCY9d9+oagiS7MnhaLnNBbqQ2YBT18+nynHUUdY2IF79J73KItZExyJ1mo5c3zKiny9+V2ky8Fh3e8UEdVjdXEBE04xd8gd1Gc1fCLIupJornW1EREV6NRuMuZwuNWK+AcaLGBRAIuODEmvTYYN9rKTaesN6SgTTZ0djoYaF+thKLw8OYEXJMQhhww45h6DciRMQRqcxr1oINxToKE9mEQtolVtySr8RS2UMmcm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H71YAJcYR8XzPRYL5ywkhIlIZGhRzgCcJjFvVlFsV3E=;
 b=eUQjWuUrPPqA3J2Wqb+Gj34Nw6u+UXNXzYarkpDgiAXn6bVSQzijXEVTr1v5caTteOzJ9p47BW38E8wCHrWIDg0UDmI9Rg6ylMowTz1gn01MPYW1CSkO12l2zhGJRwu6hIUAoGvRXHF0vccPgkABRY9HgFIm8rpRcAn4je8Nn7t2OY8rykyiURylpWRIy23cZep1ertrqInTlEIVyoKozuNIb2h/E0PaWmPQqdMsu+Y68yiAKuvezJ3OmyyweeykVYhEBk+v+iei/K773+IuVBTLBHUKsZRZosSXmegtF57NWrnAm3QB3zTk/HIB09gVDzGHOAFTxjDOK7b/MiUevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H71YAJcYR8XzPRYL5ywkhIlIZGhRzgCcJjFvVlFsV3E=;
 b=bIz5yaVcKB1rOgh/35Gi77xspdPYYWTrIJtqslb5lov/N9VZRghcPNu1IibCJyWrlNAyiFPANBavVDz7fLZ+9T1tqLY/FpIbOEMkJws8EET5GCyZOWkdE9XEUkM1/p3Dh+B9zZ2YaKERBsrUon9vdoOfDX8CNsWB1B+g3p30g0s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5293.eurprd04.prod.outlook.com (2603:10a6:803:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sat, 12 Dec
 2020 20:39:15 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sat, 12 Dec 2020
 20:39:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next] net: dsa: reference count the host mdb addresses
Date:   Sat, 12 Dec 2020 22:39:01 +0200
Message-Id: <20201212203901.351331-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1P195CA0056.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::45) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1P195CA0056.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sat, 12 Dec 2020 20:39:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a2225fa-e823-4d19-cf84-08d89eddfd64
X-MS-TrafficTypeDiagnostic: VI1PR04MB5293:
X-Microsoft-Antispam-PRVS: <VI1PR04MB529325D3C3BDB50E27B44261E0C90@VI1PR04MB5293.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bjc8wHBH/rsTizvy6+gzHpluChn97x61Vi3vgRr7W5p6t9It2MZ0VPk0K8Q+n6ocN0e/lIvgckvmfep3v0pk9JSXu5bjbt2PS3sU/KcJogx/s7U42OaVwuI/eV8NKVCzfXtXOVXINYKKp9bF13M+0vX/KRb8TkI+2Lxnkb5vcN0bp4A2oH6TABQXuq9Y+O3woeCwU8yOSmIPzwLGPVWFyCjbYMz9d4WqKhnYWSbCrsrQTPs+EvOkFbRrILUPyt/pww83AKp4YFkwvSilwlOzQTwATRQMaP3b7TL8DY8tfjTYbmsbroKw3MjDh3f1c9BPsO3i3eR2AFrz9/Is7kf6YwR7tf9a2YO2zshtPedLJ4f583i8J3zNlYwalSNuO7jz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(8936002)(6486002)(66476007)(5660300002)(66946007)(69590400008)(52116002)(83380400001)(8676002)(6506007)(4326008)(478600001)(956004)(2616005)(26005)(86362001)(54906003)(110136005)(44832011)(36756003)(16526019)(2906002)(66556008)(6666004)(1076003)(6512007)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+sJvGypTpmnJC4CeLaCfq4mnmcjd5xtpbnOGoXqbM+KlU5KsvtP2Qn1+7O0n?=
 =?us-ascii?Q?qKwgvAq8R7ay02HUWXEUDeENF8F99SqF5Kq4yAdu9fLrcj06sPqUi6FBoiNr?=
 =?us-ascii?Q?0Wo4KoaD8CzIqmjjRU1eRZirdj9u9F+nemN5X2EnTJcAoV2zglN6LBPTYhws?=
 =?us-ascii?Q?Gpm8znQzDoKqWB2YhZWQAuua6lXQB7zCVmBAoCcgmManHTuhcCSy1mTbjJc4?=
 =?us-ascii?Q?cECZwor5dorTZU8uv6YpbryCs1hurFxo+CxMAd3h0o0RyheBWsEi7wnxSeRq?=
 =?us-ascii?Q?hUzuUfZJjnphLFybBH1VjbFikGkeSn8g7MknvBYlA9rkHJI6cu1vUKc//CXG?=
 =?us-ascii?Q?CcWp4E+HgE76S2oaPbzxQsjpqpAFTrC6RrMJtAkqYdNNbNCHrMfSKgAm4B0K?=
 =?us-ascii?Q?74t6EBHo4L1FQyVwaAKtHf3FmVfwLrfuNi/t6yMVcU02Ev98lAeW0TgxiDyM?=
 =?us-ascii?Q?sqUIn6sAh5SFnh2zwzkp86Rv4BXqPVQPNYjtKkaMGSZpbvQi7iwkt7JjWWAA?=
 =?us-ascii?Q?cP3YAVJbp7gi+AJRhRgw+SBlGNxLtxOREuAmxP8ZuTWq2Meapu0FmuX1p/W+?=
 =?us-ascii?Q?vGhygQeBq8f/XdozGYBunt/XLF7X1lwA45HFnscyIW+0BGEcxc59fMywSlTz?=
 =?us-ascii?Q?Gzva9s1p7H4ZQWxOgb2BMIbT1uZuAUWG5ZtCpoBhtmexT7XBuis9Xi6pve1w?=
 =?us-ascii?Q?Y61utSKrbrwi+bTS8enemeXVcPqDMJ/tb8x07MMwk/pTdpXHtKEbScLjcMBM?=
 =?us-ascii?Q?Wk1afBv1Fe1pxxOS3Q8iOv83m1xbYmFIAgKLGSxMlgpbvC4DX9iCd+jZBJys?=
 =?us-ascii?Q?hBtZ2kuQmLnabK7ykMoWCVW8rFdVaF24qXgbL/waGAUvABl6gXUqTz9yv1FI?=
 =?us-ascii?Q?Muf1a6LffYMHeXPJTSb/NXfViPOMp3YeAa15lfIf3T/tuho+M6BLd6aPO0/D?=
 =?us-ascii?Q?eEOqBj+cKFY3PIvi0Sq5+LqfOePQfsKajdqlglCAQr0Hr9miINNsHXKRo2ll?=
 =?us-ascii?Q?Vx5M?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2020 20:39:14.8049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2225fa-e823-4d19-cf84-08d89eddfd64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LAj7VsoWcl8a/AInKCYEPNrbmTSZq4jKRUqsFnygZL7bzxELAwAv1uTQoxvGIcLwYsWNq7BBChV14A7WBjPTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently any DSA switch that is strict when implementing the mdb
operations prints these benign errors after the addresses expire, with
at least 2 ports bridged:

[  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)

The reason has to do with this piece of code:

	netdev_for_each_lower_dev(dev, lower_dev, iter)
		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);

called from:

br_multicast_group_expired
-> br_multicast_host_leave
   -> br_mdb_notify
      -> br_mdb_switchdev_host

Basically, that code is correct. It tells each switchdev port that the
host can leave that multicast group. But in the case of DSA, all user
ports are connected to the host through the same pipe. So, because DSA
translates a host MDB to a normal MDB on the CPU port, this means that
when all user ports leave a multicast group, DSA tries to remove it N
times from the CPU port.

We should be reference-counting these addresses. Otherwise, the first
port on which the MDB expires will cause an entry removal from the CPU
port, which will break the host MDB for the remaining ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Allocating memory for host mdb in prepare phase, but setting refcount
  to 1 in commit phase. This complicates the implementation of the state
  machine a little bit.

Changes in v2:
- Re-targeted against net-next, since this is not breaking any use case
  that I know of.
- Re-did the refcounting logic. The problem is that the MDB addition is
  two-phase, but the deletion is one-phase. So refcounting on addition
  needs to be done only on one phase - the commit one. Before, we had a
  problem there, and for host MDB additions where an entry already existed
  on the CPU port, we would call the prepare phase but never commit.
  This would break drivers that allocate memory on prepare, and then
  expect the commit phase to actually apply. So we're not doing this any
  longer. Both prepare and commit phases are now stubbed out for additions
  of host MDB entries that are already present on the CPU port.
- Renamed dsa_host_mdb_find into dsa_host_addr_find, and we're now
  passing it the host_mdb list rather than struct dsa_switch *ds. This
  is a generic function and we might be able to reuse it in the future
  for host FDB entries (such as slave net_device MAC addresses).
- Left the allocation as GFP_KERNEL, since that is fine - the switchdev
  notifier runs as deferred, therefore in process context.

 include/net/dsa.h |   9 ++++
 net/dsa/dsa2.c    |   2 +
 net/dsa/slave.c   | 128 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 130 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..e639db28e238 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -253,6 +253,13 @@ struct dsa_link {
 	struct list_head list;
 };
 
+struct dsa_host_addr {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	bool setup;
 
@@ -335,6 +342,8 @@ struct dsa_switch {
 	 */
 	bool			mtu_enforcement_ingress;
 
+	struct list_head	host_mdb;
+
 	size_t num_ports;
 };
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 183003e45762..52b3ef34a2cb 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -413,6 +413,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (ds->setup)
 		return 0;
 
+	INIT_LIST_HEAD(&ds->host_mdb);
+
 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
 	 * driver and before ops->setup() has run, since the switch drivers and
 	 * the slave MDIO bus driver rely on these values for probing PHY
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..e0667be7d5ed 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -376,6 +376,123 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	return 0;
 }
 
+static struct dsa_host_addr *
+dsa_host_addr_find(struct list_head *addr_list,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_host_addr *a;
+
+	list_for_each_entry(a, addr_list, list)
+		if (ether_addr_equal(a->addr, mdb->addr) && a->vid == mdb->vid)
+			return a;
+
+	return NULL;
+}
+
+/* DSA can directly translate this to a normal MDB add, but on the CPU port.
+ * But because multiple user ports can join the same multicast group and the
+ * bridge will emit a notification for each port, we need to add/delete the
+ * entry towards the host only once, so we reference count it.
+ */
+static int dsa_host_mdb_add(struct dsa_port *dp,
+			    const struct switchdev_obj_port_mdb *mdb,
+			    struct switchdev_trans *trans)
+{
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_host_addr *a;
+	int err;
+
+	/* Complication created by the fact that addition has two phases, but
+	 * deletion only has one phase, and we need reference counting.
+	 * The strategy is to do the memory allocation in the prepare phase,
+	 * but initialize the refcount in the commit phase.
+	 *
+	 * Have mdb	| mdb has refcount > 0	| Commit phase	| Resolution
+	 * -------------+-----------------------+---------------+---------------
+	 * no		| -			| no		| Alloc & proceed
+	 * no		| -			| yes		| Error
+	 * yes		| no			| no		| Error
+	 * yes		| no			| yes		| Proceed
+	 * yes		| yes			| no		| Ignore
+	 * yes		| yes			| yes		| Add refcount
+	 */
+	a = dsa_host_addr_find(&ds->host_mdb, mdb);
+	if (!a) {
+		if (WARN_ON(switchdev_trans_ph_commit(trans)))
+			return -EINVAL;
+
+		a = kzalloc(sizeof(*a), GFP_KERNEL);
+		if (!a)
+			return -ENOMEM;
+
+		err = dsa_port_mdb_add(cpu_dp, mdb, trans);
+		if (err) {
+			kfree(a);
+			return err;
+		}
+
+		ether_addr_copy(a->addr, mdb->addr);
+		a->vid = mdb->vid;
+		refcount_set(&a->refcount, 0);
+		list_add_tail(&a->list, &ds->host_mdb);
+
+		return 0;
+	}
+
+	/* If we are in the prepare phase, and a host mdb exists,
+	 * then ignore it. The refcount will be incremented during
+	 * commit, if propagation to hardware went well.
+	 */
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	/* In the commit phase, a host mdb might exist either left as
+	 * unfinished work by the previous prepare phase (this will have
+	 * refcount 0), or as a complete entry installed for another port.
+	 */
+	if (refcount_read(&a->refcount) > 0) {
+		refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	err = dsa_port_mdb_add(cpu_dp, mdb, trans);
+	if (err) {
+		list_del(&a->list);
+		kfree(a);
+		return err;
+	}
+
+	refcount_set(&a->refcount, 1);
+
+	return 0;
+}
+
+static int dsa_host_mdb_del(struct dsa_port *dp,
+			    const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_host_addr *a;
+	int err;
+
+	a = dsa_host_addr_find(&ds->host_mdb, mdb);
+	if (!a)
+		return -ENOENT;
+
+	if (!refcount_dec_and_test(&a->refcount))
+		return 0;
+
+	err = dsa_port_mdb_del(cpu_dp, mdb);
+	if (err)
+		return err;
+
+	list_del(&a->list);
+	kfree(a);
+
+	return 0;
+}
+
 static int dsa_slave_port_obj_add(struct net_device *dev,
 				  const struct switchdev_obj *obj,
 				  struct switchdev_trans *trans,
@@ -396,11 +513,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		/* DSA can directly translate this to a normal MDB add,
-		 * but on the CPU port.
-		 */
-		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj),
-				       trans);
+		err = dsa_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dsa_slave_vlan_add(dev, obj, trans);
@@ -455,10 +568,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		/* DSA can directly translate this to a normal MDB add,
-		 * but on the CPU port.
-		 */
-		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dsa_slave_vlan_del(dev, obj);
-- 
2.25.1

