Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FECF268BDE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgINNMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:12:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47548 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726675AbgINNKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 09:10:10 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8A3A3BF9A70C6DFAA768;
        Mon, 14 Sep 2020 21:09:46 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 14 Sep 2020 21:09:43 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: dnet: remove unused variable 'tx_status 'in dnet_start_xmit()
Date:   Mon, 14 Sep 2020 21:08:37 +0800
Message-ID: <1600088917-21372-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/dnet.c:510:6: warning:
 variable 'tx_status' set but not used [-Wunused-but-set-variable]
  u32 tx_status, irq_enable;
      ^~~~~~~~~

After commit 4796417417a6 ("dnet: Dave DNET ethernet controller driver
(updated)"), variable 'tx_status' is never used in dnet_start_xmit(),
so removing it to avoid build warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/dnet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 3143df9..7f87b0f 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -507,12 +507,12 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 
 	struct dnet *bp = netdev_priv(dev);
-	u32 tx_status, irq_enable;
+	u32 irq_enable;
 	unsigned int i, tx_cmd, wrsz;
 	unsigned long flags;
 	unsigned int *bufp;
 
-	tx_status = dnet_readl(bp, TX_STATUS);
+	dnet_readl(bp, TX_STATUS);
 
 	pr_debug("start_xmit: len %u head %p data %p\n",
 	       skb->len, skb->head, skb->data);
@@ -520,7 +520,7 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	tx_status = dnet_readl(bp, TX_STATUS);
+	dnet_readl(bp, TX_STATUS);
 
 	bufp = (unsigned int *)(((unsigned long) skb->data) & ~0x3UL);
 	wrsz = (u32) skb->len + 3;
@@ -542,7 +542,7 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (dnet_readl(bp, TX_FIFO_WCNT) > DNET_FIFO_TX_DATA_AF_TH) {
 		netif_stop_queue(dev);
-		tx_status = dnet_readl(bp, INTR_SRC);
+		dnet_readl(bp, INTR_SRC);
 		irq_enable = dnet_readl(bp, INTR_ENB);
 		irq_enable |= DNET_INTR_ENB_TX_FIFOAE;
 		dnet_writel(bp, irq_enable, INTR_ENB);
-- 
2.9.5

