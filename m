Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CDB6BA27E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCNWaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCNWaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6563B497D5;
        Tue, 14 Mar 2023 15:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0928661A18;
        Tue, 14 Mar 2023 22:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59684C4339E;
        Tue, 14 Mar 2023 22:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678833019;
        bh=OQVLBM3xvw+tx6e/sAb6ilEJu81ZHDEpkwHblygJP80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PzEpY2/R8ULSFXmMfxgdpCKK6oOGvgdN87mN/FfwcMXee8RTkbURJmJj3x+PGHIGV
         RxhXrMt2A0MhAYoANKaUBFX0EEpn7F4mi7onp48OAGKHLTZnSiyJ7e6YOEwgiKpLT5
         7PAxEx7XqaJXU96b1p34VoHDM3DQFfpMUVCNky6Fbfzec7KAFZz5nIa8J3F//m37AS
         kaf3V6Ylm+rbcwr37DJiP+ZCUqw8dRWFL7O5rlkKYjvuOqCZCUj5H2Bjao1r8gy37P
         Wwgo4wR4uuCh4yJJhs8acf632uRJyNsSF3B/X1hS3oAZNXTiCwxUfXGsqmNOHLj1F/
         UA35ZFtUMWmwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 349E1E66CBC;
        Tue, 14 Mar 2023 22:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built from
 XDP frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167883301921.17343.13642424828615323388.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 22:30:19 +0000
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
In-Reply-To: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, maciej.fijalkowski@intel.com,
        larysa.zaremba@intel.com, toke@redhat.com, song@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, imagedong@tencent.com,
        mykolal@fb.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 13 Mar 2023 22:55:49 +0100 you wrote:
> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
> 
> __xdp_build_skb_from_frame() missed the moment when the networking stack
> became able to recycle skb pages backed by a page_pool. This was making
> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
> also affected in some scenarios.
> A lot of drivers use skb_mark_for_recycle() already, it's been almost
> two years and seems like there are no issues in using it in the generic
> code too. {__,}xdp_release_frame() can be then removed as it losts its
> last user.
> Page Pool becomes then zero-alloc (or almost) in the abovementioned
> cases, too. Other memory type models (who needs them at this point)
> have no changes.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/4] selftests/bpf: robustify test_xdp_do_redirect with more payload magics
    https://git.kernel.org/bpf/bpf-next/c/487deb3e3393
  - [bpf-next,v3,2/4] net: page_pool, skbuff: make skb_mark_for_recycle() always available
    https://git.kernel.org/bpf/bpf-next/c/2c854e5fcd7e
  - [bpf-next,v3,3/4] xdp: recycle Page Pool backed skbs built from XDP frames
    https://git.kernel.org/bpf/bpf-next/c/9c94bbf9a87b
  - [bpf-next,v3,4/4] xdp: remove unused {__,}xdp_release_frame()
    https://git.kernel.org/bpf/bpf-next/c/d4e492338d11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


