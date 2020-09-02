Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1F825A6BC
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgIBH12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:27:28 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36639 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgIBH1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 03:27:24 -0400
Received: by mail-il1-f200.google.com with SMTP id f20so2859008ilg.3
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 00:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bPjCsLvf4YWVwJoyZQaDFqOqvUJtCilRH+5fagQZGJY=;
        b=pBJ0vbs5sXFJTkyfx6Fhymz5Y7DM2NrINoufZp/1vFrdEHtaUe0OwQ2Qu4gTkMQNns
         VOIKgbAATloWMzRJsegbcU6/WHIYv97vLP3uIiIERTV1RSe0UHmWXdEfga5Homd2TuGm
         uFQpoeh1JgnuGnQ+RLfE8eZUpGGVcd2NtgRa8CU6WYrtYqD2zxdBxyJKsJF3mCh4SfPc
         L4xmR4+0MHL0VKovZqzCIS81XdJsEQyOvqE/9djYsxn0ax/zWsZUqnR7QHKxbsj0ivNz
         9lh1sBPl5K1b1Oz86xKt+p7LryBn35Ny3GKqW8qQhhsexkdJloyB/Be4eYiu1bNEPx9N
         Tnlg==
X-Gm-Message-State: AOAM531q/BKWMDeGP82/AsV/evtLVYofgc6xPaW0lgJcLzZcfhVTTAOs
        X85IXS9KzcnaduL5M5jcfGEIXCNraizJnfuRPqCFMkKEvMgS
X-Google-Smtp-Source: ABdhPJx37j4oJkY7TNtoUOZeZICr35Z980EynEXxxYD5l4AiZWddQ/Uom0YH8so35oz8eZD0QABynd4WvzL4LfUymdDa2i2O8SSa
MIME-Version: 1.0
X-Received: by 2002:a92:dcc3:: with SMTP id b3mr162292ilr.285.1599031642741;
 Wed, 02 Sep 2020 00:27:22 -0700 (PDT)
Date:   Wed, 02 Sep 2020 00:27:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000cdfec05ae4f91da@google.com>
Subject: general protection fault in xsk_is_setup_for_bpf_map
From:   syzbot <syzbot+febe51d44243fbc564ee@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bjorn.topel@intel.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dc1a9bf2 octeontx2-pf: Add UDP segmentation offload support
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1442d38e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b6856d16f78d8fa9
dashboard link: https://syzkaller.appspot.com/bug?extid=febe51d44243fbc564ee
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1019da25900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15988279900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+febe51d44243fbc564ee@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000020: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000100-0x0000000000000107]
CPU: 1 PID: 8180 Comm: syz-executor241 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:xsk_is_setup_for_bpf_map+0xbd/0x140 net/xdp/xsk.c:39
Code: 80 3c 02 00 0f 85 8b 00 00 00 4c 8b a3 e8 04 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 00 01 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 6f 49 83 bc 24 00 01 00 00 00 74 12 41 bc 01 00 00
RSP: 0018:ffffc90005787c30 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88808880f000 RCX: ffffffff87effd24
RDX: 0000000000000020 RSI: ffffffff87efc58b RDI: 0000000000000100
RBP: 0000000000000000 R08: 0000000000000001 R09: ffff888094f6ea00
R10: 000000000000002c R11: 0000000000000000 R12: 0000000000000000
R13: ffff888082808a80 R14: ffff88808880f000 R15: 000000000000002c
FS:  0000000000767940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000077fffb CR3: 00000000a939a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xsk_map_update_elem+0x1bc/0x9d0 net/xdp/xskmap.c:188
 bpf_map_update_value.isra.0+0x715/0x900 kernel/bpf/syscall.c:200
 map_update_elem kernel/bpf/syscall.c:1120 [inline]
 __do_sys_bpf+0x320b/0x4b30 kernel/bpf/syscall.c:4186
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44c4f9
Code: e8 1c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 04 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc6d766ac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044c4f9
RDX: 000000000000002c RSI: 0000000020003000 RDI: 0000000000000002
RBP: 0000000000000000 R08: fffffffffffffff5 R09: fffffffffffffff5
R10: fffffffffffffff5 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 6b3dd16ce201e2fa ]---
RIP: 0010:xsk_is_setup_for_bpf_map+0xbd/0x140 net/xdp/xsk.c:39
Code: 80 3c 02 00 0f 85 8b 00 00 00 4c 8b a3 e8 04 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 00 01 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 6f 49 83 bc 24 00 01 00 00 00 74 12 41 bc 01 00 00
RSP: 0018:ffffc90005787c30 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88808880f000 RCX: ffffffff87effd24
RDX: 0000000000000020 RSI: ffffffff87efc58b RDI: 0000000000000100
RBP: 0000000000000000 R08: 0000000000000001 R09: ffff888094f6ea00
R10: 000000000000002c R11: 0000000000000000 R12: 0000000000000000
R13: ffff888082808a80 R14: ffff88808880f000 R15: 000000000000002c
FS:  0000000000767940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000077fffb CR3: 00000000a939a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
