Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0595326745
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 20:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhBZTMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 14:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBZTMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 14:12:14 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A469AC061574;
        Fri, 26 Feb 2021 11:11:33 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id 2so7276791ljr.5;
        Fri, 26 Feb 2021 11:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IBtIidwVwaIktxepbeCDx/8gfJLnxmhlZEhvJa7e2JM=;
        b=MoI9sH+xS+N7OBJbwDA0LImxeRrpl7LUczU+TJTygbMNzB22Qdr1WjaavoIxuqpExh
         ThwGYWvP7XH/yISb2ieM1zg3qlTQItUxEVDiShJB7FQw3d/R7WHAXXHQfPzowbJhQ2eH
         f/MsMF4UpF4lfPb/3BSVyltleh5h/W34iFaHJ4v/YZw/7tmRABEGfNBG83CwEUymXj8A
         Wz9AWiHaRd2A0m2LUMxeQE1ertmO8ALzETCNLAyqjY/qL6yL9hDrYFy7sv7bOORmLxoA
         hHl8RRqffc48Vp3sb+XewfvCvope5o2n0LwyjhmI8fLRkQlpNZ0b7QhVt3bJR4UcKUFG
         aCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IBtIidwVwaIktxepbeCDx/8gfJLnxmhlZEhvJa7e2JM=;
        b=iDay+iHIZIl+uRZVsQ2tOcicB3tNUmag+lkCgb3MeowOoxcMC8Ng8DrTZcHI9kGOQX
         xWXD8SJE7plzShgrDyHlMGu9iPY18rmTAJks0RjhEq+mhciI34s5+4rbXmVrqOoy+84z
         l5/6s6X0i9J4KXVI46GBSuq89Cwly6otxjYBEaePXcyuQOfxc+uAvg/QNaFdJCqI1ig4
         8LZmCA+K/ZyWOD2GoDkFJqQpwBAVp1/AYdWd2BQhU9VtBSxc5BitRww/Uc66//A7FzJ4
         UPuGYvxlbMTi1eVgZw5N4fYxtG1ah5JnjfDl+T7KiiLsZK5AbL5OPoS0j7G3tOz6oeUH
         kRSw==
X-Gm-Message-State: AOAM533XmSqqpyfNc2yTcrjPmoiwRtJ6ZlvLolkoIgNZVeAsj7904gtE
        ZLzvw86znKDBoYKZZfMNpUM=
X-Google-Smtp-Source: ABdhPJysY0omAmg5k2/lT1pUubT7iOOiWMSX8eFbJyo1D/LcaV3cOa42Hj1XnztgLuDez6RV12a+Cw==
X-Received: by 2002:a2e:7f1b:: with SMTP id a27mr2411804ljd.225.1614366692167;
        Fri, 26 Feb 2021 11:11:32 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.59])
        by smtp.gmail.com with ESMTPSA id n7sm1472506lfu.123.2021.02.26.11.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 11:11:31 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linmiaohe@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Subject: [PATCH] net/core/skbuff.c: __netdev_alloc_skb fix when len is greater than KMALLOC_MAX_SIZE
Date:   Fri, 26 Feb 2021 22:11:06 +0300
Message-Id: <20210226191106.554553-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found WARNING in __alloc_pages_nodemask()[1] when order >= MAX_ORDER.
It was caused by __netdev_alloc_skb(), which doesn't check len value after adding NET_SKB_PAD.
Order will be >= MAX_ORDER and passed to __alloc_pages_nodemask() if size > KMALLOC_MAX_SIZE.

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
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 785daff48030..dc28c8f7bf5f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 	if (len <= SKB_WITH_OVERHEAD(1024) ||
 	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
+		if (len > KMALLOC_MAX_SIZE)
+			return NULL;
+
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
 			goto skb_fail;
-- 
2.25.1

