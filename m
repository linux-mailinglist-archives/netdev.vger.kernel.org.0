Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D800C175189
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 02:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgCBBdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 20:33:15 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49341 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgCBBdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 20:33:15 -0500
Received: by mail-il1-f199.google.com with SMTP id p7so9699800ilq.16
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 17:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZHQ6dKVlGjCZoQqsBTW4nwVoo3qttP8kTdP8UHNlm5Y=;
        b=d1YtzxYbtkMWeE1GqRI9K7CWudRBv1OOxeqMvKHwqIGM/Zc3a2mGxUJ7RP/CNn+Sii
         pwrpEr2VEM6HvU8euE3nIZAgB6Ezi05wIsdE3VahIJ8tlXXRLuFJup/GYOWCvPPho6hF
         aENbd6CXuIXqlLLPw98xcnRCMDsnj1oLfQpwuZBeC3tXKgbHPcFudna6NPbGimnhSn4V
         1A40AlhWRCj3FsRxxHs6HLeJEqrIK67y+FaeiQI+15kdAqow7MWmnf8vavYAxaHETnhr
         3SHtPyyFZx32tJnrqZ8TAMR2RGi+GA3EcmbPrHhIqDDincmla6AxjykgWi5HG9y7lqSp
         UA1Q==
X-Gm-Message-State: APjAAAUGgwStlLBgjPXjZq/GnfOzRNFzdmxdFbesq0HnadYwxI45wxYu
        IXmqK/GTKo55qYDfYHHWmvUtIhicGfK20DNnHFYqXfWR9S16
X-Google-Smtp-Source: APXvYqxsubKI1wRCbwSnTbzzIuE6LbGN0p8GA9gpkt/F8jFFxCIST0+0eUyjWHQ5wXZuD/ZxUrnBHphOhzQhw3vhUVEu0ZIfrLZI
MIME-Version: 1.0
X-Received: by 2002:a6b:410d:: with SMTP id n13mr11484786ioa.101.1583112792367;
 Sun, 01 Mar 2020 17:33:12 -0800 (PST)
Date:   Sun, 01 Mar 2020 17:33:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0ed74059fd52b8d@google.com>
Subject: WARNING: refcount bug in __sk_destruct
From:   syzbot <syzbot+dd803bc0e8adf0003261@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, jasowang@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fd786fb1 net: convert suitable drivers to use phy_do_ioctl..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14e9726ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f93900a7904130d
dashboard link: https://syzkaller.appspot.com/bug?extid=dd803bc0e8adf0003261
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12af9369e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10583d76e00000

The bug was bisected to:

commit 14215108a1fd7e002c0a1f9faf8fbaf41fdda50d
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Feb 21 05:37:42 2019 +0000

    net_sched: initialize net pointer inside tcf_exts_init()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175b66bee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14db66bee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10db66bee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dd803bc0e8adf0003261@syzkaller.appspotmail.com
Fixes: 14215108a1fd ("net_sched: initialize net pointer inside tcf_exts_init()")

RBP: 0000000000000000 R08: 0000000000000002 R09: 00000000bb1414ac
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000009 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 9577 at lib/refcount.c:28 refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9577 Comm: syz-executor327 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
Code: e9 d8 fe ff ff 48 89 df e8 c1 f8 16 fe e9 85 fe ff ff e8 a7 77 d8 fd 48 c7 c7 e0 44 71 88 c6 05 9e 86 db 06 01 e8 93 27 a9 fd <0f> 0b e9 ac fe ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 55 48
RSP: 0018:ffffc9000c067b00 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e5dd6 RDI: fffff5200180cf52
RBP: ffffc9000c067b10 R08: ffff8880a8630340 R09: ffffed1015d26621
R10: ffffed1015d26620 R11: ffff8880ae933107 R12: 0000000000000003
R13: ffff888090256000 R14: ffff8880a7e5c040 R15: ffff8880a7e5c044
 refcount_sub_and_test include/linux/refcount.h:261 [inline]
 refcount_dec_and_test include/linux/refcount.h:281 [inline]
 put_net include/net/net_namespace.h:259 [inline]
 __sk_destruct+0x6d8/0x7f0 net/core/sock.c:1723
 sk_destruct+0xd5/0x110 net/core/sock.c:1739
 __sk_free+0xfb/0x3f0 net/core/sock.c:1750
 sk_free+0x83/0xb0 net/core/sock.c:1761
 sock_put include/net/sock.h:1719 [inline]
 __tun_detach+0xbe0/0x1150 drivers/net/tun.c:728
 tun_detach drivers/net/tun.c:740 [inline]
 tun_chr_close+0xe0/0x180 drivers/net/tun.c:3455
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xba9/0x2f50 kernel/exit.c:801
 do_group_exit+0x135/0x360 kernel/exit.c:899
 __do_sys_exit_group kernel/exit.c:910 [inline]
 __se_sys_exit_group kernel/exit.c:908 [inline]
 __x64_sys_exit_group+0x44/0x50 kernel/exit.c:908
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441a48
Code: Bad RIP value.
RSP: 002b:00007fffe55809a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000441a48
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 00000000004c8430 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006dba80 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
