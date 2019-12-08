Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAF9116131
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 09:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfLHIm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 03:42:29 -0500
Received: from mx.sdf.org ([205.166.94.20]:61901 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfLHIm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 03:42:29 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 03:42:29 EST
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id xB88cS5H025057
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits) verified NO);
        Sun, 8 Dec 2019 08:38:28 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id xB88cSTa015147;
        Sun, 8 Dec 2019 08:38:28 GMT
Date:   Sun, 8 Dec 2019 08:38:28 GMT
From:   George Spelvin <lkml@sdf.org>
Message-Id: <201912080838.xB88cSTa015147@sdf.org>
To:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH 3/4] b44: Unmap DMA ring buffers before kfree
Cc:     hauke@hauke-m.de, lkml@sdf.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's an unlikely error path during initialization, but let's
not leak DMA mappings.

Also the condition for an unacceptable mapping is corrected from
dma_addr + len > 0x3fffffff to dma_addr + len > 0x40000000, as in
the previous patch.

Signed-off-by: George Spelvin <lkml@sdf.org>
---
 drivers/net/ethernet/broadcom/b44.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index e540d5646aef..90e25a1f284f 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1226,8 +1226,12 @@ static int b44_alloc_consistent(struct b44 *bp, gfp_t gfp)
 					     DMA_TABLE_BYTES,
 					     DMA_BIDIRECTIONAL);
 
-		if (dma_mapping_error(bp->sdev->dma_dev, rx_ring_dma) ||
-			rx_ring_dma + size > DMA_BIT_MASK(30)) {
+		if (dma_mapping_error(bp->sdev->dma_dev, rx_ring_dma))
+			goto rx_failed;
+		if (rx_ring_dma + size > DMA_BIT_MASK(30)+1) {
+			dma_unmap_single(bp->sdev->dma_dev, rx_ring_dma,
+					 DMA_TABLE_BYTES, DMA_BIDIRECTIONAL);
+rx_failed:
 			kfree(rx_ring);
 			goto out_err;
 		}
@@ -1254,8 +1258,12 @@ static int b44_alloc_consistent(struct b44 *bp, gfp_t gfp)
 					     DMA_TABLE_BYTES,
 					     DMA_TO_DEVICE);
 
-		if (dma_mapping_error(bp->sdev->dma_dev, tx_ring_dma) ||
-			tx_ring_dma + size > DMA_BIT_MASK(30)) {
+		if (dma_mapping_error(bp->sdev->dma_dev, tx_ring_dma))
+			goto tx_failed;
+		if (tx_ring_dma + size > DMA_BIT_MASK(30)+1) {
+			dma_unmap_single(bp->sdev->dma_dev, tx_ring_dma,
+					 DMA_TABLE_BYTES, DMA_TO_DEVICE);
+tx_failed:
 			kfree(tx_ring);
 			goto out_err;
 		}
-- 
2.24.0
