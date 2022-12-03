Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E04664145D
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiLCFue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLCFua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:50:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F5D8B3BA
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 21:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34239B8236C
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 05:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A80B2C433B5;
        Sat,  3 Dec 2022 05:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670046624;
        bh=yQFK7dvbOnPVKjF54wZy4HrN0A2TaButCoSQ81nyeT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cP3/60CcdJphyUqoKdbBMNCFm3HLGfKKe5HTuBV2KyOCWqYr/bvHI/Vj3pPv6nz+Q
         fYJBCfw4rFel7qF5u/fE8NDSRtoREV32ZHM9Y5Ti2x9kflSiXBN+GMnkaIFCk4DwWG
         JGU7ff0v8iQZAdwml73oQ83RYKxUQn9RzXy8B4cDN1YZp5r0XT10tvsT+saYru1Z+C
         iTW0uA2rU3KaUI3SblTe/akRG5+QR0iFjpX0WInwZIOrurGCXrzu6Nhg2FcuU26FoJ
         9De8ZbPMZtWl+jMWmD9/yXgLPzS/WmtG4VM8X8u/umKW8a1RU6u/J5rNSZzG7X5HZo
         N1IDZZCO4NJ9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88867E29F40;
        Sat,  3 Dec 2022 05:50:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix sleep while atomic in
 mtk_wed_wo_queue_refill
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004662455.29967.4573439399775446639.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 05:50:24 +0000
References: <67ca94bdd3d9eaeb86e52b3050fbca0bcf7bb02f.1669908312.git.lorenzo@kernel.org>
In-Reply-To: <67ca94bdd3d9eaeb86e52b3050fbca0bcf7bb02f.1669908312.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Dec 2022 16:26:53 +0100 you wrote:
> In order to fix the following sleep while atomic bug always alloc pages
> with GFP_ATOMIC in mtk_wed_wo_queue_refill since page_frag_alloc runs in
> spin_lock critical section.
> 
> [    9.049719] Hardware name: MediaTek MT7986a RFB (DT)
> [    9.054665] Call trace:
> [    9.057096]  dump_backtrace+0x0/0x154
> [    9.060751]  show_stack+0x14/0x1c
> [    9.064052]  dump_stack_lvl+0x64/0x7c
> [    9.067702]  dump_stack+0x14/0x2c
> [    9.071001]  ___might_sleep+0xec/0x120
> [    9.074736]  __might_sleep+0x4c/0x9c
> [    9.078296]  __alloc_pages+0x184/0x2e4
> [    9.082030]  page_frag_alloc_align+0x98/0x1ac
> [    9.086369]  mtk_wed_wo_queue_refill+0x134/0x234
> [    9.090974]  mtk_wed_wo_init+0x174/0x2c0
> [    9.094881]  mtk_wed_attach+0x7c8/0x7e0
> [    9.098701]  mt7915_mmio_wed_init+0x1f0/0x3a0 [mt7915e]
> [    9.103940]  mt7915_pci_probe+0xec/0x3bc [mt7915e]
> [    9.108727]  pci_device_probe+0xac/0x13c
> [    9.112638]  really_probe.part.0+0x98/0x2f4
> [    9.116807]  __driver_probe_device+0x94/0x13c
> [    9.121147]  driver_probe_device+0x40/0x114
> [    9.125314]  __driver_attach+0x7c/0x180
> [    9.129133]  bus_for_each_dev+0x5c/0x90
> [    9.132953]  driver_attach+0x20/0x2c
> [    9.136513]  bus_add_driver+0x104/0x1fc
> [    9.140333]  driver_register+0x74/0x120
> [    9.144153]  __pci_register_driver+0x40/0x50
> [    9.148407]  mt7915_init+0x5c/0x1000 [mt7915e]
> [    9.152848]  do_one_initcall+0x40/0x25c
> [    9.156669]  do_init_module+0x44/0x230
> [    9.160403]  load_module+0x1f30/0x2750
> [    9.164135]  __do_sys_init_module+0x150/0x200
> [    9.168475]  __arm64_sys_init_module+0x18/0x20
> [    9.172901]  invoke_syscall.constprop.0+0x4c/0xe0
> [    9.177589]  do_el0_svc+0x48/0xe0
> [    9.180889]  el0_svc+0x14/0x50
> [    9.183929]  el0t_64_sync_handler+0x9c/0x120
> [    9.188183]  el0t_64_sync+0x158/0x15c
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill
    https://git.kernel.org/netdev/net-next/c/65e6af6cebef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


