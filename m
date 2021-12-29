Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882A9480F43
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhL2DXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:23:06 -0500
Received: from mail-bn8nam08on2138.outbound.protection.outlook.com ([40.107.100.138]:18785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238553AbhL2DXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:23:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad/bGmjo+IbVbwPRG/+VqO+iO+YX0U2YksZ1C+pITDigK/KtmawbyZziie+9eWPqhICkaOmfMgmiotRa1hOwzeJZruGCiSMFolU9k7OpDwwkKgzRfjtUrLzDQ/lybBoat9eZsVFaXmyla+88KgsOzk4QMHWxQjhtov8Su/OnlgG75EjVRamLCsXzuemcCHqn5r/R8M5yMZtYuqpm00BEA80K0KUs9yZhA5Vpql/5wzZWOzxs7KrQ3ex9YyMHbS685XOlhzmxsjwYVgqdveDTmPqJDrt2x5oEsTMEzX99/imjcvXedOXMmlUWlu2Egb+8bqZCbGTdL6Dw8U5A6LPiOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaydjUIgrKi0bNJce1tml4C26FG0kOgN/Ew4lJlmzY4=;
 b=PkG/d5Pd1F4b/SxiVRA815e4z4+pSZzbRzVwCydHXHUBI2yS/4PkkPq0Jbl46HWKlDZnH3aSywx1hQCSiqoDqLmQvJeSLzpBCleqUzHkMvZ9FCk6/fijJ+zici1Z1EuoNP5xEi+wiyW4kN2ZkemAxhN04Oh7aCQOkGfqEgFkA/G1ToZxcfSRiqdA/RsPtBFR1EJ/8WPcf94Ec+c07nAdMlzpmkOkODP7wW9Zi5CJ+p0TyqAmkFiWnxCuj3aB2oFMPIEJf9Muxhdmjn77AAPBuEivA4mjOnR5+VnFJ31uJbJTGcxqwkc79Hss2hZTavwJLJ+4lt2cJT84GpRV1r2fSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaydjUIgrKi0bNJce1tml4C26FG0kOgN/Ew4lJlmzY4=;
 b=dzVZaKA/4nF3JFx9B6Igzx2GnNeWnuhVwGMuy61J22nAGqh0vIG5DAROQUwrmGk3+KgVyTVzxbKDoMB76eKPPUaCMKOpm6WKrcYFdBr65rZe4F9Uasgaq3aw1o0Ks5JCemi/4W0idfXBfTqHmih2ZIKbrlViu0/o8Cuo0hRmiTA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 29 Dec
 2021 03:22:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 03:22:49 +0000
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
Subject: [PATCH v1 net-next 3/5] net: dsa: seville: name change for clarity from pcs to mdio_device
Date:   Tue, 28 Dec 2021 19:22:35 -0800
Message-Id: <20211229032237.912649-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229032237.912649-1-colin.foster@in-advantage.com>
References: <20211229032237.912649-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c9a6ba9-d8d6-42f6-1b37-08d9ca7a7dea
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB552168A84095B4E190989D22A4449@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Ghk9Mi87B8J1zabxPsSIvHNjL5tujFttzRXHDbQeXbE79k7gPGyJq0ZODoSsguOxqpr4QlSEV+t0uvjyOXHyKnDNWsESv42hKIJ19JtlarGd2GGimxkA3/RbdR+d6BFJ6zgf0FOO76rgUm3pBLapZoRVPBal8Q6EOA5BjfGrtv7RYt4Gs9YGWMwlDS3TzoxjHuhZdnFZBpN7HaTL0c9u0hFpnMJP/6w7cwyC5QjImokwkXKKv54RPjLLL32HuvufX94P4NG8QqQUbe/hi3Pc8ZbXUtw4s5M+x5yuRgmC6M5aQA2+vfPrdc+pQfah5cnkJHKaHPPM2pzooYu2yAoUurYKttvta15GZCybG3jiVU7WZiIERZTJRM2TPmHPClLw21bgt5zX/fJ+8NxLWzaufdgxsI161OYF4cifAXXTriNWA3tE/HBR+nolYQ7WuM4gUTUzDOIBsMM6zLnGNwhNwitQpMztC6XySA7vN3uR3cPMnD1HPxYxIia5X0MPj8ZQFb55+8l9B27b6MqMpkJm6b1MzYVqzzlYRigjhSsDHZDH3pCu/5LUt2Z7XG/iuypM1mZmjy6n8+CbQoff10JIL3EII5YgGIwc72w6iwDqahW7Kqn0eO1XlymeCpI+bmIyp5FjfNjpjtidxVhqo+ShU6ocDKnHe6yKBn42U4gWkcz9Y+TwynvVQvozdYl6AGjHnWR7hqqoougkzO/veJIVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(42606007)(376002)(396003)(366004)(39830400003)(6666004)(316002)(66946007)(186003)(8676002)(4326008)(2616005)(2906002)(6512007)(44832011)(83380400001)(26005)(6506007)(508600001)(1076003)(86362001)(54906003)(5660300002)(8936002)(38100700002)(38350700002)(52116002)(66556008)(66476007)(6486002)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cAOTTGDjB2Ap+7TrGL7ozyisAMF/5DFO6fsxCIvNP5gcMi3ycBL89s3MS9Xb?=
 =?us-ascii?Q?FagpZPqECN4FJEuqBdR8KL2eO9NzIpA8WNLsafKjR9k+SmiSADdkDTIaHgQG?=
 =?us-ascii?Q?garyCoGxgvdtaFKJ10rRKpJoyCjzA8S9wuQuTVf2h6b6/m+coFB9I4It1OKQ?=
 =?us-ascii?Q?FRR+HbL4ngpnIIfxeH5Yn/+QzQT+fpIQwzY8AQ18QTk99n06FkIwCOvOeInb?=
 =?us-ascii?Q?St98OEEI2J3PhnXLsQHwRKAv0xHlHWmVY/xRfVXxcMPYrgOAwG3A3k4l7ROc?=
 =?us-ascii?Q?sovgShZHJbtTsbu2Sku7NShvcLBR4xJ6CyfdF2kKDsWve7G0moRzZhIJs2Wk?=
 =?us-ascii?Q?Vpyb9cB4wmWKKLaSER4m7o+D5QxjiN5ndLlDUPC4MaHahtb7a7RWLT0c7J0f?=
 =?us-ascii?Q?3BPRGklITSiVvoVL2uLv0rFXsPNkAi9bC64gNSaZIzuksWQU9MRtYkJ9uTRH?=
 =?us-ascii?Q?1SDCrQx7KqVdCJCI1/ZZkVc8HUnnmjvbEoJmGRCZL1d2ABxdUC9a219o9Rbw?=
 =?us-ascii?Q?bTNm2m/m3LWkEsjWSav3M9FbwVcgKlh5OX89Pmspc3oFikRUUFGUrAZca1e0?=
 =?us-ascii?Q?FCfXTnu08kPZn/9edLF/58XRhssOmr6QCG/mQZ+mJ7jEnY0aCbJ8pfLVETNx?=
 =?us-ascii?Q?oycXuvE+X6dyT+ohjYweCsQOiW2ZK1Ch0nrNrxm8a3VMQqdXz/RMHuUYz3UC?=
 =?us-ascii?Q?QFN9wuNVm6aL3BCly+b1ch3aXCH42M2l1gJhWgkVoTM5eohQrvxQ6UQ8d36/?=
 =?us-ascii?Q?K29XBQ75rso8+oKq1yizGwDa7MKyfkyvB1al3izmNWwBqXYBgJ4KsHmW23zo?=
 =?us-ascii?Q?Nncw0YtpkstbnhNmmhemBJSI0qKXxMYgTJxAWYBSu167zZwRaCZdvPOsV3ko?=
 =?us-ascii?Q?8WC+vhaas3uCS64K1UKKL7AY+kZSvf6bNbGDhgKvR5ZBPv7cqKMctQ80poJr?=
 =?us-ascii?Q?mGULgymlGuhHRa/COIb52VL+qsHpxQzWtABOZGrF6iiA5+pDFcqJdcSB6b21?=
 =?us-ascii?Q?6onXlH4j49PPTjcAZYhEqVSqDaguX0nNTmX28BOqq0H73nM7o3maCWxdmzIj?=
 =?us-ascii?Q?IGnJA/A/QfRwR1kJgNq/zwYQIlc7hua64EuCy2oF395qi7vUFm9HdGgVJXgq?=
 =?us-ascii?Q?3WjYIJ6kcPMjUMgd1aepbAhiLHGDDqb8ATwFaZjFwBEgkGOy14Ug4GLBWjhb?=
 =?us-ascii?Q?SY9YL5f2cFP3EvV6X0sWBa5fRAyG3gX/N8NBSHXLeJZI/6olxSOVYbYwQACH?=
 =?us-ascii?Q?XWH2mAhj64UmL4tEkOeOUtHy8H1lC3z913SoQpNarVGGRja/2jqMrVIE7hZy?=
 =?us-ascii?Q?HP5tV+Pg5ebYeLbMqqr0LQOHNbCcWobaH6wo+ca0Hyvi9pRBKxKgE6yccVms?=
 =?us-ascii?Q?nNXvyK/Yh8WeuLlMdJWf7+UVsAEpnEZ7k3jyWi04jQ2SbM//b6NkHgJqfYDr?=
 =?us-ascii?Q?0Oy/u2wLBeiL4jPlxtob1q4mG0QBfmUD4qLcFh2if/o5wdfa+tjnvs2cA1n4?=
 =?us-ascii?Q?IB72X1xQj4xr+4jH5NZS5joM7lf2Avin1sILpSlllSczXOOmMOHc7YuDEWE1?=
 =?us-ascii?Q?WafmMnkC0LGSi0GRXUUJeMb5GZYKwN8I4TborWBRxYYEBQplVEbEXToJ+95/?=
 =?us-ascii?Q?ym+Y0r2HcGMmqTYgHZZZQXyRiaiZjzMt4YhzYGQh8X5NRZu1ZDbjFdcb82mX?=
 =?us-ascii?Q?IgK8vQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9a6ba9-d8d6-42f6-1b37-08d9ca7a7dea
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:22:49.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCogmBJxFhIPNE/aDUQg1/7DfJnL+jdK0uhw2L1RZv/v6AC18ohiPlQLfwQLOuXc64eVL9oUn4PfNi+xG9aLd7MZJ/mI8sAWYwtt8r47bMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple variable update from "pcs" to "mdio_device" for the mdio device
will make things a little cleaner.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index d34d0f737c16..8c1c9da61602 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1040,7 +1040,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *pcs;
+		struct mdio_device *mdio_device;
 		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
@@ -1049,13 +1049,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		pcs = mdio_device_create(felix->imdio, addr);
-		if (IS_ERR(pcs))
+		mdio_device = mdio_device_create(felix->imdio, addr);
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

