Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424344C0F22
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 10:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiBWJ03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 04:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiBWJ01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 04:26:27 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D563185648
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:26:00 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id c6so46646607ybk.3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=roGR89KW7YSGx9Iq3wb7OaaFf87pu/a869G/gnZpXb8=;
        b=byGC8q9A280hOaflVcWLOnnzjVAmMFZ9QXyMrgICp4TH8QfpraNALCRJxyeQZuM1Hn
         iDh4N20k+4cW29Auzrbd1CnqrPyMbIN4/3mzz5Z6Wd6y11jFiquUNZ383pUkqRDUnhJf
         X0kHM/KPKZJdEM+eWFIHK8bk/BggNL8wU4NCQw+na8zlBNGFgUqnYodwWF/rLdwwMKYY
         V24+9b3DtTDkjP/KVMkbG3FgktR+ylYL7KYzZrr8vy3Vr5Xw8McRqhr4YsbaJ1j51e/f
         DeOhXutLqVARyl0uls0sFW5KDGh7eOd6zA0fkRe/AJdfFqxcXeGbctDxhgcSYEKKiAOT
         u7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=roGR89KW7YSGx9Iq3wb7OaaFf87pu/a869G/gnZpXb8=;
        b=EMM+O8Vlih7FHER92IWxu0IC2nZ+g9vrMf9Zx428O1JLs0Uwh+KW1coR66Lf3VMBVJ
         N63uiRojOREM87kwvry+Ytz2lgwjndy2TC1ZRR9I8FNKDi4unRLybqSP6zJCK9iI4lb4
         EzDzkqyNRa8/+3G5KPvHQfn+bMLJ7RjUfvYui2HbN9+uKjGBWP4o2SBPZj7MbPX99qbj
         3K+oDTWjtYhsH6Ge6Z9fiItLLNQ/0ntNv+6k34/ZlNiHKvEY7Ggpjcw8G+s4m7j83cRt
         RE4rIOYyUV8wTeej+qT83BNrAE0HubESlMmp0ugYkK8/0iKPwvco06w9+UNsaEtmNAtI
         FWHg==
X-Gm-Message-State: AOAM531pf82zHAMlPYeVSUWOJZHNwyVVxPnPWQsxepPH8o7NUM3ROL/0
        +lY50NTA58jV/Z56I0OvWmMxEFF+TT0i/untYYc3EA==
X-Google-Smtp-Source: ABdhPJxUzhcpxnYfomRY0ENC0P3CII9/EP0EKlyqlr6y/sB0NX6GusgPzZ/itcwYOx5XbgRxvxTA20CrzxQlXt9qPfI=
X-Received: by 2002:a25:aa51:0:b0:624:6fbf:c494 with SMTP id
 s75-20020a25aa51000000b006246fbfc494mr16346479ybi.425.1645608359780; Wed, 23
 Feb 2022 01:25:59 -0800 (PST)
MIME-Version: 1.0
References: <20220222032113.4005821-1-eric.dumazet@gmail.com> <20220222032113.4005821-3-eric.dumazet@gmail.com>
In-Reply-To: <20220222032113.4005821-3-eric.dumazet@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 23 Feb 2022 10:25:48 +0100
Message-ID: <CANpmjNOwaP7QS_joNJUPbY3Q0CKYsm1Bh7YhXnqaxxKzgJHvHw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: preserve skb_end_offset() in skb_unclone_keeptruesize()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
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

On Tue, 22 Feb 2022 at 04:21, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> syzbot found another way to trigger the infamous WARN_ON_ONCE(delta < len)
> in skb_try_coalesce() [1]
>
> I was able to root cause the issue to kfence.
>
> When kfence is in action, the following assertion is no longer true:
>
> int size = xxxx;
> void *ptr1 = kmalloc(size, gfp);
> void *ptr2 = kmalloc(size, gfp);
>
> if (ptr1 && ptr2)
>         ASSERT(ksize(ptr1) == ksize(ptr2));
>
> We attempted to fix these issues in the blamed commits, but forgot
> that TCP was possibly shifting data after skb_unclone_keeptruesize()
> has been used, notably from tcp_retrans_try_collapse().
>
> So we not only need to keep same skb->truesize value,
> we also need to make sure TCP wont fill new tailroom
> that pskb_expand_head() was able to get from a
> addr = kmalloc(...) followed by ksize(addr)
>
> Split skb_unclone_keeptruesize() into two parts:
>
> 1) Inline skb_unclone_keeptruesize() for the common case,
>    when skb is not cloned.
>
> 2) Out of line __skb_unclone_keeptruesize() for the 'slow path'.
>
> WARNING: CPU: 1 PID: 6490 at net/core/skbuff.c:5295 skb_try_coalesce+0x1235/0x1560 net/core/skbuff.c:5295
> Modules linked in:
> CPU: 1 PID: 6490 Comm: syz-executor161 Not tainted 5.17.0-rc4-syzkaller-00229-g4f12b742eb2b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:skb_try_coalesce+0x1235/0x1560 net/core/skbuff.c:5295
> Code: bf 01 00 00 00 0f b7 c0 89 c6 89 44 24 20 e8 62 24 4e fa 8b 44 24 20 83 e8 01 0f 85 e5 f0 ff ff e9 87 f4 ff ff e8 cb 20 4e fa <0f> 0b e9 06 f9 ff ff e8 af b2 95 fa e9 69 f0 ff ff e8 95 b2 95 fa
> RSP: 0018:ffffc900063af268 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 00000000ffffffd5 RCX: 0000000000000000
> RDX: ffff88806fc05700 RSI: ffffffff872abd55 RDI: 0000000000000003
> RBP: ffff88806e675500 R08: 00000000ffffffd5 R09: 0000000000000000
> R10: ffffffff872ab659 R11: 0000000000000000 R12: ffff88806dd554e8
> R13: ffff88806dd9bac0 R14: ffff88806dd9a2c0 R15: 0000000000000155
> FS:  00007f18014f9700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020002000 CR3: 000000006be7a000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  tcp_try_coalesce net/ipv4/tcp_input.c:4651 [inline]
>  tcp_try_coalesce+0x393/0x920 net/ipv4/tcp_input.c:4630
>  tcp_queue_rcv+0x8a/0x6e0 net/ipv4/tcp_input.c:4914
>  tcp_data_queue+0x11fd/0x4bb0 net/ipv4/tcp_input.c:5025
>  tcp_rcv_established+0x81e/0x1ff0 net/ipv4/tcp_input.c:5947
>  tcp_v4_do_rcv+0x65e/0x980 net/ipv4/tcp_ipv4.c:1719
>  sk_backlog_rcv include/net/sock.h:1037 [inline]
>  __release_sock+0x134/0x3b0 net/core/sock.c:2779
>  release_sock+0x54/0x1b0 net/core/sock.c:3311
>  sk_wait_data+0x177/0x450 net/core/sock.c:2821
>  tcp_recvmsg_locked+0xe28/0x1fd0 net/ipv4/tcp.c:2457
>  tcp_recvmsg+0x137/0x610 net/ipv4/tcp.c:2572
>  inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:850
>  sock_recvmsg_nosec net/socket.c:948 [inline]
>  sock_recvmsg net/socket.c:966 [inline]
>  sock_recvmsg net/socket.c:962 [inline]
>  ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
>  ___sys_recvmsg+0x127/0x200 net/socket.c:2674
>  __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: c4777efa751d ("net: add and use skb_unclone_keeptruesize() helper")
> Fixes: 097b9146c0e2 ("net: fix up truesize of cloned skb in skb_prepare_for_shift()")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Marco Elver <elver@google.com>
> ---
>  include/linux/skbuff.h | 20 +++++++++++---------
>  net/core/skbuff.c      | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 9 deletions(-)

FWIW, I also exposed this to syzkaller for the last 24h with
CONFIG_KFENCE_SAMPLE_INTERVAL=10 - so far no warning.

Tested-by: Marco Elver <elver@google.com>

Thanks!
