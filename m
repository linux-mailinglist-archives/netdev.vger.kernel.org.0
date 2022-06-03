Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4B453CC5A
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245552AbiFCPeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 11:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245549AbiFCPeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 11:34:23 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81674507F
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 08:34:20 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id a2-20020a923302000000b002d1ad5053feso6319322ilf.17
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 08:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/5nuHQQHT2sCXiwzYSRm3GgReb0rjG8F9gT4TL+J8hU=;
        b=NdVk0ZFCvvPTbZe4JZ6EmlmZA8bafo0dSOWfK/YvhMBl23hi8EXCln6Y1xJBWQ5BMp
         uEZeeAmglRjoEQlG80Ewl2XLBGm6wOqgTFbPuUBpEqqgCvNk5nZaux7zteSy8alIX8u1
         5Mr6juRYmU/rId+ncav++dZKaDbHSDxJt893yLYjHMKwFdgZqEwpVUzy3d4DR5LBIntU
         i+clfPTqkvMAE1oD9OeEZ1YHPxFZpmCS9dEBBgnpSldsfyekD5V7UggQEi2k4rW2JeYV
         fFBEoz3Bt06ZyGQa702QdU5BdXxk9KgMwugoMKT9FEJE6QfrJ7vKVVaRsEkMQZ4eYDbm
         QGTA==
X-Gm-Message-State: AOAM531C0PXSLZoK5uybqBJ+LPhy7vErEQFZCWGToWIduJaZy8gDoxSM
        NpWPHFZ38IgnGIwC1OL1qkKpRbzMX70NA4XCD4xZvoXnXdpf
X-Google-Smtp-Source: ABdhPJwaExqDRnW+4ewj0B4jM+plpdRGbTdtwVFfPwaWxlkonjabhfMddli8LA2zHoCtQlld6H1aRF4Pun+SfcnVkw8nLkcdUmGD
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4d:b0:2d3:d2d2:1f47 with SMTP id
 u13-20020a056e021a4d00b002d3d2d21f47mr6422611ilv.234.1654270460307; Fri, 03
 Jun 2022 08:34:20 -0700 (PDT)
Date:   Fri, 03 Jun 2022 08:34:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026328205e08cdbeb@google.com>
Subject: [syzbot] WARNING: refcount bug in sk_psock_get (2)
From:   syzbot <syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, guwen@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7e062cda7d90 Merge tag 'net-next-5.19' of git://git.kernel..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13e2c083f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2c9c27babb4d679
dashboard link: https://syzkaller.appspot.com/bug?extid=5f26f85569bd179c18ce
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f2520bf00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c31fcbf00000

The issue was bisected to:

commit 341adeec9adad0874f29a0a1af35638207352a39
Author: Wen Gu <guwen@linux.alibaba.com>
Date:   Wed Jan 26 15:33:04 2022 +0000

    net/smc: Forward wakeup to smc socket waitqueue after fallback

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12eb9635f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11eb9635f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16eb9635f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")

netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 1 PID: 3605 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Modules linked in:
CPU: 1 PID: 3605 Comm: syz-executor208 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Code: 1d 58 b1 ac 09 31 ff 89 de e8 38 3d 80 fd 84 db 75 ab e8 4f 39 80 fd 48 c7 c7 e0 a3 27 8a c6 05 38 b1 ac 09 01 e8 62 c6 34 05 <0f> 0b eb 8f e8 33 39 80 fd 0f b6 1d 22 b1 ac 09 31 ff 89 de e8 03
RSP: 0018:ffffc90002fcf9d0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888022543b00 RSI: ffffffff81606db8 RDI: fffff520005f9f2c
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff816000f9 R11: 0000000000000000 R12: 1ffff920005f9f3d
R13: 0000000090965601 R14: ffff88807e9a0000 R15: ffffc90002fcfa08
FS:  00005555567fa300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd252aa4300 CR3: 000000001994e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:163 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 sk_psock_get+0x3bc/0x410 include/linux/skmsg.h:439
 tls_data_ready+0x6d/0x1b0 net/tls/tls_sw.c:2091
 tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4983
 tcp_data_queue+0x25f2/0x4c90 net/ipv4/tcp_input.c:5057
 tcp_rcv_state_process+0x1774/0x4e80 net/ipv4/tcp_input.c:6659
 tcp_v4_do_rcv+0x339/0x980 net/ipv4/tcp_ipv4.c:1682
 sk_backlog_rcv include/net/sock.h:1061 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2849
 release_sock+0x54/0x1b0 net/core/sock.c:3404
 inet_shutdown+0x1e0/0x430 net/ipv4/af_inet.c:909
 __sys_shutdown_sock net/socket.c:2331 [inline]
 __sys_shutdown_sock net/socket.c:2325 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2343
 __do_sys_shutdown net/socket.c:2351 [inline]
 __se_sys_shutdown net/socket.c:2349 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2349
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fbd68c61969
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdfd5f2358 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fbd68c61969
RDX: 00007fbd68c61969 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 0000000000000003 R08: bb1414ac00000000 R09: bb1414ac00000000
R10: 0000000000000028 R11: 0000000000000246 R12: 00007ffdfd5f2370
R13: 00007ffdfd5f2364 R14: 0000000000000003 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
