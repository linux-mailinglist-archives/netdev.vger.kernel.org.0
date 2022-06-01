Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAE053A33E
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352422AbiFAKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352466AbiFAKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30243640B;
        Wed,  1 Jun 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD3CFB81986;
        Wed,  1 Jun 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F5C7C3411E;
        Wed,  1 Jun 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654080612;
        bh=9tToaTR6nkvQCaAsWsWAAUfzS57hkvBG6oHogiEun68=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hhau9052MRoo88WOoOHkEPeTgEA9g965JUhTaDJD7aHRF6qLn4tG3sIq858gLNnTK
         lgnSBtVkokkMZpMLCnMiFRxoWIOTfk6grEeF/+Ua381sF80mr7E9VpOpshXqx72lBj
         +/1q7+TtR5XwmwUQYip8r6aJppzYN2oLRXFPd+x7pMM8T6rp8QLHGBrU6oRyEPH5by
         uRIiL76005mbToNwlWs/9rfm+L9SlWI3sQFEOieN1XknCf7+qMPX2QTnbjNXbdmNgd
         lKlvswE1xie4QREcLOYHNHwhkwtQf9UboCEIb5fOpYaB4eFJb5SFQ4tY2gBQB2xuFQ
         U1ALvNw3fgr3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47593F03944;
        Wed,  1 Jun 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] macsec: fix UAF bug for real_dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165408061228.2193.2356708957505093966.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 10:50:12 +0000
References: <20220531074500.1272846-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220531074500.1272846-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ap420073@gmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 31 May 2022 15:45:00 +0800 you wrote:
> Create a new macsec device but not get reference to real_dev. That can
> not ensure that real_dev is freed after macsec. That will trigger the
> UAF bug for real_dev as following:
> 
> ==================================================================
> BUG: KASAN: use-after-free in macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
> Call Trace:
>  ...
>  macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
>  dev_get_iflink+0x73/0xe0 net/core/dev.c:637
>  default_operstate net/core/link_watch.c:42 [inline]
>  rfc2863_policy+0x233/0x2d0 net/core/link_watch.c:54
>  linkwatch_do_dev+0x2a/0x150 net/core/link_watch.c:161
> 
> [...]

Here is the summary with links:
  - [net,v2] macsec: fix UAF bug for real_dev
    https://git.kernel.org/netdev/net/c/196a888ca657

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


