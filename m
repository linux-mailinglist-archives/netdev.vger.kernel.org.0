Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4105A89BA
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiIAAK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 20:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIAAK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 20:10:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CE37F259
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 17:10:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n8-20020a17090a73c800b001fd832b54f6so896114pjk.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 17:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DFPFgAkSz6ZpDaYawuJ9eytD8nlRvU+pO+OB6u1AXMc=;
        b=YoF4yhvEAfcxVSzc0UnUKWLtuQopRJXluAEmJpxU7ihN9aeqcvAzR0mlgmR5adyPdr
         aTwrpkBDyRnfeCL/TCgOfh1ZI1WNxHd/xahBB69KstGxVKKvejTH5H1Fwfn/9rX2MIWD
         yuRVL1FOnvrGP7lmWEJJCKwT1oRdJ0NufD7hGxZmTf4E3laJHKoQ7n19wXj/+ViZa1PE
         DEvB7V3Am/y3WDj3KXtba5Ij4ICs7QFjyUXPDJ0gOOEroBT3kWDGbF4AzjxDe6L5w724
         qDlZFkFgoiNsOL18C0jCTf6QIpmM+Xp1446gTx81pR1+M4KGKIgJCuQ1FsTn/pSNM5ob
         AlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DFPFgAkSz6ZpDaYawuJ9eytD8nlRvU+pO+OB6u1AXMc=;
        b=akfTriOgaapS2fofzJi25QvsCaTpJEYzsTn6RqswjFSWYzMwO0cKNgqIOa5RyMmhIC
         pqH3R7ZOQwc5lekgE+wfDaEarodtr2zi+rNY7DwwWKhaRz6MMed9zMLrahFlJM7uCRAE
         /OKuCVsbeYTAP7Gjm6Jg9NWIv5T0jpPAPIr0yBT9JQr65T8nP52g5LmSdjT1hACIJVdc
         4XupOVmub/WT11Nw3pHA5iHQyrJl6nDME73pZjFmh2GB9Fr7SGhqyvrCQ6u39rjtKzQT
         YZZUq8Bgc3y5E3NnerxUE0OxRhZxG93HqaXBnJFJ2zCfuw+5HvhBoo+PloqxF4QMnEwd
         6xgw==
X-Gm-Message-State: ACgBeo3M6mqfCZrYhbvl4d+uPiznfn+xagWGyzl7rcHEXvh91GxkVrw4
        UiFE+DA0Vc8huMr4CGzGqG4twmodgrbnmG0UnWcNaQ==
X-Google-Smtp-Source: AA6agR4Kg4CRjec4Efhwsn0NiN8xP/TK6bmpDwey9WLsdObesVByY93f6v1Xrrfv6UpK8Zim8sreAXjNxxrp0AviPhI=
X-Received: by 2002:a17:902:b410:b0:172:c9d1:7501 with SMTP id
 x16-20020a170902b41000b00172c9d17501mr28258768plr.106.1661991054865; Wed, 31
 Aug 2022 17:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220831233809.242987-1-edumazet@google.com>
In-Reply-To: <20220831233809.242987-1-edumazet@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 31 Aug 2022 17:10:42 -0700
Message-ID: <CALvZod4UTy-1B_0YBdnk2_9u7EBwkVKzQRL0cErP-s2JdW5vPw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: TX zerocopy should not sense pfmemalloc status
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 4:38 PM Eric Dumazet <edumazet@google.com> wrote:
>
> We got a recent syzbot report [1] showing a possible misuse
> of pfmemalloc page status in TCP zerocopy paths.
>
> Indeed, for pages coming from user space or other layers,
> using page_is_pfmemalloc() is moot, and possibly could give
> false positives.
>
> There has been attempts to make page_is_pfmemalloc() more robust,
> but not using it in the first place in this context is probably better,
> removing cpu cycles.
>
> Note to stable teams :
>
> You need to backport 84ce071e38a6 ("net: introduce
> __skb_fill_page_desc_noacc") as a prereq.
>
> Race is more probable after commit c07aea3ef4d4
> ("mm: add a signature in struct page") because page_is_pfmemalloc()
> is now using low order bit from page->lru.next, which can change
> more often than page->index.
>
> Low order bit should never be set for lru.next (when used as an anchor
> in LRU list), so KCSAN report is mostly a false positive.
>
> Backporting to older kernel versions seems not necessary.
>
> [1]
> BUG: KCSAN: data-race in lru_add_fn / tcp_build_frag
>
> write to 0xffffea0004a1d2c8 of 8 bytes by task 18600 on cpu 0:
> __list_add include/linux/list.h:73 [inline]
> list_add include/linux/list.h:88 [inline]
> lruvec_add_folio include/linux/mm_inline.h:105 [inline]
> lru_add_fn+0x440/0x520 mm/swap.c:228
> folio_batch_move_lru+0x1e1/0x2a0 mm/swap.c:246
> folio_batch_add_and_move mm/swap.c:263 [inline]
> folio_add_lru+0xf1/0x140 mm/swap.c:490
> filemap_add_folio+0xf8/0x150 mm/filemap.c:948
> __filemap_get_folio+0x510/0x6d0 mm/filemap.c:1981
> pagecache_get_page+0x26/0x190 mm/folio-compat.c:104
> grab_cache_page_write_begin+0x2a/0x30 mm/folio-compat.c:116
> ext4_da_write_begin+0x2dd/0x5f0 fs/ext4/inode.c:2988
> generic_perform_write+0x1d4/0x3f0 mm/filemap.c:3738
> ext4_buffered_write_iter+0x235/0x3e0 fs/ext4/file.c:270
> ext4_file_write_iter+0x2e3/0x1210
> call_write_iter include/linux/fs.h:2187 [inline]
> new_sync_write fs/read_write.c:491 [inline]
> vfs_write+0x468/0x760 fs/read_write.c:578
> ksys_write+0xe8/0x1a0 fs/read_write.c:631
> __do_sys_write fs/read_write.c:643 [inline]
> __se_sys_write fs/read_write.c:640 [inline]
> __x64_sys_write+0x3e/0x50 fs/read_write.c:640
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> read to 0xffffea0004a1d2c8 of 8 bytes by task 18611 on cpu 1:
> page_is_pfmemalloc include/linux/mm.h:1740 [inline]
> __skb_fill_page_desc include/linux/skbuff.h:2422 [inline]
> skb_fill_page_desc include/linux/skbuff.h:2443 [inline]
> tcp_build_frag+0x613/0xb20 net/ipv4/tcp.c:1018
> do_tcp_sendpages+0x3e8/0xaf0 net/ipv4/tcp.c:1075
> tcp_sendpage_locked net/ipv4/tcp.c:1140 [inline]
> tcp_sendpage+0x89/0xb0 net/ipv4/tcp.c:1150
> inet_sendpage+0x7f/0xc0 net/ipv4/af_inet.c:833
> kernel_sendpage+0x184/0x300 net/socket.c:3561
> sock_sendpage+0x5a/0x70 net/socket.c:1054
> pipe_to_sendpage+0x128/0x160 fs/splice.c:361
> splice_from_pipe_feed fs/splice.c:415 [inline]
> __splice_from_pipe+0x222/0x4d0 fs/splice.c:559
> splice_from_pipe fs/splice.c:594 [inline]
> generic_splice_sendpage+0x89/0xc0 fs/splice.c:743
> do_splice_from fs/splice.c:764 [inline]
> direct_splice_actor+0x80/0xa0 fs/splice.c:931
> splice_direct_to_actor+0x305/0x620 fs/splice.c:886
> do_splice_direct+0xfb/0x180 fs/splice.c:974
> do_sendfile+0x3bf/0x910 fs/read_write.c:1249
> __do_sys_sendfile64 fs/read_write.c:1317 [inline]
> __se_sys_sendfile64 fs/read_write.c:1303 [inline]
> __x64_sys_sendfile64+0x10c/0x150 fs/read_write.c:1303
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> value changed: 0x0000000000000000 -> 0xffffea0004a1d288
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 18611 Comm: syz-executor.4 Not tainted 6.0.0-rc2-syzkaller-00248-ge022620b5d05-dirty #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
>
> Fixes: c07aea3ef4d4 ("mm: add a signature in struct page")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
