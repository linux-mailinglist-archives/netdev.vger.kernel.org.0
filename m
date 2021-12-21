Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644E747C9F4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhLUX5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:57:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51484 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhLUX5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 18:57:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A52DDB817E6;
        Tue, 21 Dec 2021 23:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BB5C36AE8;
        Tue, 21 Dec 2021 23:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640131057;
        bh=8qvPxNI3yZtVDZ7fsJZ3PYoJdAf4RuS345z4S/1/rMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b3AYREoK/ee/S7sxjlGxTtt4jgr/6A4A1x6YCZEhc6knz/oTsLzOUIwwgQBzXBc9y
         pMAgwYg6ScjmdAddKFTO+Xwc73geMDVZ+ESYuxvSF/i6RwxKLaRIzsAcwNk2gKZehZ
         VEYQyMjPUVnh23UhzFZf5jC1hxubE5UmVtOqkraY=
Date:   Tue, 21 Dec 2021 15:57:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com, mptcp@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [syzbot] WARNING in page_counter_cancel (3)
Message-Id: <20211221155736.90bbc5928bcd779e76ca8f95@linux-foundation.org>
In-Reply-To: <000000000000f1504c05d36c21ea@google.com>
References: <00000000000021bb9b05d14bf0c7@google.com>
        <000000000000f1504c05d36c21ea@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Dec 2021 06:04:22 -0800 syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    fbf252e09678 Add linux-next specific files for 20211216
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1797de99b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7fcbb9aa19a433c8
> dashboard link: https://syzkaller.appspot.com/bug?extid=bc9e2d2dbcb347dd215a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135d179db00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113edb6db00000

Useful to have that, thanks.

I'm suspecting that mptcp is doing something strange.  Could I as the
developers to please take a look?


> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com
> 
> R13: 00007ffdeb858640 R14: 00007ffdeb858680 R15: 0000000000000004
>  </TASK>
> ------------[ cut here ]------------
> page_counter underflow: -4294966651 nr_pages=4294967295
> WARNING: CPU: 1 PID: 3665 at mm/page_counter.c:56 page_counter_cancel+0xcf/0xe0 mm/page_counter.c:56 mm/page_counter.c:56
> Modules linked in:
> CPU: 1 PID: 3665 Comm: syz-executor933 Not tainted 5.16.0-rc5-next-20211216-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:page_counter_cancel+0xcf/0xe0 mm/page_counter.c:56 mm/page_counter.c:56
> Code: c7 04 24 00 00 00 00 45 31 f6 eb 97 e8 ba 77 af ff 4c 89 ea 48 89 ee 48 c7 c7 60 fe b8 89 c6 05 5f b3 b5 0b 01 e8 a6 85 48 07 <0f> 0b eb a8 4c 89 e7 e8 d5 85 fa ff eb c7 0f 1f 00 41 56 41 55 49
> RSP: 0018:ffffc90002b1f620 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: ffff88807b6e8120 RCX: 0000000000000000
> RDX: ffff88807ad31d40 RSI: ffffffff815f4748 RDI: fffff52000563eb6
> RBP: ffffffff00000285 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff815ee4ae R11: 0000000000000000 R12: ffff88807b6e8120
> R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000001
> FS:  000055555596c300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000080 CR3: 000000007f24a000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  page_counter_uncharge+0x2e/0x60 mm/page_counter.c:159 mm/page_counter.c:159
>  drain_stock+0xc1/0x170 mm/memcontrol.c:2172 mm/memcontrol.c:2172
>  refill_stock+0x131/0x1b0 mm/memcontrol.c:2224 mm/memcontrol.c:2224
>  __sk_mem_reduce_allocated+0x24d/0x550 net/core/sock.c:2951 net/core/sock.c:2951
>  __mptcp_rmem_reclaim net/mptcp/protocol.c:169 [inline]
>  __mptcp_rmem_reclaim net/mptcp/protocol.c:169 [inline] net/mptcp/protocol.c:978
>  __mptcp_mem_reclaim_partial+0x124/0x410 net/mptcp/protocol.c:978 net/mptcp/protocol.c:978
>  mptcp_mem_reclaim_partial net/mptcp/protocol.c:985 [inline]
>  mptcp_alloc_tx_skb net/mptcp/protocol.c:1215 [inline]
>  mptcp_mem_reclaim_partial net/mptcp/protocol.c:985 [inline] net/mptcp/protocol.c:1282
>  mptcp_alloc_tx_skb net/mptcp/protocol.c:1215 [inline] net/mptcp/protocol.c:1282
>  mptcp_sendmsg_frag+0x1ada/0x2410 net/mptcp/protocol.c:1282 net/mptcp/protocol.c:1282
>  __mptcp_push_pending+0x232/0x7a0 net/mptcp/protocol.c:1548 net/mptcp/protocol.c:1548
>  mptcp_release_cb+0xfe/0x200 net/mptcp/protocol.c:3013 net/mptcp/protocol.c:3013
>  release_sock+0xb4/0x1b0 net/core/sock.c:3312 net/core/sock.c:3312
>  sk_stream_wait_memory+0x608/0xed0 net/core/stream.c:145 net/core/stream.c:145
>  mptcp_sendmsg+0x8df/0x1300 net/mptcp/protocol.c:1745 net/mptcp/protocol.c:1745
>  inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:641 net/ipv6/af_inet6.c:641
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:724
>  sock_sendmsg+0xcf/0x120 net/socket.c:724 net/socket.c:724
>  sock_write_iter+0x289/0x3c0 net/socket.c:1057 net/socket.c:1057
>  call_write_iter include/linux/fs.h:2079 [inline]
>  call_write_iter include/linux/fs.h:2079 [inline] fs/read_write.c:503
>  new_sync_write+0x429/0x660 fs/read_write.c:503 fs/read_write.c:503
>  vfs_write+0x7cd/0xae0 fs/read_write.c:590 fs/read_write.c:590
>  ksys_write+0x1ee/0x250 fs/read_write.c:643 fs/read_write.c:643
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f4cc423cf49
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 81 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdeb8585f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f4cc423cf49
> RDX: 0000000000017f88 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00007ffdeb858620 R08: 0000000000000001 R09: 00007ffdeb858630
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
> R13: 00007ffdeb858640 R14: 00007ffdeb858680 R15: 0000000000000004
>  </TASK>
