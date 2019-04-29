Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADACE585
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfD2OzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:55:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46814 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfD2OzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:55:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id i31so3471357qti.13
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 07:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q4tvDiqXFhUECaDKqyyUVAfu31JLjymUmw+eN7Kn5pQ=;
        b=EDQameFQ7EtXkHsVO0IZlYThouPBvlJEqjShDt1bmrg2JY7CsZ3gHoa3Y18oZinB27
         sYNymENSn6iN5g28P8mrR47zjPR8hWbnNme8rQa5F/aV2dA1xF6/pBZrQAG1X8oiDacw
         mjygjys/zRqm+h9GyjnsZDlyHGkflxaLPPb4Z/bZQkPZkX3Fa9KtX1a354O9xp1pPUlR
         5FLPmYU9GvlHWNITS0KFYZOmnpy8XetzjBd6E90Y9qZC5A0JGcZn2Qgyh2QKA+A5PeOp
         RYq5yWc+xSz2mv0L09SUjWJfNjpHu0P2fzb5hNlvA82nlSSdXfnCKftp3lF4zCk0dTaJ
         y09A==
X-Gm-Message-State: APjAAAUC/IaOzXP5I5CFnqQvagkKSDtIiC/WzA4nR1A+STH8XHBWfmEr
        GXtacAn3cZ94vKiotrv0DrGE7w==
X-Google-Smtp-Source: APXvYqy4aXjy+duF4+IhlQRtYwSk5xtrIZkDLu3Ta1PkW5PvER9KGP9QkNkE1Y49i8zmBreCbJJs6g==
X-Received: by 2002:ac8:2dc6:: with SMTP id q6mr25931956qta.7.1556549715474;
        Mon, 29 Apr 2019 07:55:15 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id z38sm20344878qtz.13.2019.04.29.07.55.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 07:55:14 -0700 (PDT)
Date:   Mon, 29 Apr 2019 10:55:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, jasowang@redhat.com, edumazet@google.com,
        brouer@redhat.com, lirongqing@baidu.com, xiyou.wangcong@gmail.com,
        nicolas.dichtel@6wind.com, 3chas3@gmail.com, wangli39@baidu.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
Message-ID: <20190429105422-mutt-send-email-mst@kernel.org>
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428030539.17776-1-yuehaibing@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 11:05:39AM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> KASAN report this:
> 
> BUG: KASAN: use-after-free in tun_net_xmit+0x1670/0x1750 drivers/net/tun.c:1104
> Read of size 8 at addr ffff88836cc26a70 by task swapper/3/0
> 
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.19.32 #6
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xca/0x13e lib/dump_stack.c:113
>  print_address_description+0x79/0x330 mm/kasan/report.c:253
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x18a/0x2d0 mm/kasan/report.c:409
>  tun_net_xmit+0x1670/0x1750 drivers/net/tun.c:1104
>  __netdev_start_xmit include/linux/netdevice.h:4300 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4309 [inline]
>  xmit_one net/core/dev.c:3243 [inline]
>  dev_hard_start_xmit+0x17c/0x780 net/core/dev.c:3259
>  sch_direct_xmit+0x24f/0x8a0 net/sched/sch_generic.c:327
>  qdisc_restart net/sched/sch_generic.c:390 [inline]
>  __qdisc_run+0x45b/0x1590 net/sched/sch_generic.c:398
>  qdisc_run include/net/pkt_sched.h:120 [inline]
>  __dev_xmit_skb net/core/dev.c:3438 [inline]
>  __dev_queue_xmit+0xa6b/0x2500 net/core/dev.c:3797
>  neigh_output include/net/neighbour.h:501 [inline]
>  ip6_finish_output2+0xa36/0x2290 net/ipv6/ip6_output.c:120
>  ip6_finish_output+0x3e7/0xa20 net/ipv6/ip6_output.c:154
>  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
>  ip6_output+0x1e2/0x720 net/ipv6/ip6_output.c:171
>  dst_output include/net/dst.h:444 [inline]
>  NF_HOOK include/linux/netfilter.h:289 [inline]
>  mld_sendpack+0x740/0xf20 net/ipv6/mcast.c:1683
>  mld_send_cr net/ipv6/mcast.c:1979 [inline]
>  mld_ifc_timer_expire+0x3cc/0x7f0 net/ipv6/mcast.c:2478
>  call_timer_fn+0x1ea/0x6a0 kernel/time/timer.c:1326
>  expire_timers kernel/time/timer.c:1363 [inline]
>  __run_timers kernel/time/timer.c:1682 [inline]
>  run_timer_softirq+0x637/0x1070 kernel/time/timer.c:1695
>  __do_softirq+0x26d/0xabd kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:372 [inline]
>  irq_exit+0x209/0x290 kernel/softirq.c:412
>  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
>  smp_apic_timer_interrupt+0xf6/0x480 arch/x86/kernel/apic/apic.c:1056
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:864
>  </IRQ>
> RIP: 0010:native_safe_halt+0x2/0x10 arch/x86/include/asm/irqflags.h:58
> Code: 01 f0 0f 82 bc fd ff ff 48 c7 c7 40 25 b1 83 e8 a1 72 03 ff e9 ab fd ff ff 4c 89 e7 e8 37 f5 a7 fe e9 6a ff ff ff 90 90 fb f4 <c3> 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f4 c3 90 90 90 90 90 90
> RSP: 0018:ffff8883e0f2fd20 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000007 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8883e0f04f1c
> RBP: 0000000000000003 R08: ffffed107c5dc77b R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff848b96e0
> R13: 0000000000000003 R14: 1ffff1107c1e5fae R15: 0000000000000000
>  arch_safe_halt arch/x86/include/asm/paravirt.h:94 [inline]
>  default_idle+0x24/0x2b0 arch/x86/kernel/process.c:561
>  cpuidle_idle_call kernel/sched/idle.c:153 [inline]
>  do_idle+0x2ca/0x420 kernel/sched/idle.c:262
>  cpu_startup_entry+0xcb/0xe0 kernel/sched/idle.c:368
>  start_secondary+0x421/0x570 arch/x86/kernel/smpboot.c:271
>  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243
> 
> Allocated by task 19764:
>  set_track mm/kasan/kasan.c:460 [inline]
>  kasan_kmalloc+0xa0/0xd0 mm/kasan/kasan.c:553
>  __kmalloc+0x11b/0x2d0 mm/slub.c:3750
>  kmalloc include/linux/slab.h:518 [inline]
>  sk_prot_alloc+0xf6/0x290 net/core/sock.c:1469
>  sk_alloc+0x3d/0xc00 net/core/sock.c:1523
>  tun_chr_open+0x80/0x560 drivers/net/tun.c:3204
>  misc_open+0x367/0x4e0 drivers/char/misc.c:141
>  chrdev_open+0x212/0x580 fs/char_dev.c:417
>  do_dentry_open+0x704/0x1050 fs/open.c:777
>  do_last fs/namei.c:3418 [inline]
>  path_openat+0x7ed/0x2ae0 fs/namei.c:3533
>  do_filp_open+0x1aa/0x2b0 fs/namei.c:3564
>  do_sys_open+0x307/0x430 fs/open.c:1069
>  do_syscall_64+0xc8/0x580 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 19764:
>  set_track mm/kasan/kasan.c:460 [inline]
>  __kasan_slab_free+0x12e/0x180 mm/kasan/kasan.c:521
>  slab_free_hook mm/slub.c:1370 [inline]
>  slab_free_freelist_hook mm/slub.c:1397 [inline]
>  slab_free mm/slub.c:2952 [inline]
>  kfree+0xeb/0x2f0 mm/slub.c:3905
>  sk_prot_free net/core/sock.c:1506 [inline]
>  __sk_destruct+0x4e6/0x6a0 net/core/sock.c:1588
>  sk_destruct+0x48/0x70 net/core/sock.c:1596
>  __sk_free+0xa9/0x270 net/core/sock.c:1607
>  sk_free+0x2a/0x30 net/core/sock.c:1618
>  sock_put include/net/sock.h:1696 [inline]
>  __tun_detach+0x464/0xf70 drivers/net/tun.c:735
>  tun_detach drivers/net/tun.c:747 [inline]
>  tun_chr_close+0xd8/0x190 drivers/net/tun.c:3241
>  __fput+0x27f/0x7f0 fs/file_table.c:278
>  task_work_run+0x136/0x1b0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
>  exit_to_usermode_loop+0x1a7/0x1d0 arch/x86/entry/common.c:166
>  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>  do_syscall_64+0x461/0x580 arch/x86/entry/common.c:293
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The buggy address belongs to the object at ffff88836cc26600
>  which belongs to the cache kmalloc-4096 of size 4096
> The buggy address is located 1136 bytes inside of
>  4096-byte region [ffff88836cc26600, ffff88836cc27600)
> The buggy address belongs to the page:
> page:ffffea000db30800 count:1 mapcount:0 mapping:ffff8883e280e600 index:0x0 compound_mapcount: 0
> flags: 0x2fffff80008100(slab|head)
> raw: 002fffff80008100 dead000000000100 dead000000000200 ffff8883e280e600
> raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88836cc26900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88836cc26980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88836cc26a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                              ^
>  ffff88836cc26a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88836cc26b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> If tun driver have multiqueues, user close the last queue by
> tun_detach, then tun->tfiles[index] is not cleared. Then a new
> queue may add to the tun, which using rcu_assign_pointer
> tun->tfiles[index] to the new tfile and increase the numqueues.
> However if there send a packet during this time, which picking the last
> queue, it may uses the old tun->tfiles[index], beacause there no
> RCU grace period.
> 
> 1) tun_chr_close //close the last queue
>     --> __tun_detach  //close the last queue, but tun->tfiles[index] still exist
> 
> 2) tun_chr_open  //attach a new queue
>     --> tun_attach
>       -->rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);
> 	  //there need a RCU grace period
> 
>     -->tun->numqueues++;
> 			
> 3) tun_net_xmit //a new packet is sending, which pick the last queue
>      -->if (txq >= tun->numqueues)
> 	   //above check passed, but tfile still not renew
>      -->if (tfile->socket.sk->sk_filter ...
> 	   //use the old tfile,trigger use-after-free
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: c8d68e6be1c3 ("tuntap: multiqueue support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/tun.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index e9ca1c0..3770aba 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -876,6 +876,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
>  	 */
>  	rcu_assign_pointer(tfile->tun, tun);
>  	rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);
> +	synchronize_net();
>  	tun->numqueues++;
>  	tun_set_real_num_queues(tun);
>  out:

The problem seems real enough, but an extra synchronize_net on tun_attach
might be a problem, slowing guest startup significantly.
Better ideas?

> -- 
> 2.7.0
> 
