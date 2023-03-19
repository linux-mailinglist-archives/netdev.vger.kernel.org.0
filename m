Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505546C00A1
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCSLAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCSLAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCAC23136;
        Sun, 19 Mar 2023 04:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD1A960FA2;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3426FC433EF;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223617;
        bh=wAMjv+OQaBXJ0DzFRZTo13CKHGO51sndjYWxpSODoV0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHLqBnDqmheJ2y5ayl1U+OEBaxWeJCSaHsKCxcS9br6z1sTZvzbH4VmxOHF2efhPC
         NSeqAmkYrKMmwFoa3pFZQbvfwCr7NsAPt3fYswTtBHUgHJeiQBmyiyJTLNZr7GIm1H
         XZyCGsn9WqJxO6xo/H5ytLt2h4AaRpjoosfRPlX/roOtemddgdbD3mxnghvUL+Kphl
         q1rlB788rV+Q/etpSOmWrHVLUvoTZEMGibgsLr/3zqpfp5dp9aQBYrq7eZnLtd297V
         idTy2XTVZODyM/OYkcO24rRyeuYyDdufu3jXJXy8eWvkceP8XbVC9TWtwSFWnURfni
         Ci+h7NaGJAGdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12542E21EE6;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3] net: stmmac: Fix for mismatched host/device DMA
 address width
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922361707.26931.13628628366196424198.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 11:00:17 +0000
References: <20230317080817.980517-1-jh@henneberg-systemdesign.com>
In-Reply-To: <20230317080817.980517-1-jh@henneberg-systemdesign.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, veekhee@apple.com,
        kurt@linutronix.de, ruppala@nvidia.com,
        andrey.konovalov@linaro.org, tee.min.tan@linux.intel.com,
        weifeng.voon@intel.com, mohammad.athari.ismail@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 09:08:17 +0100 you wrote:
> Currently DMA address width is either read from a RO device register
> or force set from the platform data. This breaks DMA when the host DMA
> address width is <=32it but the device is >32bit.
> 
> Right now the driver may decide to use a 2nd DMA descriptor for
> another buffer (happens in case of TSO xmit) assuming that 32bit
> addressing is used due to platform configuration but the device will
> still use both descriptor addresses as one address.
> 
> [...]

Here is the summary with links:
  - [net,V3] net: stmmac: Fix for mismatched host/device DMA address width
    https://git.kernel.org/netdev/net/c/070246e4674b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


