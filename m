Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7952C7B5C
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 22:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgK2VTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 16:19:23 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:25464 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgK2VTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 16:19:22 -0500
Received: from localhost.localdomain ([81.185.174.0])
        by mwinf5d27 with ME
        id yMHZ2300B00t0l503MHa4m; Sun, 29 Nov 2020 22:17:37 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 29 Nov 2020 22:17:37 +0100
X-ME-IP: 81.185.174.0
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mlxsw: switch from 'pci_' to 'dma_' API
Date:   Sun, 29 Nov 2020 22:17:33 +0100
Message-Id: <20201129211733.2913-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

he wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'mlxsw_pci_queue_init()' and
'mlxsw_pci_fw_area_init()' GFP_KERNEL can be used because this flag is
already used in the same function.

When memory is allocated in 'mlxsw_pci_mbox_alloc()' GFP_KERNEL can be
used because it is only called from a probe function. The call chain is:
  --> mlxsw_pci_probe
    --> mlxsw_pci_cmd_init
      --> mlxsw_pci_mbox_alloc

@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 52 +++++++++++------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 641cdd81882b..7519d3b6934e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -323,8 +323,8 @@ static int mlxsw_pci_wqe_frag_map(struct mlxsw_pci *mlxsw_pci, char *wqe,
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	dma_addr_t mapaddr;
 
-	mapaddr = pci_map_single(pdev, frag_data, frag_len, direction);
-	if (unlikely(pci_dma_mapping_error(pdev, mapaddr))) {
+	mapaddr = dma_map_single(&pdev->dev, frag_data, frag_len, direction);
+	if (unlikely(dma_mapping_error(&pdev->dev, mapaddr))) {
 		dev_err_ratelimited(&pdev->dev, "failed to dma map tx frag\n");
 		return -EIO;
 	}
@@ -342,7 +342,7 @@ static void mlxsw_pci_wqe_frag_unmap(struct mlxsw_pci *mlxsw_pci, char *wqe,
 
 	if (!frag_len)
 		return;
-	pci_unmap_single(pdev, mapaddr, frag_len, direction);
+	dma_unmap_single(&pdev->dev, mapaddr, frag_len, direction);
 }
 
 static int mlxsw_pci_rdq_skb_alloc(struct mlxsw_pci *mlxsw_pci,
@@ -858,9 +858,9 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		tasklet_setup(&q->tasklet, q_ops->tasklet);
 
 	mem_item->size = MLXSW_PCI_AQ_SIZE;
-	mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
-					     mem_item->size,
-					     &mem_item->mapaddr);
+	mem_item->buf = dma_alloc_coherent(&mlxsw_pci->pdev->dev,
+					   mem_item->size, &mem_item->mapaddr,
+					   GFP_KERNEL);
 	if (!mem_item->buf)
 		return -ENOMEM;
 
@@ -890,8 +890,8 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 err_q_ops_init:
 	kfree(q->elem_info);
 err_elem_info_alloc:
-	pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
-			    mem_item->buf, mem_item->mapaddr);
+	dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
+			  mem_item->buf, mem_item->mapaddr);
 	return err;
 }
 
@@ -903,8 +903,8 @@ static void mlxsw_pci_queue_fini(struct mlxsw_pci *mlxsw_pci,
 
 	q_ops->fini(mlxsw_pci, q);
 	kfree(q->elem_info);
-	pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
-			    mem_item->buf, mem_item->mapaddr);
+	dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
+			  mem_item->buf, mem_item->mapaddr);
 }
 
 static int mlxsw_pci_queue_group_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
@@ -1242,9 +1242,9 @@ static int mlxsw_pci_fw_area_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mem_item = &mlxsw_pci->fw_area.items[i];
 
 		mem_item->size = MLXSW_PCI_PAGE_SIZE;
-		mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
-						     mem_item->size,
-						     &mem_item->mapaddr);
+		mem_item->buf = dma_alloc_coherent(&mlxsw_pci->pdev->dev,
+						   mem_item->size,
+						   &mem_item->mapaddr, GFP_KERNEL);
 		if (!mem_item->buf) {
 			err = -ENOMEM;
 			goto err_alloc;
@@ -1273,8 +1273,8 @@ static int mlxsw_pci_fw_area_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	for (i--; i >= 0; i--) {
 		mem_item = &mlxsw_pci->fw_area.items[i];
 
-		pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
-				    mem_item->buf, mem_item->mapaddr);
+		dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
+				  mem_item->buf, mem_item->mapaddr);
 	}
 	kfree(mlxsw_pci->fw_area.items);
 	return err;
@@ -1290,8 +1290,8 @@ static void mlxsw_pci_fw_area_fini(struct mlxsw_pci *mlxsw_pci)
 	for (i = 0; i < mlxsw_pci->fw_area.count; i++) {
 		mem_item = &mlxsw_pci->fw_area.items[i];
 
-		pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
-				    mem_item->buf, mem_item->mapaddr);
+		dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
+				  mem_item->buf, mem_item->mapaddr);
 	}
 	kfree(mlxsw_pci->fw_area.items);
 }
@@ -1316,8 +1316,8 @@ static int mlxsw_pci_mbox_alloc(struct mlxsw_pci *mlxsw_pci,
 	int err = 0;
 
 	mbox->size = MLXSW_CMD_MBOX_SIZE;
-	mbox->buf = pci_alloc_consistent(pdev, MLXSW_CMD_MBOX_SIZE,
-					 &mbox->mapaddr);
+	mbox->buf = dma_alloc_coherent(&pdev->dev, MLXSW_CMD_MBOX_SIZE,
+				       &mbox->mapaddr, GFP_KERNEL);
 	if (!mbox->buf) {
 		dev_err(&pdev->dev, "Failed allocating memory for mailbox\n");
 		err = -ENOMEM;
@@ -1331,8 +1331,8 @@ static void mlxsw_pci_mbox_free(struct mlxsw_pci *mlxsw_pci,
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 
-	pci_free_consistent(pdev, MLXSW_CMD_MBOX_SIZE, mbox->buf,
-			    mbox->mapaddr);
+	dma_free_coherent(&pdev->dev, MLXSW_CMD_MBOX_SIZE, mbox->buf,
+			  mbox->mapaddr);
 }
 
 static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
@@ -1817,17 +1817,17 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_pci_request_regions;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (!err) {
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err) {
-			dev_err(&pdev->dev, "pci_set_consistent_dma_mask failed\n");
+			dev_err(&pdev->dev, "dma_set_coherent_mask failed\n");
 			goto err_pci_set_dma_mask;
 		}
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
-			dev_err(&pdev->dev, "pci_set_dma_mask failed\n");
+			dev_err(&pdev->dev, "dma_set_mask failed\n");
 			goto err_pci_set_dma_mask;
 		}
 	}
-- 
2.27.0

