Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F49452975
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfFYK3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:29:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731939AbfFYK3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6PRfHQ3NGRfwo8k6M0Ah5l3x8Qxa9hRyvFNjcHO4MeQ=; b=cgIu0kcyYdKVV/eHSTd/1vuMCG
        vw9Ww6uPJv3WwC5FyAIr2oKa78ZjAZbMJHoIWrrkiR3ksjpNBpMuVVf21RvuitABoj8Mkd4dhSrN5
        Zkri+jSdEsAqqtBh16WQ8MZowcPJTDHN/sJI4HoDXvg7SFQiVyTKfpkAd3gV/YOzz6eklgsAxjLfo
        Xu/nqaWkLHcFOAj3g8rkxGWUcTm0X85lSHIjrRwoXroqjrX2BJ8l0NuLpBVbBGV7sDYUpAq/Gq5qD
        ldbmwkfw52OOvExsW/OL5ez9vRCG6WDu/MkWyHPItHwh6P8Z7ruxUgs32KO6pYdcpIykCQmOSBePP
        1ZgTjRqQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfihl-0005Su-UF; Tue, 25 Jun 2019 10:29:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] b43legacy: remove b43legacy_dma_set_mask
Date:   Tue, 25 Jun 2019 12:29:29 +0200
Message-Id: <20190625102932.32257-2-hch@lst.de>
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

These days drivers are not required to fallback to smaller DMA masks,
but can just set the largest mask they support, removing the need for
this trial and error logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/wireless/broadcom/b43legacy/dma.c | 39 +------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index 2ce1537d983c..0c2de20622e3 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -797,43 +797,6 @@ void b43legacy_dma_free(struct b43legacy_wldev *dev)
 	dma->tx_ring0 = NULL;
 }
 
-static int b43legacy_dma_set_mask(struct b43legacy_wldev *dev, u64 mask)
-{
-	u64 orig_mask = mask;
-	bool fallback = false;
-	int err;
-
-	/* Try to set the DMA mask. If it fails, try falling back to a
-	 * lower mask, as we can always also support a lower one. */
-	while (1) {
-		err = dma_set_mask_and_coherent(dev->dev->dma_dev, mask);
-		if (!err)
-			break;
-		if (mask == DMA_BIT_MASK(64)) {
-			mask = DMA_BIT_MASK(32);
-			fallback = true;
-			continue;
-		}
-		if (mask == DMA_BIT_MASK(32)) {
-			mask = DMA_BIT_MASK(30);
-			fallback = true;
-			continue;
-		}
-		b43legacyerr(dev->wl, "The machine/kernel does not support "
-		       "the required %u-bit DMA mask\n",
-		       (unsigned int)dma_mask_to_engine_type(orig_mask));
-		return -EOPNOTSUPP;
-	}
-	if (fallback) {
-		b43legacyinfo(dev->wl, "DMA mask fallback from %u-bit to %u-"
-			"bit\n",
-			(unsigned int)dma_mask_to_engine_type(orig_mask),
-			(unsigned int)dma_mask_to_engine_type(mask));
-	}
-
-	return 0;
-}
-
 int b43legacy_dma_init(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_dma *dma = &dev->dma;
@@ -844,7 +807,7 @@ int b43legacy_dma_init(struct b43legacy_wldev *dev)
 
 	dmamask = supported_dma_mask(dev);
 	type = dma_mask_to_engine_type(dmamask);
-	err = b43legacy_dma_set_mask(dev, dmamask);
+	err = dma_set_mask_and_coherent(dev->dev->dma_dev, dmamask);
 	if (err) {
 #ifdef CONFIG_B43LEGACY_PIO
 		b43legacywarn(dev->wl, "DMA for this device not supported. "
-- 
2.20.1

