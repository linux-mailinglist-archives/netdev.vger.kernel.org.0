Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C149145F552
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbhKZTox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhKZTmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:42:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFE2C0619D9
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 11:20:11 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F7162344
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 19:20:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id CD0226024A;
        Fri, 26 Nov 2021 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637954409;
        bh=qGjAjFd9rplbhys+kc4gbE0xZB+4QvJdfIMx24ZcvME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=taPaF7wjR98XqsYcENXJyvOnt3B8Bsv8Ma/J1wLKg8OhQZ2ZsmdALLUpDq0k56SPI
         MjTcR9TczvgcqgwtMm+6sf21eqWxpusBgt6SKbIckWnNUXEDzIq5njKOSItwAfNuxO
         1ITDIaU3u2BzGC4/Y0X7IJsyeBZBiP5vzHLg+RMALRTMLCAEYR2J6dPLVOYJaEGf70
         naFO/2I/UvYrnJlTxpaGw+Tvep8nW5wvB8vn7E3odgCABezNsvYgSJX7Hr3/lF1+y3
         SjYYNEbLgSAfEYrjoEarcVClRAfEOAQ2LGgPZudrOImVsB4CMDVXhd3zJFDfw/9GrH
         wuLxRt52AviUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B523460A6C;
        Fri, 26 Nov 2021 19:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/sched: sch_ets: don't peek at classes beyond
 'nbands'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795440973.10734.11582564628861963797.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:20:09 +0000
References: <7a5c496eed2d62241620bdbb83eb03fb9d571c99.1637762721.git.dcaratti@redhat.com>
In-Reply-To: <7a5c496eed2d62241620bdbb83eb03fb9d571c99.1637762721.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, petrm@mellanox.com,
        netdev@vger.kernel.org, liuhangbin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 17:14:40 +0100 you wrote:
> when the number of DRR classes decreases, the round-robin active list can
> contain elements that have already been freed in ets_qdisc_change(). As a
> consequence, it's possible to see a NULL dereference crash, caused by the
> attempt to call cl->qdisc->ops->peek(cl->qdisc) when cl->qdisc is NULL:
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000018
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] PREEMPT SMP NOPTI
>  CPU: 1 PID: 910 Comm: mausezahn Not tainted 5.16.0-rc1+ #475
>  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
>  RIP: 0010:ets_qdisc_dequeue+0x129/0x2c0 [sch_ets]
>  Code: c5 01 41 39 ad e4 02 00 00 0f 87 18 ff ff ff 49 8b 85 c0 02 00 00 49 39 c4 0f 84 ba 00 00 00 49 8b ad c0 02 00 00 48 8b 7d 10 <48> 8b 47 18 48 8b 40 38 0f ae e8 ff d0 48 89 c3 48 85 c0 0f 84 9d
>  RSP: 0000:ffffbb36c0b5fdd8 EFLAGS: 00010287
>  RAX: ffff956678efed30 RBX: 0000000000000000 RCX: 0000000000000000
>  RDX: 0000000000000002 RSI: ffffffff9b938dc9 RDI: 0000000000000000
>  RBP: ffff956678efed30 R08: e2f3207fe360129c R09: 0000000000000000
>  R10: 0000000000000001 R11: 0000000000000001 R12: ffff956678efeac0
>  R13: ffff956678efe800 R14: ffff956611545000 R15: ffff95667ac8f100
>  FS:  00007f2aa9120740(0000) GS:ffff95667b800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000018 CR3: 000000011070c000 CR4: 0000000000350ee0
>  Call Trace:
>   <TASK>
>   qdisc_peek_dequeued+0x29/0x70 [sch_ets]
>   tbf_dequeue+0x22/0x260 [sch_tbf]
>   __qdisc_run+0x7f/0x630
>   net_tx_action+0x290/0x4c0
>   __do_softirq+0xee/0x4f8
>   irq_exit_rcu+0xf4/0x130
>   sysvec_apic_timer_interrupt+0x52/0xc0
>   asm_sysvec_apic_timer_interrupt+0x12/0x20
>  RIP: 0033:0x7f2aa7fc9ad4
>  Code: b9 ff ff 48 8b 54 24 18 48 83 c4 08 48 89 ee 48 89 df 5b 5d e9 ed fc ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa <53> 48 83 ec 10 48 8b 05 10 64 33 00 48 8b 00 48 85 c0 0f 85 84 00
>  RSP: 002b:00007ffe5d33fab8 EFLAGS: 00000202
>  RAX: 0000000000000002 RBX: 0000561f72c31460 RCX: 0000561f72c31720
>  RDX: 0000000000000002 RSI: 0000561f72c31722 RDI: 0000561f72c31720
>  RBP: 000000000000002a R08: 00007ffe5d33fa40 R09: 0000000000000014
>  R10: 0000000000000000 R11: 0000000000000246 R12: 0000561f7187e380
>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000561f72c31460
>   </TASK>
>  Modules linked in: sch_ets sch_tbf dummy rfkill iTCO_wdt intel_rapl_msr iTCO_vendor_support intel_rapl_common joydev virtio_balloon lpc_ich i2c_i801 i2c_smbus pcspkr ip_tables xfs libcrc32c crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci ghash_clmulni_intel serio_raw libata virtio_blk virtio_console virtio_net net_failover failover sunrpc dm_mirror dm_region_hash dm_log dm_mod
>  CR2: 0000000000000018
> 
> [...]

Here is the summary with links:
  - [net,v3] net/sched: sch_ets: don't peek at classes beyond 'nbands'
    https://git.kernel.org/netdev/net/c/de6d25924c2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


