Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7568F151247
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 23:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgBCWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 17:16:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50639 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBCWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 17:16:36 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so1048002wmb.0;
        Mon, 03 Feb 2020 14:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CabiIsXX7EWRJDQ4YrQ1Yjhz185qZasDPjqxyMMXa1U=;
        b=N+27466MlMfxyK3mCp8XrRFubSyG+yGfRsBhAq1ApI+1V1ZJjPrTnBybEI/I1ZmKMZ
         fM+vk13zVPCPwRiD0H/zhgvMWI2hb+MRUHnYs1uMLFyYjoLFrxr3i5QIWgDm14ATbvUZ
         7+hWv0zi9Hm6xwlvYQ772DV6NQW/tw0s1/2+uAsy/+5lNy4C+3Mk38sctU+A1EdbZrdA
         QGwIrwKu5x/wLTcGLWrT5gAm0mZL1GdHiuh6mKzyiLemNqzuMw7gWfO24j4z6jwb7PJN
         kNMLS44GkcaeQIBWx35vE+6cIDaledOWy5Qe30ZkvZ9OsbStP938YxudKXXUn4ATWTJq
         Wn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CabiIsXX7EWRJDQ4YrQ1Yjhz185qZasDPjqxyMMXa1U=;
        b=pmYECz01mvmqURGxytEiu7p1z/MhwpCgroOkynhNVCcRw4K8pZu7r2yL2ggcw4aUMB
         xeuPJfGd7jLfEFD4mDxxP6lzlY6vUrRRn62NZUuiuHioxsaMk9HZTv/HLFGXUWEAQBlJ
         ARZWXnFu+ztzZpFTVYdphYwxfMeFqDOKxp/o2cA7ItUrSaYdH3LrcV2pg2EAw8U1CyFr
         3D7Qkpu0MK576d6KJbZaBJBI4GxjASZObDgeZqiRCFx1k2AknFMS6saQ4gBEery0z0Sl
         BIhckOE0FzCFKwv/BvxHP6xp8n7C85vD7I2ZyeKIiU2v2MBCdtXSNby7AzsMEO+bXmba
         hTYA==
X-Gm-Message-State: APjAAAW7RF4UHrKDD+B4yT730GrePseSABefqA4ZZn7LpRVsuXMnHRTo
        C+t7wuyuPijlgB8eLl44K8Y=
X-Google-Smtp-Source: APXvYqyK30FrWzSUvIwajPP2DCYcCqzK/yqXxdIum8chVaCNtow1ihSBD15Jls+XrCtO16Pu+TmrBA==
X-Received: by 2002:a05:600c:2187:: with SMTP id e7mr1123449wme.11.1580768193040;
        Mon, 03 Feb 2020 14:16:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:ec63:a580:48a8:83d4? (p200300EA8F296000EC63A58048A883D4.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ec63:a580:48a8:83d4])
        by smtp.googlemail.com with ESMTPSA id a8sm1018916wmc.20.2020.02.03.14.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 14:16:32 -0800 (PST)
Subject: Re: possible deadlock in pty_write
To:     syzbot <syzbot+3118a33395397bb6b0ca@syzkaller.appspotmail.com>,
        a@unstable.cc, andrew@lunn.ch, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        jakub.kicinski@netronome.com, jslaby@suse.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
References: <0000000000002a13b5059db305a5@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b93e20ea-c995-ed5c-c306-694394a75355@gmail.com>
Date:   Mon, 3 Feb 2020 23:16:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0000000000002a13b5059db305a5@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.02.2020 22:58, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    ccaaaf6f Merge tag 'mpx-for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11bc585ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=879390c6b09ccf66
> dashboard link: https://syzkaller.appspot.com/bug?extid=3118a33395397bb6b0ca
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165bda4ee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1646a85ee00000
> 
> The bug was bisected to:
> 
> commit 65b27995a4ab8fc51b4adc6b4dcdca20f7a595bb
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Mon Aug 12 21:52:19 2019 +0000
> 
>     net: phy: let phy_speed_down/up support speeds >1Gbps
> 

I don't see how this change in libphy could contribute to the reported issue.
Most likely bisecting wasn't correct.


> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1764f735e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14e4f735e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e4f735e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3118a33395397bb6b0ca@syzkaller.appspotmail.com
> Fixes: 65b27995a4ab ("net: phy: let phy_speed_down/up support speeds >1Gbps")
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.5.0-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor465/10262 is trying to acquire lock:
> ffffffff89b9f960 (console_owner){-.-.}, at: console_trylock_spinning kernel/printk/printk.c:1724 [inline]
> ffffffff89b9f960 (console_owner){-.-.}, at: vprintk_emit+0x3fd/0x700 kernel/printk/printk.c:1995
> 
> but task is already holding lock:
> ffff88808d6b7940 (&(&port->lock)->rlock){-.-.}, at: pty_write+0xff/0x200 drivers/tty/pty.c:120
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&(&port->lock)->rlock){-.-.}:
>        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>        _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>        tty_port_tty_get+0x24/0x100 drivers/tty/tty_port.c:287
>        tty_port_default_wakeup+0x16/0x40 drivers/tty/tty_port.c:47
>        tty_port_tty_wakeup+0x57/0x70 drivers/tty/tty_port.c:387
>        uart_write_wakeup+0x46/0x70 drivers/tty/serial/serial_core.c:104
>        serial8250_tx_chars+0x495/0xaf0 drivers/tty/serial/8250/8250_port.c:1760
>        serial8250_handle_irq.part.0+0x261/0x2b0 drivers/tty/serial/8250/8250_port.c:1833
>        serial8250_handle_irq drivers/tty/serial/8250/8250_port.c:1819 [inline]
>        serial8250_default_handle_irq+0xc0/0x150 drivers/tty/serial/8250/8250_port.c:1849
>        serial8250_interrupt+0xf1/0x1a0 drivers/tty/serial/8250/8250_core.c:126
>        __handle_irq_event_percpu+0x15d/0x970 kernel/irq/handle.c:149
>        handle_irq_event_percpu+0x74/0x160 kernel/irq/handle.c:189
>        handle_irq_event+0xa7/0x134 kernel/irq/handle.c:206
>        handle_edge_irq+0x25e/0x8d0 kernel/irq/chip.c:830
>        generic_handle_irq_desc include/linux/irqdesc.h:156 [inline]
>        do_IRQ+0xde/0x280 arch/x86/kernel/irq.c:250
>        ret_from_intr+0x0/0x36
>        arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
>        __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
>        _raw_spin_unlock_irqrestore+0x90/0xe0 kernel/locking/spinlock.c:191
>        spin_unlock_irqrestore include/linux/spinlock.h:393 [inline]
>        uart_write+0x3b6/0x6f0 drivers/tty/serial/serial_core.c:613
>        process_output_block drivers/tty/n_tty.c:595 [inline]
>        n_tty_write+0x40e/0x1080 drivers/tty/n_tty.c:2333
>        do_tty_write drivers/tty/tty_io.c:962 [inline]
>        tty_write+0x496/0x7f0 drivers/tty/tty_io.c:1046
>        redirected_tty_write+0xb2/0xc0 drivers/tty/tty_io.c:1067
>        __vfs_write+0x8a/0x110 fs/read_write.c:494
>        vfs_write+0x268/0x5d0 fs/read_write.c:558
>        ksys_write+0x14f/0x290 fs/read_write.c:611
>        __do_sys_write fs/read_write.c:623 [inline]
>        __se_sys_write fs/read_write.c:620 [inline]
>        __x64_sys_write+0x73/0xb0 fs/read_write.c:620
>        do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> -> #1 (&port_lock_key){-.-.}:
>        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>        _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>        serial8250_console_write+0x253/0x9a0 drivers/tty/serial/8250/8250_port.c:3142
>        univ8250_console_write+0x5f/0x70 drivers/tty/serial/8250/8250_core.c:587
>        call_console_drivers kernel/printk/printk.c:1791 [inline]
>        console_unlock+0xb7a/0xf00 kernel/printk/printk.c:2473
>        vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1996
>        vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
>        vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
>        printk+0xba/0xed kernel/printk/printk.c:2056
>        register_console+0x745/0xb50 kernel/printk/printk.c:2798
>        univ8250_console_init+0x3e/0x4b drivers/tty/serial/8250/8250_core.c:682
>        console_init+0x461/0x67b kernel/printk/printk.c:2884
>        start_kernel+0x653/0x8e2 init/main.c:713
>        x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
>        x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
>        secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
> 
> -> #0 (console_owner){-.-.}:
>        check_prev_add kernel/locking/lockdep.c:2475 [inline]
>        check_prevs_add kernel/locking/lockdep.c:2580 [inline]
>        validate_chain kernel/locking/lockdep.c:2970 [inline]
>        __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
>        lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
>        console_trylock_spinning kernel/printk/printk.c:1745 [inline]
>        vprintk_emit+0x43a/0x700 kernel/printk/printk.c:1995
>        vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
>        vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
>        printk+0xba/0xed kernel/printk/printk.c:2056
>        fail_dump lib/fault-inject.c:45 [inline]
>        should_fail+0x708/0x852 lib/fault-inject.c:144
>        __should_failslab+0x121/0x190 mm/failslab.c:33
>        should_failslab+0x9/0x14 mm/slab_common.c:1811
>        slab_pre_alloc_hook mm/slab.h:567 [inline]
>        slab_alloc mm/slab.c:3306 [inline]
>        __do_kmalloc mm/slab.c:3654 [inline]
>        __kmalloc+0x71/0x770 mm/slab.c:3665
>        kmalloc include/linux/slab.h:561 [inline]
>        tty_buffer_alloc drivers/tty/tty_buffer.c:175 [inline]
>        __tty_buffer_request_room+0x1fb/0x5c0 drivers/tty/tty_buffer.c:273
>        tty_insert_flip_string_fixed_flag+0x93/0x1f0 drivers/tty/tty_buffer.c:318
>        tty_insert_flip_string include/linux/tty_flip.h:37 [inline]
>        pty_write+0x133/0x200 drivers/tty/pty.c:122
>        n_tty_write+0xb1d/0x1080 drivers/tty/n_tty.c:2356
>        do_tty_write drivers/tty/tty_io.c:962 [inline]
>        tty_write+0x496/0x7f0 drivers/tty/tty_io.c:1046
>        do_loop_readv_writev fs/read_write.c:717 [inline]
>        do_loop_readv_writev fs/read_write.c:701 [inline]
>        do_iter_write fs/read_write.c:972 [inline]
>        do_iter_write+0x4a0/0x610 fs/read_write.c:951
>        vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
>        do_writev+0x15b/0x330 fs/read_write.c:1058
>        __do_sys_writev fs/read_write.c:1131 [inline]
>        __se_sys_writev fs/read_write.c:1128 [inline]
>        __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
>        do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   console_owner --> &port_lock_key --> &(&port->lock)->rlock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&port->lock)->rlock);
>                                lock(&port_lock_key);
>                                lock(&(&port->lock)->rlock);
>   lock(console_owner);
> 
>  *** DEADLOCK ***
> 
> 5 locks held by syz-executor465/10262:
>  #0: ffff88809dca8090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>  #1: ffff88809dca8118 (&tty->atomic_write_lock){+.+.}, at: tty_write_lock+0x23/0x90 drivers/tty/tty_io.c:888
>  #2: ffff88809dca82a0 (&tty->termios_rwsem){++++}, at: n_tty_write+0x1b5/0x1080 drivers/tty/n_tty.c:2316
>  #3: ffffc90007a67360 (&ldata->output_lock){+.+.}, at: n_tty_write+0xadd/0x1080 drivers/tty/n_tty.c:2355
>  #4: ffff88808d6b7940 (&(&port->lock)->rlock){-.-.}, at: pty_write+0xff/0x200 drivers/tty/pty.c:120
> 
> stack backtrace:
> CPU: 0 PID: 10262 Comm: syz-executor465 Not tainted 5.5.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
>  check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
>  check_prev_add kernel/locking/lockdep.c:2475 [inline]
>  check_prevs_add kernel/locking/lockdep.c:2580 [inline]
>  validate_chain kernel/locking/lockdep.c:2970 [inline]
>  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
>  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
>  console_trylock_spinning kernel/printk/printk.c:1745 [inline]
>  vprintk_emit+0x43a/0x700 kernel/printk/printk.c:1995
>  vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
>  vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
>  printk+0xba/0xed kernel/printk/printk.c:2056
>  fail_dump lib/fault-inject.c:45 [inline]
>  should_fail+0x708/0x852 lib/fault-inject.c:144
>  __should_failslab+0x121/0x190 mm/failslab.c:33
>  should_failslab+0x9/0x14 mm/slab_common.c:1811
>  slab_pre_alloc_hook mm/slab.h:567 [inline]
>  slab_alloc mm/slab.c:3306 [inline]
>  __do_kmalloc mm/slab.c:3654 [inline]
>  __kmalloc+0x71/0x770 mm/slab.c:3665
>  kmalloc include/linux/slab.h:561 [inline]
>  tty_buffer_alloc drivers/tty/tty_buffer.c:175 [inline]
>  __tty_buffer_request_room+0x1fb/0x5c0 drivers/tty/tty_buffer.c:273
>  tty_insert_flip_string_fixed_flag+0x93/0x1f0 drivers/tty/tty_buffer.c:318
>  tty_insert_flip_string include/linux/tty_flip.h:37 [inline]
>  pty_write+0x133/0x200 drivers/tty/pty.c:122
>  n_tty_write+0xb1d/0x1080 drivers/tty/n_tty.c:2356
>  do_tty_write drivers/tty/tty_io.c:962 [inline]
>  tty_write+0x496/0x7f0 drivers/tty/tty_io.c:1046
>  do_loop_readv_writev fs/read_write.c:717 [inline]
>  do_loop_readv_writev fs/read_write.c:701 [inline]
>  do_iter_write fs/read_write.c:972 [inline]
>  do_iter_write+0x4a0/0x610 fs/read_write.c:951
>  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
>  do_writev+0x15b/0x330 fs/read_write.c:1058
>  __do_sys_writev fs/read_write.c:1131 [inline]
>  __se_sys_writev fs/read_write.c:1128 [inline]
>  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4437c9
> Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 6b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe144fe178 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004437c9
> RDX: 1000000000000252 RSI: 00000000200023c0 RDI: 0000000000000005
> RBP: 00000000000385a4 R08: 0000000000000001 R09: 0000000000400033
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000006 R14: 0000000000000000 R15: 0000000000000000
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

