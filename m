Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52254896E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380708AbiFMOG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 10:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381944AbiFMOE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 10:04:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394EE2CE20
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0218EB80D31
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5C63C3411C;
        Mon, 13 Jun 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655120413;
        bh=Mi6HvXlohQj7gnk/bnuUNonHHrWfFN6licz7u5+MqEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oGe+6xQdvvr5Ru1dSL5YY6NDnGe0fYszSC5FSMzMNOxf2AmLcQi3aCjx93TYMYSqV
         0vynoG8xtiDmtUarWE//s56xG+aMllHyUxxn9c+RgKogyRzT92d+pp7Z/rsyIbT3tB
         Pnz/L1UV8Afvd0tEwXx7I4GBQRwpB56pSKdWs+KDe/2f6c9nLDrtLRwMgyEMHVvkaG
         a2x7m5O8uHfM+Q6+MrKoQUezNmgkTZ7b78UKIJRS9ukm77m4+A0wRCxPUH/8/7jRDu
         JEY9bQCfx+o7VePB6SlUBGQv1eeLQr/YzmSNMgDCgQckcrjmYb715RNMgF9ROdAPNl
         nTPc+ENTm2gJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACF08E736B8;
        Mon, 13 Jun 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: axienet: fix DMA Tx error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165512041370.13490.13445891268155155522.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 11:40:13 +0000
References: <20220613034202.3777248-1-andy.chiu@sifive.com>
In-Reply-To: <20220613034202.3777248-1-andy.chiu@sifive.com>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Jun 2022 11:42:00 +0800 you wrote:
> We ran into multiple DMA TX errors while writing files over a network
> block device running on top of a DMA-connected AXI Ethernet device on
> 64-bit RISC-V machines. The errors indicated that the DMA had fetched a
> null descriptor and we found that the reason for this is that AXI DMA had
> unexpectedly processed a partially updated tail descriptor pointer. To
> fix it, we suggest that the driver should use one 64-bit write instead
> of two 32-bit writes to perform such update if possible. For those
> archectures where double-word load/stores are unavailable, e.g. 32-bit
> archectures, force a driver probe failure if the driver finds 64-bit
> capability on DMA.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: axienet: make the 64b addresable DMA depends on 64b archectures
    https://git.kernel.org/netdev/net/c/00be43a74ca2
  - [net-next,2/2] net: axienet: Use iowrite64 to write all 64b descriptor pointers
    https://git.kernel.org/netdev/net/c/b690f8df6497

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


