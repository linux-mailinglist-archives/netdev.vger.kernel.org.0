Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA46C5F0B0E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiI3LwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiI3Lvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:51:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A101A29379
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D49662301
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 11:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B174C433B5;
        Fri, 30 Sep 2022 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538620;
        bh=1v4Tv4zMdWJg8ZSf+j3sZwjCvT75Gbw0psyJVDr3hEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gp2hD1lOCrKhJgSyBTGbHdaYbkwdjh5PDVK5nFjDovh0BUtn7t/t9m2uyUeJqz8Cf
         ueGt0tfuUsP8fMFPLULM0NEwDnM25LdTBNAC/Ax2WkHWHdgGHjJlfSmy88JLgZa0ZC
         bU/3grEPojgC1Qe+NmLVIKkqEkf2gIdVLHhS2Khr3hhRZknySg7kz5PYKVvFqEeGEE
         DvVoAkKGTXsXvnZCH77tNcqsvWE/eJlibMwP/K+IzHVl98J/j4bfaqjVvqlIPI83mN
         RU9sKt6dTDhm+pgBdL1OcCuDR6ZhjLSYRoY6X1mvtmuvBwyay07MISOOaLJR92hTuo
         PG1etvYycdekg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F8AEE49FA5;
        Fri, 30 Sep 2022 11:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 1/3] ibmveth: Copy tx skbs into a premapped buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453862051.11280.5637680999823859051.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:50:20 +0000
References: <20220928214350.29795-1-nnac123@linux.ibm.com>
In-Reply-To: <20220928214350.29795-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 16:43:48 -0500 you wrote:
> Rather than DMA mapping and unmapping every outgoing skb, copy the skb
> into a buffer that was mapped during the drivers open function. Copying
> the skb and its frags have proven to be more time efficient than
> mapping and unmapping. As an effect, performance increases by 3-5
> Gbits/s.
> 
> Allocate and DMA map one continuous 64KB buffer at `ndo_open`. This
> buffer is maintained until `ibmveth_close` is called. This buffer is
> large enough to hold the largest possible linnear skb. During
> `ndo_start_xmit`, copy the skb and all of it's frags into the continuous
> buffer. By manually linnearizing all the socket buffers, time is saved
> during memcpy as well as more efficient handling in FW.
> As a result, we no longer need to worry about the firmware limitation
> of handling a max of 6 frags. So, we only need to maintain 1 descriptor
> instead of 6 and can hardcode 0 for the other 5 descriptors during
> h_send_logical_lan.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] ibmveth: Copy tx skbs into a premapped buffer
    https://git.kernel.org/netdev/net-next/c/d6832ca48d8a
  - [v2,net-next,2/3] ibmveth: Implement multi queue on xmit
    https://git.kernel.org/netdev/net-next/c/d926793c1de9
  - [v2,net-next,3/3] ibmveth: Ethtool set queue support
    https://git.kernel.org/netdev/net-next/c/10c2aba89cc0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


