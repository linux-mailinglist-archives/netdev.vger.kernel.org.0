Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463613A56E2
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 09:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFMHnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 03:43:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4056 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFMHnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 03:43:37 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G2mc5632tzWr8k;
        Sun, 13 Jun 2021 15:36:37 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 05/11] net: z85230: replace comparison to NULL with "!skb"
Date:   Sun, 13 Jun 2021 15:38:17 +0800
Message-ID: <1623569903-47930-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

According to the chackpatch.pl, comparison to NULL could
be written "!skb".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index f815bb5..ced746d 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -851,12 +851,12 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 		return -EMSGSIZE;
 	 
 	c->rx_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
-	if(c->rx_buf[0]==NULL)
+	if (!c->rx_buf[0])
 		return -ENOBUFS;
 	c->rx_buf[1]=c->rx_buf[0]+PAGE_SIZE/2;
 	
 	c->tx_dma_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
-	if(c->tx_dma_buf[0]==NULL)
+	if (!c->tx_dma_buf[0])
 	{
 		free_page((unsigned long)c->rx_buf[0]);
 		c->rx_buf[0]=NULL;
@@ -1039,7 +1039,7 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 		return -EMSGSIZE;
 	 
 	c->tx_dma_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
-	if(c->tx_dma_buf[0]==NULL)
+	if (!c->tx_dma_buf[0])
 		return -ENOBUFS;
 
 	c->tx_dma_buf[1] = c->tx_dma_buf[0] + PAGE_SIZE/2;
@@ -1397,7 +1397,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 	c->tx_next_skb=NULL;
 	c->tx_ptr=c->tx_next_ptr;
 	
-	if(c->tx_skb==NULL)
+	if (!c->tx_skb)
 	{
 		/* Idle on */
 		if(c->dma_tx)
@@ -1486,7 +1486,7 @@ static void z8530_tx_done(struct z8530_channel *c)
 	struct sk_buff *skb;
 
 	/* Actually this can happen.*/
-	if (c->tx_skb == NULL)
+	if (!c->tx_skb)
 		return;
 
 	skb = c->tx_skb;
@@ -1589,7 +1589,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		 */
 
 		skb = dev_alloc_skb(ct);
-		if (skb == NULL) {
+		if (!skb) {
 			c->netdevice->stats.rx_dropped++;
 			netdev_warn(c->netdevice, "Memory squeeze\n");
 		} else {
@@ -1630,7 +1630,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		RT_UNLOCK;
 
 		c->skb2 = dev_alloc_skb(c->mtu);
-		if (c->skb2 == NULL)
+		if (!c->skb2)
 			netdev_warn(c->netdevice, "memory squeeze\n");
 		else
 			skb_put(c->skb2, c->mtu);
-- 
2.8.1

