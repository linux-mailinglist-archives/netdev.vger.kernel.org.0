Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E624965E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgHSHF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgHSG5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:57:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C59FC061345;
        Tue, 18 Aug 2020 23:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gjKGhyixAeN99VD5Y9J4wAkwFSZBXIPb+5emgbxT41Q=; b=FjpJs1q6Y1lBqC7rkOykwKGmk4
        jBazOeHmmonZ9E/peW+NLv9Lx2BlZehfpM2DRRBB0RMHmZr/GqPJJcvFHiZKAAwTYVPSsnQ50LI+m
        Bu/U2WAdcWaIaZ6B5Y+fnBbU+XDBZyTv5kcCbbDigh3k4uaNsYKFoaE1XT651RmB061jQ3R2lEq/h
        hzk6lwe9o9XRUOTW2U9OJKTpjS/VsEBGE86tZB5jY45zMAWAnXdry3Tqwds8hZwv6z0Hxga1FHrno
        bssR18gkqfcz3Ua1iOftURBw2VyObut0Q/71HLKgNMs5OBxveAupyeYLotw63rsMM1/Us3GBeLTHK
        b//XcmfA==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I1G-0008Oy-KM; Wed, 19 Aug 2020 06:56:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 13/28] dma-direct: lift gfp_t manipulation out of__dma_direct_alloc_pages
Date:   Wed, 19 Aug 2020 08:55:40 +0200
Message-Id: <20200819065555.1802761-14-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the detailed gfp_t setup from __dma_direct_alloc_pages into the
caller to clean things up a little.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/dma/direct.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 8da9a62dd9a72c..01120510968fa1 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -108,7 +108,7 @@ static inline bool dma_should_free_from_pool(struct device *dev,
 }
 
 static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		gfp_t gfp, unsigned long attrs)
+		gfp_t gfp)
 {
 	int node = dev_to_node(dev);
 	struct page *page = NULL;
@@ -116,11 +116,6 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
-	if (attrs & DMA_ATTR_NO_WARN)
-		gfp |= __GFP_NOWARN;
-
-	/* we always manually zero the memory once we are done: */
-	gfp &= ~__GFP_ZERO;
 	gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
 					   &phys_limit);
 	page = dma_alloc_contiguous(dev, size, gfp);
@@ -164,6 +159,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return arch_dma_alloc(dev, size, dma_handle, gfp, attrs);
 
 	size = PAGE_ALIGN(size);
+	if (attrs & DMA_ATTR_NO_WARN)
+		gfp |= __GFP_NOWARN;
 
 	if (dma_should_alloc_from_pool(dev, gfp, attrs)) {
 		ret = dma_alloc_from_pool(dev, size, &page, gfp);
@@ -172,7 +169,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		goto done;
 	}
 
-	page = __dma_direct_alloc_pages(dev, size, gfp, attrs);
+	/* we always manually zero the memory once we are done */
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO);
 	if (!page)
 		return NULL;
 
-- 
2.28.0

