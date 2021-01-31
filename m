Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E71309B06
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhAaH4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhAaHzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:55:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD34CC061574
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:54:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g3so8229988plp.2
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqNTc3taooEGAe6NyLfpGbPnLN2+ksi09jHdju+UGdA=;
        b=M8AzrAaFS1ZVyFvtlXhTwOuAvyAv3aBASXTq49HKZOQOGaWer7HfI+3Eijv6S88Z/a
         IMSCK4vhveucdLTk1QhlGbrEFBphmVDzuFbh7WMLE4GlM21Lew0k3m10J2C694DZgKX2
         0INLtCxOD/1qDCaqdpxoUX7SkM0FZXRTEEFbmOKoWdUQAphBLrYrZq+WLubmXB+o3Rw2
         hqEVWBfKvZxfxMV+NK3QOpKJpBEPtjRi22mm5lKi9/QTE1tVMpGljg4Uitr3TfDcrwjT
         0HZ88yxQDSHIPGtBvOE6r+2wWPNG/BtUcoFSOpc7dY2QEFAxI+UOuwf8S1coULoHpCcv
         34WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqNTc3taooEGAe6NyLfpGbPnLN2+ksi09jHdju+UGdA=;
        b=PX+m1cK3a2doTrTrvccvKRWKGxtpGEZRqMg/+WdXFx+2jmFw4LnDOVp8sWeguABazj
         jKiaLl/y1XqB0Uz53s/Q1GZnWIXUeGGIhJKBqNJ7y8VWjQ+ygK//+0SKL0chbSc8jVsR
         f/24ueM00V5tPYATEWYWyv/7G+ANlzXsfFfiyEXJ7gA4QVvv+GDSD1jQP/dCdssW3KIS
         kW045VIaw6HyJ/EHhyxR6elYLRDgW9kdmGN6vMyQ3wZtVJk1RZ1KRLUQwqZJKRiSH4pe
         FE8TSiNx3j/S79dZEAmsW6B6S99KiGMWBRCZzIiftZaep7b26PsxZAObRRwbCIqfb+2a
         JVBQ==
X-Gm-Message-State: AOAM530TSUc7HO2/GMJWeWQhRPf0Mlpbhq0pC5uK0WmxcCEZpTkA9lBF
        /ExysjoPqhDXRNU4BMFfCH8=
X-Google-Smtp-Source: ABdhPJwEw8l6sPqxwHtES9zOBOuhFlNS4KTRemUbIJQZ7T+uBlUIILVDdqN/tc3afG5ifPqk9eJ9Qg==
X-Received: by 2002:a17:90a:a516:: with SMTP id a22mr12118376pjq.192.1612079692422;
        Sat, 30 Jan 2021 23:54:52 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id h23sm13931290pgh.64.2021.01.30.23.54.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 23:54:51 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 1/4] mm: page_frag: Introduce page_frag_alloc_align()
Date:   Sun, 31 Jan 2021 15:44:23 +0800
Message-Id: <20210131074426.44154-2-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210131074426.44154-1-haokexin@gmail.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
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
v2: 
  - Inline page_frag_alloc()
  - Adopt Vlastimil's suggestion and add his Acked-by
 
 include/linux/gfp.h | 12 ++++++++++--
 mm/page_alloc.c     |  8 +++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 6e479e9c48ce..39f4b3070d09 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -583,8 +583,16 @@ extern void free_pages(unsigned long addr, unsigned int order);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
-extern void *page_frag_alloc(struct page_frag_cache *nc,
-			     unsigned int fragsz, gfp_t gfp_mask);
+extern void *page_frag_alloc_align(struct page_frag_cache *nc,
+				   unsigned int fragsz, gfp_t gfp_mask,
+				   int align);
+
+static inline void *page_frag_alloc(struct page_frag_cache *nc,
+			     unsigned int fragsz, gfp_t gfp_mask)
+{
+	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
+}
+
 extern void page_frag_free(void *addr);
 
 #define __free_page(page) __free_pages((page), 0)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 519a60d5b6f7..4667e7b6993b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5137,8 +5137,8 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
-void *page_frag_alloc(struct page_frag_cache *nc,
-		      unsigned int fragsz, gfp_t gfp_mask)
+void *page_frag_alloc_align(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask, int align)
 {
 	unsigned int size = PAGE_SIZE;
 	struct page *page;
@@ -5190,11 +5190,13 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 	}
 
 	nc->pagecnt_bias--;
+	if (align)
+		offset = ALIGN_DOWN(offset, align);
 	nc->offset = offset;
 
 	return nc->va + offset;
 }
-EXPORT_SYMBOL(page_frag_alloc);
+EXPORT_SYMBOL(page_frag_alloc_align);
 
 /*
  * Frees a page fragment allocated out of either a compound or order 0 page.
-- 
2.29.2

