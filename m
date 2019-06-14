Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D8B45F2D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfFNNsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:48:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbfFNNsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RVKpwDD7wUATUASeNR+XdAkTqCzdoA7nasScp5npHqs=; b=InfZ/wOT5rvjRmLvAJ5YP0wj7w
        MnY2l6T7U9OKNQHOpXU4ecx11Q/eDpbs9QZcUEk1J6VapmhpcCqvhL8/4NsVudmklSgaa2WcxVUBe
        waQaOUcUb4RL/2HYzMKDhBFk0TbOCBJW2bM1HFoiaO8f2Ig4hC482NJbLtwEkvvRfYlxTkYB8GZfS
        F0h9hjSdleNEn2dTrk1H5znVe9s/hC3c40GaTOTSLSDPoVROxZizHibMU3rX0xz8EOQplEK9nB80Z
        xPVZaB3uqh4bQkuTonc69uqBuDRYzL7doJGRuaJI4LbV+3+NfJQNVhZazRojfRluUXrQDfyvbPdjZ
        6hG3FXUA==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmZ7-0005kh-Ep; Fri, 14 Jun 2019 13:48:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] dma-mapping: clear __GFP_COMP in dma_alloc_attrs
Date:   Fri, 14 Jun 2019 15:47:25 +0200
Message-Id: <20190614134726.3827-16-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lift the code to clear __GFP_COMP from arm into the common DMA
allocator path.  For one this fixes the various other patches that
call alloc_pages_exact or split_page in case a bogus driver passes
the argument, and it also prepares for doing exact allocation in
the generic dma-direct allocator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/mm/dma-mapping.c | 17 -----------------
 kernel/dma/mapping.c      |  9 +++++++++
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 0a75058c11f3..86135feb2c05 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -759,14 +759,6 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 	if (mask < 0xffffffffULL)
 		gfp |= GFP_DMA;
 
-	/*
-	 * Following is a work-around (a.k.a. hack) to prevent pages
-	 * with __GFP_COMP being passed to split_page() which cannot
-	 * handle them.  The real problem is that this flag probably
-	 * should be 0 on ARM as it is not supported on this
-	 * platform; see CONFIG_HUGETLBFS.
-	 */
-	gfp &= ~(__GFP_COMP);
 	args.gfp = gfp;
 
 	*handle = DMA_MAPPING_ERROR;
@@ -1527,15 +1519,6 @@ static void *__arm_iommu_alloc_attrs(struct device *dev, size_t size,
 		return __iommu_alloc_simple(dev, size, gfp, handle,
 					    coherent_flag, attrs);
 
-	/*
-	 * Following is a work-around (a.k.a. hack) to prevent pages
-	 * with __GFP_COMP being passed to split_page() which cannot
-	 * handle them.  The real problem is that this flag probably
-	 * should be 0 on ARM as it is not supported on this
-	 * platform; see CONFIG_HUGETLBFS.
-	 */
-	gfp &= ~(__GFP_COMP);
-
 	pages = __iommu_alloc_buffer(dev, size, gfp, attrs, coherent_flag);
 	if (!pages)
 		return NULL;
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index f7afdadb6770..4b618e1abbc1 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -252,6 +252,15 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	/* let the implementation decide on the zone to allocate from: */
 	flag &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
+	/*
+	 * __GFP_COMP interacts badly with splitting up a larger order
+	 * allocation.  But as our allocations might not even come from the
+	 * page allocator, the callers can't rely on the fact that they
+	 * even get pages, never mind which kind.
+	 */
+	if (WARN_ON_ONCE(flag & __GFP_COMP))
+		flag &= ~__GFP_COMP;
+
 	if (dma_is_direct(ops))
 		cpu_addr = dma_direct_alloc(dev, size, dma_handle, flag, attrs);
 	else if (ops->alloc)
-- 
2.20.1

