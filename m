Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8223C3D82
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 16:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhGKPCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 11:02:01 -0400
Received: from out07.smtpout.orange.fr ([193.252.22.91]:53854 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234200AbhGKPB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 11:01:59 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jul 2021 11:01:59 EDT
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d67 with ME
        id Tqrb2500921Fzsu03qrbGm; Sun, 11 Jul 2021 16:51:39 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 11 Jul 2021 16:51:39 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: wwan: iosm: switch from 'pci_' to 'dma_' API
Date:   Sun, 11 Jul 2021 16:51:33 +0200
Message-Id: <dd34ecd3c8afe5a9a29e026035a4a11c63e033ae.1626014972.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'ipc_protocol_init()' GFP_KERNEL can be used
because this flag is already used a few lines above and no lock is
acquired in the between.

When memory is allocated in 'ipc_protocol_msg_prepipe_open()' GFP_ATOMIC
should be used because this flag is already used a few lines above.

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

When memory is allocated in 'ipc_protocol_msg_prepipe_open()', I think
that GFP_KERNEL could be used, but I've not dug enough to be sure. So,
better safe that sorry.
---
 drivers/net/wwan/iosm/iosm_ipc_protocol.c     | 10 +++++-----
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol.c b/drivers/net/wwan/iosm/iosm_ipc_protocol.c
index 834d8b146a94..63fc7012f09f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol.c
@@ -239,9 +239,9 @@ struct iosm_protocol *ipc_protocol_init(struct iosm_imem *ipc_imem)
 	ipc_protocol->old_msg_tail = 0;
 
 	ipc_protocol->p_ap_shm =
-		pci_alloc_consistent(ipc_protocol->pcie->pci,
-				     sizeof(*ipc_protocol->p_ap_shm),
-				     &ipc_protocol->phy_ap_shm);
+		dma_alloc_coherent(&ipc_protocol->pcie->pci->dev,
+				   sizeof(*ipc_protocol->p_ap_shm),
+				   &ipc_protocol->phy_ap_shm, GFP_KERNEL);
 
 	if (!ipc_protocol->p_ap_shm) {
 		dev_err(ipc_protocol->dev, "pci shm alloc error");
@@ -275,8 +275,8 @@ struct iosm_protocol *ipc_protocol_init(struct iosm_imem *ipc_imem)
 
 void ipc_protocol_deinit(struct iosm_protocol *proto)
 {
-	pci_free_consistent(proto->pcie->pci, sizeof(*proto->p_ap_shm),
-			    proto->p_ap_shm, proto->phy_ap_shm);
+	dma_free_coherent(&proto->pcie->pci->dev, sizeof(*proto->p_ap_shm),
+			  proto->p_ap_shm, proto->phy_ap_shm);
 
 	ipc_pm_deinit(proto);
 	kfree(proto);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index 91109e27efd3..a53ad97abb98 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -74,9 +74,9 @@ static int ipc_protocol_msg_prepipe_open(struct iosm_protocol *ipc_protocol,
 		return -ENOMEM;
 
 	/* Allocate the transfer descriptors for the pipe. */
-	tdr = pci_alloc_consistent(ipc_protocol->pcie->pci,
-				   pipe->nr_of_entries * sizeof(*tdr),
-				   &pipe->phy_tdr_start);
+	tdr = dma_alloc_coherent(&ipc_protocol->pcie->pci->dev,
+				 pipe->nr_of_entries * sizeof(*tdr),
+				 &pipe->phy_tdr_start, GFP_ATOMIC);
 	if (!tdr) {
 		kfree(skbr);
 		dev_err(ipc_protocol->dev, "tdr alloc error");
@@ -492,10 +492,9 @@ void ipc_protocol_pipe_cleanup(struct iosm_protocol *ipc_protocol,
 
 	/* Free and reset the td and skbuf circular buffers. kfree is save! */
 	if (pipe->tdr_start) {
-		pci_free_consistent(ipc_protocol->pcie->pci,
-				    sizeof(*pipe->tdr_start) *
-					    pipe->nr_of_entries,
-				    pipe->tdr_start, pipe->phy_tdr_start);
+		dma_free_coherent(&ipc_protocol->pcie->pci->dev,
+				  sizeof(*pipe->tdr_start) * pipe->nr_of_entries,
+				  pipe->tdr_start, pipe->phy_tdr_start);
 
 		pipe->tdr_start = NULL;
 	}
-- 
2.30.2

