Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936735EBDC6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiI0IuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiI0IuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E912B24A;
        Tue, 27 Sep 2022 01:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B6C7B81A7F;
        Tue, 27 Sep 2022 08:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFA8DC433B5;
        Tue, 27 Sep 2022 08:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664268615;
        bh=qMdK7NLyMVV2IraowNNECpM/+mO8CR7/5v5YJjjGs2w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yag8duBNCP4igT24u4e05HRse6iMq9hcUuU5gFBfe1e40RFUXHtz8SjUCANRB4Zjq
         S+YULQWwB1+MgxRLU2BE6r3fVtrY1beAt1AjhpR3XvpDHR61C4Kdj6QOvvJmcmbdyQ
         yAn/Rfhyy96VOQPrZtJfg3Atsd+lDAqiuBkDdVDzuymQqiKCYsrPlvJto2KtWfQccv
         Eaxq81XMAlWOYtUQLnKQXI+L8EqMDqG4M5ES2a6YONq0qQ0+Tpwm461uVCVC+873J/
         dyuOer6CDXj2ZnKJ/YWq7c9ZBonz3POZ3AHyg0D3UYBEgvCQ9Y01ymYSNvco8Zm6bm
         pB2EQIfHNARbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3720E21EC2;
        Tue, 27 Sep 2022 08:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net,v3] net: stmmac: power up/down serdes in stmmac_open/release
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166426861486.17620.1374697720917378752.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 08:50:14 +0000
References: <20220923050448.1220250-1-junxiao.chang@intel.com>
In-Reply-To: <20220923050448.1220250-1-junxiao.chang@intel.com>
To:     Junxiao Chang <junxiao.chang@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jimmyjs.chen@adlinktech.com, hong.aun.looi@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 23 Sep 2022 13:04:48 +0800 you wrote:
> This commit fixes DMA engine reset timeout issue in suspend/resume
> with ADLink I-Pi SMARC Plus board which dmesg shows:
> ...
> [   54.678271] PM: suspend exit
> [   54.754066] intel-eth-pci 0000:00:1d.2 enp0s29f2: PHY [stmmac-3:01] driver [Maxlinear Ethernet GPY215B] (irq=POLL)
> [   54.755808] intel-eth-pci 0000:00:1d.2 enp0s29f2: Register MEM_TYPE_PAGE_POOL RxQ-0
> ...
> [   54.780482] intel-eth-pci 0000:00:1d.2 enp0s29f2: Register MEM_TYPE_PAGE_POOL RxQ-7
> [   55.784098] intel-eth-pci 0000:00:1d.2: Failed to reset the dma
> [   55.784111] intel-eth-pci 0000:00:1d.2 enp0s29f2: stmmac_hw_setup: DMA engine initialization failed
> [   55.784115] intel-eth-pci 0000:00:1d.2 enp0s29f2: stmmac_open: Hw setup failed
> ...
> 
> [...]

Here is the summary with links:
  - [net,v3] net: stmmac: power up/down serdes in stmmac_open/release
    https://git.kernel.org/netdev/net/c/49725ffc15fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


