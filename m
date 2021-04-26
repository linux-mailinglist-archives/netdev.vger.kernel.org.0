Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8B236BAC9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhDZUk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhDZUkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 16:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3540D60FD7;
        Mon, 26 Apr 2021 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619469609;
        bh=Yr7A+Fs6o6nhaRuOxvveP/jo5nAp8hYmSQ4YqUw0oCQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lwrl5Sq+Oo1n7ioRzlYdftXSn7om7MgsqR7mQe0sQ8ryxsdGQZeKeUvPmc2O2gsTA
         VHlPr7LaJ8EID8MyZ/XjvfeO2ZO1Zcwnx0sCEJbZ1FYj29D984C9RTQ/LnEBCise9P
         rTS4XjxzwgKz4iiZPF4tXh0FirWOaMYZc9vrHR7a4YnVjuxnxzJj6ZlsfI0nx6CrXV
         gd02l5cm65sRK4twP+H8Zmn4ClV7nFdH2cu8k/rghoYmb7cJgYtrJq+nnZ1cR/s03Z
         ChR1z6ESQk0DrB5XV9EHd0iwqab2bTJ7cK6WcX97bu7JhBpOaTF7/V6JGfE3n9mcMR
         p6Rg9fdOtcmYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 29EF560A09;
        Mon, 26 Apr 2021 20:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ct: fix wild memory access when clearing
 fragments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946960916.8317.10070114864783131903.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 20:40:09 +0000
References: <a72b5a4239942c5cc0152e4efba17b544a8a19fb.1619450967.git.dcaratti@redhat.com>
In-Reply-To: <a72b5a4239942c5cc0152e4efba17b544a8a19fb.1619450967.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, wenxu@ucloud.cn,
        marcelo.leitner@gmail.com, shuali@redhat.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 17:45:51 +0200 you wrote:
> while testing re-assembly/re-fragmentation using act_ct, it's possible to
> observe a crash like the following one:
> 
>  KASAN: maybe wild-memory-access in range [0x0001000000000448-0x000100000000044f]
>  CPU: 50 PID: 0 Comm: swapper/50 Tainted: G S                5.12.0-rc7+ #424
>  Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/17/2017
>  RIP: 0010:inet_frag_rbtree_purge+0x50/0xc0
>  Code: 00 fc ff df 48 89 c3 31 ed 48 89 df e8 a9 7a 38 ff 4c 89 fe 48 89 df 49 89 c6 e8 5b 3a 38 ff 48 8d 7b 40 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00 75 59 48 8d bb d0 00 00 00 4c 8b 6b 40 48 89 f8 48
>  RSP: 0018:ffff888c31449db8 EFLAGS: 00010203
>  RAX: 0000200000000089 RBX: 000100000000040e RCX: ffffffff989eb960
>  RDX: 0000000000000140 RSI: ffffffff97cfb977 RDI: 000100000000044e
>  RBP: 0000000000000900 R08: 0000000000000000 R09: ffffed1186289350
>  R10: 0000000000000003 R11: ffffed1186289350 R12: dffffc0000000000
>  R13: 000100000000040e R14: 0000000000000000 R15: ffff888155e02160
>  FS:  0000000000000000(0000) GS:ffff888c31440000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00005600cb70a5b8 CR3: 0000000a2c014005 CR4: 00000000003706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   <IRQ>
>   inet_frag_destroy+0xa9/0x150
>   call_timer_fn+0x2d/0x180
>   run_timer_softirq+0x4fe/0xe70
>   __do_softirq+0x197/0x5a0
>   irq_exit_rcu+0x1de/0x200
>   sysvec_apic_timer_interrupt+0x6b/0x80
>   </IRQ>
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ct: fix wild memory access when clearing fragments
    https://git.kernel.org/netdev/net-next/c/f77bd544a6bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


