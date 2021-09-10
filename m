Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1200E406282
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 02:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbhIJApd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 20:45:33 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:57163 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbhIJAfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 20:35:43 -0400
Received: by mail-il1-f198.google.com with SMTP id d11-20020a92d78b000000b0022c670da306so159921iln.23
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 17:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZOfokQluW4H1eh7MH8JkbSFmUHfUl+1/obY6V/OI4Ko=;
        b=5LRgYfmhv/Yc4e32OnvY9aztrdoavl/+HzNvS4HPIqupW2JV7aXLACrZaAqKcaKpPg
         TT0t+UgVRpyAtkEvg6kEp7syGIGSAqQe9xe8agPJ/vR+O2IdU79ibK9rOQdChYh+myE3
         ifIE83wMQ9++2YkhIeCvK7a8SjeC2ClAWGWPjyDcbmYL0ukpQjUW9ghQDCF46lWy3xqF
         RyPPT637knhMu0Gp2OXMAzTG7GIEh6/HB8x8xrtS/uRxcm2sandxkTqxMdea2A1qFidv
         O3PBrsxHjyAWeUtyle7BUaCmrmT9HPaPf16ao027zfIZNevaxd9oMWo8zSZDl90SxR74
         TFqg==
X-Gm-Message-State: AOAM530DvZfa3zdDzQpxqJJPOMPSdcVi0jAgaJHmhhYk4KO3tIn1K2Yp
        g4uuFi6vbMGtTNU8SUfKhgYXrPBWo7o6KRBK3EfFIvAzE0K+
X-Google-Smtp-Source: ABdhPJxTHUntAKZNvhK3LU0ydoOpDwDJQ43p5rOgqaIMxNiZCOdn5GeC//eUzX3b9dblv7mNBB5/RGIdSCmw1CX+G6Hm1Z8Ti4F/
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2051:: with SMTP id t17mr2114321jaj.143.1631234073006;
 Thu, 09 Sep 2021 17:34:33 -0700 (PDT)
Date:   Thu, 09 Sep 2021 17:34:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007799db05cb99479c@google.com>
Subject: [syzbot] net test error: KFENCE: use-after-free in kvm_fastop_exception
From:   syzbot <syzbot+616920e690af4ff00db3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    276aae377206 net: stmmac: fix system hang caused by eee_ct..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=102589b3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e23f04679ec35e
dashboard link: https://syzkaller.appspot.com/bug?extid=616920e690af4ff00db3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+616920e690af4ff00db3@syzkaller.appspotmail.com

==================================================================
BUG: KFENCE: use-after-free read in kvm_fastop_exception+0xf6a/0x1058

Use-after-free read at 0xffff88823bdbe020 (in kfence-#222):
 kvm_fastop_exception+0xf6a/0x1058
 d_lookup+0xd8/0x170 fs/dcache.c:2370
 lookup_dcache+0x1e/0x130 fs/namei.c:1520
 __lookup_hash+0x29/0x180 fs/namei.c:1543
 kern_path_locked+0x17e/0x320 fs/namei.c:2567
 handle_remove+0xa2/0x5fe drivers/base/devtmpfs.c:312
 handle drivers/base/devtmpfs.c:382 [inline]
 devtmpfs_work_loop drivers/base/devtmpfs.c:395 [inline]
 devtmpfsd+0x1b9/0x2a3 drivers/base/devtmpfs.c:437
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

kfence-#222 [0xffff88823bdbe000-0xffff88823bdbefff, size=4096, cache=names_cache] allocated by task 22:
 getname_kernel+0x4e/0x370 fs/namei.c:226
 kern_path_locked+0x71/0x320 fs/namei.c:2558
 handle_remove+0xa2/0x5fe drivers/base/devtmpfs.c:312
 handle drivers/base/devtmpfs.c:382 [inline]
 devtmpfs_work_loop drivers/base/devtmpfs.c:395 [inline]
 devtmpfsd+0x1b9/0x2a3 drivers/base/devtmpfs.c:437
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

freed by task 22:
 putname.part.0+0xe1/0x120 fs/namei.c:270
 putname include/linux/err.h:41 [inline]
 filename_parentat fs/namei.c:2547 [inline]
 kern_path_locked+0xc2/0x320 fs/namei.c:2558
 handle_remove+0xa2/0x5fe drivers/base/devtmpfs.c:312
 handle drivers/base/devtmpfs.c:382 [inline]
 devtmpfs_work_loop drivers/base/devtmpfs.c:395 [inline]
 devtmpfsd+0x1b9/0x2a3 drivers/base/devtmpfs.c:437
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

CPU: 1 PID: 22 Comm: kdevtmpfs Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvm_fastop_exception+0xf6a/0x1058
Code: d3 ed e9 ef d4 6e f8 49 8d 0e 48 83 e1 f8 4c 8b 21 41 8d 0e 83 e1 07 c1 e1 03 49 d3 ec e9 45 e2 6e f8 49 8d 4d 00 48 83 e1 f8 <4c> 8b 21 41 8d 4d 00 83 e1 07 c1 e1 03 49 d3 ec e9 35 ec 6e f8 bd
RSP: 0018:ffffc90000dcfae8 EFLAGS: 00010282
RAX: 0000000032736376 RBX: ffff88806e9e1ab0 RCX: ffff88823bdbe020
RDX: ffffed100dd3c35d RSI: 0000000000000004 RDI: 0000000000000007
RBP: 0000000000000004 R08: 0000000000000000 R09: ffff88806e9e1ae0
R10: ffffed100dd3c35c R11: 0000000000000000 R12: ffff88823bdbe020
R13: ffff88823bdbe020 R14: ffff88806e9e1ae0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823bdbe020 CR3: 0000000074f8f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 d_lookup+0xd8/0x170 fs/dcache.c:2370
 lookup_dcache+0x1e/0x130 fs/namei.c:1520
 __lookup_hash+0x29/0x180 fs/namei.c:1543
 kern_path_locked+0x17e/0x320 fs/namei.c:2567
 handle_remove+0xa2/0x5fe drivers/base/devtmpfs.c:312
 handle drivers/base/devtmpfs.c:382 [inline]
 devtmpfs_work_loop drivers/base/devtmpfs.c:395 [inline]
 devtmpfsd+0x1b9/0x2a3 drivers/base/devtmpfs.c:437
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
==================================================================
----------------
Code disassembly (best guess):
   0:	d3 ed                	shr    %cl,%ebp
   2:	e9 ef d4 6e f8       	jmpq   0xf86ed4f6
   7:	49 8d 0e             	lea    (%r14),%rcx
   a:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
   e:	4c 8b 21             	mov    (%rcx),%r12
  11:	41 8d 0e             	lea    (%r14),%ecx
  14:	83 e1 07             	and    $0x7,%ecx
  17:	c1 e1 03             	shl    $0x3,%ecx
  1a:	49 d3 ec             	shr    %cl,%r12
  1d:	e9 45 e2 6e f8       	jmpq   0xf86ee267
  22:	49 8d 4d 00          	lea    0x0(%r13),%rcx
  26:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
* 2a:	4c 8b 21             	mov    (%rcx),%r12 <-- trapping instruction
  2d:	41 8d 4d 00          	lea    0x0(%r13),%ecx
  31:	83 e1 07             	and    $0x7,%ecx
  34:	c1 e1 03             	shl    $0x3,%ecx
  37:	49 d3 ec             	shr    %cl,%r12
  3a:	e9 35 ec 6e f8       	jmpq   0xf86eec74
  3f:	bd                   	.byte 0xbd


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
