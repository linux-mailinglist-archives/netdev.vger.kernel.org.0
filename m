Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBF382B06
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbhEQL3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:29:38 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:57056 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbhEQL3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:29:36 -0400
Received: by mail-io1-f70.google.com with SMTP id d6-20020a5d9bc60000b0290438ecc3ee01so3039321ion.23
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2TVYOtOh5rAkZHffystqbITRpqyTyAnJ4o3aUYKjOdQ=;
        b=Rd4NpUdaLahCPROSqLX4uL9KFSOgW9lHFc6LRfBL8mwpwMp+y5lVqEaGqtXzE0hFhd
         em8swU8RwQ6qNPqytRZuX4R7J1N69ijk3NJNPO0r7v5SYwUJeW03Aj5n4T+1bD1pfBg3
         ZoQ185ebpnZmcxWBVVeXnD29GU6no8sibuUKLcrmkn++ZgR5PtrSscIu+lT/jdEGm6Wy
         0d8ODeRFYzHr4DjUdHaPFI2uLaAAGm8I/OnMUqzdff2ezRwwpsO51+Tc1/MQyFk249ri
         1r6Rk3EwdVIb1WJn6xM4PGZ8Qnzze50rgeSOtDnuo0CvcTXqZ2GT7shbDOdQwTIbqJ8f
         /jIw==
X-Gm-Message-State: AOAM532UPLno9EzUISYaJvdQU00UHm9YKncF/e0niJ5h2wQWtPqFKWfd
        sUHQpZNWPplhGZdUb0v1Nddi8R7SgjvU113yqz7owJRCPvxp
X-Google-Smtp-Source: ABdhPJxiId3aOAjyaHPtj6eXF0lTg9kn0HepBRHkpmJVrHxVLQh8w3neRFDr3qdbuqMqhzP5o88YZxnIB+Esr7jYXS37SQa8re0R
MIME-Version: 1.0
X-Received: by 2002:a92:b746:: with SMTP id c6mr20299490ilm.240.1621250899790;
 Mon, 17 May 2021 04:28:19 -0700 (PDT)
Date:   Mon, 17 May 2021 04:28:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f94f5405c284e370@google.com>
Subject: [syzbot] general protection fault in tls_sk_proto_close (3)
From:   syzbot <syzbot+29c3c12f3214b85ad081@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, borisp@nvidia.com, bp@alien8.de,
        daniel@iogearbox.net, davem@davemloft.net, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f3f409a9 Merge branch 'ionic-ptp'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10fae07ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=29c3c12f3214b85ad081
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158fe316d00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a85786d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a85786d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15a85786d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+29c3c12f3214b85ad081@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 8662 Comm: syz-executor.0 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tls_sk_proto_close+0xd8/0xaf0 net/tls/tls_main.c:304
Code: 02 00 0f 85 16 09 00 00 48 8b 85 f0 02 00 00 4d 8d 6c 24 14 4c 89 ea 48 c1 ea 03 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 4f 07 00 00
RSP: 0018:ffffc9000216fc78 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff87a353b3 RDI: ffff8880216aa7b0
RBP: ffff8880216aa4c0 R08: 0000000000000001 R09: 00000000fffffff0
R10: ffffffff87a35641 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000014 R14: ffff88801c1e5108 R15: 0000000000000001
FS:  0000000001f87400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000780000 CR3: 0000000013807000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tls_sk_proto_close+0x356/0xaf0 net/tls/tls_main.c:327
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x41926b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffd0160cbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 000000000041926b
RDX: 00000000005711e8 RSI: 0000000000000001 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000001b321200e0
R10: ffffffffffffffff R11: 0000000000000293 R12: 00000000005711e8
R13: 00007ffd0160cce0 R14: 000000000056bf60 R15: 0000000000012c65
Modules linked in:
---[ end trace 7e9ee67b64dc5682 ]---
RIP: 0010:tls_sk_proto_close+0xd8/0xaf0 net/tls/tls_main.c:304
Code: 02 00 0f 85 16 09 00 00 48 8b 85 f0 02 00 00 4d 8d 6c 24 14 4c 89 ea 48 c1 ea 03 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 4f 07 00 00
RSP: 0018:ffffc9000216fc78 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff87a353b3 RDI: ffff8880216aa7b0
RBP: ffff8880216aa4c0 R08: 0000000000000001 R09: 00000000fffffff0
R10: ffffffff87a35641 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000014 R14: ffff88801c1e5108 R15: 0000000000000001
FS:  0000000001f87400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc1c76c3010 CR3: 0000000013807000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
