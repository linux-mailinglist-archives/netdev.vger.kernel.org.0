Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248354C9A9F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbiCBBk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbiCBBkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2C5A1BFC
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 17:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CA53B81EE5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D669C340F3;
        Wed,  2 Mar 2022 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646185210;
        bh=1PDqjj33t77L84HE52AssX5xiw7Mea5p56YLu/Fe/34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CbyeOaI/HNJeysfPPQmMNttLUiHbaCUAS2UWyFgWYL4CxZS7oTCIDTEmWq6P6QIFx
         kd18kZmdGBJwFi3lkM6ZhZ1CV4h+5tXHgGvhqFcNeubpP+nHhLvTaa+N1rBhoFMPBU
         zuVoBgC8vQDvRUw1UD8ScUt8stXEbe4bmnSFuOca1LHM+1XMGfcG+uBpdOgzi3wqkJ
         q5M/WXnki7pVNCBLpdlt63+kEA1AYJ/hfT7XfbzSsbO3x3d/dizTxIiOUHaY+wt0hi
         byQN0dPFedVr4FMEKwWfFU2O6xswdhM/rGrPDgeKasN0i2NCogVZGNL/dL6ss732dY
         XyVxfbkRm7RXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2C37E6D4BB;
        Wed,  2 Mar 2022 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] sfc: optimize RXQs count and affinities
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618520999.21891.9258441569559448008.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 01:40:09 +0000
References: <20220228132254.25787-1-ihuguet@redhat.com>
In-Reply-To: <20220228132254.25787-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 14:22:52 +0100 you wrote:
> In sfc driver one RX queue per physical core was allocated by default.
> Later on, IRQ affinities were set spreading the IRQs in all NUMA local
> CPUs.
> 
> However, with that default configuration it result in a non very optimal
> configuration in many modern systems. Specifically, in systems with hyper
> threading and 2 NUMA nodes, affinities are set in a way that IRQs are
> handled by all logical cores of one same NUMA node. Handling IRQs from
> both hyper threading siblings has no benefit, and setting affinities to one
> queue per physical core is neither a very good idea because there is a
> performance penalty for moving data across nodes (I was able to check it
> with some XDP tests using pktgen).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] sfc: default config to 1 channel/core in local NUMA node only
    (no matching commit)
  - [v2,net-next,2/2] sfc: set affinity hints in local NUMA node only
    https://git.kernel.org/netdev/net-next/c/09a99ab16c60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


