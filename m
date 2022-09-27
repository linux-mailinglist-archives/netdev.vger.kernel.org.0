Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A345ECCAF
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiI0TQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiI0TQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:16:04 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222BDCD675
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jY5mI8lvF7GE09Qh9JechvF+D6VNGWBW70juiXzP8/FAWC2ljVSSOeTUCrCGcl2zMk+kKITrp0c08nXj3euFo8KDYWL9iqrALPu9jxOWPnSDSwBMn/pGJSHS1Q5Gpk0ZoTqxCBFk8AmmkYbLZk4ZuaNyAfX3tI0+HKP88WTnVDycOlKBXLH9sWplMF7RAjNoylAMzAV3A3t/8U+e2fUNNa+UcQapm+ilfm/nnEKIjbuK/ylP/JziVcxO8Oz9oAYYB7Nat7vIK/oug6tBIxva/TAXM+MgxMt/FV9mLPVVyFPvFOj3xR+4EoPIdPMbg/0LnOWZORD5lG4l2nDT/RAoGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SopNKJS5ildpDb3An0/T6b6UavPTCBFMIkrxdhb7qjA=;
 b=al6iQGfgYfKfzUxLIv8wIV51u98A4JRiLomVuXlWLLEkok2yEZEBW1lAA3DhW/oTux/WX+OujVZAcwFjRy8qfuqa8QzAsWKpkYRYl1CZmFAFAZJ/OrMAi0O4pazztA1zmnTkYKdmD0LnvxxDyymyHjZocY7U5oxOFTHHX5lv3Z8hWEbUVZOu+sb/Mk9E9DTMo+BX0oinyF5XASizzQ74corgdtup46oDW+KFozTa9wZi5aqftDv9/qAHwNxvmcmvwwvEYS1mTWgjuV3XOEVwbty1RLBgyiJl2Qq2ba69yb0ESDdxT+Jb+AlKIHxvG9PC6cV4lUvs5U9ME67xooO60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SopNKJS5ildpDb3An0/T6b6UavPTCBFMIkrxdhb7qjA=;
 b=qpbL1nbGkGCtBGcFITeEWRLjfDtoe9kovTqFq0ewAuR60HaAjng9oS+2h8kAyXCzNKbzZL9xE0tonVVZyIW3zCaJOR+uhQUB9BVUcGjk9nkhPqEI11bnmOXa2naqLtAnAvIzt03UR6f2yc5T+Gr6v1NVK9gEVo1I4vXRRlQN+EM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:39 +0000
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
Subject: [PATCH net-next 5/5] net: dsa: felix: update regmap requests to be string-based
Date:   Tue, 27 Sep 2022 22:15:21 +0300
Message-Id: <20220927191521.1578084-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f99883a4-693d-4cf7-ab30-08daa0bca9d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0UtMnt3IfiQfcVgDuw7pNRRauECLnHOL0oVtlw6lJn2Pe7ASvNCLXjkq3zWAiAzczUCR6tbsUwe6uL0p5TWZlhIl1CAtGpSvzDtvytVRAyWuCDQtc+khQiz9CT9JhiqgBPJqrNrKixnAVvRckmOnqq5rYf7RgTYRzn1Eb+UjkrGfTGyXKl+6r2YNqZgZYDER2p3+sKHfUEaVs97VECZVRfF79N3O7K0foyQFxf9q+Y2ckVhVkzkuqC8QUC++eaHhTy0hYVgQwvfQpLeY3TCEx/a0P8jGg8blp1X24/HY5PlLq1aJC3HBnU4TZ3o8LGcZmozrL527xNTQbROpqTbuulzNVKuoCYH9p5/EfQJaKrixEpnjcqM+bllK+2LYZwLwQKP8Hmnar/8JV70Xt/Z6owbgt68zZfgMJ7es5zexP/NgExsWfM2sbphjjeSAZiFdqQ3/brf68fDkNN0N05VqVFb5rS4ns6g1/mNTg8AEF8qplqWYD6TFWgVL1GuP6l7vErxZBXt3btDu9/jDLWyy7pDz+qZ+vAFHQ5dRGT/JplfiZnFvRjV8gxMvzY6/eT6Cam1FDp0yjE8qMpDu+yUB+NVwdoEtCIwErOAdXPK9IxIlrEaxOSq1d7/sZzIudzHe81+qe1b6OTVDu1fBthztwc9Vc7CXJOlpJqgQkz2CKTogPWuGSrp9fMMuBa7agyVXsJQ3rOsYgzzDNSNhEZI5Ln+VafYqZYOpx8JymUnKlBpSq6eQkgMUXKI9g6dW4yzAAFPFDqS80kkeesPeDiZ7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(30864003)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?foKZGkZoooK++yWatDcs1Cbysj5YLBMvss9PsaWXqvDrmtb/sKSDjPqmWbIz?=
 =?us-ascii?Q?tk76hOvOjREK/Md3+SUFo3vLkUSJHiwTgduZaNM8gLc7qo10MA/wVgbI/7C/?=
 =?us-ascii?Q?KCs0ksDS+FrB3XwaGD1g/vnmyWyVeSHm+fRECdLwW47TwXk0JhHbfQ07QAmr?=
 =?us-ascii?Q?wRJ9vlMEJrGymEZx8ZLVWqyCI/xfusQGHP398Zi9kUZsIALTeSwHBuw1UQdt?=
 =?us-ascii?Q?yhKODikbv9xTq6ePgK8EHk7diH/AR5eAJkyFoWkMtJMvGCtNqMHfRFe9bb6N?=
 =?us-ascii?Q?LKsGmjES0M4qO/56LwFgfo5Rv++j4LYDX3oNrm5FzMySxyqgphtlV7XHspB1?=
 =?us-ascii?Q?hq2NwqTDxLz/zDD9hqeXAeZ6UD3W8titv7FrkUYtRrOKYmI4sHwc2qhpkPNm?=
 =?us-ascii?Q?cbfXmyC5kjR/DKwHWvUPhflXwPnhe8JEQLdeXHMgPiHZj3o13fhY/jFLqJde?=
 =?us-ascii?Q?MQo1yOsoJ1KevqGOAEJ2JFw2r/ed4d+bbHXXDxElHG5AZL18Eo1237KZ26iF?=
 =?us-ascii?Q?aSXsM8UKLqBwP3+Ql0w1s+BuaAcqgxLHqsWCgKzRqwxSxEk8Ua8yc/TnMmMX?=
 =?us-ascii?Q?sxEljFyeaX28qrQHAHiOk8VjiI9Lh9nyKs+qsBIXN614TtZG40Hbzur64Ln8?=
 =?us-ascii?Q?2ANuc21dBumKuFxa6tc75XzkQhnaNlVp76dDfYUlo1Ir0pzlgUw27VjGggsE?=
 =?us-ascii?Q?LJw4vzM1plgKjaQZn8C/d+aLQKn9iIAod7cQKbUAka1LgJjAIf8dey5px+Xq?=
 =?us-ascii?Q?7eF+OsI5AmNfph/k1bIqYn3HW1k7qap9Q6LbAQcOtPRYXEAqxayxCwrTG539?=
 =?us-ascii?Q?YpTH59+os3uVkswggXrxDJAFHVnqCKawMFTEewvOLG29APYVv7tIlhSlBbKi?=
 =?us-ascii?Q?kFx3CNlMg9RhYx3/DqQoOgkYWAi0h7+4y4VOleeOZU7dYr34hzu9/XRxITHk?=
 =?us-ascii?Q?W+iRfAJvMeTuuYvRpUAd+mTAR8QR5DKsn8C4PIMpLve9Md4Pke8Q3+x4VQvq?=
 =?us-ascii?Q?cCoA1TntcNjxh+cYykZUQBC+XTsOO7SXc6LD83DwYyjhfrEZJoHaQ/OZIzpz?=
 =?us-ascii?Q?j7nWGKyl9jM+99Uv6Yr5bsBVeDiVKHdX033coqkznYFg4GWCpQGhkOfniibF?=
 =?us-ascii?Q?hlmlOsO5KIrzCUyVAYHPJjOdhpN8Q1pkzUAdsXl2ktrfnI7WFVI7y008HFkO?=
 =?us-ascii?Q?KAkgAsalRHLl3AHAMIH3Gy03HXS7wgJ0UOlJmaVicD7PIjMZ39gml3Nb0mau?=
 =?us-ascii?Q?OoYQCNimWm7NEa5vc7GQM3CmeELyQCB5B68OKli3Ni4S/nSme1ZzOA3xR+Ut?=
 =?us-ascii?Q?fDeAlpTCVM3Iq5h7SQwXBqmWtTVzinLEhCHJRSnmWF4kIUDzF/8+/R6wbnJL?=
 =?us-ascii?Q?kjFTU1CMXSyScT9tEPLvAGsNngMzPdFdDnjnk8A6+1DWpSL70zflsqqhLN2/?=
 =?us-ascii?Q?kZ+Bs6VVkDssHxAVR/z1YncQPvvgsbB4GLJv3ITKxuyyxJ3igyaL3wpJAvlu?=
 =?us-ascii?Q?/Ecq0tGvZ93ly4XVlqd1A5h6VEI+CUeNR1kWejo3BhA4H8FP3piXGchSw+3E?=
 =?us-ascii?Q?KK9RLeyXwkZ9FfRmkaB+hSft2l9hgFlh/aNgqFDgZ5sdyTH9Y4+sfwadq9r8?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99883a4-693d-4cf7-ab30-08daa0bca9d1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:39.3013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QF7VrAPyPRZrSVJ6hT7Kzx2HEemYtlA/bllEWrbgEzRN+Flvi5LmQFDaaDIXoKiGPJr/oklxW90INeKXH4pvPg==
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
is kind of odd when considering a typical device (those are retrieved
from 'reg' properties in the device tree, using platform_get_resource()
or similar).

Allow other hardware instantiations that share the felix driver to not
provide a hardcoded array of resources in the future. Instead, make the
common denominator based on which regmaps are created be just the
resource "names". Each instantiation comes with its own array of names
that are mandatory for it, and with an optional array of resources.

So we split the resources in 2 arrays, one is what's requested and the
other is what's provided. There is one pool of provided resources, in
felix->info->resources (of length felix->info->num_resources). There are
2 different ways of requesting a resource. One is by enum ocelot_target
(this handles the global regmaps), and one is by int port (this handles
the per-port ones).

For the existing vsc9959 and vsc9953, it would be a bit stupid to
request something that's not provided, given that the 2 arrays are both
defined in the same place.

The advantage is that we can now modify felix_request_regmap_by_name()
to make felix->info->resources[] optional, and if absent, the
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

