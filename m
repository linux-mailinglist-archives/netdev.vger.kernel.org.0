Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69315AF98E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 03:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiIGB40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 21:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiIGB4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 21:56:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962328A6F7;
        Tue,  6 Sep 2022 18:56:24 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MMlcy2xBxzkYFS;
        Wed,  7 Sep 2022 09:52:34 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 09:56:22 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <peterpenkov96@gmail.com>,
        <maheshb@google.com>
Subject: [PATCH net] net: tun: limit first seg size to avoid oversized linearization
Date:   Wed, 7 Sep 2022 09:56:18 +0800
Message-ID: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, we found a syzkaller problem as following:

========================================================
WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
...
Call trace:
 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
 __alloc_pages_node include/linux/gfp.h:550 [inline]
 alloc_pages_node include/linux/gfp.h:564 [inline]
 kmalloc_large_node+0x94/0x350 mm/slub.c:4038
 __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
 __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
 pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
 __skb_grow include/linux/skbuff.h:2779 [inline]
 tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
 tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
 tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036

It is because the first seg size of the iov_iter from user space is
very big, it is 2147479538 which is bigger than the threshold value
for bail out early in __alloc_pages(). And skb->pfmemalloc is true,
__kmalloc_reserve() would use pfmemalloc reserves without __GFP_NOWARN
flag. Thus we got a warning.

I noticed that non-first segs size are required less than PAGE_SIZE in
tun_napi_alloc_frags(). The first seg should not be a special case, and
oversized linearization is also unreasonable. Limit the first seg size to
PAGE_SIZE to avoid oversized linearization.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/tun.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 259b2b84b2b3..7db515f94667 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1454,12 +1454,12 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 					    size_t len,
 					    const struct iov_iter *it)
 {
+	size_t linear = iov_iter_single_seg_count(it);
 	struct sk_buff *skb;
-	size_t linear;
 	int err;
 	int i;
 
-	if (it->nr_segs > MAX_SKB_FRAGS + 1)
+	if (it->nr_segs > MAX_SKB_FRAGS + 1 || linear > PAGE_SIZE)
 		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
@@ -1468,7 +1468,6 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	linear = iov_iter_single_seg_count(it);
 	err = __skb_grow(skb, linear);
 	if (err)
 		goto free;
-- 
2.25.1

