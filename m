Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14715633BC4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiKVLuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKVLuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B02FBC6;
        Tue, 22 Nov 2022 03:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3634F61697;
        Tue, 22 Nov 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85BA2C433D7;
        Tue, 22 Nov 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669117815;
        bh=/zS7Pr7e5Xanovjuklf1yfkYV5ZF1eCkUYWQVW0NhsE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=juS0abz8xN7Sz68Q6Re2PPgH7rzwkTA+DlKcfwh3eAgpMJ7NrdYVkDc6Ex5WmTn62
         JyvrirwjuTPYpL2681GzxVpEUAngZACJ6EqIR+mbJ+HS/fK+UYQpB5Y2Yc/hpiOBWU
         AezgZVCgquFi0haxGHB3KmoJ6hFOXFpREMENatO6zQVYt/jxRfvoPpeHh18yAx0sh+
         r6YGgKP1zAhfGXUiA2+g91Sr3wv3NntJNvl5P52d9DwrCtTYsnacv9uL4PfLSbJ49x
         gTzJPI7P1wJV/Nu5wuPm+ZnCiAzScmEzwWMNfaDGzZDmPGjRZiPZ18V2gYZlOph78M
         tY9lq+VneZVCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6AD80E270C9;
        Tue, 22 Nov 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: nci: fix memory leak in nci_rx_data_packet()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166911781543.29113.2456044355826533128.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 11:50:15 +0000
References: <20221118082419.239475-1-liushixin2@huawei.com>
In-Reply-To: <20221118082419.239475-1-liushixin2@huawei.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, 18 Nov 2022 16:24:19 +0800 you wrote:
> Syzbot reported a memory leak about skb:
> 
> unreferenced object 0xffff88810e144e00 (size 240):
>   comm "syz-executor284", pid 3701, jiffies 4294952403 (age 12.620s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff83ab79a9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:497
>     [<ffffffff82a5cf64>] alloc_skb include/linux/skbuff.h:1267 [inline]
>     [<ffffffff82a5cf64>] virtual_ncidev_write+0x24/0xe0 drivers/nfc/virtual_ncidev.c:116
>     [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:759 [inline]
>     [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:743 [inline]
>     [<ffffffff815f6503>] do_iter_write+0x253/0x300 fs/read_write.c:863
>     [<ffffffff815f66ed>] vfs_writev+0xdd/0x240 fs/read_write.c:934
>     [<ffffffff815f68f6>] do_writev+0xa6/0x1c0 fs/read_write.c:977
>     [<ffffffff848802d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff848802d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - NFC: nci: fix memory leak in nci_rx_data_packet()
    https://git.kernel.org/netdev/net/c/53270fb0fd77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


