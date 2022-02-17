Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847E64BAB46
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 21:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbiBQUu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 15:50:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiBQUu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 15:50:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB226164D03;
        Thu, 17 Feb 2022 12:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FDDDB82515;
        Thu, 17 Feb 2022 20:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14350C340EB;
        Thu, 17 Feb 2022 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645131010;
        bh=vLb4Bz9FuAaLFrxkwRH0wae562i2IPgCN2e4LFcegQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iUuTr3HwsfJHh6aOkc8uNhsTk69WIVGZRsmVT++FORGPRCjntr+qSGv9NGGMcFG3t
         7SQrc7UpHllDnDI5i/zHAxhMzPlSO+evLPm+656flLDVOIWEyrDMAFCYNMhQUZHflp
         0RcljJNGo0QSXzOUtLnh6e2KLK15GooCbKUlM862NK/FvLSetayHpFYJuA3UO4p/Gj
         WS+wEOcuH4d+OEEzF+sNI0QQu8wZIcBXFpmVFv7Ce+6R1uvBGVnlxynLiasWMwNNDy
         niP1xCVWV65VUr06swwUdCnbdDRyjX5Kfiv0FEv0/31TyGiUELJ6AmOet2XKx136rw
         +zif1h5SJu97g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E90F6E7BB08;
        Thu, 17 Feb 2022 20:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: marvell: prestera: add basic routes
 offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164513100994.9820.5764759394869157729.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 20:50:09 +0000
References: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
In-Reply-To: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, tchornyi@marvell.com,
        oleksandr.mazur@plvision.eu, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Feb 2022 03:05:54 +0200 you wrote:
> Add support for blackhole and local routes for Marvell Prestera driver.
> Subscribe on fib notifications and handle add/del.
> 
> Add features:
>  - Support route adding.
>    e.g.: "ip route add blackhole 7.7.1.1/24"
>    e.g.: "ip route add local 9.9.9.9 dev sw1p30"
>  - Support "rt_trap", "rt_offload", "rt_offload_failed" flags
>  - Handle case, when route in "local" table overlaps route in "main" table
>    example:
> 	ip ro add blackhole 7.7.7.7
> 	ip ro add local 7.7.7.7 dev sw1p30
> 	# blackhole route will be deoffloaded. rt_offload flag disappeared
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: marvell: prestera: Add router LPM ABI
    https://git.kernel.org/netdev/net-next/c/19787b93f814
  - [net-next,2/3] net: marvell: prestera: add hardware router objects accounting for lpm
    https://git.kernel.org/netdev/net-next/c/16de3db1208a
  - [net-next,3/3] net: marvell: prestera: handle fib notifications
    https://git.kernel.org/netdev/net-next/c/4394fbcb78cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


