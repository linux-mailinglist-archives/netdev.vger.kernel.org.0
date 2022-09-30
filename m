Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037B75F02E3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiI3CkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3CkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBB6ECCD8
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10B95B826C8
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD495C433B5;
        Fri, 30 Sep 2022 02:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505618;
        bh=43wzb+rxq9aXHQLBvTlTeqkdga/tAJdgXb2mUMWk6E8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JM5FtkeDA2EY/sk1M0fMmkl1IXirkDL38tjDFru6kKPV3BvUcztEShxyXOG9pAi6C
         SnKKP7kpFr1zaLjxP4mYoUS8AP5yVvKqiusZ0p5UDmWKXIH56p+iZLAMnep75tMd+V
         pdItlOy5dNay24G43rjDDWRi3I+7EC039Hail3W83/zdWLyle2cuTkxfqB+wdz8Gdd
         3T0ENA/QA/AtCE0L7GDZT2SrAgIc/bmRTb5N67aiJ0yab53G6EZKIiwNcdiJQlVsIJ
         df29K36ejm9tvF4G6Mz0h0n6xBt6xLb1t/SaLVQEr9AotheJLpg5pguQknsK4sUdZc
         0WQAX/syBdzLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 961F8C395DA;
        Fri, 30 Sep 2022 02:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] eth: alx: take rtnl_lock on resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450561861.6749.7811734377990492161.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:40:18 +0000
References: <20220928181236.1053043-1-kuba@kernel.org>
In-Reply-To: <20220928181236.1053043-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, zbynek.michl@gmail.com, chris.snook@gmail.com,
        dossche.niels@gmail.com, johannes@sipsolutions.net
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 28 Sep 2022 11:12:36 -0700 you wrote:
> Zbynek reports that alx trips an rtnl assertion on resume:
> 
>  RTNL: assertion failed at net/core/dev.c (2891)
>  RIP: 0010:netif_set_real_num_tx_queues+0x1ac/0x1c0
>  Call Trace:
>   <TASK>
>   __alx_open+0x230/0x570 [alx]
>   alx_resume+0x54/0x80 [alx]
>   ? pci_legacy_resume+0x80/0x80
>   dpm_run_callback+0x4a/0x150
>   device_resume+0x8b/0x190
>   async_resume+0x19/0x30
>   async_run_entry_fn+0x30/0x130
>   process_one_work+0x1e5/0x3b0
> 
> [...]

Here is the summary with links:
  - [net] eth: alx: take rtnl_lock on resume
    https://git.kernel.org/netdev/net/c/6ad1c94e1e7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


