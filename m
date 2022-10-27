Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F760EEE0
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 06:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiJ0ED4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 00:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiJ0EDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 00:03:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395C4125034
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 21:03:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-367dc159c2fso1542557b3.19
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 21:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q3iC2p0+XlncL4bUduQLe6rqmzApPMQ2wtbgQuwzGwc=;
        b=KMV7Ihyadye9tDpqMc2IJfrjKsWbU0upQi62DkfdLRyF/FMTF9vXWRSfNYikj+Rc2f
         ThQh4GsO+406+Brda4S63NOHp8SreJhkFeZ3lN0qI6q/6sGizGGGqyf+SQvrUGmgETlB
         5vnSiL9JX337FGJgMDXNn7iwFN93FiiFFqjr3kvBXPW86kjOrSch+qhQUSJKmUdocw/H
         jDZr7BaXfsgxbW0y/zGrf8Rxwt07Ps6F6PokNGWpijxeuCqLT4jnKorP9R9H68M3z0uX
         UpJuWUogH3dG7SsxpvHFlKE9JBQvgfYZDz9GlJ43uOBA5ue5SJMdUjqUGm6fI//i16J+
         L6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q3iC2p0+XlncL4bUduQLe6rqmzApPMQ2wtbgQuwzGwc=;
        b=6q80Gp+kZXcb7uLe/CMAHPGGH+Z0ZF5sQ8NTWg8hhggood5wVsj5iAXpE3ZE8eLo5c
         HAJ96SbPbRXSKL0z4Bk4Gle9+STul6KLypxZKY/4gg3QS9NS5r5Or83gg/mMMV96IyP3
         Fny41667WogY4aA9iW1s9tx35mVTrPJ5JkU1A1XMSdHBjGh6BSPryFW7teGGe75OXswF
         xHlFt2+Hym0j8OMH9xUQ8k8ndSE17DPSfe7iqfZKIFbcR0/mhvaNbniRW2gkq7Y+2/P/
         n5PLsHNzD1dyH5j6TUUZXtiPZKc6mhKoBFq6fqTGKCa9FuqilWgp2gswx38N1hs6RNaC
         e/SA==
X-Gm-Message-State: ACrzQf1ycJ3BfokYPAU2Hu7wr/cPKOBHdGZpjCfqoqb66t5Citb7dpvr
        XE4wpevpL2LzHeWvGsUDmBaHKF7ZXG53NQ==
X-Google-Smtp-Source: AMsMyM5EDOA45ormU5RaTFvrZriJaE/wICFEvEeKRiBDMU7LicQ3H2LB5lW2N8euJ3gKfXBYrPwQyD0XZRTR6w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9d83:0:b0:6bd:57a9:143a with SMTP id
 v3-20020a259d83000000b006bd57a9143amr0ybp.218.1666843431382; Wed, 26 Oct 2022
 21:03:51 -0700 (PDT)
Date:   Thu, 27 Oct 2022 04:03:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027040346.1104204-1-edumazet@google.com>
Subject: [PATCH net] net: do not sense pfmemalloc status in skb_append_pagefrags()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_append_pagefrags() is used by af_unix and udp sendpage()
implementation so far.

In commit 326140063946 ("tcp: TX zerocopy should not sense
pfmemalloc status") we explained why we should not sense
pfmemalloc status for pages owned by user space.

We should also use skb_fill_page_desc_noacc()
in skb_append_pagefrags() to avoid following KCSAN report:

BUG: KCSAN: data-race in lru_add_fn / skb_append_pagefrags

write to 0xffffea00058fc1c8 of 8 bytes by task 17319 on cpu 0:
__list_add include/linux/list.h:73 [inline]
list_add include/linux/list.h:88 [inline]
lruvec_add_folio include/linux/mm_inline.h:323 [inline]
lru_add_fn+0x327/0x410 mm/swap.c:228
folio_batch_move_lru+0x1e1/0x2a0 mm/swap.c:246
lru_add_drain_cpu+0x73/0x250 mm/swap.c:669
lru_add_drain+0x21/0x60 mm/swap.c:773
free_pages_and_swap_cache+0x16/0x70 mm/swap_state.c:311
tlb_batch_pages_flush mm/mmu_gather.c:59 [inline]
tlb_flush_mmu_free mm/mmu_gather.c:256 [inline]
tlb_flush_mmu+0x5b2/0x640 mm/mmu_gather.c:263
tlb_finish_mmu+0x86/0x100 mm/mmu_gather.c:363
exit_mmap+0x190/0x4d0 mm/mmap.c:3098
__mmput+0x27/0x1b0 kernel/fork.c:1185
mmput+0x3d/0x50 kernel/fork.c:1207
copy_process+0x19fc/0x2100 kernel/fork.c:2518
kernel_clone+0x166/0x550 kernel/fork.c:2671
__do_sys_clone kernel/fork.c:2812 [inline]
__se_sys_clone kernel/fork.c:2796 [inline]
__x64_sys_clone+0xc3/0xf0 kernel/fork.c:2796
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffffea00058fc1c8 of 8 bytes by task 17325 on cpu 1:
page_is_pfmemalloc include/linux/mm.h:1817 [inline]
__skb_fill_page_desc include/linux/skbuff.h:2432 [inline]
skb_fill_page_desc include/linux/skbuff.h:2453 [inline]
skb_append_pagefrags+0x210/0x600 net/core/skbuff.c:3974
unix_stream_sendpage+0x45e/0x990 net/unix/af_unix.c:2338
kernel_sendpage+0x184/0x300 net/socket.c:3561
sock_sendpage+0x5a/0x70 net/socket.c:1054
pipe_to_sendpage+0x128/0x160 fs/splice.c:361
splice_from_pipe_feed fs/splice.c:415 [inline]
__splice_from_pipe+0x222/0x4d0 fs/splice.c:559
splice_from_pipe fs/splice.c:594 [inline]
generic_splice_sendpage+0x89/0xc0 fs/splice.c:743
do_splice_from fs/splice.c:764 [inline]
direct_splice_actor+0x80/0xa0 fs/splice.c:931
splice_direct_to_actor+0x305/0x620 fs/splice.c:886
do_splice_direct+0xfb/0x180 fs/splice.c:974
do_sendfile+0x3bf/0x910 fs/read_write.c:1255
__do_sys_sendfile64 fs/read_write.c:1323 [inline]
__se_sys_sendfile64 fs/read_write.c:1309 [inline]
__x64_sys_sendfile64+0x10c/0x150 fs/read_write.c:1309
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x0000000000000000 -> 0xffffea00058fc188

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 17325 Comm: syz-executor.0 Not tainted 6.1.0-rc1-syzkaller-00158-g440b7895c990-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022

Fixes: 326140063946 ("tcp: TX zerocopy should not sense pfmemalloc status")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d9ea6ca40979ff3ba95afec4f5b37..d1a3fa6f3f1265497c0a65f8b958c6312f5f0663 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3971,7 +3971,7 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	} else if (i < MAX_SKB_FRAGS) {
 		skb_zcopy_downgrade_managed(skb);
 		get_page(page);
-		skb_fill_page_desc(skb, i, page, offset, size);
+		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
 	}
-- 
2.38.1.273.g43a17bfeac-goog

