Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106A960B901
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiJXT7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiJXT6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:58:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAA927E2F9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD041B811B3
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79910C43140;
        Mon, 24 Oct 2022 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666635618;
        bh=AVp3irldjVDAO75aJpbv49xJ4YbWQgsoehBRtCro2CQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jEmjtJM3bhDl8MOOyIHjfU+NFBPTOp0/MUy5dmEmizkgNLF0BhjMAC/ILo7+LOsDV
         /XrQiMOmlHjfHE11IwPTX8oBYiKhkf3bPIIaeeWvKoP7u2L/kz5pU7qHRBsscilP10
         TVP3cJlZZcJnZ2RtyEPQwzYlfSdqnTv8hvGB5eIXMG3V8Kdlvj64QLjJmHtJmKPeLN
         LLlZXg3iuu/Ldesu9netkrXsrlX+sLflc3D1hedGOTq+AguW5R41Qh4+J8h+9Rpgtl
         THezYutipzsr3RaGXLjr0WiujmDUec6bPkfcAEm9XgCds1Sfg0aAQZvS02+rUa1WUx
         +0Pnpi8npFBJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A6DAE29F30;
        Mon, 24 Oct 2022 18:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix indefinite deferral of RTO with SACK reneging
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166663561836.26708.18423016034040154730.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 18:20:18 +0000
References: <20221021170821.1093930-1-ncardwell.kernel@gmail.com>
In-Reply-To: <20221021170821.1093930-1-ncardwell.kernel@gmail.com>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        netdev@vger.kernel.org, ncardwell@google.com, ntspring@fb.com,
        ycheng@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 21 Oct 2022 17:08:21 +0000 you wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> This commit fixes a bug that can cause a TCP data sender to repeatedly
> defer RTOs when encountering SACK reneging.
> 
> The bug is that when we're in fast recovery in a scenario with SACK
> reneging, every time we get an ACK we call tcp_check_sack_reneging()
> and it can note the apparent SACK reneging and rearm the RTO timer for
> srtt/2 into the future. In some SACK reneging scenarios that can
> happen repeatedly until the receive window fills up, at which point
> the sender can't send any more, the ACKs stop arriving, and the RTO
> fires at srtt/2 after the last ACK. But that can take far too long
> (O(10 secs)), since the connection is stuck in fast recovery with a
> low cwnd that cannot grow beyond ssthresh, even if more bandwidth is
> available.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix indefinite deferral of RTO with SACK reneging
    https://git.kernel.org/netdev/net/c/3d2af9cce313

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


