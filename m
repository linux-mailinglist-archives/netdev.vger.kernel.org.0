Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3A8062C
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 14:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390456AbfHCMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 08:32:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390259AbfHCMcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 08:32:02 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7FB3845D03C61DAABD11;
        Sat,  3 Aug 2019 20:31:58 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 3 Aug 2019
 20:31:51 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiaowei774@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH v1 3/3] net: hisilicon: Fix dma_map_single failed on arm64
Date:   Sat, 3 Aug 2019 20:31:41 +0800
Message-ID: <1564835501-90257-4-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the arm64 platform, executing "ifconfig eth0 up" will fail,
returning "ifconfig: SIOCSIFFLAGS: Input/output error."

ndev->dev is not initialized, dma_map_single->get_dma_ops->
dummy_dma_ops->__dummy_map_page will return DMA_ERROR_CODE
directly, so when we use dma_map_single, the first parameter
is to use the device of platform_device.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index d775b98..c841674 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -220,6 +220,7 @@ struct hip04_priv {
 	unsigned int reg_inten;
 
 	struct napi_struct napi;
+	struct device *dev;
 	struct net_device *ndev;
 
 	struct tx_desc *tx_desc;
@@ -465,7 +466,7 @@ static int hip04_tx_reclaim(struct net_device *ndev, bool force)
 		}
 
 		if (priv->tx_phys[tx_tail]) {
-			dma_unmap_single(&ndev->dev, priv->tx_phys[tx_tail],
+			dma_unmap_single(priv->dev, priv->tx_phys[tx_tail],
 					 priv->tx_skb[tx_tail]->len,
 					 DMA_TO_DEVICE);
 			priv->tx_phys[tx_tail] = 0;
@@ -516,8 +517,8 @@ static void hip04_start_tx_timer(struct hip04_priv *priv)
 		return NETDEV_TX_BUSY;
 	}
 
-	phys = dma_map_single(&ndev->dev, skb->data, skb->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, phys)) {
+	phys = dma_map_single(priv->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(priv->dev, phys)) {
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -596,7 +597,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 			goto refill;
 		}
 
-		dma_unmap_single(&ndev->dev, priv->rx_phys[priv->rx_head],
+		dma_unmap_single(priv->dev, priv->rx_phys[priv->rx_head],
 				 RX_BUF_SIZE, DMA_FROM_DEVICE);
 		priv->rx_phys[priv->rx_head] = 0;
 
@@ -625,9 +626,9 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 		buf = netdev_alloc_frag(priv->rx_buf_size);
 		if (!buf)
 			goto done;
-		phys = dma_map_single(&ndev->dev, buf,
+		phys = dma_map_single(priv->dev, buf,
 				      RX_BUF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, phys))
+		if (dma_mapping_error(priv->dev, phys))
 			goto done;
 		priv->rx_buf[priv->rx_head] = buf;
 		priv->rx_phys[priv->rx_head] = phys;
@@ -730,9 +731,9 @@ static int hip04_mac_open(struct net_device *ndev)
 	for (i = 0; i < RX_DESC_NUM; i++) {
 		dma_addr_t phys;
 
-		phys = dma_map_single(&ndev->dev, priv->rx_buf[i],
+		phys = dma_map_single(priv->dev, priv->rx_buf[i],
 				      RX_BUF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, phys))
+		if (dma_mapping_error(priv->dev, phys))
 			return -EIO;
 
 		priv->rx_phys[i] = phys;
@@ -766,7 +767,7 @@ static int hip04_mac_stop(struct net_device *ndev)
 
 	for (i = 0; i < RX_DESC_NUM; i++) {
 		if (priv->rx_phys[i]) {
-			dma_unmap_single(&ndev->dev, priv->rx_phys[i],
+			dma_unmap_single(priv->dev, priv->rx_phys[i],
 					 RX_BUF_SIZE, DMA_FROM_DEVICE);
 			priv->rx_phys[i] = 0;
 		}
@@ -909,6 +910,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = netdev_priv(ndev);
+	priv->dev = d;
 	priv->ndev = ndev;
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
1.8.5.6

