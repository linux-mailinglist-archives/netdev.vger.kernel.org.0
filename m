Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7385C617540
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiKCDu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKCDuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FF715818;
        Wed,  2 Nov 2022 20:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3189361D29;
        Thu,  3 Nov 2022 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39BA3C43144;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447419;
        bh=CeZEYDj//wiK7IWpaHUiuStS8yjsVLzVJ5uvI0VWgTs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u4VUZLwlU5rMzRLWcjZZQAPcgfviiYEwwdEAJtwfoBAqmaTCuQRpK70oHka4G07Vg
         TJQXMQMQjA/niIm5kSyl9Ng5+U3BoiBqNsgkjq8GTK2OUiVRbWIZJXSEB9Z39nBx+K
         w5r6kj4OX4MGW/sG05Boo1WUBsyGU90ynPh0WZExPWSzzLSlyTtqzJPzD12Wn7gTRr
         K+4gn1IlZXWwojXGq+LJ/DKptE5XqsWJpwy6bozcC8IuGCU0BGyInoCmTW1ta8nK+p
         OIvV998M3Zcf70lqc5wTpm6+fhq+J471O7bXzAS2ZHc6KLChj68d+v9MCSYnBcXaO/
         hJEzN/RuUt+kQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24C8EC41621;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding (gcc13): synchronize bond_{a,t}lb_xmit() types
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741914.12191.12618808945767261507.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:19 +0000
References: <20221031114409.10417-1-jirislaby@kernel.org>
In-Reply-To: <20221031114409.10417-1-jirislaby@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     j.vosburgh@gmail.com, linux-kernel@vger.kernel.org, mliska@suse.cz,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 12:44:09 +0100 you wrote:
> Both bond_alb_xmit() and bond_tlb_xmit() produce a valid warning with
> gcc-13:
>   drivers/net/bonding/bond_alb.c:1409:13: error: conflicting types for 'bond_tlb_xmit' due to enum/integer mismatch; have 'netdev_tx_t(struct sk_buff *, struct net_device *)' ...
>   include/net/bond_alb.h:160:5: note: previous declaration of 'bond_tlb_xmit' with type 'int(struct sk_buff *, struct net_device *)'
> 
>   drivers/net/bonding/bond_alb.c:1523:13: error: conflicting types for 'bond_alb_xmit' due to enum/integer mismatch; have 'netdev_tx_t(struct sk_buff *, struct net_device *)' ...
>   include/net/bond_alb.h:159:5: note: previous declaration of 'bond_alb_xmit' with type 'int(struct sk_buff *, struct net_device *)'
> 
> [...]

Here is the summary with links:
  - bonding (gcc13): synchronize bond_{a,t}lb_xmit() types
    https://git.kernel.org/netdev/net-next/c/777fa87c7682

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


