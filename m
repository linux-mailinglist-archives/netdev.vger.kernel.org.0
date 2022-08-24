Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584F959FABD
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbiHXNB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbiHXNAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E673081684
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8358D6162F
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAD6CC433D7;
        Wed, 24 Aug 2022 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661346020;
        bh=dUHr1oi96lmP/PzmstDaNYL661iwoDXcKwAPtP/COa4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DLgc8axnsPScMb6dIWHNJdtvUslquJwWmWEFd31vGPtCCRF3GBzlyT6WSRGp6DCRC
         RBg3ObW5Z5OownDM7EX7XCDg+dlpC4cD1RqeEZI1pM5+UzZgjuV4OC0fyqqzxFhL08
         m/YbCK0yJNa1d54YXix+ig3k4cPgi3G1wDZ8PY95fyQOXdgAj9HAWSKs+PmlqIph2s
         kS/tMhWT9f7znVFtWazmi//vyBD7JwwdbkURTxmYLGhwgAKgrmsvqrs5YncUolrB5+
         UKNDjpa0NgjR7bboF/HeLzK+8/hzjbhg0MKq8LsJMEQJs+4EAQn6rGqc7YP97RXEgc
         uDsaXpqUsjwBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF5BCC04E59;
        Wed, 24 Aug 2022 13:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net 00/17] net: sysctl: Fix data-races around net.core.XXX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134602077.6797.12204234347972679946.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 13:00:20 +0000
References: <20220823174700.88411-1-kuniyu@amazon.com>
In-Reply-To: <20220823174700.88411-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Aug 2022 10:46:43 -0700 you wrote:
> This series fixes data-races around all knobs in net_core_table and
> netns_core_table except for bpf stuff.
> 
> These knobs are skipped:
> 
>   - 4 bpf knobs
>   - netdev_rss_key: Written only once by net_get_random_once() and
>                     read-only knob
>   - rps_sock_flow_entries: Protected with sock_flow_mutex
>   - flow_limit_cpu_bitmap: Protected with flow_limit_update_mutex
>   - flow_limit_table_len: Protected with flow_limit_update_mutex
>   - default_qdisc: Protected with qdisc_mod_lock
>   - warnings: Unused
>   - high_order_alloc_disable: Protected with static_key_mutex
>   - skb_defer_max: Already using READ_ONCE()
>   - sysctl_txrehash: Already using READ_ONCE()
> 
> [...]

Here is the summary with links:
  - [v4,net,01/17] net: Fix data-races around sysctl_[rw]mem_(max|default).
    https://git.kernel.org/netdev/net/c/1227c1771dd2
  - [v4,net,02/17] net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
    https://git.kernel.org/netdev/net/c/bf955b5ab8f6
  - [v4,net,03/17] net: Fix data-races around netdev_max_backlog.
    https://git.kernel.org/netdev/net/c/5dcd08cd1991
  - [v4,net,04/17] net: Fix data-races around netdev_tstamp_prequeue.
    https://git.kernel.org/netdev/net/c/61adf447e386
  - [v4,net,05/17] ratelimit: Fix data-races in ___ratelimit().
    https://git.kernel.org/netdev/net/c/6bae8ceb90ba
  - [v4,net,06/17] net: Fix data-races around sysctl_optmem_max.
    https://git.kernel.org/netdev/net/c/7de6d09f5191
  - [v4,net,07/17] net: Fix a data-race around sysctl_tstamp_allow_data.
    https://git.kernel.org/netdev/net/c/d2154b0afa73
  - [v4,net,08/17] net: Fix a data-race around sysctl_net_busy_poll.
    https://git.kernel.org/netdev/net/c/c42b7cddea47
  - [v4,net,09/17] net: Fix a data-race around sysctl_net_busy_read.
    https://git.kernel.org/netdev/net/c/e59ef36f0795
  - [v4,net,10/17] net: Fix a data-race around netdev_budget.
    https://git.kernel.org/netdev/net/c/2e0c42374ee3
  - [v4,net,11/17] net: Fix data-races around sysctl_max_skb_frags.
    https://git.kernel.org/netdev/net/c/657b991afb89
  - [v4,net,12/17] net: Fix a data-race around netdev_budget_usecs.
    https://git.kernel.org/netdev/net/c/fa45d484c52c
  - [v4,net,13/17] net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
    https://git.kernel.org/netdev/net/c/af67508ea6cb
  - [v4,net,14/17] net: Fix data-races around sysctl_devconf_inherit_init_net.
    https://git.kernel.org/netdev/net/c/a5612ca10d1a
  - [v4,net,15/17] net: Fix a data-race around gro_normal_batch.
    https://git.kernel.org/netdev/net/c/8db24af3f02e
  - [v4,net,16/17] net: Fix a data-race around netdev_unregister_timeout_secs.
    https://git.kernel.org/netdev/net/c/05e49cfc89e4
  - [v4,net,17/17] net: Fix a data-race around sysctl_somaxconn.
    https://git.kernel.org/netdev/net/c/3c9ba81d7204

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


