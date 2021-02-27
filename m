Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF53326E80
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 18:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhB0RzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 12:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhB0RwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 12:52:08 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1970C061786;
        Sat, 27 Feb 2021 09:51:26 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id m22so18831947lfg.5;
        Sat, 27 Feb 2021 09:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ob2T5k5brIJdqBYE3JocrXjjMAfzSoc4Yi9iZ4BS4g0=;
        b=nljZq5CZm9iha7F+TswMiWD+hvhRHZnQYr8qKmzybXWkNyEEcF8GzWeTrQ30PoIiL0
         J6lCfl8asKJ1HA4AzjU13ufz7jj0XZP38lnav3h/wyBCBdftr7Rpy2ujv/81oGtww54F
         KeM7boqNAe9H/L4uFsKvkz4X6D9AWj15ARaI6FG8+KOciYJEC1Tq9jakyvQARh9XO/y8
         AmT3daoTVpg6KvnorlkKvGzZKzucrHZVVG9Q3lhR2uwlGInh+jN/1Z5wcBc43UTBj+MG
         OU6oUmtDJiwSbyw/97/V9WTDm/pWaYKRdaHIGenlXTLlQmBvoVWwrntowNztpOu6djq7
         nHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ob2T5k5brIJdqBYE3JocrXjjMAfzSoc4Yi9iZ4BS4g0=;
        b=hHlEcaNmvBnKZ/kub9sRUA/k5HqqV6Zsa2OukB+/hqziskNNQERW0jA2em0drYo41N
         kdogV1B0XQJukuOcQmjEa/SHC8eD04duzDgrkDMZdpcVPpKspaBIwPEtj4fx5maMXWeH
         1i9bpnHiCdQ1jyMaZL/hxKRMpQ8QHovCug9Yc5bIv1qO9vx8BezWb1q6Yy8QVw0R18dy
         ImPR8SXsFr2II1FS/1r4/wBRwh80FN9sZO8pJg5N0UA2XpVj+i4bpO7TJkBgjZq8agFs
         3CK1YsJAPER5zAYbHVlafxE57Go4Dx08cJ2MykcEk0yVpydL6C3NSW/m7HegnQryuqPl
         dlPA==
X-Gm-Message-State: AOAM530y2U7hE8Sb4eW+edJf5Tymd0xJfS3lL+j8zt17rYK8FmB0ioB9
        TXU6KEPdPa/yy05Nbe2P4Nk=
X-Google-Smtp-Source: ABdhPJyj1b5SuvwrUqVrc2WxYEd/+2Y6h5HzYiycTLhmbuDXDQY89gnMjIphPbsj/3pXEEaRkxZbKw==
X-Received: by 2002:a05:6512:3184:: with SMTP id i4mr5109972lfe.314.1614448285223;
        Sat, 27 Feb 2021 09:51:25 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.59])
        by smtp.gmail.com with ESMTPSA id x192sm522455lff.68.2021.02.27.09.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 09:51:24 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alobakin@pm.me
Cc:     davem@davemloft.net, linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Subject: [PATCH v3] net/core/skbuff: fix passing wrong size to __alloc_skb
Date:   Sat, 27 Feb 2021 20:51:14 +0300
Message-Id: <20210227175114.28645-1-paskripkin@gmail.com>
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

---
Changes from v3:
* Removed Change-Id and extra tabs in net/core/skbuff.c

Changes from v2:
* Added length check to __napi_alloc_skb
* Added unlikely() in checks

Change from v1:
* Added length check to __netdev_alloc_skb
---
 net/core/skbuff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 785daff48030..ec7ba8728b61 100644
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

