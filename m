Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62F27CED5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgI2NQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:16:04 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:52705
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729294AbgI2NQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:16:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNz6BDMulP0tLxTuj5N+uFn2i/g2YLzfKIiTdImEEfby11NDJrLZoJdKC/CrhhH2A9G24KrBjagkASkpEkkQv9WVV13Q+Ag5PvAdYMDXeFvLuz1ydDCMPezANwmwwOHpy2WLTeBarGlZcd6cQuMDWKQsfbhOndgOQ3e6I5FB8a42bzEvNHHCVMmTNgnwP+H4/S8nOMFrtMhyL68UYwZRsDzKeLjGu8DyHHyR9HPMTPnSpAlh1rmaPdvJkd/V6dSJNGwpISvYAMwuG356U9g88L14gy/iV0i3rJWyNswRqz1+nhg0VEZ2o558kKoNYmXDNghEJ6SaRO4tIXR8W9YnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ7YUelM7F0lAjcqYwYnDrx3azGBgOP8EC+g+CU14eY=;
 b=lRxf13HHAxTMqgr9X5rzjz5SnDrRoGjzSy1ghK60ivZEo1wif/WsTcnfZufF1nPSANs9HJBduVF5mWWMFysxOZdTpcuUsa5ZM8HYZI2gdSW3KEIzI55hOA4lNZg0XqYGv1rWqWvbn3wgkYJ2DxM6unv4Atj7wiMdZsFb5rPMWl7JTGdS1P3PSUJdcw3F7+1l/09fCO8vQe8YTBRJL5sDMPe9l7ap05fm6AxbmM8rzgBhUl9ANXZSv1N2kXHsocZffjZDadcEL+2BUFmlG1Sd/GJRjZXUFbOIlZrkYRTEC18Xh1RnskbP1EgAqJNUF4l4fRbYnXaryUmsCxSsnefNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ7YUelM7F0lAjcqYwYnDrx3azGBgOP8EC+g+CU14eY=;
 b=OreiYIdXwuvXV8gRpNr9j0FK6vB72zMyZXqJB7kESNqLnVj281/1gpST0DAXYHwMbAzc+TdhKaCjHTCRHaXMr97V/MLoN5iY9krWbiBHL+tGdOHCdTKNH7SeF5C5JoaIo11Ap03DCeqE/2mjWjA0Cu7MAqX7vL4kzAI7XryWWfI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB2967.eurprd04.prod.outlook.com (2603:10a6:6:a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.28; Tue, 29 Sep 2020 13:15:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 13:15:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 3/3] can: flexcan: disable runtime PM if register flexcandev failed
Date:   Wed, 30 Sep 2020 05:15:57 +0800
Message-Id: <20200929211557.14153-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
References: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Tue, 29 Sep 2020 13:15:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 02a8f2ed-1da1-4123-8604-08d86479ca07
X-MS-TrafficTypeDiagnostic: DB6PR04MB2967:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB29677563BF0A1A184A52B97BE6320@DB6PR04MB2967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzhOW69m2LfmgAEqPilEVIbnFpt3UdvR85eB5IE2GaaIuMECn7mrL6ubPakM2Bqatk9ED27h4Cl91te7bSMq2sK4yr1fdwLsTa+dyhfb8XrucBm0d4ZJaSekmYvgv4wW4b4ZJNvzeyHKKHQjXLOJ7BfZ559la5ofzH7znejZ1JtkoN/tnII6PIyrEbPjcUSiyWUMpZqpudM6ILRISOXS88KdI6wgqo/QVRGllc/73b18pLqmlS1P9wa2o0LgPwiNW5HX71Cd26/oeASZ3e5CBqfWEkiU6aoBqC8to4DcUSsNTDvGMTXUDodTlCBu/0lQbsF9RbnrtjC/yV2I2ryGaxPJuUAg65BVA85T8lCLysO0/gkYsPqZM4qs3yfys7sgwvyftyjPmDycwWcyQy+srpvaavEymxOBhEp6OIauz9y9r1D7Rb276y3T8UnVdZ9m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(8936002)(4326008)(6486002)(26005)(66476007)(2616005)(956004)(66946007)(4744005)(36756003)(5660300002)(6512007)(66556008)(2906002)(1076003)(16526019)(186003)(86362001)(478600001)(8676002)(316002)(69590400008)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9YxfvEGZPuhb3LUTg84InR4rtkxKg4sOyQ3kIDiC8p1xMO16RgP3VNPWiMtXFfDczU+ax6nIk/cAU8PSu0A6u1SVeMXhziYOAG3tZu0gdfPpWJa3NSp712sKPlmAwsTvm9He4gD1LVMgeBZaxb9/vn3xwU5EuXbB54EKuH6hbGDePw30tr/mXP+7kE6vmG4PZvbQCSEIygRvEz6YsrXLmu2qPCI89/cOv/0f+6Bu+zVVibq/FJxyF2yJq+Q5HqAWa+IqRKwsuiJVSBggb8DflzWUKYGh5wYa2jCmOaKhLNDvhcm9Wc2LKd58GKGhQZUl5sWvEqv7nO0Ni/gPfdeTtKvJhErSnDnWkX+7Px7h3G9J2vawB6F9U3eJiOXOe9vv1eCI1GRp5whbBJv0UWDn1aSwxHUNXiDHDMQLMSlzr+UkCgpHBvo9op96MXOS9hMRI/84XbUziU51TX80vQny60bdXvOZc/7z1QzJfdc/I7xOAWyXy1Ac4YlKfTgxacJDmnW0dh3/an38A3ATDNaFytZDDkG/lNQ09RVA7t3nXXsR2gLHP8QZd2/W/V/spajbwKKeuZNXUrbQrlUp9N6088h9XxBXGc/hloC1XThN84tzauOU4L9J7rl8+ar8VzsQkrvFy1xEDcg+2fP+/h66nA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a8f2ed-1da1-4123-8604-08d86479ca07
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 13:15:51.9581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnYvC+dunAvETaAD268MD9iidPLYgz7dkxMF4ZlbH0ztyOXdoZh1eK4zp8G6cBU+fV4fiZOkqUeeVXyxIvYr2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable runtime PM if register flexcandev failed, and balance reference
of usage_count.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V5:
	* no changes.
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1ab12774cbbb..f32660fee92c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2055,6 +2055,8 @@ static int flexcan_probe(struct platform_device *pdev)
 	return 0;
 
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
-- 
2.17.1

