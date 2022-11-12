Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B662671A
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiKLFKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiKLFKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CFE391C7;
        Fri, 11 Nov 2022 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 487BD609FE;
        Sat, 12 Nov 2022 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 772AAC433B5;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=b9hy5Uu/5y7S/TF2TAungVdatpEEDrM3Mfp/gMVTcQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qu9JGc2sCb/GEwSr0HpmKCLsOu7Zz+SEslo20KxWtTw6zVIcuD61md/ia6uY7Vc5P
         EvLLAX4uTA/zF/MPBJ7MWjneV+jpj8ljcBhHzjsYYWaWGBqo0FVgX0aTPw0n2/PEf4
         bIZWo43mm6GKi6wGFRBZK3j1j2ftDzdTO6AuobXbCDlhR1FeDj0M9U88KwSf/5WTOu
         dpx+scy55B3e19ZBxEG36dMalX48TNJn7zrf8RRFauQ78z3F96Yd+MGuR4AGkCWbj9
         xul1FzVbhNo6odPPaXAs9Yonc+4Ca/3gD/Bjr+wKi0ZjJClEzZMplAs+tL3d7fgwgq
         1LfU6heYafYoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F40FC395F7;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: ensure tx function is not running in
 stmmac_xdp_release()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981724.20406.14762867463134105044.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221110064552.22504-1-noor.azura.ahmad.tarmizi@linux.intel.com>
In-Reply-To: <20221110064552.22504-1-noor.azura.ahmad.tarmizi@linux.intel.com>
To:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, yoong.siang.song@intel.com,
        faizal.abdul.rahim@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Nov 2022 14:45:52 +0800 you wrote:
> From: Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
> 
> When stmmac_xdp_release() is called, there is a possibility that tx
> function is still running on other queues which will lead to tx queue
> timed out and reset adapter.
> 
> This commit ensure that tx function is not running xdp before release
> flow continue to run.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: ensure tx function is not running in stmmac_xdp_release()
    https://git.kernel.org/netdev/net/c/77711683a504

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


