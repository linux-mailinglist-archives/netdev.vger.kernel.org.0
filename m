Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56D0480FC2
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 06:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhL2FDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 00:03:43 -0500
Received: from mail-dm6nam08on2097.outbound.protection.outlook.com ([40.107.102.97]:64800
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhL2FDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 00:03:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBQmtydxR2klij9HzC0SRdXfnk2O8vJ+XnaYPAfpI9yYbgibo8EA2EhIvr4ZuynRiU1YkxEJBObPv3NjR1pWd6zHso7DYYHJZLuPTgnQPeOF0LowRE0FE2YWheKgPsxsxXTJGLYk+33N8cKQbLJyukKVPDIYdszFESuVqsotQNJcYzgJRJ6lK2nd8V/GvthfYT0DLUaC4D6Q/NFN0iiKrzG/q/VX3+y9pczhiBHE6FBZA3yjI4g193/fsW6tKLyblsjxFrhx2kIzAWFcmOLbn7/lC2tlxrHjI03uBTLPnUjGRFYTNN11yAxuchHyJWAOAr+/xKi+Tg8033GgK5Yt9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaydjUIgrKi0bNJce1tml4C26FG0kOgN/Ew4lJlmzY4=;
 b=fXmsr+FUtJxHREaJULKBrza6YkGYSuZFU4/fTob9TG+Pu78K2wGYX2dfNqEFFQxicJ01mxgPdxVglX2VT+hwST7calA5oLlmW3F95NxNbgaLP2+/MAeBH24W2/XssLl0TQezQdW0wN62NEJteRF28DHbJt1bbaCivTh1SYvPRIMjl8wFeFFCZNmyohZrDpqeSvmWpAFzIU3vmfwv6vpmAo2gvqozsqe4cxq/OBSXnY/Zli68Vg7uysgA9ultSQKxyf9yECRZFPt4pNuqzJSW92zA8g7arSyChQgojb7rUBpEqPSRR9tVWtNqlI42nZEuzt0pcqo6kYgnQNcH9IsY0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaydjUIgrKi0bNJce1tml4C26FG0kOgN/Ew4lJlmzY4=;
 b=IZ3vOIa5FyIvzDs4QDHvHGNI10Bd9HyvWhSrZpzYoRmIdRbTpDfSL4nbxlvnyA9J3T7WMhqsW4oh4yvx4tNo6dJP7tU0nNT08VCQCoDU6+e5FosN/R9C+h+6vgfXb2ov3t5eqQS9QTqlHERCxh0D+7e20M91JczhXVrpEcy+d0U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 05:03:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 05:03:40 +0000
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
Subject: [PATCH v2 net-next 3/5] net: dsa: seville: name change for clarity from pcs to mdio_device
Date:   Tue, 28 Dec 2021 21:03:08 -0800
Message-Id: <20211229050310.1153868-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0de969d7-7b07-49d9-0287-08d9ca889438
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5441BD68B707328A51C374EDA4449@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: boUZaxuTBAk/NHt4sp6j+UM6ITCPGkOknhR/etQh1CkkDBfnbrixthsTlisEm5tCcNbyBrwTLvHRfHxirLNvXwuOJyz1xspZCe6MihVJ1NzppO3CQJYmv5iPAaXuIBUS+l88bT5trabUs6QXXKUo2ugXTZWiKTmFclPVaaiR7igrOT8W5EIDxG1k0Vel4gBRgedw6ETHm+MSz/kSYu+zG7EUhjlTD8N2r3snFOn6t1nKOkDKNHnngrl07k1CY0pl6/4jAfk81pH19fU/vZstXSX8tBPKpiJDEyTaGijATmuQL1S5TKJbGsYZeJm37NDu1MWkCEmMrtplb/9VYGmDMgcM/HXkCa2VxWZrtCScVWuSxcvQbGJgLCzDHBDojNyXWmsbmauB8YAPgtCy6ao49sSR/ZG4WkAeXnFBNoMLXiFCaCyr7OUq2BcGwubmbskfYIEu4/7e9lGY03tv0bMgiagSFD+/VBEdAJq02UKaA7aEB7pkEjl0I06mKTqMwfvo0Dycy7r2uXfmgXaRh+4XH3MF9M7mq01H+x+uqZTHet91N99Mn3qAYg1bsVMUeB9X1g13L7zAPMEV1KmwsA6ieoXqy4qBDuRdtUjKRVX1GIxo3Nt8sNZUuh7mSv2IWu5mEV+0vQdSN3FYdUatSkpCsGk3SYo9ucySIVvHhBJdqVHJyOdh6fkd5A83pXsNAJyKK31RxT1vUcfU/xTx9wcUlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(346002)(366004)(42606007)(38100700002)(316002)(1076003)(54906003)(6666004)(66556008)(66946007)(66476007)(2616005)(6506007)(6512007)(38350700002)(86362001)(52116002)(26005)(508600001)(36756003)(4326008)(8936002)(5660300002)(186003)(7416002)(6486002)(44832011)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y5p5y310h1lUeMDXYG6tYYoDWLT3c2q8qbsdvxjoH6P66Q9C+DK90DoyEKQq?=
 =?us-ascii?Q?Iva6PHp9MMPZzPsyQwjEeF1ieOLA1bNxIWIo+BVFHHwJ/jssTdiO5MUkBT3X?=
 =?us-ascii?Q?0VMt8JP1sWC2nXHqnE3DVFe6x6U0G/PRewiVa1vxfNoOykMeoE2xzLsrVEWY?=
 =?us-ascii?Q?HyNk/shrJwQ36NcdLTs1LUYHiUY4DyAbT76clolj67hzimEWr/AhwO2/W1yS?=
 =?us-ascii?Q?KiULb8Kl6/mPgxcUQGoiDIPiTzf/9p1To5XpvBSpgGYyEQOSPmXn6jzTjjF/?=
 =?us-ascii?Q?gk21Gn4N8283pXbnK5V1rJ8hBZv6nLrG6or1eEe2A6dPmCDE4MNsffQRsKV3?=
 =?us-ascii?Q?8t3CPB5rUG4pdC1lNAqJxklxWtgF69lHAdsTT9mSnJ/QKwNjSPppgrN8S+9y?=
 =?us-ascii?Q?BzcA6EH2WjKHlx76KTMRtJJ9VKm4SvvfccQ+V4raPKvHzWDfMFuQPmUgLFTJ?=
 =?us-ascii?Q?QLoHtzZRRzjPtHjQQU1UyKhfSd9wgtByE9be7lyqoIIWwju11OJFbWiU9XqH?=
 =?us-ascii?Q?fhWCYeYAVzzLWJf4vCd/aL84p410RkDMPl35MmIbVHpV4kqSnGDTHVTbpDx5?=
 =?us-ascii?Q?FbOtmcCfZY74XVdEJcRijd8xP9qqNs3fwQuQpOZh5MxkPWVN64J+ob4oKWCj?=
 =?us-ascii?Q?VuxwtBwMhjIpmZn5qKOr2s66iGHee+lQZeQgyJFw6qVeWVO/+kMQAMbjXwtZ?=
 =?us-ascii?Q?NEK0XCP+krkBECluLdPrSaT1T8KmckuwWiTt1PrJOekWHGBPsbkb/IxGAX1A?=
 =?us-ascii?Q?4RAZBXrDt4WTuElkSqaFDUJAM2CegTGNyVcfGqGYA9xPhMhxdlSfzZ9EDMkT?=
 =?us-ascii?Q?x0rWWAIZOvM0rSIHoZkgH4lT86H1O2syr28DdGfR1ygI1YgOhNpL/44tzQF7?=
 =?us-ascii?Q?zagmp9ZizEXMjnCZUcoMzXwuLr1ETR/KP9f1TAfs1uH1xt7zaRY2Qu6H4EGT?=
 =?us-ascii?Q?RP8t9ijQZD5T5w/+67CYmzEeI9s4anjnDtmYlin/HE/dQd6eZ2T0Hu3DmpQj?=
 =?us-ascii?Q?nmwC+Jday08vfObsltjFj2xK5V7fOSC8lE53VBWtIS3Xjduv16CndspnBBz9?=
 =?us-ascii?Q?PquNRCto4JG8aHFYXfBnyTZ+KYfTnZj8MiX0+L50YFekWzsmkV0G3Kdy1x47?=
 =?us-ascii?Q?zrejgcBOH9sYw87+Q+F+PL8X3586po4/bAmrF+mVXZZd31gGm9cS1A8yFd9U?=
 =?us-ascii?Q?4+XScTpJtmwD/cvhBwAGSZOK8KG6vLk7QlbNc4RplRI8r25/TcKCOQr4/nF3?=
 =?us-ascii?Q?HMKp5QXDiD6iYUZWeHueYZHS+E8s4TDww+5u5Lef/UjT5ja242jCjGtqA9A8?=
 =?us-ascii?Q?u/1jPm8WoBmKNDjKP2o2kL0uyGHLoLWsRkUsN5kUl/x0VK28D3PS7Y8UuQii?=
 =?us-ascii?Q?/kRi2zwxua6Er13CuS9VhLB8shjcWsaJebBkAGoBfndsetCpGP94PWx/N4YZ?=
 =?us-ascii?Q?bn71RGZXYbyp+Keu70bCkQvMN/8Qz/jtJqAVnFo86gVtRogfj3DGXQN2JZH5?=
 =?us-ascii?Q?bGNauubbUrFuWkQojuKMH+PBdAPFo0avv2/Eb/ieDgV8P8RkHDqMFzVaLDFg?=
 =?us-ascii?Q?jSp0cU7U6toLEMX0MU4RoBPUYOWs7MorwdC9xAJ2bXjboeAw4cMm9iCUYi0/?=
 =?us-ascii?Q?cR/rjOsV52HjfCQcp4f6P9zKobM8u8W7vwpNGuy7XNYWe4zbvEo3D+2eqQS+?=
 =?us-ascii?Q?Vnw/sHpIn76Kgelkf499ggi/fZ4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de969d7-7b07-49d9-0287-08d9ca889438
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 05:03:40.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ES9PLiwn84MaK3FYkQIACB1FOv9m+/+hrs2iQ0LQ1KSbp47qRtxN0px/dw4tbei+06FAZTlwoZBbWFddmyKdEKLnBVlWFfOGZFV+U9+7GEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
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

