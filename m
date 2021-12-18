Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC10C479867
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhLRDaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhLRDaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F4F662474
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 03:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E817CC36AEB;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798214;
        bh=c2HV2ydJ19XWl1N9LzJGSmGhMVLlc2FKIsatb+BsuZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VCdU/iDi/gpjlgAvkYdkthxpinGnHSVrJcXDDSR3HGTf0MshM/4RL0XbB43k8Uogz
         Zn5q0W2RkHoPUbYsN77cRikzi7pzJV+ZL0flVn+OEzKJ/cGlVVXpYYEBTZ+1mcwS4P
         Wb7ytxkwnp+yl7R76sNloVz5TO4QnWrjkoVS5ganmmZm1EdchjwDkb7kEA+NgcWhtz
         mkWw8nVraHhoqMUYe0aQTMAawmXV0YEu9fvP65sCln/27wvRSClcOTzPqjhf8TMO1p
         jUtI8FoE+VSUyYvfzZHYR678V3rKM5L7DyKFhU3XevOcKU1TWImCPedkr9ZvurEO77
         HIP6/kejrSe/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7F8160A9C;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] Revert "tipc: use consistent GFP flags"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821481.17814.15580127130042872658.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:14 +0000
References: <20211217030059.5947-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20211217030059.5947-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, eric.dumazet@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Dec 2021 10:00:59 +0700 you wrote:
> This reverts commit 86c3a3e964d910a62eeb277d60b2a60ebefa9feb.
> 
> The tipc_aead_init() function can be calling from an interrupt routine.
> This allocation might sleep with GFP_KERNEL flag, hence the following BUG
> is reported.
> 
> [   17.657509] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:230
> [   17.660916] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/3
> [   17.664093] preempt_count: 302, expected: 0
> [   17.665619] RCU nest depth: 2, expected: 0
> [   17.667163] Preemption disabled at:
> [   17.667165] [<0000000000000000>] 0x0
> [   17.669753] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G        W         5.16.0-rc4+ #1
> [   17.673006] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [   17.675540] Call Trace:
> [   17.676285]  <IRQ>
> [   17.676913]  dump_stack_lvl+0x34/0x44
> [   17.678033]  __might_resched.cold+0xd6/0x10f
> [   17.679311]  kmem_cache_alloc_trace+0x14d/0x220
> [   17.680663]  tipc_crypto_start+0x4a/0x2b0 [tipc]
> [   17.682146]  ? kmem_cache_alloc_trace+0xd3/0x220
> [   17.683545]  tipc_node_create+0x2f0/0x790 [tipc]
> [   17.684956]  tipc_node_check_dest+0x72/0x680 [tipc]
> [   17.686706]  ? ___cache_free+0x31/0x350
> [   17.688008]  ? skb_release_data+0x128/0x140
> [   17.689431]  tipc_disc_rcv+0x479/0x510 [tipc]
> [   17.690904]  tipc_rcv+0x71c/0x730 [tipc]
> [   17.692219]  ? __netif_receive_skb_core+0xb7/0xf60
> [   17.693856]  tipc_l2_rcv_msg+0x5e/0x90 [tipc]
> [   17.695333]  __netif_receive_skb_list_core+0x20b/0x260
> [   17.697072]  netif_receive_skb_list_internal+0x1bf/0x2e0
> [   17.698870]  ? dev_gro_receive+0x4c2/0x680
> [   17.700255]  napi_complete_done+0x6f/0x180
> [   17.701657]  virtnet_poll+0x29c/0x42e [virtio_net]
> [   17.703262]  __napi_poll+0x2c/0x170
> [   17.704429]  net_rx_action+0x22f/0x280
> [   17.705706]  __do_softirq+0xfd/0x30a
> [   17.706921]  common_interrupt+0xa4/0xc0
> [   17.708206]  </IRQ>
> [   17.708922]  <TASK>
> [   17.709651]  asm_common_interrupt+0x1e/0x40
> [   17.711078] RIP: 0010:default_idle+0x18/0x20
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "tipc: use consistent GFP flags"
    https://git.kernel.org/netdev/net/c/f845fe5819ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


