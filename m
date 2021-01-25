Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6330307E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbhAYXtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732553AbhAYVNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 16:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9684A207B1;
        Mon, 25 Jan 2021 21:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611609174;
        bh=+7/JFcAs+r5TtRk8YUAj0V2gIvU9ZzWSvrnlc++n4Tg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AHuQ4tPHNSLwfaIpQuUoRkmuQiUx4BqrrF+8oGZ+HAsyzhRMayzSTu3hn/odj5f/H
         HK2icuEmUuIJuweyiXEhJDdgmOb+B2K+pVLeQX1FuRehC4oMmSVZOC7cWr7D9McA2K
         xG4rtddSLzHbZ2J0+DzDUjrLIleCXOeq6B6cSBx/zFzZvslVG6pFzXHpZgEEDkd16t
         OyAbv4x+Pvmy+10TGUPr97Cwvgzl6meH4k8Xw2eWy4WORWXGCWNmdbG3OiuczjVD8q
         92Qv+TaNY+6hn7AcvwUdkdN78rQBfgZDWfSsK5mgTgYhKqzfL2hr5OkFTkK450lWSI
         AN4yYCk/25c7A==
Date:   Mon, 25 Jan 2021 13:12:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+a1c17e56a8a62294c714@syzkaller.appspotmail.com>
Cc:     alexanderduyck@fb.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: WARNING in pskb_expand_head
Message-ID: <20210125131252.4e17d3f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0000000000005d4f3205b9ab95f4@google.com>
References: <0000000000005d4f3205b9ab95f4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC Willem just in case

On Sun, 24 Jan 2021 12:51:20 -0800 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7d68e382 bpf: Permit size-0 datasec
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=132567e7500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
> dashboard link: https://syzkaller.appspot.com/bug?extid=a1c17e56a8a62294c714
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ae23af500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13856bc7500000
> 
> The issue was bisected to:
> 
> commit 3226b158e67cfaa677fd180152bfb28989cb2fac
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Jan 13 16:18:19 2021 +0000
> 
>     net: avoid 32 x truesize under-estimation for tiny skbs
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151a3027500000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=171a3027500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=131a3027500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a1c17e56a8a62294c714@syzkaller.appspotmail.com
> Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
> 
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8703 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
> Modules linked in:
> CPU: 1 PID: 8703 Comm: syz-executor857 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
> Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
> RSP: 0018:ffffc90001ecf910 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff920003d9f26 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000060a20
> RBP: 0000000000020a20 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff86f1be3c R11: 0000000000000000 R12: 0000000000000012
> R13: 0000000020010300 R14: 0000000000060a20 R15: 0000000000000000
> FS:  0000000001148880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000006d5090 CR3: 000000001d414000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __alloc_pages include/linux/gfp.h:511 [inline]
>  __alloc_pages_node include/linux/gfp.h:524 [inline]
>  alloc_pages_node include/linux/gfp.h:538 [inline]
>  kmalloc_large_node+0x60/0x110 mm/slub.c:3984
>  __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4481
>  __kmalloc_reserve net/core/skbuff.c:150 [inline]
>  pskb_expand_head+0xae9/0x1050 net/core/skbuff.c:1632
>  __skb_grow include/linux/skbuff.h:2748 [inline]
>  tun_napi_alloc_frags drivers/net/tun.c:1377 [inline]
>  tun_get_user+0x1f52/0x3690 drivers/net/tun.c:1730
>  tun_chr_write_iter+0xe1/0x1d0 drivers/net/tun.c:1926
>  call_write_iter include/linux/fs.h:1901 [inline]
>  new_sync_write+0x426/0x650 fs/read_write.c:518
>  vfs_write+0x791/0xa30 fs/read_write.c:605
>  ksys_write+0x12d/0x250 fs/read_write.c:658
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x4440a9
> Code: e8 6c 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fffdb5a8e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004440a9
> RDX: 000000002001016f RSI: 0000000020000380 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

