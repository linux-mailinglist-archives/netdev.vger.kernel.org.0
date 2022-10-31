Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DEE613387
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJaKY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJaKYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:24:54 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13898DF2E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:24:49 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N18Mm1x64zJnPw;
        Mon, 31 Oct 2022 18:21:56 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 18:24:47 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <alobakin@pm.me>
Subject: [PATCH net] net: Fix memory leaks in napi_get_frags_check()
Date:   Mon, 31 Oct 2022 18:45:23 +0800
Message-ID: <1667213123-18922-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reports this issue:

unreferenced object 0xffff88819b8c97c0 (size 232):
  comm "ip", pid 2915, jiffies 4295153830 (age 408.877s)
  hex dump (first 32 bytes):
    00 80 8c 9b 81 88 ff ff e0 24 f7 12 81 88 ff ff  .........$......
    00 40 05 c0 81 88 ff ff 00 00 00 00 00 00 00 00  .@..............
  backtrace:
    [<0000000009fc179a>] napi_skb_cache_get+0xd4/0x150
    [<00000000b4383b46>] __napi_build_skb+0x15/0x50
    [<000000004902d9a0>] __napi_alloc_skb+0x26e/0x540
    [<00000000f9542b96>] napi_get_frags+0x59/0x140
    [<0000000002214936>] napi_get_frags_check+0x23/0xa0
    [<00000000c9a8df5a>] netif_napi_add_weight+0x443/0x910
    [<000000008f3a2156>] gro_cells_init+0x13f/0x230
    [<000000006f5f87fd>] vxlan_init+0x125/0x210 [vxlan]
    [<00000000f9d7479b>] register_netdevice+0x271/0xeb0
    [<000000003eb98c8e>] __vxlan_dev_create+0x2f2/0x780 [vxlan]
    [<00000000c5cdebe0>] vxlan_newlink+0xa0/0xf0 [vxlan]
    [<000000004a0b0607>] __rtnl_newlink+0xcae/0x1490
    [<0000000037188a06>] rtnl_newlink+0x5f/0x90
    [<00000000b2d4e2b2>] rtnetlink_rcv_msg+0x31a/0x980
    [<00000000613a7411>] netlink_rcv_skb+0x120/0x380
    [<00000000836c6e0e>] netlink_unicast+0x439/0x660

The root case here is: 
  napi_get_frags_check()
    napi_get_frags()
      napi_alloc_skb()
       __alloc_skb()  <-- with flag SKB_ALLOC_NAPI
        napi_skb_cache_get()
    ...
    napi_free_frags()
      kfree_skb()
        __kfree_skb()

In function napi_get_frags(), the skb is alloced by napi_skb_cache_get().
So, the skb should use __kfree_skb_defer (which called
napi_skb_cache_put()) to free.
To fix, add the function napi_free_frags_defer() to use __kfree_skb_defer
to free skb.

Fixes: cfb8ec659521 ("skbuff: allow to use NAPI cache from __napi_alloc_skb()")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 include/linux/netdevice.h | 8 ++++++++
 net/core/skbuff.c         | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee..0811663 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3833,6 +3833,14 @@ static inline void napi_free_frags(struct napi_struct *napi)
 	napi->skb = NULL;
 }
 
+static inline void napi_free_frags_defer(struct napi_struct *napi)
+{
+	if (!skb_unref(napi->skb))
+		return;
+	__kfree_skb_defer(napi->skb);
+	napi->skb = NULL;
+}
+
 bool netdev_is_rx_handler_busy(struct net_device *dev);
 int netdev_rx_handler_register(struct net_device *dev,
 			       rx_handler_func_t *rx_handler,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d1a3fa6..1db3634 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -214,7 +214,7 @@ void napi_get_frags_check(struct napi_struct *napi)
 	local_bh_disable();
 	skb = napi_get_frags(napi);
 	WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
-	napi_free_frags(napi);
+	napi_free_frags_defer(napi);
 	local_bh_enable();
 }
 
@@ -1073,6 +1073,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
 	skb_release_all(skb);
 	napi_skb_cache_put(skb);
 }
+EXPORT_SYMBOL(__kfree_skb_defer);
 
 void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
-- 
1.8.3.1

