Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCEC265314
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgIJV2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:28:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731050AbgIJOEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:04:11 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AEE2D8B54C6333E5C923;
        Thu, 10 Sep 2020 22:03:41 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Sep 2020 22:03:31 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net v1] hinic: fix rewaking txq after netif_tx_disable
Date:   Thu, 10 Sep 2020 22:04:40 +0800
Message-ID: <20200910140440.20361-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling hinic_close in hinic_set_channels, all queues are
stopped after netif_tx_disable, but some queue may be rewaken in
free_tx_poll by mistake while drv is handling tx irq. If one queue
is rewaken core may call hinic_xmit_frame to send pkt after
netif_tx_disable within a short time which may results in accessing
memory that has been already freed in hinic_close. So we call
napi_disable before netif_tx_disable in hinic_close to fix this bug.

Fixes: 2eed5a8b614b ("hinic: add set_channels ethtool_ops support")
Signed-off-by: Luo bin <luobin9@huawei.com>
---
V0~V1:
- call napi_disable before netif_tx_disable instead of judging whether
  the netdev is in down state before waking txq in free_tx_poll to fix
  this bug

 .../net/ethernet/huawei/hinic/hinic_main.c    | 24 +++++++++++++++++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  | 20 ++++------------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 501056fd32ee..28581bd8ce07 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -174,6 +174,24 @@ static int create_txqs(struct hinic_dev *nic_dev)
 	return err;
 }
 
+static void enable_txqs_napi(struct hinic_dev *nic_dev)
+{
+	int num_txqs = hinic_hwdev_num_qps(nic_dev->hwdev);
+	int i;
+
+	for (i = 0; i < num_txqs; i++)
+		napi_enable(&nic_dev->txqs[i].napi);
+}
+
+static void disable_txqs_napi(struct hinic_dev *nic_dev)
+{
+	int num_txqs = hinic_hwdev_num_qps(nic_dev->hwdev);
+	int i;
+
+	for (i = 0; i < num_txqs; i++)
+		napi_disable(&nic_dev->txqs[i].napi);
+}
+
 /**
  * free_txqs - Free the Logical Tx Queues of specific NIC device
  * @nic_dev: the specific NIC device
@@ -400,6 +418,8 @@ int hinic_open(struct net_device *netdev)
 		goto err_create_txqs;
 	}
 
+	enable_txqs_napi(nic_dev);
+
 	err = create_rxqs(nic_dev);
 	if (err) {
 		netif_err(nic_dev, drv, netdev,
@@ -484,6 +504,7 @@ int hinic_open(struct net_device *netdev)
 	}
 
 err_create_rxqs:
+	disable_txqs_napi(nic_dev);
 	free_txqs(nic_dev);
 
 err_create_txqs:
@@ -497,6 +518,9 @@ int hinic_close(struct net_device *netdev)
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	unsigned int flags;
 
+	/* Disable txq napi firstly to aviod rewaking txq in free_tx_poll */
+	disable_txqs_napi(nic_dev);
+
 	down(&nic_dev->mgmt_lock);
 
 	flags = nic_dev->flags;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index a97498ee6914..2b418b568767 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -745,18 +745,6 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 	return budget;
 }
 
-static void tx_napi_add(struct hinic_txq *txq, int weight)
-{
-	netif_napi_add(txq->netdev, &txq->napi, free_tx_poll, weight);
-	napi_enable(&txq->napi);
-}
-
-static void tx_napi_del(struct hinic_txq *txq)
-{
-	napi_disable(&txq->napi);
-	netif_napi_del(&txq->napi);
-}
-
 static irqreturn_t tx_irq(int irq, void *data)
 {
 	struct hinic_txq *txq = data;
@@ -790,7 +778,7 @@ static int tx_request_irq(struct hinic_txq *txq)
 
 	qp = container_of(sq, struct hinic_qp, sq);
 
-	tx_napi_add(txq, nic_dev->tx_weight);
+	netif_napi_add(txq->netdev, &txq->napi, free_tx_poll, nic_dev->tx_weight);
 
 	hinic_hwdev_msix_set(nic_dev->hwdev, sq->msix_entry,
 			     TX_IRQ_NO_PENDING, TX_IRQ_NO_COALESC,
@@ -807,14 +795,14 @@ static int tx_request_irq(struct hinic_txq *txq)
 	if (err) {
 		netif_err(nic_dev, drv, txq->netdev,
 			  "Failed to set TX interrupt coalescing attribute\n");
-		tx_napi_del(txq);
+		netif_napi_del(&txq->napi);
 		return err;
 	}
 
 	err = request_irq(sq->irq, tx_irq, 0, txq->irq_name, txq);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to request Tx irq\n");
-		tx_napi_del(txq);
+		netif_napi_del(&txq->napi);
 		return err;
 	}
 
@@ -826,7 +814,7 @@ static void tx_free_irq(struct hinic_txq *txq)
 	struct hinic_sq *sq = txq->sq;
 
 	free_irq(sq->irq, txq);
-	tx_napi_del(txq);
+	netif_napi_del(&txq->napi);
 }
 
 /**
-- 
2.17.1

