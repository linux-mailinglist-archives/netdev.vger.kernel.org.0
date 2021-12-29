Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4171C480FC6
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 06:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhL2FDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 00:03:49 -0500
Received: from mail-dm6nam08on2097.outbound.protection.outlook.com ([40.107.102.97]:64800
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229514AbhL2FDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 00:03:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOPITIgWsaJaBfgRJRJ9mNDGWHzWPtmocWmbIKrtzJbQTDul8fa00MrLnWoDrM+eEbptTfk8iSZaTRBP8Pb0lvR0WhIVRr7ai4Sn9uZB80J12+zltqEO+37vIVKR6AUrrGbHrjUKgwIaEMIJNcVVX6khqCbWCs5gYHYosP+Zb/uZkHNFgEpq79aedwgCE4czFX4lqpIvPcwe1s6T/oFvkC2PUba7F3V01p5EaN74PFsTB85YJkD5Jbuws1h62o1OU3y3ujzWgr3FImpVa1bm52GuvIk3PWQbX2XqSm3/zR2mZDnpGq1oZZT50emGXWILSlDC0X+vUmFE34WGLV4j2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxp44wy/vkVOsA6JwbYdAYpKJJeRm9GLNLloxAuFrYk=;
 b=HZnWwcGqEY3ZuUuBKeWHZoUT5rX+Bk5YLCUHI9uXI+uI+bkAKoqdgX9/STm3wKDtZfSqWNmMcb8XFldYqvBkqP09L+BKOX4GX+DaO+gkEls0VsNCOje8Q8HuIAj+vVycH1ZUQfrecjJROkw8Esa7fyY86sULECK+NYyrUjaWryhHgbYmlgBMq+mBEGQ/ec4Q1W3hJUfM0YFumK4mnu2wZG+HuIZHMlgS6PvwCSw1/freXOA+JIFHLHFoladQF64+QBFQGj3VHqTi/zzfNS7rOuq2Z7qyb+tJrWQGeVEHNjjIPIxTdvBTgg7vAUvX0JaChS9a1Pt/SBkP3HTaxGGz+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxp44wy/vkVOsA6JwbYdAYpKJJeRm9GLNLloxAuFrYk=;
 b=HmxMXe6dswN90b+S+A9D7rGfA4mv3yYNMcjO19hhtK9mJUdMldIVQBvn4wqwaSaWlSYUUqMpPX6KAhUOVK++zKQyptFT6BavzXia6TkjOszCz0omQe64wOzETqzqbLpMIrvxKPeONH7bp92TeBE3qkAqRrHC743r3rQpscARwik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 05:03:39 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 05:03:39 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/5] net: dsa: felix: name change for clarity from pcs to mdio_device
Date:   Tue, 28 Dec 2021 21:03:07 -0800
Message-Id: <20211229050310.1153868-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229050310.1153868-1-colin.foster@in-advantage.com>
References: <20211229050310.1153868-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cd59efa-4b6f-4385-2f77-08d9ca8893e2
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB54413FC8EC3B4920DA2E4C99A4449@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6uXPwvMUGeEbL89W9FagR3q6TJYso52vcFwyBxfL9ewbx1owgiNq8Hpq74y6TgB+CG2sF53zp38luGKmAkGAH9PXS+RtlN2b+QuWQYufTFzfysO9GujTQBjr7Vc5AexwODNwhtd9QdcBXN0/rJfsBuhXo0YnpOvCgSc/ISa/5+XEVJ8uUqSt1jf5FCUmkqkiBSHJ90YTUND2tLRyMAU+zppkrgiuo4JN8nQXzpqX0/VhYoYg+xmXcqgOvEsQs1eyDnJ2X/0ng6cO+nY1Dsi8MSY3LI0NakI7wWKuXetaMcqIb618FYkGIjqGarr7xoPLdl7hysjrGA6Jm883O6tPWOateANnTEoICsKujNKBUK9WAZyyVbfLLpkaDIcoC529kUA7OOMNTSJhPr+jF3I2TZvVANn3PxzVjhExXJL+S51eYGVKcdSeQtBirtX0i9Zvz//iajc5LgAVT2AEGby74pSjhx+Lit1T8XiQi+S0zpHo0e8VSA9/YuUZ+OdJ2XU6ZKP1nJcPVSiHisqjO/3LWlKN4r09z2oQDR86JdjFDUqb7oHcW/6D8HTis6bQj1aV15hawBKQa3xNBMjxWkAsJ/CCYvnU+yHpnpIfFxN2PMj+dRGUNyJne3UlmZ+EU6f35NJwmPUO7YmcgAwuc20+O3vxlqpwxsBBT7rwf1/l6YBIzs+73JxXtRc7yBhyiqegdz+xa2DwZGe22BV10W15g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(346002)(366004)(42606007)(38100700002)(316002)(1076003)(54906003)(6666004)(66556008)(66946007)(66476007)(2616005)(6506007)(6512007)(38350700002)(86362001)(52116002)(26005)(508600001)(36756003)(4326008)(8936002)(5660300002)(186003)(7416002)(6486002)(44832011)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZRgDkn00w2mVf1bpiAwm5LiPrQen91sHGMgTD1YqXu2fqaPQryWbC0aOsIdc?=
 =?us-ascii?Q?06tgspK+vuLUdqpD4s0S7bfU8+otAQnk8jN79H7guoPh+M6lFDW3Ja+H/WIz?=
 =?us-ascii?Q?jP7BfXwMHK9ja7cmNjRcMedHzWy85JqEb5Ex94suXiXBq92UxPP606I57qFe?=
 =?us-ascii?Q?g734wctgbr6fm8aM45P8/3Myj48Vgf+MuZ/MbTh0woaSfZYBedga4CO3TClr?=
 =?us-ascii?Q?g5Xlqwe3YNzGweYh3g9raJ2SOeaGqaP89KANyxOJrjorA5krtpsTFCrEccWA?=
 =?us-ascii?Q?FFZmQNYAnRrCq7N8j6kuQVKw0QcZXMWy3Epb6DruDDb+mHouNnHO32GZDuz6?=
 =?us-ascii?Q?dip04zCfYrXsBXS30cJh2CR62fKIm3SsiIPQetg7pzWoWCQetlfN3CCd0ldj?=
 =?us-ascii?Q?Cme7VVGhxUI7FtOlUQvsDDiBkpXqGQYqHAVjGGrXmTRC3nG6SMNHXD7g3yVj?=
 =?us-ascii?Q?5x/outsr2Ogb2z9L5fV/EP1g4jtHd3g7Gw/XD3926ns5JKFBZ3ND7iU4n3zV?=
 =?us-ascii?Q?AavZFX6mpofIbLcdaqgRQjRWnhMU8uTdSs5D64Ys4qJeu9QXSGDuc36jksUc?=
 =?us-ascii?Q?v4NyMjcWZPBWuCxOyCLY3q6VmIJ5YmnugtrMyrLrLnzkeWOZ16A1cVnrKItY?=
 =?us-ascii?Q?7vtRzpca2OFWhcl6mC7TuPuWZGX7mOerHLco4QHoV4EvcN+TCrmFNRkl3ztx?=
 =?us-ascii?Q?caYKBCTn2TVTZuDJOnLvqoh5z5im1dafcsXdq3CEde+GIP/dks5jEMDXu71k?=
 =?us-ascii?Q?hcYH1OBX97CtTyle6dpnK0yKGtwg5pciZWrwfdQbavrPfQj4oCw49T1KbZk2?=
 =?us-ascii?Q?wlMFIjyw9IIMA8rQlvsa1Zsqa9YE3tPAgsaOA2gWiJG5vKJ26nEfv1D942ID?=
 =?us-ascii?Q?MW2l+uh5qBahMFiNJXGWevccKloG16lCxrOjt3f5plRcNatSZ932hlCKwbIG?=
 =?us-ascii?Q?+ZttrXobAIHzS+uVDWal9BjZNvl6ZRWcNsyJu8R6+oDBIaK28q8R3eu+P8Vu?=
 =?us-ascii?Q?h8hDyBjRXRbAdCTaVK96vO9Mfri665Y8AWkNBYy0RO0a99jDYVlWz5NeinAy?=
 =?us-ascii?Q?iIGJGT8gSjQW6n864Z9i+6pajIlrOGRyaG6jfqs0551WFIRMIvDJh7QbI5mO?=
 =?us-ascii?Q?8PdxKqPluPPN0Sn4NvVxDIJbIVEtc39Xw2JsGHuAohXcdSqgzWepORsunJKv?=
 =?us-ascii?Q?5rLKzdWoa48EQn+wm1pD5Gxm7j29io2CIJp16iz5vaHdJ8jPUU4BufaHszMx?=
 =?us-ascii?Q?nCMUZeZUSq/edaOmo4PEPs3ibzb7Vkv6216gtoFeMYfntvdeCdI8Y2unORCQ?=
 =?us-ascii?Q?s80lh00T82W2kiLvelQ3nbXZ/rT7eKnaXPhH923uC5R0m6GAM5VGN/T/jaI4?=
 =?us-ascii?Q?FNTWMi5ftQNjejyaNxAvXU8lNiZVhzi0eMlSQ/irIgHWN2wNzNia+sp47AYQ?=
 =?us-ascii?Q?ssrxyHZxuBV+9fnQyrNnSyr6oWPmgxPM9qHBLEGIOHQU6X0AP3WnfE+bUfgk?=
 =?us-ascii?Q?yjzsKlhxKozHQ0pwg9kzZ/35AEPNKWj90ka4W4+WfShvakQtvz7Jx+hN/1K+?=
 =?us-ascii?Q?f5wwyDbad5q4AG+4aYPxvN/N47r5UuqexYwZRIbILMwznsqvJWuDG/riNZVD?=
 =?us-ascii?Q?uuBciRGdiZIE33cvSUIbOQfBl7yA70aphiUJq3iea5k39WxDA86rNoJbplcN?=
 =?us-ascii?Q?fSve6WO2igtRcsCuEM7oT6LaDy8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd59efa-4b6f-4385-2f77-08d9ca8893e2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 05:03:39.6479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLcNfNf9N87P991h7r2rwLXtEedo5f1VhY1smLcYqmWnhPHFr0euyYXkqyaZFWCitZaO+T0pNrQ9FTXBgSKGXYVVt8o8a+er8puqQTIRxiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple rename of a variable to make things more logical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 93ad1d65e212..bf8d38239e7e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1089,7 +1089,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *pcs;
+		struct mdio_device *mdio_device;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1097,13 +1097,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		pcs = mdio_device_create(felix->imdio, port);
-		if (IS_ERR(pcs))
+		mdio_device = mdio_device_create(felix->imdio, port);
+		if (IS_ERR(mdio_device))
 			continue;
 
-		phylink_pcs = lynx_pcs_create(pcs);
+		phylink_pcs = lynx_pcs_create(mdio_device);
 		if (!phylink_pcs) {
-			mdio_device_free(pcs);
+			mdio_device_free(mdio_device);
 			continue;
 		}
 
-- 
2.25.1

