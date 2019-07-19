Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A045D6E0B8
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 07:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGSFsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 01:48:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54872 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfGSFsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 01:48:07 -0400
Received: by mail-io1-f69.google.com with SMTP id n8so33419840ioo.21
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 22:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=T4YxEwf+qsQW8itajdiLddCqWEWGYRINGzf8kQCY0mU=;
        b=QBWEKOzWIu1ei2Kkpuvo+O49lOjElxr4s+RSGQV0r6BA6d0F7GWSdwCvMfvTLOMIfo
         egmau7OIazJhJ1koAVC4BvNGupYJFmPdp2U4xeLLujnsUfenVVRdZ4fxvf/smmsiRD1m
         jNY73dYhaXRmGSYQYOdaSrxEaaAb+blP+lKJQgPEeGOePu6VWB8DOZRb9YnH1vXkAdLH
         Q/bHO8MnFbum5VvIIREbjathiBBt7IN3zNiVARLD30LcoXzaGv5gHKKxycVpcX+EXbcA
         rO6jwEqF+kVQwTImj6Zw1BaCq0K7cJ1teKGL27HOLYNagdsqqWWx8he17dx/pgMnYv/2
         1I/w==
X-Gm-Message-State: APjAAAVXg6YoxhfWWpIW1oGp2AG8u0HPGK67s2B+DSQjvfl2x296nPms
        QBO1SAs54wLS0SISK/LmVlEmlPi3BHsOvjc6xXYi6NokZag7
X-Google-Smtp-Source: APXvYqzB3s9qokxDIn/hwAmiyWiEYnkHTJSmwk0y07S4pTH7IjBYabkPYMTwZjzTrJWIeqH21+Vgy4cV4JLAL0ywQOtQ2NVoa7fJ
MIME-Version: 1.0
X-Received: by 2002:a5d:8ad0:: with SMTP id e16mr37138654iot.262.1563515286612;
 Thu, 18 Jul 2019 22:48:06 -0700 (PDT)
Date:   Thu, 18 Jul 2019 22:48:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042744d058e024589@google.com>
Subject: KASAN: slab-out-of-bounds Write in check_noncircular
From:   syzbot <syzbot+e2416b38b581ad58bc1e@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    22051d9c Merge tag 'platform-drivers-x86-v5.3-2' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14090a34600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=135cb826ac59d7fc
dashboard link: https://syzkaller.appspot.com/bug?extid=e2416b38b581ad58bc1e
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1397afe0600000

The bug was bisected to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=131928f4600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=109928f4600000
console output: https://syzkaller.appspot.com/x/log.txt?x=171928f4600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e2416b38b581ad58bc1e@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

==================================================================
BUG: KASAN: slab-out-of-bounds in check_noncircular+0x91/0x560  
/kernel/locking/lockdep.c:1722
Write of size 56 at addr ffff88809752a1a0 by task syz-executor.2/9504

CPU: 1 PID: 9504 Comm: syz-executor.2 Not tainted 5.2.0+ #34
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:

Allocated by task 2258096832:
------------[ cut here ]------------
kernel BUG at mm/slab.c:4179!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9504 Comm: syz-executor.2 Not tainted 5.2.0+ #34
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__check_heap_object+0xcb/0xd0 /mm/slab.c:4203
Code: 4c 89 d1 4d 89 c8 e8 34 a6 07 00 5b 41 5e 5d c3 49 8b 73 58 41 0f b6  
d0 48 c7 c7 0f eb 7e 88 4c 89 d1 4d 89 c8 e8 d5 a6 07 00 <0f> 0b 0f 1f 00  
55 48 89 e5 53 48 83 ff 10 0f 84 90 00 00 00 48 85
RSP: 0018:ffff8880975297a0 EFLAGS: 00010046
RAX: 0000000000000fc5 RBX: 00000000000011e0 RCX: 000000000000000c
RDX: 000000000000000c RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff8880975297b0 R08: 0000000000000000 R09: fffff940004ba941
R10: ffff8880975298a0 R11: ffff8880aa5918c0 R12: ffff8880975298a2
R13: 01fffc0000010200 R14: ffff8880975286c0 R15: ffff8880975298a0
FS:  0000555556816940(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff8aff8f88 CR3: 000000008586d000 CR4: 00000000001406e0
Call Trace:
Modules linked in:
---[ end trace 35842f070e95906d ]---
RIP: 0010:__check_heap_object+0xcb/0xd0 /mm/slab.c:4203
Code: 4c 89 d1 4d 89 c8 e8 34 a6 07 00 5b 41 5e 5d c3 49 8b 73 58 41 0f b6  
d0 48 c7 c7 0f eb 7e 88 4c 89 d1 4d 89 c8 e8 d5 a6 07 00 <0f> 0b 0f 1f 00  
55 48 89 e5 53 48 83 ff 10 0f 84 90 00 00 00 48 85
RSP: 0018:ffff8880975297a0 EFLAGS: 00010046
RAX: 0000000000000fc5 RBX: 00000000000011e0 RCX: 000000000000000c
RDX: 000000000000000c RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff8880975297b0 R08: 0000000000000000 R09: fffff940004ba941
R10: ffff8880975298a0 R11: ffff8880aa5918c0 R12: ffff8880975298a2
R13: 01fffc0000010200 R14: ffff8880975286c0 R15: ffff8880975298a0
FS:  0000555556816940(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff8aff8f88 CR3: 000000008586d000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
