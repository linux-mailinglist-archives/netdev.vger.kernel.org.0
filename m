Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF324740CD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhLNKu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:50:29 -0500
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:60929
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231363AbhLNKu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 05:50:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfsFQD4TEcvwnEAJ1fhPKn3OUvmEk46o7QtW/0qLZYcTFflGsXOFyjtxuFZi/nfcw/+7UqKbjgxJqhWke942ZElRfwoSpD/a9/wbXkE+JfAkGkRVwPxConsqmerQHdsTqpM0JCCjvz+gyguJ9z98qTKftI0tn8NVIcHBpHz+Y0jo/ZMJl7OkKf478HNqC304hIwNMqUWRUlDwUITMmUHjO09bpu7E7e013Ml11+N72e50M25xnF/th1Pqp77BHzWdLtbl03NTcGKffF9cb3A7/Cyl5NZ3/JHWcmauJJJCdOq8yOmPDklu3CsIq5ANVwqUpUhLhaKXJwNAhbgTsmIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AcA9TjqEdiep8RHHpQip8XFxF2gVY/iXcYWLbTNHlOc=;
 b=lRyNrW7Hw8XAUy8at54wC+TzpwC0m5ZmaUgg4BPmAxsmKYLFUh4GJ6t/S4Qm6EORyfGRc4eZKTWceKOYR1UQmA85YAUoC25PG75SedzXodMyOpeLrV3Vukk83IBk/q2QaRIk9ZpNFvsHrm9++QUS7HCiKgyyoX3VkgCk62KS0RV/eLQ5oaO/c8dequHb72zBXUglhmz3PI73NLcuYY2m4JOa9EuoqvJL6a3mfWj/RgQ0SQEnK9Bpj9TgI6Et8aGQLBQ6AMPuezPamg2Hwy7WV4D7XxkB9WZJARneu15WAVx+QdTM20ji+RZkY4d81R9azQ8/5lVnguFRPoS1vkXJxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcA9TjqEdiep8RHHpQip8XFxF2gVY/iXcYWLbTNHlOc=;
 b=BfqxoWahhDzg58gjqN5E3SgbR0z0aSbBjtFihfZSCJ/E3Qs8hu2+WhUYZvi2Q/gBkaCJOpLqqL6TloI8Phj6Qi1i5GsJyUMpJ91KcHQQXk4HcCg4QlhWJl7zz7RYBviknQ+VjH12S8dNGD3DEbYnIiCCldNVO/LIJtzKMZZxSlQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5499.eurprd04.prod.outlook.com (2603:10a6:10:8b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Tue, 14 Dec
 2021 10:50:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 10:50:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V2 net-next] net: fec: fix system hang during suspend/resume
Date:   Tue, 14 Dec 2021 18:50:46 +0800
Message-Id: <20211214105046.31901-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:194::7) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ff8074c-c8a3-4e6f-638c-08d9beef8696
X-MS-TrafficTypeDiagnostic: DB7PR04MB5499:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB54993B0C107ACDC7521B50C5E6759@DB7PR04MB5499.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7WIdSLVyUeBuE+DV/VdSPRFriGw/eEKywXz/ylQT8Vkx9mGCU3NEJBFhII/LCENM/J6ydXPHF+Sokhc/q4yr5zpXwDOydPCbIOMbO7L5WdYvAUARnSRbIs7CtqzqZHKS4Sslva8K9FGD21XAsUF3pftdOXeRAU1CBQnowCu4wl114moo60qxzKx0OYFjZBNKy3+MAcnRIByVhsTjRq59V9A09tqqvK9KJ5L38vkYwc7+RybXgCDarWZQgzAzXMu4W5ENSwE9vIAHw+F5DN+6Awt7XMGY8Bu+eHzDXIbv/KAl+Sd2rvfJ3d3RNT/bBZbyNDPtNpF2lgNkpEf0pr48QzCSfHKI2qU8mqZNPt7E25ANjAmi1XDVEhjWGmNXEcWWpGWRk8Rju8tDv8LN095A8TZ3DOsJdD4k4xxlQZgsvvyQoeKdO5G3Phd7yO4PnG3TBi7vJlnpxIDVREUOP9tQXMamnGYvS5+pgOrA3tVBI6O+C7XITjvyzmqg+sLOgEd+ri0NDNKYJfWCgtoAr8h31gWsIpdwyhb7v/AzRLgXBBWWysjElvJLOPi5KmAnRn+voNgolHiUYlBasyflA2UEWxfZ+kEljPdRhB5G1wx2Dbxbf73aqm7PX/g6qDQlXR7QTJnbodS6kEcHvwi1CR/NGIA71ht1v7X/cGpcpYhN6O/2vq3VoAowbkP5XyQsbWbE3ltougXEFcSFW9Jvf7SuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(316002)(8936002)(2906002)(1076003)(66556008)(66946007)(66476007)(6486002)(186003)(6506007)(83380400001)(4326008)(8676002)(6666004)(26005)(38350700002)(86362001)(38100700002)(508600001)(15650500001)(5660300002)(2616005)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T1sTrihUhXlQWGyXXaiJlY1lzHEc4bFni3/EHTtGnxy8xTGMorkn72+Bnf4S?=
 =?us-ascii?Q?prRbZjBafN/CQGZ0YbesComIxMswU34WCJY/tXxCRLhw5yN3ZJ33NaC+eL8F?=
 =?us-ascii?Q?18LJeMCFhafc6oBGrgY1PqadmimXGbNyVJSExAW2Z2FaQpLH+IVu+Eyt4cNw?=
 =?us-ascii?Q?mudlbu452M97BD+QyXg3R1e0wRrnECFIbhCQsmtjryZ5YzsQZErf5BO7tD0m?=
 =?us-ascii?Q?el8xDUm/shX/d07kPogV2vZsj0IomwwPuc0CpBVS3yS2NwNAcmolaEDQyBRd?=
 =?us-ascii?Q?t7y4BlvoDWUbfXyrnetDDhWKYfC16pVpiHl1mnAiDth2+neB4mx3s6ghgStF?=
 =?us-ascii?Q?2yCKAMRP2kyfKBVUwtnyeMHHXO3ZAAE7NPTyzkTHnfwtFON9aF/Kgu6dt653?=
 =?us-ascii?Q?RrkppC8AWESV8PWDBy2F5bvv/F2l90hJd7J9fwEV/3mEeCtkz45BWTff4ymh?=
 =?us-ascii?Q?1100Vt2ULGHlJDYVtIB5aoIoW3WttZQ01Ou98VXGUWrRhQU/mBecUm5ERTJY?=
 =?us-ascii?Q?ejd1N1N4T7UxhA1Ow0JufQ88CyJ+dETaODtoIj3IF/ZKdt6+YNnO3xud48EC?=
 =?us-ascii?Q?eHraF0v78lGe+VoMYV0nqGhd5NYMTBBFvq/pF4B4Sux3ZNGhaWAPknlf40zA?=
 =?us-ascii?Q?fOx280GzEtUOmmenHnMYUylGaxL1kDKebTPlSZm0SL89Zs5DwxfgxFo6eq/e?=
 =?us-ascii?Q?yRMAsQbSn9X0dr9z47FUbG55b70JS/cBnnIiIowVa94/7OYasXtgLVn3Mrjs?=
 =?us-ascii?Q?1HoKf7+048xyn0AD5k+qrboJP1XOzV5A1uSQzuQaT53sFy/E7liRQ7/WVTuG?=
 =?us-ascii?Q?Clt0YSFu4nz9t+fvcpkAONgIIFVyJ+QPmMl9k51MJhsDFSURndSWhViyhKVA?=
 =?us-ascii?Q?Fu4HdcuAF+L3qP7W/wGx6pHo9kMK8sqwHuiwcJ5jvRi1ZN4WXTPrH2lZQSxU?=
 =?us-ascii?Q?YWuB3RXlh9H9if2kjn/ZODHz/27eR4tkZeIfsmOHJcUF/0JZGowhO1TRy/Yw?=
 =?us-ascii?Q?hhDIe0MH858fAtMGx70wKoowCGtfLiIjcTaJZjni+djQkrX5NuWvC6hV7YIe?=
 =?us-ascii?Q?sK+bCA707feFOML0Wylwdz6IOSYODMfweM+86N8u4kV+iWbHD4ZK7eUuUI/G?=
 =?us-ascii?Q?Yy/Q+HTnnAjPyL/yIZMGini7l6qocEp9EMYlJoyQovIkoFfQwumFlnXdHh9D?=
 =?us-ascii?Q?rhHNOeuiB57RH7hY4h+1x/YvO1yopBUgeVC9CDZY12Zk1HHdBynoDykXmfvo?=
 =?us-ascii?Q?k+FoAhALFaKFg+WOva3A5zFfKQQyv+nZxXA1f8nTyyGB/Oi1DesBBiEgkHxl?=
 =?us-ascii?Q?5KM2W/scKtSrSJ0QEVVniu4+tiNSjz3MECqx1O+6Fqkfs5bZMfCFtK4UmHRw?=
 =?us-ascii?Q?MdthSq59VWGfC1Q1Ki5UgLILw+SwWBxAIWUrLRxeLEWuTbHalkEv9vY7PM74?=
 =?us-ascii?Q?aZvfoucpQyjkzcHMx4PFXLX0oNkRl6Ujm4dtLlp1ztTbQf/agbbMMGwk/OJy?=
 =?us-ascii?Q?VUQQfcCaYqnTxhk9CBCD6Q1F4+7YPh0VaiHSlf6wD1vf5nc34vFyxE/QOnx8?=
 =?us-ascii?Q?7KAgOzdOnXj3STROrB9woKLF/Eb0DqTuKN6jjn0tPqqQ+MYEIi9f3jUvbLTu?=
 =?us-ascii?Q?s6RAJtEQ6YMHvRGIz8T3UEM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff8074c-c8a3-4e6f-638c-08d9beef8696
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 10:50:21.6469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQFq0tN657W6W8Lzj9jq6+CV69c0bQ6s65+75RYHosbrw1obhRFHqRpSxGqL1gQYGFoy+H7FUnrUeNu/tn/Hng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. During normal suspend (WoL not enabled) process, system has posibility
to hang. The root cause is TXF interrupt coming after clocks disabled,
system hang when accessing registers from interrupt handler. To fix this
issue, disable all interrupts when system suspend.

2. System also has posibility to hang with WoL enabled during suspend,
after entering stop mode, then magic pattern coming after clocks
disabled, system will be waked up, and interrupt handler will be called,
system hang when access registers. To fix this issue, disable wakeup
irq in .suspend(), and enable it in .resume().

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
Send to net-next although this is a bug fix, since there is no suitable
commit to be blamed, can be back ported to stable tree if others need.

ChangeLogs:
V1->V2:
	* remove inline prefix, let the compiler decide.
---
 drivers/net/ethernet/freescale/fec_main.c | 46 +++++++++++++++++------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 613b8180a1bd..796133de527e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1185,6 +1185,21 @@ static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
 	}
 }
 
+static void fec_irqs_disable(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	writel(0, fep->hwp + FEC_IMASK);
+}
+
+static void fec_irqs_disable_except_wakeup(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	writel(0, fep->hwp + FEC_IMASK);
+	writel(FEC_ENET_WAKEUP, fep->hwp + FEC_IMASK);
+}
+
 static void
 fec_stop(struct net_device *ndev)
 {
@@ -1211,15 +1226,13 @@ fec_stop(struct net_device *ndev)
 			writel(1, fep->hwp + FEC_ECNTRL);
 			udelay(10);
 		}
-		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 	} else {
-		writel(FEC_DEFAULT_IMASK | FEC_ENET_WAKEUP, fep->hwp + FEC_IMASK);
 		val = readl(fep->hwp + FEC_ECNTRL);
 		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 		writel(val, fep->hwp + FEC_ECNTRL);
-		fec_enet_stop_mode(fep, true);
 	}
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
+	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 
 	/* We have to keep ENET enabled to have MII interrupt stay working */
 	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
@@ -2877,15 +2890,10 @@ fec_enet_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 		return -EINVAL;
 
 	device_set_wakeup_enable(&ndev->dev, wol->wolopts & WAKE_MAGIC);
-	if (device_may_wakeup(&ndev->dev)) {
+	if (device_may_wakeup(&ndev->dev))
 		fep->wol_flag |= FEC_WOL_FLAG_ENABLE;
-		if (fep->wake_irq > 0)
-			enable_irq_wake(fep->wake_irq);
-	} else {
+	else
 		fep->wol_flag &= (~FEC_WOL_FLAG_ENABLE);
-		if (fep->wake_irq > 0)
-			disable_irq_wake(fep->wake_irq);
-	}
 
 	return 0;
 }
@@ -4057,9 +4065,19 @@ static int __maybe_unused fec_suspend(struct device *dev)
 		netif_device_detach(ndev);
 		netif_tx_unlock_bh(ndev);
 		fec_stop(ndev);
-		fec_enet_clk_enable(ndev, false);
-		if (!(fep->wol_flag & FEC_WOL_FLAG_ENABLE))
+		if (!(fep->wol_flag & FEC_WOL_FLAG_ENABLE)) {
+			fec_irqs_disable(ndev);
 			pinctrl_pm_select_sleep_state(&fep->pdev->dev);
+		} else {
+			fec_irqs_disable_except_wakeup(ndev);
+			if (fep->wake_irq > 0) {
+				disable_irq(fep->wake_irq);
+				enable_irq_wake(fep->wake_irq);
+			}
+			fec_enet_stop_mode(fep, true);
+		}
+		/* It's safe to disable clocks since interrupts are masked */
+		fec_enet_clk_enable(ndev, false);
 	}
 	rtnl_unlock();
 
@@ -4097,6 +4115,10 @@ static int __maybe_unused fec_resume(struct device *dev)
 		}
 		if (fep->wol_flag & FEC_WOL_FLAG_ENABLE) {
 			fec_enet_stop_mode(fep, false);
+			if (fep->wake_irq) {
+				disable_irq_wake(fep->wake_irq);
+				enable_irq(fep->wake_irq);
+			}
 
 			val = readl(fep->hwp + FEC_ECNTRL);
 			val &= ~(FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
-- 
2.17.1

