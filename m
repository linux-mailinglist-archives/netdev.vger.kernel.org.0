Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E029358F777
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 08:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiHKGK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 02:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiHKGKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 02:10:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0346E84
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 23:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6639BCE2021
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A357DC43470;
        Thu, 11 Aug 2022 06:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660198214;
        bh=8az56FqADrndVmpbDWdKIkvfR0dQo/bXpeebU1N35ag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D2WTlvfp/i6NNQXLL4wFQZ2JQLe9YTNc9UDZ9Yo9NdS4fZ+9CcH173THMMWb3nRYS
         ahgC1tIZv0XpGyN8SBJYC+44TMz8A9T2JKQnD8GKHZZm/ZVc0+WGI0+xV7pZj0c/Ie
         C97YjeCd9kDOzFxySGcHgkcor/L+9S042nHzIg7WE0H6qKELmWeJ/gvBjAC8inCeP3
         QhGfAnVIsOXhlHG8cZz8fxvqRqFjSkNRmci+pnQQqUT0B1hVkmpokLT6jEy5EnNgq/
         1lzi+MJaituzVRRqrx9+oWfGk9lwLM5bQ6fbmaCTL1d482JfijTud9tpZANCABFgcu
         RlrANaSdKAx0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C8CAC43145;
        Thu, 11 Aug 2022 06:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/tls: Use RCU API to access tls_ctx->netdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166019821457.2125.9933287708425574791.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 06:10:14 +0000
References: <20220810081602.1435800-1-maximmi@nvidia.com>
In-Reply-To: <20220810081602.1435800-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        tariqt@nvidia.com, john.fastabend@gmail.com, gal@nvidia.com,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, ayush.sawal@chelsio.com,
        vinay.yadav@chelsio.com, rohitm@chelsio.com, kuniyu@amazon.co.jp,
        dsahern@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Aug 2022 11:16:02 +0300 you wrote:
> Currently, tls_device_down synchronizes with tls_device_resync_rx using
> RCU, however, the pointer to netdev is stored using WRITE_ONCE and
> loaded using READ_ONCE.
> 
> Although such approach is technically correct (rcu_dereference is
> essentially a READ_ONCE, and rcu_assign_pointer uses WRITE_ONCE to store
> NULL), using special RCU helpers for pointers is more valid, as it
> includes additional checks and might change the implementation
> transparently to the callers.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/tls: Use RCU API to access tls_ctx->netdev
    https://git.kernel.org/netdev/net/c/94ce3b64c62d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


