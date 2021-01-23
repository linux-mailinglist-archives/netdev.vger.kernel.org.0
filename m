Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F513014FE
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 13:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbhAWMIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 07:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbhAWMIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 07:08:07 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDB3C061788
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:27 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 31so4782048plb.10
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WUpKxwAFaQa+uUPZ4D7S7tvn/MJ+fLIoM8egUUDOIRE=;
        b=Pbyb8nzayzYyMAooVb2tYrdMxI7oyoo7JMVQPKFlajzhG1P2QxuCAn+6tp/tVQd+/2
         NPtnIX/oxpj5OPYaBuhvodt/8zxF6bfC617L0WSYH12PdvFeWiin1V5lMUK+dK9VjMRn
         pm9nNml5qVYXyhbTJWFp9/XEs0Ap70yMZ9XN7/NoRjBW3XPOSR2Iw5x2T9agHe5c8/IM
         SiecVKEHa+VLwTGIuQU3RLH88kfDMXsMkxU6YYsGqDstHlelb3/zLqwariGBASP21Kxo
         Dqt3vzPOJV2p6cUgTOeIgXtc9kvSgrk3tpUorBvi1s0Hd/G7H6eh/wn1R3mjVx8Dxl3r
         6oqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WUpKxwAFaQa+uUPZ4D7S7tvn/MJ+fLIoM8egUUDOIRE=;
        b=tYk3OCabBp1NHp0r1YzlpNQ4u2u+9tyWtaUoZ3/p+Nj0UHcCVoQZMnZNjNmvqX4rz/
         752eW4tZrRYRtK6ZEfDdDeySqda/aq0RrVxsC2ie04TwncxE25HhE/6WdZwbASWer9kq
         YId+E3T2sx8C/8YlzdZf4/57q8zlk9FWxHD+JrWkkhDMNssli6MV4bb4Fr8koFUtrai8
         ND6ba+Tjc23w8l18D4uAoAMjFYzb5yWs/vKiu32BG4oPNndAFZMFiBJs4Hj1palE74Pa
         2PPMWE4vJYDDQnORzloydLfCKbUICCO5YN9VS3Poko+dPNumE7F92a7UhdM2mWWsFcbT
         BO2A==
X-Gm-Message-State: AOAM531oJ/th0htICPHB7IFfDn/QvA4ViX16WcBieuthcYmbZPMsFFBx
        TVjxfGtNH/ZgRqFhom272Q8=
X-Google-Smtp-Source: ABdhPJziHeiKV0DFst52wkp3BA7TmUFxrrrWYKSD4LhkdAWk1DHxMydY4k6pY263YMgy7xzRxI8AHA==
X-Received: by 2002:a17:90a:5911:: with SMTP id k17mr10997913pji.152.1611403647002;
        Sat, 23 Jan 2021 04:07:27 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id v9sm11471079pff.102.2021.01.23.04.07.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 04:07:26 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: Introduce {netdev,napi}_alloc_frag_align()
Date:   Sat, 23 Jan 2021 19:59:01 +0800
Message-Id: <20210123115903.31302-3-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210123115903.31302-1-haokexin@gmail.com>
References: <20210123115903.31302-1-haokexin@gmail.com>
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
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 40 ++++++++++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5f60c9e907c9..71e704732b6f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2808,6 +2808,7 @@ void skb_queue_purge(struct sk_buff_head *list);
 
 unsigned int skb_rbtree_purge(struct rb_root *root);
 
+void *netdev_alloc_frag_align(unsigned int fragsz, int align);
 void *netdev_alloc_frag(unsigned int fragsz);
 
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int length,
@@ -2867,6 +2868,7 @@ static inline void skb_free_frag(void *addr)
 	page_frag_free(addr);
 }
 
+void *napi_alloc_frag_align(unsigned int fragsz, int align);
 void *napi_alloc_frag(unsigned int fragsz);
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi,
 				 unsigned int length, gfp_t gfp_mask);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 785daff48030..d01ecb4f0de4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -374,29 +374,28 @@ struct napi_alloc_cache {
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
 
-static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
+static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask, int align)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 
-	return page_frag_alloc(&nc->page, fragsz, gfp_mask);
+	return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align);
 }
 
-void *napi_alloc_frag(unsigned int fragsz)
+void *napi_alloc_frag_align(unsigned int fragsz, int align)
 {
 	fragsz = SKB_DATA_ALIGN(fragsz);
 
-	return __napi_alloc_frag(fragsz, GFP_ATOMIC);
+	return __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
+}
+EXPORT_SYMBOL(napi_alloc_frag_align);
+
+void *napi_alloc_frag(unsigned int fragsz)
+{
+	return napi_alloc_frag_align(fragsz, 0);
 }
 EXPORT_SYMBOL(napi_alloc_frag);
 
-/**
- * netdev_alloc_frag - allocate a page fragment
- * @fragsz: fragment size
- *
- * Allocates a frag from a page for receive buffer.
- * Uses GFP_ATOMIC allocations.
- */
-void *netdev_alloc_frag(unsigned int fragsz)
+void *netdev_alloc_frag_align(unsigned int fragsz, int align)
 {
 	struct page_frag_cache *nc;
 	void *data;
@@ -404,14 +403,27 @@ void *netdev_alloc_frag(unsigned int fragsz)
 	fragsz = SKB_DATA_ALIGN(fragsz);
 	if (in_irq() || irqs_disabled()) {
 		nc = this_cpu_ptr(&netdev_alloc_cache);
-		data = page_frag_alloc(nc, fragsz, GFP_ATOMIC);
+		data = page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align);
 	} else {
 		local_bh_disable();
-		data = __napi_alloc_frag(fragsz, GFP_ATOMIC);
+		data = __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
 		local_bh_enable();
 	}
 	return data;
 }
+EXPORT_SYMBOL(netdev_alloc_frag_align);
+
+/**
+ * netdev_alloc_frag - allocate a page fragment
+ * @fragsz: fragment size
+ *
+ * Allocates a frag from a page for receive buffer.
+ * Uses GFP_ATOMIC allocations.
+ */
+void *netdev_alloc_frag(unsigned int fragsz)
+{
+	return netdev_alloc_frag_align(fragsz, 0);
+}
 EXPORT_SYMBOL(netdev_alloc_frag);
 
 /**
-- 
2.29.2

