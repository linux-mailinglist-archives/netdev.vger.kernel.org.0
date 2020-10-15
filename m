Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A0228FAA4
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgJOV12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 17:27:28 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:23393
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728970AbgJOV12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 17:27:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ2TD9SZkh4htGfc6OiH119hKIseGt1hhY0O3gHs6+CTP35PiSNR5NDSZxDcbXAmmHG4eJVNCwaL/0+jFfvlrYoscQwAoGKAALfSdtOnk1Ph3E3uKKSNezexH+hcsFPNQ3iW/rVxP2Rjh0j//dk6XqV8AQ+pYF+uSSBB2tN8AwB3TbhTyKCcDzAqJ+84pnJjJoWqvjVlyld1bAFg5O6cUEr0okkQjK89zm9Y5bswlzADQklOR2/+tvgdPLonY2QdKfRCcuOpRIqaoJJkS7I+mTQl8QHE1nZ4YNan2xsjvuJ1Kw7CkZhXzZs2E7XDxTNsC2azK+3jXAIXcICE6kNkSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4WWhh+F+QIZEwmaaWGKAkVXjGpoaKbHcufecyNRXpQ=;
 b=dJi+WjbMB45HGSbZIRxtDVgYxHsCOn9anJYw6uPGnNVh3VC7KK9B61k+2ys/Sg+c6OSuOuvEEMJSlTqWqd4GK8Q6dvguGqJpmyzpIrQOypQ5URNsGh3cpu73AnpLSRCjjykhigu2/fu6+ecDaZkeTkY0FPQZFdomIKbTWfH6Pd4dhnbkUVMXSkco86mzl+8ozbC3al+kcy00v6Ru1FdSkSBAbOC+knLYf9Cl/o0uY8B7FTVsawl9khDfY8Y2aIJS+47BHUNvT54S9t8ZMrxaQ5VliKDGaVd0WXh9pr2d4tsX0DbSm9TUrQE9Y7E423kiLFZJr1FA65yFzuurzXU47Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4WWhh+F+QIZEwmaaWGKAkVXjGpoaKbHcufecyNRXpQ=;
 b=Ebc9t/pAB2ibmFh3H/eJA8qc2kUGJNKxnu/XPdYJIuI9aGXKT8Bb6fkz9DJZ+usQ0efIbJYvicQM03cby+sVm9IG88Woxu0/t2f2ltXWp1Od+EnTWgeB9lnW049DITBC9QAxp1RG5g3v3b256F6y/QrAjF2IxsoRirHZqyaZZwY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Thu, 15 Oct
 2020 21:27:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Thu, 15 Oct 2020
 21:27:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net] net: dsa: reference count the host mdb addresses
Date:   Fri, 16 Oct 2020 00:27:11 +0300
Message-Id: <20201015212711.724678-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR03CA0004.eurprd03.prod.outlook.com
 (2603:10a6:208:14::17) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR03CA0004.eurprd03.prod.outlook.com (2603:10a6:208:14::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Thu, 15 Oct 2020 21:27:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99617907-1ed5-4144-1567-08d871511a9a
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3069CAC1E8497E9336461FD2E0020@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xh/2wxknlN2oPTJV5CZ1Mj5WbznN3T5R6s9DLrkcr2+cmvNkcVk64hLx1bEuwDytpT0DAyciT0+psi2O+BxyqnC57gmSMtre5WmMrUrdf07+e+5GxvVdjC9bLB9es8Pt2XgMOoGoalSRjVydLRgd77tdIdH0gtB8eVCeZDOsVfV1lAH/e2AVsOiW9GlHN9PDae/BTQIpQZ0hZU9AxYXPiq/Li+sRTPqWqRj0ATZGmlUnoY0zx4EnIP28lOmyv8ThQaMTyL/pM+6V+UPim8NFUZBjKIReGwrr9Bb8qYGKzIJMxeKVzEIbpgcJUQu6oISJcMHfR+/W9tXCCPOrmSGVWWyIS+FFYzNXZWCqY3InhZ4l2oxHdfr91pMz5SX+jO4Rhlh345qvQUTI9erM/lAjeB8QaDlLJeAqHY0FuL0adZg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(86362001)(8936002)(36756003)(2616005)(8676002)(6486002)(1076003)(2906002)(83380400001)(4326008)(34490700002)(66476007)(66556008)(316002)(66946007)(6666004)(6916009)(69590400008)(6506007)(956004)(26005)(5660300002)(16526019)(6512007)(44832011)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xrY+ICnvdeNgen48StTv4JxRXOktiohRHQNlBC06dNAzpFDWpEeRekPydkRsYRFZwpKrkRY3bnvO4akgjzKESoLvKE/7G5ghNSISRjeJOJoZW2Bk6zIZLtIV65456FmlOtgi4OO0gYfSiZfSM3eHAnMvwIhnKZ7wwpB0Np0k1mZYmhonXtPuIRBf0AlYynIFEH0bs/QT0LhLONVPqUzioz+LJeETFPdXN1Oitxg1wmTBgsHXyiOo1IZPIBK5WsgkFXPOLkhTRG7hItNjjQ872Lgkcj04xIChM8K34oxpLSkl+8LObY2ZvcFug0Vadyzfx0B2tyRtH2lnkXeMQ7TvjEq/13eXHXT0Oh39OGqJxT4ZO0XKWpfvTYnX9rBQV9zBtOWXMkouzpvsKPOW7pceaC8QYOztkPQaEpXb/HBDSt0RgEWu+uc6D/GJwDlCYTiVy9upFcEPVqvWGuIxncIzpaqUBDOu7VyrFaNKSzjr5EsbRbAppp0XwoFDzsQHUHPd6CyO3TfRtY43Mgfc2qcUpyWTsn5FGrPha253hamxpP+hKW+NyIDAGMQ0908co12xe5thCklznsTWSVEFjo2uBx9OUAoxim6lhH+5ulVWg9uPRwxQWVk7RZqI+qM7o9fR0aAnyDOs0mZfqLGStqk9NA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99617907-1ed5-4144-1567-08d871511a9a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2020 21:27:23.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKYJiqRCrYlL9nH3NfVqAjwtgoNHu6C+grY9Z02KrVY4o371Re4VVvkBsjfsh+QFxzhQ1hslbrAcuF/wdOLZZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently any DSA switch that implements the multicast ops (properly,
that is) gets these errors after just sitting for a while, with at least
2 ports bridged:

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

We should be reference-counting these addresses.

Fixes: 5f4dbc50ce4d ("net: dsa: slave: Handle switchdev host mdb add/del")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  9 +++++
 net/dsa/dsa2.c    |  2 ++
 net/dsa/slave.c   | 92 ++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 94 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35429a140dfa..bad3877761b9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -251,6 +251,13 @@ struct dsa_link {
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
 
@@ -333,6 +340,8 @@ struct dsa_switch {
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
index 3bc5ca40c9fb..1bf3c406e2f8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -376,6 +376,87 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	return 0;
 }
 
+static struct dsa_host_addr *
+dsa_host_mdb_find(struct dsa_switch *ds,
+		  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_host_addr *a;
+
+	list_for_each_entry(a, &ds->host_mdb, list)
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
+	/* Only the commit phase is refcounted, which means that for the
+	 * second, third, etc port which is member of this host address,
+	 * we'll call the prepare phase but never commit.
+	 */
+	if (switchdev_trans_ph_prepare(trans))
+		return dsa_port_mdb_add(cpu_dp, mdb, trans);
+
+	a = dsa_host_mdb_find(ds, mdb);
+	if (a) {
+		refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	err = dsa_port_mdb_add(cpu_dp, mdb, trans);
+	if (err)
+		return err;
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
+	a = dsa_host_mdb_find(ds, mdb);
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
@@ -396,11 +477,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
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
@@ -455,10 +532,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
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

