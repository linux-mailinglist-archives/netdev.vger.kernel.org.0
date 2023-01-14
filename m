Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D965066A950
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjANFAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjANFAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1840235A9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 21:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1D1608CC
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA380C433EF;
        Sat, 14 Jan 2023 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673672417;
        bh=dc2MVpECuOJTMizyMIBi/mQIo33ZGQ7MoFMp1bGcTJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UmgT5Vfs3r+plLBLt5d1LhqUARICffFBYhPZYnR/zDEV7ydd9ZADxGR54wA3wb5o+
         9AOvfGdS9yipRWEFY0ft8MIh3IDQVpY6lWrdUViDZAa49Re1l6h6wI1k5TMKmKA53r
         +T0VkDE8oWDceNCQ/BDLiWpR7iu+onM6Z5WrWYeRmgcMD4XUMJvfMhAjjefXyBhs0u
         DLSCUMj3RfCggDzxi71p2VK9IC1UBesX0E54ftLuQEVg5cEmup1OCCOCGHSln9KCh1
         /1ZOhFtPHSzi9V/hDUPp4NkoIHvwTq8h1Dx66CvxmzPVQajMnFlWDLcKfHybwUGrpN
         18zqXyBgeaVKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6E62C395C8;
        Sat, 14 Jan 2023 05:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: nfc: Fix use-after-free in local_cleanup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367241680.28163.5038142496471587881.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:00:16 +0000
References: <20230111131914.3338838-1-jisoo.jang@yonsei.ac.kr>
In-Reply-To: <20230111131914.3338838-1-jisoo.jang@yonsei.ac.kr>
To:     Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Cc:     pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        dokyungs@yonsei.ac.kr, linuxlovemin@yonsei.ac.kr
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 11 Jan 2023 22:19:14 +0900 you wrote:
> Fix a use-after-free that occurs in kfree_skb() called from
> local_cleanup(). This could happen when killing nfc daemon (e.g. neard)
> after detaching an nfc device.
> When detaching an nfc device, local_cleanup() called from
> nfc_llcp_unregister_device() frees local->rx_pending and decreases
> local->ref by kref_put() in nfc_llcp_local_put().
> In the terminating process, nfc daemon releases all sockets and it leads
> to decreasing local->ref. After the last release of local->ref,
> local_cleanup() called from local_release() frees local->rx_pending
> again, which leads to the bug.
> 
> [...]

Here is the summary with links:
  - [v4] net: nfc: Fix use-after-free in local_cleanup()
    https://git.kernel.org/netdev/net/c/4bb4db7f3187

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


