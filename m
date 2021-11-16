Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD84452AF7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhKPGcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:32:51 -0500
Received: from mail-dm6nam10on2120.outbound.protection.outlook.com ([40.107.93.120]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232330AbhKPGaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:30:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axSjIDJ3DaGjg8oMOBsZaJIh0jLdswTcC/yk4nhOQ5FZV5KgIkk61G+B6bx9rUq3vuZGuwRI0SaA5vsy3chgXtymHjEIMV7aDJTyP8pzNgouJbMlWWOy9F8wmzFC07xFKDmhWl58FcbANPMar/yoYe6d8esI81REACPXt34z3cdoV9xXTgZYoTgum0eoyksJawNicOjxSkMWiq2HcgjPhCXKE1+LGqPGOxvB6JHgYhCKuQL1rKQ7rbKEfJYcll3NpVMJXLMN+g6mCPSzqki8XpCMZiJqHQdqUn6BFSqqWf+iicPDXkX9N/9cl5ybDHD67DBoVCJCA9KWNugKR170OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MASfe7TvjUIYSFDLzZzkW6bpOz75kuBqfzOsutzkVLs=;
 b=TopXzmeHAuMfsAveEoS/M0Dfhz8ScJKYcp6HaCT+Sh2PIsh0DQvZZujbyaPCmhpkOPZFy/Pd/HXCI16Pc6CkVb6yE//JC5sfjA64MhOVaIM/H8R9t9qZFG/cD4UnNJ5IxtiXwqyTRdG37rtUgSwvAIiSOSiDfRhzmCtvixSyF3U0CdHXwwL2fyoqTqj/rwuwgMRsje9jJ83hPcyVc7Lylm+DBHRZwLqeJW6iFQWyOj7KVitgzToH+eAXV7sGOsFv/Dyq1v5CUbsL/JXf6UBWo9ooneoVFsUecwFO2MGk54tgRjlSbNAHiXjx1UkeFbIn6OSt/U9RriNIMw7SmKSnKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MASfe7TvjUIYSFDLzZzkW6bpOz75kuBqfzOsutzkVLs=;
 b=nu9jiJnDKQbb4KoIKPelxx/gJ1At9/MHemCKdTIOU1MieY4/oyxMCO+A5uvCkNUBVxqJbl04dBOOPZCYfuC6JdqVosGWS9xnE3CoYju91WTVu6ZXION7FjgIxgvwpKdSrEh5JXEFdpWreLWWgEa3XnAAuAOoNcxBo5oCtH1gqXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:57 +0000
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
Subject: [RFC PATCH v4 net-next 19/23] net: dsa: felix: name change for clarity from pcs to mdio_device
Date:   Mon, 15 Nov 2021 22:23:24 -0800
Message-Id: <20211116062328.1949151-20-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f03fa9a-b466-4f14-2e59-08d9a8c9abae
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722E25D4F93D56683295C19A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFqtyBgF45fDDtE66jlrqbCbTosKQg0M6aJcHIBPVj2o3tfu4A6e8mzDUGUcaRpSJx4laeGNFz4tJ9d95BAwZ7/MXPXljHi9RVHc4WQZ4qXylO4XMHhUQzTsfBx7V5mF9nY3VM7RMrCcEgLUF8BsggV+o/C7YvbyAUCbdbZz8firkhIFwIb/A7rOzo/XSUDdZutahH9mHYFsyvkt3gqKKSPp9eyv2p9CjoyZjH54lHil98PTJbnauuJPkeBQ8DV72Hk23oSI5YYhSgxyPGz0eXLX4C9zuLoAl3uQ0qsyg/mRbNm44LDk1RXJbCC+QMwv3zMQ7UC9sDgAVugH9vaNFGs4Nv4KvfI1OPmXKYR6odQrdxK88IIDv/jELzcAU7QOUifBJkqtMEv5eEzTjVvQjMGXXGIWnjYEUBzRt9EVYQXFlpWIuJ10Ho4GYYDDnsC/UlmXZ8JaAfipOisMQL2I5cl400hbkPonLjNZfvP4bFJF/pQnMS10NvDvGT3pro8kmGq75nICAvywjPD6XxuSUNnlkl1N8Fo+3Id+cES9ItjeR9aLl3CrgZx7janDIlhyQbTO7d16d7cVthY5ltczB1wc5PYpIBHadGBo+ygkkhr/IKJTbWmPCYrhMAf6TMhR1rrrq4TECgnY4aSZlUoMXZdGgrjiogaDFdtw8a2Aea5JsdUDLM0vbx37jX5FpTUtZPt/MJNFnSDj3IVP83MhRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ppF2CY2SNMWjGx0kmi1mhpStuCbvIYDLgOgxV0XjHlBjf5wD4E7bFHMffLdY?=
 =?us-ascii?Q?1ulo7rkbm5EcI71FqCVAGJRLWDiY4m4GfrJ5vWjR4woWY7vJg75nUu0DjX34?=
 =?us-ascii?Q?GC2FckxPhld74aj4vfviVOc01GHLev8ploUEPmDOcUwxapZaVmHkCUZKozES?=
 =?us-ascii?Q?0ysaJX8JdYvGdvpfsVMAvr8fYQZ09ACuHQf7Ns+qE2PGv5fClnteZxCoBD/0?=
 =?us-ascii?Q?NxmCiCSy4gN3uPsjdYrzhmHabVTOKV3tYeT+S9YObVMIr+BJyrbypqV+//PD?=
 =?us-ascii?Q?KP0+m8gTNdpL8IP+k8nwJT5jFC1SZWupr2M1Ynq6hPmiP415ZHr0UVmIQXFZ?=
 =?us-ascii?Q?FVFPBMnSIrvN0hfKJKHfZOV9rnt6pVx/66Hf6TWIoVXKFUADTRF80TmkK6zq?=
 =?us-ascii?Q?iqrZJ3xwhfS2kYUF45yHfD+9sZrwICxDUNE/rj4fuM6BGG94fC3oRN2KCj6W?=
 =?us-ascii?Q?e0PLvHkACA7jn2CC/Si5Ubs2eSxfVDIEQE+S3NtSLthutxp9EFEHhrVZ7KKl?=
 =?us-ascii?Q?Rk8Bmj7di/9H3/2egicdEHdSYfVWkCv+hKoFWiDFV47S0u5jpBwzDY0Oy0AV?=
 =?us-ascii?Q?74iA2Gyx2+QDvjMk4IR7tbVq7PuPOKfEJUWTPj2qwkJY0+4xeS1pKeVconOM?=
 =?us-ascii?Q?P+emoYxDOnKPXA65nsWb283RQ1UXKEZ82MtlxfUyBRUJnz5IWEN8hwgdQPuN?=
 =?us-ascii?Q?WGZMY5PgcUOjKfl+2LWrp5EAvydAg2jvwgpO8Ra47gg/lsZVm0zqoxHeBLTe?=
 =?us-ascii?Q?XnQ52HBhPcELHyqLLFsGDFq0TAsHy/XYGb1VJ+ftG/JY+tHd3guyldJIN7Rj?=
 =?us-ascii?Q?SK8x3ODScRIXhBTmxCnY5MhEH7meaXwc+fcG0eALsWQxLVymtOYeB+52IaGa?=
 =?us-ascii?Q?AlCXFHv9L79/7nd8r1z9oWoVfNkv//IitwVVB+LNDkInBmb45iNpYv+6o1Ed?=
 =?us-ascii?Q?JsHRJLeqj6M4lEVF3SZc3BwUCyndEzuE6AfosErOg39ot9jaG78Hkji19xUt?=
 =?us-ascii?Q?S2Jej6S6YbCtfVJU8cuAM/C/6n17f5EJOhRAzxU0MDl2Rkpskr44kcq6A881?=
 =?us-ascii?Q?O0uHQoQqBNFyUqH4Vo5Y7Emj8+ptBMqH3y11PD0+r6ObHDP4L1UYoonN6SLb?=
 =?us-ascii?Q?LRneqpcvLdAM8hsWvV4ZP13F/2g3uxtnRD2HMfdfO9VwBJ4sBP01gSpECLA2?=
 =?us-ascii?Q?wQECrAg9cLK2LJyfbeMGAFWR/ok+34lzG+t/qPm4jnhaumnctVHoaDGkSNZg?=
 =?us-ascii?Q?5VqoRjJ/vk/F6+uNZw+kLGvAE1BJbSR/5JfFwCmejHnflTdOrs5b0qwgtALJ?=
 =?us-ascii?Q?6oqvR4kuJarr7jczrEi3iPlIgfQPdcm7lS1vS6uGWrjnnuqs3+hb/RI3zU0K?=
 =?us-ascii?Q?KnqQNnQWPOWjcJ5Lhbe6iP6q2WBGiFDC6in5gnfdurRmv5stahpsfZLMnTy+?=
 =?us-ascii?Q?qu723CVnsWDeEMM8v/xNmp6txHjTkonnfPxlccGXVLXrOFhD6Weh3FrsxuC8?=
 =?us-ascii?Q?dTVqKlJrvUVz+cv6nW3hlGCXL2kNFVlvgrrOQ+YAt7vQsypiS9Xns2LY0EmJ?=
 =?us-ascii?Q?3DMBrrwtvgvqEeiP5FWwd5NWxul0DsV8/Xlz8BTEUy98H7R6PfFfKw+V8ih0?=
 =?us-ascii?Q?eF6nHlzXEEOK1U0gLGnvzBgMdtJhNkG9iaC84R7lbltuU2KnMAFD2Z9kziiD?=
 =?us-ascii?Q?25MHeZnFzBEdqsHv08sXT5FlezA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f03fa9a-b466-4f14-2e59-08d9a8c9abae
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:57.3716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2LUvERDuLwKGYj9OrrNoAOnNa8OmiOIzJ9Z8BmLIs/KsjbG+Gze+A6semPv9vbaIZlSOhGt8mND0pJ2AJt7a+7E32temg2MCRGPDV8/XMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple rename of a variable to make things more logical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 636bfb096c66..b1032b7abaea 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1094,7 +1094,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *pcs;
+		struct mdio_device *mdio_device;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1102,13 +1102,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
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

