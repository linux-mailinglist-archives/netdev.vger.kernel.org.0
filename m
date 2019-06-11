Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912233CA47
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404048AbfFKLp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:45:27 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51765 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403954AbfFKLp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:45:27 -0400
Received: by mail-it1-f195.google.com with SMTP id m3so4355670itl.1
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 04:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wtx59jhbf6f3PParuzwX0jMyTRPfZt7rhdcctnJQVu0=;
        b=mwobKIBRt+7kEGGrvs7/vECMrSHEs9l66LVpcdHR7/ZvwP/FUhl1aix+4RMF0Dh2w2
         f+UkYukotIRg/jsigtQijpdeVyIRO0I4+z8jZyhJ9uAsaWbf8RoYSZ1154J80q0Q20Mz
         SxDcb9lUHEewsdZ4rcYkTqw7aL7PY8TgWddboKryD+61/xbiBFO68Tlt7AK4VkgIiKh/
         RutGl2/AS36PUvLZR4fRUQpi12zNCcxb2XoyR56mXWpAu5BY2lTA05RoTeKO78XRlkhv
         M065fQvMDnJYfOL/jMe7x+GoNU7c4BD3m1aeCz7CLbQZBjUK8KHcN6fR/GZEhmzAFtRv
         qIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wtx59jhbf6f3PParuzwX0jMyTRPfZt7rhdcctnJQVu0=;
        b=MAOEtbEMzyAMA+pkGIYaQhKHCryJKwunhqXug8QZKfmXCMt5W5uNYG5kTDCUUYv4dO
         /BWQ+IEYbYsZywW/KAsaF5z/hKDXRg0720u1frZWc4GabsLRQt1Sw2lpBQxcJc+7Xv3d
         Hra+HSTo7iSy+OfmEVKA2jdoX9mieZY8wY2OQP/Kbkqhnqv2jeOXfA540UTajkk+OtPs
         /1iEesCirwajujabtioHsS0A0c0J+jYTdRGqmgc9nJ+cqNH+OBR0HH6UKc5y0hhH8n91
         JR35nOKjbm6g05F3Q5JYtoHnHZF9R9Xc41MR3p9oWaoExiGbq0y5Fl3raW0H/2ebMuzY
         Gymg==
X-Gm-Message-State: APjAAAWu96gjA3XrhowiWzZtITl7hdGFsc1gYy6ssLfvuHWE0sfkCB4Z
        1VDaE9KjCeMt1RYW/XnCG1JyzQE3iooPgALf8/qVVV6Dj+IrzQ==
X-Google-Smtp-Source: APXvYqwLCoLh5N1xRMQ0Ctqi54//m7SWp10d7WRGKNvycxd/43NKPV3R+18dolISI/KB7hxGBjJk4QJ+y5BoS2rcR1M=
X-Received: by 2002:a24:9083:: with SMTP id x125mr18100079itd.76.1560253523365;
 Tue, 11 Jun 2019 04:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190609025641.11448-1-hdanton@sina.com>
In-Reply-To: <20190609025641.11448-1-hdanton@sina.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 11 Jun 2019 13:45:11 +0200
Message-ID: <CACT4Y+YX4biKo1nEKh32pJoS9ANNV06hQp5=+w+3GpWQB1worg@mail.gmail.com>
Subject: Re: memory leak in create_ctx
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com,
        Daniel Borkmann <daniel@iogearbox.net>, davejwatson@fb.com,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

,On Sun, Jun 9, 2019 at 4:56 AM Hillf Danton <hdanton@sina.com> wrote:
>
>
> Hi
>
> On Sat, 08 Jun 2019 12:13:06 -0700 (PDT) syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=170e0bfea00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d5c73825cbdc7326
> > dashboard link: https://syzkaller.appspot.com/bug?extid=06537213db7ba2745c4a
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10aa806aa00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com
> >
> > IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
> > 2019/06/08 14:55:51 executed programs: 15
> > 2019/06/08 14:55:56 executed programs: 31
> > 2019/06/08 14:56:02 executed programs: 51
> > BUG: memory leak
> > unreferenced object 0xffff888117ceae00 (size 512):
> >    comm "syz-executor.3", pid 7233, jiffies 4294949016 (age 13.640s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000e6550967>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
> >      [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
> >      [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
> >      [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
> >      [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
> >      [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
> >      [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
> >      [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
> >      [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
> >      [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60 net/ipv4/tcp.c:2784
> >      [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
> >      [<00000000c840962c>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3124
> >      [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
> >      [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
> >      [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
> >      [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
> >      [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
> >      [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810965dc00 (size 512):
> >    comm "syz-executor.2", pid 7235, jiffies 4294949016 (age 13.640s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000e6550967>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
> >      [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
> >      [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
> >      [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
> >      [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
> >      [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
> >      [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
> >      [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
> >      [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
> >      [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60 net/ipv4/tcp.c:2784
> >      [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
> >      [<00000000c840962c>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3124
> >      [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
> >      [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
> >      [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
> >      [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
> >      [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
> >      [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881207d7600 (size 512):
> >    comm "syz-executor.5", pid 7244, jiffies 4294949019 (age 13.610s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000e6550967>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
> >      [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
> >      [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
> >      [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
> >      [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
> >      [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
> >      [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
> >      [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
> >      [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
> >      [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60 net/ipv4/tcp.c:2784
> >      [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
> >      [<00000000c840962c>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3124
> >      [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
> >      [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
> >      [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
> >      [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
> >      [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0 ntry/common.c:301
> >      [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> >
> Ignore my noise if you have no interest seeing the syzbot report.
>
> The following tiny diff, made in the hope that it may help you perhaps
> handle the report, adds memory barriers before and after allocating ctx
> slab to check the current ctx, and returns it if valid.

Hi Hillf,

Do you see the bug? Jakub said he can't repro.
The repro has these suspicious bpf syscalls and there is currently
some nasty bpf bug that plagues us and leads to random assorted
splats.
I've run the repro as "./syz-execprog -repeat=0 -procs=6 repro"  and
in 10 mins I got the following splat, which indeed suggests a bpf bug.
But we of course can have both bpf stack overflow and a memory leak in tls.



2019/06/11 10:26:52 executed programs: 887
2019/06/11 10:26:57 executed programs: 899
2019/06/11 10:27:02 executed programs: 916
[  429.171049][ T9870] BUG: stack guard page was hit at
00000000a78467b9 (stack is 000000001452e9df..000000004fb93e51)
[  429.173714][ T9870] kernel stack overflow (double-fault): 0000 [#1]
PREEMPT SMP
[  429.174819][ T9870] CPU: 3 PID: 9870 Comm: syz-executor Not tainted
5.2.0-rc4+ #6
[  429.175901][ T9870] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.10.2-1 04/01/2014
[  429.177215][ T9870] RIP: 0010:tcp_bpf_unhash+0xc/0x80
[  429.177950][ T9870] Code: 28 4c 89 ee 48 89 df ff 10 e8 30 56 66 fe
5b 41 5c 41 5d 41 5e 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41
54 53 48 89 fb <e8> 0f 56 66 fe e8 6a bb 5f fe 4c 8b a3 80 02 00 00 4d
85 e4 74 2f
[  429.180707][ T9870] RSP: 0018:ffffc90003690000 EFLAGS: 00010293
[  429.181562][ T9870] RAX: ffff888066a72000 RBX: ffff88806695b640
RCX: ffffffff82c82f80
[  429.182681][ T9870] RDX: 0000000000000000 RSI: 0000000000000007
RDI: ffff88806695b640
[  429.183807][ T9870] RBP: ffffc90003690018 R08: 0000000000000000
R09: 0000000000000000
[  429.184931][ T9870] R10: ffffc90003693e70 R11: 0000000000000000
R12: ffffffff82c82f10
[  429.186104][ T9870] R13: 0000000000000007 R14: ffff88806695b710
R15: ffff88806695b710
[  429.187303][ T9870] FS:  00005555569fc940(0000)
GS:ffff88807db80000(0000) knlGS:0000000000000000
[  429.188678][ T9870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  429.189674][ T9870] CR2: ffffc9000368fff8 CR3: 00000000762bc002
CR4: 00000000007606e0
[  429.190880][ T9870] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[  429.192094][ T9870] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[  429.193295][ T9870] PKRU: 55555554
[  429.193829][ T9870] Call Trace:
[  429.194326][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.195020][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.195706][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.196400][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.197079][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.197773][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.198454][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.199148][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.199833][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.200527][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.201208][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.201909][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.202590][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.203283][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.203973][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.204667][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.205347][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.206041][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.206721][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.207418][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.208100][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.208794][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.209474][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.210167][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.210846][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.211548][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.212228][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.212920][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.213600][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.214292][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.214973][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.215671][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.216353][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.217045][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.217728][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.218421][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.219101][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.219802][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.220483][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.221177][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.221857][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.222569][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.223253][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.223952][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.224636][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.225331][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.226013][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.226712][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.227395][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.228100][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.228783][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.229478][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.230161][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.230855][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.231539][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.232240][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.232921][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.233616][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.234315][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.235013][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.235702][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.236399][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.237083][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.237783][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.238467][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.239165][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.239855][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.240556][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.241241][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.241938][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.242622][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.243320][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.244008][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.244705][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.245388][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.246114][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.246800][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.247503][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.248187][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.248883][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.249569][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.250266][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.250951][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.251658][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.252342][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.253041][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.253726][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.254427][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.255121][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.255822][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.256505][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.257201][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.257890][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.258605][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.259291][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.259994][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.260681][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.261380][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.262067][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.262766][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.263457][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.264157][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.264842][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.265542][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.266200][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.266855][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.267501][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.268175][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.268814][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.269476][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.270142][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.270825][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.271494][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.272167][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.272839][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.273514][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.274179][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.274857][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.275529][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.276220][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.276892][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.277573][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.278247][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.278934][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.279608][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.280293][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.280969][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.281670][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.282360][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.283062][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.283771][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.284477][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.285170][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.285875][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.286565][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.287269][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.287977][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.288681][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.289376][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.290079][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.290769][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.291477][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.292177][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.292886][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.293558][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.294258][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.294930][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.295625][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.296289][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.296984][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.297662][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.298354][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.299036][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.299728][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.300412][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.301106][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.301800][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.302497][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.303179][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.303907][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.304599][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.305307][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.306001][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.306707][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.307414][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.308123][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.308817][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.309524][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.310217][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.310924][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.311631][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.312341][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.313036][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.313745][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.314457][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.315161][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.315860][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.316562][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.317252][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.317962][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.318653][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.319356][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.320049][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.320760][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.321332][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.321916][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.322484][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.323068][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.323643][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.324221][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.324792][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.325375][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.325948][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.326532][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.327104][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.327690][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.328270][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.328854][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.329427][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.330010][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.330583][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.331166][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.331743][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.332325][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.332913][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.333493][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.334063][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.334643][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.335213][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.335794][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.336364][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.336945][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.337515][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.338097][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.338664][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.339244][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.339822][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.340400][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.340970][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.341551][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.342121][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.342716][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.343284][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.343864][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.344436][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.345010][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.345575][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.346154][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.346717][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.347293][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.347873][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.348453][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.349020][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.349596][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.350164][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.350743][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.351306][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.351895][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.352479][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.353056][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.353621][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.354196][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.354761][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.355335][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.355899][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.356481][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.357046][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.357621][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.358184][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.358760][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.359336][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.359924][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.360489][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.361064][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.361627][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.362203][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.362785][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.363358][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.363941][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.364512][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.365075][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.365648][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.366212][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.366786][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.367349][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.367926][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.368488][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.369063][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.369627][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.370201][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.370765][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.371340][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.371937][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.372512][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.373091][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.373661][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.374216][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.374788][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.375352][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.375929][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.376489][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.377060][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.377622][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.378195][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.378755][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.379328][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.379896][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.380468][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.381029][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.381600][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.382161][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.382748][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.383309][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.383884][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.384449][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.385019][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.385580][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.386161][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.386725][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.387300][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.387867][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.388443][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.389006][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.389579][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.390144][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.390720][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.391282][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.391859][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.392419][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.392991][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.393552][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.394126][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.394688][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.395261][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.395827][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.396401][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.396964][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.397536][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.398096][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.398669][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.399230][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.399803][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.400364][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.400935][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.401495][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.402066][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.402629][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.403200][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.403773][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.404351][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.404917][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.405488][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.406056][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.406628][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.407189][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.407766][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.408327][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.408897][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.409458][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.410029][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.410589][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.411160][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.411738][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.412308][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.412869][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.413442][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.414004][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.414576][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.415138][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.415713][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.416275][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.416848][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.417410][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.417988][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.418550][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.419122][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.419689][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.420259][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.420819][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.421390][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.421951][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.422529][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.423090][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.423670][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.424235][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.424807][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.425369][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.425942][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.426504][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.427077][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.427643][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.428218][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.428779][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.429351][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.429911][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.430482][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.431045][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.431621][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.432182][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.432755][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.433316][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.433895][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.434456][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.435028][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.435592][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.436172][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.436733][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.437305][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.437865][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.438437][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.438997][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.439570][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.440133][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.440700][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.441261][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.441832][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.442391][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.442962][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.443525][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.444098][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.444660][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.445232][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.445793][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.446362][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.446922][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.447494][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.448054][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.448624][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.449184][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.449754][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.450314][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.450884][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.451448][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.452023][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.452583][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.453179][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.453744][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.454315][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.454874][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.455447][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.456016][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.456587][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.457146][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.457728][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.458295][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.458867][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.459430][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.460007][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.460568][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.461141][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.461702][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.462273][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.462836][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.463412][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.463976][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.464549][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.465113][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.465694][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.466257][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.466831][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.467394][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.467973][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.468535][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.469108][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.469668][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.470238][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.470800][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.471387][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.471954][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.472525][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.473085][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.473656][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.474217][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.474789][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.475349][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.475932][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.476493][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.477064][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.477625][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.478196][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.478755][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.479327][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.479892][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.480465][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.481025][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.481595][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.482155][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.482726][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.483285][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.483863][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.484424][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.484996][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.485557][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.486128][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.486694][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.487267][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.487839][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.488410][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.488970][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.489539][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.490098][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.490668][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.491227][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.491801][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.492363][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.492934][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.493495][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.494068][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.494628][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.495201][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.495771][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.496340][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.496898][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.497470][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.498028][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.498600][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.499158][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.499734][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.500295][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.500866][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.501427][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.502000][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.502561][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.503134][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.503700][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.504274][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.504836][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.505409][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.505971][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.506544][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.507106][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.507682][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.508242][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.508817][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.509376][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.509953][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.510514][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.511086][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.511651][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.512225][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.512787][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.513359][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.513919][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.514491][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.515050][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.515623][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.516184][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.516757][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.517318][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.517889][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.518449][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.519020][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.519590][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.520162][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.520733][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.521305][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.521865][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.522436][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.523000][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.523572][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.524139][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.524710][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.525267][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.525836][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.526394][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.526962][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.527542][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.528115][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.528674][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.529247][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.529814][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.530382][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.530945][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.531517][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.532082][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.532657][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.533220][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.533795][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.534351][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.534921][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.535483][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.536056][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.536614][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.537184][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.537743][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.538313][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.538872][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.539455][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.540018][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.540593][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.541156][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.541726][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.542284][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.542854][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.543416][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.543987][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.544548][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.545119][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.545680][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.546251][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.546812][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.547384][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.547952][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.548521][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.549080][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.549649][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.550209][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.550778][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.551337][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.551913][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.552473][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.553045][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.553606][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.554177][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.554737][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.555309][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.555873][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.556453][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.557013][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.557586][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.558145][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.558715][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.559285][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.559862][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.560420][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.560991][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.561550][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.562120][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.562679][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.563250][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.563814][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.564382][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.564940][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.565510][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.566068][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.566638][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.567197][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.567770][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.568329][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.568898][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.569457][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.570027][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.570586][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.571155][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.571717][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.572286][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.572848][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.573420][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.573982][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.574553][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.575115][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.575689][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.576248][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.576817][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.577376][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.577944][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.578501][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.579069][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.579630][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.580198][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.580757][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.581327][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.581894][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.582466][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.583027][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.583601][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.584163][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.584735][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.585295][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.585867][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.586427][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.586999][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.587562][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.588131][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.588690][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.589259][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.589818][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.590393][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.590954][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.591529][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.592089][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.592660][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.593217][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.593785][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.594344][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.594911][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.595471][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.596038][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.596596][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.597164][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.597723][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.598293][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.598853][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.599426][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.599984][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.600553][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.601110][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.601679][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.602235][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.602804][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.603361][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.603934][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.604493][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.605062][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.605619][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.606190][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.606754][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.607326][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.607887][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.608458][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.609017][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.609588][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.610147][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.610717][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.611277][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.611849][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.612407][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.612974][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.613532][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.614100][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.614657][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.615225][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.615785][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.616355][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.616914][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.617485][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.618044][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.618614][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.619173][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.619745][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.620303][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.620873][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.621432][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.622002][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.622562][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.623133][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.623695][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.624270][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.624829][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.625400][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.625959][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.626532][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.627094][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.627667][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.628225][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.628795][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.629354][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.629923][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.630481][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.631052][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.631615][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.632184][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.632742][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.633311][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.633866][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.634434][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.634992][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.635564][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.636121][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.636690][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.637250][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.637820][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.638380][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.638950][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.639513][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.640079][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.640637][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.641205][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.641763][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.642331][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.642888][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.643459][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.644027][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.644598][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.645160][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.645730][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.646288][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.646858][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.647420][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.647991][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.648550][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.649120][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.649679][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.650251][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.650812][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.651382][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.651942][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.652512][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.653071][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.653642][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.654201][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.654772][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.655331][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.655907][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.656467][ T9870]  ? tcp_bpf_close+0xa0/0xa0
[  429.657037][ T9870]  tcp_bpf_unhash+0x76/0x80
[  429.657600][ T9870]  tcp_set_state+0x7b/0x220
[  429.658160][ T9870]  ? put_object+0x20/0x30
[  429.658699][ T9870]  ? debug_smp_processor_id+0x2b/0x130
[  429.659382][ T9870]  tcp_disconnect+0x518/0x610
[  429.659973][ T9870]  tcp_close+0x41d/0x540
[  429.660501][ T9870]  ? tcp_check_oom+0x180/0x180
[  429.661095][ T9870]  tls_sk_proto_close+0x86/0x2a0
[  429.661711][ T9870]  ? locks_remove_posix+0x114/0x1c0
[  429.662359][ T9870]  inet_release+0x44/0x80
[  429.662899][ T9870]  inet6_release+0x36/0x50
[  429.663453][ T9870]  __sock_release+0x4b/0x100
[  429.664024][ T9870]  ? __sock_release+0x100/0x100
[  429.664625][ T9870]  sock_close+0x19/0x20
[  429.665141][ T9870]  __fput+0xe7/0x2f0
[  429.665624][ T9870]  ____fput+0x15/0x20
[  429.666120][ T9870]  task_work_run+0xa4/0xd0
[  429.666671][ T9870]  exit_to_usermode_loop+0x16f/0x180
[  429.667329][ T9870]  do_syscall_64+0x187/0x1b0
[  429.667920][ T9870]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  429.668654][ T9870] RIP: 0033:0x412451
[  429.669141][ T9870] Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff
ff 0f 83 94 1a 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03
00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4
08 48 3d 01
[  429.671586][ T9870] RSP: 002b:00007ffde18b5470 EFLAGS: 00000293
ORIG_RAX: 0000000000000003
[  429.672636][ T9870] RAX: 0000000000000000 RBX: 0000000000000005
RCX: 0000000000412451
[  429.673628][ T9870] RDX: 0000000000000000 RSI: 0000000000000081
RDI: 0000000000000004
[  429.674643][ T9870] RBP: 0000000000000000 R08: 0000000000721170
R09: 0000000000000000
[  429.675641][ T9870] R10: 00007ffde18b5580 R11: 0000000000000293
R12: 0000000000000000
[  429.676636][ T9870] R13: 000000000071bf00 R14: 00000000006e3140
R15: ffffffffffffffff
[  429.677630][ T9870] Modules linked in:
[  429.678119][ T9870] ---[ end trace a429c7ce256ca7bb ]---
[  429.678798][ T9870] RIP: 0010:tcp_bpf_unhash+0xc/0x80
[  429.679447][ T9870] Code: 28 4c 89 ee 48 89 df ff 10 e8 30 56 66 fe
5b 41 5c 41 5d 41 5e 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41
54 53 48 89 fb <e8> 0f 56 66 fe e8 6a bb 5f fe 4c 8b a3 80 02 00 00 4d
85 e4 74 2f
[  429.681882][ T9870] RSP: 0018:ffffc90003690000 EFLAGS: 00010293
[  429.682637][ T9870] RAX: ffff888066a72000 RBX: ffff88806695b640
RCX: ffffffff82c82f80
[  429.683630][ T9870] RDX: 0000000000000000 RSI: 0000000000000007
RDI: ffff88806695b640
[  429.684622][ T9870] RBP: ffffc90003690018 R08: 0000000000000000
R09: 0000000000000000
[  429.685611][ T9870] R10: ffffc90003693e70 R11: 0000000000000000
R12: ffffffff82c82f10
[  429.686601][ T9870] R13: 0000000000000007 R14: ffff88806695b710
R15: ffff88806695b710
[  429.687592][ T9870] FS:  00005555569fc940(0000)
GS:ffff88807db80000(0000) knlGS:0000000000000000
[  429.688701][ T9870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  429.689519][ T9870] CR2: ffffc9000368fff8 CR3: 00000000762bc002
CR4: 00000000007606e0
[  429.690511][ T9870] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[  429.691507][ T9870] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[  429.692502][ T9870] PKRU: 55555554
[  429.692941][ T9870] Kernel panic - not syncing: Fatal exception
[  429.694377][ T9870] Kernel Offset: disabled
[  429.694913][ T9870] Rebooting in 86400 seconds..




>
> Thanks
> Hillf
> ---
>  net/tls/tls_main.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 78cb4a5..2d0089d 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -39,6 +39,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/sched/signal.h>
>  #include <linux/inetdevice.h>
> +#include <linux/atomic.h>
>
>  #include <net/tls.h>
>
> @@ -539,12 +540,19 @@ static struct tls_context *create_ctx(struct sock *sk)
>  {
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tls_context *ctx;
> -
> +       struct tls_context *cur = xchg(&icsk->icsk_ulp_data,
> +                                       icsk->icsk_ulp_data);
> +       if (cur)
> +               return cur;
>         ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
>         if (!ctx)
>                 return NULL;
>
> -       icsk->icsk_ulp_data = ctx;
> +       cur = cmpxchg(&icsk->icsk_ulp_data, cur, ctx);
> +       if (cur) {
> +               kfree(ctx);
> +               return cur;
> +       }
>         ctx->setsockopt = sk->sk_prot->setsockopt;
>         ctx->getsockopt = sk->sk_prot->getsockopt;
>         ctx->sk_proto_close = sk->sk_prot->close;
