Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE47A4ED424
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 08:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiCaGwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 02:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiCaGwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 02:52:05 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B585345798;
        Wed, 30 Mar 2022 23:50:18 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KTYny1lD0z1GDHG;
        Thu, 31 Mar 2022 14:49:58 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 14:50:16 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <vakul.garg@nxp.com>, <davejwatson@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net/tls: fix slab-out-of-bounds bug in decrypt_internal
Date:   Thu, 31 Mar 2022 15:04:28 +0800
Message-ID: <20220331070428.36111-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory size of tls_ctx->rx.iv for AES128-CCM is 12 setting in
tls_set_sw_offload(). The return value of crypto_aead_ivsize()
for "ccm(aes)" is 16. So memcpy() require 16 bytes from 12 bytes
memory space will trigger slab-out-of-bounds bug as following:

==================================================================
BUG: KASAN: slab-out-of-bounds in decrypt_internal+0x385/0xc40 [tls]
Read of size 16 at addr ffff888114e84e60 by task tls/10911

Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x5e/0x5db
 ? decrypt_internal+0x385/0xc40 [tls]
 kasan_report+0xab/0x120
 ? decrypt_internal+0x385/0xc40 [tls]
 kasan_check_range+0xf9/0x1e0
 memcpy+0x20/0x60
 decrypt_internal+0x385/0xc40 [tls]
 ? tls_get_rec+0x2e0/0x2e0 [tls]
 ? process_rx_list+0x1a5/0x420 [tls]
 ? tls_setup_from_iter.constprop.0+0x2e0/0x2e0 [tls]
 decrypt_skb_update+0x9d/0x400 [tls]
 tls_sw_recvmsg+0x3c8/0xb50 [tls]

Allocated by task 10911:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x81/0xa0
 tls_set_sw_offload+0x2eb/0xa20 [tls]
 tls_setsockopt+0x68c/0x700 [tls]
 __sys_setsockopt+0xfe/0x1b0

Replace the crypto_aead_ivsize() with prot->iv_size + prot->salt_size
when memcpy() iv value in TLS_1_3_VERSION scenario.

Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---

v1->v2:
  - Remove not-required modification.
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0024a692f0f8..a8976ef95528 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1496,7 +1496,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	if (prot->version == TLS_1_3_VERSION ||
 	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
 		memcpy(iv + iv_offset, tls_ctx->rx.iv,
-		       crypto_aead_ivsize(ctx->aead_recv));
+		       prot->iv_size + prot->salt_size);
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-- 
2.25.1

