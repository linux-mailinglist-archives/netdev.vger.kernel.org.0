Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE92BBE25
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 10:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgKUJDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 04:03:16 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:17856 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKUJDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 04:03:15 -0500
Received: from localhost.localdomain ([81.185.161.242])
        by mwinf5d61 with ME
        id ux32230075E5lq903x32df; Sat, 21 Nov 2020 10:03:11 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 21 Nov 2020 10:03:11 +0100
X-ME-IP: 81.185.161.242
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, kaixuxia@tencent.com,
        mhabets@solarflare.com, mst@redhat.com,
        luc.vanoostenryck@gmail.com, jesse.brandeburg@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] net: pch_gbe: Use dma_set_mask_and_coherent to simplify code
Date:   Sat, 21 Nov 2020 10:03:02 +0100
Message-Id: <20201121090302.1332491-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'pci_set_dma_mask()' + 'pci_set_consistent_dma_mask()' can be replaced by
an equivalent 'dma_set_mask_and_coherent()' which is much less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index b9e32e4478a8..8e4255efe829 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2502,17 +2502,11 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
-		|| pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (ret) {
-			ret = pci_set_consistent_dma_mask(pdev,
-							  DMA_BIT_MASK(32));
-			if (ret) {
-				dev_err(&pdev->dev, "ERR: No usable DMA "
-					"configuration, aborting\n");
-				return ret;
-			}
+			dev_err(&pdev->dev, "ERR: No usable DMA configuration, aborting\n");
+			return ret;
 		}
 	}
 
-- 
2.27.0

