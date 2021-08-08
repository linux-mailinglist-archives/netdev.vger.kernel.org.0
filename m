Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673F23E3AD3
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhHHOgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:36:15 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:24033
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231718AbhHHOgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 10:36:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kX/zf9obdMm6MdFhaiAsphWlnwYPzLhWfzJMzMi06Xj8BoaJAq4lji6oUVyFokw0Sv4JOu4nAVmNEHWBicfwLroVwIlyEPIeIYiE4L1dbzZXOeTx98LL7AI/MLrGL7eZkVByjZd0B9ThklZa8ODtly9zZnL90hFiQ+S2hUcOrS77qKebFm+u4HiyDZbFPJ+gfP8BZnwLSaI4mGER8sPRNPpevFIz5NjEnfoG3ULJ37AE6J+n88P7SAKivV3mAzH1XsuetxCx5nXW/vD2yY8zZ1AGIW4QSVJM73hT9Rern8SawfclkX71UEIVwTIxlJLSoS7Yi1DAaV+jJbEJ3gQ2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egR+AQ6Q5lvxAVy4GeJLxi70vRlF98sgBwl+A8HqL6Q=;
 b=MBLuAXJquFMMjouW46pFKC5kTybciI0+764gNcogBBe0HA0KIIEopfpeZbEECbJbLm9SyLvCtH+7uUea+PhCwHU8zv7CKIwNG+MBChYvlOcTe/GMxBtP1KUHZNskz4yq7YEJTG19SFzXjOg3L3E1QtPKCNNv7m+ap9Bz2zdiCpK+cDGHdK6YyIF8irFEDz8hStvqQcbQnBvr6aJ3KY2RvadzEuSXZo3VdhPB4btYvFGBn/Be96VcEU3cTeqcI1XoHCNTMxYkq6hjwRqnwjvqF/fjh8guILz0ou8G7E+jdSSZ/iYtoU3KKr57X6C9oebv2OBZDz18bBWplBJOjSNJ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egR+AQ6Q5lvxAVy4GeJLxi70vRlF98sgBwl+A8HqL6Q=;
 b=aclDY+AGfPpjHgMM6bxwZ6xslbZk0wAvgoKNG1dZa5/+HJHRAHi/l0/eKjGz/pgFzR/eJBN5ldS0dztT87DyRSXEJiRACZSnw6FBI++C9SEFflMTiYUGrzMSBGSm34qI72t9WwzijYTxbES876G3MOCDRyRw4KJ19zt0bB1zzL4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 14:35:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:35:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/5] net: dsa: centralize fast ageing when address learning is turned off
Date:   Sun,  8 Aug 2021 17:35:23 +0300
Message-Id: <20210808143527.4041242-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
References: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0003.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0003.eurprd06.prod.outlook.com (2603:10a6:800:1e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 14:35:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d94f53a4-647d-45cb-5c0a-08d95a79d080
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301F33812827184B8C2FFEEE0F59@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67CEcMjVjOBpfDiFxnDfZdI+7S9nebNcfIVbbYL1vHJoAxJ0WzXC1HUiTD0DnRBKGYUEunsZANEXErX+ke6YZdUZTH9PuaKfeZBwGmJ0pLXXkCPLe9sR7orPQnIxr+UvwEBpYuV9qVHaUarNEGIOiP6AcmVOTJoGEnFAkjkP6ECf+sVvK3kroUquEpkbNPpOJgmVnUgSPuVu0HDBieVb21AyPQ192KenqZntfAXITo+VFm8yUAALQXmY8Br+xi3/6JeXTCdRToML1zEYrIyUmx4ROgWM9Fhm5rLs9fPk3+IP44PfE8/eKfZfuimrjjZK8OsBYY7iCWdipRKja1JsR/t/nel+nAiWtZ3ClyV2fGuQSsq3kzibKhlKwA36/ojqrrr5WvT0NQtBJUgiPZeV+72jK5hWLMxsNlTN72LMR9DZT0Gh5NcjoVD+iG/bdN7sZ+UOreOl3wCznyhz+NsUefASsPrfjdBj8n6+5jlYXCIPI3+qODURQEhoD090WRcDLkNnXt9995jepYaGPd53f7hL1EV9Y5Vxmp4DpUP2HDkoV+CGaUzylZG1dsU4hs2JrQl2TQuWA4tAObCQqT4maV1MVLIM//Pv61DpOXVdrwzAw2kITgoVlck52iF1N08im5bR/QGBWbRXxKHiklQVCN4MHc2hpPzcPwpHmMUgtSvbZGlAetoBKMriUMtXbXv64gQBpr7zK4FsPsUMgHaXaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(8676002)(6486002)(6512007)(956004)(2616005)(44832011)(4326008)(6506007)(186003)(2906002)(1076003)(38350700002)(38100700002)(26005)(52116002)(66556008)(66946007)(66476007)(8936002)(83380400001)(6666004)(110136005)(54906003)(5660300002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wIFmyjnWeLvLaHc+Zdu1hgt8mFm3Pfhhr9cPWgkDqAgrhmp0DuD7NSOUT7xJ?=
 =?us-ascii?Q?mkuKe404nJcuoOUq2VfuWyMpawZYZxENCU7wFJ+voZcVIWh7fYliAYprf1Jo?=
 =?us-ascii?Q?LJtz4Af1PNPhBfGMQ1x/CT7SN+YHzVESlXBDNEZJ8wINxn+2Me3fTCILFSMA?=
 =?us-ascii?Q?da0VGfVOZ/1P8eIG5Yz3YDqj/WB+onMCJq7UDLL7C7SAjrq/Vp5uFMxAAzmq?=
 =?us-ascii?Q?jWfpaSr9b0uerP8vZoNNOA7/9DHzNTSd9gFHoZ8LiuSe28WORsBQqIuBRdQp?=
 =?us-ascii?Q?T9Dtd/hKCWpcfinyWBqpZWcnzPLlUMPMolW4jhroFxmYIbecOJk2bjteuKS7?=
 =?us-ascii?Q?TBVYqhMqn6jkVnt4HpCE0VsM5bfScXpsQzT3BKJMI335JX2Hcs80gT9u28QB?=
 =?us-ascii?Q?6IrZEqXyHIUKvEQ34sa9nOpxMLb3H8Cmvh+r++k/ruLdKLpf8ASR7MxcPkK3?=
 =?us-ascii?Q?cM1kESQhH4EwEKPqcSuYi8NmhW2yPPWf5PpUqHGYYOokvFMu9R2Voafs7j02?=
 =?us-ascii?Q?mJhhrId7jOMNF/QMxj1/z6EH1O9IxHKCkFU1IqBxAuQiiEa9PY+LJI16Amnf?=
 =?us-ascii?Q?SlFl0hSfBD/5viikp4ZVKUkh+YDlChW/Q4pFpQ3KZ6ovt+toH1rjpIkroZH0?=
 =?us-ascii?Q?tQU77einfDbfH3Nla8jyCDI2CZkUk0EvsLmGPIRYc5x9Eo8jJd801I63Sggh?=
 =?us-ascii?Q?V7wFI7jz5S3D7LYuR6zNDz4g+cmvWs3Xe3tFryv0QR1hsOwu0J/PCeBbP/oF?=
 =?us-ascii?Q?C9urgvYOxzINHA9wNfVeMsZeXtY0mAlkL0mZyVbKByTiVzWM+IPDPpegpWNz?=
 =?us-ascii?Q?OA2/73Nft6eMCmXUOjgQgIdCxCiEBt3FoqF6LlaVcdqx1rWbF8/+P16hfXyl?=
 =?us-ascii?Q?3vRSfYPKdYBN4Lj5kBxzbvrpdqTO2txWo6TiCPPngWvx2AS6ek7rmGuhuC0U?=
 =?us-ascii?Q?YyqEjFYuKGxQUBtWPq+I3bLOKRaoEDwe4dOT9ct1rcevLp3xUMLS5+EBLBiK?=
 =?us-ascii?Q?xn8YF+hBNcne0o/XPgcqBWj/FIsDKwkeNpCzMOwQauLF5q0D4RO0XZI9CVD/?=
 =?us-ascii?Q?YqeCWhoutWiGkj8gBpZ7UFnw3IP9whIc0kW9E7W7nCXCCSaI8QM/Jm5ljrPL?=
 =?us-ascii?Q?moWAgUsKYVw7eUGxQmUguUrbRlKu7XSqr8XJHrVKtQ1PR3HF3mUv76kAMhp4?=
 =?us-ascii?Q?zFtV0dOtUe+sn5/7cR9vrC5VfdGWYdlY2zuH6hCjZy4qB8s+R9opRN/dKxM2?=
 =?us-ascii?Q?4tUa+bcayguNG5YPWEcWzyNcTUj/jjykKrS8XBuIX8d39G45vMvJvlXmeerL?=
 =?us-ascii?Q?XE7/q5mhNNmY1WQOJeQnam8G?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94f53a4-647d-45cb-5c0a-08d95a79d080
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:35:48.7060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1ItLxEoBrpVcUqcAIsugSVD5J8JYtirQB9f1axtEM/pTl/bzeKlWuATfTl8rUSOd9iqkDvp+xNtr5hFuJD85g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA leaves it down to device drivers to fast age the FDB on a
port when address learning is disabled on it. There are 2 reasons for
doing that in the first place:

- when address learning is disabled by user space, through
  IFLA_BRPORT_LEARNING or the brport_attr_learning sysfs, what user
  space typically wants to achieve is to operate in a mode with no
  dynamic FDB entry on that port. But if the port is already up, some
  addresses might have been already learned on it, and it seems silly to
  wait for 5 minutes for them to expire until something useful can be
  done.

- when a port leaves a bridge and becomes standalone, DSA turns off
  address learning on it. This also has the nice side effect of flushing
  the dynamically learned bridge FDB entries on it, which is a good idea
  because standalone ports should not have bridge FDB entries on them.

We let drivers manage fast ageing under this condition because if DSA
were to do it, it would need to track each port's learning state, and
act upon the transition, which it currently doesn't.

But there are 2 reasons why doing it is better after all:

- drivers might get it wrong and not do it (see b53_port_set_learning)

- we would like to flush the dynamic entries from the software bridge
  too, and letting drivers do that would be another pain point

So track the port learning state and trigger a fast age process
automatically within DSA.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  7 -------
 include/net/dsa.h                |  1 +
 net/dsa/dsa_priv.h               |  2 +-
 net/dsa/port.c                   | 35 ++++++++++++++++++++++++++++----
 4 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c2c5f1573fe5..c45ca2473743 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5797,7 +5797,6 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 				       struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	bool do_fast_age = false;
 	int err = -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
@@ -5809,9 +5808,6 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
 		if (err)
 			goto out;
-
-		if (!learning)
-			do_fast_age = true;
 	}
 
 	if (flags.mask & BR_FLOOD) {
@@ -5843,9 +5839,6 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 out:
 	mv88e6xxx_reg_unlock(chip);
 
-	if (do_fast_age)
-		mv88e6xxx_port_fast_age(ds, port);
-
 	return err;
 }
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d7dc26d316ea..995e9d3f9cfc 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -254,6 +254,7 @@ struct dsa_port {
 	struct device_node	*dn;
 	unsigned int		ageing_time;
 	bool			vlan_filtering;
+	bool			learning;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
 	int			bridge_num;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8dad40b2cf5c..9575cabd3ec3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -241,7 +241,7 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 			      struct switchdev_brport_flags flags,
 			      struct netlink_ext_ack *extack);
-int dsa_port_bridge_flags(const struct dsa_port *dp,
+int dsa_port_bridge_flags(struct dsa_port *dp,
 			  struct switchdev_brport_flags flags,
 			  struct netlink_ext_ack *extack);
 int dsa_port_vlan_add(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ef5e08b09bb7..d6a35a03acd6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -30,6 +30,16 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
+static void dsa_port_fast_age(const struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_fast_age)
+		return;
+
+	ds->ops->port_fast_age(ds, dp->index);
+}
+
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -40,7 +50,7 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 
 	ds->ops->port_stp_state_set(ds, port, state);
 
-	if (do_fast_age && ds->ops->port_fast_age) {
+	if (do_fast_age) {
 		/* Fast age FDB entries or flush appropriate forwarding database
 		 * for the given port, if we are moving it from Learning or
 		 * Forwarding state, to Disabled or Blocking or Listening state.
@@ -54,7 +64,7 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 		    (state == BR_STATE_DISABLED ||
 		     state == BR_STATE_BLOCKING ||
 		     state == BR_STATE_LISTENING))
-			ds->ops->port_fast_age(ds, port);
+			dsa_port_fast_age(dp);
 	}
 
 	dp->stp_state = state;
@@ -633,16 +643,33 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 	return ds->ops->port_pre_bridge_flags(ds, dp->index, flags, extack);
 }
 
-int dsa_port_bridge_flags(const struct dsa_port *dp,
+int dsa_port_bridge_flags(struct dsa_port *dp,
 			  struct switchdev_brport_flags flags,
 			  struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
+	int err;
 
 	if (!ds->ops->port_bridge_flags)
 		return -EOPNOTSUPP;
 
-	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
+	err = ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
+	if (err)
+		return err;
+
+	if (flags.mask & BR_LEARNING) {
+		bool learning = flags.val & BR_LEARNING;
+
+		if (learning == dp->learning)
+			return 0;
+
+		if (dp->learning && !learning)
+			dsa_port_fast_age(dp);
+
+		dp->learning = learning;
+	}
+
+	return 0;
 }
 
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-- 
2.25.1

