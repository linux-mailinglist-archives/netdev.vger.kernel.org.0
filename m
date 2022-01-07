Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117B348796D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347999AbiAGPBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:24 -0500
Received: from mail-am6eur05on2067.outbound.protection.outlook.com ([40.107.22.67]:50784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347982AbiAGPBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUgl66tUhyr631eAsgnrzlJday/VrmM2jlBFk1RZLCnp3phYRy6yFYPzrX94KgLKvI6un6OWac0n9y3Lvb2yVnmUY29LP56Q5zSHX/HKmTfShKSMPuLRQ24UCaBYG52lgcJ/F9If0IdIATFvrGuWyJ1tXp0DtcCaGudGg5ue53Qb+relbHKD6TcUS0JuvYPSCToYLBxhHVvf1yl8lxtpNdFucGprnniSG4rSQSYI4XlEIvaYovwLKpTGD82/BiAIhA1KB8hlT5bpVxztUNc3jh+QDlfghxcF+QPkvukibE2Vvk6ht42uWpDGFWBHFIx7HPZemDLND0qasjt31kIYCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5oDc4+cJpKgxqSKjys5ARx5C/BtaDl1FL7MEMnd8mo=;
 b=VAeZb1SddkWq4L4E8JpWd1cxiYzQ9y+YjJ1CfuKujfVRiXzWo/+KF+FOz11S6R44DN6HdSlL1U20FkdrtD2wr6P5L3HLD4DK2SXTgK6TzEo4s0+sa7R/f9POGCppUGWD5FxeXE8jiUQb4KQkshdNZOd18z8cWKzBPp4UIMiScg2IDS4jbnrP1KsA7NR9EzwuIDrrp71A4AXMX4oo3RB6f15bzFW4He1C4ae+nk6SWy+5JkINn/zuCg4+HhISCY1sDMyB1RQTbnKkFbcWmfP2qkCcXEr5dXKrsElILwQ+xz7zKQ57R1bUSTutJ18L0s7SnlsS4AIWFrcttT4vD6oSlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5oDc4+cJpKgxqSKjys5ARx5C/BtaDl1FL7MEMnd8mo=;
 b=OT9TbXviW1+DvRF1g9NowuXI/TYVMTqp/0aSEh/bQsor7UHpbJEDP/VmosiQYDUUTIlCnn1hZwkzFWbpUzaA9H39MO72liTalHByp8Nu4QsTQERqf94kvBqbtXs3awQx+UfdN0og5HzZybC169EiG+tF3730BUaCo5Oj1aipyHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3837.eurprd04.prod.outlook.com (2603:10a6:803:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 15:01:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 12/12] net: dsa: felix: support FDB entries on offloaded LAG interfaces
Date:   Fri,  7 Jan 2022 17:00:56 +0200
Message-Id: <20220107150056.250437-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b01af80d-2ebf-4877-9770-08d9d1ee8e5c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3837:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB383785A9795F8361F25DC36EE04D9@VI1PR0402MB3837.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mV1MbFfjLomKcM+ADAh7kPoAuMh72Ng08NyaxMV1ETVsRgbY4ibpUks7fWFFgdad1xRxz4zyFUySZNk6HWfPaYhggYzGDxRfk64Ja0GxWzxbEzaMJ1RTC8dj3kkcu/F8FmIP0hT1wWwilsc2mSBvWPfkWu/jTRCEInvZXPeHtYHAu7rV+1re48j08VVegyB/KVUX8SEGWLd75LjUjqtKR9Ejpu+hW1Ppo0aM6N6n0e2QZLN9xry3XFUyNu1BmeRe5nwTG0oF6fPsphmmo3yN7RERJCqaKUk7UFJgCAmH4Bzl119z5VvT0Ek6JEKuH/jSAofaLAEp8vqi1Z6o529G0pTSLHxVHEEZsgEa9ebbXQcteve8wgQGohJm43QdgrpPJ0RhpIvPdvwfxuoNPM40xcaNnp4DoBkcRo7de39TLznOhhJsICufMLrEObmSjUVYeFK79Q9uJ02vm8bzxPmr58ycvpkeodzhI3YbnCKGVLUcbWzBO4/p5inpL9HxuYHX+kJd9OPZWv+/mZID+TOSSmxOeLZh7pSesynKLOyZ7vEwrhj8tMTMDTx5U0FTL6/YTiqJns9N0fLbircsIHjXWCegnM2rB25CAWBKttKKTc0S7bnGzIKZrRmtETOI8qOhtplUu7kXadJaMfFut6Wlk4K4pkeFi+1wMNcVPPirBOdPV86FtG1n1mSnQCbRJ6DwHFVKrZjeziVkVFqrxpcVeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(508600001)(38100700002)(186003)(83380400001)(1076003)(44832011)(2906002)(38350700002)(6506007)(36756003)(6666004)(6512007)(86362001)(2616005)(8676002)(5660300002)(4326008)(26005)(8936002)(66946007)(316002)(52116002)(66476007)(66556008)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oe4Uk20AIE1vP6OOPBe6uTZEVxYSYTr6DDwsbb88nKkbH6gTIAJ+Z2OSjF3O?=
 =?us-ascii?Q?BTiKRdl88rlcsBdCTlZ/s3f2hyc5KJV/SsmqTpxSByLHywfKJytnjVP2oim0?=
 =?us-ascii?Q?TDCJqRw1IXWLurLtnzmiWdzTNFpAI78fdzkN7TRzCU0V9clnf9f/qe8/m5I8?=
 =?us-ascii?Q?Ep3fBJnR6ppCrB3D68qjlTNNBY8kUoqXJksAMXt9dTkm905ZUwrZE5kZg0Oy?=
 =?us-ascii?Q?UEubb6QJY8/HvLgtMGSl+yOyUuvXUATGolaLqpK5nFeoittt34GtSHnDQ1Md?=
 =?us-ascii?Q?fjbCd9VOn0w+6FAwrQVt0/Ra0IY6PG5zMEIrDj/6Z2WcXdIm0ji8QSU6Bk0u?=
 =?us-ascii?Q?5fChPJgKB8isE4TcE0d1cwiZzQnaXKLcRFkRJ5VMrTJzunWHM6hSjL2U/Yyf?=
 =?us-ascii?Q?sfC1bcbBvIw9YyrHn4vrG9fLQ8KJJhiBI+8hAkgu+fuwQys4Rl5f3TAhfawQ?=
 =?us-ascii?Q?aX1WZ5sCGwjNffdeklJcUl5RHepwskEIyw6znv6zOwbKq22gRYEJRy0e9f86?=
 =?us-ascii?Q?A1NA0vcKCFiRD6OpRqyk+51na87TPA7oZpUvwPCWytYWujgB9/H7M9FUgxf2?=
 =?us-ascii?Q?EhWIxbsU3JYim8zDR+6nyBtypsTURJrxHTJjfdmZvO2vMzx2VulXwy/wf7D7?=
 =?us-ascii?Q?AEGfcksWvR3s4DpELkzh/dtUZ657BTgBvzJizQ3q40v/MBS59S+vfAi8ab3c?=
 =?us-ascii?Q?1Q3Hp/f3SwubZ5KL61bmy95Xvq5NA6bV8O/oaDKDgV5sYgp79KeDlXcDK0sV?=
 =?us-ascii?Q?AUK+a5FlhKKopVhx7QslzFLAfG0VjKZkvSSIWm1wQSfrCicvEZLnLIIRoigh?=
 =?us-ascii?Q?m+0a8brtniUfcdwEEEn5H+U3u0dUJ9VFjREIQeau1AHWTPW4IjNYeLph/R+x?=
 =?us-ascii?Q?3m9DMPNUu4jAsJW082TsTd3lxb9HuW2iPtSeQ5WDUCtlnve1b4pGAV9F7kVl?=
 =?us-ascii?Q?jJJkEOM+s8cVk/SZvO0slx7D+Vs/tYDVH4mYpQiLARFFOe5dsbXb62Nk3kFk?=
 =?us-ascii?Q?ZWXz6H49I4iEkY/ggpDTi61A659eoF7+nbsw/sNwtMyY5HQyjIcc5YqSXNBd?=
 =?us-ascii?Q?DOeE9hZxKyIHVtdZ4D6ItRD329/H15XSXTQrBmGLVLvkvVf9mGRDYGhcs0Dt?=
 =?us-ascii?Q?yXdEIyz/gPfGJpJhD1fgz9M/K0qSwx5yYgMkUAOzUwDyPgrCgauKihWPZdFo?=
 =?us-ascii?Q?O3SOTlhmLMuNDEgapR9mm97CUf4+ghF97K1uBWNwKnwLV4zA+u+1gwhaPvVw?=
 =?us-ascii?Q?BIVTeorboMBqvXL59hEcXn1PGzAmlcg8vKIS3H/01UQ68MMezskP7OBWxtoV?=
 =?us-ascii?Q?1vwuhdU/AeiGhQ7el1Sahk+teyAU9HugNJZcy/cpAmVNUBk3GCUsVEyhfbre?=
 =?us-ascii?Q?4XDj+JUve0d8y+YYcB/hcCl3il2dJ0WhhMf1tUyra1teYGLd/EvLVLcLkeZU?=
 =?us-ascii?Q?b2h66bHlBxSul189ifQiDUPPFp5x7mpc0yYwThwwWMlWkmRaQO2TEolBUHvh?=
 =?us-ascii?Q?lUNXP8AuOKX6Qxr1Ry8GJm1B8v0hDrjPQpXqhK7zZNYrbD+xHAV+C3FGQ27K?=
 =?us-ascii?Q?GVUvlHbHr0Oxp/T+fPo1LoPGhWXHjGGxHX3i0iDy96hzyBbkFcQb531GBpDg?=
 =?us-ascii?Q?tvfz2PbVCz5lsG4QecGznco=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b01af80d-2ebf-4877-9770-08d9d1ee8e5c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:17.1740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTTlBvZrluGFcmQlm1mioOd+5n07g5c9/wlPoXbcikdS+G7ww0vefA7dUQ21D3BBpfE3ztqT5THYOQrq05UVwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the logic in the Felix DSA driver and Ocelot switch library.
For Ocelot switches, the DEST_IDX that is the output of the MAC table
lookup is a logical port (equal to physical port, if no LAG is used, or
a dynamically allocated number otherwise). The allocation we have in
place for LAG IDs is different from DSA's, so we can't use that:
- DSA allocates a continuous range of LAG IDs starting from 1
- Ocelot appears to require that physical ports and LAG IDs are in the
  same space of [0, num_phys_ports), and additionally, ports that aren't
  in a LAG must have physical port id == logical port id

The implication is that an FDB entry towards a LAG might need to be
deleted and reinstalled when the LAG ID changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     |  18 ++++
 drivers/net/ethernet/mscc/ocelot.c | 128 ++++++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h          |  12 +++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4624d51a9b0a..e766ee14dc33 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -674,6 +674,22 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
+static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
+			     const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_lag_fdb_add(ocelot, lag.dev, addr, vid);
+}
+
+static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
+			     const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_lag_fdb_del(ocelot, lag.dev, addr, vid);
+}
+
 static int felix_mdb_add(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_mdb *mdb)
 {
@@ -1637,6 +1653,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
 	.port_fdb_del			= felix_fdb_del,
+	.lag_fdb_add			= felix_lag_fdb_add,
+	.lag_fdb_del			= felix_lag_fdb_del,
 	.port_mdb_add			= felix_mdb_add,
 	.port_mdb_del			= felix_mdb_del,
 	.port_pre_bridge_flags		= felix_pre_bridge_flags,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b1311b656e17..5a4711a07105 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1829,6 +1829,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	u32 mask = 0;
 	int port;
 
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -1842,6 +1844,19 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	return mask;
 }
 
+/* The logical port number of a LAG is equal to the lowest numbered physical
+ * port ID present in that LAG. It may change if that port ever leaves the LAG.
+ */
+static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
+{
+	int bond_mask = ocelot_get_bond_mask(ocelot, bond);
+
+	if (!bond_mask)
+		return -ENOENT;
+
+	return __ffs(bond_mask);
+}
+
 u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
@@ -2335,7 +2350,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = ocelot_bond_get_id(ocelot, bond);
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -2350,6 +2365,46 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 	}
 }
 
+/* Documentation for PORTID_VAL says:
+ *     Logical port number for front port. If port is not a member of a LLAG,
+ *     then PORTID must be set to the physical port number.
+ *     If port is a member of a LLAG, then PORTID must be set to the common
+ *     PORTID_VAL used for all member ports of the LLAG.
+ *     The value must not exceed the number of physical ports on the device.
+ *
+ * This means we have little choice but to migrate FDB entries pointing towards
+ * a logical port when that changes.
+ */
+static void ocelot_migrate_lag_fdbs(struct ocelot *ocelot,
+				    struct net_device *bond,
+				    int lag)
+{
+	struct ocelot_lag_fdb *fdb;
+	int err;
+
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
+	list_for_each_entry(fdb, &ocelot->lag_fdbs, list) {
+		if (fdb->bond != bond)
+			continue;
+
+		err = ocelot_mact_forget(ocelot, fdb->addr, fdb->vid);
+		if (err) {
+			dev_err(ocelot->dev,
+				"failed to delete LAG %s FDB %pM vid %d: %pe\n",
+				bond->name, fdb->addr, fdb->vid, ERR_PTR(err));
+		}
+
+		err = ocelot_mact_learn(ocelot, lag, fdb->addr, fdb->vid,
+					ENTRYTYPE_LOCKED);
+		if (err) {
+			dev_err(ocelot->dev,
+				"failed to migrate LAG %s FDB %pM vid %d: %pe\n",
+				bond->name, fdb->addr, fdb->vid, ERR_PTR(err));
+		}
+	}
+}
+
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
@@ -2374,14 +2429,23 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
+	int old_lag_id, new_lag_id;
+
 	mutex_lock(&ocelot->fwd_domain_lock);
 
+	old_lag_id = ocelot_bond_get_id(ocelot, bond);
+
 	ocelot->ports[port]->bond = NULL;
 
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot, false);
 	ocelot_set_aggr_pgids(ocelot);
 
+	new_lag_id = ocelot_bond_get_id(ocelot, bond);
+
+	if (new_lag_id >= 0 && old_lag_id != new_lag_id)
+		ocelot_migrate_lag_fdbs(ocelot, bond, new_lag_id);
+
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
@@ -2390,13 +2454,74 @@ void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot_port->lag_tx_active = lag_tx_active;
 
 	/* Rebalance the LAGs */
 	ocelot_set_aggr_pgids(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_change);
 
+int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_lag_fdb *fdb;
+	int lag, err;
+
+	fdb = kzalloc(sizeof(*fdb), GFP_KERNEL);
+	if (!fdb)
+		return -ENOMEM;
+
+	ether_addr_copy(fdb->addr, addr);
+	fdb->vid = vid;
+	fdb->bond = bond;
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+	lag = ocelot_bond_get_id(ocelot, bond);
+
+	err = ocelot_mact_learn(ocelot, lag, addr, vid, ENTRYTYPE_LOCKED);
+	if (err) {
+		mutex_unlock(&ocelot->fwd_domain_lock);
+		kfree(fdb);
+		return err;
+	}
+
+	list_add_tail(&fdb->list, &ocelot->lag_fdbs);
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_lag_fdb_add);
+
+int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_lag_fdb *fdb, *tmp;
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	list_for_each_entry_safe(fdb, tmp, &ocelot->lag_fdbs, list) {
+		if (!ether_addr_equal(fdb->addr, addr) || fdb->vid != vid ||
+		    fdb->bond != bond)
+			continue;
+
+		ocelot_mact_forget(ocelot, addr, vid);
+		list_del(&fdb->list);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+		kfree(fdb);
+
+		return 0;
+	}
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(ocelot_lag_fdb_del);
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
@@ -2691,6 +2816,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
 	INIT_LIST_HEAD(&ocelot->vlans);
+	INIT_LIST_HEAD(&ocelot->lag_fdbs);
 	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5c3a3597f1d2..8dfe1a827097 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -630,6 +630,13 @@ enum macaccess_entry_type {
 #define OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION	BIT(0)
 #define OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP		BIT(1)
 
+struct ocelot_lag_fdb {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	struct net_device *bond;
+	struct list_head list;
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -683,6 +690,7 @@ struct ocelot {
 	u8				base_mac[ETH_ALEN];
 
 	struct list_head		vlans;
+	struct list_head		lag_fdbs;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
@@ -840,6 +848,10 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
+int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid);
+int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-- 
2.25.1

