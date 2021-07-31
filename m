Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ED53DC662
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhGaOsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:48:33 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:53193 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhGaOs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 10:48:29 -0400
Received: by mail-io1-f72.google.com with SMTP id n22-20020a6bf6160000b0290520c8d13420so7891003ioh.19
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 07:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GnCHPHIAZGrBSipZAlOzb9JHVlmDvHpAlEidlqyUeQA=;
        b=ob4L+q6cAwdFHHtD/RAb0AyRpIUtL5dsfut7wAS5C3lI8ZQFBdvjX9uAknbEhpgZXR
         b/VwTtDjQ1fQM3YbWRlOTt+hagtgMsAT5peD+VFxZhvOBnK1ikxfWi6zZLWB5jPYpTNb
         bggrLXPmg+EpEzw+is9Os09IbfqjCEtncxIAFIybsP1HfsaThyX83tnTFwsZaPk8sdgZ
         QqV+2q0RmdssFNk5Xn/TBYbjOTFObe9spV6kbAcWbWEcG07T9KeqO6niMPP0eSCNw0d1
         d2q6j3eBJmzeIFFUSJXZ6Xh1ZeqKNo33SHllTe5e3oV0IBJwDD0XYuKYusk5BEcD3g6t
         FJfQ==
X-Gm-Message-State: AOAM5320GvSXO7hKQsPLmfChcn3tLBR/wTdsnnuehxS01fAiUcoMVrda
        2Lb9nBXSgajHw3JB9QdFrMBeZtcmiIJPEsBbCCpBKVDLApD0
X-Google-Smtp-Source: ABdhPJy1emLbDRUY+QVC86+ky0OabWKbWgTxPEZWDGuiQXaNJVa1PMjzE3Qncwg4B5g924VtI9MEq+9c5Se7lkFPbdKLgAZ+PXq+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3048:: with SMTP id u8mr6518279jak.91.1627742903086;
 Sat, 31 Jul 2021 07:48:23 -0700 (PDT)
Date:   Sat, 31 Jul 2021 07:48:23 -0700
In-Reply-To: <000000000000f94f5405c284e370@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008637e205c86c6dac@google.com>
Subject: Re: [syzbot] general protection fault in tls_sk_proto_close (3)
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d67041228ac Merge tag 'linux-can-fixes-for-5.14-20210730'..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17a6e966300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42748795a8952874
dashboard link: https://syzkaller.appspot.com/bug?extid=29c3c12f3214b85ad081
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c631b2300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1519451e300000

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
CPU: 0 PID: 9805 Comm: syz-executor059 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tls_sk_proto_close+0xd8/0xaf0 net/tls/tls_main.c:304
Code: 02 00 0f 85 16 09 00 00 48 8b 85 f0 02 00 00 4d 8d 6c 24 14 4c 89 ea 48 c1 ea 03 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 4f 07 00 00
RSP: 0018:ffffc9000afffc60 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff87c151d3 RDI: ffff888147a24170
RBP: ffff888147a23e80 R08: 0000000000000001 R09: 00000000fffffff0
R10: ffffffff87c15461 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000014 R14: ffff88803d517908 R15: 0000000000000001
FS:  000000000076f400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb379600000 CR3: 000000003d560000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tls_sk_proto_close+0x356/0xaf0 net/tls/tls_main.c:327
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
 __sock_release+0xcd/0x280 net/socket.c:648
 sock_close+0x18/0x20 net/socket.c:1300
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x40c81b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007fffc346f8f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 000000000040c81b
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000005
RBP: 00000000000149a5 R08: 0000000000000000 R09: 0000000000000000
R10: 00007fffc346f940 R11: 0000000000000293 R12: 00007fffc346f940
R13: 00007fffc346f960 R14: 0000000000405060 R15: 00007fffc346f9d0
Modules linked in:
---[ end trace 6a958f78622ad753 ]---
RIP: 0010:tls_sk_proto_close+0xd8/0xaf0 net/tls/tls_main.c:304
Code: 02 00 0f 85 16 09 00 00 48 8b 85 f0 02 00 00 4d 8d 6c 24 14 4c 89 ea 48 c1 ea 03 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 4f 07 00 00
RSP: 0018:ffffc9000afffc60 EFLAGS: 00010203

RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff87c151d3 RDI: ffff888147a24170
RBP: ffff888147a23e80 R08: 0000000000000001 R09: 00000000fffffff0
R10: ffffffff87c15461 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000014 R14: ffff88803d517908 R15: 0000000000000001
FS:  000000000076f400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb379600000 CR3: 000000003d560000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

