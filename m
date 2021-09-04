Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC540094E
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 04:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbhIDC1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 22:27:16 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:50852 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhIDC1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 22:27:16 -0400
Received: by mail-il1-f200.google.com with SMTP id x4-20020a92b004000000b0022b3cb3b4deso644287ilh.17
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 19:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=eZuDXPMQCsAYrQ9Tqc+DegqAnhivS7bjb8voUZo9NDI=;
        b=OE1SfTriY9PjhNYPhHaQonsiwq0YNy/GqTCP8d44ld8phonkiK7Kee4nCi9rueYb1z
         M8BJ4jU9Vj/Og0+ujksD8VE8EghJummG3gjwdQg6AbR/lZIx4bdgB//Ov7STwCOL3zov
         fmIeKCVxpCy63fVI8xHamUGWqJavfDrKEBo6U1jCbV9q32EZijP1qAzdZQuxYTS5s65m
         iSCZrLCba6nJQUV2QYn5MTDVmj8SMx9xwn628n0g1xwalVmfbYUg39ydbOaIiJE7ucto
         TPE5wQ1uhFuJTrbjSVbV4nynRkRhCMVESaMVxeyr39CRD9pHJywqApgur7tZUDtEFW8l
         EIIw==
X-Gm-Message-State: AOAM5307TSuFMuprRotKXrqJ06kIn/JCEc1+1HVCrsdTe4B3MAHm9i3R
        Epf+gO6WEfwA9TcZZmI9EIfjxVWp0KlvCsmDiHGpzx+z+0+Y
X-Google-Smtp-Source: ABdhPJwewjvm4JSqsA/w2Lhr227sbplEvma+hNb4kWxNzENoVCqdMTAKUQf1cKXS8WETD8l2pcLOGdttictZeII6tUyyJovs74/b
MIME-Version: 1.0
X-Received: by 2002:a5d:9e0f:: with SMTP id h15mr1405728ioh.133.1630722375092;
 Fri, 03 Sep 2021 19:26:15 -0700 (PDT)
Date:   Fri, 03 Sep 2021 19:26:15 -0700
In-Reply-To: <20210904005650.2914-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e50e4705cb222399@google.com>
Subject: Re: [syzbot] INFO: task hung in __lru_add_drain_all
From:   syzbot <syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com>
To:     eric.dumazet@gmail.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in __lru_add_drain_all

INFO: task khugepaged:1665 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:khugepaged      state:D stack:24384 pid: 1665 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 __flush_work+0x56e/0xb10 kernel/workqueue.c:3083
 __lru_add_drain_all+0x3fd/0x760 mm/swap.c:820
 khugepaged_do_scan mm/khugepaged.c:2214 [inline]
 khugepaged+0x10f/0x5630 mm/khugepaged.c:2275
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 PID: 1658 Comm: khungtaskd Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 10 Comm: kworker/u4:1 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy12 ieee80211_iface_work
RIP: 0010:cmp_bss.part.0+0x1b6/0x860 net/wireless/scan.c:1320
Code: 45 31 c0 49 8d 75 1d 31 c9 e8 96 b7 ff ff 49 8d 7e 18 48 89 fa 48 89 c3 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 0f b6 04 02 <84> c0 74 08 3c 03 0f 8e bc 05 00 00 41 8b 56 18 45 31 c9 45 31 c0
RSP: 0018:ffffc90000cf6d00 EFLAGS: 00000a06
RAX: 0000000000000000 RBX: ffff88805f1b8e1d RCX: 0000000000000000
RDX: 1ffff1100c345993 RSI: ffffffff88697263 RDI: ffff888061a2cc98
RBP: ffff88801e32c468 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff88697224 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88805f1b8e00 R14: ffff888061a2cc80 R15: fffff5200019edea
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000052f7b0 CR3: 0000000034b9b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cmp_bss net/wireless/scan.c:1505 [inline]
 rb_find_bss+0x17d/0x200 net/wireless/scan.c:1505
 cfg80211_bss_update+0xc6/0x2070 net/wireless/scan.c:1704
 cfg80211_inform_single_bss_frame_data+0x6e8/0xee0 net/wireless/scan.c:2411
 cfg80211_inform_bss_frame_data+0xa7/0xb10 net/wireless/scan.c:2444
 ieee80211_bss_info_update+0x376/0xb60 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon+0xcce/0x17c0 net/mac80211/ibss.c:1608
 ieee80211_ibss_rx_queued_mgmt+0xd37/0x1610 net/mac80211/ibss.c:1635
 ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
 ieee80211_iface_work+0xa65/0xd00 net/mac80211/iface.c:1493
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	45 31 c0             	xor    %r8d,%r8d
   3:	49 8d 75 1d          	lea    0x1d(%r13),%rsi
   7:	31 c9                	xor    %ecx,%ecx
   9:	e8 96 b7 ff ff       	callq  0xffffb7a4
   e:	49 8d 7e 18          	lea    0x18(%r14),%rdi
  12:	48 89 fa             	mov    %rdi,%rdx
  15:	48 89 c3             	mov    %rax,%rbx
  18:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1f:	fc ff df
  22:	48 c1 ea 03          	shr    $0x3,%rdx
  26:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
* 2a:	84 c0                	test   %al,%al <-- trapping instruction
  2c:	74 08                	je     0x36
  2e:	3c 03                	cmp    $0x3,%al
  30:	0f 8e bc 05 00 00    	jle    0x5f2
  36:	41 8b 56 18          	mov    0x18(%r14),%edx
  3a:	45 31 c9             	xor    %r9d,%r9d
  3d:	45 31 c0             	xor    %r8d,%r8d


Tested on:

commit:         f1583cb1 Merge tag 'linux-kselftest-next-5.15-rc1' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a4f735300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c582b69de20dde2
dashboard link: https://syzkaller.appspot.com/bug?extid=a9b681dcbc06eb2bca04
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

