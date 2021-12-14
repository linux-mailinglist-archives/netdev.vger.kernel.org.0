Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA98E473AFA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhLNCxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:53:35 -0500
Received: from mail-eopbgr10087.outbound.protection.outlook.com ([40.107.1.87]:43749
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230302AbhLNCxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 21:53:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSvNERrzGxwKSWuWcbS1lSHaDbD7ufEkT3RWIZkxDm15gsdaMpEBWTWE+bed7zl1tSfZlR4bpp0jzapEbbaAZTDhzgnSLEoLQU0/oDkRnw7Nu+Oi9UsqMG1p95KibYZh7ZpKChcETwKvdvLLd0ulmtE3b6DBtIj4j7h8S2NZ/lU48mzoVyrFyxSOwm4ORsARc1eWBue0/oJwkNZsiBdwpT1U/XcQtO8RIcgz7KR/wlEd/l2jPUm2ZUr0MRykKmv5baejlPh/wFlr4mP0YQk0tNkQbK3gpWeE9rC2WpUoYtkelDFNPQFI41HCMhbZM3TDz8qE4zuCS+HtgLd+mPf/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcwAUfHbjBVoeRpO3erEh8aTAKjmZN768DtVnV1bYzE=;
 b=MpHKvm1yDtPZQ9bA8YF5rIGqQd59TGVq++gIPweo5bk383QCrTcacBRCStXPEF8QOKsqF6JM3MOMKzk3UxVJJBFvXjSfH3nUnSwllTHWnisVRuCykqPtEOEqcfKKsx2R93PciZpG+Ik+eQSel6ybRMk7eI3rZI6+57PyhMAxRV8NZDVI0tUYyhKWKbX47bHf7iUi8DS7xcj+IuIAeVeNMtYPwSZ6WLQvJWzeBJoyZ7CPTn13l04hQfwbH/MStAKZ91mR2N/eOgsFbMkNUJHDx4nmw9cpjY24CT/Dz+9/CWgs6DN7DfR6rwTrdXQrD+rHNL/6hnvlVwkum78vMyPwwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcwAUfHbjBVoeRpO3erEh8aTAKjmZN768DtVnV1bYzE=;
 b=T2BFt71oEjpliB41wtKRsiyXlTZWMCMxr5CPBPO70nJ0nMCjbatDgClP4TpImX2Kp9oFi5i5rEK7Ls82/4gDpB2jJlFlnJynSEoLpIDBagH2i0JVpYO4SNyrAIIpV18k7p57uke/KhnJOBDmHxFOPIW7q6GsQFcs4zn2Nwp5x6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3851.eurprd04.prod.outlook.com (2603:10a6:8:12::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 02:53:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 02:53:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net-next] net: fec: fix system hang during suspend/resume
Date:   Tue, 14 Dec 2021 10:53:50 +0800
Message-Id: <20211214025350.8985-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0159.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::15) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87fa467a-8c21-4d1e-4e98-08d9beace75a
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3851:EE_
X-Microsoft-Antispam-PRVS: <DB3PR0402MB38518EEBB4B331185CF2F8A8E6759@DB3PR0402MB3851.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B9ADOyrRS0ze1zZv1zcJaiewmP0GF6lmTD+trM8xvxgHNFeDTavHDp1lckW+ZHeZ7Fn8Xc3KNxHGtR+WPseZEpjKgdt2Ws75z/efnv+fEDdN1po2vTQ1JxCQdwj32RIymVcDAv2821w8niU6yMN4Fr0ISdcYXEsM/HZ7ujItF+H8XLBq0uCkd2P9jmaPIUcj8OiizXNiuiCl1Kw9OElyDBTN8DsErz5llsmsVh/ONVtmYkWbVUUrk+631d1C5BxVhmWgfUYf9F8aGwwYLq6QPeHIyfUrQWSR9ZCOnqdo0n6u6Umx/We2TJXTWansmfTFGIdiKOP1AD+8NYGFjmmpg8yo9toM3B5egWD4BOgqjzYB4zKPpkpc8BFZNJ7NTnNXCS4wwCZM8lwwwad2W9EzpsPy/5TcPutsSzPkJLZ6iXcULP070ehepMpazBnpwNxI0B5x/hVZXu+AUa3zaohuS7zFBqdsrqjqFKobLOArSAweGNe5+6/11lO557NhoHYL12buK16vhtoNN3m4yl6+Ra/7SS90UaZdOjJAVISvEemb1l6XwFfQtc+f7f2RcIdUXlyXzXAvMjP4fPVLlnF1QSn1hiw333jp8HbwdJrJmbxk7sqileRcj/dhjz+H75PYnKX6oYZqOrRPBoF0zTDAA9n4LyKVxF88eJq9C5VysZj/I0KVVJW8hKHv86tHP/KeV7IgH28LpTQdle3oG7wXbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66946007)(38100700002)(38350700002)(508600001)(8676002)(86362001)(8936002)(66476007)(6512007)(2616005)(52116002)(6666004)(66556008)(6486002)(316002)(6506007)(83380400001)(5660300002)(4326008)(186003)(15650500001)(1076003)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zKqpBP7W7+UH+XFALaLv4TgSNBOeLQEO8d1XN5MDcmYucqSbDjGj+PS8xjoo?=
 =?us-ascii?Q?PO1eS/GqclQltCvloKUy/DLDVuaTpPe0lsL3z/1DhtcQC9LQnxqrDFp9nVq2?=
 =?us-ascii?Q?HEmFoM4eOdWpcfxxmsU8tPOMCxxQc62/WV4v9Qwk8KBvMFx2IPMr/rYBhNUR?=
 =?us-ascii?Q?5SoYc9RuzHQpeIgpCC05L//YjRdhQUa8S1Xecs4lABbOJ8nIQO9vMj1zvsUa?=
 =?us-ascii?Q?Uy7cGPTamypIEJx76dkR0v4RBG8hoH/zUwq9YH6mTMw98XwkcrvXG0z+sA9i?=
 =?us-ascii?Q?COd/Iq55rs2AVM8rYIHD/I56BdaYVnVVXfX6WxNuzOwWEb9QgEVnjaqH+bBK?=
 =?us-ascii?Q?dLnhp3fRMjLG140pSA6ly9Hoqq/7SGMN/7OoJcc+WhOiIpLRRhRYVAVwReVw?=
 =?us-ascii?Q?kd/Gt9v6yOXisUrU8p3jym/iAMJjltgV+rROxCIG+ZEt8Pfz/NHNPVVQgsXc?=
 =?us-ascii?Q?yt6BSwJZtcYNaUW6zZIyaQBFMNVLr0l5DsDXLXMzmbYYuItnkmBwtE1GQ+mC?=
 =?us-ascii?Q?UrFiirQB3FMT9rbbaWci6j33DNr6Jz+F6K6jgQGAOBMshQ+qe/HFnihB/DDk?=
 =?us-ascii?Q?iLM9Vq83IpxPV/ZFci6cqhRqqa5jxrSYoTKBgMJM58mtCOp8Aw2G3+ll6ZZA?=
 =?us-ascii?Q?khAoZISeinn7oU7w1yHeGI62/CdL7earTdjuib1GAc+xJ4bzaxMJ6Qci4+/a?=
 =?us-ascii?Q?9ABQ4mRn9CHTSTaYa+0wCaM3n9FkUmkzlIBMiw2SK5mIZLXzd51pfsl2P8zM?=
 =?us-ascii?Q?kb6tAEkGilNiRvaoaZUIgL8LnBjfu8hPcV1GWDCWPINAVi3m7mkp5jCfJkC3?=
 =?us-ascii?Q?aN8IKmf0H4MS0N22cDV0s5vBqRRgNCZVYzz0UqCznTHBjs7Hc+AQUrVLh3aN?=
 =?us-ascii?Q?8HCIR2HwuMQfbrdXdrbUBngk7wkwkp6214t6/8N3hsgdFiopwHNzqRftAl0u?=
 =?us-ascii?Q?SmVtgbsbGlhzBAiExuBSrnxyXQdju7vqxD/IQSJtC39eSbE0odd0RGaXybgL?=
 =?us-ascii?Q?L3O53QKepprECSaqgscFxYU3USCwKM1E9IxCsegAfqwQNAsGeVMPWimh9qKe?=
 =?us-ascii?Q?XageCWdeU1A4NAz5+BGUOmmAOb5nkfLXeow4M259r4miAUjrUI6ayK7bFL0B?=
 =?us-ascii?Q?mkUBECGUe4be6R6rfF5VXV2IGP/xdHPkQ8p/RQhfPGe9fp367d/7+bqps3zO?=
 =?us-ascii?Q?T1OeLlJKEmCP3PDR0C2AbiaBrr0G7L5es5DR9Mx1FPcIkwd/WKp6tJ2qHhwA?=
 =?us-ascii?Q?4jC7jOfftMafkkznX6JaUBMNpZyGOMzY+os+9+SQjMuHVEevykN4WeMQQEXh?=
 =?us-ascii?Q?XqwxwkkAOj1sB80bU9IGUnTJKjIc0l47OB1AdUUh0Un+ZyUvmg0yXfILZygV?=
 =?us-ascii?Q?XtR9KNXER5dkMv9LWY6Fwm4b5JcJ8Y+ficdzP5mRHU9Rf7Pt8R6lunaZTaRW?=
 =?us-ascii?Q?0/MJ+xN7cYCWo5MkywtZH4Hbd18nhUo/9qKmeg9kbYMWloNRS+GIucR7unag?=
 =?us-ascii?Q?YTW6PDpHRgOEO2F6dehex0Wco+rbjt6qpLATzwZBcon9fU0Atd82U1cVN4X9?=
 =?us-ascii?Q?J/iCjQDGc1khkADJ5ASHhvilzqNLhgaZY4R+USa7EtYpmN2UE2aasCOzLYNh?=
 =?us-ascii?Q?usSiO68dah4b1SiJFWZR4B0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87fa467a-8c21-4d1e-4e98-08d9beace75a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 02:53:27.9363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qiLquWyiyIc6zL5FcBIRcNrJhyqppZrkgw8AkeplGGGygLneJ54qAQcuCFPYBRJkuDQQe+to67vPCHi7oBggQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3851
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
---
 drivers/net/ethernet/freescale/fec_main.c | 46 +++++++++++++++++------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 613b8180a1bd..786dcb923697 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1185,6 +1185,21 @@ static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
 	}
 }
 
+static inline void fec_irqs_disable(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	writel(0, fep->hwp + FEC_IMASK);
+}
+
+static inline void fec_irqs_disable_except_wakeup(struct net_device *ndev)
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

