Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1040418274
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbhIYNmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:42:10 -0400
Received: from mx24.baidu.com ([111.206.215.185]:50398 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343547AbhIYNmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 09:42:08 -0400
Received: from BC-Mail-Ex07.internal.baidu.com (unknown [172.31.51.47])
        by Forcepoint Email with ESMTPS id 6A8A3D3C1892A098608D;
        Sat, 25 Sep 2021 21:40:32 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX07.internal.baidu.com (172.31.51.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 21:40:32 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 21:40:31 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Steve Glendinning" <steve.glendinning@shawell.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] net: smsc: Fix function names in print messages and comments
Date:   Sat, 25 Sep 2021 21:40:13 +0800
Message-ID: <20210925134014.251-4-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210925134014.251-1-caihuoqing@baidu.com>
References: <20210925134014.251-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex31.internal.baidu.com (172.31.51.25) To
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

