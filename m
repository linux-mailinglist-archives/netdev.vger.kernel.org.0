Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C85753E5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiGNRUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbiGNRUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABEC4E85F;
        Thu, 14 Jul 2022 10:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A83CFB8279B;
        Thu, 14 Jul 2022 17:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EEC6C341C6;
        Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657819214;
        bh=mwbikd27srKBB4H1oi//HqBqo/5GVj37mlD7K7FUkgA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i0M9UqPnWQFLgyHm4Z5KBRGohNmeutOSy85I3+8THypH/7W6Ot5JYIN7PyfYrjyFs
         XOXBtezsTNRndqDnZvi9a2rdWjDQsLxRdCUsLTIA585m6UkMGx5PpCC8/cKLt76Jzk
         XgWuVdip4t/iHftcShz8kuFoAtQm38WNf8Q4E0nxvgY/kt1Nt9z9h1HAmcbrxSyFtT
         00OEZmGv850vZ088Q4bY1ZiDuE16FcGP5Rjpop1oJFCeDFrug9yW44beUTDG7sl5Sm
         yk+HzJUoEPPjqjASsd//N+ov/q/JruLwH+6kBpydPh2/Jmf07UrvEwGIWNtwaSUCag
         UxQojyc3DaRhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7A4FE45227;
        Thu, 14 Jul 2022 17:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] xen/netback: avoid entering xenvif_rx_next_skb() with an
 empty rx queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165781921394.9202.6162247811572175997.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 17:20:13 +0000
References: <20220713135322.19616-1-jgross@suse.com>
In-Reply-To: <20220713135322.19616-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, stable@vger.kernel.org, jbeulich@suse.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Jul 2022 15:53:22 +0200 you wrote:
> xenvif_rx_next_skb() is expecting the rx queue not being empty, but
> in case the loop in xenvif_rx_action() is doing multiple iterations,
> the availability of another skb in the rx queue is not being checked.
> 
> This can lead to crashes:
> 
> [40072.537261] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> [40072.537407] IP: xenvif_rx_skb+0x23/0x590 [xen_netback]
> [40072.537534] PGD 0 P4D 0
> [40072.537644] Oops: 0000 [#1] SMP NOPTI
> [40072.537749] CPU: 0 PID: 12505 Comm: v1-c40247-q2-gu Not tainted 4.12.14-122.121-default #1 SLE12-SP5
> [40072.537867] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 11/23/2021
> [40072.537999] task: ffff880433b38100 task.stack: ffffc90043d40000
> [40072.538112] RIP: e030:xenvif_rx_skb+0x23/0x590 [xen_netback]
> [40072.538217] RSP: e02b:ffffc90043d43de0 EFLAGS: 00010246
> [40072.538319] RAX: 0000000000000000 RBX: ffffc90043cd7cd0 RCX: 00000000000000f7
> [40072.538430] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffc90043d43df8
> [40072.538531] RBP: 000000000000003f R08: 000077ff80000000 R09: 0000000000000008
> [40072.538644] R10: 0000000000007ff0 R11: 00000000000008f6 R12: ffffc90043ce2708
> [40072.538745] R13: 0000000000000000 R14: ffffc90043d43ed0 R15: ffff88043ea748c0
> [40072.538861] FS: 0000000000000000(0000) GS:ffff880484600000(0000) knlGS:0000000000000000
> [40072.538988] CS: e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [40072.539088] CR2: 0000000000000080 CR3: 0000000407ac8000 CR4: 0000000000040660
> [40072.539211] Call Trace:
> [40072.539319] xenvif_rx_action+0x71/0x90 [xen_netback]
> [40072.539429] xenvif_kthread_guest_rx+0x14a/0x29c [xen_netback]
> 
> [...]

Here is the summary with links:
  - [v2] xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
    https://git.kernel.org/netdev/net/c/94e810067888

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


