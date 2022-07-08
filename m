Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E569956AF40
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiGHAKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiGHAKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:10:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AD76EE93;
        Thu,  7 Jul 2022 17:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC4D2CE2714;
        Fri,  8 Jul 2022 00:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01D75C3411E;
        Fri,  8 Jul 2022 00:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657239032;
        bh=9xpIeTxwhcZ5EtEAoq6+mS6pFAVaStUpuHHwrd8/nno=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z0paYA5JhJxDCVdE3hfAZ8m8gqzchfElEvh2xFG81Afcfg9OZkFKp3+3Uw0Kc5l7o
         BfIdEhsOOTXWrGCVdtRcolfoRCp0QcX10Qy7F6M5y+GokNF7OR6oAzwOhrWtwzb85X
         ZpimPHBZQF2GDicIlHcFk0LnOiHU2qJ3RFhCm9JgpLPNcTUm7vSuopW8vautbn5Dys
         8UvtamDgK4CGwgNXA83VTpwgE5vmTA3lmKnAvJLIel9BhYg28Z+gtikI23b2l278MD
         +LVkoNOvjUW49Mj9XNzLcp9CB2gWxi9B7MRnhbMiEYaUC1GN639N21eIjEgEL7+YVp
         4yovgTnrPFssA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D85F8E45BD9;
        Fri,  8 Jul 2022 00:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: page_pool: optimize page pool page
 allocation in NUMA scenario
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165723903188.3388.12895024005964684911.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 00:10:31 +0000
References: <20220705113515.54342-1-huangguangbin2@huawei.com>
In-Reply-To: <20220705113515.54342-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     jbrouer@redhat.com, hawk@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, lorenzo@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, lipeng321@huawei.com, chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 5 Jul 2022 19:35:15 +0800 you wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently NIC packet receiving performance based on page pool deteriorates
> occasionally. To analysis the causes of this problem page allocation stats
> are collected. Here are the stats when NIC rx performance deteriorates:
> 
> bandwidth(Gbits/s)		16.8		6.91
> rx_pp_alloc_fast		13794308	21141869
> rx_pp_alloc_slow		108625		166481
> rx_pp_alloc_slow_h		0		0
> rx_pp_alloc_empty		8192		8192
> rx_pp_alloc_refill		0		0
> rx_pp_alloc_waive		100433		158289
> rx_pp_recycle_cached		0		0
> rx_pp_recycle_cache_full	0		0
> rx_pp_recycle_ring		362400		420281
> rx_pp_recycle_ring_full		6064893		9709724
> rx_pp_recycle_released_ref	0		0
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: page_pool: optimize page pool page allocation in NUMA scenario
    https://git.kernel.org/netdev/net-next/c/d810d367ec40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


