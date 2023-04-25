Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D306EDA26
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 04:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjDYCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 22:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDYCKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 22:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B2D5FFD;
        Mon, 24 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79D93628D3;
        Tue, 25 Apr 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1827C433EF;
        Tue, 25 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682388618;
        bh=LV7mzaIjcHN7+qepxhchqcdjdPN3jQAWFFhyBHFUy8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q94SqZe4H8IsLWkzsRmsEoGvMsPjq1yZW+N8eEysVZ79LWhW4oGTrololrpxGyKwj
         bW0hMK6QEQ/sC6RTat+Xn09GDgD5m7SU0KMFWPybOO/P2dRCGH9OFJwIzp0yIFKtSr
         sxN78N5bGaIrTADFbFoINtUNO1N0YFrFMMDm3X0g2TEHs/UBfnJsTVPkFs4PNV5Cc2
         pPzJTTGTf8PwC9ZSgxxKb+uZ5KC6YvP9hhXyrVjJocZ+/LMhJqaeztKGmbZzc3EhAm
         VEXW13oTpD1S6xd+O8Ubpjfe5SHB/wEqGl/KNk3OW2PxPCPzIdO0KK4iLQ46s888aV
         ok3VxYIZyqW3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC6E7E5FFC7;
        Tue, 25 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] lan966x: Don't use xdp_frame when action is
 XDP_TX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238861870.3463.8505415279039848704.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 02:10:18 +0000
References: <20230422142344.3630602-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230422142344.3630602-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        aleksander.lobakin@intel.com, maciej.fijalkowski@intel.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 22 Apr 2023 16:23:44 +0200 you wrote:
> When the action of an xdp program was XDP_TX, lan966x was creating
> a xdp_frame and use this one to send the frame back. But it is also
> possible to send back the frame without needing a xdp_frame, because
> it is possible to send it back using the page.
> And then once the frame is transmitted is possible to use directly
> page_pool_recycle_direct as lan966x is using page pools.
> This would save some CPU usage on this path, which results in higher
> number of transmitted frames. Bellow are the statistics:
> Frame size:    Improvement:
> 64                ~8%
> 256              ~11%
> 512               ~8%
> 1000              ~0%
> 1500              ~0%
> 
> [...]

Here is the summary with links:
  - [net-next,v3] lan966x: Don't use xdp_frame when action is XDP_TX
    https://git.kernel.org/netdev/net-next/c/700f11eb2cbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


