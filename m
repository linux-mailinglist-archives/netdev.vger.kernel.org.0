Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A60542AEF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 11:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiFHJK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 05:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiFHJJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 05:09:19 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5551DD4F8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 01:27:21 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id v1-20020a922e01000000b002d40b2f60e5so10230704ile.13
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 01:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t0gc/xzcJt5stiUMCfeqVbf3IgQyudlht9hZER0u1/o=;
        b=KIep9lF3bhq57feUgT4qgmDYhzZUAI0p3rQ2nkEpjm7llK7uP5j6SQrNvjfkZZMPQW
         i1EI6ZHgVZIHSQEkdX3PgYtK9vZYX41j6IszMbGO5B4PplawiD6r8i8PcAkXYbvyLEwK
         /Bu3lbhudx4PVdkSRdo8LxOmY1x5FLtJ152kFEBD1uHu3yq0jv6ELHB4fu5ut32QBPDd
         zkexdq71GZDiiEhL8SzXasR8kbC5psx3vzR3Zru2AauBIlTOcfPBToIThDhHRWY0RDCk
         zYOzoyilA+IMGXtpevRvvdC5HbQ2XARHmpH4P0b/8gzh0fxt43QtCiB3dfljHUgkBZZw
         eVIQ==
X-Gm-Message-State: AOAM531QoDA7dMkF+M3v1Pyam5NVCW4o+ACt3trSM84M651bd3rJTuPN
        UFGaeSnohsw7NNnhylzyi3GcO+5lFlEO532v9L1KxBzjMox8
X-Google-Smtp-Source: ABdhPJy208H1/vg6mOS+YoCh8pcCwNJM7S0gj2tmb6mTfO3y45mAEVpOfNlxURU11Uc27dLH5j56Z47T04K1ADO+rBEwP1KnjFod
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1682:b0:65d:f539:e30 with SMTP id
 s2-20020a056602168200b0065df5390e30mr15247981iow.81.1654676840937; Wed, 08
 Jun 2022 01:27:20 -0700 (PDT)
Date:   Wed, 08 Jun 2022 01:27:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000527f4505e0eb795f@google.com>
Subject: [syzbot] WARNING: locking bug in __inet_bind
From:   syzbot <syzbot+089524dd375b122cfc88@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
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
console output: https://syzkaller.appspot.com/x/log.txt?x=11ae654df00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2c9c27babb4d679
dashboard link: https://syzkaller.appspot.com/bug?extid=089524dd375b122cfc88
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+089524dd375b122cfc88@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 11123 at kernel/locking/lockdep.c:906 look_up_lock_class+0x6a/0xd0 kernel/locking/lockdep.c:906
Modules linked in:
CPU: 0 PID: 11123 Comm: syz-executor.5 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:look_up_lock_class+0x6a/0xd0 kernel/locking/lockdep.c:906
Code: 85 c0 75 0a eb 57 48 8b 00 48 85 c0 74 4f 48 39 70 40 75 f2 48 8b 4f 18 48 39 88 b0 00 00 00 74 0b 48 81 3f a0 13 2a 8f 74 02 <0f> 0b 5d c3 9c 5a 80 e6 02 74 c2 e8 36 10 83 fa 85 c0 74 1f 8b 05
RSP: 0018:ffffc9000551f888 EFLAGS: 00010006
RAX: ffffffff900e6720 RBX: ffffffff905eb8c0 RCX: ffffffff8aee8220
RDX: 0000000000000046 RSI: ffffffff90965fa0 RDI: ffff88806cacd070
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88806cacd070 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fd663eb2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd662d9c028 CR3: 000000007854a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 register_lock_class+0xbe/0x11b0 kernel/locking/lockdep.c:1256
 __lock_acquire+0x10a/0x56c0 kernel/locking/lockdep.c:4901
 lock_acquire kernel/locking/lockdep.c:5634 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5599
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 __lock_sock+0x145/0x260 net/core/sock.c:2826
 lock_sock_nested+0xd6/0xf0 net/core/sock.c:3394
 lock_sock include/net/sock.h:1691 [inline]
 __inet_bind+0x8c4/0xc90 net/ipv4/af_inet.c:511
 inet_bind+0x173/0x220 net/ipv4/af_inet.c:456
 __sys_bind+0x1e9/0x250 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fd662c89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd663eb2168 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007fd662d9bf60 RCX: 00007fd662c89109
RDX: 0000000000000010 RSI: 00000000200001c0 RDI: 0000000000000015
RBP: 00007fd662ce308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd235ff65f R14: 00007fd663eb2300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
