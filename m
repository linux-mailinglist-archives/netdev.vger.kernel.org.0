Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929B32495AD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHSG5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgHSG5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:57:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9E3C061343;
        Tue, 18 Aug 2020 23:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3yo70wOVkF5CaNJSKu+AlarDAtI7zXpUGNpkgTYQVWg=; b=Stap9nZF6GC9QOjwOzcCX1NDYx
        jGVXomD9Kv31rFvbB7gCdBXXUTES2lhRo/Ye9dplxjvmv9GlaKXFAK0d1WTWoWB8yEbJSVAvr30c8
        9F4Wz/h3LBGX5AUsie/duMpRWbktxOomFvprDLV/zNeZybGiCPY3LG1ggZ2w/RgJmGuqL1PpQrHyd
        BfSAqDAFvc4rwVO/UOekcEg55Q1BUT0J6zjsbm8NsrVFPbisxVXvjV6RTEBiOWIPm0GL8lsuyZQpI
        Ybvh9GTiwEe0ZBf+TXtIz+htcpCJlIbiRdGYNQxwcwGhofUTsZ8c2xOQdxxerpc6hNAhN6tmLt14n
        N+flC3iQ==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I1r-00006Q-0Z; Wed, 19 Aug 2020 06:57:00 +0000
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
Subject: [PATCH 26/28] dmapool: add dma_alloc_pages support
Date:   Wed, 19 Aug 2020 08:55:53 +0200
Message-Id: <20200819065555.1802761-27-hch@lst.de>
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

Add an new variant of a dmapool that uses non-coherent memory from
dma_alloc_pages.  Unlike the existing mempool_create this one
initialized a pool allocated by the caller to avoid a pointless extra
allocation.  At some point it might be worth to also switch the coherent
allocation over to a similar dma_pool_init_coherent helper, but that is
better done as a separate series including a few conversions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/dmapool.h |  23 ++++-
 mm/dmapool.c            | 211 +++++++++++++++++++++++++---------------
 2 files changed, 154 insertions(+), 80 deletions(-)

diff --git a/include/linux/dmapool.h b/include/linux/dmapool.h
index f632ecfb423840..1387525c4e52e8 100644
--- a/include/linux/dmapool.h
+++ b/include/linux/dmapool.h
@@ -11,6 +11,10 @@
 #ifndef LINUX_DMAPOOL_H
 #define	LINUX_DMAPOOL_H
 
+#include <linux/dma-direction.h>
+#include <linux/gfp.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
 #include <linux/scatterlist.h>
 #include <asm/io.h>
 
@@ -18,11 +22,28 @@ struct device;
 
 #ifdef CONFIG_HAS_DMA
 
+struct dma_pool {		/* the pool */
+	struct list_head page_list;
+	spinlock_t lock;
+	size_t size;
+	struct device *dev;
+	size_t allocation;
+	size_t boundary;
+	bool is_coherent;
+	enum dma_data_direction dir;
+	char name[32];
+	struct list_head pools;
+};
+
 struct dma_pool *dma_pool_create(const char *name, struct device *dev, 
 			size_t size, size_t align, size_t allocation);
-
 void dma_pool_destroy(struct dma_pool *pool);
 
+int dma_pool_init(struct device *dev, struct dma_pool *pool, const char *name,
+		size_t size, size_t align, size_t boundary,
+		enum dma_data_direction dir);
+void dma_pool_exit(struct dma_pool *pool);
+
 void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		     dma_addr_t *handle);
 void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t addr);
diff --git a/mm/dmapool.c b/mm/dmapool.c
index f9fb9bbd733e0f..c60a48b22c8d6a 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -6,10 +6,10 @@
  * Copyright 2007 Intel Corporation
  *   Author: Matthew Wilcox <willy@linux.intel.com>
  *
- * This allocator returns small blocks of a given size which are DMA-able by
- * the given device.  It uses the dma_alloc_coherent page allocator to get
- * new pages, then splits them up into blocks of the required size.
- * Many older drivers still have their own code to do this.
+ * This allocator returns small blocks of a given size which are DMA-able by the
+ * given device.  It either uses the dma_alloc_coherent or the dma_alloc_pages
+ * allocator to get new pages, then splits them up into blocks of the required
+ * size.
  *
  * The current design of this allocator is fairly simple.  The pool is
  * represented by the 'struct dma_pool' which keeps a doubly-linked list of
@@ -39,17 +39,6 @@
 #define DMAPOOL_DEBUG 1
 #endif
 
-struct dma_pool {		/* the pool */
-	struct list_head page_list;
-	spinlock_t lock;
-	size_t size;
-	struct device *dev;
-	size_t allocation;
-	size_t boundary;
-	char name[32];
-	struct list_head pools;
-};
-
 struct dma_page {		/* cacheable header for 'allocation' bytes */
 	struct list_head page_list;
 	void *vaddr;
@@ -104,74 +93,40 @@ show_pools(struct device *dev, struct device_attribute *attr, char *buf)
 
 static DEVICE_ATTR(pools, 0444, show_pools, NULL);
 
-/**
- * dma_pool_create - Creates a pool of consistent memory blocks, for dma.
- * @name: name of pool, for diagnostics
- * @dev: device that will be doing the DMA
- * @size: size of the blocks in this pool.
- * @align: alignment requirement for blocks; must be a power of two
- * @boundary: returned blocks won't cross this power of two boundary
- * Context: not in_interrupt()
- *
- * Given one of these pools, dma_pool_alloc()
- * may be used to allocate memory.  Such memory will all have "consistent"
- * DMA mappings, accessible by the device and its driver without using
- * cache flushing primitives.  The actual size of blocks allocated may be
- * larger than requested because of alignment.
- *
- * If @boundary is nonzero, objects returned from dma_pool_alloc() won't
- * cross that size boundary.  This is useful for devices which have
- * addressing restrictions on individual DMA transfers, such as not crossing
- * boundaries of 4KBytes.
- *
- * Return: a dma allocation pool with the requested characteristics, or
- * %NULL if one can't be created.
- */
-struct dma_pool *dma_pool_create(const char *name, struct device *dev,
-				 size_t size, size_t align, size_t boundary)
+static int __dma_pool_init(struct device *dev, struct dma_pool *pool,
+		const char *name, size_t size, size_t align, size_t boundary)
 {
-	struct dma_pool *retval;
 	size_t allocation;
 	bool empty = false;
 
 	if (align == 0)
 		align = 1;
-	else if (align & (align - 1))
-		return NULL;
+	if (align & (align - 1))
+		return -EINVAL;
 
 	if (size == 0)
-		return NULL;
-	else if (size < 4)
-		size = 4;
-
-	size = ALIGN(size, align);
+		return -EINVAL;
+	size = ALIGN(min_t(size_t, size, 4), align);
 	allocation = max_t(size_t, size, PAGE_SIZE);
 
 	if (!boundary)
 		boundary = allocation;
-	else if ((boundary < size) || (boundary & (boundary - 1)))
-		return NULL;
-
-	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
-	if (!retval)
-		return retval;
-
-	strlcpy(retval->name, name, sizeof(retval->name));
-
-	retval->dev = dev;
-
-	INIT_LIST_HEAD(&retval->page_list);
-	spin_lock_init(&retval->lock);
-	retval->size = size;
-	retval->boundary = boundary;
-	retval->allocation = allocation;
-
-	INIT_LIST_HEAD(&retval->pools);
+	if (boundary < size || (boundary & (boundary - 1)))
+		return -EINVAL;
+
+	strlcpy(pool->name, name, sizeof(pool->name));
+	pool->dev = dev;
+	INIT_LIST_HEAD(&pool->page_list);
+	spin_lock_init(&pool->lock);
+	pool->size = size;
+	pool->boundary = boundary;
+	pool->allocation = allocation;
+	INIT_LIST_HEAD(&pool->pools);
 
 	/*
 	 * pools_lock ensures that the ->dma_pools list does not get corrupted.
 	 * pools_reg_lock ensures that there is not a race between
-	 * dma_pool_create() and dma_pool_destroy() or within dma_pool_create()
+	 * __dma_pool_init() and dma_pool_exit() or within dma_pool_create()
 	 * when the first invocation of dma_pool_create() failed on
 	 * device_create_file() and the second assumes that it has been done (I
 	 * know it is a short window).
@@ -180,7 +135,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	mutex_lock(&pools_lock);
 	if (list_empty(&dev->dma_pools))
 		empty = true;
-	list_add(&retval->pools, &dev->dma_pools);
+	list_add(&pool->pools, &dev->dma_pools);
 	mutex_unlock(&pools_lock);
 	if (empty) {
 		int err;
@@ -188,18 +143,94 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 		err = device_create_file(dev, &dev_attr_pools);
 		if (err) {
 			mutex_lock(&pools_lock);
-			list_del(&retval->pools);
+			list_del(&pool->pools);
 			mutex_unlock(&pools_lock);
 			mutex_unlock(&pools_reg_lock);
-			kfree(retval);
-			return NULL;
+			return err;
 		}
 	}
 	mutex_unlock(&pools_reg_lock);
-	return retval;
+	return 0;
+}
+
+/**
+ * dma_pool_create - Creates a pool of consistent memory blocks, for dma.
+ * @name: name of pool, for diagnostics
+ * @dev: device that will be doing the DMA
+ * @size: size of the blocks in this pool.
+ * @align: alignment requirement for blocks; must be a power of two
+ * @boundary: returned blocks won't cross this power of two boundary
+ * Context: not in_interrupt()
+ *
+ * Given one of these pools, dma_pool_alloc()
+ * may be used to allocate memory.  Such memory will all have "consistent"
+ * DMA mappings, accessible by the device and its driver without using
+ * cache flushing primitives.  The actual size of blocks allocated may be
+ * larger than requested because of alignment.
+ *
+ * If @boundary is nonzero, objects returned from dma_pool_alloc() won't
+ * cross that size boundary.  This is useful for devices which have
+ * addressing restrictions on individual DMA transfers, such as not crossing
+ * boundaries of 4KBytes.
+ *  Return: a dma allocation pool with the requested characteristics, or
+ * %NULL if one can't be created.
+ */
+struct dma_pool *dma_pool_create(const char *name, struct device *dev,
+				 size_t size, size_t align, size_t boundary)
+{
+	struct dma_pool *pool;
+
+	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL, dev_to_node(dev));
+	if (!pool)
+		return NULL;
+	if (__dma_pool_init(dev, pool, name, size, align, boundary))
+		goto out_free_pool;
+	pool->is_coherent = true;
+	return pool;
+out_free_pool:
+	kfree(pool);
+	return NULL;
 }
 EXPORT_SYMBOL(dma_pool_create);
 
+/**
+ * dma_pool_init - initialize a pool DMA addressable memory
+ * @dev:	device that will be doing the DMA
+ * @pool:	pool to initialize
+ * @name:	name of pool, for diagnostics
+ * @size:	size of the blocks in this pool.
+ * @align:	alignment requirement for blocks; must be a power of two
+ * @boundary:	returned blocks won't cross this power of two boundary
+ * @dir:	DMA direction the allocations are going to be used for
+ *
+ * Context:	not in_interrupt()
+ *
+ * Given one of these pools, dma_pool_alloc() may be used to allocate memory.
+ * Such memory will have the same semantics as memory returned from
+ * dma_alloc_pages(), that is ownership needs to be transferred to and from the
+ * device.  The actual size of blocks allocated may be larger than requested
+ * because of alignment.
+ *
+ * If @boundary is nonzero, objects returned from dma_pool_alloc() won't
+ * cross that size boundary.  This is useful for devices which have
+ * addressing restrictions on individual DMA transfers, such as not crossing
+ * boundaries of 4KBytes.
+ */
+int dma_pool_init(struct device *dev, struct dma_pool *pool, const char *name,
+		size_t size, size_t align, size_t boundary,
+		enum dma_data_direction dir)
+{
+	int ret;
+
+	ret = __dma_pool_init(dev, pool, name, size, align, boundary);
+	if (ret)
+		return ret;
+	pool->is_coherent = false;
+	pool->dir = dir;
+	return 0;
+}
+EXPORT_SYMBOL(dma_pool_init);
+
 static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
 {
 	unsigned int offset = 0;
@@ -223,8 +254,12 @@ static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 	page = kmalloc(sizeof(*page), mem_flags);
 	if (!page)
 		return NULL;
-	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
-					 &page->dma, mem_flags);
+	if (pool->is_coherent)
+		page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
+						 &page->dma, mem_flags);
+	else
+		page->vaddr = dma_alloc_pages(pool->dev, pool->allocation,
+					      &page->dma, pool->dir, mem_flags);
 	if (page->vaddr) {
 #ifdef	DMAPOOL_DEBUG
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
@@ -251,20 +286,25 @@ static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
 #ifdef	DMAPOOL_DEBUG
 	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
-	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
+	if (pool->is_coherent)
+		dma_free_coherent(pool->dev, pool->allocation, page->vaddr,
+				  dma);
+	else
+		dma_free_pages(pool->dev, pool->allocation, page->vaddr, dma,
+			       pool->dir);
 	list_del(&page->page_list);
 	kfree(page);
 }
 
 /**
- * dma_pool_destroy - destroys a pool of dma memory blocks.
+ * dma_pool_exit - destroys a pool of dma memory blocks.
  * @pool: dma pool that will be destroyed
  * Context: !in_interrupt()
  *
- * Caller guarantees that no more memory from the pool is in use,
- * and that nothing will try to use the pool after this call.
+ * Caller guarantees that no more memory from the pool is in use, and that
+ * nothing will try to use the pool after this call.
  */
-void dma_pool_destroy(struct dma_pool *pool)
+void dma_pool_exit(struct dma_pool *pool)
 {
 	bool empty = false;
 
@@ -299,7 +339,20 @@ void dma_pool_destroy(struct dma_pool *pool)
 		} else
 			pool_free_page(pool, page);
 	}
+}
+EXPORT_SYMBOL(dma_pool_exit);
 
+/**
+ * dma_pool_destroy - destroys a pool of dma memory blocks.
+ * @pool: dma pool that will be destroyed
+ * Context: !in_interrupt()
+ *
+ * Caller guarantees that no more memory from the pool is in use,
+ * and that nothing will try to use the pool after this call.
+ */
+void dma_pool_destroy(struct dma_pool *pool)
+{
+	dma_pool_exit(pool);
 	kfree(pool);
 }
 EXPORT_SYMBOL(dma_pool_destroy);
-- 
2.28.0

