Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07B553689B
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 23:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351532AbiE0Vit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 17:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiE0Vir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 17:38:47 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D90113B8CE
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 14:38:45 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id bb31so6742274qtb.8
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 14:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4gTazkOaMUKvSMx8S+lr6steqsXjPGv8zy0RsYGcUhU=;
        b=HcitrPduQi3/Nh7bXZ+K4V66Sd7doGBPbaXioLQJ+5wH07suwGiB4uwssR8o43ib2z
         Hmxn7klax47HyK89LaSYzk1KctEaPMMBp/h5NfXMbIkh048ESU6Mq69BtML2bK7HNw5+
         o0DHkeuhFK1cAaec3fDNODbq3Dbk6KDqKe3pXnozWMqAO97rrdlZFfMxaNRP73l9DcHk
         nHYsSDbAjbNGEv/mb+oaCRzBg8MO9JIYdlhGQO8EGtKk8e9P+mr1ThxoSskrNMUmCNy5
         0fHamYv+wueQ5eBey2InAWosrqNYzv920PexEtAM2qUPVCBXccZ8WgI999gLq4MfKI8s
         zNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4gTazkOaMUKvSMx8S+lr6steqsXjPGv8zy0RsYGcUhU=;
        b=dbhXtEDh3dpnSFVY32ir6iYVCyArIUW6oCm2UhV7u3qSAo+MdmSqawSOOlZh4SoIHQ
         UdGYv5DYpdZFqO1htoYBaDzmmusDxK43eVXfqe8xZbCw8ZKaDpfHA4bNSmQMJfTYTXfz
         43CuMYal1ntA/RCp7TRUdeTb3Fkv3IGhTl+OlQc6y2axMwbHusfM2N1ugaIzQDvgYF7X
         3hNs0s5QIIEXtaY6v0+24tFwmBiaExghKxaseUBg0rCA9csUos+4zaxD5jVpiD9uIhJ3
         pRTxgojSrj+XyifQgCEmjBSkP38MfhifD/PkAVH1GU9GJNSj1Yq2H/jNXUB6lEGJ53Dt
         S3cw==
X-Gm-Message-State: AOAM533g23TF9LmMlm78s1XGeUBIvCGuvSJ1dMs5oWcxQt3kLdtbFdeB
        QztqLjk/HYmZm7RAcJgNlEdJAOIAphodjPWkAEhNlTDShqMeUg==
X-Google-Smtp-Source: ABdhPJyNmlXp5sX+HP3HYq6nScPW667aLVrBzECV6Ku/V3mdGltJc2+1BAJRMzFrgQE85+yYsZq1ymDxrr46/eJrIvM=
X-Received: by 2002:ac8:5c51:0:b0:2f3:bc1a:4922 with SMTP id
 j17-20020ac85c51000000b002f3bc1a4922mr34574311qtj.560.1653687524579; Fri, 27
 May 2022 14:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220527212829.3325039-1-eric.dumazet@gmail.com> <CAK6E8=e8DqjxQ2doH2KLWUzb1c_chyMoTBd6roM1UruZqoyfoQ@mail.gmail.com>
In-Reply-To: <CAK6E8=e8DqjxQ2doH2KLWUzb1c_chyMoTBd6roM1UruZqoyfoQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 May 2022 17:38:28 -0400
Message-ID: <CADVnQykWCNwvQhBPJNSBdmJYnBvLWp-uw4DrXpLNto_pNYZbyA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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

On Fri, May 27, 2022 at 5:31 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Fri, May 27, 2022 at 2:28 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > syzbot got a new report [1] finally pointing to a very old bug,
> > added in initial support for MTU probing.
> >
> > tcp_mtu_probe() has checks about starting an MTU probe if
> > tcp_snd_cwnd(tp) >= 11.
> >
> > But nothing prevents tcp_snd_cwnd(tp) to be reduced later
> > and before the MTU probe succeeds.
> >
> > This bug would lead to potential zero-divides.
> >
> > Debugging added in commit 40570375356c ("tcp: add accessors
> > to read/set tp->snd_cwnd") has paid off :)
> >
> > While we are at it, address potential overflows in this code.
> >
> > [1]
> > WARNING: CPU: 1 PID: 14132 at include/net/tcp.h:1219 tcp_mtup_probe_success+0x366/0x570 net/ipv4/tcp_input.c:2712
> > Modules linked in:
> > CPU: 1 PID: 14132 Comm: syz-executor.2 Not tainted 5.18.0-syzkaller-07857-gbabf0bb978e3 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:tcp_snd_cwnd_set include/net/tcp.h:1219 [inline]
> > RIP: 0010:tcp_mtup_probe_success+0x366/0x570 net/ipv4/tcp_input.c:2712
> > Code: 74 08 48 89 ef e8 da 80 17 f9 48 8b 45 00 65 48 ff 80 80 03 00 00 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 aa b0 c5 f8 <0f> 0b e9 16 fe ff ff 48 8b 4c 24 08 80 e1 07 38 c1 0f 8c c7 fc ff
> > RSP: 0018:ffffc900079e70f8 EFLAGS: 00010287
> > RAX: ffffffff88c0f7f6 RBX: ffff8880756e7a80 RCX: 0000000000040000
> > RDX: ffffc9000c6c4000 RSI: 0000000000031f9e RDI: 0000000000031f9f
> > RBP: 0000000000000000 R08: ffffffff88c0f606 R09: ffffc900079e7520
> > R10: ffffed101011226d R11: 1ffff1101011226c R12: 1ffff1100eadcf50
> > R13: ffff8880756e72c0 R14: 1ffff1100eadcf89 R15: dffffc0000000000
> > FS:  00007f643236e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f1ab3f1e2a0 CR3: 0000000064fe7000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  tcp_clean_rtx_queue+0x223a/0x2da0 net/ipv4/tcp_input.c:3356
> >  tcp_ack+0x1962/0x3c90 net/ipv4/tcp_input.c:3861
> >  tcp_rcv_established+0x7c8/0x1ac0 net/ipv4/tcp_input.c:5973
> >  tcp_v6_do_rcv+0x57b/0x1210 net/ipv6/tcp_ipv6.c:1476
> >  sk_backlog_rcv include/net/sock.h:1061 [inline]
> >  __release_sock+0x1d8/0x4c0 net/core/sock.c:2849
> >  release_sock+0x5d/0x1c0 net/core/sock.c:3404
> >  sk_stream_wait_memory+0x700/0xdc0 net/core/stream.c:145
> >  tcp_sendmsg_locked+0x111d/0x3fc0 net/ipv4/tcp.c:1410
> >  tcp_sendmsg+0x2c/0x40 net/ipv4/tcp.c:1448
> >  sock_sendmsg_nosec net/socket.c:714 [inline]
> >  sock_sendmsg net/socket.c:734 [inline]
> >  __sys_sendto+0x439/0x5c0 net/socket.c:2119
> >  __do_sys_sendto net/socket.c:2131 [inline]
> >  __se_sys_sendto net/socket.c:2127 [inline]
> >  __x64_sys_sendto+0xda/0xf0 net/socket.c:2127
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > RIP: 0033:0x7f6431289109
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f643236e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> > RAX: ffffffffffffffda RBX: 00007f643139c100 RCX: 00007f6431289109
> > RDX: 00000000d0d0c2ac RSI: 0000000020000080 RDI: 000000000000000a
> > RBP: 00007f64312e308d R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fff372533af R14: 00007f643236e300 R15: 0000000000022000
> >
> > Fixes: 5d424d5a674f ("[TCP]: MTU probing")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
>
> Nice catch & fix!

Yes, nice catch and fix. Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
