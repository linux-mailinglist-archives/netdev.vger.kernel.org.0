Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED6431374E
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhBHPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbhBHPSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:18:05 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0623.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBD1C061794;
        Mon,  8 Feb 2021 07:15:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCUwBus1Q+xDPKi/hflCDR8+UmK7v7lC6rxBZJQ40ZLnay/sey3fKoWC+RMhZpIEchVwvREei5xTapOOQMKLKPNNWu+AhVW8Cl9TZjsJo/z7pBqUdka3u5xYW5DRLYOaDKd7jGgjYn7tydKoTf6yQPQLo+ipxE7Wn99IaMRyFCS7lpb++C3byQswflwj7nRhc/bHWvPo0IfktucOB+wRraW3UScR4xPHVthaEQ4TemCbEw2M8fJuPGm1Bum03izFgSxczDlwIt7iSMso5Ke6FO6e7Nnja0M7ulxm1FhkW5KfaurZCtHr/hBb9gkyhSJ+ROA0DdvGTVZidvx1ubrRoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCBp8rO7dBQKpbM34w0p7sIq38kfFwlkSd9Lunk4aSk=;
 b=RmWgLaWUlCfdzW8gvLfUl2u+xWKCAsEqzIY3KugdsRH+DBmmyPJFuWFdskQg1uRr0r42BV/L/oYM0Z7qUEKF+euqPlFOVSlzYDyb2S5KyM9W6ahBk2Zq6HuBqi8sFXcE44CLl5lRyohcYIx2FwekQ0oSkKUByzeXbxUZY3nPQPDt4ot/7RqRoK6AZ4nSMIekk18aZ3scUydK30EDj1G0XmnXCb+3Uqa9wYuc+MZ5HG8eXMQ4SUrIyAVh/ZldXKViI8h7BHGqX6YLZcyBBjMRDmcZhMGpx60AVLjYbDvm0o/YGJqHSTMYKsYiWOjaRkGjnLMWPgLyMgkYbngDvgdHFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCBp8rO7dBQKpbM34w0p7sIq38kfFwlkSd9Lunk4aSk=;
 b=N+GPvRrknzarMoN48Lp8Kku3rZ3/jLQ6vuAnpdQUJESNj13LMdatD26Ywu2quVOFm/O/duJpaMXEo67/R+0Kw6t4ZZTdf04t4y22mbwsnzMhFgTgzcIsN2PIZ0vi0ENUcStnJ2WRjVri1OH7GYwnC4EEbkKTCqbbAO3n1yz3ePY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4772.eurprd04.prod.outlook.com (2603:10a6:208:c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 15:14:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:40 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: [net-next PATCH v5 12/15] net/fsl: Use fwnode_mdiobus_register()
Date:   Mon,  8 Feb 2021 20:42:41 +0530
Message-Id: <20210208151244.16338-13-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9069278-ce64-413c-7d31-08d8cc44419a
X-MS-TrafficTypeDiagnostic: AM0PR04MB4772:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB477256357245AEB5535D70FFD28F9@AM0PR04MB4772.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhQ2RGc46JOkTBaJOywjIl4YQW8THVmLYg//QQtXVnNSUzB34KuETSs65iLtZaY3aiUmf1nxXiwKZ2CTBmTmhDEkx0Q3xFMgMbSVjfYQqPhnVA29BY3prs56zUbg+m5YRV5dyJUsJtcaRa6S6tmzuuFtXicSQP4iNgp/W4yFMK1LbUHQ9g4PvCgyckS9koDRZ2Jik2r+AQtmpIl2979VV1JEmMy2KFzpi5LXkLublUyv9Ta56QZMfd2OlS7G2FBefAb2nrjHZvlaWtWdu3K0YoWSNvVwPKhIXuCVK18FSrUNWk+naB1sMsAm64QbgQXzBDIBYwhIBHe/dK3GVeJOZCLmOZbnw39o8zJMFO+KgcuIE5wSRz1X0NGhp8WmWKlpGxy+1YAoRG/SEgIBttMTfLzvSlU3QEgiddnqh6ctw748AbCBjgh6xdUkRi6BsXKcvTfJHZJSEOUYVQtIsn0O3lCvydEhMFSMQu6k4EOgH6h3ZbXMVyhtiq/AcvVeyYvRPTJ/QkTIrVZdeSGBQva9+l/bpETYfdqx8GGv9OPEIZocrRi/AroHBb9xy3LUI5ekaVVKKDLKFP4D3vVaFetkW2TuXw3963wFGSPqXcR7n/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(86362001)(8936002)(6486002)(7416002)(16526019)(83380400001)(2906002)(6506007)(478600001)(8676002)(26005)(52116002)(44832011)(2616005)(55236004)(66556008)(66476007)(5660300002)(66946007)(1006002)(316002)(110136005)(6666004)(1076003)(921005)(956004)(6512007)(4326008)(186003)(54906003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?daNmY1baiC+dsPvUCA/t8+PibzCsHL2OcbF7hwJKa2hCURlOa+Oqg3V5XpH9?=
 =?us-ascii?Q?1DmRDtZvQ0It8aoZra1DklFOQdTFCU63ehd2/w7pH7jG4e1pkCy+MbAqyU4v?=
 =?us-ascii?Q?fcfaerNnI4CZ3YvppE19cA/hseyKG8zxDA0Ny+XXp36zwLpRXDfRBkTTzc3p?=
 =?us-ascii?Q?GxmYZWJOh06Zc8aewixrHnsiFPx8Ckxfla4xY/01YI1pQ27wqikoPOr9Wjfb?=
 =?us-ascii?Q?Ba2UnwKfs0cjsoAej3fHCnhe5mbDNsAFbVBKUThLZXoDZqT+8CXJVnkAGxGT?=
 =?us-ascii?Q?nowkAPtl1ZOtLD2He2W0+h7UE/2Akrhtn/3aTZQBNQf4TFQP+Ne5Q1txvVy3?=
 =?us-ascii?Q?iDjiHhnU2lYjJKvwHUGqg3dWRjFFqmc/wvXGZTbruRSH5kK2wDSlPmPSJDvh?=
 =?us-ascii?Q?rZGQN88p8S37jt01VkAz5C3P0ToyWeC62YrTnGlTBRf+8RMKtDZoLHdpxLqp?=
 =?us-ascii?Q?VoBy6GAPe60R684YqiCvDzugCgsEbHf26FPnDYqGEmDG48H2t5qYKxWY0d8x?=
 =?us-ascii?Q?O2ClhjZC6dEkM7wsvjKz2A9K3gkMlBeyqIF/NiTAPGXdV2V+7XQ/4iE+hrco?=
 =?us-ascii?Q?8uzd/FdEDZTrz/CRH6Can+UuwvqunZSjgf4fzWqBa5X3faXyUxtZ9On11OiC?=
 =?us-ascii?Q?OWVoOiNNJvUqeBJHvA2qe5HcNsgzFIoOBtXTR8uC9a+FAj6yhGCCtiYsVBr3?=
 =?us-ascii?Q?uiqA8OUlwOABTpi9uowktqKm5izAPGT1andR4lnJyl8ymn3Aq45R38B59hRe?=
 =?us-ascii?Q?DjO+EfXiazM7ojH0JvOpqs92kxFWqKZOyGpbQunCk/tn2L9FgfCCjGMLa45d?=
 =?us-ascii?Q?xMYIyffViMj54UaCycWHqKifr1Ok3WN+BNNSz5JWQf2dzgiK0/ZbpWIf4/Jc?=
 =?us-ascii?Q?lzTy2pE0XJWBVrwJPndneu69u/VE6u0i/KIIsQx+A5uI66QGZxa8wTW3smZh?=
 =?us-ascii?Q?YjYidVc/08FNq/6i4nHNxPHOSVkIzsfs+AxGiKabWq8uev2k5Eaj9rf0dkDB?=
 =?us-ascii?Q?a/SZylD2BnWlcSrm3xlT0vI8927KQ3ePWwb4xjBcp+hJe3Zn0gn8LkiXIP33?=
 =?us-ascii?Q?nGYpghNYoQikamRDoGtKTB7uz7jxAFGFvLEVMzhhR+P2e8ocUWBGNY6mJ936?=
 =?us-ascii?Q?bGS90oE88B4l36IhGsVY3UFWWYp9yGebr6XrealbSlC9/ON4GPb62AdaWMRN?=
 =?us-ascii?Q?+npwKM2alAEBGjn4aT0/kNQaASd3z7/N+xgknuNwBzpwTn4JV10nsWWqzo2d?=
 =?us-ascii?Q?SpXoxf4gP/IWqZObsfZ1B6e4BrkSWO8bkCecAuKwkI6Jduqt0TX+Oe7aMTWb?=
 =?us-ascii?Q?NoY+G+llBMZrfxkjTeQHgX1r?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9069278-ce64-413c-7d31-08d8cc44419a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:40.5899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eioS9w52HoSpF7INOtb20ZoqR59UhtYlVnNeVyqTow9C/vtd5G4BN70pRzuLbPzNragtmdheCOa1+qmwj+gDJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fwnode_mdiobus_register() internally takes care of both DT
and ACPI cases to register mdiobus. Replace existing
of_mdiobus_register() with fwnode_mdiobus_register().

Note: For both ACPI and DT cases, endianness of MDIO controller
need to be specified using "little-endian" property.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4:
- Cleanup xgmac_mdio_probe()

Changes in v3:
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..dca5305e7185 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
  *
  * Authors: Andy Fleming <afleming@freescale.com>
  *          Timur Tabi <timur@freescale.com>
@@ -243,10 +244,9 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct mii_bus *bus;
-	struct resource *res;
 	struct mdio_fsl_priv *priv;
+	struct resource *res;
+	struct mii_bus *bus;
 	int ret;
 
 	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
@@ -279,13 +279,16 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 * needs to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = of_mdiobus_register(bus, np);
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

