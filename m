Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715126121F1
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 11:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJ2JlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 05:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2JlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 05:41:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F311FCF7;
        Sat, 29 Oct 2022 02:41:06 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MzvYF4W9HzHvRr;
        Sat, 29 Oct 2022 17:40:49 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 17:41:04 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <peterpenkov96@gmail.com>,
        <maheshb@google.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>
Subject: [PATCH net v2] net: tun: fix bugs for oversize packet when napi frags enabled
Date:   Sat, 29 Oct 2022 17:41:01 +0800
Message-ID: <20221029094101.1653855-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, we got two syzkaller problems because of oversize packet
when napi frags enabled.

One of the problems is because the first seg size of the iov_iter
from user space is very big, it is 2147479538 which is bigger than
the threshold value for bail out early in __alloc_pages(). And
skb->pfmemalloc is true, __kmalloc_reserve() would use pfmemalloc
reserves without __GFP_NOWARN flag. Thus we got a warning as following:

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

The other problem is because odd IPv6 packets without NEXTHDR_NONE
extension header and have big packet length, it is 2127925 which is
bigger than ETH_MAX_MTU(65535). After ipv6_gso_pull_exthdrs() in
ipv6_gro_receive(), network_header offset and transport_header offset
are all bigger than U16_MAX. That would trigger skb->network_header
and skb->transport_header overflow error, because they are all '__u16'
type. Eventually, it would affect the value for __skb_push(skb, value),
and make it be a big value. After __skb_push() in ipv6_gro_receive(),
skb->data would less than skb->head, an out of bounds memory bug occurred.
That would trigger the problem as following:

==================================================================
BUG: KASAN: use-after-free in eth_type_trans+0x100/0x260
...
Call trace:
 dump_backtrace+0xd8/0x130
 show_stack+0x1c/0x50
 dump_stack_lvl+0x64/0x7c
 print_address_description.constprop.0+0xbc/0x2e8
 print_report+0x100/0x1e4
 kasan_report+0x80/0x120
 __asan_load8+0x78/0xa0
 eth_type_trans+0x100/0x260
 napi_gro_frags+0x164/0x550
 tun_get_user+0xda4/0x1270
 tun_chr_write_iter+0x74/0x130
 do_iter_readv_writev+0x130/0x1ec
 do_iter_write+0xbc/0x1e0
 vfs_writev+0x13c/0x26c

To fix the problems, restrict the packet size less than
(ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN) which has considered reserved
skb space in napi_alloc_skb() because transport_header is an offset from
skb->head. Add len check in tun_napi_alloc_frags() simply.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
v2:
  - Use (ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN) instead of ETH_MAX_MTU.
---
 drivers/net/tun.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 27c6d235cbda..946628050f28 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1459,7 +1459,8 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	int err;
 	int i;
 
-	if (it->nr_segs > MAX_SKB_FRAGS + 1)
+	if (it->nr_segs > MAX_SKB_FRAGS + 1 ||
+	    len > (ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN))
 		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
-- 
2.25.1

