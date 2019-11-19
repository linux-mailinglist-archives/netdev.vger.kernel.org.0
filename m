Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79A41012AD
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKSE5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfKSE5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 23:57:10 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081EF22319;
        Tue, 19 Nov 2019 04:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574139429;
        bh=LgckK45uqKCtb6QblTKAUTyeH4P8kcfppHp0oCMGRDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FmX2Ts+rXV8bVoXkFtVLrm1gzZo+dOhxYDqEzrvreidZf9r9GjZ9rwPkpl1g4wXWU
         WGxeRm3AC6QOx/lpQSHVRok/sV5dqp9C4s+NN2cdaBK80ANEElgGm0KXka6eY8ShpP
         RxJ5YuBlG9ly85D84iPwu4pyEg3oMavPPBs2dTxk=
Date:   Mon, 18 Nov 2019 20:57:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot <syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
Subject: Re: [net/tls] kernel BUG at include/linux/scatterlist.h:LINE!
Message-ID: <20191119045707.GI163020@sol.localdomain>
References: <000000000000f41cd905897c075e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f41cd905897c075e@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub and other TLS maintainers,

On Wed, May 22, 2019 at 08:58:05AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    af8f3fb7 net: stmmac: dma channel control register need to..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=17c2d418a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=df0d4ec12332661dd1f9
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b53ce4a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b0aa52a00000
> 
> The bug was bisected to:
> 
> commit f295b3ae9f5927e084bd5decdff82390e3471801
> Author: Vakul Garg <vakul.garg@nxp.com>
> Date:   Wed Mar 20 02:03:36 2019 +0000
> 
>     net/tls: Add support of AES128-CCM based ciphers
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16915282a00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=15915282a00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11915282a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
> 
> ------------[ cut here ]------------
> kernel BUG at include/linux/scatterlist.h:97!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8868 Comm: syz-executor428 Not tainted 5.2.0-rc1+ #21
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:sg_assign_page include/linux/scatterlist.h:97 [inline]
> RIP: 0010:sg_set_page include/linux/scatterlist.h:119 [inline]
> RIP: 0010:sk_msg_page_add include/linux/skmsg.h:246 [inline]
> RIP: 0010:tls_sw_do_sendpage net/tls/tls_sw.c:1171 [inline]
> RIP: 0010:tls_sw_sendpage+0xd63/0xf50 net/tls/tls_sw.c:1230
> Code: c6 c0 38 0d 88 4c 89 ef e8 aa 4c 89 fb 0f 0b e8 73 38 61 fb 4d 8d 6c
> 24 ff e9 92 f8 ff ff e8 64 38 61 fb 0f 0b e8 5d 38 61 fb <0f> 0b 45 31 ed e9
> bc fe ff ff e8 4e 38 61 fb 83 85 c4 fe ff ff 01
> RSP: 0018:ffff888091caf8f8 EFLAGS: 00010293
> RAX: ffff8880a659e640 RBX: dffffc0000000000 RCX: ffffffff860f65b3
> RDX: 0000000000000000 RSI: ffffffff860f6c13 RDI: 0000000000000007
> RBP: ffff888091cafa48 R08: ffff8880a659e640 R09: fffff940004cac97
> R10: fffff940004cac96 R11: ffffea00026564b7 R12: 0000000000000004
> R13: 0000000000000001 R14: ffff8880a44f4e88 R15: ffff8880a57a6d00
> FS:  000055555579e880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000009b335000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  inet_sendpage+0x168/0x630 net/ipv4/af_inet.c:819
>  kernel_sendpage+0x92/0xf0 net/socket.c:3648
>  sock_sendpage+0x8b/0xc0 net/socket.c:946
>  pipe_to_sendpage+0x296/0x360 fs/splice.c:448
>  splice_from_pipe_feed fs/splice.c:499 [inline]
>  __splice_from_pipe+0x38c/0x7d0 fs/splice.c:623
>  splice_from_pipe+0x108/0x170 fs/splice.c:658
>  generic_splice_sendpage+0x3c/0x50 fs/splice.c:828
>  do_splice_from fs/splice.c:847 [inline]
>  do_splice+0x708/0x1410 fs/splice.c:1154
>  __do_sys_splice fs/splice.c:1424 [inline]
>  __se_sys_splice fs/splice.c:1404 [inline]
>  __x64_sys_splice+0x2c6/0x330 fs/splice.c:1404
>  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4413e9
> 
> 

This looks like a TLS bug that is still valid.  Can you please look into it?
Here's the same crash from net-next today (commit 19b7e21c55c8):
https://syzkaller.appspot.com/text?tag=CrashReport&x=16380c6ae00000

Thanks,

- Eric
