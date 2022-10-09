Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822255F8D9C
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiJITAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJITAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B524619297;
        Sun,  9 Oct 2022 12:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5747E60C6E;
        Sun,  9 Oct 2022 19:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4330C433D7;
        Sun,  9 Oct 2022 19:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665342014;
        bh=5oaT6cRjV0u69+2ayKlnvYUhASoH5qRDauJkOK0L8NQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpFwq0khgbmOQS+SqdLnwvjh0m62CUG2xc3Pn20O/ZyiYYFN/tOMYDxSaBLv3tgmh
         cml3Rzwy0FjTQ/r+GaDsMqMC7K4OXrl8ZrnQ+HEn9WcqN25BBec3/5NasaYXWSH1sU
         6dz2DUWRt7UXo7sJvUhjg4twDgFehpLvYwRGq/Dzt8R+rDBqfNFV9qAMbR4Bd2jhKe
         WfRrBumCoBedKdruYDOKfoUJbhQPq6EwjOwwnBNSrkzbhGHr8or/0UQ0VMR6gT5wFS
         VNpxvwlZdCH3gRSXQuDyWIeo6yHyBtlPUAQGhtGUClAtG3mDU7cz8si32j/N5oT8bO
         A/A/rfbSv462A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 895ACE21EC5;
        Sun,  9 Oct 2022 19:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_softirq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166534201455.6058.9588339706087338743.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Oct 2022 19:00:14 +0000
References: <20221009063731.22733-1-duoming@zju.edu.cn>
In-Reply-To: <20221009063731.22733-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, isdn@linux-pingi.de, kuba@kernel.org,
        andrii@kernel.org, gregkh@linuxfoundation.org, axboe@kernel.dk,
        davem@davemloft.net, netdev@vger.kernel.org, zou_wei@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  9 Oct 2022 14:37:31 +0800 you wrote:
> The function hfcpci_softirq() is a timer handler. If it
> is running, the timer_pending() will return 0 and the
> del_timer_sync() in HFC_cleanup() will not be executed.
> As a result, the use-after-free bug will happen. The
> process is shown below:
> 
>     (cleanup routine)          |        (timer handler)
> HFC_cleanup()                  | hfcpci_softirq()
>  if (timer_pending(&hfc_tl))   |
>    del_timer_sync()            |
>  ...                           | ...
>  pci_unregister_driver(hc)     |
>   driver_unregister            |  driver_for_each_device
>    bus_remove_driver           |   _hfcpci_softirq
>     driver_detach              |   ...
>      put_device(dev) //[1]FREE |
>                                |    dev_get_drvdata(dev) //[2]USE
> 
> [...]

Here is the summary with links:
  - mISDN: hfcpci: Fix use-after-free bug in hfcpci_softirq
    https://git.kernel.org/netdev/net/c/175302f6b79e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


