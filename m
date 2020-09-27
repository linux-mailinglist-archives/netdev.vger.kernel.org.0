Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C33279F7E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgI0IIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:08:07 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:61957
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729125AbgI0IIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WR1k1/GPcO/IWfP60elh5GAAoy05JbGfE11zWagvCjWazL9OXQe+bVkBbylTndAxLdyibssyCi6G1NrtvDNTrLVPN3mY/asZ9DDVNlomGAFb2BVQ8nOaxox2OH918ZUD292G6uo5OWN5ZEAEjuHi8o8abQ6bW+iDy0CVmXrrI6S8TjEE+BB7jHE1cgee90FFxxkriWjeY0MG7V9qgLLE0LC91UAklPxiuR12WlBiAKCCB/szGuuqWA11FrEzPchSWG9/yIsOTGpvAYqLcwei+UuRM6hNxJjqh3oB1y1nDU3yxXetWZnvM9gNtY0oNUyiWBcTW22yxXoRiqn/qo8cYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enP4Mok5JxOb2WmVj1GrWokgmAIuk3qI7EZPEGEfKCc=;
 b=fUFlUsSHP7/PIMsVEvd8zA9pcA6yKqyZHwQskBgah4OwbwbUcWA1YILVlzs6QUeiju2jQr18+0oPJb9eYT0SuZMW9DMT0RhniKPmwAdXoNu4rRCvJQ3iI/RquUcgZmcJOuaj5NFdZSckGYN+VNiSuQ9NVpc+Etrwi2ep0BT7Hy0DnxomCnj9j+gbMq5ZjBzQVDDCkrVK3mLMcpF8slH9Vwq8jl1XDVheq7ax/xKs393fs1w8GgAI8PNa+olm5ZClD9uQoddUCknvnQRUGO+2VPAdonCog29QwF4DTfLGx3LlHac1FFdeHN/ig0kjgdHrKmt5RWLk8U3waBC5ZTT6nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enP4Mok5JxOb2WmVj1GrWokgmAIuk3qI7EZPEGEfKCc=;
 b=gLKzDYwaqcpbOcH46Np5oBlNQAkq4o6zOicpmSjzQtXWjN4baJIvSbgOenj6H5xFrALe/tRbwmCV5AhSDCvy5ooGw5uP06hkL01A7L5wkiYb77YIm2vn+ZOJ0M+eF2rGbPsijZMj8Z6MuADpAeuMRpdHmUPzQNiNY1JQKXFDMoU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Sun, 27 Sep
 2020 08:07:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 08:07:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH V2 3/3] can: flexcan: disable runtime PM if register flexcandev failed
Date:   Mon, 28 Sep 2020 00:08:01 +0800
Message-Id: <20200927160801.28569-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
References: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0012.apcprd04.prod.outlook.com
 (2603:1096:3:1::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0401CA0012.apcprd04.prod.outlook.com (2603:1096:3:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sun, 27 Sep 2020 08:07:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 939cf9ba-abb6-4bdb-242b-08d862bc72b2
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB495372E1790799611AF58715E6340@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUjLzDNGuZA2FE5Qqk+DlcmfEZjn4i/t+ljQBIg0Gw8e8bkfF+5TiLL2Qac7JwvCBSekV4y/uMCHdxKI/RfjYtHO+5tjrYO7Kr3gGXZdRZbGZqUtW2HCa6CPsLailmKWXtAoOaGgsMHmDQ6Yp4zEi3rOGra+Mk/lr9KdrE2OEFDakZ04P9kRuNrVIsRLjGGLSOGGMR6wLqykaH2NKBgE59EbOp4a1oRsAg2UaE8aah8yHydDJ0Rddp0ah0flDcxnBGu4qcYRiSh8HbLEK1muveOt0yeICqxbo1kPL87OXJ5eFMTduFRz/3wuGWaW2ckPBus7qEQLLlnHwR4c+/YaUue/PeyV4+HlmUtAr7xHLGECiXo0CA48bC5J8VzyoN1KREeMgG69sW0hzAOs7f86OOHi1d2XPnXq/m5CwnkM7zxwOd7ZYw8IqYkfgBU3lDjK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39850400004)(366004)(396003)(4326008)(2616005)(2906002)(69590400008)(66556008)(66946007)(66476007)(5660300002)(16526019)(36756003)(186003)(26005)(6512007)(4744005)(86362001)(6506007)(8676002)(6486002)(478600001)(8936002)(52116002)(6666004)(1076003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XoD6UGL/7YoUXVo1z6YpWvmHXsLhWp/vdbwQH2W2ICPByi2O491hpaLsqKWfahowI2sojQa/SaKaDUQtHgPFRWujoITV6K4H1tcCnFrwUhPNBglzG5iS3TPFUe94lOi7kiuswQKc0hk1XybUOZ0YUJ9gwhSxex0XoZnRqZ58rt654w1EnNPrXTnfPqeN/MWdL2wkLzT+Y5VIcWrg3fMxSDbR0KgiGXXPynPF31Woc61l0cwwakAesKIqZQGn4SFGAvZV9l8NUWhzurQbJpcpg5Ye+MzmugkmmLoFJmTaz1Bk+FqrYoEHOrezllxKriX1zA6F6KLon987+rG7cJmg53Oy6iSyPytxx9ukvYv7cxZpsBMeBMnb8ee/6/2C1+vKPfibyRIvBjJnv5NxUK6eIDk5gRBKcZSjE9t4v3fFGnvcNzyATtpzDrA2Eas/ItozDgN1VdUTC1G8lS0mu4h20HcNrGlGCexvYQj20MqUuhb55MQU9ygguR9+OUHmHKrRCx+oer8YZJOK6nqQcEp6Bdjq4zhbIRKtkeo0QagGUVUK3YrUnnmOLYnOka3BwPInpe3E+IJxgUVKgafROgDfsiBhTxISGw0aRNgsqptWuEjJklvEXdGBNURn7D/yHeoL+OoJW6ipYeD7sdTeau4KlA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939cf9ba-abb6-4bdb-242b-08d862bc72b2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2020 08:07:59.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dn81+JNbMZEAXbkm1hVPJ7ElCVOhHGR5q3+zO6KDYJyLrlFWkFo5efAVqOE0Zp1N0eFWmAT2hmGOzr5L0KAiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable runtime PM if register flexcandev failed, and balance reference
of usage_count.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* no changes.
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 4844dbf77c9c..ee6d220a4b12 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2075,6 +2075,8 @@ static int flexcan_probe(struct platform_device *pdev)
 	return 0;
 
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
-- 
2.17.1

