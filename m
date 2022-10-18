Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF26027C0
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiJRJAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiJRJAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443B66EF03
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EBD5B81DC9
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E90FBC433D7;
        Tue, 18 Oct 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666083617;
        bh=Wfx60ublDI3lES9jdVuKp1xhMjMKqMyFT91XNahniQo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mDTOfgx1maxG+XZf08/RFEQRPRtF1VaCDCcByT5HO/rgP8f0PucqeUWNZmMF9vGPS
         sorUK2cCNuXw5Cx4shTES8f4KKt2gojIcCky853UMAINx8W/gPoKw2eGccRSPjw+nf
         KOixf/p6k+h0PcQ6eNp2lZb4bBg4DPZpsDmRPRkMxrbXaQib2nS1jsipjhc1Z/46td
         HJQK0wSaqPjpTIq2b85Ltd30sojDJokMRg9E5a1BncX7hp8jBoZSJpSoxST2NFfsqb
         LJkERV7rKT9i9GuF8HxPrPbTb829dlOO1DBgTCYRtN+0Y9rhiprvX1NVKkkiCwI1xq
         95ZTtpYN+mTEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7FADE270EF;
        Tue, 18 Oct 2022 09:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] udp: Update reuse->has_conns under reuseport_lock.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166608361680.8174.7892846658330148901.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Oct 2022 09:00:16 +0000
References: <20221014182625.89913-1-kuniyu@amazon.com>
In-Reply-To: <20221014182625.89913-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        martin.lau@kernel.org, kraig@google.com, willemb@google.com,
        kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 14 Oct 2022 11:26:25 -0700 you wrote:
> When we call connect() for a UDP socket in a reuseport group, we have
> to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
> could select a unconnected socket wrongly for packets sent to the
> connected socket.
> 
> However, the current way to set has_conns is illegal and possible to
> trigger that problem.  reuseport_has_conns() changes has_conns under
> rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
> it must do the update under the updater's lock, reuseport_lock, but
> it doesn't for now.
> 
> [...]

Here is the summary with links:
  - [v3,net] udp: Update reuse->has_conns under reuseport_lock.
    https://git.kernel.org/netdev/net/c/69421bf98482

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


