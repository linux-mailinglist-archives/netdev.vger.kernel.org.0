Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246216210B7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiKHMaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbiKHMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96544877A;
        Tue,  8 Nov 2022 04:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 167146153F;
        Tue,  8 Nov 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 688E5C433D7;
        Tue,  8 Nov 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667910615;
        bh=SonIbouVyw/qkHMHGtqoXYaelFJP7EQ3+xGcdErC0FA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=plBR5rVswRpwN9LGq1vX3pDPetOc11uyihNDnQuDA/wIKjEeswmCFvOxR24xXZGwP
         cbGqKp6wHxp2D2IwMevRWPFrG2a+k6/psjHlswvZfseMiYHwnbdX4jhx7m+/UyzYA0
         N6KyWp/N1t76C4gqsLVRdOzdwI9bFOtx9rGUOVq+8VqShLt5hx8zPRrmJIBp2059LZ
         N3qzzmCQ+7NIsvO+sAJxo6F3O/W56o4pxVDXIlP62lRZkireP6Rne92bnnfNTk7qCT
         NmlzFFGny01fxAISjtDZLBxooUqsm+LEymOPYjvOvQuD1m8jA2qmlFLctyoyWgHk1P
         jrkOTu+1+0X7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 497B0E270D0;
        Tue,  8 Nov 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lapbether: fix issue of invalid opcode in
 lapbeth_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166791061529.27754.528965881676739737.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 12:30:15 +0000
References: <20221107011445.207372-1-shaozhengchao@huawei.com>
In-Reply-To: <20221107011445.207372-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org, ms@dev.tdt.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xie.he.0141@gmail.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 7 Nov 2022 09:14:45 +0800 you wrote:
> If lapb_register() failed when lapb device goes to up for the first time,
> the NAPI is not disabled. As a result, the invalid opcode issue is
> reported when the lapb device goes to up for the second time.
> 
> The stack info is as follows:
> [ 1958.311422][T11356] kernel BUG at net/core/dev.c:6442!
> [ 1958.312206][T11356] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> [ 1958.315979][T11356] RIP: 0010:napi_enable+0x16a/0x1f0
> [ 1958.332310][T11356] Call Trace:
> [ 1958.332817][T11356]  <TASK>
> [ 1958.336135][T11356]  lapbeth_open+0x18/0x90
> [ 1958.337446][T11356]  __dev_open+0x258/0x490
> [ 1958.341672][T11356]  __dev_change_flags+0x4d4/0x6a0
> [ 1958.345325][T11356]  dev_change_flags+0x93/0x160
> [ 1958.346027][T11356]  devinet_ioctl+0x1276/0x1bf0
> [ 1958.346738][T11356]  inet_ioctl+0x1c8/0x2d0
> [ 1958.349638][T11356]  sock_ioctl+0x5d1/0x750
> [ 1958.356059][T11356]  __x64_sys_ioctl+0x3ec/0x1790
> [ 1958.365594][T11356]  do_syscall_64+0x35/0x80
> [ 1958.366239][T11356]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [ 1958.377381][T11356]  </TASK>
> 
> [...]

Here is the summary with links:
  - [net] net: lapbether: fix issue of invalid opcode in lapbeth_open()
    https://git.kernel.org/netdev/net/c/3faf7e14ec0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


