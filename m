Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0449B6033B0
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJRUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJRUAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C130B7E81B;
        Tue, 18 Oct 2022 13:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB3FB82102;
        Tue, 18 Oct 2022 20:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 310DEC433D6;
        Tue, 18 Oct 2022 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666123217;
        bh=TtckORe7oVJmfBtYEFHgrR0/5B+0GsZkTwJZYIqMLWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lDYCjzQWaKxoOKyCD+JaoeInAS7OuaUUNfDQiA1yP6x4kSW7laFxmmm/VMFcMTIFG
         hq4Hm/nZwaU+qSb3s3lYkdtCk6d+dEdXxp8OkVkd4jucmUZEoUw/mE65eX2O7APM6V
         UaeNHrmEFMETE8g3RwXtxJ3whc0G6Tdc+cBc5jjWMCz13obe1YbzgZlJe/ss58jXFj
         vnVIaXN4ak7W05PsV0ZjNeuUkrf54M6adCQuLKFny0e6ffLApMavKevXiAMbPzJ+k0
         SrZfLud4P37m9ybSTM61CVkjDbmQVQPN65A0z7Hr3beqgE3ekLTJ6VBYTPhTn0hJiR
         19hbVhUgwN98g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B04AE21ED4;
        Tue, 18 Oct 2022 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: L2CAP: Fix memory leak in vhci_write
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166612321710.1440.974554274337472086.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Oct 2022 20:00:17 +0000
References: <20221018021851.2900-1-yin31149@gmail.com>
In-Reply-To: <20221018021851.2900-1-yin31149@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, 18801353760@163.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.von.dentz@intel.com, netdev@vger.kernel.org,
        syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Tue, 18 Oct 2022 10:18:51 +0800 you wrote:
> Syzkaller reports a memory leak as follows:
> ====================================
> BUG: memory leak
> unreferenced object 0xffff88810d81ac00 (size 240):
>   [...]
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff838733d9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:418
>     [<ffffffff833f742f>] alloc_skb include/linux/skbuff.h:1257 [inline]
>     [<ffffffff833f742f>] bt_skb_alloc include/net/bluetooth/bluetooth.h:469 [inline]
>     [<ffffffff833f742f>] vhci_get_user drivers/bluetooth/hci_vhci.c:391 [inline]
>     [<ffffffff833f742f>] vhci_write+0x5f/0x230 drivers/bluetooth/hci_vhci.c:511
>     [<ffffffff815e398d>] call_write_iter include/linux/fs.h:2192 [inline]
>     [<ffffffff815e398d>] new_sync_write fs/read_write.c:491 [inline]
>     [<ffffffff815e398d>] vfs_write+0x42d/0x540 fs/read_write.c:578
>     [<ffffffff815e3cdd>] ksys_write+0x9d/0x160 fs/read_write.c:631
>     [<ffffffff845e0645>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff845e0645>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ====================================
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: L2CAP: Fix memory leak in vhci_write
    https://git.kernel.org/bluetooth/bluetooth-next/c/97097c85c088

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


