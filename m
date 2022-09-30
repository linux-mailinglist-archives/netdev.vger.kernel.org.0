Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B055F0AEA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiI3LpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiI3Lop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFFB8FD4B;
        Fri, 30 Sep 2022 04:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7DA0B8283A;
        Fri, 30 Sep 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93F2FC43470;
        Fri, 30 Sep 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538016;
        bh=h3j7XysJOOc6Jp/kw/F6iqvqTOipGJ195F1m1aBvvl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nF8gK4Tr8cfpP2KeaBapoC25ItuiS6evjOgCrfAwT/ah1CL2ZDRlobnO097AJNj4a
         EnUrSkK2MU/N554BAdcVyqcgy8i0xzFcQatb/goU3pcSCLXO9DCc0mlw8ldx5PGD2U
         iAzeCmu2CZAlQGzuamsAMjMS+XImoJULbvA8MDVQ2KzUpX0qWJUBqyWv1tnNiYcSPC
         QF0abc10sidt9Nbp+FtFg/fb5Wm68+YzQqg+ZchDO28qwv8bWjf0i6s+vBIEWkYDqy
         a+ieujTs27h31Po8b6/VlpS83aFeya1HiPKfJ3VG0CW30XmDcHawC7xUuKuN907h8p
         pBGWHMclc48EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AECFE49FA7;
        Fri, 30 Sep 2022 11:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: handle the error returned from
 sctp_auth_asoc_init_active_key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453801649.4225.16866924781982017977.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:40:16 +0000
References: <035e28d623263b9c3ccbbea689883d6437aa5aa0.1664388613.git.lucien.xin@gmail.com>
In-Reply-To: <035e28d623263b9c3ccbbea689883d6437aa5aa0.1664388613.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 28 Sep 2022 14:10:13 -0400 you wrote:
> When it returns an error from sctp_auth_asoc_init_active_key(), the
> active_key is actually not updated. The old sh_key will be freeed
> while it's still used as active key in asoc. Then an use-after-free
> will be triggered when sending patckets, as found by syzbot:
> 
>   sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
>   sctp_set_owner_w net/sctp/socket.c:132 [inline]
>   sctp_sendmsg_to_asoc+0xbd5/0x1a20 net/sctp/socket.c:1863
>   sctp_sendmsg+0x1053/0x1d50 net/sctp/socket.c:2025
>   inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>   sock_sendmsg_nosec net/socket.c:714 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:734
> 
> [...]

Here is the summary with links:
  - [net] sctp: handle the error returned from sctp_auth_asoc_init_active_key
    https://git.kernel.org/netdev/net/c/022152aaebe1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


