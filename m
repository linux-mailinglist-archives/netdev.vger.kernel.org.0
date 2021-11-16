Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE6D452AFC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhKPGeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:34:24 -0500
Received: from mail-bn8nam12on2126.outbound.protection.outlook.com ([40.107.237.126]:16577
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231403AbhKPGay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:30:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2JMltiGIfKvYn/Lax7jq8NkG082wYWWv2lpYPNY+0bRiJqBtkBrAQp6pfYtOmBYAfrH7AgDqTdeSoCUffmMVga0N+0Ws++o9dOKhElCtXngv2dnwZv79IlZ7Ynb6xaZ9OpqEBfs863rY65yPvQvwCyBrP0FJO+RfL5N9rHcUBDZpYxHuquVFYdaJSzpu6X+Kwwnk9KtD0S+/v7f+x5awZ4+F+STOjji1Ov0i8WzhrAxFt2gnMT0Onn6CZTVs+MIrrHdNW04+68MhlePsysviaNjpoNM0D4XEhYFhI9dQW7YlrL9OWuA223qGgGtUPEwCt6dTB6OeU3h9whMAYW1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hk/1te5bwIfVZGRAaBZDCvRJcfC9N2Fnv2yUaDDDN2o=;
 b=HbrE2YcYjxV40B1NLh1Y8WkCxVT3RiborNdFg/Uk9btcKITL/Uqt7BO4lYSvgtL1nOzZ3GLUGEj0rf7/g/w+6OdWcjK7R9CBRvDAOXUb4AFPQHAwSeyG3jBvs4u5SLXK3MCMZ3HCI8pvPCP4QcOr+q14Xpc9wyQmcC46XXsC6GNWFXCu0lcmVjWNmAx75Z1FON+eH23Q6qii+EQPUS7KHulJnaq46w4T3L36ikOvjTzN0h2SzHHCeh4hWn0wKuWRAZe+aG0OxIOV0JbaqbJ8fMNlR/HO5vvbhlcOetb/eNcLwqK7ZLt9g0qv+mTgdYPhliinrjgCS8yEBZHE/qtMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk/1te5bwIfVZGRAaBZDCvRJcfC9N2Fnv2yUaDDDN2o=;
 b=iZqcoF4rgwxb37c10DgeGJeLizSujOnimbPOwNKL6QvSxf0qcfEuN8h5eSIuYl2wNPa3jp3Y7LR0slu/7GJtmIb6d4fmvui1ygCZtcU6aCr9h/Fhdbxw/bcaQL3HlKkVk4hCOSqsl42ck5eftuaRTTu83tuazzd86bNNjtCyjj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:58 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 20/23] net: dsa: seville: name change for clarity from pcs to mdio_device
Date:   Mon, 15 Nov 2021 22:23:25 -0800
Message-Id: <20211116062328.1949151-21-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aab933a-0d40-48bf-32f4-08d9a8c9ac26
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB472225A38B52CB8AA1440966A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZcSiyk8xt//c/Q25zDl9gQCtslJbPqYfkyogF8XQvZ82SUjO/kn/G2wZ3JgAhW1bkNQBNOgkKcRy0gTFDUpFHoHYpP+lVOSoU0FOk/JT+Z6045B6gN1HlSQIFtkJ/VhDPKtJ0LvIcq9W4hA2Eoa3kqn5KzerA7csvDBSCPKJ6VkXKYovnDSYzthVr13cUc7Y58PX36nFuopzOchogzseDUpBpte3/hsyo01MPYILAwSmiYTN/dLIK3ZUWS1eX46o4lef861fSlEmO5QA2JydQ5tniHHn9MMGSmAa+Ns4XTZUWTaDKyrJzCrVZbzD+YM/ZUU3yCI5mieEg3sz19wRPVUf4G5N4sqWyjeCF32pzDSfpwpQqlH4SMdKz7txBFuNBO6L2MM+BoxwYk+3fNSupc8u6lvahn7HgHkwx8/EihiG8M8hqL4EwbXLl7Mbg1ceMT/UyRL+Xy4JnIvG5c3RYPtEpxZfqGvEBmjUWv3fUUeL/PBRRT7SZNwRAb5AL9ueCcg0q5J9PLsv2K52qZ/xQuYwD91701m2dNquWcKoWitLJC8mym0ByqJ6mcFa8DbZtQM/7t8IqR7iFwRY9injkZRAItXKcQ/Hj9ITmubQCqO3EXsZWRbKJwkQ9bbidQoQUho9cXdGHUrPWSipGNYf0v4HWGnC8sIf8rIEh/pFws4GmFT8Evqv2P17rq4xKxcL8GybpkJ/DsxcUTlvxKfVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?81e9cmtjHtAuNGAXpLBa6XC0HiB0j8udeODJ23X2dyWcn6sGBP4/drh0UphW?=
 =?us-ascii?Q?WNWOMLz8ct8wYz8N0cUXdNGwF5dDKfVzy9ta08+8dHjx368iSJ9VmXzr/v4z?=
 =?us-ascii?Q?S4DhuLXgGMZfjEh2W45FCgnSWVX2BREAcAZ5kosE8uZi6rdqchEt2GdYbhMG?=
 =?us-ascii?Q?FVJZYnFbJ4xv/FBYDXPDDAnhgp1LR0wqSh+cNEOIunhcOjOOYLjzPN1psk5l?=
 =?us-ascii?Q?RcfsGd519X7qR5WnwqPJfMhHOnofwZ7mt5wNo34Y8fWYJOYjpmDO0q88WqLN?=
 =?us-ascii?Q?VmtGh4byP8TQ1X1dFVc2dV+65CFWKwQtxS4MCryAmM5o+mHcUDdVaCNPwIPW?=
 =?us-ascii?Q?x5l7zve3/1jfi3iqCr8NomzkB4USxoopcnZRRBi5LX+BdGUc+fa9EIt05LNU?=
 =?us-ascii?Q?l4SnyC9QzEviO0qFZbFZQot+NPJC1DcowzbOY9BhxFPchQy7JFduygLZ7JQz?=
 =?us-ascii?Q?OkUeVV3fCAdYgtN/ed6WxlKrHG9Zk3Rh6Sfe09umQZXFxBvFnDo4oyHpS3M6?=
 =?us-ascii?Q?WoNe5wTrYYvD7hAXyPB2g5Zwg6j2htRt+aJVxju3W1tnOLyp76lTq2SVzCAt?=
 =?us-ascii?Q?j02Ts4xo1w3KEpW8DsNha6y5JnoR++NwYlHoa2iBTPbRDB0gd/xUcP4Ahw9h?=
 =?us-ascii?Q?t1mV0/iPOfaZ8M1ueN8B0DT7HW6zF1daJP+M3WFaMLJsTbj44FwGP/UqYNwp?=
 =?us-ascii?Q?vxthM1vzMNTKVfSye4YNVvy9aQIhVTSLeLcRpZsbFrg+GYQ7clBr22Ql0gTj?=
 =?us-ascii?Q?xWR14NTiF/tWrcZVWSzZnbhMj61O728B9BvKYxi6aoABVf4PatSn6ifzZgqv?=
 =?us-ascii?Q?pdZIMysbnObuXjO5Jpyklyna38mNpJEGO4q8y/nKZXEQiX7YAQj3oIZtuu0p?=
 =?us-ascii?Q?muU/k+PoPP2wbVqdRzGCbiUYwu4jotA0IRzGTtukCcVeUduj1noxH6SXyY7O?=
 =?us-ascii?Q?/hzJdyCENeZrBpMg7KUqoGpq1l4i+VVHmpvdtn/FMe/GeMtGcWNc6Mt7xU4a?=
 =?us-ascii?Q?UB2+sbnfP7Ok07rR9qIYWEKHZDI0FUDHi6iMf+jfBNbpTG5lprvzLoA5Z2kJ?=
 =?us-ascii?Q?YphBJyM/RoDEmngafLvTmc439EujkUgTXbV+k2rz7qjXAvwthYB33a7dG/cH?=
 =?us-ascii?Q?wzkeRIVA7DKbwdRWHGUlYeDyK1ZFlJwEUrlViP9BoazwwgDDYQEgkY1Kgg36?=
 =?us-ascii?Q?RygD2zgF7vRBAAK+ULAk/XHetJacMjlosmE/yUCPdf9l5F5A9B7M8OPYCft0?=
 =?us-ascii?Q?+APuEmrUOR/pKX/3FJtT6uZ2WTsxV0PYVNsdoXPY+LHg7ESw2Dwbq5J4bf0f?=
 =?us-ascii?Q?p7dHKdPHhRGpXQ2R0bLzYf59FgiMdgeRHkeJrZnGf7mqVMchG6GSTP8UBZk4?=
 =?us-ascii?Q?Hh1M/qnzILzuIAqW2xAm2qy6ogS+LV6rAgrA3gSKmRwjd2KP6bv+lVnAjXTi?=
 =?us-ascii?Q?J3HIwGMsxnYTuEH8KmIe8ySe8uArnvYPgcRCgit13YEzg+SIsW4wegSh/rVe?=
 =?us-ascii?Q?QukftFIV0njTtz9ua6cYff6oLqULrePMSYFCBOHWyBck+zYUo6aW6O1Uuh9b?=
 =?us-ascii?Q?y9a/sTqrlJbTreNo6JdlTut7G6Xh1rERHIlVzM4Tpsm3xelnApRk9s4N8xOE?=
 =?us-ascii?Q?IfcPCa7/vbp+/utXZuyizyvZXOU4caWCnyVCAvXufJMtXBybbFLlNerfrs9W?=
 =?us-ascii?Q?psQbidVS45U4+k6rC9XlNDZwG+U=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aab933a-0d40-48bf-32f4-08d9a8c9ac26
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:58.1342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fk78c0TOqDFzSKNc58uea4JUxxDx82ESl4Mt+PHJTPPUFAPlXRztXK08P90LekX+SENh5yFYSj1cCAgvp0PyJKwTUS7vmt9iU4Si8eN5Pq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple variable update from "pcs" to "mdio_device" for the mdio device
will make things a little cleaner.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 49fc8220d636..268c09042824 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1027,7 +1027,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *pcs;
+		struct mdio_device *mdio_device;
 		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
@@ -1036,13 +1036,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		pcs = mdio_device_create(felix->imdio, addr);
+		mdio_device = mdio_device_create(felix->imdio, addr);
 		if (IS_ERR(pcs))
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

