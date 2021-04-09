Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81735A224
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhDIPjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:39:31 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:50515 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhDIPja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:39:30 -0400
Received: by mail-il1-f200.google.com with SMTP id n1so3712929ili.17
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 08:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jZbg77mtmUAx73slrlTxgnb1mnony9A1Ml58bH1UALw=;
        b=OLcNyyW3SVcDN32AZj1zvfRPvgEWeMSqRZNZ74bMMLaswbLQEj/nFNAmI7md2V0DHF
         UxaYEFPfi2dx431vpkiRj9exTO6priBw6D04xZFjVR51H9yBlP7YEUXH+t7JuFBSdA4P
         /qWEEj45deo+9a++6SLL507hwz56WZR8pVROjgcP/V5XX9li2U+I0fZMGVOipSuk44RE
         MGCt4EB9QRQA1F1IpZwiBI9zfzeZsvauw8QW7L/LqsDiN3K5bX5S8DJDc5v9kfmJL4yv
         YY/EtQHlBE1kDikjB7vgNyYz2p/TU+OyfZiQJGodvPAoLSHwHwpmWjDMDNFxTmzD4O+c
         5IwQ==
X-Gm-Message-State: AOAM533wuLt/EEJHz5dEL5Rx/ufhhkRs30qJuu54Kr7lfrTfgc/JW/4L
        swetLYQMs/FYhhyj99w2kDeNlhqGFFU1cgkNmwrr36SVioeA
X-Google-Smtp-Source: ABdhPJywqm5sQ8uWfvrUvAFPSwnslEiHr4h+DPIlj9Ki8nKrSEPlMx/yenRdvwaJicFT4iECq25yIRgOCwGTyTSCdIqY1+4lZ3RN
MIME-Version: 1.0
X-Received: by 2002:a02:b615:: with SMTP id h21mr15254285jam.93.1617982756977;
 Fri, 09 Apr 2021 08:39:16 -0700 (PDT)
Date:   Fri, 09 Apr 2021 08:39:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b81f905bf8bf7ac@google.com>
Subject: [syzbot] WARNING: refcount bug in sk_psock_get
From:   syzbot <syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bp@alien8.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9c54130c Add linux-next specific files for 20210406
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17d8d7aad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d125958c3995ddcd
dashboard link: https://syzkaller.appspot.com/bug?extid=b54a1ce86ba4a623b7f0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1729797ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1190f46ad00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a6cc96d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a6cc96d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15a6cc96d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 1 PID: 8414 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Modules linked in:
CPU: 1 PID: 8414 Comm: syz-executor793 Not tainted 5.12.0-rc6-next-20210406-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Code: 1d 69 0c e6 09 31 ff 89 de e8 c8 b4 a6 fd 84 db 75 ab e8 0f ae a6 fd 48 c7 c7 e0 52 c2 89 c6 05 49 0c e6 09 01 e8 91 0f 00 05 <0f> 0b eb 8f e8 f3 ad a6 fd 0f b6 1d 33 0c e6 09 31 ff 89 de e8 93
RSP: 0018:ffffc90000eef388 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801bbdd580 RSI: ffffffff815c2e05 RDI: fffff520001dde63
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bcc6e R11: 0000000000000000 R12: 1ffff920001dde74
R13: 0000000090200301 R14: ffff888026e00000 R15: ffffc90000eef3c0
FS:  0000000001422300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 0000000012b3b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_add_not_zero include/linux/refcount.h:163 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 sk_psock_get+0x3b0/0x400 include/linux/skmsg.h:435
 bpf_exec_tx_verdict+0x11e/0x11a0 net/tls/tls_sw.c:799
 tls_sw_sendmsg+0xa41/0x1800 net/tls/tls_sw.c:1013
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 sock_write_iter+0x289/0x3c0 net/socket.c:1001
 call_write_iter include/linux/fs.h:2106 [inline]
 do_iter_readv_writev+0x46f/0x740 fs/read_write.c:740
 do_iter_write+0x188/0x670 fs/read_write.c:866
 vfs_writev+0x1aa/0x630 fs/read_write.c:939
 do_writev+0x27f/0x300 fs/read_write.c:982
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43efa9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9279f418 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043efa9
RDX: 0000000000000001 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 0000000000402f90 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000000038 R11: 0000000000000246 R12: 0000000000403020
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
