Return-Path: <netdev+bounces-3044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A03970539C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D97E22816F7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF3C3111A;
	Tue, 16 May 2023 16:21:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6CB34CF9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:21:18 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9DD9EDC;
	Tue, 16 May 2023 09:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684254044; x=1715790044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=peHjIVqWZsKOM9GvZy/kWyMJy5lP3sTMvyjBMczKWBI=;
  b=kP5n93YVX1C+UZGMZOO9+gzKzVnCuQmn1lmaiUQvBJHjedkBVCR4JfvV
   gG+YR1u30xByW1gSP3bE0No875UX+zdMbHRXLuC1pgcKEksxSpHEJ/GxI
   P7ffCp671CdtqvFIhMk6vH9R+QolGYyK2iuMDfJIbaLhXcko9+eW/Ejt3
   eJm0uoZaIwTFGhMq3fqk3c2FPohpa9qDkO1geK5UeYJvTpuCRJVBnO2Ex
   d869f8yLH/E/UJUJwGsCY1sGmol9fHWtzAr3lnU7Q8lwkOG8IKMP6B9dS
   rOeKYYgR6lbxf/vW+3+qvA8LEM5FeW0b1wcQx5lEKp623KwlibmdReXxn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="340896698"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="340896698"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 09:20:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="701414465"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="701414465"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2023 09:20:26 -0700
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
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/11] net: page_pool: add DMA-sync-for-CPU inline helpers
Date: Tue, 16 May 2023 18:18:37 +0200
Message-Id: <20230516161841.37138-8-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230516161841.37138-1-aleksander.lobakin@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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
 include/net/page_pool.h | 59 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8435013de06e..f740c50b661f 100644
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
@@ -363,7 +363,7 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
 		(sizeof(dma_addr_t) > sizeof(unsigned long))
 
-static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
+static inline dma_addr_t page_pool_get_dma_addr(const struct page *page)
 {
 	dma_addr_t ret = page->dma_addr;
 
@@ -380,6 +380,57 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 		page->dma_addr_upper = upper_32_bits(addr);
 }
 
+/**
+ * page_pool_dma_sync_for_cpu - sync Rx page for CPU after it's written by HW
+ * @pool: page_pool which this page belongs to
+ * @page: page to sync
+ * @dma_sync_size: size of the data written to the page
+ *
+ * Can be used as a shorthand to sync Rx pages before accessing them in the
+ * driver. Caller must ensure the pool was created with %PP_FLAG_DMA_MAP.
+ */
+static inline void page_pool_dma_sync_for_cpu(const struct page_pool *pool,
+					      const struct page *page,
+					      u32 dma_sync_size)
+{
+	dma_sync_single_range_for_cpu(pool->p.dev,
+				      page_pool_get_dma_addr(page),
+				      pool->p.offset, dma_sync_size,
+				      page_pool_get_dma_dir(pool));
+}
+
+/**
+ * page_pool_dma_maybe_sync_for_cpu - sync Rx page for CPU if needed
+ * @pool: page_pool which this page belongs to
+ * @page: page to sync
+ * @dma_sync_size: size of the data written to the page
+ *
+ * Performs DMA sync for CPU, but only when required (swiotlb, IOMMU etc.).
+ */
+static inline void
+page_pool_dma_maybe_sync_for_cpu(const struct page_pool *pool,
+				 const struct page *page, u32 dma_sync_size)
+{
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		page_pool_dma_sync_for_cpu(pool, page, dma_sync_size);
+}
+
+/**
+ * page_pool_dma_sync_for_cpu - sync full Rx page for CPU
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


