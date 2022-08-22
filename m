Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE1059C13A
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiHVOAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiHVOAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4082DA99;
        Mon, 22 Aug 2022 07:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E702DB81238;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D548C433D7;
        Mon, 22 Aug 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661176815;
        bh=Czu3MfNyIpPti2fXdeDPfUodTPMADJ+JZklDJ64iozM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ia187fPDqRcsHU+GwdgwtxuGeSR046CJzvxz+no9Nx22mU4sPZJz9lq/1LaYc5Nau
         w+IE1UC0OYvslZLHcrojSA6gfUPwRsgQEz/DwsjOtF/TrDeJP665YjxwcyS+OxWe3G
         fi6yQteCvoxYGEebuPUyfWl81IZmTkXQCtY+Q6LateHovOGsPVIlmbEUscSquik9k7
         OiX9MBtJ4DLZYD1T0yPX9coSsfZlkbK86dEjvgBOVs9teQ98N+P1/Z7zzkAchEU/OH
         bY2ck+6yzOahwmLgV6RjbczneQN6qrng2NFUcuiYXiaRLgnIyjd/mbd2ImX/fUJcXK
         Q16KFonX+LfjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7312DE2A03D;
        Mon, 22 Aug 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfc: pn533: Fix use-after-free bugs caused by
 pn532_cmd_timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117681546.22523.17720942204050886000.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 14:00:15 +0000
References: <20220818090621.106094-1-duoming@zju.edu.cn>
In-Reply-To: <20220818090621.106094-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Aug 2022 17:06:21 +0800 you wrote:
> When the pn532 uart device is detaching, the pn532_uart_remove()
> is called. But there are no functions in pn532_uart_remove() that
> could delete the cmd_timeout timer, which will cause use-after-free
> bugs. The process is shown below:
> 
>     (thread 1)                  |        (thread 2)
>                                 |  pn532_uart_send_frame
> pn532_uart_remove               |    mod_timer(&pn532->cmd_timeout,...)
>   ...                           |    (wait a time)
>   kfree(pn532) //FREE           |    pn532_cmd_timeout
>                                 |      pn532_uart_send_frame
>                                 |        pn532->... //USE
> 
> [...]

Here is the summary with links:
  - [net] nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout
    https://git.kernel.org/netdev/net/c/f1e941dbf80a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


