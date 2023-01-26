Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1005267D34A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjAZRfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjAZRfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:35:14 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E909861843;
        Thu, 26 Jan 2023 09:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674754507; x=1706290507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e7Or378m0ilQnqX4qg3Zvij7Es97Kd1qcbL6rPtQvG8=;
  b=i2l9gZKVGtd/4AQ77LGp3M7IooAz6KEih081dDBzf4w+R0QMLGBSrydi
   ///D9u5MU9YIwtw3BIvx3mfz3jFHztPulrOx3dS4CRiyreSFHjpqeCu8R
   Uo6vj/1uro1LazuUtxNlrWP/0SWiNxnczyPcBQO0viRmTge4/fsGXTGCw
   A=;
X-IronPort-AV: E=Sophos;i="5.97,249,1669075200"; 
   d="scan'208";a="175419122"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 17:34:59 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id CCCF881799;
        Thu, 26 Jan 2023 17:34:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 26 Jan 2023 17:34:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Thu, 26 Jan 2023 17:34:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <v4bel@theori.io>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <imv4bel@gmail.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-hams@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <ralf@linux-mips.org>,
        <syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] netrom: Fix use-after-free caused by accept on already connected socket
Date:   Thu, 26 Jan 2023 09:34:45 -0800
Message-ID: <20230126173445.97212-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230126041636.GA2599@ubuntu>
References: <20230126041636.GA2599@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D38UWB003.ant.amazon.com (10.43.161.178) To
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

From:   Hyunwoo Kim <v4bel@theori.io>
Date:   Wed, 25 Jan 2023 20:16:36 -0800
> On Wed, Jan 25, 2023 at 08:40:35AM -0800, Kuniyuki Iwashima wrote:
> > From:   Hyunwoo Kim <v4bel@theori.io>
> > Date:   Wed, 25 Jan 2023 01:17:10 -0800
> > > On Tue, Jan 24, 2023 at 05:43:47PM -0800, Kuniyuki Iwashima wrote:
> > > > Hi,
> > > > 
> > > > I think the diff looks good but changelog is not correct.
> > > > 
> > > > From:   Hyunwoo Kim <v4bel@theori.io>
> > > > Date:   Mon, 23 Jan 2023 09:22:33 -0800
> > > > > If listen() and accept() are called on an AF_NETROM socket that
> > > > > has already been connect()ed, accept() succeeds in connecting.
> > > > > This is because nr_accept() dequeues the skb queued in
> > > > > `sk->sk_receive_queue` in nr_connect().
> > > > 
> > > > This sentence is misleading.  The skb sent by nr_connect() is queued
> > > > up for the peer's sk_receive_queue (socket_2 below), and also the reply
> > > > is not queued for connect()er (socket_1) because it is NR_CONNACK and
> > > > just consumed by nr_state1_machine() to transition to NR_STATE_3 and
> > > > TCP_ESTABLISHED.
> > > > 
> > > > 
> > > > > 
> > > > > This causes nr_accept() to allocate and return a sock with the
> > > > > sk of the parent AF_NETROM socket.
> > > > 
> > > > This happens because the peer (socket_2) sends some data by nr_sendmsg(),
> > > > whose type is NR_INFO and the data is queued up for the connect()er's
> > > > (socket_1) sk_receive_queue by
> > > > 
> > > >   - nr_state3_machine
> > > >     - nr_queue_rx_frame
> > > >       - sock_queue_rcv_skb
> > > 
> > > you're right.
> > > I misanalyzed nr_rx_frame(). sorry.
> > > 
> > > > 
> > > > 
> > > > > And here's where use-after-free
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
> > > > 
> > > > This is NR_CONNREQ for socket_2.
> > > > 
> > > > 
> > > > >             nr_transmit_buffer()
> > > > >             nr_route_frame()
> > > > >             nr_loopback_queue()
> > > > >             nr_loopback_timer()
> > > > >             nr_rx_frame()
> > > > >             nr_process_rx_frame()
> > > > 
> > > > So, nr_process_rx_frame() is not called from nr_rx_frame() because the
> > > > kernel finds socket_2 by nr_find_listener(), and creates accepted_socket,
> > > > and then responds with NR_CONNACK to socket_1.
> > > > 
> > > > And accepted_socket sends some data with NR_INFO, then, nr_state3_machine()
> > > > is called for socket_1 and the skb with sk pointing socket_1 is queued for
> > > > socket_1's sk_receive_queue.
> > > > 
> > > > I think this part is lacking in this UAF scenario.
> > > > 
> > > > What do you think ?
> > > > 
> > > > 
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
> > > > >                                                                4. close(accepted_socket)
> > > > 
> > > > And I guess this close() is not so important in this case.
> > > > Even if we don't close the socket cleanly, the UAF will happen, right ?
> > > > (it might be caused in a different place like timer though)
> > > 
> > > IMHO, I think this `close(accepted_socket)` is a necessary procedure.
> > > This is because `case NR_STATE_3:` in nr_release() is executed here, 
> > > and nr_write_internal(sk, NR_DISCREQ) ~ nr_disconnect() sets socket_1's sk to NR_STATE_0.
> > > If sk of socket_1 is not set to NR_STATE_0, `case NR_STATE_3:` is executed instead of 
> > > `case NR_STATE_0:` in `close(socket_1)` and sk is not released.
> > 
> > No, it's released by the heartbeat timer.  The heartbeat timer finally
> > calls nr_destroy_socket() as SOCK_DESTROY is flagged to the sk.
> > 
> > 
> > > This means you will not be able to trigger UAF on close(uaf_socket).
> > 
> > I didn't say close(uaf_socket) is not needed, I mean we can
> > trigger UAF without close(__accepted_socket__).
> 
> ok. understand. The reason why I put close(accepted_socket) 
> is because Freed by task in the KASAN log I attached to the 
> patch description is as follows:

Ah, right.
Sorry, I was confused with 3 close()s :/


> ```
> Freed by task 5128:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:518
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x13b/0x1a0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:177 [inline]
>  __cache_free mm/slab.c:3394 [inline]
>  __do_kmem_cache_free mm/slab.c:3580 [inline]
>  __kmem_cache_free+0xcd/0x3b0 mm/slab.c:3587
>  sk_prot_free net/core/sock.c:2074 [inline]
>  __sk_destruct+0x5df/0x750 net/core/sock.c:2166
>  sk_destruct net/core/sock.c:2181 [inline]
>  __sk_free+0x175/0x460 net/core/sock.c:2192
>  sk_free+0x7c/0xa0 net/core/sock.c:2203
>  sock_put include/net/sock.h:1991 [inline]
>  nr_release+0x39e/0x460 net/netrom/af_netrom.c:554
>  __sock_release+0xcd/0x280 net/socket.c:650
>  sock_close+0x1c/0x20 net/socket.c:1365
>  __fput+0x27c/0xa90 fs/file_table.c:320
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  exit_task_work include/linux/task_work.h:38 [inline]
>  do_exit+0xaa8/0x2950 kernel/exit.c:867
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>  get_signal+0x21c3/0x2450 kernel/signal.c:2859
>  arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ```
> 
> If, as you say, heartbeat is running and UAF is triggered, 
> the KASAN Freed log will look like this:
> ```
> Freed by task 14094:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:177 [inline]
>  slab_free_hook mm/slub.c:1781 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
>  slab_free mm/slub.c:3787 [inline]
>  __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
>  sk_prot_free net/core/sock.c:2074 [inline]
>  __sk_destruct+0x5df/0x750 net/core/sock.c:2166
>  sk_destruct net/core/sock.c:2181 [inline]
>  __sk_free+0x175/0x460 net/core/sock.c:2192
>  sk_free+0x7c/0xa0 net/core/sock.c:2203
>  sock_put include/net/sock.h:1991 [inline]
>  nr_heartbeat_expiry+0x1d7/0x460 net/netrom/nr_timer.c:148
>  call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1700
>  expire_timers+0x2c6/0x5c0 kernel/time/timer.c:1751
>  __run_timers kernel/time/timer.c:2022 [inline]
>  __run_timers kernel/time/timer.c:1995 [inline]
>  run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
>  __do_softirq+0x1fb/0xadc kernel/softirq.c:571
> ```
> 
> Anyway, I'm trying to keep close(accepted_socket) in the flow chart 
> because the KASAN log I added to the first patch description is the first one.
> 
> > 
> > 
> > > 
> > > What do you think?
> > > 
> > > So the modified flow chart looks like this:
> > > ```
> > >                   cpu0                                                     cpu1
> > >                                                                1. socket_2 = socket(AF_NETROM)
> > >                                                                         .
> > >                                                                         .
> > >                                                                   listen(socket_2)
> > >                                                                   accepted_socket = accept(socket_2)
> > >        2. socket_1 = socket(AF_NETROM)
> > >             nr_create()    // sk refcount : 1
> > >           connect(socket_1)
> > >             nr_connect()
> > >             nr_establish_data_link()
> > >             nr_write_internal()
> > >             nr_transmit_buffer()
> > >             nr_route_frame()
> > >             nr_loopback_queue()
> > >             nr_loopback_timer()
> > >             nr_rx_frame()
> > >             nr_process_rx_frame()
> > >             nr_state1_machine()
> > >             nr->state      = NR_STATE_3;
> > 
> > If you write the connect()'s stack trace, you should note the state
> > change at the socket_1 side by NR_CONNACK.  The NR_STATE_3 here is
> > for socket_2 by NR_CONNREQ.  We don't need the details of socket_2.
> > 
> > Otherwise, you should just write connect(socket_1) only like the
> > step 1 (socket(), listen() etc).
> 
> So, the modified flow chart is:
> ```
>                   cpu0                                                     cpu1
>                                                                1. socket_2 = socket(AF_NETROM)
>                                                                         .
>                                                                         .
>                                                                   listen(socket_2)
>                                                                   accepted_socket = accept(socket_2)
>        2. socket_1 = socket(AF_NETROM)
>             nr_create()    // sk refcount : 1
>           connect(socket_1)
>                                                                3. write(accepted_socket)
>                                                                     nr_sendmsg()
>                                                                     nr_output()
>                                                                     nr_kick()
>                                                                     nr_send_iframe()
>                                                                     nr_transmit_buffer()
>                                                                     nr_route_frame()
>                                                                     nr_loopback_queue()
>                                                                     nr_loopback_timer()
>                                                                     nr_rx_frame()
>                                                                     nr_process_rx_frame(sk, skb);    // sk : socket_1's sk
>                                                                     nr_state3_machine()
>                                                                     nr_queue_rx_frame()
>                                                                     sock_queue_rcv_skb()
>                                                                     sock_queue_rcv_skb_reason()
>                                                                     __sock_queue_rcv_skb()
>                                                                     __skb_queue_tail(list, skb);    // list : socket_1's sk->sk_receive_queue
>        4. listen(socket_1)
>             nr_listen()
>           uaf_socket = accept(socket_1)
>             nr_accept()
>             skb_dequeue(&sk->sk_receive_queue);
>                                                                5. close(accepted_socket)
>                                                                     nr_release()
>                                                                     nr_write_internal(sk, NR_DISCREQ)
>                                                                     nr_transmit_buffer()    // NR_DISCREQ
>                                                                     nr_route_frame()
>                                                                     nr_loopback_queue()
>                                                                     nr_loopback_timer()
>                                                                     nr_rx_frame()    // sk : socket_1's sk
>                                                                     nr_process_rx_frame()  // NR_STATE_3
>                                                                     nr_state3_machine()    // NR_DISCREQ
>                                                                     nr_disconnect()
>                                                                     nr_sk(sk)->state = NR_STATE_0;
>        6. close(socket_1)    // sk refcount : 3
>             nr_release()    // NR_STATE_0
>             sock_put(sk);    // sk refcount : 0
>             sk_free(sk);
>           close(uaf_socket)
>             nr_release()
>             sock_hold(sk);    // UAF
> ```

Ok, this looks good.
Please send v4 without my Reviewed-by tag.

Thank you.

> 
> And sorry for sending the v3 netrom patch first. 
> I received an email that the v2 x25 patch with the wrong patch 
> description was applied to the tree, 
> so I made a v3 x25 patch in a hurry and sent the netrom as well.
> 
> > 
> > 
> > >                                                                3. write(accepted_socket)
> > >                                                                     nr_sendmsg()
> > >                                                                     nr_output()
> > >                                                                     nr_kick()
> > >                                                                     nr_send_iframe()
> > >                                                                     nr_transmit_buffer()
> > >                                                                     nr_route_frame()
> > >                                                                     nr_loopback_queue()
> > >                                                                     nr_loopback_timer()
> > >                                                                     nr_process_rx_frame(sk, skb);    // sk : socket_1's sk
> > >                                                                     nr_state3_machine()
> > >                                                                     nr_queue_rx_frame()
> > >                                                                     sock_queue_rcv_skb()
> > >                                                                     sock_queue_rcv_skb_reason()
> > >                                                                     __sock_queue_rcv_skb()
> > >                                                                     __skb_queue_tail(list, skb);    // list : socket_1's sk->sk_receive_queue
> > >        4. listen(socket_1)
> > >             nr_listen()
> > >           uaf_socket = accept(socket_1)
> > >             nr_accept()
> > >             skb_dequeue(&sk->sk_receive_queue);
> > >                                                                5. close(accepted_socket)
> > >                                                                     nr_release()
> > >                                                                     nr_write_internal(sk, NR_DISCREQ)
> > >                                                                     nr_transmit_buffer()    // NR_DISCREQ
> > >                                                                     nr_route_frame()
> > >                                                                     nr_loopback_queue()
> > >                                                                     nr_loopback_timer()
> > >                                                                     nr_rx_frame()    // sk : socket_1's sk
> > >                                                                     nr_process_rx_frame()  // NR_STATE_3
> > >                                                                     nr_state3_machine()    // NR_DISCREQ
> > >                                                                     nr_disconnect()
> > >                                                                     nr_sk(sk)->state = NR_STATE_0;
> > >        6. close(socket_1)    // sk refcount : 3
> > >             nr_release()    // NR_STATE_0
> > >             sock_put(sk);    // sk refcount : 0
> > >             sk_free(sk);
> > >           close(uaf_socket)
> > >             nr_release()
> > >             sock_hold(sk);    // UAF
> > > ```
> > > 
> > > Anything wrong?
> > > 
> > > 
> > > > 
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
> > > > > To fix this problem, nr_listen() returns -EINVAL for sockets that successfully nr_connect().
> > > > > 
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > > Reported-by: syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com
> > > > > Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> > > > > ---
> > > > >  net/netrom/af_netrom.c | 5 +++++
> > > > >  1 file changed, 5 insertions(+)
> > > > > 
> > > > > diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
> > > > > index 6f7f4392cffb..5a4cb796150f 100644
> > > > > --- a/net/netrom/af_netrom.c
> > > > > +++ b/net/netrom/af_netrom.c
> > > > > @@ -400,6 +400,11 @@ static int nr_listen(struct socket *sock, int backlog)
> > > > >  	struct sock *sk = sock->sk;
> > > > >  
> > > > >  	lock_sock(sk);
> > > > > +	if (sock->state != SS_UNCONNECTED) {
> > > > > +		release_sock(sk);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > >  	if (sk->sk_state != TCP_LISTEN) {
> > > > >  		memset(&nr_sk(sk)->user_addr, 0, AX25_ADDR_LEN);
> > > > >  		sk->sk_max_ack_backlog = backlog;
> > > > > -- 
> > > > > 2.25.1
