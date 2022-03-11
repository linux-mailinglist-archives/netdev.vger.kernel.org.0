Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314C34D6046
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348122AbiCKLBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiCKLBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8AA1AE65F;
        Fri, 11 Mar 2022 03:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9988C616D6;
        Fri, 11 Mar 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED0EBC340F4;
        Fri, 11 Mar 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646996414;
        bh=vei2XrdqQh2PV8B3FwqM1GUVmbx5mhp6g8aEwOZFwcA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EgfnjWv2x1GJuuFcV5nMZ7OXVNy2/tFpmX/lECVNUyWgjxhexQiL9vMACypPjALdb
         4qI9Mv9GfAZj8huDwUzK4YIBuSnV03RJqxVXdN5Nv8k7EIaKFSKwKsJuBczAF32FRg
         nzZwJ7DX5VLMV4mjRB+zQ0EOyoxPxwKLn0rXmcOqnz0xieqvoVtjWSWUhvhQVG0ylu
         G8+zs+CginBBy1MlH5vz2XtEyGajSgYJfyUWVsKptEFV4ITMfyUyFAvQfMSVjbvXQY
         27KT0OrAQn2imOpWRXksOnDv4mhJJ46Cn/W76MB1YqGnNfkGKuI/Zgyy1CfIaTfpRn
         L6WdWbTNwHbjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDD90E6D3DD;
        Fri, 11 Mar 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] powerpc/net: Implement powerpc specific
 csum_shift() to remove branch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164699641383.30508.9920591950729101881.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 11:00:13 +0000
References: <1e1a0f38f3f0ab61283ccfb69626104a897f3551.1646755813.git.christophe.leroy@csgroup.eu>
In-Reply-To: <1e1a0f38f3f0ab61283ccfb69626104a897f3551.1646755813.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Mar 2022 17:12:10 +0100 you wrote:
> Today's implementation of csum_shift() leads to branching based on
> parity of 'offset'
> 
> 	000002f8 <csum_block_add>:
> 	     2f8:	70 a5 00 01 	andi.   r5,r5,1
> 	     2fc:	41 a2 00 08 	beq     304 <csum_block_add+0xc>
> 	     300:	54 84 c0 3e 	rotlwi  r4,r4,24
> 	     304:	7c 63 20 14 	addc    r3,r3,r4
> 	     308:	7c 63 01 94 	addze   r3,r3
> 	     30c:	4e 80 00 20 	blr
> 
> [...]

Here is the summary with links:
  - [net-next,v2] powerpc/net: Implement powerpc specific csum_shift() to remove branch
    https://git.kernel.org/netdev/net-next/c/3af722cb735d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


