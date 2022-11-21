Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B2663246F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiKUN4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiKUN4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:23 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80080.outbound.protection.outlook.com [40.107.8.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E69ABF80A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYGCXBv2YHhrM8SImwvuWQw38GWr+1GE/Vd4ij/eA63X3pBEP7og3iuAB4GxpJu9XuOg81KgIXcTEOgtIdEm/wzGlYLkwyBxo+tQXMp03DUngDVYXcgnHpiGwYY/6ACWdC0pXR0ewzcEuezZVQgvU3SwwLNi+HK5kENlbj7r2rBw2qd/gr/nYpD23+7noKGh+0vhcKi2hQXjjRH1dLb1PbT2/n0YX+wsxy5XpqUrfPtVPzZrj7/A1uO45TwhY6kv8j5lrawUTJYQT8hGXUwK4wqaLDXq3ntUJcdeJmJuQWZDiEzeuEMthRNAtpgXkmPDUX0nGDozS2lGLyKXZMu2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAF3wnp+gySgOTAUnpHbyx1SM5uKbNOh1Q5P5Zp0JoA=;
 b=EXhbprtJcyWZ2zq5ybj/wV8xJxwcRVWofrf3WTYno095JgWBmc0IUid1cHZCfJ8IW184YRFxxsp8/wEIc2+YqcocyGSJd2bTRUbrPWAofHkhqoTDnM2VLyfHLS6W69VfWUt9h4/tpkTF6xXFUGvC+efIbH/4fZXDq82oBZShkYIPIdQaO/DDuNCZ6u2K43dR5NkiaOqtp/ADxfwgN5S9oWUnMu4MONfwZ8UqkyUWAVMmEa16XFfVvrpPcI6i+3lsLQvUY/wAwL0vKxE93tMwtHfGCWDmj9oHSo6cpVUAXGHvJof4PqqzxzqGMf0u4DQN5hKGbfLYXOUAtedp1AtPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAF3wnp+gySgOTAUnpHbyx1SM5uKbNOh1Q5P5Zp0JoA=;
 b=iQIlnj6uTDOTw92Ji8CSTEYoQn/aOgS6k06ft40irxwNvJ4U6nnU8Covm4SPCa+QbapG/Japp3yTfg3b/OOdwwIZdI3gK5zh1dgHrSHNZPY2UMdbOmCo6KF/HtqhKbt+2WqZ/czWz/pcSJC2fcRSch50QcI7zMoqfo/JH3gGf5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 05/17] net: dsa: move rest of devlink setup/teardown to devlink.c
Date:   Mon, 21 Nov 2022 15:55:43 +0200
Message-Id: <20221121135555.1227271-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: eef3e61e-1528-4db5-69a8-08dacbc8284f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZwgpFV30Q1P/GgYRmaZaPcf/6cdh0gahYvqXonX+qWfQvBSkJTQ64Cr73A9MK7UBlXpYQW2yyPDo5JP6UYH459HoKt1zKCvbt+FbYifFfa0WpIZqVm0ibYyylaP7X+yffd3UC+L2lC38StIh+oFIZ3I3dbcy3ICQdGussUj1vJN18qRoItJjG3lDVXmqC1IPKt1mUiL6Aa3r3vc/lWB95kspaE2GrxlTknTK93e/wtgyxYyBXGsR1642Oz00RIKuR+6U1pMKiQiid0wv+tQEtY4np0lIYRhHjmmnSikqxO+/dwBSjgebhw21ur+wzXgq/cnv8kNE3pQlBuX5GdQJzHvD8Sr+YRZxPYnmIOOwSp7GtZlEpyQAZmiOI9DZm66hoMHrESqvJp9OEVlI6wSseqCN8CEYKhhE59J0oxYwHQ8nrAGIgLCgTvzjxrEUPwDVv0jh1avalzXE4FaAGietWtFpO0iQsLBusMpq4bJ25Ova7wPRHdGJ6hlKwX/Nn7J4ilCmMNXv7MY/Iw+ujEcpYCgOZ77WAK4HGkAtC/POHD5IPmEUZqTPH5dXI8hNe+cUhNa54/+YkOODId3Phbz8a4PH3LJXEeb0t7mozCJxYEXe9LxzTUsAPGH/VtK2GoM8k+DhfuCTfY2+MV/YecIe4DIksSKrmL1p1gr5xGqa0h6lqDhneGQ+1LDDQMvIsyTabEBWt1iL7U2waXX76SEZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tTsEfIqXxiKV3EBO9Ge7cOgncatz9omkjAE2/ZW2v/6FwcA8gZcJiaL7jTGL?=
 =?us-ascii?Q?srUZnsVTyK9ZRCf0u/LndNstfEC4Vyp+2E9gl3rRKRoEbrXSqGbL1f9lIf0b?=
 =?us-ascii?Q?UhwNSvj+I57LrZbUqmb2gSe2lsCvrTSTcX3I7I9U8wmLkvd9IQrhux0wbpA9?=
 =?us-ascii?Q?3mkOO7FKcj3Z4SiU67em+1wt3M9hQN+1NMPNZekUiiW+kjE1bK+NrHJh/+t7?=
 =?us-ascii?Q?VHaJ7US+3DD5mz9oJx7Od1UiwyEeD+KsSonJIgkvkTps+VuvsyCi3I3nZmxJ?=
 =?us-ascii?Q?hDk8aYdNh91/ExIuyfTnSzXATkExX88MXz5hYweYv4ckftCZl4rP/Ee6GaiR?=
 =?us-ascii?Q?mmzAm72HIcRHzwHK6K1ClzlH+e48kv2GeKDlUpsLP4lkeqTZ/WFflzPIj/i8?=
 =?us-ascii?Q?auKCEEekRlvMtJbg7UH6z0XhGDHPMdYMG/MlbKNAzUXXi3Z+JMH+y2s29xc8?=
 =?us-ascii?Q?hZNkN44w3PtnJ5q/mxtoQXSvTTdxdEilA5c1FkTzT6UNO4M49T1quBtZgShu?=
 =?us-ascii?Q?lCVYrQyNHU77RRtIq/gdpEZ1mVtvS+WbNMg1XiXEy/BEmA3fNpS0Va03vXCR?=
 =?us-ascii?Q?WwUXsbNyNdRhRGBGZaWqE9bDf8HQonUDYG2HAtymWPnq2sk9BMh/hG92HlWS?=
 =?us-ascii?Q?QcW994dTs1CseqTKL0DbV6mgcpOZ3NOmrU7FV8Qtg4TOglyIceDohw73GKS8?=
 =?us-ascii?Q?lSpKPTx+kkaSO7a9n13wfOgnQ/iR23T5+YiCaZ3ZXSqcVLCUUKx81UuNDxZ/?=
 =?us-ascii?Q?B3iBkbWhTOrVYnf3xQMhznw/VM5rv9aDKFVXo9lrDJ4ioRJ5w2m8QrPs0AyG?=
 =?us-ascii?Q?daYl2QjFzPGll+teiXCZKyB2qvy25UHNjttH8uGp9yWvn0cjao6caHG79rBp?=
 =?us-ascii?Q?TqQ1cChNnFMqwF9agPJflbpk8q4Kqfi7l5kIuGqJPJokDbJEQ3Q6IEucthWF?=
 =?us-ascii?Q?+8rEZ7RjpqAfpu1ZwDASomLoOSWrLg3DaCmLXEdqpsy7XiLzxo7CzEDf6E26?=
 =?us-ascii?Q?kaPXj2XWCtL2H3vdTsFhsphAp58xX7296UCKMWu0HWn3dFZr/NfngLwET+4X?=
 =?us-ascii?Q?/NWtubWIg/J3IAyjJny+1lqq9PCNMBdDwvA89aC0EuS+tIaw8G/rElgTavN1?=
 =?us-ascii?Q?Wbca7P3r3oOyCZkzlKBJcTupokLXChDRN0pjKT5CM8q4jaflX2HXR99YpYTK?=
 =?us-ascii?Q?9836502FbmIwsS7uEczxxSoG9Vye4y/DWm+xcuDYSZkmpala/hdHReBavfj1?=
 =?us-ascii?Q?q75U/GDTlZBVZSeCcIzShzKrXq0A2hBtCKQt2XarAG+kzakcjGipB6e2bJ+P?=
 =?us-ascii?Q?Qvrb0R14UvZMw15bn1DLNqrBmgjUaOcp5FXdQq8tV2uCYIG0WYzVJE7c//E3?=
 =?us-ascii?Q?4FSmdvdEkBEOJWLU9r4ydnCI1EubsHkbTj/IigeYwO4kaKiyB6gQseq+sxqr?=
 =?us-ascii?Q?FL39IDbL5q58WLmi5njDvXLAsLfgxI1EtbWsH9GT/rYH7Nw8ZSoa/R+BLPcw?=
 =?us-ascii?Q?M9sAvrNit+RJc+8z8NT2ZoBreG2nohpy9zEKZMTjb5nWhOrl+H7uz26X1bnc?=
 =?us-ascii?Q?xrrfphnkACjmceFs0fAcwz5zWjig/EdQzssIOWN7Nbq3b6nxpGrPuYWoa0Il?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef3e61e-1528-4db5-69a8-08dacbc8284f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:15.8255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1nnjMrGcXbIwKM/8Gs/OEh5VKtmxAYHqfWDIqACfThK17cu8j4PO7jNJ2bnbazaKFiSMGoK2flIiRI84qzZyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code that needed further refactoring into dedicated functions in
dsa2.c was left aside. Move it now to devlink.c, and make dsa2.c stop
including net/devlink.h.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/devlink.c | 38 +++++++++++++++++++++++++++++++++++++-
 net/dsa/devlink.h |  7 +++++--
 net/dsa/dsa2.c    | 24 +++++++-----------------
 3 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/net/dsa/devlink.c b/net/dsa/devlink.c
index eff440b2b3c5..431bf52290a1 100644
--- a/net/dsa/devlink.c
+++ b/net/dsa/devlink.c
@@ -167,7 +167,7 @@ dsa_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
 							p_max);
 }
 
-const struct devlink_ops dsa_devlink_ops = {
+static const struct devlink_ops dsa_devlink_ops = {
 	.info_get			= dsa_devlink_info_get,
 	.sb_pool_get			= dsa_devlink_sb_pool_get,
 	.sb_pool_set			= dsa_devlink_sb_pool_set,
@@ -353,3 +353,39 @@ void dsa_port_devlink_teardown(struct dsa_port *dp)
 
 	devlink_port_fini(dlp);
 }
+
+void dsa_switch_devlink_register(struct dsa_switch *ds)
+{
+	devlink_register(ds->devlink);
+}
+
+void dsa_switch_devlink_unregister(struct dsa_switch *ds)
+{
+	devlink_unregister(ds->devlink);
+}
+
+int dsa_switch_devlink_alloc(struct dsa_switch *ds)
+{
+	struct dsa_devlink_priv *dl_priv;
+	struct devlink *dl;
+
+	/* Add the switch to devlink before calling setup, so that setup can
+	 * add dpipe tables
+	 */
+	dl = devlink_alloc(&dsa_devlink_ops, sizeof(*dl_priv), ds->dev);
+	if (!dl)
+		return -ENOMEM;
+
+	ds->devlink = dl;
+
+	dl_priv = devlink_priv(ds->devlink);
+	dl_priv->ds = ds;
+
+	return 0;
+}
+
+void dsa_switch_devlink_free(struct dsa_switch *ds)
+{
+	devlink_free(ds->devlink);
+	ds->devlink = NULL;
+}
diff --git a/net/dsa/devlink.h b/net/dsa/devlink.h
index d077c7f336da..4d9f4f23705b 100644
--- a/net/dsa/devlink.h
+++ b/net/dsa/devlink.h
@@ -4,10 +4,13 @@
 #define __DSA_DEVLINK_H
 
 struct dsa_port;
-
-extern const struct devlink_ops dsa_devlink_ops;
+struct dsa_switch;
 
 int dsa_port_devlink_setup(struct dsa_port *dp);
 void dsa_port_devlink_teardown(struct dsa_port *dp);
+void dsa_switch_devlink_register(struct dsa_switch *ds);
+void dsa_switch_devlink_unregister(struct dsa_switch *ds);
+int dsa_switch_devlink_alloc(struct dsa_switch *ds);
+void dsa_switch_devlink_free(struct dsa_switch *ds);
 
 #endif
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f890dfcbf412..c0ef49d86381 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -15,7 +15,6 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <net/devlink.h>
 #include <net/sch_generic.h>
 
 #include "devlink.h"
@@ -627,7 +626,6 @@ static void dsa_switch_teardown_tag_protocol(struct dsa_switch *ds)
 
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
-	struct dsa_devlink_priv *dl_priv;
 	struct device_node *dn;
 	int err;
 
@@ -641,15 +639,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	 */
 	ds->phys_mii_mask |= dsa_user_ports(ds);
 
-	/* Add the switch to devlink before calling setup, so that setup can
-	 * add dpipe tables
-	 */
-	ds->devlink =
-		devlink_alloc(&dsa_devlink_ops, sizeof(*dl_priv), ds->dev);
-	if (!ds->devlink)
-		return -ENOMEM;
-	dl_priv = devlink_priv(ds->devlink);
-	dl_priv->ds = ds;
+	err = dsa_switch_devlink_alloc(ds);
+	if (err)
+		return err;
 
 	err = dsa_switch_register_notifier(ds);
 	if (err)
@@ -682,7 +674,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 			goto free_slave_mii_bus;
 	}
 
-	devlink_register(ds->devlink);
+	dsa_switch_devlink_register(ds);
 
 	ds->setup = true;
 	return 0;
@@ -696,8 +688,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 devlink_free:
-	devlink_free(ds->devlink);
-	ds->devlink = NULL;
+	dsa_switch_devlink_free(ds);
 	return err;
 }
 
@@ -706,7 +697,7 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (!ds->setup)
 		return;
 
-	devlink_unregister(ds->devlink);
+	dsa_switch_devlink_unregister(ds);
 
 	if (ds->slave_mii_bus && ds->ops->phy_read) {
 		mdiobus_unregister(ds->slave_mii_bus);
@@ -721,8 +712,7 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 
 	dsa_switch_unregister_notifier(ds);
 
-	devlink_free(ds->devlink);
-	ds->devlink = NULL;
+	dsa_switch_devlink_free(ds);
 
 	ds->setup = false;
 }
-- 
2.34.1

