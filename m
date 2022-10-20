Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B923460548C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiJTAk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJTAkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A6107AA8
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 17:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21E72B8265D
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE69BC433D7;
        Thu, 20 Oct 2022 00:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666226421;
        bh=54O53d9zlrhOefalBnUOx521g5Uuv70CNgXSAAvzzsg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TI7yQACo1KQAoTxvvCWxJ0Wy9ssmtLIf3/eE9/tAARYphAYzBQsBrK+xJwuGgiIkS
         vXhBVAZfPguM/nf5p+WrkoMYyK8XmOGiqb1tpRX/Ao6MQutF1lE1DqNrEHwbIQBn/2
         C2IZSAo+uktTwShWETUIaZXosn63bIedauqoHt24OLqe4M9Z/zB76J5cOf/G2KJ9zE
         Eu3OuBbng8fFMY8wRHcN3dRV2qXblIIaGtz0Mx6X+0xmWf/caNdoQqbwNDVzzUQ18b
         HKTiBzsC28RIioroy5s1AZz5oy7onVcbbreBYWk0+bpLMMaocJVjRmmwcEjmKvDdjv
         itWKhdRpjLZGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82131E4D007;
        Thu, 20 Oct 2022 00:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns: fix possible memory leak in hnae_ae_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166622642152.27263.17987700781287659037.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 00:40:21 +0000
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
In-Reply-To: <20221018122451.1749171-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net
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

On Tue, 18 Oct 2022 20:24:51 +0800 you wrote:
> Inject fault while probing module, if device_register() fails,
> but the refcount of kobject is not decreased to 0, the name
> allocated in dev_set_name() is leaked. Fix this by calling
> put_device(), so that name can be freed in callback function
> kobject_cleanup().
> 
> unreferenced object 0xffff00c01aba2100 (size 128):
>   comm "systemd-udevd", pid 1259, jiffies 4294903284 (age 294.152s)
>   hex dump (first 32 bytes):
>     68 6e 61 65 30 00 00 00 18 21 ba 1a c0 00 ff ff  hnae0....!......
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<0000000034783f26>] slab_post_alloc_hook+0xa0/0x3e0
>     [<00000000748188f2>] __kmem_cache_alloc_node+0x164/0x2b0
>     [<00000000ab0743e8>] __kmalloc_node_track_caller+0x6c/0x390
>     [<000000006c0ffb13>] kvasprintf+0x8c/0x118
>     [<00000000fa27bfe1>] kvasprintf_const+0x60/0xc8
>     [<0000000083e10ed7>] kobject_set_name_vargs+0x3c/0xc0
>     [<000000000b87affc>] dev_set_name+0x7c/0xa0
>     [<000000003fd8fe26>] hnae_ae_register+0xcc/0x190 [hnae]
>     [<00000000fe97edc9>] hns_dsaf_ae_init+0x9c/0x108 [hns_dsaf]
>     [<00000000c36ff1eb>] hns_dsaf_probe+0x548/0x748 [hns_dsaf]
> 
> [...]

Here is the summary with links:
  - [net] net: hns: fix possible memory leak in hnae_ae_register()
    https://git.kernel.org/netdev/net/c/ff2f5ec5d009

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


