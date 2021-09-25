Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA95418230
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245466AbhIYNJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:09:55 -0400
Received: from mx22.baidu.com ([220.181.50.185]:56328 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245112AbhIYNJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 09:09:52 -0400
Received: from BC-Mail-EX08.internal.baidu.com (unknown [172.31.51.48])
        by Forcepoint Email with ESMTPS id 40FEFA9B5D149AE7CF6C;
        Sat, 25 Sep 2021 20:51:04 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX08.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 20:51:03 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:51:03 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Steve Glendinning" <steve.glendinning@shawell.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] net: smsc: Fix function names in print messages and coments
Date:   Sat, 25 Sep 2021 20:50:41 +0800
Message-ID: <20210925125042.1629-4-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210925125042.1629-1-caihuoqing@baidu.com>
References: <20210925125042.1629-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_xxx_xxx() instead of pci_xxx_xxx(),
because the pci function wrappers are not called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/smsc/smsc9420.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index fdbd2a43e267..3d1176588f7d 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -788,7 +788,7 @@ static int smsc9420_alloc_rx_buffer(struct smsc9420_pdata *pd, int index)
 				 PKT_BUF_SZ, DMA_FROM_DEVICE);
 	if (dma_mapping_error(&pd->pdev->dev, mapping)) {
 		dev_kfree_skb_any(skb);
-		netif_warn(pd, rx_err, pd->dev, "pci_map_single failed!\n");
+		netif_warn(pd, rx_err, pd->dev, "dma_map_single failed!\n");
 		return -ENOMEM;
 	}
 
@@ -940,7 +940,7 @@ static netdev_tx_t smsc9420_hard_start_xmit(struct sk_buff *skb,
 				 DMA_TO_DEVICE);
 	if (dma_mapping_error(&pd->pdev->dev, mapping)) {
 		netif_warn(pd, tx_err, pd->dev,
-			   "pci_map_single failed, dropping packet\n");
+			   "dma_map_single failed, dropping packet\n");
 		return NETDEV_TX_BUSY;
 	}
 
@@ -1551,7 +1551,7 @@ smsc9420_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!pd->rx_ring)
 		goto out_free_io_4;
 
-	/* descriptors are aligned due to the nature of pci_alloc_consistent */
+	/* descriptors are aligned due to the nature of dma_alloc_coherent */
 	pd->tx_ring = (pd->rx_ring + RX_RING_SIZE);
 	pd->tx_dma_addr = pd->rx_dma_addr +
 	    sizeof(struct smsc9420_dma_desc) * RX_RING_SIZE;
-- 
2.25.1

