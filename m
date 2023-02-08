Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D970868E6FE
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjBHEU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBHEUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:20:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8202823E;
        Tue,  7 Feb 2023 20:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA102CE1DD9;
        Wed,  8 Feb 2023 04:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E82F1C4339B;
        Wed,  8 Feb 2023 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675830020;
        bh=U4GQLJyTsARaBKfrYmycFh9XU5Dd+XRhoXk8AVmi44c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rTXE9i6EJ8FWzrCwW3x3191Atwiqu21zFMj1pf4OP4oxWA14MtVzlYz0DQcDRwLVX
         HketLz37EpmPFqt1JXEOFKE0Ox0sDD7TDg6FUbD+xYENTvAMDQnhtXViJCPCmHdelC
         ra+QKLvw3039QXimEkQwq8qv3Diz/eaEdIDmN2Z2R+leWgHMCu2j6Wk1NGUljPQN4O
         KcEkrtO/Kz0DtYZxTV/VVz+FNMpB/DTFizmy+xSBtCvCwvobQx2EHy0ofSKdPmzehj
         Cb6uKoK1GDFZQrbPu58kR9pR+qwjLIPPqsmncKxWXDPZ2SseHSZG8jsvy2M9RJkrh2
         dC30CjjQM/sNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF85DE4D032;
        Wed,  8 Feb 2023 04:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on cpumask_local_spread()
 locality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583001977.19489.3612592708687977676.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 04:20:19 +0000
References: <20230121042436.2661843-1-yury.norov@gmail.com>
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        andriy.shevchenko@linux.intel.com, baohua@kernel.org,
        bsegall@google.com, dietmar.eggemann@arm.com, gal@nvidia.com,
        gregkh@linuxfoundation.org, bristot@redhat.com, hca@linux.ibm.com,
        mingo@redhat.com, jacob.e.keller@intel.com, kuba@kernel.org,
        jgg@nvidia.com, jesse.brandeburg@intel.com,
        Jonathan.Cameron@huawei.com, juri.lelli@redhat.com,
        leonro@nvidia.com, torvalds@linux-foundation.org, mgorman@suse.de,
        peter@n8pjl.ca, peterz@infradead.org, linux@rasmusvillemoes.dk,
        saeedm@nvidia.com, rostedt@goodmis.org, tariqt@nvidia.com,
        ttoukan.linux@gmail.com, tony.luck@intel.com, vschneid@redhat.com,
        vincent.guittot@linaro.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 20:24:27 -0800 you wrote:
> cpumask_local_spread() currently checks local node for presence of i'th
> CPU, and then if it finds nothing makes a flat search among all non-local
> CPUs. We can do it better by checking CPUs per NUMA hops.
> 
> This has significant performance implications on NUMA machines, for example
> when using NUMA-aware allocated memory together with NUMA-aware IRQ
> affinity hints.
> 
> [...]

Here is the summary with links:
  - [1/9] lib/find: introduce find_nth_and_andnot_bit
    https://git.kernel.org/netdev/net-next/c/43245117806f
  - [2/9] cpumask: introduce cpumask_nth_and_andnot
    https://git.kernel.org/netdev/net-next/c/62f4386e564d
  - [3/9] sched: add sched_numa_find_nth_cpu()
    https://git.kernel.org/netdev/net-next/c/cd7f55359c90
  - [4/9] cpumask: improve on cpumask_local_spread() locality
    https://git.kernel.org/netdev/net-next/c/406d394abfcd
  - [5/9] lib/cpumask: reorganize cpumask_local_spread() logic
    https://git.kernel.org/netdev/net-next/c/b1beed72b8b7
  - [6/9] sched/topology: Introduce sched_numa_hop_mask()
    https://git.kernel.org/netdev/net-next/c/9feae65845f7
  - [7/9] sched/topology: Introduce for_each_numa_hop_mask()
    https://git.kernel.org/netdev/net-next/c/06ac01721f7d
  - [8/9] net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity hints
    https://git.kernel.org/netdev/net-next/c/2acda57736de
  - [9/9] lib/cpumask: update comment for cpumask_local_spread()
    https://git.kernel.org/netdev/net-next/c/2ac4980c57f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


