Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293DE3CE82E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350619AbhGSQik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:38:40 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355063AbhGSQfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMbRIC4O6vK71P825DzFt9O6iGDWjPJoJp0y+gWlUuEw5uJKxOp2SzTA50VezZmvDezXxakPLjGPixema34o9M5Z4oGgQ7+yE6IyVsKP/oOWAD3uGnHnajCFS2EFtxTQovXq/94NQU6eto/CLIX8XKIsWRW2NQhl1HVU8MXhGwIVoYjKvOP52IxouQbRAO1mD5PlgvUhBeK+ds12RmFwrmZBIvCp75R7sctN6SButxCYXh62Gg391xgSd0ISi/05apQ+kpJRva+vdaoqdb8fX3wj9sLlivQK+KtaLm7A08cZMGaxVsdak+UaqftlofXcUpLL8pCyPMCALmkwkH2ZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5jDFvkiH3psSH6wXcLGZrGruROKURyJyZEFsje7DjY=;
 b=CGm+UeGKB7EN1Xr7hb1fo0JUU77nk28bwPMIyJYPz4/ncfsZyA7cqPORfkOqd3zJpT57jVozyR7+sKRMSumwj8jVeq5k88nX7G4p0Wa0GRROIyOBWameAcuibs6+VHCHsMG5bKL+JjROLjwwymd2UdIjGis1eXmajuVJLDa+JihC0LCeHjsfxVJBGZkj0lahtWvAxgOmtX+KVDv6saIV4yAUakQlwsDUq2XN5oI1dOlNrK0i8/8JJg3OLct0RDnZWGkwR/UCzxE/k6np1rifnkdDsEDXla5mynhnXM93hTpMybMVlHneGqWlC6SWxso3nW6fZJ/waVxWHmnBBOGCeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5jDFvkiH3psSH6wXcLGZrGruROKURyJyZEFsje7DjY=;
 b=MAiNwvKvjmlHKLdQPUGReVnXGunI5pj9Wz1N3NoulXY6MgVN+Z0hWR5evhXtFYq0RU2lFSF45sHseU5CQ1tfGIM9xkuDC6O1Vzzlh9CEJ4alFj6jRrA99fwXslq8t7Ve2GQmpliVVbrDs/P94dDgjwZHrw3XY/q4Ak5yuGqKE+g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 05/11] net: dsa: tag_8021q: create dsa_tag_8021q_{register,unregister} helpers
Date:   Mon, 19 Jul 2021 20:14:46 +0300
Message-Id: <20210719171452.463775-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20f459c5-90f4-4344-316f-08d94ad8e5fb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34078618227036E94D038858E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iiNWNTHfAvWjNbTXac4uqb1uQtSRI981ktxLrH82RAnGA/yEM/IwuyW80cXXOpvad7M45zz1vsPt0Lmv7kNvvCXNQDTBd45nRLRMLSAUE4oGdtdssi++JBTWjmMotAgc0Y+snmtkaySlG5uW4Si1hRf6XTOTGaO6pRLT1yh3KGqr2cP3JZSXRxCRMq0myRhhIfnUTxKBl9diuNq+SwPmXx8FZUJw1MGnOyi5paICxaQ8Sa861ZqfQfcQLHzC3tTuqaXaEOrncKap2bY96GfBdKypZq0r4S13mQT7JLyUjPa7Yy68rsE5tsXGywaz8N0lBRCviUnCIffR9voGTcSik7uFhCe9ang34EW4m4FyrPpIY6dw+pBI/HgDvN1buIrG9r2IE1AReJfHJkBWFqac75R/kAp1vsvBG12pknYWfgNejLF4621HH2JaLMYbMKSPmMGDsbf91nVeMAPOuXp1TkD9yxaKzOi3kKtPLVYjt93eFZeSUqIflY3rlPkfivYn0Q9nHrZ6t3VasCNumEVidtWML2P5D7YVyNqIJvAw0AEr8i30nyOSWQGTr4BY33zMBkxkUN1eeR+67Ly2cRVGA5zAT/zF38GrIMbvBFzfC1Uj+DgkcEcSohXMmn4tThC2GObdMzNZvgfDp03z1S+z+B1bLDwZCfcpY/OHx/HRrO9ql7fmvaUvAMM4TCpZFDYwtJHi6mD8YKH7VazuG7YZ+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gMpmlbh+kSsJEFqBpzpTjLYoAyfx7UdPZXoSlRPEdXt0dI4nx6lHDoP/kVnU?=
 =?us-ascii?Q?GSEvVheWkr7uLek8I0et5060QDLgJcOCXFZFULytv4j9Lg9XlAQtAO+MRUac?=
 =?us-ascii?Q?qP2jLqIEbqaTsitX5k1EOkvsvPFyIZz7DnXC83u+6ZnH2SgNOGsUjHiUj/70?=
 =?us-ascii?Q?XAYqUw7dwdm6dZK/GufCCvyfbYRpPnXR0JW1rc1D5eGofX3bPaaejDwQmbr2?=
 =?us-ascii?Q?Glf9iJNviv6U/THYKMlnenZAUV71so4T9VXaUgvpK7rRVgPsSLTOjbXAJ35i?=
 =?us-ascii?Q?3xl/OjomKDlNYVvmtghj6V/0V2Q7uYrlDnQnEfQedtLWbvZDZ9zHzKe/0TM3?=
 =?us-ascii?Q?8/mARSACCkbQAAj43aFSLXLQlafI5yX96cX1tWtqBZDhi4cUH7NyEhPmdAYM?=
 =?us-ascii?Q?hV1dtE8Cbu5ClmmBBLf5uwt88aYSURaDikqMb/l1If0210slvEmRk5vdflXj?=
 =?us-ascii?Q?llU2+f9vTQIH+u9+Tg5LHG6iYaINikyDJT6vSFIK9k9BhJaB5dpqiqD36D+l?=
 =?us-ascii?Q?0s1R0WnxenKe43WRwi3PLXFXahHcTbhwWfHga+7ndCfQF24K+ds+FN/LHNjj?=
 =?us-ascii?Q?PoGrdGZbEU7kzH7OwsvGmrhP3HlgOPha4SQJpWNByL/2BCTCTYF80R10WnWM?=
 =?us-ascii?Q?H2cgW7+ZLdpVrGJF1YzbUZ/DQHxuTa/L4wGc9MxTJj37wKAd0Y/J/LVcYqLF?=
 =?us-ascii?Q?C7weaz6aQxA2yfEdGAMADVZzXEY3HqYecfnF5if4bsegsis1sgxtYZEku0ao?=
 =?us-ascii?Q?UOnQuHuQWYDJD0q3hZYoTX+xZjDjgm44i4YgETS7ayxDjmbQUFmpzONTHhRv?=
 =?us-ascii?Q?9hX+fzZFyrEooYVFtAU8H/ERKaDDDVNUdDamTaSsBlNnc8dKSUVdlFcf/cCI?=
 =?us-ascii?Q?frWZ+Ev7bSffWMOlAHmJEMnr0H5T2xEiNPkEmf3ZR5HnhkofK21eFZUm+aIw?=
 =?us-ascii?Q?KgrAIu+L+NqEUYXsRrK7HvE6Ad5WHt3Ux77tZC9CJ8XMhmgRmYiiWnAb/ZQY?=
 =?us-ascii?Q?0mlFW7DaWHHCkjhPpd4NfqP9nUlvUeg0EhbIMfyJqx/KJsMavZh5cUO+v7/L?=
 =?us-ascii?Q?Gu/6EtNBzBNrtZMR6KmOlAxsBJvS0h0GufZFuFRv1fgcaWSar2YHxSjLtQoc?=
 =?us-ascii?Q?AE9z0B4iVK4RGnVu4d6/LhJnC7uo+4ip32zy6Pp90gHGHRMKz8bbZE+SksmW?=
 =?us-ascii?Q?H9wUz7sJFs271XawNBcfB0Kh5ZGRSlf024ykoPbKyOU8ijWAC2Vj82PohkOW?=
 =?us-ascii?Q?g7a0/TeANsSf6aD985vG8NvNPnQQAZvnCSXN7EI2oKqQEbuOrYZsKDWF7YoU?=
 =?us-ascii?Q?k71A8bXo9uYzAbg8FGTOWxRD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f459c5-90f4-4344-316f-08d94ad8e5fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:08.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaZAWdqsUjHptNd3r5VSKB0z/S0Xi+9oRwQziZRtU5P5JRgL/Csvuym4HdxgY2qTUEOz4hX5BdNOe0cM/U/Gpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of moving tag_8021q to core DSA, move all initialization
and teardown related to tag_8021q which is currently done by drivers in
2 functions called "register" and "unregister". These will gather more
functionality in future patches, which will better justify the chosen
naming scheme.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 12 ++++------
 drivers/net/dsa/sja1105/sja1105_main.c | 18 +++++++-------
 include/linux/dsa/8021q.h              |  6 +++++
 net/dsa/tag_8021q.c                    | 33 ++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a2a15919b960..b52cc381cdc1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -425,15 +425,11 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
-	felix->dsa_8021q_ctx = kzalloc(sizeof(*felix->dsa_8021q_ctx),
-				       GFP_KERNEL);
+	felix->dsa_8021q_ctx = dsa_tag_8021q_register(ds, &felix_tag_8021q_ops,
+						      htons(ETH_P_8021AD));
 	if (!felix->dsa_8021q_ctx)
 		return -ENOMEM;
 
-	felix->dsa_8021q_ctx->ops = &felix_tag_8021q_ops;
-	felix->dsa_8021q_ctx->proto = htons(ETH_P_8021AD);
-	felix->dsa_8021q_ctx->ds = ds;
-
 	err = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
 	if (err)
 		goto out_free_dsa_8021_ctx;
@@ -447,7 +443,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 out_teardown_dsa_8021q:
 	dsa_8021q_setup(felix->dsa_8021q_ctx, false);
 out_free_dsa_8021_ctx:
-	kfree(felix->dsa_8021q_ctx);
+	dsa_tag_8021q_unregister(felix->dsa_8021q_ctx);
 	return err;
 }
 
@@ -466,7 +462,7 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		dev_err(ds->dev, "dsa_8021q_setup returned %d", err);
 
-	kfree(felix->dsa_8021q_ctx);
+	dsa_tag_8021q_unregister(felix->dsa_8021q_ctx);
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4514ac468cc8..689f46797d1c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3306,16 +3306,11 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	priv->dsa_8021q_ctx = devm_kzalloc(dev, sizeof(*priv->dsa_8021q_ctx),
-					   GFP_KERNEL);
+	priv->dsa_8021q_ctx = dsa_tag_8021q_register(ds, &sja1105_dsa_8021q_ops,
+						     htons(ETH_P_8021Q));
 	if (!priv->dsa_8021q_ctx)
 		return -ENOMEM;
 
-	priv->dsa_8021q_ctx->ops = &sja1105_dsa_8021q_ops;
-	priv->dsa_8021q_ctx->proto = htons(ETH_P_8021Q);
-	priv->dsa_8021q_ctx->ds = ds;
-
-	INIT_LIST_HEAD(&priv->dsa_8021q_ctx->crosschip_links);
 	INIT_LIST_HEAD(&priv->bridge_vlans);
 	INIT_LIST_HEAD(&priv->dsa_8021q_vlans);
 
@@ -3324,7 +3319,7 @@ static int sja1105_probe(struct spi_device *spi)
 
 	rc = dsa_register_switch(priv->ds);
 	if (rc)
-		return rc;
+		goto out_tag_8021q_unregister;
 
 	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
 		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
@@ -3377,6 +3372,8 @@ static int sja1105_probe(struct spi_device *spi)
 
 out_unregister_switch:
 	dsa_unregister_switch(ds);
+out_tag_8021q_unregister:
+	dsa_tag_8021q_unregister(priv->dsa_8021q_ctx);
 
 	return rc;
 }
@@ -3384,8 +3381,11 @@ static int sja1105_probe(struct spi_device *spi)
 static int sja1105_remove(struct spi_device *spi)
 {
 	struct sja1105_private *priv = spi_get_drvdata(spi);
+	struct dsa_switch *ds = priv->ds;
+
+	dsa_unregister_switch(ds);
+	dsa_tag_8021q_unregister(priv->dsa_8021q_ctx);
 
-	dsa_unregister_switch(priv->ds);
 	return 0;
 }
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 5f01dea7d5b6..9945898a90c3 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -34,6 +34,12 @@ struct dsa_8021q_context {
 	__be16 proto;
 };
 
+struct dsa_8021q_context *dsa_tag_8021q_register(struct dsa_switch *ds,
+						 const struct dsa_8021q_ops *ops,
+						 __be16 proto);
+
+void dsa_tag_8021q_unregister(struct dsa_8021q_context *ctx);
+
 int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled);
 
 int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 3a25b7b1ba50..73966ca23ac3 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -410,6 +410,39 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_leave);
 
+struct dsa_8021q_context *dsa_tag_8021q_register(struct dsa_switch *ds,
+						 const struct dsa_8021q_ops *ops,
+						 __be16 proto)
+{
+	struct dsa_8021q_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ctx->ops = ops;
+	ctx->proto = proto;
+	ctx->ds = ds;
+
+	INIT_LIST_HEAD(&ctx->crosschip_links);
+
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
+
+void dsa_tag_8021q_unregister(struct dsa_8021q_context *ctx)
+{
+	struct dsa_8021q_crosschip_link *c, *n;
+
+	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
+		list_del(&c->list);
+		kfree(c);
+	}
+
+	kfree(ctx);
+}
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_unregister);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci)
 {
-- 
2.25.1

