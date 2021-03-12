Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E9D338396
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhCLCaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhCLCaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B040464F91;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615516215;
        bh=8E6sU0LnweLIbQgKpvMYPT+z10uZzmOr5ZiEdlS1IVA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LDV/jka2iy3f2izicescFmjG/neCQw6MFXHyeZLFf5Gg9YbwVhXYhRWOKMCLrF2Qn
         i0s8K/ZNTADrMsu6OvaLmGqL3Lwm9/Vh5YO11NA7zUMTXxST+ZqeKXeJNL1Bd3ONy+
         SJnrDI29wll1nLMue18FBjNujqx3icwtES7S8DoPuNmtnAeIG1jkSf7QAqgV0pCIl1
         nWbNEf2PVuJsA5HJEtcm2PE3kInYivcWTt69lrEK0qrCME3g3B9pjM+kSkRnjCG2Mv
         /WkGPTwHJHrwmqyCs4uJLvr9OcWUizz/Jg7iIKWTxsz7hKYmD/j9DeL6Fe2569wfHl
         7BB23rsNAnThA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A76B1609E7;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mISDN: fix crash in fritzpci
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161551621568.2118.5359755247201765154.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 02:30:15 +0000
References: <20210311042736.2062228-1-ztong0001@gmail.com>
In-Reply-To: <20210311042736.2062228-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 23:27:35 -0500 you wrote:
> setup_fritz() in avmfritz.c might fail with -EIO and in this case the
> isac.type and isac.write_reg is not initialized and remains 0(NULL).
> A subsequent call to isac_release() will dereference isac->write_reg and
> crash.
> 
> [    1.737444] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [    1.737809] #PF: supervisor instruction fetch in kernel mode
> [    1.738106] #PF: error_code(0x0010) - not-present page
> [    1.738378] PGD 0 P4D 0
> [    1.738515] Oops: 0010 [#1] SMP NOPTI
> [    1.738711] CPU: 0 PID: 180 Comm: systemd-udevd Not tainted 5.12.0-rc2+ #78
> [    1.739077] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-p
> rebuilt.qemu.org 04/01/2014
> [    1.739664] RIP: 0010:0x0
> [    1.739807] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> [    1.740200] RSP: 0018:ffffc9000027ba10 EFLAGS: 00010202
> [    1.740478] RAX: 0000000000000000 RBX: ffff888102f41840 RCX: 0000000000000027
> [    1.740853] RDX: 00000000000000ff RSI: 0000000000000020 RDI: ffff888102f41800
> [    1.741226] RBP: ffffc9000027ba20 R08: ffff88817bc18440 R09: ffffc9000027b808
> [    1.741600] R10: 0000000000000001 R11: 0000000000000001 R12: ffff888102f41840
> [    1.741976] R13: 00000000fffffffb R14: ffff888102f41800 R15: ffff8881008b0000
> [    1.742351] FS:  00007fda3a38a8c0(0000) GS:ffff88817bc00000(0000) knlGS:0000000000000000
> [    1.742774] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.743076] CR2: ffffffffffffffd6 CR3: 00000001021ec000 CR4: 00000000000006f0
> [    1.743452] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    1.743828] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    1.744206] Call Trace:
> [    1.744339]  isac_release+0xcc/0xe0 [mISDNipac]
> [    1.744582]  fritzpci_probe.cold+0x282/0x739 [avmfritz]
> [    1.744861]  local_pci_probe+0x48/0x80
> [    1.745063]  pci_device_probe+0x10f/0x1c0
> [    1.745278]  really_probe+0xfb/0x420
> [    1.745471]  driver_probe_device+0xe9/0x160
> [    1.745693]  device_driver_attach+0x5d/0x70
> [    1.745917]  __driver_attach+0x8f/0x150
> [    1.746123]  ? device_driver_attach+0x70/0x70
> [    1.746354]  bus_for_each_dev+0x7e/0xc0
> [    1.746560]  driver_attach+0x1e/0x20
> [    1.746751]  bus_add_driver+0x152/0x1f0
> [    1.746957]  driver_register+0x74/0xd0
> [    1.747157]  ? 0xffffffffc00d8000
> [    1.747334]  __pci_register_driver+0x54/0x60
> [    1.747562]  AVM_init+0x36/0x1000 [avmfritz]
> [    1.747791]  do_one_initcall+0x48/0x1d0
> [    1.747997]  ? __cond_resched+0x19/0x30
> [    1.748206]  ? kmem_cache_alloc_trace+0x390/0x440
> [    1.748458]  ? do_init_module+0x28/0x250
> [    1.748669]  do_init_module+0x62/0x250
> [    1.748870]  load_module+0x23ee/0x26a0
> [    1.749073]  __do_sys_finit_module+0xc2/0x120
> [    1.749307]  ? __do_sys_finit_module+0xc2/0x120
> [    1.749549]  __x64_sys_finit_module+0x1a/0x20
> [    1.749782]  do_syscall_64+0x38/0x90
> 
> [...]

Here is the summary with links:
  - mISDN: fix crash in fritzpci
    https://git.kernel.org/netdev/net/c/a9f81244d2e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


