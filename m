Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AD53CBEC
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 14:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbfFKMjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 08:39:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43615 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfFKMjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 08:39:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so1042208qtj.10;
        Tue, 11 Jun 2019 05:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XN3fdwJg/1ymduxamw9Yc8WWX44+wT/44w1TY3cVD68=;
        b=h65OoEXcMrUfvAbkzzkLh7tsRVvD3pePyq+VOC7UIwxEIP+hfN1MfmQvNAU1u/W2kC
         XRZn51Hn5v45KuJyRFlOGBBowQrdmLQBBJeW5rP5YOL7ZEIdwub1zkwDlbv+eu4/CxHG
         lVWj25tE3Ddo0zcO2WSPLIKuxSxQXPKzQmghcdkYptxyXo2M+kM6eCv03tlRg5Kjv7kJ
         JGLS+sWkJSoAPt2awwxN7Sn/hhDxqeDkw0jTH7YI2y8umM4FjsAo4gjU1j26J/xNUoZp
         y8zN8K7H92R9tpH5ht+UQekMNhojOvi4lmRXG/G1nVfHU/LlgILjR+DmDgW6W+W2BLxc
         M+vA==
X-Gm-Message-State: APjAAAWEnAWWC36ucRiL/vqL9BQkTLPM2NAE2jADL9sYdwUnbSx8tFaE
        d3iU/Er8OULDzFK7YnC/4Wn2dY/eiw1sW1CsNMQ=
X-Google-Smtp-Source: APXvYqwmSxz91ETm2g0mbXcHkb07TlAw56ssGqW2/FqZR35L2ttg80Er6XbiViGTQYeI9p3/OWxF9OBLbPdYmK1HXHE=
X-Received: by 2002:aed:2bc1:: with SMTP id e59mr43872597qtd.7.1560256757764;
 Tue, 11 Jun 2019 05:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007ce6f5058b0715ea@google.com>
In-Reply-To: <0000000000007ce6f5058b0715ea@google.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 11 Jun 2019 14:39:01 +0200
Message-ID: <CAK8P3a1akOXWgAWXM0g_FYSdWUynBDRR2dAwZt8Xg5RiXhMZag@mail.gmail.com>
Subject: Re: KASAN: null-ptr-deref Read in x25_connect
To:     syzbot <syzbot+777a2aab6ffd397407b5@syzkaller.appspotmail.com>
Cc:     allison@lohutok.net, Andrew Hendry <andrew.hendry@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x25@vger.kernel.org, ms@dev.tdt.de,
        Networking <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 9:18 AM syzbot
<syzbot+777a2aab6ffd397407b5@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    f4cfcfbd net: dsa: sja1105: Fix link speed not working at ..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=16815cd2a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4f721a391cd46ea
> dashboard link: https://syzkaller.appspot.com/bug?extid=777a2aab6ffd397407b5
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+777a2aab6ffd397407b5@syzkaller.appspotmail.com

Not sure why I was on Cc on this (I know nothing about x25), but I had
a brief look and found that this is in the error path of x25_connect,
after "goto out_put_neigh", with x25->neighbour==NULL.

This would indicate that either 'x25' is being freed between the
"if (!x25->neighbour)" check in that function and the
x25_neigh_put(x25->neighbour), or that there are two concurrent
calls to x25_connect, with both failing, so one sets
x25->neighbour=NULL before the other one checks it.

    Arnd

> ==================================================================
> BUG: KASAN: null-ptr-deref in atomic_read
> include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: null-ptr-deref in refcount_sub_and_test_checked+0x87/0x200
> lib/refcount.c:182
> Read of size 4 at addr 00000000000000c8 by task syz-executor.2/16959
>
> CPU: 0 PID: 16959 Comm: syz-executor.2 Not tainted 5.2.0-rc2+ #40
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   __kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
>   kasan_report+0x12/0x20 mm/kasan/common.c:614
>   check_memory_region_inline mm/kasan/generic.c:185 [inline]
>   check_memory_region+0x123/0x190 mm/kasan/generic.c:191
>   kasan_check_read+0x11/0x20 mm/kasan/common.c:94
>   atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
>   refcount_sub_and_test_checked+0x87/0x200 lib/refcount.c:182
>   refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
>   x25_neigh_put include/net/x25.h:252 [inline]
>   x25_connect+0x8d8/0xea0 net/x25/af_x25.c:820
>   __sys_connect+0x264/0x330 net/socket.c:1840
>   __do_sys_connect net/socket.c:1851 [inline]
>   __se_sys_connect net/socket.c:1848 [inline]
>   __x64_sys_connect+0x73/0xb0 net/socket.c:1848
>   do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459279
> Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f09776b4c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
> RDX: 0000000000000012 RSI: 0000000020000280 RDI: 0000000000000004
> RBP: 000000000075bfc0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f09776b56d4
> R13: 00000000004bf854 R14: 00000000004d0e08 R15: 00000000ffffffff
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
