Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6617E69D79B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbjBUAkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjBUAkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9E71A66E;
        Mon, 20 Feb 2023 16:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF5D60F58;
        Tue, 21 Feb 2023 00:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1472CC433EF;
        Tue, 21 Feb 2023 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940017;
        bh=VhTw6+ty7Uy7+7gPWBXLZ20yxCWQedsCuDqOZ/YlgEg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=evKo+/LxHtHqQziyotx04ypCXrRCodUs41h4o7IpwaRL8cD4ZPOBvoiGX/SGIjnNh
         dh47Wf2uz2YDLPv9rBSM3RVG75bxBbdJxn9S8YikvrV7vNmKcptQvposkZ5Ld1Ra+F
         Iz3E+yjpqpqHtbPgyg+uQJkzj2gyc7+NaeLDrPzwSXNXRe6+hJbg8RTwGQA/aYz46f
         G0+WkO6EiFS7Feu9mg01iivlzCUbmS9yAXGSiROjdTS18VW9RA55jsAGskYfpOb9vW
         N6HHAs2YTHE1dhgn4DYkMsFKRsRPcEruVkbUqc8lRPFnYWQazyQ3DAmHmn4AFP3FYV
         q/afxOrJ9Oj2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE8DBC691DE;
        Tue, 21 Feb 2023 00:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4_en: Introduce flexible array to silence overflow
 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694001697.5796.9907214630396973552.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:40:16 +0000
References: <20230218183842.never.954-kees@kernel.org>
In-Reply-To: <20230218183842.never.954-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     tariqt@nvidia.com, joskera@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yishaih@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 18 Feb 2023 10:38:50 -0800 you wrote:
> The call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers a FORTIFY
> memcpy() warning on ppc64 platform:
> 
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘skb_copy_from_linear_data’ at ./include/linux/skbuff.h:4029:2,
>     inlined from ‘build_inline_wqe’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
>     inlined from ‘mlx4_en_xmit’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
> ./include/linux/fortify-string.h:513:25: error: call to ‘__write_overflow_field’ declared with
> attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()?
> [-Werror=attribute-warning]
>   513 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net/mlx4_en: Introduce flexible array to silence overflow warning
    https://git.kernel.org/netdev/net-next/c/f8f185e39b4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


