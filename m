Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23BF60D623
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 23:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiJYVaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 17:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiJYVaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 17:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A773E4F64C;
        Tue, 25 Oct 2022 14:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43FB161BAC;
        Tue, 25 Oct 2022 21:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93F39C433D7;
        Tue, 25 Oct 2022 21:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666733416;
        bh=sOpXMCe9LC1xfyUXh2lmcg/3x2PBBpExWr6Hng1hpAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i8wngfqK8cXmbc2Bn0/GH0lD40yiiXTzQzGaoftBx6FOZOqMNz1oG92AUzTKJtfTl
         +PDpYSNe3XbSTSKU8l5LBbV46pmxJhyThuIvEotpWbYqdJaCds48JMHC+sfG3evXVx
         sDvef30alWKmmKuwUyMRYX0bm1VJHPjv72iwDCQGohaUX9Ouiza3CjwjVyGYbUJtON
         0LKC38A65N1T53TjX4bmNcFe30fxMADlvL9DkhY9gy0mnEU6HQs3KkcCTpsaAxDT8d
         8jSMlseccyi94HZJWQFWw+TwqGruQqSC5IwqzOGEBizBsfK67q3jGZe/vIXzBpMz6g
         EGWSB2dlmasbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73CCEE45192;
        Tue, 25 Oct 2022 21:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: dev: Convert sa_data to flexible array in struct
 sockaddr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166673341646.9987.5803101009027995896.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 21:30:16 +0000
References: <20221018095503.never.671-kees@kernel.org>
In-Reply-To: <20221018095503.never.671-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        dsahern@kernel.org, dylany@fb.com, yajun.deng@linux.dev,
        petrm@nvidia.com, liuhangbin@gmail.com, leon@kernel.org,
        syzkaller@googlegroups.com, willemb@google.com,
        pablo@netfilter.org, netdev@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com,
        alibuda@linux.alibaba.com, jk@codeconstruct.com.au,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        liu3101@purdue.edu, wsa+renesas@sang-engineering.com,
        william.xuanziyang@huawei.com, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Oct 2022 02:56:03 -0700 you wrote:
> One of the worst offenders of "fake flexible arrays" is struct sockaddr,
> as it is the classic example of why GCC and Clang have been traditionally
> forced to treat all trailing arrays as fake flexible arrays: in the
> distant misty past, sa_data became too small, and code started just
> treating it as a flexible array, even though it was fixed-size. The
> special case by the compiler is specifically that sizeof(sa->sa_data)
> and FORTIFY_SOURCE (which uses __builtin_object_size(sa->sa_data, 1))
> do not agree (14 and -1 respectively), which makes FORTIFY_SOURCE treat
> it as a flexible array.
> 
> [...]

Here is the summary with links:
  - [next] net: dev: Convert sa_data to flexible array in struct sockaddr
    https://git.kernel.org/netdev/net-next/c/b5f0de6df6dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


