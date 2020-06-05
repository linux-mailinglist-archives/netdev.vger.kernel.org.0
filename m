Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087621EF01B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 05:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgFEDz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 23:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgFEDz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 23:55:58 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E89D52074B;
        Fri,  5 Jun 2020 03:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591329357;
        bh=6t0M3zFZVF+jZAsXowaGuunNSqX7ly6WswrQPRMr1Bw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yneYV/PRIdEyxazGndKrJSWENlyqxOjFhyvutnMSdyLbNmqPQzScN/o1F5ArFJcyS
         I42pKIMoQruGkhM2bkEcaGvr8BmLKhLEBRfxqTxyU4EvXaH/TOgxUWpWloWrFjjIwa
         AUxixT0aEIw5HVPy8FK0guOa2jU7ZioTGJZDb9hw=
Date:   Thu, 4 Jun 2020 20:55:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>,
        bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: BUG: using smp_processor_id() in preemptible code in
 radix_tree_node_alloc
Message-ID: <20200605035555.GA2667@sol.localdomain>
References: <000000000000a363b205a74ca6a2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a363b205a74ca6a2@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+Cc Matthew Wilcox]

Possibly a bug in lib/radix-tree.c?  this_cpu_ptr() in radix_tree_node_alloc()
can be reached without a prior preempt_disable().  Or is the caller of
idr_alloc() doing something wrong?

On Thu, Jun 04, 2020 at 07:02:18PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    acf25aa6 Merge tag 'Smack-for-5.8' of git://github.com/csc..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d6307a100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5263d9b5bce03c67
> dashboard link: https://syzkaller.appspot.com/bug?extid=3eec59e770685e3dc879
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd4c1e100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1520c9de100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> 
> RAX: ffffffffffffffda RBX: 00007ffdf01d56d0 RCX: 00000000004406c9
> RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
> RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000000031
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401f50
> R13: 0000000000401fe0 R14: 0000000000000000 R15: 0000000000000000
> BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor036/6796
> caller is radix_tree_node_alloc.constprop.0+0x200/0x330 lib/radix-tree.c:262
> CPU: 0 PID: 6796 Comm: syz-executor036 Not tainted 5.7.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>  debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
>  radix_tree_node_alloc.constprop.0+0x200/0x330 lib/radix-tree.c:262
>  radix_tree_extend+0x256/0x4e0 lib/radix-tree.c:424
>  idr_get_free+0x60c/0x8e0 lib/radix-tree.c:1492
>  idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
>  idr_alloc+0xc2/0x130 lib/idr.c:87
>  qrtr_port_assign net/qrtr/qrtr.c:703 [inline]
>  __qrtr_bind.isra.0+0x12e/0x5c0 net/qrtr/qrtr.c:756
>  qrtr_autobind net/qrtr/qrtr.c:787 [inline]
>  qrtr_autobind+0xaf/0xf0 net/qrtr/qrtr.c:775
>  qrtr_sendmsg+0x1d6/0x770 net/qrtr/qrtr.c:895
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2406
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x4406c9
> Code: 25 02 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffdf01d56c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ffdf01d56d0 RCX: 00000000004406c9
> RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
> RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000000031
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401f50
> R13: 0000000000401fe0 R14: 0000000000000000 R15: 0000000000000000
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
