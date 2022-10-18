Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9579C602821
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiJRJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJRJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD618A1E0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EC39B81E11
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08B94C433D7;
        Tue, 18 Oct 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666084816;
        bh=vX0zAEqC82ax13d/HV5mQjJG/kldm44qQiXbPQI3kxU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C96gHwXfmoHvfMph6HUCvPr/QADQ86U8w4VoD3u3RS7x2jl/B6sYUaGM6NllpzDGz
         2Q0NzxqoY6CgliiZWfS+kVwragTbgh9KvAr9aHtWSIrVskLf+i4MN2ItLkSjlQseQZ
         Y4H/+89+dO3ZzRHYW2qQ0JrKmiZEJ4u4SvKGUcwSjcnc6126An0y0bqj68e720b8sh
         b7EyMQcF/oAbkCB3PmCNAIjUadKctpRvQMzdChTCoIe2JVktbDxFJF+fU4MBSDD7qe
         btvrUFrZ3Dbe9caJV6IhAM9i83i9X24oisYt1qTLgM3zDIAFCYpwOplq55oE6uLC8X
         abkIQb0T/4z2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E38B0E270EF;
        Tue, 18 Oct 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip6mr: fix UAF issue in ip6mr_sk_done() when
 addrconf_init_net() failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166608481592.2815.17700735863807978261.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Oct 2022 09:20:15 +0000
References: <20221017080331.16878-1-shaozhengchao@huawei.com>
In-Reply-To: <20221017080331.16878-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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

On Mon, 17 Oct 2022 16:03:31 +0800 you wrote:
> If the initialization fails in calling addrconf_init_net(), devconf_all is
> the pointer that has been released. Then ip6mr_sk_done() is called to
> release the net, accessing devconf->mc_forwarding directly causes invalid
> pointer access.
> 
> The process is as follows:
> setup_net()
> 	ops_init()
> 		addrconf_init_net()
> 		all = kmemdup(...)           ---> alloc "all"
> 		...
> 		net->ipv6.devconf_all = all;
> 		__addrconf_sysctl_register() ---> failed
> 		...
> 		kfree(all);                  ---> ipv6.devconf_all invalid
> 		...
> 	ops_exit_list()
> 		...
> 		ip6mr_sk_done()
> 			devconf = net->ipv6.devconf_all;
> 			//devconf is invalid pointer
> 			if (!devconf || !atomic_read(&devconf->mc_forwarding))
> 
> [...]

Here is the summary with links:
  - [net] ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
    https://git.kernel.org/netdev/net/c/1ca695207ed2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


