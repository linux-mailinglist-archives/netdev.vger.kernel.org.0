Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2297615A96
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiKBDeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiKBDeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:34:05 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31257C9;
        Tue,  1 Nov 2022 20:34:04 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2CD64qbpz15MK2;
        Wed,  2 Nov 2022 11:33:58 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 11:34:01 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ecree@solarflare.com>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH net] net: Fix memory leaks of napi->rx_list
Date:   Wed, 2 Nov 2022 11:54:34 +0800
Message-ID: <1667361274-2621-1-git-send-email-wangyufen@huawei.com>
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

kmemleak reports after running test_progs:

unreferenced object 0xffff8881b1672dc0 (size 232):
  comm "test_progs", pid 394388, jiffies 4354712116 (age 841.975s)
  hex dump (first 32 bytes):
    e0 84 d7 a8 81 88 ff ff 80 2c 67 b1 81 88 ff ff  .........,g.....
    00 40 c5 9b 81 88 ff ff 00 00 00 00 00 00 00 00  .@..............
  backtrace:
    [<00000000c8f01748>] napi_skb_cache_get+0xd4/0x150
    [<0000000041c7fc09>] __napi_build_skb+0x15/0x50
    [<00000000431c7079>] __napi_alloc_skb+0x26e/0x540
    [<000000003ecfa30e>] napi_get_frags+0x59/0x140
    [<0000000099b2199e>] tun_get_user+0x183d/0x3bb0 [tun]
    [<000000008a5adef0>] tun_chr_write_iter+0xc0/0x1b1 [tun]
    [<0000000049993ff4>] do_iter_readv_writev+0x19f/0x320
    [<000000008f338ea2>] do_iter_write+0x135/0x630
    [<000000008a3377a4>] vfs_writev+0x12e/0x440
    [<00000000a6b5639a>] do_writev+0x104/0x280
    [<00000000ccf065d8>] do_syscall_64+0x3b/0x90
    [<00000000d776e329>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue occurs in the following scenarios:
tun_get_user()
  napi_gro_frags()
    napi_frags_finish()
      case GRO_NORMAL:
        gro_normal_one()
          list_add_tail(&skb->list, &napi->rx_list);
          <-- While napi->rx_count < READ_ONCE(gro_normal_batch),
          <-- gro_normal_list() is not called, napi->rx_list is not empty
...
netif_napi_del()
  __netif_napi_del()
  <-- &napi->rx_list is not empty, which caused memory leaks

To fix, add flush_rx_list() to free skbs in napi->rx_list.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 net/core/dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3be2560..de3bc9c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6461,6 +6461,16 @@ static void flush_gro_hash(struct napi_struct *napi)
 	}
 }
 
+static void flush_rx_list(struct napi_struct *napi)
+{
+	struct sk_buff *skb, *next;
+
+	list_for_each_entry_safe(skb, next, &napi->rx_list, list) {
+		skb_list_del_init(skb);
+		kfree_skb(skb);
+	}
+}
+
 /* Must be called in process context */
 void __netif_napi_del(struct napi_struct *napi)
 {
@@ -6471,6 +6481,7 @@ void __netif_napi_del(struct napi_struct *napi)
 	list_del_rcu(&napi->dev_list);
 	napi_free_frags(napi);
 
+	flush_rx_list(napi);
 	flush_gro_hash(napi);
 	napi->gro_bitmask = 0;
 
-- 
1.8.3.1

