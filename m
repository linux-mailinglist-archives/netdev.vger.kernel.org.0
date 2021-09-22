Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFCF414C49
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhIVOps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:45:48 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:19854
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230356AbhIVOpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:45:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERCCIdlAj3qL89jGcQl+1xpw/o4GjOcj3ffD0jSn95kNUPbE2hD/dVW1I9YONi5dN5LQLqTTjXhM+xDVkBrYRNuSoHUEqogpsw7+NDOz/nQP5wCHqcnVbQ9+Z7GUFIG/irM8/Bo/CcIba4QgFmcQUifTFQLQYUaWpM2XYQbvBzr9ILD4m4BdjWsfoawtnrejKmmU9Hrw4c1tCxpYQp+CG5LJ1Km50vHUwrvQsfy6tL1PU2qChdoy2iZRr750mLR53Yfj69s14mBBU+RfLYE6JE8BuHyy+VIEbqpg3RXUUG4SVcf8GjM2fg0ZSFB6nAl6/z60ZPrRp9fDchXS1AobUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FcjBla0I32+NES52YFWzIxENkptpXcL6C14pSAo7t0k=;
 b=n9IJZFs8jC5MGXSzHizQsRaaesLpNuVkLgsajaN10AV5Nuf7v77NQGPaP5rpuNCMxjUBMEZrxWtYg+R22PEAyyYJHgSHIeeY0nS00E+yfCx8xdrRZbsy7LkMoOaxDMlBkjBFYq7BCfekHglb0MVjKOD2rv1S9r3oyeLnvSMWSRVPRvW9xlBBKuNtsKIqlf0Oor7CXxhlmEaz7avIlcKfL2rOwtH/D+fghOIXFZuItNeDzAEOTYSnvXhIINWAoQ5WGkuDLg/EJ0BuFSItbU5CctNwi1oAF5XpvdCdQLMEDpOT+uIVoZOF//XyGJNYjn5KwYyiraLgWG50Yy4PMfUseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcjBla0I32+NES52YFWzIxENkptpXcL6C14pSAo7t0k=;
 b=lV0qRU4xMO27dI41z+ZoL2raL8HjWXsPJwNxhg4dIxyItFnLPzlJYL+uksYuPvychsJCxQeoL2sVL9mNnPzS/n2/8NL3maOqzApXahPoOCBxwvO9AfSSn2Jp1ummqySt7Jtkgtxw4D1cB3ohQ86wECHaC/MmTfJdVJFunAUrtK8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:44:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 14:44:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dsa: sja1105: stop using priv->vlan_aware
Date:   Wed, 22 Sep 2021 17:44:01 +0300
Message-Id: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0058.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR3P189CA0058.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 14:44:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22114f34-b508-40b6-4587-08d97dd77154
X-MS-TrafficTypeDiagnostic: VI1PR04MB6944:
X-Microsoft-Antispam-PRVS: <VI1PR04MB69445130FF2CBC2219CE1316E0A29@VI1PR04MB6944.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NbsNl2Upxd450mFKfdyt8xTMTVUebv9dF2tR4yuMMMsul+s+z+BJ8lk1rlnBZYsz8GY/LtDV0hdKpB20nq+7Rx1WgE5/DyfLmTKrZgoeUmKdvNnVqse+r3DQ7MbskFWYe2mpGLfbKTBEP4HKot0NXmybDMxWTp5Jd+wOkrK7k9ZxHoOkfJYDjDEZznjk9oHLMmVVmFsAM6JTtpo6wrIDbFNkD7t9J71yNULk3n2x50W/aweUTEwpuiz73RdnoqyEZTVhqN5GxrP74uArRH0RxO8TOKi8FpARc82I30JbMeUoT/TUkj/jnz8wVsR44fb8AxlkNxUEsAFzE6IlsXtdYh3fg878zK8PJxEatNGWh/Xmbm1TnwSH7f9AK31Bt24CuW9DaF9V9qQjqtNq/BD2oIoU560GWu/0M1Xf9zSVBxosFfP8eSuH5/k0phOzAeXqge0KJUnOEmZxXDfCFX64lnaFfCJ2jEMwwxHQcrqlSxzLt+INdd4bllNcH+VrR6y4xT7L6Nnk33hHiwnsk5w6roTD5Fxvjs+3DmpAmkaQKokRx+AyOJO49iR6D5tE8loICYBSyNt3ln4awq9C2VO0/4NQpALiQllXpCyos0raLUVpTTpgZQAlNkcIuxpSig9p+UrOs9d23jTDqgWOi81FVazEoCtdIE6v5wURfjN2jvbqgbBQQVVMcB679IrJ+DDae//9qMnb+S159BuaSV8ebQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(956004)(2906002)(36756003)(1076003)(5660300002)(6486002)(316002)(8936002)(54906003)(4326008)(26005)(508600001)(66476007)(6506007)(66946007)(86362001)(6512007)(66556008)(186003)(38350700002)(6666004)(8676002)(52116002)(6916009)(38100700002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wadrBAj4Nqf8WCU0PkoKOw6Xiv9mybNdxdXP+KkUM3Tdu8mwcjzxyRW5Z1bR?=
 =?us-ascii?Q?2D8pq0JXORxm1bM/+Z8A6SxTme6lUILpsomeGGlk6XPHVbRkKCK0yLLKKUmn?=
 =?us-ascii?Q?hrB0R5GhCVPprg0Hq5yde0oNt+lif7HHeQmT+M9+OwOnbe/ZDdxiiaj4wjXF?=
 =?us-ascii?Q?6allbpyHh7zRQq/vogwjwXHhfEJw5AcSovrCw08A8aJ0hkWSssVKC5pMywij?=
 =?us-ascii?Q?6fgVyoi5xDzFT9OJRswh9lCkDdqCqZBwQjQegV4Y+KG4RagPRie57lTI2ZkH?=
 =?us-ascii?Q?nyvKeXvR9cuguYg14TIIrc35GZ8CjPqIqExjNmi2rAfoDFDhBf53ldfR3vYt?=
 =?us-ascii?Q?q2vsw/a0doYGhEwC804/uOkQ9bDjA1PzdXmvSlxLMuw6kKU9OhUPu5nE9mwh?=
 =?us-ascii?Q?zqkvhr62TQlZxYQTQjNHqsnVZhhvPhuLs0qJJPLwi3kLynDGua2UOAT82hNq?=
 =?us-ascii?Q?fqXVdDbdNRk0YH/qDwOG28+u0o270bv4kTvVLbt89QiAhmpHEkqy6aMZYJkX?=
 =?us-ascii?Q?gYU0HWj4GIpV9gQbT7wdirc50lILTwDcYlKHWYSpXPs4WyuZqltTqpAktnsY?=
 =?us-ascii?Q?64ydoHRgjdHlp2SJVWIeb99dnA7G/IZVhL5GVIneQVQFgnt6N/TKgSyRa+YU?=
 =?us-ascii?Q?ehxtFWyPTDXiO6ZBDN5Qa1zyKIPyVhJvzPp5n1sljG1PNx8Qvvt67L3Y5Lop?=
 =?us-ascii?Q?3N0qJcjr56Ud9jhOy8esEQ8WBPEcqZw8AXewHJOycoULtYHqwjxptQRUZSZo?=
 =?us-ascii?Q?c2kF1gn7zLPm4EzY6dVDUVpPsFXgy/dKe7UcoSqFrdwEiQoztDIdzNgDTMiz?=
 =?us-ascii?Q?uQ+PauSTJZYUMP6h0WRl8hg6BtvkBaF/5UY3t34dUcXDtxHfzkLteDiftvWy?=
 =?us-ascii?Q?VXqn6bk4l6N5wKS41POHQTN2g9G1tmsxW6SC/A2hV1WVXDGvKpdBAa4eM/MG?=
 =?us-ascii?Q?gPLHHLyKtz3RTJDTTa7myLPPsQOnHTXmoRa1gPmzqYwdgVgqnisIOv/QvbAx?=
 =?us-ascii?Q?DwqYFEgvXzPob5tyPMAXMgLw5R7eMbej+++BZ7UbfGWYjTiFqdRBSkomebtM?=
 =?us-ascii?Q?POIxpPz4QJLy0o1dOPI3H9/Sy0qbBnFwmssfipGkSWqVZSSrRymozneEBbbs?=
 =?us-ascii?Q?Vc/plgnh9rfDum24EAi265v0yZnOrbh27LNdkMiOyFywl9/AZ+hYOYif/MkT?=
 =?us-ascii?Q?qJQXEDgK7e56gNxrQa1q41rv4iqfdCoe2onE18Yi97KArlokvOtNfGfvoBkC?=
 =?us-ascii?Q?Bz3r/AgR0u5zW4qQEhQiYz8owQPhJyiUFcOoZC7TO+nHVSQH/JukzV3vw8Ww?=
 =?us-ascii?Q?GVCYCJ6R4n7YVmvTPZ5aQL0n?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22114f34-b508-40b6-4587-08d97dd77154
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 14:44:12.3624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dj4Hloi3ayVQu+EMPxXrng0lwK6FMQhJmOk2KJ6oYQ4FNhk93IdW+zl2pdhRDoX8wYXsLCQ6GeXOtZ0BMxrN/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the sja1105 driver is finally sane enough again to stop having
a ternary VLAN awareness state, we can remove priv->vlan_aware and query
DSA for the ds->vlan_filtering value (for SJA1105, VLAN filtering is a
global property).

Also drop the paranoid checking that DSA calls ->port_vlan_filtering
multiple times without the VLAN awareness state changing. It doesn't,
the same check is present inside dsa_port_vlan_filtering too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c |  9 ++-------
 drivers/net/dsa/sja1105/sja1105_vl.c   | 13 +++++++++----
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 5e5d24e7c02b..b83a5114348c 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -226,7 +226,6 @@ struct sja1105_private {
 	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
 	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
-	bool vlan_aware;
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
 	const struct sja1105_info *info;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 181d814bd4e7..4d2114449cd6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1802,7 +1802,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (!priv->vlan_aware)
+		if (!dsa_port_is_vlan_filtering(ds, port))
 			l2_lookup.vlanid = 0;
 		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 		if (rc)
@@ -2295,11 +2295,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 		tpid2 = ETH_P_SJA1105;
 	}
 
-	if (priv->vlan_aware == enabled)
-		return 0;
-
-	priv->vlan_aware = enabled;
-
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
@@ -2332,7 +2327,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !priv->vlan_aware;
+	l2_lookup_params->shared_learn = !enabled;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index ec7b65daec20..0f77ec78094b 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -494,13 +494,16 @@ int sja1105_vl_redirect(struct sja1105_private *priv, int port,
 			bool append)
 {
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	struct dsa_switch *ds = priv->ds;
 	int rc;
 
-	if (!priv->vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	if (!dsa_port_is_vlan_filtering(ds, port) &&
+	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (priv->vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if (dsa_port_is_vlan_filtering(ds, port) &&
+		   key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
@@ -592,11 +595,13 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		return -ERANGE;
 	}
 
-	if (!priv->vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	if (!dsa_port_is_vlan_filtering(ds, port) &&
+	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (priv->vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if (dsa_port_is_vlan_filtering(ds, port) &&
+		   key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
-- 
2.25.1

