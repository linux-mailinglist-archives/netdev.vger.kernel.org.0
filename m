Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC126364E75
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhDSXK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhDSXKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E1CA613C1;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618873815;
        bh=vzQ9QnuNO52P7Ce9F6gK8HWE8RMuh4kNY3FvdCfekg4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P91NzjyfnyjbIwGT5gPw7AqI5XtsdRdSOnmINievkC32MpnRPndsXcbezkWIupHSV
         Z2IrRNsT2qO6xIIMbeXmlu6+xwxFWdTlqp2RUPTJsJ3t8+4grnzLYs3spb6WUKoDL4
         HFuWNIfuobzo05jlhpycf1PNMiXUv+VOn2noEXZSyTAZu75auFuozbio8WCwnkFyw/
         41d2sCOaO8D/dB9lhxZSib//UucfqNqXKXigSNNMNFAhpC+aFjQjcqdvmQsZP7HlRI
         Rt6SXKjVZXlXDHk6gfLJBlzVX2s0bccPaj1emCdntiVEqcNT7NymLpBJWpimaLxwkv
         SERvqyVKFswjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60DAB60A37;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: fix memory leak during driver probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887381539.661.5024854346370869109.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:10:15 +0000
References: <20210419112530.20395-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210419112530.20395-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 19:25:30 +0800 you wrote:
> On driver probe, kmemleak reported the following memory leak which was
> due to allocated bitmap that was not being freed in stmmac_dvr_probe().
> 
> unreferenced object 0xffff9276014b13c0 (size 8):
>   comm "systemd-udevd", pid 2143, jiffies 4294681112 (age 116.720s)
>   hex dump (first 8 bytes):
>     00 00 00 00 00 00 00 00                          ........
>   backtrace:
>     [<00000000c51e34b2>] stmmac_dvr_probe+0x1c0/0x440 [stmmac]
>     [<00000000b530eb41>] intel_eth_pci_probe.cold+0x2b/0x14e [dwmac_intel]
>     [<00000000b10f8929>] pci_device_probe+0xd2/0x150
>     [<00000000fb254c74>] really_probe+0xf8/0x410
>     [<0000000034128a59>] driver_probe_device+0x5d/0x150
>     [<00000000016104d5>] device_driver_attach+0x53/0x60
>     [<00000000cb18cd07>] __driver_attach+0x96/0x140
>     [<00000000da9ffd5c>] bus_for_each_dev+0x7a/0xc0
>     [<00000000af061a88>] bus_add_driver+0x184/0x1f0
>     [<000000008be5c1c5>] driver_register+0x6c/0xc0
>     [<0000000052b18a9e>] do_one_initcall+0x4d/0x210
>     [<00000000154d4f07>] do_init_module+0x5c/0x230
>     [<000000009b648d09>] load_module+0x2a5a/0x2d40
>     [<000000000d86b76d>] __do_sys_finit_module+0xb5/0x120
>     [<000000002b0cef95>] do_syscall_64+0x33/0x40
>     [<0000000067b45bbb>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: fix memory leak during driver probe
    https://git.kernel.org/netdev/net-next/c/d7f576dc9836

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


