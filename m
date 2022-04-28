Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8073151285B
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbiD1BDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239615AbiD1BDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D190BB86B
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81F1361F33
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97114C385A9;
        Thu, 28 Apr 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651107612;
        bh=tUtSKRYBje0jib+z9T3U7cVvex6rmivNxerIBNejZbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LiMm+lOvVcuSKeB5AaBccELWpPdTUIIwCxPfSOx81A9cSPUCth9+ACRKujDDMlGiU
         0qXbB+glqhwNMg/UG+rPprx0z5xL7OB9FCokgKREiXtOucS8qs8LAi+LXWx8e/Ttbc
         KCdV8611S+SGCaX+sFv7G4JLLr4b+DRtylITk5I5hGs9zVYjxTeq4d+4FTy4TwubKJ
         Iv+tHr+BliHrLQgCKnyyIYUUv3voEr2i/KTTTF2aNaRJ+G7A5YZLY0gzFIpPrHxcBZ
         bzzyySPrGr4eUqMakV8cR4x7/d9GnOp/oHAfyoKGMSaxYeCF4ON1qAPPju51hPDS1S
         WVdQauOsWINEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75248F03840;
        Thu, 28 Apr 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnx2x: fix napi API usage sequence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165110761247.23759.5826870759764197211.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 01:00:12 +0000
References: <20220426153913.6966-1-manishc@marvell.com>
In-Reply-To: <20220426153913.6966-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, drc@linux.vnet.ibm.com, netdev@vger.kernel.org,
        aelior@marvell.com, davem@davemloft.net
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Apr 2022 08:39:13 -0700 you wrote:
> While handling PCI errors (AER flow) driver tries to
> disable NAPI [napi_disable()] after NAPI is deleted
> [__netif_napi_del()] which causes unexpected system
> hang/crash.
> 
> System message log shows the following:
> =======================================
> [ 3222.537510] EEH: Detected PCI bus error on PHB#384-PE#800000 [ 3222.537511] EEH: This PCI device has failed 2 times in the last hour and will be permanently disabled after 5 failures.
> [ 3222.537512] EEH: Notify device drivers to shutdown [ 3222.537513] EEH: Beginning: 'error_detected(IO frozen)'
> [ 3222.537514] EEH: PE#800000 (PCI 0384:80:00.0): Invoking
> bnx2x->error_detected(IO frozen)
> [ 3222.537516] bnx2x: [bnx2x_io_error_detected:14236(eth14)]IO error detected [ 3222.537650] EEH: PE#800000 (PCI 0384:80:00.0): bnx2x driver reports:
> 'need reset'
> [ 3222.537651] EEH: PE#800000 (PCI 0384:80:00.1): Invoking
> bnx2x->error_detected(IO frozen)
> [ 3222.537651] bnx2x: [bnx2x_io_error_detected:14236(eth13)]IO error detected [ 3222.537729] EEH: PE#800000 (PCI 0384:80:00.1): bnx2x driver reports:
> 'need reset'
> [ 3222.537729] EEH: Finished:'error_detected(IO frozen)' with aggregate recovery state:'need reset'
> [ 3222.537890] EEH: Collect temporary log [ 3222.583481] EEH: of node=0384:80:00.0 [ 3222.583519] EEH: PCI device/vendor: 168e14e4 [ 3222.583557] EEH: PCI cmd/status register: 00100140 [ 3222.583557] EEH: PCI-E capabilities and status follow:
> [ 3222.583744] EEH: PCI-E 00: 00020010 012c8da2 00095d5e 00455c82 [ 3222.583892] EEH: PCI-E 10: 10820000 00000000 00000000 00000000 [ 3222.583893] EEH: PCI-E 20: 00000000 [ 3222.583893] EEH: PCI-E AER capability register set follows:
> [ 3222.584079] EEH: PCI-E AER 00: 13c10001 00000000 00000000 00062030 [ 3222.584230] EEH: PCI-E AER 10: 00002000 000031c0 000001e0 00000000 [ 3222.584378] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000 [ 3222.584416] EEH: PCI-E AER 30: 00000000 00000000 [ 3222.584416] EEH: of node=0384:80:00.1 [ 3222.584454] EEH: PCI device/vendor: 168e14e4 [ 3222.584491] EEH: PCI cmd/status register: 00100140 [ 3222.584492] EEH: PCI-E capabilities and status follow:
> [ 3222.584677] EEH: PCI-E 00: 00020010 012c8da2 00095d5e 00455c82 [ 3222.584825] EEH: PCI-E 10: 10820000 00000000 00000000 00000000 [ 3222.584826] EEH: PCI-E 20: 00000000 [ 3222.584826] EEH: PCI-E AER capability register set follows:
> [ 3222.585011] EEH: PCI-E AER 00: 13c10001 00000000 00000000 00062030 [ 3222.585160] EEH: PCI-E AER 10: 00002000 000031c0 000001e0 00000000 [ 3222.585309] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000 [ 3222.585347] EEH: PCI-E AER 30: 00000000 00000000 [ 3222.586872] RTAS: event: 5, Type: Platform Error (224), Severity: 2 [ 3222.586873] EEH: Reset without hotplug activity [ 3224.762767] EEH: Beginning: 'slot_reset'
> [ 3224.762770] EEH: PE#800000 (PCI 0384:80:00.0): Invoking
> bnx2x->slot_reset()
> [ 3224.762771] bnx2x: [bnx2x_io_slot_reset:14271(eth14)]IO slot reset initializing...
> [ 3224.762887] bnx2x 0384:80:00.0: enabling device (0140 -> 0142) [ 3224.768157] bnx2x: [bnx2x_io_slot_reset:14287(eth14)]IO slot reset
> --> driver unload
> 
> [...]

Here is the summary with links:
  - [net] bnx2x: fix napi API usage sequence
    https://git.kernel.org/netdev/net/c/af68656d66ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


