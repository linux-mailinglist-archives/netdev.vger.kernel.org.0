Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A197A116132
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 09:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfLHImc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 03:42:32 -0500
Received: from mx.sdf.org ([205.166.94.20]:61901 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfLHIm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 03:42:29 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 03:42:29 EST
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id xB88Z7e1023442
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits) verified NO);
        Sun, 8 Dec 2019 08:35:07 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id xB88Z74s014619;
        Sun, 8 Dec 2019 08:35:07 GMT
Date:   Sun, 8 Dec 2019 08:35:07 GMT
From:   George Spelvin <lkml@sdf.org>
Message-Id: <201912080835.xB88Z74s014619@sdf.org>
To:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH 1/4] b44: Add DMA_ATTR_NO_WARN to dma_map_single attempts
Cc:     hauke@hauke-m.de, lkml@sdf.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The b44 family of fast ethernet chips have a hardware bug limiting
DMA to the low 30 bits of address space.  The driver implements its
own bouncing through ZONE_DMA if buffers are outside this range,
but not before the DMA layer tries the SWIOTLB driver for help.

The latter is designed only for helping devices with a 32-bit DMA
restriction, is not even initialized on machines with < 4GB of RAM,
and proceeds to spam the log with:

b44 0000:02:00.0: swiotlb buffer is full (sz: 66 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 72 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 401 bytes), total 0 (slots), used 0 (slots)
swiotlb_tbl_map_single: 7 callbacks suppressed
b44 0000:02:00.0: swiotlb buffer is full (sz: 90 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 74 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 74 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 74 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 66 bytes), total 0 (slots), used 0 (slots)
b44 0000:02:00.0: swiotlb buffer is full (sz: 426 bytes), total 0 (slots), used 0 (slots)

DMA_ATTR_NO_WARN on the first (non-ZONE_DMA) attempt turns off this
repeated complaint.

There still is a remaining bug: kernel/dma/direct.c:report_addr() throws
a WARN_ON_ONCE the first time this happens.  I'm less certain how to fix
that, but it's less annoying.

Signed-off-by: George Spelvin <lkml@sdf.org>
---
 drivers/net/ethernet/broadcom/b44.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

This is the only substantive patch in the series.  The other three are
relatively minor issues that I ran into while studying the surrounding
code.  (Although #3/4 actually fixes a resource leak.)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 97ab0dd25552..394671230c1c 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -674,9 +674,9 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 	if (skb == NULL)
 		return -ENOMEM;
 
-	mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
-				 RX_PKT_BUF_SZ,
-				 DMA_FROM_DEVICE);
+	mapping = dma_map_single_attrs(bp->sdev->dma_dev, skb->data,
+				       RX_PKT_BUF_SZ, DMA_FROM_DEVICE,
+				       DMA_ATTR_NO_WARN);
 
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
@@ -988,7 +988,8 @@ static netdev_tx_t b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto err_out;
 	}
 
-	mapping = dma_map_single(bp->sdev->dma_dev, skb->data, len, DMA_TO_DEVICE);
+	mapping = dma_map_single_attrs(bp->sdev->dma_dev, skb->data, len,
+				       DMA_TO_DEVICE, DMA_ATTR_NO_WARN);
 	if (dma_mapping_error(bp->sdev->dma_dev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
 		struct sk_buff *bounce_skb;
 
-- 
2.24.0
