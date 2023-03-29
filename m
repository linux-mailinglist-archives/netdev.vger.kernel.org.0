Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED936CCFF4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjC2CaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2CaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F76510F0;
        Tue, 28 Mar 2023 19:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B61C0B81FAC;
        Wed, 29 Mar 2023 02:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 530B7C433D2;
        Wed, 29 Mar 2023 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680057019;
        bh=QoF+PKmwmMTcX0Hg3+TzEjooPuR5Z8gFjdGStkE1TD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ILxWoaGoZN8at13CnPBRljcwoALfih+GvV5eSD5kYQv1BArqXXDGL82kP+pP2iVek
         EmYMnYTAgsoPlnKPEbY00Ymh88B/AMx4P/h6q2Al+14BjmWB0+V8t+EK6b7Lq9uYGj
         wxT85V9dMVDJUls2BgkT/05uSdIP1ONks1PcwTFqd0O5RYp+uh/EagGEjY3IykK0mm
         RDrS/Dj1HzKKYtXTJt1TQZdFM0YUbagvbjrafL5Hfj/XIXGbV++kPAkPKKNQ7847ap
         5K59NjAM7rZzBU8xpJxZU1JyOQggt67EVNFrLTE9v/0vPblCjd91Pwe5LGiwY0w/y1
         87DqwOK6aQosg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25BD2E50D74;
        Wed, 29 Mar 2023 02:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch V3 0/4] net, refcount: Address dst_entry reference count
 scalability issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168005701914.27658.17147408850533748612.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 02:30:19 +0000
References: <20230323102649.764958589@linutronix.de>
In-Reply-To: <20230323102649.764958589@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linuxfoundation.org,
        x86@kernel.org, wangyang.guo@intel.com, arjan@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, will@kernel.org,
        peterz@infradead.org, boqun.feng@gmail.com, mark.rutland@arm.com,
        maz@kernel.org, qiuxu.zhuo@intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 21:55:27 +0100 (CET) you wrote:
> Hi!
> 
> This is version 3 of this series. Version 2 can be found here:
> 
>      https://lore.kernel.org/lkml/20230307125358.772287565@linutronix.de
> 
> Wangyang and Arjan reported a bottleneck in the networking code related to
> struct dst_entry::__refcnt. Performance tanks massively when concurrency on
> a dst_entry increases.
> 
> [...]

Here is the summary with links:
  - [V3,1/4,V2,1/4] net: dst: Prevent false sharing vs. dst_entry:: __refcnt
    https://git.kernel.org/netdev/net-next/c/d288a162dd1c
  - [V3,2/4] atomics: Provide atomic_add_negative() variants
    https://git.kernel.org/netdev/net-next/c/e5ab9eff46b0
  - [V3,3/4] atomics: Provide rcuref - scalable reference counting
    https://git.kernel.org/netdev/net-next/c/ee1ee6db0779
  - [V3,4/4] net: dst: Switch to rcuref_t reference counting
    https://git.kernel.org/netdev/net-next/c/bc9d3a9f2afc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


