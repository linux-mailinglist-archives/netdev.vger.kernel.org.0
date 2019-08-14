Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369D08C6F9
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfHNCUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbfHNCTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:19:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C44A20843;
        Wed, 14 Aug 2019 02:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749171;
        bh=AIUaCxOwkGSbsq2amNqngxAUJmcJeKMBuosjmYGa65Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZyqqGejVUsGp4huk4vd61uq30hovbZKwiw6VOQ9/xMiur+YYg91j7DjrIFxdRcHJ
         4JKtQWlSqbQ9IooQ89mpN9RpI91baKerGm5xejLBNKj2+65m1mxhisyrpLYHdpIugh
         W1WsDafqgqGra+/7CJ86A2UHiYopQ9WFnkWAtUnY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/44] net: hisilicon: Fix dma_map_single failed on arm64
Date:   Tue, 13 Aug 2019 22:18:25 -0400
Message-Id: <20190814021834.16662-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit 96a50c0d907ac8f5c3d6b051031a19eb8a2b53e3 ]

On the arm64 platform, executing "ifconfig eth0 up" will fail,
returning "ifconfig: SIOCSIFFLAGS: Input/output error."

ndev->dev is not initialized, dma_map_single->get_dma_ops->
dummy_dma_ops->__dummy_map_page will return DMA_ERROR_CODE
directly, so when we use dma_map_single, the first parameter
is to use the device of platform_device.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index b04fb82d7fa3e..1bfe9544b3c10 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -157,6 +157,7 @@ struct hip04_priv {
 	unsigned int reg_inten;
 
 	struct napi_struct napi;
+	struct device *dev;
 	struct net_device *ndev;
 
 	struct tx_desc *tx_desc;
@@ -387,7 +388,7 @@ static int hip04_tx_reclaim(struct net_device *ndev, bool force)
 		}
 
 		if (priv->tx_phys[tx_tail]) {
-			dma_unmap_single(&ndev->dev, priv->tx_phys[tx_tail],
+			dma_unmap_single(priv->dev, priv->tx_phys[tx_tail],
 					 priv->tx_skb[tx_tail]->len,
 					 DMA_TO_DEVICE);
 			priv->tx_phys[tx_tail] = 0;
@@ -437,8 +438,8 @@ static int hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_BUSY;
 	}
 
-	phys = dma_map_single(&ndev->dev, skb->data, skb->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, phys)) {
+	phys = dma_map_single(priv->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(priv->dev, phys)) {
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -508,7 +509,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 			goto refill;
 		}
 
-		dma_unmap_single(&ndev->dev, priv->rx_phys[priv->rx_head],
+		dma_unmap_single(priv->dev, priv->rx_phys[priv->rx_head],
 				 RX_BUF_SIZE, DMA_FROM_DEVICE);
 		priv->rx_phys[priv->rx_head] = 0;
 
@@ -537,9 +538,9 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
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
@@ -642,9 +643,9 @@ static int hip04_mac_open(struct net_device *ndev)
 	for (i = 0; i < RX_DESC_NUM; i++) {
 		dma_addr_t phys;
 
-		phys = dma_map_single(&ndev->dev, priv->rx_buf[i],
+		phys = dma_map_single(priv->dev, priv->rx_buf[i],
 				      RX_BUF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, phys))
+		if (dma_mapping_error(priv->dev, phys))
 			return -EIO;
 
 		priv->rx_phys[i] = phys;
@@ -678,7 +679,7 @@ static int hip04_mac_stop(struct net_device *ndev)
 
 	for (i = 0; i < RX_DESC_NUM; i++) {
 		if (priv->rx_phys[i]) {
-			dma_unmap_single(&ndev->dev, priv->rx_phys[i],
+			dma_unmap_single(priv->dev, priv->rx_phys[i],
 					 RX_BUF_SIZE, DMA_FROM_DEVICE);
 			priv->rx_phys[i] = 0;
 		}
@@ -822,6 +823,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = netdev_priv(ndev);
+	priv->dev = d;
 	priv->ndev = ndev;
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.20.1

