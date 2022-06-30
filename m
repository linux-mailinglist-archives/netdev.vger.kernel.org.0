Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C405B560FD7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiF3EA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3EAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:00:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F36727CC4;
        Wed, 29 Jun 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8459BCE2BAB;
        Thu, 30 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D81FBC3411E;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561613;
        bh=vBmiMFTgYtYOTriXq5xiEGxOIm2M+lub1uwNaPG6RV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UDfnXzhNUigfc0bSD+jI4GhpVCa7h+/3u8Bmod+Q6LJaORea6muEf8yK/7ppkemXi
         NChkdanQ76MJwkmYSox+eyDjPr7Jds8HXSeY+0BWf9QVNwo8ZmOfC8uRFoW6jXbrRX
         PFm3TO3f89hkMWCRpGx/zvnGd08PBtH35YyxMZJiwW0zsZFJ4x3dcgWEVgxMNzSz6k
         I/1ooFyfR5lSLGMvMCkxMaXOY/8418TEfuCdIOMbFAhfnu4CYelzlufFqFh/+I4vGh
         gnk2QHVo4WXD9gxSaU00enDg1CqeuGkxocNTj2xd0WLDI+eSQa2aqbyQQwxF/Q+JRn
         oQqPcRDloT/0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1DF5E49FA0;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bonding: fix use-after-free after 802.3ad slave
 unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656161371.1686.14484699232188262665.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:00:13 +0000
References: <20220629012914.361-1-yevhen.orlov@plvision.eu>
In-Reply-To: <20220629012914.361-1-yevhen.orlov@plvision.eu>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, maksym.glubokiy@plvision.eu,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 29 Jun 2022 04:29:14 +0300 you wrote:
> commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection"),
> resolve case, when there is several aggregation groups in the same bond.
> bond_3ad_unbind_slave will invalidate (clear) aggregator when
> __agg_active_ports return zero. So, ad_clear_agg can be executed even, when
> num_of_ports!=0. Than bond_3ad_unbind_slave can be executed again for,
> previously cleared aggregator. NOTE: at this time bond_3ad_unbind_slave
> will not update slave ports list, because lag_ports==NULL. So, here we
> got slave ports, pointing to freed aggregator memory.
> 
> [...]

Here is the summary with links:
  - [net] net: bonding: fix use-after-free after 802.3ad slave unbind
    https://git.kernel.org/netdev/net/c/050133e1aa2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


