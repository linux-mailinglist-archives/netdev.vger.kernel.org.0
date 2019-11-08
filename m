Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC498F5228
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfKHRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:04:27 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:43979 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfKHREM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:04:12 -0500
Received: by mail-il1-f200.google.com with SMTP id d11so7493592ild.10
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Qf6/971redFg5+hNvL72Agdhn9HP6mUxpqJ1caev7c4=;
        b=r63xEf27a4Qz8caqMXfCBh969G/KwuKl94djBu4EvXfTv3wsUpVDW5JTfsODafC3uY
         JxSbqHp4qYifTE1CZlh4bAoq/Jlo9qYsHodhFeiv/KFwsrAE1ty0tXdfO06zXGP6Fs6M
         0xwT/JVtAXP5IgPd81ImCXEXnf6T+qBf2BI2/UTwK2nBZ1+zSY3CCzAAdKWH5ehPVGIi
         QfItRGmg+TnZaYnVX3FUeq0IUUUOBbvhA/6C14248YImAdeSYOvHjcErVQrK7xZNyxV8
         zb1nmYxB/jOMnyiYuUXJqZU8oSAwBS5/il5wpVQWGyfsys1e7eI1QQE+oHauGBRgoBMU
         hxlw==
X-Gm-Message-State: APjAAAVUfssN06AWaF0LkCjFLIykJKiCQIYeWUd7vB/2798j1lHV8g8E
        1l03tjI097ktpMhzwkuXAUc6B9WWIg+vFRa/tNrTKMa9UxB8
X-Google-Smtp-Source: APXvYqyQmUieY6KPbHUN5J96vU2WE/TqY+EHvMAdv6Rn77xwW31IsVLTeBCAUL6lDnbae9trKVf56uhf2kJ3gOe5Gj5kN6pHTyGF
MIME-Version: 1.0
X-Received: by 2002:a6b:6512:: with SMTP id z18mr10894907iob.282.1573232651747;
 Fri, 08 Nov 2019 09:04:11 -0800 (PST)
Date:   Fri, 08 Nov 2019 09:04:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b4a6c0596d8c5a8@google.com>
Subject: KMSAN: use-after-free in rxrpc_send_keepalive
From:   syzbot <syzbot+2e7168a4d3c4ec071fdc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, glider@google.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c38191cb kmsan: fixed unaligned origin handling in kmsan_m..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10c518e3600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49548798e87d32d7
dashboard link: https://syzkaller.appspot.com/bug?extid=2e7168a4d3c4ec071fdc
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c4fec7600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2e7168a4d3c4ec071fdc@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: use-after-free in rxrpc_peer_keepalive_dispatch  
net/rxrpc/peer_event.c:369 [inline]
BUG: KMSAN: use-after-free in rxrpc_peer_keepalive_worker+0xb82/0x1510  
net/rxrpc/peer_event.c:430
CPU: 1 PID: 3995 Comm: kworker/1:2 Not tainted 5.4.0-rc2+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x153/0x2c0 mm/kmsan/kmsan_report.c:113
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
  rxrpc_send_keepalive+0x53c/0x830 net/rxrpc/output.c:634
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:369 [inline]
  rxrpc_peer_keepalive_worker+0xb82/0x1510 net/rxrpc/peer_event.c:430
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:154 [inline]
  kmsan_internal_poison_shadow+0x60/0x120 mm/kmsan/kmsan.c:137
  kmsan_slab_free+0x8d/0x100 mm/kmsan/kmsan_hooks.c:123
  slab_free_freelist_hook mm/slub.c:1473 [inline]
  slab_free mm/slub.c:3040 [inline]
  kfree+0x4c1/0x2db0 mm/slub.c:3982
  rxrpc_local_rcu+0x7a/0xe0 net/rxrpc/local_object.c:499
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2157 [inline]
  rcu_core+0xc99/0x1b10 kernel/rcu/tree.c:2377
  rcu_core_si+0xe/0x10 kernel/rcu/tree.c:2386
  __do_softirq+0x4a1/0x83a kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:375 [inline]
  irq_exit+0x230/0x280 kernel/softirq.c:416
  exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
  smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1139
  apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:837
  native_restore_fl arch/x86/include/asm/irqflags.h:41 [inline]
  arch_local_irq_restore arch/x86/include/asm/irqflags.h:84 [inline]
  kmsan_slab_free+0xac/0x100 mm/kmsan/kmsan_hooks.c:127
  slab_free_freelist_hook mm/slub.c:1473 [inline]
  slab_free mm/slub.c:3040 [inline]
  kmem_cache_free+0x2d1/0x2b70 mm/slub.c:3056
  anon_vma_chain_free mm/rmap.c:134 [inline]
  unlink_anon_vmas+0x3c1/0xb70 mm/rmap.c:401
  free_pgtables+0x2e2/0x6a0 mm/memory.c:396
  exit_mmap+0x53f/0xa00 mm/mmap.c:3162
  __mmput+0x148/0x590 kernel/fork.c:1081
  mmput+0x83/0x90 kernel/fork.c:1102
  exec_mmap fs/exec.c:1048 [inline]
  flush_old_exec+0xfaf/0x2180 fs/exec.c:1281
  load_elf_binary+0x1121/0x5f10 fs/binfmt_elf.c:847
  search_binary_handler+0x2f4/0xac0 fs/exec.c:1659
  exec_binprm fs/exec.c:1702 [inline]
  __do_execve_file+0x2218/0x2e90 fs/exec.c:1822
  do_execveat_common fs/exec.c:1868 [inline]
  do_execve fs/exec.c:1885 [inline]
  __do_sys_execve fs/exec.c:1961 [inline]
  __se_sys_execve+0xec/0x110 fs/exec.c:1956
  __x64_sys_execve+0x4a/0x70 fs/exec.c:1956
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
