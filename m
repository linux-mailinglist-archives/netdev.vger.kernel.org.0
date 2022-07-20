Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F382757BC57
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiGTRJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiGTRJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:09:33 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526F66D2F8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:09:32 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id t3-20020a5d81c3000000b0067bcd25f108so8544319iol.4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cmzFT4h31a1T2jFibLO3TAgARdQJGAATchWIxh6fpuQ=;
        b=fvgMIxFXTHCPzTW+yIrr/l0BaOpo8FlK4y1btPdsf91V3gerXCH7svw1C52vCkL1G7
         sNXJ3XAbl27giunwFGkUBfWRdN59esvtNyH0b4MEUhzOAKSJPB1Y0Z9LH/oegeN2vvQH
         r5/YYcROP50jAIdxeFrwFPK256N5qFmDtRsTA7Req3zT0T+K3RD5tgXS2auq1dmcJIR6
         Tlh14rJ65WeGlTXVhFtl3sLtjSBipXXNE6bFV+JCwavjapgKdG3OfOBg4A8J833AytbV
         GFvDh7jLc/6J3dr7Heg6I4DdAFCz5Ovt1ZVb4MbY0Brv0nlnp3G1dloZKp21F868aHUr
         1FYw==
X-Gm-Message-State: AJIora+Ve09amapX22/RUnMlG2YIHAeWZFggst2cG1BM/K+nB0UTP45+
        eYWq9eAeOrg7Ae4uyMp6fR9Pc1pH6BkZK2+85NMCZjep+BlN
X-Google-Smtp-Source: AGRyM1s/3CQQWjJCZ/ZWEkjKS1d8JEADjyq3XmeNtHUoON5cuL3ztpqDKmrqHL3AdOpDjoIMvmSDZTyy0o5cfWceheOjk4VZ3hG2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4511:b0:33f:4ccb:3139 with SMTP id
 bs17-20020a056638451100b0033f4ccb3139mr20195589jab.20.1658336971661; Wed, 20
 Jul 2022 10:09:31 -0700 (PDT)
Date:   Wed, 20 Jul 2022 10:09:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d2a9405e43faa78@google.com>
Subject: [syzbot] WARNING: still has locks held in tls_rx_reader_lock
From:   syzbot <syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com>
To:     borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, john.fastabend@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e22c88799f26 Merge branch '100GbE' of git://git.kernel.org..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=159aa626080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c46ba1483fd8356
dashboard link: https://syzkaller.appspot.com/bug?extid=16e72110feb2b653ef27
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d11d78080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147797ac080000

The issue was bisected to:

commit 4cbc325ed6b4dce4910be06d9d6940a8b919c59b
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Fri Jul 15 05:22:25 2022 +0000

    tls: rx: allow only one reader at a time

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16966bac080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15966bac080000
console output: https://syzkaller.appspot.com/x/log.txt?x=11966bac080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
Fixes: 4cbc325ed6b4 ("tls: rx: allow only one reader at a time")

====================================
WARNING: syz-executor279/3626 still has locks held!
5.19.0-rc6-syzkaller-01454-ge22c88799f26 #0 Not tainted
------------------------------------
1 lock held by syz-executor279/3626:
 #0: ffff888026449ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1659 [inline]
 #0: ffff888026449ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tls_rx_reader_lock+0x2da/0x4e0 net/tls/tls_sw.c:1817

stack backtrace:
CPU: 0 PID: 3626 Comm: syz-executor279 Not tainted 5.19.0-rc6-syzkaller-01454-ge22c88799f26 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 try_to_freeze include/linux/freezer.h:66 [inline]
 get_signal+0x1424/0x2600 kernel/signal.c:2647
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f66234ef999
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f66234802f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: fffffffffffffe00 RBX: 00007f66235773f0 RCX: 00007f66234ef999
RDX: 00000000000000c1 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007f6623545064 R08: 00007f6623480700 R09: 0000000000000000
R10: 00007f6623480700 R11: 0000000000000246 R12: 0100000000000000
R13: e8fece2d4e6d48fb R14: 0cb28def7c465af4 R15: 00007f66235773f8
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
