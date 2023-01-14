Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9980566A974
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjANFkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjANFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB7E3A87
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 21:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEBCE60B2D
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54956C4339C;
        Sat, 14 Jan 2023 05:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673674817;
        bh=qXoXzi5FfPHh/seEpoNP/v9nMpjK6EP1WpnU55BxDaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BeNM4OgMzbNcE80yTISvyrwCaFyx6Lc9aldrttfQO2SKo7we17Lf9/7g4MARejxUo
         +KvCSxg91xFnbSH7+bItYUGsp7gVzy9P73z84YxSEvBmR/O7dJ9V0u/2352Bc4XTtW
         pdduz+6Zv59yV2TIA6rotZBM4I1aYTMGLkXJiIaqaIfKBt7T+nnZWGAOjM7J407Btu
         gG/0NDh9NGxEh2rjRIlgqLNLEV1WY39+HXGgTFzH7yq+Q/2jRP8HvvI8zlnNIn8Mbf
         bobWJQkj7lUH6fZ1vCXrMaCSm3+RW7nvptNnPExYKr2L53CTCQGxWa43WgI0pUKBHV
         eV+ydN2WkIY+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F000E270DD;
        Sat, 14 Jan 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_wed: get rid of queue lock for
 tx queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367481725.11900.7048087007656114248.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:40:17 +0000
References: <7bd0337b2a13ab1a63673b7c03fd35206b3b284e.1673515140.git.lorenzo@kernel.org>
In-Reply-To: <7bd0337b2a13ab1a63673b7c03fd35206b3b284e.1673515140.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 10:21:29 +0100 you wrote:
> Similar to MTK Wireless Ethernet Dispatcher (WED) MCU rx queue,
> we do not need to protect WED MCU tx queue with a spin lock since
> the tx queue is accessed in the two following routines:
> - mtk_wed_wo_queue_tx_skb():
>   it is run at initialization and during mt7915 normal operation.
>   Moreover MCU messages are serialized through MCU mutex.
> - mtk_wed_wo_queue_tx_clean():
>   it runs just at mt7915 driver module unload when no more messages
>   are sent to the MCU.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ethernet: mtk_wed: get rid of queue lock for tx queue
    https://git.kernel.org/netdev/net-next/c/bf20ce9f3040

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


