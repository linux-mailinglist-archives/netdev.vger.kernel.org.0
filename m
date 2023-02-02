Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24228687D65
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBBMgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBBMgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:36:13 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C8E7374D
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:36:10 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id b1so1934862ybn.11
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 04:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1H8wFBOyPkjGl14ZZGifIpI9n23/NSkoyGUNWz/xoCY=;
        b=MNLy31iC/RKvsSK9GZsB186SPDmdAnN6ZwbOkN0qCYzXppcsf2ef2v1e+JrB01pUae
         sIG7jMW0R9rQMd1Qoq06n9tsyJ0XnF2IdOYiISLXSpiC1+v1az9PIn/nfwz5RQPoqhxF
         2YvQ9ZLvMK98LWoNjDEvuzpBqTmx9JwyMHxzd3TcGrTm4zrO4s8duA+VoHhKl1K/3gg9
         KGH5BnjMtI1JwYrmrSEs/Omvjz+lZHs8bSoNy8OGNrWCvPN45IkN2L3Hu2ZaSh+66Iad
         DpWMC4UWWGELS5y28tBiu1tP1W+mw8Z2xy9lUD9jz0lizh2eGAdqu+c4wEyJksHYTCIK
         PWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1H8wFBOyPkjGl14ZZGifIpI9n23/NSkoyGUNWz/xoCY=;
        b=hc7my+pvU8jMTkbluYGUu/B4FjbOeta6rLBNrMHx3YMdrvNc4kQFFyiIZT2XRztwC9
         aMwG4iZmq39T5eBoejFHC2Qua+D9r99WLikf0ACYhM/EVexVeLfDLoFgoA2Ofyi4gSsZ
         6RKTDTBjVo/GonPcwMYI2qNmHrD6NvOh6ee6zzDUs47ODeyXHBd3SoUxyaSdK1Ebwtqf
         6mWIYDIMKQrP91EOGr0R5dVKlTPNjDDsLMFUKeht0fj9JI23A7cnIYI93ykF1zXehz/s
         7gqD0c7LGH72NWL2wOAN5JpiqBqwG6bCi9hRgMTEOhxDYRuHsX8wH6cXcQftfnHjJlr8
         E3Ng==
X-Gm-Message-State: AO0yUKUyeeKi43VQOFZtC8Lzx9cJ+34b0jVcKS+VgxQnkowueh5+/Cu9
        4pU+C8LdQx4XKi03kldMHYQ9Dt0/499qmom7lBR68Q==
X-Google-Smtp-Source: AK7set96i5msEO6+Tf/ghTVEhAq48i95AHAjRKXlmu837XwqQ+AG3Nrx+hQbKqODLSNsVVpTgak6Y9WsCIEm/1kRUl4=
X-Received: by 2002:a25:8711:0:b0:80b:5c18:a17 with SMTP id
 a17-20020a258711000000b0080b5c180a17mr735338ybl.394.1675341369046; Thu, 02
 Feb 2023 04:36:09 -0800 (PST)
MIME-Version: 1.0
References: <CANn89i+hAht=g1F6kjPfq8eO4j6-2WEE+CNtRtq1S4UnwXEQaw@mail.gmail.com>
 <20230202120902.2827191-1-iam@sung-woo.kim>
In-Reply-To: <20230202120902.2827191-1-iam@sung-woo.kim>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Feb 2023 13:35:57 +0100
Message-ID: <CANn89i+CiUvz-7PmQUAs3Lq7ZEcbonmkyUOegxGDN7N0VX5Xdg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix use-after-free
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
        happiness.sung.woo@gmail.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        wuruoyu@me.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 1:09 PM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> On Thu, Feb 2, 2023 at 4:26 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Feb 2, 2023 at 10:07 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
> > >
> > > Due to the race condition between l2cap_sock_cleanup_listen and
> > > l2cap_sock_close_cb, l2cap_sock_kill can receive already freed sk,
> > > resulting in use-after-free inside l2cap_sock_kill.
> > > This patch prevent this by adding a null check in l2cap_sock_kill.
> > >
> > > Context 1:
> > > l2cap_sock_cleanup_listen();
> > >   // context switched
> > >   l2cap_chan_lock(chan);
> > >   l2cap_sock_kill(sk); // <-- sk is already freed below
> >
> > But sk is used in l2cap_sock_cleanup_listen()
> > and should not be NULL...
> >
> > while ((sk =3D bt_accept_dequeue(parent, NULL))) {
> >   ...
> >   l2cap_sock_kill(sk);
> >   ..
> > }
> >
> > It would help if you send us a stack trace ...
>
> Here is the stack trace and l2cap_sock.c:
> https://gist.github.com/swkim101/5c3b8cb7c7d7172aef23810c9412f323
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in l2cap_sock_kill (/v6.1-rc2/./include/net/so=
ck.h:986 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1281)
> Read of size 8 at addr ffff88800f7f4060 by task l2cap-server/1764
> CPU: 0 PID: 1764 Comm: l2cap-server Not tainted 6.1.0-rc2 #129
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubunt=
u1.1 04/01/2014
> Call Trace:
>  <TASK>
> dump_stack_lvl (/v6.1-rc2/lib/dump_stack.c:105)
> print_address_description+0x7e/0x360
> print_report (/v6.1-rc2/mm/kasan/report.c:187 /v6.1-rc2/mm/kasan/report.c=
:389)
> ? __virt_addr_valid (/v6.1-rc2/./include/linux/mmzone.h:1855 /v6.1-rc2/ar=
ch/x86/mm/physaddr.c:65)
> ? kasan_complete_mode_report_info (/v6.1-rc2/mm/kasan/report_generic.c:10=
4 /v6.1-rc2/mm/kasan/report_generic.c:127 /v6.1-rc2/mm/kasan/report_generic=
.c:136)
> ? l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluet=
ooth/l2cap_sock.c:1281)
> kasan_report (/v6.1-rc2/mm/kasan/report.c:? /v6.1-rc2/mm/kasan/report.c:4=
84)
> ? l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluet=
ooth/l2cap_sock.c:1281)
> kasan_check_range (/v6.1-rc2/mm/kasan/generic.c:85 /v6.1-rc2/mm/kasan/gen=
eric.c:115 /v6.1-rc2/mm/kasan/generic.c:128 /v6.1-rc2/mm/kasan/generic.c:15=
9 /v6.1-rc2/mm/kasan/generic.c:180 /v6.1-rc2/mm/kasan/generic.c:189)
> __kasan_check_read (/v6.1-rc2/mm/kasan/shadow.c:31)
> l2cap_sock_kill (/v6.1-rc2/./include/net/sock.h:986 /v6.1-rc2/net/bluetoo=
th/l2cap_sock.c:1281)
> l2cap_sock_teardown_cb (/v6.1-rc2/./include/net/bluetooth/bluetooth.h:304=
 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1475 /v6.1-rc2/net/bluetooth/l2cap_so=
ck.c:1612)
> l2cap_chan_close (/v6.1-rc2/net/bluetooth/l2cap_core.c:885)
> ? __kasan_check_write (/v6.1-rc2/mm/kasan/shadow.c:37)
> l2cap_sock_shutdown (/v6.1-rc2/./include/linux/kcsan-checks.h:231 /v6.1-r=
c2/./include/net/sock.h:2470 /v6.1-rc2/net/bluetooth/l2cap_sock.c:1321 /v6.=
1-rc2/net/bluetooth/l2cap_sock.c:1377)
> ? _raw_write_unlock (/v6.1-rc2/./include/asm-generic/qrwlock.h:122 /v6.1-=
rc2/./include/linux/rwlock_api_smp.h:225 /v6.1-rc2/kernel/locking/spinlock.=
c:342)
> l2cap_sock_release (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1453)
> sock_close (/v6.1-rc2/net/socket.c:1382)
> ? sock_mmap (/v6.1-rc2/net/socket.c:?)
> __fput (/v6.1-rc2/./include/linux/fsnotify.h:? /v6.1-rc2/./include/linux/=
fsnotify.h:99 /v6.1-rc2/./include/linux/fsnotify.h:341 /v6.1-rc2/fs/file_ta=
ble.c:306)
> ____fput (/v6.1-rc2/fs/file_table.c:348)
> task_work_run (/v6.1-rc2/kernel/task_work.c:165)
> do_exit (/v6.1-rc2/kernel/exit.c:?)
> do_group_exit (/v6.1-rc2/kernel/exit.c:943)

OK, now compare this trace with what you put in your changelog...

Very different problem.

Context 1:
l2cap_sock_cleanup_listen();
  // context switched
  l2cap_chan_lock(chan);
  l2cap_sock_kill(sk); // <-- sk is already freed below


On current linux tree, all l2cap_sock_kill() callers already checked sk !=
=3D NULL

Do you have a repro ?

> ? __kasan_check_write (/v6.1-rc2/mm/kasan/shadow.c:37)
> get_signal (/v6.1-rc2/kernel/signal.c:2863)
> ? _raw_spin_unlock (/v6.1-rc2/./include/linux/spinlock_api_smp.h:142 /v6.=
1-rc2/kernel/locking/spinlock.c:186)
> ? finish_task_switch (/v6.1-rc2/./arch/x86/include/asm/current.h:15 /v6.1=
-rc2/kernel/sched/core.c:5065)
> arch_do_signal_or_restart (/v6.1-rc2/arch/x86/kernel/signal.c:869)
> exit_to_user_mode_prepare (/v6.1-rc2/kernel/entry/common.c:383)
> syscall_exit_to_user_mode (/v6.1-rc2/./arch/x86/include/asm/current.h:15 =
/v6.1-rc2/kernel/entry/common.c:261 /v6.1-rc2/kernel/entry/common.c:283 /v6=
.1-rc2/kernel/entry/common.c:296)
> do_syscall_64 (/v6.1-rc2/arch/x86/entry/common.c:50 /v6.1-rc2/arch/x86/en=
try/common.c:80)
> ? sysvec_apic_timer_interrupt (/v6.1-rc2/arch/x86/kernel/apic/apic.c:1107=
)
> entry_SYSCALL_64_after_hwframe (/v6.1-rc2/arch/x86/entry/entry_64.S:120)
> RIP: 0033:0x7f66c14db970
> Code: Unable to access opcode bytes at 0x7f66c14db946.
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> RSP: 002b:00007ffe166a5508 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: 0000000000000013 RBX: 0000000000000013 RCX: 00007f66c14db970
> RDX: 0000000000000013 RSI: 00007ffe166a56d0 RDI: 0000000000000002
> RBP: 00007ffe166a56d0 R08: 00007f66c1a28440 R09: 0000000000000013
> R10: 0000000000000078 R11: 0000000000000246 R12: 0000000000000013
> R13: 0000000000000001 R14: 00007f66c179a520 R15: 0000000000000013
>  </TASK>
> Allocated by task 77:
> kasan_set_track (/v6.1-rc2/mm/kasan/common.c:51)
> kasan_save_alloc_info (/v6.1-rc2/mm/kasan/generic.c:432 /v6.1-rc2/mm/kasa=
n/generic.c:498)
> __kasan_kmalloc (/v6.1-rc2/mm/kasan/common.c:356)
> __kmalloc (/v6.1-rc2/mm/slab_common.c:943 /v6.1-rc2/mm/slab_common.c:968)
> sk_prot_alloc (/v6.1-rc2/net/core/sock.c:2028)
> sk_alloc (/v6.1-rc2/net/core/sock.c:2083)
> l2cap_sock_alloc (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1903)
> l2cap_sock_new_connection_cb (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1504)
> l2cap_connect (/v6.1-rc2/net/bluetooth/l2cap_core.c:102 /v6.1-rc2/net/blu=
etooth/l2cap_core.c:4277)
> l2cap_bredr_sig_cmd (/v6.1-rc2/net/bluetooth/l2cap_core.c:5634 /v6.1-rc2/=
net/bluetooth/l2cap_core.c:5927)
> l2cap_recv_frame (/v6.1-rc2/net/bluetooth/l2cap_core.c:7851 /v6.1-rc2/net=
/bluetooth/l2cap_core.c:7919)
> l2cap_recv_acldata (/v6.1-rc2/net/bluetooth/l2cap_core.c:8601 /v6.1-rc2/n=
et/bluetooth/l2cap_core.c:8631)
> hci_rx_work (/v6.1-rc2/./include/net/bluetooth/hci_core.h:1121 /v6.1-rc2/=
net/bluetooth/hci_core.c:3937 /v6.1-rc2/net/bluetooth/hci_core.c:4189)
> process_one_work (/v6.1-rc2/kernel/workqueue.c:2225)
> worker_thread (/v6.1-rc2/kernel/workqueue.c:816 /v6.1-rc2/kernel/workqueu=
e.c:2107 /v6.1-rc2/kernel/workqueue.c:2159 /v6.1-rc2/kernel/workqueue.c:240=
8)
> kthread (/v6.1-rc2/kernel/kthread.c:361)
> ret_from_fork (/v6.1-rc2/arch/x86/entry/entry_64.S:306)
> Freed by task 52:
> kasan_set_track (/v6.1-rc2/mm/kasan/common.c:51)
> kasan_save_free_info (/v6.1-rc2/mm/kasan/generic.c:508)
> ____kasan_slab_free (/v6.1-rc2/./include/linux/slub_def.h:164 /v6.1-rc2/m=
m/kasan/common.c:214)
> __kasan_slab_free (/v6.1-rc2/mm/kasan/common.c:244)
> slab_free_freelist_hook (/v6.1-rc2/mm/slub.c:381 /v6.1-rc2/mm/slub.c:1747=
)
> __kmem_cache_free (/v6.1-rc2/mm/slub.c:3656 /v6.1-rc2/mm/slub.c:3674)
> kfree (/v6.1-rc2/mm/slab_common.c:1007)
> __sk_destruct (/v6.1-rc2/./include/linux/cred.h:288 /v6.1-rc2/net/core/so=
ck.c:2147)
> __sk_free (/v6.1-rc2/./include/linux/sock_diag.h:87 /v6.1-rc2/net/core/so=
ck.c:2175)
> sk_free (/v6.1-rc2/./include/linux/instrumented.h:? /v6.1-rc2/./include/l=
inux/atomic/atomic-instrumented.h:176 /v6.1-rc2/./include/linux/refcount.h:=
272 /v6.1-rc2/./include/linux/refcount.h:315 /v6.1-rc2/./include/linux/refc=
ount.h:333 /v6.1-rc2/net/core/sock.c:2188)
> l2cap_sock_kill (/v6.1-rc2/./include/net/bluetooth/bluetooth.h:286 /v6.1-=
rc2/net/bluetooth/l2cap_sock.c:1284)
> l2cap_sock_close_cb (/v6.1-rc2/net/bluetooth/l2cap_sock.c:1576)
> l2cap_chan_timeout (/v6.1-rc2/./include/net/bluetooth/bluetooth.h:296 /v6=
.1-rc2/net/bluetooth/l2cap_core.c:462)
> process_one_work (/v6.1-rc2/kernel/workqueue.c:2225)
> worker_thread (/v6.1-rc2/kernel/workqueue.c:816 /v6.1-rc2/kernel/workqueu=
e.c:2107 /v6.1-rc2/kernel/workqueue.c:2159 /v6.1-rc2/kernel/workqueue.c:240=
8)
> kthread (/v6.1-rc2/kernel/kthread.c:361)
> ret_from_fork (/v6.1-rc2/arch/x86/entry/entry_64.S:306)
> The buggy address belongs to the object at ffff88800f7f4000
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 96 bytes inside of
>  1024-byte region [ffff88800f7f4000, ffff88800f7f4400)
> The buggy address belongs to the physical page:
> page:00000000b8d65c1d refcount:1 mapcount:0 mapping:0000000000000000 inde=
x:0xffff88800f7f6800 pfn:0xf7f4
> head:00000000b8d65c1d order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfffffc0010200(slab|head|node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> raw: 000fffffc0010200 ffffea0000993408 ffffea0000991308 ffff888005841dc0
> raw: ffff88800f7f6800 0000000000080002 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> Memory state around the buggy address:
>  ffff88800f7f3f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff88800f7f3f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >ffff88800f7f4000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                        ^
>  ffff88800f7f4080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88800f7f4100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> > >
> > > Context 2:
> > > l2cap_chan_timeout();
> > >   l2cap_chan_lock(chan);
> > >   chan->ops->close(chan);
> > >     l2cap_sock_close_cb()
> > >     l2cap_sock_kill(sk); // <-- sk is freed here
> > >   l2cap_chan_unlock(chan);
> > >
> >
> > Please add a Fixes: tag
>
> Fixes: 6c08fc896b60 ("Bluetooth: Fix refcount use-after-free issue")
> > > Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> > > ---
> > >  net/bluetooth/l2cap_sock.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> > > index ca8f07f35..657704059 100644
> > > --- a/net/bluetooth/l2cap_sock.c
> > > +++ b/net/bluetooth/l2cap_sock.c
> > > @@ -1245,7 +1245,7 @@ static int l2cap_sock_recvmsg(struct socket *so=
ck, struct msghdr *msg,
> > >   */
> > >  static void l2cap_sock_kill(struct sock *sk)
> > >  {
> > > -       if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> > > +       if (!sk || !sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> > >                 return;
> > >
> > >         BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
> > > --
> > > 2.25.1
> > >
