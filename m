Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CE3116130
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 09:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfLHImc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 03:42:32 -0500
Received: from mx.sdf.org ([205.166.94.20]:61901 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfLHIma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 03:42:30 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 03:42:29 EST
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id xB88amFK021882
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits) verified NO);
        Sun, 8 Dec 2019 08:36:48 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id xB88amHd015549;
        Sun, 8 Dec 2019 08:36:48 GMT
Date:   Sun, 8 Dec 2019 08:36:48 GMT
From:   George Spelvin <lkml@sdf.org>
Message-Id: <201912080836.xB88amHd015549@sdf.org>
To:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH 2/4] b44: Fix off-by-one error in acceptable address range
Cc:     hauke@hauke-m.de, lkml@sdf.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The requirement is dma_addr + size <= 0x40000000, not 0x3fffffff.

In a logically separate but overlapping change, this patch also
rearranges the logic for detecting failures to use a goto rather
than testing dma_mapping_error() twice.  The latter is expensive if
CONFIG_DMA_API_DEBUG is set, but also for bug-proofing reasons I try to
avoid having the same condition in two places that must be kept in sync.

Signed-off-by: George Spelvin <lkml@sdf.org>
---
 drivers/net/ethernet/broadcom/b44.c | 42 ++++++++++++++++-------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 394671230c1c..e540d5646aef 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -680,12 +680,13 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
-	if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
-		mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
+	if (dma_mapping_error(bp->sdev->dma_dev, mapping))
+		goto workaround;
+	if (mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)+1) {
 		/* Sigh... */
-		if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
-			dma_unmap_single(bp->sdev->dma_dev, mapping,
-					     RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
+		dma_unmap_single(bp->sdev->dma_dev, mapping,
+				 RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
+workaround:
 		dev_kfree_skb_any(skb);
 		skb = alloc_skb(RX_PKT_BUF_SZ, GFP_ATOMIC | GFP_DMA);
 		if (skb == NULL)
@@ -693,10 +694,12 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 		mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
 					 RX_PKT_BUF_SZ,
 					 DMA_FROM_DEVICE);
-		if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
-		    mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
-			if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
-				dma_unmap_single(bp->sdev->dma_dev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
+		if (dma_mapping_error(bp->sdev->dma_dev, mapping))
+			goto failed;
+		if (mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)+1) {
+			dma_unmap_single(bp->sdev->dma_dev, mapping,
+					 RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
+failed:
 			dev_kfree_skb_any(skb);
 			return -ENOMEM;
 		}
@@ -990,24 +993,27 @@ static netdev_tx_t b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	mapping = dma_map_single_attrs(bp->sdev->dma_dev, skb->data, len,
 				       DMA_TO_DEVICE, DMA_ATTR_NO_WARN);
-	if (dma_mapping_error(bp->sdev->dma_dev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
+	if (dma_mapping_error(bp->sdev->dma_dev, mapping))
+	       goto workaround;
+	if (mapping + len > DMA_BIT_MASK(30)+1) {
 		struct sk_buff *bounce_skb;
 
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
-		if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
-			dma_unmap_single(bp->sdev->dma_dev, mapping, len,
-					     DMA_TO_DEVICE);
-
+		dma_unmap_single(bp->sdev->dma_dev, mapping, len,
+				 DMA_TO_DEVICE);
+workaround:
 		bounce_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb)
 			goto err_out;
 
 		mapping = dma_map_single(bp->sdev->dma_dev, bounce_skb->data,
 					 len, DMA_TO_DEVICE);
-		if (dma_mapping_error(bp->sdev->dma_dev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
-			if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
-				dma_unmap_single(bp->sdev->dma_dev, mapping,
-						     len, DMA_TO_DEVICE);
+		if (dma_mapping_error(bp->sdev->dma_dev, mapping))
+		       goto failed;
+		if (mapping + len > DMA_BIT_MASK(30)+1) {
+			dma_unmap_single(bp->sdev->dma_dev, mapping, len,
+					 DMA_TO_DEVICE);
+failed:
 			dev_kfree_skb_any(bounce_skb);
 			goto err_out;
 		}
-- 
2.24.0
