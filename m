Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0847FE04
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 16:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhL0PAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 10:00:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52074 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhL0PAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 10:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B57E6B810AF;
        Mon, 27 Dec 2021 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E029C36AEA;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640617210;
        bh=PDitx3l87QvqjyLvOLT4yEMezkebyTmyTSSdBBi5dAI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PzK9zD/NDd8Q/rKxWvRyZivRCDkWZ3xyrMJswJ5c4/KxXQWGarBsSf8+vtaHm6XE8
         RfWWkwTpz9DtsHsh7n9pQFqSgSzcJMUeLJYFVb2wsKVXs/zj2rEMHpq9rV5JuzO3IY
         xWzL0TF22jd3mRh0gGVVNJIZAVEepoSxd8a+mo8c0XqqFZ3xTq4z9vxzygj9/3xUvO
         vwtZ3Ac9Wt/szKD8VB9yu0hicSqjqRBMx14YsXFk514pyNiKyXJ4qv67AoTJxQH9Hx
         vl3uUEt1x4ATf6lTUu3/l/3vJjki83V6MPlRTcwnWSfiX9kRfSwnoGvR65Kr+fRHbO
         +qADK6+pT02pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44CD1C395E7;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [PATCH v2] atlantic: Fix buff_ring OOB in aq_ring_rx_clean
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164061721027.30887.13673531589236728477.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 15:00:10 +0000
References: <YcklzW522Gkew1zI@a-10-27-26-18.dynapool.vpn.nyu.edu>
In-Reply-To: <YcklzW522Gkew1zI@a-10-27-26-18.dynapool.vpn.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 26 Dec 2021 21:32:45 -0500 you wrote:
> The function obtain the next buffer without boundary check.
> We should return with I/O error code.
> 
> The bug is found by fuzzing and the crash report is attached.
> It is an OOB bug although reported as use-after-free.
> 
> [    4.804724] BUG: KASAN: use-after-free in aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
> [    4.805661] Read of size 4 at addr ffff888034fe93a8 by task ksoftirqd/0/9
> [    4.806505]
> [    4.806703] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.6.0 #34
> [    4.809030] Call Trace:
> [    4.809343]  dump_stack+0x76/0xa0
> [    4.809755]  print_address_description.constprop.0+0x16/0x200
> [    4.810455]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
> [    4.811234]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
> [    4.813183]  __kasan_report.cold+0x37/0x7c
> [    4.813715]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
> [    4.814393]  kasan_report+0xe/0x20
> [    4.814837]  aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
> [    4.815499]  ? hw_atl_b0_hw_ring_rx_receive+0x9a5/0xb90 [atlantic]
> [    4.816290]  aq_vec_poll+0x179/0x5d0 [atlantic]
> [    4.816870]  ? _GLOBAL__sub_I_65535_1_aq_pci_func_init+0x20/0x20 [atlantic]
> [    4.817746]  ? __next_timer_interrupt+0xba/0xf0
> [    4.818322]  net_rx_action+0x363/0xbd0
> [    4.818803]  ? call_timer_fn+0x240/0x240
> [    4.819302]  ? __switch_to_asm+0x40/0x70
> [    4.819809]  ? napi_busy_loop+0x520/0x520
> [    4.820324]  __do_softirq+0x18c/0x634
> [    4.820797]  ? takeover_tasklets+0x5f0/0x5f0
> [    4.821343]  run_ksoftirqd+0x15/0x20
> [    4.821804]  smpboot_thread_fn+0x2f1/0x6b0
> [    4.822331]  ? smpboot_unregister_percpu_thread+0x160/0x160
> [    4.823041]  ? __kthread_parkme+0x80/0x100
> [    4.823571]  ? smpboot_unregister_percpu_thread+0x160/0x160
> [    4.824301]  kthread+0x2b5/0x3b0
> [    4.824723]  ? kthread_create_on_node+0xd0/0xd0
> [    4.825304]  ret_from_fork+0x35/0x40
> 
> [...]

Here is the summary with links:
  - [v2] atlantic: Fix buff_ring OOB in aq_ring_rx_clean
    https://git.kernel.org/netdev/net/c/5f5015328845

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


