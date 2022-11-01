Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE556143CF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 05:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiKAEEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 00:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAEEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 00:04:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47B313F9A;
        Mon, 31 Oct 2022 21:04:42 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1brK2f6GzVj3y;
        Tue,  1 Nov 2022 11:59:45 +0800 (CST)
Received: from huawei.com (10.175.104.82) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 1 Nov
 2022 12:04:40 +0800
From:   Baisong Zhong <zhongbaisong@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <zhongbaisong@huawei.com>,
        <ast@kernel.org>, <song@kernel.org>, <yhs@fb.com>,
        <haoluo@google.com>
Subject: [PATCH -next] bpf, test_run: fix alignment problem in bpf_prog_test_run_skb()
Date:   Tue, 1 Nov 2022 12:04:40 +0800
Message-ID: <20221101040440.3637007-1-zhongbaisong@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, we got a syzkaller problem because of aarch64
alignment fault if KFENCE enabled.

When the size from user bpf program is an odd number, like
399, 407, etc, it will cause skb shard info's alignment access,
as seen below:

BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032

Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
 __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
 arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
 arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
 __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
 skb_clone+0xf4/0x214 net/core/skbuff.c:1481
 ____bpf_clone_redirect net/core/filter.c:2433 [inline]
 bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
 bpf_prog_d3839dd9068ceb51+0x80/0x330
 bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
 bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
 bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
 bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
 __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
 __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381

kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=407, cache=kmalloc-512

allocated by task 15074 on cpu 0 at 1342.585390s:
 kmalloc include/linux/slab.h:568 [inline]
 kzalloc include/linux/slab.h:675 [inline]
 bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
 bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
 bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
 __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
 __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
 __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381

To fix the problem, we round up allocations with kmalloc_size_roundup()
so that build_skb()'s use of kize() is always alignment and no special
handling of the memory is needed by KFENCE.

Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
---
 net/bpf/test_run.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..058b67108873 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -774,6 +774,7 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
 	if (user_size > size)
 		return ERR_PTR(-EMSGSIZE);
 
+	size = kmalloc_size_roundup(size);
 	data = kzalloc(size + headroom + tailroom, GFP_USER);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
-- 
2.25.1

