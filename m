Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B1D56A9A0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbiGGR3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236406AbiGGR3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477D020F69
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 10:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34D361458
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 17:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE7EC3411E;
        Thu,  7 Jul 2022 17:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657214963;
        bh=hzTgXHxgJoHgC9UZ4FzsvDgBZh9NWdHDv3k0xZGQbk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L3HNQ45qRnnI7rd2sQVLR3J5JL67Cn54LOSYKo2pToe+3jFLtYEeeiSix/CdhZAug
         OOY2lcJOh8JpXNuDAS5epYolLMFIuNYVW1J5yWO+fkCTC0IBqT8ftVWDE092xelrzV
         Fh1uOdI6Yi9r061TgTZhxQznC+/BvP8BxXygPQFZAi48Ozz5NNB1xRMJiohJR8ECaC
         Tz6Jk0zHqTaJ13pKiqA4wgSmwR0rHDkCi8bs2IinTTHbbWk6lHAnDV3ZNbWgPtIKDD
         Vn9Nq0dKzNSmtcxsNZD+7l7rQ6XXKaKpEMuLs2Nb/QNTqDDMr501ymgXt+c4ulbE2c
         8SGA9xGloSMdA==
Date:   Thu, 7 Jul 2022 10:29:22 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 10/15] net/tls: Perform immediate device ctx cleanup
 when possible
Message-ID: <20220707172922.loqztmiwwij3ilgy@sx1>
References: <20220706232421.41269-1-saeed@kernel.org>
 <20220706232421.41269-11-saeed@kernel.org>
 <20220706192107.0b6fe869@kernel.org>
 <20220707065114.4tdx6f2lxig6lsof@sx1>
 <20220707091442.01354da7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220707091442.01354da7@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Jul 09:14, Jakub Kicinski wrote:
>On Wed, 6 Jul 2022 23:51:14 -0700 Saeed Mahameed wrote:
>> On 06 Jul 19:21, Jakub Kicinski wrote:
>> >On Wed,  6 Jul 2022 16:24:16 -0700 Saeed Mahameed wrote:
>> >> From: Tariq Toukan <tariqt@nvidia.com>
>> >>
>> >> TLS context destructor can be run in atomic context. Cleanup operations
>> >> for device-offloaded contexts could require access and interaction with
>> >> the device callbacks, which might sleep. Hence, the cleanup of such
>> >> contexts must be deferred and completed inside an async work.
>> >>
>> >> For all others, this is not necessary, as cleanup is atomic. Invoke
>> >> cleanup immediately for them, avoiding queueuing redundant gc work.
>> >>
>> >> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> >> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> >
>> >Not sure if posting core patches as part of driver PRs is a good idea,
>> >if I ack this now the tag will not propagate.
>>
>> I agree, how about the devlink lock removal  ? same thing ?
>
>I didn't have the same reaction to the devlink part, perhaps because
>of the clear driver dependency there and the fact we discussed that
>work thoroughly before.
>
>Looking at it again it seems like the problem is that these are really
>two independent series squashed together, no? Multiple driver features
>mixed up in a series is fine but when changing the core let's stick to
>clearer separation.
>
>The objective is to get reviewers engaged, and it's really easy to miss
>the core changes among the driver ones in a large multi-purpose series.
>

I see, i will make the separation when I have core patches.

>On the topic of PRs, does it matter to you if the core changes are
>posted as a PR? I presume it's okay for those to come out as a normal
>series with a proper subject and applied from the list?
No i don't mind that at all, it just means that some patchsets will have
to go different path than what i have for mlx5, not a big deal

