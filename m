Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4985226F91B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIRJWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:22:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgIRJWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:22:08 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6238588FCF4E78924EC0;
        Fri, 18 Sep 2020 17:22:06 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 17:21:59 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <zengweiliang.zengweiliang@huawei.com>
Subject: [PATCH net-next] hinic: modify irq name
Date:   Fri, 18 Sep 2020 17:23:22 +0800
Message-ID: <20200918092322.3058-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make a distinction between different irqs by netdev name or pci name.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c | 15 +++++++++------
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_rx.c     |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c     |  4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 05018562222f..f108b0c9228e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -793,12 +793,15 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 			    HINIC_EQ_MSIX_LLI_CREDIT_LIMIT_DEFAULT,
 			    HINIC_EQ_MSIX_RESEND_TIMER_DEFAULT);
 
-	if (type == HINIC_AEQ)
-		err = request_irq(entry.vector, aeq_interrupt, 0,
-				  "hinic_aeq", eq);
-	else if (type == HINIC_CEQ)
-		err = request_irq(entry.vector, ceq_interrupt, 0,
-				  "hinic_ceq", eq);
+	if (type == HINIC_AEQ) {
+		snprintf(eq->irq_name, sizeof(eq->irq_name), "hinic_aeq%d@pci:%s", eq->q_id,
+			 pci_name(pdev));
+		err = request_irq(entry.vector, aeq_interrupt, 0, eq->irq_name, eq);
+	} else if (type == HINIC_CEQ) {
+		snprintf(eq->irq_name, sizeof(eq->irq_name), "hinic_ceq%d@pci:%s", eq->q_id,
+			 pci_name(pdev));
+		err = request_irq(entry.vector, ceq_interrupt, 0, eq->irq_name, eq);
+	}
 
 	if (err) {
 		dev_err(&pdev->dev, "Failed to request irq for the EQ\n");
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
index 43065fc70869..2f3222174fc7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
@@ -186,6 +186,7 @@ struct hinic_eq {
 	int                     num_elem_in_pg;
 
 	struct msix_entry       msix_entry;
+	char			irq_name[64];
 
 	dma_addr_t              *dma_addr;
 	void                    **virt_addr;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 5bee951fe9d4..f403a6711e97 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -588,7 +588,7 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
 	rxq_stats_init(rxq);
 
 	rxq->irq_name = devm_kasprintf(&netdev->dev, GFP_KERNEL,
-				       "hinic_rxq%d", qp->q_id);
+				       "%s_rxq%d", netdev->name, qp->q_id);
 	if (!rxq->irq_name)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 502f00e1e2d0..c249b7e6e432 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -894,14 +894,14 @@ int hinic_init_txq(struct hinic_txq *txq, struct hinic_sq *sq,
 		goto err_alloc_free_sges;
 	}
 
-	irqname_len = snprintf(NULL, 0, "hinic_txq%d", qp->q_id) + 1;
+	irqname_len = snprintf(NULL, 0, "%s_txq%d", netdev->name, qp->q_id) + 1;
 	txq->irq_name = devm_kzalloc(&netdev->dev, irqname_len, GFP_KERNEL);
 	if (!txq->irq_name) {
 		err = -ENOMEM;
 		goto err_alloc_irqname;
 	}
 
-	sprintf(txq->irq_name, "hinic_txq%d", qp->q_id);
+	sprintf(txq->irq_name, "%s_txq%d", netdev->name, qp->q_id);
 
 	err = hinic_hwdev_hw_ci_addr_set(hwdev, sq, CI_UPDATE_NO_PENDING,
 					 CI_UPDATE_NO_COALESC);
-- 
2.17.1

