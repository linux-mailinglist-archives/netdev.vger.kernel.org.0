Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7644218CB
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 22:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhJDU4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 16:56:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:30197 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhJDU4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 16:56:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="311797383"
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="311797383"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 13:54:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="711581783"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga006.fm.intel.com with ESMTP; 04 Oct 2021 13:54:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: properly cancel timer from
 taprio_destroy()
In-Reply-To: <20211004195522.2041705-1-eric.dumazet@gmail.com>
References: <20211004195522.2041705-1-eric.dumazet@gmail.com>
Date:   Mon, 04 Oct 2021 13:55:11 -0700
Message-ID: <875yuc33yo.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> There is a comment in qdisc_create() about us not calling ops->reset()
> in some cases.
>
> err_out4:
> 	/*
> 	 * Any broken qdiscs that would require a ops->reset() here?
> 	 * The qdisc was never in action so it shouldn't be necessary.
> 	 */
>
> As taprio sets a timer before actually receiving a packet, we need
> to cancel it from ops->destroy, just in case ops->reset has not
> been called.
>
> syzbot reported:
>
> ODEBUG: free active (active state 0) object type: hrtimer hint: advance_sched+0x0/0x9a0 arch/x86/include/asm/atomic64_64.h:22
> WARNING: CPU: 0 PID: 8441 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Modules linked in:
> CPU: 0 PID: 8441 Comm: syz-executor813 Not tainted 5.14.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd e0 d3 e3 89 4c 89 ee 48 c7 c7 e0 c7 e3 89 e8 5b 86 11 05 <0f> 0b 83 05 85 03 92 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> RSP: 0018:ffffc9000130f330 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffff88802baeb880 RSI: ffffffff815d87b5 RDI: fffff52000261e58
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815d25ee R11: 0000000000000000 R12: ffffffff898dd020
> R13: ffffffff89e3ce20 R14: ffffffff81653630 R15: dffffc0000000000
> FS:  0000000000f0d300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffb64b3e000 CR3: 0000000036557000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __debug_check_no_obj_freed lib/debugobjects.c:987 [inline]
>  debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1018
>  slab_free_hook mm/slub.c:1603 [inline]
>  slab_free_freelist_hook+0x171/0x240 mm/slub.c:1653
>  slab_free mm/slub.c:3213 [inline]
>  kfree+0xe4/0x540 mm/slub.c:4267
>  qdisc_create+0xbcf/0x1320 net/sched/sch_api.c:1299
>  tc_modify_qdisc+0x4c8/0x1a60 net/sched/sch_api.c:1663
>  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>
> Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Davide Caratti <dcaratti@redhat.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


-- 
Vinicius
