Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB9260547A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJTAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJTAaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4548EFF236
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 17:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9E666125A
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 210A1C433D7;
        Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666225817;
        bh=jbjaAh/jS+9DCtNNtGmhV5GWjV/pCL+q00b8sGMMkkM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=geb3vtUPkiW84rqkhv/ZFJH+hVLjwN089opk7HVR9xv+2rE35lhOr7gAUiKzPv0FX
         6z+QSkWVd2CXVaBgtuMpxas5QbLhN4rsYud3P4RL4l86cAnkLMK3gk3MJwTKgL1am7
         GLNqSZ7ZLY773K1o4MqlDFnY/UNVulVwqXXdgWXel319VBwcUnw99/riJ64ysxhuyc
         I9PVP2tN9Hr9m58EaKKx2fiB+1AQmz6hSCJAppP+NHtbtaiMonJqbf4jZ/7ye8QxNk
         n75KtMNwm4m5fuKLGg7BJhmRjnPiQIFnLHm0AHCkbVIv7R927E+8ClvJkRHFrumKjO
         SjuOHgfwUeM/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03BD4E4D007;
        Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] wwan_hwsim: fix possible memory leak in
 wwan_hwsim_dev_new()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166622581700.22962.14913328109699543637.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 00:30:17 +0000
References: <20221018131607.1901641-1-yangyingliang@huawei.com>
In-Reply-To: <20221018131607.1901641-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Oct 2022 21:16:07 +0800 you wrote:
> Inject fault while probing module, if device_register() fails,
> but the refcount of kobject is not decreased to 0, the name
> allocated in dev_set_name() is leaked. Fix this by calling
> put_device(), so that name can be freed in callback function
> kobject_cleanup().
> 
> unreferenced object 0xffff88810152ad20 (size 8):
>   comm "modprobe", pid 252, jiffies 4294849206 (age 22.713s)
>   hex dump (first 8 bytes):
>     68 77 73 69 6d 30 00 ff                          hwsim0..
>   backtrace:
>     [<000000009c3504ed>] __kmalloc_node_track_caller+0x44/0x1b0
>     [<00000000c0228a5e>] kvasprintf+0xb5/0x140
>     [<00000000cff8c21f>] kvasprintf_const+0x55/0x180
>     [<0000000055a1e073>] kobject_set_name_vargs+0x56/0x150
>     [<000000000a80b139>] dev_set_name+0xab/0xe0
> 
> [...]

Here is the summary with links:
  - [net] wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
    https://git.kernel.org/netdev/net/c/258ad2fe5ede

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


