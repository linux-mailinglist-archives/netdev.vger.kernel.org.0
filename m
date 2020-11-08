Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA202AAA70
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgKHJt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 04:49:28 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7465 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgKHJt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 04:49:27 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CTTqP4wcTzhj1J;
        Sun,  8 Nov 2020 17:49:21 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sun, 8 Nov 2020
 17:49:21 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <fugang.duan@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] net: fec: Fix reference count leak in fec series ops
Date:   Sun, 8 Nov 2020 17:53:10 +0800
Message-ID: <20201108095310.2892555-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pm_runtime_get_sync() will increment pm usage at first and it
will resume the device later. If runtime of the device has
error or device is in inaccessible state(or other error state),
resume operation will fail. If we do not call put operation to
decrease the reference, it will result in reference count leak.
Moreover, this device cannot enter the idle state and always
stay busy or other non-idle state later. So we fixed it through
adding pm_runtime_put_noidle.

Fixes: 8fff755e9f8d0 ("net: fec: Ensure clocks are enabled while using mdio bus")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d7919555250d..6c02f885c67e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1809,8 +1809,10 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		return ret;
+	}
 
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
@@ -1868,10 +1870,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		return ret;
-	else
+	} else {
 		ret = 0;
+	}
 
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
@@ -2276,8 +2280,10 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		return;
+	}
 
 	regs->version = fec_enet_register_version;
 
@@ -2977,8 +2983,10 @@ fec_enet_open(struct net_device *ndev)
 	bool reset_again;
 
 	ret = pm_runtime_get_sync(&fep->pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&fep->pdev->dev);
 		return ret;
+	}
 
 	pinctrl_pm_select_default_state(&fep->pdev->dev);
 	ret = fec_enet_clk_enable(ndev, true);
@@ -3771,8 +3779,10 @@ fec_drv_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		return ret;
+	}
 
 	cancel_work_sync(&fep->tx_timeout_work);
 	fec_ptp_stop(pdev);
-- 
2.25.4

