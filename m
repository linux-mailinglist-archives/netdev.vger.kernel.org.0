Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B7F3994B6
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFBUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhFBUlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3523613E9;
        Wed,  2 Jun 2021 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622666403;
        bh=XmuAynM0hvpRQItZ9xBkL6PmdQ/eIq6AizBpJd1B7so=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YRFiAf9691w5eeYVSy6YhuMCy0jAF6ZrSUzWiP9VqhE34nIe/4rQ1oJp8szcOdpaM
         UujtSabHXeCJgcfdwmcZ4UzLUyfigJi63mjNrjAA8RKPj86SbVOQUqQyp42s+INafB
         vCn0B56WnIbsQB7bZjcq++zx0kf6lPqyntc7vBJn1XJtgU8BO2NcWZ1/WuWN2YA+Vn
         MIyWU9hpDqJtQF/P9PYpiRs/4rATqWW4o3L6g1YVtp7eA2StTVrFdCHfGaaTLMhyEy
         7VVHSfmpOY0g83cdY6s6ZF6O/WlWnDv+wg6jPF2ibjTzcUe48r5u015Y5lktdBPY8K
         d2R54kRVivJaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A55D160BFB;
        Wed,  2 Jun 2021 20:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: fix issue where clk is being unprepared
 twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266640367.10923.8870511595725834118.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 20:40:03 +0000
References: <20210602023125.1263950-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210602023125.1263950-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, qiangqing.zhang@nxp.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  2 Jun 2021 10:31:25 +0800 you wrote:
> In the case of MDIO bus registration failure due to no external PHY
> devices is connected to the MAC, clk_disable_unprepare() is called in
> stmmac_bus_clk_config() and intel_eth_pci_probe() respectively.
> 
> The second call in intel_eth_pci_probe() will caused the following:-
> 
> [   16.578605] intel-eth-pci 0000:00:1e.5: No PHY found
> [   16.583778] intel-eth-pci 0000:00:1e.5: stmmac_dvr_probe: MDIO bus (id: 2) registration failed
> [   16.680181] ------------[ cut here ]------------
> [   16.684861] stmmac-0000:00:1e.5 already disabled
> [   16.689547] WARNING: CPU: 13 PID: 2053 at drivers/clk/clk.c:952 clk_core_disable+0x96/0x1b0
> [   16.697963] Modules linked in: dwc3 iTCO_wdt mei_hdcp iTCO_vendor_support udc_core x86_pkg_temp_thermal kvm_intel marvell10g kvm sch_fq_codel nfsd irqbypass dwmac_intel(+) stmmac uio ax88179_178a pcs_xpcs phylink uhid spi_pxa2xx_platform usbnet mei_me pcspkr tpm_crb mii i2c_i801 dw_dmac dwc3_pci thermal dw_dmac_core intel_rapl_msr libphy i2c_smbus mei tpm_tis intel_th_gth tpm_tis_core tpm intel_th_acpi intel_pmc_core intel_th i915 fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
> [   16.746785] CPU: 13 PID: 2053 Comm: systemd-udevd Tainted: G     U            5.13.0-rc3-intel-lts #76
> [   16.756134] Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-S ADP-S DRR4 CRB, BIOS ADLIFSI1.R00.1494.B00.2012031421 12/03/2020
> [   16.769465] RIP: 0010:clk_core_disable+0x96/0x1b0
> [   16.774222] Code: 00 8b 05 45 96 17 01 85 c0 7f 24 48 8b 5b 30 48 85 db 74 a5 8b 43 7c 85 c0 75 93 48 8b 33 48 c7 c7 6e 32 cc b7 e8 b2 5d 52 00 <0f> 0b 5b 5d c3 65 8b 05 76 31 18 49 89 c0 48 0f a3 05 bc 92 1a 01
> [   16.793016] RSP: 0018:ffffa44580523aa0 EFLAGS: 00010086
> [   16.798287] RAX: 0000000000000000 RBX: ffff8d7d0eb70a00 RCX: 0000000000000000
> [   16.805435] RDX: 0000000000000002 RSI: ffffffffb7c62d5f RDI: 00000000ffffffff
> [   16.812610] RBP: 0000000000000287 R08: 0000000000000000 R09: ffffa445805238d0
> [   16.819759] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8d7d0eb70a00
> [   16.826904] R13: ffff8d7d027370c8 R14: 0000000000000006 R15: ffffa44580523ad0
> [   16.834047] FS:  00007f9882fa2600(0000) GS:ffff8d80a0940000(0000) knlGS:0000000000000000
> [   16.842177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.847966] CR2: 00007f9882bea3d8 CR3: 000000010b126001 CR4: 0000000000370ee0
> [   16.855144] Call Trace:
> [   16.857614]  clk_core_disable_lock+0x1b/0x30
> [   16.861941]  intel_eth_pci_probe.cold+0x11d/0x136 [dwmac_intel]
> [   16.867913]  pci_device_probe+0xcf/0x150
> [   16.871890]  really_probe+0xf5/0x3e0
> [   16.875526]  driver_probe_device+0x64/0x150
> [   16.879763]  device_driver_attach+0x53/0x60
> [   16.883998]  __driver_attach+0x9f/0x150
> [   16.887883]  ? device_driver_attach+0x60/0x60
> [   16.892288]  ? device_driver_attach+0x60/0x60
> [   16.896698]  bus_for_each_dev+0x77/0xc0
> [   16.900583]  bus_add_driver+0x184/0x1f0
> [   16.904469]  driver_register+0x6c/0xc0
> [   16.908268]  ? 0xffffffffc07ae000
> [   16.911598]  do_one_initcall+0x4a/0x210
> [   16.915489]  ? kmem_cache_alloc_trace+0x305/0x4e0
> [   16.920247]  do_init_module+0x5c/0x230
> [   16.924057]  load_module+0x2894/0x2b70
> [   16.927857]  ? __do_sys_finit_module+0xb5/0x120
> [   16.932441]  __do_sys_finit_module+0xb5/0x120
> [   16.936845]  do_syscall_64+0x42/0x80
> [   16.940476]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   16.945586] RIP: 0033:0x7f98830e5ccd
> [   16.949177] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 31 0c 00 f7 d8 64 89 01 48
> [   16.967970] RSP: 002b:00007ffc66b60168 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   16.975583] RAX: ffffffffffffffda RBX: 000055885de35ef0 RCX: 00007f98830e5ccd
> [   16.982725] RDX: 0000000000000000 RSI: 00007f98832541e3 RDI: 0000000000000012
> [   16.989868] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000000000000000
> [   16.997042] R10: 0000000000000012 R11: 0000000000000246 R12: 00007f98832541e3
> [   17.004222] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffc66b60328
> [   17.011369] ---[ end trace df06a3dab26b988c ]---
> [   17.016062] ------------[ cut here ]------------
> [   17.020701] stmmac-0000:00:1e.5 already unprepared
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: fix issue where clk is being unprepared twice
    https://git.kernel.org/netdev/net/c/ab00f3e051e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


