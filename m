Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45985687CE6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjBBMJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjBBMJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:09:26 -0500
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E2E89367;
        Thu,  2 Feb 2023 04:09:24 -0800 (PST)
Received: by mail-io1-f41.google.com with SMTP id y2so647810iot.4;
        Thu, 02 Feb 2023 04:09:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3yqTjoiurUNw6iqh9W7t7GhYeJehAa2SRb6L8gDpCOM=;
        b=Bsg3ixvJWp0Em5RjlTrKNtLOX0ZC5lx/Rc3nNG7RPaT/OtwLTBQxFIJl2JNKb6Jl+E
         xoTKIvcUzlzUwuSXrjlqSZHw1O3iptU6RhI22n/OzSKTOy60Ms4/Qf7V6mcYskfmgCkN
         s5fvymOOyURpIRqY1Jig/UAuu7MYef9WVW2RtvK1Kfdyv6l2ia6xH3yWS9EqSaiDhDsW
         6ra+535kHg+TRvARVg0CusV8XjhTcZ14LxfsR4QQ2egH2nNVsu4CLtW7fvHb8fl+l3Mq
         eAkueQCHeid5nLKK+4tQKJNIEZAXQOZRGlHHDAZy6FSsj5/jzl6/ZcUXxDJ7VxeuhjOu
         sOOw==
X-Gm-Message-State: AO0yUKUSMygaqBRos658Y0X3laZu/pvGJNqrsB7l/P9SiaAr3lFYzQ3G
        4kEi7oj5vZERk1X8bfksAZ1jMSr+n+p5mQ==
X-Google-Smtp-Source: AK7set/9ESYYv6tvDVUzrWC+jHT3ARDbiwbIrf6ZCRppJHxvXsPr55Y7CDsrH4Cy0xNnPFa7/C0rkw==
X-Received: by 2002:a05:6602:2748:b0:704:c2fe:d923 with SMTP id b8-20020a056602274800b00704c2fed923mr1466535ioe.2.1675339763002;
        Thu, 02 Feb 2023 04:09:23 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id o17-20020a056602125100b0071b3d353401sm3894809iou.33.2023.02.02.04.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 04:09:22 -0800 (PST)
From:   Sungwoo Kim <iam@sung-woo.kim>
To:     edumazet@google.com
Cc:     benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
        happiness.sung.woo@gmail.com, iam@sung-woo.kim,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wuruoyu@me.com
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix use-after-free
Date:   Thu,  2 Feb 2023 07:09:02 -0500
Message-Id: <20230202120902.2827191-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CANn89i+hAht=g1F6kjPfq8eO4j6-2WEE+CNtRtq1S4UnwXEQaw@mail.gmail.com>
References: <CANn89i+hAht=g1F6kjPfq8eO4j6-2WEE+CNtRtq1S4UnwXEQaw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 4:26 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 2, 2023 at 10:07 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
> >
> > Due to the race condition between l2cap_sock_cleanup_listen and
> > l2cap_sock_close_cb, l2cap_sock_kill can receive already freed sk,
> > resulting in use-after-free inside l2cap_sock_kill.
> > This patch prevent this by adding a null check in l2cap_sock_kill.
> >
> > Context 1:
> > l2cap_sock_cleanup_listen();
> >   // context switched
> >   l2cap_chan_lock(chan);
> >   l2cap_sock_kill(sk); // <-- sk is already freed below
>
> But sk is used in l2cap_sock_cleanup_listen()
> and should not be NULL...
>
> while ((sk = bt_accept_dequeue(parent, NULL))) {
>   ...
>   l2cap_sock_kill(sk);
>   ..
> }
>
> It would help if you send us a stack trace ...

Here is the stack trace and l2cap_sock.c:
https://gist.github.com/swkim101/5c3b8cb7c7d7172aef23810c9412f323

==================================================================
BUG: KASAN: use-after-free in l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1281) 
Read of size 8 at addr ffff88800f7f4060 by task l2cap-server/1764
CPU: 0 PID: 1764 Comm: l2cap-server Not tainted 6.1.0-rc2 #129
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
dump_stack_lvl (/v6.1-rc2/lib/dump_stack.c:105) 
print_address_description+0x7e/0x360 
print_report (/v6.1-rc2/mm/kasan/report.c:187 /v6.1-rc2/mm/kasan/report.c:389) 
? __virt_addr_valid (/v6.1-rc2/./include/linux/mmzone.h:1855 /v6.1-rc2/arch/x86/mm/physaddr.c:65) 
? kasan_complete_mode_report_info (/v6.1-rc2/mm/kasan/report_generic.c:104 /v6.1-rc2/mm/kasan/report_generic.c:127 /v6.1-rc2/mm/kasan/report_generic.c:136) 
? l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1281) 
kasan_report (/v6.1-rc2/mm/kasan/report.c:? /v6.1-rc2/mm/kasan/report.c:484) 
? l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1281) 
kasan_check_range (/v6.1-rc2/mm/kasan/generic.c:85 /v6.1-rc2/mm/kasan/generic.c:115 /v6.1-rc2/mm/kasan/generic.c:128 /v6.1-rc2/mm/kasan/generic.c:159 /v6.1-rc2/mm/kasan/generic.c:180 /v6.1-rc2/mm/kasan/generic.c:189) 
__kasan_check_read (/v6.1-rc2/mm/kasan/shadow.c:31) 
l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1281) 
l2cap_sock_teardown_cb (/v6.1-rc2/./include/net/bluetooth/bluetooth.h:304 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1475 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1612) 
l2cap_chan_close (/v6.1-rc2/net/bluetooth/l2cap_core.c:885) 
? __kasan_check_write (/v6.1-rc2/mm/kasan/shadow.c:37) 
l2cap_sock_shutdown (/v6.1-rc2/./include/linux/kcsan-checks.h:231 /v6.1-rc2/./include/net/sock.h:2470 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1321 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1377) 
? _raw_write_unlock (/v6.1-rc2/./include/asm-generic/qrwlock.h:122 /v6.1-rc2/./include/linux/rwlock_api_smp.h:225 /v6.1-rc2/kernel/locking/spinlock.c:342) 
l2cap_sock_release (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1453) 
sock_close (/v6.1-rc2/net/socket.c:1382) 
? sock_mmap (/v6.1-rc2/net/socket.c:?) 
__fput (/v6.1-rc2/./include/linux/fsnotify.h:? /v6.1-rc2/./include/linux/fsnotify.h:99 /v6.1-rc2/./include/linux/fsnotify.h:341 /v6.1-rc2/fs/file_table.c:306) 
____fput (/v6.1-rc2/fs/file_table.c:348) 
task_work_run (/v6.1-rc2/kernel/task_work.c:165) 
do_exit (/v6.1-rc2/kernel/exit.c:?) 
do_group_exit (/v6.1-rc2/kernel/exit.c:943) 
? __kasan_check_write (/v6.1-rc2/mm/kasan/shadow.c:37) 
get_signal (/v6.1-rc2/kernel/signal.c:2863) 
? _raw_spin_unlock (/v6.1-rc2/./include/linux/spinlock_api_smp.h:142 /v6.1-rc2/kernel/locking/spinlock.c:186) 
? finish_task_switch (/v6.1-rc2/./arch/x86/include/asm/current.h:15 /v6.1-rc2/kernel/sched/core.c:5065) 
arch_do_signal_or_restart (/v6.1-rc2/arch/x86/kernel/signal.c:869) 
exit_to_user_mode_prepare (/v6.1-rc2/kernel/entry/common.c:383) 
syscall_exit_to_user_mode (/v6.1-rc2/./arch/x86/include/asm/current.h:15 /v6.1-rc2/kernel/entry/common.c:261 /v6.1-rc2/kernel/entry/common.c:283 /v6.1-rc2/kernel/entry/common.c:296) 
do_syscall_64 (/v6.1-rc2/arch/x86/entry/common.c:50 /v6.1-rc2/arch/x86/entry/common.c:80) 
? sysvec_apic_timer_interrupt (/v6.1-rc2/arch/x86/kernel/apic/apic.c:1107) 
entry_SYSCALL_64_after_hwframe (/v6.1-rc2/arch/x86/entry/entry_64.S:120) 
RIP: 0033:0x7f66c14db970
Code: Unable to access opcode bytes at 0x7f66c14db946.

Code starting with the faulting instruction
===========================================
RSP: 002b:00007ffe166a5508 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: 0000000000000013 RBX: 0000000000000013 RCX: 00007f66c14db970
RDX: 0000000000000013 RSI: 00007ffe166a56d0 RDI: 0000000000000002
RBP: 00007ffe166a56d0 R08: 00007f66c1a28440 R09: 0000000000000013
R10: 0000000000000078 R11: 0000000000000246 R12: 0000000000000013
R13: 0000000000000001 R14: 00007f66c179a520 R15: 0000000000000013
 </TASK>
Allocated by task 77:
kasan_set_track (/v6.1-rc2/mm/kasan/common.c:51) 
kasan_save_alloc_info (/v6.1-rc2/mm/kasan/generic.c:432 /v6.1-rc2/mm/kasan/generic.c:498) 
__kasan_kmalloc (/v6.1-rc2/mm/kasan/common.c:356) 
__kmalloc (/v6.1-rc2/mm/slab_common.c:943 /v6.1-rc2/mm/slab_common.c:968) 
sk_prot_alloc (/v6.1-rc2/net/core/sock.c:2028) 
sk_alloc (/v6.1-rc2/net/core/sock.c:2083) 
l2cap_sock_alloc (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1903) 
l2cap_sock_new_connection_cb (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1504) 
l2cap_connect (/v6.1-rc2/net/bluetooth/l2cap_core.c:102 /v6.1-rc2/net/bluetooth/l2cap_core.c:4277) 
l2cap_bredr_sig_cmd (/v6.1-rc2/net/bluetooth/l2cap_core.c:5634 /v6.1-rc2/net/bluetooth/l2cap_core.c:5927) 
l2cap_recv_frame (/v6.1-rc2/net/bluetooth/l2cap_core.c:7851 /v6.1-rc2/net/bluetooth/l2cap_core.c:7919) 
l2cap_recv_acldata (/v6.1-rc2/net/bluetooth/l2cap_core.c:8601 /v6.1-rc2/net/bluetooth/l2cap_core.c:8631) 
hci_rx_work (/v6.1-rc2/./include/net/bluetooth/hci_core.h:1121 /v6.1-rc2/net/bluetooth/hci_core.c:3937 /v6.1-rc2/net/bluetooth/hci_core.c:4189) 
process_one_work (/v6.1-rc2/kernel/workqueue.c:2225) 
worker_thread (/v6.1-rc2/kernel/workqueue.c:816 /v6.1-rc2/kernel/workqueue.c:2107 /v6.1-rc2/kernel/workqueue.c:2159 /v6.1-rc2/kernel/workqueue.c:2408) 
kthread (/v6.1-rc2/kernel/kthread.c:361) 
ret_from_fork (/v6.1-rc2/arch/x86/entry/entry_64.S:306) 
Freed by task 52:
kasan_set_track (/v6.1-rc2/mm/kasan/common.c:51) 
kasan_save_free_info (/v6.1-rc2/mm/kasan/generic.c:508) 
____kasan_slab_free (/v6.1-rc2/./include/linux/slub_def.h:164 /v6.1-rc2/mm/kasan/common.c:214) 
__kasan_slab_free (/v6.1-rc2/mm/kasan/common.c:244) 
slab_free_freelist_hook (/v6.1-rc2/mm/slub.c:381 /v6.1-rc2/mm/slub.c:1747) 
__kmem_cache_free (/v6.1-rc2/mm/slub.c:3656 /v6.1-rc2/mm/slub.c:3674) 
kfree (/v6.1-rc2/mm/slab_common.c:1007) 
__sk_destruct (/v6.1-rc2/./include/linux/cred.h:288 /v6.1-rc2/net/core/sock.c:2147) 
__sk_free (/v6.1-rc2/./include/linux/sock_diag.h:87 /v6.1-rc2/net/core/sock.c:2175) 
sk_free (/v6.1-rc2/./include/linux/instrumented.h:? /v6.1-rc2/./include/linux/atomic/atomic-instrumented.h:176 /v6.1-rc2/./include/linux/refcount.h:272 /v6.1-rc2/./include/linux/refcount.h:315 /v6.1-rc2/./include/linux/refcount.h:333 /v6.1-rc2/net/core/sock.c:2188) 
l2cap_sock_kill (/v6.1-rc2/./include/net/bluetooth/bluetooth.h:286 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1284) 
l2cap_sock_close_cb (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1576) 
l2cap_chan_timeout (/v6.1-rc2/./include/net/bluetooth/bluetooth.h:296 /v6.1-rc2/net/bluetooth/l2cap_core.c:462) 
process_one_work (/v6.1-rc2/kernel/workqueue.c:2225) 
worker_thread (/v6.1-rc2/kernel/workqueue.c:816 /v6.1-rc2/kernel/workqueue.c:2107 /v6.1-rc2/kernel/workqueue.c:2159 /v6.1-rc2/kernel/workqueue.c:2408) 
kthread (/v6.1-rc2/kernel/kthread.c:361) 
ret_from_fork (/v6.1-rc2/arch/x86/entry/entry_64.S:306) 
The buggy address belongs to the object at ffff88800f7f4000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 96 bytes inside of
 1024-byte region [ffff88800f7f4000, ffff88800f7f4400)
The buggy address belongs to the physical page:
page:00000000b8d65c1d refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88800f7f6800 pfn:0xf7f4
head:00000000b8d65c1d order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0010200 ffffea0000993408 ffffea0000991308 ffff888005841dc0
raw: ffff88800f7f6800 0000000000080002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88800f7f3f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88800f7f3f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88800f7f4000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff88800f7f4080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800f7f4100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

> >
> > Context 2:
> > l2cap_chan_timeout();
> >   l2cap_chan_lock(chan);
> >   chan->ops->close(chan);
> >     l2cap_sock_close_cb()
> >     l2cap_sock_kill(sk); // <-- sk is freed here
> >   l2cap_chan_unlock(chan);
> >
>
> Please add a Fixes: tag

Fixes: 6c08fc896b60 ("Bluetooth: Fix refcount use-after-free issue")
> > Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> > ---
> >  net/bluetooth/l2cap_sock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> > index ca8f07f35..657704059 100644
> > --- a/net/bluetooth/l2cap_sock.c
> > +++ b/net/bluetooth/l2cap_sock.c
> > @@ -1245,7 +1245,7 @@ static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
> >   */
> >  static void l2cap_sock_kill(struct sock *sk)
> >  {
> > -       if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> > +       if (!sk || !sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> >                 return;
> >
> >         BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
> > --
> > 2.25.1
> >
