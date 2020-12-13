Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697932D8CAF
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 12:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394470AbgLMLNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:13:55 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41123 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgLMLNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:13:55 -0500
Received: by mail-il1-f199.google.com with SMTP id f19so11217193ilk.8
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 03:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=M6uDlvuP8ZesOshmh3GfQ1w4FjzRQGgg4+C8JVDnCPM=;
        b=M2k3CK7SHA8b4LnpvBnUbWAw4CpOIGTDuZNg+5XJnSenxTtuzEvqA1qLEt/BpFEHpI
         4EeNnChIVj8pVFDy2YXjdPZnstcbCEPjSiBfmL382Yf2C7Amg5a9Lic3ICgGZ0/INCib
         AmW00udLRnPiW3/RUMsxTE6LH9iDoUC1kV+w7x4ES8Yk5UinQ0iFNHrP3PD2KyrAe+2B
         sJZ3gk7ZYiNqiR2tHz2bhJCZV/FZnvBEg8jT9VBUpHCNWOwhCgrrST9z33qx514eF/qy
         Gxc+2AnbMPdwYhwiN6nN9Wkan8yGgKP5HCWsbjSSorXnNIgq6HMDoKnvFNypYXozY8l4
         ZpHw==
X-Gm-Message-State: AOAM533SwJW0txcwMpetZr54nCqVD1NpBqlJ806p5bSxBZPN1c40zDek
        GHn1T8newwgniapTWB4xB4p/4vNghhAY0UKQIrHrGZd6Hp+T
X-Google-Smtp-Source: ABdhPJyRCebjxQppXW1ARDdAZ8ZwbxApTHSZGlPIuCEcuyQKvsdeXwgfLKuQZxK9Zg922GB8tkktMDnAUZhnyPkPEunQ+0GQLsZk
MIME-Version: 1.0
X-Received: by 2002:a02:6c50:: with SMTP id w77mr26857725jab.68.1607857993945;
 Sun, 13 Dec 2020 03:13:13 -0800 (PST)
Date:   Sun, 13 Dec 2020 03:13:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000094184905b6569cdd@google.com>
Subject: UBSAN: shift-out-of-bounds in strset_parse_request
From:   syzbot <syzbot+96523fb438937cd01220@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9e26cb5 Add linux-next specific files for 20201208
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1752cf17500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e259434a8eaf0206
dashboard link: https://syzkaller.appspot.com/bug?extid=96523fb438937cd01220
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16edd00f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b72237500000

The issue was bisected to:

commit 71921690f9745fef60a2bad425f30adf8cdc9da0
Author: Michal Kubecek <mkubecek@suse.cz>
Date:   Fri Dec 27 14:55:43 2019 +0000

    ethtool: provide string sets with STRSET_GET request

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108cd433500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=128cd433500000
console output: https://syzkaller.appspot.com/x/log.txt?x=148cd433500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+96523fb438937cd01220@syzkaller.appspotmail.com
Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")

================================================================================
UBSAN: shift-out-of-bounds in net/ethtool/strset.c:191:28
shift exponent 3476603555 is too large for 32-bit type 'unsigned int'
CPU: 1 PID: 8488 Comm: syz-executor226 Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 strset_parse_request.cold+0x3b/0x40 net/ethtool/strset.c:191
 ethnl_default_parse+0xda/0x130 net/ethtool/netlink.c:282
 ethnl_default_start+0x21c/0x570 net/ethtool/netlink.c:501
 genl_start+0x3cc/0x670 net/netlink/genetlink.c:604
 __netlink_dump_start+0x5a7/0x920 net/netlink/af_netlink.c:2363
 genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:697
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0x43c/0x590 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4409d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc89faeb48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004409d9
RDX: 0000000000000000 RSI: 0000000020000fc0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 000000000000000c R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401fc0
R13: 0000000000402050 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
