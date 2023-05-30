Return-Path: <netdev+bounces-6459-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C04771662B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9669F1C20C8B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D612720E;
	Tue, 30 May 2023 15:04:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD63D17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:04:43 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FAC11A;
	Tue, 30 May 2023 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685459074; x=1716995074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qc32wr3Sot3sTRrntPIfsglvVZOOpvIVVghP/EIoq2w=;
  b=k5i1Sb67MeSrFNE8E8jr6Jty4T/qrKYUZY0vLxgQ4gLS6nfQvy0GokFs
   d5A0N5RE1aiL7H3d+FRQS13dVV7VpkhSxFJFTCfL1sOzJpxQ5wQEukHGr
   mAwj/ZXidiOJYLaFYef0EvwWOwXOklmnuEchHJ6ga8wCX4qdxUzIM0a9E
   bcXY9+PJ2zPwXx6Otremp/VQbMi4mXFUs7XqADGKadhrmMYrBi2gk6wOg
   w8TMgoj7TGEUgV86gjf6Lc8qXht5Itayn0DuK5WYKEToqtYt2BIlXg/WO
   UFUEdsIg0SrNrGld4Ff6BJhCRVeB6FevAIYAxQstqmtpMfANu6HJoulZv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358192521"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="358192521"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 08:03:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796304173"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="796304173"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by FMSMGA003.fm.intel.com with ESMTP; 30 May 2023 08:03:31 -0700
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
Subject: [PATCH net-next v3 07/12] net: page_pool: avoid calling no-op externals when possible
Date: Tue, 30 May 2023 17:00:30 +0200
Message-Id: <20230530150035.1943669-8-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Turned out page_pool_put{,_full}_page() can burn quite a bunch of cycles
even when on DMA-coherent platforms (like x86) with no active IOMMU or
swiotlb, just for the call ladder.
Indeed, it's

page_pool_put_page()
  page_pool_put_defragged_page()                  <- external
    __page_pool_put_page()
      page_pool_dma_sync_for_device()             <- non-inline
        dma_sync_single_range_for_device()
          dma_sync_single_for_device()            <- external
            dma_direct_sync_single_for_device()
              dev_is_dma_coherent()               <- exit

For the inline functions, no guarantees the compiler won't uninline them
(they're clearly not one-liners and sometimes compilers uninline even
2 + 2). The first external call is necessary, but the rest 2+ are done
for nothing each time, plus a bunch of checks here and there.
Since Page Pool mappings are long-term and for one "device + addr" pair
dma_need_sync() will always return the same value (basically, whether it
belongs to an swiotlb pool), addresses can be tested once right after
they're obtained and the result can be reused until the page is unmapped.
Define new PP flag, which will mean "do DMA syncs for device, but only
when needed" and turn it on by default when the driver asks to sync
pages. When a page is mapped, check whether it needs syncs and if so,
replace that "sync when needed" back to "always do syncs" globally for
the whole pool (better safe than sorry). As long as a pool has no pages
requiring DMA syncs, this cuts off a good piece of calls and checks.
On my x86_64, this gives from 2% to 5% performance benefit with no
negative impact for cases when IOMMU is on and the shortcut can't be
used.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/net/page_pool.h |  3 +++
 net/core/page_pool.c    | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2a9ce2aa6eb2..ee895376270e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -46,6 +46,9 @@
 					* device driver responsibility
 					*/
 #define PP_FLAG_PAGE_FRAG	BIT(2) /* for page frag feature */
+#define PP_FLAG_DMA_MAYBE_SYNC	BIT(3) /* Internal, should not be used in
+					* drivers
+					*/
 #define PP_FLAG_ALL		(PP_FLAG_DMA_MAP |\
 				 PP_FLAG_DMA_SYNC_DEV |\
 				 PP_FLAG_PAGE_FRAG)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a3e12a61d456..102b5e3718c2 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -198,6 +198,10 @@ static int page_pool_init(struct page_pool *pool,
 		/* pool->p.offset has to be set according to the address
 		 * offset used by the DMA engine to start copying rx data
 		 */
+
+		/* Try to avoid calling no-op syncs */
+		pool->p.flags |= PP_FLAG_DMA_MAYBE_SYNC;
+		pool->p.flags &= ~PP_FLAG_DMA_SYNC_DEV;
 	}
 
 	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
@@ -346,6 +350,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 
 	page_pool_set_dma_addr(page, dma);
 
+	if ((pool->p.flags & PP_FLAG_DMA_MAYBE_SYNC) &&
+	    dma_need_sync(pool->p.dev, dma)) {
+		pool->p.flags |= PP_FLAG_DMA_SYNC_DEV;
+		pool->p.flags &= ~PP_FLAG_DMA_MAYBE_SYNC;
+	}
+
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
 
-- 
2.40.1


