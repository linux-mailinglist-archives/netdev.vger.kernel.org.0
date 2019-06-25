Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64CB52989
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbfFYK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:29:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731939AbfFYK3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0y+EkNmxmNFKoAnJ+llx9gsPNEjWrfJ32e7lcmuW1Qk=; b=AQTn+w72W/klcp4DMDBpwA3Bhy
        5DmYdjJzY3eqHj5wbpQDqJa4gwhJsgBSDKrd6qqFd03GdIv4/BCqsHPjQSK2ZaWG7y7PpGSlD8cc+
        NRRo2RpvSLk0OpAlWtSyEqnJYNtbtkGIpm8mqh3shzx/ruc7DmV1w63ZS+VfhjweJgDSl4LUE2tJC
        HBQzrwVWzI6NrUU+ppxbg+D+xEJbeWPgtfmsZF9JIwb6FSKtwk5g5ALzsctiur6jcoVDzcrmpccJg
        WabVtfau/MV8V/Rjmni0Bbtj2VoWSYOq4s88gzAVn29ciKQz+MJwMnPjd8dDtfCVPgQm/kKdTwRDw
        diR8YfgQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfihq-0005UB-KE; Tue, 25 Jun 2019 10:29:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] b43: remove b43_dma_set_mask
Date:   Tue, 25 Jun 2019 12:29:31 +0200
Message-Id: <20190625102932.32257-4-hch@lst.de>
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
 drivers/net/wireless/broadcom/b43/dma.c | 43 +++----------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index b34e51933257..1d5ace4d3372 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -1056,42 +1056,6 @@ void b43_dma_free(struct b43_wldev *dev)
 	destroy_ring(dma, tx_ring_mcast);
 }
 
-static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
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
-		b43err(dev->wl, "The machine/kernel does not support "
-		       "the required %u-bit DMA mask\n",
-		       (unsigned int)dma_mask_to_engine_type(orig_mask));
-		return -EOPNOTSUPP;
-	}
-	if (fallback) {
-		b43info(dev->wl, "DMA mask fallback from %u-bit to %u-bit\n",
-			(unsigned int)dma_mask_to_engine_type(orig_mask),
-			(unsigned int)dma_mask_to_engine_type(mask));
-	}
-
-	return 0;
-}
-
 /* Some hardware with 64-bit DMA seems to be bugged and looks for translation
  * bit in low address word instead of high one.
  */
@@ -1120,9 +1084,12 @@ int b43_dma_init(struct b43_wldev *dev)
 
 	dmamask = supported_dma_mask(dev);
 	type = dma_mask_to_engine_type(dmamask);
-	err = b43_dma_set_mask(dev, dmamask);
-	if (err)
+	err = dma_set_mask_and_coherent(dev->dev->dma_dev, dmamask);
+	if (err) {
+		b43err(dev->wl, "The machine/kernel does not support "
+		       "the required %u-bit DMA mask\n", type);
 		return err;
+	}
 
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
-- 
2.20.1

