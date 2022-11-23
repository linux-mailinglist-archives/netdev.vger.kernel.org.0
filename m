Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F34D6362F1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiKWPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbiKWPKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:10:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E1618E12
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:10:28 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b8so14458057edf.11
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AGECrzt3uoggquR9T5NWAuygTEsucjarZVkM0Ifzc+A=;
        b=Ps1KceAViMRS7WDKX/6diIvormslJYdVWl2rr8qrPnIS9XhxaJfHVyGo9kdr9v3NrN
         34OMejhcogXV37wlLKYuh0myT9pPMMw1CrdyZU+MOlx7gSmguOkDxn7LFQwl5tiMgwFT
         hyWqAfLdNXC1yDkqIaoMIJlR+8Ue/vZT0FSXPcRtcTTrtjtUbu9c673NUeh1zm1r90yZ
         xb7XZBOPalafxnc+K/RiyIx1/RIjDnFspqI/dfP7UPNlGpJ6xA4gmbcBp6J1Y02NvUhi
         l5gc6mHVVwQBXdZZE6pW08nKBBGeWVbVtdm1cQd5Ufp9+E+lGCvV4zp6lysEzdmM3zDd
         MBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AGECrzt3uoggquR9T5NWAuygTEsucjarZVkM0Ifzc+A=;
        b=XMqYY60OFISvbgiYra9fs0Q8Dpq9UQACE2JMbBcXgJ5h/WoEygmie+f2GJFimqBm9S
         YyWn5102OnTHgyV2JxYE65bd7kFDYTjz6yte/Ooj8qITqGzSCwPTmVr2PYwBfr0MfsK2
         dVNP3DvTTSt2NKjfuHnHBySi5QelxC09cHOJFITxpBa1zAd/2CXL3vscXGGoau7ioRvp
         /pJvPtBP1sKK4CPDYu3sfUVfnnsyjvxE8SZ107t+p3nBUQK4uStLM4vOTqXV2O71WSbz
         GgzZYxAb/Jr4buH1ZILeNfBhG2ljWulfOVim3xBkeZI8FFbmXVxdXYFt/D+Q2LYWkdMM
         F/7g==
X-Gm-Message-State: ANoB5pmzJDGVi1hU080ti+g8HD4B8duoBHPn00QLKanJ2hk4EwXUfl+h
        ZDiZnJWF+eSQS707STVCkjB0iTP8S38pF5dDvME=
X-Google-Smtp-Source: AA0mqf5OHY1d97nDFV/JgFfbmQiwJXHOFW9ROtStTB6sNtX92nEHPMai2PZGz4WF4x1ZXOytELMxZrXc13h8RCQ7Tpg=
X-Received: by 2002:a05:6402:1691:b0:469:bbe9:8b13 with SMTP id
 a17-20020a056402169100b00469bbe98b13mr9909821edv.127.1669216227268; Wed, 23
 Nov 2022 07:10:27 -0800 (PST)
MIME-Version: 1.0
References: <20221122205811.20910-1-kuniyu@amazon.com> <e04315e7c90d9a75613f3993c2baf2d344eef7eb.camel@redhat.com>
In-Reply-To: <e04315e7c90d9a75613f3993c2baf2d344eef7eb.camel@redhat.com>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Wed, 23 Nov 2022 23:09:53 +0800
Message-ID: <CAO4mrfcuDa5hKFksJtBLskA3AAuHUTP_wO9JOfD9Kq0ZvEPPCA@mail.gmail.com>
Subject: Re: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket lock.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Paolo,

Could you explain the meaning of modified "ss" version to reproduce
the bug? I'd like to learn how to reproduce the bug in the user space
to facilitate the bug fix.

Best,
Wei

On Wed, 23 Nov 2022 at 18:26, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-11-22 at 12:58 -0800, Kuniyuki Iwashima wrote:
> > Wei Chen reported sk->sk_socket can be NULL in sk_user_ns(). [0][1]
> >
> > It seems that syzbot was dumping an AF_UNIX socket while closing it,
> > and there is a race below.
> >
> >   unix_release_sock               unix_diag_handler_dump
> >   |                               `- unix_diag_get_exact
> >   |                                  |- unix_lookup_by_ino
> >   |                                  |  |- spin_lock(&net->unx.table.locks[i])
> >   |                                  |  |- sock_hold
> >   |                                  |  `- spin_unlock(&net->unx.table.locks[i])
> >   |- unix_remove_socket(net, sk)     |     /* after releasing this lock,
> >   |  /* from here, sk cannot be      |      * there is no guarantee that
> >   |   * seen in the hash table.      |      * sk is not SOCK_DEAD.
> >   |   */                             |      */
> >   |                                  |
> >   |- unix_state_lock(sk)             |
> >   |- sock_orphan(sk)                 `- sk_diag_fill
> >   |  |- sock_set_flag(sk, SOCK_DEAD)    `- sk_diag_dump_uid
> >   |  `- sk_set_socket(sk, NULL)            `- sk_user_ns
> >   `- unix_state_unlock(sk)                   `- sk->sk_socket->file->f_cred->user_ns
> >                                                 /* NULL deref here */
> >
> > After releasing the bucket lock, we cannot guarantee that the found
> > socket is still alive.  Then, we have to check the SOCK_DEAD flag
> > under unix_state_lock() and keep holding it unless we access the socket.
> >
> > In this case, however, we cannot acquire unix_state_lock() in
> > unix_lookup_by_ino() because we lock it later in sk_diag_dump_peer(),
> > resulting in deadlock.
> >
> > Instead, we do not release the bucket lock; then, we can safely access
> > sk->sk_socket later in sk_user_ns(), and there is no deadlock scenario.
> > We are already using this strategy in unix_diag_dump().
> >
> > Note we have to call nlmsg_new() before unix_lookup_by_ino() not to
> > change the flag from GFP_KERNEL to GFP_ATOMIC.
> >
> > [0]: https://lore.kernel.org/netdev/CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com/
> > [1]:
> > BUG: kernel NULL pointer dereference, address: 0000000000000270
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP
> > CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
> > RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
> > RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
> > Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
> > 54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
> > 9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
> > RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
> > RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
> > RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
> > RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
> > R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
> > R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
> > FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  unix_diag_get_exact net/unix/diag.c:285 [inline]
> >  unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
> >  __sock_diag_cmd net/core/sock_diag.c:235 [inline]
> >  sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
> >  netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
> >  sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
> >  netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
> >  netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
> >  sock_sendmsg_nosec net/socket.c:714 [inline]
> >  sock_sendmsg net/socket.c:734 [inline]
> >  ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
> >  ___sys_sendmsg net/socket.c:2530 [inline]
> >  __sys_sendmsg+0x197/0x230 net/socket.c:2559
> >  __do_sys_sendmsg net/socket.c:2568 [inline]
> >  __se_sys_sendmsg net/socket.c:2566 [inline]
> >  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x4697f9
> > Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
> > RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
> > RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
> > R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
> >  </TASK>
> > Modules linked in:
> > CR2: 0000000000000270
>
> I *think* that the root cause of the above splat could be
> different/simpler. In unix_diag_get_exact():
>
>
>         rep = nlmsg_new(sizeof(struct unix_diag_msg) + extra_len, GFP_KERNEL);
>         if (!rep)
>                 goto out;
>
>         // rep->sk is NULL now.
>         err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
>                            nlh->nlmsg_seq, 0, req->udiag_ino);
>
> and sk_diag_fill() will splats deterministically. Note that the user
> space don't trigger that code path usually, but it can be reproduced
> with a sligthly modified 'ss' version.
>
>
> Thanks,
>
> Paolo
>
