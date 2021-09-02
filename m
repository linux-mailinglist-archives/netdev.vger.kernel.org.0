Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D333FF7B5
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347902AbhIBXSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:18:53 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:62432
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231232AbhIBXSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 19:18:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7zlNPQcsF7OqmLmfjjtVJzC7Ff+ACxo6qQCF3exUkCoPT8NLPeMXSyRra1ZMOQI/DheJt1HiPcx3DRz++V3mZUcVW06ETRkEO3hdA2wm1nLFzLbadYZ2mDc+wdHJew/tC8pR2fp41jEY3PJCG+4lmV/ECxOvJgrZ4n5V3f8Sy6I8vKKPFUq+6hpFygUDGPtjOLW8wblnXeDeoyUuhqWFHPWgxRpBY3ffB+4/UaW3g2OJjsf662EzkeKJDWe2ZQVhSUXdRn/F0t3athNpeBpHal0RDJ49s9XQpZOg6rU2+3+0eRUW0lCcpSrGpzflrlpnM9maj46EBX6BhTx8ErJTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TToOeu1qLomtDwEpr6NM6z8pqKcSie9YhuqczRZdzAk=;
 b=m6bFzlkJoKLajeku839j9oZZH4xOTJqiYunWCwxB22dhCES4GqIWoRXh6p12mj/wliU9Oj4WSxfmtCxxsqxizpv9ymfCo8fbehwImAnujh8t4O5ZayxvodLIt1AsrS97UJ/zzQDxSBmkbuwzsg8PehmOzKF5T2oY63roysyUJpakYvT/R2DjXpa1St1y9Cojqr0tYVBB3xR9FITMmDP3A+4f/PoJjtBGH+NjmRtJtr/SV343zZ1JiND8j1n6WS5ozuLnf7aETbbdTV47RHQ6Aar4e4qEEap0Lvdjjy+UElX2qSGGK0zVAkRlaSFCwlT2MiylkJa1FWKupUt+t9yBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TToOeu1qLomtDwEpr6NM6z8pqKcSie9YhuqczRZdzAk=;
 b=WGRxE21gjcwDsiaed3b0Ng+FyIo0mSjLO1ECf/PLRdSu4TIAXpIsISPmtrpKzsCtqQr/guLa5RZkpGywQ1Ly6a138xQ/kMVmH6vmXYh70im8p4jv4ok3mocz9WrgFhKzUg8Gt3qP79iLb2wcsiuCDr6nXavHuqMdT68Ej3Ehcmc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Thu, 2 Sep
 2021 23:17:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.026; Thu, 2 Sep 2021
 23:17:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net] net: dsa: tear down devlink port regions when tearing down the devlink port on error
Date:   Fri,  3 Sep 2021 02:17:38 +0300
Message-Id: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0078.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR0801CA0078.eurprd08.prod.outlook.com (2603:10a6:800:7d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Thu, 2 Sep 2021 23:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f1aab85-cc86-4fbc-b332-08d96e67e1ca
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340824257071EBEA8707FCC5E0CE9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIulVDpPKw8VpMDAnpvOD4OHAxwCGjGMzKDcdRxL1u0hFKX7nBuhX23T57vHdzM6ZzeQiWgrlHGKP9TYpW0f9iKovQQQZgIv396aV69bEHvPCJBmENo3Rn1hAZ/4QptNvrBLWEiH8LF4J7gzbjTFU1eUvwJ+xDRvY86nvRo4c96XsRC8sa8fKgd6RN/OtyJs/4usodO8sspYXPPoT4WMTRrVhl5/bF7H58CWhHoVmZVSHjqycYrLgDWe1Kbr1bsSTrYutgyfK69sThEUnfjXgGY6ii94lXyyv4wstgX80Wz4tszEwjsupj7cBj0A5lBYch/IOIbNgKgXW5a00+NaS/WeizWB/xp5955/5R+7/kIn0biDc9uhuBcvJRpkjOYnxsc8HjWETKnVHOhtrOvonOI8df3yZkby9VjibBAA2MHiduHpdcTnddrYBqIiJvh8w/BUpLu1xgeFnoApQwFy3V2w4FP8bG1Pg4O/Y7m+Tz11o1nBTC0jmjr1zH+5j2eemhNYbre8uq0nKTz29b80rtUuKLDIZAWgrVbLDU1MroQtd9Lb1rMgD8Dl1g/w96+ayicOft/TAkyJG8AYlIdhZc9bXkFiNh0LLNT7qI+vitGCIwGON/W+7vFh/DFsPW6WDVup2dZR58XTZcOHxJo60vyPvsWmIUtA95sWAc1vS0ckQ7NNGphyyzzEuhrSZeGVaJPH95O5DuQy6WHLyw4p5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(66556008)(186003)(86362001)(83380400001)(478600001)(66476007)(8936002)(1076003)(66946007)(316002)(54906003)(6506007)(26005)(6916009)(36756003)(6666004)(6512007)(5660300002)(38350700002)(2906002)(38100700002)(52116002)(44832011)(6486002)(2616005)(8676002)(956004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XW/yo/AePbbyUbH2hDeK5mJAKRS2SaGpTdg+GfwJwRmFJuNpqbtLgxxbrzhs?=
 =?us-ascii?Q?cA3GAbntXm+om7yh+vPltgqJzHkBw0CNlfIZlD7LLkCx60ROi0NCpk5thSM8?=
 =?us-ascii?Q?Hd7shB9Ewrt0z7T880Pa1+hkmKFRe7XpW1FPIRSuluZ0wO+5dDXO26OiHTh7?=
 =?us-ascii?Q?k2EB81cXqVkkSE6ofbIBxYIrVVWHmsSUnbu/Y5xAjhDvWBlRRWbzSgdnCxSa?=
 =?us-ascii?Q?VSd5RBrrbAs9gUK3th3SI7ker2vWA17+ST1W03255HCM/i3VXYifQYSDpLdl?=
 =?us-ascii?Q?WWNvZBkD+qzdcW1cXo1OEOIxGeSfDy6/s3/dKRbyswDt+g2vzxkPklWxUhc0?=
 =?us-ascii?Q?hkUxKtwNi463DkV5vumatv+I9PO1bjpqRLMihoAz82kj9VsweskUxGabQOVY?=
 =?us-ascii?Q?df2Xqe5Q6/qo9FmAodxbFQoujZ6mbjwRwMmlk6W7txoaJDDQFRxv6Pkfe0cb?=
 =?us-ascii?Q?JaX1v/+kdG329juW1+37zzAgNYy+yT2pG1iRHurCgHIHwQekPOSMuhUCyz3o?=
 =?us-ascii?Q?z4MOiJmaDVo//mNdwyPks0DlXs+ny0nq9TPwL0PzopWH26Rwe7P2LwDUarEH?=
 =?us-ascii?Q?b75QnxODkL3u5Fnd4uSnGar0VA649FEBszH1U4y46ScRuszY0c97ELmsOi6S?=
 =?us-ascii?Q?8gtzVt7lK68IHJY2OeVxx2ha4UH5S9IUe9XUcMAlZ+FN5EGXMh5j+8u//J3M?=
 =?us-ascii?Q?/Yr696NOy0jZQBASKy9+3Mt7oK5u8RWUgh1HdIQv/MM14AVckGPCo9b6hEgs?=
 =?us-ascii?Q?OJOhNg95BGRwvgXCJgSdKrqBFFl6hVUtARS+jZlkDdIjS7iCv1bTAWlkYlf2?=
 =?us-ascii?Q?BN72TSvcEnThnJRA7xFrX7yIHZ/kMGIhwsSv9BPK3BEm6i88rQasePdCGe+A?=
 =?us-ascii?Q?Z5wGoZnNoBhtgUQIjxiHxnNiHeGxA+qnp726jYOYRT6PmaRy7bWUhNFDFib0?=
 =?us-ascii?Q?5Qt60hh5sKUn4yivXm+VohAmqE7re0D1NuTWp353WTBdj0vrFfqdRnJQnO6h?=
 =?us-ascii?Q?XZ92arIn82MZKScfYcDzJ94JLF+/k3gI5fI9GJGsG7qh5PWD7VTibPjU/diE?=
 =?us-ascii?Q?4+U9ZDhfpdLQa1O/J/4tK7H9iX7G03WHwyvdgh4SYOMWA1Fx7caDDX8vJvBL?=
 =?us-ascii?Q?4eaaxd8DSbd5nrf45I3ageBHfJ+7Euij+CBptjBmnOAsReGPuLu4fZlcJSr8?=
 =?us-ascii?Q?aHiX1BuD2mTYT8IdyfeI5mEjhg+8fAw+Yrfom/LQf3iRgsoH3L98WJM9oclm?=
 =?us-ascii?Q?t0wUx/oL/rEL3vu6LiWmyl6Ok1AWoBaLiADkq/DrRmG03z/1puKuAOWVihGx?=
 =?us-ascii?Q?GVHlOE0JhME0fVP/sMjtN92v?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1aab85-cc86-4fbc-b332-08d96e67e1ca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 23:17:50.0359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DE7cSGClgi/PkqDPeBQcwsepgdR4AIknN6IJ48IP5x2G7Z7S1Mf2DPLfqN7o5Mi/gMQ5e4r8WHA0HNECRmVIvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
decided it was fine to ignore errors on certain ports that fail to
probe, and go on with the ports that do probe fine.

Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
called, and devlink notices after a timeout of 3700 seconds and prints a
WARN_ON. So it went ahead to unregister the devlink port. And because
there exists an UNUSED port flavour, we actually re-register the devlink
port as UNUSED.

Commit 08156ba430b4 ("net: dsa: Add devlink port regions support to
DSA") added devlink port regions, which are set up by the driver and not
by DSA.

When we trigger the devlink port deregistration and reregistration as
unused, devlink now prints another WARN_ON, from here:

devlink_port_unregister:
	WARN_ON(!list_empty(&devlink_port->region_list));

So the port still has regions, which makes sense, because they were set
up by the driver, and the driver doesn't know we're unregistering the
devlink port.

Somebody needs to tear them down, and optionally (actually it would be
nice, to be consistent) set them up again for the new devlink port.

But DSA's layering stays in our way quite badly here.

The options I've considered are:

1. Introduce a function in devlink to just change a port's type and
   flavour. No dice, devlink keeps a lot of state, it really wants the
   port to not be registered when you set its parameters, so changing
   anything can only be done by destroying what we currently have and
   recreating it.

2. Make DSA cache the parameters passed to dsa_devlink_port_region_create,
   and the region returned, keep those in a list, then when the devlink
   port unregister needs to take place, the existing devlink regions are
   destroyed by DSA, and we replay the creation of new regions using the
   cached parameters. Problem: mv88e6xxx keeps the region pointers in
   chip->ports[port].region, and these will remain stale after DSA frees
   them. There are many things DSA can do, but updating mv88e6xxx's
   private pointers is not one of them.

3. Just let the driver do it. It's pretty horrible, but the other
   methods just don't seem to work.

Fixes: 08156ba430b4 ("net: dsa: Add devlink port regions support to DSA")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  1 +
 drivers/net/dsa/mv88e6xxx/devlink.c | 16 ++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  1 +
 include/net/dsa.h                   |  9 +++++++++
 net/dsa/dsa.c                       |  6 ++++++
 net/dsa/dsa2.c                      | 22 +++++++++++++++++-----
 6 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c45ca2473743..76f580a12bac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6173,6 +6173,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
 	.port_bridge_tx_fwd_offload = mv88e6xxx_bridge_tx_fwd_offload,
 	.port_bridge_tx_fwd_unoffload = mv88e6xxx_bridge_tx_fwd_unoffload,
+	.port_reinit_as_unused	= mv88e6xxx_port_reinit_as_unused,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 0c0f5ea6680c..6c928b6af6d0 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -792,3 +792,19 @@ int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
 					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
 					      chip->info->name);
 }
+
+int mv88e6xxx_port_reinit_as_unused(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_teardown_devlink_regions_port(chip, port);
+	dsa_port_devlink_teardown(dp);
+	dp->type = DSA_PORT_TYPE_UNUSED;
+	err = dsa_port_devlink_setup(dp);
+	if (err)
+		return err;
+
+	return mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
index 3d72db3dcf95..5a23e115f23f 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.h
+++ b/drivers/net/dsa/mv88e6xxx/devlink.h
@@ -14,6 +14,7 @@ int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
 				struct devlink_param_gset_ctx *ctx);
 int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
 void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
+int mv88e6xxx_port_reinit_as_unused(struct dsa_switch *ds, int port);
 
 int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
 			       struct devlink_info_req *req,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index f9a17145255a..046dbebbf647 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -846,6 +846,12 @@ struct dsa_switch_ops {
 						   enum devlink_sb_pool_type pool_type,
 						   u32 *p_cur, u32 *p_max);
 
+	/* Hook for drivers to tear down their port devlink regions when a
+	 * port failed to register and its devlink port must be torn down and
+	 * reinitialized by DSA as unused.
+	 */
+	int	(*port_reinit_as_unused)(struct dsa_switch *ds, int port);
+
 	/*
 	 * MTU change functionality. Switches can also adjust their MRU through
 	 * this method. By MTU, one understands the SDU (L2 payload) length.
@@ -961,6 +967,9 @@ static inline int dsa_devlink_port_to_port(struct devlink_port *port)
 	return port->index;
 }
 
+int dsa_port_devlink_setup(struct dsa_port *dp);
+void dsa_port_devlink_teardown(struct dsa_port *dp);
+
 struct dsa_switch_driver {
 	struct list_head	list;
 	const struct dsa_switch_ops *ops;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1dc45e40f961..4d9e5fe5bbb7 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -440,6 +440,12 @@ dsa_devlink_port_region_create(struct dsa_switch *ds,
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
+	/* Make sure drivers provide the method for cleaning this up when the
+	 * port might need to be torn down at runtime.
+	 */
+	if (WARN_ON(!ds->ops->port_reinit_as_unused))
+		return NULL;
+
 	return devlink_port_region_create(&dp->devlink_port, ops,
 					  region_max_snapshots,
 					  region_size);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1b2b25d7bd02..bc1da54fcf4c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -488,7 +488,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_devlink_setup(struct dsa_port *dp)
+int dsa_port_devlink_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 	struct dsa_switch_tree *dst = dp->ds->dst;
@@ -529,6 +529,7 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(dsa_port_devlink_setup);
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
@@ -572,7 +573,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	dp->setup = false;
 }
 
-static void dsa_port_devlink_teardown(struct dsa_port *dp)
+void dsa_port_devlink_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 
@@ -580,6 +581,19 @@ static void dsa_port_devlink_teardown(struct dsa_port *dp)
 		devlink_port_unregister(dlp);
 	dp->devlink_port_setup = false;
 }
+EXPORT_SYMBOL_GPL(dsa_port_devlink_teardown);
+
+static int dsa_port_reinit_as_unused(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->port_reinit_as_unused)
+		return ds->ops->port_reinit_as_unused(ds, dp->index);
+
+	dsa_port_devlink_teardown(dp);
+	dp->type = DSA_PORT_TYPE_UNUSED;
+	return dsa_port_devlink_setup(dp);
+}
 
 static int dsa_devlink_info_get(struct devlink *dl,
 				struct devlink_info_req *req,
@@ -911,9 +925,7 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
 		if (err) {
-			dsa_port_devlink_teardown(dp);
-			dp->type = DSA_PORT_TYPE_UNUSED;
-			err = dsa_port_devlink_setup(dp);
+			err = dsa_port_reinit_as_unused(dp);
 			if (err)
 				goto teardown;
 			continue;
-- 
2.25.1

