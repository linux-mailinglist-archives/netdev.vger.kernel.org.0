Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A23480BB9
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 18:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhL1RCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 12:02:23 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:49068 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbhL1RCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 12:02:23 -0500
Received: by mail-io1-f69.google.com with SMTP id i12-20020a056602134c00b0060211f8b5b7so4017279iov.15
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 09:02:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Elz8FkYtiNR+oWGYVYY+4bZsQT+pCjbnV2l/cLFCBOI=;
        b=p6tdt0iuSxIyvLcZjcGYEr705lhVGOh9HSzNbYQWKIsK+d3Sdr/0IagSRne4Hufu3U
         FD1yNlxqD9ZHNaLZcW75A/WAbCRpOGmKWy+v0D/tRBHnKf2s4oGqvMMVRh/RSrRTElZP
         90Ie+hjn2k4pvp8MmGR2paH7FPw3vD8kHsbY91so1ngF0WlG5mDSWTCUG9Vyc7Tw98qY
         eVZwv8YzzBDPTDwutfV1x2bzOLSAwc8goV2W1ptD3Amh/zPljcILUTORjjSgL/nfwr81
         /xlq9u4dX834lZFusQ+/wTMS+s5thm9R5Lsehi32ylPCBA0v5z+QWKWjujRA9YHZRIEw
         IVDw==
X-Gm-Message-State: AOAM531A4Nxq160zATLmkhG//y7RnjP7oc1IzeGV20b49dhg9VWDp82N
        yckIv1DmrTxrjWSgpuXceVU7RKviwbgA0qBIFiipZoxSEmhB
X-Google-Smtp-Source: ABdhPJzeywTUU05+9GxB2u6Yr/SzFJoLeNd5prGngvOMMrmG+u33GhwzB0Q5KCUECZV1QxDHQvNndWXRbhWA5PgamPw2TU3ClDH1
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1989:: with SMTP id g9mr9710032ilf.88.1640710942975;
 Tue, 28 Dec 2021 09:02:22 -0800 (PST)
Date:   Tue, 28 Dec 2021 09:02:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef6c6c05d437c830@google.com>
Subject: [syzbot] WARNING in kvm_mmu_notifier_invalidate_range_start
From:   syzbot <syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com>
To:     changbin.du@intel.com, christian.brauner@ubuntu.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ea586a076e8a Add linux-next specific files for 20211224
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12418ea5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9c4e3dde2c568fb
dashboard link: https://syzkaller.appspot.com/bug?extid=4e697fe80a31aa7efe21
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15724985b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d1aedbb00000

The issue was bisected to:

commit e4b8954074f6d0db01c8c97d338a67f9389c042f
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Dec 7 01:30:37 2021 +0000

    netlink: add net device refcount tracker to struct ethnl_req_info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1640902db00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1540902db00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1140902db00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com
Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3605 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 __kvm_handle_hva_range arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 [inline]
WARNING: CPU: 0 PID: 3605 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 kvm_mmu_notifier_invalidate_range_start+0x91b/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:714
Modules linked in:
CPU: 0 PID: 3605 Comm: syz-executor402 Not tainted 5.16.0-rc6-next-20211224-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__kvm_handle_hva_range arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 [inline]
RIP: 0010:kvm_mmu_notifier_invalidate_range_start+0x91b/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:714
Code: 00 48 c7 c2 20 08 a2 89 be b9 01 00 00 48 c7 c7 c0 0b a2 89 c6 05 4c 4e 75 0c 01 e8 f3 22 09 08 e9 76 ff ff ff e8 25 e0 6e 00 <0f> 0b e9 8f fc ff ff e8 19 e0 6e 00 0f 0b e9 5f fc ff ff e8 0d e0
RSP: 0018:ffffc900028bf5a0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000020800000 RCX: 0000000000000000
RDX: ffff88801ccc3a80 RSI: ffffffff8109245b RDI: 0000000000000003
RBP: ffffc900029e0290 R08: 0000000020800000 R09: ffffc900029e0293
R10: ffffffff81091d04 R11: 0000000000000001 R12: ffffc900029e9168
R13: ffffc900029df000 R14: ffffc900028bf868 R15: 0000000020800000
FS:  0000555555953300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd0eb9e48d0 CR3: 00000000749c0000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mn_hlist_invalidate_range_start mm/mmu_notifier.c:493 [inline]
 __mmu_notifier_invalidate_range_start+0x2ff/0x800 mm/mmu_notifier.c:548
 mmu_notifier_invalidate_range_start include/linux/mmu_notifier.h:459 [inline]
 __unmap_hugepage_range+0xdd3/0x1170 mm/hugetlb.c:4961
 unmap_hugepage_range+0xa8/0x100 mm/hugetlb.c:5072
 hugetlb_vmdelete_list+0x134/0x190 fs/hugetlbfs/inode.c:439
 hugetlbfs_punch_hole fs/hugetlbfs/inode.c:616 [inline]
 hugetlbfs_fallocate+0xf31/0x1550 fs/hugetlbfs/inode.c:646
 vfs_fallocate+0x48d/0xe10 fs/open.c:308
 madvise_remove mm/madvise.c:959 [inline]
 madvise_vma_behavior+0x9ca/0x1fa0 mm/madvise.c:982
 madvise_walk_vmas mm/madvise.c:1207 [inline]
 do_madvise mm/madvise.c:1385 [inline]
 do_madvise+0x3d6/0x660 mm/madvise.c:1343
 __do_sys_madvise mm/madvise.c:1398 [inline]
 __se_sys_madvise mm/madvise.c:1396 [inline]
 __x64_sys_madvise+0xa6/0x110 mm/madvise.c:1396
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f64377bd039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff39388f08 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f64377bd039
RDX: 0000000000000009 RSI: 0000000000800000 RDI: 0000000020000000
RBP: 00007f6437781020 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f64377810b0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
