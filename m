Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A9D45F55
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfFNNsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:48:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbfFNNsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Gz4Xhr4GKX8cgnBiH4+BILh020IQOylUizPJRjDHE/E=; b=cf3JZA+ZRH3KX860kHpnPR8oA/
        bqAxf2wdh/kYQFTTiXQ/cfGIHFtkzi1Q6IAe9eh8VXYnYOyFEmHCCu4FhR+BvSXtpAx5ApdhZC2tL
        eqsB5EioSDc9+R5gTT7rMPzafsusILIBU05BomvsIAKlHCVNuXOq2PanGax2oHqCJpo1ef3+4E/WO
        eAvSS6Dx80B05dalPw/wekrBppUw3IEJLxzJHpuSGlVG4QM3kKSs6MrdGwLQEd0MHw3LaJPiqt54p
        Ec8ghntYydM0pKm2+mAy/RaUMsAIhlCtQMD+RUDzu5uz1USZRuoH2TqfwRFQkKEzx7x86HBrZfST/
        CbsAG57g==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmZ3-0005hB-Ky; Fri, 14 Jun 2019 13:48:22 +0000
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
Subject: [PATCH 14/16] mm: use alloc_pages_exact_node to implement alloc_pages_exact
Date:   Fri, 14 Jun 2019 15:47:24 +0200
Message-Id: <20190614134726.3827-15-hch@lst.de>
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

No need to duplicate the logic over two functions that are almost the
same.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/gfp.h |  5 +++--
 mm/page_alloc.c     | 39 +++++++--------------------------------
 2 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4274ea6bc72b..c616a23a3f81 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -530,9 +530,10 @@ extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
-void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
-void * __meminit alloc_pages_exact_node(int nid, size_t size, gfp_t gfp_mask);
+void *alloc_pages_exact_node(int nid, size_t size, gfp_t gfp_mask);
+#define alloc_pages_exact(size, gfp_mask) \
+	alloc_pages_exact_node(NUMA_NO_NODE, size, gfp_mask)
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd2fed66b656..dec68bd21a71 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4859,34 +4859,6 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
 	return (void *)addr;
 }
 
-/**
- * alloc_pages_exact - allocate an exact number physically-contiguous pages.
- * @size: the number of bytes to allocate
- * @gfp_mask: GFP flags for the allocation, must not contain __GFP_COMP
- *
- * This function is similar to alloc_pages(), except that it allocates the
- * minimum number of pages to satisfy the request.  alloc_pages() can only
- * allocate memory in power-of-two pages.
- *
- * This function is also limited by MAX_ORDER.
- *
- * Memory allocated by this function must be released by free_pages_exact().
- *
- * Return: pointer to the allocated area or %NULL in case of error.
- */
-void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
-{
-	unsigned int order = get_order(size);
-	unsigned long addr;
-
-	if (WARN_ON_ONCE(gfp_mask & __GFP_COMP))
-		gfp_mask &= ~__GFP_COMP;
-
-	addr = __get_free_pages(gfp_mask, order);
-	return make_alloc_exact(addr, order, size);
-}
-EXPORT_SYMBOL(alloc_pages_exact);
-
 /**
  * alloc_pages_exact_node - allocate an exact number of physically-contiguous
  *			   pages on a node.
@@ -4894,12 +4866,15 @@ EXPORT_SYMBOL(alloc_pages_exact);
  * @size: the number of bytes to allocate
  * @gfp_mask: GFP flags for the allocation, must not contain __GFP_COMP
  *
- * Like alloc_pages_exact(), but try to allocate on node nid first before falling
- * back.
+ * This function is similar to alloc_pages_node(), except that it allocates the
+ * minimum number of pages to satisfy the request while alloc_pages() can only
+ * allocate memory in power-of-two pages.  This function is also limited by
+ * MAX_ORDER.
  *
- * Return: pointer to the allocated area or %NULL in case of error.
+ * Returns a pointer to the allocated area or %NULL in case of error, memory
+ * allocated by this function must be released by free_pages_exact().
  */
-void * __meminit alloc_pages_exact_node(int nid, size_t size, gfp_t gfp_mask)
+void *alloc_pages_exact_node(int nid, size_t size, gfp_t gfp_mask)
 {
 	unsigned int order = get_order(size);
 	struct page *p;
-- 
2.20.1

