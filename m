Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B1B479DC2
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhLRVuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:25 -0500
Received: from mail-mw2nam10on2118.outbound.protection.outlook.com ([40.107.94.118]:19424
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234587AbhLRVuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ztey6i6A+sGBCT1rUM5FCYjdX1XYWavKmUNBpruoa3soCEoz+ptzgdlWb+QgsB+m6Se+ohYdEDkfMdOVKtKDz4zb7TxuJ+kg5IMbG1x0T5390uFCstUgEITezefAr1EN73UiNADN4gus2D6JZgBjeauOb1jd0rxAaTw8imA6Zdwb48gly06JTaVxFlqpmA8L+ULEe4iKpVckRG0AkW8J/zysvOJzt3IcVlbYPgrVy4FuHJNtxEsxhcpfMFFnQ0DpqK+uNp0K/fy7hUd4LPlovOEgJkSFFVU+LtBR0QKbBQifm8E9JZWZ6qqQeW2uLIoIbzzFWTcIxJQCdIWNpFemEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+rLDXGxLvtuOdamBqUJt6dGCQ4/RX/3E87jruiMwKU=;
 b=WlxGdEfHNA3/G/IidEw2gcr/jZu9dk9TKjinhEOd5OfWEFmS0kF3xkjBmDJ5l8TslRk1q2BLcFhHZsE1G6iajfjEdZKtCFm6pbbxzfj8ItiKnrY4GJcuG3YVPdBAw2AvaJK/VjUwWKf1/MtKk0wFMifLiegvr/Brlpy260NwxM+AuIuZ9a0cJBHKgqOydCfo/q8uUOuteRw7x/13gJoHLCHqz4fygFcHV059GQNyL2P9i2yP0eYzhYZn4+W6P0AMsjk2puHPVvZQG0XN+PfEvoWQVyPWZtwmD3hsOFQWUSfH9MGzFUIUUyB8Y1n/yt2zcUWbgDzKtpyzuHD0fpTUdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+rLDXGxLvtuOdamBqUJt6dGCQ4/RX/3E87jruiMwKU=;
 b=BnUeA+GL6EVIg1TAJghEyheC9h7oWlv4pzN+BDjfyGu21tGJa4H0Kaq73uK5tZq0e9aGHuZBn7gG99nk6V1Xyz+yRvBC4wwv6LrpTpqtRGVbQgphELUIw+03kQ8yR32goLibth7W4slsMeJIIxJ8GN1d/2o8yxY2RWyWOwZHYAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:12 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 08/13] mfd: add interface to check whether a device is mfd
Date:   Sat, 18 Dec 2021 13:49:49 -0800
Message-Id: <20211218214954.109755-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e9a4c9f-e7c9-49e8-6904-08d9c2705dff
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633E6DD31983737A0CC0511A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wI7owGYTJqa64Kaeb5GCxh/VWRdXQWGnvOABRfhX6WEhwVDOQiBU/zYtX8cl3R+AvCoNyeHLhMfIYYSR2iuhbtV+SU3nxA7S2t/axqDWw6rV2EnxZ1JajwZjpi9+6wryvP+dpOMe6lvgbH8MrVX1rC+SxpOPhIdL1OM8Ogzj/NiN78oA3er/Z1yKkOw3BhaTWAhO4LdrNc77Qu1nTKLARKZC8tcvp+6+IuLljIx6Xz3o6qtdS0SPvk8Em+JTOEoNPw45rnlyerKZrns0pdd6md2AVa1SwMguRY4l3cHOPCZmNxRHkiNey10I11REoRaHCk4MgLDCKxvJ1L4zVU55T3IQr6BWWjfzzKM3MPQuqPLS75ubBECmfQJkLwpNjkrbVUqi4a22virhd28bKjhomlSV0W2yoXXPO5rIHcmUs7GgkqFqGpfrmqPiOMwT213ToXD84C58F+fi44Di3tIQeLw6PcThM6JREnFSNGEZYKFkedc2tzgH1z5nszHvg8cC0jhV/14mxCmsnulJB0mXkkavVLotLabzUM8Y3b/G9WNO27DKRQ1IvopJ/QwXW04LIGZrwMHajbQop8+2IrWtoGwVgcsHDwUVxvPNoOXiTHFabSv9Fh3kQgtZoHtcoHiskL00F9HPboiPBj7evYCUsX6nX8saNpnDPHG0TolDOWKYC1Bai7a2sH5rdN2om+oTLxjFMG+SMlZnCI9vNdjllw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ATJvwAhJxN//bWL3FjnolGwvgbyzp+b6MDC/gcLWu4VvKB76DX5SJ9k/q318?=
 =?us-ascii?Q?gqjurlVpq6HSV+Yzo8pZuVbMj2xd3kWygdzAUqcuBRxP3/rYHXc4eiQ3L9fl?=
 =?us-ascii?Q?alKEAnDqsFFMCUh40HLMv9zJhyKzCwLvLcq3vExhsva7waUNq7TjIzKb8b14?=
 =?us-ascii?Q?ygZiwLw7T/Vk95LidaX+mN03rFssirtFyH/FwpfYcYnpY4+3EpQ7MEhxB98l?=
 =?us-ascii?Q?HwqHIkPrM1AFWBT25eXc4owwzry4Ou0M8nW0C7nxRD9c3oDeAu/U0o2O9WSl?=
 =?us-ascii?Q?RlleVfnBkzUW/hJJbNEEBFXqcHZxdYacRZ3HXDB0mB2XFlW7UcatojCiacG1?=
 =?us-ascii?Q?I48uBP5RMAmt5vtqNApmq+Cs7JAoPWKjgHIYprpxZQ19dBPyNNC+7xSR1f53?=
 =?us-ascii?Q?+U7mWoqJ2rswkBy6Ssr91J+vTBxTEtEXuUoZ7Th7FXY882+oowva1XP7xuLn?=
 =?us-ascii?Q?OpspfYNlN4OLGKDflMJXObwgbbmjk5WdKcbLj3YP7xztvXJiOe9YYf+C4aSb?=
 =?us-ascii?Q?BP3Qvr2WvvUEzh3eQs3DVqS7vULsi+FbbDQ3AmwX2Ua2Qc3ZNQ4fBAdMcqz1?=
 =?us-ascii?Q?95S2JhZiqmhKPQS5AlZpxBbUGz97RLamY6UmT5qW52ywR6hBPsK/1weQaTqi?=
 =?us-ascii?Q?C5BKP07SptylJJEn+W1Rv9KVEfzu3MuZSr1X6K6f5rMh0l/PaLohjDM3Kc+a?=
 =?us-ascii?Q?bG36SyRsM5nrmci6FKRkKGKxHh2TROQAiQ8gr6kxUKKBqbV72ASaSTYtwaKL?=
 =?us-ascii?Q?UUomu9Nj4kLx6gHv/gmEWGuIhndKHogpTNMLXThrzrIfcefP0OVGikACcHsJ?=
 =?us-ascii?Q?Gdl3UxE5i8/arwVc0O6Jw4WOJXIPy3attFc03NsN7dBhfE7s2rCf5SQ8hZ5l?=
 =?us-ascii?Q?+Wsdw07z7uk6ZfJysvtShalEgUrBI73Qbop4fam/QHOLPSSZ5yJ1MDk113/q?=
 =?us-ascii?Q?qh9oDPg64ymHf4vZAMxxcItmsJK0dm6x716ZL8NAJ/0M3b+CyCSsTLhqw/Zk?=
 =?us-ascii?Q?ovN9WXGRIUoJVNBF7zSsFSOjNx+cHYhgS+hDmWJjQRecIV34FBeGKiIT1F92?=
 =?us-ascii?Q?DuN1xKWf0g2wKqxFerR924M0anaV8rO6JCje/QC4hDONzBa7mEIm4TOfkgRO?=
 =?us-ascii?Q?4eO085r5OWAJY3UNvu05m2yCb+hEDEQnVzUdPi9H3CM4MgU/L8yUwa/vQ1di?=
 =?us-ascii?Q?Uw83hhYrlwbs2mR6/coszVk3UPqVoNWrtQRrq372shYtj+fwdCV1iukGtHub?=
 =?us-ascii?Q?I/3xpipHdVSLVEvqU5PHoRYDRkmxSONZCPPOmkBWv2FRI1yX9MWucNmT6ldf?=
 =?us-ascii?Q?Rr7HvHUNkUO2fzhiia4rCs/mMKi8XJywKnuLa46J7G9nSj73nm+wExiMwyCz?=
 =?us-ascii?Q?yZ8cPMfFAs8jIWfnAMAye6hpRb/a44nKFbbnIVkch51VIQQVWeb3DRlMocQx?=
 =?us-ascii?Q?PqA0erX1mwnksXEyOYG0EoujVIjhkE1JrzG4j1jlTGCaXuIQWl0o5tHfLql5?=
 =?us-ascii?Q?lcC9n8XZWC6wd9IGRAE1E82YywNhv2CiebOxr8wp9HUDKYc0TthSFlZuSysO?=
 =?us-ascii?Q?V9K9K05t7M1xoyHrr+jIlQ6xpsrb5pIhNLvOL7Uwu6k/kk6kO5a2zJyXzwjY?=
 =?us-ascii?Q?9rE20wP++CysgQbfg1sqUm82sj2cPrES+4EtTxReHDTHZPs4GJ23eISgIe/1?=
 =?us-ascii?Q?F+H4seAxEXW8+0sz91Da20Lj+Mg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9a4c9f-e7c9-49e8-6904-08d9c2705dff
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:12.1437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWHdCZONncExQVMCp1PDpVu0Lxao1QgRO23LNuUBSv+FM1wYuNDqgWIBfDbKGtmwA/IhgVCRjdcWhSAGY+Sh8Nuh7LEXL/TcbG7/kXXP/pM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers will need to create regmaps differently based on whether they
are a child of an MFD or a standalone device. An example of this would be
if a regmap were directly memory-mapped or an external bus. In the
memory-mapped case a call to devm_regmap_init_mmio would return the correct
regmap. In the case of an MFD, the regmap would need to be requested from
the parent device.

This addition allows the driver to correctly reason about these scenarios.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/mfd-core.c   |  5 +++++
 include/linux/mfd/core.h | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 684a011a6396..905f508a31b4 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -33,6 +33,11 @@ static struct device_type mfd_dev_type = {
 	.name	= "mfd_device",
 };
 
+int device_is_mfd(struct platform_device *pdev)
+{
+	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
+}
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 0bc7cba798a3..c0719436b652 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -10,6 +10,7 @@
 #ifndef MFD_CORE_H
 #define MFD_CORE_H
 
+#include <generated/autoconf.h>
 #include <linux/platform_device.h>
 
 #define MFD_RES_SIZE(arr) (sizeof(arr) / sizeof(struct resource))
@@ -123,6 +124,15 @@ struct mfd_cell {
 	int			num_parent_supplies;
 };
 
+#ifdef CONFIG_MFD_CORE
+int device_is_mfd(struct platform_device *pdev);
+#else
+static inline int device_is_mfd(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 /*
  * Convenience functions for clients using shared cells.  Refcounting
  * happens automatically, with the cell's enable/disable callbacks
-- 
2.25.1

