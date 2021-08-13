Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593F93EB728
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 16:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240969AbhHMO63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 10:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbhHMO61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 10:58:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38D1C061756;
        Fri, 13 Aug 2021 07:58:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so16369767pjb.3;
        Fri, 13 Aug 2021 07:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIxYs8ZFxmYhiFq5p0PeX+N+Q5/J7OLXipqllrYK6/w=;
        b=KlNdNHCLJby8KxhDbZnl2t/Zafi6negWcdlb43BmkLeo4NHBFMom3e6NtVjZdtpYEe
         yNtVzsSSSqthLfESR3VzZ4mAG/nnst0f+xCbVslycdQrg26wEfOsMLEXHCoe2vcpf6q4
         iEbdUGbK3nfKAI4wCA5ARvGcIyIMfUzC02pp4bV4FTMystCycl4dbQOtP0ME1G+npmIs
         f8b4g8vgp6r8aJxxP6CqVFsjVcUgXnIputTqTuQN9sqkOJvYDDcfGHQZfO/jYoD2uB2Y
         zCwREXGKHtaEAGJCUo+Tz3iYop0XxyQYrcYcAnK9Oo0E8DXgULcW4dACf+MmeY1CojTY
         9k1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIxYs8ZFxmYhiFq5p0PeX+N+Q5/J7OLXipqllrYK6/w=;
        b=kSludYe2IbvjUj0slTukOs0DbrvcEWADloJlClY7Q6nFFilQkToGMu0rCv+52F+CnZ
         Rdi7cDtLrwYmJ1rW7nWrn0JynU0X14ciGcAP/j0/P84Tl1xHI8RWXcs5+NXS272vSWat
         Nhdb0ve2STvYsArJhjytw2RMWzQ5mrCPeOs53LRtVIMBBUTQUbp3+gIxo1ItlpchwC0+
         wtjLhnN5MJAPa/t2Wr4XvXxDZo39VxNV/bMPO4FB0MIKiiSElBt60IwUj5kwgtkb9KgM
         Jr7gO281pb+FxR445mFvF2uCns8gjl+03B8BpoO6puV1qmubfgsiYqJIFupzPLx4nfib
         2sSw==
X-Gm-Message-State: AOAM531MoZHTTvE+Ek6X7S3T01QwHdKlj7heQnjw1IxWx3GEnKKcJy9t
        42rJA09/yPnLx7cr+AexKc0=
X-Google-Smtp-Source: ABdhPJyllrJr859w1e7CFPpLuUHf91BE/yDxCU4yZvQ/rgU5UFKkgJzLNMBWsldljFxoNm5th5+VGA==
X-Received: by 2002:aa7:9906:0:b029:3c7:a6a1:c73d with SMTP id z6-20020aa799060000b02903c7a6a1c73dmr2927697pff.1.1628866680387;
        Fri, 13 Aug 2021 07:58:00 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id g14sm2903379pfr.31.2021.08.13.07.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 07:57:59 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>
Subject: [PATCH] net: in_irq() cleanup
Date:   Fri, 13 Aug 2021 22:57:49 +0800
Message-Id: <20210813145749.86512-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the obsolete and ambiguos macro in_irq() with new
macro in_hardirq().

Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 include/linux/netdevice.h | 2 +-
 net/core/bpf_sk_storage.c | 4 ++--
 net/core/dev.c            | 2 +-
 net/core/skbuff.c         | 6 +++---
 net/nfc/rawsock.c         | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..3edc793546e7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3948,7 +3948,7 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason);
 /*
  * It is not allowed to call kfree_skb() or consume_skb() from hardware
  * interrupt context or with hardware interrupts being disabled.
- * (in_irq() || irqs_disabled())
+ * (in_hardirq() || irqs_disabled())
  *
  * We provide four helpers that can be used in following contexts :
  *
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index f564f82e91d9..68d2cbf8331a 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -416,7 +416,7 @@ static bool bpf_sk_storage_tracing_allowed(const struct bpf_prog *prog)
 BPF_CALL_4(bpf_sk_storage_get_tracing, struct bpf_map *, map, struct sock *, sk,
 	   void *, value, u64, flags)
 {
-	if (in_irq() || in_nmi())
+	if (in_hardirq() || in_nmi())
 		return (unsigned long)NULL;
 
 	return (unsigned long)____bpf_sk_storage_get(map, sk, value, flags);
@@ -425,7 +425,7 @@ BPF_CALL_4(bpf_sk_storage_get_tracing, struct bpf_map *, map, struct sock *, sk,
 BPF_CALL_2(bpf_sk_storage_delete_tracing, struct bpf_map *, map,
 	   struct sock *, sk)
 {
-	if (in_irq() || in_nmi())
+	if (in_hardirq() || in_nmi())
 		return -EPERM;
 
 	return ____bpf_sk_storage_delete(map, sk);
diff --git a/net/core/dev.c b/net/core/dev.c
index 8f1a47ad6781..b743b3702f40 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3190,7 +3190,7 @@ EXPORT_SYMBOL(__dev_kfree_skb_irq);
 
 void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
-	if (in_irq() || irqs_disabled())
+	if (in_hardirq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
 	else
 		dev_kfree_skb(skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fc7942c0dddc..ba1cd7071ef0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -156,7 +156,7 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 	void *data;
 
 	fragsz = SKB_DATA_ALIGN(fragsz);
-	if (in_irq() || irqs_disabled()) {
+	if (in_hardirq() || irqs_disabled()) {
 		nc = this_cpu_ptr(&netdev_alloc_cache);
 		data = page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align_mask);
 	} else {
@@ -502,7 +502,7 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
-	if (in_irq() || irqs_disabled()) {
+	if (in_hardirq() || irqs_disabled()) {
 		nc = this_cpu_ptr(&netdev_alloc_cache);
 		data = page_frag_alloc(nc, len, gfp_mask);
 		pfmemalloc = nc->pfmemalloc;
@@ -724,7 +724,7 @@ void skb_release_head_state(struct sk_buff *skb)
 {
 	skb_dst_drop(skb);
 	if (skb->destructor) {
-		WARN_ON(in_irq());
+		WARN_ON(in_hardirq());
 		skb->destructor(skb);
 	}
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 5e39640becdb..0ca214ab5aef 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -140,7 +140,7 @@ static void rawsock_data_exchange_complete(void *context, struct sk_buff *skb,
 {
 	struct sock *sk = (struct sock *) context;
 
-	BUG_ON(in_irq());
+	BUG_ON(in_hardirq());
 
 	pr_debug("sk=%p err=%d\n", sk, err);
 
-- 
2.30.2

