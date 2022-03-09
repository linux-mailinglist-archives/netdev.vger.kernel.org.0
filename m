Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315444D3D37
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiCIWnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiCIWnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:43:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92716122218;
        Wed,  9 Mar 2022 14:42:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3112561C31;
        Wed,  9 Mar 2022 22:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93856C340F4;
        Wed,  9 Mar 2022 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646865726;
        bh=VGrK/lY6hU91nS5eVUxRG/6vvQWkMFm7/XqjabM4iBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d2+Net85QYOU8xxkVAQeCemAQdyU5STf58cQNGynZzCbCcrEhM4xYMfnkuHRC5ZcN
         hwu9HIuwDu4StwB8Nh22hqekvXxp2dSnO6pHbodhLWtB8tw1IfiwRn7hCYEoxZgeZn
         123Z85kzYIPVL+5x/anaeuysh9lAV9p+ltGfEifCuZiARNAvUu0v5MH2LrfdpQBdKi
         AI+4jBU7phD1Gs1fTuiRKUTektLPYgcgiOQsxvdxlDaEvT/BdBawLOZSAlb44G4xfb
         7yLp3gH/NI3zk2xIX1lMkI/GqkBZodMqVF+FOfdBYmbo88eIPu/4y1ZIsraZPZjJ2o
         2nMKLLy42BZhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72002E7BB08;
        Wed,  9 Mar 2022 22:42:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v11 0/5] Add support for transmitting packets using
 XDP in bpf_prog_run()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164686572644.6474.17558582597165654953.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 22:42:06 +0000
References: <20220309105346.100053-1-toke@redhat.com>
In-Reply-To: <20220309105346.100053-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 11:53:41 +0100 you wrote:
> This series adds support for transmitting packets using XDP in
> bpf_prog_run(), by enabling a new mode "live packet" mode which will handle
> the XDP program return codes and redirect the packets to the stack or other
> devices.
> 
> The primary use case for this is testing the redirect map types and the
> ndo_xdp_xmit driver operation without an external traffic generator. But it
> turns out to also be useful for creating a programmable traffic generator
> in XDP, as well as injecting frames into the stack. A sample traffic
> generator, which was included in previous versions of the series, but now
> moved to xdp-tools, transmits up to 9 Mpps/core on my test machine.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v11,1/5] bpf: Add "live packet" mode for XDP in BPF_PROG_RUN
    https://git.kernel.org/bpf/bpf-next/c/b530e9e1063e
  - [bpf-next,v11,2/5] Documentation/bpf: Add documentation for BPF_PROG_RUN
    https://git.kernel.org/bpf/bpf-next/c/1a7551f15097
  - [bpf-next,v11,3/5] libbpf: Support batch_size option to bpf_prog_test_run
    https://git.kernel.org/bpf/bpf-next/c/24592ad1ab18
  - [bpf-next,v11,4/5] selftests/bpf: Move open_netns() and close_netns() into network_helpers.c
    https://git.kernel.org/bpf/bpf-next/c/a30338840fa5
  - [bpf-next,v11,5/5] selftests/bpf: Add selftest for XDP_REDIRECT in BPF_PROG_RUN
    https://git.kernel.org/bpf/bpf-next/c/55fcacca3646

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


