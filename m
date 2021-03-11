Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C229337E5D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCKTox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:44:53 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:33392 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCKTop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:44:45 -0500
Received: by mail-ed1-f45.google.com with SMTP id w18so4604585edc.0;
        Thu, 11 Mar 2021 11:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DWBxv9mwIlByZiQqIZk+iqgg+9i0Rl2rKMKfAz4j0UU=;
        b=GbP4HPaED+vL9CBa9J2ICuHwbcMsawLurHACP8tPu97/U+BDANOv35jVRbtXEiVGEq
         pr0Zz2T+iyVkkJc/TElgbjdBRfw79fsPecEhTp2vSkx71qDZ8HprTQ2ahE7zs55da8GE
         mgLH8FFkhBKAom3j+bpbvNPNm/qflL3SYksYh1cZoAENj/BaZPVpi+1eqSWHd5DmJxc7
         O3AWjPwYq+2cl/wq2NEqQZjL48YVm86GIDcWN0HkbdJhrROqbc0VPhZKt/INNkB5bXGb
         TLLqasFPtO7XcvFUd0FNQjdbKKNIl0rQKdbrqxcjKS4WneleDtQ8Xn9dyfjXOG7ezcOL
         OFmA==
X-Gm-Message-State: AOAM532WTz+sjly3oyx66jHXSUaB1SiOYFsrLS8kjAc6WabdATK6uch1
        9MTxZl/fdb4kHQ7cddopzRTwkGBbTyE=
X-Google-Smtp-Source: ABdhPJz/PbHJ5l5YDixdyLXgqrrRs7TRJoBF869Rz1VS0P1XiSdvg24p0p9d0HEH4APEjaIlsjvCzg==
X-Received: by 2002:a05:6402:1c86:: with SMTP id cy6mr10025404edb.276.1615491884378;
        Thu, 11 Mar 2021 11:44:44 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-188-216-41-250.cust.vodafonedsl.it. [188.216.41.250])
        by smtp.gmail.com with ESMTPSA id t16sm1875652edi.60.2021.03.11.11.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:44:43 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [RFC net-next 2/6] mm: add a signature in struct page
Date:   Thu, 11 Mar 2021 20:42:52 +0100
Message-Id: <20210311194256.53706-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311194256.53706-1-mcroce@linux.microsoft.com>
References: <20210311194256.53706-1-mcroce@linux.microsoft.com>
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
index 0974ad501a47..67caade433e4 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -100,6 +100,7 @@ struct page {
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
2.29.2

