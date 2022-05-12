Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BA452420E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 03:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiELBaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 21:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiELBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 21:30:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8601B174E;
        Wed, 11 May 2022 18:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A812CE27DD;
        Thu, 12 May 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9579CC34117;
        Thu, 12 May 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652319013;
        bh=m5acg99mSq3zpG/3PXvxW8EnYwk4V14uo7lZl0qIYx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aVhYB4aesnC2yqwl7d20vjBh++kf35nLMMDnXTVV3ORIsvHPPS9ggTYycIqaZu+1x
         eyGkEXrfG9WRVuGHbTg30K0+ZD8BSURYyj+RbI3Q0h2v+VLKUJwlmeuQS7ladgE/Py
         lUvvgq9ks1NedWXkIjCMNXZi4gH+EylIKwrlgIySHFQiKgMbU1JPE57n3iigh8KTLA
         n4QctZLYA7eX4eG7m92l53lvcccI5hUdwX/WqPXo8rhsdknvIG5sraCq2mLuiTcSpN
         vyvdPRUHOVfyhejXPT/USs8VzMkHSCCBeb4PQLjmYbHHidNLW38KFQEFJr/kfxSAtB
         XbZ0KvrPpPp4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72E93E8DBDA;
        Thu, 12 May 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Introduce access remote cpu elem support in
 BPF percpu map
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165231901346.29050.11394051230756915389.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 01:30:13 +0000
References: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        wangdongdong.6@bytedance.com, cong.wang@bytedance.com,
        zhouchengming@bytedance.com, yosryahmed@google.com
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 11 May 2022 17:38:52 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Trace some functions, such as enqueue_task_fair, need to access the
> corresponding cpu, not the current cpu, and bpf_map_lookup_elem percpu map
> cannot do it. So add bpf_map_lookup_percpu_elem to accomplish it for
> percpu_array_map, percpu_hash_map, lru_percpu_hash_map.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: add bpf_map_lookup_percpu_elem for percpu map
    https://git.kernel.org/bpf/bpf-next/c/07343110b293
  - [bpf-next,v2,2/2] selftests/bpf: add test case for bpf_map_lookup_percpu_elem
    https://git.kernel.org/bpf/bpf-next/c/ed7c13776e20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


