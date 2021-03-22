Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D80344094
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCVMOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:14:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14061 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCVMOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 08:14:12 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3tdl4ypNzNq5d;
        Mon, 22 Mar 2021 20:11:39 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 20:14:03 +0800
From:   'w00385741 <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Russell King" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP
Date:   Mon, 22 Mar 2021 12:23:59 +0000
Message-ID: <20210322122359.2980197-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Get rid of the CONFIG_PM_SLEEP ifdefery to fix the build error
and use __maybe_unused for the suspend()/resume() hooks to avoid
build warning:

drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:21:
 error: 'stmmac_runtime_suspend' undeclared here (not in a function); did you mean 'stmmac_suspend'?
  769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
      |                     ^~~~~~~~~~~~~~~~~~~~~~
./include/linux/pm.h:342:21: note: in definition of macro 'SET_RUNTIME_PM_OPS'
  342 |  .runtime_suspend = suspend_fn, \
      |                     ^~~~~~~~~~
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:45:
 error: 'stmmac_runtime_resume' undeclared here (not in a function)
  769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
      |                                             ^~~~~~~~~~~~~~~~~~~~~
./include/linux/pm.h:343:20: note: in definition of macro 'SET_RUNTIME_PM_OPS'
  343 |  .runtime_resume = resume_fn, \
      |                    ^~~~~~~~~

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 .../stmicro/stmmac/stmmac_platform.c       | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index a70b0bc84b2a..5a1e018884e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -704,7 +704,6 @@ int stmmac_pltfr_remove(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 
-#ifdef CONFIG_PM_SLEEP
 /**
  * stmmac_pltfr_suspend
  * @dev: device pointer
@@ -712,7 +711,7 @@ EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
  * call the main suspend function and then, if required, on some platform, it
  * can call an exit helper.
  */
-static int stmmac_pltfr_suspend(struct device *dev)
+static int __maybe_unused stmmac_pltfr_suspend(struct device *dev)
 {
 	int ret;
 	struct net_device *ndev = dev_get_drvdata(dev);
@@ -733,7 +732,7 @@ static int stmmac_pltfr_suspend(struct device *dev)
  * the main resume function, on some platforms, it can call own init helper
  * if required.
  */
-static int stmmac_pltfr_resume(struct device *dev)
+static int __maybe_unused stmmac_pltfr_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -745,7 +744,7 @@ static int stmmac_pltfr_resume(struct device *dev)
 	return stmmac_resume(dev);
 }
 
-static int stmmac_runtime_suspend(struct device *dev)
+static int __maybe_unused stmmac_runtime_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -755,14 +754,13 @@ static int stmmac_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int stmmac_runtime_resume(struct device *dev)
+static int __maybe_unused stmmac_runtime_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	return stmmac_bus_clks_config(priv, true);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 const struct dev_pm_ops stmmac_pltfr_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)

