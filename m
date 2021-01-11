Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5709B2F1F7E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391255AbhAKTbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:31:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391107AbhAKTbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8147322A84;
        Mon, 11 Jan 2021 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610393460;
        bh=CzOgAbq/i/ABHtAiBRihLOwC5OEAFdAAMCCUKs67AEc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hFdsPvgoPadh+Rcv6wB5zxtOUOhZDKRXTw9/6yh73tGF2+Z3NLuyeQ42I3XM4aJBT
         GaGFmOdms+8Gn6ljLTteqRsLQ9K1J+jWuDwU8xJkJnHiOQEW9FdK9g/LoXe1j/tLPi
         WjWe8740igQdO0PC93VR8TdTorOkN9ylrL3EAZ76WCmrfUv2FCle7q9hYdlsnCGdbQ
         zIya+9JHvbOxI+zinzsbyZRATmanJYnDfsE6t1GxW9tdfx5cDivxQnCh2NwjXDUaWv
         yrvp3pJKtvlz+Hcf3A14Nb1dBnbmGJOrsTL4BD7aNWt5K0xwSq/OP3Fsc+sMJf2YLu
         jvF4O0x1tn4mA==
Date:   Mon, 11 Jan 2021 11:30:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KMSAN: kernel-infoleak in move_addr_to_user (4)
Message-ID: <20210111113059.42de599d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <00000000000019908405b8891f9d@google.com>
References: <00000000000019908405b8891f9d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like a AF_CAN socket:

r0 = socket(0x1d, 0x2, 0x6)
getsockname$packet(r0, &(0x7f0000000100)={0x11, 0x0, 0x0, 0x1, 0x0, 0x6, @broadcast}, &(0x7f0000000000)=0x14)


On Sun, 10 Jan 2021 02:19:15 -0800 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c8b8c7500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdf4151c9653e32
> dashboard link: https://syzkaller.appspot.com/bug?extid=057884e2f453e8afebc8
> compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101520c7500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100b8f4f500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x9c/0xb0 mm/kmsan/kmsan_hooks.c:249
> CPU: 0 PID: 8245 Comm: syz-executor868 Not tainted 5.10.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x21c/0x280 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
>  kmsan_internal_check_memory+0x202/0x520 mm/kmsan/kmsan.c:402
>  kmsan_copy_to_user+0x9c/0xb0 mm/kmsan/kmsan_hooks.c:249
>  instrument_copy_to_user include/linux/instrumented.h:121 [inline]
>  _copy_to_user+0x1af/0x270 lib/usercopy.c:33
>  copy_to_user include/linux/uaccess.h:209 [inline]
>  move_addr_to_user+0x3a2/0x640 net/socket.c:237
>  __sys_getsockname+0x407/0x5d0 net/socket.c:1906
>  __do_sys_getsockname net/socket.c:1917 [inline]
>  __se_sys_getsockname+0x91/0xb0 net/socket.c:1914
>  __x64_sys_getsockname+0x4a/0x70 net/socket.c:1914
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x441219
> Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe3c24eaf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000033
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441219
> RDX: 0000000020000000 RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000401fc0
> R13: 0000000000402050 R14: 0000000000000000 R15: 0000000000000000
> 
> Local variable ----address@__sys_getsockname created at:
>  __sys_getsockname+0x91/0x5d0 net/socket.c:1891
>  __sys_getsockname+0x91/0x5d0 net/socket.c:1891
> 
> Bytes 2-3 of 20 are uninitialized
> Memory access of size 20 starts at ffff888124bbbdf0
> Data copied to user address 0000000020000100
> =====================================================
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

