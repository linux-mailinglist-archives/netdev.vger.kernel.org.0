Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352D13014FD
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 13:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbhAWMIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 07:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbhAWMH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 07:07:59 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED9BC061786
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:18 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id z21so5694872pgj.4
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYPGbLlrL+NTSiBBV8yr2vAi1NU6ocBFEQbckFDVJpw=;
        b=uDZJQsgEQB7Mj1PtcF2p1ayxYHYrYhMqXlN5owzLMJvcXLWCRe/YYKC7X/OaQc8Hk3
         UecKo+g15Ajvd1rQxfewlaTRNR3+6m7SVu1KErb69dKGanK23wlMoMxH+0aa6jUwdvf7
         jXEuMjjUuFtMgZdLMW+7veaXYpqWJA2k/ooIIPPRbXC4dhrfpPKgRxfKuvWzY0XZOD1j
         wrixoLnHWb8PwfZ396UfJwklrWn46KUoTnrQ07bocnW8DywzUmXZiTOT0RMgGGIGKT0p
         GX0fq1bRhopcXi/A2nSYPEgPtMypHvq01UuuYxC1XosmHtswgA7vQ84bEyoVUYqXsGoA
         jgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYPGbLlrL+NTSiBBV8yr2vAi1NU6ocBFEQbckFDVJpw=;
        b=Tagn46MM1LrpPja9Eo9VERdh1FMe4uyO8VMjqAd3B/z4X6OdZiRBOswWFxRnw8mlmM
         yU37lLM5RSkFcC45B4lrewPbBoJd+JzlqKewPDF1VtU/OLTBRMBQGUai5alGs0F/a4qn
         id1oMtZFIE9iFir2EByzQKo/KPyWP9SxI6reExMxR/5E22IXahRyC7ERrzJdceGfQOes
         ieC2SWNVEqcZro9rdtC9tLv2/1tJbfWWGcrHT7IoNapz3MhI1/tB1TQfp/NCYd0JDzVh
         R+AzsdoGO17cZCEjbNyhxpRSdmN7Hz4JmxvTt/gEHmNEEhSv/SqC5Wyuix5gOeAlaVua
         DnDg==
X-Gm-Message-State: AOAM531MNELlH5wbDHtJ71bwd8laShjYQvACkZpeMTT41eIvwGS7kyC+
        o8iNTh9IT1PYke20VIbHfzM=
X-Google-Smtp-Source: ABdhPJwj/7xX5kbsGyhaegLymVfXoi5PXvQ1CKAZjDU/HcrfSOm7otarMdq7wI/s3djHT5ueIUY7ug==
X-Received: by 2002:a65:628a:: with SMTP id f10mr1105422pgv.380.1611403638500;
        Sat, 23 Jan 2021 04:07:18 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id v9sm11471079pff.102.2021.01.23.04.07.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 04:07:17 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH net-next 1/4] mm: page_frag: Introduce page_frag_alloc_align()
Date:   Sat, 23 Jan 2021 19:59:00 +0800
Message-Id: <20210123115903.31302-2-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210123115903.31302-1-haokexin@gmail.com>
References: <20210123115903.31302-1-haokexin@gmail.com>
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
---
 include/linux/gfp.h |  3 +++
 mm/page_alloc.c     | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 6e479e9c48ce..e76e8618e9d7 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -583,6 +583,9 @@ extern void free_pages(unsigned long addr, unsigned int order);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
+extern void *page_frag_alloc_align(struct page_frag_cache *nc,
+				   unsigned int fragsz, gfp_t gfp_mask,
+				   int align);
 extern void *page_frag_alloc(struct page_frag_cache *nc,
 			     unsigned int fragsz, gfp_t gfp_mask);
 extern void page_frag_free(void *addr);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 027f6481ba59..80f7c5f7d738 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5135,8 +5135,8 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
-void *page_frag_alloc(struct page_frag_cache *nc,
-		      unsigned int fragsz, gfp_t gfp_mask)
+void *page_frag_alloc_align(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask, int align)
 {
 	unsigned int size = PAGE_SIZE;
 	struct page *page;
@@ -5188,10 +5188,18 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 	}
 
 	nc->pagecnt_bias--;
+	offset = align ? ALIGN_DOWN(offset, align) : offset;
 	nc->offset = offset;
 
 	return nc->va + offset;
 }
+EXPORT_SYMBOL(page_frag_alloc_align);
+
+void *page_frag_alloc(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask)
+{
+	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
+}
 EXPORT_SYMBOL(page_frag_alloc);
 
 /*
-- 
2.29.2

