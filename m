Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A37225848
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGTHSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:18:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7787 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725845AbgGTHSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 03:18:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 39AED5CE058544805D14;
        Mon, 20 Jul 2020 15:18:51 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 20 Jul 2020 15:18:50 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <opendmb@gmail.com>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <bcm-kernel-feedback-list@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: bcmgenet: fix error returns in bcmgenet_probe()
Date:   Mon, 20 Jul 2020 15:18:43 +0800
Message-ID: <1595229523-9725-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: 99d55638d4b0 ("net: bcmgenet: enable NETIF_F_HIGHDMA flag")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 368e05b..903811e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3988,7 +3988,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (err)
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
-		goto err;
+		goto err_clk_disable;
 
 	/* Mii wait queue */
 	init_waitqueue_head(&priv->wq);
-- 
1.8.3.1

