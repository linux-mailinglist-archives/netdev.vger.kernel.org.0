Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7312EA537
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfJ3VMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:12:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=22kvHD/hWcG2cO4hLMYG7wA29ncL+V047iuVK+xMpB8=; b=PxUAV0zR014r4JtQn3kEUh3skF
        OSH/O3wRztTyKKFOwkKC8wwbhmvwccT769gvh8iHfHErNt6JmCLhRnHpvYofxzJWrH33klMacDyNq
        VbcG0zjvx/9xCwc5FbxW6nB8yt9moF7cAjMNki/FWumSvUwbXkSCuSX8dWQ6LH7jKdc4PXLuh/vFY
        I6D1WUPnKgT1EjV8AqCMzD5rGgc0ojORPaH0cD1XoVcjTUgZOJUMJkG2aT3acmlvMaGeAcSRVpb0A
        WWUbsw66sxeGMJJFv3Ty+1jL6Gf+4anfkDbrCTDBtRIfbxAI1dJsC2qOEPcWw4ynbMujLmxKVZ64Q
        m2OmiN5Q==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPvGt-0007ez-9y; Wed, 30 Oct 2019 21:12:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net: sgi: ioc3-eth: fix usage of GFP_* flags
Date:   Wed, 30 Oct 2019 14:12:31 -0700
Message-Id: <20191030211233.30157-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030211233.30157-1-hch@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_alloc_coherent always zeroes memory, there is no need for
__GFP_ZERO.  Also doing a GFP_ATOMIC allocation just before a GFP_KERNEL
one is clearly bogus.

Fixes: ed870f6a7aa2 ("net: sgi: ioc3-eth: use dma-direct for dma allocations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 477af82bf8a9..8a684d882e63 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1243,7 +1243,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Allocate rx ring.  4kb = 512 entries, must be 4kb aligned */
 	ip->rxr = dma_alloc_coherent(ip->dma_dev, RX_RING_SIZE, &ip->rxr_dma,
-				     GFP_ATOMIC);
+				     GFP_KERNEL);
 	if (!ip->rxr) {
 		pr_err("ioc3-eth: rx ring allocation failed\n");
 		err = -ENOMEM;
@@ -1252,7 +1252,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Allocate tx rings.  16kb = 128 bufs, must be 16kb aligned  */
 	ip->txr = dma_alloc_coherent(ip->dma_dev, TX_RING_SIZE, &ip->txr_dma,
-				     GFP_KERNEL | __GFP_ZERO);
+				     GFP_KERNEL);
 	if (!ip->txr) {
 		pr_err("ioc3-eth: tx ring allocation failed\n");
 		err = -ENOMEM;
-- 
2.20.1

