Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A373F2D0F9F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgLGLnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:43:52 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35377 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgLGLnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 06:43:52 -0500
Received: by mail-il1-f197.google.com with SMTP id l11so5418186ilq.2
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 03:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RnH0gk+Ggl9SU1hd2RqCdO8fPhHvsCanm+XQaqUSaic=;
        b=POWWpVQsAAg1fkabL4Jgl75y8XiO68gDlTSJZWunbWyHcsu1+mBdo3cojYmwsSVjq3
         TfBTE2hvYrV+HPMddx8WoYcdOSMJ5bHpsT3I/iy3dtJH7/Eh6kwGkuQ8/17kIlr46jNp
         LkmHmFqmpBzT29ph1AjhORWT7UYThAt0nW14b+Y/0qPveAQeNzuJkJMUUOVhTucuoDNQ
         asDkoVXkz8Kz+GDctSbmZ/egTWEcszbCyg07EJ54UGyC6xGrRkj1ecF1eAaOKG7VBSuZ
         AyiuLKReCbtMheKh/pSzBRQUSJLt4OCung3QIY599P91QahRHQYWxFAQNeTqqQpKLDKn
         ITVQ==
X-Gm-Message-State: AOAM533Z/1ipYiqXqt6FoZArrJ/N82rescXDm4mzQMMIfVi89p2nV+FS
        ybOHGVpUP+Jz3XVrhf3m9Di+ltoev093xITfAhYSLTpa7B02
X-Google-Smtp-Source: ABdhPJzUlx+oPhmbyQL/NekSIbjRMQ2Ty1OUzOoHKQwibq/ge3Wotf5qeCBXta4kripcWaFaYn5ng/0NsTiUsRzsHsz4MerVK/Nt
MIME-Version: 1.0
X-Received: by 2002:a92:cd03:: with SMTP id z3mr407488iln.181.1607341390986;
 Mon, 07 Dec 2020 03:43:10 -0800 (PST)
Date:   Mon, 07 Dec 2020 03:43:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4832105b5de5453@google.com>
Subject: BUG: unable to handle kernel paging request in bpf_lru_populate
From:   syzbot <syzbot+ec2234240c96fdd26b93@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        johannes@sipsolutions.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bcd684aa net/nfc/nci: Support NCI 2.x initial sequence
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12001bd3500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cb098ab0334059f
dashboard link: https://syzkaller.appspot.com/bug?extid=ec2234240c96fdd26b93
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7f2ef500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=103833f7500000

The issue was bisected to:

commit b93ef089d35c3386dd197e85afb6399bbd54cfb3
Author: Martin KaFai Lau <kafai@fb.com>
Date:   Mon Nov 16 20:01:13 2020 +0000

    bpf: Fix the irq and nmi check in bpf_sk_storage for tracing usage

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1103b837500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1303b837500000
console output: https://syzkaller.appspot.com/x/log.txt?x=1503b837500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ec2234240c96fdd26b93@syzkaller.appspotmail.com
Fixes: b93ef089d35c ("bpf: Fix the irq and nmi check in bpf_sk_storage for tracing usage")

BUG: unable to handle page fault for address: fffff5200471266c
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 23fff2067 P4D 23fff2067 PUD 101a4067 PMD 32e3a067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8503 Comm: syz-executor608 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_common_lru_populate kernel/bpf/bpf_lru_list.c:569 [inline]
RIP: 0010:bpf_lru_populate+0xd8/0x5e0 kernel/bpf/bpf_lru_list.c:614
Code: 03 4d 01 e7 48 01 d8 48 89 4c 24 10 4d 89 fe 48 89 44 24 08 e8 99 23 eb ff 49 8d 7e 12 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 18 38 d0 7f 08 84 c0 0f 85 80 04 00 00 49 8d 7e 13 41 c6
RSP: 0018:ffffc9000126fc20 EFLAGS: 00010202
RAX: 1ffff9200471266c RBX: dffffc0000000000 RCX: ffffffff8184e3e2
RDX: 0000000000000002 RSI: ffffffff8184e2e7 RDI: ffffc90023893362
RBP: 00000000000000bc R08: 000000000000107c R09: 0000000000000000
R10: 000000000000107c R11: 0000000000000000 R12: 0000000000000001
R13: 000000000000107c R14: ffffc90023893350 R15: ffffc900234832f0
FS:  0000000000fe0880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff5200471266c CR3: 000000001ba62000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 prealloc_init kernel/bpf/hashtab.c:319 [inline]
 htab_map_alloc+0xf6e/0x1230 kernel/bpf/hashtab.c:507
 find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
 map_create kernel/bpf/syscall.c:829 [inline]
 __do_sys_bpf+0xa81/0x5170 kernel/bpf/syscall.c:4374
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4402e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe77af23b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402e9
RDX: 0000000000000040 RSI: 0000000020000000 RDI: 0d00000000000000
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401af0
R13: 0000000000401b80 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: fffff5200471266c
---[ end trace 4f3928bacde7b3ed ]---
RIP: 0010:bpf_common_lru_populate kernel/bpf/bpf_lru_list.c:569 [inline]
RIP: 0010:bpf_lru_populate+0xd8/0x5e0 kernel/bpf/bpf_lru_list.c:614
Code: 03 4d 01 e7 48 01 d8 48 89 4c 24 10 4d 89 fe 48 89 44 24 08 e8 99 23 eb ff 49 8d 7e 12 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 18 38 d0 7f 08 84 c0 0f 85 80 04 00 00 49 8d 7e 13 41 c6
RSP: 0018:ffffc9000126fc20 EFLAGS: 00010202
RAX: 1ffff9200471266c RBX: dffffc0000000000 RCX: ffffffff8184e3e2
RDX: 0000000000000002 RSI: ffffffff8184e2e7 RDI: ffffc90023893362
RBP: 00000000000000bc R08: 000000000000107c R09: 0000000000000000
R10: 000000000000107c R11: 0000000000000000 R12: 0000000000000001
R13: 000000000000107c R14: ffffc90023893350 R15: ffffc900234832f0
FS:  0000000000fe0880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff5200471266c CR3: 000000001ba62000 CR4: 00000000001506e0
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
