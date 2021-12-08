Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92646CBCE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhLHEBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:01:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42798 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhLHEBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:01:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B827EB81F5A;
        Wed,  8 Dec 2021 03:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E44EC00446;
        Wed,  8 Dec 2021 03:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638935861;
        bh=FtjpWZPJVoluMWs2mk5gq8BR40ZCBd76O6gXfop4EcA=;
        h=Date:From:To:Cc:Subject:From;
        b=iyPzdfvs9bnulUL4iH6H0goZDGQLG42pCkWpK0Diq9uRrbkxklaBjxH3Nv7O6jC9j
         6cUFDI8DrR7nW2/DhI3N4CtUeS3Xhi3QNnae64vxBlDoPNbbZtl6PjbVRSEh3v3hUT
         x2pRvTB5m0xoz5zaQgH9EG+UQuYPGYBwDZt27iQ8AXs7IVf4g/C/if/L/MSnWM27Um
         Xehj1tgS9cGVgzjg2t1sE0S/QaVttyu3dVOj8L0tKncFMZYDXiR6SOJUzuYIoW0RXY
         mzX1ks+EghL5C8i5d8RZQwE99nHCqpgHvo5d7qIFemOxpbSRu3pLbcYiuWfBidFcQg
         YnBOzPUoFyqUg==
Date:   Tue, 7 Dec 2021 22:03:11 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: huawei: hinic: Use devm_kcalloc() instead of
 devm_kzalloc()
Message-ID: <20211208040311.GA169838@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor multiplication argument form devm_kcalloc() instead
of devm_kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 .../ethernet/huawei/hinic/hinic_hw_api_cmd.c  |  5 ++--
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 10 ++++----
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  5 ++--
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  9 ++++----
 .../net/ethernet/huawei/hinic/hinic_hw_wq.c   | 23 +++++++++----------
 .../net/ethernet/huawei/hinic/hinic_main.c    | 10 ++++----
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  9 ++++----
 7 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
index 06586173add7..998717f02136 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
@@ -814,7 +814,6 @@ static int api_chain_init(struct hinic_api_cmd_chain *chain,
 {
 	struct hinic_hwif *hwif = attr->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	size_t cell_ctxt_size;
 
 	chain->hwif = hwif;
 	chain->chain_type  = attr->chain_type;
@@ -826,8 +825,8 @@ static int api_chain_init(struct hinic_api_cmd_chain *chain,
 
 	sema_init(&chain->sem, 1);
 
-	cell_ctxt_size = chain->num_cells * sizeof(*chain->cell_ctxt);
-	chain->cell_ctxt = devm_kzalloc(&pdev->dev, cell_ctxt_size, GFP_KERNEL);
+	chain->cell_ctxt = devm_kcalloc(&pdev->dev, chain->num_cells,
+					sizeof(*chain->cell_ctxt), GFP_KERNEL);
 	if (!chain->cell_ctxt)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 307a6d4af993..a627237f694b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -796,11 +796,10 @@ static int init_cmdqs_ctxt(struct hinic_hwdev *hwdev,
 	struct hinic_cmdq_ctxt *cmdq_ctxts;
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
-	size_t cmdq_ctxts_size;
 	int err;
 
-	cmdq_ctxts_size = HINIC_MAX_CMDQ_TYPES * sizeof(*cmdq_ctxts);
-	cmdq_ctxts = devm_kzalloc(&pdev->dev, cmdq_ctxts_size, GFP_KERNEL);
+	cmdq_ctxts = devm_kcalloc(&pdev->dev, HINIC_MAX_CMDQ_TYPES,
+				  sizeof(*cmdq_ctxts), GFP_KERNEL);
 	if (!cmdq_ctxts)
 		return -ENOMEM;
 
@@ -884,7 +883,6 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 	struct hinic_func_to_io *func_to_io = cmdqs_to_func_to_io(cmdqs);
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_hwdev *hwdev;
-	size_t saved_wqs_size;
 	u16 max_wqe_size;
 	int err;
 
@@ -895,8 +893,8 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 	if (!cmdqs->cmdq_buf_pool)
 		return -ENOMEM;
 
-	saved_wqs_size = HINIC_MAX_CMDQ_TYPES * sizeof(struct hinic_wq);
-	cmdqs->saved_wqs = devm_kzalloc(&pdev->dev, saved_wqs_size, GFP_KERNEL);
+	cmdqs->saved_wqs = devm_kcalloc(&pdev->dev, HINIC_MAX_CMDQ_TYPES,
+					sizeof(*cmdqs->saved_wqs), GFP_KERNEL);
 	if (!cmdqs->saved_wqs) {
 		err = -ENOMEM;
 		goto err_saved_wqs;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 657a15447bd0..2127a48749a8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -162,7 +162,6 @@ static int init_msix(struct hinic_hwdev *hwdev)
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	int nr_irqs, num_aeqs, num_ceqs;
-	size_t msix_entries_size;
 	int i, err;
 
 	num_aeqs = HINIC_HWIF_NUM_AEQS(hwif);
@@ -171,8 +170,8 @@ static int init_msix(struct hinic_hwdev *hwdev)
 	if (nr_irqs > HINIC_HWIF_NUM_IRQS(hwif))
 		nr_irqs = HINIC_HWIF_NUM_IRQS(hwif);
 
-	msix_entries_size = nr_irqs * sizeof(*hwdev->msix_entries);
-	hwdev->msix_entries = devm_kzalloc(&pdev->dev, msix_entries_size,
+	hwdev->msix_entries = devm_kcalloc(&pdev->dev, nr_irqs,
+					   sizeof(*hwdev->msix_entries),
 					   GFP_KERNEL);
 	if (!hwdev->msix_entries)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index d3fc05a07fdb..045c47786a04 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -631,16 +631,15 @@ static int alloc_eq_pages(struct hinic_eq *eq)
 	struct hinic_hwif *hwif = eq->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	u32 init_val, addr, val;
-	size_t addr_size;
 	int err, pg;
 
-	addr_size = eq->num_pages * sizeof(*eq->dma_addr);
-	eq->dma_addr = devm_kzalloc(&pdev->dev, addr_size, GFP_KERNEL);
+	eq->dma_addr = devm_kcalloc(&pdev->dev, eq->num_pages,
+				    sizeof(*eq->dma_addr), GFP_KERNEL);
 	if (!eq->dma_addr)
 		return -ENOMEM;
 
-	addr_size = eq->num_pages * sizeof(*eq->virt_addr);
-	eq->virt_addr = devm_kzalloc(&pdev->dev, addr_size, GFP_KERNEL);
+	eq->virt_addr = devm_kcalloc(&pdev->dev, eq->num_pages,
+				     sizeof(*eq->virt_addr), GFP_KERNEL);
 	if (!eq->virt_addr) {
 		err = -ENOMEM;
 		goto err_virt_addr_alloc;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index 7f0f1aa3cedd..2d9b06d7caad 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -193,20 +193,20 @@ static int alloc_page_arrays(struct hinic_wqs *wqs)
 {
 	struct hinic_hwif *hwif = wqs->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	size_t size;
 
-	size = wqs->num_pages * sizeof(*wqs->page_paddr);
-	wqs->page_paddr = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	wqs->page_paddr = devm_kcalloc(&pdev->dev, wqs->num_pages,
+				       sizeof(*wqs->page_paddr), GFP_KERNEL);
 	if (!wqs->page_paddr)
 		return -ENOMEM;
 
-	size = wqs->num_pages * sizeof(*wqs->page_vaddr);
-	wqs->page_vaddr = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	wqs->page_vaddr = devm_kcalloc(&pdev->dev, wqs->num_pages,
+				       sizeof(*wqs->page_vaddr), GFP_KERNEL);
 	if (!wqs->page_vaddr)
 		goto err_page_vaddr;
 
-	size = wqs->num_pages * sizeof(*wqs->shadow_page_vaddr);
-	wqs->shadow_page_vaddr = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	wqs->shadow_page_vaddr = devm_kcalloc(&pdev->dev, wqs->num_pages,
+					      sizeof(*wqs->shadow_page_vaddr),
+					      GFP_KERNEL);
 	if (!wqs->shadow_page_vaddr)
 		goto err_page_shadow_vaddr;
 
@@ -379,15 +379,14 @@ static int alloc_wqes_shadow(struct hinic_wq *wq)
 {
 	struct hinic_hwif *hwif = wq->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	size_t size;
 
-	size = wq->num_q_pages * wq->max_wqe_size;
-	wq->shadow_wqe = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	wq->shadow_wqe = devm_kcalloc(&pdev->dev, wq->num_q_pages,
+				      wq->max_wqe_size, GFP_KERNEL);
 	if (!wq->shadow_wqe)
 		return -ENOMEM;
 
-	size = wq->num_q_pages * sizeof(wq->prod_idx);
-	wq->shadow_idx = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	wq->shadow_idx = devm_kcalloc(&pdev->dev, wq->num_q_pages,
+				      sizeof(wq->prod_idx), GFP_KERNEL);
 	if (!wq->shadow_idx)
 		goto err_shadow_idx;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index f9a766b8ac43..1e1b1be86174 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -144,13 +144,12 @@ static int create_txqs(struct hinic_dev *nic_dev)
 {
 	int err, i, j, num_txqs = hinic_hwdev_num_qps(nic_dev->hwdev);
 	struct net_device *netdev = nic_dev->netdev;
-	size_t txq_size;
 
 	if (nic_dev->txqs)
 		return -EINVAL;
 
-	txq_size = num_txqs * sizeof(*nic_dev->txqs);
-	nic_dev->txqs = devm_kzalloc(&netdev->dev, txq_size, GFP_KERNEL);
+	nic_dev->txqs = devm_kcalloc(&netdev->dev, num_txqs,
+				     sizeof(*nic_dev->txqs), GFP_KERNEL);
 	if (!nic_dev->txqs)
 		return -ENOMEM;
 
@@ -241,13 +240,12 @@ static int create_rxqs(struct hinic_dev *nic_dev)
 {
 	int err, i, j, num_rxqs = hinic_hwdev_num_qps(nic_dev->hwdev);
 	struct net_device *netdev = nic_dev->netdev;
-	size_t rxq_size;
 
 	if (nic_dev->rxqs)
 		return -EINVAL;
 
-	rxq_size = num_rxqs * sizeof(*nic_dev->rxqs);
-	nic_dev->rxqs = devm_kzalloc(&netdev->dev, rxq_size, GFP_KERNEL);
+	nic_dev->rxqs = devm_kcalloc(&netdev->dev, num_rxqs,
+				     sizeof(*nic_dev->rxqs), GFP_KERNEL);
 	if (!nic_dev->rxqs)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index c5bdb0d374ef..a984a7a6dd2e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -862,7 +862,6 @@ int hinic_init_txq(struct hinic_txq *txq, struct hinic_sq *sq,
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	int err, irqname_len;
-	size_t sges_size;
 
 	txq->netdev = netdev;
 	txq->sq = sq;
@@ -871,13 +870,13 @@ int hinic_init_txq(struct hinic_txq *txq, struct hinic_sq *sq,
 
 	txq->max_sges = HINIC_MAX_SQ_BUFDESCS;
 
-	sges_size = txq->max_sges * sizeof(*txq->sges);
-	txq->sges = devm_kzalloc(&netdev->dev, sges_size, GFP_KERNEL);
+	txq->sges = devm_kcalloc(&netdev->dev, txq->max_sges,
+				 sizeof(*txq->sges), GFP_KERNEL);
 	if (!txq->sges)
 		return -ENOMEM;
 
-	sges_size = txq->max_sges * sizeof(*txq->free_sges);
-	txq->free_sges = devm_kzalloc(&netdev->dev, sges_size, GFP_KERNEL);
+	txq->free_sges = devm_kcalloc(&netdev->dev, txq->max_sges,
+				      sizeof(*txq->free_sges), GFP_KERNEL);
 	if (!txq->free_sges) {
 		err = -ENOMEM;
 		goto err_alloc_free_sges;
-- 
2.27.0

