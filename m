Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC883584B20
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiG2Fa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiG2FaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D27263D;
        Thu, 28 Jul 2022 22:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A25A61E9E;
        Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8B95C433D7;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072619;
        bh=EIR8NVljv3koQHCSvnPmV6i1eonxgxGo6SWfRruA0X4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HAr06cO7MrTUMKpeBG6J36lWsxCTWLxBfzduUUY2J9ovL+ecce5QH92qHvCRHXqjy
         7baqKmyspEbww9fRVBkhfsndONomYPzlstHoxjeYRovw6OwNNpPhFIIje9hm7q227k
         G8i0H9rJ0LfiWb5h+6yGF7yI+zZeZfrdrF89Rn1dQKmj0TU4bwjYV/IBzOGGJcJPND
         mdvY4pxjYrA6oV8muaJNh5kpmdhUHiInScNWb9HDF4QjELP3rRGtSCvQ+yECcYkRd7
         ufT5Fd9iqchbiRgYwErDgVnc+sAbQu5sd7Wtu9zXJAwBXm1q4vBx9UTlBZPaKEa/Pq
         e+SDJly95jL6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4492C43140;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v5 00/14] net: dsa: qca8k: code split for qca8k
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261973.17632.10185478057101306176.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
In-Reply-To: <20220727113523.19742-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 13:35:09 +0200 you wrote:
> This is needed ad ipq4019 SoC have an internal switch that is
> based on qca8k with very minor changes. The general function is equal.
> 
> Because of this we split the driver to common and specific code.
> 
> As the common function needs to be moved to a different file to be
> reused, we had to convert every remaining user of qca8k_read/write/rmw
> to regmap variant.
> We had also to generilized the special handling for the ethtool_stats
> function that makes use of the autocast mib. (ipq4019 will have a
> different tagger and use mmio so it could be quicker to use mmio instead
> of automib feature)
> And we had to convert the regmap read/write to bulk implementation to
> drop the special function that makes use of it. This will be compatible
> with ipq4019 and at the same time permits normal switch to use the eth
> mgmt way to send the entire ATU table read/write in one go.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/14] net: dsa: qca8k: cache match data to speed up access
    https://git.kernel.org/netdev/net-next/c/3bb0844e7bcd
  - [net-next,v5,02/14] net: dsa: qca8k: make mib autocast feature optional
    https://git.kernel.org/netdev/net-next/c/533c64bca62a
  - [net-next,v5,03/14] net: dsa: qca8k: move mib struct to common code
    https://git.kernel.org/netdev/net-next/c/027152b83043
  - [net-next,v5,04/14] net: dsa: qca8k: move qca8k read/write/rmw and reg table to common code
    https://git.kernel.org/netdev/net-next/c/d5f901eab2e9
  - [net-next,v5,05/14] net: dsa: qca8k: move qca8k bulk read/write helper to common code
    https://git.kernel.org/netdev/net-next/c/910746444313
  - [net-next,v5,06/14] net: dsa: qca8k: move mib init function to common code
    https://git.kernel.org/netdev/net-next/c/fce1ec0c4e2d
  - [net-next,v5,07/14] net: dsa: qca8k: move port set status/eee/ethtool stats function to common code
    https://git.kernel.org/netdev/net-next/c/472fcea160f2
  - [net-next,v5,08/14] net: dsa: qca8k: move bridge functions to common code
    https://git.kernel.org/netdev/net-next/c/fd3cae2f3ac1
  - [net-next,v5,09/14] net: dsa: qca8k: move set age/MTU/port enable/disable functions to common code
    https://git.kernel.org/netdev/net-next/c/b3a302b171f7
  - [net-next,v5,10/14] net: dsa: qca8k: move port FDB/MDB function to common code
    https://git.kernel.org/netdev/net-next/c/2e5bd96eea86
  - [net-next,v5,11/14] net: dsa: qca8k: move port mirror functions to common code
    https://git.kernel.org/netdev/net-next/c/742d37a84d3f
  - [net-next,v5,12/14] net: dsa: qca8k: move port VLAN functions to common code
    https://git.kernel.org/netdev/net-next/c/c5290f636624
  - [net-next,v5,13/14] net: dsa: qca8k: move port LAG functions to common code
    https://git.kernel.org/netdev/net-next/c/e9bbf019af44
  - [net-next,v5,14/14] net: dsa: qca8k: move read_switch_id function to common code
    https://git.kernel.org/netdev/net-next/c/9d1bcb1f293f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


