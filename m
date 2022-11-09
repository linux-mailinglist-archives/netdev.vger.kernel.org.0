Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89352622091
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKIAAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 19:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKIAAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844CB7DC;
        Tue,  8 Nov 2022 16:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9760617EA;
        Wed,  9 Nov 2022 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33546C433B5;
        Wed,  9 Nov 2022 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667952017;
        bh=+vXxWC+6rtBRpR5aPMhc7c91nQFk2a+7aGl++UeI7T0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i6yCGC+Gyw0/Xl7XM0K4uQTh9cWZuIVpyq6DPw/DG1/G2O7ae+nqVlKAlMnR45yDs
         xhxRPThCW5AQJZHh/em5sE25oS9pl2p3taM+6emz8d0/kvVyOkTJiQG/K5E47NLUsc
         djUKA6LwLtVw+JZlT5cHy3cSMqRnVrcOFZLC60fTxUN/9HI/0yK7BcmfKoZc5mmGip
         TmACAksDdCxaJq7waDCn9u9Xi4MrBTe8VFuulsmZDzdGVc3nHKnkDzFHrOrVHZIOKm
         8ViGUr/7neV5a4smwif3NuVJaWR6BzJSndO4m3d7cR9cZLr1ST17FRtrf1+gXyCGa7
         lx60zgU1vKikg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 104A3E270D3;
        Wed,  9 Nov 2022 00:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] can: af_can: can_exit(): add missing
 dev_remove_pack() of canxl_packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166795201703.19546.8517575673806903140.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 00:00:17 +0000
References: <20221107133217.59861-2-mkl@pengutronix.de>
In-Reply-To: <20221107133217.59861-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        chenzhongjin@huawei.com, socketcan@hartkopp.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon,  7 Nov 2022 14:32:12 +0100 you wrote:
> From: Chen Zhongjin <chenzhongjin@huawei.com>
> 
> In can_init(), dev_add_pack(&canxl_packet) is added but not removed in
> can_exit(). It breaks the packet handler list and can make kernel
> panic when can_init() is called for the second time.
> 
> | > modprobe can && rmmod can
> | > rmmod xxx && modprobe can
> |
> | BUG: unable to handle page fault for address: fffffbfff807d7f4
> | RIP: 0010:dev_add_pack+0x133/0x1f0
> | Call Trace:
> |  <TASK>
> |  can_init+0xaa/0x1000 [can]
> |  do_one_initcall+0xd3/0x4e0
> |  ...
> 
> [...]

Here is the summary with links:
  - [net,1/6] can: af_can: can_exit(): add missing dev_remove_pack() of canxl_packet
    https://git.kernel.org/netdev/net/c/a3335faebe16
  - [net,2/6] can: af_can: fix NULL pointer dereference in can_rx_register()
    https://git.kernel.org/netdev/net/c/8aa59e355949
  - [net,3/6] can: isotp: fix tx state handling for echo tx processing
    https://git.kernel.org/netdev/net/c/866337865f37
  - [net,4/6] can: j1939: j1939_send_one(): fix missing CAN header initialization
    https://git.kernel.org/netdev/net/c/3eb3d283e857
  - [net,5/6] can: dev: fix skb drop check
    https://git.kernel.org/netdev/net/c/ae64438be192
  - [net,6/6] can: rcar_canfd: Add missing ECC error checks for channels 2-7
    https://git.kernel.org/netdev/net/c/8b043dfb3dc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


