Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0414A2AB226
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgKIIF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:05:59 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7435 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729730AbgKIIF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:05:59 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CV3TT05hBz73nD;
        Mon,  9 Nov 2020 16:05:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 16:05:50 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 2/2] net: fec: Fix reference count leak in fec series ops
Date:   Mon, 9 Nov 2020 16:09:38 +0800
Message-ID: <20201109080938.4174745-3-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201109080938.4174745-1-zhangqilong3@huawei.com>
References: <20201109080938.4174745-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pm_runtime_get_sync() will increment pm usage at first and it will
resume the device later. If runtime of the device has error or
device is in inaccessible state(or other error state), resume
operation will fail. If we do not call put operation to decrease
the reference, it will result in reference count leak. Moreover,
this device cannot enter the idle state and always stay busy or other
non-idle state later. So we fixed it by replacing it with
gene_pm_runtime_get_sync.

Fixes: 8fff755e9f8d0 ("net: fec: Ensure clocks are enabled while using mdio bus")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d7919555250d..f3f632bf3676 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1808,7 +1808,7 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	int ret = 0, frame_start, frame_addr, frame_op;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = gene_pm_runtime_get_sync(dev, false);
 	if (ret < 0)
 		return ret;
 
@@ -1867,7 +1867,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	int ret, frame_start, frame_addr;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = gene_pm_runtime_get_sync(dev, false);
 	if (ret < 0)
 		return ret;
 	else
@@ -2275,7 +2275,7 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	u32 i, off;
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = gene_pm_runtime_get_sync(dev, false);
 	if (ret < 0)
 		return;
 
@@ -2976,7 +2976,7 @@ fec_enet_open(struct net_device *ndev)
 	int ret;
 	bool reset_again;
 
-	ret = pm_runtime_get_sync(&fep->pdev->dev);
+	ret = gene_pm_runtime_get_sync(&fep->pdev->dev, false);
 	if (ret < 0)
 		return ret;
 
@@ -3770,7 +3770,7 @@ fec_drv_remove(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = gene_pm_runtime_get_sync(&pdev->dev, false);
 	if (ret < 0)
 		return ret;
 
-- 
2.25.4

