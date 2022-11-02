Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8193615F17
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 10:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiKBJMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 05:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiKBJLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 05:11:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E3A29828;
        Wed,  2 Nov 2022 02:10:07 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2Lgb09w2zHvbq;
        Wed,  2 Nov 2022 17:09:47 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 17:10:05 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <peterpenkov96@gmail.com>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH net] net: tun: Fix memory leaks of napi_get_frags
Date:   Wed, 2 Nov 2022 17:30:39 +0800
Message-ID: <1667381439-4419-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
  <-- not ask to complete the gro work, will cause memory leaks in
  <-- following tun_napi_del()
...
tun_napi_del()
  netif_napi_del()
    __netif_napi_del()
    <-- &napi->rx_list is not empty, which caused memory leaks

To fix, add napi_complete() after napi_gro_frags().

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/tun.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 27c6d23..910990d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1864,13 +1864,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
-		kfree_skb(skb);
-		if (frags) {
-			tfile->napi.skb = NULL;
-			mutex_unlock(&tfile->napi_mutex);
-		}
-
-		return -EINVAL;
+		err = -EINVAL;
+		goto drop;
 	}
 
 	switch (tun->flags & TUN_TYPE_MASK) {
@@ -1886,9 +1881,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				dev_core_stats_rx_dropped_inc(tun->dev);
-				kfree_skb(skb);
-				return -EINVAL;
+				err = -EINVAL;
+				goto drop;
 			}
 		}
 
@@ -1976,6 +1970,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		local_bh_disable();
 		napi_gro_frags(&tfile->napi);
+		napi_complete(&tfile->napi);
 		local_bh_enable();
 		mutex_unlock(&tfile->napi_mutex);
 	} else if (tfile->napi_enabled) {
-- 
1.8.3.1

