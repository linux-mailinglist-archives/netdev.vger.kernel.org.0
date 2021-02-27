Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1F4326DEE
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 17:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhB0QnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 11:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhB0QmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 11:42:06 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E671C06174A;
        Sat, 27 Feb 2021 08:41:24 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id k12so5244140ljg.9;
        Sat, 27 Feb 2021 08:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2kJ+akVZdN0RZerG3cR+FK9vS9Cr6lCvITb5oXS64J4=;
        b=FsE8+G6D3CJ417+4kZs5yOR5XZsmI4X4DTVrqshFXL0ob3/OO8x5woXqypXEcutF3m
         oDNT7bD7lCTFMBKhv1GISBXNfg/wr40fp7Xn3eVnY8cP/niOa6cEZd33LC0rMIfrdpMJ
         J0MpgG+D8dCBF2hN47qaICc8AFU9xtY+g50RL5U++JMxagZKoLgoqMGh9iv7B8joDty+
         SZh7PO2mU/N7Vh4mlmmKXTQq8RsMbFOq31t+wEV5QparW20FQsqL/2U9Y7DTD72pDOnB
         7eDHxQnUbIxtL9lKNpqqRuFheUt/MikEWh6UEquMunAFTXNY+tdaoNo3s9JerY7ljnb+
         OKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2kJ+akVZdN0RZerG3cR+FK9vS9Cr6lCvITb5oXS64J4=;
        b=EFXJIugqQajo8kuk7R8tza3sZxN0e9sP7rtQOUc4rN+74G4UG7icuFxP4N7Tb/FoMs
         OlzInRzKWY84tpNvWeYv8O+svhxvw0opJoMB7Tgp8GXj+iGW2v63xKGDob46EW6jkGcz
         zq5DXDrNrqbDeg8kXjHHRwMJlF7G8LshBHu9ndNLG2E5xbKmex7ERlMynjXp/mfS1jCW
         2IVK2wie4NuTf3HPxDYWvfEtxuwKnJKSHodl3AKr/7hk6svDcFHwA6nhlhIOCFnyAXZC
         WcFRmo76MxGG5QH4LaeThKz2Og0m+pZalCeXGhxzT+u12d+tGILcS0RUQpkDrX3Gg+Uo
         W6DQ==
X-Gm-Message-State: AOAM5319CcX6pUHm7BloqmzqKvD7Sn9kPVR8bnPGiK43z4aEh2MK+nFY
        6QrhMn2eA/TjThxZaQEAqZw=
X-Google-Smtp-Source: ABdhPJxFCszFUea7FawYs/6SUHk8XvOJQTlQBLwm+ULp1tyXV41NJYMQqRJshbMYfK9sLoUxG1JQoA==
X-Received: by 2002:a05:651c:229:: with SMTP id z9mr4839872ljn.267.1614444082640;
        Sat, 27 Feb 2021 08:41:22 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.59])
        by smtp.gmail.com with ESMTPSA id q16sm1726626lfu.153.2021.02.27.08.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 08:41:22 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alobakin@pm.me
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        linmiaohe@huawei.com, netdev@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Subject: [PATCH v2] net/core/skbuff: fix passing wrong size to __alloc_skb
Date:   Sat, 27 Feb 2021 19:41:01 +0300
Message-Id: <20210227164101.19071-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227110306.13360-1-alobakin@pm.me>
References: <20210227110306.13360-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found WARNING in __alloc_pages_nodemask()[1] when order >= MAX_ORDER.
It was caused by __netdev_alloc_skb(), which doesn't check len value after adding NET_SKB_PAD.
Order will be >= MAX_ORDER and passed to __alloc_pages_nodemask() if size > KMALLOC_MAX_SIZE.
Same happens in __napi_alloc_skb.

static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
{
	struct page *page;
	void *ptr = NULL;
	unsigned int order = get_order(size);
...
	page = alloc_pages_node(node, flags, order);
...

[1] WARNING in __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
Call Trace:
 __alloc_pages include/linux/gfp.h:511 [inline]
 __alloc_pages_node include/linux/gfp.h:524 [inline]
 alloc_pages_node include/linux/gfp.h:538 [inline]
 kmalloc_large_node+0x60/0x110 mm/slub.c:3999
 __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
 __kmalloc_reserve net/core/skbuff.c:150 [inline]
 __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
 __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
 netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
 qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
 qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Change-Id: I480a6d6f818a4c0a387db0cd3f230b68a7daeb16
---
 net/core/skbuff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 785daff48030..a35ba145a060 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 	if (len <= SKB_WITH_OVERHEAD(1024) ||
 	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
+		if (unlikely(len > KMALLOC_MAX_SIZE))
+			return NULL;
+
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
 			goto skb_fail;
@@ -517,6 +520,9 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 	if (len <= SKB_WITH_OVERHEAD(1024) ||
 	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
+		if (unlikely(len > KMALLOC_MAX_SIZE))
+			return NULL;
+		
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
 			goto skb_fail;
-- 
2.25.1

