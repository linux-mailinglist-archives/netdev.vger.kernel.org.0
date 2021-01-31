Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE5309B0A
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhAaH6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhAaHzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:55:43 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEC8C061756
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:55:01 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y10so3964307plk.7
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i70Sxj4cZmzmtpdWdusZpF/p3QeH5YwXfzmt166XqM8=;
        b=Ivip4xEgpcjpL33QnfkgJUy3vXZ5UN3g27zjVxXfKQmx6nkn9ZJHP3kwHEpM6E3sd5
         bY0fD/EdoVEiGCJipg3Em+xofbz1ofTG7c8COSP1ZgtWw/e/6TD/+0qAEaiM4n8+8htZ
         VX4Mzyl2PzN9vTopaUq2HmCGz0OZ/uDFz9hUb+7543iGgg8DCQF7l/IlDDxGRerpkW+E
         mEb7IQfAm5qwxGU+NqX+WbkWsJJmPFq6Ms6g7rq5KsoBMVfrqP+o9GQiYRlWgo7JBDE2
         6IVMAeEi/lx0592FX8Nlg7QbC4ad9IWDkx4hpLWMU3cUwXRri27SXyia6lUckrJdMthF
         obgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i70Sxj4cZmzmtpdWdusZpF/p3QeH5YwXfzmt166XqM8=;
        b=Mo84fOiwf3OKiod6E7CwMC12F/eX002YJeZ6qdnALuPaLwjpQxv3bq02OL/jqauGmH
         5GcfjyJh858ePHHNON4P1P7ZL/iT6WfSG6pNFOPP6xVY9RS/O2vrUpCIJ6Db91quftwO
         2ExW1jHu/b5Ry4nE8rRIgy3BWTKVI361h+QKe74ofshh5XejaaKJ2+RL6V5HhlnOzSuo
         dp+1eJcHdpSRQI9QzUlvPr7XrsWjN87jtIylmpozTC4QZr4rDKbMwQO32Fp2459EZv+6
         waJ5YfJoAXzlP882LuSzsaQJIWw2EuAKEO597c6jSscOWk6VwMDbQJiulrIC8ux240cL
         ZizQ==
X-Gm-Message-State: AOAM530vckuZgXvIzI/fbHN7FFIogSq1TGaOQOaZRTPokz1Xh+AfgBmm
        ds7ssix9QxPXcGhdDCXwBeo=
X-Google-Smtp-Source: ABdhPJzMmkvcuAiHK6PybhCiIOVlXRNSMshrT2HDkQJxMZUhFJ6SONGDiTCfG+Xr6QKGAOKAx6Yr/Q==
X-Received: by 2002:a17:90b:f08:: with SMTP id br8mr11708524pjb.134.1612079701560;
        Sat, 30 Jan 2021 23:55:01 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id h23sm13931290pgh.64.2021.01.30.23.54.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 23:55:00 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 2/4] net: Introduce {netdev,napi}_alloc_frag_align()
Date:   Sun, 31 Jan 2021 15:44:24 +0800
Message-Id: <20210131074426.44154-3-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210131074426.44154-1-haokexin@gmail.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
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
v2: Inline {netdev,napi}_alloc_frag().

 include/linux/skbuff.h | 22 ++++++++++++++++++++--
 net/core/skbuff.c      | 25 +++++++++----------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9313b5aaf45b..7e8beff4ff22 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2818,7 +2818,19 @@ void skb_queue_purge(struct sk_buff_head *list);
 
 unsigned int skb_rbtree_purge(struct rb_root *root);
 
-void *netdev_alloc_frag(unsigned int fragsz);
+void *netdev_alloc_frag_align(unsigned int fragsz, int align);
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
+	return netdev_alloc_frag_align(fragsz, 0);
+}
 
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int length,
 				   gfp_t gfp_mask);
@@ -2877,7 +2889,13 @@ static inline void skb_free_frag(void *addr)
 	page_frag_free(addr);
 }
 
-void *napi_alloc_frag(unsigned int fragsz);
+void *napi_alloc_frag_align(unsigned int fragsz, int align);
+
+static inline void *napi_alloc_frag(unsigned int fragsz)
+{
+	return napi_alloc_frag_align(fragsz, 0);
+}
+
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi,
 				 unsigned int length, gfp_t gfp_mask);
 static inline struct sk_buff *napi_alloc_skb(struct napi_struct *napi,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2af12f7e170c..a35e75f12428 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -374,29 +374,22 @@ struct napi_alloc_cache {
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
 }
-EXPORT_SYMBOL(napi_alloc_frag);
+EXPORT_SYMBOL(napi_alloc_frag_align);
 
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
@@ -404,15 +397,15 @@ void *netdev_alloc_frag(unsigned int fragsz)
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
-EXPORT_SYMBOL(netdev_alloc_frag);
+EXPORT_SYMBOL(netdev_alloc_frag_align);
 
 /**
  *	__netdev_alloc_skb - allocate an skbuff for rx on a specific device
-- 
2.29.2

