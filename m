Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5661297BF
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLWOzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:55:12 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:36311 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfLWOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:55:12 -0500
Received: by mail-io1-f69.google.com with SMTP id 144so11673694iou.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 06:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MXAH+5x0CIJYi1dDiKEIBiQX1//cGwDTkc0vcfTXCXg=;
        b=sCu+MLqEJ9lo/dulZx8oSpVzX07PMdJQVQYGloLtnWtqpgoU/WxKIZl9LsSgGtJRTx
         GGsMzOG4AqPMpDJMO765ZJb2BxkQUwr6DFyvp9ZRGXr0jrP0s1FW46Cn7FxTNag2/4xK
         P/+5zMuRM3mw6QbHtyBN3mckjEl1eUWaF4oykoSziXIYZHE2CDCeuG8sYPPgPqtlX1jp
         +DdFWBBcGEwqMuDn0LZaeEXZj/Liyh6Ri7iO/Rl5PI3mcC+PmrldorgY/l+0LISEsmR6
         0v9L6EgYNQMufX700OPYhk8gVarzhT3vBRkSL6JfqKjLeSPMar1FZLAmdJbnepR3BL5F
         bqdA==
X-Gm-Message-State: APjAAAWNjbgeAPxVE8r/C6SyyHLNM/irk4nZ7/8EsI4hK6FKEJCviUss
        vd+Qk6nM6VRQ6oElLTH0Cup+Def42UgOGqEx5vZshIVk1ztK
X-Google-Smtp-Source: APXvYqwUUAZkCTx3Y/w41e4629jcASn6MZ/pjHu7YCvdy6jphpuZwSXnpXcXKz5Re9Uxmp9cm9FBiCUyidvwd9WsYSY5RsQ9iSh2
MIME-Version: 1.0
X-Received: by 2002:a92:d80f:: with SMTP id y15mr26195608ilm.225.1577112911058;
 Mon, 23 Dec 2019 06:55:11 -0800 (PST)
Date:   Mon, 23 Dec 2019 06:55:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5a039059a6036a3@google.com>
Subject: KASAN: use-after-free Read in eth_type_trans
From:   syzbot <syzbot+6745e272378d071cac7f@syzkaller.appspotmail.com>
To:     arnd@arndb.de, daniel@iogearbox.net, davej@redhat.com,
        davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        hkallweit1@gmail.com, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, maximmi@mellanox.com, mst@redhat.com,
        mtk.manpages@gmail.com, netdev@vger.kernel.org,
        peterpenkov96@gmail.com, sdf@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4a94c433 Merge tag 'tpmdd-next-20191219' of git://git.infr..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e240aee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=745a1e367d8abf39
dashboard link: https://syzkaller.appspot.com/bug?extid=6745e272378d071cac7f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1351eb1ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11911f2ee00000

The bug was bisected to:

commit 90e33d45940793def6f773b2d528e9f3c84ffdc7
Author: Petar Penkov <peterpenkov96@gmail.com>
Date:   Fri Sep 22 20:49:15 2017 +0000

     tun: enable napi_gro_frags() for TUN/TAP driver

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114ebf2ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=134ebf2ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=154ebf2ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6745e272378d071cac7f@syzkaller.appspotmail.com
Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")

==================================================================
BUG: KASAN: use-after-free in ether_addr_equal_64bits  
include/linux/etherdevice.h:348 [inline]
BUG: KASAN: use-after-free in eth_type_trans+0x6ce/0x760  
net/ethernet/eth.c:167
Read of size 8 at addr ffff888084bf0040 by task syz-executor336/10162

CPU: 1 PID: 10162 Comm: syz-executor336 Not tainted 5.5.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
  ether_addr_equal_64bits include/linux/etherdevice.h:348 [inline]
  eth_type_trans+0x6ce/0x760 net/ethernet/eth.c:167
  napi_frags_finish net/core/dev.c:5924 [inline]
  napi_gro_frags+0x8c2/0xd00 net/core/dev.c:5999
  tun_get_user+0x2e7f/0x3fc0 drivers/net/tun.c:1976
  tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2022
  call_write_iter include/linux/fs.h:1902 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
  do_writev+0x15b/0x330 fs/read_write.c:1058
  __do_sys_writev fs/read_write.c:1131 [inline]
  __se_sys_writev fs/read_write.c:1128 [inline]
  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441800
Code: 05 48 3d 01 f0 ff ff 0f 83 fd 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00  
00 66 90 83 3d 51 9c 29 00 00 75 14 b8 14 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 d4 0e fc ff c3 48 83 ec 08 e8 9a 2b 00 00
RSP: 002b:00007ffe7bc617c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441800
RDX: 0000000000000001 RSI: 00007ffe7bc61820 RDI: 00000000000000f0
RBP: 00007ffe7bc617f0 R08: 0000000000000000 R09: 0000000000000020
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000004 R14: 00007ffe7bc61870 R15: 0000000000000000

The buggy address belongs to the page:
page:ffffea000212fc00 refcount:0 mapcount:0 mapping:0000000000000000  
index:0x0
raw: 00fffe0000000000 ffffea000212fc08 ffffea000212fc08 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888084beff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888084beff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ffff888084bf0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                            ^
  ffff888084bf0080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888084bf0100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
