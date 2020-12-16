Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AEF2DC732
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbgLPTdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388789AbgLPTdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:12 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608145806;
        bh=8yE9/zFyt8wA6oqcl+WWejRFxyyoiO5aqyymwhooz7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPoc3czXDyZ9Moa8xD0i1gNEepmI2KjApi/uE0QCwfyxoDlna55X+OxWvJTy7YnrZ
         lSWJsYbZik1sDfSYrByZwkJN1VE1+/E/zLLy1WYr+1XApINhc2g03wlk81XGxgr9rP
         RTA3sc0y9jVOJQ4/foY2gMwTy2NeqyjYv45VKQlxWHd9rNaxsBxWN/CiMgC5MOJvlJ
         wLdt0aFXpjPzKMkdFF9TWLqbp1MKlxRPIUS3Dnas1gzVq8OznceZEB8yXUDwjAfzqD
         fwERvJuSO1f9eaTjWGC/himhwWbDixSt/0wrCzWb9NsV53l/2t0KAmzDYk8oir0s0e
         iijsEn8iVsD5g==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: qca: ar9331: fix sleeping function called from
 invalid context bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814580686.32605.8279850342805439211.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:10:06 +0000
References: <20201211110317.17061-1-o.rempel@pengutronix.de>
In-Reply-To: <20201211110317.17061-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 11 Dec 2020 12:03:17 +0100 you wrote:
> With lockdep enabled, we will get following warning:
> 
>  ar9331_switch ethernet.1:10 lan0 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:00] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
>  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:935
>  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 18, name: kworker/0:1
>  INFO: lockdep is turned off.
>  irq event stamp: 602
>  hardirqs last  enabled at (601): [<8073fde0>] _raw_spin_unlock_irq+0x3c/0x80
>  hardirqs last disabled at (602): [<8073a4f4>] __schedule+0x184/0x800
>  softirqs last  enabled at (0): [<80080f60>] copy_process+0x578/0x14c8
>  softirqs last disabled at (0): [<00000000>] 0x0
>  CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 5.10.0-rc3-ar9331-00734-g7d644991df0c #31
>  Workqueue: events deferred_probe_work_func
>  Stack : 80980000 80980000 8089ef70 80890000 804b5414 80980000 00000002 80b53728
>          00000000 800d1268 804b5414 ffffffde 00000017 800afe08 81943860 0f5bfc32
>          00000000 00000000 8089ef70 819436c0 ffffffea 00000000 00000000 00000000
>          8194390c 808e353c 0000000f 66657272 80980000 00000000 00000000 80890000
>          804b5414 80980000 00000002 80b53728 00000000 00000000 00000000 80d40000
>          ...
>  Call Trace:
>  [<80069ce0>] show_stack+0x9c/0x140
>  [<800afe08>] ___might_sleep+0x220/0x244
>  [<8073bfb0>] __mutex_lock+0x70/0x374
>  [<8073c2e0>] mutex_lock_nested+0x2c/0x38
>  [<804b5414>] regmap_update_bits_base+0x38/0x8c
>  [<804ee584>] regmap_update_bits+0x1c/0x28
>  [<804ee714>] ar9331_sw_unmask_irq+0x34/0x60
>  [<800d91f0>] unmask_irq+0x48/0x70
>  [<800d93d4>] irq_startup+0x114/0x11c
>  [<800d65b4>] __setup_irq+0x4f4/0x6d0
>  [<800d68a0>] request_threaded_irq+0x110/0x190
>  [<804e3ef0>] phy_request_interrupt+0x4c/0xe4
>  [<804df508>] phylink_bringup_phy+0x2c0/0x37c
>  [<804df7bc>] phylink_of_phy_connect+0x118/0x130
>  [<806c1a64>] dsa_slave_create+0x3d0/0x578
>  [<806bc4ec>] dsa_register_switch+0x934/0xa20
>  [<804eef98>] ar9331_sw_probe+0x34c/0x364
>  [<804eb48c>] mdio_probe+0x44/0x70
>  [<8049e3b4>] really_probe+0x30c/0x4f4
>  [<8049ea10>] driver_probe_device+0x264/0x26c
>  [<8049bc10>] bus_for_each_drv+0xb4/0xd8
>  [<8049e684>] __device_attach+0xe8/0x18c
>  [<8049ce58>] bus_probe_device+0x48/0xc4
>  [<8049db70>] deferred_probe_work_func+0xdc/0xf8
>  [<8009ff64>] process_one_work+0x2e4/0x4a0
>  [<800a0770>] worker_thread+0x2a8/0x354
>  [<800a774c>] kthread+0x16c/0x174
>  [<8006306c>] ret_from_kernel_thread+0x14/0x1c
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: qca: ar9331: fix sleeping function called from invalid context bug
    https://git.kernel.org/netdev/net/c/3e47495fc4de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


