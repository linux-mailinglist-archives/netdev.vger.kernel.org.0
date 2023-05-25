Return-Path: <netdev+bounces-5326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C93B8710CE5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84C99281577
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB435101EC;
	Thu, 25 May 2023 13:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D4F156D1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:00:23 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1261BC;
	Thu, 25 May 2023 06:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685019614; x=1716555614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mEj5fLVJVo9/4L7Z/kE/pHEwiAz1HdRlcuBfDmRGsuA=;
  b=nluclvX6SzODHqeDZWRV3IwYOejmOJUU0Dei6zRsfBQPRZ+LGYHTCj9a
   uvQSQhNLr9fY57S4gIeg2QvL/NIhRnuvfakEnu65UGVA/cANJGeNK1eOY
   Qxj2cHKtVZsnTlYxEN7UfbgBsrjsF9RLcDX6iMFMUqwYHHy1SDmrUZCsy
   DOPt2S5IAAIfnqqocZ5ZJY6xvzzIlKUu+Hoh3zznzf0XypTEa1Z2rPVzF
   klnQx6i97gzEvqgZBJU7NmqoLYXFb4WuarV9IsOrxSFv8xH5sgi/PF+pZ
   jxEYTzt0YJMKDKq5TL/BScgFrA8yFpJFerqVqeX18kFZIbaTswXyhlTzp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351384431"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="351384431"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 05:59:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="817075173"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="817075173"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga002.fm.intel.com with ESMTP; 25 May 2023 05:59:01 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 08/12] net: page_pool: add DMA-sync-for-CPU inline helpers
Date: Thu, 25 May 2023 14:57:42 +0200
Message-Id: <20230525125746.553874-9-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525125746.553874-1-aleksander.lobakin@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Each driver is responsible for syncing buffers written by HW for CPU
before accessing them. Almost each PP-enabled driver uses the same
pattern, which could be shorthanded into a static inline to make driver
code a little bit more compact.
Introduce a couple such functions. The first one takes the actual size
of the data written by HW and is the main one to be used on Rx. The
second does the same, but only if the PP performs DMA synchronizations
at all. The last one picks max_len from the PP params and is designed
for more extreme cases when the size is unknown, but the buffer still
needs to be synced.
Also constify pointer arguments of page_pool_get_dma_dir() and
page_pool_get_dma_addr() to give a bit more room for optimization,
as both of them are read-only.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/net/page_pool.h | 64 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 08e9571d2545..080778e8cf84 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -32,7 +32,7 @@
 
 #include <linux/mm.h> /* Needed by ptr_ring */
 #include <linux/ptr_ring.h>
-#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
 
 #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
 					* map/unmap
@@ -237,8 +237,8 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
 /* get the stored dma direction. A driver might decide to treat this locally and
  * avoid the extra cache line from page_pool to determine the direction
  */
-static
-inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
+static inline enum dma_data_direction
+page_pool_get_dma_dir(const struct page_pool *pool)
 {
 	return pool->p.dma_dir;
 }
@@ -361,7 +361,7 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
 		(sizeof(dma_addr_t) > sizeof(unsigned long))
 
-static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
+static inline dma_addr_t page_pool_get_dma_addr(const struct page *page)
 {
 	dma_addr_t ret = page->dma_addr;
 
@@ -378,6 +378,62 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 		page->dma_addr_upper = upper_32_bits(addr);
 }
 
+/**
+ * __page_pool_dma_sync_for_cpu - sync Rx page for CPU after it's written by HW
+ * @pool: page_pool which this page belongs to
+ * @page: page to sync
+ * @dma_sync_size: size of the data written to the page
+ *
+ * Can be used as a shorthand to sync Rx pages before accessing them in the
+ * driver. Caller must ensure the pool was created with %PP_FLAG_DMA_MAP.
+ * Note that this version performs DMA sync unconditionally, even if the
+ * associated PP doesn't perform sync-for-device. Consider the non-underscored
+ * version first if unsure.
+ */
+static inline void __page_pool_dma_sync_for_cpu(const struct page_pool *pool,
+						const struct page *page,
+						u32 dma_sync_size)
+{
+	dma_sync_single_range_for_cpu(pool->p.dev,
+				      page_pool_get_dma_addr(page),
+				      pool->p.offset, dma_sync_size,
+				      page_pool_get_dma_dir(pool));
+}
+
+/**
+ * page_pool_dma_sync_for_cpu - sync Rx page for CPU if needed
+ * @pool: page_pool which this page belongs to
+ * @page: page to sync
+ * @dma_sync_size: size of the data written to the page
+ *
+ * Performs DMA sync for CPU, but *only* when:
+ * 1) page_pool was created with %PP_FLAG_DMA_SYNC_DEV to manage DMA syncs;
+ * 2) AND sync shortcut is not available (IOMMU, swiotlb, non-coherent DMA, ...)
+ */
+static inline void page_pool_dma_sync_for_cpu(const struct page_pool *pool,
+					      const struct page *page,
+					      u32 dma_sync_size)
+{
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		__page_pool_dma_sync_for_cpu(pool, page, dma_sync_size);
+}
+
+/**
+ * page_pool_dma_sync_full_for_cpu - sync full Rx page for CPU (if needed)
+ * @pool: page_pool which this page belongs to
+ * @page: page to sync
+ *
+ * Performs sync for the entire length exposed to hardware. Can be used on
+ * DMA errors or before freeing the page, when it's unknown whether the HW
+ * touched the buffer.
+ */
+static inline void
+page_pool_dma_sync_full_for_cpu(const struct page_pool *pool,
+				const struct page *page)
+{
+	page_pool_dma_sync_for_cpu(pool, page, pool->p.max_len);
+}
+
 static inline bool is_page_pool_compiled_in(void)
 {
 #ifdef CONFIG_PAGE_POOL
-- 
2.40.1


