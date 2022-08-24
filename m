Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B4E59F913
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbiHXMKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiHXMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907A43AB30
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C29161982
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 890EFC433D7;
        Wed, 24 Aug 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661343016;
        bh=rheROY6XJ30l0oKYXoz/hM+4EjVT5ubJNSO01v1jjnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nqQ77JIivERe5nPFo+CmuvuR5o72dX+3Roog2Le4jJO+svMdwRDoE1Po9D1QM7I9X
         ckrAUOy2ep01IBckZ4ZFZFYWOEoGt/e3TVTRQIEZV7sXt4prkcwCl6N4PlSbztqep/
         +I2wJgkYv6uGgfi8QPchRzEVx2WrQRpYDgZy6rDU4Tgv/14ikeWFULxrpDU21yXeHY
         tQ4ZXNZ+csTpYj6KsQZxsk0heDkFGI+MpzAg2nMZwYMRuyFvIH1LfqXxzrbwLRNrv0
         XoniilTEUYJF/8+s5n67MxaCUOf6fHg7qVTHPV8F4GF224qKjC/7T4+6zE2J/CtC2d
         TkMsV5inLXbLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BAB0E2A03B;
        Wed, 24 Aug 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] xfrm: fix refcount leak in __xfrm_policy_check()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134301643.8334.12701828590513575555.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:10:16 +0000
References: <20220824050213.3643599-2-steffen.klassert@secunet.com>
In-Reply-To: <20220824050213.3643599-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 24 Aug 2022 07:02:08 +0200 you wrote:
> From: Xin Xiong <xiongx18@fudan.edu.cn>
> 
> The issue happens on an error path in __xfrm_policy_check(). When the
> fetching process of the object `pols[1]` fails, the function simply
> returns 0, forgetting to decrement the reference count of `pols[0]`,
> which is incremented earlier by either xfrm_sk_policy_lookup() or
> xfrm_policy_lookup(). This may result in memory leaks.
> 
> [...]

Here is the summary with links:
  - [1/6] xfrm: fix refcount leak in __xfrm_policy_check()
    https://git.kernel.org/netdev/net/c/9c9cb23e00dd
  - [2/6] Revert "xfrm: update SA curlft.use_time"
    https://git.kernel.org/netdev/net/c/717ada9f10f2
  - [3/6] xfrm: fix XFRMA_LASTUSED comment
    https://git.kernel.org/netdev/net/c/36d763509be3
  - [4/6] xfrm: clone missing x->lastused in xfrm_do_migrate
    https://git.kernel.org/netdev/net/c/6aa811acdb76
  - [5/6] af_key: Do not call xfrm_probe_algs in parallel
    https://git.kernel.org/netdev/net/c/ba953a9d89a0
  - [6/6] xfrm: policy: fix metadata dst->dev xmit null pointer dereference
    https://git.kernel.org/netdev/net/c/17ecd4a4db47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


