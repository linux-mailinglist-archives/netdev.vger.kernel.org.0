Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D209352F11
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhDBSSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:18:13 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39870 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhDBSSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:18:13 -0400
Received: by mail-wr1-f42.google.com with SMTP id e18so5383757wrt.6;
        Fri, 02 Apr 2021 11:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vTaN//8xhOW6+dxdPY1I1bInoY8eqI/bBr1slqBlUSQ=;
        b=PMsEUT3LX3i9ZY6wuGFYmadxrBRvH9klkiND76AoRjZNGWixLWLLHvSXOHpFbdhhf0
         qTXeB0MBjO6pMPh9wS3ry6DeIkptNHAkgKoGpBzLp6KgblzsSGPI3GVNZGpxAxvYqW/z
         RXNuwmCVZUCJsmX45sgpP8cQyzF8Z58AmTeTGaKqHc1yayXk15lfAz8jaDqjyZhAjakw
         Pk9U40ghcwHDs50TCcXWBKnTeZ1ZztWq9+DP385bSYUNGWATAojZ68Q0LeUbhs1g29YA
         Mt3KAh7hmZhd51d9MeimVmaWkXplM0ehMyY7YgOEbkkoxSl7D3ERld+gvHUVVc/bCsR7
         VXOA==
X-Gm-Message-State: AOAM5333tJFJavtLmM5uL2nJrxFuOlsDNj7ihujGCIDkzE4Ffu7a+pbx
        DrPLLmztuKENlcYXqHRvOXjqFY0DMek=
X-Google-Smtp-Source: ABdhPJzdQxmSHNopopptWYYFZgbCL2iTiZL0ut4i0AvqkAyvsxFGXDMSUur76yIw4kq9Lm8L3WstWw==
X-Received: by 2002:adf:fa8d:: with SMTP id h13mr16321490wrr.331.1617387490714;
        Fri, 02 Apr 2021 11:18:10 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id l9sm11472831wmq.2.2021.04.02.11.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:18:10 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/5] mm: add a signature in struct page
Date:   Fri,  2 Apr 2021 20:17:30 +0200
Message-Id: <20210402181733.32250-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210402181733.32250-1-mcroce@linux.microsoft.com>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is needed by the page_pool to avoid recycling a page not allocated
via page_pool.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 include/linux/mm_types.h | 1 +
 include/net/page_pool.h  | 2 ++
 net/core/page_pool.c     | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6613b26a8894..ef2d0d5f62e4 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -101,6 +101,7 @@ struct page {
 			 * 32-bit architectures.
 			 */
 			dma_addr_t dma_addr;
+			unsigned long signature;
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b5b195305346..b30405e84b5e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -63,6 +63,8 @@
  */
 #define PP_ALLOC_CACHE_SIZE	128
 #define PP_ALLOC_CACHE_REFILL	64
+#define PP_SIGNATURE		0x20210303
+
 struct pp_alloc_cache {
 	u32 count;
 	void *cache[PP_ALLOC_CACHE_SIZE];
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..2ae9b554ef98 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -232,6 +232,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
 
 skip_dma_map:
+	page->signature = PP_SIGNATURE;
+
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 
@@ -302,6 +304,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page->dma_addr = 0;
 skip_dma_unmap:
+	page->signature = 0;
+
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
-- 
2.30.2

