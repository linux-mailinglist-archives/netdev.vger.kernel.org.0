Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3E5297E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbfFYK3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:29:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731939AbfFYK3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=89G6EnwERirS4pDlPNUguptOr/aOmuUOxBTr3VXKKtI=; b=EYAj5n9Onzxz1XWV3DkgWAEsti
        mDpDQPPYiczl1tyYrHvdfWc/Y4kWdwSyqrQT/RJQkf8d8R/AQH3y2i9/e6Cu/9yvaBv9dquWTHb3D
        bJhW3gA7ZT2uR3QnNGqKK/Tu6u8ePt84doINubL+ydG58jP87rb13seIQPKE1/SKTgl0VFGT7LhfJ
        eMDjhH++IhhTS4h3BLAsTRQIJpREN3rO3NQ0lsZu+d1tt+/rMqLXJV1jNNUiMoJmYMGzyZdiEWgNZ
        TTTydT0pg7vZfddzox44QpDBJ3XeSJplhzvneQpcXeTGrKvJpyHBuXSkDJwEcxVQG+FqnTjwBQG2d
        ABfUns2g==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfihs-0005Xp-VP; Tue, 25 Jun 2019 10:29:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] b43: simplify engine type / DMA mask selection
Date:   Tue, 25 Jun 2019 12:29:32 +0200
Message-Id: <20190625102932.32257-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625102932.32257-1-hch@lst.de>
References: <20190625102932.32257-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the engine type from the function looking at the registers, and
just derive the DMA mask from that in the one place we care.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/wireless/broadcom/b43/dma.c | 28 ++++++-------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 1d5ace4d3372..e8958edb9094 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -810,7 +810,7 @@ static void free_all_descbuffers(struct b43_dmaring *ring)
 	}
 }
 
-static u64 supported_dma_mask(struct b43_wldev *dev)
+static enum b43_dmatype b43_engine_type(struct b43_wldev *dev)
 {
 	u32 tmp;
 	u16 mmio_base;
@@ -820,14 +820,14 @@ static u64 supported_dma_mask(struct b43_wldev *dev)
 	case B43_BUS_BCMA:
 		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOST);
 		if (tmp & BCMA_IOST_DMA64)
-			return DMA_BIT_MASK(64);
+			return B43_DMA_64BIT;
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		tmp = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
 		if (tmp & SSB_TMSHIGH_DMA64)
-			return DMA_BIT_MASK(64);
+			return B43_DMA_64BIT;
 		break;
 #endif
 	}
@@ -836,20 +836,7 @@ static u64 supported_dma_mask(struct b43_wldev *dev)
 	b43_write32(dev, mmio_base + B43_DMA32_TXCTL, B43_DMA32_TXADDREXT_MASK);
 	tmp = b43_read32(dev, mmio_base + B43_DMA32_TXCTL);
 	if (tmp & B43_DMA32_TXADDREXT_MASK)
-		return DMA_BIT_MASK(32);
-
-	return DMA_BIT_MASK(30);
-}
-
-static enum b43_dmatype dma_mask_to_engine_type(u64 dmamask)
-{
-	if (dmamask == DMA_BIT_MASK(30))
-		return B43_DMA_30BIT;
-	if (dmamask == DMA_BIT_MASK(32))
 		return B43_DMA_32BIT;
-	if (dmamask == DMA_BIT_MASK(64))
-		return B43_DMA_64BIT;
-	B43_WARN_ON(1);
 	return B43_DMA_30BIT;
 }
 
@@ -1078,13 +1065,10 @@ static bool b43_dma_translation_in_low_word(struct b43_wldev *dev,
 int b43_dma_init(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
+	enum b43_dmatype type = b43_engine_type(dev);
 	int err;
-	u64 dmamask;
-	enum b43_dmatype type;
 
-	dmamask = supported_dma_mask(dev);
-	type = dma_mask_to_engine_type(dmamask);
-	err = dma_set_mask_and_coherent(dev->dev->dma_dev, dmamask);
+	err = dma_set_mask_and_coherent(dev->dev->dma_dev, DMA_BIT_MASK(type));
 	if (err) {
 		b43err(dev->wl, "The machine/kernel does not support "
 		       "the required %u-bit DMA mask\n", type);
@@ -1793,7 +1777,7 @@ void b43_dma_direct_fifo_rx(struct b43_wldev *dev,
 	enum b43_dmatype type;
 	u16 mmio_base;
 
-	type = dma_mask_to_engine_type(supported_dma_mask(dev));
+	type = b43_engine_type(dev);
 
 	mmio_base = b43_dmacontroller_base(type, engine_index);
 	direct_fifo_rx(dev, type, mmio_base, enable);
-- 
2.20.1

