Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B544AD024
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346543AbiBHEKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346517AbiBHEKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A93CC0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 050FEB817FF
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A885CC340F6;
        Tue,  8 Feb 2022 04:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644293408;
        bh=m0OQQK/kwD2QCv1uwGNHbrltUDqGCgDqUpwriANXeH8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dqw0BbqIufzwagWXlLSSqlyBnlXxs39F3n8jKil+oXkU1Ww/iCXL6a6kXCYcPkS58
         r4Xe1vrSeXr18bvYZwzl1481iRZ9/esGDb7aEA5f1+W6VTyKq3koB2xT4dp/K/O7Az
         SmSiSWTPEaGTRAvgOEzRz9DAjKrY01nMF6uxGFtS64+TQJIR1vS7u+JOEyRkKwT73C
         Zpr8JuNujBYKCmsAahHheaxEX6VqLFhxBxuFgIPof0rcHPQIv2Pkaye4XklBEv0bhT
         EiM+uynRvUJuH8/cDd0H/VeADn//aS+1DHMTwFr3mjqgqjZrp0/99H2QhNzssgjK2J
         e/OmXTR1ozAcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97AFFE5D084;
        Tue,  8 Feb 2022 04:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: optimize locking around PTP clock reads
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164429340861.30538.10382631851655387838.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 04:10:08 +0000
References: <20220204135545.2770625-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20220204135545.2770625-1-yannick.vignon@oss.nxp.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        olteanv@gmail.com, xiaoliang.yang_1@nxp.com, mingkai.hu@nxp.com,
        qiangqing.zhang@nxp.com, sebastien.laveze@nxp.com,
        yannick.vignon@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Feb 2022 14:55:44 +0100 you wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> Reading the PTP clock is a simple operation requiring only 3 register
> reads. Under a PREEMPT_RT kernel, protecting those reads by a spin_lock is
> counter-productive: if the 2nd task preempting the 1st has a higher prio
> but needs to read time as well, it will require 2 context switches, which
> will pretty much always be more costly than just disabling preemption for
> the duration of the reads. Moreover, with the code logic recently added
> to get_systime(), disabling preemption is not even required anymore:
> reads and writes just need to be protected from each other, to prevent a
> clock read while the clock is being updated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: optimize locking around PTP clock reads
    https://git.kernel.org/netdev/net-next/c/642436a1ad34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


