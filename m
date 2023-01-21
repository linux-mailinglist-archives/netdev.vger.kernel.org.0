Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3CB676709
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjAUPMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 10:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjAUPMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 10:12:33 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813EB23854
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 07:12:32 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9so7731811pll.9
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 07:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vhLg/NccQIbYS88/cxO9nYQLbfpzqVllO2E1gziu1e8=;
        b=C7NL6GLmd0U/chGijSaigUCtNfOnQbLJ57fswl4/KfeOFNbCAyu5pASwhGEaGxHIR7
         w16F6Z157TEj1ldXFoQ9L8fS0vUBBLkZWWj8pwTagJv/R9aI8cJ4O+xiz+aX5iqgFV8W
         WwsKkLb4sHVBNVbgvxar1DjZSfxvX+c7WQnRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhLg/NccQIbYS88/cxO9nYQLbfpzqVllO2E1gziu1e8=;
        b=aSjuUpfLUo6m6lOtZmTDKpLrGPNrO66QmxOp2P+G51KPKhW8R3iQ5i6HWUWfFxPZNc
         5eo1MCm6h08BcMyCNQORKNbEUTVeMQIZal7aoZaLP3om4Z8yJMfM9Z99YKbcBe06j4iW
         m2SxC1linQLc/TqBLGOd2ofyaYKAVQz8RGpqdAafCvIGzvB/8lMo43HdoTmPRoAG2D7n
         vU8URb9bu4ehd6MbyVzNitUGFWJEufph5TZF332KOxHgs3B6QE2PCZt3GX0XoiILnqMj
         JpRq2P3LYS+qZ8LCQXYxBHC/en1+8r2qrUUN02kfoPD1ZgOBs2KMIjxCBMoLjHqdv+UD
         8D1Q==
X-Gm-Message-State: AFqh2kq+nQxERxUyJndZxzzsC+0x/u7B/saGex2eHhI99tgCfOiOSoEl
        /NKTDU9V1vWtQq5D9FBebU4vVA==
X-Google-Smtp-Source: AMrXdXuhENILgOBYe6/WJH7uFb33v4/aZMz/eBea+PiWEqhrqCnNDObKkfxZMluNamW81rxK6PbnbA==
X-Received: by 2002:a05:6a20:6da9:b0:b5:c940:f587 with SMTP id gl41-20020a056a206da900b000b5c940f587mr16607912pzb.54.1674313951946;
        Sat, 21 Jan 2023 07:12:31 -0800 (PST)
Received: from ubuntu ([39.115.108.115])
        by smtp.gmail.com with ESMTPSA id u127-20020a626085000000b00580fb018e4bsm24013473pfb.211.2023.01.21.07.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 07:12:31 -0800 (PST)
Date:   Sat, 21 Jan 2023 07:12:27 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     imv4bel@gmail.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com
Subject: Re: [PATCH] netrom: Fix use-after-free caused by accept on already
 connected socket
Message-ID: <20230121151227.GA9907@ubuntu>
References: <20230121150859.GA9817@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121150859.GA9817@ubuntu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 07:08:59AM -0800, Hyunwoo Kim wrote:
> If listen() and accept() are called on an AF_NETROM socket that
> has already been connect()ed, accept() succeeds in connecting.
> This is because nr_accept() dequeues the skb queued in
> `sk->sk_receive_queue` in nr_connect().
> 
> This causes nr_accept() to allocate and return a sock with the
> sk of the parent AF_NETROM socket. And here's where use-after-free
> can happen through complex race conditions:
> ```
>                   cpu0                                                     cpu1
>                                                                1. socket_2 = socket(AF_NETROM)
>                                                                   listen(socket_2)
>                                                                   accepted_socket = accept(socket_2)    // loopback connection with socket_1
>        2. socket_1 = socket(AF_NETROM)
>             nr_create()    // sk refcount : 1
>           connect(socket_1)    // loopback connection with socket_2
>             nr_connect()
>             nr_establish_data_link()
>             nr_write_internal()
>             nr_transmit_buffer()
>             nr_route_frame()
>             nr_loopback_queue()
>             nr_loopback_timer()
>             nr_rx_frame()
>             nr_process_rx_frame()
>             nr_state3_machine()
>             nr_queue_rx_frame()
>             sock_queue_rcv_skb()
>             sock_queue_rcv_skb_reason()
>             __sock_queue_rcv_skb()
>             __skb_queue_tail(list, skb);    // list : sk->sk_receive_queue
> 
>        3. listen(socket_1)
>             nr_listen()
>           uaf_socket = accept(socket_1)
>             nr_accept()
>             skb_dequeue(&sk->sk_receive_queue);
>                                                                4. close(accepted_socket)
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
>        5. close(socket_1)    // sk refcount : 3
>             nr_release()    // NR_STATE_0
>             sock_put(sk);    // sk refcount : 0
>             sk_free(sk);
>           close(uaf_socket)
>             nr_release()
>             sock_hold(sk);    // UAF
> ```
> 
> KASAN report by syzbot:
> ```
> BUG: KASAN: use-after-free in nr_release+0x66/0x460 net/netrom/af_netrom.c:520
> Write of size 4 at addr ffff8880235d8080 by task syz-executor564/5128
> 
> CPU: 0 PID: 5128 Comm: syz-executor564 Not tainted 6.2.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:306 [inline]
>  print_report+0x15e/0x461 mm/kasan/report.c:417
>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
>  instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
>  atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
>  __refcount_add include/linux/refcount.h:193 [inline]
>  __refcount_inc include/linux/refcount.h:250 [inline]
>  refcount_inc include/linux/refcount.h:267 [inline]
>  sock_hold include/net/sock.h:775 [inline]
>  nr_release+0x66/0x460 net/netrom/af_netrom.c:520
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
> RIP: 0033:0x7f6c19e3c9b9
> Code: Unable to access opcode bytes at 0x7f6c19e3c98f.
> RSP: 002b:00007fffd4ba2ce8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: 0000000000000116 RBX: 0000000000000003 RCX: 00007f6c19e3c9b9
> RDX: 0000000000000318 RSI: 00000000200bd000 RDI: 0000000000000006
> RBP: 0000000000000003 R08: 000000000000000d R09: 000000000000000d
> R10: 0000000000000000 R11: 0000000000000246 R12: 000055555566a2c0
> R13: 0000000000000011 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> Allocated by task 5128:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>  __kasan_kmalloc+0xa3/0xb0 mm/kasan/common.c:380
>  kasan_kmalloc include/linux/kasan.h:211 [inline]
>  __do_kmalloc_node mm/slab_common.c:968 [inline]
>  __kmalloc+0x5a/0xd0 mm/slab_common.c:981
>  kmalloc include/linux/slab.h:584 [inline]
>  sk_prot_alloc+0x140/0x290 net/core/sock.c:2038
>  sk_alloc+0x3a/0x7a0 net/core/sock.c:2091
>  nr_create+0xb6/0x5f0 net/netrom/af_netrom.c:433
>  __sock_create+0x359/0x790 net/socket.c:1515
>  sock_create net/socket.c:1566 [inline]
>  __sys_socket_create net/socket.c:1603 [inline]
>  __sys_socket_create net/socket.c:1588 [inline]
>  __sys_socket+0x133/0x250 net/socket.c:1636
>  __do_sys_socket net/socket.c:1649 [inline]
>  __se_sys_socket net/socket.c:1647 [inline]
>  __x64_sys_socket+0x73/0xb0 net/socket.c:1647
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
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
> To fix this problem, nr_listen() returns -EINVAL for sockets that
> successfully nr_connect().
> 
> Reported-by: syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com
> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> ---
>  net/netrom/af_netrom.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
> index 6f7f4392cffb..dcfa606684d7 100644
> --- a/net/netrom/af_netrom.c
> +++ b/net/netrom/af_netrom.c
> @@ -400,6 +400,11 @@ static int nr_listen(struct socket *sock, int backlog)
>  	struct sock *sk = sock->sk;
>  
>  	lock_sock(sk);
> +	if (sock->state == SS_CONNECTED) {
> +		release_sock(sk);
> +		return -EINVAL;
> +	}
> +
>  	if (sk->sk_state != TCP_LISTEN) {
>  		memset(&nr_sk(sk)->user_addr, 0, AX25_ADDR_LEN);
>  		sk->sk_max_ack_backlog = backlog;
> -- 
> 2.25.1
> 

Dear,

Looks like a patch was recently submitted for another use-after-free bug in netrom:
https://lore.kernel.org/all/20230120231927.51711-1-kuniyu@amazon.com/

However, the connect -> accept bug I reported is unaffected by the above patch and still occurs.


Regards,
Hyunwoo Kim
