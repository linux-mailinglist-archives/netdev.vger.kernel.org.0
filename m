Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC1E636351
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbiKWPWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbiKWPWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:22:22 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD65E9E7
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669216941; x=1700752941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DcjnVufAsut0UT9yHPfeS4AedOtr5yAK8B0F1zHkUX4=;
  b=bYa3Y30sCylaxuT0vqb1wO8w1EMe1lAjjyUAbBm3DYD0NLFLmqDSSpmH
   W+WZ/wNTkuUFUKsbrdMvuxl+L50LYgr+rsdkwfvXAEmq40YBOsKfyjD/w
   3b3Hw5E99wLID91S+NqcaJl+RPbTJqXA8ZgpS6ffYfyEItjAWOLhiM5+k
   I=;
X-IronPort-AV: E=Sophos;i="5.96,187,1665446400"; 
   d="scan'208";a="270035571"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:22:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 3D777341DF3;
        Wed, 23 Nov 2022 15:22:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 23 Nov 2022 15:22:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 23 Nov 2022 15:22:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <harperchen1110@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket lock.
Date:   Wed, 23 Nov 2022 07:22:05 -0800
Message-ID: <20221123152205.79232-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAO4mrfcuDa5hKFksJtBLskA3AAuHUTP_wO9JOfD9Kq0ZvEPPCA@mail.gmail.com>
References: <CAO4mrfcuDa5hKFksJtBLskA3AAuHUTP_wO9JOfD9Kq0ZvEPPCA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D48UWB001.ant.amazon.com (10.43.163.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Wei Chen <harperchen1110@gmail.com>
Date:   Wed, 23 Nov 2022 23:09:53 +0800
> Dear Paolo,
> 
> Could you explain the meaning of modified "ss" version to reproduce
> the bug? I'd like to learn how to reproduce the bug in the user space
> to facilitate the bug fix.

I think it means to drop NLM_F_DUMP and modify args as needed because
ss dumps all sockets, not exactly a single socket.

And please do not top-post :)

> 
> Best,
> Wei
> 
> On Wed, 23 Nov 2022 at 18:26, Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Tue, 2022-11-22 at 12:58 -0800, Kuniyuki Iwashima wrote:
> > > Wei Chen reported sk->sk_socket can be NULL in sk_user_ns(). [0][1]
> > >
> > > It seems that syzbot was dumping an AF_UNIX socket while closing it,
> > > and there is a race below.
> > >
> > >   unix_release_sock               unix_diag_handler_dump
> > >   |                               `- unix_diag_get_exact
> > >   |                                  |- unix_lookup_by_ino
> > >   |                                  |  |- spin_lock(&net->unx.table.locks[i])
> > >   |                                  |  |- sock_hold
> > >   |                                  |  `- spin_unlock(&net->unx.table.locks[i])
> > >   |- unix_remove_socket(net, sk)     |     /* after releasing this lock,
> > >   |  /* from here, sk cannot be      |      * there is no guarantee that
> > >   |   * seen in the hash table.      |      * sk is not SOCK_DEAD.
> > >   |   */                             |      */
> > >   |                                  |
> > >   |- unix_state_lock(sk)             |
> > >   |- sock_orphan(sk)                 `- sk_diag_fill
> > >   |  |- sock_set_flag(sk, SOCK_DEAD)    `- sk_diag_dump_uid
> > >   |  `- sk_set_socket(sk, NULL)            `- sk_user_ns
> > >   `- unix_state_unlock(sk)                   `- sk->sk_socket->file->f_cred->user_ns
> > >                                                 /* NULL deref here */
> > >
> > > After releasing the bucket lock, we cannot guarantee that the found
> > > socket is still alive.  Then, we have to check the SOCK_DEAD flag
> > > under unix_state_lock() and keep holding it unless we access the socket.
> > >
> > > In this case, however, we cannot acquire unix_state_lock() in
> > > unix_lookup_by_ino() because we lock it later in sk_diag_dump_peer(),
> > > resulting in deadlock.
> > >
> > > Instead, we do not release the bucket lock; then, we can safely access
> > > sk->sk_socket later in sk_user_ns(), and there is no deadlock scenario.
> > > We are already using this strategy in unix_diag_dump().
> > >
> > > Note we have to call nlmsg_new() before unix_lookup_by_ino() not to
> > > change the flag from GFP_KERNEL to GFP_ATOMIC.
> > >
> > > [0]: https://lore.kernel.org/netdev/CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com/
> > > [1]:
> > > BUG: kernel NULL pointer dereference, address: 0000000000000270
> > > #PF: supervisor read access in kernel mode
> > > #PF: error_code(0x0000) - not-present page
> > > PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
> > > Oops: 0000 [#1] PREEMPT SMP
> > > CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > > rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> > > RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
> > > RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
> > > RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
> > > Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
> > > 54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
> > > 9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
> > > RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
> > > RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
> > > RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
> > > RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
> > > R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
> > > R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
> > > FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  unix_diag_get_exact net/unix/diag.c:285 [inline]
> > >  unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
> > >  __sock_diag_cmd net/core/sock_diag.c:235 [inline]
> > >  sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
> > >  netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
> > >  sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
> > >  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
> > >  netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
> > >  netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
> > >  sock_sendmsg_nosec net/socket.c:714 [inline]
> > >  sock_sendmsg net/socket.c:734 [inline]
> > >  ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
> > >  ___sys_sendmsg net/socket.c:2530 [inline]
> > >  __sys_sendmsg+0x197/0x230 net/socket.c:2559
> > >  __do_sys_sendmsg net/socket.c:2568 [inline]
> > >  __se_sys_sendmsg net/socket.c:2566 [inline]
> > >  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x4697f9
> > > Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> > > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > > 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > > RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
> > > RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
> > > RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
> > > R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
> > >  </TASK>
> > > Modules linked in:
> > > CR2: 0000000000000270
> >
> > I *think* that the root cause of the above splat could be
> > different/simpler. In unix_diag_get_exact():
> >
> >
> >         rep = nlmsg_new(sizeof(struct unix_diag_msg) + extra_len, GFP_KERNEL);
> >         if (!rep)
> >                 goto out;
> >
> >         // rep->sk is NULL now.
> >         err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
> >                            nlh->nlmsg_seq, 0, req->udiag_ino);
> >
> > and sk_diag_fill() will splats deterministically. Note that the user
> > space don't trigger that code path usually, but it can be reproduced
> > with a sligthly modified 'ss' version.

Ah, I misunderstood that the found sk is passed to sk_user_ns(), but it's
skb->sk.

I'll check again.

Thank you, Paolo!


P.S.  I'm leaving for Japan today and will be bit slow this and next week
for vacation.
