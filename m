Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E03341612
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 07:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhCSGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 02:41:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13992 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbhCSGkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 02:40:33 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F1vNm250DzrYNN;
        Fri, 19 Mar 2021 14:38:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 14:40:21 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/4] net: hinic: Remove unnecessary 'out of memory' message
Date:   Fri, 19 Mar 2021 14:36:22 +0800
Message-ID: <1616135785-122085-2-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
References: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes unnecessary out of memory message in hinic driver,
fixes the following checkpatch.pl warning:
"WARNING: Possible unnecessary 'out of memory' message"

Signed-off-by: Daode Huang <huangdaode@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c | 8 ++------
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c    | 5 +----
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c      | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         | 8 ++------
 4 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
index 4e4029d..0658617 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
@@ -629,10 +629,8 @@ static int alloc_cmd_buf(struct hinic_api_cmd_chain *chain,
 
 	cmd_vaddr = dma_alloc_coherent(&pdev->dev, API_CMD_BUF_SIZE,
 				       &cmd_paddr, GFP_KERNEL);
-	if (!cmd_vaddr) {
-		dev_err(&pdev->dev, "Failed to allocate API CMD DMA memory\n");
+	if (!cmd_vaddr)
 		return -ENOMEM;
-	}
 
 	cell_ctxt = &chain->cell_ctxt[cell_idx];
 
@@ -679,10 +677,8 @@ static int api_cmd_create_cell(struct hinic_api_cmd_chain *chain,
 
 	node = dma_alloc_coherent(&pdev->dev, chain->cell_size, &node_paddr,
 				  GFP_KERNEL);
-	if (!node) {
-		dev_err(&pdev->dev, "Failed to allocate dma API CMD cell\n");
+	if (!node)
 		return -ENOMEM;
-	}
 
 	node->read.hw_wb_resp_paddr = 0;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 819fa13..6b9b94a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -443,15 +443,12 @@ static void mgmt_recv_msg_handler(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	struct pci_dev *pdev = pf_to_mgmt->hwif->pdev;
 
 	mgmt_work = kzalloc(sizeof(*mgmt_work), GFP_KERNEL);
-	if (!mgmt_work) {
-		dev_err(&pdev->dev, "Allocate mgmt work memory failed\n");
+	if (!mgmt_work)
 		return;
-	}
 
 	if (recv_msg->msg_len) {
 		mgmt_work->msg = kzalloc(recv_msg->msg_len, GFP_KERNEL);
 		if (!mgmt_work->msg) {
-			dev_err(&pdev->dev, "Allocate mgmt msg memory failed\n");
 			kfree(mgmt_work);
 			return;
 		}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
index fcf7bfe..dcba4d0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
@@ -414,7 +414,6 @@ int hinic_init_rq(struct hinic_rq *rq, struct hinic_hwif *hwif,
 	rq->pi_virt_addr = dma_alloc_coherent(&pdev->dev, pi_size,
 					      &rq->pi_dma_addr, GFP_KERNEL);
 	if (!rq->pi_virt_addr) {
-		dev_err(&pdev->dev, "Failed to allocate PI address\n");
 		err = -ENOMEM;
 		goto err_pi_virt;
 	}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 070a7cc..cce0864 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -137,10 +137,8 @@ static struct sk_buff *rx_alloc_skb(struct hinic_rxq *rxq,
 	int err;
 
 	skb = netdev_alloc_skb_ip_align(rxq->netdev, rxq->rq->buf_sz);
-	if (!skb) {
-		netdev_err(rxq->netdev, "Failed to allocate Rx SKB\n");
+	if (!skb)
 		return NULL;
-	}
 
 	addr = dma_map_single(&pdev->dev, skb->data, rxq->rq->buf_sz,
 			      DMA_FROM_DEVICE);
@@ -212,10 +210,8 @@ static int rx_alloc_pkts(struct hinic_rxq *rxq)
 
 	for (i = 0; i < free_wqebbs; i++) {
 		skb = rx_alloc_skb(rxq, &dma_addr);
-		if (!skb) {
-			netdev_err(rxq->netdev, "Failed to alloc Rx skb\n");
+		if (!skb)
 			goto skb_out;
-		}
 
 		hinic_set_sge(&sge, dma_addr, skb->len);
 
-- 
2.8.1

