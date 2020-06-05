Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECFC1EF027
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 06:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFEEGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 00:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgFEEGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 00:06:08 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707BD20738;
        Fri,  5 Jun 2020 04:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591329967;
        bh=C9y2n9lFDA6FBJxdno1XJNGe5jOYfBYcSITJkIxJtYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1r4NSGDSyOrLnpclI3deDQihcLGg6oWadLtmlEc/solN908H2EKx2JqcsZ09Vzkr+
         dK407a9jccUE7dQrM2nI4qXm1BxPgvDyiiU/fAvxzfCd3ziFRSbOddwYJeW+rzfYDH
         fa1SCDfd8TYPMPncDNs3+5Df4u67HeKcz8ZMorpg=
Date:   Thu, 4 Jun 2020 21:06:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+9e0b179ae55eaf7a307a@syzkaller.appspotmail.com>
Cc:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: BUG: using smp_processor_id() in preemptible code in
 debug_smp_processor_id
Message-ID: <20200605040606.GC2667@sol.localdomain>
References: <000000000000c4abec05a7432666@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c4abec05a7432666@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 07:42:18AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    065fcfd4 selftests: net: ip_defrag: ignore EPERM
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c3e516100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d89141553e61b775
> dashboard link: https://syzkaller.appspot.com/bug?extid=9e0b179ae55eaf7a307a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131b5cf2100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176dfcf2100000
> 
> The bug was bisected to:
> 
> commit e42671084361302141a09284fde9bbc14fdd16bf
> Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Date:   Thu May 7 12:53:06 2020 +0000
> 
>     net: qrtr: Do not depend on ARCH_QCOM
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1295eb91100000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1195eb91100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1695eb91100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9e0b179ae55eaf7a307a@syzkaller.appspotmail.com
> Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")
> 
> RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000004
> RBP: 00000000006cb018 R08: 0000000000000001 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e90
> R13: 0000000000401f20 R14: 0000000000000000 R15: 0000000000000000
> BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor013/7182
> caller is radix_tree_node_alloc.constprop.0+0x200/0x330 lib/radix-tree.c:264
> CPU: 0 PID: 7182 Comm: syz-executor013 Not tainted 5.7.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>  debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
>  radix_tree_node_alloc.constprop.0+0x200/0x330 lib/radix-tree.c:264
>  radix_tree_extend+0x234/0x4a0 lib/radix-tree.c:426
>  idr_get_free+0x60c/0x8e0 lib/radix-tree.c:1494
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
> RIP: 0033:0x4405a9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 14 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe905331b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004a1bd8 RCX: 00000000004405a9
> RDX: 0000000000000000 RSI: 00000000

#syz dup: BUG: using smp_processor_id() in preemptible code in radix_tree_node_alloc

See discussion at https://lkml.kernel.org/lkml/000000000000a363b205a74ca6a2@google.com/T/#u
