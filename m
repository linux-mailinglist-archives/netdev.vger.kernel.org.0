Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6881968067A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbjA3Ha3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbjA3HaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:30:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9E319F0E;
        Sun, 29 Jan 2023 23:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 995EECE126E;
        Mon, 30 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89408C4339B;
        Mon, 30 Jan 2023 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675063816;
        bh=rg9irJegOw5SWfJITeliDo5z7rjer8uzyKSZn2A5JlQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h4aXTZo8h0vny9BjBFbV1JJ1acsVL4Tiq8fCb0kD7qp3Mst+7NDpFL2VQqbKwH6+H
         CcsH+NT7CnvvDXb5YmWk5u7DK1zK1ZmV5SJyYD4ShU2CSdOUc3xT2DmlFZUbyNbto1
         HXsExQpkmqYiwKDoukKihIbsElvufomWgsCrBogva/Stiv2zuK+9uV6qCBq9ihGPiT
         gwYw+TH0aEp8NlIgFRi3dZGPD5PQX7MB2jMCiuMuDq2iPh/ZolbW6D99nFKdKWzG8o
         /X32SfRPNJYhhe4QNnAAygBR8d1TRFSQb2k4A4+IwWkHJJXNnI5kLU3lyK04XcgFE5
         3uTiRXHAbEDEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E71FE21ED8;
        Mon, 30 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/1] net: stmmac: do not stop RX_CLK in Rx LPI state for
 qcs404 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506381644.14069.1519780033829172123.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 07:30:16 +0000
References: <20230126213539.166298-1-andrey.konovalov@linaro.org>
In-Reply-To: <20230126213539.166298-1-andrey.konovalov@linaro.org>
To:     Andrey Konovalov <andrey.konovalov@linaro.org>
Cc:     vkoul@kernel.org, bhupesh.sharma@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, robh@kernel.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 Jan 2023 00:35:38 +0300 you wrote:
> This is a different, for one SoC only solution to the issue described below
> vs a generic one submitted earlier [1].
> 
> On my qcs404 based board the ethernet MAC has issues with handling
> Rx LPI exit / Rx LPI entry interrupts.
> 
> When in LPI mode the "refresh transmission" is received, the driver may
> see both "Rx LPI exit", and "Rx LPI entry" bits set in the single read from
> GMAC4_LPI_CTRL_STATUS register (vs "Rx LPI exit" first, and "Rx LPI entry"
> then). In this case an interrupt storm happens: the LPI interrupt is
> triggered every few microseconds - with all the status bits in the
> GMAC4_LPI_CTRL_STATUS register being read as zeros. This interrupt storm
> continues until a normal non-zero status is read from GMAC4_LPI_CTRL_STATUS
> register (single "Rx LPI exit", or "Tx LPI exit").
> 
> [...]

Here is the summary with links:
  - [1/1] net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC
    https://git.kernel.org/netdev/net/c/54aa39a513db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


