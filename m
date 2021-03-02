Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262E832B3DB
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840227AbhCCEHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhCBXzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 18:55:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B795064F3E;
        Tue,  2 Mar 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614728406;
        bh=ABt6OaQXxSJrMIjXTxRUKwBVgyxYbL5f4ep+5/xdFyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tkkem2oFlI1G1THjSLzD4GWKMuu6c1oAjs5gVoZiQX4uYNKmDbMiez0y3mIYMdfug
         81ryaxQ+Cvn4hv8vnt0EOR2b6oTbqE/Od33uLrmQiYKvOMAyxj9H2pTM/XoG1tfq9O
         qfhBl8TNnpBuyF/8hpzYUcX7B0aTRFOcEsfd88TDPED8WamgHhBkbh0L5Hd6GrA9K3
         Fadx3KhH4jOmxyjI/KQjIziXyIX+ljcWgtENVaex78BjrH7eySg1uypIdehht7/4er
         oBvK25rSSfu8TBFpGxwBVvHECX/wrP2QuqxaosNeeQENeeaQ1dQzjJ0OM5sb+QH6B1
         xnVSezNHkytmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A594160192;
        Tue,  2 Mar 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] stmmac: intel: Fix mdio bus registration issue for
 TGL-H/ADL-S
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161472840667.3168.1105400631486899998.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Mar 2021 23:40:06 +0000
References: <20210302085721.3168-1-vee.khee.wong@intel.com>
In-Reply-To: <20210302085721.3168-1-vee.khee.wong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        muhammad.husaini.zulkifli@intel.com,
        noor.azura.ahmad.tarmizi@intel.com, weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Mar 2021 16:57:21 +0800 you wrote:
> On Intel platforms which consist of two Ethernet Controllers such as
> TGL-H and ADL-S, a unique MDIO bus id is required for MDIO bus to be
> successful registered:
> 
> [   13.076133] sysfs: cannot create duplicate filename '/class/mdio_bus/stmmac-1'
> [   13.083404] CPU: 8 PID: 1898 Comm: systemd-udevd Tainted: G     U            5.11.0-net-next #106
> [   13.092410] Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-S ADP-S DRR4 CRB, BIOS ADLIFSI1.R00.1494.B00.2012031421 12/03/2020
> [   13.105709] Call Trace:
> [   13.108176]  dump_stack+0x64/0x7c
> [   13.111553]  sysfs_warn_dup+0x56/0x70
> [   13.115273]  sysfs_do_create_link_sd.isra.2+0xbd/0xd0
> [   13.120371]  device_add+0x4df/0x840
> [   13.123917]  ? complete_all+0x2a/0x40
> [   13.127636]  __mdiobus_register+0x98/0x310 [libphy]
> [   13.132572]  stmmac_mdio_register+0x1c5/0x3f0 [stmmac]
> [   13.137771]  ? stmmac_napi_add+0xa5/0xf0 [stmmac]
> [   13.142493]  stmmac_dvr_probe+0x806/0xee0 [stmmac]
> [   13.147341]  intel_eth_pci_probe+0x1cb/0x250 [dwmac_intel]
> [   13.152884]  pci_device_probe+0xd2/0x150
> [   13.156897]  really_probe+0xf7/0x4d0
> [   13.160527]  driver_probe_device+0x5d/0x140
> [   13.164761]  device_driver_attach+0x4f/0x60
> [   13.168996]  __driver_attach+0xa2/0x140
> [   13.172891]  ? device_driver_attach+0x60/0x60
> [   13.177300]  bus_for_each_dev+0x76/0xc0
> [   13.181188]  bus_add_driver+0x189/0x230
> [   13.185083]  ? 0xffffffffc0795000
> [   13.188446]  driver_register+0x5b/0xf0
> [   13.192249]  ? 0xffffffffc0795000
> [   13.195577]  do_one_initcall+0x4d/0x210
> [   13.199467]  ? kmem_cache_alloc_trace+0x2ff/0x490
> [   13.204228]  do_init_module+0x5b/0x21c
> [   13.208031]  load_module+0x2a0c/0x2de0
> [   13.211838]  ? __do_sys_finit_module+0xb1/0x110
> [   13.216420]  __do_sys_finit_module+0xb1/0x110
> [   13.220825]  do_syscall_64+0x33/0x40
> [   13.224451]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   13.229515] RIP: 0033:0x7fc2b1919ccd
> [   13.233113] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 31 0c 00 f7 d8 64 89 01 48
> [   13.251912] RSP: 002b:00007ffcea2e5b98 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   13.259527] RAX: ffffffffffffffda RBX: 0000560558920f10 RCX: 00007fc2b1919ccd
> [   13.266706] RDX: 0000000000000000 RSI: 00007fc2b1a881e3 RDI: 0000000000000012
> [   13.273887] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000000000000000
> [   13.281036] R10: 0000000000000012 R11: 0000000000000246 R12: 00007fc2b1a881e3
> [   13.288183] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffcea2e5d58
> [   13.295389] libphy: mii_bus stmmac-1 failed to register
> 
> [...]

Here is the summary with links:
  - [net,1/1] stmmac: intel: Fix mdio bus registration issue for TGL-H/ADL-S
    https://git.kernel.org/netdev/net/c/fa706dce2f2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


