Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B7B4686F9
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385441AbhLDSZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:25:15 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:6433
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1385425AbhLDSZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:25:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4tSQkbQtemZ3x6ergNjnaX8fZEhzuoiLx20QsOtuIvgncbfVLDXW3qpSdyoEDg2cPZ3M0hgyJ44TRK/uiBdlKSITXagnQTtGSqCls7QPtUy+JjdezAgSQJCriHRJ4bJzg9cZWKK7i0SG4YWZ23mp5kjg2j9Y/hC4q9yvoHIDxRsJlLIlTDnf42AG9tB/iZ4a6PBbZKc1ReNuqcfo4wqBApl2b3crPIwT8VuwqaEi2ubmwwrTuuc6Z1vfRsxzw669FhnNzpfgRL9uCBU6JwfdrpcXX+yShhQNUKL713ClprOI7hyxSIfRCQoVyqzaMoEV3iIx6DZmXc9K374+kqZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=th9ScbWDPw/DaWCBSLNCbdjKbC/QjWgQfEV1eslwZSk=;
 b=RlXPJ62sAzIahkyxtu76CzNZKVt0ZgfMCgGjinTtBOmRZLfMaX32MF6EZTldt32bkjWFaM7hYVdC//x0l1vl7jo/0r6x5v7G7I76OZ+MSSrelCAXFFuquuGqju1LI2xkMTwQ1B9V5Rvyq8JO6J0Ky3p/Ny30ljrfcSsLK5WnJOrPpqfni1QIDrpVROWkGDLpQgHr0yZfDWak2KXnK1J3+q4sJGs0pvfyp++ffEIez8xkErSnukvP22sJhbgwXF1v8h5iANUQ/3UfPEbS2wPx6OqqK+4oqvFNA6GjBQdO7y/6jEmjtosHmGsUW8O0exAsUh7MlbCLuINuKwN+/jURfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th9ScbWDPw/DaWCBSLNCbdjKbC/QjWgQfEV1eslwZSk=;
 b=DGlfF5obnQCVPPxIuATjBqLqSEaAAvYoHnX+W8t/EYYZ5ruoEmqtU7sTSr+S1ZR2tDJkM5L1NFDLqNd9KnN8iYwjhjuMoRYjGIr9Jj1jI9B1lNDBDAHFrs7bMJQCMGFJbZ3LwGwwTGNf1k7iqvbTDwc+uV77RA7SejwHDA2S1Z4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:21:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:21:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 net-next 3/5] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Sat,  4 Dec 2021 10:21:27 -0800
Message-Id: <20211204182129.1044899-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182129.1044899-1-colin.foster@in-advantage.com>
References: <20211204182129.1044899-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 18:21:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13b0c747-4380-4a8f-9a0a-08d9b752ebee
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2061194A8DBA59C5ED9738CCA46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grBYpwQAN9FTepq2VGngMCEdaw7DBSOKjA78PbOMNUdW0Z2G1nDaZZK6RZJPdAypntjXFtH2+wxE4mCCwKRRWJNG3WtfBJBQ6usRbQ3FmVxjGd1Q/Y1Z7XzRkogMWBwl1hiEoV+m75oKYbV+xT7vvhKxh0cxy1SKRKBrJ0yGZrvqnnUUgwD+NSp8WWTlLC0hkxIT/fAzk6PMKUfsMqLJRjU3RkGjW6JiUHvy9TsKXJHlhftag6vs1B4Ri3o1NitqBVAF4jUbTIaQsZuNVWAWEt3a9V+034FO0oq3GXUPnX7JFbuWC1aT/qhs8FtBugKqLOqR5QzhJ9FR2tFYzoKNOXfrNkm5iLbcZsDrITj6wDipRilGiSpDdVvoCo6H2xjVPnKPWZyj3Wd7KBzBztiRPgFM/Gl/a0j1p6541qC3QAI7oKAxfmEv9a4mQ+k8l2epn9EAg1QluAvC8W4o2r1d8U5wd7W+s5Si0iQsxI/HRzzDKafmz/hzJW/unFmLyl/5y/Ar/zQBPsPQ5Lcn+SiRE09VTtPhq+lj/T0766VPcgp4Yb3HHc/Z5AtIUZHo84WTOMhvyrQcRIPTZeuqNO60cxHlYCtLTNZPQr7n+bCrykveiGXXQTl8SZLJIPJCX419cyDkWm3vFfEz+WrpOV7XHvddci+/mNQwjb/KMSUjLAK4sbrjfcHh3RJlReKiknDjWw4hFJTcUODon+6akA0irg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(54906003)(52116002)(7416002)(6486002)(2906002)(6506007)(36756003)(66556008)(8676002)(26005)(186003)(66476007)(316002)(8936002)(83380400001)(2616005)(86362001)(6666004)(5660300002)(66946007)(956004)(38100700002)(4326008)(38350700002)(44832011)(508600001)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UcOE23CypcdaZUJ/1SafIMB+dlmANjWOe+vk5Xiy/7wStX6T0qGAXM6KVkZV?=
 =?us-ascii?Q?TGJ0/ffjEYwGGXtt5WGwRHGSB6vODWFpd6S2pOL4TbLE097nSBzqaRLvO4id?=
 =?us-ascii?Q?oQcj9/f7jcePG6zDcUsbhsRrV7JmmkCGJKp/KxtKFPYilKLpAcZFuAevojdV?=
 =?us-ascii?Q?zBnd57DfUAKtFfH8EptKW75j+Wkkl/B0oS8Y06iO2efX8vrsmG4EFHT5v3Wv?=
 =?us-ascii?Q?yx36Ege3O0HgSFVtIv1rUXKYEs6uk8lLu+yfAcJMoLWRY+0e06yZFjAkc+oB?=
 =?us-ascii?Q?gTiBdyoiAAhbf6rM6ht89HgUxck/40ipS8EFizLI25hq4rXFqKzhPm+JpE9P?=
 =?us-ascii?Q?bylJ6XiiQBjpuAwicO4H0e82K3Ho1j83wuevH4QlmRFrmAZpGyjHTBXppTH5?=
 =?us-ascii?Q?KnxQROL4Xq4kkZRDV3vb17Mqax75DojPHccnueKtwuOgrCavsrwt7BYS4Upk?=
 =?us-ascii?Q?KMWnf+OLFPkXDZhy0wgq2t+1hU/woGb/JLLlwPh+zEVG7pf6kec3D/lI78yx?=
 =?us-ascii?Q?NGBNVeHMbbxuUX9ubzBaeqDvJ17CdjVNZj0exLmqR5ta1q7rH7pux+X4xZSU?=
 =?us-ascii?Q?QMHAj7ff3lflVKJUbxlifTYH6wZ/NS0v+CgBJKp8MC1mw1uG5DumBP/VkLSG?=
 =?us-ascii?Q?1MRN8hZ0bzu1xTpnVwRpVHZ4O+JIiMoodQ+2s+Qpr7cCllrFCrJtm7NMKtFM?=
 =?us-ascii?Q?hQoeClgT+dtPWEzd3cMtK2u4IP4iOEjUdNC5/MP1bdzj8829dnsYztunbh/L?=
 =?us-ascii?Q?uX5UKz2Tw6X5bEAjxvgxobuHtDqSEvThJv2z0h0uqjRqDXMofeJWZSJPxXY2?=
 =?us-ascii?Q?VwDG+I3+VomP1uzMA3SKgEUMD0gU3VkAMvCz/nIWb0QTPETLNddhNSzUa1SI?=
 =?us-ascii?Q?ltBbRMyfVb93FXL0nCQ3Iet681mw2fMpDJIjMoLyFEi7RGFe6NoTKSBbgWTV?=
 =?us-ascii?Q?ZJHWJ2rDNq8eaw1ORmrGQIJX26UPQxBcEIODbIYLto7f43wOxA7yYO5VqlON?=
 =?us-ascii?Q?C1Ci2azArRwAdBTlEhWjNv1EsB9mV11AbRzdEuiIa75QPv86B6u+lSXRlN8A?=
 =?us-ascii?Q?5csVAKZwVL8y4rmwYxtoLBbp7mzuxAlfNmZ4mRl80xv60MOEgpuSIE0f54Ik?=
 =?us-ascii?Q?B+tYN3JuubcFEuUE/FYm04Lka/4AwkvdoGQ9SXlERcELkhtBfLu2RmkZjUTJ?=
 =?us-ascii?Q?RUkXfm8tyXKg/nQ1p2RpAcg6SMvvaNBAKJN3WKriedqkwTpQjDMBQUeb3sem?=
 =?us-ascii?Q?aW+X1DqFPIWjQKAbIQABrlS+fDSpQToTUcICQFip6X1BwrJg0xJ5KXnvBERu?=
 =?us-ascii?Q?jHLeRE3dyNtRAiv1S9qzmjrm2lO2sorku1uSVCvJ+ImM9yQL+4Yx96tFoYL5?=
 =?us-ascii?Q?rRV9lulwhCXpDa6JvUKALy/QFKXhkRmEB8bfRO7jSwFm7o2c/tgI5hf4wSei?=
 =?us-ascii?Q?q62tw0WWL7QLaZEEt9b7TTG+eLAm7z9nJtXB6RFRC73NUDRFUw4NJ5qvPy59?=
 =?us-ascii?Q?5cb1cuCLN/KkNVmlP0jhTErtpwlNdq55rqhVqnNoJCobqSKpVIDUnIu/XP9E?=
 =?us-ascii?Q?phJS6A9ZEWHcNC7CUSOOJjE71AVjD/hZHv1NC+w36jYJ2Ez0iJtVPfIAqEcN?=
 =?us-ascii?Q?2c6dvfgQrvNOjkHTLRzJvUEp9alQPtHYQFvmSOreXE5X1yrWK0O8I8p7FuBg?=
 =?us-ascii?Q?eRDn2Jp9MOs8I0tLhToApr6AA5M=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b0c747-4380-4a8f-9a0a-08d9b752ebee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:21:42.4659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UlQ6hqa7xB1SNtb4+dqxevqP814rFyVWAtXiDWHtn3bTvlv3sXMi/qQjCRYKS+T80WM8/YFYy6L7Q9wnL9ocgMjVQulSv6J/Edu226b3oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4ead3ebe947b..57beab3d3ff3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1028,7 +1028,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1065,7 +1065,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 183dbf832db9..515bddc012c0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -50,6 +50,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 0676e204c804..74c5c8cd664a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2240,6 +2240,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b9be889016ce..e110550e3507 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1104,6 +1104,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1

