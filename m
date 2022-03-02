Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D234CAE66
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbiCBTQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244976AbiCBTPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:53 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3505255BDE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/DiVbeJiZAeoUKBGh3Nhyyc53mMJGE7DR7J9trZGStvIwQXQAp6th/Nc8iUGRCrUlEukLj5iXARKgkPYWdgym5ck/CPW8CY95buY2LFTVwwRQqQaMOF51s5+u4IWfNIhXdLPsnCb8xyiDtYQBHf2UOC4OzCZtwx2wHZav0w+0TQTDIVcrEyWE4zzDjifAd+JvAZv/DgShBAMh4ESHwLEgi3d1Z9Fk+bVsDwJuxS3zlTT/BsidkXxA/a/Y8dxnb6M13C+akpt33RUlXQd4u2BZ7fmLiNXitbJRpVBjTaY91fSp7YyI0yoi06seoQWyKEYEXQDEeC1rZS+5CpBfjMKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H15loXmpIPvmLVp1dEov1ouG5sWxo6iNDAXBFWZv1eU=;
 b=T70JE3Iqfaph+Z/nkjU5JJf1obt9y3l14Z2eAZ7yRQbhPqrPvCQRNBwKyt+ZFL99bIh+w/sbDSDakeFDQ8dYf/w0mJTRr6THYvKS1PmZgCYZRV3CYK+hBG69IrwfyMj1JZA40X6EuHE+9eGUT/gf/Oi5s8EsURIWsGozRR9F5va6XewD0Hc5FN8VkbFo9j19treW+HSDa29Ufe4+Nw3KVO1OrbCZyeSUkDtBrh1KY7J8VmNJPnQZB/9hwfgSRkL6e91fgNH3n7/rZpJVCfAZJ8GRw74fbtMbtFC3J5RxQD4YKyOWsR1KEfTHc/hHFs5cH+R7g4tVKdhmAFX1ebKl9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H15loXmpIPvmLVp1dEov1ouG5sWxo6iNDAXBFWZv1eU=;
 b=KzxbjLTDiHiVAEYjTXayE1wMx2BAmoC8L/Rj5hRkdvV3FB8MOifrPd0RvLzrhPvxOXdHJs4fWvFTQDelZRQalV8Dvcf5QtDi5zZZgKHJAYFr0j/V0CIvwLg+NmpEcyNIhcMCk+Z2xEOaxvV0QRmty9l/a4Eith+2Q0HocdFp0O0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 06/10] net: dsa: felix: migrate host FDB and MDB entries when changing tag proto
Date:   Wed,  2 Mar 2022 21:14:13 +0200
Message-Id: <20220302191417.1288145-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9e09302-d85c-4f67-6a6b-08d9fc80f15c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2911522F922C0F22D62F960BE0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: diRnLz3hV6lC23tSgtQNkLLz25D3EGR+AUDcPogBKz73XSzqqeq9JxiGvYZgOzcaSN55D1HKiCvpBOw/culmCzT92R5uo2g0P4y7MQKlwojCp8NFYNtxURYuz0h9w7ljveIU3DpPMlQnp+e/dHCBM/DE0lp6ANufs/5jkIsO2YFr0QQsUpdJ+0Xf6JSmPRbSyg8bJ9Pw9N2C6Bgoe1W/0tYt16s7BnAQAcUZ1Cb0C4PZonibY3ay7p8vdrEj+p4XtjILRI2eWacNFMufa737DpomD0us/Jcs8je/XtE+ikKA5NVMTwj+qi4nyjA/b8UKLBrQnjgBDPG29/CxVpCrKTRBEIFJ8ZgHtBLYcaYFF8kFKsrv7jN5LD1XeXvClgSV7ThQm9YGNpHk8JO/fa2UXnizylX6rIbOcxhsUL6iIXLG6/NmHcHf4l0yRkhepQwSoldk7yUG97LeFB8azO09J8YmpnMmhEqJ3cNgIBqnSFg3gBVYxDyKk0Sz0yaKhHVk52IAHTBTpSDUen0Gr5kxfqGc6LedwxE/F487yXUql9GMOoneXPspHsIbxrruvntF3TVjhUOtARXFzvO3gunJePoG8d+p8v8rb4coDQ5UsTgkV3NNZAw7uf8CfXuLihzO/D7j2nk79mQusEmPSz5mTRSSTQtROnnycii96o1gpcnQA5Vm+u3rNVee2Dff3rFBMHU1e5pTupbmDnIC0cmfag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(30864003)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KdqWjue2xvicO1mxpRB9+tP40TH4eck2W2c6j5sg8/3XVoI5pqW0pmLhO9TD?=
 =?us-ascii?Q?1xSTN69eKHNTh9K9XLXB5fOGzqg+loKn6P1mr2ABui+X+3k5/aKD9J9dNXmU?=
 =?us-ascii?Q?bSwcgKb+UzuOk6zzO2v+iUtmPz8dnDjJjXqFjrpM8OinBrKSwhjOtWSYdNFn?=
 =?us-ascii?Q?tKACx/4zFamW59n9v/tLNI3HbQ9YtB1kIuQ9O+HOrDCmmKezBbmz43lDGfER?=
 =?us-ascii?Q?f8gPBZhbvwFti0Geg6UcOeCGNQpCbiYmIkAfenHM2BR+g+g0ABD/vTejl/8V?=
 =?us-ascii?Q?08OWkxj3A530g5t/hfE77F4Qgssj3aaIBfCrtl9etpFyNmuwdxgd3fki0/sV?=
 =?us-ascii?Q?GyJGADvCHVtVhs0hKJwtzmFnF9Yc57zN1qmCjwOPmUyFBmhDBDao08RVbhDt?=
 =?us-ascii?Q?8DW7/DgW4cNV2Y9IXJk1WrblXAkwB3iB5/VKBR/uyjw5yWOJyN9ytoAy1YVT?=
 =?us-ascii?Q?KPkN3A1PI78dTkw4QGkpxgSySjE5tNaN57kiNDwKEmymf5A1iwYdvQhZEEvB?=
 =?us-ascii?Q?OT+KOD69V7MGo60uUlocdnUwJGnI6UxXzE9J4gq2JIH8bPgJJhmu0ItEEnRQ?=
 =?us-ascii?Q?aPD+DiAC7GsjEzXhQqgblc6KM60YZkKFHvstvltvKHk7B+WbXnqaDJlSmJtZ?=
 =?us-ascii?Q?Pyip3gxAWx0zlOF9oTkiwipWGJfEglmN6bCN70WlWnw/3uaxvUsM08QVubcz?=
 =?us-ascii?Q?Tu/hzvDs/Hy5EnZZgj9kjaQlYKVfK8wS+IC0YzXZbFTs9GQz1zvMGm0AFnqn?=
 =?us-ascii?Q?ovmpr7tXLxG5xdg44WKyRmkRMgppIIaM8pAW7Jy2WxHRwbnnS1zvhN4IrfZ7?=
 =?us-ascii?Q?iMllydvMQD6j6Nr7MpcJjAjPiSW+1sjORM6kDfsNfjlLIvOiNpbPohP62yAv?=
 =?us-ascii?Q?IIpoh0u7nE/mQZ7XofbvKa3s94DMFyXSx5NhRk1gnrgGLN+53xyj2K3kAakS?=
 =?us-ascii?Q?POrWRAZWApTOsCCgVvBHumka2twNZ6iSGTW4uY1vjjfSPGDWH0TdBLmfpV82?=
 =?us-ascii?Q?t+85CJ7To179BH8WBhojAmjcbEeZqrIOMWysk0cRBk/gwKUjAFrIkgd3TurH?=
 =?us-ascii?Q?QMAY2mZ9sYhVxXDe+IAclMeFbNgaO+nLqie/a+Jqubex0bKfz74aCtaX3E1f?=
 =?us-ascii?Q?36kalzJBKHEqknL9kLY6puCld+KsaLfheSZqMZDm5TtluAjY7KYEYGNwFJMv?=
 =?us-ascii?Q?4/OHyE4nju5a6KmrEYVKCsbZsM5nvHAO77S5st4yfMFIcL6kZBGi8IFrb0Wh?=
 =?us-ascii?Q?oG67xLDQUHqC9J38utTgZw/m0APdskM5RQ6vFnjxR1uAX038ZnuFwbdJe5uq?=
 =?us-ascii?Q?CTQZVP4M0GzWXkhK9IcRhY6YRExHqiEA3UUOvMaQAIOByJtEOdgI7ldGsyoP?=
 =?us-ascii?Q?OyibNQsJASfy1z83OE0hKykq4/gNcA32kl+besBMFqWUsfOoumecOi65W4Oa?=
 =?us-ascii?Q?FzMS/piXUEBYz4DgK+0s2OAz4AmIq9+1rxpngzb/SQq2SsahIOhy+bFF3eEA?=
 =?us-ascii?Q?03Fx3+ciKSQ9bMDjcUgCleBDKrCXmYpuB79XiGnTAV5SQkcxW6EZK75Po1Cm?=
 =?us-ascii?Q?EmyQUDyliLMhEdGo44EoowSFPvnWV7hMC3R1+bJ8K2DW79aROCf5h9j5johg?=
 =?us-ascii?Q?eQ0XpWkFpzB1eaeiEPuMPDY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e09302-d85c-4f67-6a6b-08d9fc80f15c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:58.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T592e6WzJq5unKA5z9MKrvBI7UTxS8ealt791sEoJKAT4hiRT3rGQT7CCZb56h3GSgYkq0qs1ac/gkeK+oDrGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ocelot" and "ocelot-8021q" tagging protocols make use of different
hardware resources, and host FDB entries have different destination
ports in the switch analyzer module, practically speaking.

So when the user requests a tagging protocol change, the driver must
migrate all host FDB and MDB entries from the NPI port (in fact CPU port
module) towards the same physical port, but this time used as a regular
port.

It is pointless for the felix driver to keep a copy of the host
addresses, when we can create and export DSA helpers for walking through
the addresses that it already needs to keep on the CPU port, for
refcounting purposes.

felix_classify_db() is moved up to avoid a forward declaration.

We pass "bool change" because dp->fdbs and dp->mdbs are uninitialized
lists when felix_setup() first calls felix_set_tag_protocol(), so we
need to avoid calling dsa_port_walk_fdbs() during probe time.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 171 ++++++++++++++++++++++++++++-----
 include/net/dsa.h              |   7 ++
 net/dsa/dsa.c                  |  40 ++++++++
 3 files changed, 192 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index badb5b9ba790..47320bfbaac1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -25,6 +25,104 @@
 #include <net/dsa.h>
 #include "felix.h"
 
+/* Translate the DSA database API into the ocelot switch library API,
+ * which uses VID 0 for all ports that aren't part of a bridge,
+ * and expects the bridge_dev to be NULL in that case.
+ */
+static struct net_device *felix_classify_db(struct dsa_db db)
+{
+	switch (db.type) {
+	case DSA_DB_PORT:
+	case DSA_DB_LAG:
+		return NULL;
+	case DSA_DB_BRIDGE:
+		return db.bridge.dev;
+	default:
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+}
+
+/* We are called before felix_npi_port_init(), so ocelot->npi is -1. */
+static int felix_migrate_fdbs_to_npi_port(struct dsa_switch *ds, int port,
+					  const unsigned char *addr, u16 vid,
+					  struct dsa_db db)
+{
+	struct net_device *bridge_dev = felix_classify_db(db);
+	struct ocelot *ocelot = ds->priv;
+	int cpu = ocelot->num_phys_ports;
+	int err;
+
+	err = ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
+	if (err)
+		return err;
+
+	return ocelot_fdb_add(ocelot, cpu, addr, vid, bridge_dev);
+}
+
+static int felix_migrate_mdbs_to_npi_port(struct dsa_switch *ds, int port,
+					  const unsigned char *addr, u16 vid,
+					  struct dsa_db db)
+{
+	struct net_device *bridge_dev = felix_classify_db(db);
+	struct switchdev_obj_port_mdb mdb;
+	struct ocelot *ocelot = ds->priv;
+	int cpu = ocelot->num_phys_ports;
+	int err;
+
+	memset(&mdb, 0, sizeof(mdb));
+	ether_addr_copy(mdb.addr, addr);
+	mdb.vid = vid;
+
+	err = ocelot_port_mdb_del(ocelot, port, &mdb, bridge_dev);
+	if (err)
+		return err;
+
+	return ocelot_port_mdb_add(ocelot, cpu, &mdb, bridge_dev);
+}
+
+/* ocelot->npi was already set to -1 by felix_npi_port_deinit, so
+ * ocelot_fdb_add() will not redirect FDB entries towards the
+ * CPU port module here, which is what we want.
+ */
+static int
+felix_migrate_fdbs_to_tag_8021q_port(struct dsa_switch *ds, int port,
+				     const unsigned char *addr, u16 vid,
+				     struct dsa_db db)
+{
+	struct net_device *bridge_dev = felix_classify_db(db);
+	struct ocelot *ocelot = ds->priv;
+	int cpu = ocelot->num_phys_ports;
+	int err;
+
+	err = ocelot_fdb_del(ocelot, cpu, addr, vid, bridge_dev);
+	if (err)
+		return err;
+
+	return ocelot_fdb_add(ocelot, port, addr, vid, bridge_dev);
+}
+
+static int
+felix_migrate_mdbs_to_tag_8021q_port(struct dsa_switch *ds, int port,
+				     const unsigned char *addr, u16 vid,
+				     struct dsa_db db)
+{
+	struct net_device *bridge_dev = felix_classify_db(db);
+	struct switchdev_obj_port_mdb mdb;
+	struct ocelot *ocelot = ds->priv;
+	int cpu = ocelot->num_phys_ports;
+	int err;
+
+	memset(&mdb, 0, sizeof(mdb));
+	ether_addr_copy(mdb.addr, addr);
+	mdb.vid = vid;
+
+	err = ocelot_port_mdb_del(ocelot, cpu, &mdb, bridge_dev);
+	if (err)
+		return err;
+
+	return ocelot_port_mdb_add(ocelot, port, &mdb, bridge_dev);
+}
+
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
@@ -327,7 +425,7 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 	return 0;
 }
 
-static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
+static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 {
 	struct ocelot *ocelot = ds->priv;
 	unsigned long cpu_flood;
@@ -365,9 +463,21 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		return err;
 
+	if (change) {
+		err = dsa_port_walk_fdbs(ds, cpu,
+					 felix_migrate_fdbs_to_tag_8021q_port);
+		if (err)
+			goto out_tag_8021q_unregister;
+
+		err = dsa_port_walk_mdbs(ds, cpu,
+					 felix_migrate_mdbs_to_tag_8021q_port);
+		if (err)
+			goto out_migrate_fdbs;
+	}
+
 	err = felix_update_trapping_destinations(ds, true);
 	if (err)
-		goto out_tag_8021q_unregister;
+		goto out_migrate_mdbs;
 
 	/* The ownership of the CPU port module's queues might have just been
 	 * transferred to the tag_8021q tagger from the NPI-based tagger.
@@ -380,6 +490,12 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 
 	return 0;
 
+out_migrate_mdbs:
+	if (change)
+		dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
+out_migrate_fdbs:
+	if (change)
+		dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_npi_port);
 out_tag_8021q_unregister:
 	dsa_tag_8021q_unregister(ds);
 	return err;
@@ -454,10 +570,23 @@ static void felix_npi_port_deinit(struct ocelot *ocelot, int port)
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
 }
 
-static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
+static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu, bool change)
 {
 	struct ocelot *ocelot = ds->priv;
 	unsigned long cpu_flood;
+	int err;
+
+	if (change) {
+		err = dsa_port_walk_fdbs(ds, cpu,
+					 felix_migrate_fdbs_to_npi_port);
+		if (err)
+			return err;
+
+		err = dsa_port_walk_mdbs(ds, cpu,
+					 felix_migrate_mdbs_to_npi_port);
+		if (err)
+			goto out_migrate_fdbs;
+	}
 
 	felix_npi_port_init(ocelot, cpu);
 
@@ -478,6 +607,13 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
 	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
 	return 0;
+
+out_migrate_fdbs:
+	if (change)
+		dsa_port_walk_fdbs(ds, cpu,
+				   felix_migrate_fdbs_to_tag_8021q_port);
+
+	return err;
 }
 
 static void felix_teardown_tag_npi(struct dsa_switch *ds, int cpu)
@@ -488,17 +624,17 @@ static void felix_teardown_tag_npi(struct dsa_switch *ds, int cpu)
 }
 
 static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
-				  enum dsa_tag_protocol proto)
+				  enum dsa_tag_protocol proto, bool change)
 {
 	int err;
 
 	switch (proto) {
 	case DSA_TAG_PROTO_SEVILLE:
 	case DSA_TAG_PROTO_OCELOT:
-		err = felix_setup_tag_npi(ds, cpu);
+		err = felix_setup_tag_npi(ds, cpu, change);
 		break;
 	case DSA_TAG_PROTO_OCELOT_8021Q:
-		err = felix_setup_tag_8021q(ds, cpu);
+		err = felix_setup_tag_8021q(ds, cpu, change);
 		break;
 	default:
 		err = -EPROTONOSUPPORT;
@@ -542,9 +678,9 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 
 	felix_del_tag_protocol(ds, cpu, old_proto);
 
-	err = felix_set_tag_protocol(ds, cpu, proto);
+	err = felix_set_tag_protocol(ds, cpu, proto, true);
 	if (err) {
-		felix_set_tag_protocol(ds, cpu, old_proto);
+		felix_set_tag_protocol(ds, cpu, old_proto, true);
 		return err;
 	}
 
@@ -592,23 +728,6 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 	return ocelot_fdb_dump(ocelot, port, cb, data);
 }
 
-/* Translate the DSA database API into the ocelot switch library API,
- * which uses VID 0 for all ports that aren't part of a bridge,
- * and expects the bridge_dev to be NULL in that case.
- */
-static struct net_device *felix_classify_db(struct dsa_db db)
-{
-	switch (db.type) {
-	case DSA_DB_PORT:
-	case DSA_DB_LAG:
-		return NULL;
-	case DSA_DB_BRIDGE:
-		return db.bridge.dev;
-	default:
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-}
-
 static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
 			 struct dsa_db db)
@@ -1260,7 +1379,7 @@ static int felix_setup(struct dsa_switch *ds)
 		/* The initial tag protocol is NPI which always returns 0, so
 		 * there's no real point in checking for errors.
 		 */
-		felix_set_tag_protocol(ds, dp->index, felix->tag_proto);
+		felix_set_tag_protocol(ds, dp->index, felix->tag_proto, false);
 		break;
 	}
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index cfedcfb86350..71cc363dbbd4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1219,6 +1219,13 @@ struct dsa_switch_driver {
 
 struct net_device *dsa_dev_to_net_device(struct device *dev);
 
+typedef int dsa_fdb_walk_cb_t(struct dsa_switch *ds, int port,
+			      const unsigned char *addr, u16 vid,
+			      struct dsa_db db);
+
+int dsa_port_walk_fdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb);
+int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb);
+
 /* Keep inline for faster access in hot path */
 static inline bool netdev_uses_dsa(const struct net_device *dev)
 {
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index c43f7446a75d..06d5de28a43e 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -467,6 +467,46 @@ struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
 }
 EXPORT_SYMBOL_GPL(dsa_port_from_netdev);
 
+int dsa_port_walk_fdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+	int err;
+
+	mutex_lock(&dp->addr_lists_lock);
+
+	list_for_each_entry(a, &dp->fdbs, list) {
+		err = cb(ds, port, a->addr, a->vid, a->db);
+		if (err)
+			break;
+	}
+
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(dsa_port_walk_fdbs);
+
+int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+	int err;
+
+	mutex_lock(&dp->addr_lists_lock);
+
+	list_for_each_entry(a, &dp->mdbs, list) {
+		err = cb(ds, port, a->addr, a->vid, a->db);
+		if (err)
+			break;
+	}
+
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(dsa_port_walk_mdbs);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.25.1

