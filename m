Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C853CE831
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352596AbhGSQi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:38:57 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355136AbhGSQf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tyy2I6ABVmzdhfyPfHwWo2NJt9HUB4E16CddNsKHXonl0jiPoINkkiwpEQGhLhyZ++M8Pe2fhvsbz8e8eEaaPQtxymwyqSg/ZF1nExRRkQC/eJp8oC/G63sOkZqzSS0aKXTfD0iPlKhH4CmVW5qAii92B0YD0mS/r4vOqVLAAsEFw7gdLxeTRWBduilU/U8gbuafVZI4DF2GZqphqUjjjJhIw81KMxoOFaB4acRM4sGdFu6HGkSxJpm0f6KhkdS9y2+tgWvTsyStkTPQvJ3CXZzhjV4NSjT2BccvabrgTdUErMBZT7aQPuNTZa3EzWoxVJNPcAbD85+aEuhPNLNvnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzuwfDPv4elBY0Kph0lYxhhu39nN1bvzevVZdm0Oi4s=;
 b=UE3f+XVzR3r+T5PrFYWy/SBQDAt+YnqrNXTxlklItSnwc2IENTivZYcRX6APMoahLwdgRDiriy70gaCWfMHRf2V0lXIXTrUCo/AoYzGVh6GTdnp6Z7HxzfEImX8elYOCTxKH7gpZALBgov6J6HG2NA9Xc2DdhM6okohdW3BQfawdjvaLzCivekRqQ1qqg1Ug9aQpYdBNTvsh8y//WUSvfMkNRteLqReXnjQaR1ipey30jwEaoI+r6x60knNy8xhr8I701p5hmCLv0TUX+VX/3azelnwAXLRRAZMtpwg43HAX6w6nAMaH5QXPyeweHqfPISuLJR6X9YkNs+D59fs1Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzuwfDPv4elBY0Kph0lYxhhu39nN1bvzevVZdm0Oi4s=;
 b=Svrtb9EF6a5aH17FdncH2WN3F4KdqzlDWMRJs/7pxL9GCz79BoIXrNNKeTBReN+n+Snz2iWkj97KvyaKH/bsYjPCDmsV0qnlm1qpkik7xZ/2XeorJigWgiuCEsbTfQ7hLxVUZtd4cwNvb32U1M0aPZq2gbW/dwKpmpbMb/ofQ5g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 07/11] net: dsa: let the core manage the tag_8021q context
Date:   Mon, 19 Jul 2021 20:14:48 +0300
Message-Id: <20210719171452.463775-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57fb65ce-7f8b-477b-4fbd-08d94ad8e739
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407D345D64B114577CE683BE0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoJueF6A/PeI4C4rMDyWMYnNYKQb/GJ9c6qJnp4UvrYAlL4QkkbnCOJtlBLXeejypAs8j2Q0vO+Dxs8ah266uUibBN+wvjgqrVq+pd8JXQyuhTrkzDgfJspXzqfUJdz652ucD/l0iJcyPG3oNgsfG51Cr6fWVYeJlh1NQAdyLMsVX7OaVE5q1K3Lf87NjXYcpKhiXzv8EJ4+jf7Cf7TsjmA5Q5lL638z5mBsx9+fLJu16z9eDj22awjS7N5Iao5qwydBtoWBtDwS2aD4dCJl2rHEcGX/ixfHq24wrcq2bUEwoClpe3E2sG5z6yQsU1tB2SW2SFssj/6eA2GXJI6ySm763KyH02Nhrb5hmfg1uLxg4u4+yOl+A3rEEEQYw2krIozVhPQdUelrbvoZpzDlkI/o0qVLMRq9TvqPRJfITyiTZSwy+yvKlRNoq83aY8ggjf4DSTv5ahUWExGlDj/RBPgZKUhcPYUR9nkLgIFTrAOIOG1guYTUfHz2THZ7gDaDVRyWFqIVYOAq5EA/5MFnKIxp54ZBwZjLJnKDij6GQwzcHntyUQc8ITvCXxAy/z5EtUgB6FeZDI/bkj9KEQgjGV6X34rbYp27QhAcQHisc8nHxgjI7zmp1ctRu5uYYzfDiUyDTtbo46z4OiwUHETrteGfDVHPrGaLxGCjBVfAKSymHMutsze2fKYR7NWhbeGkNHxbgb3a/tbtpR7Ax9T9BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(30864003)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v6uHvSYIq0nv0zv56OSOymTCqtQEvm7FJpMQXYuSXcQTeMBFDjZdcOiO2d3F?=
 =?us-ascii?Q?DIGcuOJzaFNfpnbU/Naj0ib/P5FIBuv6GoaasZjtjMlj7+Xw85b4y4cxtUaN?=
 =?us-ascii?Q?9br74tP92CFWiK6/fCurCVPOSw0xqbyQSmCYvZAs9DjJ/a+fKPKsa6PFdVrb?=
 =?us-ascii?Q?1LLniY+ubQqZA01O+k+UZR9alknf/B3LhEjO3n8qzd9oojRz4HGVnkwlBLkc?=
 =?us-ascii?Q?MI9J4OszA2eD47/zmDW6h23VgXqclC9SJf8pjYzU0zJhXiMWtG7PCekPG9bW?=
 =?us-ascii?Q?ydYejwoQfiMQ8ghBo+BlUzWDigYcAdmc/U2i84UOp8DJXx7UGYwja3Meo+n/?=
 =?us-ascii?Q?0YKNympfFFcbR5hZ0Kwy0e11MUyeMDZ575oR3lNqz3XBtMlGuoMYlMrJhR0q?=
 =?us-ascii?Q?gEz9FF48yc/h8bUq9S1+LvD6jybU6G0oEZ5sMcLrwz3Pzgd7wtEUA9g6O4xm?=
 =?us-ascii?Q?Umpj331uciOGu7ic/3aTmeyWqfKlV7pFGyTTLPWw1C1l0A3hKhtqcer+snmH?=
 =?us-ascii?Q?z5dC0JjY7tbuDw+QcAqgrrdQ7yn0HZFkKnECkMmuLqjdBFKEWWw3+sazO0IL?=
 =?us-ascii?Q?EfbpZr3VRqEij8NfyNKyQ9zfKv/JQvQ8BBXafzrKudTNPBKLjDy0loIYo4MV?=
 =?us-ascii?Q?RsY7NH6ZBc8GImmlppHQRSfjUDkP8fF4VYkEfBLh88Mgexnh+steOhM5Ew7q?=
 =?us-ascii?Q?zBczcxJSw2VGwVi7r34lGg08/ZgiIEyqYAtp9xJb7xj6Mz4PXoDvS0rY9YU3?=
 =?us-ascii?Q?+HFhdl8xwpPI2mFmoxMHpHKLj5wuY7irMWS9ajwFhCvUBzzSctv7sn1Wx7Uz?=
 =?us-ascii?Q?CsGaM8pPcJRpzwD9gXcHMEqmND7ZCWsNlq28WWMOrr98+vVEI9UWXLOllvfZ?=
 =?us-ascii?Q?uDMQU8PopHHoanQeghq8/MhDWIuVFCNjVrYweH0zv8QE0yjzNJBz20+0d5Yq?=
 =?us-ascii?Q?TQSZQcT9Z2QMtyzIdJLLeE/zg4HGQwYYlYPyXmqVYp94s1p9rPhOww9kHSC9?=
 =?us-ascii?Q?vH/+Dos9M47LsxvT+3JYkXWAEkaVyKM360jQtCBs9tkYjb16M08cwZVqh2vT?=
 =?us-ascii?Q?CVFNKRgS3NMdCbz+80fxBJ2Liw77ZZ7bUIRD1XmV3iRd1xyKtL2eEohjcAwe?=
 =?us-ascii?Q?N4EOo1PydPuxZMlYYizGOHLm6eO2yWc0VSqQbIL5W6YLKFtLCEHJdjoRcVGu?=
 =?us-ascii?Q?3cBxBNWdvSRGIP9QcEoR1Gj57XrVC7XnNs8xaE9Jbu4Jrwlc1Skd/B8ikAZR?=
 =?us-ascii?Q?zivWo6FyTFxKfTt5LI6uTvAh+FpzzuKgeNiXq+oolWPrhR54fzw+LKZ24hZb?=
 =?us-ascii?Q?WS3Q1VwjrutXpA8ARwRE6qQk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57fb65ce-7f8b-477b-4fbd-08d94ad8e739
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:10.4878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ekCyi10HwafQUzBjl1rPCFfFpX5Xq9SEUjYtRQpZg31PM+HA12BRl6So9vRrLz3C1Bq66/HlIyN4HkRCw17Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The basic problem description is as follows:

Be there 3 switches in a daisy chain topology:

                                             |
    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
 [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
                                   |
                                   +---------+
                                             |
    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
 [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
                                   |
                                   +---------+
                                             |
    sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
 [  user ] [  user ] [  user ] [  user ] [  dsa  ]

The CPU will not be able to ping through the user ports of the
bottom-most switch (like for example sw2p0), simply because tag_8021q
was not coded up for this scenario - it has always assumed DSA switch
trees with a single switch.

To add support for the topology above, we must admit that the RX VLAN of
sw2p0 must be added on some ports of switches 0 and 1 as well. This is
in fact a textbook example of thing that can use the cross-chip notifier
framework that DSA has set up in switch.c.

There is only one problem: core DSA (switch.c) is not able right now to
make the connection between a struct dsa_switch *ds and a struct
dsa_8021q_context *ctx. Right now, it is drivers who call into
tag_8021q.c and always provide a struct dsa_8021q_context *ctx pointer,
and tag_8021q.c calls them back with the .tag_8021q_vlan_{add,del}
methods.

But with cross-chip notifiers, it is possible for tag_8021q to call
drivers without drivers having ever asked for anything. A good example
is right above: when sw2p0 wants to set itself up for tag_8021q,
the .tag_8021q_vlan_add method needs to be called for switches 1 and 0,
so that they transport sw2p0's VLANs towards the CPU without dropping
them.

So instead of letting drivers manage the tag_8021q context, add a
tag_8021q_ctx pointer inside of struct dsa_switch, which will be
populated when dsa_tag_8021q_register() returns success.

The patch is fairly long-winded because we are partly reverting commit
5899ee367ab3 ("net: dsa: tag_8021q: add a context structure") which made
the driver-facing tag_8021q API use "ctx" instead of "ds". Now that we
can access "ctx" directly from "ds", this is no longer needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  22 ++---
 drivers/net/dsa/ocelot/felix.h         |   1 -
 drivers/net/dsa/sja1105/sja1105.h      |   1 -
 drivers/net/dsa/sja1105/sja1105_main.c |  40 ++++-----
 include/linux/dsa/8021q.h              |  18 ++--
 include/net/dsa.h                      |   3 +
 net/dsa/tag_8021q.c                    | 114 +++++++++++++------------
 7 files changed, 99 insertions(+), 100 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b52cc381cdc1..9e4ae15aa4fb 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -425,14 +425,14 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
-	felix->dsa_8021q_ctx = dsa_tag_8021q_register(ds, &felix_tag_8021q_ops,
-						      htons(ETH_P_8021AD));
-	if (!felix->dsa_8021q_ctx)
-		return -ENOMEM;
+	err = dsa_tag_8021q_register(ds, &felix_tag_8021q_ops,
+				     htons(ETH_P_8021AD));
+	if (err)
+		return err;
 
-	err = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
+	err = dsa_8021q_setup(ds, true);
 	if (err)
-		goto out_free_dsa_8021_ctx;
+		goto out_tag_8021q_unregister;
 
 	err = felix_setup_mmio_filtering(felix);
 	if (err)
@@ -441,9 +441,9 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	return 0;
 
 out_teardown_dsa_8021q:
-	dsa_8021q_setup(felix->dsa_8021q_ctx, false);
-out_free_dsa_8021_ctx:
-	dsa_tag_8021q_unregister(felix->dsa_8021q_ctx);
+	dsa_8021q_setup(ds, false);
+out_tag_8021q_unregister:
+	dsa_tag_8021q_unregister(ds);
 	return err;
 }
 
@@ -458,11 +458,11 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 		dev_err(ds->dev, "felix_teardown_mmio_filtering returned %d",
 			err);
 
-	err = dsa_8021q_setup(felix->dsa_8021q_ctx, false);
+	err = dsa_8021q_setup(ds, false);
 	if (err)
 		dev_err(ds->dev, "dsa_8021q_setup returned %d", err);
 
-	dsa_tag_8021q_unregister(felix->dsa_8021q_ctx);
+	dsa_tag_8021q_unregister(ds);
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4d96cad815d5..9da3c6a94c6e 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -60,7 +60,6 @@ struct felix {
 	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
-	struct dsa_8021q_context	*dsa_8021q_ctx;
 	enum dsa_tag_protocol		tag_proto;
 };
 
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 869b19c08fc0..068be8afd322 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -257,7 +257,6 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
-	struct dsa_8021q_context *dsa_8021q_ctx;
 	struct devlink_region **regions;
 	struct sja1105_cbs_entry *cbs;
 	struct mii_bus *mdio_base_t1;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 689f46797d1c..ac4254690a8d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1995,8 +1995,6 @@ static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 					 int other_port, struct net_device *br)
 {
 	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
-	struct sja1105_private *other_priv = other_ds->priv;
-	struct sja1105_private *priv = ds->priv;
 	int port, rc;
 
 	if (other_ds->ops != &sja1105_switch_ops)
@@ -2008,17 +2006,13 @@ static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 		if (dsa_to_port(ds, port)->bridge_dev != br)
 			continue;
 
-		rc = dsa_8021q_crosschip_bridge_join(priv->dsa_8021q_ctx,
-						     port,
-						     other_priv->dsa_8021q_ctx,
+		rc = dsa_8021q_crosschip_bridge_join(ds, port, other_ds,
 						     other_port);
 		if (rc)
 			return rc;
 
-		rc = dsa_8021q_crosschip_bridge_join(other_priv->dsa_8021q_ctx,
-						     other_port,
-						     priv->dsa_8021q_ctx,
-						     port);
+		rc = dsa_8021q_crosschip_bridge_join(other_ds, other_port,
+						     ds, port);
 		if (rc)
 			return rc;
 	}
@@ -2032,8 +2026,6 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 					   struct net_device *br)
 {
 	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
-	struct sja1105_private *other_priv = other_ds->priv;
-	struct sja1105_private *priv = ds->priv;
 	int port;
 
 	if (other_ds->ops != &sja1105_switch_ops)
@@ -2045,22 +2037,19 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 		if (dsa_to_port(ds, port)->bridge_dev != br)
 			continue;
 
-		dsa_8021q_crosschip_bridge_leave(priv->dsa_8021q_ctx, port,
-						 other_priv->dsa_8021q_ctx,
+		dsa_8021q_crosschip_bridge_leave(ds, port, other_ds,
 						 other_port);
 
-		dsa_8021q_crosschip_bridge_leave(other_priv->dsa_8021q_ctx,
-						 other_port,
-						 priv->dsa_8021q_ctx, port);
+		dsa_8021q_crosschip_bridge_leave(other_ds, other_port,
+						 ds, port);
 	}
 }
 
 static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 {
-	struct sja1105_private *priv = ds->priv;
 	int rc;
 
-	rc = dsa_8021q_setup(priv->dsa_8021q_ctx, enabled);
+	rc = dsa_8021q_setup(ds, enabled);
 	if (rc)
 		return rc;
 
@@ -2233,6 +2222,7 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify);
 
 static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 {
+	struct dsa_8021q_context *ctx = priv->ds->tag_8021q_ctx;
 	struct sja1105_crosschip_switch *s, *pos;
 	struct list_head crosschip_switches;
 	struct dsa_8021q_crosschip_link *c;
@@ -2240,7 +2230,7 @@ static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 
 	INIT_LIST_HEAD(&crosschip_switches);
 
-	list_for_each_entry(c, &priv->dsa_8021q_ctx->crosschip_links, list) {
+	list_for_each_entry(c, &ctx->crosschip_links, list) {
 		bool already_added = false;
 
 		list_for_each_entry(s, &crosschip_switches, list) {
@@ -3306,10 +3296,10 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	priv->dsa_8021q_ctx = dsa_tag_8021q_register(ds, &sja1105_dsa_8021q_ops,
-						     htons(ETH_P_8021Q));
-	if (!priv->dsa_8021q_ctx)
-		return -ENOMEM;
+	rc = dsa_tag_8021q_register(ds, &sja1105_dsa_8021q_ops,
+				    htons(ETH_P_8021Q));
+	if (rc)
+		return rc;
 
 	INIT_LIST_HEAD(&priv->bridge_vlans);
 	INIT_LIST_HEAD(&priv->dsa_8021q_vlans);
@@ -3373,7 +3363,7 @@ static int sja1105_probe(struct spi_device *spi)
 out_unregister_switch:
 	dsa_unregister_switch(ds);
 out_tag_8021q_unregister:
-	dsa_tag_8021q_unregister(priv->dsa_8021q_ctx);
+	dsa_tag_8021q_unregister(ds);
 
 	return rc;
 }
@@ -3384,7 +3374,7 @@ static int sja1105_remove(struct spi_device *spi)
 	struct dsa_switch *ds = priv->ds;
 
 	dsa_unregister_switch(ds);
-	dsa_tag_8021q_unregister(priv->dsa_8021q_ctx);
+	dsa_tag_8021q_unregister(ds);
 
 	return 0;
 }
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 9945898a90c3..77939c0c8dd5 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -34,20 +34,20 @@ struct dsa_8021q_context {
 	__be16 proto;
 };
 
-struct dsa_8021q_context *dsa_tag_8021q_register(struct dsa_switch *ds,
-						 const struct dsa_8021q_ops *ops,
-						 __be16 proto);
+int dsa_tag_8021q_register(struct dsa_switch *ds,
+			   const struct dsa_8021q_ops *ops,
+			   __be16 proto);
 
-void dsa_tag_8021q_unregister(struct dsa_8021q_context *ctx);
+void dsa_tag_8021q_unregister(struct dsa_switch *ds);
 
-int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled);
+int dsa_8021q_setup(struct dsa_switch *ds, bool enabled);
 
-int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
-				    struct dsa_8021q_context *other_ctx,
+int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
+				    struct dsa_switch *other_ds,
 				    int other_port);
 
-int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
-				     struct dsa_8021q_context *other_ctx,
+int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
+				     struct dsa_switch *other_ds,
 				     int other_port);
 
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 33f40c1ec379..e213572f6341 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -352,6 +352,9 @@ struct dsa_switch {
 	unsigned int ageing_time_min;
 	unsigned int ageing_time_max;
 
+	/* Storage for drivers using tag_8021q */
+	struct dsa_8021q_context *tag_8021q_ctx;
+
 	/* devlink used to represent this switch device */
 	struct devlink		*devlink;
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 16eb2c7bcc8d..de46a551a486 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -113,10 +113,11 @@ EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
  * user explicitly configured this @vid through the bridge core, then the @vid
  * is installed again, but this time with the flags from the bridge layer.
  */
-static int dsa_8021q_vid_apply(struct dsa_8021q_context *ctx, int port, u16 vid,
+static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 			       u16 flags, bool enabled)
 {
-	struct dsa_port *dp = dsa_to_port(ctx->ds, port);
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (enabled)
 		return ctx->ops->vlan_add(ctx->ds, dp->index, vid, flags);
@@ -176,29 +177,29 @@ static int dsa_8021q_vid_apply(struct dsa_8021q_context *ctx, int port, u16 vid,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
-				bool enabled)
+static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 {
-	int upstream = dsa_upstream_port(ctx->ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ctx->ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ctx->ds, port);
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
+	int upstream = dsa_upstream_port(ds, port);
+	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
 	struct net_device *master;
 	int i, err;
 
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
 	 */
-	if (!dsa_is_user_port(ctx->ds, port))
+	if (!dsa_is_user_port(ds, port))
 		return 0;
 
-	master = dsa_to_port(ctx->ds, port)->cpu_dp->master;
+	master = dsa_to_port(ds, port)->cpu_dp->master;
 
 	/* Add this user port's RX VID to the membership list of all others
 	 * (including itself). This is so that bridging will not be hindered.
 	 * L2 forwarding rules still take precedence when there are no VLAN
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
-	for (i = 0; i < ctx->ds->num_ports; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		u16 flags;
 
 		if (i == upstream)
@@ -211,9 +212,9 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 			/* The RX VID is a regular VLAN on all others */
 			flags = BRIDGE_VLAN_INFO_UNTAGGED;
 
-		err = dsa_8021q_vid_apply(ctx, i, rx_vid, flags, enabled);
+		err = dsa_8021q_vid_apply(ds, i, rx_vid, flags, enabled);
 		if (err) {
-			dev_err(ctx->ds->dev,
+			dev_err(ds->dev,
 				"Failed to apply RX VID %d to port %d: %pe\n",
 				rx_vid, port, ERR_PTR(err));
 			return err;
@@ -223,9 +224,9 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 	/* CPU port needs to see this port's RX VID
 	 * as tagged egress.
 	 */
-	err = dsa_8021q_vid_apply(ctx, upstream, rx_vid, 0, enabled);
+	err = dsa_8021q_vid_apply(ds, upstream, rx_vid, 0, enabled);
 	if (err) {
-		dev_err(ctx->ds->dev,
+		dev_err(ds->dev,
 			"Failed to apply RX VID %d to port %d: %pe\n",
 			rx_vid, port, ERR_PTR(err));
 		return err;
@@ -238,17 +239,17 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 		vlan_vid_del(master, ctx->proto, rx_vid);
 
 	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_8021q_vid_apply(ctx, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
+	err = dsa_8021q_vid_apply(ds, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
 				  enabled);
 	if (err) {
-		dev_err(ctx->ds->dev,
+		dev_err(ds->dev,
 			"Failed to apply TX VID %d on port %d: %pe\n",
 			tx_vid, port, ERR_PTR(err));
 		return err;
 	}
-	err = dsa_8021q_vid_apply(ctx, upstream, tx_vid, 0, enabled);
+	err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
 	if (err) {
-		dev_err(ctx->ds->dev,
+		dev_err(ds->dev,
 			"Failed to apply TX VID %d on port %d: %pe\n",
 			tx_vid, upstream, ERR_PTR(err));
 		return err;
@@ -257,16 +258,16 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 	return err;
 }
 
-int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
+int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
 {
 	int err, port;
 
 	ASSERT_RTNL();
 
-	for (port = 0; port < ctx->ds->num_ports; port++) {
-		err = dsa_8021q_setup_port(ctx, port, enabled);
+	for (port = 0; port < ds->num_ports; port++) {
+		err = dsa_8021q_setup_port(ds, port, enabled);
 		if (err < 0) {
-			dev_err(ctx->ds->dev,
+			dev_err(ds->dev,
 				"Failed to setup VLAN tagging for port %d: %pe\n",
 				port, ERR_PTR(err));
 			return err;
@@ -277,24 +278,25 @@ int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_setup);
 
-static int dsa_8021q_crosschip_link_apply(struct dsa_8021q_context *ctx,
-					  int port,
-					  struct dsa_8021q_context *other_ctx,
+static int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
+					  struct dsa_switch *other_ds,
 					  int other_port, bool enabled)
 {
-	u16 rx_vid = dsa_8021q_rx_vid(ctx->ds, port);
+	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 
 	/* @rx_vid of local @ds port @port goes to @other_port of
 	 * @other_ds
 	 */
-	return dsa_8021q_vid_apply(other_ctx, other_port, rx_vid,
+	return dsa_8021q_vid_apply(other_ds, other_port, rx_vid,
 				   BRIDGE_VLAN_INFO_UNTAGGED, enabled);
 }
 
-static int dsa_8021q_crosschip_link_add(struct dsa_8021q_context *ctx, int port,
-					struct dsa_8021q_context *other_ctx,
+static int dsa_8021q_crosschip_link_add(struct dsa_switch *ds, int port,
+					struct dsa_switch *other_ds,
 					int other_port)
 {
+	struct dsa_8021q_context *other_ctx = other_ds->tag_8021q_ctx;
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_8021q_crosschip_link *c;
 
 	list_for_each_entry(c, &ctx->crosschip_links, list) {
@@ -305,9 +307,9 @@ static int dsa_8021q_crosschip_link_add(struct dsa_8021q_context *ctx, int port,
 		}
 	}
 
-	dev_dbg(ctx->ds->dev,
+	dev_dbg(ds->dev,
 		"adding crosschip link from port %d to %s port %d\n",
-		port, dev_name(other_ctx->ds->dev), other_port);
+		port, dev_name(other_ds->dev), other_port);
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c)
@@ -323,7 +325,7 @@ static int dsa_8021q_crosschip_link_add(struct dsa_8021q_context *ctx, int port,
 	return 0;
 }
 
-static void dsa_8021q_crosschip_link_del(struct dsa_8021q_context *ctx,
+static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
 					 struct dsa_8021q_crosschip_link *c,
 					 bool *keep)
 {
@@ -332,7 +334,7 @@ static void dsa_8021q_crosschip_link_del(struct dsa_8021q_context *ctx,
 	if (*keep)
 		return;
 
-	dev_dbg(ctx->ds->dev,
+	dev_dbg(ds->dev,
 		"deleting crosschip link from port %d to %s port %d\n",
 		c->port, dev_name(c->other_ctx->ds->dev), c->other_port);
 
@@ -347,8 +349,8 @@ static void dsa_8021q_crosschip_link_del(struct dsa_8021q_context *ctx,
  * or untagged: it doesn't matter, since it should never egress a frame having
  * our @rx_vid.
  */
-int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
-				    struct dsa_8021q_context *other_ctx,
+int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
+				    struct dsa_switch *other_ds,
 				    int other_port)
 {
 	/* @other_upstream is how @other_ds reaches us. If we are part
@@ -356,49 +358,50 @@ int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
 	 * our CPU ports. If we're part of the same tree though, we should
 	 * probably use dsa_towards_port.
 	 */
-	int other_upstream = dsa_upstream_port(other_ctx->ds, other_port);
+	int other_upstream = dsa_upstream_port(other_ds, other_port);
 	int err;
 
-	err = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_port);
+	err = dsa_8021q_crosschip_link_add(ds, port, other_ds, other_port);
 	if (err)
 		return err;
 
-	err = dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
+	err = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
 					     other_port, true);
 	if (err)
 		return err;
 
-	err = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_upstream);
+	err = dsa_8021q_crosschip_link_add(ds, port, other_ds, other_upstream);
 	if (err)
 		return err;
 
-	return dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
+	return dsa_8021q_crosschip_link_apply(ds, port, other_ds,
 					      other_upstream, true);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_join);
 
-int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
-				     struct dsa_8021q_context *other_ctx,
+int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
+				     struct dsa_switch *other_ds,
 				     int other_port)
 {
-	int other_upstream = dsa_upstream_port(other_ctx->ds, other_port);
+	struct dsa_8021q_context *other_ctx = other_ds->tag_8021q_ctx;
+	int other_upstream = dsa_upstream_port(other_ds, other_port);
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_8021q_crosschip_link *c, *n;
 
 	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
 		if (c->port == port && c->other_ctx == other_ctx &&
 		    (c->other_port == other_port ||
 		     c->other_port == other_upstream)) {
-			struct dsa_8021q_context *other_ctx = c->other_ctx;
 			int other_port = c->other_port;
 			bool keep;
 			int err;
 
-			dsa_8021q_crosschip_link_del(ctx, c, &keep);
+			dsa_8021q_crosschip_link_del(ds, c, &keep);
 			if (keep)
 				continue;
 
-			err = dsa_8021q_crosschip_link_apply(ctx, port,
-							     other_ctx,
+			err = dsa_8021q_crosschip_link_apply(ds, port,
+							     other_ds,
 							     other_port,
 							     false);
 			if (err)
@@ -410,15 +413,15 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_leave);
 
-struct dsa_8021q_context *dsa_tag_8021q_register(struct dsa_switch *ds,
-						 const struct dsa_8021q_ops *ops,
-						 __be16 proto)
+int dsa_tag_8021q_register(struct dsa_switch *ds,
+			   const struct dsa_8021q_ops *ops,
+			   __be16 proto)
 {
 	struct dsa_8021q_context *ctx;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return NULL;
+		return -ENOMEM;
 
 	ctx->ops = ops;
 	ctx->proto = proto;
@@ -426,12 +429,15 @@ struct dsa_8021q_context *dsa_tag_8021q_register(struct dsa_switch *ds,
 
 	INIT_LIST_HEAD(&ctx->crosschip_links);
 
-	return ctx;
+	ds->tag_8021q_ctx = ctx;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
 
-void dsa_tag_8021q_unregister(struct dsa_8021q_context *ctx)
+void dsa_tag_8021q_unregister(struct dsa_switch *ds)
 {
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_8021q_crosschip_link *c, *n;
 
 	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
@@ -439,6 +445,8 @@ void dsa_tag_8021q_unregister(struct dsa_8021q_context *ctx)
 		kfree(c);
 	}
 
+	ds->tag_8021q_ctx = NULL;
+
 	kfree(ctx);
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_unregister);
-- 
2.25.1

