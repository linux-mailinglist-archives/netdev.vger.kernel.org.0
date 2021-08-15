Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3195D3EC8DE
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 14:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhHOMBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 08:01:22 -0400
Received: from mail-eopbgr20077.outbound.protection.outlook.com ([40.107.2.77]:45951
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhHOMBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 08:01:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGX/X+Qf1puLZc9T2kMUFPozHFNhnDJnoYgTtBl/P9kncDCeT9Dlb91kpzvx+3DNEdMlusv7LHrX5Nx2khslctNtrcrqohfPScB/3TdjoOgkqEMTFNESkrUAp0DThYA0aS9K3w5M2L1bzLUnfKP0SB5CsU9XPBmJ6+kKjsS6UFPkxkbxu3D1BIi3zLNyg9SfG5SWXogw/63Ng9w8R2SqhmzgPncO2mfbW8ufq40WCym4vSFsAYGpErgkr+R1G+cOs9EZKBGGu3HKHkyVFEVS9/ZVB0QTbI2x3suRxFV2iDpcE9Ge/ucFRgkr1SVj5Hc0YKZb6so4YhLDrDB5Llr9iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiaUXy8NTCH8volbYxwVo+4t0C9xJC1/J8BkINZQCWY=;
 b=gqNpU1kla8JdQWnBjqHIctkIxc83S5WhIir+TOe1GxvpIapSBvkrgAujqPfY7nt5NpCo164qFknzSq4/N26guuFoRqB/B68OCG9CUI2zbe8tEw3OC5BoqftZ0TXmbY4mae0ZtMJlcz+gc19/GZGy7usjMm7h/MwiBuLuL+M8LRfpzPDFExQNixyTwH7YORXZfZZvzUSz9UId3WXA7qT5qAp4JgzN4Xp+qMMx/o7AN90Y1dnsm2e6myYtGk467eug2qn7QR9bYs/yMG5E8tjgKL1JTzbhAM4pGca+7fMaX/vCEdlziU6GAKUCK2F4x2aP+MuwDuUeWej48+LIqEMCqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiaUXy8NTCH8volbYxwVo+4t0C9xJC1/J8BkINZQCWY=;
 b=RxuakOt/wYdJXQb47NLpxdUuVveqAay6TUHEpR3dpiuarQdinBjt0a1sxF+KdVI7sDN1qUmTgW5ewyNvuH5e+UtO9ttk6XNnm7cppvDGkSWVgCYNI8I7+n1knA1UXshqIW9+zaxEkY26zVNudDqq5AAFoXtc09XYj9sKylLT71E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5694.eurprd04.prod.outlook.com (2603:10a6:803:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Sun, 15 Aug
 2021 12:00:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 12:00:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: reorganize probe, remove, setup and teardown ordering
Date:   Sun, 15 Aug 2021 15:00:35 +0300
Message-Id: <20210815120035.1374134-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P195CA0022.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR3P195CA0022.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Sun, 15 Aug 2021 12:00:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9de851a-c420-4487-5bd7-08d95fe45277
X-MS-TrafficTypeDiagnostic: VI1PR04MB5694:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5694841844521A73370B547DE0FC9@VI1PR04MB5694.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMW1PKbzU+fxMi2r83V5f8s2gidoDTF6lYkqB4LOzl/QQh6CMlBMfu+9IdNoZaOa/32MrlXkMH21qMIIEBYrI8RkjWBaxiO8Kl7+Jm1AHIOzhnDhY7Oq0oy5NpsIkZ7v/40oSE8PI5v4DAqKWh8rkOL4Ki9erB+sFNGeph/FGEMZ5o3HAZdlXZUrkwIJ5XLlTGiaOgDR6EXQ2RGqbjXMqSVVBwqAbqXbOkA9bRcHwKIcImrFLx3ihArnhC61Lsm4XfbUpBPEms0yR5FdXZL25ydBY/IVXp6Nib35ov0BywuEB+3el7jyUS0O7CKmKqP9uHY8WodON832YnhjzzhJoDv2n5X37iFWi5aAOCh3PW25E1drjVHlceSOP3GbyWaFR4E+HeSeiAQn9Im/RGO2zN3LZDVj75/cZYLpKcP142/w2NLteItr+h0lkH4gpd039lG0/GftHUVbVnZscTTiLahMrxlQGwzeMv+2I2oe5SCiIirsuG6R05JglsD4MuNbQZ6ZcxQStaEtHg9DymNXXdgTBegoVIIxuQ3DwZvZ9xA8JtRmkgc+bFLLG9taewgdtOkuJeeMGxCel4KRc+swDVunNXbe86AM9H4X1nknVXj1M+c5B3Whwi3N6FVm5dQ40PpSQk7gOplLQcpcy0MMvU/50Hydt4rewGl8V7q0RRJlGmMv7iXcPgpVWwwtSueVIeYWmi4sfNKkfctgNzqzBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(1076003)(956004)(6486002)(6512007)(2616005)(44832011)(52116002)(38350700002)(8936002)(186003)(6506007)(26005)(54906003)(478600001)(86362001)(8676002)(4326008)(316002)(83380400001)(30864003)(5660300002)(2906002)(66476007)(110136005)(6666004)(66556008)(36756003)(38100700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ov9epUq7Cm1NuUYp8AcSOQFmJ/WpKqLycXZu7aGocp94+fTWWGQqlMY+hTQ9?=
 =?us-ascii?Q?qe5RyIY8JuGF8ngtFzoOsq2/UWNOHEwdcFpTT9G/k48tWX5xzcG5AK0q4NbI?=
 =?us-ascii?Q?7y5EY/xLwYR2dfyljW4FkLpIxzxuajLRg9UR03TJAFJ1xatPxTfvJOedVma7?=
 =?us-ascii?Q?ZU9r31472IKKya+CJcb94ETqdiv5+J9aF4CG4p/Bx3LRthKH9PsUlE2KBVyb?=
 =?us-ascii?Q?EM8lb3JkLAYl4YPCvryM8HvdWg/BRhgy73hgqBYoiNsiK24t6exsNyUzDwL5?=
 =?us-ascii?Q?hBqoyLwVF6azK04FOP80cOwhKtX8LzYC9ZhmTpVvFttqFSZz6RqaKv5fcQKL?=
 =?us-ascii?Q?QnIdTzCqXKl5MF1yfREW66Je3H1/pH5hIkmShpvYOO5Liu+/+zTLljgb+8MC?=
 =?us-ascii?Q?PfHV+PKLTw8ubncqlNPGrhAbWctOhukqjpZp4hyEa0spq5eqfjWe07bOLde+?=
 =?us-ascii?Q?wbJQyFMMhqw1qdIUoIN/3yDFx5iWa/cHH721dMeJCf6ayGmJH+0mzYHjvqiU?=
 =?us-ascii?Q?kBQif0jdZ+0x/JOzP2GnBCvTR6iKjeLr5f3ey/M9Rp7P6yHeS7bzSaP1uknp?=
 =?us-ascii?Q?aHU7PLWWUVY7dLk4UxdW+0mYM5OUPMk7sMxrqdayFbMMqxnfb0yjAS2t1vuG?=
 =?us-ascii?Q?dz1fgEJfgnT2DF1NXvtkAyRLvBY+utFMnjCkbheVobFVkzvppVsJE0QG+Arz?=
 =?us-ascii?Q?pa6s0UVRxMz/6DD2u31lCDf68gQvjiPNbE2Kz0rm7dUaVQrDv0DOB6sLG7Xx?=
 =?us-ascii?Q?XUQj4AYQqBfB/L4FeYfuRCG7lQwlMHu9tTwgi8S3PXcRh8zdI8EhbTiJrdHB?=
 =?us-ascii?Q?Kti8aa6c2Y7GemCantXaRvTbugxoQrA5+m9JhktYUvNq3bbb3eY/Ezj3W5LC?=
 =?us-ascii?Q?jZBpBVaem8OhdFhAm32S3bIb6Waa1BOBTahqXPcR5UmY0SR3/FRZo8yCorsw?=
 =?us-ascii?Q?thLVibvYzqSX404MuNtCNkYcdABjTRhr/kp2t4ONjpiuB1caBiPikqtEJenH?=
 =?us-ascii?Q?3NiaF0yBYME/bExLk22at7HUYxD46+4oEnDpfOY6Y7Z5FTE3zv6ltR5nUFf4?=
 =?us-ascii?Q?g3MDJPKT4rlxm81C5XmwKZphMhCxXzXGTRlrXSAt1fniAlrEhNnOWCyRq7+u?=
 =?us-ascii?Q?HbZpP7K4U8dS9bB2XLnXYq8P0D988DKCPRWSuW2neEjUduQp+Adz68eTJjxU?=
 =?us-ascii?Q?fGGDjOcax2kcaNvhfHG7MZKqVjNvlVv8enq50QhwFxc/fRdvz6W/jr2gEnIe?=
 =?us-ascii?Q?Iex3tLJDLqScMu2d7u477hKbm1iZbA5cbwhRHQhi7WbmzyUJMJjvznqSzdz5?=
 =?us-ascii?Q?qggvPs4TYZPidS5pTcIRx/pS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9de851a-c420-4487-5bd7-08d95fe45277
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 12:00:49.2570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1gkTvAXTn/TR1kpqU4lz4vPzn6ei997/DtwLWo70ZqYnXGSuKFHjg+FIuoesy/1WAVQSEnfXZArMuOSpVd5Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 driver's initialization and teardown sequence is a chaotic
mess that has gathered a lot of cruft over time. It works because there
is no strict dependency between the functions, but it could be improved.

The basic principle that teardown should be the exact reverse of setup
is obviously not held. We have initialization steps (sja1105_tas_setup,
sja1105_flower_setup) in the probe method that are torn down in the DSA
.teardown method instead of driver unbind time.

We also have code after the dsa_register_switch() call, which implicitly
means after the .setup() method has finished, which is pretty unusual.

Also, sja1105_teardown() has calls set up in a different order than the
error path of sja1105_setup(): see the reversed ordering between
sja1105_ptp_clock_unregister and sja1105_mdiobus_unregister.

Also, sja1105_static_config_load() is called towards the end of
sja1105_setup(), but sja1105_static_config_free() is also towards the
end of the error path and teardown path. The static_config_load() call
should be earlier.

Also, making and breaking the connections between struct sja1105_port
and struct dsa_port could be refactored into dedicated functions, makes
the code easier to follow.

We move some code from the DSA .setup() method into the probe method,
like the device tree parsing, and we move some code from the probe
method into the DSA .setup() method to be symmetric with its placement
in the DSA .teardown() method, which is nice because the unbind function
has a single call to dsa_unregister_switch(). Example of the latter type
of code movement are the connections between ports mentioned above, they
are now in the .setup() method.

Finally, due to fact that the kthread_init_worker() call is no longer
in sja1105_probe() - located towards the bottom of the file - but in
sja1105_setup() - located much higher - there is an inverse ordering
with the worker function declaration, sja1105_port_deferred_xmit. To
avoid that, the entire sja1105_setup() and sja1105_teardown() functions
are moved towards the bottom of the file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 397 +++++++++++++------------
 1 file changed, 199 insertions(+), 198 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ae7dd9fa70a1..fe894dc18335 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2515,149 +2515,6 @@ static int sja1105_prechangeupper(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-/* The programming model for the SJA1105 switch is "all-at-once" via static
- * configuration tables. Some of these can be dynamically modified at runtime,
- * but not the xMII mode parameters table.
- * Furthermode, some PHYs may not have crystals for generating their clocks
- * (e.g. RMII). Instead, their 50MHz clock is supplied via the SJA1105 port's
- * ref_clk pin. So port clocking needs to be initialized early, before
- * connecting to PHYs is attempted, otherwise they won't respond through MDIO.
- * Setting correct PHY link speed does not matter now.
- * But dsa_slave_phy_setup is called later than sja1105_setup, so the PHY
- * bindings are not yet parsed by DSA core. We need to parse early so that we
- * can populate the xMII mode parameters table.
- */
-static int sja1105_setup(struct dsa_switch *ds)
-{
-	struct sja1105_private *priv = ds->priv;
-	int rc;
-
-	rc = sja1105_parse_dt(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to parse DT: %d\n", rc);
-		return rc;
-	}
-
-	/* Error out early if internal delays are required through DT
-	 * and we can't apply them.
-	 */
-	rc = sja1105_parse_rgmii_delays(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "RGMII delay not supported\n");
-		return rc;
-	}
-
-	rc = sja1105_ptp_clock_register(ds);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to register PTP clock: %d\n", rc);
-		return rc;
-	}
-
-	rc = sja1105_mdiobus_register(ds);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to register MDIO bus: %pe\n",
-			ERR_PTR(rc));
-		goto out_ptp_clock_unregister;
-	}
-
-	if (priv->info->disable_microcontroller) {
-		rc = priv->info->disable_microcontroller(priv);
-		if (rc < 0) {
-			dev_err(ds->dev,
-				"Failed to disable microcontroller: %pe\n",
-				ERR_PTR(rc));
-			goto out_mdiobus_unregister;
-		}
-	}
-
-	/* Create and send configuration down to device */
-	rc = sja1105_static_config_load(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
-		goto out_mdiobus_unregister;
-	}
-
-	/* Configure the CGU (PHY link modes and speeds) */
-	if (priv->info->clocking_setup) {
-		rc = priv->info->clocking_setup(priv);
-		if (rc < 0) {
-			dev_err(ds->dev,
-				"Failed to configure MII clocking: %pe\n",
-				ERR_PTR(rc));
-			goto out_static_config_free;
-		}
-	}
-
-	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
-	 * The only thing we can do to disable it is lie about what the 802.1Q
-	 * EtherType is.
-	 * So it will still try to apply VLAN filtering, but all ingress
-	 * traffic (except frames received with EtherType of ETH_P_SJA1105)
-	 * will be internally tagged with a distorted VLAN header where the
-	 * TPID is ETH_P_SJA1105, and the VLAN ID is the port pvid.
-	 */
-	ds->vlan_filtering_is_global = true;
-	ds->untag_bridge_pvid = true;
-	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
-	ds->num_fwd_offloading_bridges = 7;
-
-	/* Advertise the 8 egress queues */
-	ds->num_tx_queues = SJA1105_NUM_TC;
-
-	ds->mtu_enforcement_ingress = true;
-	ds->assisted_learning_on_cpu_port = true;
-
-	rc = sja1105_devlink_setup(ds);
-	if (rc < 0)
-		goto out_static_config_free;
-
-	rtnl_lock();
-	rc = dsa_tag_8021q_register(ds, htons(ETH_P_8021Q));
-	rtnl_unlock();
-	if (rc)
-		goto out_devlink_teardown;
-
-	return 0;
-
-out_devlink_teardown:
-	sja1105_devlink_teardown(ds);
-out_mdiobus_unregister:
-	sja1105_mdiobus_unregister(ds);
-out_ptp_clock_unregister:
-	sja1105_ptp_clock_unregister(ds);
-out_static_config_free:
-	sja1105_static_config_free(&priv->static_config);
-
-	return rc;
-}
-
-static void sja1105_teardown(struct dsa_switch *ds)
-{
-	struct sja1105_private *priv = ds->priv;
-	int port;
-
-	rtnl_lock();
-	dsa_tag_8021q_unregister(ds);
-	rtnl_unlock();
-
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-
-		if (!dsa_is_user_port(ds, port))
-			continue;
-
-		if (sp->xmit_worker)
-			kthread_destroy_worker(sp->xmit_worker);
-	}
-
-	sja1105_devlink_teardown(ds);
-	sja1105_mdiobus_unregister(ds);
-	sja1105_flower_teardown(ds);
-	sja1105_tas_teardown(ds);
-	sja1105_ptp_clock_unregister(ds);
-	sja1105_static_config_free(&priv->static_config);
-}
-
 static void sja1105_port_disable(struct dsa_switch *ds, int port)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -3060,6 +2917,189 @@ static int sja1105_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void sja1105_teardown_ports(struct sja1105_private *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+	int port;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		struct sja1105_port *sp = &priv->ports[port];
+
+		if (sp->xmit_worker)
+			kthread_destroy_worker(sp->xmit_worker);
+	}
+}
+
+static int sja1105_setup_ports(struct sja1105_private *priv)
+{
+	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
+	struct dsa_switch *ds = priv->ds;
+	int port, rc;
+
+	/* Connections between dsa_port and sja1105_port */
+	for (port = 0; port < ds->num_ports; port++) {
+		struct sja1105_port *sp = &priv->ports[port];
+		struct dsa_port *dp = dsa_to_port(ds, port);
+		struct kthread_worker *worker;
+		struct net_device *slave;
+
+		if (!dsa_port_is_user(dp))
+			continue;
+
+		dp->priv = sp;
+		sp->dp = dp;
+		sp->data = tagger_data;
+		slave = dp->slave;
+		kthread_init_work(&sp->xmit_work, sja1105_port_deferred_xmit);
+		worker = kthread_create_worker(0, "%s_xmit", slave->name);
+		if (IS_ERR(worker)) {
+			rc = PTR_ERR(worker);
+			dev_err(ds->dev,
+				"failed to create deferred xmit thread: %d\n",
+				rc);
+			goto out_destroy_workers;
+		}
+		sp->xmit_worker = worker;
+		skb_queue_head_init(&sp->xmit_queue);
+		sp->xmit_tpid = ETH_P_SJA1105;
+	}
+
+	return 0;
+
+out_destroy_workers:
+	sja1105_teardown_ports(priv);
+	return rc;
+}
+
+/* The programming model for the SJA1105 switch is "all-at-once" via static
+ * configuration tables. Some of these can be dynamically modified at runtime,
+ * but not the xMII mode parameters table.
+ * Furthermode, some PHYs may not have crystals for generating their clocks
+ * (e.g. RMII). Instead, their 50MHz clock is supplied via the SJA1105 port's
+ * ref_clk pin. So port clocking needs to be initialized early, before
+ * connecting to PHYs is attempted, otherwise they won't respond through MDIO.
+ * Setting correct PHY link speed does not matter now.
+ * But dsa_slave_phy_setup is called later than sja1105_setup, so the PHY
+ * bindings are not yet parsed by DSA core. We need to parse early so that we
+ * can populate the xMII mode parameters table.
+ */
+static int sja1105_setup(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	if (priv->info->disable_microcontroller) {
+		rc = priv->info->disable_microcontroller(priv);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to disable microcontroller: %pe\n",
+				ERR_PTR(rc));
+			return rc;
+		}
+	}
+
+	/* Create and send configuration down to device */
+	rc = sja1105_static_config_load(priv);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
+		return rc;
+	}
+
+	/* Configure the CGU (PHY link modes and speeds) */
+	if (priv->info->clocking_setup) {
+		rc = priv->info->clocking_setup(priv);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to configure MII clocking: %pe\n",
+				ERR_PTR(rc));
+			goto out_static_config_free;
+		}
+	}
+
+	rc = sja1105_setup_ports(priv);
+	if (rc)
+		goto out_static_config_free;
+
+	sja1105_tas_setup(ds);
+	sja1105_flower_setup(ds);
+
+	rc = sja1105_ptp_clock_register(ds);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to register PTP clock: %d\n", rc);
+		goto out_flower_teardown;
+	}
+
+	rc = sja1105_mdiobus_register(ds);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to register MDIO bus: %pe\n",
+			ERR_PTR(rc));
+		goto out_ptp_clock_unregister;
+	}
+
+	rc = sja1105_devlink_setup(ds);
+	if (rc < 0)
+		goto out_mdiobus_unregister;
+
+	rtnl_lock();
+	rc = dsa_tag_8021q_register(ds, htons(ETH_P_8021Q));
+	rtnl_unlock();
+	if (rc)
+		goto out_devlink_teardown;
+
+	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
+	 * The only thing we can do to disable it is lie about what the 802.1Q
+	 * EtherType is.
+	 * So it will still try to apply VLAN filtering, but all ingress
+	 * traffic (except frames received with EtherType of ETH_P_SJA1105)
+	 * will be internally tagged with a distorted VLAN header where the
+	 * TPID is ETH_P_SJA1105, and the VLAN ID is the port pvid.
+	 */
+	ds->vlan_filtering_is_global = true;
+	ds->untag_bridge_pvid = true;
+	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
+	ds->num_fwd_offloading_bridges = 7;
+
+	/* Advertise the 8 egress queues */
+	ds->num_tx_queues = SJA1105_NUM_TC;
+
+	ds->mtu_enforcement_ingress = true;
+	ds->assisted_learning_on_cpu_port = true;
+
+	return 0;
+
+out_devlink_teardown:
+	sja1105_devlink_teardown(ds);
+out_mdiobus_unregister:
+	sja1105_mdiobus_unregister(ds);
+out_ptp_clock_unregister:
+	sja1105_ptp_clock_unregister(ds);
+out_flower_teardown:
+	sja1105_flower_teardown(ds);
+	sja1105_tas_teardown(ds);
+	sja1105_teardown_ports(priv);
+out_static_config_free:
+	sja1105_static_config_free(&priv->static_config);
+
+	return rc;
+}
+
+static void sja1105_teardown(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	rtnl_lock();
+	dsa_tag_8021q_unregister(ds);
+	rtnl_unlock();
+
+	sja1105_devlink_teardown(ds);
+	sja1105_mdiobus_unregister(ds);
+	sja1105_ptp_clock_unregister(ds);
+	sja1105_flower_teardown(ds);
+	sja1105_tas_teardown(ds);
+	sja1105_teardown_ports(priv);
+	sja1105_static_config_free(&priv->static_config);
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -3161,12 +3201,11 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 
 static int sja1105_probe(struct spi_device *spi)
 {
-	struct sja1105_tagger_data *tagger_data;
 	struct device *dev = &spi->dev;
 	struct sja1105_private *priv;
 	size_t max_xfer, max_msg;
 	struct dsa_switch *ds;
-	int rc, port;
+	int rc;
 
 	if (!dev->of_node) {
 		dev_err(dev, "No DTS bindings for SJA1105 driver\n");
@@ -3246,71 +3285,33 @@ static int sja1105_probe(struct spi_device *spi)
 	ds->priv = priv;
 	priv->ds = ds;
 
-	tagger_data = &priv->tagger_data;
-
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	sja1105_tas_setup(ds);
-	sja1105_flower_setup(ds);
+	rc = sja1105_parse_dt(priv);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to parse DT: %d\n", rc);
+		return rc;
+	}
 
-	rc = dsa_register_switch(priv->ds);
-	if (rc)
+	/* Error out early if internal delays are required through DT
+	 * and we can't apply them.
+	 */
+	rc = sja1105_parse_rgmii_delays(priv);
+	if (rc < 0) {
+		dev_err(ds->dev, "RGMII delay not supported\n");
 		return rc;
+	}
 
 	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
 		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
 					 sizeof(struct sja1105_cbs_entry),
 					 GFP_KERNEL);
-		if (!priv->cbs) {
-			rc = -ENOMEM;
-			goto out_unregister_switch;
-		}
+		if (!priv->cbs)
+			return -ENOMEM;
 	}
 
-	/* Connections between dsa_port and sja1105_port */
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		struct net_device *slave;
-
-		if (!dsa_is_user_port(ds, port))
-			continue;
-
-		dp->priv = sp;
-		sp->dp = dp;
-		sp->data = tagger_data;
-		slave = dp->slave;
-		kthread_init_work(&sp->xmit_work, sja1105_port_deferred_xmit);
-		sp->xmit_worker = kthread_create_worker(0, "%s_xmit",
-							slave->name);
-		if (IS_ERR(sp->xmit_worker)) {
-			rc = PTR_ERR(sp->xmit_worker);
-			dev_err(ds->dev,
-				"failed to create deferred xmit thread: %d\n",
-				rc);
-			goto out_destroy_workers;
-		}
-		skb_queue_head_init(&sp->xmit_queue);
-		sp->xmit_tpid = ETH_P_SJA1105;
-	}
-
-	return 0;
-
-out_destroy_workers:
-	while (port-- > 0) {
-		struct sja1105_port *sp = &priv->ports[port];
-
-		if (!dsa_is_user_port(ds, port))
-			continue;
-
-		kthread_destroy_worker(sp->xmit_worker);
-	}
-
-out_unregister_switch:
-	dsa_unregister_switch(ds);
-
-	return rc;
+	return dsa_register_switch(priv->ds);
 }
 
 static int sja1105_remove(struct spi_device *spi)
-- 
2.25.1

