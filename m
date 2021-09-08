Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E740359F
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 09:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350259AbhIHHpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 03:45:04 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:29825
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233210AbhIHHpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 03:45:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya6WXrIyF9uJuY12LmyTQCMU3XIhcUSMIL0ni0Gs4n5GaX+SLNHQ6O/PTsPXOdlIQlO8eVW7KlnkrzpPEWpWuWS6juuCGXgPl689bcurMMUaYXE+CmzNBoLNQOvSKMUOhJaYO7qlHQBMlfzSz14/t46ACuuFcZ+Y/j8gZu3AD2M0FI+3h/vUISOIsGwgc7VjucVMCPUFQ+D/UJ8G4c8DeH/cJIOu64kX+vIsqtScT2RHsDsp1ikFESUSvjHPqx+r6ezeJZ729EBrlfyHY11dYV/fNeZTZ/QhsshS8dzaChPiLqLrK+95No7/fQJ0lLtbI3Y+2ZKc/QyPR33fT///YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SxFOVMvr3I7ZqC047mf3EEdFJnJVE0Na9oNxpm+A3cM=;
 b=FLbe3AkKR3BAjRluky8FL6x7WUZoVNQGRNd/lgcRmA7IkgSWNcwqPngVqxyKX7uV6Yy9GoYBHu1pOyiPs2Hh1ZE6ZM6Cgm7XiNN4kUru86KpQilVrUyCMW/HKRC7wsG2+KGzj2Btw508wZKft7XilcNTMu08VokIzzg5PnDHMOGxFJNoYm94aYVw+fyb5EPUCMDgoLniKihPKNCpj7RgO0oXBnCWPtFvd/IJ6B88FvrQM91yOzZfgUbK09DT9qXPL1VTJhOWxlaQZv4rib4eaV6jSPHzJlNzde5AugF4fwzF4DsV01nb/LcEFIlrlP7B+DbQqD7xXQieY/KM8W/vsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxFOVMvr3I7ZqC047mf3EEdFJnJVE0Na9oNxpm+A3cM=;
 b=hM0XdG3owte4gbonMMj07bhTt30imOdbT3+H0jz/weCrxK+je6OAgJ/F90jBrCnQprdlvRxEeWhuoXldOY/PiPruBd9CkHh5aM2V2Z+5+38YN7GOWnjDYfDQkRFuVZKqEkW9N948/aTODgRZ4IdLbqN3iTJvCbJYkVD0HxRPO2o=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2327.eurprd04.prod.outlook.com (2603:10a6:4:48::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Wed, 8 Sep
 2021 07:43:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4500.014; Wed, 8 Sep 2021
 07:43:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume
Date:   Wed,  8 Sep 2021 15:43:35 +0800
Message-Id: <20210908074335.4662-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0092.apcprd02.prod.outlook.com
 (2603:1096:4:90::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0092.apcprd02.prod.outlook.com (2603:1096:4:90::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 8 Sep 2021 07:43:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 478115ef-70cf-428e-3124-08d9729c676d
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2327EC7546474C49E896DA0DE6D49@DB6PR0401MB2327.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYRH0IFVX1bVXUFZDiCNaue3M3Jz6kYyqQ84CnzJEmQGCKCiGsMHpkR8DbormNSU9GJN9pGvGa1TmiAszNP+4dNyBSHOANIfU5H1cGnF2uSwDeuGcaBvk7SGBzaFxm5NtD83idfINf4K4MlyF/PczSX9buegWxZOz53Z9pKZ28Ljl4K2CtfVdG5J9QB5FtdMF09RpQHluFwcYMYoKp8axj7tK7DrpJhUQ8mVJ3kIBSPQzcbBkpoEr3cFVEDXvzz42eWpTCWPkNVku1jDvR8dDNvdxlCf/Jw0Qt1zad38l9XryABy+8UOLsGe65cmhWo3FKsRF9SclzKyyubZhS8WgY5Y1TQIXufjxE5B0rM/KAOClwspipvNkKFnixpQLPC0RiN5jUwW7QLV/5nrmFHRw0Ri5iaXKtLElIMtF5o3u511eDeC2xOAuhEWRj6Xr7Fu2Ot8X2e4KfWHpAjBQsOaiw8sOMxFcoBkf7dKqdmns0jEwcT9KwMKjIOve/H7Pc26NUo6M0ZnPWmUsdwGGBA+s6pCyOEGN/0OBC3InTWFl/6cc8GkEweqsOiVua9azwlHGNOxA47mVOHrKxJPn6N4WmMIcsMAwEdoTmoR901EpxA1ZM/8jVaw1/rhs5YRFkHgD0GKONcsJWCm5IDH31rL83vm7Xec/kMKua4KqOAA09ZwdHnz+T947i6xJK42yA026mZNHC8tODr1OVdslhgO/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6506007)(15650500001)(508600001)(5660300002)(8676002)(2906002)(26005)(66946007)(38350700002)(66556008)(186003)(6512007)(6486002)(8936002)(86362001)(6666004)(4326008)(956004)(316002)(2616005)(1076003)(36756003)(38100700002)(66476007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FHzaiUByEX97D1+GJH9j2O/eWkC4eetmjUfZ1MkGTtDMZniCDSSbBd6PLSHe?=
 =?us-ascii?Q?vLaYxbddzj5R+KDdQhPxja9fM6ynSqydNAgDVFNjTPa6HJAynmkyh6NN1osv?=
 =?us-ascii?Q?iRyN5w1MNKWcWMwBjYpCNNm737f6LNO6h8luxxtzl3A8tHf6wREBt2eCFHYu?=
 =?us-ascii?Q?h9d9qAd5OmnPRyo53CyyH5W8TlfHBu3fhV++58aps2KQ3a+TFRpp2eFTBuE+?=
 =?us-ascii?Q?D1FPLQwSBDKm3+qZNVo+dhPB4QWC48heY6SxO+uoYay32WW5pRjkTkSFF6Mq?=
 =?us-ascii?Q?6SqTPGuYkadpcNr/F/9pa0wDRf4rLvCNm0QGe1V1oZxaxbUDbb7ceO29wKhD?=
 =?us-ascii?Q?gYiM9rsjlHgd3uslNOoFJ6pF8DomxyeoOIn7voCIarnLDaeBLWshwH+SQItJ?=
 =?us-ascii?Q?G7NquBNAx+//7+EFgQPphHU9Yst3NBwEugNAeDAIckFrOgEqqRJnUJBgMHy2?=
 =?us-ascii?Q?Tfb0zMZJHfIvyiE/c4esvU7N66EmYd1It3X0fN39ThJlN9/FE3fcF16+tAzN?=
 =?us-ascii?Q?BA9hppbbh+r5J084ch8MHmVuHtnsv/cqx1cdhVKa8h8H5WwMXrJcDoYLmUbT?=
 =?us-ascii?Q?axPiItg93rcplmcwOXTqSxJ/pVcsNVF83uie5Fpca00tZ+5JhLNSqt0CxL9R?=
 =?us-ascii?Q?acj1Xvz7DGwlFe3arSs3QD5sH81vBpaJPXk+dXvJbn4V7qznmWBjtJvxFa4u?=
 =?us-ascii?Q?KnDkEN5LzOlDGZG/txQlmz94UsPZGKM8bSwDY8+wnD4TBluqdCvnyEZbpvCo?=
 =?us-ascii?Q?HWWAOOwxBZvFG55nWndPFiJEe+XPBMMxWcxi5dIFbQnPUWMUiaOxELT+xFSC?=
 =?us-ascii?Q?xaW+Sf8hZYTfZcIG9PuBk69vJaP7pYkASpQBQzQwxGerAjTUceGNJg/Y7bY3?=
 =?us-ascii?Q?NjaN8sQvFSRvs/tyI+ywI77NUZyJwXAzQhLXYa0XNg41Xnp+tu5myuqRs/Us?=
 =?us-ascii?Q?YNgP9k2usKqvYCyDbxtGlqpbeAUUpr6aBQOa+LD6DN9jwTXOztKPAmnSEHCN?=
 =?us-ascii?Q?OIweTWpV2kYe2HqLdXSHNmxQUtpG5EIePf2q27lMHnxK/BOi2aMewBPN/kx2?=
 =?us-ascii?Q?KM6q64W/6eBmZlQWi9zPPIuQ6Wiq7Ll4agMD82WRXwLOIo2p9bUlvZq8Su8k?=
 =?us-ascii?Q?VMZKQhLDUO9Iq+wF7DCQeZGhTUhVrnIikB2g4ze3rY9qmPlji7KCKR/RpwEn?=
 =?us-ascii?Q?kDCekI3msw7Oz276dMyDVlPJHctPnz4ySUR4DQkASwD0Y/wheXR6F2XTNO5o?=
 =?us-ascii?Q?qC8Kt3B0Yc6svqXOnhk9DctOiq9PAAmiKKy2o4ZoQ+P8E80DyC58rNgWuTrg?=
 =?us-ascii?Q?Req88ZhnVxDHKjpX8eL0OWOl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478115ef-70cf-428e-3124-08d9729c676d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 07:43:52.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whxuRbqptOsEJMEtdY58nOD3D4gOnT0vClC7Q6i4OSXaE/LEI7ORoOoDWAg+qk1PJSHiPfTOO7GYlzwtLnjvbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after
napi disabled"), this patch tries to fix system hang caused by eee_ctrl_timer,
unfortunately, it only can resolve it for system reboot stress test. System
hang also can be reproduced easily during system suspend/resume stess test
when mount NFS on i.MX8MP EVK board.

In stmmac driver, eee feature is combined to phylink framework. When do
system suspend, phylink_stop() would queue delayed work, it invokes
stmmac_mac_link_down(), where to deactivate eee_ctrl_timer synchronizly.
In above commit, try to fix issue by deactivating eee_ctrl_timer obviously,
but it is not enough. Looking into eee_ctrl_timer expire callback
stmmac_eee_ctrl_timer(), it could enable hareware eee mode again. What is
unexpected is that LPI interrupt (MAC_Interrupt_Enable.LPIEN bit) is always
asserted. This interrupt has chance to be issued when LPI state entry/exit
from the MAC, and at that time, clock could have been already disabled.
The result is that system hang when driver try to touch register from
interrupt handler.

The reason why above commit can fix system hang issue in stmmac_release()
is that, deactivate eee_ctrl_timer not just after napi disabled, further
after irq freed.

In conclusion, hardware would generate LPI interrupt when clock has been
disabled during suspend or resume, since hardware is in eee mode and LPI
interrupt enabled.

Interrupts from MAC, MTL and DMA level are enabled and never been disabled
when system suspend, so postpone clocks management from suspend stage to
noirq suspend stage should be more safe.

Fixes: 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after napi disabled")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ------
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 44 +++++++++++++++++++
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ece02b35a6ce..246f84fedbc8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7118,7 +7118,6 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
-	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -7150,13 +7149,6 @@ int stmmac_suspend(struct device *dev)
 	} else {
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
-		/* Disable clock in case of PWM is off */
-		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		ret = pm_runtime_force_suspend(dev);
-		if (ret) {
-			mutex_unlock(&priv->lock);
-			return ret;
-		}
 	}
 
 	mutex_unlock(&priv->lock);
@@ -7242,12 +7234,6 @@ int stmmac_resume(struct device *dev)
 		priv->irq_wake = 0;
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
-		/* enable the clk previously disabled */
-		ret = pm_runtime_force_resume(dev);
-		if (ret)
-			return ret;
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5ca710844cc1..4885f9ad1b1e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -9,6 +9,7 @@
 *******************************************************************************/
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -771,9 +772,52 @@ static int __maybe_unused stmmac_runtime_resume(struct device *dev)
 	return stmmac_bus_clks_config(priv, true);
 }
 
+static int stmmac_pltfr_noirq_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	if (!netif_running(ndev))
+		return 0;
+
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		/* Disable clock in case of PWM is off */
+		clk_disable_unprepare(priv->plat->clk_ptp_ref);
+
+		ret = pm_runtime_force_suspend(dev);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int stmmac_pltfr_noirq_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	if (!netif_running(ndev))
+		return 0;
+
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		/* enable the clk previously disabled */
+		ret = pm_runtime_force_resume(dev);
+		if (ret)
+			return ret;
+
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
+	}
+
+	return 0;
+}
+
 const struct dev_pm_ops stmmac_pltfr_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
 	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_noirq_suspend, stmmac_pltfr_noirq_resume)
 };
 EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
 
-- 
2.17.1

