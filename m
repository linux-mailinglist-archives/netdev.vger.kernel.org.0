Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E203CE833
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352637AbhGSQjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:07 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355190AbhGSQgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:36:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2MPlXEvFVfZuf+pcFxl4zzyCwj49dY8sVWKgqN0KyrpEqv7irzOxeXx9MHS7JCy+TI0XguNTwjg5+qrz0Ri7+FZfcHg2T56aHfmq3TdpTNUBZEO0VrcAQWofNhMmG2LSA80mB400Xi8npREqejaGe3kiPRrXOUw/Pxu1D4j6kmVKHcRYs5CCXt1LT+lmA7P18Xw0y+3pZd+dzXpSEDTPCAaiI8Z3IpSqEuzvTXEp0WTVAm7tiHx2o5bTXttFfVh3v+3NeAA4JURJhyihFbUV0auf2fNJTE86qA+CjpR0/sznYHus3o4QeRNqaNw/N8A3bOS0/YPWNBMceDY1x1lsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sytrZu9snO08lR+vm1S0L/+15z0Xa3xuVUhEoC7lf3s=;
 b=hY3Zpw4lV9GdJM3mUcpwRi43buq7rQ8kubD6As1K8R8m0PJBTrkPiG+05fcQq7xBA5AUusKAQUhPS3pq/vujSkheqwkkmSgZ3LEKbzNfM4+DCj8IxIH8P+CkrG8+Ve6hOd6PJ94nfYCliMHF1w6G/WNuEWEc7++/Id5/SDlLY+QdSCxfRSW09U373UVB83yZd8/HnFg+YgHWm7XuCBB3CVPz4v5zlx06jjuFhUaY7cOPk6cJOsNfc3f+jY9NFtVL/WYIxKf/D7suMCr9qT2FOJjAmLZlOTN0waDT75dEN+Z8FvBMRA3m+MtEaI3C/iMGoLkIVRXBrDsozK6mu43lHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sytrZu9snO08lR+vm1S0L/+15z0Xa3xuVUhEoC7lf3s=;
 b=OuXJmd+mUGWHqDhFQXFtzhXk/LbATojgfmTli/w+cHKFQWUYwQBNGCTRgUE4unRQrZhAZLTp/pwKr0xWZTmTcgvwotX+bbG2LGplVNdMhohFN9z7AcjOt+EJliAaqO6rQ9VuaxHydwNbsH05EIzI2g9Wl6dXo17IQ3sepJ1TLr8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 09/11] net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register
Date:   Mon, 19 Jul 2021 20:14:50 +0300
Message-Id: <20210719171452.463775-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cbf606d-163a-479e-0478-08d94ad8e88c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340764B6FB7522156F6792ADE0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxMHVyJlGqs8vr85QTzmOGr5zJ0X/L/ry61stCrrFQ+vKynx106phDmLSV0zRjeiFryAg2eYIEDiOnsVTQimJMSNhkm0ZewW/nPKpppxVSr1xN98x9PCAv9fPRV+teGsCVSHCPmi3KJ7J6ymfHeafFwtcQQITf3Ak/9m2G+Clfy81kD4oan1R/oZ3GxVrlfJUjAFIsgnsf2osOUhZjDmMeXuH0KtgOdyRGuhmvHD11FATFUmNpmnFHLc2S4hLFjoYtmMmLxW4y50dIXM5khXsZXPo4uhW+SkD1ylt2tQqMb8S8Qsaw2v51UTZM0LZ1umyuwd4x+/Tttw+bQxexiD2eiELDZHd/wjEA/IL+Vd7FvSzd9GOwujn5SsBCoKbEDPs/1t+dzedW9hiL+sEAcBN8y+yc6g/2Ivfad5+LjPdxDtrwIQioKlUDveyuyFlLmXe0VWfkksWpntIx+Vv0Sa4Qyq6jrw6o6YlPiKOoCN9YPszTRt5Tl++k2/tgb+Nk1falbAxB0IZFASD/0lnibbHm3zvroYgKZMESGL/qgXs7twzZmp6goVT2FJk2B8FMcCMxQs2RoPydzMA6EuRmVDN6LAJXwxjs8j8X3MAxsXXjvgAsW+f8rDMAmcX+5SsFI+P5Ua6LlGN2GWgqQXJpiouOLwQuHSosF7i6QK6ItUEqndn2LFHoGJAKMJPHbuLEijZiyTEjNUeCp8et8eO9jKxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?74wHmPrMnSU4E8bxvS5cOQDKcECCQhS1E8rB1VFlzCjOM4rPrlOpRG4ISXU6?=
 =?us-ascii?Q?WBGvlldX5r0EAYyrna98mW7/OXGrZXVvvE8ELo94jgKDpN2RbuKNvJCsEZg9?=
 =?us-ascii?Q?70XvhsGVnZsR801cp8c57L6mkM+0ce1LKaJMHcRj8yVHE5CrBhrj8BaXanhe?=
 =?us-ascii?Q?Avv76BfrkXxinilg83q8rFkYx/fFuvfwXMhsNwusN0k+lOOQK+795l3MJ/iy?=
 =?us-ascii?Q?vGDWGcQNnYfkMMTAn2fd5t3LHJW5+m30ZeMZ/n1JLAO+DU5WC2UjYWpX+oVg?=
 =?us-ascii?Q?ShabzMPHulECPW/jQVn2YWQQYVgt/awVDkesjuMDXRpKa0Tw/odeiXQV8K52?=
 =?us-ascii?Q?+5bxk+mci3vU2JpZntnyTqVj4Z3xRVEWWhdWVmHWc7kXxVVspI2COGxWsGfi?=
 =?us-ascii?Q?YVcUer02qj+o2GOdH5CV6ZXBncHw20xEZ9AYxCV5eJbCU4+epTf90B0y2vIx?=
 =?us-ascii?Q?4S19Yw7uIhYhyUVY8J2wgZ+kZfLbAIDw5E8wzaOD04xC3SUxRs03Gl23phVP?=
 =?us-ascii?Q?tVT7oTOh332DcnDIvgdK+8HesJ8mXVWUCv6XDmkpMeTHThXaP1evPGIiHeF5?=
 =?us-ascii?Q?q6xkmfEz6zWH2lMiqv2EqdCqnC7igI97sSuWL4ntXRXC7FmAbMpxEMYNoNU/?=
 =?us-ascii?Q?eVnr43ISsZ+rqywsaiFsVfjYQsnmQl1tUN2g3WIOjrOnOcJ1QHxvUuPTtD74?=
 =?us-ascii?Q?OxYktteL7cRSSDEvsXdsNjuCi6Uz/XVXt1ENLyr5VTpt2DqIM5+yjpGW1w1O?=
 =?us-ascii?Q?YzzntUSyZDXY6xTgppkixzjZCArPyGUpCC8Jak4MQPMrEMu0DEKbY6kZA7YM?=
 =?us-ascii?Q?r+fqxCOA+QyRvk29kiL8PP86ZhjUT5GNNzI65WeFTVG30olP6ow8j8DWzwCf?=
 =?us-ascii?Q?Z8AUyyONJl9ilUowP1RPwB7j1e+eMv3D85VuyiwB9XZMENuc744UJF42d2uY?=
 =?us-ascii?Q?YfAkXuyID4bxFIhLoRj3AWPPEjBZ4HM2ERN+MobT/3L7yEZ5RBh72HN3Yw72?=
 =?us-ascii?Q?QXZdpyyi1wlpRzbtyL/KINSKVObwWQ/j2eJMfULueUadGtMDFhT/qwmvdyeB?=
 =?us-ascii?Q?7NrP9tgDQNb0g2/s6DiVdhAXodjbJYxC5ZDJpQuM/F5tz7BWOPjQLYiwmrS7?=
 =?us-ascii?Q?50dgY85az7msRsW24+N1frfwTcxEu73hd4CZ3rkIt9q4FFN5q7pxrEcXwj9M?=
 =?us-ascii?Q?lO7iFEf8CxvCU0JyMnRIQtfEUv2Orq53ffFQ18Jb1kNhf7JV8B53BG5Wx0nN?=
 =?us-ascii?Q?5na+VHNeRlseiiKDWvzVYhKIcvJSxpZCZ7EErjbl8HZVKvb86RrzgRZmv6eI?=
 =?us-ascii?Q?+fwGPVeixOIe+9tEQmVT49Tv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbf606d-163a-479e-0478-08d94ad8e88c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:12.6016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmYT6fo9bhsJdGWizYtqdciLNJ9dGVQqGgR3YUgbHr5VmXPpw9T/mo5ESiWxNKAOLdxQLga6zZ/lrjZrrQSPSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, setting up tag_8021q is a 2-step operation for a driver,
first the context structure needs to be created, then the VLANs need to
be installed on the ports. A similar thing is true for teardown.

Merge the 2 steps into the register/unregister methods, to be as
transparent as possible for the driver as to what tag_8021q does behind
the scenes. This also gets rid of the funny "bool setup == true means
setup, == false means teardown" API that tag_8021q used to expose.

Note that dsa_tag_8021q_register() must be called at least in the
.setup() driver method and never earlier (like in the driver probe
function). This is because the DSA switch tree is not initialized at
probe time, and the cross-chip notifiers will not work.

For symmetry with .setup(), the unregister method should be put in
.teardown().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 12 +---------
 drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++---------------------
 include/linux/dsa/8021q.h              |  2 --
 net/dsa/tag_8021q.c                    | 11 ++++++---
 4 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b6ab28d2f155..583a22d901b3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -424,18 +424,12 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		return err;
 
-	err = dsa_8021q_setup(ds, true);
-	if (err)
-		goto out_tag_8021q_unregister;
-
 	err = felix_setup_mmio_filtering(felix);
 	if (err)
-		goto out_teardown_dsa_8021q;
+		goto out_tag_8021q_unregister;
 
 	return 0;
 
-out_teardown_dsa_8021q:
-	dsa_8021q_setup(ds, false);
 out_tag_8021q_unregister:
 	dsa_tag_8021q_unregister(ds);
 	return err;
@@ -452,10 +446,6 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 		dev_err(ds->dev, "felix_teardown_mmio_filtering returned %d",
 			err);
 
-	err = dsa_8021q_setup(ds, false);
-	if (err)
-		dev_err(ds->dev, "dsa_8021q_setup returned %d", err);
-
 	dsa_tag_8021q_unregister(ds);
 
 	for (port = 0; port < ds->num_ports; port++) {
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0c04f6caccdf..6b56c1ada3ee 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2045,19 +2045,6 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 	}
 }
 
-static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
-{
-	int rc;
-
-	rc = dsa_8021q_setup(ds, enabled);
-	if (rc)
-		return rc;
-
-	dev_info(ds->dev, "%s switch tagging\n",
-		 enabled ? "Enabled" : "Disabled");
-	return 0;
-}
-
 static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 			 enum dsa_tag_protocol mp)
@@ -2635,12 +2622,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 	if (rc < 0)
 		goto out_static_config_free;
 
-	/* The DSA/switchdev model brings up switch ports in standalone mode by
-	 * default, and that means vlan_filtering is 0 since they're not under
-	 * a bridge, so it's safe to set up switch tagging at this time.
-	 */
 	rtnl_lock();
-	rc = sja1105_setup_8021q_tagging(ds, true);
+	rc = dsa_tag_8021q_register(ds, htons(ETH_P_8021Q));
 	rtnl_unlock();
 	if (rc)
 		goto out_devlink_teardown;
@@ -2665,6 +2648,10 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	struct sja1105_bridge_vlan *v, *n;
 	int port;
 
+	rtnl_lock();
+	dsa_tag_8021q_unregister(ds);
+	rtnl_unlock();
+
 	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_port *sp = &priv->ports[port];
 
@@ -3293,10 +3280,6 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	rc = dsa_tag_8021q_register(ds, htons(ETH_P_8021Q));
-	if (rc)
-		return rc;
-
 	INIT_LIST_HEAD(&priv->bridge_vlans);
 	INIT_LIST_HEAD(&priv->dsa_8021q_vlans);
 
@@ -3305,7 +3288,7 @@ static int sja1105_probe(struct spi_device *spi)
 
 	rc = dsa_register_switch(priv->ds);
 	if (rc)
-		goto out_tag_8021q_unregister;
+		return rc;
 
 	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
 		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
@@ -3358,8 +3341,6 @@ static int sja1105_probe(struct spi_device *spi)
 
 out_unregister_switch:
 	dsa_unregister_switch(ds);
-out_tag_8021q_unregister:
-	dsa_tag_8021q_unregister(ds);
 
 	return rc;
 }
@@ -3370,7 +3351,6 @@ static int sja1105_remove(struct spi_device *spi)
 	struct dsa_switch *ds = priv->ds;
 
 	dsa_unregister_switch(ds);
-	dsa_tag_8021q_unregister(ds);
 
 	return 0;
 }
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 0bda08fb2f16..9cf2c99eb668 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -32,8 +32,6 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto);
 
 void dsa_tag_8021q_unregister(struct dsa_switch *ds);
 
-int dsa_8021q_setup(struct dsa_switch *ds, bool enabled);
-
 int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 				    struct dsa_switch *other_ds,
 				    int other_port);
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 4a11c5004783..9785c8497039 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -257,7 +257,7 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	return err;
 }
 
-int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
+static int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
 {
 	int err, port;
 
@@ -275,7 +275,6 @@ int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_setup);
 
 static int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
 					  struct dsa_switch *other_ds,
@@ -427,7 +426,7 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 
 	ds->tag_8021q_ctx = ctx;
 
-	return 0;
+	return dsa_8021q_setup(ds, true);
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
 
@@ -435,6 +434,12 @@ void dsa_tag_8021q_unregister(struct dsa_switch *ds)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_8021q_crosschip_link *c, *n;
+	int err;
+
+	err = dsa_8021q_setup(ds, false);
+	if (err)
+		dev_err(ds->dev, "failed to tear down tag_8021q VLANs: %pe\n",
+			ERR_PTR(err));
 
 	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
 		list_del(&c->list);
-- 
2.25.1

