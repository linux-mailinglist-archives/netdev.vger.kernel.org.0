Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31D754CB90
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbiFOOmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348001AbiFOOkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 10:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A6D31DC3;
        Wed, 15 Jun 2022 07:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AA04B81EAA;
        Wed, 15 Jun 2022 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9738DC3411C;
        Wed, 15 Jun 2022 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655304013;
        bh=wUKIpD5mViMom0zx5vefjmKD76K/NxZlyeucxykzhV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uhAevbgdLjZFe7oz7H9cdF+T8bEuywC1LcUB5CD77I/wBH/TCtc4ppnBP5Fhj2Dub
         1zKSAI4AFKMShxi5eXyjHNK2nOjGnTy7F876X5a5lAGKiSGcd3qPMFZ0mfl8/UC1wi
         JcwA4wDgIMLi4BC7srNfehJJ1NJ5Tp2u3Zhkt/OMnqCZbQUqRpPPRq3UfVB7PoDpK1
         VaZ6nbyZ8tqbdVbec9BjXWXP0QInePP54NR4zZIQ+D+8ie8lq0iKllp1XYu6ruvzVf
         bAo461Fj709qSrcSmjHspBfC8P8Lg87mcQh0ik0NWC62kSS4WthxsXmkwmUbUgIB7j
         K3SMFrZ++wZDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A641E6D466;
        Wed, 15 Jun 2022 14:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: bpf: fix request_sock leak in filter.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165530401349.30434.14644430973088453576.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 14:40:13 +0000
References: <20220615011540.813025-1-jmaxwell37@gmail.com>
In-Reply-To: <20220615011540.813025-1-jmaxwell37@gmail.com>
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, cutaylor-pub@yahoo.com,
        atenart@kernel.org, daniel@iogearbox.net, joe@cilium.io, i@lmb.io,
        kafai@fb.com, alexei.starovoitov@gmail.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 15 Jun 2022 11:15:40 +1000 you wrote:
> v2 of this patch contains, refactor as per Daniel Borkmann's suggestions to
> validate RCU flags on the listen socket so that it balances with
> bpf_sk_release() and update comments as per Martin KaFai Lau's suggestion.
> One small change to Daniels suggestion, put "sk = sk2" under "if (sk2 != sk)"
> to avoid an extra instruction.
> 
> A customer reported a request_socket leak in a Calico cloud environment. We
> found that a BPF program was doing a socket lookup with takes a refcnt on
> the socket and that it was finding the request_socket but returning the parent
> LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> 1st, resulting in request_sock slab object leak. This patch retains the
> existing behaviour of returning full socks to the caller but it also decrements
> the child request_socket if one is present before doing so to prevent the leak.
> 
> [...]

Here is the summary with links:
  - [v2] net: bpf: fix request_sock leak in filter.c
    https://git.kernel.org/bpf/bpf/c/3046a827316c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


