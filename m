Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C516D8D50
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjDFCKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbjDFCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7081F6196;
        Wed,  5 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E532F62CF9;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46B01C433A0;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680747018;
        bh=84dnOHxJLvRLAV3cCIz8QrnxN5Q05YNcM1cDzpVJ7X8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tIt9Zq8skri0IOIteO900wuOHhMMbx+jOivszbUExBIwoAoh0REsczXmnChxD7nDq
         tGFIrNrZ/GErki4n8AIiVkXJ4gVeR/Ur7RoQF85jX9EhQRZ/WRRT8qC5Vs5ESs4Hsd
         rBc5H6d0r/vCyHnGDNgCEnhT6rBS77lvI9ZP5Hf9pUDv/ulnQEPjD5R0ke7HEf0JFN
         xkRDUrOjTCD9BTd6UaFn8XTnYlVNR3ckxOhKlW9iyPs2XA18gzwhZRWre3H4wGFmQW
         hwXyPOOkrz1WapLjQ436gT0LL9rup1y5aR7K8cuV2CwOP643e6PSJApt4BZRiyEyt1
         Uv7ZlWNic1h5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0ECD8E2A033;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: Add queue reset into stmmac_xdp_open()
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074701805.16861.13421664747148882489.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 02:10:18 +0000
References: <20230404044823.3226144-1-yoong.siang.song@intel.com>
In-Reply-To: <20230404044823.3226144-1-yoong.siang.song@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, ansuelsmth@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Apr 2023 12:48:23 +0800 you wrote:
> Queue reset was moved out from __init_dma_rx_desc_rings() and
> __init_dma_tx_desc_rings() functions. Thus, the driver fails to transmit
> and receive packet after XDP prog setup.
> 
> This commit adds the missing queue reset into stmmac_xdp_open() function.
> 
> Fixes: f9ec5723c3db ("net: ethernet: stmicro: stmmac: move queue reset to dedicated functions")
> Cc: <stable@vger.kernel.org> # 6.0+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: Add queue reset into stmmac_xdp_open() function
    https://git.kernel.org/netdev/net/c/24e3fce00c0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


