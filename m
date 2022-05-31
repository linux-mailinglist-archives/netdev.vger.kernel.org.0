Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666ED539702
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347273AbiEaT3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiEaT3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:29:38 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B0A4ECC8
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:29:37 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id el14so6204787qvb.7
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OXOzg5SLTm6WfQh4LSGMTTWuGMUbz209+SlET/BYj0=;
        b=KsdTrRmks+8aLlTwBaC0LL3F07HsYb+DGS6ttPOGH9N9tTOiIBSLevsXlW3VtIS6MP
         S9963HIdHtAxvIss3MpXJ5bab6CYdp/imzjnGA0Zc6dT4USLToZnJsxITBuIBSIa6syF
         cF/DZKZhdzdgz/v2Tsb7r9nxfo1B+QhIRoGzDUBNDnihAWxvePX4MjGWK1Wx2gdJo2l6
         OvkePxwH1SWUL1T4/ziGVltC4mHhqHDi4AOYIlPoj9lVy4WG0TpjCGQ7q1Tae9Mc/kB7
         xudfX295TC1erxm8PUxHMXRF3007vYJs/V7FeZe9sMa4QZJN0+SD38yw+n6WMfPyixNo
         bLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OXOzg5SLTm6WfQh4LSGMTTWuGMUbz209+SlET/BYj0=;
        b=H/o+PTx5C+YER60vS5vt1VW1luihj28fXAUk2AdmBkUbdyyxlbTGL1TD9evD/KIciJ
         tZeK5El4DgLKg+7ZqOQIpslrowV+ldslI7xQ6jRyZBiKOW7o85VAKoIdnj2S+ePQmk8M
         8gG+1rMJFahK5ZC9OzXv9gbuNOLwa1n0xcNTRp1dH+RwJERHdEGAEP556q70Vk3g3yvT
         XK7qU79Ah5ikKTM+l0WSNtyCZBsssall2AbInlwEAdeIYpFTTLHMv9l4BNgYvujyp9xy
         oHf7iDGphHB202c8d6ZKF8E8LHRQg4rAkHveZSUqL4OALrq/Xmv7v8qbWkGgZgEW8jNi
         LmXg==
X-Gm-Message-State: AOAM532Tc6TlCz4hy2/CsArt4CRRjBjC/QeUeqkS0UWgB6EACU/FFm0I
        w/53I7b7uGAuwDh+yDOxeCcJwSaqk7o=
X-Google-Smtp-Source: ABdhPJyZlKQisE/76AT9vVvEQAAzUwMZcFMoOrgufiXz+W+0NGtfRY2z7PdGyjzMMea+MBqq8PUEzA==
X-Received: by 2002:a05:6214:c2a:b0:45b:527:4115 with SMTP id a10-20020a0562140c2a00b0045b05274115mr52370593qvd.62.1654025376350;
        Tue, 31 May 2022 12:29:36 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id c15-20020ac84e0f000000b00304a27bde85sm3772784qtw.1.2022.05.31.12.29.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 12:29:35 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id e184so16146568ybf.8
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:29:35 -0700 (PDT)
X-Received: by 2002:a25:664d:0:b0:65c:bef8:8caa with SMTP id
 z13-20020a25664d000000b0065cbef88caamr13327552ybm.532.1654025374904; Tue, 31
 May 2022 12:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220531185933.1086667-1-eric.dumazet@gmail.com> <20220531185933.1086667-3-eric.dumazet@gmail.com>
In-Reply-To: <20220531185933.1086667-3-eric.dumazet@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 31 May 2022 15:28:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeVKbakVBuwx5WuLmkbycxXJUxcTs43oODnLe5DS+L94A@mail.gmail.com>
Message-ID: <CA+FuTSeVKbakVBuwx5WuLmkbycxXJUxcTs43oODnLe5DS+L94A@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/af_packet: make sure to pull mac header
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 2:59 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> GSO assumes skb->head contains link layer headers.
>
> tun device in some case can provide base 14 bytes,
> regardless of VLAN being used or not.
>
> After blamed commit, we can end up setting a network
> header offset of 18+, we better pull the missing
> bytes to avoid a posible crash in GSO.
>
> syzbot report was:
> kernel BUG at include/linux/skbuff.h:2699!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3601 Comm: syz-executor210 Not tainted 5.18.0-syzkaller-11338-g2c5ca23f7414 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__skb_pull include/linux/skbuff.h:2699 [inline]
> RIP: 0010:skb_mac_gso_segment+0x48f/0x530 net/core/gro.c:136
> Code: 00 48 c7 c7 00 96 d4 8a c6 05 cb d3 45 06 01 e8 26 bb d0 01 e9 2f fd ff ff 49 c7 c4 ea ff ff ff e9 f1 fe ff ff e8 91 84 19 fa <0f> 0b 48 89 df e8 97 44 66 fa e9 7f fd ff ff e8 ad 44 66 fa e9 48
> RSP: 0018:ffffc90002e2f4b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000012 RCX: 0000000000000000
> RDX: ffff88805bb58000 RSI: ffffffff8760ed0f RDI: 0000000000000004
> RBP: 0000000000005dbc R08: 0000000000000004 R09: 0000000000000fe0
> R10: 0000000000000fe4 R11: 0000000000000000 R12: 0000000000000fe0
> R13: ffff88807194d780 R14: 1ffff920005c5e9b R15: 0000000000000012
> FS:  000055555730f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200015c0 CR3: 0000000071ff8000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  __skb_gso_segment+0x327/0x6e0 net/core/dev.c:3411
>  skb_gso_segment include/linux/netdevice.h:4749 [inline]
>  validate_xmit_skb+0x6bc/0xf10 net/core/dev.c:3669
>  validate_xmit_skb_list+0xbc/0x120 net/core/dev.c:3719
>  sch_direct_xmit+0x3d1/0xbe0 net/sched/sch_generic.c:327
>  __dev_xmit_skb net/core/dev.c:3815 [inline]
>  __dev_queue_xmit+0x14a1/0x3a00 net/core/dev.c:4219
>  packet_snd net/packet/af_packet.c:3071 [inline]
>  packet_sendmsg+0x21cb/0x5550 net/packet/af_packet.c:3102
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:734
>  ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
>  __sys_sendmsg net/socket.c:2575 [inline]
>  __do_sys_sendmsg net/socket.c:2584 [inline]
>  __se_sys_sendmsg net/socket.c:2582 [inline]
>  __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f4b95da06c9
> Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd7defc4c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ffd7defc4f0 RCX: 00007f4b95da06c9
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
> RBP: 0000000000000003 R08: bb1414ac00000050 R09: bb1414ac00000050
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffd7defc4e0 R14: 00007ffd7defc4d8 R15: 00007ffd7defc4d4
>  </TASK>
>
> Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for fixing this, Eric.
