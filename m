Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43C02236E5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgGQITy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:19:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8314 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbgGQITy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 04:19:54 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6B4E61E758A4206AE34F;
        Fri, 17 Jul 2020 16:19:50 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 17 Jul 2020 16:19:45 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <opendmb@gmail.com>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <bcm-kernel-feedback-list@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: bcmgenet: fix error returns in bcmgenet_probe()
Date:   Fri, 17 Jul 2020 16:19:42 +0800
Message-ID: <1594973982-27988-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver forgets to call clk_disable_unprepare() in error path after
a success calling for clk_prepare_enable().

Fix to goto err_clk_disable if clk_prepare_enable() is successful.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ee84a26..23df6f2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4016,7 +4016,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (err)
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
-		goto err;
+		goto err_clk_disable;
 
 	/* Mii wait queue */
 	init_waitqueue_head(&priv->wq);
@@ -4028,14 +4028,14 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk_wol)) {
 		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
 		err = PTR_ERR(priv->clk_wol);
-		goto err;
+		goto err_clk_disable;
 	}
 
 	priv->clk_eee = devm_clk_get_optional(&priv->pdev->dev, "enet-eee");
 	if (IS_ERR(priv->clk_eee)) {
 		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
 		err = PTR_ERR(priv->clk_eee);
-		goto err;
+		goto err_clk_disable;
 	}
 
 	/* If this is an internal GPHY, power it on now, before UniMAC is
-- 
1.8.3.1

