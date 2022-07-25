Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE0F57FDF8
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiGYLAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiGYLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF01FEB;
        Mon, 25 Jul 2022 04:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39D3B60EF2;
        Mon, 25 Jul 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49350C341CD;
        Mon, 25 Jul 2022 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658746814;
        bh=GesNSSeiqm0otPKf0yDytjcXixR2TGA5PrEK8Cvxth0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kd94w//poMFFkjAn1K8lTrjrMyx8H3uqnUsC2QYB2+IM6xyu7LOjC3MtgEu9O08BA
         0p/lbfDyBXD0yBUooVgK0x+I1PhTbPawP0j4k6ePEhWq4KEb06t0H5tF47CJ2ONCAL
         UwXZb5dKL65JqnEP0DogKtMBveSE0K7+U3mUgy8nk++8fQRBD0bKzHeFY+gbJtZsD/
         yEKr4DzN+nfcmf0dXvucUXl35SENGWVmbMUIzwuPHM7XVIGLgEqBLVeJ4nQVx8Qyi4
         IgjQZfj70Df+aJtLvYPp8N/b4nslgYtoJTXdMTohbaS7msNGRs0KOJ0YHA7zwxjLzJ
         X60+5K7Su4sYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AE1EE450B5;
        Mon, 25 Jul 2022 11:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macsec: fix potential resource leak in macsec_add_rxsa()
 and macsec_add_txsa()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874681416.5766.17149669926226309133.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 11:00:14 +0000
References: <20220722092902.2528745-1-niejianglei2021@163.com>
In-Reply-To: <20220722092902.2528745-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Jul 2022 17:29:02 +0800 you wrote:
> init_rx_sa() allocates relevant resource for rx_sa->stats and rx_sa->
> key.tfm with alloc_percpu() and macsec_alloc_tfm(). When some error
> occurs after init_rx_sa() is called in macsec_add_rxsa(), the function
> released rx_sa with kfree() without releasing rx_sa->stats and rx_sa->
> key.tfm, which will lead to a resource leak.
> 
> We should call macsec_rxsa_put() instead of kfree() to decrease the ref
> count of rx_sa and release the relevant resource if the refcount is 0.
> The same bug exists in macsec_add_txsa() for tx_sa as well. This patch
> fixes the above two bugs.
> 
> [...]

Here is the summary with links:
  - net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()
    https://git.kernel.org/netdev/net/c/c7b205fbbf3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


