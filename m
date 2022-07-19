Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C00579169
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiGSDk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiGSDkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:40:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D683562D1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 110E2CE1A92
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43E44C341CE;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202014;
        bh=cCUCHXpno9wMc2LrYcDSHaxfzP6r2TFqRerANFq10Uk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XWfKdNbeRVb9VmdDK7xuY+Xr2KDMOK4R5bQUGOCs971zmhqTlKdYMUEmMWBPWuzK1
         iZPJ7LmGyv1aGk7X78OHJ/NAgKdnqfvntToQa96zYIFHIY3OTKtiZ+9gQi/kz4fe1A
         Vilqglt9CzQYybM2RrECYpN6yQrlrUiVW5TXXNs14oIez2c1QHa3mqvOwfKcLw6qeB
         BK5uBsWaQrG5KWAw0OFOLsx2qOAohbUtnymDrSESMPND7UgWmQjY3xSNhTlbIWW0Ss
         3vFN+tfJlacRGXO4GBcB+DxaNLqji5UJTW7QgNIF8JsFMbLHizXdWRA19ItHu90Gww
         hh5obI3hutwpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A3D0E451B9;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] ixgbe: Add locking to prevent panic when setting
 sriov_numvfs to zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820201416.29134.18018200682925789592.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:40:14 +0000
References: <20220715214456.2968711-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220715214456.2968711-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, piotrx.skajewski@intel.com,
        netdev@vger.kernel.org, marek.szlosek@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 15 Jul 2022 14:44:56 -0700 you wrote:
> From: Piotr Skajewski <piotrx.skajewski@intel.com>
> 
> It is possible to disable VFs while the PF driver is processing requests
> from the VF driver.  This can result in a panic.
> 
> BUG: unable to handle kernel paging request at 000000000000106c
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP NOPTI
> CPU: 8 PID: 0 Comm: swapper/8 Kdump: loaded Tainted: G I      --------- -
> Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS 2.8.2 08/27/2020
> RIP: 0010:ixgbe_msg_task+0x4c8/0x1690 [ixgbe]
> Code: 00 00 48 8d 04 40 48 c1 e0 05 89 7c 24 24 89 fd 48 89 44 24 10 83 ff
> 01 0f 84 b8 04 00 00 4c 8b 64 24 10 4d 03 a5 48 22 00 00 <41> 80 7c 24 4c
> 00 0f 84 8a 03 00 00 0f b7 c7 83 f8 08 0f 84 8f 0a
> RSP: 0018:ffffb337869f8df8 EFLAGS: 00010002
> RAX: 0000000000001020 RBX: 0000000000000000 RCX: 000000000000002b
> RDX: 0000000000000002 RSI: 0000000000000008 RDI: 0000000000000006
> RBP: 0000000000000006 R08: 0000000000000002 R09: 0000000000029780
> R10: 00006957d8f42832 R11: 0000000000000000 R12: 0000000000001020
> R13: ffff8a00e8978ac0 R14: 000000000000002b R15: ffff8a00e8979c80
> FS:  0000000000000000(0000) GS:ffff8a07dfd00000(0000) knlGS:00000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000000106c CR3: 0000000063e10004 CR4: 00000000007726e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <IRQ>
>  ? ttwu_do_wakeup+0x19/0x140
>  ? try_to_wake_up+0x1cd/0x550
>  ? ixgbevf_update_xcast_mode+0x71/0xc0 [ixgbevf]
>  ixgbe_msix_other+0x17e/0x310 [ixgbe]
>  __handle_irq_event_percpu+0x40/0x180
>  handle_irq_event_percpu+0x30/0x80
>  handle_irq_event+0x36/0x53
>  handle_edge_irq+0x82/0x190
>  handle_irq+0x1c/0x30
>  do_IRQ+0x49/0xd0
>  common_interrupt+0xf/0xf
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero
    https://git.kernel.org/netdev/net/c/1e53834ce541

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


