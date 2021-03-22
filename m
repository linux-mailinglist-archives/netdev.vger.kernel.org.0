Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C985D344CA8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhCVREA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:04:00 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:40595 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbhCVRDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:03:45 -0400
Received: by mail-ej1-f44.google.com with SMTP id u9so22490759ejj.7;
        Mon, 22 Mar 2021 10:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+BsUOGlJPlozZqQd4/Ev8lzvqr0OkEcaNTSgyVqY+KY=;
        b=HnDDrvnZK0os8sOjW68lUvmaztT6S/qQeaZueI6rQy0PkxOnAWFua5oa3yWSE5TOcr
         pGezPjGvmfvgY3EMHDAi5LOXO1rKbOstCasfh0l7bf7TyiUiCxx57F01Tn72RGnecPMj
         NhbSwQ5/zXMlueoT2vqJcUe8jL/5b3vM6wVR0jDuD5mRYt61XAtRtb5jsc+pp6alnXSt
         er5KDBvoe+GPDV8xUo7ELO3R7iUl/vFFeqBRp8VOz/Fj9DUH0wENDcvPoYo7KMkml1YA
         3XP5kJykUHVJXsGKnkoC77QPsiD0w0bSwTHgMB5U/tIgnQji/6ArKcaIfSs2AL4fQFfh
         MwDg==
X-Gm-Message-State: AOAM531J1Wi60IvhKb6h1Uo9goOp58njgSv5WeD9A4VsH28n+akoFCkd
        mQePtzB+ihV+G+5TmYtYFTHU351D5Tc=
X-Google-Smtp-Source: ABdhPJzrAUPAH3yCEiDU5Ga19EEwvTHbgl7CZZbhzgNhdwxhGmG4jmkDs2fX4CGx1gwNw6TiiCKBLA==
X-Received: by 2002:a17:906:f6ce:: with SMTP id jo14mr811444ejb.476.1616432624245;
        Mon, 22 Mar 2021 10:03:44 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id h22sm9891589eji.80.2021.03.22.10.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:03:43 -0700 (PDT)
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
Subject: [PATCH net-next 2/6] mm: add a signature in struct page
Date:   Mon, 22 Mar 2021 18:02:57 +0100
Message-Id: <20210322170301.26017-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
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
2.30.2

