Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8E2635A6E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbiKWKoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbiKWKnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD01134F2D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669199210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjIZXSNGA9bP8OvATL+IPcbYT3tKtCtE2cdhTnwFINg=;
        b=TmKZJiTowoW63p3XAL0wmW0EwzrWxoany1OtJ4XC1q+Mpz5gSiC/B2qhkjUQf/Ls6cFo//
        XF1oUN968ILir4Sv6mXPUYCBUZKW2J9unYgcWczdDYjfaZy15+1RN+cjchdtuW6HIQrHCc
        QlSPleWuLJcqFYv2S9xZsC6eocQ9y84=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-WH4QOO0ZPmS0wULvAJvnPA-1; Wed, 23 Nov 2022 05:26:49 -0500
X-MC-Unique: WH4QOO0ZPmS0wULvAJvnPA-1
Received: by mail-wr1-f70.google.com with SMTP id h2-20020adfa4c2000000b00241cf936619so2697660wrb.9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:26:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AjIZXSNGA9bP8OvATL+IPcbYT3tKtCtE2cdhTnwFINg=;
        b=45/sYR8WNIM8gOS9GPy/2WKBq2rQljGfinbwjgVwp3Zo4D6kcp0K9782elVe/hxujV
         2HyFsRQO1gbSQNMSRRDRNRYLLfPcPvt1Vj7xj1397mh9x1HpXQiB4RfyS+/q7tTvH4OD
         6l5L+YSfcH+tagjCNpHladb9aSRsHgLan2Bzsqiv605CGtN3ehIH7WJtQGqa7gPlmQbY
         4T10d7IsZGUbgWa+uwGPLok4fIvOkeKK/5/xkf5yhjxS8o8YS9Eb9FrlYqfHOXtQdPzT
         1Al0gDMxweA+kVcC7Blmy6I/oXjHMI2YPiV68ASwRvM/VlZHW/DWoKiuAAFIIPv3Hnc4
         AcSQ==
X-Gm-Message-State: ANoB5pm9Dor7nEN9ZSqKjWVxkyS0M03zsE2gU6/Q/+iNJLncrcWBQt2I
        PZBcIgkAK6Lr3utpQrJrZWkG/Fxq6LPH2RlNxV2WmTE+qNqLOVfuQZnitf++Sn+RpOeUq1GyfiW
        R8df0B9ilO2TjJrtX
X-Received: by 2002:adf:cd91:0:b0:230:1a1:ac8 with SMTP id q17-20020adfcd91000000b0023001a10ac8mr17144563wrj.530.1669199207466;
        Wed, 23 Nov 2022 02:26:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7DBrycSMtRfpVWb0DjgjF2JJxK4dEvrSsd4nDFPh2yUJ3xg97QJRSK7GC6rAJcZV0I8pmuZw==
X-Received: by 2002:adf:cd91:0:b0:230:1a1:ac8 with SMTP id q17-20020adfcd91000000b0023001a10ac8mr17144544wrj.530.1669199207125;
        Wed, 23 Nov 2022 02:26:47 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id p21-20020a1c7415000000b003cf75f56105sm1913361wmc.41.2022.11.23.02.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 02:26:46 -0800 (PST)
Message-ID: <e04315e7c90d9a75613f3993c2baf2d344eef7eb.camel@redhat.com>
Subject: Re: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket
 lock.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Wei Chen <harperchen1110@gmail.com>
Date:   Wed, 23 Nov 2022 11:26:45 +0100
In-Reply-To: <20221122205811.20910-1-kuniyu@amazon.com>
References: <20221122205811.20910-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-22 at 12:58 -0800, Kuniyuki Iwashima wrote:
> Wei Chen reported sk->sk_socket can be NULL in sk_user_ns(). [0][1]
> 
> It seems that syzbot was dumping an AF_UNIX socket while closing it,
> and there is a race below.
> 
>   unix_release_sock               unix_diag_handler_dump
>   |                               `- unix_diag_get_exact
>   |                                  |- unix_lookup_by_ino
>   |                                  |  |- spin_lock(&net->unx.table.locks[i])
>   |                                  |  |- sock_hold
>   |                                  |  `- spin_unlock(&net->unx.table.locks[i])
>   |- unix_remove_socket(net, sk)     |     /* after releasing this lock,
>   |  /* from here, sk cannot be      |      * there is no guarantee that
>   |   * seen in the hash table.      |      * sk is not SOCK_DEAD.
>   |   */                             |      */
>   |                                  |
>   |- unix_state_lock(sk)             |
>   |- sock_orphan(sk)                 `- sk_diag_fill
>   |  |- sock_set_flag(sk, SOCK_DEAD)    `- sk_diag_dump_uid
>   |  `- sk_set_socket(sk, NULL)            `- sk_user_ns
>   `- unix_state_unlock(sk)                   `- sk->sk_socket->file->f_cred->user_ns
>                                                 /* NULL deref here */
> 
> After releasing the bucket lock, we cannot guarantee that the found
> socket is still alive.  Then, we have to check the SOCK_DEAD flag
> under unix_state_lock() and keep holding it unless we access the socket.
> 
> In this case, however, we cannot acquire unix_state_lock() in
> unix_lookup_by_ino() because we lock it later in sk_diag_dump_peer(),
> resulting in deadlock.
> 
> Instead, we do not release the bucket lock; then, we can safely access
> sk->sk_socket later in sk_user_ns(), and there is no deadlock scenario.
> We are already using this strategy in unix_diag_dump().
> 
> Note we have to call nlmsg_new() before unix_lookup_by_ino() not to
> change the flag from GFP_KERNEL to GFP_ATOMIC.
> 
> [0]: https://lore.kernel.org/netdev/CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com/
> [1]:
> BUG: kernel NULL pointer dereference, address: 0000000000000270
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
> RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
> RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
> Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
> 54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
> 9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
> RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
> RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
> RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
> RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
> R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
> R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
> FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  unix_diag_get_exact net/unix/diag.c:285 [inline]
>  unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
>  __sock_diag_cmd net/core/sock_diag.c:235 [inline]
>  sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
>  netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
>  sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
>  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
>  netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
>  netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
>  ___sys_sendmsg net/socket.c:2530 [inline]
>  __sys_sendmsg+0x197/0x230 net/socket.c:2559
>  __do_sys_sendmsg net/socket.c:2568 [inline]
>  __se_sys_sendmsg net/socket.c:2566 [inline]
>  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x4697f9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
> RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
> RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
> R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
>  </TASK>
> Modules linked in:
> CR2: 0000000000000270

I *think* that the root cause of the above splat could be
different/simpler. In unix_diag_get_exact():

	
	rep = nlmsg_new(sizeof(struct unix_diag_msg) + extra_len, GFP_KERNEL);
        if (!rep)
                goto out;

	// rep->sk is NULL now.
        err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
                           nlh->nlmsg_seq, 0, req->udiag_ino);

and sk_diag_fill() will splats deterministically. Note that the user
space don't trigger that code path usually, but it can be reproduced
with a sligthly modified 'ss' version.


Thanks,

Paolo

