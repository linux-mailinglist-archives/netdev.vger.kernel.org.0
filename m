Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075D6536887
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 23:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbiE0VbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 17:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiE0VbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 17:31:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCB1558D
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 14:31:20 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v17so3256215wrv.2
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 14:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dUiFQEuA7KqZBNdm8KB4GQL/gc8Fn2kEei0gMmBjTOk=;
        b=iXLNhmMtGRowPlgf9X4wsyC841J5/ZThbqZUkIn5oZDVVmjfP4okYpcheSBTIhvC4P
         cUdqyxLxH3g1ptPCUNY320r+Ei1hhtYggS81cdFLsHRf68ioshCZUNBD5MwXoR6piEeo
         SDK/GY5X8YUPCudeJhra5X26Y2kwb7rqiGfM5EPw362TWRDDUl1HStolliw4Dz/R/CLc
         epf/j0F3aKYMJvbLG8corPFUo6Oy/9NQoqFNkn46MdF9/dsILxJ/TZ1O4YzLaVjfYKQ9
         ug+h7mAZgr4nBrz6o7iM3HDPdrAXGSYrm59Z6mttsEANqv36i3+wbqLup+swHuwFctfU
         8PjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dUiFQEuA7KqZBNdm8KB4GQL/gc8Fn2kEei0gMmBjTOk=;
        b=LZjR5yW2T4m1NMlJekj7DU/X/XrC65ZSdaTvX8xIiOg47U20InlcrnBHVlc5nsvPdw
         UvImCNC1mow61COETe3Xc40YMKObvb74ffszsd0ySi08/WH4Gggx7rX4CMWkNtG4Ilci
         IwX7DFHzx77mLeOuTq/ZPv6jAG1NY2KVeZav/Hl3884tFL+cBP989IMLJy7OgMUmXF9m
         kWQoTZZt36woisOrIX+NHMIPN6UH1vgmqpsZWtn4dCRy2wFQ6IfOgyWsmy0fkC/zeQLi
         uvEwW/jKfTVog0hmw1Dt4z/DajaLwadD8mI/mXhcVLLef8WGWcVMdKIbp/tueEYIiRaS
         AcDA==
X-Gm-Message-State: AOAM530gzKnBUAgywjDlgk5BtN80tP9agl4yb+UKLAjZujLq3ysffQ7S
        yZaQI3wVpWgsfxcaMBjYE+Mlcd2G9IlCmY520MEiSXgMdl0=
X-Google-Smtp-Source: ABdhPJxWypc7hx+EYhR2lljCEYwkWjXkjLjTLsmJHq5AvZMGt6gh9Ws+njRCjbXCne7cvYTswFbEfolNQ9QeizSEArQ=
X-Received: by 2002:a5d:4302:0:b0:210:824:48ee with SMTP id
 h2-20020a5d4302000000b00210082448eemr8868994wrq.471.1653687078907; Fri, 27
 May 2022 14:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220527212829.3325039-1-eric.dumazet@gmail.com>
In-Reply-To: <20220527212829.3325039-1-eric.dumazet@gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 27 May 2022 14:30:42 -0700
Message-ID: <CAK6E8=e8DqjxQ2doH2KLWUzb1c_chyMoTBd6roM1UruZqoyfoQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
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

On Fri, May 27, 2022 at 2:28 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> syzbot got a new report [1] finally pointing to a very old bug,
> added in initial support for MTU probing.
>
> tcp_mtu_probe() has checks about starting an MTU probe if
> tcp_snd_cwnd(tp) >= 11.
>
> But nothing prevents tcp_snd_cwnd(tp) to be reduced later
> and before the MTU probe succeeds.
>
> This bug would lead to potential zero-divides.
>
> Debugging added in commit 40570375356c ("tcp: add accessors
> to read/set tp->snd_cwnd") has paid off :)
>
> While we are at it, address potential overflows in this code.
>
> [1]
> WARNING: CPU: 1 PID: 14132 at include/net/tcp.h:1219 tcp_mtup_probe_success+0x366/0x570 net/ipv4/tcp_input.c:2712
> Modules linked in:
> CPU: 1 PID: 14132 Comm: syz-executor.2 Not tainted 5.18.0-syzkaller-07857-gbabf0bb978e3 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:tcp_snd_cwnd_set include/net/tcp.h:1219 [inline]
> RIP: 0010:tcp_mtup_probe_success+0x366/0x570 net/ipv4/tcp_input.c:2712
> Code: 74 08 48 89 ef e8 da 80 17 f9 48 8b 45 00 65 48 ff 80 80 03 00 00 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 aa b0 c5 f8 <0f> 0b e9 16 fe ff ff 48 8b 4c 24 08 80 e1 07 38 c1 0f 8c c7 fc ff
> RSP: 0018:ffffc900079e70f8 EFLAGS: 00010287
> RAX: ffffffff88c0f7f6 RBX: ffff8880756e7a80 RCX: 0000000000040000
> RDX: ffffc9000c6c4000 RSI: 0000000000031f9e RDI: 0000000000031f9f
> RBP: 0000000000000000 R08: ffffffff88c0f606 R09: ffffc900079e7520
> R10: ffffed101011226d R11: 1ffff1101011226c R12: 1ffff1100eadcf50
> R13: ffff8880756e72c0 R14: 1ffff1100eadcf89 R15: dffffc0000000000
> FS:  00007f643236e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1ab3f1e2a0 CR3: 0000000064fe7000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  tcp_clean_rtx_queue+0x223a/0x2da0 net/ipv4/tcp_input.c:3356
>  tcp_ack+0x1962/0x3c90 net/ipv4/tcp_input.c:3861
>  tcp_rcv_established+0x7c8/0x1ac0 net/ipv4/tcp_input.c:5973
>  tcp_v6_do_rcv+0x57b/0x1210 net/ipv6/tcp_ipv6.c:1476
>  sk_backlog_rcv include/net/sock.h:1061 [inline]
>  __release_sock+0x1d8/0x4c0 net/core/sock.c:2849
>  release_sock+0x5d/0x1c0 net/core/sock.c:3404
>  sk_stream_wait_memory+0x700/0xdc0 net/core/stream.c:145
>  tcp_sendmsg_locked+0x111d/0x3fc0 net/ipv4/tcp.c:1410
>  tcp_sendmsg+0x2c/0x40 net/ipv4/tcp.c:1448
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  __sys_sendto+0x439/0x5c0 net/socket.c:2119
>  __do_sys_sendto net/socket.c:2131 [inline]
>  __se_sys_sendto net/socket.c:2127 [inline]
>  __x64_sys_sendto+0xda/0xf0 net/socket.c:2127
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f6431289109
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f643236e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f643139c100 RCX: 00007f6431289109
> RDX: 00000000d0d0c2ac RSI: 0000000020000080 RDI: 000000000000000a
> RBP: 00007f64312e308d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fff372533af R14: 00007f643236e300 R15: 0000000000022000
>
> Fixes: 5d424d5a674f ("[TCP]: MTU probing")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>

Nice catch & fix!
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  net/ipv4/tcp_input.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3231af73e4302b44e48eacd2bc51bcf56b8fdcf4..2e2a9ece9af27372e6b653d685a89a2c71ba05d1 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -2706,12 +2706,15 @@ static void tcp_mtup_probe_success(struct sock *sk)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct inet_connection_sock *icsk = inet_csk(sk);
> +       u64 val;
>
> -       /* FIXME: breaks with very large cwnd */
>         tp->prior_ssthresh = tcp_current_ssthresh(sk);
> -       tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) *
> -                            tcp_mss_to_mtu(sk, tp->mss_cache) /
> -                            icsk->icsk_mtup.probe_size);
> +
> +       val = (u64)tcp_snd_cwnd(tp) * tcp_mss_to_mtu(sk, tp->mss_cache);
> +       do_div(val, icsk->icsk_mtup.probe_size);
> +       DEBUG_NET_WARN_ON_ONCE((u32)val != val);
> +       tcp_snd_cwnd_set(tp, max_t(u32, 1U, val));
> +
>         tp->snd_cwnd_cnt = 0;
>         tp->snd_cwnd_stamp = tcp_jiffies32;
>         tp->snd_ssthresh = tcp_current_ssthresh(sk);
> --
> 2.36.1.255.ge46751e96f-goog
>
