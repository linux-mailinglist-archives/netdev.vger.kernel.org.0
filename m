Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2764447287
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFOX2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:28:53 -0400
Received: from mail-ot1-f74.google.com ([209.85.210.74]:37335 "EHLO
        mail-ot1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFOX2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:28:53 -0400
Received: by mail-ot1-f74.google.com with SMTP id d62so3148477otb.4
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 16:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KhxzwExhVXYf0j1RDyfuhlWHCnmpMBAoNNLT/tbsHsI=;
        b=v67BzsDIy0nqOtR3sHuhp78ScHzsU5mhHKKJyOqN9nrNR+8By7aqt/suriZiqYvBSB
         faq1L0P6BGoyqs8UiIWOsGTwrz8kQV9Fcu8h+odCnQkHPQ2Pi/YxNTLodl/kmDj5+gsC
         /+REMnjC4WZh6vQsupsXc35LKgifN9mmTynrsNBPxM0loEk75wkwy3chFvph4YEW3z2f
         AmoyG9cXZ07CL1Sk6Oy1+Sb5nI3ZX2I35uFllfzo0EyufryAJQaphUNezCcDzHI8se3Q
         z+FzK+CykvxoMXQ/yqx/+eLFUhzmFcOGtJaGwU9s/0UHkvrWNYat1d1hVd+NHotvsD5C
         JN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KhxzwExhVXYf0j1RDyfuhlWHCnmpMBAoNNLT/tbsHsI=;
        b=OxnilHCG7U5BhGi52b85GBnPugwqpGx9DfGBnATe+dS2AXmHrhpNI3nH5pMzXG0fBP
         XCYMSTlL5jHroxAsn0F0mLeyZUAcKtG2ESvC17cMpmaVbP3TbJCtNiTxByprS32Gf93b
         znSlDtAPrQTverQMWB+Jjm3GiMSkfV68Vx2Gajfl53O0QyJcv5rjqCDquSf8l4sJW7RI
         4jvQFolLlYVBEdUP+/OpDIojX2RilAaoa0gG1rS7Dmd/q8BLLjDJEtmiHAtpcCfTI7nu
         t7Abm9hOnncQy4r59PIiS/LxLyyki52pS7RdLRssSzq2hGFYFh4J2b9QpUkgrX4JNQn3
         m+UA==
X-Gm-Message-State: APjAAAWNNEz3xPDPYExiWhuCKBIHltRKuaGj3I7atK17wa0tocDcLP+A
        Qxj8qX/2GFDW/fzllN3m4dR2oOUjWR9v9g==
X-Google-Smtp-Source: APXvYqwJI9WHnLg8v0vWoilz+79Bh0d0uCFuqkveUZ6zdOX2ImUaV1s1GRc4ZHU+HAbhlu5ZdyvDl5B0nhdWkQ==
X-Received: by 2002:aca:bfc3:: with SMTP id p186mr6480361oif.107.1560641332289;
 Sat, 15 Jun 2019 16:28:52 -0700 (PDT)
Date:   Sat, 15 Jun 2019 16:28:48 -0700
Message-Id: <20190615232848.60731-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] neigh: fix use-after-free read in pneigh_get_next
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nine years ago, I added RCU handling to neighbours, not pneighbours.
(pneigh are not commonly used)

Unfortunately I missed that /proc dump operations would use a
common entry and exit point : neigh_seq_start() and neigh_seq_stop()

We need to read_lock(tbl->lock) or risk use-after-free while
iterating the pneigh structures.

We might later convert pneigh to RCU and revert this patch.

sysbot reported :

BUG: KASAN: use-after-free in pneigh_get_next.isra.0+0x24b/0x280 net/core/neighbour.c:3158
Read of size 8 at addr ffff888097f2a700 by task syz-executor.0/9825

CPU: 1 PID: 9825 Comm: syz-executor.0 Not tainted 5.2.0-rc4+ #32
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 pneigh_get_next.isra.0+0x24b/0x280 net/core/neighbour.c:3158
 neigh_seq_next+0xdb/0x210 net/core/neighbour.c:3240
 seq_read+0x9cf/0x1110 fs/seq_file.c:258
 proc_reg_read+0x1fc/0x2c0 fs/proc/inode.c:221
 do_loop_readv_writev fs/read_write.c:714 [inline]
 do_loop_readv_writev fs/read_write.c:701 [inline]
 do_iter_read+0x4a4/0x660 fs/read_write.c:935
 vfs_readv+0xf0/0x160 fs/read_write.c:997
 kernel_readv fs/splice.c:359 [inline]
 default_file_splice_read+0x475/0x890 fs/splice.c:414
 do_splice_to+0x127/0x180 fs/splice.c:877
 splice_direct_to_actor+0x2d2/0x970 fs/splice.c:954
 do_splice_direct+0x1da/0x2a0 fs/splice.c:1063
 do_sendfile+0x597/0xd00 fs/read_write.c:1464
 __do_sys_sendfile64 fs/read_write.c:1525 [inline]
 __se_sys_sendfile64 fs/read_write.c:1511 [inline]
 __x64_sys_sendfile64+0x1dd/0x220 fs/read_write.c:1511
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4592c9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4aab51dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00000000004592c9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000246 R12: 00007f4aab51e6d4
R13: 00000000004c689d R14: 00000000004db828 R15: 00000000ffffffff

Allocated by task 9827:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
 __do_kmalloc mm/slab.c:3660 [inline]
 __kmalloc+0x15c/0x740 mm/slab.c:3669
 kmalloc include/linux/slab.h:552 [inline]
 pneigh_lookup+0x19c/0x4a0 net/core/neighbour.c:731
 arp_req_set_public net/ipv4/arp.c:1010 [inline]
 arp_req_set+0x613/0x720 net/ipv4/arp.c:1026
 arp_ioctl+0x652/0x7f0 net/ipv4/arp.c:1226
 inet_ioctl+0x2a0/0x340 net/ipv4/af_inet.c:926
 sock_do_ioctl+0xd8/0x2f0 net/socket.c:1043
 sock_ioctl+0x3ed/0x780 net/socket.c:1194
 vfs_ioctl fs/ioctl.c:46 [inline]
 file_ioctl fs/ioctl.c:509 [inline]
 do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
 ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
 __do_sys_ioctl fs/ioctl.c:720 [inline]
 __se_sys_ioctl fs/ioctl.c:718 [inline]
 __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9824:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3432 [inline]
 kfree+0xcf/0x220 mm/slab.c:3755
 pneigh_ifdown_and_unlock net/core/neighbour.c:812 [inline]
 __neigh_ifdown+0x236/0x2f0 net/core/neighbour.c:356
 neigh_ifdown+0x20/0x30 net/core/neighbour.c:372
 arp_ifdown+0x1d/0x21 net/ipv4/arp.c:1274
 inetdev_destroy net/ipv4/devinet.c:319 [inline]
 inetdev_event+0xa14/0x11f0 net/ipv4/devinet.c:1544
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
 __raw_notifier_call_chain kernel/notifier.c:396 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
 call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1749
 call_netdevice_notifiers_extack net/core/dev.c:1761 [inline]
 call_netdevice_notifiers net/core/dev.c:1775 [inline]
 rollback_registered_many+0x9b9/0xfc0 net/core/dev.c:8178
 rollback_registered+0x109/0x1d0 net/core/dev.c:8220
 unregister_netdevice_queue net/core/dev.c:9267 [inline]
 unregister_netdevice_queue+0x1ee/0x2c0 net/core/dev.c:9260
 unregister_netdevice include/linux/netdevice.h:2631 [inline]
 __tun_detach+0xd8a/0x1040 drivers/net/tun.c:724
 tun_detach drivers/net/tun.c:741 [inline]
 tun_chr_close+0xe0/0x180 drivers/net/tun.c:3451
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:185 [inline]
 exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
 prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888097f2a700
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 64-byte region [ffff888097f2a700, ffff888097f2a740)
The buggy address belongs to the page:
page:ffffea00025fca80 refcount:1 mapcount:0 mapping:ffff8880aa400340 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea000250d548 ffffea00025726c8 ffff8880aa400340
raw: 0000000000000000 ffff888097f2a000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888097f2a600: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff888097f2a680: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888097f2a700: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff888097f2a780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888097f2a800: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc

Fixes: 767e97e1e0db ("neigh: RCU conversion of struct neighbour")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/neighbour.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0e2c0735546396005406d3297f39bca58a9938cb..9e7fc929bc50914698d1af09525d4e87fd32b198 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3203,6 +3203,7 @@ static void *neigh_get_idx_any(struct seq_file *seq, loff_t *pos)
 }
 
 void *neigh_seq_start(struct seq_file *seq, loff_t *pos, struct neigh_table *tbl, unsigned int neigh_seq_flags)
+	__acquires(tbl->lock)
 	__acquires(rcu_bh)
 {
 	struct neigh_seq_state *state = seq->private;
@@ -3213,6 +3214,7 @@ void *neigh_seq_start(struct seq_file *seq, loff_t *pos, struct neigh_table *tbl
 
 	rcu_read_lock_bh();
 	state->nht = rcu_dereference_bh(tbl->nht);
+	read_lock(&tbl->lock);
 
 	return *pos ? neigh_get_idx_any(seq, pos) : SEQ_START_TOKEN;
 }
@@ -3246,8 +3248,13 @@ void *neigh_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL(neigh_seq_next);
 
 void neigh_seq_stop(struct seq_file *seq, void *v)
+	__releases(tbl->lock)
 	__releases(rcu_bh)
 {
+	struct neigh_seq_state *state = seq->private;
+	struct neigh_table *tbl = state->tbl;
+
+	read_unlock(&tbl->lock);
 	rcu_read_unlock_bh();
 }
 EXPORT_SYMBOL(neigh_seq_stop);
-- 
2.22.0.410.gd8fdbe21b5-goog

