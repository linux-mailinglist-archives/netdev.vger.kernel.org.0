Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAC30F198
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhBDLHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhBDLHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:07:14 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E65C061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:06:34 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id f63so1880531pfa.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 03:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzRX1HfoeK2op0+prNfA/idHix5q68PSODuxm8/cIYM=;
        b=R0N6gAaPC7JgOLunC1tZpT2+L+NPJEUeEG6XTRefQTEPj7zzkV0kgMAt2J7mOJafoY
         32md2We20b/pzzRgCgPP13mYlF7BiNlby80x1XLJcyhbo0eMADNOjYwMMlZoeIS1b8pZ
         10xgraO/wGtXWAsz/qJvmrAu6wfc1Bp31vLAGerVGcd2bDH69yPLRHSf6SVb0ikMhf1I
         DwUJ8P2XRAdigOyfEizoZ1S4vyEe5MePjW4yQHrJdqvdUf5hjoSKbz9XGpvVNewwHLc5
         5pe4VJ/pkbvwsOedWN44tWlvcHOwsorMr30kr3nps+HOhUceif+BKpPTrbyaG/N8Ih5o
         +6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzRX1HfoeK2op0+prNfA/idHix5q68PSODuxm8/cIYM=;
        b=XPo0fadmPzuhKWjJwDN+cRiGBjgMYZ/oNKXNMoMw9w63/+V/fnd3PhKOZYa1J+XYdt
         UDKokd+oz1YY4pVoX5JFzvs4zGrkOv6coejzi/18sBY14CKr5wl3l+fnWKnVU0mabBbk
         /OLwUdCAeVy4+gEPlwwwTrnkCfVVoX985vr9uZJiRArewcGTZOXUZ1SztP53mNwDH40x
         a2nf/8i4LmpxzJlI7J2yg32putWRmR1n9woummto6wFlCrOc2f0e9KkCnYtJaQBShNxc
         lz3tqjvlKBbt0J+zUyBvYsFL1el0fydy0ExGeFvNw6XCokbzSk6kLTfM2qH0SwWkRTKs
         jjvw==
X-Gm-Message-State: AOAM530rldNWu3pFm33xmCfTfevNGg4BnMa6YgfBA7S9N68+anNqPadp
        eZvhhkudTtVFWT05DsycMRY=
X-Google-Smtp-Source: ABdhPJwLLKd/sOGOgGu+kcgF9rf8T1k2S0b430KT8VlReHaedaYquO2N1s2UghD9Uec5tBvvwlEBKQ==
X-Received: by 2002:aa7:8016:0:b029:1d5:ea54:d7be with SMTP id j22-20020aa780160000b02901d5ea54d7bemr801383pfi.29.1612436793940;
        Thu, 04 Feb 2021 03:06:33 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id y15sm5283351pju.20.2021.02.04.03.06.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 03:06:33 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next v3 2/4] net: Introduce {netdev,napi}_alloc_frag_align()
Date:   Thu,  4 Feb 2021 18:56:36 +0800
Message-Id: <20210204105638.1584-3-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210204105638.1584-1-haokexin@gmail.com>
References: <20210204105638.1584-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current implementation of {netdev,napi}_alloc_frag(), it doesn't
have any align guarantee for the returned buffer address, But for some
hardwares they do require the DMA buffer to be aligned correctly,
so we would have to use some workarounds like below if the buffers
allocated by the {netdev,napi}_alloc_frag() are used by these hardwares
for DMA.
    buf = napi_alloc_frag(really_needed_size + align);
    buf = PTR_ALIGN(buf, align);

These codes seems ugly and would waste a lot of memories if the buffers
are used in a network driver for the TX/RX. We have added the align
support for the page_frag functions, so add the corresponding
{netdev,napi}_frag functions.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
v3: Use align mask and refactor the {netdev,napi}_alloc_frag_align() as
    suggested by Alexander.

 include/linux/skbuff.h | 36 ++++++++++++++++++++++++++++++++++--
 net/core/skbuff.c      | 26 ++++++++++----------------
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9313b5aaf45b..c875b36c43fc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2818,7 +2818,26 @@ void skb_queue_purge(struct sk_buff_head *list);
 
 unsigned int skb_rbtree_purge(struct rb_root *root);
 
-void *netdev_alloc_frag(unsigned int fragsz);
+void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask);
+
+/**
+ * netdev_alloc_frag - allocate a page fragment
+ * @fragsz: fragment size
+ *
+ * Allocates a frag from a page for receive buffer.
+ * Uses GFP_ATOMIC allocations.
+ */
+static inline void *netdev_alloc_frag(unsigned int fragsz)
+{
+	return __netdev_alloc_frag_align(fragsz, ~0u);
+}
+
+static inline void *netdev_alloc_frag_align(unsigned int fragsz,
+					    unsigned int align)
+{
+	WARN_ON_ONCE(!is_power_of_2(align));
+	return __netdev_alloc_frag_align(fragsz, -align);
+}
 
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int length,
 				   gfp_t gfp_mask);
@@ -2877,7 +2896,20 @@ static inline void skb_free_frag(void *addr)
 	page_frag_free(addr);
 }
 
-void *napi_alloc_frag(unsigned int fragsz);
+void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask);
+
+static inline void *napi_alloc_frag(unsigned int fragsz)
+{
+	return __napi_alloc_frag_align(fragsz, ~0u);
+}
+
+static inline void *napi_alloc_frag_align(unsigned int fragsz,
+					  unsigned int align)
+{
+	WARN_ON_ONCE(!is_power_of_2(align));
+	return __napi_alloc_frag_align(fragsz, -align);
+}
+
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi,
 				 unsigned int length, gfp_t gfp_mask);
 static inline struct sk_buff *napi_alloc_skb(struct napi_struct *napi,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2af12f7e170c..063b365ce5b2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -374,29 +374,23 @@ struct napi_alloc_cache {
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
 
-static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
+static void *__alloc_frag_align(unsigned int fragsz, gfp_t gfp_mask,
+				unsigned int align_mask)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 
-	return page_frag_alloc(&nc->page, fragsz, gfp_mask);
+	return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align_mask);
 }
 
-void *napi_alloc_frag(unsigned int fragsz)
+void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
 	fragsz = SKB_DATA_ALIGN(fragsz);
 
-	return __napi_alloc_frag(fragsz, GFP_ATOMIC);
+	return __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
 }
-EXPORT_SYMBOL(napi_alloc_frag);
+EXPORT_SYMBOL(__napi_alloc_frag_align);
 
-/**
- * netdev_alloc_frag - allocate a page fragment
- * @fragsz: fragment size
- *
- * Allocates a frag from a page for receive buffer.
- * Uses GFP_ATOMIC allocations.
- */
-void *netdev_alloc_frag(unsigned int fragsz)
+void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
 	struct page_frag_cache *nc;
 	void *data;
@@ -404,15 +398,15 @@ void *netdev_alloc_frag(unsigned int fragsz)
 	fragsz = SKB_DATA_ALIGN(fragsz);
 	if (in_irq() || irqs_disabled()) {
 		nc = this_cpu_ptr(&netdev_alloc_cache);
-		data = page_frag_alloc(nc, fragsz, GFP_ATOMIC);
+		data = page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align_mask);
 	} else {
 		local_bh_disable();
-		data = __napi_alloc_frag(fragsz, GFP_ATOMIC);
+		data = __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
 		local_bh_enable();
 	}
 	return data;
 }
-EXPORT_SYMBOL(netdev_alloc_frag);
+EXPORT_SYMBOL(__netdev_alloc_frag_align);
 
 /**
  *	__netdev_alloc_skb - allocate an skbuff for rx on a specific device
-- 
2.29.2

