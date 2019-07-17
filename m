Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEAE6B8BC
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfGQI6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:58:14 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46817 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfGQI6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 04:58:08 -0400
Received: by mail-io1-f70.google.com with SMTP id s83so26382146iod.13
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 01:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CJN4Gn5liL+Jh4v+hqpUaqsWoFYa6wblFMfrTlxL8OU=;
        b=H8l6sIZSxfLP4AYhSGBuK0DoshWhhQrxUrNn806simeuPgoeAt5HfUDyTqP5ofvth7
         LGaB21H51ZmQJCBrWZa2iq90I+IZeLXZW91gs0DaZxoRr7UDaoOjwmoNXX6QTIy3sXqV
         C6g81WR2iyDygoXW2EQ9sNjnaqQ7cJHa9VwdKq1+tkLnd49L65Mwm/FTfi2PXUUUC4PJ
         6J2T5Yc/swlh/xkxgLW43XZKVi6EUgLhgbxW82W/omjMMwET8f82KZp8R7qHd5uCcZ9U
         5S1gbg3E6NTqgGoOS10eUo7vbkcT8XJVmnWRxYegZa3dVgaMrIPWXsW9ZA3YvVQqj3lO
         Qdqw==
X-Gm-Message-State: APjAAAVErIEDjxOaa65V/bDBcX3FwSVlLu7pzpHrQzrpg4MWKcjqEtLE
        fbvS4Aj39zs39FqjS+ymKVGVujerrXsZ4VHS8ziVfRqEFJUB
X-Google-Smtp-Source: APXvYqxd7ZhaaWkXOV+fLH0umZHc+nGgsaMmwYqUp9a22i6583Rozz+W85kIpA1+g3OfMKCk4uKdAbbKd+HxmP1/bq+GAnqlVG0c
MIME-Version: 1.0
X-Received: by 2002:a5e:9701:: with SMTP id w1mr36713957ioj.294.1563353887422;
 Wed, 17 Jul 2019 01:58:07 -0700 (PDT)
Date:   Wed, 17 Jul 2019 01:58:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e443b058ddcb128@google.com>
Subject: KASAN: use-after-free Write in check_noncircular
From:   syzbot <syzbot+f5ceb7c55f59455035ca@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jmorris@namei.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9637d517 Merge tag 'for-linus-20190715' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f42e1fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88095c4f62402bcd
dashboard link: https://syzkaller.appspot.com/bug?extid=f5ceb7c55f59455035ca
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cfbe1fa00000

The bug was bisected to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=109c3078600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=129c3078600000
console output: https://syzkaller.appspot.com/x/log.txt?x=149c3078600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f5ceb7c55f59455035ca@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

==================================================================
BUG: KASAN: use-after-free in check_noncircular+0x91/0x560  
kernel/locking/lockdep.c:1722
Write of size 56 at addr ffff888089815160 by task syz-executor.4/8772

CPU: 1 PID: 8772 Comm: syz-executor.4 Not tainted 5.2.0+ #31
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:

Allocated by task 8457:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:487
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  tomoyo_print_header security/tomoyo/audit.c:156 [inline]
  tomoyo_init_log+0x176/0x1f20 security/tomoyo/audit.c:255
  tomoyo_supervisor+0x39c/0x13f0 security/tomoyo/common.c:2095
  tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
  tomoyo_path_permission security/tomoyo/file.c:587 [inline]
  tomoyo_check_open_permission+0x488/0x9e0 security/tomoyo/file.c:777
  tomoyo_file_open+0x141/0x190 security/tomoyo/tomoyo.c:319
  security_file_open+0x65/0x2f0 security/security.c:1457
  do_dentry_open+0x397/0x1060 fs/open.c:765
  vfs_open+0x73/0x80 fs/open.c:887
  do_last fs/namei.c:3416 [inline]
  path_openat+0x136d/0x4400 fs/namei.c:3533
  do_filp_open+0x1f7/0x430 fs/namei.c:3563
  do_sys_open+0x343/0x620 fs/open.c:1070
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x87/0x90 fs/open.c:1083
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8457:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  tomoyo_init_log+0x1bf7/0x1f20 security/tomoyo/audit.c:294
  tomoyo_supervisor+0x39c/0x13f0 security/tomoyo/common.c:2095
  tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
  tomoyo_path_permission security/tomoyo/file.c:587 [inline]
  tomoyo_check_open_permission+0x488/0x9e0 security/tomoyo/file.c:777
  tomoyo_file_open+0x141/0x190 security/tomoyo/tomoyo.c:319
  security_file_open+0x65/0x2f0 security/security.c:1457
  do_dentry_open+0x397/0x1060 fs/open.c:765
  vfs_open+0x73/0x80 fs/open.c:887
  do_last fs/namei.c:3416 [inline]
  path_openat+0x136d/0x4400 fs/namei.c:3533
  do_filp_open+0x1f7/0x430 fs/namei.c:3563
  do_sys_open+0x343/0x620 fs/open.c:1070
  __do_sys_open fs/open.c:1088 [inline]
  __se_sys_open fs/open.c:1083 [inline]
  __x64_sys_open+0x87/0x90 fs/open.c:1083
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880898146c0
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2720 bytes inside of
  4096-byte region [ffff8880898146c0, ffff8880898156c0)
The buggy address belongs to the page:
page:ffffea0002260500 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002263b08 ffffea0002916d08 ffff8880aa402000
raw: 0000000000000000 ffff8880898146c0 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888089815000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888089815080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888089815100: fb fb fb fb f1 f1 f1 f1 00 f2 f2 f2 fb fb fb fb
                                                        ^
  ffff888089815180: fb fb fb f3 f3 f3 f3 f3 fb fb fb fb fb fb fb fb
  ffff888089815200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
