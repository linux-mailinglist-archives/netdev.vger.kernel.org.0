Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0A067F543
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 07:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjA1GkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 01:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjA1GkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 01:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42064A1F0;
        Fri, 27 Jan 2023 22:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB686B8121B;
        Sat, 28 Jan 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 465A0C4339C;
        Sat, 28 Jan 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674888019;
        bh=Eqeb1YOaeFH+/4gYrBgLt6DPu9iTXgFy+dVrX3XHPG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A88r+y0FKi17nFSkVlcLBv7L3AIEBjUPKNHPCsLRyIG1TGwB4ECXVsYoLHi/mgkPK
         7q20EnET8+WUdVqFFu2qR1X7R0G9hAf6zdzU85Gymqq23cQ45CbLUPTgQ9dbKyY55X
         dzgOtmsEoQ/ZMzIBBtofCMd7+uR4rdI8ghB6DPQrve0f8g1r9uKpWV/xwTJPNzuJGf
         HeW5sDmZ79+16cyqlhytcvMJGtkgLUnC+skNWNZ7kj8hZijXLp1wUx7H1wftlbZzXD
         4QTedh32AY78raD+BqA5V9r/qno3bciwBfV7fBwd2sRyzW+uM3uEx7Ejds0idf6S3N
         cuMWJHij+ED9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D5EDC39564;
        Sat, 28 Jan 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/5] net: xdp: execute xdp_do_flush() before
 napi_complete_done()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167488801911.1883.7455001304854457036.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 06:40:19 +0000
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230125074901.2737-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com, bpf@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 08:48:56 +0100 you wrote:
> Make sure that xdp_do_flush() is always executed before
> napi_complete_done(). This is important for two reasons. First, a
> redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> napi context X on CPU Y will be followed by a xdp_do_flush() from the
> same napi context and CPU. This is not guaranteed if the
> napi_complete_done() is executed before xdp_do_flush(), as it tells
> the napi logic that it is fine to schedule napi context X on another
> CPU. Details from a production system triggering this bug using the
> veth driver can be found in [1].
> 
> [...]

Here is the summary with links:
  - [net,v2,1/5] qede: execute xdp_do_flush() before napi_complete_done()
    https://git.kernel.org/netdev/net/c/2ccce20d51fa
  - [net,v2,2/5] lan966x: execute xdp_do_flush() before napi_complete_done()
    https://git.kernel.org/netdev/net/c/12b5717990c8
  - [net,v2,3/5] virtio-net: execute xdp_do_flush() before napi_complete_done()
    https://git.kernel.org/netdev/net/c/ad7e615f646c
  - [net,v2,4/5] dpaa_eth: execute xdp_do_flush() before napi_complete_done()
    https://git.kernel.org/netdev/net/c/b534013798b7
  - [net,v2,5/5] dpaa2-eth: execute xdp_do_flush() before napi_complete_done()
    https://git.kernel.org/netdev/net/c/a3191c4d86c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


