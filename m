Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA595ECCAE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiI0TQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiI0TQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:16:03 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D95D855BB
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIe6g/ZN4kyS5rLxyhkryLgOiJRGRxR5oJrCnLhopPzi40y24+NLR6Cp28D0HASUIheWoeMjtNKT7EYCsptoXZof9qmu2OufOaQ/iFkBHmU8s9Dg5dEQVjOaqEQK0j3sBPR6wisrRrt/7xvWUWsacXaJQ436UMVj+czAb37qS/wStUrgU+sUmUot8AVPF9MBHJlACgwZF1hmQWo2Jf5CrdE4PMAc9K2cUTCx1vp6tTwr+snZRk9uMDGFlSKtb/IuxdNdfK8A5wcAxqKtlZk5wxDAfH9JXTDVLjOxkxI/3Rf5t/u+ZGtA44p66TwpFeZN9BtQYQtF3aA5BKQzb7UPuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYhOeuXgCgtehVBpmtBI6HmQ8WUzoqXAo3pJccxYA9g=;
 b=SeKF9khoJoMWmnyDkd9EE/u99T9NrtdLIR7+Z+lcgNXzNi2sbrhjpRB60eruOS0lIBJvWNptqS9wRhXlfUGTskrYF7DYPAGftHltimR9NHs1X1R7k+ZUfj0Pb+fYZOcBR4pEcPH3haGFj77Pq0q6fmmCOkDO5gXcNBzFBoA8/0+d+Jq8EBYDtDDruGH2QiroOQx1uahepIpe6ZQ+W8onUKsvW07YQx+B3jtfpf6/wAOGB1IXg/MsWC+xpF2Hjpsq/3iyZdeHfuRAuzoYeZUtA+UImDdaYkHYjUdlsCXLq4trijSUhePEHGVNM6hEK8Ieqeuccl7G4UxHMBfJX2SOmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYhOeuXgCgtehVBpmtBI6HmQ8WUzoqXAo3pJccxYA9g=;
 b=c+TGpoB/Ciq68C7uy9/F+h1CT0N0h9d34b6uDV/pwUBAx52m+DyQaXoxKMlYF3/14R6OgInc83evOMydE031wCnlO645x6qRISGOhYAAA0XylIxWcIqEuA2lKXi9L45+pcpo0M4vjoHSRtxUqacQ5WjBcFgdZKBpd6qLL3Y52MQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net-next 5/5] net: dsa: felix: update init_regmap to be string-based
Date:   Tue, 27 Sep 2022 22:15:20 +0300
Message-Id: <20220927191521.1578084-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: e7890f49-9c5e-47a0-1784-08daa0bca939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPGRRAjutEb9NToU4rU+tAXd3LZPkuiUeGSyj1fWqXCRKrOvj3sjG4Da2+4jcf9vVHkrLSPaU1Lfig+QFbbuGaHOOWltJ8tRbtuIcQcb2OxmBZNu2zy2/jyDTRusBgRO+hqg2nT46UMvCS4ZxfJ8iqJCgXfmCET+TBSDbo0m0LlvI3qa3IV2K/+cQib7JKzssTlNOBHGyglmnuDnBLFvTde+7/910RxrgxfRifZpNmrD/hhsG6PsMX3sS83Y1e2gZCwmieUlF8gpslXKx0tz0pVAKT1n1bj0TOPn+OCLJKl4xKQme9fXHyQQnKMeo2GQV6kZkB1DxY+i44yOG+m+NNzaYmk7O5YP3uy747sVoO2k5FVTfDq9ConsKIlrooFrHtLu8xxUOrZn6qEPtZj7F3tka0yWHCqK3re4ifsTc9xojPmm+bO8LN7FbEWcvpUDX24NRKtVoAvXRj60I3hjGz14ObP+3ZPFs7tTbh4T1Xz0JoyE2W/2ywBSp8l91/STDrYZaeIk6k1+W257NMQsKCsrKpstBEVSNfXpVyrMAwUM/EzxFcuvPFXXkpbUFq6DuT+5V0UI4fnT35ZcqOthDeBlVRwhgMXTLUNssR6Pw9Vgd2qs/vpS8JCawAnUGAoS47pjGi7/7KZpSwKYO43CoU0jnya36wUHd3td57gCn45XXMn60VE7WST3prz4tttYNhs3lrUtZkrTAGDGLwb0kEbMeUjfJNyqEoqmC/ReM2oeIP8Vk6wF3KebschDw7Kfc8esv6g6ZPrfQbCwL1Q6JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(30864003)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqLsapk3TOgc25BJVeipSWG8fWA049wms5i5M0SbjFs2JWUjTMJJ/OfjYV70?=
 =?us-ascii?Q?sAzupn16wMWGoR4/K//XuCkB26Qe5PMJ3SAvhl694dYEmy8cgB33z31huBWu?=
 =?us-ascii?Q?qzPksjWtxlhlW0yzFYXxgg0k87xxmNDK6TfSAsd5ZnHZzR4uRIEUdRm2O1qE?=
 =?us-ascii?Q?NbFiOOLF4f05qz8pIpuFwIcgTLpLY8TtFzIOFU455nNV2dIlE0RGtrAbZ8X6?=
 =?us-ascii?Q?9R0oHSQjMVlPmjmmj1p6sRF/Z233xpetkeeUQiFvtJEZBBzEWx/xAo+hGor6?=
 =?us-ascii?Q?x04eFErwtw8Ue+pC3i454TPoF8MB2aeZPuIQm/HWKrOgMYy51LbHt/yNbFzv?=
 =?us-ascii?Q?yRQCgUp9oqJf7AOa4+iKIKNFsXNkndM3MUh+b7YpJl54P7H8qfPXulFCSv//?=
 =?us-ascii?Q?YQ+rEVMlAsUp2mHxdKJmrp5sOwvwKUZBxt7yqDrzNXRu9Lprkb626si3wLUZ?=
 =?us-ascii?Q?jcWyqQBCst3NgEZipVdImBfwPU8SNcVQQxKGsdHnzToC+CSzU+SyGH1eAair?=
 =?us-ascii?Q?7UPIRF4jhpoCmzdSuTj0aRD9q1Q3EGEKlQ/wZgGIZxOVhgYV8PXN92YxsqFW?=
 =?us-ascii?Q?wMfnSbfN+5fCkV8jcCC2qbve4aKPWatkkGGVJa5Aee5e27pLkKYiZuxacDeQ?=
 =?us-ascii?Q?bTrKGtKJ/s4+n4ctGgD6T3cTa+MZbd0GEsLWnCVjak+8kSH1iAn8Hc41g/qF?=
 =?us-ascii?Q?UCJNazYpZgX6Jrt8RktMGaMreDAmSXPoxaUVLD4b9Lz8ttGWScbFIZeHS0Bb?=
 =?us-ascii?Q?G/nWSOWrTGbsl0f7syvLG2RN7c5FHpev7nrCJzzG03Z9UiQFlWxaiPyWFuBK?=
 =?us-ascii?Q?QoFMq/3bqZeXLcGtEeJpxDZpycMgRP5CMk8goSO1PoG8Zd3CgovAXOgBV+Mp?=
 =?us-ascii?Q?xFCgxSVcyVCHKD55qnb9yZIUF9/+TQRjyhXGDy6+X2uUsQDuCigJa6p8ZWxY?=
 =?us-ascii?Q?agq7PrU3kROdO4Hh9dinwlM2yhzBZOU2NA3ovhhVj2Oc8JcHTAQGMzPX6shi?=
 =?us-ascii?Q?g7EuOulBfnwZy9KEtsLmOqglD1TrgssyU/WNTWgZvwgiLvH/67iwZY/5Ccm6?=
 =?us-ascii?Q?5McrgGTwY82/5uhzeYeAn6gtQnuyBLgZK0BCc/mnBbN8EJqcZwiIqJNmFuzj?=
 =?us-ascii?Q?kYVd2D12XcDrmSn8fq7i4TnKRJsaquv1HrCvFgfJwlsBGwuqtvt79mrIoEW5?=
 =?us-ascii?Q?dvQBFGUGDGSkhbr+YhPFwfWeMd+cFJZ4Tbit7faxM9Tr+Np2//Q0sZFUO+cl?=
 =?us-ascii?Q?sbbYpeLYd9jIq89uIva8BC/7pmyNg8ZN0VwnSq9jmi6oulH+hqY4kxG07pz5?=
 =?us-ascii?Q?v4S0YMOxyyDd9qHg9UEOdo4zfDpNxvJBCr+s/VkbyOBUjUEcLNyxMc/1/Zjh?=
 =?us-ascii?Q?oFZfgy+Y2wIkWHlYiIYd+vK37ttI0Wg1ps0e0m/qYMdpIMWwH5XgByf+5U2M?=
 =?us-ascii?Q?5fi3evPflBvIlT8LqOoAXLnsYYYutwXbefqm+Fcgtj4kSdyeboebyVeTskte?=
 =?us-ascii?Q?YIriYNucQ+hrG5EPkX2KyjJUDW9TRsTR+anmYLg3fJU4IO04d0HGW++lImpz?=
 =?us-ascii?Q?Ay55McrljlKJKBF+j1ZTN5O28gI7oKc6WSN874mm6IDsfxenscaOvYJQ9W+x?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7890f49-9c5e-47a0-1784-08daa0bca939
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:38.2545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSeKLvdBT0HVW0Yk0XBU7e//I50TlNCmxo0vb1zU3wbDov+uhO3087pQ7oFScuSTdDHyIFQRZhb926VTokK4Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix DSA drivers (vsc9959, vsc9953) are all switches that were
integrated in NXP SoCs, which makes them a bit unusual compared to the
usual Microchip branded Ocelot switches.

To be precise, looking at
Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml, one can
see 21 memory regions for the "switch" node, and these correspond to the
"targets" of the switch IP, which are spread throughout the guts of that
SoC's memory space.

In NXP integrations, those targets still exist, but they were condensed
within a single memory region, with no other peripheral in between them,
so it made more sense for the driver to ioremap the entire memory space
of the switch, and then find the targets within that memory space via
some offsets hardcoded in the driver.

The effect of this design decision is that now, the felix driver expects
hardware instantiations to provide their own resource definitions, which
is kind of odd when considering a typical switch (those are retrieved
from device tree, using platform_get_resource() or similar).

Allow other hardware instantiations that share the felix driver to not
provide an array of resources in the future. Instead, make the common
denominator based on which regmaps are created be just the resource
"names". Each instantiation comes with its own array of names that are
mandatory for it, and with an optional array of resources.

If we can match the name from the array of mandatory resources to any
element in the list of hardcoded resources, use that. The advantage is
that this permits us to modify felix_request_regmap_by_name() in the
future to make felix->info->resources[] optional, and if absent, the
implementation can call dev_get_regmap() and this is something that is
compatible with MFD.

Co-developed-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 71 +++++++++++++++++-------
 drivers/net/dsa/ocelot/felix.h           |  9 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 43 ++++++++------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 43 ++++++++------
 4 files changed, 112 insertions(+), 54 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6a7643c31c46..dd3a18cc89dd 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1312,11 +1312,55 @@ static int felix_parse_dt(struct felix *felix, phy_interface_t *port_phy_modes)
 	return err;
 }
 
+static struct regmap *felix_request_regmap_by_name(struct felix *felix,
+						   const char *resource_name)
+{
+	struct ocelot *ocelot = &felix->ocelot;
+	struct resource res;
+	int i;
+
+	for (i = 0; i < felix->info->num_resources; i++) {
+		if (strcmp(resource_name, felix->info->resources[i].name))
+			continue;
+
+		memcpy(&res, &felix->info->resources[i], sizeof(res));
+		res.start += felix->switch_base;
+		res.end += felix->switch_base;
+
+		return ocelot_regmap_init(ocelot, &res);
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
+static struct regmap *felix_request_regmap(struct felix *felix,
+					   enum ocelot_target target)
+{
+	const char *resource_name = felix->info->resource_names[target];
+
+	/* If the driver didn't provide a resource name for the target,
+	 * the resource is optional.
+	 */
+	if (!resource_name)
+		return NULL;
+
+	return felix_request_regmap_by_name(felix, resource_name);
+}
+
+static struct regmap *felix_request_port_regmap(struct felix *felix, int port)
+{
+	char resource_name[32];
+
+	sprintf(resource_name, "port%d", port);
+
+	return felix_request_regmap_by_name(felix, resource_name);
+}
+
 static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
-	struct resource res;
+	struct regmap *target;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -1350,19 +1394,11 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	}
 
 	for (i = 0; i < TARGET_MAX; i++) {
-		struct regmap *target;
-
-		if (!felix->info->target_io_res[i].name)
-			continue;
-
-		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
-		res.start += felix->switch_base;
-		res.end += felix->switch_base;
-
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix_request_regmap(felix, i);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
-				"Failed to map device memory space\n");
+				"Failed to map device memory space: %pe\n",
+				target);
 			kfree(port_phy_modes);
 			return PTR_ERR(target);
 		}
@@ -1379,7 +1415,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
-		struct regmap *target;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -1391,15 +1426,11 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return -ENOMEM;
 		}
 
-		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
-		res.start += felix->switch_base;
-		res.end += felix->switch_base;
-
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix_request_port_regmap(felix, port);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
-				"Failed to map memory space for port %d\n",
-				port);
+				"Failed to map memory space for port %d: %pe\n",
+				port, target);
 			kfree(port_phy_modes);
 			return PTR_ERR(target);
 		}
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 54322d0398fd..c9c29999c336 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -16,8 +16,13 @@
 
 /* Platform-specific information */
 struct felix_info {
-	const struct resource		*target_io_res;
-	const struct resource		*port_io_res;
+	/* Hardcoded resources provided by the hardware instantiation. */
+	const struct resource		*resources;
+	size_t				num_resources;
+	/* Names of the mandatory resources that will be requested during
+	 * probe. Must have TARGET_MAX elements, since it is indexed by target.
+	 */
+	const char *const		*resource_names;
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1872727e80df..12810fea2075 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -477,26 +477,36 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 };
 
 /* Addresses are relative to the PCI device's base address */
-static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
-	[SYS]  = DEFINE_RES_MEM_NAMED(0x0010000, 0x0010000, "sys"),
-	[REW]  = DEFINE_RES_MEM_NAMED(0x0030000, 0x0010000, "rew"),
-	[S0]   = DEFINE_RES_MEM_NAMED(0x0040000, 0x0000400, "s0"),
-	[S1]   = DEFINE_RES_MEM_NAMED(0x0050000, 0x0000400, "s1"),
-	[S2]   = DEFINE_RES_MEM_NAMED(0x0060000, 0x0000400, "s2"),
-	[GCB]  = DEFINE_RES_MEM_NAMED(0x0070000, 0x0000200, "devcpu_gcb"),
-	[QS]   = DEFINE_RES_MEM_NAMED(0x0080000, 0x0000100, "qs"),
-	[PTP]  = DEFINE_RES_MEM_NAMED(0x0090000, 0x00000cc, "ptp"),
-	[QSYS] = DEFINE_RES_MEM_NAMED(0x0200000, 0x0020000, "qsys"),
-	[ANA]  = DEFINE_RES_MEM_NAMED(0x0280000, 0x0010000, "ana"),
-};
-
-static const struct resource vsc9959_port_io_res[] = {
+static const struct resource vsc9959_resources[] = {
+	DEFINE_RES_MEM_NAMED(0x0010000, 0x0010000, "sys"),
+	DEFINE_RES_MEM_NAMED(0x0030000, 0x0010000, "rew"),
+	DEFINE_RES_MEM_NAMED(0x0040000, 0x0000400, "s0"),
+	DEFINE_RES_MEM_NAMED(0x0050000, 0x0000400, "s1"),
+	DEFINE_RES_MEM_NAMED(0x0060000, 0x0000400, "s2"),
+	DEFINE_RES_MEM_NAMED(0x0070000, 0x0000200, "devcpu_gcb"),
+	DEFINE_RES_MEM_NAMED(0x0080000, 0x0000100, "qs"),
+	DEFINE_RES_MEM_NAMED(0x0090000, 0x00000cc, "ptp"),
 	DEFINE_RES_MEM_NAMED(0x0100000, 0x0010000, "port0"),
 	DEFINE_RES_MEM_NAMED(0x0110000, 0x0010000, "port1"),
 	DEFINE_RES_MEM_NAMED(0x0120000, 0x0010000, "port2"),
 	DEFINE_RES_MEM_NAMED(0x0130000, 0x0010000, "port3"),
 	DEFINE_RES_MEM_NAMED(0x0140000, 0x0010000, "port4"),
 	DEFINE_RES_MEM_NAMED(0x0150000, 0x0010000, "port5"),
+	DEFINE_RES_MEM_NAMED(0x0200000, 0x0020000, "qsys"),
+	DEFINE_RES_MEM_NAMED(0x0280000, 0x0010000, "ana"),
+};
+
+static const char * const vsc9959_resource_names[TARGET_MAX] = {
+	[SYS] = "sys",
+	[REW] = "rew",
+	[S0] = "s0",
+	[S1] = "s1",
+	[S2] = "s2",
+	[GCB] = "devcpu_gcb",
+	[QS] = "qs",
+	[PTP] = "ptp",
+	[QSYS] = "qsys",
+	[ANA] = "ana",
 };
 
 /* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
@@ -2526,8 +2536,9 @@ static const struct ocelot_ops vsc9959_ops = {
 };
 
 static const struct felix_info felix_info_vsc9959 = {
-	.target_io_res		= vsc9959_target_io_res,
-	.port_io_res		= vsc9959_port_io_res,
+	.resources		= vsc9959_resources,
+	.num_resources		= ARRAY_SIZE(vsc9959_resources),
+	.resource_names		= vsc9959_resource_names,
 	.regfields		= vsc9959_regfields,
 	.map			= vsc9959_regmap,
 	.ops			= &vsc9959_ops,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 66237c4385ac..7af33b2c685d 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -458,20 +458,15 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 };
 
 /* Addresses are relative to the device's base address */
-static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
-	[SYS]  = DEFINE_RES_MEM_NAMED(0x0010000, 0x0010000, "sys"),
-	[REW]  = DEFINE_RES_MEM_NAMED(0x0030000, 0x0010000, "rew"),
-	[S0]   = DEFINE_RES_MEM_NAMED(0x0040000, 0x0000400, "s0"),
-	[S1]   = DEFINE_RES_MEM_NAMED(0x0050000, 0x0000400, "s1"),
-	[S2]   = DEFINE_RES_MEM_NAMED(0x0060000, 0x0000400, "s2"),
-	[GCB]  = DEFINE_RES_MEM_NAMED(0x0070000, 0x0000200, "devcpu_gcb"),
-	[QS]   = DEFINE_RES_MEM_NAMED(0x0080000, 0x0000100, "qs"),
-	[PTP]  = DEFINE_RES_MEM_NAMED(0x0090000, 0x00000cc, "ptp"),
-	[QSYS] = DEFINE_RES_MEM_NAMED(0x0200000, 0x0020000, "qsys"),
-	[ANA]  = DEFINE_RES_MEM_NAMED(0x0280000, 0x0010000, "ana"),
-};
-
-static const struct resource vsc9953_port_io_res[] = {
+static const struct resource vsc9953_resources[] = {
+	DEFINE_RES_MEM_NAMED(0x0010000, 0x0010000, "sys"),
+	DEFINE_RES_MEM_NAMED(0x0030000, 0x0010000, "rew"),
+	DEFINE_RES_MEM_NAMED(0x0040000, 0x0000400, "s0"),
+	DEFINE_RES_MEM_NAMED(0x0050000, 0x0000400, "s1"),
+	DEFINE_RES_MEM_NAMED(0x0060000, 0x0000400, "s2"),
+	DEFINE_RES_MEM_NAMED(0x0070000, 0x0000200, "devcpu_gcb"),
+	DEFINE_RES_MEM_NAMED(0x0080000, 0x0000100, "qs"),
+	DEFINE_RES_MEM_NAMED(0x0090000, 0x00000cc, "ptp"),
 	DEFINE_RES_MEM_NAMED(0x0100000, 0x0010000, "port0"),
 	DEFINE_RES_MEM_NAMED(0x0110000, 0x0010000, "port1"),
 	DEFINE_RES_MEM_NAMED(0x0120000, 0x0010000, "port2"),
@@ -482,6 +477,21 @@ static const struct resource vsc9953_port_io_res[] = {
 	DEFINE_RES_MEM_NAMED(0x0170000, 0x0010000, "port7"),
 	DEFINE_RES_MEM_NAMED(0x0180000, 0x0010000, "port8"),
 	DEFINE_RES_MEM_NAMED(0x0190000, 0x0010000, "port9"),
+	DEFINE_RES_MEM_NAMED(0x0200000, 0x0020000, "qsys"),
+	DEFINE_RES_MEM_NAMED(0x0280000, 0x0010000, "ana"),
+};
+
+static const char * const vsc9953_resource_names[TARGET_MAX] = {
+	[SYS] = "sys",
+	[REW] = "rew",
+	[S0] = "s0",
+	[S1] = "s1",
+	[S2] = "s2",
+	[GCB] = "devcpu_gcb",
+	[QS] = "qs",
+	[PTP] = "ptp",
+	[QSYS] = "qsys",
+	[ANA] = "ana",
 };
 
 static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
@@ -980,8 +990,9 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 }
 
 static const struct felix_info seville_info_vsc9953 = {
-	.target_io_res		= vsc9953_target_io_res,
-	.port_io_res		= vsc9953_port_io_res,
+	.resources		= vsc9953_resources,
+	.num_resources		= ARRAY_SIZE(vsc9953_resources),
+	.resource_names		= vsc9953_resource_names,
 	.regfields		= vsc9953_regfields,
 	.map			= vsc9953_regmap,
 	.ops			= &vsc9953_ops,
-- 
2.34.1

