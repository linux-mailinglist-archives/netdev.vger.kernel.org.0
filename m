Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265A05255D0
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 21:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358099AbiELTfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 15:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358095AbiELTf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 15:35:29 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E687F260865
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 12:35:28 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id j4-20020a92c204000000b002caad37af3fso3855615ilo.22
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 12:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vnBY0HzgcdQ5Va+zEnq5HjFQ0qe5vbnNzeKtvYL+KTM=;
        b=2WG6LGRx13fbS9yEywM8Z6ckWX2FPR1gltyaqtiK6hFwFqs9KtDEzEqXJUsENIOKfx
         pGMwdXGIceVthQ5OZY76wTJ37EA3injCOVh3BEbvghItakJFKwZtYTJplGSwixk1pHnM
         T5PGY4GCZnzvZOxruN1Rzn8ywouAhM1G8utGitLHPFWULP7RHLyP59SIyTCHEvO0774Z
         U8du11QH8ZgqSyKHQLZd5qZDhQwiC2vpfaoR2+y45AJ5CkrJ4ZoeQ0RLtb2+E6dLgg9f
         ybyjeGtnvjI/2TPgEQ4b+A7cA/lVpk8j3l5/HoQW9Ft3GeaMO6319udJ6DCmkJrPqxpI
         n4Hg==
X-Gm-Message-State: AOAM531zvUzp8W2kJDDcUkSLicTgiFUFidyW08KD6boyaCIMexIMyS71
        dyMvwpyBcYkamoSOhxklD9YxfibL1EfZW7nlLH59yoCS2IRq
X-Google-Smtp-Source: ABdhPJyv1FM7UI0nrMJNmcePkouONIWR1m2g431a3Tqc+Z2iBZjMpy4slL2YQ4f+e2cevHFMw4W5JLLgDe1Y4ou86OuY3PJhPPDk
MIME-Version: 1.0
X-Received: by 2002:a05:6638:258b:b0:32d:b5e8:b282 with SMTP id
 s11-20020a056638258b00b0032db5e8b282mr872153jat.16.1652384128139; Thu, 12 May
 2022 12:35:28 -0700 (PDT)
Date:   Thu, 12 May 2022 12:35:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd857805ded5a88e@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in bond_ethtool_get_ts_info
From:   syzbot <syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andy@greyhouse.net, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, j.vosburgh@gmail.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        liuhangbin@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com, yhs@fb.com
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

HEAD commit:    01f4685797a5 eth: amd: remove NI6510 support (ni65)
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16391d99f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c04cc4641789ea51
dashboard link: https://syzkaller.appspot.com/bug?extid=92beb3d46aab498710fa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17df03e1f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12159cbef00000

The issue was bisected to:

commit aa6034678e873db8bd5c5a4b73f8b88c469374d6
Author: Hangbin Liu <liuhangbin@gmail.com>
Date:   Fri Jan 21 08:25:18 2022 +0000

    bonding: use rcu_dereference_rtnl when get bonding active slave

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fce349f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15fce349f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11fce349f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")

=============================
WARNING: suspicious RCU usage
5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0 Not tainted
-----------------------------
include/net/bonding.h:353 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor317/3599:
 #0: ffff88801de78130 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1680 [inline]
 #0: ffff88801de78130 (sk_lock-AF_INET){+.+.}-{0:0}, at: sock_setsockopt+0x1e3/0x2ec0 net/core/sock.c:1066

stack backtrace:
CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
 bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5595
 __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
 ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
 sock_timestamping_bind_phc net/core/sock.c:869 [inline]
 sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
 sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
 __sys_setsockopt+0x55e/0x6a0 net/socket.c:2223
 __do_sys_setsockopt net/socket.c:2238 [inline]
 __se_sys_setsockopt net/socket.c:2235 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8902c8eb39
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
