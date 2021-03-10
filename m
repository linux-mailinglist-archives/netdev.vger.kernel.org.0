Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD3F333960
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhCJKEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:04:45 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55018 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231139AbhCJKEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 05:04:39 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lJvha-0002Ru-GW; Wed, 10 Mar 2021 21:04:27 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Mar 2021 21:04:26 +1100
Date:   Wed, 10 Mar 2021 21:04:26 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] macvlan: macvlan_count_rx() needs to be aware of
 preemption
Message-ID: <20210310100426.GA24654@gondor.apana.org.au>
References: <20210310095636.202881-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310095636.202881-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:56:36AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> macvlan_count_rx() can be called from process context, it is thus
> necessary to disable preemption before calling u64_stats_update_begin()
> 
> syzbot was able to spot this on 32bit arch:
> 
> WARNING: CPU: 1 PID: 4632 at include/linux/seqlock.h:271 __seqprop_assert include/linux/seqlock.h:271 [inline]
> WARNING: CPU: 1 PID: 4632 at include/linux/seqlock.h:271 __seqprop_assert.constprop.0+0xf0/0x11c include/linux/seqlock.h:269
> Modules linked in:
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 4632 Comm: kworker/1:3 Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: ARM-Versatile Express
> Workqueue: events macvlan_process_broadcast
> Backtrace:
> [<82740468>] (dump_backtrace) from [<827406dc>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
>  r7:00000080 r6:60000093 r5:00000000 r4:8422a3c4
> [<827406c4>] (show_stack) from [<82751b58>] (__dump_stack lib/dump_stack.c:79 [inline])
> [<827406c4>] (show_stack) from [<82751b58>] (dump_stack+0xb8/0xe8 lib/dump_stack.c:120)
> [<82751aa0>] (dump_stack) from [<82741270>] (panic+0x130/0x378 kernel/panic.c:231)
>  r7:830209b4 r6:84069ea4 r5:00000000 r4:844350d0
> [<82741140>] (panic) from [<80244924>] (__warn+0xb0/0x164 kernel/panic.c:605)
>  r3:8404ec8c r2:00000000 r1:00000000 r0:830209b4
>  r7:0000010f
> [<80244874>] (__warn) from [<82741520>] (warn_slowpath_fmt+0x68/0xd4 kernel/panic.c:628)
>  r7:81363f70 r6:0000010f r5:83018e50 r4:00000000
> [<827414bc>] (warn_slowpath_fmt) from [<81363f70>] (__seqprop_assert include/linux/seqlock.h:271 [inline])
> [<827414bc>] (warn_slowpath_fmt) from [<81363f70>] (__seqprop_assert.constprop.0+0xf0/0x11c include/linux/seqlock.h:269)
>  r8:5a109000 r7:0000000f r6:a568dac0 r5:89802300 r4:00000001
> [<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (u64_stats_update_begin include/linux/u64_stats_sync.h:128 [inline])
> [<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (macvlan_count_rx include/linux/if_macvlan.h:47 [inline])
> [<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (macvlan_broadcast+0x154/0x26c drivers/net/macvlan.c:291)
>  r5:89802300 r4:8a927740
> [<8136499c>] (macvlan_broadcast) from [<81365020>] (macvlan_process_broadcast+0x258/0x2d0 drivers/net/macvlan.c:317)
>  r10:81364f78 r9:8a86d000 r8:8a9c7e7c r7:8413aa5c r6:00000000 r5:00000000
>  r4:89802840
> [<81364dc8>] (macvlan_process_broadcast) from [<802696a4>] (process_one_work+0x2d4/0x998 kernel/workqueue.c:2275)
>  r10:00000008 r9:8404ec98 r8:84367a02 r7:ddfe6400 r6:ddfe2d40 r5:898dac80
>  r4:8a86d43c
> [<802693d0>] (process_one_work) from [<80269dcc>] (worker_thread+0x64/0x54c kernel/workqueue.c:2421)
>  r10:00000008 r9:8a9c6000 r8:84006d00 r7:ddfe2d78 r6:898dac94 r5:ddfe2d40
>  r4:898dac80
> [<80269d68>] (worker_thread) from [<80271f40>] (kthread+0x184/0x1a4 kernel/kthread.c:292)
>  r10:85247e64 r9:898dac80 r8:80269d68 r7:00000000 r6:8a9c6000 r5:89a2ee40
>  r4:8a97bd00
> [<80271dbc>] (kthread) from [<80200114>] (ret_from_fork+0x14/0x20 arch/arm/kernel/entry-common.S:158)
> Exception stack(0x8a9c7fb0 to 0x8a9c7ff8)
> 
> Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  include/linux/if_macvlan.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
