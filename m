Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA857353E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiGMLUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiGMLUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BCB1014BA;
        Wed, 13 Jul 2022 04:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92852B81E26;
        Wed, 13 Jul 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CB10C385A5;
        Wed, 13 Jul 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657711215;
        bh=PeJmCD9YYnEwyuCK6N/wek0MqkHO8+ExaeeWGxY14YU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pN/LPEvCCtIvCRowMBSOMsf+1AlQWG4Qrkn9hph+g6o4WH0mijiXIYK7CzLRlfUsZ
         j5t+lL6AIb+D6MG7Ty7Nj7WoCCghT6RkFdwaQn3Fa5ar1IoA+bUYMyw2jdicUbT2TL
         buchE08HNKb1FX4pEnHZ46wmmcy/CoxkXLs/UXiPelGJj8p13y1kmw8alV5hs7jxRp
         I0m6PVm7OG9mWASBMHQeAp/SmqGb7xs17zccHVT7B+w88m554PRY7rvxjGlFdpx32U
         tpei+4UhSl2hAPls7eqNj5x91QrO9jAAFVILWDxiVeEt71FFb2+F1TuwpLwpYy8Yiq
         m27CnSQYgS7Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CB33E45223;
        Wed, 13 Jul 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V5 net-next 0/4] net: marvell: prestera: add MDB offloading
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771121504.27638.8815130999141728184.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 11:20:15 +0000
References: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        yevhen.orlov@plvision.eu
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Jul 2022 14:28:18 +0300 you wrote:
> This patch series adds support for the MDB handling for the marvell
> Prestera Driver. It's used to propagate IGMP groups registered within
> the Kernel to the underlying HW (offload registered groups).
> 
> Features:
>  - define (and implement) main internal MDB-related objects;
>  - define (and implement) main HW APIs for MDB handling;
>  - add MDB handling support for both regular ports as well as Bond
>    interfaces;
>  - Mirrored behavior of Bridge driver upon multicast router appearance
>    (all traffic flooded when there's no mcast router; mcast router
>     receives all mcast traffic, and only group-specific registered mcast
>     traffic is being received by ports who've explicitly joined any group
>     when there's a registered mcast router);
>  - Reworked prestera driver bridge flags (especially multicast)
>    setting - thus making it possible to react over mcast disabled messages
>    properly by offloading this state to the underlying HW
>    (disabling multicast flooding);
> 
> [...]

Here is the summary with links:
  - [V5,net-next,1/4] net: marvell: prestera: rework bridge flags setting
    https://git.kernel.org/netdev/net-next/c/116f5af7c3ab
  - [V5,net-next,2/4] net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
    https://git.kernel.org/netdev/net-next/c/fec7c9c73fd3
  - [V5,net-next,3/4] net: marvell: prestera: define and implement MDB / flood domain API for entries creation and deletion
    https://git.kernel.org/netdev/net-next/c/7950b214a1e4
  - [V5,net-next,4/4] net: marvell: prestera: implement software MDB entries allocation
    https://git.kernel.org/netdev/net-next/c/deef0d6afe84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


