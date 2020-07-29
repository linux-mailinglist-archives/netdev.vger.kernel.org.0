Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7F2317F0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 05:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbgG2DEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 23:04:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8292 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731057AbgG2DEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 23:04:31 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 27FFA65DC97449FFB3C6;
        Wed, 29 Jul 2020 11:04:29 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Jul 2020
 11:04:21 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangyunjian@huawei.com>,
        <dan.carpenter@oracle.com>, <andrew@lunn.ch>,
        <alex.williams@ni.com>, <mdf@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: nixge: fix potential memory leak in nixge_probe()
Date:   Wed, 29 Jul 2020 11:50:05 +0800
Message-ID: <20200729035005.89161-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If some processes in nixge_probe() fail, free_netdev(dev)
needs to be called to aviod a memory leak.

Fixes: 87ab207981ec ("net: nixge: Separate ctrl and dma resources")
Fixes: abcd3d6fc640 ("net: nixge: Fix error path for obtaining mac address")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 drivers/net/ethernet/ni/nixge.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index d2708a57f2ff..4075f5e59955 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1299,19 +1299,21 @@ static int nixge_probe(struct platform_device *pdev)
 	netif_napi_add(ndev, &priv->napi, nixge_poll, NAPI_POLL_WEIGHT);
 	err = nixge_of_get_resources(pdev);
 	if (err)
-		return err;
+		goto free_netdev;
 	__nixge_hw_set_mac_address(ndev);
 
 	priv->tx_irq = platform_get_irq_byname(pdev, "tx");
 	if (priv->tx_irq < 0) {
 		netdev_err(ndev, "could not find 'tx' irq");
-		return priv->tx_irq;
+		err = priv->tx_irq;
+		goto free_netdev;
 	}
 
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx");
 	if (priv->rx_irq < 0) {
 		netdev_err(ndev, "could not find 'rx' irq");
-		return priv->rx_irq;
+		err = priv->rx_irq;
+		goto free_netdev;
 	}
 
 	priv->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
-- 
2.17.1

