Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD102D8993
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391223AbgLLTGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:06:42 -0500
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:33878
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726314AbgLLTGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:06:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7j5VajETzPvERriS3yB+FmieyxAp5drHuwZAg5OsZ6q4G5rwe9ZLrceN43pmxBwgrk70ZUSM0peQkbE5SVOVIpsUzI8iJJ0xN9rPdlWyLvMJB/e/ejNpepGBOetAIZmlxq9x338fZqMXqcMOl82+Tzk3QxUdLV5y9gJT0sl0GnomW1f0Xqy5LOhOttREaepkikv+CDaVE3TZ7dkxZDHChbp0Vqm5VJHxh/hArHEBKEOu/OTcwrTVAqiONcbm6a11so7GtIH+3JNJMnU/DGqYmda6SKKQCHS4rpBB7DbMM/1TGSfdjeCDJVfpUWpkB0MNGjgKytfVpwoRFiW0TsTMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x78Bds0X4R7+AYu2GMAtlRZ/dbnla4dcZ9NgOsK1jPI=;
 b=fskPlBIWuJ1v4QrT5cM8HSkpR8WWNErPzaUtX/Uw/vT0iCZ3hc6wiilz2xtNcjfNCdlK3lg1aNgwSEiFiQzz/UyiQ5UtxTv/zw3J/I0OwMVkkItOijCu2CO3vreDRQLUmdVi4tO02H2ngTIoXMIspzuqsYi9tUNDw3TMpKWwMPk8uIDmIG6X9ENNVv+ygpX16CH3Saqkb8S2yuk4cFaG9fIEsI0NsDxxf6CGGmBguyDJb/xvRqP8HGBSBL5pkadcZBvezuZsFfkGnuLFKqmp74+IwvwVuErTc0FEfIN4bW14Uud25wracCyPCpNkEPr8aCjaqUkHHoXmxkl3ifosUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x78Bds0X4R7+AYu2GMAtlRZ/dbnla4dcZ9NgOsK1jPI=;
 b=adsA22f9qtTjyNbqTXDO3AhLelwsZN/oODA6MjuPVY/8rlMZBRXPOjb4tTGFvaKwXj++Qv+S1O5fz2KipN9qkKYvklMpEOomeK8zGbpXyYhCyHhzzz0ey3goZ02bLqoe5t+Hj5KqnXkUiGXtP5bmumOlHL45e3xV/mbtc+QtHUg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6512.eurprd04.prod.outlook.com (2603:10a6:803:120::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sat, 12 Dec
 2020 19:05:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sat, 12 Dec 2020
 19:05:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next] net: dsa: reference count the host mdb addresses
Date:   Sat, 12 Dec 2020 21:03:52 +0200
Message-Id: <20201212190352.214642-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR09CA0112.eurprd09.prod.outlook.com
 (2603:10a6:803:78::35) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR09CA0112.eurprd09.prod.outlook.com (2603:10a6:803:78::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sat, 12 Dec 2020 19:05:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 922a05db-48ab-4d19-5340-08d89ed0e817
X-MS-TrafficTypeDiagnostic: VE1PR04MB6512:
X-Microsoft-Antispam-PRVS: <VE1PR04MB651271A685C08231B9CF911BE0C90@VE1PR04MB6512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYT9SQT5W72/odYRGsFNz1tW16aFbfin4Ky7JZG5eTqCOyoIO0MvqwkSJRk/SqzPFbZFgiyR64i2/gvnaqBx7xoAH5HHvewHFXNEUJ82tByrPAA260asd7sZTLtBYWwzqP3jZvewr4vowsVH0CZvTRDv+r8OjJoq+Q5BMyOZhxtsjZlX/YawWa3aMCWAs/KjX+LPgDTACzlwR1ZEipFu7uLPO5nvuTmdxmZj2F2nXXYhqsl/NuG2dMrUSa/04CqGWeXGv/bfI6nHyjjUCsOSJJoOtu42rGxjsa69av7PT9nA5IJGQHONihtDyh5hn/3+CBHjVEHBsP0FDbXbAf73CqtEWcQNNK9J38tKDa5WxT9JRNCMn9FX8osf+nRZsM4B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(4326008)(26005)(6666004)(478600001)(6512007)(52116002)(66946007)(5660300002)(54906003)(8936002)(66476007)(36756003)(110136005)(44832011)(83380400001)(2906002)(8676002)(1076003)(66556008)(86362001)(16526019)(6506007)(186003)(2616005)(69590400008)(6486002)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?raKOl8pwLS92rJtFpuFc96kXKQsvH9gJrx8N5AfOkZtVyG+WFxQfPEDozW7v?=
 =?us-ascii?Q?K8+V+rShj4yhTgYBXHyyeOHva94bwnemtv3O7LhPpirgquC82vf7zy12E+9o?=
 =?us-ascii?Q?4mu/QdEtreKlkwiQfZkkYHTr9ekkMvuW6rUd7aMi/tBhqk8/GAarSO48MI9Q?=
 =?us-ascii?Q?4SGkbn7JhnlmEcKSdb0nvPCe9cz73zTbnZaEa98sdDBS5gdyqanQYs/OVKsX?=
 =?us-ascii?Q?4Ydmr6zCcm47kanNw9/6xmelsy2MCjvaPZjiJo7Y7zjiu25dV/cewEn9b5aZ?=
 =?us-ascii?Q?gjCeMglbq4EhaTRUJ8IgeMb9Ktc+9FynQmqvM02d9a/m8d2KsD1vqBCJWqFh?=
 =?us-ascii?Q?YtzTIN8Izi8kb6xkB7qHXYcs2IjM5LT0dTlKXMg9vjV+Zn/fTmcXATY4co97?=
 =?us-ascii?Q?qy1TRqdgtgzdHqeaf6wX18mmeO+sGhanFNtIONvoxe8VgNTgPliTmAxfLB3d?=
 =?us-ascii?Q?Q9WxtK9qtHmkfF11pyIps1bcXQUiOJOdFzZwt8k8E64fJtZR3kbGyIpORj2f?=
 =?us-ascii?Q?zjPe82lVW2oRPg4pUt6njHS2OxUiIhx+RCMdTpL8dthApgdsN0KBUt6rUTNw?=
 =?us-ascii?Q?H20cg67uOzjQMsmgu8ctnx6SKb0NdoaT5irHu6BOOhbZsTU8z0PZ7Rp1FVCn?=
 =?us-ascii?Q?gsLS9/o8hKH1aWNeBsVbMZAawkdkAkAnIGJdR4Qznr2n7xwocnRKnmGXonA0?=
 =?us-ascii?Q?W03alulIJ+8s6+ybP6DGHf22k3YhcN3cFxqKDSKczroGj8Aiu5u94yJUZ0zW?=
 =?us-ascii?Q?enmzh3+pMC6u+gVcf3CcnPrl8PXanATud9p2rAA7hcMF57rW3XBdPbyBDkvL?=
 =?us-ascii?Q?Jor2Mhq41pXb9W5n7CgtI8848cFVG6vEMwtCNTmJO+O9LNxBia4Ij7vpehcV?=
 =?us-ascii?Q?u8kNEZ5hFZyNf1mlMtD8YNG0IXHYNXQee4fAkUzSLhty7ceVwBzdJ7pX0PB7?=
 =?us-ascii?Q?XkoXRjpRdbu4LpSB9FlM06mplYAiUzg9866RsbExmS2uIzSdwXIBhehNQm5q?=
 =?us-ascii?Q?1bY8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2020 19:05:35.4575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 922a05db-48ab-4d19-5340-08d89ed0e817
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtUneSlPgLfBL2/V9SUPrzRSFebwn0XBQIHhGY7XkJlnBXOfqH1JKQ1ix0Qz1Fwl65r5qrSmvJiOh9uAe2dTiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6512
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

 include/net/dsa.h |  9 +++++
 net/dsa/dsa2.c    |  2 ++
 net/dsa/slave.c   | 91 ++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 93 insertions(+), 9 deletions(-)

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
index 4a0498bf6c65..ccf397f02129 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -376,6 +376,86 @@ static int dsa_slave_vlan_add(struct net_device *dev,
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
+	a = dsa_host_addr_find(&ds->host_mdb, mdb);
+	if (a) {
+		/* Only the commit phase is refcounted */
+		if (switchdev_trans_ph_commit(trans))
+			refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	err = dsa_port_mdb_add(cpu_dp, mdb, trans);
+	if (err)
+		return err;
+
+	/* Only the commit phase is refcounted, so don't save this just yet */
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	ether_addr_copy(a->addr, mdb->addr);
+	a->vid = mdb->vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &ds->host_mdb);
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
@@ -396,11 +476,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
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
@@ -455,10 +531,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
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

