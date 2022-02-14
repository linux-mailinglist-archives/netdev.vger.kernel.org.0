Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485774B4EBC
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351237AbiBNLeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:34:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351867AbiBNLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:33:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4CD694A2;
        Mon, 14 Feb 2022 03:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67E6D61140;
        Mon, 14 Feb 2022 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA768C340F4;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644837610;
        bh=zWy0Fim2DwHOqTznLyHN/+gBuNl38IaDVjY6vI5cAbc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ByKf4xlzTOWN4zaJBApDy94pxmz1dtM683EsWZe7YQgB+7CG3ElSqXWY2nx8IIAEa
         gUdXdXud4e//MmD/9eOiO0xRz8oLbCJ+6NipSvWydSaDvTN2aHVHQHi+2CSy/pY4Tz
         lHJOn3Gr7py+zZ5q4L0mdbrWB732VkCjb9BW35VGjnLl9GAYy0Q6g/xbVEXT38bkDo
         dsA4BQERYiVCdFTdteuap97ZKUeJP8bvOWKCo+MvGXxKPh5h/Hly29lzQL6qutdWEr
         DvQx4Lj34Ze9zO+mOgKN6R05FH5Bw/0GQEWPhxdSsYEp0e5cpk7rWcaylrHdfYjLzr
         J3TLa3r37/N0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A44C1E7BB04;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] etherdevice: Adjust ether_addr* prototypes to silence
 -Wstringop-overead
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164483761066.10850.7033053223597897963.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 11:20:10 +0000
References: <20220212171449.3000885-1-keescook@chromium.org>
In-Reply-To: <20220212171449.3000885-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org, mkl@pengutronix.de, davem@davemloft.net,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 12 Feb 2022 09:14:49 -0800 you wrote:
> With GCC 12, -Wstringop-overread was warning about an implicit cast from
> char[6] to char[8]. However, the extra 2 bytes are always thrown away,
> alignment doesn't matter, and the risk of hitting the edge of unallocated
> memory has been accepted, so this prototype can just be converted to a
> regular char *. Silences:
> 
> net/core/dev.c: In function ‘bpf_prog_run_generic_xdp’: net/core/dev.c:4618:21: warning: ‘ether_addr_equal_64bits’ reading 8 bytes from a region of size 6 [-Wstringop-overread]
>  4618 |         orig_host = ether_addr_equal_64bits(eth->h_dest, > skb->dev->dev_addr);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> net/core/dev.c:4618:21: note: referencing argument 1 of type ‘const u8[8]’ {aka ‘const unsigned char[8]’}
> net/core/dev.c:4618:21: note: referencing argument 2 of type ‘const u8[8]’ {aka ‘const unsigned char[8]’}
> In file included from net/core/dev.c:91: include/linux/etherdevice.h:375:20: note: in a call to function ‘ether_addr_equal_64bits’
>   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
>       |                    ^~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
    https://git.kernel.org/netdev/net-next/c/2618a0dae09e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


