Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D1B050D
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 22:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfIKU7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 16:59:39 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36129 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728877AbfIKU7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 16:59:38 -0400
Received: by mail-yb1-f193.google.com with SMTP id m9so7865918ybm.3
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 13:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zF7KCN8IljNVBNdfIUqvEDVfD3OCuvP6Ek3LkXaJwYE=;
        b=KqGF5BHvcdUda7rd7w6xglXbOFILchWLbM/S3QcwjH9VSE45Fmb5igHHiekK9WNEzv
         wl1Hd7nmsJT/Dbv1R69Ar8tKhCz50dfGDtdb4RJ8p3TktrQVdpRgbV0e0LvTS3N/L+ml
         +cQ9mZMnPz773Yf3hMGB1FsG8tLlmlzchfRgMUI9rjSBVMtZGKqTur24k5pt9MBtHUC0
         g3vx25Sq7iKnzhS7qTMGSor/MatFYAk1dH+Jv53lkEQ8ETGlEdQxM8khM2SEewi9Rjj0
         AVCUdYSdiB7//ubm28BIzcaTs4WG02aPCNU9lJ5BQdi3JTKOTYhsqNYgf+R52U+KN/In
         P/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zF7KCN8IljNVBNdfIUqvEDVfD3OCuvP6Ek3LkXaJwYE=;
        b=bJqT4cbaYFzb5iyuanb/t1piVhIDUkz6jbdUk2fBvZY6J1CGUbbLCVF3K0sIFY9xUH
         2XWXPKflAYVEBESdFPkZVNUHvsIl5O0mqiWTl7jAgUH/p14VUAlMiF8zGp4i1h6uwJ6E
         n7eE9WnAPSJKJyLa65n9YMJUTTjfbnXelX84wGiiYjbZDykqcoWaSmUmHPSIwDzTGjkj
         iF8okHxoZZIhWxzofbDpHNnqWprF92AIRSzkes6Y9OmcQ3sJsN5vHsqFTi9XOwSh9WPU
         43KufLpBsnOBYJxMKmW/FwEp1OowFwPwABZZh36Xki9JTE8Oy5IeKoIf83IPFA20YMxu
         raBQ==
X-Gm-Message-State: APjAAAXHvxaAcF9S4UgAgR+oTC937uUi054l3HfFtDXitF3mIXVg28J7
        LBmTTIypEJmCrokOLkONI4GJv+T9li0VY+XtDanXAQ==
X-Google-Smtp-Source: APXvYqzvHWKkI+c9E6FMFMeXXeYRwG3++GikoaJpiRL6WYJbJn6Qll48JXuFqb9Y566c293QmBY6elZFpIwvQxP3lIo=
X-Received: by 2002:a25:9783:: with SMTP id i3mr25317414ybo.446.1568235577176;
 Wed, 11 Sep 2019 13:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190826161915.81676-1-edumazet@google.com> <CALMXkpZfufqWhvd9F4kbtC18bFYCgNWrkEvL7Tw976i24f1EFw@mail.gmail.com>
In-Reply-To: <CALMXkpZfufqWhvd9F4kbtC18bFYCgNWrkEvL7Tw976i24f1EFw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 11 Sep 2019 22:59:25 +0200
Message-ID: <CANn89i++mOSPmMbHP5jjwG04rD2cx6HHCyD0-J3f5u7=TQ-U1w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: remove empty skb from write queue in error cases
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 7:36 PM Christoph Paasch
<christoph.paasch@gmail.com> wrote:
>
> Hello,
>
> On Mon, Aug 26, 2019 at 11:04 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Vladimir Rutsky reported stuck TCP sessions after memory pressure
> > events. Edge Trigger epoll() user would never receive an EPOLLOUT
> > notification allowing them to retry a sendmsg().
> >
> > Jason tested the case of sk_stream_alloc_skb() returning NULL,
> > but there are other paths that could lead both sendmsg() and sendpage()
> > to return -1 (EAGAIN), with an empty skb queued on the write queue.
> >
> > This patch makes sure we remove this empty skb so that
> > Jason code can detect that the queue is empty, and
> > call sk->sk_write_space(sk) accordingly.
> >
> > Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jason Baron <jbaron@akamai.com>
> > Reported-by: Vladimir Rutsky <rutsky@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > ---
> >  net/ipv4/tcp.c | 30 ++++++++++++++++++++----------
> >  1 file changed, 20 insertions(+), 10 deletions(-)
>
> I got syzkaller complaining now on 4.14.143 with the following reproducer:
>
> # {Threaded:true Collide:true Repeat:true RepeatTimes:0 Procs:1
> Sandbox: Fault:false FaultCall:-1 FaultNth:0 EnableTun:false
> UseTmpDir:false EnableCgroups:false EnableNetdev:false ResetNet:false
> HandleSegv:false Repro:false Trace:false}
> r0 = socket$inet_tcp(0x2, 0x1, 0x0)
> setsockopt$inet_tcp_TCP_REPAIR(r0, 0x6, 0x13, &(0x7f0000000040)=0x1, 0x4)
> setsockopt$inet_tcp_TCP_REPAIR_QUEUE(r0, 0x6, 0x14, &(0x7f00000012c0)=0x2, 0x4)
> setsockopt$inet_tcp_int(r0, 0x6, 0x19, &(0x7f0000000000)=0x9, 0x4)
> setsockopt$inet_tcp_TCP_MD5SIG(r0, 0x6, 0xe,
> &(0x7f00000001c0)={@in={{0x2, 0x0, @empty}}, 0x0, 0x2, 0x0,
> "c157cf4809151e5e89cfd6d934fbe981ec8ff6afc252ccf486c325c7ff3d35f3a89412a5cb6430e169092617df2ba65bf0ab844572e4e7dd4ece8ec1de5ac1ccd870067b018cb3b1f05f2391d872b67d"},
> 0xd8)
> connect$inet(r0, &(0x7f0000000080)={0x2, 0x0, @dev={0xac, 0x14, 0x14,
> 0x1d}}, 0x10)
> sendto(r0, 0x0, 0x87, 0x0, 0x0, 0x391)
>
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN PTI
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 2529 Comm: syz-executor709 Not tainted 4.14.143 #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
> task: ffff8880677fdc00 task.stack: ffff8880642b0000
> RIP: 0010:tcp_sendmsg_locked+0x6b4/0x4390 net/ipv4/tcp.c:1350
> RSP: 0018:ffff8880642bf718 EFLAGS: 00010206
> RAX: 0000000000000014 RBX: 0000000000000087 RCX: ffff88806a794f50
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000a0
> RBP: ffff8880642bfaa8 R08: 0000000000000006 R09: ffff8880677fe3a0
> R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
> R13: ffff88806a794f50 R14: ffff88806a794d00 R15: 0000000000000087
> FS:  00007f644b697700(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffcd37370b0 CR3: 00000000679f2006 CR4: 00000000003606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tcp_sendmsg+0x2a/0x40 net/ipv4/tcp.c:1533
>  inet_sendmsg+0x173/0x4e0 net/ipv4/af_inet.c:784
>  sock_sendmsg_nosec net/socket.c:646 [inline]
>  sock_sendmsg+0xc3/0x100 net/socket.c:656
>  SYSC_sendto+0x35d/0x5e0 net/socket.c:1766
>  do_syscall_64+0x241/0x680 arch/x86/entry/common.c:292
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x7f644afc6469
> RSP: 002b:00007f644b696f28 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000602130 RCX: 00007f644afc6469
> RDX: 0000000000000087 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 0000000000602138 R08: 0000000000000000 R09: 0000000000000391
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060213c
> R13: 00007ffcd373700f R14: 00007f644b677000 R15: 0000000000000003
> Code: 74 08 3c 03 0f 8e f1 32 00 00 8b 85 98 fd ff ff 89 85 60 fd ff
> ff 48 8b 85 70 fd ff ff 48 8d b8 a0 00 00 00 48 89 f8 48 c1 e8 03 <42>
> 0f b6 04 20 84 c0 74 06 0f 8e d2 32 00 00 4c 8b bd 70 fd ff
> RIP: tcp_sendmsg_locked+0x6b4/0x4390 net/ipv4/tcp.c:1350 RSP: ffff8880642bf718
> ---[ end trace 70f07f242cd3b9d8 ]---
>
>
> It's because skb is NULL in tcp_sendmsg_locked at:
>                   skb = tcp_write_queue_tail(sk);
>                   if (tcp_send_head(sk)) {
>                           if (skb->ip_summed == CHECKSUM_NONE)
>
>
> I think we need this here on pre-rb-tree kernels :
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 5ce069ce2a97..efe767e20d01 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -924,8 +924,7 @@ static void tcp_remove_empty_skb(struct sock *sk,
> struct sk_buff *skb)
>  {
>   if (skb && !skb->len) {
>   tcp_unlink_write_queue(skb, sk);
> - if (tcp_write_queue_empty(sk))
> - tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
> + tcp_check_send_head(sk, skb);
>   sk_wmem_free_skb(sk, skb);
>   }
>  }
>
> Does that look good?
>

Yes the backport to 4.14.143 was not done properly.

Thanks
