Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EFD67864A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjAWT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjAWT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:28:08 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6D7A241;
        Mon, 23 Jan 2023 11:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674502087; x=1706038087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tfaw+/L87CG5yg03iqoYJpp0kgXeawdLvGY7KUo08aE=;
  b=DT5YgDymMJMvBivJBvDgFafiQIrnpUAwaV/5Ndbb59kogSozfHmtN9UY
   25TP0t9CXgaaNNkYBqP+Fcg540oetWMlBnqQs8TX20PL3G0Bspp95HaED
   lf/p/xOVfOcUyT9rHcLtedGy8Fw3D9bQ+M69We9p5qeOgNp+8cGjzLEGM
   s=;
X-IronPort-AV: E=Sophos;i="5.97,240,1669075200"; 
   d="scan'208";a="285659779"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 19:28:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 60CCA4178C;
        Mon, 23 Jan 2023 19:28:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 23 Jan 2023 19:28:00 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Mon, 23 Jan 2023 19:27:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <v4bel@theori.io>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <imv4bel@gmail.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-hams@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <ralf@linux-mips.org>,
        <syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com>
Subject: Re: [PATCH] netrom: Fix use-after-free caused by accept on already connected socket
Date:   Mon, 23 Jan 2023 11:27:49 -0800
Message-ID: <20230123192749.63775-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230123182209.GB108558@ubuntu>
References: <20230123182209.GB108558@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D42UWB004.ant.amazon.com (10.43.161.99) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Hyunwoo Kim <v4bel@theori.io>
Date:   Mon, 23 Jan 2023 10:22:09 -0800
> On Mon, Jan 23, 2023 at 09:24:57AM -0800, Kuniyuki Iwashima wrote:
> > From:   Hyunwoo Kim <v4bel@theori.io>
> > Date:   Mon, 23 Jan 2023 08:57:06 -0800
> > > Hi,
> > > 
> > > Thank you for your review.
> > > 
> > > 
> > > On Mon, Jan 23, 2023 at 08:22:00AM -0800, Kuniyuki Iwashima wrote:
> > > > Hi,
> > > > 
> > > > Thanks for the patch!
> > > > 
> > > > From:   Hyunwoo Kim <v4bel@theori.io>
> > > > Date:   Sat, 21 Jan 2023 07:08:59 -0800
> > > > > If listen() and accept() are called on an AF_NETROM socket that
> > > > > has already been connect()ed, accept() succeeds in connecting.
> > > > > This is because nr_accept() dequeues the skb queued in
> > > > > `sk->sk_receive_queue` in nr_connect().
> > > > > 
> > > > > This causes nr_accept() to allocate and return a sock with the
> > > > > sk of the parent AF_NETROM socket. And here's where use-after-free
> > > > > can happen through complex race conditions:
> > > > > ```
> > > > >                   cpu0                                                     cpu1
> > > > >                                                                1. socket_2 = socket(AF_NETROM)
> > > > >                                                                   listen(socket_2)
> > > > >                                                                   accepted_socket = accept(socket_2)    // loopback connection with socket_1
> > > > >        2. socket_1 = socket(AF_NETROM)
> > > > >             nr_create()    // sk refcount : 1
> > > > >           connect(socket_1)    // loopback connection with socket_2
> > > > >             nr_connect()
> > > > >             nr_establish_data_link()
> > > > >             nr_write_internal()
> > > > >             nr_transmit_buffer()
> > > > >             nr_route_frame()
> > > > >             nr_loopback_queue()
> > > > >             nr_loopback_timer()
> > > > >             nr_rx_frame()
> > > > >             nr_process_rx_frame()
> > > > >             nr_state3_machine()
> > > > >             nr_queue_rx_frame()
> > > > >             sock_queue_rcv_skb()
> > > > >             sock_queue_rcv_skb_reason()
> > > > >             __sock_queue_rcv_skb()
> > > > >             __skb_queue_tail(list, skb);    // list : sk->sk_receive_queue
> > > > > 
> > > > >        3. listen(socket_1)
> > > > >             nr_listen()
> > > > >           uaf_socket = accept(socket_1)
> > > > >             nr_accept()
> > > > >             skb_dequeue(&sk->sk_receive_queue);
> > > > 
> > > > Sorry, I didn't understand how this is populated by close(accepted_socket),
> > > > especially how skb->sk is set as socket_1's sk.
> > > 
> > > When calling close(accepted_socket), accepted_socket is currently in NR_STATE_3 state, 
> > > so nr_release() calls `nr_write_internal(sk, NR_DISCREQ)`.
> > > In a later flow, nr_rx_frame() is called, where nr_find_socket() is used to get socket_1's sk 
> > > from the global list `nr_list` (Because `circuit_index` and `circuit_id` used for search were index/id of socket_1's sk):
> > > ```
> > >         sk = NULL;
> > > 
> > >         if (circuit_index == 0 && circuit_id == 0) {
> > >                 if (frametype == NR_CONNACK && flags == NR_CHOKE_FLAG)
> > >                         sk = nr_find_peer(peer_circuit_index, peer_circuit_id, src);
> > >         } else {
> > >                 if (frametype == NR_CONNREQ)
> > >                         sk = nr_find_peer(circuit_index, circuit_id, src);
> > >                 else
> > >                         sk = nr_find_socket(circuit_index, circuit_id);    // here
> > >         }
> > > ```
> > > 
> > > And nr_process_rx_frame(), nr_state3_machine(), nr_disconnect() are executed sequentially, 
> > > and `nr_sk(sk)->state = NR_STATE_0;` is executed, so the state of socket_1 sk becomes NR_STATE_0.
> > 
> > Right, but nr_process_rx_frame() just sends out NR_DISCACK for
> > accepted_socket, and nr_disconnect() does not queue skb for socket_1 ?
> > 
> > IIUC, uaf_socket's sk is the same one with socket_1, but I'm wondering
> > how the sk is queued up for socket_1's recv queue at 4.
> 
> As I understand it, you know that socket_1 and uaf_socket's sk are the same, 
> but you're confused about how the accepted_socket's sk of number 4 is equal 
> to socket_1's sk, am I correct?

No.  I'm not sure how close(accepeted_socket) populates socket_1's
sk_receive_queue by a skb->sk with socket_1's sk so that uaf_socket
has the same sk with socket_1.


> 
> The sk of socket_1 and the sk of accepted_socket are completely different.
> In the flow chart I made, socket_1 and uaf_socket have the same sk,
> socket_2 has distinct sk, and accepted_socket has distinct non-overlapping sk.
> (There are a total of three sks in the flowchart.)
> 
> The reason accepted_socket can refer to the sk of socket_1 in #4 is that 
> `->your_index` and `->your_id` of the sk of accepted_socket point to the sk of socket_1.
> As explained before, this index/id is used to get the sk of socket_1. 
> (In flowchart #4, nr_process_rx_frame() is called using the sk of socket_1 retrieved 
> from nr_list, rather than using accepted_socket's own sk)

I understand this, but to make "uaf_socket = accept(socket_1)" happen,
we need to put a skb in socket_1's recv_q in 4. with the found sk.

As you said, 4. finds the sk by nr_find_socket() (as not listener) and ends
up calling nr_process_rx_frame(), which does not queue the skb with the sk
for socket_1's queue, right ?

In short, where is a skb created with socket_1's sk and queued for
socket_1's recv_q ?  We don't call sock_queue_rcv_skb() at 4.

> 
> Please let me know if I'm misunderstanding and giving a strange answer.
> 
> > 
> > 
> > > 
> > > As a result, `5. In close(socket_1)`, the code of `case NR_STATE_0:` of nr_release() is executed 
> > > to free the sk, and finally, by calling `close(uaf_socket)`, UAF occurs by referring to the freed sk.
> > > 
> > > > 
> > > > 
> > > > >                                                                4. close(accepted_socket)
> > > > >                                                                     nr_release()
> > > > >                                                                     nr_write_internal(sk, NR_DISCREQ)
> > > > >                                                                     nr_transmit_buffer()    // NR_DISCREQ
> > > > >                                                                     nr_route_frame()
> > > > >                                                                     nr_loopback_queue()
> > > > >                                                                     nr_loopback_timer()
> > > > >                                                                     nr_rx_frame()    // sk : socket_1's sk
> > > > >                                                                     nr_process_rx_frame()  // NR_STATE_3
> > > > >                                                                     nr_state3_machine()    // NR_DISCREQ
> > > > >                                                                     nr_disconnect()
> > > > >                                                                     nr_sk(sk)->state = NR_STATE_0;
> > > > >        5. close(socket_1)    // sk refcount : 3
> > > > >             nr_release()    // NR_STATE_0
> > > > >             sock_put(sk);    // sk refcount : 0
> > > > >             sk_free(sk);
> > > > >           close(uaf_socket)
> > > > >             nr_release()
> > > > >             sock_hold(sk);    // UAF
> > > > > ```
> > > > > 
> > > > > KASAN report by syzbot:
> > > > > ```
> > > > > BUG: KASAN: use-after-free in nr_release+0x66/0x460 net/netrom/af_netrom.c:520
> > > > > Write of size 4 at addr ffff8880235d8080 by task syz-executor564/5128
> > > > > 
> > > > > CPU: 0 PID: 5128 Comm: syz-executor564 Not tainted 6.2.0-rc1-syzkaller #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > > > > Call Trace:
> > > > >  <TASK>
> > > > >  __dump_stack lib/dump_stack.c:88 [inline]
> > > > >  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
> > > > >  print_address_description mm/kasan/report.c:306 [inline]
> > > > >  print_report+0x15e/0x461 mm/kasan/report.c:417
> > > > >  kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
> > > > >  check_region_inline mm/kasan/generic.c:183 [inline]
> > > > >  kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
> > > > >  instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
> > > > >  atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
> > > > >  __refcount_add include/linux/refcount.h:193 [inline]
> > > > >  __refcount_inc include/linux/refcount.h:250 [inline]
> > > > >  refcount_inc include/linux/refcount.h:267 [inline]
> > > > >  sock_hold include/net/sock.h:775 [inline]
> > > > >  nr_release+0x66/0x460 net/netrom/af_netrom.c:520
> > > > >  __sock_release+0xcd/0x280 net/socket.c:650
> > > > >  sock_close+0x1c/0x20 net/socket.c:1365
> > > > >  __fput+0x27c/0xa90 fs/file_table.c:320
> > > > >  task_work_run+0x16f/0x270 kernel/task_work.c:179
> > > > >  exit_task_work include/linux/task_work.h:38 [inline]
> > > > >  do_exit+0xaa8/0x2950 kernel/exit.c:867
> > > > >  do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> > > > >  get_signal+0x21c3/0x2450 kernel/signal.c:2859
> > > > >  arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> > > > >  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > > > >  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> > > > >  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> > > > >  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> > > > >  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > RIP: 0033:0x7f6c19e3c9b9
> > > > > Code: Unable to access opcode bytes at 0x7f6c19e3c98f.
> > > > > RSP: 002b:00007fffd4ba2ce8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> > > > > RAX: 0000000000000116 RBX: 0000000000000003 RCX: 00007f6c19e3c9b9
> > > > > RDX: 0000000000000318 RSI: 00000000200bd000 RDI: 0000000000000006
> > > > > RBP: 0000000000000003 R08: 000000000000000d R09: 000000000000000d
> > > > > R10: 0000000000000000 R11: 0000000000000246 R12: 000055555566a2c0
> > > > > R13: 0000000000000011 R14: 0000000000000000 R15: 0000000000000000
> > > > >  </TASK>
> > > > > 
> > > > > Allocated by task 5128:
> > > > >  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> > > > >  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> > > > >  ____kasan_kmalloc mm/kasan/common.c:371 [inline]
> > > > >  ____kasan_kmalloc mm/kasan/common.c:330 [inline]
> > > > >  __kasan_kmalloc+0xa3/0xb0 mm/kasan/common.c:380
> > > > >  kasan_kmalloc include/linux/kasan.h:211 [inline]
> > > > >  __do_kmalloc_node mm/slab_common.c:968 [inline]
> > > > >  __kmalloc+0x5a/0xd0 mm/slab_common.c:981
> > > > >  kmalloc include/linux/slab.h:584 [inline]
> > > > >  sk_prot_alloc+0x140/0x290 net/core/sock.c:2038
> > > > >  sk_alloc+0x3a/0x7a0 net/core/sock.c:2091
> > > > >  nr_create+0xb6/0x5f0 net/netrom/af_netrom.c:433
> > > > >  __sock_create+0x359/0x790 net/socket.c:1515
> > > > >  sock_create net/socket.c:1566 [inline]
> > > > >  __sys_socket_create net/socket.c:1603 [inline]
> > > > >  __sys_socket_create net/socket.c:1588 [inline]
> > > > >  __sys_socket+0x133/0x250 net/socket.c:1636
> > > > >  __do_sys_socket net/socket.c:1649 [inline]
> > > > >  __se_sys_socket net/socket.c:1647 [inline]
> > > > >  __x64_sys_socket+0x73/0xb0 net/socket.c:1647
> > > > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > > >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > 
> > > > > Freed by task 5128:
> > > > >  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> > > > >  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> > > > >  kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:518
> > > > >  ____kasan_slab_free mm/kasan/common.c:236 [inline]
> > > > >  ____kasan_slab_free+0x13b/0x1a0 mm/kasan/common.c:200
> > > > >  kasan_slab_free include/linux/kasan.h:177 [inline]
> > > > >  __cache_free mm/slab.c:3394 [inline]
> > > > >  __do_kmem_cache_free mm/slab.c:3580 [inline]
> > > > >  __kmem_cache_free+0xcd/0x3b0 mm/slab.c:3587
> > > > >  sk_prot_free net/core/sock.c:2074 [inline]
> > > > >  __sk_destruct+0x5df/0x750 net/core/sock.c:2166
> > > > >  sk_destruct net/core/sock.c:2181 [inline]
> > > > >  __sk_free+0x175/0x460 net/core/sock.c:2192
> > > > >  sk_free+0x7c/0xa0 net/core/sock.c:2203
> > > > >  sock_put include/net/sock.h:1991 [inline]
> > > > >  nr_release+0x39e/0x460 net/netrom/af_netrom.c:554
> > > > >  __sock_release+0xcd/0x280 net/socket.c:650
> > > > >  sock_close+0x1c/0x20 net/socket.c:1365
> > > > >  __fput+0x27c/0xa90 fs/file_table.c:320
> > > > >  task_work_run+0x16f/0x270 kernel/task_work.c:179
> > > > >  exit_task_work include/linux/task_work.h:38 [inline]
> > > > >  do_exit+0xaa8/0x2950 kernel/exit.c:867
> > > > >  do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> > > > >  get_signal+0x21c3/0x2450 kernel/signal.c:2859
> > > > >  arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> > > > >  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > > > >  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> > > > >  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> > > > >  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> > > > >  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > ```
> > > > > 
> > > > > To fix this problem, nr_listen() returns -EINVAL for sockets that
> > > > > successfully nr_connect().
> > > > >
> > > > 
> > > > I'd add
> > > > 
> > > >   Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > 
> > > > > Reported-by: syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com
> > > > > Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> > > > > ---
> > > > >  net/netrom/af_netrom.c | 5 +++++
> > > > >  1 file changed, 5 insertions(+)
> > > > > 
> > > > > diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
> > > > > index 6f7f4392cffb..dcfa606684d7 100644
> > > > > --- a/net/netrom/af_netrom.c
> > > > > +++ b/net/netrom/af_netrom.c
> > > > > @@ -400,6 +400,11 @@ static int nr_listen(struct socket *sock, int backlog)
> > > > >  	struct sock *sk = sock->sk;
> > > > >  
> > > > >  	lock_sock(sk);
> > > > > +	if (sock->state == SS_CONNECTED) {
> > > > 
> > > > I guess the same issue happens for SS_CONNECTING (non-blocking connect()),
> > > > so this should be
> > > > 
> > > >         if (sock->state != SS_UNCONNECTED) {
> > > > 
> > > > ?
> > > > 
> > > > Same for the rose and x25 patches.
> > > > https://lore.kernel.org/netdev/20230122173957.GA99728@ubuntu/
> > > > https://lore.kernel.org/netdev/20230122170925.GA98061@ubuntu/
> > > 
> > > you're right.
> > > I will submit the fixed v2 patches.
> > > 
> > > Regards,
> > > Hyunwoo Kim
> > > 
> > > > 
> > > > 
> > > > Thanks,
> > > > Kuniyuki
> > > > 
> > > > > +		release_sock(sk);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > >  	if (sk->sk_state != TCP_LISTEN) {
> > > > >  		memset(&nr_sk(sk)->user_addr, 0, AX25_ADDR_LEN);
> > > > >  		sk->sk_max_ack_backlog = backlog;
> > > > > -- 
> > > > > 2.25.1
