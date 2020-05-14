Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD58D1D3FDA
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgENVUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgENVUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:20:39 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F518C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:20:39 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so668718wrt.1
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+rYjoGtuxlXKizP48D57qQwiV7XOdUeIco1CMaI3zk=;
        b=FCKExaK9YHuDpqMWT7apg7gTWaFSri2lpTr840b5r8h/jEBIbnQ8iFS0DDfkFhlQZc
         ICZQDskxVH/f6UmGJdHd+MHCTNAuKcO1QoiORKQixRK1unhNGR87cW/VVabZa8NjZFyO
         R5De33D7x4Bjd9Xj4KSxzqYhpIlO7w+o8dI5qyaUnWQDgMMqLU9rShvWmqqV6us1dR3p
         3LBkchOCv2nS7KoLYwnIAJGscPkCoznR06eV1xE29p1WzP4pEDSp4e5bw+dOtexl7pH9
         MxUIh4mYMoecjedoKXoeazDJ5Dq5jfiI9xxN3OnhWxmKrg8Q+HnPLQAAwLCpUEWrawNn
         TjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+rYjoGtuxlXKizP48D57qQwiV7XOdUeIco1CMaI3zk=;
        b=PW4S79GTqK31IcCP37Qb7woUTmhsROPukCxc8wv3Ou6RjA3qaRaISPi8CbIbrOgp1r
         m/L/eYwi9PAElsmgINNypHVwPdV4fMKmwPju60eAHaGe4QJ2tgNarh7RN+yqAU/5NZnd
         ECgtjsBfiRwqajbM9UKQIAZhqNbbDreRKQ+emcZDEQsG/IjbtlW2rvng0iNaoMJPF0cp
         w2GscK7Qo1ntweNapYcJgLghg9Lkj2J8A7vorCdqFmc+To3IZ4f/5XMnnnVNF+DysWNU
         SisolFDtxiWpDtkWhgxUXZSlyKVJLtaJQ68cXS3N4LiYE+kTAFFEqM13L2VMKtPIX2d+
         M4TQ==
X-Gm-Message-State: AOAM5326cV4awujqUAs4siF0/0GJEyLP77ohhmQv0fZSb3gpjPDYGNCR
        heBsgPXl0DWsHk8UciqIvIkCFgJUlyiBQ57MYiAHMg==
X-Google-Smtp-Source: ABdhPJyKZoDUeoFTw+OiVXKUoSMoPeogbJoQUgmBxSZU9bXFiD/4Bw/3Uh6xLlAyqewn4rQJE6KnKrXLfEN3eK6S+tE=
X-Received: by 2002:adf:ec85:: with SMTP id z5mr437401wrn.153.1589491237091;
 Thu, 14 May 2020 14:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200514205813.164401-1-edumazet@google.com>
In-Reply-To: <20200514205813.164401-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 14 May 2020 17:20:00 -0400
Message-ID: <CACSApvaAgGWh0Zj=0bjEYGs7SfhUZ4JQnuO0f1ebCNyAzKxXrw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix error recovery in tcp_zerocopy_receive()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 4:58 PM Eric Dumazet <edumazet@google.com> wrote:
>
> If user provides wrong virtual address in TCP_ZEROCOPY_RECEIVE
> operation we want to return -EINVAL error.
>
> But depending on zc->recv_skip_hint content, we might return
> -EIO error if the socket has SOCK_DONE set.
>
> Make sure to return -EINVAL in this case.
>
> BUG: KMSAN: uninit-value in tcp_zerocopy_receive net/ipv4/tcp.c:1833 [inline]
> BUG: KMSAN: uninit-value in do_tcp_getsockopt+0x4494/0x6320 net/ipv4/tcp.c:3685
> CPU: 1 PID: 625 Comm: syz-executor.0 Not tainted 5.7.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>  tcp_zerocopy_receive net/ipv4/tcp.c:1833 [inline]
>  do_tcp_getsockopt+0x4494/0x6320 net/ipv4/tcp.c:3685
>  tcp_getsockopt+0xf8/0x1f0 net/ipv4/tcp.c:3728
>  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:3131
>  __sys_getsockopt+0x533/0x7b0 net/socket.c:2177
>  __do_sys_getsockopt net/socket.c:2192 [inline]
>  __se_sys_getsockopt+0xe1/0x100 net/socket.c:2189
>  __x64_sys_getsockopt+0x62/0x80 net/socket.c:2189
>  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45c829
> Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f1deeb72c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 00000000004e01e0 RCX: 000000000045c829
> RDX: 0000000000000023 RSI: 0000000000000006 RDI: 0000000000000009
> RBP: 000000000078bf00 R08: 0000000020000200 R09: 0000000000000000
> R10: 00000000200001c0 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000001d8 R14: 00000000004d3038 R15: 00007f1deeb736d4
>
> Local variable ----zc@do_tcp_getsockopt created at:
>  do_tcp_getsockopt+0x1a74/0x6320 net/ipv4/tcp.c:3670
>  do_tcp_getsockopt+0x1a74/0x6320 net/ipv4/tcp.c:3670
>
> Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thanks for the fix!

> ---
>  net/ipv4/tcp.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index a385fcaaa03beed9bfeabdebc12371e34e0649de..dd401757eea1f0187b0e547828f794e62eb895b8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1764,10 +1764,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
>
>         down_read(&current->mm->mmap_sem);
>
> -       ret = -EINVAL;
>         vma = find_vma(current->mm, address);
> -       if (!vma || vma->vm_start > address || vma->vm_ops != &tcp_vm_ops)
> -               goto out;
> +       if (!vma || vma->vm_start > address || vma->vm_ops != &tcp_vm_ops) {
> +               up_read(&current->mm->mmap_sem);
> +               return -EINVAL;
> +       }
>         zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
>
>         tp = tcp_sk(sk);
> --
> 2.26.2.761.g0e0b3e54be-goog
>
