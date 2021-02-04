Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8096D30F18F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbhBDLHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhBDLHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:07:06 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60096C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:06:26 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r38so1814259pgk.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 03:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bzd7HKkd3Ts7ESkt/aXKI/JaGnhZL+skqDucX4yLTCQ=;
        b=C3c5dyJb6O/yirl0WF84J4RT6j6OM2oYPdgzYChKvnn7e54EVcapMYrooxphRQCGtc
         EHnKKcL4T46bfTuSE5iSFN5XH6Gh/ONPzXb3LmrgV2UcE3ajgNE/zRs+EQt+c/aM3DRw
         q1f+9cOQuRfs++EeRILkxm4qzsfr+6pTSa09hZBe+F7NzGwhIuqo3OThZyeOeWlk12eO
         GMnD4svgDEm3KNS9aHJkY1yGOJYSUpX5jXHmUrz5bPZyC28e0qzshMfE/o51ztssDV55
         y1I4YtZsJJ5hRlC0LJ87EzhiFMK9qIGtcpx2InevX16Jw6mlaSM07T/Eyhq52poqLorN
         KOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bzd7HKkd3Ts7ESkt/aXKI/JaGnhZL+skqDucX4yLTCQ=;
        b=L0cUffIPKuYPkZfrNEeo1GyLNbCHtdtjF8sNYMNFieixxKFStGdr2CvbAe/sKsR23k
         EwOTA0mpVjmB3aNkrb5TbPizyeGl6mHq11Kgnvw0nd8iSL44aa7SZtPnH1T7N67hOU4N
         0Ml/tTODakd9zcw6Uwba7TfhsgKnc8ABW9THd9afMZWZJ2Ih0qwsIf5TCqoCbNq8OHVX
         4xMnueJNofwywZY/QZ+2sCycjs0GrjWLUepbsmrbT7J+Tb98YW9QvrwnLVBguA51sbPY
         udKQxYuhFCRq9J8OcaqbHEbKZyONgxXl1dfQ8N3uPeUoZlflu3gdCy/JOf+H9J+f9m+Y
         N4SA==
X-Gm-Message-State: AOAM531pFSquSQgmDilAurQ6G0+uXO0Vpg7C3FwGcGLRiaoVsVjR8+FA
        ygWQYhQbVduwA1BaQOTg9Qg=
X-Google-Smtp-Source: ABdhPJwxg80JL7uzJYm6e8ZqRQQZBcVyE1xoR7h7pgijaY23L3+J6ubz96J9mZG3Ijj2ipr1a1XCTA==
X-Received: by 2002:aa7:96bc:0:b029:1d3:3d93:5a11 with SMTP id g28-20020aa796bc0000b02901d33d935a11mr5652568pfk.4.1612436785982;
        Thu, 04 Feb 2021 03:06:25 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id y15sm5283351pju.20.2021.02.04.03.06.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 03:06:25 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next v3 1/4] mm: page_frag: Introduce page_frag_alloc_align()
Date:   Thu,  4 Feb 2021 18:56:35 +0800
Message-Id: <20210204105638.1584-2-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210204105638.1584-1-haokexin@gmail.com>
References: <20210204105638.1584-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current implementation of page_frag_alloc(), it doesn't have
any align guarantee for the returned buffer address. But for some
hardwares they do require the DMA buffer to be aligned correctly,
so we would have to use some workarounds like below if the buffers
allocated by the page_frag_alloc() are used by these hardwares for
DMA.
    buf = page_frag_alloc(really_needed_size + align);
    buf = PTR_ALIGN(buf, align);

These codes seems ugly and would waste a lot of memories if the buffers
are used in a network driver for the TX/RX. So introduce
page_frag_alloc_align() to make sure that an aligned buffer address is
returned.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
v3: Use align mask as suggested by Alexander.

 include/linux/gfp.h | 12 ++++++++++--
 mm/page_alloc.c     |  8 +++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 53caa9846854..52cd415b436c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -583,8 +583,16 @@ extern void free_pages(unsigned long addr, unsigned int order);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
-extern void *page_frag_alloc(struct page_frag_cache *nc,
-			     unsigned int fragsz, gfp_t gfp_mask);
+extern void *page_frag_alloc_align(struct page_frag_cache *nc,
+				   unsigned int fragsz, gfp_t gfp_mask,
+				   unsigned int align_mask);
+
+static inline void *page_frag_alloc(struct page_frag_cache *nc,
+			     unsigned int fragsz, gfp_t gfp_mask)
+{
+	return page_frag_alloc_align(nc, fragsz, gfp_mask, ~0u);
+}
+
 extern void page_frag_free(void *addr);
 
 #define __free_page(page) __free_pages((page), 0)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ad3ed3ec4dd5..3583c6accd88 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5137,8 +5137,9 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
-void *page_frag_alloc(struct page_frag_cache *nc,
-		      unsigned int fragsz, gfp_t gfp_mask)
+void *page_frag_alloc_align(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask,
+		      unsigned int align_mask)
 {
 	unsigned int size = PAGE_SIZE;
 	struct page *page;
@@ -5190,11 +5191,12 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 	}
 
 	nc->pagecnt_bias--;
+	offset &= align_mask;
 	nc->offset = offset;
 
 	return nc->va + offset;
 }
-EXPORT_SYMBOL(page_frag_alloc);
+EXPORT_SYMBOL(page_frag_alloc_align);
 
 /*
  * Frees a page fragment allocated out of either a compound or order 0 page.
-- 
2.29.2

