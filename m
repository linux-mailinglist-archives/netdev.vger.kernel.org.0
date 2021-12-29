Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79171480FC4
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 06:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhL2FDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 00:03:46 -0500
Received: from mail-dm6nam08on2097.outbound.protection.outlook.com ([40.107.102.97]:64800
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229614AbhL2FDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 00:03:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIT5jtQGo0XwZBvhKlO1gCUl6V69aJJU5nAVf/9B3PnL8lrXPXQ1mPgG8p/BnqzpTt029cmDhJYxoCiNl12R5OLDSDeo7WEKDqyN5mNlxC+WGY3xLdqM/HMC2b53HL8qdkFD08HJgd7Bf4NeudFyWa+z899vaGHJtwfB+dIwoF3L6J1NkwGrpziQu3aIhAtpqNyfn9pm1rGGaeJT9u/udqV2SfP6wp+UEj4GtPsx+phZEvmZRlKnRvp2ImSrhdJVXoHqj/OLxepb50p0YshAdkr8R/FncRt3nQWqTJPB5koLYdEy/7W4FaHw55E3p332VWe9ude4xMU6wpuIOhbhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3I8bFq1RrC7DmRxtzSgqcEXpeZKTKWzDORpVAI5/KE=;
 b=hM9cbcsOYV0tccAVBmF1NnSAnXD0quVAqj1ReToz6frEyOIzsDvrsvnBZ11JRpk/1zG44UauNUiCz4aSOKFzrUL8BK6JPja8r8njvpcUk2B5pnRJXMcd+qtSE8UwFeYjoMhF3hA6i/ycDXl5G6d5hoX53yyftq8BmdG6lkBDUqqWNQwppVldy05dHmf7ZntUHweXRlveJuHtB/JvxWDiveVYDx/0K8fe4LF8TwzonS8izH4jsf2bAV9+mCp9xPZm+p5ybxGn1W1RFEBnDg/K/+FJGtgUKYPKDrIcUICfFih/v5sCmUnLLODSnQ0coQ5frGCb7fq2UG5NHugYIBgATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3I8bFq1RrC7DmRxtzSgqcEXpeZKTKWzDORpVAI5/KE=;
 b=cuNFhW/ljPMRJWMmhX/mrIKBOs1lCE0kQyEY+580Q1uigdpXOVdQ956/Elu4EUb1bp1DDMy1Nyh9CDsRfwwGKWXX4CpLZoZpYQRNwqY8b+kgPgBbCfLmjIw/J14i4I0uPW6p9NIqu8R03oDSb6xkK4kGrwEwv56ueKfh/NjQy+s=
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
Subject: [PATCH v2 net-next 1/5] net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
Date:   Tue, 28 Dec 2021 21:03:06 -0800
Message-Id: <20211229050310.1153868-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: a1f6fdce-98e3-480e-70cf-08d9ca889380
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB54416BBCBC3E27C41612B2D2A4449@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7bXXmKGkCLkq0saRuK1TBW/1NPnLKDK5teJa+tg3ZbV4mSlYcpbuRoLgafbJNZid6roE42kNBXDam1ceBy8hn3w0J3Nu/05uCafKmiU7hUc7G0QiqkfUvo//adND/ZqEDOu7HDLuvZ9ZM9pbMxN4NkdccJ/LgPX73vr/y6aSA6WQ15pJGnaYAoz4iEz8l3HL8HUPYoVCitZuy8nkw3k9fyWCouia1c8LcSq/GTW3NY2WGx599vFHFtOBRGuvLrzt8tUHAfCfu2yPZDvnhPLz58f43mkYmOyx6taoK0M07FhDmj7pzI/3vUaa1aseDKE9na1Tb3BnzCwNnlozpQjGpHH0q8F/uhA6DC5jMzh4CGuxUzHrVYA4lcJ2L7CtdLqAzvDmD3TctxNM5Bxyb/b9nc8wKuxi5oJ7id6pu8jvFRMTc7B4IHwPfXufuNpg8gFJj4Q4DBafiCPSsirIO0GytSkJVhkGWub0eSbrUXW7yTDQqSn+drvzSU0hbDo/bfhCeiQcnwRTK3G5vS2r3+clR4v6IVdXry3AZk7EZJ0+/BJM7JubQ1ZyNMpgkGiaBVPlx9sNDea087ZWR0jYHu5wfIk0b6fyqzjUB36omvUj1NasKUdf/KiwL7ff2VP7HwYEVCpZrilV4AhwhB2FipzoBDDIQ0yDl7WkLPW1Bo8XtrRMeakpAjFK8obdbo+7v6EJMkgyW0zkda+4excOcigDHgmcrqgIPyeyXrZokxOy4ko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(346002)(366004)(42606007)(38100700002)(316002)(1076003)(54906003)(6666004)(66556008)(66946007)(66476007)(2616005)(6506007)(6512007)(38350700002)(86362001)(52116002)(26005)(508600001)(36756003)(4326008)(8936002)(5660300002)(186003)(7416002)(6486002)(44832011)(8676002)(2906002)(30864003)(83380400001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+YGYlW3JLEXFLltRnAmuPE9N5Ho3Gt6Ju3djXxukYy3wR96J9o++VbuwWT88?=
 =?us-ascii?Q?7GcnWAozHW1VUIrqGtvOxKpwm/1Dsuc9dyTn/WLHtxnf/SmJgknR2YuYYtvE?=
 =?us-ascii?Q?GU3HZsKuMUKLxBBfwCS3ScLUv9ZVqsQCRIsqzyNJChoPeRcdcGz6abf81L1l?=
 =?us-ascii?Q?mX/nN3aZ1RdrlmDM6BEDLv/2MesGHv6VwmY2WOwpY/qnaP5oyShrzyXeGBC0?=
 =?us-ascii?Q?9F0zroIikVIm9LGcSjMMU5xagfTXTR7xRCz84mVPMKh9CVSJ/2Y3sriUU7J8?=
 =?us-ascii?Q?2uRzyClBD7DSLRTrKofOtwL1SOOmtNxzfQal2sHdgFEQUMA1JzuIxvppjF5W?=
 =?us-ascii?Q?UeeUo15lHtd0HYvZeBHm4JDLJiQFbYYbqObwXFbZlWxtBFVpmSiwHBDRzgtL?=
 =?us-ascii?Q?T0sKVdV19TRigT0u/eRCm77rFyi1KSxbvYSCFM1LicvWx4EeVktodjVFDjDb?=
 =?us-ascii?Q?zX58RhtE0sqEBKvyddBmSzd/3CAZfULX+0/QPKiLLR8o7SJA/VqLLOkvDu5n?=
 =?us-ascii?Q?DCK4vcd8gjcVfJKbTUpVLN3EfJKsB3Yba2a+F99VC6D2i6vleuY4T4FyYMkj?=
 =?us-ascii?Q?88+HIKNAifcg6Lzy3CyWwOUa1DnfygsPrSR+x9eg6ygZjTxnh3AFs+O70ofp?=
 =?us-ascii?Q?HdfZVQYj5cH8Y4HUAvGN766oUnvYguUzAcjl3bnOCpFKbxTP65bG/TcmdWJL?=
 =?us-ascii?Q?MbJCdb8F5lyh8zqCO6ua8VaniDAIr3BRUiARtb09yZpq4aWv5vwddzCGmjvh?=
 =?us-ascii?Q?owwuG6rOGOz3tkG/UobCfDQyW3b/cG7Mgd6KviSrknSo0ACqFI65SxW2413g?=
 =?us-ascii?Q?mvA5e4Ir4HwstW3u7hsX2fLBqs2ZXpYzSYeT/guhTW9iG/A8xbqW8iLTZ35J?=
 =?us-ascii?Q?/uWKCKX6JfLdEnwSvlJS8R3DJ16o7RpYnysvm11XjU3tvYunNj8xGGloNNXV?=
 =?us-ascii?Q?8MmY/RnAzRti+vo+WlXhl+209JHmnJRL7t80k+z9NzsJmgWuiapposN3cIS4?=
 =?us-ascii?Q?gTRc6nuE4FbVvE3XjaF8kL66Hm8pFnzsrVPRuQjup+mXMVsYuhQnObIsUyuB?=
 =?us-ascii?Q?3HTQI5IJYpop1IWLM9AwNxL5DA912MwLEH/jKlDRvwpA+ryI9DYmY2exq4Rg?=
 =?us-ascii?Q?4sYdmmsQW9XxPQiExhVGjvqdJ/bCWXtv6KMBNPwCNkC7GGQ9vmcMPVtRm0jf?=
 =?us-ascii?Q?MQlpyaF+71o3SczEQmrzPRJcDCU7rf6WpGFvMwQ2Lvp+Ryd/DXL1OGBXN7kb?=
 =?us-ascii?Q?3kgd+JfDM9aJHuWI/8/4TMajqEFrVDka1cWrgVgQT52sEh9QcnhDzuteawZb?=
 =?us-ascii?Q?7ir/UMgbLbGxXDVUc6CMzszq77x1jTzOUvzGJciJIqNMFKkb6aQGdErK8FaZ?=
 =?us-ascii?Q?8SUUG9/uBpgVPCjvaoC6YRTKXU3bZak0jiYcNqHmmbpj7sMPa64d8zWVVwxF?=
 =?us-ascii?Q?7b4rWQfJsu1PQtzCJc19klu6uFBHxFjYipxLcBYkMbHSIvmNwTVtM16EbUTF?=
 =?us-ascii?Q?F25c5+TG/zucVrhVHyHDCuopnBN+Vg5SqAfbWbyQY4NDhCTpuQog8kgEVMHA?=
 =?us-ascii?Q?tC+7G0+tuLLNmHxXPiWwBS5XHhGYQ5RwJjb2HXD5HvzzkCfNtHhyLyi8RswA?=
 =?us-ascii?Q?1PCV+wIJtoXRL51iUPVhS1G5aqVOSmTl+2FWfztNh6Ym9WcERAZUQa/0D/gU?=
 =?us-ascii?Q?BaNCGQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f6fdce-98e3-480e-70cf-08d9ca889380
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 05:03:39.0541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzgwSZuzN3LHA2olpreozv6NNooZtsJycfbBwLlCZdVgZ8DZM+RIx0WRN+bVNfKhgc2w8JOEWViSQ9gFEQ1F5oDUKI7kEroNw8X1VGLAnqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove references to lynx_pcs structures so drivers like the Felix DSA
can reference alternate PCS drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c                |  3 +--
 drivers/net/dsa/ocelot/felix.h                |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 20 +++++++++-------
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 22 +++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 13 ++++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 16 ++++++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  4 ++--
 drivers/net/pcs/pcs-lynx.c                    | 24 +++++++++++++++----
 include/linux/pcs-lynx.h                      |  9 +++----
 10 files changed, 69 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f4fc403fbc1e..bb2a43070ea8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -21,7 +21,6 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/of.h>
-#include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
@@ -832,7 +831,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (felix->pcs && felix->pcs[port])
-		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
+		phylink_set_pcs(dp->pl, felix->pcs[port]);
 }
 
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 515bddc012c0..9395ac119d33 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -62,7 +62,7 @@ struct felix {
 	const struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct lynx_pcs			**pcs;
+	struct phylink_pcs		**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4ffd303c64ea..93ad1d65e212 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1039,7 +1039,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct lynx_pcs *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1088,8 +1088,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct phylink_pcs *phylink_pcs;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1101,13 +1101,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (IS_ERR(pcs))
 			continue;
 
-		lynx = lynx_pcs_create(pcs);
-		if (!lynx) {
+		phylink_pcs = lynx_pcs_create(pcs);
+		if (!phylink_pcs) {
 			mdio_device_free(pcs);
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
 	}
@@ -1121,13 +1121,15 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *phylink_pcs = felix->pcs[port];
+		struct mdio_device *mdio_device;
 
-		if (!pcs)
+		if (!phylink_pcs)
 			continue;
 
-		mdio_device_free(pcs->mdio);
-		lynx_pcs_destroy(pcs);
+		mdio_device = lynx_get_mdio_device(phylink_pcs);
+		mdio_device_free(mdio_device);
+		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e110550e3507..d34d0f737c16 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1012,7 +1012,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct phy_device *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1039,9 +1039,9 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		int addr = port + 4;
+		struct phylink_pcs *phylink_pcs;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
+		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1053,13 +1053,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (IS_ERR(pcs))
 			continue;
 
-		lynx = lynx_pcs_create(pcs);
-		if (!lynx) {
+		phylink_pcs = lynx_pcs_create(pcs);
+		if (!phylink_pcs) {
 			mdio_device_free(pcs);
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
 	}
@@ -1073,13 +1073,15 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *phylink_pcs = felix->pcs[port];
+		struct mdio_device *mdio_device;
 
-		if (!pcs)
+		if (!phylink_pcs)
 			continue;
 
-		mdio_device_free(pcs->mdio);
-		lynx_pcs_destroy(pcs);
+		mdio_device = lynx_get_mdio_device(phylink_pcs);
+		mdio_device_free(mdio_device);
+		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 34b2a73c347f..7f509f427e3d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -2,6 +2,7 @@
 /* Copyright 2019 NXP */
 
 #include <linux/acpi.h>
+#include <linux/pcs-lynx.h>
 #include <linux/property.h>
 
 #include "dpaa2-eth.h"
@@ -204,11 +205,13 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
-	struct lynx_pcs *pcs = mac->pcs;
+	struct phylink_pcs *phylink_pcs = mac->pcs;
 
-	if (pcs) {
-		struct device *dev = &pcs->mdio->dev;
-		lynx_pcs_destroy(pcs);
+	if (phylink_pcs) {
+		struct mdio_device *mdio = lynx_get_mdio_device(phylink_pcs);
+		struct device *dev = &mdio->dev;
+
+		lynx_pcs_destroy(phylink_pcs);
 		put_device(dev);
 		mac->pcs = NULL;
 	}
@@ -292,7 +295,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink = phylink;
 
 	if (mac->pcs)
-		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
+		phylink_set_pcs(mac->phylink, mac->pcs);
 
 	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 7842cbb2207a..1331a8477fe4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -7,7 +7,6 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/phylink.h>
-#include <linux/pcs-lynx.h>
 
 #include "dpmac.h"
 #include "dpmac-cmd.h"
@@ -23,7 +22,7 @@ struct dpaa2_mac {
 	struct phylink *phylink;
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
-	struct lynx_pcs *pcs;
+	struct phylink_pcs *pcs;
 	struct fwnode_handle *fw_node;
 };
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index fe6a544f37f0..e36d2d2ba03d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -8,6 +8,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <linux/pcs-lynx.h>
 #include "enetc_ierb.h"
 #include "enetc_pf.h"
 
@@ -828,7 +829,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
-	struct lynx_pcs *pcs_lynx;
+	struct phylink_pcs *phylink_pcs;
 	struct mdio_device *pcs;
 	struct mii_bus *bus;
 	int err;
@@ -860,8 +861,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto unregister_mdiobus;
 	}
 
-	pcs_lynx = lynx_pcs_create(pcs);
-	if (!pcs_lynx) {
+	phylink_pcs = lynx_pcs_create(pcs);
+	if (!phylink_pcs) {
 		mdio_device_free(pcs);
 		err = -ENOMEM;
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
@@ -869,7 +870,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	}
 
 	pf->imdio = bus;
-	pf->pcs = pcs_lynx;
+	pf->pcs = phylink_pcs;
 
 	return 0;
 
@@ -882,8 +883,11 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
+	struct mdio_device *mdio_device;
+
 	if (pf->pcs) {
-		mdio_device_free(pf->pcs->mdio);
+		mdio_device = lynx_get_mdio_device(pf->pcs);
+		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(pf->pcs);
 	}
 	if (pf->imdio) {
@@ -941,7 +945,7 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 
 	priv = netdev_priv(pf->si->ndev);
 	if (pf->pcs)
-		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
+		phylink_set_pcs(priv->phylink, pf->pcs);
 }
 
 static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 263946c51e37..c26bd66e4597 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -2,7 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include "enetc.h"
-#include <linux/pcs-lynx.h>
+#include <linux/phylink.h>
 
 #define ENETC_PF_NUM_RINGS	8
 
@@ -46,7 +46,7 @@ struct enetc_pf {
 
 	struct mii_bus *mdio; /* saved for cleanup */
 	struct mii_bus *imdio;
-	struct lynx_pcs *pcs;
+	struct phylink_pcs *pcs;
 
 	phy_interface_t if_mode;
 	struct phylink_config phylink_config;
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index af36cd647bf5..7ff7f86ad430 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -22,6 +22,11 @@
 #define IF_MODE_SPEED_MSK		GENMASK(3, 2)
 #define IF_MODE_HALF_DUPLEX		BIT(4)
 
+struct lynx_pcs {
+	struct phylink_pcs pcs;
+	struct mdio_device *mdio;
+};
+
 enum sgmii_speed {
 	SGMII_SPEED_10		= 0,
 	SGMII_SPEED_100		= 1,
@@ -30,6 +35,15 @@ enum sgmii_speed {
 };
 
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
+#define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
+
+struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	return lynx->mdio;
+}
+EXPORT_SYMBOL(lynx_get_mdio_device);
 
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
@@ -329,7 +343,7 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
 	struct lynx_pcs *lynx_pcs;
 
@@ -341,13 +355,15 @@ struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
 	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
 	lynx_pcs->pcs.poll = true;
 
-	return lynx_pcs;
+	return lynx_to_phylink_pcs(lynx_pcs);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
-void lynx_pcs_destroy(struct lynx_pcs *pcs)
+void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
-	kfree(pcs);
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	kfree(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
 
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index a6440d6ebe95..5712cc2ce775 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,13 +9,10 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct lynx_pcs {
-	struct phylink_pcs pcs;
-	struct mdio_device *mdio;
-};
+struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
 
-struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio);
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 
-void lynx_pcs_destroy(struct lynx_pcs *pcs);
+void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
 #endif /* __LINUX_PCS_LYNX_H */
-- 
2.25.1

