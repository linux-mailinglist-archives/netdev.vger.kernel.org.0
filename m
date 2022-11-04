Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A7E6194FC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiKDLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiKDLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F6E1131;
        Fri,  4 Nov 2022 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43551B82CF6;
        Fri,  4 Nov 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAC49C433D6;
        Fri,  4 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559616;
        bh=zneFbejEW9LBYhxS4d3DAaEVbLOG6uSiFCMXfhmbaFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FkUDa8JJEdc4TM7yU6n69aYK6MRBcgZEvKao9u9ygTBiIsNRJDnYJ4TooOdzPFQwj
         k5mAv2BpkhCNHVSAx6NylvPbsl/MabaK5EQaTrnYZfIJVrWqtgcNGdLddoFPFOgF1V
         +6anezI86w6WqOucXlBY6vBsabX25mXrEPWWvtg4IIpD/v5s9pjr82nk38ZaiLNdOq
         A2Dw2kSsfZN0sTobq/PT86eztC7A2mX08bZfnaspS9JXuBasjqDUqQMKGpQCcX+fb2
         LWN/cvsAdUH8MBNUb9lNMYYQ9+aGMJXRVj6yMjVcU8YugCbkORBaAR/dHxWC8K/OY0
         /fJ+ivuXyvQtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8701E270FB;
        Fri,  4 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: Fix segmentation fault at
 module unload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755961675.11617.10498696959613868503.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 11:00:16 +0000
References: <20221102103144.12022-1-rogerq@kernel.org>
In-Reply-To: <20221102103144.12022-1-rogerq@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, s-vadapalli@ti.com,
        vigneshr@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Nov 2022 12:31:44 +0200 you wrote:
> Move am65_cpsw_nuss_phylink_cleanup() call to after
> am65_cpsw_nuss_cleanup_ndev() so phylink is still valid
> to prevent the below Segmentation fault on module remove when
> first slave link is up.
> 
> [   31.652944] Unable to handle kernel paging request at virtual address 00040008000005f4
> [   31.684627] Mem abort info:
> [   31.687446]   ESR = 0x0000000096000004
> [   31.704614]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   31.720663]   SET = 0, FnV = 0
> [   31.723729]   EA = 0, S1PTW = 0
> [   31.740617]   FSC = 0x04: level 0 translation fault
> [   31.756624] Data abort info:
> [   31.759508]   ISV = 0, ISS = 0x00000004
> [   31.776705]   CM = 0, WnR = 0
> [   31.779695] [00040008000005f4] address between user and kernel address ranges
> [   31.808644] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> [   31.814928] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 libarc4 cfg80211 rfkill crct10dif_ce phy_gmii_sel ti_am65_cpsw_nuss(-) sch_fq_codel ipv6
> [   31.828776] CPU: 0 PID: 1026 Comm: modprobe Not tainted 6.1.0-rc2-00012-gfabfcf7dafdb-dirty #160
> [   31.837547] Hardware name: Texas Instruments AM625 (DT)
> [   31.842760] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   31.849709] pc : phy_stop+0x18/0xf8
> [   31.853202] lr : phylink_stop+0x38/0xf8
> [   31.857031] sp : ffff80000a0839f0
> [   31.860335] x29: ffff80000a0839f0 x28: ffff000000de1c80 x27: 0000000000000000
> [   31.867462] x26: 0000000000000000 x25: 0000000000000000 x24: ffff80000a083b98
> [   31.874589] x23: 0000000000000800 x22: 0000000000000001 x21: ffff000001bfba90
> [   31.881715] x20: ffff0000015ee000 x19: 0004000800000200 x18: 0000000000000000
> [   31.888842] x17: ffff800076c45000 x16: ffff800008004000 x15: 000058e39660b106
> [   31.895969] x14: 0000000000000144 x13: 0000000000000144 x12: 0000000000000000
> [   31.903095] x11: 000000000000275f x10: 00000000000009e0 x9 : ffff80000a0837d0
> [   31.910222] x8 : ffff000000de26c0 x7 : ffff00007fbd6540 x6 : ffff00007fbd64c0
> [   31.917349] x5 : ffff00007fbd0b10 x4 : ffff00007fbd0b10 x3 : ffff00007fbd3920
> [   31.924476] x2 : d0a07fcff8b8d500 x1 : 0000000000000000 x0 : 0004000800000200
> [   31.931603] Call trace:
> [   31.934042]  phy_stop+0x18/0xf8
> [   31.937177]  phylink_stop+0x38/0xf8
> [   31.940657]  am65_cpsw_nuss_ndo_slave_stop+0x28/0x1e0 [ti_am65_cpsw_nuss]
> [   31.947452]  __dev_close_many+0xa4/0x140
> [   31.951371]  dev_close_many+0x84/0x128
> [   31.955115]  unregister_netdevice_many+0x130/0x6d0
> [   31.959897]  unregister_netdevice_queue+0x94/0xd8
> [   31.964591]  unregister_netdev+0x24/0x38
> [   31.968504]  am65_cpsw_nuss_cleanup_ndev.isra.0+0x48/0x70 [ti_am65_cpsw_nuss]
> [   31.975637]  am65_cpsw_nuss_remove+0x58/0xf8 [ti_am65_cpsw_nuss]
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw: Fix segmentation fault at module unload
    https://git.kernel.org/netdev/net/c/1a0c016a4831

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


