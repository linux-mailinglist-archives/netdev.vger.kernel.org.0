Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB6939ECE9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFHDSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:18:13 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:6176
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230406AbhFHDSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:18:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBqs00FQZxL8xSF6PtG3eAq7bki08VYw0/OujAnrCEsxeDUd9K1e2M+xAEu6GNChC4yYVDS0GVYwcoZH0rTu0n2kaJ8gDZkiof0nmzUBmR2KTuFWPtIjj2b9aJ06v3p/D98Gchaq7Q/NH42AlpY8rGgIXir0/7Nc+WlEtWIlWjStuMavaMPlvc9mymFdFgPQtw6+Ibb72NqJliZg7nnvBbE7lFerC6CR3LWplY5kWmQTxrniXfZiM23yYpwoz6wY3YgoHEkoiuO9BSPy1JxXAtKV+JppTLHUG6+IUjjHMQtzphugiZjDQnmphOnnCRRK/tcaI3pre88OSTGCZr4vlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoJr1xoxYoHqMvfgMN1jpHrsrbHvTrgIezAdGHxm2no=;
 b=OTfIbogcxlyJ6PHH2aEOMGYnd0OY3E7P4DOmFOYjNrNp8BdciskWznb8BIzKTIiBer0Jvh8z5L32rZqHsOZCSUla+xJrff7UGAppgxJmic7sawf5U7pp590eJ9UxGS4VCkG/SNoce3pyQlqDH/DfUNCqS81aYckLOirFC2tNVYeXCdL+P5PJh7tmvW5w3qzUSwJZ1F+aJA7gD9bSVVHA4kGgHldUM4S6zgx1aw8+J3OUXjHCqCIkweLr2LwzAgPiHaWoU6+tuNpAUz47VrYxDKYCkOmhOOxyFJ2guvCupVZZXVmUnTYsxskGZjFYYUkChpWgq9sa1mKmihmg0533cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoJr1xoxYoHqMvfgMN1jpHrsrbHvTrgIezAdGHxm2no=;
 b=UDkiWt8lWlRAP081L4RjmjLJFBAItVHriW3XiKV9rBa80nxQes2VKJyGhXypKA1kNWlZ4JxqGqTQwEBK/0a93vbzf6puE9mfmfaLp5S2+dRXIs3LIq8OTzsBnpBompeK6AiGKVm+2CUwqPfAohGocdHEWucoKpc71302gpc44x0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5499.eurprd04.prod.outlook.com (2603:10a6:10:8b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 03:16:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:16:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 net-next 4/4] net: phy: realtek: add delay to fix RXC generation issue
Date:   Tue,  8 Jun 2021 11:15:35 +0800
Message-Id: <20210608031535.3651-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24 via Frontend Transport; Tue, 8 Jun 2021 03:16:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e61192bd-2417-44c0-b92d-08d92a2bc69b
X-MS-TrafficTypeDiagnostic: DB7PR04MB5499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB549903C7C725055C4FB20DDDE6379@DB7PR04MB5499.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rfK5Kks60G/vaFkdvWvLPiyKDzW2r/OUXSYatu3jy+yK4ChfzECyCx1h40PJArT84oIXs33RUR6KtHVzx9Br1Jl+/Uvs5oEqeunEDjTHzYDM1a+d+72vvhl8IdE8fwvsLqToyKXsOg95NQr2xD3hHUL88kjNYMhLruIf+hSc+LHTd71c8uOo6n0uC/XCiESGMMIL6uxcVtopHPweWkp1RJEo9FDnZd4zq13+MB99PPacEenHrYH+JWy/LrsvxAhENEn4d1dZWBHtKulLrrfT3h2gO3r8WZ40vCrl7fG6mo5DFVQSb0NwGRcb0ZEXkYfHkT7pQQ0Ag/6YrsKjJ8/TvERSlo2nwHucLzaTb9tqeaF3SIhIe4L/bdUfLn5P3q2EiG7feLQ78cbI0LfPUkM+I2ca4Q6k+G7p7qVtKKrCQ8xzENbErXfFtzuLP74ONt2B19gMOy1gJlZYwHKNZ9Fr++r8ZWqKYYfwMWcaxbXfEUFmq/AIg5tZkk7bYJ7oB0lmf0VIs9ZYrbJZKy4bu09ayDfqnSMuMrHUY6GEgSfHNTrp8YUE20IPrYxTbfD6wpj2/gU6S6Or/O0pqCVwN7Ovs3sreK9xfIjYjGcc4IBb6jNp7j/AjeW7+Q3Qk/HAgkN7HO3EYEfKQc2r+vRnrNbOJkiByMtWAX2G+4aRVU7S4Qvtw/nP2w9DzJHCtk+bklNp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(956004)(7416002)(6512007)(52116002)(478600001)(2906002)(6506007)(38100700002)(4326008)(2616005)(1076003)(186003)(16526019)(86362001)(66946007)(38350700002)(66476007)(66556008)(36756003)(5660300002)(8936002)(6666004)(26005)(6486002)(83380400001)(8676002)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XVTe+L2B0h5ou0M5upgUUUKMddhVxEV2HeezOW9r1SGQ8wQLsvK0Fvz2eiyc?=
 =?us-ascii?Q?VXZE5EpWXM8xkz0EbC2horfmY6+ddxj40cAG3+XWO5oPvpnaepAJB9MpGHSN?=
 =?us-ascii?Q?CisFC75Hz0GJd8xQRMnM4RewoZZGhKadDmDc69bpX17VbKsyAqWQZkOzHvhf?=
 =?us-ascii?Q?czuKmmbn20Umus0ft7NgQuJB/7fOWnqzqRN5ohNLfHzS5iz2hDSy3afd92Sy?=
 =?us-ascii?Q?cjY8SFgCsSKd+jNkmMrLrRupqo2DH8AJcsjhgDwXsYapji7V9Sl7QqHFjRbX?=
 =?us-ascii?Q?CHH/cPr2phR/6Wb5fcN/bDAya3XgDEIGwF4JDLyhY+esnGqe/cAPMH2klX3b?=
 =?us-ascii?Q?6HMmG0KhQV/heoihgpN8JRbH0QtSg9pv02lBLVHJAQJRNRa+GbxwxBnMiN0M?=
 =?us-ascii?Q?UM54GqeBFpU+qUYhcbIoJwXvpm6brMGVcs62kT4f7wbSBRQ1765sYisx9DDm?=
 =?us-ascii?Q?MMGU4IemZJAynuMMzX66yIrU9fH5GWIaTh6O0bdHSb5bOCAkd0A1jb3UvOFW?=
 =?us-ascii?Q?n9pwvz4z/7zeV0NOHaF+W/lqJDFvu3NMxqJlwhwVjaSDtfEblavRl4QyCyVI?=
 =?us-ascii?Q?F6rlIiQWaWBhNWkMQ6KNIqVtklB+7dBQUn7nMRCjYaUtu7UyXH7KDIWI4j9T?=
 =?us-ascii?Q?mjSr3j8dC/D3VD9/H2D1NawI7Th0X/sCWREJVqUCmP7OQAIxhan1wojVEqyS?=
 =?us-ascii?Q?8uJJeOGrjkiWfXh7zrfLyJBd8DKKhnEJwXiMJT9tf+fAqysnFkd0y86PToYu?=
 =?us-ascii?Q?gEPnaKRychMqxsZ2Hy/b6nelYGiOtiQSDQQyBH08vuyGjPWqcPWTjs9pG0bV?=
 =?us-ascii?Q?uyjyMGFh9TYvZZcg1Z91b6HxqJo7cs7tFxzZQr1KkkUw/uFs3xJpmxBfcVpI?=
 =?us-ascii?Q?IuHqHfQzYdWzvjdws+LCCmEPd28aWikD8O3EiFUFI0mFmB72cjjYR+JOG6gT?=
 =?us-ascii?Q?oAwu4adhBMX4yAzfpjzR0hwuuayYgbUgMxBCvPElbvfcRdpeRi70l1Zg7KPW?=
 =?us-ascii?Q?awIlzri1IIqJBo9ASvpcsRuhKb4pEsvO+y/0GDjIeQ8FbiiI3BW7TSO1VZoY?=
 =?us-ascii?Q?cYjeDjqCyeQnrgJTEoISRqrtFGlsS9H7y4iIjcybFnkglH9ierjEm6IikhXq?=
 =?us-ascii?Q?RTyZ/ih0Ru7w/FMadt8P4UMnWzefG3oQgutWyUUXM7RcEgZO3TOjgLf26XoT?=
 =?us-ascii?Q?StTPpG5TSyftD2N16Q3p+8BYfguOl15glp6qO/VM8lsNeU3YfKxLzUmyhjuz?=
 =?us-ascii?Q?Hz475IDZHK5aRGSdZZAJoZhH6UwvxipvqTXSKxS0DQCsWrsnErBLWzfn8VTS?=
 =?us-ascii?Q?hXdhajX+2LYqlNimD5oj26qI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e61192bd-2417-44c0-b92d-08d92a2bc69b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:16:15.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CUIT5mlUT7gopR8qN3Qvzuqvi360YNow1tKud5CTD1BnWb91mwY/MyaQl8xOTMtU6Fsb3FUQ4biUgf6rFYFig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY will delay about 11.5ms to generate RXC clock when switching from
power down to normal operation. Read/write registers would also cause RXC
become unstable and stop for a while during this process. Realtek engineer
suggests 15ms or more delay can workaround this issue.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 79dc55bb4091..1b844a06fe72 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -410,6 +410,19 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int rtl821x_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	msleep(20);
+
+	return 0;
+}
+
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	int ret = 0, oldpage;
@@ -906,7 +919,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-- 
2.17.1

