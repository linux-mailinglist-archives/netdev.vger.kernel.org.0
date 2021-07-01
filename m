Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F403B97B8
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhGAUn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:43:58 -0400
Received: from out02.smtpout.orange.fr ([193.252.22.211]:47328 "EHLO
        out.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhGAUn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:43:57 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d15 with ME
        id PwhP2500U21Fzsu03whQxr; Thu, 01 Jul 2021 22:41:24 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 01 Jul 2021 22:41:24 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next v2] gve: Simplify code and axe the use of a deprecated API
Date:   Thu,  1 Jul 2021 22:41:19 +0200
Message-Id: <a8ff6511e4740cff2bb549708b98fb1e6dd7e070.1625172036.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

Replace 'pci_set_dma_mask/pci_set_consistent_dma_mask' by an equivalent
and less verbose 'dma_set_mask_and_coherent()' call.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4

v2: Unchanged
    This patch was previously 3/3 of a serie
---
 drivers/net/ethernet/google/gve/gve_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index c03984b26db4..099a2bc5ae67 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1477,19 +1477,12 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
 		goto abort_with_pci_region;
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (err) {
-		dev_err(&pdev->dev,
-			"Failed to set consistent dma mask: err=%d\n", err);
-		goto abort_with_pci_region;
-	}
-
 	reg_bar = pci_iomap(pdev, GVE_REGISTER_BAR, 0);
 	if (!reg_bar) {
 		dev_err(&pdev->dev, "Failed to map pci bar!\n");
-- 
2.30.2

