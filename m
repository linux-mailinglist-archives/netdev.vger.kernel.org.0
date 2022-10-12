Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8815FC1DD
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJLIVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJLIUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168B2A7A8F
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2C2261348
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FA58C433D7;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665562816;
        bh=ehZvcWKRexhzT6nq4OD0O4rIW9gh5qg6UqXHmVQSsgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f8WZkun3etQCVtvMX+JegoF3JpI+42w+f3lgXKWWSWz/gIMz0Ze8+CwlfzB/fdyJ+
         cN5dqxTnprOPqqBEMy6lNKob/tN9PJsDOlac4jShWAWAS16kPhU+Dy69TcQA5NUIKg
         JCvsjMrSVysXnJ9HWhgxGlmfQ5J0f2YsbOZgmZB6pG3FisCeOYJlxrQLWZr0v3h4XL
         nj5KLC8lcGS2bGkFsz+mSYdDauBbyz8HuG8Fz7PWuz+AHxlG9T7Xwng0aKSbEvHd+X
         xJRY2JCIqsuYRL/Sg9g3JJUCBXrVG+6TS686DAtkPGpUdyr5COtnNJ2nJ3wL5Fc6XW
         +vCe0hCNJB8zQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34235E21EC5;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net/mlx5: Make ASO poll CQ usable in atomic context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166556281621.4495.12120662116539689622.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 08:20:16 +0000
References: <ddf073ea964de8fd8984961ffe3dcb78559b08ac.1665493459.git.leonro@nvidia.com>
In-Reply-To: <ddf073ea964de8fd8984961ffe3dcb78559b08ac.1665493459.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        edumazet@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        saeedm@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Oct 2022 16:14:55 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Poll CQ functions shouldn't sleep as they are called in atomic context.
> The following splat appears once the mlx5_aso_poll_cq() is used in such
> flow.
> 
>  BUG: scheduling while atomic: swapper/17/0/0x00000100
>  Modules linked in: sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs ib_core fuse [last unloaded: mlx5_core]
>  CPU: 17 PID: 0 Comm: swapper/17 Tainted: G        W          6.0.0-rc2+ #13
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>  Call Trace:
>   <IRQ>
>   dump_stack_lvl+0x34/0x44
>   __schedule_bug.cold+0x47/0x53
>   __schedule+0x4b6/0x670
>   ? hrtimer_start_range_ns+0x28d/0x360
>   schedule+0x50/0x90
>   schedule_hrtimeout_range_clock+0x98/0x120
>   ? __hrtimer_init+0xb0/0xb0
>   usleep_range_state+0x60/0x90
>   mlx5_aso_poll_cq+0xad/0x190 [mlx5_core]
>   mlx5e_ipsec_aso_update_curlft+0x81/0xb0 [mlx5_core]
>   xfrm_timer_handler+0x6b/0x360
>   ? xfrm_find_acq_byseq+0x50/0x50
>   __hrtimer_run_queues+0x139/0x290
>   hrtimer_run_softirq+0x7d/0xe0
>   __do_softirq+0xc7/0x272
>   irq_exit_rcu+0x87/0xb0
>   sysvec_apic_timer_interrupt+0x72/0x90
>   </IRQ>
>   <TASK>
>   asm_sysvec_apic_timer_interrupt+0x16/0x20
>  RIP: 0010:default_idle+0x18/0x20
>  Code: ae 7d ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 8b 05 b5 30 0d 01 85 c0 7e 07 0f 00 2d 0a e3 53 00 fb f4 <c3> 0f 1f 80 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 80 ad 01 00
>  RSP: 0018:ffff888100883ee0 EFLAGS: 00000242
>  RAX: 0000000000000001 RBX: ffff888100849580 RCX: 4000000000000000
>  RDX: 0000000000000001 RSI: 0000000000000083 RDI: 000000000008863c
>  RBP: 0000000000000011 R08: 00000064e6977fa9 R09: 0000000000000001
>  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   default_idle_call+0x37/0xb0
>   do_idle+0x1cd/0x1e0
>   cpu_startup_entry+0x19/0x20
>   start_secondary+0xfe/0x120
>   secondary_startup_64_no_verify+0xcd/0xdb
>   </TASK>
>  softirq: huh, entered softirq 8 HRTIMER 00000000a97c08cb with preempt_count 00000100, exited with 00000000?
> 
> [...]

Here is the summary with links:
  - [net,v1] net/mlx5: Make ASO poll CQ usable in atomic context
    https://git.kernel.org/netdev/net/c/739cfa34518e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


