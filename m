Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE90065BB45
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 08:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbjACHct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 02:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjACHck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 02:32:40 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30DCDE9D;
        Mon,  2 Jan 2023 23:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672731159; x=1704267159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eg8xyNkw1cdCh6LJHAM7D5LBicxzzCkmJSboAbV8gYM=;
  b=gdl6sxV8fs+1qZoTOfr5ySdz9MNZYXEN0rrBb4lb4foAVZmHfpHfRDRV
   VU0V+mAVBpcTQroQPTKdhnSO7IJyOjFkWu2ZVPTsG41ixOIoyasAZ/2BK
   nhaV4lgbrx5sZ5Fn6UQE+gAIAFiqFrouj1z/OcvbV5YfOLvgSYY+oADWr
   g=;
X-IronPort-AV: E=Sophos;i="5.96,296,1665446400"; 
   d="scan'208";a="167171106"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 07:32:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id 1F0FC811A6;
        Tue,  3 Jan 2023 07:32:32 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 3 Jan 2023 07:32:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Tue, 3 Jan 2023 07:32:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com>
CC:     <bpf@vger.kernel.org>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        <yoshfuji@linux-ipv6.org>, <kuniyu@amazon.com>
Subject: Re: [syzbot] WARNING: locking bug in inet_send_prepare
Date:   Tue, 3 Jan 2023 16:32:16 +0900
Message-ID: <20230103073216.71701-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <00000000000004b24605f143804b@google.com>
References: <00000000000004b24605f143804b@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D46UWC002.ant.amazon.com (10.43.162.67) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   syzbot <syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com>
Date:   Mon, 02 Jan 2023 00:11:36 -0800
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a5541c0811a0 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=124dd2a2480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd4e584773e9397
> dashboard link: https://syzkaller.appspot.com/bug?extid=52866e24647f9a23403f
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d322e0480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1208adc4480000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4b7702208fb9/disk-a5541c08.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9ec0153ec051/vmlinux-a5541c08.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6f8725ad290a/Image-a5541c08.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> Looking for class "l2tp_sock" with key l2tp_socket_class, but found a different class "slock-AF_INET6" with the same key
> WARNING: CPU: 0 PID: 24577 at kernel/locking/lockdep.c:940 look_up_lock_class+0x158/0x160
> Modules linked in:
> CPU: 0 PID: 24577 Comm: syz-executor105 Not tainted 6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : look_up_lock_class+0x158/0x160
> lr : look_up_lock_class+0x154/0x160 kernel/locking/lockdep.c:937
> sp : ffff800014a7b980
> x29: ffff800014a7b980 x28: 0000000000000000 x27: 0000000000000000
> x26: ffff0000d0864bb0 x25: ffff80000b22ff14 x24: 0000000000000000
> x23: ffff80000eec8000 x22: 0000000000000001 x21: ffff80000f1c3018
> x20: 0000000000000000 x19: ffff80000dc27c18 x18: 0000000000000000
> x17: 6f6620747562202c x16: 7373616c635f7465 x15: 6b636f735f707432
> x14: 6c2079656b206874 x13: 205d373735343254 x12: 5b5d313634303832
> x11: ff808000081c4d64 x10: 0000000000000000 x9 : ad3022ef6adb7200
> x8 : ad3022ef6adb7200 x7 : 545b5d3136343038 x6 : ffff80000c091ebc
> x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000100000201 x0 : ffff80000dc27c18
> Call trace:
>  look_up_lock_class+0x158/0x160
>  register_lock_class+0x4c/0x2f8 kernel/locking/lockdep.c:1289
>  __lock_acquire+0xa8/0x3084 kernel/locking/lockdep.c:4934
>  lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
>  _raw_spin_lock_bh+0x54/0x6c kernel/locking/spinlock.c:178
>  spin_lock_bh include/linux/spinlock.h:355 [inline]
>  lock_sock_nested+0x88/0xd8 net/core/sock.c:3450
>  lock_sock include/net/sock.h:1721 [inline]
>  inet_autobind net/ipv4/af_inet.c:177 [inline]
>  inet_send_prepare+0x70/0xf4 net/ipv4/af_inet.c:813
>  inet6_sendmsg+0x30/0x80 net/ipv6/af_inet6.c:660
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  __sys_sendto+0x1e4/0x280 net/socket.c:2117
>  __do_sys_sendto net/socket.c:2129 [inline]
>  __se_sys_sendto net/socket.c:2125 [inline]
>  __arm64_sys_sendto+0x30/0x44 net/socket.c:2125
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
>  el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x48/0x140 arch/arm64/kernel/syscall.c:197
>  el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
>  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
> irq event stamp: 162
> hardirqs last  enabled at (161): [<ffff800008038a7c>] local_daif_restore arch/arm64/include/asm/daifflags.h:75 [inline]
> hardirqs last  enabled at (161): [<ffff800008038a7c>] el0_svc_common+0x40/0x220 arch/arm64/kernel/syscall.c:107
> hardirqs last disabled at (160): [<ffff80000c0844f4>] el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
> softirqs last  enabled at (156): [<ffff80000801c82c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
> softirqs last disabled at (162): [<ffff80000b22ff14>] spin_lock_bh include/linux/spinlock.h:355 [inline]
> softirqs last disabled at (162): [<ffff80000b22ff14>] lock_sock_nested+0x88/0xd8 net/core/sock.c:3450
> ---[ end trace 0000000000000000 ]---
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz dup: WARNING: locking bug in inet_autobind

https://lore.kernel.org/netdev/0000000000002ae67f05f0f191aa@google.com/
