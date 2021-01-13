Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AAF2F4FBF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbhAMQTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMQTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:19:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FD7C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:18:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t6so1343234plq.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2mBfeUd25g+LHLXPdeKtkMoLHAyQ5E95VvvGhTdHj04=;
        b=KjqU93gBELpdYCLOfMoT8lPJfYrkcfUzJO7DbH7YLFpiJ3S9E83Za5xu1QcXHpZsmv
         UH1hmPgvt3eQvmyT8Ifo7yGv57wk3Brxm2KDSJJiA3JRlKUS1Yrkh9XsBfrVK1gd5kYA
         9fxubrYxR+8i9K8d90TpUxCov9K3TWoU25enD5TV5Jzs54Wxen5FTBbpMtK3S4NjHOwF
         2RS5vteenTvipfHrrUDI7ok/aoHuFdwZnIKIh2cFxFcmUxKh0c2uUY2sn+v8aKwU4/Z9
         HWnpDY0oL6xXKPvyyENocyqwDyia26o8I4k0tRe0KlQA+LO4W2VeQ948hLyI5l9FUIs6
         9GiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2mBfeUd25g+LHLXPdeKtkMoLHAyQ5E95VvvGhTdHj04=;
        b=hcKLYyFiPq6U9MgoAD3FQ/bVEp8meQOCYpCaTZINF2bOLgDpK5ZJhdWrwZMCrnH2op
         yjyFI9NzgexWenMI9ULa11YfBzoTQB72hoQpqspCY/jSz8xcckYK8KBHX4RDrQ0CsVqm
         /ysr2OdkpBQwQKH6QgPJnE/eYV+hZchKZYnRO3xJiA2kSVRFBiuGsV4jM52W5/HzhIBJ
         1fClFgs1OZQUcjTsZjBlnjANL5Mbeaor2IIoaXVWMnORH6z6fbpF/xl9g043wMPjTb0M
         OZss6YUJTPA/H6VPKmG1hhNXpVEhH2lkwk3T5pElEpn0vkTXSzTrRkiR8jFmh5QiKUea
         38XQ==
X-Gm-Message-State: AOAM530nN940shr3vzha+ZT+nO8WB+46GJkgGwJqUAAhtvOurpApeMZE
        9b+AI5xYEWiQGiuKCoGQZ0A=
X-Google-Smtp-Source: ABdhPJzkL0kn2R138KofCFGRjJd4ILdc5SIgmQg+0H1t7uo9mqxbtpUTBKMwOjjCNsIvAXTYCI/LmQ==
X-Received: by 2002:a17:902:6a82:b029:da:fc41:bafe with SMTP id n2-20020a1709026a82b02900dafc41bafemr3012406plk.20.1610554704043;
        Wed, 13 Jan 2021 08:18:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id j17sm2953173pfh.183.2021.01.13.08.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:18:23 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
Date:   Wed, 13 Jan 2021 08:18:19 -0800
Message-Id: <20210113161819.1155526-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both virtio net and napi_get_frags() allocate skbs
with a very small skb->head

While using page fragments instead of a kmalloc backed skb->head might give
a small performance improvement in some cases, there is a huge risk of
under estimating memory usage.

For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
per page (order-3 page in x86), or even 64 on PowerPC

We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
but consuming far more memory for TCP buffers than instructed in tcp_mem[2]

Even if we force napi_alloc_skb() to only use order-0 pages, the issue
would still be there on arches with PAGE_SIZE >= 32768

This patch makes sure that small skb head are kmalloc backed, so that
other objects in the slab page can be reused instead of being held as long
as skbs are sitting in socket queues.

Note that we might in the future use the sk_buff napi cache,
instead of going through a more expensive __alloc_skb()

Another idea would be to use separate page sizes depending
on the allocated length (to never have more than 4 frags per page)

I would like to thank Greg Thelen for his precious help on this matter,
analysing crash dumps is always a time consuming task.

Fixes: fd11a83dd363 ("net: Pull out core bits of __netdev_alloc_skb and add __napi_alloc_skb")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexanderduyck@fb.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
---
 net/core/skbuff.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7626a33cce590e530f36167bd096026916131897..3a8f55a43e6964344df464a27b9b1faa0eb804f3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -501,13 +501,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 				 gfp_t gfp_mask)
 {
-	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
+	struct napi_alloc_cache *nc;
 	struct sk_buff *skb;
 	void *data;
 
 	len += NET_SKB_PAD + NET_IP_ALIGN;
 
-	if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
+	/* If requested length is either too small or too big,
+	 * we use kmalloc() for skb->head allocation.
+	 */
+	if (len <= SKB_WITH_OVERHEAD(1024) ||
+	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
@@ -515,6 +519,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 		goto skb_success;
 	}
 
+	nc = this_cpu_ptr(&napi_alloc_cache);
 	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	len = SKB_DATA_ALIGN(len);
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

