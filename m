Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596D92F5417
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbhAMU1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:27:10 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:43995 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbhAMU1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:27:10 -0500
Received: from localhost.localdomain ([92.131.99.25])
        by mwinf5d54 with ME
        id GLRJ240030Ys01Y03LRJLM; Wed, 13 Jan 2021 21:25:23 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 13 Jan 2021 21:25:23 +0100
X-ME-IP: 92.131.99.25
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] netxen_nic: switch from 'pci_' to 'dma_' API
Date:   Wed, 13 Jan 2021 21:25:18 +0100
Message-Id: <20210113202519.487672-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'netxen_get_minidump_template()' GFP_KERNEL can
be used because its only caller, ' netxen_setup_minidump(()' already uses
it and no lock is acquired in the between.

When memory is allocated in other function in 'netxen_nic_ctx.c' GFP_KERNEL
can be used because the call chain already uses GFP_KERNEL and no lock is
taken in the between.
The call chain is:
  netxen_nic_attach()
    --> netxen_alloc_sw_resources()          : already uses GFP_KERNEL
    --> netxen_alloc_hw_resources()
      --> nx_fw_cmd_create_rx_ctx()
      --> nx_fw_cmd_create_tx_ctx()

When memory is allocated in 'netxen_init_dummy_dma()' GFP_KERNEL can be
used because its only call chain already uses it and no lock is acquired in
the between.
The call chain is:
  --> netxen_start_firmware
    --> netxen_request_firmware()
      --> request_firmware()
        --> _request_firmware(()
          --> fw_get_filesystem_firmware()
            --> __getname()                  : already uses GFP_KERNEL
    --> netxen_init_dummy_dma()

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
 .../ethernet/qlogic/netxen/netxen_nic_ctx.c   | 83 ++++++++++---------
 .../ethernet/qlogic/netxen/netxen_nic_init.c  | 49 ++++++-----
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 22 ++---
 3 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
index 5e9f8ee99800..2fcbcecb41d1 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -113,7 +113,8 @@ netxen_get_minidump_template(struct netxen_adapter *adapter)
 		return NX_RCODE_INVALID_ARGS;
 	}
 
-	addr = pci_zalloc_consistent(adapter->pdev, size, &md_template_addr);
+	addr = dma_alloc_coherent(&adapter->pdev->dev, size,
+				  &md_template_addr, GFP_KERNEL);
 	if (!addr) {
 		dev_err(&adapter->pdev->dev, "Unable to allocate dmable memory for template.\n");
 		return -ENOMEM;
@@ -133,7 +134,7 @@ netxen_get_minidump_template(struct netxen_adapter *adapter)
 		dev_err(&adapter->pdev->dev, "Failed to get minidump template, err_code : %d, requested_size : %d, actual_size : %d\n",
 			cmd.rsp.cmd, size, cmd.rsp.arg2);
 	}
-	pci_free_consistent(adapter->pdev, size, addr, md_template_addr);
+	dma_free_coherent(&adapter->pdev->dev, size, addr, md_template_addr);
 	return 0;
 }
 
@@ -281,14 +282,14 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	rsp_size =
 		SIZEOF_CARDRSP_RX(nx_cardrsp_rx_ctx_t, nrds_rings, nsds_rings);
 
-	addr = pci_alloc_consistent(adapter->pdev,
-				rq_size, &hostrq_phys_addr);
+	addr = dma_alloc_coherent(&adapter->pdev->dev, rq_size,
+				  &hostrq_phys_addr, GFP_KERNEL);
 	if (addr == NULL)
 		return -ENOMEM;
 	prq = addr;
 
-	addr = pci_alloc_consistent(adapter->pdev,
-			rsp_size, &cardrsp_phys_addr);
+	addr = dma_alloc_coherent(&adapter->pdev->dev, rsp_size,
+				  &cardrsp_phys_addr, GFP_KERNEL);
 	if (addr == NULL) {
 		err = -ENOMEM;
 		goto out_free_rq;
@@ -387,9 +388,10 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	recv_ctx->virt_port = prsp->virt_port;
 
 out_free_rsp:
-	pci_free_consistent(adapter->pdev, rsp_size, prsp, cardrsp_phys_addr);
+	dma_free_coherent(&adapter->pdev->dev, rsp_size, prsp,
+			  cardrsp_phys_addr);
 out_free_rq:
-	pci_free_consistent(adapter->pdev, rq_size, prq, hostrq_phys_addr);
+	dma_free_coherent(&adapter->pdev->dev, rq_size, prq, hostrq_phys_addr);
 	return err;
 }
 
@@ -429,14 +431,14 @@ nx_fw_cmd_create_tx_ctx(struct netxen_adapter *adapter)
 	struct netxen_cmd_args cmd;
 
 	rq_size = SIZEOF_HOSTRQ_TX(nx_hostrq_tx_ctx_t);
-	rq_addr = pci_alloc_consistent(adapter->pdev,
-		rq_size, &rq_phys_addr);
+	rq_addr = dma_alloc_coherent(&adapter->pdev->dev, rq_size,
+				     &rq_phys_addr, GFP_KERNEL);
 	if (!rq_addr)
 		return -ENOMEM;
 
 	rsp_size = SIZEOF_CARDRSP_TX(nx_cardrsp_tx_ctx_t);
-	rsp_addr = pci_alloc_consistent(adapter->pdev,
-		rsp_size, &rsp_phys_addr);
+	rsp_addr = dma_alloc_coherent(&adapter->pdev->dev, rsp_size,
+				      &rsp_phys_addr, GFP_KERNEL);
 	if (!rsp_addr) {
 		err = -ENOMEM;
 		goto out_free_rq;
@@ -491,10 +493,11 @@ nx_fw_cmd_create_tx_ctx(struct netxen_adapter *adapter)
 		err = -EIO;
 	}
 
-	pci_free_consistent(adapter->pdev, rsp_size, rsp_addr, rsp_phys_addr);
+	dma_free_coherent(&adapter->pdev->dev, rsp_size, rsp_addr,
+			  rsp_phys_addr);
 
 out_free_rq:
-	pci_free_consistent(adapter->pdev, rq_size, rq_addr, rq_phys_addr);
+	dma_free_coherent(&adapter->pdev->dev, rq_size, rq_addr, rq_phys_addr);
 
 	return err;
 }
@@ -745,9 +748,9 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 	recv_ctx = &adapter->recv_ctx;
 	tx_ring = adapter->tx_ring;
 
-	addr = pci_alloc_consistent(pdev,
-			sizeof(struct netxen_ring_ctx) + sizeof(uint32_t),
-			&recv_ctx->phys_addr);
+	addr = dma_alloc_coherent(&pdev->dev,
+				  sizeof(struct netxen_ring_ctx) + sizeof(uint32_t),
+				  &recv_ctx->phys_addr, GFP_KERNEL);
 	if (addr == NULL) {
 		dev_err(&pdev->dev, "failed to allocate hw context\n");
 		return -ENOMEM;
@@ -762,8 +765,8 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 		(__le32 *)(((char *)addr) + sizeof(struct netxen_ring_ctx));
 
 	/* cmd desc ring */
-	addr = pci_alloc_consistent(pdev, TX_DESC_RINGSIZE(tx_ring),
-			&tx_ring->phys_addr);
+	addr = dma_alloc_coherent(&pdev->dev, TX_DESC_RINGSIZE(tx_ring),
+				  &tx_ring->phys_addr, GFP_KERNEL);
 
 	if (addr == NULL) {
 		dev_err(&pdev->dev, "%s: failed to allocate tx desc ring\n",
@@ -776,9 +779,9 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 
 	for (ring = 0; ring < adapter->max_rds_rings; ring++) {
 		rds_ring = &recv_ctx->rds_rings[ring];
-		addr = pci_alloc_consistent(adapter->pdev,
-				RCV_DESC_RINGSIZE(rds_ring),
-				&rds_ring->phys_addr);
+		addr = dma_alloc_coherent(&adapter->pdev->dev,
+					  RCV_DESC_RINGSIZE(rds_ring),
+					  &rds_ring->phys_addr, GFP_KERNEL);
 		if (addr == NULL) {
 			dev_err(&pdev->dev,
 				"%s: failed to allocate rds ring [%d]\n",
@@ -797,9 +800,9 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 	for (ring = 0; ring < adapter->max_sds_rings; ring++) {
 		sds_ring = &recv_ctx->sds_rings[ring];
 
-		addr = pci_alloc_consistent(adapter->pdev,
-				STATUS_DESC_RINGSIZE(sds_ring),
-				&sds_ring->phys_addr);
+		addr = dma_alloc_coherent(&adapter->pdev->dev,
+					  STATUS_DESC_RINGSIZE(sds_ring),
+					  &sds_ring->phys_addr, GFP_KERNEL);
 		if (addr == NULL) {
 			dev_err(&pdev->dev,
 				"%s: failed to allocate sds ring [%d]\n",
@@ -874,19 +877,17 @@ void netxen_free_hw_resources(struct netxen_adapter *adapter)
 	recv_ctx = &adapter->recv_ctx;
 
 	if (recv_ctx->hwctx != NULL) {
-		pci_free_consistent(adapter->pdev,
-				sizeof(struct netxen_ring_ctx) +
-				sizeof(uint32_t),
-				recv_ctx->hwctx,
-				recv_ctx->phys_addr);
+		dma_free_coherent(&adapter->pdev->dev,
+				  sizeof(struct netxen_ring_ctx) + sizeof(uint32_t),
+				  recv_ctx->hwctx, recv_ctx->phys_addr);
 		recv_ctx->hwctx = NULL;
 	}
 
 	tx_ring = adapter->tx_ring;
 	if (tx_ring->desc_head != NULL) {
-		pci_free_consistent(adapter->pdev,
-				TX_DESC_RINGSIZE(tx_ring),
-				tx_ring->desc_head, tx_ring->phys_addr);
+		dma_free_coherent(&adapter->pdev->dev,
+				  TX_DESC_RINGSIZE(tx_ring),
+				  tx_ring->desc_head, tx_ring->phys_addr);
 		tx_ring->desc_head = NULL;
 	}
 
@@ -894,10 +895,10 @@ void netxen_free_hw_resources(struct netxen_adapter *adapter)
 		rds_ring = &recv_ctx->rds_rings[ring];
 
 		if (rds_ring->desc_head != NULL) {
-			pci_free_consistent(adapter->pdev,
-					RCV_DESC_RINGSIZE(rds_ring),
-					rds_ring->desc_head,
-					rds_ring->phys_addr);
+			dma_free_coherent(&adapter->pdev->dev,
+					  RCV_DESC_RINGSIZE(rds_ring),
+					  rds_ring->desc_head,
+					  rds_ring->phys_addr);
 			rds_ring->desc_head = NULL;
 		}
 	}
@@ -906,10 +907,10 @@ void netxen_free_hw_resources(struct netxen_adapter *adapter)
 		sds_ring = &recv_ctx->sds_rings[ring];
 
 		if (sds_ring->desc_head != NULL) {
-			pci_free_consistent(adapter->pdev,
-				STATUS_DESC_RINGSIZE(sds_ring),
-				sds_ring->desc_head,
-				sds_ring->phys_addr);
+			dma_free_coherent(&adapter->pdev->dev,
+					  STATUS_DESC_RINGSIZE(sds_ring),
+					  sds_ring->desc_head,
+					  sds_ring->phys_addr);
 			sds_ring->desc_head = NULL;
 		}
 	}
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 94546ed5f867..08f9477d2ee8 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -102,10 +102,8 @@ void netxen_release_rx_buffers(struct netxen_adapter *adapter)
 			rx_buf = &(rds_ring->rx_buf_arr[i]);
 			if (rx_buf->state == NETXEN_BUFFER_FREE)
 				continue;
-			pci_unmap_single(adapter->pdev,
-					rx_buf->dma,
-					rds_ring->dma_size,
-					PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&adapter->pdev->dev, rx_buf->dma,
+					 rds_ring->dma_size, DMA_FROM_DEVICE);
 			if (rx_buf->skb != NULL)
 				dev_kfree_skb_any(rx_buf->skb);
 		}
@@ -124,16 +122,16 @@ void netxen_release_tx_buffers(struct netxen_adapter *adapter)
 	for (i = 0; i < tx_ring->num_desc; i++) {
 		buffrag = cmd_buf->frag_array;
 		if (buffrag->dma) {
-			pci_unmap_single(adapter->pdev, buffrag->dma,
-					 buffrag->length, PCI_DMA_TODEVICE);
+			dma_unmap_single(&adapter->pdev->dev, buffrag->dma,
+					 buffrag->length, DMA_TO_DEVICE);
 			buffrag->dma = 0ULL;
 		}
 		for (j = 1; j < cmd_buf->frag_count; j++) {
 			buffrag++;
 			if (buffrag->dma) {
-				pci_unmap_page(adapter->pdev, buffrag->dma,
-					       buffrag->length,
-					       PCI_DMA_TODEVICE);
+				dma_unmap_page(&adapter->pdev->dev,
+					       buffrag->dma, buffrag->length,
+					       DMA_TO_DEVICE);
 				buffrag->dma = 0ULL;
 			}
 		}
@@ -1250,9 +1248,10 @@ int netxen_init_dummy_dma(struct netxen_adapter *adapter)
 	if (!NX_IS_REVISION_P2(adapter->ahw.revision_id))
 		return 0;
 
-	adapter->dummy_dma.addr = pci_alloc_consistent(adapter->pdev,
-				 NETXEN_HOST_DUMMY_DMA_SIZE,
-				 &adapter->dummy_dma.phys_addr);
+	adapter->dummy_dma.addr = dma_alloc_coherent(&adapter->pdev->dev,
+						     NETXEN_HOST_DUMMY_DMA_SIZE,
+						     &adapter->dummy_dma.phys_addr,
+						     GFP_KERNEL);
 	if (adapter->dummy_dma.addr == NULL) {
 		dev_err(&adapter->pdev->dev,
 			"ERROR: Could not allocate dummy DMA memory\n");
@@ -1304,10 +1303,10 @@ void netxen_free_dummy_dma(struct netxen_adapter *adapter)
 	}
 
 	if (i) {
-		pci_free_consistent(adapter->pdev,
-			    NETXEN_HOST_DUMMY_DMA_SIZE,
-			    adapter->dummy_dma.addr,
-			    adapter->dummy_dma.phys_addr);
+		dma_free_coherent(&adapter->pdev->dev,
+				  NETXEN_HOST_DUMMY_DMA_SIZE,
+				  adapter->dummy_dma.addr,
+				  adapter->dummy_dma.phys_addr);
 		adapter->dummy_dma.addr = NULL;
 	} else
 		dev_err(&adapter->pdev->dev, "dma_watchdog_shutdown failed\n");
@@ -1467,10 +1466,10 @@ netxen_alloc_rx_skb(struct netxen_adapter *adapter,
 	if (!adapter->ahw.cut_through)
 		skb_reserve(skb, 2);
 
-	dma = pci_map_single(pdev, skb->data,
-			rds_ring->dma_size, PCI_DMA_FROMDEVICE);
+	dma = dma_map_single(&pdev->dev, skb->data, rds_ring->dma_size,
+			     DMA_FROM_DEVICE);
 
-	if (pci_dma_mapping_error(pdev, dma)) {
+	if (dma_mapping_error(&pdev->dev, dma)) {
 		dev_kfree_skb_any(skb);
 		buffer->skb = NULL;
 		return 1;
@@ -1491,8 +1490,8 @@ static struct sk_buff *netxen_process_rxbuf(struct netxen_adapter *adapter,
 
 	buffer = &rds_ring->rx_buf_arr[index];
 
-	pci_unmap_single(adapter->pdev, buffer->dma, rds_ring->dma_size,
-			PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&adapter->pdev->dev, buffer->dma, rds_ring->dma_size,
+			 DMA_FROM_DEVICE);
 
 	skb = buffer->skb;
 	if (!skb)
@@ -1754,13 +1753,13 @@ int netxen_process_cmd_ring(struct netxen_adapter *adapter)
 		buffer = &tx_ring->cmd_buf_arr[sw_consumer];
 		if (buffer->skb) {
 			frag = &buffer->frag_array[0];
-			pci_unmap_single(pdev, frag->dma, frag->length,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&pdev->dev, frag->dma, frag->length,
+					 DMA_TO_DEVICE);
 			frag->dma = 0ULL;
 			for (i = 1; i < buffer->frag_count; i++) {
 				frag++;	/* Get the next frag */
-				pci_unmap_page(pdev, frag->dma, frag->length,
-					       PCI_DMA_TODEVICE);
+				dma_unmap_page(&pdev->dev, frag->dma,
+					       frag->length, DMA_TO_DEVICE);
 				frag->dma = 0ULL;
 			}
 
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index d258e0ccf946..1c6620577538 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -243,8 +243,8 @@ static int nx_set_dma_mask(struct netxen_adapter *adapter)
 		cmask = mask;
 	}
 
-	if (pci_set_dma_mask(pdev, mask) == 0 &&
-		pci_set_consistent_dma_mask(pdev, cmask) == 0) {
+	if (dma_set_mask(&pdev->dev, mask) == 0 &&
+	    dma_set_coherent_mask(&pdev->dev, cmask) == 0) {
 		adapter->pci_using_dac = 1;
 		return 0;
 	}
@@ -277,13 +277,13 @@ nx_update_dma_mask(struct netxen_adapter *adapter)
 
 		mask = DMA_BIT_MASK(32+shift);
 
-		err = pci_set_dma_mask(pdev, mask);
+		err = dma_set_mask(&pdev->dev, mask);
 		if (err)
 			goto err_out;
 
 		if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
 
-			err = pci_set_consistent_dma_mask(pdev, mask);
+			err = dma_set_coherent_mask(&pdev->dev, mask);
 			if (err)
 				goto err_out;
 		}
@@ -293,8 +293,8 @@ nx_update_dma_mask(struct netxen_adapter *adapter)
 	return 0;
 
 err_out:
-	pci_set_dma_mask(pdev, old_mask);
-	pci_set_consistent_dma_mask(pdev, old_cmask);
+	dma_set_mask(&pdev->dev, old_mask);
+	dma_set_coherent_mask(&pdev->dev, old_cmask);
 	return err;
 }
 
@@ -1978,9 +1978,9 @@ netxen_map_tx_skb(struct pci_dev *pdev,
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	nf = &pbuf->frag_array[0];
 
-	map = pci_map_single(pdev, skb->data,
-			skb_headlen(skb), PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(pdev, map))
+	map = dma_map_single(&pdev->dev, skb->data, skb_headlen(skb),
+			     DMA_TO_DEVICE);
+	if (dma_mapping_error(&pdev->dev, map))
 		goto out_err;
 
 	nf->dma = map;
@@ -2004,12 +2004,12 @@ netxen_map_tx_skb(struct pci_dev *pdev,
 unwind:
 	while (--i >= 0) {
 		nf = &pbuf->frag_array[i+1];
-		pci_unmap_page(pdev, nf->dma, nf->length, PCI_DMA_TODEVICE);
+		dma_unmap_page(&pdev->dev, nf->dma, nf->length, DMA_TO_DEVICE);
 		nf->dma = 0ULL;
 	}
 
 	nf = &pbuf->frag_array[0];
-	pci_unmap_single(pdev, nf->dma, skb_headlen(skb), PCI_DMA_TODEVICE);
+	dma_unmap_single(&pdev->dev, nf->dma, skb_headlen(skb), DMA_TO_DEVICE);
 	nf->dma = 0ULL;
 
 out_err:
-- 
2.27.0

