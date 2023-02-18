Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6671E69B791
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjBRBu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBRBuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5766BDC8
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3059EB82EA6
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF10AC4339C;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676685017;
        bh=2+LRSuSfUn64pstTTrUelwv5rwfi/VsXeV1uQfOfPNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YTKjJZRHQAR29pIOIVnszvQ7w+atC4+ir5mSCvZLVZhhUi9/rRWToGqUsrBViPkO4
         ZpVtFLbJR/op9wlH71wdGU1KNlz+1HCLikLtvwedHWcSKnUdMqCfEnJoGJY/1W2IHd
         kqOtouiFE877ezoUY+kwmTDIVHEDwEbQfzIqI7wQ9Uenes5QADv2RmQKJvRThZMMxa
         dSC5kx6pNrMBxF+fHYbsjIsAGXhkzcF8bYAARnphrSdIlvCgepvDGk1GWUtcpMqalH
         McDZA8bAr0FVfjVxW/CvAKE00tBdyLNToemjf0/E0I6AP9aWu7xASFnnJnKUwU7cor
         EoSNYhIFVch6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5833E4D025;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] libnetlink.c: Fix memory leak in batch mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167668501780.31159.4113921260569147664.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 01:50:17 +0000
References: <b90aafd60f264e4e2dd3367974f3bd16c3f17fa8.camel@nuclearcat.com>
In-Reply-To: <b90aafd60f264e4e2dd3367974f3bd16c3f17fa8.camel@nuclearcat.com>
To:     Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Sat, 11 Feb 2023 01:46:37 +0200 you wrote:
> During testing we noticed significant memory leak that is easily
> reproducible and detectable with valgrind:
> 
> ==2006284== 393,216 bytes in 12 blocks are definitely lost in loss record 5 of 5
> ==2006284==    at 0x4848899: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==2006284==    by 0x18C73E: rtnl_recvmsg (libnetlink.c:830)
> ==2006284==    by 0x18CF9E: __rtnl_talk_iov (libnetlink.c:1032)
> ==2006284==    by 0x18D3CE: __rtnl_talk (libnetlink.c:1140)
> ==2006284==    by 0x18D4DE: rtnl_talk (libnetlink.c:1168)
> ==2006284==    by 0x11BF04: tc_filter_modify (tc_filter.c:224)
> ==2006284==    by 0x11DD70: do_filter (tc_filter.c:748)
> ==2006284==    by 0x116B06: do_cmd (tc.c:210)
> ==2006284==    by 0x116C7C: tc_batch_cmd (tc.c:231)
> ==2006284==    by 0x1796F2: do_batch (utils.c:1701)
> ==2006284==    by 0x116D05: batch (tc.c:246)
> ==2006284==    by 0x117327: main (tc.c:331)
> ==2006284==
> ==2006284== LEAK SUMMARY:
> ==2006284==    definitely lost: 884,736 bytes in 27 blocks
> 
> [...]

Here is the summary with links:
  - [iproute2] libnetlink.c: Fix memory leak in batch mode
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=6d25be27cc29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


