Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048E55A18E7
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbiHYSk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242158AbiHYSkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737883ED71;
        Thu, 25 Aug 2022 11:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D217B82A2E;
        Thu, 25 Aug 2022 18:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4438C433C1;
        Thu, 25 Aug 2022 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661452816;
        bh=pGsnlrzUs9rFUKA1BHRL6k9aWIJQ/q1skMQLzZaS5rQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vM36CzAGqCstVAofRH9O8k5B6COSFFRc+vCFwFrBdU7R9OnoQVPqY0DkHa5JM9i8L
         TAUmmFH7jtb/DaN0+YZv+A86P9T8xmlwUyV0crgMZp3EBo85OOs9G6HFpqaCc9wHzW
         JdgQaq/7atIsuDMOw7T3hD2EobDzYo2LxLm6sf/ZTvbf2UNQ6CaUtiRhRWOcJK+WEf
         M96F91YU3Rc74GntKdLTgW1DaGTk0oq902MubZkNIfqsCb4p/D2G3wMNn81Icltbj2
         D86xRDTrAmLpl87DmyfAF/9VDG9/hdWmHmZpvS8ZPAtgF6GDy8dbsU3/XKus39XLq4
         NCKLF1zTG1Wdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94146E2A03C;
        Thu, 25 Aug 2022 18:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145281660.28094.16612223815048062311.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 18:40:16 +0000
References: <20220824030031.1013441-1-haoluo@google.com>
In-Reply-To: <20220824030031.1013441-1-haoluo@google.com>
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, tj@kernel.org,
        lizefan.x@bytedance.com, kpsingh@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        mkoutny@suse.com, roman.gushchin@linux.dev, rientjes@google.com,
        sdf@google.com, shakeelb@google.com, yosryahmed@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 23 Aug 2022 20:00:26 -0700 you wrote:
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats percpu and
> propagate them through the cgroup hierarchy.
> 
> The stats are exposed to userspace in textual form by reading files in
> bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> - walking a cgroup's descendants in pre-order.
> - walking a cgroup's descendants in post-order.
> - walking a cgroup's ancestors.
> - process only a single object.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v9,1/5] bpf: Introduce cgroup iter
    https://git.kernel.org/bpf/bpf-next/c/d4ccaf58a847
  - [bpf-next,v9,2/5] selftests/bpf: Test cgroup_iter.
    https://git.kernel.org/bpf/bpf-next/c/fe0dd9d4b740
  - [bpf-next,v9,3/5] cgroup: bpf: enable bpf programs to integrate with rstat
    https://git.kernel.org/bpf/bpf-next/c/a319185be9f5
  - [bpf-next,v9,4/5] selftests/bpf: extend cgroup helpers
    https://git.kernel.org/bpf/bpf-next/c/434992bb6037
  - [bpf-next,v9,5/5] selftests/bpf: add a selftest for cgroup hierarchical stats collection
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


